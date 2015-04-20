//
//  PostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 4/18/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation


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
        
        
        self.pageController?.dataSource = self
        self.pageController?.view.frame = self.imagesView.bounds
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor =  UIColor.whiteColor()
        appearance.currentPageIndicatorTintColor = UIColor.greenColor()
        appearance.backgroundColor = UIColor(rgb: 0x006600)
        

        if let imageFile = post?.image1file.getData() {
            let imageViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ImageDetailsView") as! ImageViewController
            imageViewController.image  = UIImage(data: imageFile)
            imageViewController.index = 0
            imageViewControllers.append(imageViewController)


        }
        if let imageFile = post?.image2file.getData() {
            let imageViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ImageDetailsView") as! ImageViewController
            imageViewController.image  = UIImage(data: imageFile)
            imageViewController.index = 1
            imageViewControllers.append(imageViewController)
        }
        if let imageFile = post?.image3file.getData() {
            let imageViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ImageDetailsView") as! ImageViewController
            imageViewController.image  = UIImage(data: imageFile)
            imageViewController.index = 2
            imageViewControllers.append(imageViewController)
        }
        if let imageFile = post?.image4file.getData() {
            let imageViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ImageDetailsView") as! ImageViewController
            imageViewController.image  = UIImage(data: imageFile)
            imageViewController.index = 3
            imageViewControllers.append(imageViewController)
        }

        
        self.pageController?.setViewControllers([imageViewControllers[0]],
            direction: UIPageViewControllerNavigationDirection.Forward,
            animated: true,
            completion: nil)
        
        
        
        self.addChildViewController(self.pageController!)
        self.imagesView.addSubview(self.pageController!.view)
        self.pageController!.didMoveToParentViewController(self)
        self.viewControllerAtIndex(0)
        
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
