//
//  HopitalAccountNumberModel.swift
//  HiDoctorApp
//
//  Created by User on 02/08/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit
import GRDB

class CustomerHospitalInfoModel: Record
{
    var Region_Code: String!
    var Customer_Code: String!
    var Hospital_Name: String!
    var Hospital_Address1: String!
    var Hospital_Address2: String!
    var Hospital_Local_Area: String!
    var Hospital_City: String!
    var Hospital_State: String!
    var Hospital_Latitude: String!
    var Hospital_Longitude: String!
    var Hospital_Pincode: String!
    var Mapping_Status: Int!
    var Hospital_Classification: String!
    var Hospital_Account_Number: String!
    
    init(dict: NSDictionary)
    {
        
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        self.Hospital_Address1 = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Address1") as? String)
        self.Hospital_Address2 = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Address2") as? String)
        self.Hospital_Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Local_Area") as? String)
        self.Hospital_City = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_City") as? String)
        self.Hospital_State = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_State") as? String)
        self.Hospital_Latitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Latitude") as? String)
        self.Hospital_Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Pincode") as? String)
        self.Hospital_Pincode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Classification") as? String)
        self.Mapping_Status = (dict.value(forKey: "Mapping_Status") as? Int)!
        self.Hospital_Classification = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Classification") as? String)
        self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Account_Number") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_CUSTOMER_HOSPITAL_INFO
    }
    
    required init(row: Row)
    {
        Customer_Code = row["Customer_Code"]
        Region_Code = row["Region_Code"]
        Hospital_Name = row["Hospital_Name"]
        Hospital_Address1 = row["Hospital_Address1"]
        Hospital_Address2 = row["Hospital_Address2"]
        Hospital_Local_Area = row["Hospital_Local_Area"]
        Hospital_City = row["Hospital_City"]
        Hospital_State = row["Hospital_State"]
        Hospital_Latitude = row["Hospital_Latitude"]
        Hospital_Longitude = row["Hospital_Longitude"]
        Hospital_Pincode = row["Hospital_Pincode"]
        Mapping_Status = row["Mapping_Status"]
        Hospital_Classification = row["Hospital_Classification"]
        Hospital_Account_Number = row["Hospital_Account_Number"]
        
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Customer_Code"] =  Customer_Code
        container["Region_Code"] =  Region_Code
        container["Hospital_Name"] =  Hospital_Name
        container["Hospital_Address1"] =  Hospital_Address1
        container["Hospital_Address2"] =  Hospital_Address2
        container["Hospital_Local_Area"] =  Hospital_Local_Area
        container["Hospital_City"] =  Hospital_City
        container["Hospital_State"] =  Hospital_State
        container["Hospital_Latitude"] =  Hospital_Latitude
        container["Hospital_Longitude"] =  Hospital_Longitude
        container["Hospital_Pincode"] =  Hospital_Pincode
        container["Mapping_Status"] =  Mapping_Status
        container["Hospital_Classification"] =  Hospital_Classification
        container["Hospital_Account_Number"] =  Hospital_Account_Number
        
    }
}
