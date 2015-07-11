//
//  SKATestHud.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKATestPlayer.h"

//TODO Comment this is a class for testing only, not meant to be subclassed or used in the final project
@interface SKATestHud : SKNode

/**
 TODO comment on this
 */
-(id)initWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player;

/**
 TODO comment on this
 */
+(id)hudWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player;

@end