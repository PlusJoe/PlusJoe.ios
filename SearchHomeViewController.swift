//
//  SearchViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class SearchHomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!

    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var alertsCountLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    
    var completions = [String]()
    
    var timer:NSTimer?

    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateAlertsView() -> Void {
        if UNREAD_ALERTS_COUNT == 0 {
            self.alertsCountLabel.hidden = true
        } else {
            self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
            self.alertsCountLabel.hidden = false
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updateAlertsView"), userInfo: nil, repeats: true)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        menuButton.setTitle("\u{f0c9}", forState: .Normal)
        alertButton.setTitle("\u{f0a2}", forState: .Normal)
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        
        searchButton.setTitle("Search   \u{f002}",forState: UIControlState.Normal)
        searchTextField.becomeFirstResponder()

       
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
    
    
    
    @IBAction func menuTapped(sender: AnyObject) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("MenuSearchHome") as! MenuSearchHomeViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(200, 180)
        
        
        let popoverPresentationViewController = popoverVC.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.Any
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView =             menuButton
        popoverPresentationViewController?.sourceRect =             menuButton.bounds
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

