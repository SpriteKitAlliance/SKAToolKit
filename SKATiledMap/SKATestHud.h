//
//  SKATestHud.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/23/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKATestPlayer.h"

@interface SKATestHud : SKNode

-(id)initWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player;

+(id)hudWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player;

@end
