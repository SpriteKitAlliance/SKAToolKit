//
//  SpriteMapTile.h
//  SpriteKitGame
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKAMapTile : NSObject

@property(nonatomic) NSInteger indexKey;

@property(nonatomic, strong) NSDictionary *properties;
@property(nonatomic, strong) SKTexture *texture;

@end