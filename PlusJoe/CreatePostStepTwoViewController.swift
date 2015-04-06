//
//  CreatePostStepTwoViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit

extension String {
    func beginsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.startIndex == self.startIndex
        }
        return false
    }
    
    func endsWith (str: String) -> Bool {
        if let range = self.rangeOfString(str) {
            return range.endIndex == self.endIndex
        }
        return false
    }
}

class CreatePostStepTwoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!

    @IBOutlet weak var postBody: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!

    let placeHolderText = "Your post must contain at least one #hash_tag. It should also contain exactly one $price_tag. Other people in your communitry will be able to find your post and will be notified by #hash_tags -- choose your #hash_tags wisely."
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonClicked(sender: AnyObject) {
        if postBody.text == "" || postBody.text == placeHolderText || count(postBody.text) < 10 {
            let alertMessage = UIAlertController(title: nil, message: "Your post can't be empty. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else if postBody.text.rangeOfString("#") == nil {
            let alertMessage = UIAlertController(title: nil, message: "Your post can not be saved without any #hash_tags. You post will not be searchable unless it has #hash_tags. Add some #has_tags and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else if postBody.text.componentsSeparatedByString("$").count != 2 {
            let alertMessage = UIAlertController(title: nil, message: "Your post must contain exactly one $price_tag. A $price_tag must contain a whole ammount and may look like this $5 or $50 or $5003.", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        countLabel.text = "+" + String(140 - count(postBody.text))
        
        if postBody.text == "" {
            postBody.textColor = UIColor.lightGrayColor()
            postBody.text = placeHolderText
            postBody.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    
     func textViewDidChange(textView: UITextView) {
//        NSLog("text changed: \(textView.text)")
        
        if postBody.text != placeHolderText && postBody.text.endsWith(placeHolderText) {
            postBody.text = String(postBody.text[postBody.text.startIndex])
            postBody.textColor = UIColor.blackColor()
        }

        var countChars = count(textView.text)
        countLabel.text = "+" + String(140 - countChars)
        
        if(countChars > 130) {
            countLabel.textColor = UIColor.redColor()
        } else {
            countLabel.textColor = UIColor.blueColor()
        }
        
        while(countChars > 140) {
            postBody.text = dropLast(postBody.text)
            countChars--
            countLabel.text = "+" + String(140 - countChars)
        }
    }

//    func textViewDidBeginEditing(textView: UITextView) {
//    }

    
}
