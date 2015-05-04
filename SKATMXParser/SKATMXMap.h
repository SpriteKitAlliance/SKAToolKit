//
//  SKATMXParser.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKATMXMap : SKNode

-(instancetype)initWithMapName:(NSString *)mapName;

@property (nonatomic)NSInteger mapWidth;
@property (nonatomic)NSInteger mapHeight;
@property (nonatomic)NSInteger tileWidth;

@property (nonatomic)NSArray *layers;

@property (nonatomic, strong)NSDictionary *mapProperties;

@property (nonatomic, strong)SKSpriteNode *firstTile;

@end
