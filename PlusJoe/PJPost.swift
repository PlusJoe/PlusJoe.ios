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
    let CLASS_NAME = "Post"
    
    
    let createdBy = "createdBy" //PFUser.objectId!
    let body =  "body" //: String
    let price =  "price" //: Int (whole amount)
    let fee = "fee" //: Int (whole amount)
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
        query.whereKey(PJPOST.createdBy, equalTo: PFUser.currentUser()!.objectId!)
        return query.getFirstObject()
    }
    
    class func createUnfinishedPost() -> (PFObject) {
        let newPost = PFObject(className: PJPOST.CLASS_NAME)
        newPost[PJPOST.location] = CURRENT_LOCATION!
        newPost[PJPOST.createdBy] = PFUser.currentUser()!.objectId!
        newPost[PJPOST.active] = false
        newPost[PJPOST.archived] = false
        newPost[PJPOST.body] = ""
        newPost[PJPOST.price] = 0
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
            queryPost.whereKey(PJPOST.location, nearGeoPoint:location, withinMiles:3000)
            queryPost.whereKey(PJPOST.active, equalTo:true)
            queryPost.whereKey(PJPOST.archived, equalTo:false)
            queryPost.whereKey(PJPOST.inappropriate, notEqualTo:true)
            queryPost.whereKey(PJPOST.createdBy, notEqualTo: PFUser.currentUser()!.objectId!)
            NSLog("Searching for string \(searchText)")
            
            
            let queryTag =  PFQuery(className:PJHASHTAG.CLASS_NAME)
            queryTag.whereKey(PJHASHTAG.post, matchesQuery:queryPost)
            if searchText != "" {
                queryTag.whereKey(PJHASHTAG.hashTag, equalTo: searchText)
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
            postQuery.whereKey(PJPOST.createdBy, equalTo: PFUser.currentUser()!.objectId!)
            postQuery.whereKey(PJPOST.active, equalTo:true)
            postQuery.whereKey(PJPOST.archived, equalTo:false)
            postQuery.whereKey(PJPOST.inappropriate, notEqualTo:true)
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

    
    class func notifyBookmarksAboutNewPost(post:PFObject,
        succeeded:() -> (),
        failed:(error: NSError!) -> ()
        ) {
        // load all hashtags of the post
        //   for each hashtg, load all bookmarks with in 100 miles radius
        //     for each bookmark, create conversation, chat message and alert
        
        NSLog("Notifyng bookmarks after creating new post...")
        PJHashTag.loadTagsForPostInBackground(post,
            succeeded: { (hashTags) -> () in
                NSLog("found \(hashTags.count) hashTags to notify")
                for hashTag in hashTags {
                    NSLog("notifying about \(hashTag[PJHASHTAG.hashTag]!) hashtag")
                    
                    let query = PFQuery(className:PJFOLLOWING.CLASS_NAME)
                    query.whereKey(PJFOLLOWING.location, nearGeoPoint:post[PJPOST.location] as! PFGeoPoint)
                    query.whereKey(PJFOLLOWING.createdBy, notEqualTo: PFUser.currentUser()!.objectId!)
                    query.whereKey(PJFOLLOWING.hashTag, equalTo: hashTag[PJHASHTAG.hashTag]!)
                    query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            NSLog("there are \((objects?.count)!) followings to notify about new post")
                            for bookmark in objects as! [PFObject] {
                                let conversation = PJConversation.findOrCreateConversation(post, participant2id: bookmark[PJFOLLOWING.createdBy] as! String)
                                PJChatMessage.createChatMessageAndAlert(
                                    conversation!,
                                    body: "Here is a new post matching one of your bookmarks.",
                                    createdBy: post[PJPOST.createdBy] as! String,
                                    success: { (result) -> () in
                                        succeeded()
                                }, failed: { (error) -> () in
                                    failed(error: error)
                                })
                                
                            }
                        } else {
                            // Log details of the failure
                            failed(error: error)
                        }
                    })

                    
                }
            }) { (error) -> () in
                failed(error: error!)
        }
        
    }
    
}
