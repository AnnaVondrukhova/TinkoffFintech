//
//  AppDelegate.swift
//  TinkoffFintech
//
//  Created by Anya on 11.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit

public func print(_ items: Any...) {
    //comment next line if you want to disable logging
    Swift.print(items)
}

enum UIApplicationState {
    case notRunning
    case inactive
    case active
    case background
    case suspended
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Application moved from \(UIApplicationState.notRunning) to \(UIApplicationState.inactive): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Application moved from \(UIApplicationState.inactive) to \(UIApplicationState.inactive): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Application moved from \(UIApplicationState.inactive) to \(UIApplicationState.active): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("Application moved from \(UIApplicationState.active) to \(UIApplicationState.inactive): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("Application moved from \(UIApplicationState.inactive) to \(UIApplicationState.background): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("Application moved from \(UIApplicationState.background) to \(UIApplicationState.inactive): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("Application moved from \(UIApplicationState.background)/\(UIApplicationState.suspended) to \(UIApplicationState.notRunning): \(#function)")
//        print(UIApplication.shared.applicationState.rawValue)
    }

}

