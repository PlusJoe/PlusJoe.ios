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
    
    
    var post:PJPost?
    
    var postIndex:UInt = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("SearchDetailsViewController viewDidLoad")
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
        
        if let imageFile = post?.image1file.getData() {
            postImage.image = UIImage(data: imageFile)
            
            postImage.contentMode = .ScaleAspectFit
            postImage.clipsToBounds = true
        }
        searchResultsViewController?.mapView.selectAnnotation(searchResultsViewController?.annotations[Int(postIndex)], animated: true)
    }
}
