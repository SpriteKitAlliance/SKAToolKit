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
  var danceAction: SKAction?
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    let disableButton = SKAButtonSprite(color: UIColor.redColor(), size: CGSize(width: 50, height: 50))
    disableButton.position = CGPoint(x: view.center.x, y: UIScreen.mainScreen().bounds.height - 60)
    disableButton.addTarget(self, selector: "disableSKA:", forControlEvents: .TouchUpInside)
    addChild(disableButton)
    
    //Dance Action
    let textures = [SKTexture(imageNamed: "ska-dance1"), SKTexture(imageNamed: "ska-dance2"), SKTexture(imageNamed: "ska-dance1"), SKTexture(imageNamed: "ska-dance3")]
    let dance = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
    danceAction = SKAction.repeatActionForever(dance)
    
    
    //SKA Button
    button = SKAButtonSprite(color: UIColor.blueColor(), size: CGSize(width: 100, height: 100))
    addChild(button!)
    
    button?.addTarget(self, selector: "touchUpInside:", forControlEvents: .TouchUpInside)
    button?.addTarget(self, selector: "touchUpOutside:", forControlEvents: .TouchUpOutside)
    button?.addTarget(self, selector: "dragOutside:", forControlEvents: .DragOutside)
    button?.addTarget(self, selector: "dragInside:", forControlEvents: .DragInside)
    button?.addTarget(self, selector: "dragEnter:", forControlEvents: .DragEnter)
    button?.addTarget(self, selector: "dragExit:", forControlEvents: .DragExit)
    button?.addTarget(self, selector: "touchDown:", forControlEvents: .TouchDown)
    
    button?.setTexture(SKTexture(imageNamed: "ska-dance0"), forState: .Normal)
    button?.setTexture(SKTexture(imageNamed: "ska-pressed"), forState: .Highlighted)
    button?.setTexture(SKTexture(imageNamed: "ska-disabled"), forState: .Disabled)
    button?.position = CGPoint(x: view.center.x, y: 100)
  }
  
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)
    
  }
  
  func touchUpInside(sender:AnyObject) {
    print("SKABUTTON: touchUpInside")
    if button != nil {
      
      if button!.selected {
        button!.selected = false
        button!.removeActionForKey("dance")
      } else {
        button!.selected = true
        guard let dance = danceAction else { return }
        button!.runAction(dance, withKey: "dance")
      }
    }
  }
  
  func touchUpOutside(sender:AnyObject) {
    print("SKABUTTON: touchUpOutside")
  }
  
  func dragOutside(sender:AnyObject) {
    print("SKABUTTON: dragOutside")
  }
  
  func dragInside(sender:AnyObject) {
    print("SKABUTTON: dragInside")
    
    if button != nil {
      button!.removeActionForKey("dance")
    }
  }
  
  func dragEnter(sender:AnyObject) {
    print("SKABUTTON: dragEnter")
    
    if button != nil {
      button!.removeActionForKey("dance")
    }
  }
  
  func dragExit(sender:AnyObject) {
    print("SKABUTTON: dragExit")
    
    if button?.selected ?? false {
      button?.selected = true
      guard let dance = danceAction else { return }
      button!.runAction(dance, withKey: "dance")
    }
  }
  
  func touchDown(sender:AnyObject) {
    print("SKABUTTON: touchDown")
    
    if button != nil {
      button!.removeActionForKey("dance")
    }
  }
  
  func disableSKA(sender:AnyObject) {
    guard let button = button else { return }
    
    button.enabled = !button.enabled
  }
}