//
//  SKATMXParser.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "SKASpriteLayer.h"
#import "SKAObjectLayer.h"

@interface SKATiledMap : SKNode

- (instancetype)initWithMapName:(NSString *)mapName;

@property(nonatomic) NSInteger mapWidth;
@property(nonatomic) NSInteger mapHeight;
@property(nonatomic) NSInteger tileWidth;
@property(nonatomic) NSInteger tileHeight;

/**
 returns an array of SKASpriteLayers
 */
@property(nonatomic, strong) NSArray *spriteLayers;

/**
 returns an array of SKAObjectLayers
 */
@property(nonatomic, strong) NSArray *objectLayers;

@property(nonatomic, strong) NSDictionary *mapProperties;

@property(nonatomic, strong) SKSpriteNode *firstTile;

@property(nonatomic, strong) SKNode *autoFollowNode;

- (void)update;
- (CGPoint)indexForPoint:(CGPoint)point;

- (NSArray *)tilesAroundPoint:(CGPoint)point inLayer:(NSInteger)layer;
- (NSArray *)tilesAroundIndex:(CGPoint)point inLayer:(NSInteger)layer;

// returns a small version of the map at the time of creation
- (SKSpriteNode *)miniMapWithWidth:(NSInteger)width;

- (SKSpriteNode *)miniMapWithWidth:(NSInteger)width
                   withCroppedSize:(CGSize)size;

- (SKASprite *)spriteOnLayer:(NSInteger)layerNumber
                      indexX:(NSInteger)x
                      indexY:(NSInteger)y;

- (NSArray *)objectsOnLayer:(NSInteger)layerNumber withName:(NSString *)name;

- (void)cullAroundIndexX:(NSInteger)x
                  indexY:(NSInteger)y
             columnWidth:(NSInteger)width
               rowHeight:(NSInteger)height;

@end