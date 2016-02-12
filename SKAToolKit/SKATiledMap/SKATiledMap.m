//
//  SKATMXParser.m
//  SKATMXParser
//
//  Copyright (c) 2015 Sprite Kit Alliance
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "SKATiledMap.h"
#import "SKAMapTile.h"
#import "SKACollisionDefine.h"
#import "SKATMXParser.h"

@interface SKATiledMap ()

@property (nonatomic, strong) SKSpriteNode *miniMap;
@property (nonatomic, strong) SKSpriteNode *croppedMap;

// culling
// TODO more explanation is needed
@property (nonatomic) BOOL culledBefore;
@property (nonatomic) NSMutableArray *visibleArray;
@property (nonatomic) NSInteger lastX;
@property (nonatomic) NSInteger lastY;
@property (nonatomic) NSInteger lastWidth;
@property (nonatomic) NSInteger lastHeight;

@end

@implementation SKATiledMap

#pragma mark - Init
- (instancetype)initWithMapName:(NSString *)mapName
{
    if(!(self = [super init]))
        return nil;

    [self loadFile:mapName];

    return self;
}

#pragma mark - File Loading
- (void)loadFile:(NSString *)fileName
{
    NSString *filePath =
        [[NSBundle mainBundle] pathForResource:fileName
                                        ofType:@"tmx"];

    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [self loadMap:[self mapDictionaryForTMXFile:filePath]];
    }
    else
    {
        filePath =
            [[NSBundle mainBundle] pathForResource:fileName
                                            ofType:@"json"];

        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            [self loadMap:[self mapDictionaryForJSONFile:filePath]];
        }
        else
        {
            NSLog(@"error: no file could be found for %@.tmx or %@.json",
                fileName, fileName);
        }
    }
}

- (NSDictionary *)mapDictionaryForTMXFile:(NSString *)filePath
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingMappedIfSafe
                                            error:&error];

    if(!error)
    {
        SKATMXParser *parser = [[SKATMXParser alloc] init];
        return [parser dictionaryWithData:data];
    }

    NSLog(@"Error creating map from TMX file: %@", filePath);
    return nil;
}

- (NSDictionary *)mapDictionaryForJSONFile:(NSString *)filePath
{
    NSError *error = nil;
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:&error];

    if(!error)
    {
        error = nil;
        NSDictionary *mapDictionary =
            [NSJSONSerialization JSONObjectWithData:JSONData
                                            options:NSJSONReadingAllowFragments
                                              error:&error];

        if(!error)
        {
            return mapDictionary;
        }
    }

    NSLog(@"Error creating map from JSON file: %@", filePath);
    return nil;
}

