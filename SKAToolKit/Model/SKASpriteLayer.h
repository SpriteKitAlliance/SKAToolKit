//
//  SKASpriteLayer.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKASprite.h"

@interface SKASpriteLayer : SKNode

//TODO these can be a struct {{x: NSInteger, y: NSInteger}, {width: NSInteger, height: NSInteger}}
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;

@property (nonatomic) float opacity;
@property (nonatomic) BOOL visible;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSArray *collisionSprites;

/**
 two dementional array of SKASprites and NSNull
 */
@property (nonatomic, strong) NSArray *sprites;

-(SKASprite *)spriteForIndexX:(NSInteger)x indexY:(NSInteger)y;

@end