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

class PJChatMessage: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "ChatMessages"
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }

    @NSManaged var post: PJPost
    
    @NSManaged var body: String // no more then 140 chars
    @NSManaged var participants: [String] // always 2 participants
    @NSManaged var createdBy: String // must match one of the artcipants

    
}
