//
//  PostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 4/18/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit


extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class PostDetailsViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    var post:PJPost? 
    
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var postBody: UILabel!
    
//    var images = [NSData]()
    var imageViewControllers = [ImageViewController]()
    
    var postNumberText = ""
    
    var pageController:UIPageViewController!


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
    
        postNumberLabel.text = postNumberText
        postBody.text = post?.body
        price.text = "$\((post?.price)!)"
        fee.text = "$\((post?.fee)!)"
        
        
        // set pagination
        let options = [UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerSpineLocation.Min.rawValue]
        
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
            navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
            options: options)
        
        
        

        if let imageFile = post?.image1file.getData() {
            addImageToView(UIImage(data: imageFile)!)
        }
        if let imageFile = post?.image2file.getData() {
            addImageToView(UIImage(data: imageFile)!)
        }
        if let imageFile = post?.image3file.getData() {
            addImageToView(UIImage(data: imageFile)!)
        }
        if let imageFile = post?.image4file.getData() {
            addImageToView(UIImage(data: imageFile)!)
        }


        
        
        let mapView = MKMapView()//frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200))
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        
        let mylocation = CLLocationCoordinate2D(
            latitude: (post?.location.latitude)!,
            longitude: (post?.location.longitude)!
        )
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: mylocation, span: span)
        mapView.setRegion(region, animated: false)
        //        mapView.frame.size = CGSize(width: UIScreen.mainScreen().bounds.width, height: 200)
        
        let mapOptions:MKMapSnapshotOptions  = MKMapSnapshotOptions()
        mapOptions.region = region
//        mapOptions.scale = self.imagesView.scale
        mapOptions.size = CGSize(width: self.imagesView.bounds.width, height: self.imagesView.bounds.height)
        let snapshotter:MKMapSnapshotter  = MKMapSnapshotter(options: mapOptions)
        snapshotter.startWithCompletionHandler { (snapshot:MKMapSnapshot!, error:NSError!) -> Void in
            self.addImageToView(snapshot.image)
            
            self.pageController?.dataSource = self
            self.pageController?.view.frame = self.imagesView.bounds
            
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor =  UIColor.whiteColor()
            appearance.currentPageIndicatorTintColor = UIColor.greenColor()
            appearance.backgroundColor = UIColor(rgb: 0x006600)
            appearance.hidesForSinglePage = true
            
            
            self.pageController?.setViewControllers([self.imageViewControllers[0]],
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: true,
                completion: nil)
            
            
            
            self.addChildViewController(self.pageController!)
            self.imagesView.addSubview(self.pageController!.view)
            self.pageController!.didMoveToParentViewController(self)
            self.viewControllerAtIndex(0)
        }
        
    }

    
    private func addImageToView(image:UIImage) -> () {
        let imageViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ImageDetailsView") as! ImageViewController
        imageViewController.image  = image
        imageViewController.index = UInt(self.imageViewControllers.count)
        self.imageViewControllers.append(imageViewController)
    }
    

    func viewControllerAtIndex(index:UInt) -> (ImageViewController?) {
        return imageViewControllers[Int(index)]
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ImageViewController).index
        
        if ((index == 0) || (Int(index) == NSNotFound)) {
            return nil
        }
        index--
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ImageViewController).index
        if (Int(index) == NSNotFound) {
            return nil
        }
        index++
        if(Int(index) == self.imageViewControllers.count) {
            return nil
        }
        return viewControllerAtIndex(index)
    }

    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return imageViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
}
