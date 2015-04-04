//
//  SearchViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    
    @IBAction func unwindToHome (segue : UIStoryboardSegue) {
        NSLog("SearchPosts seque from segue id: \(segue.identifier)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createButton.title = "\u{f067}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            createButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
    }
    
    
}

