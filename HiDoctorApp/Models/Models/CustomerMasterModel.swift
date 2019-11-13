//
//  CustomerMasterModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CustomerMasterModel: Record
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
    var userCode : String!
    var isSelected : Bool = false
    var isReadOnly : Bool = false
    var Latitude: Double = 0
    var Longitude: Double = 0
    var Anniversary_Date: Date?
    var DOB: Date?
    var indays: Int?
    var Customer_Status: Int = 1
    var isViewEnable: Bool = false //DPM
    var noOfPrescription: String = EMPTY
    var potentialPrescription: String =  EMPTY
    var Hospital_Account_Number: String?
     
    
    init(dict: NSDictionary)
    {
//        self.Customer_Id = dict.value(forKey: "Customer_Id") as! Int
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
        self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Account_Number") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        self.Latitude = dict.value(forKey: "Customer_Latitude") as? Double ?? 0.0
        self.Longitude = dict.value(forKey: "Customer_Longitude") as? Double ?? 0.0

        let anniversaryDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Anniversary_Date") as? String)
        let dob = checkNullAndNilValueForString(stringData: dict.value(forKey: "DOB") as? String)
        
        self.userCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "userCode") as? String)
        
        if (anniversaryDate != EMPTY && anniversaryDate != "1900-01-01")
        {
            self.Anniversary_Date = convertDateIntoString(dateString: anniversaryDate)
        }
        
        if (dob != EMPTY && dob != "1900-01-01")
        {
            self.DOB = convertDateIntoString(dateString: dob)
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CUSTOMER_MASTER
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
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Anniversary_Date = row["Anniversary_Date"]
        DOB = row["DOB"]
        indays = row["indays"]
        userCode = row["userCode"]
        Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Customer_Id"] = Customer_Id
        container["Customer_Code"] = Customer_Code
        container["Customer_Name"] = Customer_Name
        container["Region_Code"] = Region_Code
        container["Region_Name"] = Region_Name
        container["Speciality_Code"] = Speciality_Code
        container["Speciality_Name"] = Speciality_Name
        container["Category_Code"] = Category_Code
        container["Category_Name"] = Category_Name
        container["MDL_Number"] = MDL_Number
        container["Local_Area"] = Local_Area
        container["Hospital_Name"] = Hospital_Name
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Sur_Name"] = Sur_Name
        container["Anniversary_Date"] = Anniversary_Date
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["DOB"] = DOB
        container["userCode"] = userCode
        container["Hospital_Account_Number"] = Hospital_Account_Number
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
//        let dict3: [String : DatabaseValueConvertible?] = [
//            "Latitude": Latitude,
//            "Longitude": Longitude,
//            "Anniversary_Date": Anniversary_Date,
//            "DOB": DOB
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        combinedAttributes.addEntries(from: dict3)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class CustomerMasterEditModel: Record
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
    var userCode : String?
    var isSelected : Bool = false
    var isReadOnly : Bool = false
    var Latitude: Double = 0
    var Longitude: Double = 0
    var Anniversary_Date: Date?
    var DOB: Date?
    var indays: Int?
    var Customer_Status: Int = 0
    var Hospital_Account_Number: String!
    
    init(dict: NSDictionary)
    {
        //        self.Customer_Id = dict.value(forKey: "Customer_Id") as! Int
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
        self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Account_Number") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        self.Latitude = dict.value(forKey: "Customer_Latitude") as? Double ?? 0.0
        self.Longitude = dict.value(forKey: "Customer_Longitude") as? Double ?? 0.0
        
        let anniversaryDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Anniversary_Date") as? String)
        let dob = checkNullAndNilValueForString(stringData: dict.value(forKey: "DOB") as? String)
        
        if (anniversaryDate != EMPTY && anniversaryDate != "1900-01-01")
        {
            self.Anniversary_Date = convertDateIntoString(dateString: anniversaryDate)
        }
        
        if (dob != EMPTY && dob != "1900-01-01")
        {
            self.DOB = convertDateIntoString(dateString: dob)
        }
        
        let customerStatus = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Status_Str") as? String)
        if customerStatus != EMPTY
        {
            self.Customer_Status = Int(customerStatus)!
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CUSTOMER_MASTER_EDIT
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
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Anniversary_Date = row["Anniversary_Date"]
        DOB = row["DOB"]
        indays = row["indays"]
        Customer_Status = row["Customer_Status"]
        Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Customer_Id"] = Customer_Id
        container["Customer_Code"] = Customer_Code
        container["Customer_Name"] = Customer_Name
        container["Region_Code"] = Region_Code
        container["Region_Name"] = Region_Name
        container["Speciality_Code"] = Speciality_Code
        container["Speciality_Name"] = Speciality_Name
        container["Category_Code"] = Category_Code
        container["Category_Name"] = Category_Name
        container["MDL_Number"] = MDL_Number
        container["Local_Area"] = Local_Area
        container["Hospital_Name"] = Hospital_Name
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Sur_Name"] = Sur_Name
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["Anniversary_Date"] = Anniversary_Date
        container["DOB"] = DOB
        container["Customer_Status"] = Customer_Status
        container["Hospital_Account_Number"] = Hospital_Account_Number
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
//        let dict3: [String : DatabaseValueConvertible?] = [
//            "Latitude": Latitude,
//            "Longitude": Longitude,
//            "Anniversary_Date": Anniversary_Date,
//            "DOB": DOB,
//            "Customer_Status": Customer_Status
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        combinedAttributes.addEntries(from: dict3)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
