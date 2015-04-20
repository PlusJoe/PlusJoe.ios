//
//  ImageViewController.swift
//  PlusJoe
//
//  Created by D on 4/19/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage?
    var index:UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image        
    }
}
