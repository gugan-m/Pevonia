//
//  NoticeBoardModel.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class NoticeBoardModel: Record
    
{
    var  Msg_Code: String!
    var  Msg_Distribution_Type: String!
    var  Msg_Title: String!
    var  Msg_Body: String!
    var  Msg_Hyperlink: String!
    var  Msg_Priority: Int!
    var  Msg_Valid_From: String!
    var  Msg_Valid_To: String!
    var  Msg_Sender_UserCode: String!
    var  Msg_AcknowlendgementReqd: String!
    var  Msg_ApprovalStatus: String!
    var  Msg_AttachmentPath: String!
    var  User_Name: String!
    var  Employee_Name: String!
    var  Show_In_Ticker_Only: String!
    var  Highlight: String!
    var  Company_Code: String!
    var  Target_UserCode: String!
    var  Is_Read: String!

    init(dict: NSDictionary)
    {
        self.Msg_Code = dict.value(forKey: "MsgCode") as! String
        self.Msg_Distribution_Type = dict.value(forKey: "MsgDistributionType") as! String
        self.Msg_Title = dict.value(forKey: "MsgTitle") as! String
        self.Msg_Body = dict.value(forKey: "MsgBody") as! String
        self.Msg_Hyperlink = dict.value(forKey: "MsgHyperlink") as! String
        self.Msg_Priority = dict.value(forKey: "MsgPriority") as! Int
        self.Msg_Valid_From = dict.value(forKey: "MsgValidFrom") as! String
        self.Msg_Valid_To = dict.value(forKey: "MsgValidTo") as! String
        self.Msg_Sender_UserCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgSenderUserCode") as? String)
        self.Msg_AcknowlendgementReqd = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgAcknowlendgementReqd") as? String)
        self.Msg_ApprovalStatus = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgApprovalStatus") as? String)
        self.Msg_AttachmentPath = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgAttachmentPath") as? String)
        self.User_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Name") as? String)
        self.Employee_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Employee_Name") as? String)
        self.Show_In_Ticker_Only = checkNullAndNilValueForString(stringData: dict.value(forKey: "SHOW_IN_TICKER_ONLY") as?String)
        self.Highlight = checkNullAndNilValueForString(stringData: dict.value(forKey: "HIGHLIGHT") as? String)
        self.Company_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Company_Code") as? String)
        self.Target_UserCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Target_UserCode") as? String)
        self.Is_Read = checkNullAndNilValueForString(stringData: dict.value(forKey: "IsRead") as? String)
        
        super.init()
            }
    
    override class var databaseTableName: String
    {
        return NOTICEBOARD_DETAIL
    }
    
    required init(row: Row)
    {
        Msg_Code = row["Msg_Code"]
        Msg_Distribution_Type = row["Msg_Distribution_Type"]
        Msg_Title = row["Msg_Title"]
        Msg_Body = row["Msg_Body"]
        Msg_Hyperlink = row["Msg_Hyperlink"]
        Msg_Priority = row["Msg_Priority"]
        Msg_Valid_From = row["Msg_Valid_From"]
        Msg_Valid_To = row["Msg_Valid_To"]
        Msg_Sender_UserCode = row["Msg_Sender_UserCode"]
        Msg_AcknowlendgementReqd = row["Msg_AcknowlendgementReqd"]
        Msg_ApprovalStatus = row["Msg_ApprovalStatus"]
        Msg_AttachmentPath = row["Msg_AttachmentPath"]
        User_Name = row["User_Name"]
        Employee_Name = row["Employee_Name"]
        Show_In_Ticker_Only = row["Show_In_Ticker_Only"]
        Highlight = row["Highlight"]
        Company_Code = row["Company_Code"]
        Target_UserCode = row["Target_UserCode"]
        Is_Read = row["Is_Read"]
       
                
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Code"] = Msg_Code
        container["Msg_Distribution_Type"] = Msg_Distribution_Type
        container["Msg_Title"] = Msg_Title
        container["Msg_Body"] = Msg_Body
        container["Msg_Hyperlink"] = Msg_Hyperlink
        container["Msg_Priority"] = Msg_Priority
        container["Msg_Valid_From"] = Msg_Valid_From
        container["Msg_Valid_To"] = Msg_Valid_To
        container["Msg_Sender_UserCode"] = Msg_Sender_UserCode
        container["Msg_AcknowlendgementReqd"] = Msg_AcknowlendgementReqd
        container["Msg_ApprovalStatus"] = Msg_ApprovalStatus
        container["Msg_AttachmentPath"] = Msg_AttachmentPath
        container["User_Name"] = User_Name
        container["Employee_Name"] = Employee_Name
        container["Show_In_Ticker_Only"] = Show_In_Ticker_Only
        container["Highlight"] = Highlight
        container["Company_Code"] = Company_Code
        container["Target_UserCode"] = Target_UserCode
        container["Is_Read"] = Is_Read
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//                    "Msg_Code": Msg_Code,
//                    "Msg_Distribution_Type": Msg_Distribution_Type,
//                    "Msg_Title": Msg_Title,
//                    "Msg_Body": Msg_Body,
//                    "Msg_Hyperlink": Msg_Hyperlink,
//                    "Msg_Priority": Msg_Priority,
//                    "Msg_Valid_From": Msg_Valid_From,
//                    "Msg_Valid_To": Msg_Valid_To,
//                    "Msg_Sender_UserCode": Msg_Sender_UserCode
//
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "Msg_AcknowlendgementReqd": Msg_AcknowlendgementReqd,
//            "Msg_ApprovalStatus": Msg_ApprovalStatus,
//            "Msg_AttachmentPath": Msg_AttachmentPath,
//            "User_Name": User_Name,
//            "Employee_Name": Employee_Name,
//            "Show_In_Ticker_Only": Show_In_Ticker_Only,
//            "Highlight": Highlight,
//            "Company_Code": Company_Code,
//            "Target_UserCode": Target_UserCode,
//            "Is_Read": Is_Read
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//
//
//    }


    
}
class NoticeBoardDetailModel: Record
{
    var  Msg_Code: String!
    var  Msg_Distribution_Type: String!
    var  Msg_Title: String!
    var  Msg_Valid_From: String!
    var  Msg_Valid_To: String!
    var  Msg_AttachmentPath: String!
    var  Msg_Body: String!
    var  Msg_Hyperlink: String!
    var  Is_Read:String!
    init(dict: NSDictionary)
    {
        self.Msg_Code = dict.value(forKey: "MsgCode") as! String
        self.Msg_Distribution_Type = dict.value(forKey: "MsgDistributionType") as! String
        self.Msg_Title = dict.value(forKey: "MsgTitle") as! String
        self.Msg_Body = dict.value(forKey: "MsgBody") as! String
        self.Msg_Hyperlink = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgHyperlink") as? String)
        self.Msg_Valid_From = dict.value(forKey: "MsgValidFrom") as! String
        self.Msg_Valid_To = dict.value(forKey: "MsgValidTo") as! String
        self.Msg_AttachmentPath = checkNullAndNilValueForString(stringData: dict.value(forKey: "MsgAttachmentPath") as? String)
        self.Is_Read = checkNullAndNilValueForString(stringData: dict.value(forKey: "IsRead") as? String)
        super.init()
    }
    override class var databaseTableName: String
    {
        return NOTICEBOARD_DOWNLOAD
    }

    required init(row: Row)
    {
        Msg_Code = row["Msg_Code"]
        Msg_Distribution_Type = row["Msg_Distribution_Type"]
        Msg_Title = row["Msg_Title"]
        Msg_Body = row["Msg_Body"]
        Msg_Hyperlink = row["Msg_Hyperlink"]
        Msg_Valid_From = row["Msg_Valid_From"]
        Msg_Valid_To = row["Msg_Valid_To"]
        Msg_AttachmentPath = row["Msg_AttachmentPath"]
        Is_Read = row["Is_Read"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Msg_Code"] = Msg_Code
        container["Msg_Distribution_Type"] = Msg_Distribution_Type
        container["Msg_Title"] = Msg_Title
        container["Msg_Body"] = Msg_Body
        container["Msg_Hyperlink"] = Msg_Hyperlink
        container["Msg_Valid_From"] = Msg_Valid_From
        container["Msg_Valid_To"] = Msg_Valid_To
        container["Msg_AttachmentPath"] = Msg_AttachmentPath
        container["Is_Read"] = Is_Read
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Msg_Code": Msg_Code,
//            "Msg_Distribution_Type": Msg_Distribution_Type,
//            "Msg_Title": Msg_Title,
//            "Msg_Body": Msg_Body,
//            "Msg_Hyperlink": Msg_Hyperlink,
//            "Msg_Valid_From": Msg_Valid_From,
//            "Msg_Valid_To": Msg_Valid_To,
//            "Msg_AttachmentPath":Msg_AttachmentPath,
//            "Is_Read":Is_Read
//        ]
//    return dict
//    }
}
