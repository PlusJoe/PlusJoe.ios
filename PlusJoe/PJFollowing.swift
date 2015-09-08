//
//  PJBookmark.swift
//  PlusJoe
//
//  Created by D on 5/14/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

let PJFOLLOWING:PJFollowing = PJFollowing()
class PJFollowing: BaseDataModel {
    let CLASS_NAME = "Following"
    
    let hashTag = "hashTag" //: String
    let createdBy = "createdBy" // String
    let location = "location" //: PFGeoPoint

    
    class func loadHashTagsImFollowing(
        succeeded:(hashTags:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let query = PFQuery(className:PJFOLLOWING.CLASS_NAME)
            query.whereKey(PJFOLLOWING.createdBy, equalTo: PFUser.currentUser()!.objectId!)
            query.orderByAscending(PJFOLLOWING.hashTag)
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(hashTags: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
 
    
    class func createOrUpdateTagsImFollowing(hashTag:String,
        succeeded:(succeeds: Bool) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
        var following = PFObject(className: PJFOLLOWING.CLASS_NAME)

        let query = PFQuery(className:PJFOLLOWING.CLASS_NAME)
        query.whereKey(PJFOLLOWING.createdBy, equalTo: PFUser.currentUser()!.objectId!)
        query.whereKey(PJFOLLOWING.hashTag, equalTo: hashTag)
        query.getFirstObjectInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
            if error != nil || object == nil {
                // Log details of the failure
                NSLog("Error finding followings or non found: \(error)")
                // and create new object
                NSLog("creating new followings: \(hashTag)")
                following[PJFOLLOWING.location] = CURRENT_LOCATION!
                following[PJFOLLOWING.createdBy] = PFUser.currentUser()!.objectId!
                following[PJFOLLOWING.hashTag] = hashTag
            } else {
                // lets update existing object
                NSLog("updating followings: \(hashTag)")
                following = object!
                following[PJFOLLOWING.location] = CURRENT_LOCATION!
            }
            following.saveInBackgroundWithBlock({ (succeeds: Bool, error:NSError?) -> Void in
                if error == nil {
                    succeeded(succeeds: succeeds.boolValue)
                } else {
                    failed(error: error)
                }
            })
        }
        
    }
}