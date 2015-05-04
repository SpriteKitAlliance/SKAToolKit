//
//  GameScene.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "GameScene.h"
#import "SKATMXMap.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    
    SKATMXMap *map = [[SKATMXMap alloc]initWithMapName:@"SampleMap0"];
//    parser.mapNode.xScale = .3;
//    parser.mapNode.yScale = .3;
    [self addChild:map];
}

@end
