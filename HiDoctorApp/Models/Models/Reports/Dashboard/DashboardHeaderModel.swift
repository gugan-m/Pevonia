//
//  DashboardHeaderModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardHeaderModel: Record
{
    var Dashboard_Id: Int!
    var User_Code: String!
    var Region_Code: String!
    var Last_Update_Date: Date!
    
    init(dict: NSDictionary, userCode: String, regionCode: String)
    {
        self.User_Code = userCode
        self.Region_Code = regionCode
        self.Last_Update_Date = getDateAndTimeInFormat(dateString: dict.value(forKey: "LastUpdatedDate") as! String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DASHBOARD_HEADER
    }
    
    required init(row: Row)
    {
        Dashboard_Id = row["Dashboard_Id"]
        User_Code = row["User_Code"]
        Region_Code = row["Region_Code"]
        Last_Update_Date = row["Last_Update_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["Dashboard_Id"] =  Dashboard_Id
        container["User_Code"] =  User_Code
        container["Region_Code"] =  Region_Code
        container["Last_Update_Date"] =  Last_Update_Date
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Dashboard_Id": Dashboard_Id,
//            "User_Code": User_Code,
//            "Region_Code": Region_Code,
//            "Last_Update_Date": Last_Update_Date
//        ]
//    }
}
