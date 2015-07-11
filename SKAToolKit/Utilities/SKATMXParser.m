//
//  SKAXMLParser.m
//  SKAToolKitExample
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKATMXParser.h"
#import "LFCGzipUtility.h"
#import "NSMutableDictionary+SKATMXParserUtils.h"

typedef NS_ENUM(NSUInteger, ParseMode) {
  ParseModeStandard,
  ParseModeTileset,
  ParseModeTile,
  ParseModeTileProperties,
  ParseModeLayer,
  ParseModeData,
  ParseModeObjectGroup,
  ParseModeObject,
  ParseModeObjectProperties
};

@interface SKATMXParser ()<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableDictionary *mapDictionary;
@property (strong, nonatomic) NSMutableDictionary *currentTileset;
@property (strong, nonatomic) NSMutableDictionary *currentProperties;
@property (strong, nonatomic) NSMutableDictionary *currentLayer;

@property (strong, nonatomic) NSDictionary *currentDataAttributes;

@property (strong, nonatomic) NSString *currentTileID;

@property (nonatomic) ParseMode parseMode;

@end

@implementation SKATMXParser

#pragma mark - Init
- (instancetype)init {
  if(!(self = [super init])) return nil;
  
  _parseMode = ParseModeStandard;
  
  _mapDictionary = [[NSMutableDictionary alloc] init];
  _mapDictionary[kTilesets] = [[NSMutableArray alloc] init];
  _mapDictionary[kLayers] = [[NSMutableArray alloc] init];
  return self;
}

#pragma mark - Public Getter
- (NSDictionary *)dictionaryWithData:(NSData *)data {
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
  parser.delegate = self;
  parser.shouldResolveExternalEntities = NO;
  
  if([parser parse]) {
    return [NSDictionary dictionaryWithDictionary:self.mapDictionary];
  }
  
  NSLog(@"error: invalid TMX");
  
  return nil;
}

#pragma mark - Map Dictionary Modifications
- (void)addCurrentTileset {
  if(self.currentTileset) {
    [self.mapDictionary[kTilesets] addObject:self.currentTileset];
  }
}

- (void)addCurrentTileProperties {
  if(self.currentProperties && self.currentTileset) {
    self.currentTileset[kTileProperties] = self.currentProperties;
  }
}

- (void)addCurrentLayer {
  if(self.currentLayer) {
    [self.mapDictionary[kLayers] addObject:self.currentLayer];
  }
}

#pragma mark - Data Tag Parsing
- (void)parseData:(NSString *)dataString {
  dataString = [dataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  if(self.currentDataAttributes
     && [self.currentDataAttributes[kEncoding] isEqualToString:kBase64]
     && [self.currentDataAttributes[kCompression] isEqualToString:kZlib]) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:0];
    data = [LFCGzipUtility ungzipData:data];
    
    NSInteger mapWidth = [self.mapDictionary[kWidth] integerValue];
    NSInteger mapHeight = [self.mapDictionary[kHeight] integerValue];
    
    // Verify data is the correct length
    if(data.length == mapWidth * mapHeight * 4) {
      uint8_t *bytes = (uint8_t *)[data bytes];
      NSInteger tileIndex = 0;
      NSMutableArray *tileIDArray = [[NSMutableArray alloc] init];
      
      for(NSInteger y = 0; y < mapHeight; y++) {
        for(NSInteger x = 0; x < mapWidth; x++) {
          NSInteger globalTileID = bytes[tileIndex] | (bytes[tileIndex + 1] << 8) | (bytes[tileIndex + 2] << 16)| (bytes[tileIndex + 3] << 24);
          [tileIDArray addObject:@(globalTileID)];
          tileIndex += 4;
        }
      }
      
      self.currentLayer[kData] = [NSArray arrayWithArray:tileIDArray];
    }
  }
}

