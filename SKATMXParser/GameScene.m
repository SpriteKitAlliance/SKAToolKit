//
//  GameScene.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "GameScene.h"
#import <SKATiledMap/SKATiledMap.h>

@interface GameScene ()

@property (nonatomic, strong)SKATestPlayer *player;
@property (nonatomic, strong)SKAMap *map;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    self.map = [[SKAMap alloc]initWithMapName:@"SampleMap0"];
//    self.map.xScale = .3;
//    self.map.yScale = .3;
    [self addChild:self.map];
    
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.5];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:.5];
    
    SKAction *repeat = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
    
    SKASpriteLayer *layer =  self.map.spriteLayers[2];
    
    [layer runAction:repeat];
    
    SKASpriteLayer *backgroundLayer = self.map.spriteLayers[1];
    
    SKAction *rotate = [SKAction rotateByAngle:2 duration:1];
    SKAction *repeatRotation = [SKAction repeatActionForever:rotate];
    
    SKASprite *sprite = backgroundLayer.sprites[3][3];
    [sprite runAction:repeatRotation];
    
    self.player = [SKATestPlayer spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(40, 80)];
    self.player.zPosition = 20;
    self.player.position = CGPointMake(400, 400);
    [self.map addChild:self.player];
    
    self.map.autoFollowNode = self.player;

     
    SKATestHud *testHud = [SKATestHud hudWithScene:self.scene withPlayer:self.player];
    
    [self addChild:testHud];
    
    
}

-(void)update:(NSTimeInterval)currentTime
{
    [self.player update];
    [self.map update];
}

@end
