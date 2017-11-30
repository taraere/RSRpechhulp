//
//  AppDelegate.swift
//  RSRPechhulpApp
//
//  Created by Tara Elsen on 03/11/2017.
//  Copyright © 2017 Tara Elsen. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        LocationManager.instance().stopUpdatingLocation()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Check for GPS and Internet
        if !Reachability.isConnectedToNetwork() {
            noInternetAlert()
        }
        LocationManager.instance().startUpdatingLocation()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func noInternetAlert() {
        let internetAlert = UIAlertController(title: "Geen internetwerbinging", message: "Er is geen verbinding mogelijk met het internet. Hierdoor kunnen uw locatiegegevens niet opgehaald worden.", preferredStyle: UIAlertControllerStyle.alert)
        
        internetAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        if let window = self.window, let viewController = window.rootViewController {
            viewController.present(internetAlert, animated: true, completion: nil)
        }
    }
    
}
