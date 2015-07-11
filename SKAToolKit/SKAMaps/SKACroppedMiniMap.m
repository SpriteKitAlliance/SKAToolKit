//
//  SKACroppedMiniMap.m
//  SKAToolKitExample
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKACroppedMiniMap.h"

@interface SKACroppedMiniMap  ()

@property (nonatomic, strong)SKAMiniMap *miniMap;
@property (nonatomic, strong)SKNode *map;

@end

@implementation SKACroppedMiniMap

- (id)initWithMap:(SKNode*)map withWidth:(NSInteger)width withCroppedSize:(CGSize)size {
  SKAMiniMap *miniMap = [[SKAMiniMap alloc]initWithMap:map withWidth:width];
  
  miniMap.anchorPoint = CGPointMake(0, 0);
  
  SKCropNode *croppedNode = [[SKCropNode alloc]init];
  [croppedNode addChild:miniMap];
  
  SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:size];
  croppedNode.maskNode = mask;
  
  self = [super initWithColor:[UIColor clearColor] size:size];
  self.miniMap = miniMap;
  [self addChild:croppedNode];
  
  return self;
}

- (void)update {
  
  if (self.autoFollowNode && self.miniMap) {
    self.miniMap.position = CGPointMake(-self.autoFollowNode.position.x + self.scene.size.width / 2.f,
                                        -self.autoFollowNode.position.y + self.scene.size.height / 2.f);
    
    //scaling down
    self.miniMap.position = CGPointMake(self.miniMap.position.x*self.miniMap.scaledTo, self.miniMap.position.y * self.miniMap.scaledTo);
    
    //This keeps the map from going off screen
    CGPoint position = self.miniMap.position;
    
    //TODO explain why we do this!
    if (position.x > 0) {
      position.x = 0;
    }
    
    if (position.y > 0) {
      position.y = 0;
    }
    
    if (position.y < -self.miniMap.size.height + self.size.height) {
      position.y = -self.miniMap.size.height + self.size.height;
    }
    
    if (position.x < -self.miniMap.size.width + self.size.width) {
      position.x = -self.miniMap.size.width + self.size.width;
    }
    
    //TODO: Determine if we need to cast to ints here
    self.miniMap.position = CGPointMake((int) (position.x - self.size.width / 2.f),
                                        (int) (position.y - self.size.height / 2.f));
  }
}

@end
