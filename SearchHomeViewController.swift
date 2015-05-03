//
//  SearchViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class SearchHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var alertsButton: UIButton!
    var lbl_card_count:UILabel?
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!

    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    
    var completions = [String]()
    
    
    
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
        
        
        alertsButton.setTitle("\u{f0f3}", forState: .Normal)
        lbl_card_count = UILabel(frame: CGRectMake(23,0, 13, 13))
        lbl_card_count!.textColor = UIColor.whiteColor()
        lbl_card_count!.textAlignment = NSTextAlignment.Center
        lbl_card_count!.text = "22"
        lbl_card_count!.layer.borderWidth = 1;
        lbl_card_count!.layer.cornerRadius = 4;
        lbl_card_count!.layer.masksToBounds = true
        lbl_card_count!.layer.borderColor = UIColor.clearColor().CGColor
        lbl_card_count!.layer.shadowColor = UIColor.clearColor().CGColor
        lbl_card_count!.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lbl_card_count!.layer.shadowOpacity = 0.0;
        lbl_card_count!.backgroundColor = UIColor.redColor()
        lbl_card_count!.font = UIFont(name: "ArialMT", size: 10)
        menuView.addSubview(lbl_card_count!)
        lbl_card_count!.hidden = false
        
        
        
        menuButton.setTitle("\u{f0c9}", forState: .Normal)

        
        
        searchButton.setTitle("Search   \u{f002}",forState: UIControlState.Normal)
        searchTextField.becomeFirstResponder()

        createButton.setTitle("\u{f067}", forState: .Normal)
        bookmarkButton.setTitle("\u{f097}",forState: UIControlState.Normal)
       
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: searchTextField
        )
        
        autocompleteTableView.hidden = true
        autocompleteTableView.delegate      =   self
        autocompleteTableView.dataSource    =   self
        

    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CURRENT_LOCATION == nil {
            let alertMessage = UIAlertController(title: nil, message: "Your current location cant be detected. Turn GPS on, and/or enable PlusJoe GPS access in preferences and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertMessage.addAction(ok)
            presentViewController(alertMessage, animated: true, completion: nil)
        }

    }
    
    func textFieldTextChanged(sender : AnyObject) {
        NSLog("searching for text: " + searchTextField.text); //the textView parameter is the textView where text was changed
        PJHashTag.autoComplete(CURRENT_LOCATION!, searchText: searchTextField.text, succeeded: { (results) -> () in
            
            self.autocompleteTableView.hidden = false
            self.completions = results
            self.autocompleteTableView.reloadData()
            self.autocompleteTableView.reloadInputViews()
            
        }) { (error) -> () in
            NSLog("error autocompleting")
        }
    }
 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = autocompleteTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.completions[indexPath.row]
        cell.textLabel?.textColor = UIColor(rgb: 0xff8000)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        autocompleteTableView.hidden = true
        println("You selected cell #\(self.completions[indexPath.row])!")
        searchTextField.text = self.completions[indexPath.row]
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchResults") {
            var searchResutsViewController = segue.destinationViewController as! SearchResultsViewController
            searchResutsViewController.searchString = searchTextField.text
        }
    }
    
    
    
    @IBAction func actionsTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.view.tintColor = UIColor(rgb: 0xff8000)

        
        let showMyAlerts = UIAlertAction(title: "my Alerts", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(showMyAlerts)
        

        let showMyBookmarks = UIAlertAction(title: "my Bookmarks", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(showMyBookmarks)

        
        let showMyPosts = UIAlertAction(title: "my Posts", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(showMyPosts)
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
}

