//
//  AppDelegate.swift
//  MixboxDemo
//
//  Created by Artem Razinov on 06.08.2018.
//  Copyright © 2018 Mixbox. All rights reserved.
//

import UIKit
import MixboxInAppServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let mixboxInAppServices = MixboxInAppServices()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool
    {
        if let mixboxInAppServices = mixboxInAppServices {
            mixboxInAppServices.start()
            mixboxInAppServices.handleUiBecomeVisible()
        }
        
        return true
    }
}

