//
//  SearchHomeMenuViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuSearchHomeViewController: UIViewController {
    
    @IBOutlet weak var alerts: UIButton!
    @IBOutlet weak var alertsCount: UILabel!
    @IBOutlet weak var bookmarks: UIButton!
    @IBOutlet weak var createNewPost: UIButton!
    @IBOutlet weak var myPosts: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts.setTitle("\u{f0a2}", forState: UIControlState.Normal)
        bookmarks.setTitle("\u{f097}", forState: UIControlState.Normal)
        createNewPost.setTitle("\u{f0fe}", forState: UIControlState.Normal)
        myPosts.setTitle("\u{f0c5}", forState: UIControlState.Normal)
        
        
        alertsCount.text = String(7)
//        alertsCount.hidden = true
    }
}
