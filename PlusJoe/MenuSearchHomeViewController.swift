//
//  SearchHomeMenuViewController.swift
//  PlusJoe
//
//  Created by D on 5/5/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class MenuSearchHomeViewController: UIViewController {
    
    @IBOutlet weak var alertsCountLabel: UILabel!
    @IBOutlet weak var myAlertsButton: UIButton!
    @IBOutlet weak var myTagsButton: UIButton!
    @IBOutlet weak var mySellsButton: UIButton!
    @IBOutlet weak var myBuysButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAlertsView()

        
        
        myAlertsButton.setTitle("\u{f0f3}", forState: UIControlState.Normal)
        myTagsButton.setTitle("\u{f02c}", forState: UIControlState.Normal)
        mySellsButton.setTitle("\u{f155}", forState: UIControlState.Normal)
        myBuysButton.setTitle("\u{f07a}", forState: UIControlState.Normal)

    }
    
    func updateAlertsView() -> Void {
        if UNREAD_ALERTS_COUNT == 0 {
            self.alertsCountLabel.hidden = true
        } else {
            self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
            self.alertsCountLabel.hidden = false
        }
    }

    
}
