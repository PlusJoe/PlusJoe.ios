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
    @IBOutlet weak var bookmarks: UIButton!
    @IBOutlet weak var createNewPost: UIButton!
    @IBOutlet weak var myPosts: UIButton!
    @IBOutlet weak var myChats: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts.setTitle("\((alerts.titleLabel!.text)!)   \u{f0a2}", forState: UIControlState.Normal)
        bookmarks.setTitle("\((bookmarks.titleLabel!.text)!)   \u{f097}", forState: UIControlState.Normal)
        createNewPost.setTitle("\((createNewPost.titleLabel!.text)!)   \u{f0fe}", forState: UIControlState.Normal)
        myPosts.setTitle("\((myPosts.titleLabel!.text)!)   \u{f0c5}", forState: UIControlState.Normal)
        myChats.setTitle("\((myChats.titleLabel!.text)!)   \u{f0e6}", forState: UIControlState.Normal)
        
        
        var lbl_card_count:UILabel?
        lbl_card_count = UILabel(frame: CGRectMake(215,0, 13, 13))
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
