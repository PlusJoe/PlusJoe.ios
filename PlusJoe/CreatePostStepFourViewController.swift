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
    
    var cells = [UITableViewCell]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate      =   self
        self.tableView.dataSource    =   self

        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.scrollEnabled = true
        self.tableView.userInteractionEnabled = true
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        nextButton.setTitle("done" + "   \u{f046}", forState: UIControlState.Normal)



        
        
        cells.append(UITableViewCell())
        let label1 = UILabel()
        label1.font = UIFont(name: "Helvetica-Bold", size: 14)
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
        cells.last!.addSubview(label1)
        embedConstrainst(cells.last!, childView: label1)

        
        
        
        cells.append(UITableViewCell())
        let label2 = UILabel()
        label2.font = UIFont(name: "Helvetica Neue", size: 14)
        label2.text = "It will be searchable by following tags:"
        cells.last!.addSubview(label2)
        embedConstrainst(cells.last!, childView: label2)


        
        
        
        cells.append(UITableViewCell())
        let label3 = UILabel()
        label3.text = ""
        label3.numberOfLines = 0
        label3.font = UIFont(name: "Helvetica-Bold", size: 12)
        for var index = 0; index < (UNFINISHED_POST?.hashtags)!.count; ++index {
            label3.text = label3.text! + (UNFINISHED_POST?.hashtags[index])!
            if index < ((UNFINISHED_POST?.hashtags)!.count)-1  {
                label3.text = label3.text! + ", "
            }
        }
        cells.last!.addSubview(label3)
        embedConstrainst(cells.last!, childView: label3)

        
        
        
        cells.append(UITableViewCell())
        let postBody = UILabel()
        postBody.numberOfLines = 0
        postBody.text = ""
        postBody.font = UIFont(name: "American TypeWriter", size: 14)
        postBody.text = postBody.text! + (UNFINISHED_POST?.body)!
        cells.last!.addSubview(postBody)
        cells.last!.layer.cornerRadius=5
        cells.last!.layer.borderWidth=1
        embedConstrainst(cells.last!, childView: postBody)
        
        
        
        
        

        if let imageFile = UNFINISHED_POST?.image1file.getData() {
            cells.append(UITableViewCell())
            let label4 = UILabel()
            label4.font = UIFont(name: "Helvetica Neue", size: 12)
            label4.text = "Here are some photos:"
            cells.last!.addSubview(label4)
            embedConstrainst(cells.last!, childView: label4)

            
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFill
            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        } else {
            cells.append(UITableViewCell())
            let label4 = UILabel()
            label4.font = UIFont(name: "Helvetica Neue", size: 12)
            label4.text = "No photos provided"
            cells.last!.addSubview(label4)
            embedConstrainst(cells.last!, childView: label4)
        }
        if let imageFile = UNFINISHED_POST?.image2file.getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFill
            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }
        if let imageFile = UNFINISHED_POST?.image3file.getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFill
            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }
        if let imageFile = UNFINISHED_POST?.image4file.getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFill
            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }

        
        
        cells.append(UITableViewCell())
        let mapView = MKMapView()
        mapView.frame = CGRectMake(10, 10, UIScreen.mainScreen().bounds.width-20, UIScreen.mainScreen().bounds.width)

        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        cells.last!.addSubview(mapView)
        cells.last!.layer.cornerRadius=5
        cells.last!.layer.borderWidth=1
        embedConstrainst(cells.last!, childView: mapView)
        

        
        
    }


    func embedConstrainst(parentView:UIView, childView:UIView) {
        childView.setTranslatesAutoresizingMaskIntoConstraints(false)
        parentView.addConstraint(
        NSLayoutConstraint(item: childView,
        attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: parentView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 8.0) )
        
        parentView.addConstraint(
            NSLayoutConstraint(item: childView,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: parentView,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1.0,
                constant: -8.0) )
        
        parentView.addConstraint(
            NSLayoutConstraint(item: childView,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: parentView,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1.0,
                constant: 8.0) )

        parentView.addConstraint(
            NSLayoutConstraint(item: childView,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: parentView,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1.0,
                constant: -8.0) )

    }
    
    
    // Return the number of sections
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // Return the number of rows for each section in your static table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return cells.count    // section 0 has 7 rows
        default: fatalError("Unknown number of sections")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

}
