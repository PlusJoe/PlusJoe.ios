//
//  CreatePostDescribeStepViewController
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import UIKit


class CreatePostDescribeStepViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!

    @IBOutlet weak var postBody: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    let placeHolderText = "Your post must contain at least one #hash_tag. Other people in your communitry will be able to find your post by #hash_tags. People in your community will be notified about new posts which contain #hash_tags they follow -- choose your #hash_tags wisely."
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "createPostPhotosSegue" {
            if postBody.text == "" || postBody.text == placeHolderText || postBody.text.characters.count < 10 {
                let alertMessage = UIAlertController(title: nil, message: "Your post can't be empty. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
                alertMessage.addAction(ok)
                presentViewController(alertMessage, animated: true, completion: nil)
            } else if postBody.text.rangeOfString("#") == nil {
                let alertMessage = UIAlertController(title: nil, message: "Your post can not be saved without any #hash_tags. You post will not be searchable unless it has #hash_tags. Add some #has_tags and try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
                alertMessage.addAction(ok)
                presentViewController(alertMessage, animated: true, completion: nil)
            } else {
                UNFINISHED_POST?[PJPOST.body] = postBody.text
                UNFINISHED_POST?.saveEventually(nil)
            }
        }
        return true
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
        
        
        postBody.becomeFirstResponder()
        
        //now let's see if a temporary post was already created, otherwise use the new one
        if UNFINISHED_POST == nil {// let's try to load one from a DB
            UNFINISHED_POST = PJPost.getUnfinishedPost()
            if UNFINISHED_POST == nil {
                UNFINISHED_POST = PJPost.createUnfinishedPost()
            }
        }
        
        postBody.text = UNFINISHED_POST?[PJPOST.body] as! String
        postBody.delegate = self
        
        countLabel.text = "+" + String(140 - postBody.text.characters.count)
        
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

        var countChars = textView.text.characters.count
        countLabel.text = "+" + String(140 - countChars)
        
        if(countChars > 130) {
            countLabel.textColor = UIColor.redColor()
        } else {
            countLabel.textColor = UIColor.blueColor()
        }
        
        while(countChars > 140) {
            postBody.text = String(dropLast(postBody.text.characters))
            countChars--
            countLabel.text = "+" + String(140 - countChars)
        }
    }

//    func textViewDidBeginEditing(textView: UITextView) {
//    }

    
}
