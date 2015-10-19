//
//  SKATestPlayer.m
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

#import "SKATestPlayer.h"
#import "SKACollisionDefine.h"

@interface SKATestPlayer ()

@property (nonatomic, strong) SKAction *playerAnimation;

@property (nonatomic) NSInteger currentState;

@end

@implementation SKATestPlayer

- (instancetype)initWithTexture:(SKTexture *)texture
{
    self = [super initWithTexture:texture];

    [self loadAssets];

    return self;
}

- (instancetype)initWithColor:(UIColor *)color size:(CGSize)size
{
    self = [super initWithColor:color size:size];

    [self loadAssets];

    return self;
}

- (instancetype)init
{
    self = [super init];

    [self loadAssets];

    return self;
}

- (void)loadAssets
{
    self.position = CGPointMake(300, 350);
    self.physicsBody =
        [SKPhysicsBody bodyWithCircleOfRadius:15
                                       center:CGPointMake(0, -40)];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.friction = 0.2;
    self.physicsBody.mass = 100;
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.categoryBitMask = SKACategoryPlayer;
    self.physicsBody.collisionBitMask = SKACategoryFloor | SKACategoryWall;
    self.physicsBody.contactTestBitMask = SKACategoryFloor | SKACategoryWall;
}

- (void)update
{
    // determine player states:
    switch(self.playerState)
    {
    case PlayerStateMoveRight:
        [self runRight];
        break;
    case PlayerStateMoveLeft:
        [self runLeft];
        break;
    case PlayerStateMoveIdel:
        break;
    default:
        break;
    }

    if(self.wantsToJump && self.physicsBody.velocity.dy == 0)
    {
        [self jump];
    }

}

- (void)runLeft
{
    if(!self.physicsBody.velocity.dy)
    {
        self.physicsBody.velocity = CGVectorMake(-170, self.physicsBody.velocity.dy);
    }
}

- (void)runRight
{
    if(!self.physicsBody.velocity.dy)
    {
        self.physicsBody.velocity = CGVectorMake(170, self.physicsBody.velocity.dy);
    }
}

- (void)jump
{
    self.wantsToJump = NO;

    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 800);
}

@end