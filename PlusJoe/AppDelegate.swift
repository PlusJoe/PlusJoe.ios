//
//  AppDelegate.swift
//  PlusJoe
//
//  Created by D on 3/23/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit
import Parse
import Stripe

let FLURRY_API_KEY = "SHP3N5P9KFXPBT6BHY9G"
let PARSE_APP_ID = "2VdZroRZXm1voBa03m3F1cgkwgV5AFgJel1dYsVf"
let PARSE_CLIENT_KEY = "GUtWFcyuOVxCYSA1vMs0XDSWpTHKpbb1DhEweAy0"
let STRIPE_PUBLISHABLE_KEY = "pk_test_a8Gey5Uae2pQrcZfkqmjWaDO"
let STRIPE_MERCHANT_ID = "merchant.com.plusjoe"
let SUPPORTED_PAYMENT_NETWORKS = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]





let PJHost = "http://plusjoe.com"

var DEVICE_PHONE_NUMBER = ""
var DEVICE_UUID = ""
let APP_DELEGATE:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let USER_DEFAULTS = NSUserDefaults.standardUserDefaults()

var CURRENT_LOCATION:PFGeoPoint! = nil // the app will only work if the current location can be detected

var UNFINISHED_POST:PFObject! = nil // we use this to store intermidiary post object
var UNREAD_ALERTS_COUNT = 0



func roundMoney(number: Double) -> Double {
    let numberOfPlaces = 2.0
    let multiplier = pow(10.0, numberOfPlaces)
    return round(number * multiplier) / multiplier
}


extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

// http://rajiev.com/resize-uiimage-in-swift/
extension UIImage {
    public func resize(newWidth:Int, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            let newSize:CGSize = CGSizeMake(CGFloat(newWidth), CGFloat(Float(newWidth) * Float(self.size.height) / Float(self.size.width)))
            
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}

extension String {
    func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
    func endsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.endIndex == self.endIndex
        }
        return false
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var timer:NSTimer?


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

        
        // configure stripe
        Stripe.setDefaultPublishableKey(STRIPE_PUBLISHABLE_KEY)

        
        getCurrentLocation()
        
        if timer == nil {
        timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getAlerts"), userInfo: nil, repeats: true)
        }
        return true
    }
    // need this wrapper function, because selecter can only invoke the function on the class
    func getAlerts() -> Void {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        PJAlert.loadUnreadAlertsCount({ (alertsCount) -> () in
            UNREAD_ALERTS_COUNT = alertsCount
            NSLog("There are \(alertsCount) unread alerts")
            
            if  alertsCount > 0 {
                var localNotification:UILocalNotification = UILocalNotification()
                localNotification.alertAction = "Alerts"
                localNotification.alertBody = "There are \(alertsCount) unread alerts."
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
                UIApplication.sharedApplication().applicationIconBadgeNumber = alertsCount
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
            },
            failed: { (error) -> () in
                NSLog("Error retreiveing alerts in background: %@ %@", error, error.userInfo!)
        })
    }
    
    func getCurrentLocation() -> PFGeoPoint? {
        if CURRENT_LOCATION == nil {
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if !(error != nil) {
                    CURRENT_LOCATION = geoPoint!
                    NSLog("current location detected")
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


    

    
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        NSLog("fetching in background");
        completionHandler(UIBackgroundFetchResult.NewData)        
        getAlerts()        
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        NSLog("received local notification")
        application.applicationIconBadgeNumber = UNREAD_ALERTS_COUNT
//        NSLog("tabBarController is nil:\(tabBarController == nil)")
//        if tabBarController != nil {
//            let tabArray = self.tabBarController?.tabBar.items as NSArray!
//            let tabItem = tabArray.objectAtIndex(2) as! UITabBarItem
//            if  unreadAlertsCount > 0 {
//                tabItem.badgeValue = "\(unreadAlertsCount)"
//            } else {
//                tabItem.badgeValue = nil
//            }
//        }
        
        //        var alert = UIAlertView()
        //        alert.title = "Alert"
        //        alert.message = notification.alertBody
        //        alert.addButtonWithTitle("Dismiss")
        //        alert.show()
    }
    
    
}


//http://stackoverflow.com/questions/16244969/how-to-tell-git-to-ignore-individual-lines-i-e-gitignore-for-specific-lines-of
//http://www.buildsucceeded.com/2014/swift-move-uitextfield-so-keyboard-does-not-hide-it-ios-8-xcode-6-swift/
//https://github.com/NatashaTheRobot/SeinfeldQuotes
//http://www.appcoda.com/self-sizing-cells/
//http://www.snip2code.com/Snippet/197992/Swift-Background-Fetch
//gitignore lines http://stackoverflow.com/questions/16244969/how-to-tell-git-to-ignore-individual-lines-i-e-gitignore-for-specific-lines-of
// taking photo or picking image from library http://makeapppie.com/2014/12/04/swift-swift-using-the-uiimagepickercontroller-for-a-camera-and-photo-library/
// scrollview with autolayout http://spin.atomicobject.com/2014/03/05/uiscrollview-autolayout-ios/
// more on scroll view http://natashatherobot.com/ios-autolayout-scrollview/
// update table view programmatically http://derpturkey.com/create-a-static-uitableview-without-storyboards/
// dynamically sizing table cells hight http://www.raywenderlich.com/87975/dynamic-table-view-cell-height-ios-8-swift
// working with mapkit http://www.techotopia.com/index.php/Working_with_Maps_on_iOS_8_with_Swift,_MapKit_and_the_MKMapView_Class
// apple pay tutorial http://www.raywenderlich.com/87300/apple-pay-tutorial
// one more apple pay tutorial http://nshipster.com/apple-pay/
// scanning CC with camera https://github.com/card-io/card.io-iOS-SDK


