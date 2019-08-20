//
//  UserModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 02/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UserModel: Record {

    var userCode : String!
    var userName : String!
    var userId: Int!
    var employeeName : String!
    var regionName : String!
    var regionCode : String!
    var userTypeCode : String!
    var userTypeName : String!
    var userPassword : String!
    var startDate : Date!
    var appUserFlag : Int!
    var isWideangleUser : Int!
    var sessionId: Int?
    var LastPasswordUpdatedDate: String!
    var AccountLockedDate: String!
    var IsAccountLocked: Int!
    var Region_Type_Code: String!
    var Region_Type_Name: String!
    
    var Manager_Name: String!
    var Employee_Number: String!
    var Full_index: String!
    
    init(dict: NSDictionary)
    {
        self.userCode = dict.value(forKey: "User_Code") as? String
        self.userName = dict.value(forKey: "User_Name") as? String
        self.userId = dict.value(forKey: "User_Id") as? Int
        self.employeeName = dict.value(forKey: "Employee_Name") as? String
        self.regionName = dict.value(forKey: "Region_Name") as? String
        self.regionCode = dict.value(forKey: "Region_Code") as? String
        self.userTypeCode = dict.value(forKey: "User_Type_Code") as? String
        self.userTypeName = dict.value(forKey: "User_Type_Name") as? String
        self.userPassword = dict.value(forKey: "User_Pass") as? String
        let startDateString: String = dict.value(forKey: "HiDOCTOR_Start_Date") as! String
        self.startDate = getStringInFormatDate(dateString: startDateString)
        self.appUserFlag = dict.value(forKey: "App_User_Flag") as? Int
        self.isWideangleUser = dict.value(forKey: "Is_WideAngle_User") as? Int
        self.LastPasswordUpdatedDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Last_Password_Updated_Date") as? String)
        self.AccountLockedDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Account_Locked_DateTime") as? String)
        self.IsAccountLocked = 0
        
        let lockStatus = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Account_Locked") as? String)
        if (lockStatus == "Y")
        {
            self.IsAccountLocked = 1
        }
        self.Region_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Type_Code") as? String)
        self.Region_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Type_Name") as? String)
        self.Full_index = checkNullAndNilValueForString(stringData: dict.value(forKey: "Full_index") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_USER_DETAILS
    }
    
    required init(row: Row) {
        
        userCode = row["User_Code"]
        userName = row["User_Name"]
        userId = row["User_Id"]
        employeeName = row["Employee_Name"]
        regionName = row["Region_Name"]
        regionCode = row["Region_Code"]
        userTypeCode = row["User_Type_code"]
        userTypeName = row["User_Type_Name"]
        userPassword = row["User_Password"]
        startDate = row["Hidoctor_Start_Date"]
        appUserFlag = row["App_User_Flag"]
        isWideangleUser = row["Is_WideAngle_User"]
        sessionId = row["Session_Id"]
        LastPasswordUpdatedDate = row["Last_Password_Updated_Date"]
        AccountLockedDate = row["Account_Locked_DateTime"]
        IsAccountLocked = row["Is_Account_Locked"]
        Region_Type_Code = row["Region_Type_Code"]
        Region_Type_Name = row["Region_Type_Name"]
        Full_index = row["Full_index"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer)
    {
        container["User_Code"] =  userCode
        container["User_Name"] =  userName
        container["User_Id"] =  userId
        container["Employee_Name"] =  employeeName
        container["Region_Name"] =  regionName
        container["Region_Code"] =  regionCode
        container["User_Type_code"] =  userTypeCode
        container["User_Type_Name"] =  userTypeName
        container["User_Password"] =  userPassword
        container["Hidoctor_Start_Date"] =  startDate
        container["App_User_Flag"] =  appUserFlag
        container["Is_WideAngle_User"] =  isWideangleUser
        container["Session_Id"] =  sessionId
        container["Last_Password_Updated_Date"] = LastPasswordUpdatedDate
        container["Account_Locked_DateTime"] = AccountLockedDate
        container["Is_Account_Locked"] = IsAccountLocked
        container["Region_Type_Code"] = Region_Type_Code
        container["Region_Type_Name"] = Region_Type_Name
        container["Full_index"] = Full_index
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "User_Code": userCode,
//            "User_Name": userName,
//            "User_Id": userId,
//            "Employee_Name": employeeName,
//            "Region_Name": regionName,
//            "Region_Code": regionCode,
//            "User_Type_code": userTypeCode,
//            "User_Type_Name": userTypeName,
//            "User_Password": userPassword,
//            "Hidoctor_Start_Date": startDate,
//            "App_User_Flag": appUserFlag,
//            "Is_WideAngle_User": isWideangleUser,
//            "Session_Id": sessionId
//        ]
//    }
//
}

class ErrorLogModel: Record
{
    var Log_Id: Int!
    var Event_Id: Int!
    var Priority: Int!
    var Severity: String!
    var Timestamp: String!
    var MachineName: String!
    var AppDomainName: String!
    var ProcessID: String!
    var ProcessName: String!
    var ThreadName: String!
    var Message: String!
    var ExtendedProperties: String!
    
    init(dict: NSDictionary)
    {
        self.Event_Id = dict.value(forKey: "Event_Id") as! Int
        self.Priority = dict.value(forKey: "Priority") as! Int
        self.Severity = dict.value(forKey: "Severity") as! String
        self.Timestamp = dict.value(forKey: "Timestamp") as! String
        self.MachineName = dict.value(forKey: "MachineName") as! String
        self.AppDomainName = dict.value(forKey: "AppDomainName") as! String
        self.ProcessID = dict.value(forKey: "ProcessID") as! String
        self.ProcessName = dict.value(forKey: "ProcessName") as! String
        self.ThreadName = dict.value(forKey: "ThreadName") as! String
        self.Message = dict.value(forKey: "Message") as! String
        self.ExtendedProperties = dict.value(forKey: "ExtendedProperties") as! String
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_ERROR_LOG
    }
    
    required init(row: Row)
    {
        Log_Id = row["Log_Id"]
        Event_Id = row["Event_Id"]
        Priority = row["Priority"]
        Severity = row["Severity"]
        Timestamp = row["Timestamp"]
        MachineName = row["MachineName"]
        AppDomainName = row["AppDomainName"]
        ProcessID = row["ProcessID"]
        ProcessName = row["ProcessName"]
        ThreadName = row["ThreadName"]
        Message = row["Message"]
        ExtendedProperties = row["ExtendedProperties"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Log_Id"] = Log_Id
        container["Event_Id"] = Event_Id
        container["Priority"] = Priority
        container["Severity"] = Severity
        container["Timestamp"] = Timestamp
        container["MachineName"] = MachineName
        container["AppDomainName"] = AppDomainName
        container["ProcessID"] = ProcessID
        container["ProcessName"] = ProcessName
        container["ThreadName"] = ThreadName
        container["Message"] = Message
        container["ExtendedProperties"] = ExtendedProperties
    }
}
