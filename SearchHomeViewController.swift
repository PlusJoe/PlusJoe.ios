//
//  SearchViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class SearchHomeViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var searchButton: UIButton!
    
    
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

    }
    
    func textFieldTextChanged(sender : AnyObject) {
        NSLog("searching for text: " + searchTextField.text); //the textView parameter is the textView where text was changed
        PJHashTag.autoComplete(CURRENT_LOCATION!, searchText: searchTextField.text, succeeded: { (results) -> () in
            let autoCompleteMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

            for result in results {
                NSLog( "completed to string: \(result)")

                let wordAction = UIAlertAction(title: result, style: .Default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    println("clicked: \(result)")
                })
                autoCompleteMenu.addAction(wordAction)
            }
            
            self.presentViewController(autoCompleteMenu, animated: true, completion: nil)

        }) { (error) -> () in
            NSLog("error autocompleting")
        }
        
        
    }
    
}

