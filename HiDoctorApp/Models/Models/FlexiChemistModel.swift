//
//  FlexiChemistModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class FlexiChemistModel: Record
{
    var Flexi_Chemist_Id: Int!
    var Flexi_Chemist_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Flexi_Chemist_Name = dict.value(forKey: "Flexi_Chemist_Name") as! String
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_FLEXI_CHEMIST
    }
    
    required init(row: Row)
    {
        Flexi_Chemist_Id = row["Flexi_Chemist_Id"]
        Flexi_Chemist_Name = row["Flexi_Chemist_Name"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["Flexi_Chemist_Id"] = Flexi_Chemist_Id
        container["Flexi_Chemist_Name"] = Flexi_Chemist_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Flexi_Chemist_Id": Flexi_Chemist_Id,
//            "Flexi_Chemist_Name": Flexi_Chemist_Name
//        ]
//    }
}
