//
//  CreatePostFindersFeeStepViewController.swift
//  PlusJoe
//
//  Created by D on 5/1/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class CreatePostFindersFeeStepViewController:
    UIViewController {
    
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
        nextButton.title = "next \u{f054}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            nextButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        

        
        if UNFINISHED_POST?[PJPOST.price] as? Int > 0 {
            self.priceTextField.text = "\((UNFINISHED_POST?[PJPOST.price])!)"
        }
    
        if UNFINISHED_POST?[PJPOST.fee] as? Int > 0 {
            self.findersFeeTextField.text = "\((UNFINISHED_POST?[PJPOST.fee])!)"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        priceTextField.becomeFirstResponder()
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "createPostPreviewSegue" {
//            if postBody.text == "" || postBody.text == placeHolderText || count(postBody.text) < 10 {
//                let alertMessage = UIAlertController(title: nil, message: "Your post can't be empty. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
//                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
//                alertMessage.addAction(ok)
//                presentViewController(alertMessage, animated: true, completion: nil)
//            } else if postBody.text.rangeOfString("#") == nil {
//                let alertMessage = UIAlertController(title: nil, message: "Your post can not be saved without any #hash_tags. You post will not be searchable unless it has #hash_tags. Add some #has_tags and try again.", preferredStyle: UIAlertControllerStyle.Alert)
//                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
//                alertMessage.addAction(ok)
//                presentViewController(alertMessage, animated: true, completion: nil)
//            } else {
//                UNFINISHED_POST?[PJPOST.body] = postBody.text
//                UNFINISHED_POST?.saveEventually(nil)
//            }
            
            UNFINISHED_POST[PJPOST.price] = priceTextField.text.toInt()!
            UNFINISHED_POST[PJPOST.fee] = findersFeeTextField.text.toInt()!
            
            UNFINISHED_POST?.saveEventually(nil)

        }
        return true
    }

}
