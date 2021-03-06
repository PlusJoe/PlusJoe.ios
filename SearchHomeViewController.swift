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

    @IBOutlet weak var sellButton: UIButton!
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

    @IBAction func sellButtonAction(sender: AnyObject) {
        if PJPurchase.arePendingPurchasesPresent() {
            let sellViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SellViewController") as! SellViewController
            self.presentViewController(sellViewController, animated: true, completion: nil)
            
        } else {
            let createPostDescribeStepViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("CreatePostDescribeStepViewController") as! CreatePostDescribeStepViewController
            self.presentViewController(createPostDescribeStepViewController, animated: true, completion: nil)
        }
    }

    
    func updateAlertsView() -> Void {
        if UNREAD_ALERTS_COUNT == 0 {
            self.alertsCountLabel.hidden = true
        } else {
            self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
            self.alertsCountLabel.hidden = false
        }
        if PENDING_SALES_PRESENT == true {
            addPulseAnimation(sellButton.layer)
        } else {
            removePulseAnimation(sellButton.layer)
        }

    }
    

    // this method is called when done button is clicked in the create new sell workflow
    @IBAction func unwindAndSaveNewPost (segue : UIStoryboardSegue) {
        NSLog("SearchPosts seque from segue id: \(segue.identifier)")
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.view.addSubview(actInd)
        self.view.backgroundColor = UIColor.grayColor()
        actInd.startAnimating()
        
        
        UNFINISHED_POST?[PJPOST.active] = true
        UNFINISHED_POST?.save()
        
        
        PJPost.notifyBookmarksAboutNewPost(UNFINISHED_POST!,
            succeeded: { () -> () in
                actInd.stopAnimating()
            }) { (error) -> () in
                actInd.stopAnimating()
                let alertMessage = UIAlertController(title: nil, message: "Error.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        UNFINISHED_POST = nil
        actInd.stopAnimating()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updateAlertsView"), userInfo: nil, repeats: true)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        menuButton.setTitle("\u{f0c9}", forState: .Normal)
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
        updateAlertsView()
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
        NSLog("searching for text: " + searchTextField.text!); //the textView parameter is the textView where text was changed
        PJHashTag.autoComplete(CURRENT_LOCATION!, searchText: searchTextField.text!, succeeded: { (results) -> () in
            
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
        
        let cell = autocompleteTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        cell.textLabel?.text = self.completions[indexPath.row]
        cell.textLabel?.textColor = UIColor(rgb: 0xff8000)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        autocompleteTableView.hidden = true
        print("You selected cell #\(self.completions[indexPath.row])!")
        searchTextField.text = self.completions[indexPath.row]
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchResults") {
            let searchResutsViewController = segue.destinationViewController as! SearchResultsViewController
            searchResutsViewController.searchString = searchTextField.text!
        }
    }
    
    
    
    @IBAction func menuTapped(sender: AnyObject) {
        self.alertsCountLabel.hidden = true

        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("MenuSearchHome") as! MenuSearchHomeViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(200, 200)
        
        
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

