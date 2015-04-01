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
    @NSManaged var sell: Bool // if it's false, it's not a sell, it's a buy
    @NSManaged var thing: Bool // if it's false, it's not a thing, it's a service
    @NSManaged var body: String
    @NSManaged var words: [String]
    @NSManaged var hashtags: [String]
    @NSManaged var pricetags: [String]
    @NSManaged var location: PFGeoPoint
    @NSManaged var active: Bool
    @NSManaged var archived: Bool
    
    @NSManaged var image1file: PFFile
    @NSManaged var image2file: PFFile
    @NSManaged var image3file: PFFile
    @NSManaged var image4file: PFFile
    

    
    class func getUnfinishedPost() -> (PJPost?) {
        let query = PJPost.query()
        // Interested in locations near user.
        query!.whereKey("active", equalTo: false)
        query!.whereKey("archived", equalTo: false)
        query!.whereKey("createdBy", equalTo: DEVICE_UUID)
        return query!.getFirstObject() as? PJPost
    }
    
    class func createUnfinishedPost() -> (PJPost) {
        let newPost = PJPost(className: PJPost.parseClassName())
        newPost.location = CURRENT_LOCATION!
        newPost.createdBy = DEVICE_UUID
        newPost.sell = true
        newPost.thing = true
        newPost.active = false
        newPost.archived = false
        newPost.body = ""
        newPost.save()
        return newPost
    }

    
}