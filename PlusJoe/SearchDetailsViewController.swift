//
//  SearchDetailsViewController.swift
//  PlusJoe
//
//  Created by D on 4/16/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class SearchDetailsViewController : UIViewController {
    
    var searchResultsViewController:SearchResultsViewController?
    
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    
    var first = false
    var last = false
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var post:PJPost?
    var postIndex:UInt = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("SearchDetailsViewController viewDidLoad")

        bookmarkButton.setTitle("\u{f02e}   bookmark", forState: .Normal)
        shareButton.setTitle("\u{f1e0}   share", forState: .Normal)
        detailsButton.setTitle("details \u{f05a}", forState: .Normal)

        leftLabel.text = "\u{f053}"
        rightLabel.text = "\u{f054}"

        if first == true {
            leftLabel.hidden = true
        }
        if last == true {
            rightLabel.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("SearchDetailsViewController viewDidAppear")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        postBody.text = post?.body
        price.text = "$\((post?.price)!)"
        fee.text = "$\((post?.fee)!)"
        
        
        
        post?.image1file.getDataInBackgroundWithBlock({ (imageFile:NSData?, error:NSError?) -> Void in
            if error == nil {
                if imageFile != nil {
                self.postImage.image = UIImage(data: imageFile!)
                self.postImage.contentMode = .ScaleAspectFit
                self.postImage.clipsToBounds = true
                }
            }
        })

        searchResultsViewController?.mapView.selectAnnotation(searchResultsViewController?.annotations[Int(postIndex)], animated: true)
        

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "postDetailsSegue") {
            var postDetailsViewController = segue.destinationViewController as! PostDetailsViewController
            postDetailsViewController.post = self.post
            postDetailsViewController.postNumberText = "\(searchResultsViewController!.currentPost) / \(searchResultsViewController!.posts.count)"
        }
    }

    
}
