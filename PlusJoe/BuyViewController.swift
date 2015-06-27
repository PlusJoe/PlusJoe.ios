//
//  BuyViewController.swift
//  PlusJoe
//
//  Created by D on 5/31/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import Parse

class BuyViewController: UIViewController {
    
    var post:PFObject?
    var pendingPurchase:PFObject?
    
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        if self.pendingPurchase != nil {
            self.pendingPurchase!.deleteInBackgroundWithBlock(nil)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if registerUserIfNecessery(self) == true {
            //user is registered and verified, can proceed with purchase
            
            //here generate a new purchase and encode it in QR code plusjoe://purchases/123123
            PJPurchase.createPurchase(post!,
                succeeded: { (result) -> () in
                    self.pendingPurchase = result
                    self.qrImageView.image = generateQRImage("plusjoe://purchases/\(result.objectId!)")
                })
                { (error) -> () in
                    let alertMessage = UIAlertController(title: nil, message: "Unable to generate QR code.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)
            }
            
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
    }
    
    
    
    @IBAction func unwindFromRegistration (segue : UIStoryboardSegue) {
    }
}