- (void)loadMap:(NSDictionary *)mapDictionary
{
    self.mapProperties = mapDictionary[@"properties"];

    self.mapWidth = [mapDictionary[@"width"] integerValue];
    self.mapHeight = [mapDictionary[@"height"] integerValue];

    self.tileWidth = [mapDictionary[@"tilewidth"] integerValue];
    self.tileHeight = [mapDictionary[@"tileheight"] integerValue];

    // creating tile dictionary
    NSMutableDictionary *tileSets = [[NSMutableDictionary alloc] init];

    for(NSDictionary *tileset in mapDictionary[@"tilesets"])
    {
        NSInteger tileWidth = [tileset[@"tilewidth"] integerValue];
        NSInteger tileHeight = [tileset[@"tileheight"] integerValue];

        // getting big texture
        NSString *path = [[tileset[
            @"image"] lastPathComponent] stringByDeletingPathExtension];

        if(path)
        {
            NSString *filePath = [[NSBundle mainBundle]
                pathForResource:path
                         ofType:[tileset[@"image"] pathExtension]];

            UIImage *image =
                [UIImage imageNamed:[tileset[@"image"] lastPathComponent]];

            if(!image)
            {
                NSLog(@"Image not found in bundle: %@ looking in file path",
                    [tileset[@"image"] lastPathComponent]);
                image = [[UIImage alloc] initWithContentsOfFile:filePath];
            }

            SKTexture *mainTexture = [SKTexture textureWithImage:image];
            mainTexture.filteringMode = SKTextureFilteringNearest;

            // calculating small texture
            NSInteger imageWidth = [tileset[@"imagewidth"] integerValue];
            NSInteger imageHeight = [tileset[@"imageheight"] integerValue];

            NSInteger spacing = [tileset[@"spacing"] integerValue];
            NSInteger margin = [tileset[@"margin"] integerValue];

            NSInteger width = imageWidth - margin * 2;
            NSInteger height = imageHeight - margin * 2;

            NSInteger tileColumns = ceil((float)width / (float)(tileWidth + spacing));
            NSInteger tileRows = ceil((float)height / (float)(tileHeight + spacing));

            float spacingPercentWidth = (float)spacing / (float)imageWidth;
            float spacingPercentHeight = (float)spacing / (float)imageHeight;

            float marginPercentWidth = (float)margin / (float)tileWidth;
            float marginPercentHeight = (float)margin / (float)tileHeight;

            float tileWidthPercent = (float)tileWidth / (float)imageWidth;
            float tileHeightPercent = (float)tileHeight / (float)imageHeight;

            NSInteger index = [tileset[@"firstgid"] integerValue];

            // TODO I belive there is a better way to do this than two loops,
            // too
            // tired to remember right now
            // May be a swift thing though
            for(NSInteger i = 0; i < tileRows; i++)
            {
                for(NSInteger j = 0; j < tileColumns; j++)
                {
                    SKAMapTile *mapTile = [[SKAMapTile alloc] init];
                    float x = marginPercentWidth + j * (tileWidthPercent + spacingPercentWidth); // advance based on column

                    float y = 1.0f - (marginPercentHeight + tileHeightPercent + (i * (tileHeightPercent + (spacingPercentHeight))));

                    SKTexture *texture = [SKTexture
                        textureWithRect:CGRectMake(x, y, tileWidthPercent,
                                            tileHeightPercent)
                              inTexture:mainTexture];

                    texture.filteringMode = SKTextureFilteringNearest;

                    mapTile.texture = texture;
                    mapTile.indexKey = index;

                    // TODO this looks spooky, maybe make it a helper function
                    // to get the
                    // keys?
                    NSString *key =
                        [NSString stringWithFormat:@"%@", @(mapTile.indexKey)];

                    NSString *propertyKey = [NSString
                        stringWithFormat:
                            @"%@", @(mapTile.indexKey -
                                       [tileset[@"firstgid"] integerValue])];

                    if(tileset[@"tileproperties"][propertyKey])
                    {
                        mapTile.properties = tileset[@"tileproperties"][propertyKey];
                    }

                    [tileSets setObject:mapTile forKey:key];

                    index++;
                }
            }
        }
        else
        {

            for(NSString *key in [tileset[@"tiles"] allKeys])
            {
                SKAMapTile *mapTile = [[SKAMapTile alloc] init];

                NSDictionary *spriteDict = tileset[@"tiles"][key];
                NSString *imageName;
                
                if (spriteDict[@"image"])
                {
                    imageName = [spriteDict[@"image"] lastPathComponent];
                }
                else if (spriteDict[@"source"])
                {
                    imageName = [spriteDict[@"source"] lastPathComponent];
                }
                else
                {
                    NSLog(@"error finding source for image in collection");
                }
                
                //iOS 9 does not like path extensions for textureWithImageName:
                SKTexture *texture =
                    [SKTexture textureWithImageNamed:[imageName stringByDeletingPathExtension]];
                texture.filteringMode = SKTextureFilteringNearest;

                mapTile.texture = texture;
                mapTile.indexKey =
                    [tileset[@"firstgid"] integerValue] + [key integerValue];

                NSString *key =
                    [NSString stringWithFormat:@"%@", @(mapTile.indexKey)];

                NSString *propertyKey = [NSString
                    stringWithFormat:@"%@",
                    @(mapTile.indexKey -
                                         [tileset[@"firstgid"] integerValue])];
                if(tileset[@"tileproperties"][propertyKey])
                {
                    mapTile.properties = tileset[@"tileproperties"][propertyKey];
                }

                [tileSets setObject:mapTile forKey:key];
            }
        }
    }

    NSMutableArray *spriteLayers = [[NSMutableArray alloc] init];
    NSMutableArray *objectLayers = [[NSMutableArray alloc] init];

    NSInteger layer = 0;

    // layers
    // TODO more explanation please
    for(NSDictionary *layerDictionary in mapDictionary[@"layers"])
    {
        NSArray *data = layerDictionary[@"data"];

        if(data.count)
        {
            SKASpriteLayer *spriteLayer = [[SKASpriteLayer alloc] init];
            spriteLayer.zPosition = layer;

            spriteLayer.height = [layerDictionary[@"height"] integerValue];
            spriteLayer.width = [layerDictionary[@"width"] integerValue];
            spriteLayer.type = layerDictionary[@"type"];

            spriteLayer.opacity = [layerDictionary[@"opacity"] floatValue];
            spriteLayer.name = layerDictionary[@"name"];
            spriteLayer.x = [layerDictionary[@"x"] integerValue];
            spriteLayer.y = [layerDictionary[@"y"] integerValue];
            spriteLayer.visible = [layerDictionary[@"visible"] boolValue];

            // starting order from bottom left
            NSMutableArray *rowsArray = [[NSMutableArray alloc] init];

            NSInteger rangeStart;
            NSInteger rangeLength = self.mapWidth;

            for(int i = 0; i < self.mapHeight; i++)
            {
                rangeStart = data.count - ((i + 1) * self.mapWidth);
                NSArray *row = [data
                    subarrayWithRange:NSMakeRange(rangeStart, rangeLength)];
                [rowsArray addObject:row];
            }

            NSMutableArray *sprites = [[NSMutableArray alloc] init];

            for(NSInteger i = 0; i < self.mapWidth; i++)
            {
                NSMutableArray *column = [[NSMutableArray alloc] init];

                for(NSInteger j = 0; j < self.mapHeight; j++)
                {
                    [column addObject:[NSNull null]];
                }

                [sprites addObject:column];
            }

            // adding sprites
            for(int i = 0; i < rowsArray.count; i++)
            {
                NSArray *row = rowsArray[i];

                for(int j = 0; j < row.count; j++)
                {
                    NSNumber *number = row[j];

                    if(number.integerValue)
                    {
                        NSString *key =
                            [NSString stringWithFormat:@"%@", number];

                        SKAMapTile *mapTile = tileSets[key];

                        SKASprite *sprite =
                            [SKASprite spriteNodeWithTexture:mapTile.texture];
                        NSInteger x = (sprite.size.width / 2 - self.tileWidth / 2) + self.tileWidth / 2 + j * self.tileWidth;
                        NSInteger y = (sprite.size.height / 2 - self.tileHeight / 2) + self.tileHeight / 2 + i * self.tileHeight;
                        sprite.position = CGPointMake(x, y);
                        sprite.properties = mapTile.properties;
                        if([sprite.properties[@"SKACollisionType"]
                               isEqualToString:@"SKACollisionTypeRect"])
                        {
                            sprite.physicsBody = [SKPhysicsBody
                                bodyWithRectangleOfSize:sprite.size];
                            sprite.physicsBody.pinned = YES;
                            sprite.physicsBody.dynamic = NO;
                            sprite.physicsBody.categoryBitMask = SKACategoryFloor;
                            sprite.physicsBody.contactTestBitMask = SKACategoryPlayer;
                            sprite.zPosition = 20;
                        }
                        sprite.positionOnMap = CGPointMake(j,i);
                        //[spriteLayer addChild:sprite];
                        
                        if(!spriteLayer.visible)
                        {
                            sprite.hidden = YES;
                        }

                        sprites[j][i] = sprite;
                    }
                    else
                    {
                        sprites[j][i] = [NSNull null];
                    }
                }
            }

            spriteLayer.sprites = sprites;

            [self addChild:spriteLayer];
            [spriteLayers addObject:spriteLayer];

            layer++;
        }

        NSArray *objectArray = layerDictionary[@"objects"];

        if(objectArray.count)
        {
            SKAObjectLayer *objectLayer = [[SKAObjectLayer alloc] init];

            NSMutableArray *collisionSprites = [[NSMutableArray alloc] init];

            objectLayer.height = [layerDictionary[@"height"] integerValue];
            objectLayer.width = [layerDictionary[@"width"] integerValue];
            objectLayer.opacity = [layerDictionary[@"opacity"] floatValue];
            objectLayer.name = layerDictionary[@"name"];
            objectLayer.x = [layerDictionary[@"x"] integerValue];
            objectLayer.y = [layerDictionary[@"y"] integerValue];
            objectLayer.visible = [layerDictionary[@"visible"] boolValue];
            objectLayer.drawOrder = layerDictionary[@"draworder"];

            NSMutableArray *objects = [[NSMutableArray alloc] init];

            for(NSDictionary *objectDictionary in objectArray)
            {
                SKAObject *object = [[SKAObject alloc] init];
                object.height = [objectDictionary[@"height"] integerValue];
                object.width = [objectDictionary[@"width"] integerValue];
                object.x = [objectDictionary[@"x"] integerValue];
                object.y = [objectDictionary[@"y"] integerValue];

                if([objectLayer.drawOrder isEqualToString:@"topdown"])
                {
                    object.y = (self.mapHeight * self.tileHeight) - object.y - object.height;
                }

                object.objectID = [objectDictionary[@"objectID"] integerValue];
                object.name = objectDictionary[@"name"];
                object.rotation = [objectDictionary[@"rotation"] integerValue];
                object.type = objectDictionary[@"type"];
                object.visible = [objectDictionary[@"visible"] boolValue];

                object.properties = objectDictionary[@"properties"];

                if([object.properties[@"SKACollisionType"]
                       isEqualToString:@"SKACollisionTypeRect"])
                {
                    SKSpriteNode *floorSprite = [SKSpriteNode
                        spriteNodeWithColor:[UIColor clearColor]
                                       size:CGSizeMake(object.width,
                                                object.height)];
                    floorSprite.zPosition = layer;
                    floorSprite.position = CGPointMake(object.centerX, object.centerY);
                    floorSprite.physicsBody = [SKPhysicsBody
                        bodyWithRectangleOfSize:floorSprite.size];
                    floorSprite.physicsBody.dynamic = NO;
                    floorSprite.physicsBody.pinned = YES;
                    floorSprite.physicsBody.categoryBitMask = SKACategoryFloor;
                    floorSprite.physicsBody.contactTestBitMask = SKACategoryPlayer;
                    [self addChild:floorSprite];

                    [collisionSprites addObject:floorSprite];
                }

                [objects addObject:object];
            }

            objectLayer.collisionSprites = collisionSprites;

            objectLayer.objects = objects;
            [objectLayers addObject:objectLayer];

            layer++;
        }
    }

    self.spriteLayers = spriteLayers;
    self.objectLayers = objectLayers;
    self.visibleArray = [[NSMutableArray alloc] init];
}

