//
//  HourlyReportModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/05/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit
import GRDB

class HourlyReportModel: Record
{
    var Doctor_Code: String?
    var Doctor_Name: String?
    var Doctor_Region_Code: String?
    var Speciality_Name: String?
    var Category_Code: String?
    var MDL_Number: String?
    var DCR_Actual_Date: String?
    var Doctor_Visit_Date_Time: String?
    var Latitude: String?
    var Longitude: String?
    var Modified_Entity: Int64?
    var Synced_DateTime: String?
    var Customer_Entity_Type: String?
    var Category_Name: String?
    var Doctor_Region_Name: String?
    var Hospital_Name: String!
//    var Hospital_Account_Number : String!

   
    
    init(dict: NSDictionary)
    {
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.DCR_Actual_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Actual_Date") as? String)
        self.Doctor_Visit_Date_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Visit_Date_Time") as? String)
        self.Latitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Latitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Modified_Entity = (dict.value(forKey: "Modified_Entity") as? Int64)
        self.Synced_DateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Synced_DateTime") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
      //   self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return Hourly_Report_Visit
    }
    
    required init(row: Row)
    {
        Doctor_Code = row["Doctor_Code"]
        Doctor_Name = row["Doctor_Name"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Speciality_Name = row["Speciality_Name"]
        Category_Code = row["Category_Code"]
        MDL_Number = row["MDL_Number"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Doctor_Visit_Date_Time = row["Doctor_Visit_Date_Time"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Modified_Entity = row["Modified_Entity"]
        Synced_DateTime = row["Synced_DateTime"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Category_Name = row["Category_Name"]
        Doctor_Region_Name = row["Doctor_Region_Name"]
        Hospital_Name = row["Hospital_Name"]
      //  Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Doctor_Code"] = Doctor_Code
        container["Doctor_Name"] = Doctor_Name
        container["Doctor_Region_Code"] = Doctor_Region_Code
        container["Speciality_Name"] = Speciality_Name
        container["Category_Code"] = Category_Code
        container["MDL_Number"] = MDL_Number
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Doctor_Visit_Date_Time"] = Doctor_Visit_Date_Time
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["Modified_Entity"] = Modified_Entity
        container["Synced_DateTime"] = Synced_DateTime
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Category_Name"] = Category_Name
        container["Doctor_Region_Name"] = Doctor_Region_Name
        container["Hospital_Name"] = Hospital_Name
       // container["Hospital_Account_Number"] = Hospital_Account_Number
    }
}

