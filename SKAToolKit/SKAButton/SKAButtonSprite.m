//
//  ButtonSprite.m
//  SpriteKitGame
//
//  Copyright (c) 2015 Sprite Kit Alliance
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "SKAButtonSprite.h"

@implementation SKAButtonSprite

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(buttonSpriteDown:)])
    {
        [self.delegate buttonSpriteDown:self];
    }

    NSLog(@"touched");
    self.alpha = .5;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        self.alpha = 1;
        CGPoint location = [touch locationInNode:self.parent];

        if(CGRectContainsPoint(self.calculateAccumulatedFrame, location))
        {
            NSLog(@"UP IN SIDE");
            if([self.delegate respondsToSelector:@selector(buttonSpritePressed:)])
            {
                [self.delegate buttonSpritePressed:self];
            }
        }
        else
        {
            NSLog(@"not touched");
        }

        if([self.delegate respondsToSelector:@selector(buttonSpriteUp:)])
        {
            [self.delegate buttonSpriteUp:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;

    if([self.delegate respondsToSelector:@selector(buttonSpriteUp:)])
    {
        [self.delegate buttonSpriteUp:self];
    }
}

@end
