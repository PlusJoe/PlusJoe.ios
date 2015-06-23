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
    
    let purchasedBy = "purchasedBy" //String
    let soldBy = "soldBy" //String
    let status = "status" // ""|"Pending"|"Purchased"
    let purchasedAt = NSDate()
    
    
    
    class func createPurchase(
        post:PFObject,
//        purchasedBy: PFUser, // currentUser
        succeeded:(result:PFObject) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            //first see if the purchase already created
            let purchaseQuery = PFQuery(className:PJPURCHASE.CLASS_NAME)
            //            purchaeQuery.includeKey("post")
//            purchaseQuery.whereKey(PJPURCHASE.post, equalTo: post)
            purchaseQuery.whereKey(PJPURCHASE.purchasedBy, equalTo: (PFUser.currentUser()?.objectId)!)
            purchaseQuery.whereKey(PJPURCHASE.status, equalTo: "Pending")
            
            purchaseQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil  {
                    for purchase in (objects as! [PFObject]) {
                        purchase.deleteInBackgroundWithBlock(nil)
                    }
                    
                    //                        create a new purchase object
                    let newPurchase = PFObject(className: PJPURCHASE.CLASS_NAME)
                    newPurchase[PJPURCHASE.post] = post
                    newPurchase[PJPURCHASE.purchasedBy] = PFUser.currentUser()?.objectId!
                    newPurchase[PJPURCHASE.soldBy] = post[PJPOST.createdBy] as! String
                    newPurchase[PJPURCHASE.status] = "Pending"
                    newPurchase.save()
                    succeeded(result: newPurchase)
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    class func arePendingPurchasesPresent() -> (Bool) {
        let purchaseQuery = PFQuery(className:PJPURCHASE.CLASS_NAME)
        purchaseQuery.whereKey(PJPURCHASE.soldBy, equalTo: (PFUser.currentUser()?.objectId)!)
        purchaseQuery.whereKey(PJPURCHASE.status, equalTo: "Pending")
 
        if purchaseQuery.countObjects() == 0 {
            return false
        }
        return true
    }
    
    
}
