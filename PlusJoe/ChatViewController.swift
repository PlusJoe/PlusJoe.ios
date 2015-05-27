//
//  ChatViewController.swift
//  PlusJoe
//
//  Created by D on 5/3/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class ChatViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var timer:NSTimer?
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var chatMessageBody: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    // conversation should always be passed from chid controller
    var conversation:PFObject?
    
    var chatMessages:[PFObject] = [PFObject]()
    
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        if chatMessages.count == 0 {
            conversation?.deleteInBackgroundWithBlock({ (sucseeded:Bool, error:NSError?) -> Void in})
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        chatMessageBody.becomeFirstResponder()
        chatMessageBody.text = ""
        countLabel.text = "+" + String(140)
        countLabel.textColor = UIColor.blueColor()
        chatMessageBody.textColor = UIColor.lightGrayColor()
        chatMessageBody.delegate = self
        
        
        sendButton.setTitle("\u{f1d8}", forState: .Normal)

    }
    

    func retrieveNewMessages() -> Void {
        
        let conversationDate = conversation!.createdAt
//        let firstChatMessageDate = chatMessages[0].createdAt
//        NSLog("conversationDate: \(conversationDate)")
//        NSLog("first chat message date: \(firstChatMessageDate)")
        PJChatMessage.loadNewChatMessages(
            (chatMessages.count == 0 ? conversation!.createdAt : chatMessages[0].createdAt)!,
            conversation: conversation!,
            succeeded: { (results) -> () in
                if results.count > 0 {
                    for var index = results.count-1; index >= 0; --index {
                        self.chatMessages.insert(results[index], atIndex: 0)
                    }
                    self.tableView.reloadData()
                    self.tableView.reloadInputViews()
                }
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Error retreiving new messages.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.retrieveAllMessages()

        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("retrieveNewMessages"), userInfo: nil, repeats: true)

    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }

    
    func retrieveAllMessages() -> Void {
        PJChatMessage.loadAllChatMessages(conversation!,
            succeeded: { (results) -> () in
                self.chatMessages = results
                self.tableView.reloadData()
                
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Error retreiving all messages.", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    
    
    @IBAction func sendReplyAction(sender: AnyObject) {
        
        if textView.text == "" || textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 1 {
            let alertMessage = UIAlertController(title: "Warning", message: "You reply can't be empty. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        } else {
            PJChatMessage.createChatMessageAndAlert(conversation!,
                body: chatMessageBody.text,
                createdBy: DEVICE_UUID,
                success: { (result) -> () in
//                    self.chatMessages.insert(result, atIndex: 0)
                    self.chatMessageBody.text = ""
                }, failed: { (error) -> () in
                    let alertMessage = UIAlertController(title: "Error", message: "Failed replying. Try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in})
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)
            })
            
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("there are \(chatMessages.count) chat messages")
        return self.chatMessages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatMessage = chatMessages[indexPath.row]
        var cell:UITableViewCell?
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy hh:mm a"

        if chatMessage[PJCHATMESSAGE.createdBy] as! String == DEVICE_UUID {
            cell = self.tableView.dequeueReusableCellWithIdentifier("chat_cell") as? ChatTableViewCell
            (cell as? ChatTableViewCell)?.postedAt.text = String(format: "%@", df.stringFromDate(chatMessage.createdAt!))
            (cell as? ChatTableViewCell)?.body.text = chatMessage[PJCHATMESSAGE.body] as? String

        } else {
            cell = self.tableView.dequeueReusableCellWithIdentifier("chat1_cell") as? ChatTableViewCell1
            (cell as? ChatTableViewCell1)?.postedAt.text = String(format: "%@", df.stringFromDate(chatMessage.createdAt!))
            (cell as? ChatTableViewCell1)?.body.text = chatMessage[PJCHATMESSAGE.body] as? String
        }

        
        NSLog("Rendering ReplyPost")
        
        
        
        return cell!
    }
    
}
