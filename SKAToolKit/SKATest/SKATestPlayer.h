//
//  SKATestPlayer.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

//TODO Comment this is a class for testing only, not meant to be subclassed or used in the final project
typedef NS_ENUM(NSUInteger, PlayerState) {
    PlayerStateMoveLeft,
    PlayerStateMoveRight,
    PlayerStateMoveIdel
};

@interface SKATestPlayer : SKSpriteNode

@property (nonatomic) BOOL wantsToJump;
@property (nonatomic) PlayerState playerState;

- (void)update;

@end