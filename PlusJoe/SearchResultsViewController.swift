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

class SearchResultsViewController: UIViewController, MKMapViewDelegate , UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    var searchString = ""
    @IBOutlet weak var resultNumber: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchingForLabel: UILabel!
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var pageView: UIView!
    
    var posts:[PJPost] = [PJPost]()

    
    var currentPost:UInt = 0

    var pageController:UIPageViewController!

    
    @IBOutlet weak var currentPostBody: UILabel!
    
    
    
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
        
        
        
        

        PJPost.search(CURRENT_LOCATION, searchText: searchString,
            succeeded: { (results) -> () in
                self.posts = results
                if results.count == 0 {
                    let alertMessage = UIAlertController(title: nil, message: "Nothing found, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    alertMessage.addAction(ok)
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                    return
                }
                
                
                for var index = 0; index < self.posts.count; ++index {
                    let annotation = MKPointAnnotation()
                    let location = self.posts[index].location
                    annotation.coordinate =
                        CLLocationCoordinate2D(latitude: CLLocationDegrees(location.latitude), longitude: CLLocationDegrees(location.longitude))
                    annotation.title = "\(index + 1)"
                    //                    annotation.subtitle = "\(index)"
                    self.mapView.addAnnotation(annotation)
                    self.annotations.append(annotation)
                }
                if self.annotations.count > 0 {
                    self.mapView.selectAnnotation(self.annotations[0], animated: true)
                    self.mapView.showAnnotations(self.annotations, animated: true)
                }
                
                
                
                
                let options = [UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerSpineLocation.Min.rawValue]
                
                self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
                    navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
                    options: options)
                
                
                self.pageController?.dataSource = self
                self.pageController?.view.frame = self.view.bounds
                
                let searchDetailsViewController:SearchDetailsViewController = self.viewControllerAtIndex(0)!
                
                let viewControllers = [searchDetailsViewController]
                
                self.pageController?.setViewControllers(viewControllers,
                    direction: UIPageViewControllerNavigationDirection.Forward,
                    animated: true,
                    completion: nil)
                
                
                self.addChildViewController(self.pageController!)
                self.pageView.addSubview(self.pageController!.view)
                self.pageController!.didMoveToParentViewController(self)
                self.viewControllerAtIndex(0)
                
                
                
            }) { (error) -> () in
                let alertMessage = UIAlertController(title: nil, message: "Search Error, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
                
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        NSLog("selected annotation: \(view.annotation.title)")
        currentPost = UInt(view.annotation.title!.toInt()!)
        resultNumber.text = "\(currentPost) of \(posts.count)"

        let searchDetailsViewController:SearchDetailsViewController = self.viewControllerAtIndex(currentPost-1)!
        
        let viewControllers = [searchDetailsViewController]
        
        self.pageController?.setViewControllers(viewControllers,
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: true,
            completion: nil)

    }
    
    
    func viewControllerAtIndex(index:UInt) -> (SearchDetailsViewController?) {
        // Return the data view controller for the given index.
        if (self.posts.count == 0 || (Int(index) >= self.posts.count)) {
            return nil
        }
        
        let searchDetailsViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SearchDetailsView") as! SearchDetailsViewController
        

        searchDetailsViewController.post = posts[Int(index)]
        searchDetailsViewController.postIndex = index
        
        searchDetailsViewController.searchResultsViewController = self
        
        return searchDetailsViewController
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
var index = (viewController as! SearchDetailsViewController).postIndex
        
        if ((index == 0) || (Int(index) == NSNotFound)) {
        return nil
        }
        index--
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! SearchDetailsViewController).postIndex
        if (Int(index) == NSNotFound) {
            return nil
        }
        index++
        if(Int(index) == self.posts.count) {
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "postDetailsSegue") {
            var postDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            postDetailsViewController.post = posts[Int(currentPost)-1]
            if searchString != "" {
                postDetailsViewController.postNumberText = "\(currentPost) of \(posts.count) for \(searchString)"
            } else {
                postDetailsViewController.postNumberText = "\(currentPost) of \(posts.count)"
            }
        }
    }

    
}
