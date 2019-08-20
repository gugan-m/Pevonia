//
//  DCRHeaderModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 07/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRHeaderModel: Record
{
    var DCR_Id: Int!
    var DCR_Actual_Date: Date!
    var DCR_Entered_Date: Date!
    var DCR_Status: String!
    var Flag: Int!
    var Place_Worked: String?
    var Category_Id: Int?
    var Category_Name: String?
    var Category_Code : String?
    var Travelled_KMS: Float?
    var CP_Name: String?
    var CP_Code: String?
    var CP_Id: Int?
    var Start_Time: String?
    var End_Time: String?
    var Approved_By: String?
    var Approved_Date: Date?
    var Unapprove_Reason: String?
    var Leave_Type_Id: Int?
    var Leave_Type_Code: String?
    var Region_Code: String?
    var Lattitude: String?
    var Longitude: String?
    var Activity_Count: Float?
    var Reason: String?
    var DCR_Code: String?
    var DCR_General_Remarks: String?
    var Is_TP_Frozen: Int = 0
    
    init(dict: NSDictionary)
    {
        self.DCR_Actual_Date = getStringInFormatDate(dateString: dict.value(forKey: "DCR_Actual_Date") as! String)
        let enteredDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Dcr_Entered_Date") as? String)
        
        if (enteredDate != EMPTY)
        {
            self.DCR_Entered_Date = getStringInFormatDate(dateString: enteredDate)
        }
        
        self.DCR_Status = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Status") as? String)
        self.Flag = dict.value(forKey: "Flag") as! Int
        self.Place_Worked = checkNullAndNilValueForString(stringData: dict.value(forKey: "Place_Worked") as? String)
        
        if let categoryId = dict.value(forKey: "Category_Id") as? Int
        {
            self.Category_Id = categoryId
        }
        
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        
        if let travelKm = dict.value(forKey: "Travelled_KMS") as? Float
        {
            self.Travelled_KMS = travelKm
        }
        
        self.CP_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Name") as? String)
        self.CP_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "CP_Code") as? String)
        
        if let cpId = dict.value(forKey: "CP_Id") as? Int
        {
            self.CP_Id = cpId
        }
        
        self.Start_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Start_Time") as? String)
        self.End_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "End_Time") as? String)
        self.Approved_By = checkNullAndNilValueForString(stringData: dict.value(forKey: "Approved_By") as? String)
        
//        if let approvedDate = dict.value(forKey: "Approved_Date") as? String
//        {
//            self.Approved_Date = getStringInFormatDate(dateString: approvedDate)
//        }
        
        self.Unapprove_Reason = checkNullAndNilValueForString(stringData: dict.value(forKey: "Unapprove_Reason") as? String)
        
        if let leaveTypeId = dict.value(forKey: "Leave_Type_Id") as? Int
        {
            self.Leave_Type_Id = leaveTypeId
        }
        
        self.Leave_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Leave_Type_Code") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Lattitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Lattitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        
        if let activityCount = dict.value(forKey: "Activity_Count") as? Float
        {
            self.Activity_Count = activityCount
        }
        
        self.Reason = checkNullAndNilValueForString(stringData: dict.value(forKey: "Reason") as? String)
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.DCR_General_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_General_Remarks") as? String)
        
        if let frozenTP = dict.value(forKey: "IsTPFrozenData") as? Int
        {
            self.Is_TP_Frozen = frozenTP
        }
        else
        {
            self.Is_TP_Frozen = 0
        }
        
        super.init()
    }
    
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
        Category_Code = row["Category_Code"]
        Is_TP_Frozen = row["Is_TP_Frozen"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Id"] =  DCR_Id
        container["DCR_Actual_Date"] =  DCR_Actual_Date
        container["DCR_Entered_Date"] =  DCR_Entered_Date
        container["DCR_Status"] =  DCR_Status
        container["Flag"] =  Flag
        container["Place_Worked"] =  Place_Worked
        container["Category_Id"] =  Category_Id
        container["Category_Name"] =  Category_Name
        container["Travelled_KMS"] =  Travelled_KMS
        container["CP_Name"] =  CP_Name
        container["CP_Code"] =  CP_Code
        container[ "CP_Id"] =  CP_Id
        container["Start_Time"] =  Start_Time
        container["End_Time"] =  End_Time
        container["Approved_By"] =  Approved_By
        container["Approved_Date"] =  Approved_Date
        container["Unapprove_Reason"] =  Unapprove_Reason
        container["Leave_Type_Id"] =  Leave_Type_Id
        container["Leave_Type_Code"] =  Leave_Type_Code
        container["Region_Code"] =  Region_Code
        container["Lattitude"] =  Lattitude
        container["Longitude"] =  Longitude
        container["Activity_Count"] =  Activity_Count
        container["Reason"] =  Reason
        container["DCR_Code"] =  DCR_Code
        container["DCR_General_Remarks"] =  DCR_General_Remarks
        container["Is_TP_Frozen"] = Is_TP_Frozen
    }
//   var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Id": DCR_Id,
//            "DCR_Actual_Date": DCR_Actual_Date,
//            "DCR_Entered_Date": DCR_Entered_Date,
//            "DCR_Status": DCR_Status,
//            "Flag": Flag,
//            "Place_Worked": Place_Worked,
//            "Category_Id": Category_Id,
//            "Category_Name": Category_Name,
//            "Travelled_KMS": Travelled_KMS
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "CP_Name": CP_Name,
//            "CP_Code": CP_Code,
//            "CP_Id": CP_Id,
//            "Start_Time": Start_Time,
//            "End_Time": End_Time,
//            "Approved_By": Approved_By,
//            "Approved_Date": Approved_Date,
//            "Unapprove_Reason": Unapprove_Reason,
//            "Leave_Type_Id": Leave_Type_Id
//        ]
//
//        let dict3 : [String : DatabaseValueConvertible?] = [
//            "Leave_Type_Code": Leave_Type_Code,
//            "Region_Code": Region_Code,
//            "Lattitude": Lattitude,
//            "Longitude": Longitude,
//            "Activity_Count": Activity_Count,
//            "Reason": Reason,
//            "DCR_Code": DCR_Code,
//            "DCR_General_Remarks": DCR_General_Remarks
//        ]
//
//        let dict4 : [String : DatabaseValueConvertible?] = [
//            "Is_TP_Frozen": Is_TP_Frozen
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        combinedAttributes.addEntries(from: dict3)
//        combinedAttributes.addEntries(from: dict4)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class DCRHeaderObjectModel: NSObject
{
    var DCR_Id: Int!
    var DCR_Actual_Date: Date!
    var DCR_Entered_Date: Date!
    var DCR_Status: String!
    var Flag: Int!
    var Place_Worked: String?
    var Category_Id: Int?
    var Category_Name: String?
    var Travelled_KMS: Float?
    var CP_Name: String?
    var CP_Code: String?
    var CP_Id: Int?
    var Start_Time: String?
    var End_Time: String?
    var Approved_By: String?
    var Approved_Date: Date?
    var Unapprove_Reason: String?
    var Leave_Type_Id: Int?
    var Leave_Type_Code: String?
    var Region_Code: String?
    var Lattitude: String?
    var Longitude: String?
    var Activity_Count: Float!
    var Reason: String?
    var DCR_Code: String?
 
}
