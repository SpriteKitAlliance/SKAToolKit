//
//  SKALabelNode.h
//
//  Created by Max Kargin on 8/10/15.
//  Copyright (c) 2015 Max Kargin. All rights reserved.
//
//  Created for Sprite Kit Alliance and distributed under SKA guidelines
//

#import <SpriteKit/SpriteKit.h>

@interface SKALabelNode : SKSpriteNode

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName;
+ (instancetype)labelNodeWithText:(NSString *)text;
- (instancetype)initWithFontNamed:(NSString *)fontName;

- (void)drawLabel;

@property(nonatomic, copy) NSString *text;
@property(nonatomic, retain) SKColor *fontColor;
@property(nonatomic, copy) NSString *fontName;
@property(nonatomic) CGFloat fontSize;

@end
