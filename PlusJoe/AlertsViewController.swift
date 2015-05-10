//
//  AlertsViewController.swift
//  PlusJoe
//
//  Created by D on 5/8/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class AlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alerts:[PJAlert] = [PJAlert]()

    
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
        let alert = alerts[indexPath.row]
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(alert.createdAt!))
        
        cell.body.text = alert.chatMessage.body
        
        cell.postedAt.text = "\(cell.postedAt.text!)"
        
        
        return cell
    }

}
