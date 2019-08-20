//
//  MessageModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 30/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB
class MailMessageHeader: Record
{
    var Msg_Id : Int!
    var Msg_Code : String!
    var Is_RichText : Int!
    var Priority : Int!
    var Date_From : Date!
    var Sent_Status : String!
    var Sent_Type : String!
    var Sender_Employee_Name : String
    var Sender_User_Code : String
    var Is_Sent : Int!
    
    init(dict: NSDictionary)
    {
        //self.Msg_Id = dict.value(forKey: "Msg_Id") as? Int
        self.Msg_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Msg_Code")as? String)
        self.Is_RichText = dict.value(forKey: "Is_Richtext") as? Int ?? 0
        self.Priority = dict.value(forKey: "Priority") as? Int ?? 0
        self.Date_From = getDateAndTimeInFormat(dateString: (dict.value(forKey: "Date_From")as? String)! + ".000")
        self.Sent_Status = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sent_Status") as? String)
        self.Sent_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sent_Type") as? String)
        self.Sender_Employee_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Employee_Name") as? String)
        self.Sender_User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Code") as? String)
        self.Is_Sent = 0
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MAIL_MESSAGE_HEADER
    }
    
    required init(row: Row)
    {
        Msg_Id = row["Msg_Id"]
        Msg_Code = row["Msg_Code"]
        Is_RichText = row["Is_Richtext"]
        Priority = row["Priority"]
        Date_From = row["Date_From"]
        Sent_Status = row["Sent_Status"]
        Sent_Type = row["Sent_Type"]
        Sender_Employee_Name = row["Sender_Employee_Name"]
        Sender_User_Code = row["Sender_User_Code"]
        Is_Sent = row["Is_Sent"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Id"] = Msg_Id
        container["Msg_Code"] = Msg_Code
        container["Is_Richtext"] = Is_RichText
        container["Priority"] = Priority
        container["Date_From"] = Date_From
        container["Sent_Status"] = Sent_Status
        container["Sent_Type"] = Sent_Type
        container["Sender_Employee_Name"] = Sender_Employee_Name
        container["Sender_User_Code"] = Sender_User_Code
        container["Is_Sent"] = Is_Sent
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Msg_Id" : Msg_Id,
//            "Msg_Code" : Msg_Code,
//            "Is_Richtext" : Is_RichText,
//            "Priority" : Priority,
//            "Date_From" : Date_From
//        ]
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Sent_Status" : Sent_Status,
//            "Sent_Type" : Sent_Type,
//            "Sender_Employee_Name" : Sender_Employee_Name,
//            "Sender_User_Code" : Sender_User_Code,
//            "Is_Sent" : Is_Sent
//        ]
//        var combinedAttributes : NSMutableDictionary!
//
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class MailMessageContent: Record
{
    var Msg_Content_Id : Int!
    var Msg_Id : Int!
    var Msg_Code : String!
    var Subject : String!
    var Content : String!
    
    init(dict : NSDictionary)
    {
        //self.Msg_Content_Id = dict.value(forKey: "Msg_Content_Id")as? Int
        //self.Msg_Id = dict.value(forKey: "Msg_Id") as! Int
        self.Msg_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Msg_Code") as? String)
        self.Subject = checkNullAndNilValueForString(stringData: dict.value(forKey: "Subject") as? String)
        self.Content = checkNullAndNilValueForString(stringData: dict.value(forKey: "Message_Content") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MAIL_MSG_CONTENT
    }
    
    required init(row: Row)
    {
        Msg_Content_Id = row["Msg_Content_Id"]
        Msg_Id = row["Msg_Id"]
        Msg_Code = row["Msg_Code"]
        Subject = row["Subject"]
        Content = row["Content"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Content_Id"] = Msg_Content_Id
        container["Msg_Id"] = Msg_Id
        container["Msg_Code"] = Msg_Code
        container["Subject"] = Subject
        container["Content"] = Content
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return[
//            "Msg_Content_Id" : Msg_Content_Id,
//            "Msg_Id" : Msg_Id,
//            "Msg_Code" : Msg_Code,
//            "Subject" : Subject,
//            "Content" : Content
//        ]
//    }
}

class MailMessageAttachment: Record
{
    var Msg_Attachment_Id : Int?
    var Msg_Id : Int!
    var Msg_Code : String!
    var Local_Attachment_Path : String!
    var Blob_Url : String!
    var AttachmentType: String = EMPTY
    var FileName: String = EMPTY
    
    init(dict : NSDictionary)
    {
        //self.Msg_Attachment_Id = dict.value(forKey: "Msg_Attachment_Id")as? Int
        //self.Msg_Id = dict.value(forKey: "Msg_Id")as? Int
        self.Msg_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Msg_Code") as? String)
        self.Local_Attachment_Path = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Attachment_Path") as? String)
        self.Blob_Url = checkNullAndNilValueForString(stringData: dict.value(forKey: "Blob_Url") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MAIL_MSG_ATTACHMENT
    }
    
    required init(row: Row)
    {
        Msg_Attachment_Id = row["Msg_Attachment_Id"]
        Msg_Id = row["Msg_Id"]
        Msg_Code = row["Msg_Code"]
        Local_Attachment_Path = row["Local_Attachment_Path"]
        Blob_Url = row["Blob_Url"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Attachment_Id"] = Msg_Attachment_Id
        container["Msg_Id"] = Msg_Id
        container["Msg_Code"] = Msg_Code
        container["Local_Attachment_Path"] = Local_Attachment_Path
        container["Blob_Url"] = Blob_Url
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return[
//            "Msg_Attachment_Id" : Msg_Attachment_Id,
//            "Msg_Id" : Msg_Id,
//            "Msg_Code" : Msg_Code,
//            "Local_Attachment_Path" : Local_Attachment_Path,
//            "Blob_Url" : Blob_Url
//        ]
//    }
}

class MailMessageAgent: Record
{
    var Msg_Agent_Id : Int!
    var Msg_Id : Int!
    var Msg_Code : String!
    var Target_UserCode : String!
    var Address_Type :String!
    var Is_Read : Int!
    var Ack_Req : Int!
    var Target_Employee_Name : String!
    
    init(dict : NSDictionary)
    {
        //self.Msg_Agent_Id = dict.value(forKey: "Msg_Agent_Id")as? Int
        //self.Msg_Id = dict.value(forKey: "Msg_Id")as? Int
        self.Msg_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgCode") as? String)
        self.Target_UserCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "UserCode") as? String)
        self.Address_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "AddressType") as? String)
        self.Is_Read = dict.value(forKey: "isRead") as? Int ?? 0
        self.Ack_Req = dict.value(forKey: "Ack_Req") as? Int ?? 0
        self.Target_Employee_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "EmployeeName") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MAIL_MSG_AGENT
    }
    
    required init(row: Row)
    {
        Msg_Agent_Id = row["Msg_Agent_Id"]
        Msg_Id = row["Msg_Id"]
        Msg_Code = row["Msg_Code"]
        Target_UserCode = row["Target_Usercode"]
        Address_Type = row["Address_Type"]
        Is_Read = row["Is_Read"]
        Ack_Req = row["Ack_Req"]
        Target_Employee_Name = row["Target_Employee_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Agent_Id"] = Msg_Agent_Id
        container["Msg_Id"] = Msg_Id
        container["Msg_Code"] = Msg_Code
        container["Target_Usercode"] = Target_UserCode
        container["Address_Type"] = Address_Type
        container["Is_Read"] = Is_Read
        container["Ack_Req"] = Ack_Req
        container["Target_Employee_Name"] = Target_Employee_Name
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return[
//            "Msg_Agent_Id" : Msg_Agent_Id,
//            "Msg_Id" : Msg_Id,
//            "Msg_Code" : Msg_Code,
//            "Target_Usercode" : Target_UserCode,
//            "Address_Type" : Address_Type,
//            "Is_Read" : Is_Read,
//            "Ack_Req" : Ack_Req,
//            "Target_Employee_Name" : Target_Employee_Name
//        ]
//    }
}

class MailMessageWrapperModel
{
    var objMailMessageHeader: MailMessageHeader!
    var objMailMessageContent: MailMessageContent!
    var lstMailMessageAgents: [MailMessageAgent]!
    var lstMailMessageAttachments: [MailMessageAttachment]!
    var isSelected: Bool = false
}


