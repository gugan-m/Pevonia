//
//  CampaignPlannerSFC.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CampaignPlannerSFC: Record
{
    var CP_SFC_Id: Int!
    var CP_Code: String!
    var CP_Id: Int!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Double!
    var Fare_Amount: Double!
    var SFC_Category_Code: String!
    var SFC_Category_Name: String!
    var Distance_fare_Code: String!
    var SFC_Version: Int!
    var Route_Way: String
    
    init(dict: NSDictionary)
    {
        self.CP_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Code") as? String)
        self.CP_Id = dict.value(forKey: "CP_Id") as! Int
        self.From_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "From_Place") as? String)
        self.To_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "To_Place") as? String)
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        self.Distance = dict.value(forKey: "Distance") as! Double
        self.Fare_Amount = dict.value(forKey: "Fare_Amount") as! Double
        self.SFC_Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Category_Code") as? String)
        self.Distance_fare_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Fare_Code") as? String)
        self.SFC_Version = dict.value(forKey: "SFC_Version") as! Int
        self.Route_Way = checkNullAndNilValueForString(stringData: dict.value(forKey: "Route_Way") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CP_SFC
    }
    
    required init(row: Row)
    {
        CP_SFC_Id = row["CP_SFC_Id"]
        CP_Code = row["CP_Code"]
        CP_Id = row["CP_Id"]
        From_Place = row["From_Place"]
        To_Place = row["To_Place"]
        Travel_Mode = row["Travel_Mode"]
        Distance = row["Distance"]
        Fare_Amount = row["Fare_Amount"]
        SFC_Category_Code = row["SFC_Category_Code"]
        Distance_fare_Code = row["Distance_fare_Code"]
        SFC_Version = row["SFC_Version"]
        Route_Way = row["Route_Way"]
        SFC_Category_Name = row["Category_Name"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["CP_SFC_Id"] =  CP_SFC_Id
        container["CP_Code"] =  CP_Code
        container["CP_Id"] =  CP_Id
        container["From_Place"] =  From_Place
        container["To_Place"] =  To_Place
        container["Travel_Mode"] =  Travel_Mode
        container["Distance"] =  Distance
        container["Fare_Amount"] =  Fare_Amount
        container["SFC_Category_Code"] =  SFC_Category_Code
        container["Distance_fare_Code"] =  Distance_fare_Code
        container["SFC_Version"] =  SFC_Version
        container["Route_Way"] =  Route_Way
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "CP_SFC_Id": CP_SFC_Id,
//            "CP_Code": CP_Code,
//            "CP_Id": CP_Id,
//            "From_Place": From_Place,
//            "To_Place": To_Place,
//            "Travel_Mode": Travel_Mode,
//            "Distance": Distance,
//            "Fare_Amount": Fare_Amount,
//            "SFC_Category_Code": SFC_Category_Code,
//            "Distance_fare_Code": Distance_fare_Code,
//            "SFC_Version": SFC_Version,
//            "Route_Way": Route_Way
//        ]
//    }
}
