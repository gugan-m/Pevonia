//
//  DCRSampleModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRSampleModel: Record
{
    var sampleObj : SampleProductsModel = SampleProductsModel()
    
    init(sampleObj : SampleProductsModel)
    {
        self.sampleObj = sampleObj
        super.init()
    }
    
    init(dict: NSDictionary)
    {
        self.sampleObj.DCR_Doctor_Visit_Id = dict.value(forKey: "Visit_Id") as! Int
        self.sampleObj.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.sampleObj.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.sampleObj.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.sampleObj.Product_Id = dict.value(forKey: "Product_Id") as! Int
        self.sampleObj.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.sampleObj.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.sampleObj.Quantity_Provided = Int(dict.value(forKey: "Quantity_Provided") as! String)
        self.sampleObj.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
     //   self.sampleObj.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_SAMPLE_DETAILS
    }
    
    required init(row: Row)
    {
        sampleObj.DCR_Sample_Id = row["DCR_Sample_Id"]
        sampleObj.DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        sampleObj.DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        sampleObj.DCR_Id = row["DCR_Id"]
        sampleObj.DCR_Code = row["DCR_Code"]
        sampleObj.Product_Id = row["Product_Id"]
        sampleObj.Product_Code = row["Product_Code"]
        sampleObj.Product_Name = row["Product_Name"]
        sampleObj.Quantity_Provided = row["Quantity_Provided"]
        sampleObj.Speciality_Code = row["Speciality_Code"]
        sampleObj.Current_Stock = row["Current_Stock"]
        sampleObj.Product_Type_Code = row["Product_Type_Code"]
        sampleObj.Product_Type_Name = row["Product_Type_Name"]
        sampleObj.Division_Name = row["Division_Name"]
        //sampleObj.Hospital_Name = row["Hospital_Name"]

        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Id"] = sampleObj.DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code"] = sampleObj.DCR_Doctor_Visit_Code
        container["DCR_Id"] = sampleObj.DCR_Id
        container["DCR_Code"] = sampleObj.DCR_Code
        container["Product_Id"] = sampleObj.Product_Id
        container["Product_Code"] = sampleObj.Product_Code
        container["Product_Name"] = sampleObj.Product_Name
        container["Quantity_Provided"] = sampleObj.Quantity_Provided
        container["Speciality_Code"] = sampleObj.Speciality_Code
        //container["Hospital_Name"] = sampleObj.Hospital_Name
    }
}

class DCRSampleBatchModel: Record
{
 
    var DCR_Id: Int!
    var DCR_Code: String!
    var Visit_Id: Int!
    var Visit_Code: String!
    var Ref_Id: Int!
    var Product_Code: String!
    var Batch_Number: String!
    var Quantity_Provided: Int!
    var Entity_Type: String!
    
    init(dict: NSDictionary)
    {
        
        self.Visit_Id = dict.value(forKey: "Visit_Id") as! Int
        self.Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Code") as? String)
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Batch_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Batch_Number") as? String)
        if let quantity = dict.value(forKey: "Quantity_Provided") as? String
        {
           self.Quantity_Provided = Int(quantity)
        }
        else if let quantityInt = dict.value(forKey: "Quantity_Provided") as? Int
        {
            self.Quantity_Provided = quantityInt
        }
        self.Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Type") as? String)
        
        if let refId = dict.value(forKey: "Ref_Id") as? Int
        {
            self.Ref_Id = refId
        }
        else
        {
            self.Ref_Id = -1
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_SAMPLE_DETAILS_MAPPING
    }
    
    required init(row: Row)
    {
        
        Visit_Id = row["Visit_Id"]
        Visit_Code = row["Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Code = row["Product_Code"]
        Batch_Number = row["Batch_Number"]
        Quantity_Provided = row["Quantity_Provided"]
        Entity_Type = row["Entity_Type"]
        Ref_Id = row["Ref_Id"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Visit_Id"] = Visit_Id
        container["Visit_Code"] = Visit_Code
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Product_Code"] = Product_Code
        container["Batch_Number"] = Batch_Number
        container["Quantity_Provided"] = Quantity_Provided
        container["Entity_Type"] = Entity_Type
        container["Ref_Id"] = Ref_Id
    }
    
}





















