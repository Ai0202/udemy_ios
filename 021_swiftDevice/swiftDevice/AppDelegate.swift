//
//  AppDelegate.swift
//  swiftDevice
//
//  Created by Atsushi on 2018/05/29.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //デバイスを分ける
        
        sleep(2)
        
        let storyboard:UIStoryboard = self.grabStoryboard()
        
        if let window = window{
            
            window.rootViewController = storyboard.instantiateInitialViewController() as UIViewController!
            
        }
        
        self.window?.makeKeyAndVisible()

        return true
    }
    
    func grabStoryboard() -> UIStoryboard{
        
        var storyboard = UIStoryboard()
        var height = UIScreen.main.bounds.size.height
        
        //iPhone6
        if height == 667{
            
            storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        }else if height == 736{
            
            //plus
            storyboard = UIStoryboard(name: "iPhone7Plus", bundle: nil)
            
        }else if height == 480{
            
            //iPhone4s
            storyboard = UIStoryboard(name: "iPhone4S", bundle: nil)
            
        }else{
            
            //iphone5,5s,5c
            storyboard = UIStoryboard(name: "iPhone5", bundle: nil)
        }
        
        return storyboard
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

