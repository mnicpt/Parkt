//
//  AppDelegate.swift
//  SMARTePARK
//
//  Created by Steven Mask on 5/20/15.
//  Copyright (c) 2015 Steven Mask. All rights reserved.
//

import UIKit

let CURRENT_RESERVATION: String = "current_reservation"
let PREVIOUS_RESERVATIONS: String = "previous_reservations"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var userDefaults  = NSUserDefaults.standardUserDefaults()
        
        var file = NSBundle.mainBundle().pathForResource("ParkingReservation", ofType: "plist")
        var currentReservation = NSMutableDictionary(contentsOfFile: file!)

        userDefaults.setObject(currentReservation, forKey: CURRENT_RESERVATION)
        
        if userDefaults.objectForKey(PREVIOUS_RESERVATIONS) == nil {
            userDefaults.setObject(NSMutableArray(), forKey: PREVIOUS_RESERVATIONS)
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    class func currentReservation() -> NSDictionary {
        return NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_RESERVATION) as! NSDictionary
    }
    
    class func previousReservations() -> NSMutableArray {
        return NSUserDefaults.standardUserDefaults().mutableArrayValueForKey(PREVIOUS_RESERVATIONS)
    }
    
    class func updateCurrentReservation(key: String, withValue value: AnyObject) {
        var currentReservation = NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_RESERVATION)?.mutableCopy() as! NSMutableDictionary
        currentReservation.setObject(value, forKey: key)
        
        NSUserDefaults.standardUserDefaults().setObject(currentReservation, forKey: CURRENT_RESERVATION)
    }

}