#pragma mark - NSXMLParserDelegate
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict{
  if([elementName isEqualToString:kMap]) {
    [self.mapDictionary addEntriesFromDictionary:attributeDict];
    [self.mapDictionary cleanseMap];
  }
  
  if([elementName isEqualToString:kTileset]) {
    self.parseMode = ParseModeTileset;
    self.currentTileset = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    [self.currentTileset cleanseTileset];
  } else if([elementName isEqualToString:kImage]) {
    if(self.parseMode == ParseModeTileset)
      {
      self.currentTileset[kImage] = attributeDict[kSource];
      self.currentTileset[kImageWidth] = attributeDict[kHeight];
      self.currentTileset[kImageHeight] = attributeDict[kWidth];
      }
  } else if([elementName isEqualToString:kTile]) {
    self.parseMode = ParseModeTile;
    self.currentTileID = attributeDict[kId];
  } else if([elementName isEqualToString:kProperties]) {
    
    if(self.parseMode == ParseModeTile) {
      self.parseMode = ParseModeTileProperties;
      
      if(!self.currentProperties) {
        self.currentProperties = [[NSMutableDictionary alloc] init];
      }
    } else if(self.parseMode == ParseModeObject) {
      self.parseMode = ParseModeObjectProperties;
      
      if(!self.currentProperties) {
        self.currentProperties = [[NSMutableDictionary alloc] init];
      }
    }
  } else if([elementName isEqualToString:kProperty]) {
    if(self.parseMode == ParseModeTileProperties) {
      self.currentProperties[self.currentTileID] = @{attributeDict[kName] : attributeDict[kValue]};
    } else if(self.parseMode == ParseModeObjectProperties) {
      self.currentProperties[attributeDict[kName]] = attributeDict[kValue];
    }
  } else if([elementName isEqualToString:kLayer]) {
    if(self.parseMode == ParseModeStandard) {
      self.parseMode = ParseModeLayer;
      self.currentLayer = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
      [self.currentLayer cleanseLayer];
    }
  }
  else if([elementName isEqualToString:kData]) {
    if(self.parseMode == ParseModeLayer) {
      self.parseMode = ParseModeData;
      self.currentDataAttributes = attributeDict;
    }
  } else if([elementName isEqualToString:kObjectGroup]) {
    if(self.parseMode == ParseModeStandard) {
      self.parseMode = ParseModeObjectGroup;
      
      NSMutableDictionary *objectGroupDict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
      [objectGroupDict cleanseObjectGroup];
      
      self.currentLayer = objectGroupDict;
    }
  } else if([elementName isEqualToString:kObject]) {
    if(self.parseMode == ParseModeObjectGroup) {
      self.parseMode = ParseModeObject;
      
      if(!self.currentLayer[kObjects]) {
        self.currentLayer[kObjects] = [[NSMutableArray alloc] init];
      }
      
      NSMutableDictionary *objectDict = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
      [objectDict cleanseObject];
      
      [self.currentLayer[kObjects] addObject:objectDict];
    }
  }
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string {
  if(self.parseMode == ParseModeData) {
    [self parseData:string];
  }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
  if([elementName isEqualToString:kTileset]) {
    [self addCurrentTileProperties];
    [self addCurrentTileset];
    self.currentTileset = nil;
    self.currentProperties = nil;
    self.parseMode = ParseModeStandard;
    
  } else if([elementName isEqualToString:kTile]) {
    self.parseMode = ParseModeTileset;
    self.currentTileID = nil;
    
  } else if([elementName isEqualToString:kProperties]) {
    if(self.parseMode == ParseModeTileProperties) {
      self.parseMode = ParseModeTile;
    } else if(self.parseMode == ParseModeObjectProperties) {
      self.parseMode = ParseModeObject;
      
      if(self.currentProperties) {
        [self.currentLayer[kObjects] lastObject][kProperties] = self.currentProperties;
        self.currentProperties = nil;
      }
    }
  } else if([elementName isEqualToString:kObject]) {
    self.parseMode = ParseModeObjectGroup;
  
  } else if([elementName isEqualToString:kLayer] || [elementName isEqualToString:kObjectGroup]) {
    [self addCurrentLayer];
    self.currentLayer = nil;
    self.parseMode = ParseModeStandard;
 
  } else if([elementName isEqualToString:kData]) {
    self.parseMode = ParseModeLayer;
    self.currentDataAttributes = nil;
  }
}

@end