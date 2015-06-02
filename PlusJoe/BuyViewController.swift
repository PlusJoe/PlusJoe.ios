//
//  BuyViewController.swift
//  PlusJoe
//
//  Created by D on 5/31/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import Parse
import Stripe

extension BuyViewController: PKPaymentAuthorizationViewControllerDelegate {
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


class BuyViewController: UIViewController {
    
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!

    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBOutlet weak var buyWithApplePayButton: UIButton!
    @IBOutlet weak var isNotAvailableLabel: UILabel!
    @IBOutlet weak var useYourCreditCardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SUPPORTED_PAYMENT_NETWORKS) {
            // Pay is available!
            isNotAvailableLabel.hidden = true
        } else {
//            disable the button
            buyWithApplePayButton.enabled = false
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

    
}
