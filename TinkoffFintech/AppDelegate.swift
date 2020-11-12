//
//  AppDelegate.swift
//  TinkoffFintech
//
//  Created by Anya on 11.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import UIKit
import os
import Firebase

enum UIApplicationState {
    case notRunning
    case inactive
    case active
    case background
    case suspended
}

public let subsystem = Bundle.main.bundleIdentifier!

struct Log {
  static let appDelegate = OSLog(subsystem: subsystem, category: "appDelegate")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.notRunning)", "\(UIApplicationState.inactive)", "\(#function)")
        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.inactive)", "\(UIApplicationState.inactive)", "\(#function)")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.presentationAssembly.conversationListViewController().embedInNavigationController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        rootAssembly.addObservers()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.inactive)", "\(UIApplicationState.active)", "\(#function)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.active)", "\(UIApplicationState.inactive)", "\(#function)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.inactive)", "\(UIApplicationState.background)", "\(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.background)", "\(UIApplicationState.inactive)", "\(#function)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        os_log("Application moved from %s to %s: %s", log: Log.appDelegate, type: .debug, "\(UIApplicationState.background)", "\(UIApplicationState.notRunning)", "\(#function)")
    }
    
    func changeStatusBar(theme: Theme) {
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = theme.colors.userInterfaceStyle
        } 
    }

}
