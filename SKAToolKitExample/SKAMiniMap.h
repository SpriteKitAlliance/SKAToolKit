//
//  SKAMiniMap.h
//  SKAToolKitExample
//
//  Created by Skyler Lauren on 5/29/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAMiniMap : SKSpriteNode

//map must be part of a scene with a view
-(id)initWithMap:(SKNode*)map withWidth:(NSInteger)width;

@property (nonatomic, readonly)float scaledTo;

@end
