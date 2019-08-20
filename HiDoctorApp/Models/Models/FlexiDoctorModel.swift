//
//  FlexiDoctorModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class FlexiDoctorModel: Record
{
    var Flexi_Doctor_Id: Int!
    var Flexi_Doctor_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Flexi_Doctor_Name = dict.value(forKey: "Flexi_Doctor_Name") as! String
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_FLEXI_DOCTOR
    }
    
    required init(row: Row)
    {
        Flexi_Doctor_Id = row["Flexi_Doctor_Id"]
        Flexi_Doctor_Name = row["Flexi_Doctor_Name"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
       
        container["Flexi_Doctor_Id"] = Flexi_Doctor_Id
        container["Flexi_Doctor_Name"] = Flexi_Doctor_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Flexi_Doctor_Id": Flexi_Doctor_Id,
//            "Flexi_Doctor_Name": Flexi_Doctor_Name
//        ]
//    }
}
