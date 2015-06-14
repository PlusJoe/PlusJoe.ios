//
//  PJAlert.swift
//  PlusJoe
//
//  Created by D on 5/3/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

//Types of alerts:
//- bookmark
//    * new Post created matching bookmarks hashtag
//- converstaion
//    * someone replied to my post
//
//
//
//Really just one type of alert, when there is some new chat message. Here is some logic to acheive it:
//* replying to new post, always create a conversation first
//* when a bookmark match is detected, it has to create a conversation and a chat message (with alert)
//
//As such, alert should always contain a reference to a chat message.



import Foundation
import Parse

let PJALERT:PJAlert = PJAlert()
class PJAlert: BaseDataModel {
    let CLASS_NAME = "Alert"
    
    let chatMessage = "chatMessage" //: PJChatMessage
    let targetUser = "targetUser" //: String
    let read = "read" //: Bool
    
    
    class func loadMyAlerts(
        succeeded:(alerts:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PFQuery(className:PJALERT.CLASS_NAME)
            alertsQuery.includeKey("chatMessage.conversation.post")
//            alertsQuery.whereKey(PJALERT.read, equalTo: false)
            alertsQuery.whereKey(PJALERT.targetUser, equalTo: PFUser.currentUser()!.objectId!)
            alertsQuery.orderByDescending("createdAt")

            
            alertsQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(alerts: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

    
    class func loadUnreadAlerts(
        succeeded:(alerts:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PFQuery(className:PJALERT.CLASS_NAME)
            alertsQuery.includeKey("chatMessage.conversation.post")
            alertsQuery.whereKey(PJALERT.read, equalTo: false)
            alertsQuery.whereKey(PJALERT.targetUser, equalTo: PFUser.currentUser()!.objectId!)
            alertsQuery.orderByDescending("createdAt")

            alertsQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(alerts: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    class func loadUnreadAlertsCount(
        succeeded:(alertsCount:Int) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PFQuery(className:PJALERT.CLASS_NAME)
            alertsQuery.whereKey(PJALERT.read, equalTo: false)
            alertsQuery.whereKey(PJALERT.targetUser, equalTo: PFUser.currentUser()!.objectId!)
            alertsQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(alertsCount: objects!.count)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

}
