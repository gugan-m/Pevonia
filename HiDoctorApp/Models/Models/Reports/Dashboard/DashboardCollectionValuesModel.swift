//
//  DashboardCollectionValuesModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardCollectionValuesModel: Record
{
    var Collection_Id  :Int!
    var Region_Code : String!
    var Collection_Value : Double!
    var OutStanding_Value : Double!
    var Month : Int!
    var Year : Int!
    var Processed_Date : Date!

    init(dict : NSDictionary)
    {
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Code") as? String)
        
        if let month = dict.object(forKey: "Month") as? Int
        {
            self.Month = month
        }
        
        if let year = dict.object(forKey: "Year") as? Int
        {
            self.Year = year
        }
        
        if let collectionValue = dict.object(forKey: "Collection_value") as? Double
        {
            self.Collection_Value = collectionValue
        }
        
        if let outStandingValue = dict.object(forKey: "OutStanding_Value") as? Double
        {
            self.OutStanding_Value = outStandingValue
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
        return TRAN_PS_Collection_Values
    }
    
    required init(row: Row)
    {
        Collection_Id = row["Collection_Id"]
        Region_Code = row["Region_Code"]
        Month = row["Month"]
        Year = row["Year"]
        Collection_Value = row["Collection_Value"]
        OutStanding_Value = row["OutStanding_Value"]
        Processed_Date = row["Processed_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Collection_Id"] = Collection_Id
        container["Region_Code"] = Region_Code
        container["Month"] = Month
        container["Year"] = Year
        container["Collection_Value"] = Collection_Value
        container["OutStanding_Value"] = OutStanding_Value
        container["Processed_Date"] = Processed_Date
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return
//            [
//            "Collection_Id" :Collection_Id,
//            "Region_Code" : Region_Code,
//            "Month" :Month,
//            "Year" : Year,
//            "Collection_Value" : Collection_Value,
//            "OutStanding_Value":OutStanding_Value,
//            "Processed_Date": Processed_Date
//        ]
//    }

}
