//
//  UploadDCRStockistVisit.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRStockistVisit: Record
{
    var DCR_Stockiest_Id: Int!
    var DCR_Id: Int!
    var Stockiest_Code: String!
    var Stockiest_Id: Int?
    var Stockiest_Name: String!
    var POB_Amount: Float?
    var Collection_Amount: Float?
    var Visit_Mode: String?
    var Remarks: String?
    var DCR_Code: String?
    var Visit_Time: String?
    var Latitude: String?
    var Longitude: String?
    
    
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
}
