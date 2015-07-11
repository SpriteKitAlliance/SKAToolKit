//
//  ViewController.m
//  SKATMXParser
//
//  TODO: Insert proper license copy
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"

@implementation ViewController

- (void)loadView {
  CGRect applicaitonFrame = [UIScreen mainScreen].applicationFrame;
  SKView *skView = [[SKView alloc] initWithFrame:applicaitonFrame];
  self.view = skView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
  
    skView.ignoresSiblingOrder = YES;
    skView.showsFPS = YES;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    
    // Create and configure the scene.
    GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];

    // Do any additional setup after loading the view, typically from a nib.
}

@end
