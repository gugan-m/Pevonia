//
//  UploadDCRDoctorVisit.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRDoctorVisit: Record
{
    var DCR_Visit_Tracker_Id: Int!
    var DCR_Actual_Date: String?
    var Visit_Id: Int!
    var DCR_Id: Int!
    var DCR_Code: String?
    var DCR_Visit_Code: String?
    var Doctor_Id: Int?
    var Doctor_Region_Code: String?
    var Doctor_Code: String?
    var Doctor_Name: String!
    var MDL_Number: String?
    var Speciality_Name: String?
    var Visit_Mode: String!
    var Visit_Time: String?
    var IS_CP_Doctor: String?
    var POB_Amount: Float?
    var Category_Code: String?
    var Is_Acc_Doctor: String?
    var Remarks: String?
    var Lattitude: Double?
    var Longitude: Double?
    var Category_Name: String?
    var Region_Name: String?
    var Doctor_Visit_Date_Time: String?
    var Modified_Entity: String?
    var Speciality_Code: String?
    var Customer_Entity_Type: String?
    
    
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT
    }
    
    required init(row: Row)
    {
        Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Doctor_Id = row["Doctor_Id"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Name = row["Doctor_Name"]
        Speciality_Name = row["Speciality_Name"]
        MDL_Number = row["MDL_Number"]
        Category_Code = row["Category_Code"]
        Category_Name = row["Category_Name"]
        Visit_Mode = row["Visit_Mode"]
        Visit_Time = row["Visit_Time"]
        POB_Amount = row["POB_Amount"]
        IS_CP_Doctor = row["Is_CP_Doctor"]
        Is_Acc_Doctor = row["Is_Acc_Doctor"]
        Remarks = row["Remarks"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        Region_Name = row["Region_Name"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        
        super.init(row: row)
    }
}
