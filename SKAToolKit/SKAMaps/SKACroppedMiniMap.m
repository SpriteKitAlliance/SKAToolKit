//
//  SKACroppedMiniMap.m
//  SKAToolKitExample
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

#import "SKACroppedMiniMap.h"

@interface SKACroppedMiniMap ()

@property (nonatomic, strong) SKAMiniMap *miniMap;
@property (nonatomic, strong) SKNode *map;

@end

@implementation SKACroppedMiniMap

- (id)initWithMap:(SKNode *)map
        withWidth:(NSInteger)width
  withCroppedSize:(CGSize)size
{
    SKAMiniMap *miniMap = [[SKAMiniMap alloc] initWithMap:map withWidth:width];

    miniMap.anchorPoint = CGPointMake(0, 0);

    SKCropNode *croppedNode = [[SKCropNode alloc] init];
    [croppedNode addChild:miniMap];

    SKSpriteNode *mask =
        [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                     size:size];
    croppedNode.maskNode = mask;

    self = [super initWithColor:[UIColor clearColor] size:size];
    self.miniMap = miniMap;
    [self addChild:croppedNode];

    return self;
}

- (void)update
{

    if(self.autoFollowNode && self.miniMap)
    {
        self.miniMap.position = CGPointMake(
            -self.autoFollowNode.position.x + self.scene.size.width / 2,
            -self.autoFollowNode.position.y + self.scene.size.height / 2);

        // scaling down
        self.miniMap.position = CGPointMake(self.miniMap.position.x * self.miniMap.scaledTo,
            self.miniMap.position.y * self.miniMap.scaledTo);

        /*
         * Check position of the minimap and stop it from going off screen
         */

        CGPoint position = self.miniMap.position;

        if(position.x > 0)
        {
            position.x = 0;
        }

        if(position.y > 0)
        {
            position.y = 0;
        }

        if(position.y < -self.miniMap.size.height + self.size.height)
        {
            position.y = -self.miniMap.size.height + self.size.height;
        }

        if(position.x < -self.miniMap.size.width + self.size.width)
        {
            position.x = -self.miniMap.size.width + self.size.width;
        }

        self.miniMap.position = CGPointMake((int)(position.x - self.size.width / 2),
            (int)(position.y - self.size.height / 2));
    }
}

@end
