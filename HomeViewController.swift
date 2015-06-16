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
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        searchButton.setTitle("Go Do It   \u{f164}",forState: UIControlState.Normal)

        // if there is no current user, sign in as guest
        if  PFUser.currentUser() == nil {
            PFAnonymousUtils.logInWithBlock {
                (user: PFUser?, error: NSError?) -> Void in
                if error != nil || user == nil {
                    NSLog("Anonymous login failed.")
                } else {
                    NSLog("Anonymous user logged in.")
                    self.signedInAsLabel.text = "Signed in as guest"
                    getAlerts()
                }
            }
        } else {
            // the user is already signed in and it's a guest
            getAlerts()
            // the user is already signed in and it's a guest
            if PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser()) {
                signedInAsLabel.text = "Signed in as guest"
            } else {
                signedInAsLabel.text = "Signed in as \((PFUser.currentUser()!.username)!)"
            }
        }
    }
    
    @IBAction func unwindFromRegistration (segue : UIStoryboardSegue) {
    }
}

