//
//  AppDelegate.swift
//  EVC
//
//  Created by Benjamin Garrigues on 04/09/2017.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var engine: EVCEngine? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
            let env = EVCEngineEnvironment.development
            #else
            let env = EVCEngineEnvironment.integration
            #endif
        engine = EVCEngine(initialContext: EVCEngineContext(environment: env,
                                                            applicationForeground: UIApplication.shared.applicationState == .active))


        /*
         //Because this sample uses a storyboard, keyWindow is nil.
         //If you were to instanciate your root view controller manually, then you would configure its engine at this point.
         if let rootVC = UIApplication.shared.keyWindow?.rootViewController as? ViewController {
            rootVC.engine = engine
        }
         */

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        engine?.onApplicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        engine?.onApplicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

