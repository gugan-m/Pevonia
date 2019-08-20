//
//  TPTravelPlacesModel.swift
//  HiDoctorApp
//
//  Created by Admin on 8/9/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class TPTravelPlacesModel: Record
{
    var TP_SFC_Id: Int!
    var TP_Id: Int!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var SFC_Category_Name: String?
    var Distance_Fare_Code: String?
    var SFC_Version: Int?
    var Flag: Int!
    var TP_Entry_Id: String!
    var Region_Code : String?
    
    init(dict: NSDictionary)
    {
        self.TP_Id = dict.value(forKey: "TP_Id") as! Int
        self.From_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "From_Place") as? String)
        self.To_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "To_Place") as? String)
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        self.Distance = NSString(string:(dict.value(forKey: "Distance") as? String)!).floatValue
        self.SFC_Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Category_Name") as? String)
        self.Distance_Fare_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Fare_Code") as? String)
        self.SFC_Version = dict.value(forKey: "SFC_Version") as? Int
        self.Flag = dict.value(forKey: "Flag") as! Int
        self.TP_Entry_Id = checkNullAndNilValueForString(stringData: dict.value(forKey: "TP_Entry_Id") as? String)

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
        SFC_Category_Name = row["SFC_Category_Mode"]
        Distance_Fare_Code = row["Distance_fare_Code"]
        SFC_Version = row["SFC_Version"]
        Flag = row["Flag"]
        TP_Entry_Id = row["TP_Entry_Id"]
        Region_Code = row["Region_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Id"] =  TP_Id
        container["From_Place"] =  From_Place
        container["To_Place"] =  To_Place
        container["Travel_Mode"] =  Travel_Mode
        container["Distance"] =  Distance
        container["SFC_Category_Mode"] =  SFC_Category_Name
        container["Distance_fare_Code"] =  Distance_Fare_Code
        container["SFC_Version"] =  SFC_Version
        container["Flag"] =  Flag
        container["TP_Entry_Id"] =  TP_Entry_Id
        container["Region_Code"] =  Region_Code
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "TP_Id": TP_Id,
//            "From_Place": From_Place,
//            "To_Place": To_Place,
//            "Travel_Mode": Travel_Mode,
//            "Distance": Distance,
//            "SFC_Category_Mode": SFC_Category_Name,
//            "Distance_fare_Code": Distance_Fare_Code,
//            "SFC_Version": SFC_Version,
//            "Flag": Flag,
//            "TP_Entry_Id": TP_Entry_Id,
//            "Region_Code": Region_Code
//        ]
//    }
}
