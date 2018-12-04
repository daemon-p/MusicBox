//
//  AppDelegate.swift
//  Host
//
//  Created by What on 2018/12/4.
//  Copyright © 2018 dumbass. All rights reserved.
//

import UIKit
import MusicBox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AssistantSetup()
        return true
    }
}

