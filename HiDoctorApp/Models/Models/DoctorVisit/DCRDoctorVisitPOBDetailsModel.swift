//
//  DCRDoctorVisitPOBModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB


class DCRDoctorVisitPOBDetailsModel: Record
{
    var Order_Detail_Id : Int!
    var Order_Entry_Id: Int!
    var DCR_Id: Int?
    var DCR_Code: String?
    var Product_Name : String!
    var Product_Code : String!
    var Product_Qty : Double!
    var Product_Unit_Rate : Double!
    var Product_Amount : Double!
    
    
    init(dict : NSDictionary)
    {
        if let orderEntryId = dict.value(forKey: "Order_Entry_Id") as? Int
        {
            self.Order_Entry_Id = orderEntryId
        }
        self.DCR_Id = dict.value(forKey: "Order_Entry_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        if let productQty = dict.value(forKey: "Product_Qty") as? Double
        {
            self.Product_Qty = productQty
        }
        if let productUnitRate = dict.value(forKey: "Product_Unit_Rate") as? Double
        {
            self.Product_Unit_Rate = productUnitRate
        }
        if let productAmount = dict.value(forKey: "Product_Amount") as? Double
        {
            self.Product_Amount = productAmount
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT_POB_DETAILS
    }
    
    required init(row: Row)
    {
        Order_Detail_Id = row["Order_Detail_Id"]
        Order_Entry_Id = row["Order_Entry_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Name = row["Product_Name"]
        Product_Code = row["Product_Code"]
        Product_Qty = row["Product_QtY"]
        Product_Unit_Rate = row["Product_Unit_Rate"]
        Product_Amount = row["Product_Amount"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Order_Detail_Id"] = Order_Detail_Id
        container["Order_Entry_Id"] = Order_Entry_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Product_Name"] = Product_Name
        container["Product_Code"] = Product_Code
        container["Product_Qty"] = Product_Qty
        container["Product_Unit_Rate"] = Product_Unit_Rate
        container["Product_Amount"] = Product_Amount
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Order_Detail_Id" :Order_Detail_Id,
//            "Order_Entry_Id":Order_Entry_Id,
//            "DCR_Id":DCR_Id,
//            "DCR_Code":DCR_Code,
//            "Product_Name":Product_Name,
//            "Product_Code":Product_Code,
//            "Product_Qty":Product_Qty,
//            "Product_Unit_Rate":Product_Unit_Rate,
//            "Product_Amount":Product_Amount
//            
//        ]
//    }
}

class DCRCompetitorDetailsModel: Record
{
    var Competitor_Detail_Id : Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Product_Detail_Id: Int!
    var DCR_Product_Detail_Code: String!
    var DCR_Id : Int!
    var DCR_Code: String?
    var Competitor_Code : Int!
    var Competitor_Name : String!
    var Product_Name : String!
    var Product_Code : String!
    var Value : Int!
    var Probability: Float!
    var Remarks : String!
    var Doctor_Code: String?
    
    init(dict : NSDictionary)
    {
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "DCR_Doctor_Visit_Id") as? Int ?? 0
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
         self.Competitor_Code = dict.value(forKey: "Competitor_Code") as? Int ?? 0
         self.Competitor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Name") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        self.Value = dict.value(forKey: "Value") as? Int ?? 0
        if let Probability = dict.value(forKey: "Probability") as? Float
        {
            self.Probability = Probability
        }
        self.DCR_Product_Detail_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sale_Product_Code") as? String)
        self.DCR_Product_Detail_Id = dict.value(forKey: "DCR_Product_Detail_Id") as? Int ?? 0
        
        super.init()
    }
    override class var databaseTableName: String
    {
        return TRAN_DCR_COMPETITOR_DETAILS
    }
    
    required init(row: Row)
    {
        Competitor_Detail_Id = row["Competitor_Detail_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Name = row["Product_Name"]
        Product_Code = row["Product_Code"]
        Competitor_Code = row["Competitor_Code"]
        Competitor_Name = row["Competitor_Name"]
        Value = row["Value"]
        Probability = row["Probability"]
        Remarks = row["Remarks"]
        DCR_Product_Detail_Code = row["DCR_Product_Detail_Code"]
        DCR_Product_Detail_Id = row["DCR_Product_Detail_Id"]
        Doctor_Code = row["Doctor_Code"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
      
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Product_Name"] = Product_Name
        container["Product_Code"] = Product_Code
        container["Competitor_Code"] = Competitor_Code
        container["Competitor_Name"] = Competitor_Name
        container["Value"] = Value
        container["Probability"] = Probability
        container["Remarks"] = Remarks
        container["DCR_Product_Detail_Code"] = DCR_Product_Detail_Code
        container["DCR_Product_Detail_Id"] = DCR_Product_Detail_Id
    }
    
}

class CompetitorModel: Record
{
    
    var Competitor_Code : Int!
    var Competitor_Name : String!
    var Competitor_Status : Int!
    var isSelected : Bool = false
    
    init(dict : NSDictionary)
    {
        self.Competitor_Code = dict.value(forKey: "Competitor_Code") as? Int ?? 0
        self.Competitor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Name") as? String)
        self.Competitor_Status = dict.value(forKey: "Competitor_Status") as? Int ?? 0
        
     super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_COMPETITOR_MAPPING
    }
    required init(row: Row)
    {
        Competitor_Code = row["Competitor_Code"]
        Competitor_Name = row["Competitor_Name"]
        Competitor_Status = row["Competitor_Status"]
        
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Competitor_Code"] = Competitor_Code
        container["Competitor_Name"] = Competitor_Name
        container["Competitor_Status"] = Competitor_Status
    }
    
}

class ProductModel: Record
{
    
    var Product_Code : String!
    var Product_Name : String!
    var Competitor_Code : Int!
    var isSelected : Bool = false
    
    init(dict : NSDictionary)
    {
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Competitor_Code = dict.value(forKey: "Competitor_Code") as? Int ?? 0
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_COMPETITOR_PRODUCT_MASTER
    }
    required init(row: Row)
    {
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Competitor_Code = row["Competitor_Code"]
        
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Product_Code"] = Product_Code
        container["Product_Name"] = Product_Name
        container["Competitor_Code"] = Competitor_Code
    }
    
}
