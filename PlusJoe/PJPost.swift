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
    //    @NSManaged var words: [String]!
    //    @NSManaged var hashtags: [PJHashTag]!
    @NSManaged var price: Int
    @NSManaged var fee: Int
    @NSManaged var location: PFGeoPoint
    @NSManaged var active: Bool
    @NSManaged var archived: Bool
    @NSManaged var inappropriate: Bool
    
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
        newPost.fee = 0
        newPost.image1file = PFFile(name:"blank.png", data:NSData())
        newPost.image2file = PFFile(name:"blank.png", data:NSData())
        newPost.image3file = PFFile(name:"blank.png", data:NSData())
        newPost.image4file = PFFile(name:"blank.png", data:NSData())
        newPost.save()
        return newPost
    }
    
    class func search(
        location: PFGeoPoint,
        searchText: String,
        succeeded:(results:[PJPost]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            
            let queryPost = PJPost.query()
            // Interested in locations near user.
            queryPost!.whereKey("location", nearGeoPoint:location)
            queryPost!.whereKey("active", equalTo:true)
            queryPost!.whereKey("archived", equalTo:false)
            queryPost!.whereKey("inappropriate", notEqualTo:true)
            queryPost!.whereKey("createdBy", notEqualTo: DEVICE_UUID)  
            NSLog("Searching for string \(searchText)")
            
            
            let queryTag = PJHashTag.query()
            queryTag!.whereKey("post", matchesQuery:queryPost!)
            if searchText != "" {
                queryTag!.whereKey("tag", equalTo: searchText)
            }
            queryTag!.includeKey("post")
//            // Limit what could be a lot of points.
//            queryTag!.limit = 100
            // Final list of objects
            //                self.postsNearMe =
            
            queryTag!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    var posts = [PJPost]()
                    var postsSet:Set<String> = Set<String>()
                    NSLog("results hash: \(objects!.count)")
                    for hashTag in objects as! [PJHashTag] {
                        if !postsSet.contains(hashTag.post.objectId!) {
                            posts.append(hashTag.post)
                            postsSet.insert(hashTag.post.objectId!) // is it strictly to avoid duplicates
                        }
                    }
                    NSLog("results post: \(posts.count)")
                    NSLog("results set : \(postsSet.count)")
                    
                    succeeded(results: posts)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }


    class func myPosts(
        succeeded:(results:[PJPost]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            
            let queryPost = PJPost.query()
            queryPost!.whereKey("active", equalTo:true)
            queryPost!.whereKey("archived", equalTo:false)
            queryPost!.whereKey("inappropriate", notEqualTo:true)
            queryPost!.whereKey("createdBy", equalTo: DEVICE_UUID)
            
            
            let queryTag = PJHashTag.query()
            queryTag!.whereKey("post", matchesQuery:queryPost!)
            queryTag!.includeKey("post")
//            // Limit what could be a lot of points.
//            queryTag!.limit = 100
            // Final list of objects
            //                self.postsNearMe =
            
            queryTag!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    var posts = [PJPost]()
                    var postsSet:Set<String> = Set<String>()
                    NSLog("results hash: \(objects!.count)")
                    for hashTag in objects as! [PJHashTag] {
                        if !postsSet.contains(hashTag.post.objectId!) {
                            posts.append(hashTag.post)
                            postsSet.insert(hashTag.post.objectId!) // is it strictly to avoid duplicates
                        }
                    }
                    NSLog("results post: \(posts.count)")
                    NSLog("results set : \(postsSet.count)")
                    
                    succeeded(results: posts)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
}
