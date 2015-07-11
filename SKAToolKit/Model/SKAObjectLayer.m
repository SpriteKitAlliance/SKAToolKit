//
//  SKAObjectLayer.m
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "SKAObjectLayer.h"

@implementation SKAObjectLayer

- (NSArray *)objectsWithName:(NSString *)name
{
    NSPredicate *namePredicate = [NSPredicate
        predicateWithBlock:^BOOL(SKAObject *object, NSDictionary *bindings) {
          return [object.name isEqualToString:name];
        }];

    return [self.objects filteredArrayUsingPredicate:namePredicate];
}

@end