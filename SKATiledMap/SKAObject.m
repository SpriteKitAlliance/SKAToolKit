//
//  SKAObject.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/4/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKAObject.h"

@implementation SKAObject

-(float)centerX
{
    return self.x+self.width/2;
}

-(float)centerY
{
    return self.y+self.height/2;
}

@end
