//
//  PJPost.swift
//  PlusJoe
//
//  Created by D on 3/29/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation


class PJPost: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Posts"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    
    @NSManaged var createdBy: String //uuid
    @NSManaged var body: String
    @NSManaged var words: [String]
    @NSManaged var hashtags: [String]
    @NSManaged var pricetags: [String]
    @NSManaged var location: PFGeoPoint
    @NSManaged var active: Bool
    @NSManaged var archived: Bool
    
}
