//
//  PJBuyRequest.swift
//  PlusJoe
//
//  Created by D on 6/7/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation
import Parse

let PJBUYREQUEST:PJBuyRequest = PJBuyRequest()
class PJBuyRequest: BaseDataModel {
    let CLASS_NAME = "BuyRequest"
    
    let buyerId = "buyerId" //:String
    let sellerId = "sellerId" //:String
    
    let post = "post" //: PJPost
    
    let complete = "complete" //: Bool

}
