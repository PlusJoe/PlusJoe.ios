//
//  CreatePostStepFourViewController.swift
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit

class CreatePostStepFourViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var contentView: UIView!
    
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
        
        nextButton.setTitle("done" + "   \u{f046}", forState: UIControlState.Normal)
        
        self.scrollView.pagingEnabled = true
        self.scrollView.alwaysBounceVertical = false
        
        let label1 = UILabel()//frame: CGRectMake(10, 10, UIScreen.mainScreen().bounds.size.width-20.0, 20))
        label1.setTranslatesAutoresizingMaskIntoConstraints(false)
        label1.font = UIFont(name: "Times-Bold", size: 12)
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
        label3.numberOfLines = 0
        label3.setTranslatesAutoresizingMaskIntoConstraints(false)
        label3.font = UIFont(name: "Times-Bold", size: 12)
        for var index = 0; index < (UNFINISHED_POST?.hashtags)!.count; ++index {
            label3.text = label3.text! + (UNFINISHED_POST?.hashtags[index])!
            if index < ((UNFINISHED_POST?.hashtags)!.count)-1  {
                label3.text = label3.text! + ", "
            }
        }
        contentView.addSubview(label3)

        let postBody = UITextView()
        postBody.setTranslatesAutoresizingMaskIntoConstraints(false)
        postBody.font = UIFont(name: "American TypeWriter", size: 14)
        postBody.sizeToFit()
        postBody.scrollEnabled = true
        postBody.text = UNFINISHED_POST?.body
        postBody.scrollEnabled = false
        postBody.userInteractionEnabled = false

        contentView.addSubview(postBody)

        let label4 = UILabel()
        label4.setTranslatesAutoresizingMaskIntoConstraints(false)
        label4.font = UIFont(name: "Helvetica Neue", size: 12)
        label4.text = "Here are some photos:"
        contentView.addSubview(label4)
        

        let image1 = UIView()
        image1.setTranslatesAutoresizingMaskIntoConstraints(false)
        if let imageFile1 = UNFINISHED_POST?.image1file.getData() {
            let image = UIImageView()
//            image.setTranslatesAutoresizingMaskIntoConstraints(false)
            image.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            image.image = UIImage(data: imageFile1)

            image.contentMode = .ScaleAspectFill
            image.sizeToFit()
            image.clipsToBounds = true
            image1.addSubview(image)
            contentView.addSubview(image1)
        }
        
        
        postBody.layer.cornerRadius=5
        postBody.layer.borderWidth=1
        label4.layer.cornerRadius=5
        label4.layer.borderWidth=1
        image1.layer.cornerRadius=5
        image1.layer.borderWidth=1
        contentView.layer.cornerRadius=5
        contentView.layer.borderWidth=1
        

        

        var viewsDict = Dictionary <String, UIView>()
        viewsDict["view"] = self.view
        viewsDict["scrollView"] = self.scrollView
        viewsDict["contentView"] = self.contentView
        viewsDict["label1"] = label1
        viewsDict["label2"] = label2
        viewsDict["label3"] = label3
        viewsDict["postBody"] = postBody
        viewsDict["label4"] = label4
        viewsDict["image1"] = image1
//        viewsDict["image2"] = image2

        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "[contentView(==view)]", options: nil, metrics: nil, views: viewsDict))

        scrollView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[contentView]|", options: nil, metrics: nil, views: viewsDict))
        scrollView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[contentView]|", options: nil, metrics: nil, views: viewsDict))
        
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
                "H:|-[postBody]-|",
                options: nil, metrics: nil, views: viewsDict))
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[label4]-|",
                options: nil, metrics: nil, views: viewsDict))


//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[image1]-|",
//                options: nil, metrics: nil, views: viewsDict))
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[image2]-|",
//                options: nil, metrics: nil, views: viewsDict))
//        
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-[label1]-[label2][label3]-[postBody]", options: nil, metrics: nil,
                views: viewsDict))
        
        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[postBody]-[label4]", options: nil, metrics: nil,
                views: viewsDict))

        contentView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[label4]-[image1]-|", options: nil, metrics: nil,
                views: viewsDict))
        
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:[image1]-[image2]|", options: nil, metrics: nil,
//                views: viewsDict))
        
        
        
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
//

    
    
}
