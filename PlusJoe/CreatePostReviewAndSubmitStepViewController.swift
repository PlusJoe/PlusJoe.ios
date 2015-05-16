//
//  CreatePostReviewAndSubmitStepViewController
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit
import Parse

class CreatePostReviewAndSubmitStepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
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

        self.tableView.estimatedRowHeight = 10.0
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
        label1.font = UIFont(name: "Helvetica-Bold", size: 18)
        if (UNFINISHED_POST?[PJPOST.sell] as! Bool) == false && (UNFINISHED_POST?[PJPOST.thing] as! Bool) == false {
            label1.text = "You wish to hire a service for $\(UNFINISHED_POST![PJPOST.price] as! Int)"
        } else
        if (UNFINISHED_POST?[PJPOST.sell] as! Bool) == false && (UNFINISHED_POST?[PJPOST.thing] as! Bool) == true {
            label1.text = "You wish to buy something for $\(UNFINISHED_POST![PJPOST.price] as! Int)"
        } else
        if (UNFINISHED_POST?[PJPOST.sell] as! Bool) == true && (UNFINISHED_POST?[PJPOST.thing] as! Bool) == false {
            label1.text = "You wish to offer a service for $\(UNFINISHED_POST![PJPOST.price] as! Int)"
        } else
        if (UNFINISHED_POST?[PJPOST.sell] as! Bool) == true && (UNFINISHED_POST?[PJPOST.thing] as! Bool) == true {
            label1.text = "You wish to sell something for $\(UNFINISHED_POST![PJPOST.price] as! Int)"
        }
        label1.numberOfLines = 0
        cells.last!.addSubview(label1)
        embedConstrainst(cells.last!, childView: label1)

        
        
        if UNFINISHED_POST![PJPOST.fee] as! Int > 0 {
            cells.append(UITableViewCell())
            let labelFee = UILabel()
            labelFee.font = UIFont(name: "Helvetica-Bold", size: 14)
            labelFee.text = "If someone helps you to acheive your goal, you will pay the finder's fee of $\(UNFINISHED_POST![PJPOST.fee] as! Int)"
            labelFee.numberOfLines = 0
            cells.last!.addSubview(labelFee)
            embedConstrainst(cells.last!, childView: labelFee)
        }
        
        
        
        
        
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
        
        PJHashTag.loadTagsForPost(UNFINISHED_POST!,
            succeeded: { (hashTags) -> () in
                for var index = 0; index < hashTags.count; ++index {
                    label3.text = label3.text! + (hashTags[index][PJHASHTAG.tag] as! String)
                    if index < (hashTags.count)-1  {
                        label3.text = label3.text! + ", "
                    }
                }
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Error loading #hashtags.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        
        cells.last!.addSubview(label3)
        embedConstrainst(cells.last!, childView: label3)

        
        
        
        cells.append(UITableViewCell())
        let postBody = UILabel()
        postBody.numberOfLines = 0
        postBody.text = ""
        postBody.font = UIFont(name: "American TypeWriter", size: 18)
        postBody.text = postBody.text! + (UNFINISHED_POST?[PJPOST.body] as! String)
        cells.last!.addSubview(postBody)
        cells.last!.layer.cornerRadius=5
        cells.last!.layer.borderWidth=1
        embedConstrainst(cells.last!, childView: postBody)
        
        
        
        
        

        if let imageFile = (UNFINISHED_POST?[PJPOST.image1file] as! PFFile).getData() {
            cells.append(UITableViewCell())
            let label4 = UILabel()
            label4.font = UIFont(name: "Helvetica Neue", size: 12)
            label4.text = "Here are some photos:"
            cells.last!.addSubview(label4)
            embedConstrainst(cells.last!, childView: label4)

            
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFit
//            image.sizeToFit()
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
        
        
        if let imageFile = (UNFINISHED_POST?[PJPOST.image2file] as! PFFile).getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFit
//            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }
        if let imageFile = (UNFINISHED_POST?[PJPOST.image3file] as! PFFile).getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFit
//            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }
        if let imageFile = (UNFINISHED_POST?[PJPOST.image4file] as! PFFile).getData() {
            cells.append(UITableViewCell())
            let image = UIImageView()
            image.image = UIImage(data: imageFile)
            
            image.contentMode = .ScaleAspectFit
//            image.sizeToFit()
            image.clipsToBounds = true
            cells.last!.addSubview(image)
            embedConstrainst(cells.last!, childView: image)
        }

        
        
        
        cells.append(UITableViewCell())
        let label5 = UILabel()
        label5.numberOfLines = 0
        label5.font = UIFont(name: "Helvetica Neue", size: 12)
        label5.text = "Your post will be searchable within and beyond following area:"
        cells.last!.addSubview(label5)
        embedConstrainst(cells.last!, childView: label5)
                
        
        

        let mapView = MKMapView()//frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200))
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        
        let mylocation = CLLocationCoordinate2D(
            latitude:  ((UNFINISHED_POST?[PJPOST.location] as! PFGeoPoint).latitude),
            longitude: ((UNFINISHED_POST?[PJPOST.location] as! PFGeoPoint).longitude)
        )
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: mylocation, span: span)
        mapView.setRegion(region, animated: false)
//        mapView.frame.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: 200)

        let options:MKMapSnapshotOptions  = MKMapSnapshotOptions()
        options.region = region
        options.scale = UIScreen.mainScreen().scale
        options.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: 200)
        let snapshotter:MKMapSnapshotter  = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler { (snapshot:MKMapSnapshot!, error:NSError!) -> Void in
            let image:UIImage = snapshot.image
            self.cells.append(UITableViewCell())
            let imageView = UIImageView()
            imageView.image = image
            
            imageView.contentMode = .ScaleAspectFit
            imageView.sizeToFit()
            imageView.clipsToBounds = true
            self.cells.last!.addSubview(imageView)
            self.embedConstrainst(self.cells.last!, childView: imageView)

            self.tableView.reloadData()
            self.tableView.reloadInputViews()

        }
        
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

    @IBAction func finishPost(sender: AnyObject) {
        UNFINISHED_POST?[PJPOST.active] = true
        UNFINISHED_POST?.save()
        UNFINISHED_POST = nil
    }
}
