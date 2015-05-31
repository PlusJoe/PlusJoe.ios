//
//  MenuPostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse
import Stripe


extension MenuPostDetailsViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController!,
        didAuthorizePayment payment: PKPayment!,
        completion: ((PKPaymentAuthorizationStatus) -> Void)!) {
//            completion(PKPaymentAuthorizationStatus.Success)
            
            // 2
            Stripe.setDefaultPublishableKey(STRIPE_PUBLISHABLE_KEY)
            
            // 3
            STPAPIClient.sharedClient().createTokenWithPayment(payment) {
                (token, error) -> Void in
                
                if (error != nil) {
                    println(error)
                    completion(PKPaymentAuthorizationStatus.Failure)
                    return
                }

                
                
                let requestInfo = [
                    "cardToken": token!.tokenId,
                    "price": 1.11
                ]
                
                PFCloud.callFunctionInBackground("purchaseItem",
                    withParameters: requestInfo as [NSObject : AnyObject],
                    block: { (result:AnyObject?, error:NSError?) -> Void in
                        if (error != nil) {
                            let alertMessage = UIAlertController(title: nil, message: "Error processing payment.", preferredStyle: UIAlertControllerStyle.Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
                            alertMessage.addAction(ok)
                            self.presentViewController(alertMessage, animated: true, completion: nil)
                            
                            completion(PKPaymentAuthorizationStatus.Failure)
                            return
                        } else {
                            completion(PKPaymentAuthorizationStatus.Success)
                        }
                })
                
            }
            
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

class MenuPostDetailsViewController: UIViewController {
    
    var post:PFObject?
    // if conversation is passed from child controller, then use it for initiating the chat
    var conversation:PFObject?
    
    
    @IBOutlet weak var flagInapproproate: UIButton!
    @IBOutlet weak var buyIt: UIButton!
    @IBOutlet weak var buyItLabel: UILabel!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var shareAndEarn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagInapproproate.setTitle("\u{f05e}", forState: UIControlState.Normal)
        buyIt.setTitle("\u{f155}", forState: UIControlState.Normal)
        follow.setTitle("\u{f02c}", forState: UIControlState.Normal)
        shareAndEarn.setTitle("\u{f0d6}", forState: UIControlState.Normal)
        
        //disable buy button for posts that can't be bought
        if post![PJPOST.sell] as! Bool == false {
            buyIt.enabled = false
            buyIt.setTitleColor(UIColor.grayColor(), forState: .Normal)
            buyItLabel.textColor = UIColor.grayColor()
        }
    }
    
    @IBAction func buyIt(sender: AnyObject) {
        
        var request:PKPaymentRequest = PKPaymentRequest()
        // Configure your request here.
        let label = "+Joe"
        let amount = NSDecimalNumber(string: "1.00")
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: label, amount: amount)]
        request.merchantIdentifier = STRIPE_MERCHANT_ID
        request.supportedNetworks = SUPPORTED_PAYMENT_NETWORKS
        request.merchantCapabilities = PKMerchantCapability.Capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "buying thing1", amount: 2.00),
            PKPaymentSummaryItem(label: "finders fee", amount: 1.00),
            PKPaymentSummaryItem(label: "+JOE", amount: 3.30)
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        self.presentViewController(applePayController, animated: true, completion: nil)

        
        if Stripe.canSubmitPaymentRequest(request) {
            NSLog("payment request submitted")
            
        } else {
            // Show the user your own credit card form (see options 2 or 3)
            NSLog("payment request could not be submitted")

        }
        
        
//        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
//        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
//        alertMessage.addAction(ok)
//        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func flagInapropriate(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.post?[PJPOST.inappropriate] = true
            self.post?.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    
    
    @IBAction func followHashtags(sender: AnyObject) {
        let hashTags = PJHashTag.loadTagsForPost(post!)
        
        var tagsString = "Following tags will be followed:\n"
        for hashTag in hashTags {
            PJFollowing.createOrUpdateTagsImFollowing(hashTag[PJHASHTAG.hashTag] as! String,
                succeeded: { (succeeds) -> () in
                    
                },
                failed: { (error) -> () in
            })
            
            
            tagsString += "#" + (hashTag[PJHASHTAG.hashTag] as! String) + "\n"
        }
        tagsString += "You will be notified when someone creates a new post in your area with one of these tags."
        let alertMessage = UIAlertController(title: nil, message: tagsString, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func shareAndEarn(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func chat(sender: AnyObject) {
        //        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        //        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        //        alertMessage.addAction(ok)
        //        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "chatSegue") {
            
            var chatViewController = segue.destinationViewController as! ChatViewController
            
            if self.conversation == nil {
                let conversation = PJConversation.findOrCreateConversation(post!,
                    participant2: DEVICE_UUID)
                chatViewController.conversation = conversation
            } else {
                chatViewController.conversation = self.conversation
            }
        }
    }
    
    
}
