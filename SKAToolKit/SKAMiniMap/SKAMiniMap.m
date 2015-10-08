//
//  SKAMiniMap.m
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

#import "SKAMiniMap.h"

@interface SKAMiniMap ()

@property (nonatomic, readwrite) float scaledTo;

@end

@implementation SKAMiniMap

- (id)initWithMap:(SKNode *)map withWidth:(NSInteger)width
{
    if(!map.scene.view)
    {
        NSLog(@"map must be added to a scene to create a minimap");
        return nil;
    }

    SKTexture *texture = [map.scene.view textureFromNode:map];
    
    if(texture.size.width > 2048 || texture.size.height > 2048)
    {
        NSLog(@"WARNING map max size is {2048, 2048} for mini map yours is: %@", NSStringFromCGSize(texture.size));
    }

    float scaledTo = (float)width / map.calculateAccumulatedFrame.size.width;

    NSInteger height = (scaledTo * (float)map.calculateAccumulatedFrame.size.height);

    SKSpriteNode *miniMap =
        [SKSpriteNode spriteNodeWithTexture:texture
                                       size:CGSizeMake(width, height)];

    [map addChild:miniMap];

    texture = [map.scene.view textureFromNode:miniMap];

    
    [miniMap removeFromParent];

    self = [super initWithTexture:texture];

    self.scaledTo = scaledTo;

    return self;
}

@end