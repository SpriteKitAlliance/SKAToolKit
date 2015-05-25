//
//  SKATMXParser.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "SKASpriteLayer.h"
#import "SKAObjectLayer.h"

@interface SKATiledMap : SKNode

-(instancetype)initWithMapName:(NSString *)mapName;

@property (nonatomic)NSInteger mapWidth;
@property (nonatomic)NSInteger mapHeight;
@property (nonatomic)NSInteger tileWidth;

//returns an array of SKASpriteLayers
@property (nonatomic, strong)NSArray *spriteLayers;

//returns an array of SKAObjectLayers
@property (nonatomic, strong)NSArray *objectLayers;

@property (nonatomic, strong)NSDictionary *mapProperties;

@property (nonatomic, strong)SKSpriteNode *firstTile;

@property (nonatomic, strong)SKNode *autoFollowNode;

-(void)update;

@end