- (SKSpriteNode *)miniMapWithWidth:(NSInteger)width
{
    SKTexture *texture = [self.scene.view textureFromNode:self];

    NSInteger height = ((float)width / ((float)self.mapWidth * (float)self.tileWidth)) * (self.mapHeight * self.tileHeight);
    SKSpriteNode *miniMap =
        [SKSpriteNode spriteNodeWithTexture:texture
                                       size:CGSizeMake(width, height)];

    [self addChild:miniMap];

    texture = [self.scene.view textureFromNode:miniMap];

    [miniMap removeFromParent];

    miniMap = [SKSpriteNode spriteNodeWithTexture:texture];

    return miniMap;
}

- (SKSpriteNode *)miniMapWithWidth:(NSInteger)width withCroppedSize:(CGSize)size
{
    self.miniMap = [self miniMapWithWidth:width];
    self.miniMap.anchorPoint = CGPointMake(0, 0);

    SKCropNode *croppedNode = [[SKCropNode alloc] init];
    [croppedNode addChild:self.miniMap];

    SKSpriteNode *mask =
        [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                     size:size];
    croppedNode.maskNode = mask;

    self.croppedMap =
        [SKSpriteNode spriteNodeWithColor:[SKColor clearColor]
                                     size:size];
    [self.croppedMap addChild:croppedNode];

    return self.croppedMap;
}

