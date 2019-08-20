//
//  FlexiPlaceModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class FlexiPlaceModel: Record
{
    var Flexi_Place_Id: Int!
    var Flexi_Place_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Flexi_Place_Name = dict.value(forKey: "Flexi_Place_Name") as! String
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_FLEXI_PLACE
    }
    
    required init(row: Row)
    {
        Flexi_Place_Id = row["Flexi_Place_Id"]
        Flexi_Place_Name = row["Flexi_Place_Name"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Flexi_Place_Id"] = Flexi_Place_Id
        container["Flexi_Place_Name"] = Flexi_Place_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Flexi_Place_Id": Flexi_Place_Id,
//            "Flexi_Place_Name": Flexi_Place_Name
//        ]
//    }
}
