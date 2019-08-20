//
//  DCRStockistVisitModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRStockistVisitModel: Record
{
    var DCR_Stockiest_Id: Int!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Stockiest_Id: Int!
    var Stockiest_Code: String!
    var Stockiest_Name: String!
    var POB_Amount: Double?
    var Collection_Amount: Double?
    var Remarks: String?
    var Visit_Mode : String?
    var Visit_Time : String?
    var Latitude: String?
    var Longitude: String?
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        if let stockistId = dict.value(forKey: "Stockiest_Id") as? Int
        {
            self.Stockiest_Id = stockistId
        }
        
        self.Stockiest_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Code") as? String)
        self.Stockiest_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Name") as? String)
        self.Visit_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Mode") as? String)
        self.Visit_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Time") as? String)
        self.Latitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Latitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        
        if let pobAmount = dict.value(forKey: "POB_Amount") as? Double
        {
            self.POB_Amount = pobAmount
        }
        else
        {
            self.POB_Amount = 0
        }
        
        if let collectionAmount = dict.value(forKey: "Collection_Amount") as? Double
        {
            self.Collection_Amount = collectionAmount
        }
        else
        {
            self.Collection_Amount = 0
        }
        
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_STOCKIST_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Stockiest_Id = row["DCR_Stockiest_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Stockiest_Id = row["Stockiest_Id"]
        Stockiest_Code = row["Stockiest_Code"]
        Stockiest_Name = row["Stockiest_Name"]
        POB_Amount = row["POB_Amount"]
        Visit_Mode = row["Visit_Mode"]
        Collection_Amount = row["Collection_Amount"]
        Remarks = row["Remarks"]
        Visit_Time = row["Visit_Time"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Stockiest_Id"] = DCR_Stockiest_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Stockiest_Id"] = Stockiest_Id
        container["Stockiest_Code"] = Stockiest_Code
        container["Stockiest_Name"] = Stockiest_Name
        container["POB_Amount"] = POB_Amount
        container["Collection_Amount"] = Collection_Amount
        container["Visit_Mode"] = Visit_Mode
        container["Remarks"] = Remarks
        container["Visit_Time"] = Visit_Time
        container["Latitude"] =  Latitude
        container["Longitude"] =  Longitude
    }
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        return [
    //            "DCR_Stockiest_Id": DCR_Stockiest_Id,
    //            "DCR_Id": DCR_Id,
    //            "DCR_Code": DCR_Code,
    //            "Stockiest_Id": Stockiest_Id,
    //            "Stockiest_Code": Stockiest_Code,
    //            "Stockiest_Name": Stockiest_Name,
    //            "POB_Amount": POB_Amount,
    //            "Collection_Amount": Collection_Amount,
    //            "Visit_Mode": Visit_Mode,
    //            "Remarks": Remarks
    //        ]
    //    }
}
