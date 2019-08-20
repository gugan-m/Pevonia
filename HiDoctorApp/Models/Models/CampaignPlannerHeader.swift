//
//  CampaignPlannerHeader.swift
//  HiDoctorApp
//
//  Created by SwaaS on 04/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CampaignPlannerHeader: Record
{
    var CP_Id: Int!
    var CP_Code: String!
    var CP_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Category_Code: String!
    var Work_Area: String?
    var Category_Name: String?
    
    init(dict: NSDictionary)
    {
        self.CP_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Code") as? String)
        self.CP_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Name") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Name") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Work_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Work_Area") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CP_HEADER
    }
    
    required init(row: Row)
    {
        CP_Id = row["CP_Id"]
        CP_Code = row["CP_Code"]
        CP_Name = row["CP_Name"]
        Region_Code = row["Region_Code"]
        Region_Name = row["Region_Name"]
        Category_Code = row["Category_Code"]
        Work_Area = row["Work_Area"]
        Category_Name = row["Category_Name"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["CP_Id"] =  CP_Id
        container["CP_Code"] =  CP_Code
        container["CP_Name"] =  CP_Name
        container["Region_Code"] =  Region_Code
        container["Region_Name"] =  Region_Name
        container["Category_Code"] =  Category_Code
        container["Work_Area"] =  Work_Area
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "CP_Id": CP_Id,
//            "CP_Code": CP_Code,
//            "CP_Name": CP_Name,
//            "Region_Code": Region_Code,
//            "Region_Name": Region_Name,
//            "Category_Code": Category_Code,
//            "Work_Area": Work_Area
//        ]
//    }
}
