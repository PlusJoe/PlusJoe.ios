//
//  CreatePostStepFourViewController.swift
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit

class CreatePostStepFourViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var cell1: UITableViewCell = UITableViewCell()
    var cell2: UITableViewCell = UITableViewCell()
    var cell3: UITableViewCell = UITableViewCell()
    var bodyPostCell: UITableViewCell = UITableViewCell()
    var image1Cell: UITableViewCell = UITableViewCell()
    var image2Cell: UITableViewCell = UITableViewCell()
    var image3Cell: UITableViewCell = UITableViewCell()
    var image4Cell: UITableViewCell = UITableViewCell()
    var mapCell: UITableViewCell = UITableViewCell()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self

        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        nextButton.setTitle("done" + "   \u{f046}", forState: UIControlState.Normal)
//        tableView.dataSource = self


        
        
        
        let label1 = UILabel(frame: CGRectInset(self.cell1.contentView.bounds, 5, 0))
        label1.setTranslatesAutoresizingMaskIntoConstraints(true)
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
        cell1.addSubview(label1)
        

        let label2 = UILabel(frame: CGRectInset(self.cell1.contentView.bounds, 5, 0))
        label2.setTranslatesAutoresizingMaskIntoConstraints(false)
        label2.font = UIFont(name: "Helvetica Neue", size: 12)
        label2.text = "It will be searchable by following tags:"
        cell2.addSubview(label2)

        let label3 = UILabel(frame: CGRectInset(self.cell1.contentView.bounds, 5, 0))//frame: CGRectMake(10, 60, UIScreen.mainScreen().bounds.size.width-10.0, 20))
        label3.text = ""
        label3.numberOfLines = 0
//        label3.setTranslatesAutoresizingMaskIntoConstraints(false)
        label3.font = UIFont(name: "Times-Bold", size: 12)
        for var index = 0; index < (UNFINISHED_POST?.hashtags)!.count; ++index {
            label3.text = label3.text! + (UNFINISHED_POST?.hashtags[index])!
            if index < ((UNFINISHED_POST?.hashtags)!.count)-1  {
                label3.text = label3.text! + ", "
            }
        }
        cell3.addSubview(label3)


//
//        let postBody = UITextView()
//        postBody.setTranslatesAutoresizingMaskIntoConstraints(false)
//        postBody.font = UIFont(name: "American TypeWriter", size: 14)
//        postBody.sizeToFit()
//        postBody.scrollEnabled = true
//        postBody.text = UNFINISHED_POST?.body
//        postBody.scrollEnabled = false
//        postBody.userInteractionEnabled = false
//
//        contentView.addSubview(postBody)
//
//        let label4 = UILabel()
//        label4.setTranslatesAutoresizingMaskIntoConstraints(false)
//        label4.font = UIFont(name: "Helvetica Neue", size: 12)
//        label4.text = "Here are some photos:"
//        contentView.addSubview(label4)
//        
//
//        let image1 = UIView()
//        image1.setTranslatesAutoresizingMaskIntoConstraints(false)
//        if let imageFile1 = UNFINISHED_POST?.image1file.getData() {
//            let image = UIImageView()
////            image.setTranslatesAutoresizingMaskIntoConstraints(false)
//            image.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//            image.image = UIImage(data: imageFile1)
//
//            image.contentMode = .ScaleAspectFill
//            image.sizeToFit()
//            image.clipsToBounds = true
//            image1.addSubview(image)
//            contentView.addSubview(image1)
//        }
        
        
//        postBody.layer.cornerRadius=5
//        postBody.layer.borderWidth=1
//        label4.layer.cornerRadius=5
//        label4.layer.borderWidth=1
//        image1.layer.cornerRadius=5
//        image1.layer.borderWidth=1
//        contentView.layer.cornerRadius=5
//        contentView.layer.borderWidth=1
//        

        
//
//        var viewsDict = Dictionary <String, UIView>()
//        viewsDict["view"] = self.view
//        viewsDict["scrollView"] = self.scrollView
//        viewsDict["contentView"] = self.contentView
//        viewsDict["label1"] = label1
//        viewsDict["label2"] = label2
//        viewsDict["label3"] = label3
//        viewsDict["postBody"] = postBody
//        viewsDict["label4"] = label4
//        viewsDict["image1"] = image1
////        viewsDict["image2"] = image2
//
//        view.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "[contentView(==view)]", options: nil, metrics: nil, views: viewsDict))
//
//        scrollView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|[contentView]|", options: nil, metrics: nil, views: viewsDict))
//        scrollView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:|[contentView]|", options: nil, metrics: nil, views: viewsDict))
//        
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[label1]-|", options: nil, metrics: nil, views: viewsDict))
//        
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[label2]-|",
//                options: nil, metrics: nil, views: viewsDict))
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[label3]-|",
//                options: nil, metrics: nil, views: viewsDict))
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[postBody]-|",
//                options: nil, metrics: nil, views: viewsDict))
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "H:|-[label4]-|",
//                options: nil, metrics: nil, views: viewsDict))
//
//
////        contentView.addConstraints(
////            NSLayoutConstraint.constraintsWithVisualFormat(
////                "H:|-[image1]-|",
////                options: nil, metrics: nil, views: viewsDict))
////        contentView.addConstraints(
////            NSLayoutConstraint.constraintsWithVisualFormat(
////                "H:|-[image2]-|",
////                options: nil, metrics: nil, views: viewsDict))
////        
//        
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:|-[label1]-[label2][label3]-[postBody]", options: nil, metrics: nil,
//                views: viewsDict))
//        
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:[postBody]-[label4]", options: nil, metrics: nil,
//                views: viewsDict))
//
//        contentView.addConstraints(
//            NSLayoutConstraint.constraintsWithVisualFormat(
//                "V:[label4]-[image1]-|", options: nil, metrics: nil,
//                views: viewsDict))
//        
//        
        
        
    }


    
    // Return the number of sections
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // Return the number of rows for each section in your static table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 3    // section 0 has 7 rows
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        switch(indexPath.row) {
        case 0: cell = cell1    // section 0 has 7 rows
        case 1: cell = cell2
        case 2: cell = cell3
        default: fatalError("Unknown number of sections")
        }
        
        return cell
    }

}
