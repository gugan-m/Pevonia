//
//  DCRCalendarModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 07/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRCalendarModel: Record
{
    var Date_Id: Int!
    var Activity_Date: Date!
    var Activity_Count: Int!
    var Is_WeekEnd: Int!
    var Is_Holiday: Int!
    var Is_LockLeave: Int!
    var DCR_Status: Int!
    var Activity_Date_In_Date: Date
    var Is_Field_Lock: Int = 0
    var Is_Attendance_Lock: Int = 0
    
    init(dict: NSDictionary)
    {
        self.Activity_Date = getStringInFormatDate(dateString: dict.value(forKey: "Activity_Date") as! String)
        self.Activity_Count = dict.value(forKey: "Activity_Count") as! Int
        self.Is_WeekEnd = dict.value(forKey: "Is_WeekEnd") as! Int
        self.Is_Holiday = dict.value(forKey: "Is_Holiday") as! Int
        self.Is_LockLeave = dict.value(forKey: "Is_LockLeave") as! Int
        self.DCR_Status = dict.value(forKey: "DCR_Status") as! Int
        self.Activity_Date_In_Date = getStringInFormatDate(dateString: dict.value(forKey: "Activity_Date") as! String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CALENDAR_HEADER
    }
    
    required init(row: Row)
    {
        //Date_Id = row["Date_Id"]
        //Date_Id = row["Date_Id"]
        Activity_Date = row["Activity_Date"]
        Activity_Count = row["Activity_Count"]
        Is_WeekEnd = row["Is_WeekEnd"]
        Is_Holiday = row["Is_Holiday"]
        Is_LockLeave = row["Is_LockLeave"]
        DCR_Status = row["DCR_Status"]
        Activity_Date_In_Date = row["Activity_Date_In_Date"]
        Is_Field_Lock = row["Is_Field_Lock"]
        Is_Attendance_Lock = row["Is_Attendance_Lock"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
    container["Activity_Date"] = Activity_Date
    container["Activity_Count"] = Activity_Count
    container["Is_WeekEnd"] = Is_WeekEnd
    container["Is_Holiday"] = Is_Holiday
    container["Is_LockLeave"] = Is_LockLeave
    container["DCR_Status"] = DCR_Status
    container["Activity_Date_In_Date"] = Activity_Date_In_Date
    container["Is_Field_Lock"] = Is_Field_Lock
        container["Is_Attendance_Lock"] = Is_Attendance_Lock
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            //"Date_Id": Date_Id,
//            "Activity_Date": Activity_Date,
//            "Activity_Count": Activity_Count,
//            "Is_WeekEnd": Is_WeekEnd,
//            "Is_Holiday": Is_Holiday,
//            "Is_LockLeave": Is_LockLeave,
//            "DCR_Status": DCR_Status,
//            "Activity_Date_In_Date": Activity_Date_In_Date
//        ]
//    }
}
