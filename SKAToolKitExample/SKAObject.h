//
//  SKAObject.h
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/4/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKAObject : NSObject

@property (nonatomic)NSInteger height;
@property (nonatomic)NSInteger width;
@property (nonatomic)NSInteger x;
@property (nonatomic)NSInteger y;

@property (nonatomic)NSInteger objectID;
@property (nonatomic, strong)NSString *name;
@property (nonatomic)NSInteger roation;
@property (nonatomic,strong)NSString *type;

@property (nonatomic)BOOL visible;

@property (nonatomic, strong)NSDictionary *properties;

-(float)centerX;
-(float)centerY;

@end
