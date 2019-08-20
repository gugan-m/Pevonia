//
//  TourPlannerDoctor.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TourPlannerDoctor: Record
{
    var TP_Doctor_Id: Int!
    var TP_Id: Int!
    var TP_Entry_Id : Int!
    var TP_Date: Date!
    var Doctor_Code: String!
    var Doctor_Region_Code: String!
    var Doctor_Name: String!
    var Speciality_Name: String!
    var MDL_Number: String?
    var Category_Code: String?
    var Category_Name: String?
    var Doctor_Region_Name : String?
    var Hospital_Name : String!
   // var Hospital_Account_Number : String!
    
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
        
        self.TP_Id = dict.value(forKey: "TP_Id") as! Int
        
        if dict.value(forKey: "TP_Date") != nil
        {
            self.TP_Date = getStringInFormatDate(dateString: dict.value(forKey: "TP_Date") as! String)
        }
        
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey : "Doctor_Name") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey : "Speciality_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "MDL_Number") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey : "Category_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey : "Category_Name") as? String)
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey : "Doctor_Region_Name") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Name") as? String)
       // self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_DOCTOR
    }
    
    required init(row: Row)
    {
        TP_Doctor_Id = row["TP_Doctor_Id"]
        TP_Id = row["TP_Id"]
        TP_Date = row["TP_Date"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Region_Name = row["Doctor_Region_Name"]
        Doctor_Name = row["Doctor_Name"]
        Speciality_Name = row["Speciality_Name"]
        MDL_Number = row["MDL_Number"]
        Category_Code = row["Category_Code"]
        Category_Name = row["Category_Name"]
        TP_Entry_Id = row["TP_Entry_Id"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Doctor_Id"] = TP_Doctor_Id
        container["TP_Id"] = TP_Id
        container["TP_Date"] = TP_Date
        container["Doctor_Code"] = Doctor_Code
        container["Doctor_Region_Code"] = Doctor_Region_Code
        container["Doctor_Region_Name"] = Doctor_Region_Name
        container["Doctor_Name"] = Doctor_Name
        container["MDL_Number"] = MDL_Number
        container["Speciality_Name"] = Speciality_Name
        container["Category_Name"] = Category_Name
        container["Category_Code"] = Category_Code
        container["TP_Entry_Id"] = TP_Entry_Id
        container["Hospital_Name"] = Hospital_Name
      //  container["Hospital_Account_Number"] = Hospital_Account_Number
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "TP_Doctor_Id": TP_Doctor_Id,
//            "TP_Id": TP_Id,
//            "TP_Date": TP_Date,
//            "Doctor_Code": Doctor_Code,
//            "Doctor_Region_Code": Doctor_Region_Code,
//            "Doctor_Region_Name": Doctor_Region_Name,
//            "Doctor_Name":Doctor_Name
//        ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "MDL_Number":MDL_Number,
//            "Speciality_Name" : Speciality_Name,
//            "Category_Name": Category_Name,
//            "Category_Code" : Category_Code,
//            "TP_Entry_Id": TP_Entry_Id
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
