//
//  CreatePostStepOneViewController.swift
//  PlusJoe
//
//  Created by D on 3/26/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//


import UIKit

class CreatePostStepOneViewController: UIViewController {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var thingButton: UIButton!
    @IBOutlet weak var serviceButton: UIButton!

    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        
        thingButton.hidden = true
        serviceButton.hidden = true
        nextButton.hidden = true
        
        nextButton.setTitle("next" + "   \u{f054}", forState: UIControlState.Normal)
    }
    
    @IBAction func sellButtonAction(sender: AnyObject) {
        sellButton.backgroundColor = UIColor.greenColor()
        buyButton.backgroundColor = UIColor.whiteColor()
        
        sellButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buyButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        thingButton.hidden = false
        serviceButton.hidden = false
    }
    
    @IBAction func buyButtonAction(sender: AnyObject) {
        buyButton.backgroundColor = UIColor.greenColor()
        sellButton.backgroundColor = UIColor.whiteColor()

        buyButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sellButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        thingButton.hidden = false
        serviceButton.hidden = false
    }
    
    @IBAction func thingButtonAction(sender: AnyObject) {
        thingButton.backgroundColor = UIColor.greenColor()
        serviceButton.backgroundColor = UIColor.whiteColor()
        
        thingButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        serviceButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        nextButton.hidden = false
    }
    
    @IBAction func serviceButtonAction(sender: AnyObject) {
        serviceButton.backgroundColor = UIColor.greenColor()
        thingButton.backgroundColor = UIColor.whiteColor()
        
        serviceButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        thingButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        
        nextButton.hidden = false
    }
    
    
}

