//
//  ButtonGameScene.swift
//  SKAToolKit
//
//  Created by Marc Vandehey on 9/1/15.
//  Copyright © 2015 SpriteKit Alliance. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonGameScene: SKScene {
  var button: SKAButtonSprite?
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    button = SKAButtonSprite(color: UIColor.blueColor(), size: CGSize(width: 100, height: 100))
    addChild(button!)
    
    button?.addTarget(self, selector: "touchUpInside:", forControlEvents: .TouchUpInside)
    button?.addTarget(self, selector: "touchUpOutside:", forControlEvents: .TouchUpOutside)
    button?.addTarget(self, selector: "dragOutside:", forControlEvents: .DragOutside)
    button?.addTarget(self, selector: "dragInside:", forControlEvents: .DragInside)
    button?.addTarget(self, selector: "dragEnter:", forControlEvents: .DragEnter)
    button?.addTarget(self, selector: "dragExit:", forControlEvents: .DragExit)
    button?.addTarget(self, selector: "touchDown:", forControlEvents: .TouchDown)

    button?.position = CGPoint(x: 100, y: 100)
    
    button?.anchorPoint = CGPoint(x: 0, y: 0)
  }
  
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)
    
  }
  
  func touchUpInside(sender:AnyObject) {
    print("SKABUTTON: touchUpInside")
  }
  
  func touchUpOutside(sender:AnyObject) {
    print("SKABUTTON: touchUpOutside")

  }
  
  func dragOutside(sender:AnyObject) {
    print("SKABUTTON: dragOutside")

  }
  
  func dragInside(sender:AnyObject) {
    print("SKABUTTON: dragInside")

  }
  
  func dragEnter(sender:AnyObject) {
    print("SKABUTTON: dragEnter")

  }
  
  func dragExit(sender:AnyObject) {
    print("SKABUTTON: dragExit")

  }
  
  func touchDown(sender:AnyObject) {
    print("SKABUTTON: touchDown")

  }
}