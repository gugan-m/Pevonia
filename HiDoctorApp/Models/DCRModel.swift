//
//  DCRModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRModel: NSObject
{
    static let sharedInstance : DCRModel = DCRModel()
    
    var dcrId: Int!
    var dcrFlag: Int!
    var dcrCode: String!
    var dcrDateString: String!
    var dcrDate: Date!
    var dcrStatus: Int!
    var expenseEntityCode: String!
    var expenseEntityName: String!
    var accompanistDownloadRequestId: Int!
    var doctorVisitId : Int!
    var doctorName : String!
    var doctorSpeciality : String!
    var customerEntityType: String!
    var customerVisitId: Int!
    //var customerId : Int!
    var doctorVisitCode : String!
    var customerCode : String!
    var customerRegionCode : String!
    var deleteDCRFilterList: [String]!
    var userDetail : ApprovalUserMasterModel!
}
class ChemistDay: NSObject
{
    static let sharedInstance : ChemistDay = ChemistDay()
    var customerId: Int!
    var customerCode: String!
    var customerName: String!
    var regionCode : String!
    var regionName: String!
    var localArea: String!
    var customerEntityType : String!
    var SpecialityName : String!
    var chemistVisitId: Int!
    var chemistVisitCode: String?
}

