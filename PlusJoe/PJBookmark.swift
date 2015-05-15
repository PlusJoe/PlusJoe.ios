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
    
    let tag = "tag" //: String
    let createdBy = "createdBy" //uuid
    let location = "location" //: PFGeoPoint

    
    class func loadUMyBookmarks(
        succeeded:(bookmarks:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let bookmarksQuery = PFQuery(className:PJBOOKMARK.CLASS_NAME)
            bookmarksQuery.whereKey(PJBOOKMARK.createdBy, equalTo: DEVICE_UUID)
            
            bookmarksQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(bookmarks: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
}
