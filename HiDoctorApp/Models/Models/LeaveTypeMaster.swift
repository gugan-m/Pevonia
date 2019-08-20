//
//  LeaveTypeMaster.swift
//  HiDoctorApp
//
//  Created by SwaaS on 03/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class LeaveTypeMaster: Record
{
    var Leave_Type_Id: Int!
    var Leave_Type_Code: String!
    var Leave_Type_Name: String!
    var Effective_From: Date!
    var Effective_To: Date!
    
    init(dict: NSDictionary)
    {
        self.Leave_Type_Id = dict.value(forKey: "Leave_Type_Id") as? Int
        self.Leave_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Leave_Type_Code") as? String)
        self.Leave_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Leave_Type_Name") as? String)
        self.Effective_From = getStringInFormatDate(dateString: dict.value(forKey: "Effective_From") as! String)
        self.Effective_To = getStringInFormatDate(dateString: dict.value(forKey: "Effective_To") as! String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_LEAVE_TYPE_MASTER
    }
    
    required init(row: Row)
    {
        Leave_Type_Id = row["Leave_Type_Id"]
        Leave_Type_Code = row["Leave_Type_Code"]
        Leave_Type_Name = row["Leave_Type_Name"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Leave_Type_Id"] =  Leave_Type_Id
        container["Leave_Type_Code"] =  Leave_Type_Code
        container["Leave_Type_Name"] =  Leave_Type_Name
        container["Effective_From"] =  Effective_From
        container["Effective_To"] =  Effective_To
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Leave_Type_Id": Leave_Type_Id,
//            "Leave_Type_Code": Leave_Type_Code,
//            "Leave_Type_Name": Leave_Type_Name,
//            "Effective_From": Effective_From,
//            "Effective_To": Effective_To
//        ]
//    }
}
