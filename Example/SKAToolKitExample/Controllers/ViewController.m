//
//  ViewController.m
//  SKATMXParser
//
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
//

#import "ViewController.h"
#import "GameScene.h"

@implementation ViewController

- (void)loadView
{
    CGRect applicaitonFrame = [UIScreen mainScreen].applicationFrame;
    SKView *skView = [[SKView alloc] initWithFrame:applicaitonFrame];
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;

    skView.ignoresSiblingOrder = YES;
    skView.showsFPS = YES;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;

    // Create and configure the scene.
    GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];

    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];

    // Do any additional setup after loading the view, typically from a nib.
}

@end
