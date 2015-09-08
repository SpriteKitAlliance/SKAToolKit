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
    return [.TouchDown, .TouchUpInside, .TouchUpOutside, .DragOutside, .DragInside, .DragEnter, .DragExit, .TouchCancelled]
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

/// Container for SKAButton Selectors
/// - Parameter target: target Object to call the selector on
/// - Parameter selector: Selector to call
private struct SKAButtonSelector {
  let target: AnyObject
  let selector: Selector
}

class SKAButtonSprite : SKSpriteNode {
  private var selectors = [SKAControlEvent: [SKAButtonSelector]]()
  private var textures = [SKAControlState: SKTexture]()
  private var normalTextures = [SKAControlState: SKTexture]()
  private var colors = [SKAControlState: SKColor]()
  private var backgroundColor = SKColor.clearColor()
  
  /// Sets the button to the selected state
  /// - Note: If an SKAction is taking place, the selected state may not show properly
  var selected:Bool {
    get {
      return controlState.contains(.Selected)
    }
    set(newValue) {
      if newValue {
        controlState.insert(.Selected)
      } else {
        controlState.subtractInPlace(.Selected)
      }
    }
  }
  
  /// Sets the button to the enabled/disabled state. In a disabled state, the button will not trigger selectors
  /// - Note: If an SKAction is taking place, the disabled state may not show properly
  var enabled:Bool {
    get {
      return !controlState.contains(.Disabled)
    }
    set(newValue) {
      if newValue {
        controlState.subtractInPlace(.Disabled)
      } else {
        controlState.insert(.Disabled)
      }
    }
  }
  
  /// Current State of the button
  /// - Note: ReadOnly
  private(set) var controlState:SKAControlState = .Normal {
    didSet {
      if oldValue != controlState {
        print("this was updated: \(controlState)")
        updateButton()
      }
    }
  }
  
  /// Update the button based on the state of the button. Since the button can hold more than one state at a time,
  /// determine the most important state and display the correct texture/color
  /// - Note: Disabled > Highlighted > Selected > Normal
  /// - Warning: SKActions will override setting the textures
  /// - Returns: void
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
    }  else if let normalColor = colors[.Normal] {
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
  
  /// Add target for a SKAControlEvent. You may call this multiple times and you can specify multiple targets for any event.
  /// - Parameter target: Object the selecter will be called on
  /// - Parameter selector: The chosen selector for the event that is a member of the target
  /// - Parameter events: SKAControlEvents that you want to register the selector to
  /// - Returns: void
  func addTarget(target: AnyObject, selector: Selector, forControlEvents events: SKAControlEvent) {
    userInteractionEnabled = true
    let buttonSelector = SKAButtonSelector(target: target, selector: selector)
    addButtonSelector(buttonSelector, forControlEvents: events)
  }
  
  /// Add Selector(s) to our dictionary of actions based on the SKAControlEvent
  /// - Parameter buttonSelector: Internal struct containing the selector and the target
  /// - Parameter events: SKAControl event(s) associated to the selector
  /// - Returns: void
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
  
  /// Checks if there are any listed selectors for the control event, and performs them
  /// - Parameter event: Single control event
  /// - Returns: void
  private func performSelectorsForEvent(event:SKAControlEvent) {
    guard let selectors = selectors[event] else { return }
    performSelectors(selectors)
  }
  
  /// Loops through the selected actions and performs the selectors associated to them
  /// - Parameter buttonSelectors: buttonSelectors Array of button selectors to perform
  /// - Returns: void
  private func performSelectors(buttonSelectors: [SKAButtonSelector]) {
    for selector in buttonSelectors {
      selector.target.performSelector(selector.selector, withObject: self)
    }
  }
  
  // Mark: - Control States
  
  /// Sets the node's background color for the specified control state
  /// - Parameter color: The specified color
  /// - Parameter state: The specified control state to trigger the color change
  /// - Returns: void
  func setColor(color:SKColor, forState state:SKAControlState) {
    colors[state] = color
    updateButton()
  }
  
  /// Sets the node's texture for the specified control state
  /// - Parameter texture: The specified texture, if nil it clears the texture for the control state
  /// - Parameter state: The specified control state to trigger the texture change
  /// - Returns: void
  func setTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      textures[state] = texture
    } else {
      textures.removeValueForKey(state)
    }
    updateButton()
  }
  
  /// Sets the node's normal texture for the specified control state
  /// - Parameter texture: The specified texture, if nil it clears the texture for the control state
  /// - Parameter state: The specified control state to trigger the normal texture change
  /// - Returns: void
  func setNormalTexture(texture:SKTexture?, forState state:SKAControlState) {
    if let texture = texture {
      normalTextures[state] = texture
    } else {
      normalTextures.removeValueForKey(state)
    }
    
    updateButton()
  }
  
  /// Save a touch to help determine if the touch just entered or exited the node
  private var lastEvent:SKAControlEvent = .None
  
  // Mark: - Touch Methods
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let _ = touches.first as UITouch? where enabled {
      performSelectorsForEvent(.TouchDown)
      lastEvent = .TouchDown
      controlState.insert(.Highlighted)
    }
    super.touchesBegan(touches , withEvent:event)
  }
  
  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      let currentLocation = (touch.locationInNode(scene))
      
      if lastEvent == .DragInside && !containsPoint(currentLocation) {
        //Touch Moved Outside Node
        controlState.subtractInPlace(.Highlighted)
        performSelectorsForEvent(.DragExit)
        lastEvent = .DragExit
      } else if lastEvent == .DragOutside && containsPoint(currentLocation) {
        //Touched Moved Inside Node
        controlState.insert(.Highlighted)
        performSelectorsForEvent(.DragEnter)
        lastEvent = .DragEnter
      } else if !containsPoint(currentLocation) {
        // Touch stayed Outside Node
        performSelectorsForEvent(.DragOutside)
        lastEvent = .DragOutside
      } else if containsPoint(currentLocation) {
        //Touch Stayed Inside Node
        performSelectorsForEvent(.DragInside)
        lastEvent = .DragInside
      }
    }
    
    super.touchesMoved(touches, withEvent: event)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    lastEvent = .None
    if let touch = touches.first as UITouch?, scene = scene where enabled {
      if containsPoint(touch.locationInNode(scene)) {
        performSelectorsForEvent(.TouchUpInside)
      } else {
        performSelectorsForEvent(.TouchUpOutside)
      }
      
      controlState.subtractInPlace(.Highlighted)
    }
    
    super.touchesEnded(touches, withEvent: event)
  }
  
  override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    lastEvent = .None
    if let _ = touches?.first as UITouch? {
      performSelectorsForEvent(.TouchCancelled)
    }
    
    super.touchesCancelled(touches, withEvent: event)
  }
  
  /// Remove unneeded textures
  deinit {
    textures.removeAll()
    normalTextures.removeAll()
  }
}
