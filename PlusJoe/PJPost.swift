//
//  PJPost.swift
//  PlusJoe
//
//  Created by D on 3/29/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse


let PJPOST:PJPost = PJPost()

class PJPost: BaseDataModel {
    let CLASS_NAME = "Posts"
    
    
    let createdBy = "createdBy" //uuid
    let sell = "sell" //: Bool // if it's false, it's not a sell, it's a buy
    let thing = "thing" //: Bool // if it's false, it's not a thing, it's a service
    let body =  "body" //: String
    let price =  "price" //: Int
    let fee = "fee" //: Int
    let location = "location" //: PFGeoPoint
    let active = "active" //: Bool
    let archived = "archived" //: Bool
    let inappropriate = "inappropriate" //: Bool
    
    let image1file = "image1file" //: PFFile
    let image2file = "image2file" //: PFFile
    let image3file = "image3file" //: PFFile
    let image4file = "image4file" //: PFFile
    
    
    
    class func getUnfinishedPost() -> (PFObject?) {
        let query = PFQuery(className:PJPOST.CLASS_NAME)
        // Interested in locations near user.
        query.whereKey(PJPOST.active, equalTo: false)
        query.whereKey(PJPOST.archived, equalTo: false)
        query.whereKey(PJPOST.createdBy, equalTo: DEVICE_UUID)
        return query.getFirstObject()
    }
    
    class func createUnfinishedPost() -> (PFObject) {
        let newPost = PFObject(className: PJPOST.CLASS_NAME)
        newPost[PJPOST.location] = CURRENT_LOCATION!
        newPost[PJPOST.createdBy] = DEVICE_UUID
        newPost[PJPOST.sell] = true
        newPost[PJPOST.thing] = true
        newPost[PJPOST.active] = false
        newPost[PJPOST.archived] = false
        newPost[PJPOST.body] = ""
        newPost[PJPOST.fee] = 0
        newPost[PJPOST.image1file] = PFFile(name:"blank.png", data:NSData())
        newPost[PJPOST.image2file] = PFFile(name:"blank.png", data:NSData())
        newPost[PJPOST.image3file] = PFFile(name:"blank.png", data:NSData())
        newPost[PJPOST.image4file] = PFFile(name:"blank.png", data:NSData())
        newPost.save()
        return newPost
    }
    
    
    class func search(
        location: PFGeoPoint,
        searchText: String,
        succeeded:(results:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {

            let queryPost = PFQuery(className:PJPOST.CLASS_NAME)
            // Interested in locations near user.
            queryPost.whereKey(PJPOST.location, nearGeoPoint:location)
            queryPost.whereKey(PJPOST.active, equalTo:true)
            queryPost.whereKey(PJPOST.archived, equalTo:false)
            queryPost.whereKey(PJPOST.inappropriate, notEqualTo:true)
            queryPost.whereKey(PJPOST.createdBy, notEqualTo: DEVICE_UUID)
            NSLog("Searching for string \(searchText)")
            
            
            let queryTag =  PFQuery(className:PJHASHTAG.CLASS_NAME)
            queryTag.whereKey(PJHASHTAG.post, matchesQuery:queryPost)
            if searchText != "" {
                queryTag.whereKey(PJHASHTAG.tag, equalTo: searchText)
            }
            queryTag.includeKey(PJHASHTAG.post)
//            // Limit what could be a lot of points.
//            queryTag!.limit = 100
            // Final list of objects
            //                self.postsNearMe =
            
            queryTag.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    var posts = [PFObject]()
                    var postsSet:Set<String> = Set<String>()
                    NSLog("results hash: \(objects!.count)")
                    for hashTag in objects as! [PFObject] {
                        if !postsSet.contains((hashTag[PJHASHTAG.post] as! PFObject).objectId!) {
                            posts.append(hashTag[PJHASHTAG.post] as! PFObject)
                            postsSet.insert((hashTag[PJHASHTAG.post] as! PFObject).objectId!) // is it strictly to avoid duplicates
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

    
    class func loadMyPosts(
        succeeded:(posts:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let postQuery = PFQuery(className:PJPOST.CLASS_NAME)
            postQuery.whereKey(PJPOST.createdBy, equalTo: DEVICE_UUID)
            postQuery.orderByDescending("updatedAt")
            
            postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(posts: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

    
}
