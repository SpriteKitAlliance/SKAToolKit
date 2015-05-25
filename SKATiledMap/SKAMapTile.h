//
//  SpriteMapTile.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/4/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKAMapTile : NSObject

@property (nonatomic, strong)NSDictionary *properties;
@property (nonatomic)NSInteger indexKey;
@property (nonatomic, strong)SKTexture *texture;

@end
