//
//  CompetitorProductModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class CompetitorProductModel: Record
{
    var Competitor_Product_Id: Int?
    var Competitor_Product_Code: String?
    var Competitor_Product_Name: String!
    var Own_Product_code: String!
    var Qty_Given : Float!
    
    init(dict: NSDictionary)
    {
        if let compProductId = dict.value(forKey: "Competitor_Product_Id") as? String
        {
            self.Competitor_Product_Id = Int(compProductId)
        }
        
        self.Competitor_Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Code") as? String)
        self.Competitor_Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Name")as? String)
        self.Own_Product_code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Own_Product_Code") as? String)
            
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_COMPETITOR_PRODUCT
    }
    
    required init(row: Row)
    {
        Competitor_Product_Id = row["Competitor_Product_Id"]
        Competitor_Product_Code = row["Competitor_Product_Code"]
        Competitor_Product_Name = row["Competitor_Product_Name"]
        Own_Product_code = row["Own_Product_code"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Competitor_Product_Id"] = Competitor_Product_Id
        container["Competitor_Product_Code"] = Competitor_Product_Code
        container["Competitor_Product_Name"] = Competitor_Product_Name
        container["Own_Product_code"] = Own_Product_code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Competitor_Product_Id": Competitor_Product_Id,
//            "Competitor_Product_Code": Competitor_Product_Code,
//            "Competitor_Product_Name": Competitor_Product_Name,
//            "Own_Product_code": Own_Product_code
//        ]
//    }
}

