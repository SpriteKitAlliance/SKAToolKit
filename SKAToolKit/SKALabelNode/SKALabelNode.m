//
//  SKALabelNode.m
//
//  Created by Max Kargin on 8/10/15.
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

#import "SKALabelNode.h"

@implementation SKALabelNode

/* initializers */

- (instancetype)init
{

    self = [super init];

    if(self != nil)
    {
        UIFont *defaultFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.fontName = defaultFont.fontName;
        self.fontColor = [SKColor blackColor];
        self.fontSize = defaultFont.pointSize;
        self.text = [NSString string];
        self.lineSpacing = 1;
        self.shadow = nil;
        self.textAlignmentMode = NSTextAlignmentCenter;
        [self setHorizontalAlignment:SKLabelHorizontalAlignmentModeCenter];
        [self setVerticalAlignnment:SKLabelVerticalAlignmentModeBaseline];
    }

    return self;
}

- (void)setVerticalAlignnment:(SKLabelVerticalAlignmentMode)verticalAlignmentMode
{
    _verticalAlignmentMode = verticalAlignmentMode;
    CGPoint labelAnchorPoint = self.anchorPoint;
    if(verticalAlignmentMode == SKLabelVerticalAlignmentModeBaseline)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 0);
    }
    else if(verticalAlignmentMode == SKLabelVerticalAlignmentModeCenter)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 0.5);
    }
    else if(verticalAlignmentMode == SKLabelVerticalAlignmentModeTop)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, 1);
    }
    else if(verticalAlignmentMode == SKLabelVerticalAlignmentModeBottom)
    {
        self.anchorPoint = CGPointMake(labelAnchorPoint.x, -0.2);
    }
}

- (void)setHorizontalAlignment:(SKLabelHorizontalAlignmentMode)horizontalAlignmentMode
{
    _horizontalAlignmentMode = horizontalAlignmentMode;
    CGPoint labelAnchorPoint = self.anchorPoint;
    if(horizontalAlignmentMode == SKLabelHorizontalAlignmentModeCenter)
    {
        self.anchorPoint = CGPointMake(0.5, labelAnchorPoint.y);
    }
    else if(horizontalAlignmentMode == SKLabelHorizontalAlignmentModeLeft)
    {
        self.anchorPoint = CGPointMake(0, labelAnchorPoint.y);
    }
    else if(horizontalAlignmentMode == SKLabelHorizontalAlignmentModeRight)
    {
        self.anchorPoint = CGPointMake(1, labelAnchorPoint.y);
    }
}

- (instancetype)initWithFontNamed:(NSString *)fontName
{

    self = [self init];

    if(self != nil)
    {
        self.fontName = fontName;
    }

    return self;
}

+ (instancetype)labelNodeWithText:(NSString *)text
{

    SKALabelNode *labelNode = [[SKALabelNode alloc] init];
    labelNode.text = text;

    return labelNode;
}

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName
{

    SKALabelNode *labelNode = [[SKALabelNode alloc] initWithFontNamed:fontName];

    return labelNode;
}

/* you must call drawLabel: before using it and before every time you change the label */

- (void)drawLabel
{

    // load text attributes
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];

    UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
    textAttributes[NSFontAttributeName] = font;

    textAttributes[NSForegroundColorAttributeName] = self.fontColor;

    if(self.shadow != nil)
    {
        textAttributes[NSShadowAttributeName] = self.shadow;
    }

    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignmentMode;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = self.lineSpacing;
    textAttributes[NSParagraphStyleAttributeName] = paragraphStyle;

    // getting the text rect
    CGRect textRect =
        [self.text boundingRectWithSize:CGSizeMake(self.scene.size.width,
                                            self.scene.size.height)
                                options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                             attributes:textAttributes
                                context:nil];
    textRect.size = CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
    self.size = textRect.size;

    NSAttributedString *labelString = [[NSAttributedString alloc] initWithString:self.text attributes:textAttributes];

    // create UIImage
    UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);
    [labelString drawInRect:textRect];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // update Sprite Node with textImage
    SKTexture *labelTexture = [SKTexture textureWithImage:textImage];
    self.texture = labelTexture;
}

@end