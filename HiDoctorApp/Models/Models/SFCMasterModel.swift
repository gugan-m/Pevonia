//
//  SFCMasterModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class SFCMasterModel: Record
{
    var SFC_Id: Int!
    var Distance_Fare_Code: String!
    var Region_Code: String!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var Fare_Amount: Float!
    var Category_Name: String!
    var Date_From: Date!
    var Date_To: Date!
    var SFC_Version: Int!
    var SFC_Visit_Count: Int!
    
    init(dict: NSDictionary)
    {
        self.Distance_Fare_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Fare_Code") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.From_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "From_Place") as? String)
        self.To_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "To_Place") as? String)
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        if let distanceFloat = dict.value(forKey: "Distance") as? Float
        {
            self.Distance = distanceFloat
        }
        else if let distanceDouble = dict.value(forKey: "Distance") as? Double
        {
            self.Distance = Float(distanceDouble)
        }
       // self.Distance = dict.value(forKey: "Distance") as! Float
        if let fareAmountFloat = dict.value(forKey: "Fare_Amount") as? Float
        {
            self.Fare_Amount = fareAmountFloat 
        }
        else if let fareAmountFloat = dict.value(forKey: "Fare_Amount") as? Double
        {
            self.Fare_Amount = Float(fareAmountFloat)
        }
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Category_Name") as? String)
        self.Date_From = getStringInFormatDate(dateString: dict.value(forKey: "Date_From") as! String)
        self.Date_To = getStringInFormatDate(dateString: dict.value(forKey: "Date_To") as! String)
        self.SFC_Version = dict.value(forKey: "SFC_Version") as! Int
        self.SFC_Visit_Count = dict.value(forKey: "SFC_Visit_Count") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_SFC_MASTER
    }
    
    required init(row: Row)
    {
        SFC_Id = row["SFC_Id"]
        Distance_Fare_Code = row["Distance_Fare_Code"]
        From_Place = row["From_Place"]
        To_Place = row["To_Place"]
        Travel_Mode = row["Travel_Mode"]
        Distance = row["Distance"]
        Fare_Amount = row["Fare_Amount"]
        Category_Name = row["Category_Name"]
        Date_From = row["Date_From"]
        Date_To = row["Date_To"]
        SFC_Version = row["SFC_Version"]
        SFC_Visit_Count = row["SFC_Visit_Count"]
        Region_Code = row["Region_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["SFC_Id"] = SFC_Id
        container["Distance_Fare_Code"] = Distance_Fare_Code
        container["From_Place"] = From_Place
        container["To_Place"] = To_Place
        container["Travel_Mode"] = Travel_Mode
        container["Distance"] = Distance
        container["Fare_Amount"] = Fare_Amount
        container["Date_From"] = Date_From
        container["Date_To"] = Date_To
        container["SFC_Version"] = SFC_Version
        container["SFC_Visit_Count"] = SFC_Visit_Count
        container["Region_Code"] = Region_Code
        container["Category_Name"] = Category_Name
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "SFC_Id": SFC_Id,
//            "Distance_Fare_Code": Distance_Fare_Code,
//            "From_Place": From_Place,
//            "To_Place": To_Place,
//            "Travel_Mode": Travel_Mode,
//            "Distance": Distance,
//            "Fare_Amount": Fare_Amount
//        ]
//        
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Date_From": Date_From,
//            "Date_To": Date_To,
//            "SFC_Version": SFC_Version,
//            "SFC_Visit_Count": SFC_Visit_Count,
//            "Region_Code": Region_Code,
//            "Category_Name": Category_Name
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        
//        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
