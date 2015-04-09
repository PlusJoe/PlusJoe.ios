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

    
    class func autoComplete(
        location: PFGeoPoint,
        searchText: String,
        succeeded:(results:[String]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            
            // Create a query for places
            let queryPost = PJPost.query()
            // Interested in locations near user.
            queryPost!.whereKey("location", nearGeoPoint:location)
            queryPost!.whereKey("active", equalTo:true)
            queryPost!.whereKey("archived", equalTo:false)
            //            query!.whereKey("createdBy", notEqualTo: DEVICE_UUID)  //TODO: uncomment
            NSLog("Searching for string \(searchText)")

            
            let queryTag = PJHashTag.query()
            queryTag!.whereKey("post", matchesQuery:queryPost!)
            queryTag!.whereKey("tag", hasPrefix: searchText)
            // Limit what could be a lot of points.
            queryTag!.limit = 100
            // Final list of objects
            //                self.postsNearMe =
            
            queryTag!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    
                    NSLog("results: \(objects!.count)")
                    let tags:[String] = (objects as! [PJHashTag]).map{$0.tag}
                    succeeded(results: tags)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
            
    }

    
}
