//
//  UploadDCRRCPADetails.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRRCPADetails: Record
{
    var DCR_RCPA_Id: Int!
    var DCR_Chemists_Id: Int!
    var Visit_Id: Int!
    var DCR_Code: String?
    var DCR_Visit_Code: String?
    var Chemist_Visit_Code: String?
    var DCR_ID: Int!
    var Product_Code: String?
    var Own_Product_Id: Int?
    var Own_Product_Code: String?
    var Qty_Given: Int!
    var Competitor_Product_Name: String!
    var Competitor_Product_Code: String?
    var Competitor_Product_Id: Int?

    override class var databaseTableName: String
    {
        return TRAN_DCR_RCPA_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_RCPA_Id = row["DCR_RCPA_Id"]
        DCR_Chemists_Id = row["DCR_Chemist_Visit_Id"]
        Chemist_Visit_Code = row["DCR_Chemist_Visit_Code"]
        Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_ID = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Own_Product_Id = row["Own_Product_Id"]
        Own_Product_Code = row["Own_Product_Code"]
        Qty_Given = row["Qty_Given"]
        Competitor_Product_Id = row["Competitor_Product_Id"]
        Competitor_Product_Code = row["Competitor_Product_Code"]
        Competitor_Product_Name = row["Competitor_Product_Name"]
        
        super.init(row: row)
    }
}
