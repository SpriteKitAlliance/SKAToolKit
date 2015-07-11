//
//  SKAMiniMap.h
//  SKAToolKitExample
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKAMiniMap : SKSpriteNode

@property(nonatomic, readonly) float scaledTo;

/**
 map must be part of a scene with a view
 */
- (id)initWithMap:(SKNode *)map withWidth:(NSInteger)width;

@end