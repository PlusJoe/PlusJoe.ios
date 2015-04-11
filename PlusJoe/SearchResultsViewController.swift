//
//  SearchResultsViewController.swift
//  PlusJoe
//
//  Created by D on 4/10/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchResultsViewController: UIViewController {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    var searchString = ""
    
    @IBOutlet weak var resultNumber: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchingForLabel: UILabel!
    
    var posts:[PJPost] = [PJPost]()
    
    
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
        searchingForLabel.text = "Searching for: \(searchString)"
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        PJPost.search(CURRENT_LOCATION, searchText: searchString,
            succeeded: { (results) -> () in
                self.posts = results
                var annotations = [MKPointAnnotation]()
                for index in 0...self.posts.count-1 {
                    let annotation = MKPointAnnotation()
                    let location = self.posts[index].location
                    annotation.coordinate =
                        CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
                    annotation.title = "\(index + 1)"
//                    annotation.subtitle = "\(index)"
                    self.mapView.addAnnotation(annotation)
                    annotations.append(annotation)
                }

                self.mapView.selectAnnotation(annotations[0], animated: true)
                self.mapView.showAnnotations(annotations, animated: true)
                
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Search Error, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
        }
    }
    
}
