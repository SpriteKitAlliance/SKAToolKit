//
//  SKATMXParser.h
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