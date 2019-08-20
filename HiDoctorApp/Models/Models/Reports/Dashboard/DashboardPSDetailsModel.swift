//
//  DashboardPSDetailsModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardPSDetailsModel: Record
{
    var PS_Details_Id : Int!
    var Region_Code : String!
    var Product_Name : String!
    var Value : Double!
    var Doc_Month : Int!
    var Doc_Year : Int!
    var Processed_Date : Date!
    
    
    init(dict : NSDictionary)
    {
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Code") as? String)
        
        if let month = dict.object(forKey: "Month") as? Int
        {
            self.Doc_Month = month
        }
        
        if let year = dict.object(forKey: "Year") as? Int
        {
            self.Doc_Year = year
        }
        
        if let value = dict.object(forKey: "Value") as? Double
        {
            self.Value = value
        }
        
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
        let processedDate = checkNullAndNilValueForString(stringData: dict.object(forKey: "Processed_Date") as? String)
        
        if processedDate != ""
        {
            self.Processed_Date = getDateAndTimeInFormat(dateString: processedDate)
        }
        
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_PS_ProductDetails
    }
    
    required init(row: Row)
    {
        PS_Details_Id = row["PS_Id"]
        Region_Code = row["Region_Code"]
        Doc_Month = row["Doc_Month"]
        Doc_Year = row["Doc_Year"]
        Value = row["Value"]
        Product_Name = row["Product_Name"]
        Processed_Date = row["Processed_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["PS_Details_Id"] = PS_Details_Id
        container["Region_Code"] = Region_Code
        container["Doc_Month"] = Doc_Month
        container["Doc_Year"] = Doc_Year
        container["Value"] = Value
        container["Product_Name"] = Product_Name
        container["Processed_Date"] = Processed_Date
    }
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        return [
    //            "PS_Details_Id" :PS_Details_Id,
    //            "Region_Code" : Region_Code,
    //            "Doc_Month" :Doc_Month,
    //            "Doc_Year" : Doc_Year,
    //            "Value" : Value,
    //            "Product_Name":Product_Name,
    //            "Processed_Date":Processed_Date
    //        ]
    //    }
    
}




