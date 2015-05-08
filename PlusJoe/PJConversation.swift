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
        participant2: String,
        succeeded:(result:PJConversation) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            
            let query = PJConversation.query()
            // Interested in locations near user.
            query!.whereKey("post", equalTo: post)
            query!.whereKey("participants", containsAllObjectsInArray: [participant1, participant2])
            
            
            query!.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if objects?.count > 0 {
                        // return first found object
                        succeeded(result:(objects as! [PJConversation])[0])
                    } else {
                        // otherwise create one
                        var conversation = PJConversation(className: PJConversation.parseClassName())
                        conversation.post = post
                        conversation.participants = [participant1, participant2]
                        conversation.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                // The object has been saved.
                                succeeded(result:conversation)
                            } else {
                                // There was a problem, check error.description
                                failed(error: error)
                            }
                        }
                    }
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
}
