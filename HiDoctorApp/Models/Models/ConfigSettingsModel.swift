//
//  ConfigSettingsModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class ConfigSettingsModel: Record
{
    var Config_Name: String!
    var Config_Value: String!
    
    init(dict: NSDictionary)
    {
        self.Config_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Config_Name") as? String)
        self.Config_Value = checkNullAndNilValueForString(stringData: dict.value(forKey: "Config_Value") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_CONFIG_SETTINGS
    }
    
    required init(row: Row)
    {
        Config_Name = row["Config_Name"]
        Config_Value = row["Config_Value"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Config_Name"] = Config_Name
        container["Config_Value"] = Config_Value
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Config_Name": Config_Name,
//            "Config_Value": Config_Value
//        ]
//    }
}
