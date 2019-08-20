//
//  DashboardPSHeaderModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardPSHeaderModel: Record
{
    var PS_Id : Int!
    var Region_Code : String!
    var Value : Double!
    var Doc_Month : Int!
    var Doc_Year : Int!
    var Processed_Date : Date!
    var Doc_Type_Code : Int!
    var Doc_Type_Name : String!
    var Display_Order : Int!
    
    init(dict : NSDictionary)
    {
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Code") as? String)
        
        if let docTypeCode = dict.object(forKey: "Doc_Type_Code") as? Int
        {
            self.Doc_Type_Code = docTypeCode
        }
        
        if let month = dict.object(forKey: "Month") as? Int
        {
            self.Doc_Month = month
        }
        
        if let year = dict.object(forKey: "Year") as? Int
        {
            self.Doc_Year = year
        }
        
        if let netAmount = dict.object(forKey: "Value") as? Double
        {
            self.Value = netAmount
        }
        
        self.Doc_Type_Name = checkNullAndNilValueForString(stringData: dict.object(forKey: "Document_Type") as? String)
        
        if let displayOrder = dict.object(forKey: "Display_Order") as? Int
        {
            self.Display_Order = displayOrder
        }
        
        let processedDate = checkNullAndNilValueForString(stringData: dict.object(forKey: "Processed_Date") as? String)
        if processedDate != ""
        {
            self.Processed_Date = getDateAndTimeInFormat(dateString: processedDate)
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_PS_Header
    }
    
    required init(row: Row)
    {
        PS_Id = row["PS_Id"]
        Region_Code = row["Region_Code"]
        Doc_Month = row["Doc_Month"]
        Doc_Year = row["Doc_Year"]
        Value = row["Value"]
        Processed_Date = row["Processed_Date"]
        Doc_Type_Code = row["Doc_Type_Code"]
        Doc_Type_Name = row["Doc_Type_Name"]
        Display_Order = row["Display_Order"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["PS_Id"] =  PS_Id
        container["Region_Code"] =  Region_Code
        container["Doc_Month"] =  Doc_Month
        container["Doc_Year"] =  Doc_Year
        container["Value"] =  Value
        container["Processed_Date"] =  Processed_Date
        container["Doc_Type_Code"] =  Doc_Type_Code
        container["Doc_Type_Name"] =  Doc_Type_Name
        container["Display_Order"] =  Display_Order
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "PS_Id" :PS_Id,
//            "Region_Code" : Region_Code,
//            "Doc_Month" :Doc_Month,
//            "Doc_Year" : Doc_Year,
//            "Value" : Value,
//            "Processed_Date" : Processed_Date,
//            "Doc_Type_Code" : Doc_Type_Code,
//            "Doc_Type_Name": Doc_Type_Name,
//            "Display_Order" : Display_Order
//        ]
//    }
}
