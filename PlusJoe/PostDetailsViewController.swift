//
//  PostDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 4/18/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import MapKit
import Parse


class PostDetailsViewController : UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIPopoverPresentationControllerDelegate  {
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    @IBOutlet weak var alertsCountLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var menuView: UIBarButtonItem!
    
    var post:PFObject?
    // if conversation is passed from child controller, then use it for initiating the chat
    var conversation:PFObject?
    
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    var timer:NSTimer?
    
    //    var images = [NSData]()
    var imageViewControllers = [ImageViewController]()
    
    var titleText = ""
    
    var pageController:UIPageViewController!
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sellButtonAction(sender: AnyObject) {
        if PJPurchase.arePendingPurchasesPresent() {
            let sellViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("SellViewController") as! SellViewController
            self.presentViewController(sellViewController, animated: true, completion: nil)
            
        } else {
            let createPostDescribeStepViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("CreatePostDescribeStepViewController") as! CreatePostDescribeStepViewController
            self.presentViewController(createPostDescribeStepViewController, animated: true, completion: nil)
        }
    }

    
    func updateAlertsView() -> Void {
        if allowChat() == true && allowBuy() == true {
            if UNREAD_ALERTS_COUNT == 0 {
                self.alertsCountLabel.hidden = true
            } else {
                self.alertsCountLabel.text = String(UNREAD_ALERTS_COUNT)
                self.alertsCountLabel.hidden = false
            }
        }
        if PENDING_SALES_PRESENT == true {
            addPulseAnimation(sellButton.layer)
        } else {
            removePulseAnimation(sellButton.layer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        menuButton.setTitle("\u{f0c9}", forState: .Normal)
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        self.navBar.topItem?.title = titleText
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgb: 0x666666)]
        
        
        shareButton.setTitle("share \u{f1e0}", forState: .Normal)
        buyButton.setTitle("buy \u{f164}", forState: .Normal)
        chatButton.setTitle("chat \u{f086}", forState: UIControlState.Normal)

        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("updateAlertsView"), userInfo: nil, repeats: true)
        }
        
        
        postBody.text = post?[PJPOST.body] as? String
        
        let df = NSDateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        let dateStr  = String(format: "%@", df.stringFromDate((post?.createdAt!)!))
        
        let user = PFQuery.getUserObjectWithId(post?[PJPOST.createdBy] as! String)!
        
        if isGuestUser(user) {
            self.postUserName.text = "guest"
        } else {
            self.postUserName.text = "\((user.username)!)"
        }
        
        self.postDate.text = "\(dateStr)"
        
        // set pagination
        let options = [UIPageViewControllerOptionSpineLocationKey: UIPageViewControllerSpineLocation.Min.rawValue]
        
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
            navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
            options: options)
        
        
        
        if let imageFile = (post?[PJPOST.image1file] as! PFFile).getData() {
            if imageFile.length > 0 {
                addImageToView(UIImage(data: imageFile)!)
            }
        }
        if let imageFile = (post?[PJPOST.image2file] as! PFFile).getData() {
            if imageFile.length > 0 {
                addImageToView(UIImage(data: imageFile)!)
            }
        }
        if let imageFile = (post?[PJPOST.image3file] as! PFFile).getData() {
            if imageFile.length > 0 {
                addImageToView(UIImage(data: imageFile)!)
            }
        }
        if let imageFile = (post?[PJPOST.image4file] as! PFFile).getData() {
            if imageFile.length > 0 {
                addImageToView(UIImage(data: imageFile)!)
            }
        }
        
        
        
        
        let mapView = MKMapView()//frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 200))
        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        
        let mylocation = CLLocationCoordinate2D(
            latitude: (post?[PJPOST.location] as! PFGeoPoint).latitude,
            longitude: (post?[PJPOST.location] as! PFGeoPoint).longitude
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
        snapshotter.startWithCompletionHandler { (snapshot:MKMapSnapshot?, error:NSError?) -> Void in
            self.addImageToView(snapshot!.image)
            
            self.pageController?.dataSource = self
            self.pageController?.view.frame = self.imagesView.bounds
            
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor =  UIColor.whiteColor()
            appearance.currentPageIndicatorTintColor = UIColor(rgb:0xff8000)
            appearance.backgroundColor = UIColor(rgb: 0xffd37c)
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

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateAlertsView()
    
        
        // looking at my own post
        if allowChat() == false {
            chatButton.enabled = false
            chatButton.backgroundColor = UIColor.grayColor()

            sellButton.enabled = false
            sellButton.hidden = true
        }
        
        if allowBuy() == false {
            buyButton.enabled = false
            buyButton.backgroundColor = UIColor.grayColor()

            sellButton.enabled = false
            sellButton.hidden = true
        }
        
        price.text = "$\((post?[PJPOST.price] as? Int)!)"
        fee.text = "$\((post?[PJPOST.fee] as? Int)!)"

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
    
    
    @IBAction func menuTapped(sender: AnyObject) {
        self.alertsCountLabel.hidden = true
        
        
        // looking at my own post
        if allowBuy() == false {
            let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("Menu2PostDetails") as! Menu2PostDetailsViewController
            popoverVC.modalPresentationStyle = .Popover
            popoverVC.preferredContentSize = CGSizeMake(300, 100)
            popoverVC.post = post
            
            
            let popoverPresentationViewController = popoverVC.popoverPresentationController
            popoverPresentationViewController?.permittedArrowDirections = .Any
            
            popoverPresentationViewController?.delegate = self
            popoverPresentationViewController?.sourceView =             menuButton
            popoverPresentationViewController?.sourceRect =             menuButton.bounds
            presentViewController(popoverVC, animated: true, completion: nil)
            
        } else {
            let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("MenuPostDetails") as! MenuPostDetailsViewController
            popoverVC.modalPresentationStyle = .Popover
            popoverVC.preferredContentSize = CGSizeMake(300, 300)
            popoverVC.post = post
            
            
            let popoverPresentationViewController = popoverVC.popoverPresentationController
            popoverPresentationViewController?.permittedArrowDirections = .Any
            
            popoverPresentationViewController?.delegate = self
            popoverPresentationViewController?.sourceView =             menuButton
            popoverPresentationViewController?.sourceRect =             menuButton.bounds
            presentViewController(popoverVC, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "chatSegue") {
            
            let chatViewController = segue.destinationViewController as! ChatViewController
            
            if self.conversation == nil {
                let conversation = PJConversation.findOrCreateConversation(post!,
                    participant2id: PFUser.currentUser()!.objectId!)
                chatViewController.conversation = conversation
            } else {
                chatViewController.conversation = self.conversation
            }
        }
        

        if(segue.identifier == "BuyViewControllerSegue") {
            
            let buyViewController = segue.destinationViewController as! BuyViewController
            buyViewController.post = post
        }

        
        
    }
    
    
    func allowChat() -> Bool {
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            return post?[PJPOST.createdBy]! as? String != PFUser.currentUser()!.objectId! || conversation != nil
        }
        return false
    }

    func allowBuy() -> Bool {
        return post?[PJPOST.createdBy]! as? String != PFUser.currentUser()!.objectId!
    }
    
}
