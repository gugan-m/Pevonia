//
//  LockReleaseResponseModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LockReleaseResponseModel: NSObject
{
    var Locked_Date: String!
    var DCR_Actual_Date: String!
    var Lock_Type: String!
    var Month_Number: Int!
    var Year: Int!
    var Sort_Date: Date!
    var Server_Date: Date!
    var isSelected: Bool = false
    var Locked_Date_Server: String!
    var DCR_Actual_Date_Server: String!
    var User_Code: String!
    
    convenience init(dict: NSDictionary)
    {
        self.init()
        
        let lockedDate = convertDateIntoString(dateString: dict.value(forKey: "Locked_Date") as! String)
        let monthNumber = getMonthNumberFromDate(date: lockedDate)
        let year = getYearFromDate(date: lockedDate)
        var sortDate: String = String(year) + "-"
        
        if (monthNumber < 10)
        {
            sortDate = sortDate + "0" + String(monthNumber) + "-01"
        }
        else
        {
            sortDate = sortDate + String(monthNumber) + "-01"
        }
        
        self.Locked_Date = convertDateIntoString(date: lockedDate)
        
        let dcrActualDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Actual_Date") as? String)
        
        if (dcrActualDate != EMPTY)
        {
            self.DCR_Actual_Date = convertDateIntoString(date: convertDateIntoString(dateString: dcrActualDate))
        }
        else
        {
            self.DCR_Actual_Date = NOT_APPLICABLE
        }
        
        self.Lock_Type = dict.value(forKey: "Lock_Type") as! String
        self.Month_Number = monthNumber
        self.Year = year
        self.Sort_Date = getStringInFormatDate(dateString: sortDate)
        self.Server_Date = lockedDate
        self.isSelected = false
        self.Locked_Date_Server = dict.value(forKey: "Locked_Date") as! String
        self.DCR_Actual_Date_Server = dict.value(forKey: "DCR_Actual_Date") as! String
        self.User_Code = dict.value(forKey: "User_Code") as! String
    }
}

class ActivityLockReleaseResponseModel: NSObject
{
    var Locked_Date: String!
    var DCR_Actual_Date: String!
    var Lock_Type: String!
    var Month_Number: Int!
    var Year: Int!
    var Sort_Date: Date!
    var Server_Date: Date!
    var isSelected: Bool = false
    var Locked_Date_Server: String!
    var DCR_Actual_Date_Server: String!
    var User_Code: String!
    var unApproveReason: String!
    var unApproveBy: String!
    
    convenience init(dict: NSDictionary)
    {
        self.init()
        
        let lockedDate = convertDateIntoString(dateString: dict.value(forKey: "Locked_Date") as! String)
        let monthNumber = getMonthNumberFromDate(date: lockedDate)
        let year = getYearFromDate(date: lockedDate)
        var sortDate: String = String(year) + "-"
        
        if (monthNumber < 10)
        {
            sortDate = sortDate + "0" + String(monthNumber) + "-01"
        }
        else
        {
            sortDate = sortDate + String(monthNumber) + "-01"
        }
        
        self.Locked_Date = convertDateIntoString(date: lockedDate)
        
        let dcrActualDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Actual_Date") as? String)
        
        if (dcrActualDate != EMPTY)
        {
            self.DCR_Actual_Date = convertDateIntoString(date: convertDateIntoString(dateString: dcrActualDate))
        }
        else
        {
            self.DCR_Actual_Date = NOT_APPLICABLE
        }
        
        self.Lock_Type = dict.value(forKey: "Activity_Flag") as! String
        self.Month_Number = monthNumber
        self.Year = year
        self.Sort_Date = getStringInFormatDate(dateString: sortDate)
        self.Server_Date = lockedDate
        self.isSelected = false
        self.Locked_Date_Server = dict.value(forKey: "Locked_Date") as! String
        self.DCR_Actual_Date_Server = dict.value(forKey: "DCR_Actual_Date") as! String
        self.User_Code = dict.value(forKey: "User_Code") as! String
        self.unApproveBy = dict.value(forKey: "Unapproved_by") as! String
        self.unApproveReason = dict.value(forKey: "Unapproval_Reason") as! String
    }
}

