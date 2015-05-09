//
//  SearchHomeMenuViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuSearchHomeViewController: UIViewController {
    
    @IBOutlet weak var bookmarks: UIButton!
    @IBOutlet weak var createNewPost: UIButton!
    @IBOutlet weak var myActivity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarks.setTitle("\u{f097}", forState: UIControlState.Normal)
        createNewPost.setTitle("\u{f0fe}", forState: UIControlState.Normal)
        myActivity.setTitle("\u{f0c5}", forState: UIControlState.Normal)
    }
    
    
}
