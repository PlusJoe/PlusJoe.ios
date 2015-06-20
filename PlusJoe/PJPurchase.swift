//
//  PJPurchase.swift
//  PlusJoe
//
//  Created by D on 6/19/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse


let PJPURCHASE:PJPurchase = PJPurchase()

class PJPurchase: BaseDataModel {
    let CLASS_NAME = "Purchase"
    
    let post = "post" //PJPost
    
    let purchasedBy = "" //String
    let status = "" // ""|"Pending"|"Purchased"
    let purchasedAt = NSDate()
    
    
    
    class func createOrSelectPurchase(
        post:PJPost,
        purchasedBy: PFUser, // currentUser
        succeeded:(result:PFObject) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            //first see if the purchase already created
            
            let purchaseQuery = PFQuery(className:PJPURCHASE.CLASS_NAME)
//            purchaeQuery.includeKey("post")
            purchaseQuery.whereKey(PJPURCHASE.post, equalTo: post)
            purchaseQuery.whereKey(PJPURCHASE.purchasedBy, equalTo: purchasedBy)
            
            purchaseQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil  {
                    if objects?.count == 0 {
//                        create a new purchase object
                        
                        
                        let newPurchase = PFObject(className: PJPURCHASE.CLASS_NAME)
                        newPurchase[PJPURCHASE.post] = post
                        newPurchase[PJPURCHASE.purchasedBy] = purchasedBy
                        newPurchase[PJPURCHASE.status] = "Pending"
                        newPurchase.saveInBackgroundWithBlock({ (succeeded2:Bool, error2:NSError?) -> Void in
                            if error2 == nil {
                                succeeded(result: newPurchase)
                            } else {
                                failed(error: error2)
                            }
                        })

                    } else {
                        succeeded(result: objects?[0] as! PFObject)
                    }
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
}
