//
//  BookmarksViewController.swift
//  PlusJoe
//
//  Created by D on 5/15/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class FollowingHashTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newFollowing: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFollowingsLabel: UILabel!
    @IBOutlet weak var addNewFollowingButton: UIButton!
    
    
    var followings:[PFObject] = [PFObject]()
    
    
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
        
        addNewFollowingButton.setTitle("Add \u{f02b}", forState: .Normal)
        
        
        retrieveFollowings()
    }
    
    func retrieveFollowings() -> Void {
        PJFollowing.loadHashTagsImFollowing({ (hashTags) -> () in
            if hashTags.count > 0 {
                self.followings = hashTags
                self.tableView.reloadData()
                self.tableView.reloadInputViews()
                self.noFollowingsLabel.hidden = true
                self.tableView.hidden = false
            } else {
                self.noFollowingsLabel.hidden = false
                self.tableView.hidden = true
            }
            },
            failed: { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Error loading Bookmarks.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("there are \(followings.count) followings")
        return self.followings.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FollowingHashTagsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("following_cell") as! FollowingHashTagsTableViewCell
        
        let following:PFObject = followings[indexPath.row]
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(following.createdAt!))
        
        cell.hashTag.text = following[PJFOLLOWING.hashTag] as? String
        cell.deleteButton.setTitle("\u{f1f8}", forState: UIControlState.Normal)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: "deleteFollowingAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func deleteFollowingAction(sender:UIButton!) {
        let deleteButton:UIButton = sender as UIButton!
        let buttonRow:Int = sender.tag
        NSLog("button clicked: \(buttonRow)")
        let bookmarkObject = followings[buttonRow]
        
        
        let alertMessage = UIAlertController(title: nil, message: "Are you sure you want to delete a hashtag your are following?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            bookmarkObject.delete()
            self.followings.removeAtIndex(buttonRow)
            self.tableView.reloadData()
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
    }
    
    @IBAction func addNewBookmark(sender: AnyObject) {
        if newFollowing.text.isEmpty {
            return
        }
        PJFollowing.createOrUpdateTagsImFollowing(newFollowing.text,
            succeeded: { (succeeds) -> () in
                self.retrieveFollowings()
            }) { (error) -> () in
                self.retrieveFollowings()
        }
        
        newFollowing.text! = ""
    }
}
