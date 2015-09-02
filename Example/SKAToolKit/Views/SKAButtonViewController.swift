//
//  SKAButtonViewController.swift
//  SKAToolKit
//
//  Created by Marc Vandehey on 9/1/15.
//  Copyright © 2015 SpriteKit Alliance. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class SKAButtonViewController : UIViewController {
  
  override func loadView() {
    super.loadView()
    
    let appFrame = UIScreen.mainScreen().bounds
    let skView = SKView(frame: appFrame)
    self.view = skView
  }
  
  override func viewDidLoad() {
    let skView = self.view as! SKView
    
    skView.showsFPS = true
    skView.showsDrawCount = true
    skView.showsNodeCount = true
    skView.showsPhysics = true
    
    let gameScene = ButtonGameScene()
    gameScene.size = skView.bounds.size
    gameScene.scaleMode = .AspectFill
    
    skView.presentScene(gameScene)
  }
}