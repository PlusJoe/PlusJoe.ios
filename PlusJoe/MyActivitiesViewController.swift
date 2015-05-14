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
    
    
    var conversations:[PFObject] = [PFObject]()
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
        
        retrieveMyActivities()
        retreiveMyPosts()
    }
    
    func retrieveMyActivities() -> Void {
        PJConversation.loadConversationsImPartOf({ (conversations) -> () in
            if conversations.count > 0 {
                self.conversations = conversations
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
            NSLog("there are \(conversations.count) conversations I'm part of")
            return self.conversations.count
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            NSLog("there are \(myPosts.count) my posts")
            return self.myPosts.count
        } else {
            return 0 // this will never be reached anyways
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ActivityTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("activity_cell") as! ActivityTableViewCell
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            let conversation:PFObject = conversations[indexPath.row]
            let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
            
            let df = NSDateFormatter()
            df.dateFormat = "MM-dd-yyyy hh:mm a"
            cell.postedAt.text = String(format: "%@", df.stringFromDate(conversation.updatedAt!))
            
            cell.body.text = post[PJPOST.body] as? String
        } else if(segmentedControl.selectedSegmentIndex == 1) {
            let post:PFObject = myPosts[indexPath.row]
            
            let df = NSDateFormatter()
            df.dateFormat = "MM-dd-yyyy hh:mm a"
            cell.postedAt.text = String(format: "%@", df.stringFromDate(post.updatedAt!))
            
            cell.body.text = post[PJPOST.body] as? String
        }
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        NSLog("prepareForSegue \(segue.identifier!)")
        if segue.identifier == "show_post" {
            let postDetailsViewController:PostDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            NSLog("indexpath row1: \(indexPath.row)")
            let conversation:PFObject = self.conversations[indexPath.row]
            let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
            
            postDetailsViewController.titleText = "I'm a chatting in"
            postDetailsViewController.conversation = conversation
            postDetailsViewController.post = post
            
        }
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        NSLog("selected segment: \(segmentedControl.selectedSegmentIndex)")
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    }
}
