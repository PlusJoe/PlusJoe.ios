//
//  AlertsViewController.swift
//  PlusJoe
//
//  Created by D on 5/8/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noAlertsLabel: UILabel!
    
    
    var alerts:[PFObject] = [PFObject]()

    
    @IBOutlet weak var backNavButton: UIBarButtonItem!

    
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
        
        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self
        
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        retrieveMyAlerts()
    }
    
    func retrieveMyAlerts() -> Void {
        PJAlert.loadMyAlerts({ (alerts) -> () in
            if alerts.count > 0 {
                self.alerts = alerts
                self.tableView.reloadData()
                self.tableView.reloadInputViews()
                self.noAlertsLabel.hidden = true
                self.tableView.hidden = false
            } else {
                self.noAlertsLabel.hidden = false
                self.tableView.hidden = true
            }
            
        }, failed: { (error) -> () in
            let alertMessage = UIAlertController(title: nil, message: "Error.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("there are \(alerts.count) unread alerts")
        return self.alerts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AlertTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("alert_cell") as! AlertTableViewCell
        
        let alert:PFObject = alerts[indexPath.row]
        let chatMessage:PFObject = alert[PJALERT.chatMessage] as! PFObject
        let conversation:PFObject = chatMessage[PJCHATMESSAGE.conversation] as! PFObject
        let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(post.createdAt!))
        if post[PJPOST.createdBy] as? String == PFUser.currentUser()!.objectId! {
            cell.postedAt.text = "Created by me on \(cell.postedAt.text!)"
        } else {
            let user = PFQuery.getUserObjectWithId(post[PJPOST.createdBy] as! String)
            if !PFAnonymousUtils.isLinkedWithUser(user) {
                cell.postedAt.text = "guest \(cell.postedAt.text!)"
            } else {
                cell.postedAt.text = "\((user?.username)!) \(cell.postedAt.text!)"
            }
        }
        
        cell.postBody.text = post[PJPOST.body] as? String
        
        cell.chattedAt.text = String(format: "%@", df.stringFromDate(chatMessage.createdAt!))
        if chatMessage[PJCHATMESSAGE.createdBy] as? String == PFUser.currentUser()!.objectId! {
            cell.chattedAt.text = "Replied by me on \(cell.chattedAt.text!)"
        } else {
            let user = PFQuery.getUserObjectWithId(chatMessage[PJCHATMESSAGE.createdBy] as! String)
            if !PFAnonymousUtils.isLinkedWithUser(user) {
                cell.chattedAt.text = "guest \(cell.chattedAt.text!)"
            } else {
                cell.postedAt.text = "\((user?.username)!) \(cell.postedAt.text!)"
            }
        }
        
        cell.lastChatBody.text = chatMessage[PJCHATMESSAGE.body] as? String
        
        if alert[PJALERT.read] as! Bool == false {
            cell.backgroundColor = UIColor(rgb: 0xFFCC66)
        }
        
        return cell
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        NSLog("prepareForSegue \(segue.identifier!)")
        if segue.identifier == "show_post" {
            let postDetailsViewController:PostDetailsViewController = segue.destinationViewController as! PostDetailsViewController

            let indexPath = self.tableView.indexPathForSelectedRow()!
            NSLog("indexpath row1: \(indexPath.row)")
            let alert:PFObject = self.alerts[indexPath.row]
            alert[PJALERT.read] = true
            alert.saveInBackgroundWithBlock(nil)
            let chatMessage:PFObject = alert[PJALERT.chatMessage] as! PFObject
            let conversation:PFObject = chatMessage[PJCHATMESSAGE.conversation] as! PFObject
            let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
            
            postDetailsViewController.titleText = "Alert"
            postDetailsViewController.conversation = conversation
            postDetailsViewController.post = post
            
        }
    }
    
    @IBAction func unwindAndSaveEditedPost (segue : UIStoryboardSegue) {
        retrieveMyAlerts()
    }

}
