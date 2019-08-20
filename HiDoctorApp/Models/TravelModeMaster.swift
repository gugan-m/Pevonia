//
//  TravelModeMaster.swift
//  HiDoctorApp
//
//  Created by SwaaS on 03/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TravelModeMaster: Record
{
    var Travel_Mode_Id: String!
    var Travel_Mode_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Travel_Mode_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "TravelMode_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TRAVEL_MODE_MASTER
    }
    
    required init(row: Row)
    {
        Travel_Mode_Id = row["Travel_Mode_Id"]
        Travel_Mode_Name = row["Travel_Mode_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Travel_Mode_Id"] = Travel_Mode_Id
        container["Travel_Mode_Name"] = Travel_Mode_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Travel_Mode_Id": Travel_Mode_Id,
//            "Travel_Mode_Name": Travel_Mode_Name
//        ]
//    }
}
