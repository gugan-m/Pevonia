//
//  TourPlannerSFC.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TourPlannerSFC: Record
{
    var TP_SFC_Id: Int! // DCR Travel id
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var Distance_fare_Code: String?
    var SFC_Version: Int?
    var TP_Id: Int! //--> For DCR code
    var SFC_Category_Name : String?
    var Flag: Int! = 1
    var TP_Entry_Id: Int!
    var Region_Code : String?
    
    init(dict: NSDictionary)
    {
        if let tpEntryId = dict.value(forKey: "TP_Entry_Id") as? Int
        {
            self.TP_Entry_Id = tpEntryId
        }
        else
        {
            self.TP_Entry_Id = 0
        }
        self.TP_Id = dict.value(forKey: "TP_Id") as? Int ?? 0
        self.From_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "From_Place") as? String)
        self.To_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "To_Place") as? String)
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        self.Distance = 0
        
        if let km = dict.value(forKey: "Distance") as? String
        {
            self.Distance = Float(km)
        }
        else
        {
            if let km = dict.value(forKey: "Distance") as? Float
            {
                self.Distance = Float(km)
            }
        }
        
        self.SFC_Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Category_Name") as? String)
        self.Distance_fare_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Fare_Code") as? String)
        self.SFC_Version = dict.value(forKey: "SFC_Version") as? Int ?? 0
        self.Flag = dict.value(forKey: "Flag") as? Int ?? 0
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Region_Code") as? String)
        super.init()

    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_SFC
    }
    
    required init(row: Row)
    {
        TP_SFC_Id = row["TP_SFC_Id"]
        TP_Id = row["TP_Id"]
        From_Place = row["From_Place"]
        To_Place = row["To_Place"]
        Travel_Mode = row["Travel_Mode"]
        Distance = row["Distance"]
        Distance_fare_Code = row["Distance_fare_Code"]
        SFC_Version = row["SFC_Version"]
        TP_Id = row["TP_Id"]
        SFC_Category_Name = row["SFC_Category_Name"]
        Flag = row["Flag"]
        TP_Entry_Id = row["TP_Entry_Id"]
        Region_Code = row["Region_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Id"] =  TP_Id
        container["From_Place"] = From_Place
        container["To_Place"] = To_Place
        container["Travel_Mode"] = Travel_Mode
        container["Distance"] = Distance
        container["SFC_Category_Name"] = SFC_Category_Name
        container["Distance_fare_Code"] = Distance_fare_Code
        container["SFC_Version"] = SFC_Version
        container["Flag"] = Flag
        container["TP_Entry_Id"] = TP_Entry_Id
        container["Region_Code"] = Region_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//
//            "TP_Id": TP_Id,
//            "From_Place": From_Place,
//            "To_Place": To_Place,
//            "Travel_Mode": Travel_Mode,
//            "Distance": Distance,
//            "SFC_Category_Name": SFC_Category_Name,
//            "Distance_fare_Code": Distance_fare_Code,
//            "SFC_Version": SFC_Version,
//            "Flag": Flag,
//            "TP_Entry_Id": TP_Entry_Id,
//            "Region_Code": Region_Code
//        ]
//    }
}


