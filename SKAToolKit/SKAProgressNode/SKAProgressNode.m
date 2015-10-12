//
//  SKACircularProgressBar.m
//  CircularProgressNodeAlpha
//
//  Created by Violet on 9/29/15.
//  Copyright (c) 2015 Violetsoft. All rights reserved.
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

#import "SKAProgressNode.h"

NSString *const kProgressCountdownAction = @"progressCountdownAction";

/** Degrees to Radians **/
#define degreesToRadians(degrees) ((degrees) / 180.0f * M_PI)

/** Radians to Degrees **/
#define radiansToDegrees(radians) ((radians) * (180.0f / M_PI))

@interface SKAProgressNode ()

@property(nonatomic, assign) CGFloat radius;

@property(nonatomic, strong) SKColor *foregroundColor;

@property(nonatomic, assign) CGFloat progress;

@property(nonatomic, assign) BOOL clockwise;

@property(nonatomic, strong) SKShapeNode *progressInidicatorNode;

@property(nonatomic, strong) SKLabelNode *percentageLabel;

@end

@implementation SKAProgressNode

- (instancetype)initWithRadius:(CGFloat)radius
                      andWidth:(CGFloat)width
            andForegroundColor:(SKColor *)foregroundColor
            andBackgroundColor:(SKColor *)backgroundColor
          inClockwiseDirection:(BOOL)clockwise {
    
    if (self = [super init]) {
        
        self.path = CGPathCreateWithEllipseInRect(
                                                  CGRectMake(-radius, -radius, radius * 2.0f, radius * 2.0f), NULL);
        
        self.name = @"progressBackgroundNode";
        
        self.fillColor = [SKColor clearColor];
        
        self.strokeColor = backgroundColor;
        
        self.lineWidth = width;
        
        // Initializing parameters required for progressIndicatorNode creation.
        
        _radius = radius;
        
        _foregroundColor = foregroundColor;
        
        _clockwise = clockwise;
        
        _progress = 0.0f;
        
        // Creating progress indicator node.
        
        _progressInidicatorNode = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
        
        _progressInidicatorNode.fillColor = [SKColor clearColor];
        
        _progressInidicatorNode.lineWidth = width;
        
        _progressInidicatorNode.strokeColor = foregroundColor;
        
        _progressInidicatorNode.name = @"progressIndicatorNode";
        
        _progressInidicatorNode.zPosition = 2;
        
        self.zPosition = _progressInidicatorNode.zPosition - 1;
        
        [self addChild:_progressInidicatorNode];
    }
    
    return self;
}


- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    CGFloat startAngle = 0.0f;
    
    CGFloat endAngle = 0.0f;
    
    if (self.clockwise) {
        
        endAngle = M_PI / 2.0f;
        
        startAngle = endAngle - (progress * 2.0f * M_PI);
        
    } else {
        
        startAngle = M_PI / 2.0f;
        
        endAngle = startAngle + (progress * 2.0f * M_PI);
    }
    
    if (self.percentageLabel) {
        
        self.percentageLabel.text = [NSString
                                     stringWithFormat:@"%ld%%", (NSInteger)self.getCurrentPercentage];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointZero
                                                        radius:self.radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    
    self.progressInidicatorNode.path = path.CGPath;
}

#pragma mark - Public methods

-(void)setPercentageLabel:(SKLabelNode *)percentageLabel{
    
    if([_percentageLabel parent])[_percentageLabel removeFromParent];
    
    [self addChild:percentageLabel];
    
    _percentageLabel = percentageLabel;
    _percentageLabel.text = [NSString
                             stringWithFormat:@"%ld%%", (NSInteger)self.getCurrentPercentage];
    
}

- (CGFloat)getCurrentPercentage {
    
    return _progress * 100.0f;
}

- (void)stopProgress {
    
    if ([self actionForKey:kProgressCountdownAction]) {
        
        [self removeActionForKey:kProgressCountdownAction];
    }
}

// You can call this to manually set the progress.
- (void)updateProgress:(CGFloat)progress {
    
    [self setProgress:progress];
}

// Countdown without completion handler.
- (void)countdownWithDuration:(NSTimeInterval)duration {
    
    [self countdownWithDuration:duration andCompletionHandler:nil];
}

// Countdown with completion handler.
- (void)countdownWithDuration:(NSTimeInterval)duration
         andCompletionHandler:(ProgressCompletionHandler)completionHandler {
    
    [self countdownWithDuration:duration
             andProgressHandler:nil
           andCompletionHandler:completionHandler];
}

// Countdown with completion and progress handler.
- (void)countdownWithDuration:(NSTimeInterval)duration
           andProgressHandler:(ProgressHandler)progressHandler
         andCompletionHandler:(ProgressCompletionHandler)completionHandler {
    
    SKAction *countdown =
    [SKAction customActionWithDuration:(duration)
                           actionBlock:^(SKNode *node, CGFloat elapsedTime) {
                               
                               self.progress = elapsedTime / duration;
                               
                               if (progressHandler) {
                                   
                                   progressHandler(_progress);
                               }
                               
                               if (self.progress >= 1.0) {
                                   
                                   [self stopProgress];
                                   
                                   if (!completionHandler) {
                                       return;
                                   }
                                   
                                   completionHandler();
                               }
                               
                           }];
    
    if ([self actionForKey:kProgressCountdownAction]) {
        
        [self removeActionForKey:kProgressCountdownAction];
    }
    
    [self runAction:countdown withKey:kProgressCountdownAction];
}

@end
