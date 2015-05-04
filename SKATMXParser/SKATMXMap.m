//
//  SKATMXParser.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKATMXMap.h"
#import "MapTile.h"

@interface SKATMXMap ()

@end

@implementation SKATMXMap

-(instancetype)initWithMapName:(NSString *)mapName
{
    self = [super init];

    [self loadFile:mapName];
    
    return self;
}

-(void)loadFile:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    NSDictionary *mapDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    
    self.mapProperties = mapDictionary[@"properties"];
    
    self.mapWidth = [mapDictionary[@"width"] integerValue];
    self.mapHeight = [mapDictionary[@"height"] integerValue];
    
    
    //creating tile dictionary
    NSMutableDictionary *tileSets = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tileset in mapDictionary[@"tilesets"])
    {
        
        NSInteger tileWidth = [tileset[@"tilewidth"] integerValue];
        self.tileWidth = tileWidth;
        
        //getting big texture
        NSString *path = [[tileset[@"image"] lastPathComponent] stringByDeletingPathExtension];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:path ofType:[tileset[@"image"] pathExtension]];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
        SKTexture *mainTexture = [SKTexture textureWithImage:image];
        
        NSLog(@"Image: %@", image);
        
        //calculating small texture
        NSInteger imageWidth = [tileset[@"imagewidth"] integerValue];
        NSInteger imageHeight = [tileset[@"imageheight"] integerValue];
        
        NSInteger tileRows = imageWidth/tileWidth;
        NSInteger tileColumns = imageHeight/tileWidth;
        
        float tileWidthPercent = 1.0f/(float)tileRows;
        float tileHeightPercent = 1.0f/(float)tileColumns;

        NSInteger index = [tileset[@"firstgid"] integerValue];;
        
        for (NSInteger i = 0; i < tileRows; i++)
        {
            for (NSInteger j = 0; j < tileColumns; j++)
            {
                
                MapTile *mapTile = [[MapTile alloc]init];
                SKTexture *texture = [SKTexture textureWithRect:CGRectMake(j*tileWidthPercent, 1.0f-tileHeightPercent*(i+1), tileWidthPercent, tileHeightPercent) inTexture:mainTexture];
                mapTile.texture = texture;
                mapTile.indexKey = index;
                
                NSString *key = [NSString stringWithFormat:@"%@", @(mapTile.indexKey)];
                if (tileset[@"tileproperties"][key])
                {
                    mapTile.properties = tileset[@"tileproperties"][key];
                }
                
                [tileSets setObject:mapTile forKey:key];
                
                index++;
            }
        }
    }
    
    //layers
    for (NSDictionary *layerDictionary in mapDictionary[@"layers"])
    {
        NSArray *data = layerDictionary[@"data"];
        
        if (data.count)
        {
            //starting order from bottom left
            NSMutableArray *rowsArray = [[NSMutableArray alloc]init];
            
            NSInteger rangeStart;
            NSInteger rangeLength = self.mapWidth;
            
            for (int i = 0; i < self.mapHeight; i++)
            {
                rangeStart = data.count - ((i+1)*self.mapWidth);
                NSArray *row = [data subarrayWithRange:NSMakeRange(rangeStart, rangeLength)];
                [rowsArray addObject:row];
            }
            
            //adding sprites
            for (int i = 0; i < rowsArray.count; i ++)
            {
                NSArray *row = rowsArray[i];
                
                for (int j = 0; j < row.count; j++)
                {
                    NSNumber *number = row[j];
                    
                    if (number.integerValue)
                    {
                        NSString *key = [NSString stringWithFormat:@"%@", number];
                        
                        MapTile *mapTile = tileSets[key];
                        
                        NSLog(@"KEY: %@", key);
                        
                        if(!mapTile)
                        {
                            
                        }
                        
                        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:mapTile.texture];
                        spriteNode.position = CGPointMake(j*spriteNode.size.width, i*spriteNode.size.height);
                        
                        [self addChild:spriteNode];
                    }
                }
            }
        }
    }
}


@end
