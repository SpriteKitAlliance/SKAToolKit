//
//  SKATMXParser.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKAMap.h"
#import "SKAMapTile.h"
#import "CollisionDefine.h"

@interface SKAMap ()

@end

@implementation SKAMap

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
        
        UIImage *image = [UIImage imageNamed:[tileset[@"image"] lastPathComponent]];
        
        if (!image)
        {
            NSLog(@"Image not found in bundle: %@ looking in file path", [tileset[@"image"] lastPathComponent]);
            image = [[UIImage alloc]initWithContentsOfFile:filePath];
        }
        
        SKTexture *mainTexture = [SKTexture textureWithImage:image];
        
        NSLog(@"Image: %@", image);
        
        //calculating small texture
        NSInteger imageWidth = [tileset[@"imagewidth"] integerValue];
        NSInteger imageHeight = [tileset[@"imageheight"] integerValue];
        
        NSInteger tileRows = imageWidth/tileWidth;
        NSInteger tileColumns = imageHeight/tileWidth;
        
        float tileWidthPercent = 1.0f/(float)tileRows;
        float tileHeightPercent = 1.0f/(float)tileColumns;

        NSInteger index = [tileset[@"firstgid"] integerValue];
        
        for (NSInteger i = 0; i < tileRows; i++)
        {
            for (NSInteger j = 0; j < tileColumns; j++)
            {
                
                SKAMapTile *mapTile = [[SKAMapTile alloc]init];
                SKTexture *texture = [SKTexture textureWithRect:CGRectMake(j*tileWidthPercent, 1.0f-tileHeightPercent*(i+1), tileWidthPercent, tileHeightPercent) inTexture:mainTexture];
                mapTile.texture = texture;
                mapTile.indexKey = index;
                
                NSString *key = [NSString stringWithFormat:@"%@", @(mapTile.indexKey)];
                
                NSString *propertyKey =  [NSString stringWithFormat:@"%@", @(mapTile.indexKey-[tileset[@"firstgid"] integerValue])];
                if (tileset[@"tileproperties"][propertyKey])
                {
                    mapTile.properties = tileset[@"tileproperties"][propertyKey];
                }
                
                [tileSets setObject:mapTile forKey:key];
                
                index++;
            }
        }
    }
    
    NSMutableArray *spriteLayers = [[NSMutableArray alloc]init];
    NSMutableArray *objectLayers = [[NSMutableArray alloc]init];
    
    NSInteger layer = 0;
    
    //layers
    for (NSDictionary *layerDictionary in mapDictionary[@"layers"])
    {
        NSArray *data = layerDictionary[@"data"];
        
        NSLog(@"Layer: %@", layerDictionary);
        
        if (data.count)
        {
            SKASpriteLayer *spriteLayer = [[SKASpriteLayer alloc]init];
            spriteLayer.zPosition = layer;
            
            spriteLayer.height = [layerDictionary[@"height"] integerValue];
            spriteLayer.width = [layerDictionary[@"width"] integerValue];
            spriteLayer.type = layerDictionary[@"type"];

            spriteLayer.opacity = [layerDictionary[@"opacity"] floatValue];
            spriteLayer.name = layerDictionary[@"name"];
            spriteLayer.x = [layerDictionary[@"x"] integerValue];
            spriteLayer.y = [layerDictionary[@"y"] integerValue];
            spriteLayer.visible = [layerDictionary[@"visible"] boolValue];

            
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
            
            NSMutableArray *sprites = [[NSMutableArray alloc]init];
            
            //adding sprites
            for (int i = 0; i < rowsArray.count; i ++)
            {
                NSArray *row = rowsArray[i];
                NSMutableArray *spriteRow = [[NSMutableArray alloc]init];
                
                for (int j = 0; j < row.count; j++)
                {
                    NSNumber *number = row[j];
                    
                    if (number.integerValue)
                    {
                        NSString *key = [NSString stringWithFormat:@"%@", number];
                        
                        SKAMapTile *mapTile = tileSets[key];
                        
                        NSLog(@"KEY: %@", key);
                        
                        if(!mapTile)
                        {
                            
                        }
                        
                        SKASprite *sprite = [SKASprite spriteNodeWithTexture:mapTile.texture];
                        sprite.position = CGPointMake(sprite.size.width/2 + j*sprite.size.width, sprite.size.height/2 + i*sprite.size.height);
                        sprite.properties = mapTile.properties;
                        
                        if ([sprite.properties[@"SKACollisionType"] isEqualToString:@"SKACollisionTypeRect"])
                        {
                            sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
                            sprite.physicsBody.dynamic = NO;
                            sprite.physicsBody.categoryBitMask = SKACategoryFloor;
                            sprite.physicsBody.contactTestBitMask = SKACategoryPlayer;
                            sprite.zPosition = 20;
                        }

                        
                        [spriteRow addObject:sprite];
                        [spriteLayer addChild:sprite];
                    }
                }
                
                [sprites addObject:spriteRow];
            }
            
            spriteLayer.sprites = sprites;
            
            [self addChild:spriteLayer];
            [spriteLayers addObject:spriteLayer];
            
            layer++;
        }
        
        NSArray *objectArray = layerDictionary[@"objects"];
        
        if (objectArray.count)
        {
            SKAObjectLayer *objectLayer = [[SKAObjectLayer alloc]init];
            
            NSMutableArray *collisionSprites = [[NSMutableArray alloc]init];
            
            objectLayer.height = [layerDictionary[@"height"] integerValue];
            objectLayer.width = [layerDictionary[@"width"] integerValue];
            objectLayer.opacity = [layerDictionary[@"opacity"] floatValue];
            objectLayer.name = layerDictionary[@"name"];
            objectLayer.x = [layerDictionary[@"x"] integerValue];
            objectLayer.y = [layerDictionary[@"y"] integerValue];
            objectLayer.visible = [layerDictionary[@"visible"] boolValue];
            objectLayer.drawOrder = layerDictionary[@"draworder"];
          
            
            NSMutableArray *objects = [[NSMutableArray alloc]init];
            
            for (NSDictionary *objectDictionary in objectArray)
            {
                SKAObject *object = [[SKAObject alloc]init];
                object.height = [objectDictionary[@"height"] integerValue];
                object.width = [objectDictionary[@"width"] integerValue];
                object.x = [objectDictionary[@"x"] integerValue];
                object.y = [objectDictionary[@"y"] integerValue];
                
                if ([objectLayer.drawOrder isEqualToString:@"topdown"])
                {
                    object.y = (self.mapHeight*self.tileWidth)-object.y-object.height;
                }
                
                object.objectID = [objectDictionary[@"objectID"] integerValue];
                object.name = objectDictionary[@"name"];
                object.roation = [objectDictionary[@"roation"] integerValue];
                object.type = objectDictionary[@"type"];
                object.visible =  [objectDictionary[@"visible"] boolValue];
                
                object.properties = objectDictionary[@"properties"];
                
                if ([object.properties[@"SKACollisionType"] isEqualToString:@"SKACollisionTypeRect"])
                {
                    SKSpriteNode *floorSprite = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(object.width, object.height)];
                    floorSprite.zPosition = layer;
                    floorSprite.position = CGPointMake(object.centerX, object.centerY);
                    floorSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floorSprite.size];
                    floorSprite.physicsBody.dynamic = NO;
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
}

-(void)update
{
    if (self.autoFollowNode)
    {
        self.position = CGPointMake(-self.autoFollowNode.position.x+self.scene.size.width/2, -self.autoFollowNode.position.y+self.scene.size.height/2);
        
        //keep map from going off screen
        CGPoint position = self.position;
        
        if (position.x > 0)
            position.x = 0;
        
        
        if (position.y > 0)
            position.y = 0;
        
        if (position.y < -self.mapHeight*self.tileWidth+self.scene.size.height)
            position.y = -self.mapHeight*self.tileWidth+self.scene.size.height;
        if (position.x < -self.mapWidth*self.tileWidth+self.scene.size.width)
            position.x = -self.mapWidth*self.tileWidth+self.scene.size.width;
        
        self.position = CGPointMake((int)(position.x), (int)(position.y));
    }
}


@end
