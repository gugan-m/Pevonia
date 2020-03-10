//
//  UserProductMapping.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UserProductMapping: Record
{
    var Product_Id: Int!
    var Product_Code: String!
    var Product_Name: String!
    var Product_Type_Code: String!
    var Product_Type_Name: String!
    var Division_Name: String!
    var Current_Stock: Int!
    var Speciality_Code: String!
    var Effective_From:String!
    var Effective_To:String!
    var Min_Count: Int!
    var Max_Count: Int!
    var dcrId :Int = 0
    var visitId : Int = 0
    var sampleId : Int = 0
    var Selected_Quantity : Int = 0
    init(dict: NSDictionary)
    {
        self.Product_Id = dict.value(forKey: "Product_Id") as! Int
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Product_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Type_Code") as? String)
        self.Product_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Type_Name") as? String)
        self.Division_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Division_Name") as? String)
        self.Current_Stock = dict.value(forKey: "Current_Stock") as! Int
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        self.Effective_From = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_From") as? String)
        self.Effective_To = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_To") as? String)
        self.Min_Count = dict.value(forKey: "Min_Count") as! Int
        self.Max_Count = dict.value(forKey: "Max_Count") as! Int
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_USER_PRODUCT
    }
    
    required init(row: Row)
    {
        Product_Id = row["Product_Id"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Product_Type_Code = row["Product_Type_Code"]
        Product_Type_Name = row["Product_Type_Name"]
        Division_Name = row["Division_Name"]
        Current_Stock = row["Current_Stock"]
        Speciality_Code = row["Speciality_Code"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        Min_Count = row["Min_Count"]
        Max_Count = row["Max_Count"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Product_Id"] =  Product_Id
        container["Product_Code"] =  Product_Code
        container["Product_Name"] =  Product_Name
        container["Product_Type_Code"] =  Product_Type_Code
        container["Product_Type_Name"] =  Product_Type_Name
        container["Division_Name"] =  Division_Name
        container["Current_Stock"] =  Current_Stock
        container["Speciality_Code"] =  Speciality_Code
        container["Effective_From"] =  Effective_From
        container["Effective_To"] =  Effective_To
        container["Min_Count"] = Min_Count
        container["Max_Count"] = Max_Count
    }

}

class SampleBatchMapping: Record
{
    var Product_Code: String!
    var Batch_Number: String!
    var Expiry_Date: String!
    var Batch_Effective_From: String!
    var Batch_Effective_To: String!
    var Batch_Current_Stock: Int!
    
    init(dict: NSDictionary)
    {
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Batch_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Batch_Number") as? String)
        self.Expiry_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expiry_Date") as? String)
        self.Batch_Effective_From = checkNullAndNilValueForString(stringData: dict.value(forKey: "Batch_Effective_From") as? String)
        self.Batch_Effective_To = checkNullAndNilValueForString(stringData: dict.value(forKey: "Batch_Effective_To") as? String)
        self.Batch_Current_Stock = dict.value(forKey: "Batch_Current_Stock") as! Int
        
         super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_SAMPLE_BATCH_MAPPING
    }
    
    required init(row: Row)
    {
        Product_Code = row["Product_Code"]
        Batch_Number = row["Batch_Number"]
        Expiry_Date = row["Expiry_Date"]
        Batch_Effective_From = row["Batch_Effective_From"]
        Batch_Effective_To = row["Batch_Effective_To"]
        Batch_Current_Stock = row["Batch_Current_Stock"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Product_Code"] =  Product_Code
        container["Batch_Number"] =  Batch_Number
        container["Expiry_Date"] =  Expiry_Date
        container["Batch_Effective_From"] =  Batch_Effective_From
        container["Batch_Effective_To"] =  Batch_Effective_To
        container["Batch_Current_Stock"] =  Batch_Current_Stock
    }
}

