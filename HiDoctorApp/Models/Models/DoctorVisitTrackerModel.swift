//
//  DoctorVisitTrackerModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 22/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DoctorVisitTrackerModel: Record
{
    var DCR_Doctor_Visit_Tracker_Id: Int!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Id: Int!
    var DCR_Actual_Date: Date!
    var Doctor_Code: String?
    var Doctor_Region_Code: String?
    var Doctor_Name: String!
    var Speciality_Name: String?
    var MDL_Number: String?
    var Category_Code: String?
    var Lattitude: String?
    var Longitude: String?
    var Doctor_Visit_Date_Time: Date!
    var Modified_Entity: Int!
    var POB_Amount: Double!
    var Hospital_Name: String!
   // var Hospital_Account_Number : String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "DCR_Doctor_Visit_Id") as! Int
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Actual_Date = getStringInFormatDate(dateString: dict.value(forKey: "DCR_Actual_Date") as! String)
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Lattitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Lattitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Doctor_Visit_Date_Time = dict.value(forKey: "Doctor_Visit_Date_Time") as! Date
        self.Modified_Entity = dict.value(forKey: "Modified_Entity") as! Int
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
       // self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        
        if (self.Lattitude == EMPTY)
        {
            self.Lattitude = "0.0"
        }
        
        if (self.Longitude == EMPTY)
        {
            self.Longitude = "0.0"
        }
        
        self.POB_Amount = dict.value(forKey: "POB_Amount") as? Double ?? 0
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT_TRACKER
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Visit_Tracker_Id = row["DCR_Doctor_Visit_Tracker_Id"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        MDL_Number = row["MDL_Number"]
        Category_Code = row["Category_Code"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        Doctor_Visit_Date_Time = row["Doctor_Visit_Date_Time"]
        Modified_Entity = row["Modified_Entity"]
        Doctor_Name = row["Doctor_Name"]
        Speciality_Name = row["Speciality_Name"]
        POB_Amount = row["POB_Amount"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Tracker_Id"] = DCR_Doctor_Visit_Tracker_Id
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Doctor_Code"] = Doctor_Code
        container["Doctor_Region_Code"] = Doctor_Region_Code
        container["MDL_Number"] = MDL_Number
        container["Category_Code"] = Category_Code
        container["Lattitude"] = Lattitude
        container["Longitude"] = Longitude
        container["Doctor_Visit_Date_Time"] = Doctor_Visit_Date_Time
        container["Modified_Entity"] = Modified_Entity
        container["Doctor_Name"] = Doctor_Name
        container["Speciality_Name"] = Speciality_Name
        container["POB_Amount"] = POB_Amount
        container["Hospital_Name"] = Hospital_Name
      //  container["Hospital_Account_Number"] = Hospital_Account_Number
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Doctor_Visit_Tracker_Id": DCR_Doctor_Visit_Tracker_Id,
//            "DCR_Doctor_Visit_Id": DCR_Doctor_Visit_Id,
//            "DCR_Id": DCR_Id,
//            "DCR_Actual_Date": DCR_Actual_Date,
//            "Doctor_Code": Doctor_Code,
//            "Doctor_Region_Code": Doctor_Region_Code,
//            "MDL_Number": MDL_Number,
//            "Category_Code": Category_Code,
//            "Lattitude": Lattitude,
//            "Longitude": Longitude
//        ]
//        
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "Doctor_Visit_Date_Time": Doctor_Visit_Date_Time,
//            "Modified_Entity": Modified_Entity,
//            "Doctor_Name": Doctor_Name,
//            "Speciality_Name": Speciality_Name,
//            "POB_Amount": POB_Amount
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
