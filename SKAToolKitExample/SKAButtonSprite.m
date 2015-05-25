//
//  ButtonSprite.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/28/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "SKAButtonSprite.h"

@implementation SKAButtonSprite

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate buttonSpriteDown:self];
    NSLog(@"touched");
    self.alpha = .5;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        self.alpha = 1;
        CGPoint location = [touch locationInNode:self.parent];

        if(CGRectContainsPoint(self.calculateAccumulatedFrame, location))
        {
            NSLog(@"UP IN SIDE");
            [self.delegate buttonSpritePressed:self];
        }
        else
        {
            NSLog(@"not touched");
        }
        
        [self.delegate buttonSpriteUp:self];

    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;

    [self.delegate buttonSpriteUp:self];
}


@end
