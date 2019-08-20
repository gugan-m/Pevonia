//
//  TPModel.swift
//  HiDoctorApp
//
//  Created by Admin on 8/9/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPModel: NSObject {
    static let sharedInstance : TPModel = TPModel()
    
    var tpId: Int!
    var tpFlag: Int!
    var tpEntryId : Int! //--like DCRID
    var tpDateString: String!
    var tpDate: Date!
    var tpStatus: Int!
    var expenseEntityCode: String!
    var expenseEntityName: String!
    var accompanistDownloadRequestId: Int!
    var doctorVisitId : Int!
    var doctorName : String!
    var doctorSpeciality : String!
    //var customerId : Int!
    var doctorVisitCode : String!
    var customerCode : String!
    var isHollday: Int = 0
    var isWeekend: Int = 0
}
