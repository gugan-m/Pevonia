//
//  DCRDetailedProductsModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDetailedProductsModel: Record
{
    var DCR_Detailed_Products_Id: Int!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Product_Id: Int!
    var Product_Code: String!
    var Product_Name: String!
    var DA_Code: Int?
    var Status: Int?
    var Business_Status_ID: Int!
    var Business_Status_Name: String!
    var Business_Status_Active_Status: Int!
    var Remarks: String!
    var Business_Potential: Float!
    
    init(dict: NSDictionary)
    {
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "Visit_Id") as! Int
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Product_Id = dict.value(forKey: "Product_Id") as! Int
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.DA_Code = dict.value(forKey: "DA_Code") as? Int ?? 0
        self.Status = dict.value(forKey: "Status") as? Int ?? 0
        self.Business_Status_ID = defaultBusineessStatusId
        if let businessStatusId = dict.value(forKey: "Business_Status_ID") as? Int
        {
            self.Business_Status_ID = businessStatusId
        }
        
        self.Business_Status_Active_Status = defaultBusinessStatusActviveStatus
        if let activeStatus = dict.value(forKey: "Status") as? Int
        {
            self.Business_Status_Active_Status = activeStatus
        }
        
        self.Business_Status_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Status_Name") as? String)
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Business_Status_Remarks") as? String)
        self.Business_Potential = Float(defaultBusinessPotential)
        
        if let businessPotential = dict.value(forKey: "BusinessPotential") as? Float
        {
            self.Business_Potential = businessPotential
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DETAILED_PRODUCTS
    }
    
    required init(row: Row)
    {
        DCR_Detailed_Products_Id = row["DCR_Detailed_Products_Id"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Id = row["Product_Id"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Business_Status_ID = row["Business_Status_ID"]
        Business_Status_Name = row["Business_Status_Name"]
        Business_Status_Active_Status = row["Business_Status_Active_Status"]
        Remarks = row["Remarks"]
        Business_Potential = row["Business_Potential"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["DCR_Doctor_Visit_Id"] =  DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code"] =  DCR_Doctor_Visit_Code
        container["DCR_Id"] =  DCR_Id
        container["DCR_Code"] =  DCR_Code
        container["Product_Id"] =  Product_Id
        container["Product_Code"] =  Product_Code
        container["Product_Name"] =  Product_Name
        container["Business_Status_ID"] = Business_Status_ID
        container["Business_Status_Name"] = Business_Status_Name
        container["Business_Status_Active_Status"] = Business_Status_Active_Status
        container["Remarks"] = Remarks
        container["Business_Potential"] = Business_Potential
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Doctor_Visit_Id": DCR_Doctor_Visit_Id,
//            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
//            "DCR_Id": DCR_Id,
//            "DCR_Code": DCR_Code,
//            "Product_Id": Product_Id,
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name
//        ]
//        
//        return dict1
//    }
}
