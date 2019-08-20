//
//  UploadDCRSample.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRSample: Record
{
    var DCR_Sample_Id: Int!
    var Visit_Id: Int!
    var DCR_Id: Int!
    var Product_Id: Int?
    var Product_Code: String!
    var Quantity_Provided: Int!
    var Speciality_Code: String!
    var DCR_Code: String?
    var DCR_Visit_Code: String?
    var Product_Name: String!
    var Current_Stock: Int!
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_SAMPLE_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_Sample_Id = row["DCR_Sample_Id"]
        Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Product_Id = row["Product_Id"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Quantity_Provided = row["Quantity_Provided"]
        Speciality_Code = row["Speciality_Code"]
        Current_Stock = row["Current_Stock"]
        
        super.init(row: row)
    }
}
