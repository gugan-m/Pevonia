//
//  UploadDCRAccompanist.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRAccompanist: Record
{
    var DCR_Accompanist_Id: Int!
    var DCR_Id: Int!
    var Acc_Region_Code: String?
    var Acc_User_Name: String?
    var Acc_User_Code: String?
    var Acc_User_Type_Name: String?
    var Is_Only_For_Doctor: Int?
    var Acc_Start_Time: String?
    var Acc_End_Time: String?
    var Acc_Employee_Name: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        DCR_Accompanist_Id = row["DCR_Accompanist_Id"]
        DCR_Id = row["DCR_Id"]
        Acc_Region_Code = row["Acc_Region_Code"]
        Acc_User_Code = row["Acc_User_Code"]
        Acc_User_Name = row["Acc_User_Name"]
        Acc_User_Type_Name = row["Acc_User_Type_Name"]
        Is_Only_For_Doctor = row["Is_Only_For_Doctor"]
        Acc_Start_Time = row["Acc_Start_Time"]
        Acc_End_Time = row["Acc_End_Time"]
        //DCR_Code = row["DCR_Code")
        Acc_Employee_Name = row["Employee_Name"]
        //Region_Name = row["Region_Name")
        
        super.init(row: row)
    }
}
