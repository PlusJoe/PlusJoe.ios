//
//  AppDelegate.swift
//  PlusJoe
//
//  Created by D on 3/23/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit

//let FLURRY_API_KEY = ""
//let PARSE_APP_ID = ""
//let PARSE_CLIENT_KEY = ""



let PJHost = "http://plusjoe.com"

var DEVICE_PHONE_NUMBER = ""
var DEVICE_UUID = ""
let APP_DELEGATE:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let USER_DEFAULTS = NSUserDefaults.standardUserDefaults()



func roundMoney(number: Double) -> Double {
    let numberOfPlaces = 2.0
    let multiplier = pow(10.0, numberOfPlaces)
    return round(number * multiplier) / multiplier
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var CURRENT_LOCATION:PFGeoPoint?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // setup Flurry
        Flurry.startSession(FLURRY_API_KEY) // replace flurryKey with your own key
        Flurry.setCrashReportingEnabled(true)  // records app crashing in Flurry
        Flurry.logEvent("Start Application")   // Example of even logging
        Flurry.setSessionReportsOnCloseEnabled(false)
        Flurry.setSessionReportsOnPauseEnabled(false)
        Flurry.setBackgroundSessionEnabled(true)
        
        //setup parse
        // parse prod
        // parse dev
        Parse.setApplicationId(PARSE_APP_ID, clientKey: PARSE_CLIENT_KEY)
        
        
        // Register for Push Notitications and/or Alerts
        let userNotificationTypes:UIUserNotificationType = (UIUserNotificationType.Alert |
            UIUserNotificationType.Badge |
            UIUserNotificationType.Sound)
        
        let settings:UIUserNotificationSettings  = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        //        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(settings)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        //        BaseDataModel.clearStoredCredential()
        //generate and store UUID for device if necessey
        if let credentials = BaseDataModel.getStoredCredential() {
            NSLog("getting GUID from nsuserdefaults")
            //            DEVICE_PHONE_NUMBER = credentials.user!
            DEVICE_UUID = credentials.password!
        }
        if DEVICE_UUID == "" {
            NSLog("generating new UDID")
            let uuidString = NSUUID().UUIDString
            //            var uuidRef:CFUUIDRef  = CFUUIDCreate(kCFAllocatorDefault)
            //            var uuidString = CFUUIDCreateString(nil, uuidRef)
            NSLog("uuid: \(uuidString)")
            BaseDataModel.storeCredential(uuidString)
            DEVICE_UUID = uuidString
        }

        
        getCurrentLocation()
//        getAlerts()
        return true
    }
    
    func getCurrentLocation() -> PFGeoPoint? {
        if CURRENT_LOCATION == nil {
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if !(error != nil) {
                    self.CURRENT_LOCATION = geoPoint!
                    NSLog("current location detected")
                    var post = PJPost(className: PJPost.parseClassName())
                    post.location = self.CURRENT_LOCATION!
                    post.createdBy = DEVICE_UUID
                    post.save()

                }
            })
        }
        return CURRENT_LOCATION
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


}


//http://stackoverflow.com/questions/16244969/how-to-tell-git-to-ignore-individual-lines-i-e-gitignore-for-specific-lines-of
//http://www.buildsucceeded.com/2014/swift-move-uitextfield-so-keyboard-does-not-hide-it-ios-8-xcode-6-swift/
//https://github.com/NatashaTheRobot/SeinfeldQuotes
//http://www.appcoda.com/self-sizing-cells/
//http://www.snip2code.com/Snippet/197992/Swift-Background-Fetch
//gitignore lines http://stackoverflow.com/questions/16244969/how-to-tell-git-to-ignore-individual-lines-i-e-gitignore-for-specific-lines-of
