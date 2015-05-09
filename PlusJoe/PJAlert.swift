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
//* replying to new post, always create a conversation first, and a first message of a chat becomes the post itself, there is no separate conversation abstraction, the chat itself will compose the conversation, the first essage of the chat will be marked as such, so it can be queried for number to determine number of conversations.
//* when a bookmark match is detected, it has to create a conversation and a chat message that matches the post body.
//
//As such, alert should always contain a reference to a chat message.



import Foundation

class PJAlert: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Alerts"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    //    @NSManaged var post: PJPost
    @NSManaged var chatMessage: PJChatMessage
    @NSManaged var target: String
    @NSManaged var read: Bool
    
    
    class func loadUnreadAlerts(
        succeeded:(alerts:[PJAlert]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PJAlert.query()
            alertsQuery!.whereKey("read", equalTo: false)
            alertsQuery!.whereKey("target", equalTo: DEVICE_UUID)
            alertsQuery!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(alerts: objects as! [PJAlert])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
}
