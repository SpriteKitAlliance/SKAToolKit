//
//  SKALabelNode.m
//
//  Created by Max Kargin on 8/10/15.
//  Copyright (c) 2015 Max Kargin. All rights reserved.
//
//  Created for Sprite Kit Alliance and distributed under SKA guidelines
//

#import "SKALabelNode.h"

@implementation SKALabelNode

/* initializers */

- (instancetype)init {

  self = [super init];

  if (self != nil) {
    self.fontName = @"Arial";
    self.fontColor = [UIColor blackColor];
    self.fontSize = 24;
    self.text = @"";
  }

  return self;
}

- (instancetype)initWithFontNamed:(NSString *)fontName {

  self = [self init];

  if (self != nil) {
    self.fontName = fontName;
  }

  return self;
}

+ (instancetype)labelNodeWithText:(NSString *)text {

  SKALabelNode *labelNode = [[SKALabelNode alloc] init];
  labelNode.text = text;

  return labelNode;
}

+ (instancetype)labelNodeWithFontNamed:(NSString *)fontName {

  SKALabelNode *labelNode = [[SKALabelNode alloc] initWithFontNamed:fontName];

  return labelNode;
}

/* you must call drawLabel: before using it and before every time you change the label */

- (void)drawLabel {

  // load text attributes
  NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];

  UIFont *font = [UIFont fontWithName:self.fontName size:self.fontSize];
  [textAttributes setObject:font forKey:NSFontAttributeName];

  [textAttributes setObject:self.fontColor
                     forKey:NSForegroundColorAttributeName];

  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
  paragraphStyle.lineSpacing = 1;
  [textAttributes setObject:paragraphStyle
                     forKey:NSParagraphStyleAttributeName];

  // getting the text rect
  CGRect textRect =
      [self.text boundingRectWithSize:CGSizeMake(self.scene.size.width,
                                                 self.scene.size.height)
                              options:NSStringDrawingTruncatesLastVisibleLine |
                                      NSStringDrawingUsesLineFragmentOrigin
                           attributes:textAttributes
                              context:nil];
  textRect.size = CGSizeMake(textRect.size.width + 5, textRect.size.height + 5);
  self.size = textRect.size;

  // create UIImage
  UIGraphicsBeginImageContextWithOptions(textRect.size, NO, 0);
  [self.text drawInRect:textRect withAttributes:textAttributes];
  UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  // update Sprite Node with textImage
  SKTexture *labelTexture = [SKTexture textureWithImage:textImage];
  self.texture = labelTexture;
}

@end
