//
//  SKACircularProgressBar.h
//  CircularProgressNodeAlpha
//
//  Created by Violet on 9/29/15.
//  Copyright (c) 2015 Violetsoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^ProgressCompletionHandler)(void);

typedef void (^ProgressHandler)(CGFloat);

@interface SKAProgressNode : SKShapeNode

- (instancetype)initWithRadius:(CGFloat)radius
                      andWidth:(CGFloat)width
            andForegroundColor:(SKColor *)foregroundColor
            andBackgroundColor:(SKColor *)backgroundColor
          inClockwiseDirection:(BOOL)clockwise;

- (void)updateProgress:(CGFloat)progress;

- (CGFloat)getCurrentPercentage;

- (void)stopProgress;

- (void)setPercentageLabel:(SKLabelNode*)percentageLabel;

- (void)countdownWithDuration:(NSTimeInterval)duration;

- (void)countdownWithDuration:(NSTimeInterval)duration
         andCompletionHandler:(ProgressCompletionHandler)completionHandler;

- (void)countdownWithDuration:(NSTimeInterval)duration
           andProgressHandler:(ProgressHandler)progressHandler
         andCompletionHandler:(ProgressCompletionHandler)completionHandler;

@end