- (void)update
{
    if(self.autoFollowNode)
    {
        self.position = CGPointMake(
            -self.autoFollowNode.position.x + self.scene.size.width / 2,
            -self.autoFollowNode.position.y + self.scene.size.height / 2);

        /*
         * Check position of the minimap and stop it from going off screen
         */

        CGPoint position = self.position;

        if(position.x > 0)
        {
            position.x = 0;
        }

        if(position.y > 0)
        {
            position.y = 0;
        }

        if(position.y < -self.mapHeight * self.tileHeight + self.scene.size.height)
            position.y = -self.mapHeight * self.tileHeight + self.scene.size.height;
        if(position.x < -self.mapWidth * self.tileWidth + self.scene.size.width)
            position.x = -self.mapWidth * self.tileWidth + self.scene.size.width;

        self.position = CGPointMake((int)(position.x), (int)(position.y));
    }

    if(self.autoFollowNode && self.miniMap && self.croppedMap)
    {
        float scale = self.miniMap.size.width / (self.mapWidth * self.tileWidth);

        self.miniMap.position = CGPointMake(
            -self.autoFollowNode.position.x + self.scene.size.width / 2,
            -self.autoFollowNode.position.y + self.scene.size.height / 2);

        // scaling down
        self.miniMap.position = CGPointMake(self.miniMap.position.x * scale,
            self.miniMap.position.y * scale);

        // keep map from going off screen
        CGPoint position = self.miniMap.position;

        /*
         * Check position of the minimap and stop it from going off screen
         */

        if(position.x > 0)
        {
            position.x = 0;
        }

        if(position.y > 0)
        {
            position.y = 0;
        }

        if(position.y < -self.miniMap.size.height + self.croppedMap.size.height)
        {
            position.y = -self.miniMap.size.height + self.croppedMap.size.height;
        }

        if(position.x < -self.miniMap.size.width + self.croppedMap.size.width)
            position.x = -self.miniMap.size.width + self.croppedMap.size.width;

        self.miniMap.position = CGPointMake((int)(position.x - self.croppedMap.size.width / 2),
            (int)(position.y - self.croppedMap.size.height / 2));
    }
}

