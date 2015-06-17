//
//  ConfirmEmailViewController.swift
//  PlusJoe
//
//  Created by D on 6/13/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmtTextField: UITextField!
    
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        nextButton.title = "sign up \u{f054}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            nextButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        userNameTextField.becomeFirstResponder()
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        if(userNameTextField.text == "") {
            let alertMessage = UIAlertController(title: nil, message: "User name is required", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
            //            userNameTextField.becomeFirstResponder()
        } else
            if(passwordTextField.text == "") {
                let alertMessage = UIAlertController(title: nil, message: "Password is required", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
                //            passwordTextField.becomeFirstResponder()
            } else
                if(emailTextField.text == "") {
                    let alertMessage = UIAlertController(title: nil, message: "Email is required", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                    //            emailTextField.becomeFirstResponder()
                } else
                    if(emailConfirmtTextField.text == "") {
                        let alertMessage = UIAlertController(title: nil, message: "Email (confirm) is required", preferredStyle: UIAlertControllerStyle.Alert)
                        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertMessage.addAction(ok)
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                        //            emailConfirmtTextField.becomeFirstResponder()
                    } else
                        if(emailConfirmtTextField.text != emailTextField.text) {
                            let alertMessage = UIAlertController(title: nil, message: "Email (confirm) must match Email", preferredStyle: UIAlertControllerStyle.Alert)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertMessage.addAction(ok)
                            self.presentViewController(alertMessage, animated: true, completion: nil)
                            //            emailConfirmtTextField.becomeFirstResponder()
                        } else {
                            // all validation passed, register here
                            
                            var user = PFUser.currentUser()!
                            
                            if !PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser()) {
                                user = PFUser() // create a new user
                            }
                            
                            
                            user.username = userNameTextField.text
                            user.password = passwordTextField.text
                            user.email = emailTextField.text
                            // other fields can be set just like with PFObject
                            
                            user.signUpInBackgroundWithBlock {
                                (succeeded: Bool, error: NSError?) -> Void in
                                if let error = error {
                                    let errorString = error.userInfo?["error"] as? NSString
                                    // Show the errorString somewhere and let the user try again.
                                    let alertMessage = UIAlertController(title: nil, message: "Unable to register a user \(errorString!)", preferredStyle: UIAlertControllerStyle.Alert)
                                    let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                    alertMessage.addAction(ok)
                                    self.presentViewController(alertMessage, animated: true, completion: nil)
                                } else {
                                    PFUser.logInWithUsernameInBackground(self.userNameTextField.text, password:self.passwordTextField.text) {
                                        (user: PFUser?, error: NSError?) -> Void in
                                        if user != nil {
                                            // Do stuff after successful login.
                                            self.performSegueWithIdentifier("unwindFromRegistration", sender: self)
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
        }
    }
    
}
