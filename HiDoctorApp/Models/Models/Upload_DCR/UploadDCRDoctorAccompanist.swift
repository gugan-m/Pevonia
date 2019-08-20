//
//  UploadDCRDoctorAccompanist.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRDoctorAccompanist: Record
{
    var DCR_Doctor_Accompanist_Id: Int!
    var DCR_Id: Int!
    var Visit_ID: Int!
    var Acc_Region_Code: String!
    var Acc_User_Name: String?
    var Acc_User_Code: String?
    var Acc_user_Type_Name: String?
    var Is_Only_For_Doctor: Int?
    var isFlag: Bool?
    var isSelected: Bool?
    var isAlreadyAdded: Bool?
    var employeeName: String?
    var accompanistRegionName: String!
    var Is_TP_Frozen: Int!
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Accompanist_Id = row["DCR_Doctor_Accompanist_Id"]
        DCR_Id = row["DCR_Id"]
        Acc_Region_Code = row["Acc_Region_Code"]
        Acc_User_Code = row["Acc_User_Code"]
        Acc_User_Name = row["Acc_User_Name"]
        Acc_user_Type_Name = row["Acc_User_Type_Name"]
        Is_Only_For_Doctor = row["Is_Only_For_Doctor"]
        Visit_ID = row["DCR_Doctor_Visit_Id"]
        employeeName = row["Employee_Name"]
        accompanistRegionName = row["Region_Name"]
        //DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        Is_TP_Frozen = row["Is_TP_Frozen"]
        super.init(row: row)
    }
}
