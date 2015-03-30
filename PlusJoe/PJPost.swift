//
//  PJPost.swift
//  PlusJoe
//
//  Created by D on 3/29/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation


class PJPost: PFObject, PFSubclassing {
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    @NSManaged var createdBy: String //uuid
    @NSManaged var body: String
    @NSManaged var words: [String]
    @NSManaged var hash_tags: [String]
    @NSManaged var price_tags: [String]
    @NSManaged var location: PFGeoPoint
    @NSManaged var active: Boolean
    @NSManaged var archived: Boolean
    
}
