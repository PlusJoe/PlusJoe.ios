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

class SearchResultsViewController: UIViewController, MKMapViewDelegate , UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    var searchString = ""
    
    @IBOutlet weak var menuButton: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var postView: UIView!
    
    var posts:[PJPost] = [PJPost]()
    
    
    var currentPost:UInt = 0
    
    var pageController:UIPageViewController!
    
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        detailsButton.enabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        menuButton.title = "\u{f0c9}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
            menuButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
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
                self.pageController?.view.frame = self.postView.bounds
                
                let searchDetailsViewController:SearchDetailsViewController = self.viewControllerAtIndex(0)!
                
                let viewControllers = [searchDetailsViewController]
                
                self.pageController?.setViewControllers(viewControllers,
                    direction: UIPageViewControllerNavigationDirection.Forward,
                    animated: true,
                    completion: nil)
                
                
                self.addChildViewController(self.pageController!)
                self.pageView.addSubview(self.pageController!.view)
                self.pageController!.didMoveToParentViewController(self)
                //                self.viewControllerAtIndex(0)
                self.navBar.topItem?.title = "1 / \(self.posts.count)"
                
                
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
        NSLog("!!!!!!!!!!!!!!!!!!!!!!! selected annotation: \(view.annotation.title)")
        currentPost = UInt(view.annotation.title!.toInt()!)
        //        resultNumber.text = "\(currentPost) of \(posts.count)"
        
        let searchDetailsViewController:SearchDetailsViewController = self.viewControllerAtIndex(currentPost-1)!
        
        let viewControllers = [searchDetailsViewController]
        self.navBar.topItem?.title = "\(currentPost) / \(self.posts.count)"
        
        //weird, need this sleep to prevent for crashes
        //        usleep(500)
        
        self.pageController?.setViewControllers(
            viewControllers,
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: false,
            completion: { (Bool) -> Void in
                //weird, need this sleep to prevent for crashes
                //                usleep(1)
        })
        
        
    }
    
    
    func viewControllerAtIndex(index:UInt) -> (SearchDetailsViewController?) {
        NSLog("@@@@@@@@@@@@@@@@@@@@@@@@@@  viewControllerAtIndex: \(index)")
        
        // Return the data view controller for the given index.
        if (self.posts.count == 0 || (Int(index) >= self.posts.count)) {
            return nil
        }
        
        let searchDetailsViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SearchDetailsView") as! SearchDetailsViewController
        
        
        searchDetailsViewController.post = posts[Int(index)]
        searchDetailsViewController.postIndex = index
        
        searchDetailsViewController.searchResultsViewController = self
        
        
        
        if Int(index) == 0 {
            searchDetailsViewController.first = true
        }
        if Int(index) == posts.count-1 {
            searchDetailsViewController.last = true
        }
        
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
    
    
    
    
    @IBAction func menuTapped(sender: AnyObject) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("MenuPostDetails") as! MenuPostDetailsViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(350, 300)
        
        
        let popoverPresentationViewController = popoverVC.popoverPresentationController
        popoverPresentationViewController?.permittedArrowDirections = .Up
        
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.barButtonItem            = menuButton
        presentViewController(popoverVC, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    
    
    
    
    
    @IBAction func actionsTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.view.tintColor = UIColor(rgb: 0xff8000)
        
        let oneAction = UIAlertAction(title: "Flag as Inapropriate", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in })
            let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                self.posts[Int(self.currentPost)-1].inappropriate = true
                self.posts[Int(self.currentPost)-1].save()
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertMessage.addAction(cancel)
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(oneAction)
        
        
        if self.posts[Int(self.currentPost)-1].sell == true { // this menu should only be available for the sell posts
            let twoAction = UIAlertAction(title: "Buy it", style: .Default) { (_) in
                let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)
            }
            alertController.addAction(twoAction)
        }

        let bookmarkAction = UIAlertAction(title: "Bookmark #hashtags", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(bookmarkAction)

        
        let shareAction = UIAlertAction(title: "Share & earn finders fee", style: .Default) { (_) in
            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
            alertMessage.addAction(ok)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        }
        alertController.addAction(shareAction)
        
        
        //        let fourAction = UIAlertAction(title: "Contact this person", style: .Default) { (_) in
        //            let alertMessage = UIAlertController(title: nil, message: "Under construction. \nComing soon.", preferredStyle: UIAlertControllerStyle.Alert)
        //            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in })
        //            alertMessage.addAction(ok)
        //            self.presentViewController(alertMessage, animated: true, completion: nil)
        //        }
        //        alertController.addAction(fourAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
}
