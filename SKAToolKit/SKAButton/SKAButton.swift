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

/// SKAControlEvent Mimics the usefulness of UIControl class
/// - Note: None - Used internally only
///
/// TouchDown - User Touches Down on the button
///
/// TouchUpInside - User releases Touch inside the bounds of the button
///
/// TouchUpOutside - User releases Touch outside the bounds of the button
///
/// DragOutside - User Drags touch from outside the bounds of the button and stays outside
///
/// DragInside - User Drags touch from inside the bounds of the button and stays inside
///
/// DragEnter - User Drags touch from outside the bounds of the button to inside the bounds of the button
///
/// DragExit - User Drags touch from inside the bounds of the button to outside the bounds of the button
struct SKAControlEvent: OptionSetType, Hashable {
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }
  
  static private var None:   SKAControlEvent   { return SKAControlEvent(rawValue: 0) }
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

/// SKAControlState Possible states for the SKAButton
/// - Note: Normal - No States are active on the button
///
/// Highlighted - Button is being touched
///
/// Selected - Button in selected state
///
/// Disabled - Button in disabled state, will ignore SKAControlEvents
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

/// Insets for the texture/color of the node
///
/// - Note: Inset direction will move the texture/color towards that edge at the given amount.
///
/// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0)
///   Top will move the texture/color towards the top
/// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0)
///   Top and Bottom will cancel each other out
struct SKButtonEdgeInsets {
  let top:CGFloat
  let right:CGFloat
  let bottom:CGFloat
  let left:CGFloat
  
  init() {
    top = 0
    right = 0
    bottom = 0
    left = 0
  }
  
  init(top:CGFloat, right:CGFloat, bottom:CGFloat, left:CGFloat) {
    self.top = top
    self.right = right
    self.bottom = bottom
    self.left = left
  }
}

/// Container for SKAButton Selectors
/// - Parameter target: target Object to call the selector on
/// - Parameter selector: Selector to call
private struct SKAButtonSelector {
  let target: AnyObject
  let selector: Selector
}

/// SKSpriteNode set up to mimic the utility of UIButton
class SKAButtonSprite : SKSpriteNode {
  private var selectors = [SKAControlEvent: [SKAButtonSelector]]()
  private var textures = [SKAControlState: SKTexture]()
  private var normalTextures = [SKAControlState: SKTexture]()
  private var colors = [SKAControlState: SKColor]()
  private var backgroundColor = SKColor.clearColor()
  private var childNode: SKSpriteNode
  
  /// Will restore the size of the texture node to the button size every time the button is updated
  var restoreSizeAfterAction = true
  var touchTarget:CGSize
  
  // MARK: - Initializers
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    childNode = SKSpriteNode(texture: nil, color: color, size: size)
    touchTarget = size
    super.init(texture: texture, color: color, size: size)
    self.addChild(childNode)
  }

  required init?(coder aDecoder: NSCoder) {
    childNode = SKSpriteNode()
    touchTarget = CGSize()
    super.init(coder: aDecoder)
    self.addChild(childNode)
  }
  
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
    var newColor = childNode.color
    
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
    childNode.normalTexture = newNormalTexture
    childNode.texture = newTexture
    childNode.color = newColor
    
    if restoreSizeAfterAction {
      childNode.size = childNode.size
    }
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
  
  // MARK: - Control States
  
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
  
  /// Private variable to tell us when to update the button size or the child size
  private var updatingTargetSize = false
  
  /// Insets for the texture/color of the node
  ///
  /// - Note: Inset direction will move the texture/color towards that edge at the given amount.
  ///
  /// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 0, left: 0) 
  ///   Top will move the texture/color towards the top
  /// - SKButtonEdgeInsets(top: 10, right: 0, bottom: 10, left: 0) 
  ///   Top and Bottom will cancel each other out
  var insets = SKButtonEdgeInsets() {
    didSet{
      childNode.position = CGPoint(x: -insets.left + insets.right, y: -insets.bottom + insets.top)
    }
  }
  
  /// Sets the touchable area for the button
  /// - Parameter size: The size of the touchable area
  /// - Returns: void
  func setButtonTargetSize(size:CGSize) {
    updatingTargetSize = true
    self.size = size
  }
  
  /// Sets the touchable area for the button
  /// - Parameter size: The size of the touchable area
  /// - Parameter insets: The edge insets for the texture/color of the node
  /// - Returns: void
  /// - Note: Inset direction will move the texture/color towards that edge at the given amount.
  func setButtonTargetSize(size:CGSize, insets:SKButtonEdgeInsets) {
    self.insets = insets
    self.setButtonTargetSize(size)
  }
  
  /// Save a touch to help determine if the touch just entered or exited the node
  private var lastEvent:SKAControlEvent = .None
  
  // MARK: - Touch Methods
  
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

  /// MARK: Override basic functions and pass them to our child node, this leaves the button as a colorless touchable area
  
  override func actionForKey(key: String) -> SKAction? {
    return childNode.actionForKey(key)
  }
  
  override func runAction(action: SKAction) {
    childNode.runAction(action)
  }
  
  override func runAction(action: SKAction, completion block: () -> Void) {
    childNode.runAction(action, completion: block)
  }
  
  override func runAction(action: SKAction, withKey key: String) {
    childNode.runAction(action, withKey: key)
  }
  
  override func removeActionForKey(key: String) {
    childNode.removeActionForKey(key)
    updateButton()
  }
  
  override func removeAllActions() {
    childNode.removeAllActions()
    updateButton()
  }
  
  override func removeAllChildren() {
    childNode.removeAllChildren()
  }
  
  override var texture: SKTexture? {
    get {
      return childNode.texture
    }
    set {
      childNode.texture = newValue
    }
  }
  
  override var normalTexture: SKTexture? {
    get {
      return childNode.normalTexture
    }
    set {
      childNode.normalTexture = newValue
    }
  }
  
  override var color: SKColor {
    get {
      return childNode.color
    }
    set {
      super.color = SKColor.clearColor()
      childNode.color = newValue
    }
  }
  
 override var size: CGSize {
    willSet {
      if updatingTargetSize {
        if self.size != newValue {
          super.size = newValue
        }
      
        updatingTargetSize = false
      } else {
        childNode.size = newValue
      }
    }
  }
  
  /// Remove unneeded textures
  deinit {
    textures.removeAll()
    normalTextures.removeAll()
    removeAllChildren()
  }
}
