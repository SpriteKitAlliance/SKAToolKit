//
//  SKATestHud.m
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

#import "SKATestHud.h"
#import "SKAButtonSprite.h"
#import "SKACollisionDefine.h"

@interface SKATestHud () <ButtonSpriteDelegate>

@property(nonatomic, strong) SKAButtonSprite *buttonLeft;
@property(nonatomic, strong) SKAButtonSprite *buttonRight;
@property(nonatomic, strong) SKAButtonSprite *buttonJump;

@property(nonatomic, strong) SKATestPlayer *player;

@end

@implementation SKATestHud

- (id)initWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player
{
    self = [super init];

    self.zPosition = 100;
    NSInteger padding = 10;

    self.player = player;

    self.buttonLeft = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor]
                                                      size:CGSizeMake(50, 50)];
    self.buttonLeft.position =
        CGPointMake(self.buttonLeft.size.width / 2 + padding,
                    self.buttonLeft.size.height / 2 + padding);
    self.buttonLeft.name = @"buttonLeft";
    self.buttonLeft.userInteractionEnabled = YES;
    self.buttonLeft.delegate = self;
    [self addChild:self.buttonLeft];

    self.buttonRight = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor]
                                                       size:CGSizeMake(50, 50)];
    CGFloat buttonRightPos = self.buttonLeft.position.x +
                             self.buttonLeft.size.width / 2 + padding +
                             self.buttonRight.size.width / 2 + padding;

    self.buttonRight.position =
        CGPointMake(buttonRightPos, self.buttonRight.size.height / 2 + padding);
    self.buttonRight.name = @"buttonRight";
    self.buttonRight.userInteractionEnabled = YES;
    self.buttonRight.delegate = self;
    [self addChild:self.buttonRight];

    self.buttonJump = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor]
                                                      size:CGSizeMake(50, 50)];
    CGPoint position = CGPointMake(scene.view.frame.size.width -
                                       self.buttonJump.size.width / 2 - padding,
                                   self.buttonJump.size.height / 2 + padding);
    self.buttonJump.position = position;
    self.buttonJump.name = @"buttonJump";
    self.buttonJump.userInteractionEnabled = YES;
    self.buttonJump.delegate = self;
    [self addChild:self.buttonJump];

    return self;
}

+ (id)hudWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player
{
    SKATestHud *testHud =
        [[SKATestHud alloc] initWithScene:scene withPlayer:player];

    return testHud;
}

#pragma mark - ButtonSpriteDelegate

- (void)buttonSpritePressed:(SKAButtonSprite *)buttonSprite
{
    if (buttonSprite == self.buttonLeft)
    {
        NSLog(@"moving Left");
    }
    else if (buttonSprite == self.buttonRight)
    {
        NSLog(@"Moving Right");
    }
    else if (buttonSprite == self.buttonJump)
    {
        NSLog(@"Jumping");
    }
}

- (void)buttonSpriteDown:(SKAButtonSprite *)buttonSprite
{
    if (buttonSprite == self.buttonLeft)
    {
        self.player.playerState = PlayerStateMoveLeft;
    }

    if (buttonSprite == self.buttonRight)
    {
        self.player.playerState = PlayerStateMoveRight;
    }

    if (buttonSprite == self.buttonJump)
    {
        self.player.wantsToJump = YES;
    }
}

- (void)buttonSpriteUp:(SKAButtonSprite *)buttonSprite
{
    if (buttonSprite == self.buttonLeft &&
        self.player.playerState == PlayerStateMoveLeft)
    {
        self.player.playerState = PlayerStateMoveIdel;
    }

    if (buttonSprite == self.buttonRight &&
        self.player.playerState == PlayerStateMoveRight)
    {
        self.player.playerState = PlayerStateMoveIdel;
    }
}

@end
