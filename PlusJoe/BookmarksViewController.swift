//
//  BookmarksViewController.swift
//  PlusJoe
//
//  Created by D on 5/15/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

class BookrmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBookmarksLabel: UILabel!
    
    
    var bookmarks:[PFObject] = [PFObject]()
    
    
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
        PJBookmark.loadUMyBookmarks({ (bookmarks) -> () in
            if bookmarks.count > 0 {
                self.bookmarks = bookmarks
                self.tableView.reloadData()
                self.tableView.reloadInputViews()
                self.noBookmarksLabel.hidden = true
                self.tableView.hidden = false
            } else {
                self.noBookmarksLabel.hidden = false
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
        NSLog("there are \(bookmarks.count) bookmarks")
        return self.bookmarks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:BookmarkTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("bookmark_cell") as! BookmarkTableViewCell
        
        let bookmark:PFObject = bookmarks[indexPath.row]
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        cell.postedAt.text = String(format: "%@", df.stringFromDate(bookmark.createdAt!))
        
        cell.hashTag.text = bookmark[PJBOOKMARK.hashTag] as? String
        cell.deleteButton.setTitle("\u{f1f8}", forState: UIControlState.Normal)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: "deleteBookmarkAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func deleteBookmarkAction(sender:UIButton!) {
        let deleteButton:UIButton = sender as UIButton!
        let buttonRow:Int = sender.tag
        NSLog("button clicked: \(buttonRow)")
        let bookmarkObject = bookmarks[buttonRow]

        
        let alertMessage = UIAlertController(title: nil, message: "Are you sure you want to delete bookmark?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            bookmarkObject.delete()
            self.bookmarks.removeAtIndex(buttonRow)
            self.tableView.reloadData()
        })
        alertMessage.addAction(cancel)
        alertMessage.addAction(ok)
        self.presentViewController(alertMessage, animated: true, completion: nil)
        
    }

}
