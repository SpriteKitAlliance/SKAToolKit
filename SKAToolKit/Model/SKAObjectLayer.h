//
//  SKAObjectLayer.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAObject.h"

@interface SKAObjectLayer : NSObject

// TODO these can be a struct {{x: NSInteger, y: NSInteger}, {width: NSInteger,
// height: NSInteger}}
@property(nonatomic) NSInteger x;
@property(nonatomic) NSInteger y;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger width;

@property(nonatomic) float opacity;
@property(nonatomic) BOOL visible;

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *drawOrder;
@property(nonatomic, strong) NSString *name;

/**
 returns an array of SKAObjects
 */
@property(nonatomic, strong) NSArray *objects;
@property(nonatomic, strong) NSArray *collisionSprites;

- (NSArray *)objectsWithName:(NSString *)name;

@end