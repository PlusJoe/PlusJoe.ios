//
//  CreatePostFindersFeeStepViewController.swift
//  PlusJoe
//
//  Created by D on 5/1/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class CreatePostFindersFeeStepViewController:
    UIViewController {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var findersFeeTextField: UITextField!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonAction(sender: AnyObject) {
        UNFINISHED_POST.fee = findersFeeTextField.text.toInt()!
        UNFINISHED_POST?.saveEventually(nil)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        findersFeeTextField.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        nextButton.setTitle("next" + "   \u{f054}", forState: UIControlState.Normal)
    
        findersFeeTextField.text = "\(UNFINISHED_POST.fee)"
    }
    
        
}
