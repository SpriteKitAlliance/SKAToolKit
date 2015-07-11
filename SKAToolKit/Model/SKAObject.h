//
//  SKAObject.h
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKAObject : NSObject

//TODO: these can be a struct {{x: NSInteger, y: NSInteger}, {width: NSInteger, height: NSInteger}}
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger width;

@property (nonatomic) NSInteger objectID;
@property (nonatomic) NSInteger roation;

@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *type;

@property (nonatomic)BOOL visible;

@property (nonatomic, strong) NSDictionary *properties;

//TODO: This should return a CGPoint and be one function
- (float)centerX;
- (float)centerY;

@end