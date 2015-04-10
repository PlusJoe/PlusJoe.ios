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
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    
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
        createButton.title = "\u{f067}"
        if let font = UIFont(name: "FontAwesome", size: 30) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            createButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
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
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        autocompleteTableView.hidden = true
        println("You selected cell #\(self.completions[indexPath.row])!")
        searchTextField.text = self.completions[indexPath.row]        
    }
    
    
}

