//
//  MyActivitiesViewController.swift
//  PlusJoe
//
//  Created by D on 5/12/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class MyActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noActivitiesLabel: UILabel!
    
    
    var myAlerts:[PFObject] = [PFObject]()
    var myPosts:[PFObject] = [PFObject]()
    
    
    
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
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        retrieveMyAlerts()
        retreiveMyPosts()
    }
    
    func retrieveMyAlerts() -> Void {
        PJAlert.loadMyAlerts({ (alerts) -> () in
            if alerts.count > 0 {
                self.myAlerts = alerts
                self.tableView.reloadData()
                self.tableView.reloadInputViews()
                self.noActivitiesLabel.hidden = true
                self.tableView.hidden = false
            } else {
                self.noActivitiesLabel.hidden = false
                self.tableView.hidden = true
            }
            
            }, failed: { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Error loading myAlerts.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }
    
    
    func retreiveMyPosts() -> Void {
        PJPost.loadMyPosts({ (posts) -> () in
            if posts.count > 0 {
                self.myPosts = posts
                self.tableView.reloadData()
                self.tableView.reloadInputViews()
                self.noActivitiesLabel.hidden = true
                self.tableView.hidden = false
            } else {
                self.noActivitiesLabel.hidden = false
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
        if(segmentedControl.selectedSegmentIndex == 0) {
            NSLog("there are \(myAlerts.count) conversations I'm part of")
            return self.myAlerts.count
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            NSLog("there are \(myPosts.count) my posts")
            return self.myPosts.count
        } else {
            return 0 // this will never be reached anyways
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(segmentedControl.selectedSegmentIndex == 0) {
            var cell:MyAlertTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("myalert_cell") as! MyAlertTableViewCell
            
            let alert:PFObject = myAlerts[indexPath.row]
            let chatMessage:PFObject = alert[PJALERT.chatMessage] as! PFObject
            let conversation:PFObject = chatMessage[PJCHATMESSAGE.conversation] as! PFObject
            let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
            
            
            let df = NSDateFormatter()
            df.dateFormat = "MM-dd-yyyy hh:mm a"
            cell.postedAt.text = String(format: "%@", df.stringFromDate(post.createdAt!))
            if post[PJPOST.createdBy] as? PFUser == CURRENT_USER! {
                cell.postedAt.text = "Created by me on \(cell.postedAt.text!)"
            } else {
                cell.postedAt.text = "Someone created on \(cell.postedAt.text!)"
            }
            
            cell.postBody.text = post[PJPOST.body] as? String
            
            cell.chattedAt.text = String(format: "%@", df.stringFromDate(chatMessage.createdAt!))
            if chatMessage[PJCHATMESSAGE.createdBy] as? PFUser == CURRENT_USER! {
                cell.chattedAt.text = "Replied by me on \(cell.chattedAt.text!)"
            } else {
                cell.chattedAt.text = "Someone replied on \(cell.chattedAt.text!)"
            }
            
            cell.lastChatBody.text = chatMessage[PJCHATMESSAGE.body] as? String
            return cell
            
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            var cell:MyPostTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("mypost_cell") as! MyPostTableViewCell

            
            let post:PFObject = myPosts[indexPath.row]
            
            let df = NSDateFormatter()
            df.dateFormat = "MM-dd-yyyy hh:mm a"
            cell.postedAt.text = String(format: "%@", df.stringFromDate(post.updatedAt!))
            
            cell.body.text = post[PJPOST.body] as? String

            return cell
        }
        // it will never reach here
        return UITableViewCell()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        NSLog("prepareForSegue \(segue.identifier!)")
        if segue.identifier == "show_mypost" || segue.identifier == "show_myalert" {
            let postDetailsViewController:PostDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            NSLog("indexpath row1: \(indexPath.row)")
            
            if(segmentedControl.selectedSegmentIndex == 0) {
                let alert:PFObject = self.myAlerts[indexPath.row]
                alert[PJALERT.read] = true
                alert.saveInBackgroundWithBlock(nil)
                let chatMessage:PFObject = alert[PJALERT.chatMessage] as! PFObject
                let conversation:PFObject = chatMessage[PJCHATMESSAGE.conversation] as! PFObject
                let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
                
                postDetailsViewController.titleText = "I'm Alerted"
                postDetailsViewController.conversation = conversation
                postDetailsViewController.post = post
            } else if(segmentedControl.selectedSegmentIndex == 1) {
                let post:PFObject = self.myPosts[indexPath.row]
                
                postDetailsViewController.titleText = "I posted"
                postDetailsViewController.post = post
            }
            
        }
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        NSLog("selected segment: \(segmentedControl.selectedSegmentIndex)")
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    }
}
