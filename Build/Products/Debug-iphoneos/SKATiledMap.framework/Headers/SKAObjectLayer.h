//
//  SKAObjectLayer.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/4/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAObject.h"

@interface SKAObjectLayer : NSObject

//returns an array of SKAObjects
@property (nonatomic, strong)NSArray *objects;

@property (nonatomic)NSInteger height;
@property (nonatomic)NSInteger width;

@property (nonatomic)float opacity;
@property (nonatomic, strong)NSString *type;
@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger y;
@property (nonatomic)BOOL visible;

@property (nonatomic, strong)NSString *drawOrder;
@property (nonatomic, strong)NSString *name;

@property (nonatomic, strong)NSArray *collisionSprites;

@end
