//
//  Menu2PostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 5/14/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

// this meny shows for posts that are mine, so i can't reply to them, I can't buy it, etc..., I can only delete it.
class Menu2PostDetailsViewController: UIViewController {
    
    var post:PFObject?
    
    @IBOutlet weak var alertsCountLabel: UILabel!
    @IBOutlet weak var myAlertsButton: UIButton!
    @IBOutlet weak var myTagsButton: UIButton!
    @IBOutlet weak var mySellsButton: UIButton!
    @IBOutlet weak var myBuysButton: UIButton!

    
    @IBOutlet weak var delete: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAlertsView()
        
        myAlertsButton.setTitle("\u{f0f3}", forState: UIControlState.Normal)
        myTagsButton.setTitle("\u{f02c}", forState: UIControlState.Normal)
        mySellsButton.setTitle("\u{f164}", forState: UIControlState.Normal)
        myBuysButton.setTitle("\u{f07a}", forState: UIControlState.Normal)

        
        delete.setTitle("\u{f05e}", forState: UIControlState.Normal)
        
    }
    
    
    func updateAlertsView() -> Void {
        if UNREAD_ALERTS_COUNT == 0 {
            self.alertsCountLabel.hidden = true
        } else {
            self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
            self.alertsCountLabel.hidden = false
        }
    }

    
    @IBAction func deleteIt(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.post?[PJPOST.archived] = true
            self.post?.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
}
