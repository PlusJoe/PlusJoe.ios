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
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        retrieveUnreadAlerts()
    }
    
    func retrieveUnreadAlerts() -> Void {
        PJAlert.loadUnreadAlerts({ (alerts) -> () in
            self.alerts = alerts
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            
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
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(alert.createdAt!))
        
        
        cell.body.text = chatMessage[PJCHATMESSAGE.body] as? String
        
        cell.postedAt.text = "\(cell.postedAt.text!)"
        
        return cell
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        NSLog("prepareForSegue \(segue.identifier!)")
        if segue.identifier == "show_post" {
            let postDetailsViewController:PostDetailsViewController = segue.destinationViewController as! PostDetailsViewController

            let indexPath = self.tableView.indexPathForSelectedRow()!
            NSLog("indexpath row1: \(indexPath.row)")
            let alert:PFObject = self.alerts[indexPath.row]
            let chatMessage:PFObject = alert[PJALERT.chatMessage] as! PFObject
            let conversation:PFObject = chatMessage[PJCHATMESSAGE.conversation] as! PFObject
            let post:PFObject = conversation[PJCONVERSATION.post] as! PFObject
            
            postDetailsViewController.conversation = conversation
            postDetailsViewController.post = post
        }
    }
}
