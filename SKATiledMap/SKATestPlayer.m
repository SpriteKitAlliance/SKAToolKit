//
//  SKATestPlayer.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/23/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKATestPlayer.h"
#import "CollisionDefine.h"


@interface SKATestPlayer ()

@property (nonatomic, strong)SKAction *playerAnimation;

@property (nonatomic)NSInteger currentState;

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

-(instancetype)init{
    self = [super init];

    [self loadAssets];
    
    return self;
}

-(void)loadAssets {
    
    self.position = CGPointMake(300, 350);
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15 center:CGPointMake(0, -40)];
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = 0;
    self.physicsBody.friction = 0.2;
    self.physicsBody.mass = 100;
    self.physicsBody.affectedByGravity = YES;
    self.physicsBody.categoryBitMask = SKACategoryPlayer;
    self.physicsBody.collisionBitMask = SKACategoryFloor | SKACategoryWall;
    self.physicsBody.contactTestBitMask = SKACategoryFloor | SKACategoryWall;
}

-(void)update
{
    // determine player states:
    
    switch (self.playerState)
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
    
    if (self.wantsToJump && self.physicsBody.velocity.dy == 0)
    {
        [self jump];
    }
    
    self.wantsToJump = NO;
    

}

-(void)runLeft
{
    if (!self.physicsBody.velocity.dy)
    {
        self.physicsBody.velocity = CGVectorMake(-170, self.physicsBody.velocity.dy);
    }
}

-(void)runRight
{
    if (!self.physicsBody.velocity.dy)
    {
        self.physicsBody.velocity = CGVectorMake(170, self.physicsBody.velocity.dy);
    }
}

-(void)jump
{
    self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 800);
}

@end
