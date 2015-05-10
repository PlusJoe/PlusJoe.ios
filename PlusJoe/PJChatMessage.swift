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
        conversation: PJConversation,
        succeeded:(results:[PJChatMessage]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let query = PJChatMessage.query()
            // Interested in locations near user.
            query!.whereKey("conversation", equalTo: conversation)
            query!.orderByDescending("createdAt")
            query!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.markAlertsRead(objects as! [PJChatMessage])
                    succeeded(results: objects as! [PJChatMessage])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    
    class func loadNewChatMessages(
        since: NSDate,
        conversation: PJConversation,
        succeeded:(results:[PJChatMessage]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let query = PJChatMessage.query()
            // Interested in locations near user.
            query!.whereKey("conversation", equalTo: conversation)
            query!.whereKey("createdAt", greaterThan: since)
            query!.orderByDescending("createdAt")
            
            
            query!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.markAlertsRead(objects as! [PJChatMessage])
                    succeeded(results: objects as! [PJChatMessage])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    
    class func markAlertsRead(chatMessages:[PJChatMessage]) -> () {
        for chatMessage in chatMessages {
            let alertsQuery = PJAlert.query()
            alertsQuery!.whereKey("chatMessage", equalTo: chatMessage)
            alertsQuery!.whereKey("target", equalTo: DEVICE_UUID)
            alertsQuery!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                for alert in objects as! [PJAlert] {
                    alert.read = true
                    alert.saveInBackgroundWithBlock({ (succeeds: Bool, error:NSError?) -> Void in})
                }
            })
        }
    }
    
    
    class func createChatMessage(
        conversation:PJConversation,
        body:String,
        createdBy:String,
        success:(result: PJChatMessage) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let chatMessage = PJChatMessage(className: PJChatMessage.parseClassName())
            chatMessage.conversation = conversation
            chatMessage.body = body
            chatMessage.createdBy = createdBy
            chatMessage.saveInBackgroundWithBlock { (succeeded:Bool, error:NSError?) -> Void in
                if error == nil {
                    let alert = PJAlert(className: PJAlert.parseClassName())
                    alert.chatMessage = chatMessage
                    alert.read = false
                    alert.target = (conversation.participants[0] == DEVICE_UUID) ? conversation.participants[1] : conversation.participants[0]
                    alert.saveInBackgroundWithBlock({ (succeeded:Bool, error:NSError?) -> Void in })
                    success(result: chatMessage)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            }
    }
    
}