- (CGPoint)indexForPoint:(CGPoint)point
{
    return CGPointMake((NSInteger)point.x / self.tileWidth,
        (NSInteger)point.y / self.tileHeight);
}

- (NSArray *)tilesAroundPoint:(CGPoint)point inLayer:(NSInteger)layer
{
    CGPoint index = [self indexForPoint:point];

    return [self tilesAroundIndex:index inLayer:layer];
}

- (NSArray *)tilesAroundIndex:(CGPoint)point inLayer:(NSInteger)layer
{
    NSMutableArray *tiles = [[NSMutableArray alloc] init];

    NSInteger x = point.x;
    NSInteger y = point.y;

    SKASpriteLayer *spriteLayer = self.spriteLayers[layer];
    NSArray *array = spriteLayer.sprites;

    if(x - 1 >= 0)
    {
        [tiles addObject:array[x - 1][y]];

        if(y - 1 >= 0)
        {
            [tiles addObject:array[x - 1][y - 1]];
        }

        if(y + 1 < self.mapHeight)
        {
            [tiles addObject:array[x - 1][y + 1]];
        }
    }

    if(x + 1 < self.mapWidth)
    {
        [tiles addObject:array[x + 1][y]];

        if(y + 1 < self.mapHeight)
        {
            [tiles addObject:array[x + 1][y + 1]];
        }

        if(y - 1 >= 0)
        {
            [tiles addObject:array[x + 1][y - 1]];
        }
    }

    if(y - 1 >= 0)
    {
        [tiles addObject:array[x][y - 1]];
    }

    if(y + 1 < self.mapHeight)
    {
        [tiles addObject:array[x][y + 1]];
    }

    // removing any NSNulls
    for(id object in tiles.copy)
    {
        if(![object isKindOfClass:[SKASprite class]])
        {
            [tiles removeObject:object];
        }
    }

    return tiles;
}

