//
//  UploadDCRDetailedProducts.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRDetailedProducts: Record
{
    var DCR_Detailed_Products_Id: Int!
    var Visit_Id: Int!
    var DCR_Code: String?
    var DCR_Visit_Code: String?
    var DCR_Id: Int!
    var Product_Id: Int?
    var Product_Code: String!
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DETAILED_PRODUCTS
    }
    
    required init(row: Row)
    {
        DCR_Detailed_Products_Id = row["DCR_Detailed_Products_Id"]
        Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Id = row["Product_Id"]
        Product_Code = row["Product_Code"]
        
        super.init(row: row)
    }
}
