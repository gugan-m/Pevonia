//
//  DFCMaster.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DFCMaster: Record
{
    var DFC_Id: Int!
    var Distance_Range_Code: String!
    var From_Km: Float!
    var To_Km: Float!
    var Travel_Mode: String!
    var Fare_Amount: Float!
    var Date_From: Date!
    var Date_To: Date!
    var Is_Amount_Fixed: String!
    var Entity_Code: String!
    var Category_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Distance_Range_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Distance_Range_Code") as? String)
       
        if let fromKmFloat = dict.value(forKey: "From_Km") as? Float
        {
            self.From_Km = fromKmFloat
        }
        else if let fromKmDouble = dict.value(forKey: "From_Km") as? Double
        {
            self.From_Km = Float(fromKmDouble)
        }
        else
        {
            self.From_Km = 0
        }
        //self.From_Km = dict.value(forKey: "From_Km") as! Float
        if let toKmFloat = dict.value(forKey: "To_Km") as? Float
        {
            self.To_Km = toKmFloat
        }
        else if let toKmDouble = dict.value(forKey: "To_Km") as? Double
        {
            self.To_Km = Float(toKmDouble)
        }
        else
        {
            self.To_Km = 0
        }
       // self.To_Km = dict.value(forKey: "To_Km") as! Float
        if let fareAmountFloat = dict.value(forKey: "Fare_Amount") as? Float
        {
            self.Fare_Amount = fareAmountFloat
        }
        else if let fareAmountDouble = dict.value(forKey: "Fare_Amount") as? Double
        {
            self.Fare_Amount = Float(fareAmountDouble)
        }
        else
        {
            self.Fare_Amount = 0
        }
      //  self.Fare_Amount = dict.value(forKey: "Fare_Amount") as! Float
        self.Travel_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Travel_Mode") as? String)
        self.Date_From = getStringInFormatDate(dateString: dict.value(forKey: "Date_From") as! String)
        self.Date_To = getStringInFormatDate(dateString: dict.value(forKey: "Date_To") as! String)
        self.Is_Amount_Fixed = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Amount_Fixed") as? String)
        self.Entity_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DFC
    }
    
    required init(row: Row)
    {
        DFC_Id = row["DFC_Id"]
        Distance_Range_Code = row["Distance_Range_code"]
        From_Km = row["From_Km"]
        To_Km = row["To_Km"]
        Fare_Amount = row["Fare_Amount"]
        Travel_Mode = row["Travel_Mode"]
        Date_From = row["Date_From"]
        Date_To = row["Date_To"]
        Is_Amount_Fixed = row["Is_Amount_Fixed"]
        Entity_Code = row["Entity_Code"]
        Category_Name = row["Category_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DFC_Id"] =  DFC_Id
        container["Distance_Range_code"] =  Distance_Range_Code
        container["From_Km"] =  From_Km
        container["To_Km"] =  To_Km
        container["Travel_Mode"] =  Travel_Mode
        container["Fare_Amount"] =  Fare_Amount
        container["Date_From"] =  Date_From
        container["Date_To"] =  Date_To
        container["Is_Amount_Fixed"] =  Is_Amount_Fixed
        container["Entity_Code"] =  Entity_Code
        container["Category_Name"] =  Category_Name
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "DFC_Id": DFC_Id,
//            "Distance_Range_code": Distance_Range_Code,
//            "From_Km": From_Km,
//            "To_Km": To_Km,
//            "Travel_Mode": Travel_Mode,
//            "Fare_Amount": Fare_Amount,
//            "Date_From": Date_From,
//            "Date_To": Date_To,
//            "Is_Amount_Fixed": Is_Amount_Fixed,
//            "Entity_Code": Entity_Code,
//            "Category_Name": Category_Name
//        ]
//    }
}
