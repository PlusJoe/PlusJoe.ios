//
//  ForgotEmailViewController.swift
//  PlusJoe
//
//  Created by D on 6/13/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class ForgotEmailViewController: UIViewController {
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        nextButton.title = "reset \u{f054}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            nextButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        //        postBody.becomeFirstResponder()
    }
    
    @IBAction func resetEmailAction(sender: AnyObject) {
        if emailTextField.text == "" {
        let alertMessage = UIAlertController(title: nil, message: "Email is required", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
        } else {
            PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!, block: { (success: ObjCBool, error:NSError?) -> Void in
                if success.boolValue == true {
                    let alertMessage = UIAlertController(title: nil, message: "Password reset. Check your email for a reset link.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)                    
                }
            })

        }
    }
}
