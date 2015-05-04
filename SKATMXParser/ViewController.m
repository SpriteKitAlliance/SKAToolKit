//
//  ViewController.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"

@interface ViewController ()

@end

@implementation ViewController

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
    //SKScene * scene = [MyScene sceneWithSize:CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width)];
    GameScene * scene = [GameScene sceneWithSize:self.view.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
