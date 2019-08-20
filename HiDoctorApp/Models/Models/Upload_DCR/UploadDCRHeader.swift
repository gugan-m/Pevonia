//
//  UploadDCRHeader.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRHeader: Record
{
    var DCR_Id: Int!
    var DCR_Code: String?
    var DCR_Actual_Date: String?
    var DCR_Entered_Date: String?
    var DCR_Status: String?
    var Flag: Int!
    var Place_Worked: String?
    var Category_Id: Int?
    var Category_Name: String?
    var Travelled_KMS: Float?
    var CP_Code: String?
    var CP_Id: Int?
    var Start_Time: String?
    var End_Time: String?
    var Approved_By: String?
    var Approved_Date: String?
    var Unapprove_Reason: String?
    var Leave_Type_Id: Int?
    var Leave_Type_Code: String?
    var Reason: String?
    var Region_Code: String?
    var Lattitude: Double?
    var Longitude: Double?
    var Activity_Count: Float?
    var CP_Name: String?
    var Doctors_Count: Int?
    var Chemist_Count: Int?
    var RCPA_Count: Int?
    var Stockiest_Count: Int?
    var Expenses_Count: Int?
    var leaveTypeName: String?
    var Source_Of_Entry: String?
    var DCR_General_Remarks: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_HEADER
    }
    
    required init(row: Row)
    {
        DCR_Id = row["DCR_Id"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        DCR_Entered_Date = row["DCR_Entered_Date"]
        DCR_Status = row["DCR_Status"]
        Flag = row["Flag"]
        Place_Worked = row["Place_Worked"]
        Category_Id = row["Category_Id"]
        Category_Name = row["Category_Name"]
        Travelled_KMS = row["Travelled_KMS"]
        CP_Name = row["CP_Name"]
        CP_Code = row["CP_Code"]
        CP_Id = row["CP_Id"]
        Start_Time = row["Start_Time"]
        End_Time = row["End_Time"]
        Approved_By = row["Approved_By"]
        Approved_Date = row["Approved_Date"]
        Unapprove_Reason = row["Unapprove_Reason"]
        Leave_Type_Id = row["Leave_Type_Id"]
        Leave_Type_Code = row["Leave_Type_Code"]
        Region_Code = row["Region_Code"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        Activity_Count = row["Activity_Count"]
        Reason = row["Reason"]
        DCR_Code = row["DCR_Code"]
        DCR_General_Remarks = row["DCR_General_Remarks"]
        
        super.init(row: row)
    }
}
