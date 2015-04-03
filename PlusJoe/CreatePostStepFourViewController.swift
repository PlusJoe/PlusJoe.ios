//
//  CreatePostStepFourViewController.swift
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit

class CreatePostStepFourViewController: UIViewController {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var buySellThingServiceLabel: UILabel!
    @IBOutlet weak var hashTagsLabel: UILabel!
    @IBOutlet weak var postBodyTextView: UITextView!
    
    @IBOutlet weak var postMap: MKMapView!
    
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
        
        nextButton.setTitle("done" + "   \u{f046}", forState: UIControlState.Normal)
        
        
        
        
        let label1 = UILabel()//frame: CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width-20.0, 20))
        label1.setTranslatesAutoresizingMaskIntoConstraints(false)
        label1.font = UIFont(name: "Helvetica Neue", size: 12)
        if UNFINISHED_POST?.sell == false && UNFINISHED_POST?.thing == false {
            label1.text = "You wish to hire a service for $\((UNFINISHED_POST?.pricetags[0])!)"
        } else
        if UNFINISHED_POST?.sell == false && UNFINISHED_POST?.thing == true {
            label1.text = "You wish to buy something for $\((UNFINISHED_POST?.pricetags[0])!)"
        } else
        if UNFINISHED_POST?.sell == true && UNFINISHED_POST?.thing == false {
            label1.text = "You wish to offer a service for $\((UNFINISHED_POST?.pricetags[0])!)"
        } else
        if UNFINISHED_POST?.sell == true && UNFINISHED_POST?.thing == true {
            label1.text = "You wish to sell something for $\((UNFINISHED_POST?.pricetags[0])!)"
        }
        contentView.addSubview(label1)

        let label2 = UILabel()
        label2.setTranslatesAutoresizingMaskIntoConstraints(false)
        label2.font = UIFont(name: "Helvetica Neue", size: 12)
        label2.text = "It will be searchable by following tags:"
        contentView.addSubview(label2)

        let label3 = UILabel()
        label3.text = ""
        label3.setTranslatesAutoresizingMaskIntoConstraints(false)
        label3.font = UIFont(name: "Helvetica Neue", size: 12)
        for hashtag in (UNFINISHED_POST?.hashtags)! {
            label3.text = label3.text! + ", " + hashtag
        }
        contentView.addSubview(label3)

        label1.layer.cornerRadius=5
        label1.layer.borderWidth=1
        label2.layer.cornerRadius=5
        label2.layer.borderWidth=1
        label3.layer.cornerRadius=5
        label3.layer.borderWidth=1

        
        

        var viewsDict = Dictionary <String, UIView>()
        viewsDict["label1"] = label1
        viewsDict["label2"] = label2
        viewsDict["label3"] = label3

        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[label1]-|", options: nil, metrics: nil, views: viewsDict))
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[label2]-|",
                options: nil, metrics: nil, views: viewsDict))
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[label3]-|",
                options: nil, metrics: nil, views: viewsDict))
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[label1][label2][label3]-|", options: nil, metrics: nil,
                views: viewsDict))
        
        
        
        contentView.layer.cornerRadius=5
        contentView.layer.borderWidth=1

    }

//    override func viewDidLayoutSubviews() {
//
//        // Force the text view to resize to fit its content
//
//        super.viewDidLayoutSubviews()
//        self.scrollView.layoutIfNeeded()
//        self.scrollView.contentSize = self.postBodyTextView.bounds.size
//
//
//    }
    

    
    
}
