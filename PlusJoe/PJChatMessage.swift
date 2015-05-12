//
//  PJChat.swift
//  PlusJoe
//
//  Created by D on 5/3/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

//There are only 2 parties in any given chat.
//Each chat message contains an array of both parrites, who participates in the chat, so it can always be queried on both array values.
//We query chat always by post it belongs to and both parties in the array


//To determine all my conversations, select all chat messages that contain my id and have attribute of the first message


import Foundation
import Parse

let PJCHATMESSAGE:PJChatMessage = PJChatMessage()
class PJChatMessage: BaseDataModel {
    let CLASS_NAME = "ChatMessages"
    
    let conversation = "conversation" //: PJConversation
    let body = "body" //: String // no more then 140 chars
    let createdBy = "createdBy" //: String // must match one of the partcipants in conversation
    
    
    
    class func loadAllChatMessages(
        conversation: PFObject,
        succeeded:(results:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let query = PFQuery(className:PJCHATMESSAGE.CLASS_NAME)
            // Interested in locations near user.
            query.whereKey(PJCHATMESSAGE.conversation, equalTo: conversation)
            query.orderByDescending("createdAt")
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.markAlertsRead(objects as! [PFObject])
                    succeeded(results: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    
    class func loadNewChatMessages(
        since: NSDate,
        conversation: PFObject,
        succeeded:(results:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let query = PFQuery(className:PJCHATMESSAGE.CLASS_NAME)
            // Interested in locations near user.
            query.whereKey(PJCHATMESSAGE.conversation, equalTo: conversation)
            query.whereKey("createdAt", greaterThan: since)
            query.orderByDescending("createdAt")
            
            
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.markAlertsRead(objects as! [PFObject])
                    succeeded(results: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    
    class func markAlertsRead(chatMessages:[PFObject]) -> () {
        for chatMessage in chatMessages {
            let alertsQuery = PFQuery(className:PJALERT.CLASS_NAME)
            alertsQuery.whereKey(PJALERT.chatMessage, equalTo: chatMessage)
            alertsQuery.whereKey(PJALERT.target, equalTo: DEVICE_UUID)
            alertsQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                for alert in objects as! [PFObject] {
                    alert[PJALERT.read] = true
                    alert.saveInBackgroundWithBlock({ (succeeds: Bool, error:NSError?) -> Void in})
                }
            })
        }
    }
    
    
    class func createChatMessage(
        conversation:PFObject,
        body:String,
        createdBy:String,
        success:(result: PFObject) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let chatMessage = PFObject(className: PJCHATMESSAGE.CLASS_NAME)
            chatMessage[PJCHATMESSAGE.conversation] = conversation
            chatMessage[PJCHATMESSAGE.body] = body
            chatMessage["createdBy"] = createdBy
            chatMessage.saveInBackgroundWithBlock { (succeeded:Bool, error:NSError?) -> Void in
                if error == nil {
                    let alert = PFObject(className: PJALERT.CLASS_NAME)
                    alert[PJALERT.chatMessage] = chatMessage
                    alert[PJALERT.read] = false
                    if (conversation[PJCONVERSATION.participants] as! [String])[0] == DEVICE_UUID {
                        alert[PJALERT.target] = (conversation[PJCONVERSATION.participants] as! [String])[1]
                    } else {
                        alert[PJALERT.target] = (conversation[PJCONVERSATION.participants] as! [String])[0]
                    }
                    alert.saveInBackgroundWithBlock({ (succeeded:Bool, error:NSError?) -> Void in })
                    success(result: chatMessage)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            }
    }
    
}
