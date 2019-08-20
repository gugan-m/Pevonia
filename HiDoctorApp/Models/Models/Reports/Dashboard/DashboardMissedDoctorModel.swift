//
//  DashboardMissedDoctorModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DashboardMissedDoctorModel: Record
{
    var Customer_Id: Int!
    var Customer_Code: String!
    var Customer_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Speciality_Code: String!
    var Speciality_Name: String!
    var Category_Code: String?
    var Category_Name: String?
    var MDL_Number: String!
    var Local_Area: String?
    var Hospital_Name: String?
    var Customer_Entity_Type: String!
    var Sur_Name: String?
    
    init(dict: NSDictionary)
    {
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Customer_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Name") as? String)
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DASHBOARD_MISSED_DOCTOR
    }
    
    required init(row: Row)
    {
        Customer_Id = row["Customer_Id"]
        Customer_Code = row["Customer_Code"]
        Customer_Name = row["Customer_Name"]
        Region_Code = row["Region_Code"]
        Region_Name = row["Region_Name"]
        Speciality_Code = row["Speciality_Code"]
        Speciality_Name = row["Speciality_Name"]
        Category_Code = row["Category_Code"]
        Category_Name = row["Category_Name"]
        MDL_Number = row["MDL_Number"]
        Local_Area = row["Local_Area"]
        Hospital_Name = row["Hospital_Name"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Sur_Name = row["Sur_Name"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Customer_Id"] = Customer_Id
        container["Customer_Code"] =  Customer_Code
        container["Customer_Name"] =  Customer_Name
        container["Region_Code"] =  Region_Code
        container["Region_Name"] =  Region_Name
        container["Speciality_Code"] =  Speciality_Code
        container["Speciality_Name"] =  Speciality_Name
        container["Category_Code"] =  Category_Code
        container["Category_Name"] =  Category_Name
        container["MDL_Number"] =  MDL_Number
        container["Local_Area"] =  Local_Area
        container["Hospital_Name"] =  Hospital_Name
        container["Customer_Entity_Type"] =  Customer_Entity_Type
        container["Sur_Name"] =  Sur_Name
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Customer_Id": Customer_Id,
//            "Customer_Code": Customer_Code,
//            "Customer_Name": Customer_Name,
//            "Region_Code": Region_Code,
//            "Region_Name": Region_Name,
//            "Speciality_Code": Speciality_Code,
//            "Speciality_Name": Speciality_Name
//        ]
//        
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Category_Code": Category_Code,
//            "Category_Name": Category_Name,
//            "MDL_Number": MDL_Number,
//            "Local_Area": Local_Area,
//            "Hospital_Name": Hospital_Name,
//            "Customer_Entity_Type": Customer_Entity_Type,
//            "Sur_Name": Sur_Name
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
