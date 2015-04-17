//
//  SearchDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 4/16/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class SearchDetailsViewController : UIViewController {
    
    @IBOutlet weak var postBody: UILabel!
    
    var postBodyText = ""
    
    
    var postIndex:UInt = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("SearchDetailsViewController viewDidLoad")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("SearchDetailsViewController viewDidAppear")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        postBody.text = postBodyText
    }
}
