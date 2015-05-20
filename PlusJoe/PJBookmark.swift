//
//  PJBookmark.swift
//  PlusJoe
//
//  Created by D on 5/14/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

let PJBOOKMARK:PJBookmark = PJBookmark()
class PJBookmark: BaseDataModel {
    let CLASS_NAME = "Bookmarks"
    
    let hashTag = "hashTag" //: String
    let createdBy = "createdBy" //uuid
    let location = "location" //: PFGeoPoint

    
    class func loadUMyBookmarks(
        succeeded:(bookmarks:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let bookmarksQuery = PFQuery(className:PJBOOKMARK.CLASS_NAME)
            bookmarksQuery.whereKey(PJBOOKMARK.createdBy, equalTo: DEVICE_UUID)
            bookmarksQuery.orderByAscending(PJBOOKMARK.hashTag)
            bookmarksQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(bookmarks: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
 
    
    class func createOrUpdateBookmark(hashTag:String,
        succeeded:(succeeds: Bool) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
        var bookmark = PFObject(className: PJBOOKMARK.CLASS_NAME)

        let bookmarksQuery = PFQuery(className:PJBOOKMARK.CLASS_NAME)
        bookmarksQuery.whereKey(PJBOOKMARK.createdBy, equalTo: DEVICE_UUID)
        bookmarksQuery.whereKey(PJBOOKMARK.hashTag, equalTo: hashTag)
        bookmarksQuery.getFirstObjectInBackgroundWithBlock { (object:PFObject?, error:NSError?) -> Void in
            if error != nil || object == nil {
                // Log details of the failure
                NSLog("Error finding bookmarks or non found: \(error)")
                // and create new object
                NSLog("creating new bookmar: \(hashTag)")
                bookmark[PJBOOKMARK.location] = CURRENT_LOCATION!
                bookmark[PJBOOKMARK.createdBy] = DEVICE_UUID
                bookmark[PJBOOKMARK.hashTag] = hashTag
            } else {
                // lets update existing object
                NSLog("updating bookmar: \(hashTag)")
                bookmark = object!
                bookmark[PJBOOKMARK.location] = CURRENT_LOCATION!
            }
            bookmark.saveInBackgroundWithBlock({ (succeeds: Bool, error:NSError?) -> Void in
                if error == nil {
                    succeeded(succeeds: succeeds)
                } else {
                    failed(error: error)
                }
            })
        }
        
    }
}
