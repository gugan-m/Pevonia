//
//  DCRAttendanceActivityModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 15/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRAttendanceActivityModel: Record
{
    var DCR_Attendance_Id: Int!
    var DCR_Id: Int!
    var DCR_Date: Date!
    var Project_Code: String!
    var Activity_Code: String!
    var Start_Time: String!
    var End_Time: String!
    var Remarks: String?
    var Project_Name: String?
    var Activity_Name: String?
    var DCR_Code: String?
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Date = getStringInFormatDate(dateString: dict.value(forKey: "DCR_Actual_Date") as! String)
        self.Project_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Project_Code") as? String)
        self.Activity_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Code") as? String)
        self.Start_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Start_Time") as? String)
        self.End_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "End_Time") as? String)
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        super.init()
    }
    
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
        DCR_Code = row["DCR_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Id"] = DCR_Id
        container["DCR_Date"] = DCR_Date
        container["Project_Code"] = Project_Code
        container["Activity_Code"] = Activity_Code
        container["Start_Time"] = Start_Time
        container["End_Time"] = End_Time
        container["Remarks"] = Remarks
        container["DCR_Code"] = DCR_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Id": DCR_Id,
//            "DCR_Date": DCR_Date,
//            "Project_Code": Project_Code,
//            "Activity_Code": Activity_Code,
//            "Start_Time": Start_Time,
//            "End_Time": End_Time,
//            "Remarks": Remarks,
//            "DCR_Code": DCR_Code
//        ]
//        
//        return dict1
//    }
}
class DCRAttendanceDoctorModel: Record
{
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Id: Int?
    var DCR_Code: String!
    var Doctor_Code: String!
    var Doctor_Name: String!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Actual_Date: Date!
    var Speciality_Name: String!
    var Speciality_Code: String!
    var Doctor_Region_Code: String!
    var Doctor_Region_Name: String!
    var Category_Code: String!
    var Category_Name: String!
    var MDL_Number: String!
    var Visit_Mode: String!
    var Visit_Time: String?
    var Business_Status_ID: Int!
    var Business_Status_Active_Status: Int!
    var Business_Status_Name: String!
    var Call_Objective_ID: Int!
    var Call_Objective_Active_Status: Int!
    var Call_Objective_Name: String!
    var Campaign_Code: String!
    var Campaign_Name: String!
    var Lattitude: String?
    var Longitude: String?
    var Remarks: String?
    var POB_Amount: Double?
    var Hospital_Name: String!
 //   var Hospital_Account_Number : String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        if let stringCode = dict.value(forKey: "DCR_Doctor_Visit_Code") as? String
        {
            self.DCR_Doctor_Visit_Code = stringCode
        }
        else if let intCode = dict.value(forKey: "DCR_Doctor_Visit_Code") as? Int
        {
            self.DCR_Doctor_Visit_Code = "\(intCode)"
        }
        else
        {
            self.DCR_Doctor_Visit_Code = EMPTY
        }
        if  let dateString = dict.value(forKey: "DCR_Actual_Date") as? String
        {
            self.DCR_Actual_Date = convertDateIntoString(dateString: dateString)
        }
        else if let date = dict.value(forKey: "DCR_Actual_Date") as? Date
        {
            self.DCR_Actual_Date = date
        }
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        //self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
       // self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        if let regionCode = dict.value(forKey: "Doctor_Region_Code") as? String
        {
           self.Doctor_Region_Code = regionCode
        }
        else if let regionCode = dict.value(forKey: "Region_Code") as? String
        {
           self.Doctor_Region_Code = regionCode
        }
        else
        {
            self.Doctor_Region_Code = EMPTY
        }
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Visit_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Mode") as? String)
        self.Visit_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Time") as? String)
        let visitTime = self.Visit_Time
        
        if (visitTime != EMPTY)
        {
            if (visitTime!.contains(AM) == false) && (visitTime!.contains(PM) == false)
            {
                self.Visit_Time = visitTime! + " " + self.Visit_Mode!
            }
        }
        self.Lattitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Lattitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Business_Status_ID = defaultBusineessStatusId
        if let businessStatusId = dict.value(forKey: "Business_Status_ID") as? Int
        {
            self.Business_Status_ID = businessStatusId
        }
        
        self.Business_Status_Active_Status = defaultBusinessStatusActviveStatus
        if let activeStatus = dict.value(forKey: "Status") as? Int
        {
            self.Business_Status_Active_Status = activeStatus
        }
        
        self.Business_Status_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Status_Name") as? String)
        
        self.Call_Objective_ID = defaultCallObjectiveId
        if let callObjId = dict.value(forKey: "Call_Objective_ID") as? Int
        {
            self.Call_Objective_ID = callObjId
        }
        
