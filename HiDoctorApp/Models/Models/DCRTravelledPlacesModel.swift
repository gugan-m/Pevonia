//
//  DCRTravelledPlacesModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 07/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRTravelledPlacesModel: Record
{
    var DCR_Travel_Id: Int!
    var DCR_Id: Int!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var SFC_Category_Name: String?
    var Distance_Fare_Code: String?
    var SFC_Version: Int?
    var Route_Way: String?
    var Flag: Int!
    var DCR_Code: String!
    var Is_Circular_Route_Complete: Int?
    var Region_Code : String?
    var Is_TP_SFC: Int = 0
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.From_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "From_Place") as? String)
        self.To_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "To_Place") as? String)
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        self.Distance = NSString(string:(dict.value(forKey: "Distance") as? String)!).floatValue
        self.SFC_Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Category_Name") as? String)
        self.Distance_Fare_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Fare_Code") as? String)
        self.SFC_Version = dict.value(forKey: "SFC_Version") as? Int
        self.Route_Way = checkNullAndNilValueForString(stringData: dict.value(forKey: "Route_Way") as? String)
        self.Flag = dict.value(forKey: "Flag") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        if let value = dict.value(forKey: "Is_Circular_Route_Complete")
        {
            self.Is_Circular_Route_Complete = value as? Int
        }
        else
        {
            self.Is_Circular_Route_Complete = 0
        }
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Region_Code") as? String)
        
        if let isTPSFC = dict.value(forKey: "Is_TP_Place") as? Int
        {
            self.Is_TP_SFC = isTPSFC
        }
        else
        {
            self.Is_TP_SFC = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_TRAVELLED_PLACES //448960
    }
    
    required init(row: Row)
    {
        DCR_Travel_Id = row["DCR_Travel_Id"]
        DCR_Id = row["DCR_Id"]
        From_Place = row["From_Place"]
        To_Place = row["To_Place"]
        Travel_Mode = row["Travel_Mode"]
        Distance = row["Distance"]
        SFC_Category_Name = row["SFC_Category_Name"]
        Distance_Fare_Code = row["Distance_Fare_Code"]
        SFC_Version = row["SFC_Version"]
        Route_Way = row["Route_Way"]
        Flag = row["Flag"]
        DCR_Code = row["DCR_Code"]
        Is_Circular_Route_Complete = row["Is_Circular_Route_Complete"]
        Region_Code = row["Region_Code"]
        Is_TP_SFC = row["Is_TP_SFC"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
       
        container["DCR_Id"] =  DCR_Id
        container["From_Place"] =  From_Place
        container["To_Place"] =  To_Place
        container["Travel_Mode"] =  Travel_Mode
        container["Distance"] =  Distance
        container["SFC_Category_Name"] =  SFC_Category_Name
        container["Distance_Fare_Code"] =  Distance_Fare_Code
        container["SFC_Version"] =  SFC_Version
        container["Route_Way"] =  Route_Way
        container["Flag"] =  Flag
        container["DCR_Code"] =  DCR_Code
        container["Is_Circular_Route_Complete"] =  Is_Circular_Route_Complete
        container["Region_Code"] =  Region_Code
        container["Is_TP_SFC"] =  Is_TP_SFC
        
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Id": DCR_Id,
//            "From_Place": From_Place,
//            "To_Place": To_Place,
//            "Travel_Mode": Travel_Mode,
//            "Distance": Distance,
//            "SFC_Category_Name": SFC_Category_Name,
//            "Distance_Fare_Code": Distance_Fare_Code,
//            "SFC_Version": SFC_Version
//        ]
//        
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Route_Way": Route_Way,
//            "Flag": Flag,
//            "DCR_Code": DCR_Code,
//            "Is_Circular_Route_Complete": Is_Circular_Route_Complete,
//            "Region_Code": Region_Code,
//            "Is_TP_SFC": Is_TP_SFC
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
