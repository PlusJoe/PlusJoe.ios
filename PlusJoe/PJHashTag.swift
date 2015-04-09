//
//  PJHashTag.swift
//  PlusJoe
//
//  Created by D on 4/8/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class PJHashTag: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "HashTags"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var post: PJPost
    @NSManaged var tag: String

}
