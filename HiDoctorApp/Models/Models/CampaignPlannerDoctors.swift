//
//  CampaignPlannerDoctors.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CampaignPlannerDoctors: Record
{
    var CP_Doctor_Id: Int!
    var CP_Id: Int!
    var CP_Code: String!
    var Doctor_Code: String!
    var Doctor_Region_Code: String!
    
    init(dict: NSDictionary)
    {
        self.CP_Id = dict.value(forKey: "CP_Id") as! Int
        self.CP_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Code") as? String)
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CP_DOCTORS
    }
    
    required init(row: Row)
    {
        CP_Doctor_Id = row["CP_Doctor_Id"]
        CP_Id = row["CP_Id"]
        CP_Code = row["CP_Code"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["CP_Doctor_Id"] =  CP_Doctor_Id
        container["CP_Id"] =  CP_Id
        container["CP_Code"] =  CP_Code
        container["Doctor_Code"] =  Doctor_Code
        container["Doctor_Region_Code"] =  Doctor_Region_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "CP_Doctor_Id": CP_Doctor_Id,
//            "CP_Id": CP_Id,
//            "CP_Code": CP_Code,
//            "Doctor_Code": Doctor_Code,
//            "Doctor_Region_Code": Doctor_Region_Code
//        ]
//    }
}
