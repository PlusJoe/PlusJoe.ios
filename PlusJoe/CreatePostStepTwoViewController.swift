//
//  CreatePostStepTwoViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit

class CreatePostStepTwoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!

    @IBOutlet weak var postBody: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!

    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if postBody.text == "" || postBody.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 10 {
            let alertMessage = UIAlertController(title: "Warning", message: "Your post can't be empty. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else if postBody.text.rangeOfString("#") == nil {
            let alertMessage = UIAlertController(title: "Warning", message: "Your post can not be saved without any #hash_tags. You post will not be searchable unless it has #hash_tags. Add some #has_tags and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else if postBody.text.componentsSeparatedByString("$").count != 2 {
            let alertMessage = UIAlertController(title: "Warning", message: "Your post must contain exactly one $price_tag. A $price_tag must contain a whole ammount and may look like this $5 or $50 or $5003.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else {
            UNFINISHED_POST?.body = postBody.text
            UNFINISHED_POST?.saveEventually(nil)
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        nextButton.setTitle("next" + "   \u{f054}", forState: UIControlState.Normal)
        
        postBody.becomeFirstResponder()
        postBody.text = UNFINISHED_POST?.body
        postBody.delegate = self
        
        
    }
    
     func textViewDidChange(textView: UITextView) {
//        NSLog("text changed: \(textView.text)")
        countLabel.text = "+" + String(140 - count(textView.text))
    }

    
}
