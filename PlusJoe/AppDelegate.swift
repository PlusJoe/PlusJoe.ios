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
import Bolts

let FLURRY_API_KEY = "SHP3N5P9KFXPBT6BHY9G"
let PARSE_APP_ID = "2VdZroRZXm1voBa03m3F1cgkwgV5AFgJel1dYsVf"
let PARSE_CLIENT_KEY = "GUtWFcyuOVxCYSA1vMs0XDSWpTHKpbb1DhEweAy0"
let STRIPE_PUBLISHABLE_KEY = "pk_test_a8Gey5Uae2pQrcZfkqmjWaDO"
let STRIPE_MERCHANT_ID = "merchant.com.plusjoe"
let SUPPORTED_PAYMENT_NETWORKS = [PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]





//let PJHost = "http://plusjoe.com"

var DEVICE_PHONE_NUMBER = ""
//var CURRENT_USER:PFUser? = PFUser.currentUser()
let APP_DELEGATE:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let USER_DEFAULTS = NSUserDefaults.standardUserDefaults()

var CURRENT_LOCATION:PFGeoPoint! = nil // the app will only work if the current location can be detected

var UNFINISHED_POST:PFObject! = nil // we use this to store intermidiary post object
var UNREAD_ALERTS_COUNT = 0
var PENDING_SALES_PRESENT = false


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
                completionHandler(resizedImage: newImage, data:imageData!)
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


func getAlerts() -> Void {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    PJAlert.loadUnreadAlertsCount({ (alertsCount) -> () in
        UNREAD_ALERTS_COUNT = alertsCount
        NSLog("There are \(alertsCount) unread alerts")
        
        if  alertsCount > 0 {
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Alerts"
            localNotification.alertBody = "There are \(alertsCount) unread alerts."
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
            UIApplication.sharedApplication().applicationIconBadgeNumber = alertsCount
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        },
        failed: { (error) -> () in
//            NSLog("Error retreiveing alerts in background: %@ %@", error, error.userInfo!)
            NSLog("Error retreiveing alerts in background: %@", error)
    })
    
    PENDING_SALES_PRESENT = PJPurchase.arePendingPurchasesPresent()
    
    
    //        if count == 0 {
    //            if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
    //                while let presentedViewController = topController.presentedViewController {
    //                    topController = presentedViewController
    //                }
    //                let sellViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SellViewController") as! SellViewController
    //                topController.presentViewController(sellViewController, animated: true, completion: nil)
    //            }
    //
    //        }
    //    NSLog("count \(count)")
    //    count++
}

func getTopViewController() -> UIViewController? {
    if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}


func isGuestUser(user:PFUser) -> Bool {
    if user.username! == user.objectId! {
        return true
    }
    return false
}



//    func generateQRImage(stringQR:NSString, withSizeRate rate:CGFloat) -> UIImage
func generateQRImage(stringQR:NSString) -> UIImage
{
    let filter:CIFilter = CIFilter(name:"CIQRCodeGenerator")!
    filter.setDefaults()
    
    let data:NSData = stringQR.dataUsingEncoding(NSUTF8StringEncoding)!
    filter.setValue(data, forKey: "inputMessage")
    
    let outputImg:CIImage = filter.outputImage
    
    let context:CIContext = CIContext(options: nil)
    let cgimg:CGImageRef = context.createCGImage(outputImg, fromRect: outputImg.extent)
    
    var img:UIImage = UIImage(CGImage: cgimg, scale: 1.0, orientation: UIImageOrientation.Up)
    
    //        let width  = img.size.width * rate
    //        let height = img.size.height * rate
    let width  = CGFloat(200)
    let height = CGFloat(200)
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height))
    let cgContxt:CGContextRef = UIGraphicsGetCurrentContext()
    CGContextSetInterpolationQuality(cgContxt, CGInterpolationQuality.None)
    img.drawInRect(CGRectMake(0, 0, width, height))
    img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
}

func addPulseAnimation(layer:CALayer) {
    if layer.animationForKey("scale") == nil {
        let pulseAnimation1:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation1.duration = 1.0
        pulseAnimation1.toValue = NSNumber(float: 0.85)
        pulseAnimation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation1.autoreverses = true
        pulseAnimation1.repeatCount = FLT_MAX
        
        let pulseAnimation2:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        pulseAnimation2.duration = 1.0
        pulseAnimation2.toValue = NSNumber(float: 0.7)
        pulseAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation2.autoreverses = true
        pulseAnimation2.repeatCount = FLT_MAX
        
        layer.addAnimation(pulseAnimation1, forKey: "scale")
        layer.addAnimation(pulseAnimation2, forKey: "opacity")
    }
}

