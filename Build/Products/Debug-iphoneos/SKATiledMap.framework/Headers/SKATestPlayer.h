//
//  SKATestPlayer.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/23/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, PlayerState) {
    PlayerStateMoveLeft,
    PlayerStateMoveRight,
    PlayerStateMoveIdel
};

@interface SKATestPlayer : SKSpriteNode

@property (nonatomic)BOOL wantsToJump;
@property (nonatomic)PlayerState playerState;

-(void)update;

@end
