//
//  travelTrackingReport.swift
//  HiDoctorApp
//
//  Created by SwaaS on 21/03/19.
//  Copyright © 2019 swaas. All rights reserved.
//
import UIKit
import GRDB

class travelTrackingReport: Record
{
    var Latitude: String?
    var Longitude: String?
    var Entered_DateTime: String?
    var type1: String?
    
    init(dict: NSDictionary)
    {
        self.Latitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Latitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Entered_DateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entered_DateTime") as? String)
        self.type1 = checkNullAndNilValueForString(stringData: dict.value(forKey: "type") as? String)
        
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return Travel_Tracking_Report
    }
    
    required init(row: Row)
    {
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Entered_DateTime = row["Entered_DateTime"]
        type1 = row["type"]
       
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["Entered_DateTime"] = Entered_DateTime
        container["type"] = type1
        
    }

}