func removePulseAnimation(layer:CALayer) {
    layer.removeAnimationForKey("scale")
    layer.removeAnimationForKey("opacity")
}



func registerUserIfNecessery(viewController:UIViewController) ->(Bool) {
    if isGuestUser(PFUser.currentUser()!) {
        let signUpViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
        viewController.presentViewController(signUpViewController, animated: true, completion: nil)
    } else {
        PFUser.currentUser()?.fetch()
        if PFUser.currentUser()!["emailVerified"] == nil || PFUser.currentUser()!["emailVerified"] as! Bool == false {
            let alertMessage = UIAlertController(title: nil, message: "Unable to proceed for unverified user. Check your email for verification code and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//                viewController.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertMessage.addAction(ok)
            viewController.presentViewController(alertMessage, animated: true, completion: nil)
            let verifyEmail = PFUser.currentUser()?.email
            PFUser.currentUser()?.email = "dmitry+ignore@plusjoe.com" // this should trigger verification email to be sent out
            PFUser.currentUser()?.save()
            PFUser.currentUser()?.email = verifyEmail // this should trigger verification email to be sent out
            PFUser.currentUser()?.save()
            //                saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            //                NSLog("new verification email is sent our")
            //            })
        } else {
            return true // means user is registered and verified
        }
    }
    return false
}


func handleIncomingPurchaseUrl(url:BFURL) -> () {
    NSLog("%%%%%%%%%%%%%%%%%%%%%% received purchase url: \(url.inputURL.description)")
    // let's check if the code was scanned by the right seller
    let host:String = url.targetURL!.host!
    let pathComponents:[String]? = url.targetURL!.pathComponents as [String]?
    
    if host == "purchases" {
        let purchaseId:String = pathComponents![1]
        NSLog("%%%%%%%%%%%%%%%%%%%%%% received purchase id: \(purchaseId)")
        
        let topController:UIViewController? = getTopViewController()
        if topController != nil {
            PJPurchase.loadPurchase(
                purchaseId,
                succeeded: { (result) -> () in
                    if result[PJPURCHASE.soldBy] as? String == PFUser.currentUser()?.objectId {
                        NSLog("^^^^^^^^^^^^^^^^^^^^^^^^^ correct seller")
                        let sellViewController1 = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SellViewController1") as! SellViewController1
                        
                        sellViewController1.purchase = result
                        topController?.presentViewController(sellViewController1, animated: true, completion: nil)
                        
                        
                    } else {
                        NSLog("^^^^^^^^^^^^^^^^^^^^^^^^^ incorrect seller")
                        let alertMessage = UIAlertController(title: nil, message: "Incorrect seller.", preferredStyle: UIAlertControllerStyle.Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//                            topController?.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alertMessage.addAction(ok)
                        topController?.presentViewController(alertMessage, animated: true, completion: nil)
                    }
                },
                failed: { (error) -> () in
                    NSLog("^^^^^^^^^^^^^^^^^^^^^^^^^ error seller")
                    let alertMessage = UIAlertController(title: nil, message: "Error, unable to proceed.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
//                        topController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertMessage.addAction(ok)
                    topController?.presentViewController(alertMessage, animated: true, completion: nil)
            })
        }
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
        let userNotificationTypes:UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
        
        let settings:UIUserNotificationSettings  = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        //        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(settings)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        //        BaseDataModel.clearStoredCredential()
        
        
        
        
        // configure stripe
        Stripe.setDefaultPublishableKey(STRIPE_PUBLISHABLE_KEY)
        
        //        PFUser.enableAutomaticUser()
        
        getCurrentLocation()
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getAppAlerts"), userInfo: nil, repeats: true)
        }
        return true
    }
    
    
    // need this wrapper function, because selecter can only invoke the function on the class
    func getAppAlerts() -> Void {
        getAlerts()
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
        application.applicationIconBadgeNumber = UNREAD_ALERTS_COUNT + Int(PENDING_SALES_PRESENT)
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
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let parsedUrl:BFURL = BFURL(inboundURL: url, sourceApplication: sourceApplication)

        let host:String = parsedUrl.targetURL!.host!
        if host == "purchases" {
            handleIncomingPurchaseUrl(parsedUrl)
            return true
        }
        return false
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
// generate QR code in swift http://stackoverflow.com/questions/26007484/qr-code-reader-generator-in-swift
// qr code reader http://www.appcoda.com/qr-code-reader-swift/
// pulse effect http://stackoverflow.com/questions/8083138/ios-how-to-do-a-native-pulse-effect-animation-on-a-uibutton
// QR code scanning http://shrikar.com/implementing-barcode-scanning-in-ios8-with-swift/


