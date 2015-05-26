//
//  SearchHomeMenuViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuSearchHomeViewController: UIViewController {
    
    @IBOutlet weak var followings: UIButton!
    @IBOutlet weak var createNewPost: UIButton!
    @IBOutlet weak var myActivity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followings.setTitle("\u{f02c}", forState: UIControlState.Normal)
        createNewPost.setTitle("\u{f0fe}", forState: UIControlState.Normal)
        myActivity.setTitle("\u{f0c5}", forState: UIControlState.Normal)
    }
    
    
}
