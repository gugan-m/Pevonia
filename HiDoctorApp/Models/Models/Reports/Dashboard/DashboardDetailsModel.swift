//
//  DashboardDetailsModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardDetailsModel: Record
{
    var Dashboard_Detail_Id: Int!
    var Dashboard_Id: Int!
    var Entity_Id: Int!
    var Current_Month_Value: Float!
    var Previous_Month_Value: Float!
    var Count: Int!
    var Is_Self: Int!
    
    init(dict: NSDictionary, dashboardId: Int)
    {
        self.Dashboard_Id = dashboardId
        self.Entity_Id = dict.value(forKey: "EntityType") as! Int
        self.Current_Month_Value = Float(dict.value(forKey: "CurMonthValue") as! Double)
        self.Previous_Month_Value = Float(dict.value(forKey: "PreMonthValue") as! Double)
        self.Count = 0
        
        if let count = dict.value(forKey: "Count") as? Int
        {
            self.Count = count
        }
        
        self.Is_Self = 1
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DASHBOARD_DETAILS
    }
    
    required init(row: Row)
    {
        Dashboard_Detail_Id = row["Dashboard_Detail_Id"]
        Dashboard_Id = row["Dashboard_Id"]
        Entity_Id = row["Entity_Id"]
        Current_Month_Value = row["Current_Month_Value"]
        Previous_Month_Value = row["Previous_Month_Value"]
        Count = row["Count"]
        Is_Self = row["Is_Self"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Dashboard_Detail_Id"] =  Dashboard_Detail_Id
        container["Dashboard_Id"] =  Dashboard_Id
        container["Entity_Id"] =  Entity_Id
        container["Current_Month_Value"] =  Current_Month_Value
        container["Previous_Month_Value"] =  Previous_Month_Value
        container["Count"] =  Count
        container["Is_Self"] =  Is_Self
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Dashboard_Detail_Id": Dashboard_Detail_Id,
//            "Dashboard_Id": Dashboard_Id,
//            "Entity_Id": Entity_Id,
//            "Current_Month_Value": Current_Month_Value,
//            "Previous_Month_Value": Previous_Month_Value,
//            "Count": Count,
//            "Is_Self": Is_Self,
//        ]
//    }
}
