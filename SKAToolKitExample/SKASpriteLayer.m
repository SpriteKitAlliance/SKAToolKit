//
//  SKASpriteLayer.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/4/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKASpriteLayer.h"

@implementation SKASpriteLayer

-(SKASprite *)spriteForIndexX:(NSInteger)x indexY:(NSInteger)y
{
    SKASprite *sprite = self.sprites[x][y];
    
    if ([sprite isKindOfClass:[SKASprite class]])
    {
        return sprite;
    }
    else
    {
        return nil;
    }
}

@end
