//
//  CompanyDetails.swift
//  HiDoctorApp
//
//  Created by Vijay on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CompanyDetails: Record {
    
    var companyId: Int!
    var companyCode : String!
    var companyName: String!
    var subDomain: String!
    var companyURL: String!
    var geoLocation: Int!
    var displayName: String!
    var companyLogoURL: String!
    var payrollIntegrated: Int!
    
    init(dict: NSDictionary) {
        
        self.companyId = dict.value(forKey: "Company_Id") as? Int
        self.companyCode = dict.value(forKey: "Company_Code") as? String
        self.companyName = dict.value(forKey: "Company_Name") as? String
//        self.subDomain = checkNullAndNilValueForString(stringData: dict.value(forKey: "SubDomain") as? String)
        self.companyURL = checkNullAndNilValueForString(stringData: dict.value(forKey: "Company_Url") as? String)
        self.geoLocation = dict.value(forKey: "Geo_location_Support") as? Int
        self.displayName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Display_Name") as? String)
        self.companyLogoURL = checkNullAndNilValueForString(stringData: dict.value(forKey: "Company_Logo_Url") as? String)
        self.payrollIntegrated = dict.value(forKey: "Payroll_Integrated") as? Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_COMP_DETAILS
    }
    
    required init(row: Row) {
        
        companyId = row["Company_Id"]
        companyCode = row["Company_Code"]
        companyName = row["Company_Name"]
        companyURL = row["Company_Url"]
        geoLocation = row["Geo_location_Support"]
        displayName = row["Display_Name"]
        companyLogoURL = row["Logo_URL"]
        payrollIntegrated = row["Payroll_Integrated"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["Company_Id"] =  companyId
        container["Company_Code"] =  companyCode
        container["Company_Name"] =  companyName
        container["Company_Url"] =  companyURL
        container["Geo_location_Support"] =  geoLocation
        container["Display_Name"] =  displayName
        container["Logo_URL"] =  companyLogoURL
        container["Payroll_Integrated"] =  payrollIntegrated
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Company_Id": companyId,
//            "Company_Code": companyCode,
//            "Company_Name": companyName,
//            "Company_Url": companyURL,
//            "Geo_location_Support": geoLocation,
//            "Display_Name": displayName,
//            "Logo_URL": companyLogoURL,
//            "Payroll_Integrated": payrollIntegrated
//        ]
//    }
    
//    func getCompanyModel(dict: NSDictionary] -> CompanyDetails {
//        
//        let companyDetails = CompanyDetails()
//        
//        companyDetails.companyId = dict.value(forKey: "Company_Id") as! Int
//        companyDetails.companyCode = dict.value(forKey: "Company_Code") as! String
//        companyDetails.companyName = dict.value(forKey: "Company_Name") as! String
//        
//        if let subDomain = dict.value(forKey: "SubDomain") as? String {
//            companyDetails.subDomain = subDomain
//        } else {
//            companyDetails.subDomain = ""
//        }
//        
//        if let companyUrl = dict.value(forKey: "Company_Url") as? String {
//            companyDetails.companyURL = companyUrl
//        } else {
//            companyDetails.companyURL = ""
//        }
//        
//        if let geoLocation = dict.value(forKey: "Geo_location_Support") as? Int {
//            companyDetails.geoLocation = geoLocation
//        } else {
//            companyDetails.geoLocation = 0
//        }
//        
//        if let displayName = dict.value(forKey: "Display_Name") as? String {
//            companyDetails.displayName = displayName
//        } else {
//            companyDetails.displayName = ""
//        }
//        
//        if let companyLogoUrl = dict.value(forKey: "Company_Logo_Url") as? String {
//            companyDetails.companyLogoURL = companyLogoUrl
//        } else {
//            companyDetails.companyLogoURL = ""
//        }
//        
//        if let payroll = dict.value(forKey: "Payroll_Integrated") as? Int {
//            companyDetails.payrollIntegrated = payroll
//        } else {
//            companyDetails.payrollIntegrated = 0
//        }
//        
//        return companyDetails
//    }

}
