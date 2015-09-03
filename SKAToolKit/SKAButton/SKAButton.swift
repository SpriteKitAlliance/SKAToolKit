//
//  SKAButton.swift
//  SKAToolKit
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

import Foundation
import SpriteKit

struct SKAControlEvent: OptionSetType, Hashable {
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }
  
  static var None:           SKAControlEvent   { return SKAControlEvent(rawValue: 0) }
  static var TouchDown:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 0) }
  static var TouchUpInside:  SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 1) }
  static var TouchUpOutside: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 2) }
  static var DragOutside:    SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 3) }
  static var DragInside:     SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 4) }
  static var DragEnter:      SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 5) }
  static var DragExit:       SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 6) }
  static var TouchCancelled: SKAControlEvent   { return SKAControlEvent(rawValue: 1 << 7) }
  static var AllOptions:     [SKAControlEvent] {
    return [.None, .TouchDown, .TouchUpInside, .TouchUpOutside, .DragOutside, .DragInside, .DragEnter, .DragEnter, .TouchCancelled]
  }
  var hashValue: Int {
    return rawValue.hashValue
  }
}

struct SKAControlState: OptionSetType, Hashable {
  let rawValue: Int
  let key: String
  init(rawValue: Int) {
    self.rawValue = rawValue
    self.key = "\(rawValue)"
  }
  
  static var Normal:       SKAControlState { return SKAControlState(rawValue: 0 << 0) }
  static var Highlighted:  SKAControlState { return SKAControlState(rawValue: 1 << 0) }
  static var Selected:     SKAControlState { return SKAControlState(rawValue: 1 << 1) }
  static var Disabled:     SKAControlState { return SKAControlState(rawValue: 1 << 2) }
  static var AllOptions: [SKAControlState] {
    return [.Normal, .Highlighted, .Selected, .Disabled]
  }
  var hashValue: Int {
    return rawValue.hashValue
  }
}

struct SKAButtonSelector {
  let target: AnyObject
  let selector: Selector
}

class SKAButtonSprite : SKSpriteNode {
  private var selectors = [SKAControlEvent: [SKAButtonSelector]]()
  private var textures = [SKAControlState: SKTexture]()
  private var normalTextures = [SKAControlState: SKTexture]()
  private var colors = [SKAControlState: SKColor]()
  
  var tintColor = SKColor.darkGrayColor()
  
//  override var color: SKColor {
//    set(newColor){
//      setColor(newColor, forState: .Normal)
//    }
//    get{
//      return backgroundColor
//    }
//  }
//  
//  override var texture: SKTexture? {
//    set(newTexture){
//      setTexture(newTexture, forState: .Normal)
//    }
//    get {
//      return textures[.Normal]
//    }
//  }
//  
//  override var normalTexture: SKTexture? {
//    set(newTexture){
//      setNormalTexture(newTexture, forState: .Normal)
//    }
//    get {
//      return normalTextures[.Normal]
//    }
//  }
  
  private var backgroundColor = SKColor.clearColor()
  
  var selected = false {
    didSet {
      if selected {
        controlState.insert(.Selected)
      } else {
        controlState.subtractInPlace(.Selected)
      }
    }
  }
  
  var enabled = true {
    didSet {
      if enabled {
        controlState.subtractInPlace(.Disabled)
      } else {
        controlState.insert(.Disabled)
      }
    }
  }
  
  //Disabled > Selected > Highlighted > Normal
  var controlState:SKAControlState = .Normal {
    didSet {
      if oldValue != controlState {
        print("this was updated: \(controlState)")
        updateButton()
      }
    }
  }
  
  /*
   * Update the button based on the state of the button. Since the button can hold more than one state at a time,
   * determine the most important state and display the correct texture/color
   */
  private func updateButton() {
    var newNormalTexture:SKTexture?
    var newTexture:SKTexture?
    var newColor = color
    
    if controlState.contains(.Disabled) {
      if let disabledNormal = normalTextures[.Disabled] {
        newNormalTexture = disabledNormal
      }
        
      if let disabled = textures[.Disabled] {
        newTexture = disabled
      }
      
      if let disabledColor = colors[.Disabled] {
        newColor = disabledColor
      }
      
    } else if controlState.contains(.Selected) {
      if let selectedNormal = normalTextures[.Selected] {
        newNormalTexture = selectedNormal
      }
      
      if let selected = textures[.Selected] {
        newTexture = selected
      }
      
      if let selectedColor = colors[.Selected] {
        newColor = selectedColor
      }
    } else if controlState.contains(.Highlighted){
      if let highlightedNormal = normalTextures[.Highlighted] {
        newNormalTexture = highlightedNormal
      }
      
      if let highlighted = textures[.Highlighted] {
        newTexture = highlighted
      }
      
      if let highlightedColor = colors[.Highlighted] {
        newColor = highlightedColor
      }
    } else if let normalColor = colors[.Normal] {
      newColor = normalColor
    }
    
    if newNormalTexture == nil {
      newNormalTexture = normalTextures[.Normal]
    }
    
    if newTexture == nil {
      newTexture = textures[.Normal]
    }
    
    normalTexture = newNormalTexture
    texture = newTexture
    color = newColor
  }
  
