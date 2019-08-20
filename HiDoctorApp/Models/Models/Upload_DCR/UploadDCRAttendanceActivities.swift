//
//  UploadDCRAttendanceActivities.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRAttendanceActivities: Record
{
    var DCR_Id: Int!
    var DCR_Attendance_Id: Int!
    var Activity_Name: String!
    var Activity_Code: String!
    var Project_Code: String?
    var Project_Name: String?
    var DCR_Date: String!
    var Start_Time: String!
    var End_Time: String!
    var Remarks: String?
    var DCR_Code: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_ATTENDANCE_ACTIVITIES
    }
    
    required init(row: Row)
    {
        DCR_Attendance_Id = row["DCR_Attendance_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Date = row["DCR_Date"]
        Project_Code = row["Project_Code"]
        Activity_Code = row["Activity_Code"]
        Start_Time = row["Start_Time"]
        End_Time = row["End_Time"]
        Remarks = row["Remarks"]
        Project_Name = row["Project_Name"]
        Activity_Name = row["Activity_Name"]
        
        super.init(row: row)
    }
}
