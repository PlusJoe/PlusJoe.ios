//
//  AlertsViewController.swift
//  PlusJoe
//
//  Created by D on 5/8/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class AlertsViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource */{
    
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
    }
    
}