        self.Call_Objective_Active_Status = defaultCallObjectiveActviveStatus
        if let callObjStatus = dict.value(forKey: "Call_Objective_Status") as? Int
        {
            self.Call_Objective_Active_Status = callObjStatus
        }
        
        self.Call_Objective_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Call_Objective_Name") as? String)
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Campaign_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Name") as? String)
        
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        let pobAmount = checkNullAndNilValueForString(stringData: dict.value(forKey: "POB_Amount") as? String)
        
        if (pobAmount != EMPTY)
        {
            self.POB_Amount = Double(pobAmount)
        }
        else
        {
            self.POB_Amount = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_ATTENDANCE_DOCTOR_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Name = row["Doctor_Name"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Speciality_Name = row["Speciality_Name"]
        Speciality_Code = row["Speciality_Code"]
        Category_Name = row["Category_Name"]
        Category_Code = row["Category_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Region_Name = row["Doctor_Region_Name"]
        MDL_Number = row["MDL_Number"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        Visit_Mode = row["Visit_Mode"]
        Visit_Time = row["Visit_Time"]
        Business_Status_ID = row["Business_Status_ID"]
        Business_Status_Name = row["Business_Status_Name"]
        Business_Status_Active_Status = row["Business_Status_Active_Status"]
        Call_Objective_ID = row["Call_Objective_ID"]
        Call_Objective_Name = row["Call_Objective_Name"]
        Call_Objective_Active_Status = row["Call_Objective_Active_Status"]
        Campaign_Code = row["Campaign_Code"]
        Campaign_Name = row["Campaign_Name"]
        Remarks = row["Remarks"]
        POB_Amount = row["POB_Amount"]
        Hospital_Name = row["Hospital_Name"]
        //Hospital_Account_Number = row["Hospital_Account_Number"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Doctor_Code"] = Doctor_Code
        container["Doctor_Name"] = Doctor_Name
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Speciality_Name"] = Speciality_Name
        container["Speciality_Code"] = Speciality_Code
        container["Category_Code"] = Category_Code
        container["Category_Name"] = Category_Name
        container["Doctor_Region_Code"] = Doctor_Region_Code
        container["Doctor_Region_Name"] = Doctor_Region_Name
        container["MDL_Number"] = MDL_Number
        container["Visit_Mode"] =  Visit_Mode
        container["Visit_Time"] =  Visit_Time
        container["Lattitude"] =  Lattitude
        container["Longitude"] =  Longitude
        container["Business_Status_ID"] = Business_Status_ID
        container["Business_Status_Name"] = Business_Status_Name
        container["Business_Status_Active_Status"] = Business_Status_Active_Status
        container["Call_Objective_ID"] = Call_Objective_ID
        container["Call_Objective_Name"] = Call_Objective_Name
        container["Call_Objective_Active_Status"] = Call_Objective_Active_Status
        container["Campaign_Code"] = Campaign_Code
        container["Campaign_Name"] = Campaign_Name
        container["Remarks"] =  Remarks
        container["POB_Amount"] =  POB_Amount
        container["Hospital_Name"] =  Hospital_Name
      //  container["Hospital_Account_Number"] = Hospital_Account_Number
    }
    
}

class DCRAttendanceSampleDetailsModel: Record
{
    var DCR_Attendance_Sample_Id: Int!
    var DCR_Id: Int?
    var DCR_Code: String!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Actual_Date: Date?
    var Product_Code: String!
    var Product_Name: String!
    var Quantity_Provided: Int?
    var Remark: String?
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "DCR_Doctor_Visit_Id") as? Int ?? 0
        if let stringCode = dict.value(forKey: "DCR_Doctor_Visit_Code") as? String
        {
            self.DCR_Doctor_Visit_Code = stringCode
        }
        else if let intCode = dict.value(forKey: "DCR_Doctor_Visit_Code") as? Int
        {
            self.DCR_Doctor_Visit_Code = "\(intCode)"
        }
        else
        {
           self.DCR_Doctor_Visit_Code = EMPTY
        }
        if  let dateString = dict.value(forKey: "DCR_Actual_Date") as? String
        {
            self.DCR_Actual_Date = convertDateIntoString(dateString: dateString)
        }
        else if let date = dict.value(forKey: "DCR_Actual_Date") as? Date
        {
            self.DCR_Actual_Date = date
        }
        
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Quantity_Provided =  dict.value(forKey: "Quantity_Provided") as? Int ?? 0
        self.Remark = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remark") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_Attendance_Sample_Id = row["DCR_Attendance_Sample_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Quantity_Provided = row["Quantity_Provided"]
        Remark = row["Remark"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Attendance_Sample_Id"] = DCR_Attendance_Sample_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Product_Code"] = Product_Code
        container["Product_Name"] = Product_Name
        container["Quantity_Provided"] = Quantity_Provided
        container["Remark"] = Remark
        
    }
    
}
