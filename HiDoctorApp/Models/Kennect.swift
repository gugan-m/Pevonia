//
//  Kennect.swift
//  HiDoctorApp
//
//  Created by Administrator on 24/04/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class KennectResponseModel: NSObject
{
    static let sharedInstance = KennectResponseModel()
    
    var ok: Bool!
    var createdUser: Bool!
    var token: String!
    var list: NSArray!
    
    func getSuccessApiModel (dict: NSDictionary) -> KennectResponseModel
    {
        let apiResponseObj = KennectResponseModel()

        if let ok = dict.value(forKey: "ok") as? Bool
        {
            apiResponseObj.ok = ok
        }
        else
        {
            apiResponseObj.ok = nil
        }
        
        if let token = dict.value(forKey: "token") as? String
        {
            apiResponseObj.token = token
        }
        else
        {
            apiResponseObj.token = ""
        }
        
        if let createdUser = dict.value(forKey: "createdUser") as? Bool
        {
            apiResponseObj.createdUser = createdUser
        }
        else
        {
            apiResponseObj.createdUser = nil
            
        }
        
        if let list = dict.value(forKey: "list") as? NSArray
        {
            apiResponseObj.list = list
        }
        else
        {
            apiResponseObj.list = []
        }
        
        return apiResponseObj
    }
    
    func getFailureApiModel() -> KennectResponseModel
    {
        let apiResponseObj = KennectResponseModel()
        
        apiResponseObj.ok = nil
        apiResponseObj.createdUser = nil
        apiResponseObj.token = ""
        
        return apiResponseObj
    }
    
    func getNoInternetApiModel() -> KennectResponseModel
    {
        let apiResponseObj = KennectResponseModel()
        
        apiResponseObj.ok = nil
        apiResponseObj.createdUser = nil
        apiResponseObj.token = ""
        
        return apiResponseObj
    }
}
