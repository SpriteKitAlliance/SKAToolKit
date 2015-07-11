//
//  SKAMiniMap.m
//  SKAToolKitExample
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKAMiniMap.h"

@interface SKAMiniMap ()

@property (nonatomic, readwrite) float scaledTo;

@end

@implementation SKAMiniMap

- (id)initWithMap:(SKNode*)map withWidth:(NSInteger)width {
  if(!map.scene.view) {
    NSLog(@"map must be added to a scene to create a minimap");
    return nil;
  }
  
  SKTexture *texture = [map.scene.view textureFromNode:map];
  
  float scaledTo = (float) width / map.calculateAccumulatedFrame.size.width;
  
  NSInteger height = (scaledTo * (float) map.calculateAccumulatedFrame.size.height);
  
  SKSpriteNode *miniMap = [SKSpriteNode spriteNodeWithTexture:texture size:CGSizeMake(width, height)];
  
  [map addChild:miniMap];
  
  texture = [map.scene.view textureFromNode:miniMap];
  
  [miniMap removeFromParent];
  
  self = [super initWithTexture:texture];
  
  self.scaledTo = scaledTo;
  
  return self;
}

@end