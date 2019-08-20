//
//  DCRRCPAModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRRCPAModel: Record
{
    var DCR_RCPA_Id: Int!
    var DCR_Chemist_Visit_Id: Int!
    var DCR_Chemist_Visit_Code: String!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Own_Product_Id: Int!
    var Own_Product_Code: String!
    var Own_Product_Name: String!
    var Qty_Given: Float?
    var Competitor_Product_Id: Int?
    var Competitor_Product_Code: String?
    var Competitor_Product_Name: String?
    var Product_Code: String?
    
    init(dict: NSDictionary)
    {
        self.DCR_Chemist_Visit_Id = dict.value(forKey: "DCR_Chemists_Id") as! Int
        self.DCR_Chemist_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemist_Visit_Code") as? String)
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "Visit_Id") as! Int
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Own_Product_Id = dict.value(forKey: "Own_Product_Id") as! Int
        
        let ownProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Own_Product_Code") as? String)
        
        self.Own_Product_Code = ownProductCode
        self.Own_Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Own_Product_Name") as? String)
        
        if let qtyGiven = dict.value(forKey: "Qty_Given") as? Float
        {
            self.Qty_Given = qtyGiven
        }
        
        if let compProductId = dict.value(forKey: "Competitor_Product_Id") as? Int
        {
            self.Competitor_Product_Id = compProductId
        }
        
        self.Competitor_Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Code") as? String)
        
        let competitorProductName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Name") as? String)
        
        self.Competitor_Product_Name = competitorProductName
        
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        
        if (ownProductCode != EMPTY && competitorProductName != EMPTY)
        {
            self.Competitor_Product_Name = EMPTY
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_RCPA_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_RCPA_Id = row["DCR_RCPA_Id"]
        DCR_Chemist_Visit_Id = row["DCR_Chemist_Visit_Id"]
        DCR_Chemist_Visit_Code = row["DCR_Chemist_Visit_Code"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Own_Product_Id = row["Own_Product_Id"]
        Own_Product_Code = row["Own_Product_Code"]
        Own_Product_Name = row["Own_Product_Name"]
        Qty_Given = row["Qty_Given"]
        Competitor_Product_Id = row["Competitor_Product_Id"]
        Competitor_Product_Code = row["Competitor_Product_Code"]
        Competitor_Product_Name = row["Competitor_Product_Name"]
        Product_Code = row["Product_Code"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Chemist_Visit_Id"] = DCR_Chemist_Visit_Id
        container["DCR_Chemist_Visit_Code"] = DCR_Chemist_Visit_Code
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Own_Product_Id"] = Own_Product_Id
        container["Own_Product_Code"] = Own_Product_Code
        container["Own_Product_Name"] = Own_Product_Name
        container["Qty_Given"] =  Qty_Given
        container["Competitor_Product_Id" ] = Competitor_Product_Id
        container["Competitor_Product_Code"] = Competitor_Product_Code
        container["Competitor_Product_Name"] = Competitor_Product_Name
        container["Product_Code"] = Product_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Chemist_Visit_Id": DCR_Chemist_Visit_Id,
//            "DCR_Chemist_Visit_Code": DCR_Chemist_Visit_Code,
//            "DCR_Doctor_Visit_Id": DCR_Doctor_Visit_Id,
//            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
//            "DCR_Id": DCR_Id,
//            "DCR_Code": DCR_Code,
//            "Own_Product_Id": Own_Product_Id,
//            "Own_Product_Code": Own_Product_Code
//        ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Own_Product_Name": Own_Product_Name,
//            "Qty_Given": Qty_Given,
//            "Competitor_Product_Id" : Competitor_Product_Id,
//            "Competitor_Product_Code": Competitor_Product_Code,
//            "Competitor_Product_Name": Competitor_Product_Name,
//            "Product_Code": Product_Code
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
