//
//  BaseDataModel.swift
//  PlusJoe
//
//  Created by D on 3/29/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation



class BaseDataModel : NSObject {
    
    
    class func pjProtectionSpace() -> (NSURLProtectionSpace) {
        let url:NSURL = NSURL(string: PJHost)!
        
        
        let protSpace =
        NSURLProtectionSpace(
            host: url.host!,
            port: 80,
            `protocol`: url.scheme,
            realm: nil,
            authenticationMethod: nil)
        
        println("prot space: \(protSpace)")
        return protSpace
    }
    
    class func storeCredential(uuid: String)  -> () {
        let protSpace = pjProtectionSpace()
        
        if let credentials: NSDictionary = NSURLCredentialStorage.sharedCredentialStorage().credentialsForProtectionSpace(protSpace) {
            
            //remove all credentials
            for credentialKey in credentials {
                let credential = (credentials.objectForKey(credentialKey.key) as! NSURLCredential)
                NSURLCredentialStorage.sharedCredentialStorage().removeCredential(credential, forProtectionSpace: protSpace)
            }
        }
        //store new credential
        let credential = NSURLCredential(user: uuid, password: uuid, persistence: NSURLCredentialPersistence.Permanent)
        NSURLCredentialStorage.sharedCredentialStorage().setCredential(credential, forProtectionSpace: protSpace)
        
    }
    
    
    class func getStoredCredential() -> (NSURLCredential?)  {
        //check if credentials are already stored, then show it in the tune in fields
        
        if let credentials: NSDictionary? = NSURLCredentialStorage.sharedCredentialStorage().credentialsForProtectionSpace(pjProtectionSpace()) {
            return credentials?.objectEnumerator().nextObject() as! NSURLCredential?
        }
        return nil
    }
    class func clearStoredCredential() -> Void  {
        //check if credentials are already stored, then show it in the tune in fields
        NSURLCredentialStorage.sharedCredentialStorage().removeCredential(getStoredCredential()!, forProtectionSpace: pjProtectionSpace())
    }
    
}