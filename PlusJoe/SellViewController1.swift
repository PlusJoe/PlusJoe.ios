//
//  SellViewController1.swift
//  PlusJoe
//
//  Created by D on 6/25/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse


class SellViewController1: UIViewController {
    
    var purchase:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // here, let's check if the seller has stripe account, and if not, have then register
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=\(STRIPE_CLIENT_ID)&scope=read_write")!)
    }
    
    
}
