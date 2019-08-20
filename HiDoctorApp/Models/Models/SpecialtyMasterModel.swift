//
//  SpecialtyMasterModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class SpecialtyMasterModel: Record
{
    var Speciality_Name: String!
    var Speciality_Code: String!
    
    init(dict: NSDictionary)
    {
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_SPECIALTIES
    }
    
    required init(row: Row)
    {
        Speciality_Name = row["Speciality_Name"]
        Speciality_Code = row["Speciality_Code"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        container["Speciality_Name"] = Speciality_Name
        container["Speciality_Code"] = Speciality_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Speciality_Name": Speciality_Name,
//            "Speciality_Code": Speciality_Code
//        ]
//    }
}
