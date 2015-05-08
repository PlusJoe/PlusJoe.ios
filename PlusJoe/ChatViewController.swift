//
//  ChatViewController.swift
//  PlusJoe
//
//  Created by D on 5/3/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class ChatViewController: UIViewController, UITextViewDelegate/*, UITableViewDelegate, UITableViewDataSource*/ {

    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var chatMessageBody: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    // conversation should always be passed from chid controller
    var conversation:PJConversation?
    
    var chatMessages:[PJChatMessage] = [PJChatMessage]()

    

    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        chatMessageBody.becomeFirstResponder()
        chatMessageBody.text = ""
        countLabel.text = "+" + String(140)
        countLabel.textColor = UIColor.blueColor()
        chatMessageBody.textColor = UIColor.lightGrayColor()
        chatMessageBody.delegate = self


        sendButton.setTitle("\u{f1d8}", forState: .Normal)
        
        
        PJChatMessage.loadAllChatMessages(conversation!,
            succeeded: { (results) -> () in
                self.chatMessages = results
        }) { (error) -> () in
            let alertMessage = UIAlertController(title: nil, message: "Error.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }                
    }

    func textViewDidChange(textView: UITextView) {
        //        NSLog("text changed: \(textView.text)")
        
        
        var countChars = count(textView.text)
        countLabel.text = "+" + String(140 - countChars)
        
        if(countChars > 130) {
            countLabel.textColor = UIColor.redColor()
        } else {
            countLabel.textColor = UIColor.blueColor()
        }
        
        while(countChars > 140) {
            chatMessageBody.text = dropLast(chatMessageBody.text)
            countChars--
            countLabel.text = "+" + String(140 - countChars)
        }
    }

    
    
}
