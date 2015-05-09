//
//  MenuPostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuPostDetailsViewController: UIViewController {
    
    var post:PJPost?

    
    @IBOutlet weak var flagInapproproate: UIButton!
    @IBOutlet weak var buyIt: UIButton!
    @IBOutlet weak var buyItLabel: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var shareAndEarn: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagInapproproate.setTitle("\u{f05e}", forState: UIControlState.Normal)
        buyIt.setTitle("\u{f155}", forState: UIControlState.Normal)
        bookmark.setTitle("\u{f097}", forState: UIControlState.Normal)
        shareAndEarn.setTitle("\u{f0d6}", forState: UIControlState.Normal)
        chat.setTitle("\u{f0e6}", forState: UIControlState.Normal)
    }
    
    @IBAction func buyIt(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func flagInapropriate(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.post?.inappropriate = true
            self.post?.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func bookmarkHashtags(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }

    @IBAction func shareAndEarn(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    @IBAction func chat(sender: AnyObject) {
//        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
//        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
//        alertMessage.addAction(ok)
//        self.presentViewController(alertMessage, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "chatSegue") {
            
            let conversation = PJConversation.findOrCreateConversation(post!,
                participant1: DEVICE_UUID,
                participant2: self.post!.createdBy)
            
            var chatViewController = segue.destinationViewController as! ChatViewController
            chatViewController.conversation = conversation
            
        }
    }

    
}
