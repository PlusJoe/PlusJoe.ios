//
//  HomeViewController.swift
//  PlusJoe
//
//  Created by D on 4/6/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var searchButton: UIButton!
 
    @IBAction func unwindToHome (segue : UIStoryboardSegue) {
        NSLog("SearchPosts seque from segue id: \(segue.identifier)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchButton.setTitle("Go Do It   \u{f164}",forState: UIControlState.Normal)
        
    }
    
    
}

