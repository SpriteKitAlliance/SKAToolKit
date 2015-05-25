//
//  ButtonSprite.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/28/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SKAButtonSprite;

@protocol ButtonSpriteDelegate <NSObject>

@optional
-(void)buttonSpritePressed:(SKAButtonSprite *)buttonSprite;
-(void)buttonSpriteDown:(SKAButtonSprite *)buttonSprite;
-(void)buttonSpriteUp:(SKAButtonSprite *)buttonSprite;

@end

@interface SKAButtonSprite : SKSpriteNode

@property (weak)id<ButtonSpriteDelegate> delegate;

@end
