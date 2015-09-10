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
  var disableButton: SKAButtonSprite!
  var danceAction: SKAction?
  let atlas = SKTextureAtlas(named: "Textures")

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    disableButton = SKAButtonSprite(color: UIColor.redColor(), size: CGSize(width: 260, height: 44))
    disableButton.setTexture(self.atlas.textureNamed("disable"), forState: .Normal)
    disableButton.setTexture(self.atlas.textureNamed("enabled"), forState: .Selected)
    disableButton.position = CGPoint(x: view.center.x, y: UIScreen.mainScreen().bounds.height - 100)
    disableButton.addTarget(self, selector: "disableSKA:", forControlEvents: .TouchUpInside)
    disableButton.setButtonTargetSize(CGSize(width: 300, height: 60))

    addChild(disableButton)
    
    //Dance Action
    let textures = [self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance2"), self.atlas.textureNamed("ska-dance1"), self.atlas.textureNamed("ska-dance3")]

    let dance = SKAction.animateWithTextures(textures, timePerFrame: 0.12, resize: true, restore: true)
    danceAction = SKAction.repeatActionForever(dance)
    //SKA Button
    button = SKAButtonSprite(color: UIColor.greenColor(), size: CGSize(width: 126, height: 112))
    addChild(button!)
    
    button?.addTarget(self, selector: "touchUpInside:", forControlEvents: .TouchUpInside)
    button?.addTarget(self, selector: "touchUpOutside:", forControlEvents: .TouchUpOutside)
    button?.addTarget(self, selector: "dragOutside:", forControlEvents: .DragOutside)
    button?.addTarget(self, selector: "dragInside:", forControlEvents: .DragInside)
    button?.addTarget(self, selector: "dragEnter:", forControlEvents: .DragEnter)
    button?.addTarget(self, selector: "dragExit:", forControlEvents: .DragExit)
    button?.addTarget(self, selector: "touchDown:", forControlEvents: .TouchDown)
    
    button?.setTexture(self.atlas.textureNamed("ska-stand"), forState: .Normal)
    button?.setTexture(self.atlas.textureNamed("ska-pressed"), forState: .Highlighted)
    button?.setTexture(self.atlas.textureNamed("ska-disabled"), forState: .Disabled)
    button?.position = CGPoint(x: view.center.x, y: 200)
  }
  
  func touchUpInside(sender:AnyObject) {
    print("SKABUTTON: touchUpInside")
    guard let button = button else { return }
    
    if button.selected {
      button.selected = false
      button.removeActionForKey("dance")
    } else {
      button.selected = true
      guard let dance = danceAction else { return }
      button.runAction(dance, withKey: "dance")
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
    
    guard let button = button else { return }
    button.removeActionForKey("dance")
  }
  
  func dragEnter(sender:AnyObject) {
    print("SKABUTTON: dragEnter")
    
    guard let button = button else { return }
    button.removeActionForKey("dance")
  }
  
  func dragExit(sender:AnyObject) {
    print("SKABUTTON: dragExit")
    
    guard let button = button else { return }
    
    if button.selected ?? false {
      button.selected = true
    
      guard let dance = danceAction else { return }
      button.runAction(dance, withKey: "dance")
    }
  }
  
  func touchDown(sender:AnyObject) {
    print("SKABUTTON: touchDown")
    
    guard let button = button else { return }
    button.removeActionForKey("dance")
  }
  
  func disableSKA(sender:AnyObject) {
    guard let button = button else { return }
    button.enabled = !button.enabled
    disableButton.selected = !button.enabled
  }
}