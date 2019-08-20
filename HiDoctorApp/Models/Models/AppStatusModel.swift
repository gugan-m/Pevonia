//
//  AppStatusModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class AppStatusModel: Record
{
    var Is_Login_Completed: Int!
    var Is_PMD_Completed: Int!
    var Is_PMD_Accompanist_Completed: Int!
    var OverAll_Status: Int!
    
    override init()
    {
        self.Is_Login_Completed = 0
        self.Is_PMD_Completed = 0
        self.Is_PMD_Accompanist_Completed = 0
        self.OverAll_Status = 0
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_APP_STATUS
    }
    
    required init(row: Row)
    {
        Is_Login_Completed = row["Is_Login_Completed"]
        Is_PMD_Completed = row["Is_PMD_Completed"]
        Is_PMD_Accompanist_Completed = row["Is_PMD_Accompanist_Completed"]
        OverAll_Status = row["OverAll_Status"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Is_Login_Completed"] = Is_Login_Completed
        container["Is_PMD_Completed"] = Is_PMD_Completed
        container["Is_PMD_Accompanist_Completed"] = Is_PMD_Accompanist_Completed
        container["OverAll_Status"] = OverAll_Status
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Is_Login_Completed": Is_Login_Completed,
//            "Is_PMD_Completed": Is_PMD_Completed,
//            "Is_PMD_Accompanist_Completed": Is_PMD_Accompanist_Completed,
//            "OverAll_Status": OverAll_Status
//        ]
//    }
}
