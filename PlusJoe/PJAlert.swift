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
import Parse

let PJALERT:PJAlert = PJAlert()
class PJAlert: BaseDataModel {
    let CLASS_NAME = "Alerts"
    
    let chatMessage = "chatMessage" //: PJChatMessage
    let target = "target" //: String
    let read = "read" //: Bool
    
    
    class func loadUnreadAlerts(
        succeeded:(alerts:[PJAlert]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PJAlert.query()
            alertsQuery!.includeKey("chatMessage.conversation.post")
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
    
    class func loadUnreadAlertsCount(
        succeeded:(alertsCount:Int) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let alertsQuery = PJAlert.query()
            alertsQuery!.whereKey("read", equalTo: false)
            alertsQuery!.whereKey("target", equalTo: DEVICE_UUID)
            alertsQuery!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(alertsCount: objects!.count)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

}
