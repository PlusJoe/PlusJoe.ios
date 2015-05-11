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
    let CLASS_NAME = "Conversations"
    
    let post = "post" //: PJPost
    let participants = "participants" //: [String] // always 2 participants
    
    
    
    
    class func findOrCreateConversation(
        post: PFObject,
        participant1: String,
        participant2: String
        ) -> (PFObject) {
            
            let query = PFQuery(className:PJCONVERSATION.CLASS_NAME)
            // Interested in locations near user.
            query.whereKey(PJCONVERSATION.post, equalTo: post)
            query.whereKey(PJCONVERSATION.participants, containsAllObjectsInArray: [participant1, participant2])
            
            
            let conversations:[PFObject]? = query.findObjects() as! [PFObject]?
            
            if conversations!.count > 0 {
                // return first found object
                return conversations![0]
            } else {
                // otherwise create one
                var conversation = PFObject(className: PJCONVERSATION.CLASS_NAME)
                conversation[PJCONVERSATION.post] = post
                conversation[PJCONVERSATION.participants] = [participant1, participant2]
                conversation.save()
                return conversation
            }
    }
    
    
}
