//
//  SKATestHud.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/23/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKATestHud.h"
#import "SKAButtonSprite.h"
#import "CollisionDefine.h"

@interface SKATestHud ()<ButtonSpriteDelegate>

@property (nonatomic, strong)SKAButtonSprite *buttonLeft;
@property (nonatomic, strong)SKAButtonSprite  *buttonRight;
@property (nonatomic, strong)SKAButtonSprite  *buttonJump;

@property (nonatomic, strong)SKATestPlayer *player;

@end

@implementation SKATestHud

-(id)initWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player
{
    self = [super init];
    
    self.zPosition = 100;
    
    self.player = player;
    
    NSInteger padding = 10;
    
    self.buttonLeft = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(50, 50)];
    self.buttonLeft.position = CGPointMake(self.buttonLeft.size.width/2+padding, self.buttonLeft.size.height/2+padding);
    self.buttonLeft.name = @"buttonLeft";
    self.buttonLeft.userInteractionEnabled = YES;
    self.buttonLeft.delegate = self;
    [self addChild:self.buttonLeft];
    
    self.buttonRight = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(50, 50)];
    self.buttonRight.position = CGPointMake(self.buttonLeft.position.x+self.buttonLeft.size.width/2+padding+self.buttonRight.size.width/2+padding, self.buttonRight.size.height/2+padding);
    self.buttonRight.name = @"buttonRight";
    self.buttonRight.userInteractionEnabled = YES;
    self.buttonRight.delegate = self;
    [self addChild:self.buttonRight];
 
    
    self.buttonJump  = [SKAButtonSprite spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(50, 50)];
    CGPoint position = CGPointMake(scene.view.frame.size.width-self.buttonJump.size.width/2-padding, self.buttonJump.size.height/2+padding);
    self.buttonJump.position = position;
    self.buttonJump.name = @"buttonJump";
    self.buttonJump.userInteractionEnabled = YES;
    self.buttonJump.delegate = self;
    [self addChild:self.buttonJump];
    
    return self;
}

+(id)hudWithScene:(SKScene *)scene withPlayer:(SKATestPlayer *)player
{
    SKATestHud *testHud = [[SKATestHud alloc]initWithScene:scene withPlayer:player];
    
    return testHud;
}

#pragma mark - ButtonSpriteDelegate

-(void)buttonSpritePressed:(SKAButtonSprite *)buttonSprite
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

-(void)buttonSpriteDown:(SKAButtonSprite *)buttonSprite
{
    if(buttonSprite == self.buttonLeft)
    {
        self.player.playerState = PlayerStateMoveLeft;
    }
    
    if(buttonSprite == self.buttonRight)
    {
        self.player.playerState = PlayerStateMoveRight;
    }
    
    if(buttonSprite == self.buttonJump)
    {
        self.player.wantsToJump = YES;
    }

}

-(void)buttonSpriteUp:(SKAButtonSprite *)buttonSprite
{
    if(buttonSprite == self.buttonLeft && self.player.playerState == PlayerStateMoveLeft)
    {
        self.player.playerState = PlayerStateMoveIdel;
    }
    
    if(buttonSprite == self.buttonRight && self.player.playerState == PlayerStateMoveRight)
    {
        self.player.playerState = PlayerStateMoveIdel;
    }
    
}


@end
