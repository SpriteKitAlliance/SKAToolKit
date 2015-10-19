//
//  SKACircularProgressBar.h
//  CircularProgressNodeAlpha
//
//  Created by Violet on 9/29/15.
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

#import <SpriteKit/SpriteKit.h>

typedef void (^ProgressCompletionHandler)(void);

typedef void (^ProgressHandler)(CGFloat);

@interface SKAProgressNode : SKShapeNode

- (instancetype)initWithRadius:(CGFloat)radius
                  andLineWidth:(CGFloat)width
            andForegroundColor:(SKColor *)foregroundColor
            andBackgroundColor:(SKColor *)backgroundColor
          inClockwiseDirection:(BOOL)clockwise;

- (void)updateProgress:(CGFloat)progress;

- (CGFloat)getCurrentPercentage;

- (void)stopProgress;

// You can call this to manually set the progress.
- (void)setPercentageLabel:(SKLabelNode*)percentageLabel;

// Countdown without completion handler.
- (void)countdownWithDuration:(NSTimeInterval)duration;

// Countdown with completion handler.
- (void)countdownWithDuration:(NSTimeInterval)duration
         andCompletionHandler:(ProgressCompletionHandler)completionHandler;

// Countdown with completion and progress handler.
- (void)countdownWithDuration:(NSTimeInterval)duration
           andProgressHandler:(ProgressHandler)progressHandler
         andCompletionHandler:(ProgressCompletionHandler)completionHandler;

@end
