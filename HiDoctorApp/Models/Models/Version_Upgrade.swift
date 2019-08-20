//
//  Version_Upgrade.swift
//  HiDoctorApp
//
//  Created by SwaaS on 21/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class VersionUpgradeModel: Record
{
    var Version_Number: String!
    var Is_Version_Update_Completed: Int!
    
    init(dict: NSDictionary)
    {
        self.Version_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Version_Number") as? String)
        self.Is_Version_Update_Completed = dict.value(forKey: "Is_Version_Update_Completed") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_VERSION_UPGRADE_INFO
    }
    
    required init(row: Row)
    {
        Version_Number = row["Version_Number"]
        Is_Version_Update_Completed = row["Is_Version_Update_Completed"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Version_Number"] = Version_Number
        container["Is_Version_Update_Completed"] = Is_Version_Update_Completed
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Version_Number": Version_Number,
//            "Is_Version_Update_Completed": Is_Version_Update_Completed
//        ]
//    }
}
