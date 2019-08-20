//
//  DashboardDateDetailsModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardDateDetailsModel: Record
{
    var Dashboard_Date_Detail_Id: Int!
    var Dashboard_Detail_Id: Int!
    var Dashboard_Id: Int!
    var Activity_Date: Date!
    var Activity: Int!
    
    init(dict: NSDictionary, dashboardDetailId: Int, dashboardId: Int)
    {
        self.Dashboard_Detail_Id = dashboardDetailId
        self.Dashboard_Id = dashboardId
        self.Activity_Date = convertDateIntoString(dateString: dict.value(forKey: "Activity_Date") as! String)
        self.Activity = dict.value(forKey: "Activity") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DASHBOARD_DATE_DETAILS
    }
    
    required init(row: Row)
    {
        Dashboard_Date_Detail_Id = row["Dashboard_Date_Detail_Id"]
        Dashboard_Detail_Id = row["Dashboard_Detail_Id"]
        Dashboard_Id = row["Dashboard_Id"]
        Activity_Date = row["Activity_Date"]
        Activity = row["Activity"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Dashboard_Date_Detail_Id"] =  Dashboard_Date_Detail_Id
        container["Dashboard_Detail_Id"] =  Dashboard_Detail_Id
        container["Dashboard_Id"] =  Dashboard_Id
        container["Activity_Date"] =  Activity_Date
        container["Activity"] =  Activity
        
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Dashboard_Date_Detail_Id": Dashboard_Date_Detail_Id,
//            "Dashboard_Detail_Id": Dashboard_Detail_Id,
//            "Dashboard_Id": Dashboard_Id,
//            "Activity_Date": Activity_Date,
//            "Activity": Activity
//        ]
//    }
}
