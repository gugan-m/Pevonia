//
//  DCRDetail.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRDetail: NSObject {
    
    var dcrId : Int!
    var dcrFlag : Int!
    var dcrCode : String? = ""
    var dcrStatus : Int!
    var workPlace : String? = ""
    var cpName : String? = ""
    var doctorVisitCount : Int? = 0
    var doctorPendingVisitCount : Int? = 0
    var chemistEntryCount : Int? = 0
    var rcpaEntryCount : Int? = 0
    var stockiestEntryCount : Int? = 0
    var expensesEntryCount : Int? = 0
    var attendanceActivityCount : Int? = 0
    var leaveName : String? = ""
    var unapprovedBy : String? = ""
    var unapprovedReason : String? = ""
    var categoryName : String? = ""
    var categoryCode : String? = ""
    var categoryId : Int!
    var isLocked: Int!
    var selectedDate: Date!
}
