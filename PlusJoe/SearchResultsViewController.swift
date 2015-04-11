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

class SearchResultsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    var searchString = ""
    
    @IBOutlet weak var resultNumber: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchingForLabel: UILabel!
    
    var posts:[PJPost] = [PJPost]()
    
    var currentPost = 0
    
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
        if searchString != "" {
            searchingForLabel.text = "Searching for: \(searchString)"
        } else {
            searchingForLabel.text = "Showing all in your area"
        }
        
        mapView.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PJPost.search(CURRENT_LOCATION, searchText: searchString,
            succeeded: { (results) -> () in
                self.posts = results
//                self.resultNumber.text = "\(self.currentPost+1) of \(self.posts.count)"
                if results.count == 0 {
                    let alertMessage = UIAlertController(title: nil, message: "Nothing found, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                }
                
                var annotations = [MKPointAnnotation]()
                for var index = 0; index < self.posts.count; ++index {
                    let annotation = MKPointAnnotation()
                    let location = self.posts[index].location
                    annotation.coordinate =
                        CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
                    annotation.title = "\(index + 1)"
                    //                    annotation.subtitle = "\(index)"
                    self.mapView.addAnnotation(annotation)
                    annotations.append(annotation)
                }
                if annotations.count > 0 {
                    self.mapView.selectAnnotation(annotations[0], animated: true)
                    self.mapView.showAnnotations(annotations, animated: true)
                }
                
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Search Error, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
                
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        NSLog("selected annotation: \(view.annotation.title)")
        currentPost = view.annotation.title!.toInt()!
        resultNumber.text = "\(currentPost) of \(posts.count)"

    }
    
    
}
