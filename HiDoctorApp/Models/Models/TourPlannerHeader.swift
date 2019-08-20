//
//  TourPlannerHeader.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TourPlannerHeader: Record
{
    var TP_Id: Int!
    var TP_Date: Date!
    var TP_Day: String!
    var CP_Id: Int?
    var CP_Code: String?
    var Category_Code: String!
    var Activity: Int?
    var LeaveType_Id : Int?
    var Activity_Code: String?
    var Work_Place: String?
    var Category_Name: String?
    var Category_Id : Int?
    var CP_Name: String?
    var Activity_Name: String?
    var Project_Code: String?
    
    var Hospital_Name: String!
   // var Hospital_Account_Number : String!
    
    var TP_Entry_Id: Int!
    var Status: Int!
    var Meeting_Place: String?
    var Meeting_Time: String?
    var UnApprove_Reason: String?
    var TP_ApprovedBy: String?
    var Approved_Date: String?
    var Is_Weekend: Int!
    var Is_Holiday: Int!
    var Remarks: String?
    var Upload_Msg: String?
    var Upload_Status: Int = -1
    
    init(dict: NSDictionary)
    {
        self.TP_Id = dict.value(forKey: "TP_Id") as! Int
        
        let tpDate = dict.value(forKey: "TP_Date") as! String
        
        let dateArray = tpDate.components(separatedBy: " ")
        
        self.TP_Date = getStringInFormatDate(dateString: dateArray[0])
        self.TP_Day = checkNullAndNilValueForString(stringData: convertDateInToDay(date: TP_Date)) 
        self.CP_Id = dict.value(forKey: "CP_Id") as? Int
        self.CP_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Code") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.CP_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Name") as? String)
        
        if let activity = dict.value(forKey: "Activity") as? String
        {
            self.Activity = Int(activity)
        }
        else if let activity = dict.value(forKey: "Activity") as? Int
        {
            self.Activity = activity
        }
        else
        {
            self.Activity = 0
        }
        
        self.Activity_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Code") as? String)
        self.Work_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "Work_Area") as? String)
        self.Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Name") as? String)
        self.Project_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Project_Code") as? String)
        
        //self.TP_Entry_Id = dict.value(forKey: "TP_Entry_Id") as? Int ?? 0
        
        self.Status = dict.value(forKey: "TP_Status") as? Int ?? 0
        
        self.Meeting_Place = checkNullAndNilValueForString(stringData: dict.value(forKey: "Meeting_Place") as? String)
        
        self.Meeting_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Meeting_Time") as? String)
        
        self.UnApprove_Reason = checkNullAndNilValueForString(stringData: dict.value(forKey: "UnApprove_Reason") as? String)
        
        self.TP_ApprovedBy = checkNullAndNilValueForString(stringData: dict.value(forKey: "TP_ApprovedBy") as? String)
        
        self.Approved_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Approved_Date") as? String)
        
        self.Is_Weekend = dict.value(forKey: "Is_Weekend") as? Int ?? 0
        
        self.Is_Holiday = dict.value(forKey: "Is_Holiday") as? Int ?? 0
        
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        //self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        self.Remarks = dict.value(forKey: "Remarks") as? String ?? ""
        
        if let uploadMsg = dict.value(forKey: "Upload_Message") as? String
        {
            self.Upload_Msg = uploadMsg
        }
        else
        {
            self.Upload_Msg = ""
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_HEADER
    }
    
    required init(row: Row)
    {
        TP_Id = row["TP_Id"]
        TP_Date = row["TP_Date"]
        TP_Day = row["TP_Day"]
        CP_Id = row["CP_Id"]
        CP_Code = row["CP_Code"]
        Category_Code = row["Category_Code"]
        Activity = row["Activity"]
        Activity_Code = row["Activity_Code"]
        Work_Place = row["Work_Place"]
        Category_Name = row["Category_Name"]
        Category_Id = row["Category_Id"]
        CP_Name = row["CP_Name"]
        Activity_Name = row["Activity_Name"]
        Project_Code = row["Project_Code"]
        LeaveType_Id = row["Leave_Type_Id"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]
        
        TP_Entry_Id = row["TP_Entry_Id"]
        Status = row["Status"]
        Meeting_Place = row["Meeting_Place"]
        Meeting_Time = row["Meeting_Time"]
        UnApprove_Reason = row["UnApprove_Reason"]
        TP_ApprovedBy = row["TP_ApprovedBy"]
        Approved_Date = row["Approved_Date"]
        Is_Weekend = row["Is_Weekend"]
        Is_Holiday = row["Is_Holiday"]
        Category_Name = row["Category_Name"]
        Remarks = row["Remarks"]
        Upload_Msg = row["Upload_Message"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Id"] =  TP_Id
        container["TP_Date"] =  TP_Date
        container["TP_Day"] =  TP_Day
        container[ "CP_Id"] =  CP_Id
        container["CP_Code"] =  CP_Code
        container["Category_Code"] =  Category_Code
        container["Activity"] =  Activity
        container["Activity_Code"] =  Activity_Code
        container["TP_Entry_Id"] =  TP_Entry_Id
        container["Status"] =  Status
        container["Meeting_Place"] =  Meeting_Place
        container["Meeting_Time"] =  Meeting_Time
        container["UnApprove_Reason"] =  UnApprove_Reason
        container["TP_ApprovedBy"] =  TP_ApprovedBy
        container["Approved_Date"] =  Approved_Date
        container["Work_Place"] =  Work_Place
        container["Activity_Name"] =  Activity_Name
        container["Project_Code"] =  Project_Code
        container["Remarks"] =  Remarks
        container["Upload_Message"] =  Upload_Msg
        container["Is_Weekend"] =  Is_Weekend
        container["Is_Holiday"] =  Is_Holiday
        container["Category_Name"] =  Category_Name
        container["CP_Name"] =  CP_Name
        container["Hospital_Name"] =  Hospital_Name
       // container["Hospital_Account_Number"] = Hospital_Account_Number
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String: DatabaseValueConvertible?] = [
//            "TP_Id": TP_Id,
//            "TP_Date": TP_Date,
//            "TP_Day": TP_Day,
//            "CP_Id": CP_Id,
//            "CP_Code": CP_Code,
//            "Category_Code": Category_Code,
//            "Activity": Activity,
//            "Activity_Code": Activity_Code
//        ]
//        
//        let dict2: [String: DatabaseValueConvertible?] = [
//            "TP_Entry_Id": TP_Entry_Id,
//            "Status": Status,
//            "Meeting_Place": Meeting_Place,
//            "Meeting_Time": Meeting_Time,
//            "UnApprove_Reason": UnApprove_Reason,
//            "TP_ApprovedBy": TP_ApprovedBy,
//            "Approved_Date": Approved_Date
//        ]
//        
//        let dict3: [String: DatabaseValueConvertible?] = [
//            "Work_Place": Work_Place,
//            "Activity_Name": Activity_Name,
//            "Project_Code": Project_Code,
//            "Remarks": Remarks,
//            "Upload_Message": Upload_Msg,
//            "Is_Weekend": Is_Weekend,
//            "Is_Holiday": Is_Holiday,
//            "Category_Name": Category_Name,
//            "CP_Name": CP_Name
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        
//        combinedAttributes.addEntries(from: dict2)
//        combinedAttributes.addEntries(from: dict3)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class TourPlannerHeaderObjModel: NSObject
{
    var TP_Id: Int!
    var TP_Date: Date!
    var TP_Day: String!
    var CP_Id: Int?
    var CP_Code: String?
    var Category_Code: String!
    var Activity: Int?
    var LeaveType_Id : Int?
    var Activity_Code: String?
    var Work_Place: String?
    var Category_Name: String?
    var Category_Id : Int?
    var CP_Name: String?
    var Activity_Name: String?
    var Project_Code: String?
    
    var TP_Entry_Id: Int!
    var Status: Int!
    var Meeting_Place: String?
    var Meeting_Time: String?
    var UnApprove_Reason: String?
    var TP_ApprovedBy: String?
    var Approved_Date: String?
    var Is_Weekend: Int!
    var Is_Holiday: Int!
    var Remarks: String?
    var Upload_Msg: String?
}