- (SKASprite *)spriteOnLayer:(NSInteger)layerNumber
                      indexX:(NSInteger)x
                      indexY:(NSInteger)y
{
    SKASpriteLayer *spriteLayer = self.spriteLayers[layerNumber];

    return [spriteLayer spriteForIndexX:x indexY:y];
}

- (NSArray *)objectsOnLayer:(NSInteger)layerNumber withName:(NSString *)name
{
    SKAObjectLayer *objectLayer = self.objectLayers[layerNumber];

    return [objectLayer objectsWithName:name];
}

- (void)cullAroundIndexX:(NSInteger)x
                  indexY:(NSInteger)y
             columnWidth:(NSInteger)width
               rowHeight:(NSInteger)height
{
    
    // only update if something changed
  if(self.lastX != x || self.lastY != y || self.lastWidth != width || self.lastHeight != height)
    {
      
        NSInteger startingX = x - width / 2;
        NSInteger startingY = y - height / 2 ;
        NSInteger endingX = startingX + width;
        NSInteger endingY = startingY + height;
        
        if(startingX < 0)
        {
            startingX = 0;
            
            endingX = width;
        }
        
        if(startingY < 0)
        {
            startingY = 0;
            
            endingY = height;
        }
        
        if(endingX > self.mapWidth - 1)
        {
            endingX = self.mapWidth - 1;
            
            startingX = endingX - width;
        }
        
        if(endingY > self.mapHeight - 1)
        {
            endingY = self.mapHeight - 1;
            
            startingY = endingY - height;
        }
        NSMutableArray *spritesToTrash = [[NSMutableArray alloc] init];
       [self.visibleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            SKASprite *sprite = obj;
            if (sprite.positionOnMap.x < startingX || sprite.positionOnMap.x >= endingX || sprite.positionOnMap.y < startingY || sprite.positionOnMap.y >= endingY) {
                [sprite removeFromParent];
                [spritesToTrash addObject:sprite];
            }
        }];
        [self.visibleArray removeObjectsInArray:spritesToTrash];

        for(NSInteger l = 0; l < self.spriteLayers.count; l++)
        {
            for(NSInteger x = startingX; x < endingX; x++)
                {
                    for(NSInteger y = startingY; y < endingY; y++)
                    {
                    
                            SKASprite *sprite =
                            [self spriteOnLayer:l
                                         indexX:x
                                         indexY:y];

                            if (sprite && sprite.parent == nil) {
                                    SKASpriteLayer *layer = self.spriteLayers[l];
                                    [layer addChild:sprite];
                                    [self.visibleArray addObject:sprite];
                            }
                    }
                }
        }
    }
    
    self.lastX = x;
    self.lastY = y;
    self.lastWidth = width;
    self.lastHeight = height;
    
    self.culledBefore = YES;
}


@end