//
//  GameScene.m
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

#import "GameScene.h"

#import "SKAToolKit.h"
#import "SKATest.h"

@interface GameScene ()

@property (nonatomic, strong) SKATestPlayer *player;
@property (nonatomic, strong) SKATiledMap *map;
@property (nonatomic, strong) SKACroppedMiniMap *croppedMiniMap;

@property (nonatomic, strong) SKAProgressNode *progressNode;
@property (nonatomic) CGFloat progress;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    //creating a map...yes it is that easy
    self.map = [[SKATiledMap alloc] initWithMapName:@"SampleMapKenny"];

    [self addChild:self.map];

    //showing off how easy it is to add actions to layers or a specific tile
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:2];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:2];

    SKAction *repeat = [SKAction
        repeatActionForever:[SKAction sequence:@[ fadeOut, fadeIn ]]];

    SKASpriteLayer *layer = self.map.spriteLayers[0];

    [layer runAction:repeat];

    SKAction *rotate = [SKAction rotateByAngle:2 duration:1];
    SKAction *repeatRotation = [SKAction repeatActionForever:rotate];

    SKASprite *sprite = [self.map spriteOnLayer:2 indexX:5 indexY:4];

    [sprite runAction:repeatRotation];

    //adding testing nodes
    self.player = [SKATestPlayer spriteNodeWithColor:[SKColor greenColor]
                                                size:CGSizeMake(40, 80)];
    self.player.zPosition = 20;
    self.player.position = CGPointMake(400, 400);

    self.map.autoFollowNode = self.player;

    SKATestHud *testHud =
        [SKATestHud hudWithScene:self.scene
                      withPlayer:self.player];

    //adding mini map
    NSInteger padding = 10;
    
    self.croppedMiniMap =
        [[SKACroppedMiniMap alloc] initWithMap:self.map
                                     withWidth:225
                               withCroppedSize:CGSizeMake(100, 50)];
    self.croppedMiniMap.position = CGPointMake(
        self.size.width - self.croppedMiniMap.size.width / 2 - padding,
        self.size.height - self.croppedMiniMap.size.height / 2 - padding);
    self.croppedMiniMap.autoFollowNode = self.player;

    [testHud addChild:self.croppedMiniMap];

    [self addChild:testHud];
    [self.map addChild:self.player];

    SKALabelNode *labelNode = [[SKALabelNode alloc] init];
    labelNode.text = @"This is an\nexample of a\nmultiline\nSKALabelNode";
    labelNode.position = CGPointMake(100, self.size.height - 150);
    labelNode.fontSize = 20;
    [testHud addChild:labelNode];
    [labelNode drawLabel];
    
    //SKAProgressNode Example
    self.progressNode = [[SKAProgressNode alloc]initWithRadius:14 andLineWidth:10 andForegroundColor:[SKColor blueColor] andBackgroundColor:[SKColor redColor] inClockwiseDirection:YES];
    self.progressNode.position = CGPointMake(self.scene.size.width/2, 50);
    [testHud addChild:self.progressNode];
    
    SKLabelNode *percentLabel = [[SKLabelNode alloc]init];
    percentLabel.fontSize = 20;
    percentLabel.fontColor = [SKColor blackColor];
    percentLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    percentLabel.position = CGPointMake(0, -40);
    [self.progressNode setPercentageLabel:percentLabel];
    
}

- (void)update:(NSTimeInterval)currentTime
{

    //player movement
    [self.player update];

    //cropping feature update
    CGPoint playerIndex = [self.map indexForPoint:self.player.position];
    [self.map cullAroundIndexX:playerIndex.x
                        indexY:playerIndex.y
                   columnWidth:14
                     rowHeight:7];

    //auto follow updates
    [self.map update];
    [self.croppedMiniMap update];
    
    //progress node updates
    self.progress += .01;
    self.progress = self.progress > 1 ? 0.0 : self.progress;
    [self.progressNode updateProgress:self.progress];
}

@end
