
//
//  EditPostViewController.swift
//  PlusJoe
//
//  Created by D on 6/12/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class EditPostViewController : UIViewController {
    //this is to be passed from the invoking controller
    var post:PFObject?
    
    var origPrice:Int = 0
    var origFindersFee:Int = 0
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var findersFeeTextField: UITextField!

    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        nextButton.title = "done \u{f054}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            nextButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        self.priceTextField.text = "\((post?[PJPOST.price])!)"
        self.findersFeeTextField.text = "\((post?[PJPOST.fee])!)"
        
        origPrice = (post?[PJPOST.price] as? Int)!
        origFindersFee = (post?[PJPOST.fee] as? Int)!

        NSLog("price: \(origPrice), fee: \(origFindersFee)")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        priceTextField.becomeFirstResponder()
    }
    

    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if priceTextField.text == "" {
            priceTextField.text = "0"
        }
        if findersFeeTextField.text == "" {
            findersFeeTextField.text = "0"
        }
        
        
        if Int(priceTextField.text!)! > origPrice || Int(priceTextField.text!)! <= 0 {
            let alertMessage = UIAlertController(title: nil, message: "Price must be between $1 and \(origPrice).", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else if Int(findersFeeTextField.text!)! < origFindersFee || Int(findersFeeTextField.text!)! > Int(priceTextField.text!)! {
            let alertMessage = UIAlertController(title: nil, message: "Finder's fee must be between \(origFindersFee) and \(Int(priceTextField.text!)!)", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else {
            post?[PJPOST.price] = Int(priceTextField.text!)!
            post?[PJPOST.fee] = Int(findersFeeTextField.text!)!
        
            post?.save()
            return true
        }

        return false
    }
}
