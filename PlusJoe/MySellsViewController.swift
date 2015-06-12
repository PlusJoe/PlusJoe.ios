//
//  MyActivitiesViewController.swift
//  PlusJoe
//
//  Created by D on 5/12/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class MySellsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noActivitiesLabel: UILabel!
    
    
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
        
        retreiveMyPosts()
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
            NSLog("there are \(myPosts.count) my posts")
            return self.myPosts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:MySellTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("mysell_cell") as! MySellTableViewCell
        
        
        let post:PFObject = myPosts[indexPath.row]
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy hh:mm a"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(post.updatedAt!))
        
        cell.body.text = post[PJPOST.body] as? String
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        NSLog("prepareForSegue \(segue.identifier!)")
        if segue.identifier == "show_mypost" || segue.identifier == "show_myalert" {
            let postDetailsViewController:PostDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            NSLog("indexpath row1: \(indexPath.row)")
            
            let post:PFObject = self.myPosts[indexPath.row]
            
            postDetailsViewController.titleText = "I posted"
            postDetailsViewController.post = post
            
        }
    }
    
}
