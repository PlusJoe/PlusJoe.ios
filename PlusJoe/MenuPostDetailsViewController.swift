//
//  MenuPostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuPostDetailsViewController: UIViewController {
    
    @IBOutlet weak var alerts: UIButton!
    @IBOutlet weak var alertsCount: UILabel!
    @IBOutlet weak var flagInapproproate: UIButton!
    @IBOutlet weak var buyIt: UIButton!
    @IBOutlet weak var buyItLabel: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var shareAndEarn: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts.setTitle("\u{f0a2}", forState: UIControlState.Normal)
        flagInapproproate.setTitle("\u{f05e}", forState: UIControlState.Normal)
        buyIt.setTitle("\u{f155}", forState: UIControlState.Normal)
        bookmark.setTitle("\u{f097}", forState: UIControlState.Normal)
        shareAndEarn.setTitle("\u{f0d6}", forState: UIControlState.Normal)
        chat.setTitle("\u{f0e6}", forState: UIControlState.Normal)
        
     
        alertsCount.text = String(22)
//        alertsCount.hidden = true
        
    }
}
