//
//  SearchResultsViewController.swift
//  PlusJoe
//
//  Created by D on 4/10/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    var searchString = ""
    
    @IBOutlet weak var searchingForLabel: UILabel!
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 30) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        searchingForLabel.text = "Searching for: \(searchString)"
    }
    
}
