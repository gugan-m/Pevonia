//
//  TourPlannerProduct.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TourPlannerProduct: Record
{
    var TP_Product_Id: Int!
    var TP_Entry_Id: Int!
    var TP_Id: Int!
    var Doctor_Code: String!
    var Doctor_Region_Code: String!
    var Product_Code: String!
    var Product_Name: String!
    var Quantity_Provided: Int!
    
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
        
        //self.TP_Product_Id = dict.value(forKey: "TP_Product_Id") as! Int
        self.TP_Id = dict.value(forKey: "TP_Id") as! Int
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Quantity_Provided = Int(checkNullAndNilValueForString(stringData: dict.value(forKey: "Quantity_Provided") as? String))
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_PRODUCT
    }
    
    required init(row: Row)
    {
        TP_Product_Id = row["TP_Product_Id"]
        TP_Id = row["TP_Id"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Quantity_Provided = row["Quantity_Provided"]
        TP_Entry_Id = row["TP_Entry_Id"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Product_Id"] =  TP_Product_Id
        container["TP_Id"] =  TP_Id
        container["Doctor_Code"] =  Doctor_Code
        container["Doctor_Region_Code"] =  Doctor_Region_Code
        container["Product_Code"] =  Product_Code
        container["Product_Name"] =  Product_Name
        container["Quantity_Provided"] =  Quantity_Provided
        container["TP_Entry_Id"] =  TP_Entry_Id
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "TP_Product_Id": TP_Product_Id,
//            "TP_Id": TP_Id,
//            "Doctor_Code": Doctor_Code,
//            "Doctor_Region_Code": Doctor_Region_Code,
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name,
//            "Quantity_Provided": Quantity_Provided,
//            "TP_Entry_Id": TP_Entry_Id
//        ]
//    }
}

class TourPlannerUnfreezeDates: Record
{
    var TP_Unfreeze_Id: Int!
    var TP_Date: Date!
    
    init(dict: NSDictionary)
    {
        self.TP_Date = getStringInFormatDate(dateString: dict.value(forKey: "TP_Date") as! String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_UNFREEZE_DATES
    }
    
    required init(row: Row)
    {
        TP_Unfreeze_Id = row["TP_Unfreeze_Id"]
        TP_Date = row["TP_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Unfreeze_Id"] = TP_Unfreeze_Id
        container["TP_Date"] = TP_Date
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "TP_Unfreeze_Id": TP_Unfreeze_Id,
//            "TP_Date": TP_Date
//        ]
//    }
}
