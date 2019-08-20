//
//  UploadDCRChemistVisit.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRChemistVisit: Record
{
    var DCR_Chemists_Id: Int!
    var Visit_Id: Int!
    var DCR_Chemists_Code: String?
    var DCR_Id: Int!
    var Chemist_Code: String?
    var Chemist_Id: Int?
    var Chemist_Name: String!
    var POB_Amount: Float?
    var DCR_Code: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMISTS_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Chemists_Id = row["DCR_Chemist_Visit_Id"]
        DCR_Chemists_Code = row["DCR_Chemist_Visit_Code"]
        Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Chemist_Id = row["Chemist_Id"]
        Chemist_Code = row["Chemist_Code"]
        Chemist_Name = row["Chemist_Name"]
        POB_Amount = row["POB_Amount"]
        
        super.init(row: row)
    }
}
