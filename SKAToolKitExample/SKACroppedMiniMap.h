//
//  SKACroppedMiniMap.h
//  SKAToolKitExample
//
//  Created by Skyler Lauren on 5/29/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKAMiniMap.h"

@interface SKACroppedMiniMap : SKAMiniMap

//node that is child of map used to create minimap
@property (nonatomic, strong)SKNode *autoFollowNode;

//map must be part of a scene with a view
-(id)initWithMap:(SKNode*)map withWidth:(NSInteger)width withCroppedSize:(CGSize)size;

-(void)update;

@end
