//
//  MenuPostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse


class MenuPostDetailsViewController: UIViewController {
    
    var post:PFObject?
    // if conversation is passed from child controller, then use it for initiating the chat
    var conversation:PFObject?
    
    
    @IBOutlet weak var alertsCountLabel: UILabel!
    @IBOutlet weak var myAlertsButton: UIButton!
    @IBOutlet weak var myTagsButton: UIButton!
    @IBOutlet weak var mySellsButton: UIButton!
    @IBOutlet weak var myBuysButton: UIButton!

    
    
    @IBOutlet weak var flagInapproproate: UIButton!
    @IBOutlet weak var follow: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAlertsView()
        
        myAlertsButton.setTitle("\u{f0f3}", forState: UIControlState.Normal)
        myTagsButton.setTitle("\u{f02c}", forState: UIControlState.Normal)
        mySellsButton.setTitle("\u{f155}", forState: UIControlState.Normal)
        myBuysButton.setTitle("\u{f07a}", forState: UIControlState.Normal)

        
        flagInapproproate.setTitle("\u{f05e}", forState: UIControlState.Normal)
        follow.setTitle("\u{f02b}", forState: UIControlState.Normal)
        
    }
    
    
    func updateAlertsView() -> Void {
        if UNREAD_ALERTS_COUNT == 0 {
            self.alertsCountLabel.hidden = true
        } else {
            self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
            self.alertsCountLabel.hidden = false
        }
    }

    
    @IBAction func flagInapropriate(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.post?[PJPOST.inappropriate] = true
            self.post?.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
    
    
    @IBAction func followHashtags(sender: AnyObject) {
        let hashTags = PJHashTag.loadTagsForPost(post!)
        
        var tagsString = "Following tags will be followed:\n"
        for hashTag in hashTags {
            PJFollowing.createOrUpdateTagsImFollowing(hashTag[PJHASHTAG.hashTag] as! String,
                succeeded: { (succeeds) -> () in
                    
                },
                failed: { (error) -> () in
            })
            
            
            tagsString += "#" + (hashTag[PJHASHTAG.hashTag] as! String) + "\n"
        }
        tagsString += "You will be notified when someone creates a new post in your area with one of these tags."
        let alertMessage = UIAlertController(title: nil, message: tagsString, preferredStyle: UIAlertControllerStyle.Alert)
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
            
            var chatViewController = segue.destinationViewController as! ChatViewController
            
            if self.conversation == nil {
                let conversation = PJConversation.findOrCreateConversation(post!,
                    participant2id: PFUser.currentUser()!.objectId!)
                chatViewController.conversation = conversation
            } else {
                chatViewController.conversation = self.conversation
            }
        }
    }
    
    
}
