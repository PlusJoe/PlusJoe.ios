//
//  SignInViewController.swift
//  PlusJoe
//
//  Created by D on 6/13/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class SignInViewController: UIViewController {
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        nextButton.title = "sign in \u{f054}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            nextButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        userNameTextField.becomeFirstResponder()
    }
    
    @IBAction func signInAction(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameTextField.text!, password:passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // The login failed. Check error to see why.
                let alertMessage = UIAlertController(title: nil, message: "Try different credentials, or Register a new user.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: { () -> Void in
                })
            }
        }
    }
}
