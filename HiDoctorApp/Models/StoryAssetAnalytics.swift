//
//  StoryAssetAnalytics.swift
//  HiDoctorApp
//
//  Created by Vijay on 31/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class StoryAssetAnalytics: Record
{
    var Story_Id: NSNumber!
    var DA_Code: Int!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var Visit_DateTime: Date!
    var TimeZone: String!
    var Is_Synched: Int!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Customer_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Region_Code") as? String)
        self.TimeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "TimeZone") as? String)
        self.Is_Synched = dict.value(forKey: "Is_Synched") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MC_STORY_ASSET_LOG
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        DA_Code = row["DA_Code"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Visit_DateTime = row["Visit_DateTime"]
        TimeZone = row["TimeZone"]
        Is_Synched = row["Is_Synched"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["DA_Code"] = DA_Code
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Visit_DateTime"] = Visit_DateTime
        container["TimeZone"] = TimeZone
        container["Is_Synched"] = Is_Synched
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "DA_Code": DA_Code,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code,
//            "Visit_DateTime": Visit_DateTime,
//            "TimeZone": TimeZone,
//            "Is_Synched": Is_Synched
//        ]
//
//        return dict
//    }
}

class StoryLocalAssetAnalytics: Record
{
    var Story_Id: NSNumber!
    var DA_Code: Int!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var Visit_DateTime: Date!
    var TimeZone: String!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Customer_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Region_Code") as? String)
        self.Visit_DateTime = getStringInFormatDate(dateString: dict.value(forKey: "Visit_DateTime") as! String)
        self.TimeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "TimeZone") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_LOCAL_STORY_ASSET_LOG
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        DA_Code = row["DA_Code"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Visit_DateTime = row["Visit_DateTime"]
        TimeZone = row["TimeZone"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["DA_Code"] = DA_Code
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Visit_DateTime"] = Visit_DateTime
        container["TimeZone"] = TimeZone
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "DA_Code": DA_Code,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code,
//            "Visit_DateTime": Visit_DateTime,
//            "TimeZone": TimeZone
//        ]
//        
//        return dict
//    }
}
