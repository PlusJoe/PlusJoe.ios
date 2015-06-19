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

extension BuyViewController: PKPaymentAuthorizationViewControllerDelegate, CardIOPaymentViewControllerDelegate {
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
    @IBOutlet weak var buyWithCreditCardButton: UIButton!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isGuestUser(PFUser.currentUser()!) {
            let signUpViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SignUpViewController") as! SignUpViewController
            self.presentViewController(signUpViewController, animated: true, completion: nil)
        }
        
        PFUser.currentUser()?.fetch()
        if PFUser.currentUser()!["emailVerified"] == nil || PFUser.currentUser()!["emailVerified"] as! Bool == false {
            let alertMessage = UIAlertController(title: nil, message: "Unable to buy for unverified user. Check your email for verification code and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
            let verifyEmail = PFUser.currentUser()?.email
            PFUser.currentUser()?.email = "dmitry@plusjoe.com" // this should trigger verification email to be sent out
            PFUser.currentUser()?.save()
            PFUser.currentUser()?.email = verifyEmail // this should trigger verification email to be sent out
            PFUser.currentUser()?.save()
//                saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
//                NSLog("new verification email is sent our")
//            })
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        if PKPaymentAuthorizationViewController.canMakePaymentsUsingNetworks(SUPPORTED_PAYMENT_NETWORKS) {
            // Pay is available!
            buyWithCreditCardButton.hidden = true
        } else {
            buyWithApplePayButton.hidden = true
        }

        
    }
    
    
    @IBAction func buyItWithApplePay(sender: AnyObject) {
        
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
        
    }


    @IBAction func buyItWithCC(sender: AnyObject) {
        var cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
//        resultLabel.text = "user canceled"
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)

            NSLog(str as String)
            
            
            
            var card:STPCard  = STPCard()
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            STPAPIClient.sharedClient().createTokenWithCard(card,
                completion: { (token:STPToken?, error:NSError?) -> Void in
                    if (error != nil) {
                        let alertMessage = UIAlertController(title: nil, message: "Error processing your payment. \(error!)", preferredStyle: UIAlertControllerStyle.Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alertMessage.addAction(ok)
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                        
                    } else {

                        let requestInfo = [
                            "cardToken": token!.tokenId,
                            "price": 1.10
                        ]
                        
                        PFCloud.callFunctionInBackground("purchaseItem",
                            withParameters: requestInfo as [NSObject : AnyObject],
                            block: { (result:AnyObject?, error:NSError?) -> Void in
                                if (error != nil) {
                                    let alertMessage = UIAlertController(title: nil, message: "Error processing payment.", preferredStyle: UIAlertControllerStyle.Alert)
                                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
                                    alertMessage.addAction(ok)
                                    self.presentViewController(alertMessage, animated: true, completion: nil)
                                    
                                    
                                } else {
                                    let alertMessage = UIAlertController(title: nil, message: "Payent successfull.", preferredStyle: UIAlertControllerStyle.Alert)
                                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    })
                                    alertMessage.addAction(ok)
                                    self.presentViewController(alertMessage, animated: true, completion: nil)

                                }
                        })
                        
                    }
            })
            
            
            
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindFromRegistration (segue : UIStoryboardSegue) {
    }

}
