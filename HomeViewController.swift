//
//  HomeViewController.swift
//  PlusJoe
//
//  Created by D on 4/6/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var signedInAsLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchButton.setTitle("Go Do It   \u{f164}",forState: UIControlState.Normal)

        if PFAnonymousUtils.isLinkedWithUser(CURRENT_USER!) {
            signedInAsLabel.text = "Signed in as guest"
        } else {
            signedInAsLabel.text = "Signed in as \((CURRENT_USER?.username)!)"
        }
        
    }
    
    @IBAction func unwindFromRegistration (segue : UIStoryboardSegue) {
    }
}

