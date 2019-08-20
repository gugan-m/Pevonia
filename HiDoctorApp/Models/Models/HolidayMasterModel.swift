//
//  HolidayMasterModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class HolidayMasterModel: Record
{
    var Holiday_Name: String!
    var Holiday_Date: Date!
    
    init(dict: NSDictionary)
    {
        self.Holiday_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Holiday_Name") as? String)
        self.Holiday_Date = getStringInFormatDate(dateString: dict.value(forKey: "Holiday_Date") as! String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_HOLIDAY_MASTER
    }
    
    required init(row: Row)
    {
        Holiday_Name = row["Holiday_Name"]
        Holiday_Date = row["Holiday_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Holiday_Name"] = Holiday_Name
        container["Holiday_Date"] = Holiday_Date
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Holiday_Name": Holiday_Name,
//            "Holiday_Date": Holiday_Date
//        ]
//    }
}