  // MARK: - Selector Events
  
  func addTarget(target: AnyObject, selector: Selector, forControlEvents events: SKAControlEvent) {
    userInteractionEnabled = true
    let buttonSelector = SKAButtonSelector(target: target, selector: selector)
    addButtonSelector(buttonSelector, forControlEvents: events)
  }
  
  /*
  * Add Selector(s) to our dictionary of actions based on the SKAControlEvent
  */
  private func addButtonSelector(buttonSelector: SKAButtonSelector, forControlEvents events: SKAControlEvent) {
    for option in SKAControlEvent.AllOptions where events.contains(option) {
      if var buttonSelectors = selectors[option] {
        buttonSelectors.append(buttonSelector)
        selectors[option] = buttonSelectors
      } else {
        selectors[option] = [buttonSelector]
      }
    }
  }
  
  /*
  * Checks if there are any listed selectors for the control event, and performs them
  */
  private func performSelectorsForType(type:SKAControlEvent) {
    guard let selectors = selectors[type] else { return }
    performSelectors(selectors)
  }
  
  /*
  * Loops through the selected actions and performs the selectors associated to them
  */
  private func performSelectors(buttonSelectors: [SKAButtonSelector]) {
    for selector in buttonSelectors {
      selector.target.performSelector(selector.selector, withObject: self)
    }
  }
  
  // Mark: - Control States
  func setColor(color:UIColor, forState state:SKAControlState) {
    colors[state] = color
    updateButton()
  }
  
  func setTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      textures[state] = texture
    } else {
      textures.removeValueForKey(state)
    }
    updateButton()
  }
  
  func setNormalTexture(texture:SKTexture?, forState state:SKAControlState){
    if let texture = texture {
      normalTextures[state] = texture
    } else {
      normalTextures.removeValueForKey(state)
    }
    
    updateButton()
  }
  
  //Save a touch to help determine if the touch just entered or exited the node
  private var lastEvent:SKAControlEvent = .None
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let _ = touches.first as UITouch? where enabled {
      performSelectorsForType(.TouchDown)
      lastEvent = .TouchDown
      controlState.insert(.Highlighted)
    }
    super.touchesBegan(touches , withEvent:event)
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      let currentLocation = (touch.locationInNode(scene))
      
      if !containsPoint(currentLocation) {
        if lastEvent != .DragOutside  && lastEvent != .DragExit {
          performSelectorsForType(.DragExit)
          controlState.subtractInPlace(.Highlighted)
          lastEvent = .DragExit
        } else {
          // Touch stayed Outside Node
          performSelectorsForType(.DragOutside)
          lastEvent = .DragOutside
        }
      } else  {
        if lastEvent != .DragInside && lastEvent != .DragEnter {
          //Touched Moved Inside Node
          performSelectorsForType(.DragEnter)
          controlState.insert(.Highlighted)
          lastEvent = .DragEnter
        } else {
          //Touch Stayed Inside Node
          performSelectorsForType(.DragInside)
          lastEvent = .DragInside
        }
      }
    }
    
    super.touchesMoved(touches, withEvent: event)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    lastEvent = .None
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      if containsPoint(touch.locationInNode(scene)) {
        performSelectorsForType(.TouchUpInside)
      } else {
        performSelectorsForType(.TouchUpOutside)
      }
      
      controlState.subtractInPlace(.Highlighted)
    }
    
    super.touchesEnded(touches, withEvent: event)
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    lastEvent = .None
    if let _ = touches?.first as UITouch? {
      performSelectorsForType(.TouchCancelled)
    }
    
    super.touchesCancelled(touches, withEvent: event)
  }
  
  deinit {
    textures.removeAll()
    normalTextures.removeAll()
  }
}
