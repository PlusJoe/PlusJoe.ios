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
    
    
    
    class func createOrSelectPurchase(
        post:PFObject,
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
                        newPurchase[PJPURCHASE.purchasedBy] = purchasedBy.objectId!
                        newPurchase[PJPURCHASE.soldBy] = post[PJPOST.createdBy] as! String
                        newPurchase[PJPURCHASE.status] = "Pending"
                        newPurchase.save()
                        succeeded(result: newPurchase)
                    } else {
                        succeeded(result: objects?[0] as! PFObject)
                    }
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }
    
    class func getPendingPurchases(
        seller:String,//seller's objectId
        succeeded:(results:[PFObject]) -> (),
        failed:(error: NSError!) -> ()
        ) -> () {
            let purchaseQuery = PFQuery(className:PJPURCHASE.CLASS_NAME)
            purchaseQuery.includeKey("post")
            purchaseQuery.whereKey(PJPURCHASE.soldBy, equalTo: seller)
//            purchaseQuery.whereKey(PJPURCHASE.status, equalTo: pen)
            
            purchaseQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil  {
                    NSLog("found \((objects?.count)!) pending purchasess")                    
                    succeeded(results: objects as! [PFObject])
                } else {
                    // Log details of the failure
                    failed(error: error)
                }
            })
    }

    
}
