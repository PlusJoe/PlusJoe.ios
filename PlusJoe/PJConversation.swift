//
//  PJConversation.swift
//  PlusJoe
//
//  Created by D on 5/7/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

let PJCONVERSATION:PJConversation = PJConversation()

class PJConversation: BaseDataModel {
    let CLASS_NAME = "Conversation"
    
    let post = "post" //: PJPost
    let participants = "participants" //: [String] // always 2 participants
    
    
    
    
    class func findOrCreateConversation(
        post: PFObject, // participant1 always comes from the post
        participant2id: String
        ) -> (PFObject?) {
            let participant1id:String = post[PJPOST.createdBy] as! String
            if participant1id == participant2id {
                return nil
            }

            let query = PFQuery(className:PJCONVERSATION.CLASS_NAME)
            // Interested in locations near user.
            query.whereKey(PJCONVERSATION.post, equalTo: post)
            query.whereKey(PJCONVERSATION.participants, containsAllObjectsInArray: [participant1id, participant2id])
            
            
            let conversations:[PFObject]? = query.findObjects() as! [PFObject]?
            
            if conversations!.count > 0 {
                // return first found object
                return conversations![0]
            } else {
                // otherwise create one
                var conversation = PFObject(className: PJCONVERSATION.CLASS_NAME)
                conversation[PJCONVERSATION.post] = post
                conversation[PJCONVERSATION.participants] = [participant1id, participant2id]
                conversation.save()
                return conversation
            }
    }
 
    
    class func loadConversationsImPartOf(
        succeeded:(conversations:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let conversationQuery = PFQuery(className:PJCONVERSATION.CLASS_NAME)
            conversationQuery.includeKey("post")
            conversationQuery.whereKey(PJCONVERSATION.participants, equalTo: PFUser.currentUser()!.objectId!)
            conversationQuery.orderByDescending("updatedAt")
            
            conversationQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    succeeded(conversations: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

    
}
