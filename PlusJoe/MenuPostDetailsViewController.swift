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
    @IBOutlet weak var flagInapproproate: UIButton!
    @IBOutlet weak var buyIt: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var shareAndEarn: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts.setTitle("\((alerts.titleLabel!.text)!)   \u{f0a2}", forState: UIControlState.Normal)
        flagInapproproate.setTitle("\((flagInapproproate.titleLabel!.text)!)   \u{f05e}", forState: UIControlState.Normal)
        buyIt.setTitle("\((buyIt.titleLabel!.text)!)   \u{f155}", forState: UIControlState.Normal)
        bookmark.setTitle("\((bookmark.titleLabel!.text)!)   \u{f02e}", forState: UIControlState.Normal)
        shareAndEarn.setTitle("\((shareAndEarn.titleLabel!.text)!)   \u{f0d6}", forState: UIControlState.Normal)
        chat.setTitle("\((chat.titleLabel!.text)!)   \u{f086}", forState: UIControlState.Normal)
        
        
        
        
        var lbl_card_count:UILabel?
        lbl_card_count = UILabel(frame: CGRectMake(315,0, 13, 13))
        lbl_card_count!.textColor = UIColor.whiteColor()
        lbl_card_count!.textAlignment = NSTextAlignment.Center
        lbl_card_count!.layer.borderWidth = 1;
        lbl_card_count!.layer.cornerRadius = 4;
        lbl_card_count!.layer.masksToBounds = true
        lbl_card_count!.layer.borderColor = UIColor.clearColor().CGColor
        lbl_card_count!.layer.shadowColor = UIColor.clearColor().CGColor
        lbl_card_count!.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lbl_card_count!.layer.shadowOpacity = 0.0;
        lbl_card_count!.backgroundColor = UIColor.redColor()
        lbl_card_count!.font = UIFont(name: "ArialMT", size: 10)
        alerts.addSubview(lbl_card_count!)
        lbl_card_count!.hidden = false
        lbl_card_count!.text = "22"
        
    }
}
