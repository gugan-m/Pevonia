//
//  PrivilegeModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class PrivilegeModel: Record
{
    var Privilege_Name: String!
    var Privilege_Value: String!
    
    init(dict: NSDictionary)
    {
        self.Privilege_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Privilege_Name") as? String)
        self.Privilege_Value = checkNullAndNilValueForString(stringData: dict.value(forKey: "Privilege_Value") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_PRIVILEGES
    }
    
    required init(row: Row)
    {
        Privilege_Name = row["Privilege_Name"]
        Privilege_Value = row["Privilege_Value"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Privilege_Name"] = Privilege_Name
        container["Privilege_Value"] = Privilege_Value
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Privilege_Name": Privilege_Name,
//            "Privilege_Value": Privilege_Value
//            ]
//    }
}
