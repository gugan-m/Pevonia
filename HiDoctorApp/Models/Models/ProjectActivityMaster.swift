//
//  ProjectActivityMaster.swift
//  HiDoctorApp
//
//  Created by SwaaS on 04/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class ProjectActivityMaster: Record
{
    var Activity_Code: String!
    var Activity_Name: String!
    var Project_Code: String!
    var Project_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Activity_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Code") as? String)
        self.Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Name") as? String)
        self.Project_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Project_Code") as? String)
        self.Project_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Project_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_PROJECT_ACTIVITY
    }
    
    required init(row: Row)
    {
        Activity_Code = row["Activity_Code"]
        Activity_Name = row["Activity_Name"]
        Project_Code = row["Project_Code"]
        Project_Name = row["Project_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Activity_Code"] =  Activity_Code
        container["Activity_Name"] =  Activity_Name
        container["Project_Code"] =  Project_Code
        container["Project_Name"] =  Project_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Activity_Code": Activity_Code,
//            "Activity_Name": Activity_Name,
//            "Project_Code": Project_Code,
//            "Project_Name": Project_Name
//        ]
//    }
}
