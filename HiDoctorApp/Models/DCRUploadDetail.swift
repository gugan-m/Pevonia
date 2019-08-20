//
//  DCRUploadDetail.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRUploadDetail: NSObject {
    
    var dcrId : Int!
    var dcrDate : Date!
    var statusText : String!
    var flagLabel : String!
    var reason: String = ""
    var showPopup : Bool! = false
    var failedStatusCode: Int = -1
    var flag: Int!
}
