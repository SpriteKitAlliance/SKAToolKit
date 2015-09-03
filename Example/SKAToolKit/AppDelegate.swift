//
//  AppDelegate.swift
//  SKAToolKit
//
//  Created by Marc Vandehey on 8/31/15.
//  Copyright © 2015 SpriteKit Alliance. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var button:SKAButtonSprite?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    let viewController = SKAButtonViewController()
    
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.backgroundColor = UIColor.whiteColor()
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func something(sender:AnyObject) {
    print("something selector \(sender)")
  }
  
  func somethingElse(sender:AnyObject) {
    print("something else selector \(sender)")
  }
}

