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
    
    
    @IBOutlet weak var delete: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delete.setTitle("\u{f05e}", forState: UIControlState.Normal)
        
        
    }
    
    @IBAction func deleteIt(sender: AnyObject) {
        let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
    }
    
}
