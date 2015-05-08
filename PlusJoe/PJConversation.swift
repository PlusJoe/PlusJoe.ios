//
//  PJConversation.swift
//  PlusJoe
//
//  Created by D on 5/7/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

class PJConversation: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Conversations"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    @NSManaged var post: PJPost
    @NSManaged var participants: [String] // always 2 participants
    
    
    
    
    class func findOrCreateConversation(
        post: PJPost,
        participant1: String,
        participant2: String
        ) -> (PJConversation) {
            
            let query = PJConversation.query()
            // Interested in locations near user.
            query!.whereKey("post", equalTo: post)
            query!.whereKey("participants", containsAllObjectsInArray: [participant1, participant2])
            
            
            let conversations:[PJConversation]! = query!.findObjects() as! [PJConversation]
            
            if conversations?.count > 0 {
                // return first found object
                return conversations[0]
            } else {
                // otherwise create one
                var conversation = PJConversation(className: PJConversation.parseClassName())
                conversation.post = post
                conversation.participants = [participant1, participant2]
                conversation.save()
                return conversation
            }
    }
    
    
}
