//
//  DCRFollowUpModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 17/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRFollowUpModel: Record
{
    var Follow_Up_Id : Int!
    var DCR_Id : Int!
    var DCR_Code : String!
    var DCR_Doctor_Visit_Code : String!
    var DCR_Doctor_Visit_Id : Int!
    var Follow_Up_Text : String!
    var Due_Date : Date!
    
    init(dict: NSDictionary)
    {
        if let doctorVisitId = dict.value(forKey: "Visit_Id") as? Int
        {
            self.DCR_Doctor_Visit_Id = doctorVisitId
        }
        
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        
        if let dcrId = dict.value(forKey: "DCR_Id") as? Int
        {
            self.DCR_Id = dcrId
        }
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Follow_Up_Text = checkNullAndNilValueForString(stringData: dict.value(forKey: "Tasks") as? String)
        let dueDate = dict.value(forKey: "Due_Date") as? String
        // crased in saving follow ups in dvr visit stepper
        if dueDate != nil
        {
            if (dueDate?.contains(" "))! {
              let date1 = dueDate?.split(separator: " ")
                let samDate = date1![0] + " 00:00:00.000"
                 self.Due_Date =  getDateAndTimeInFormat(dateString: samDate + " 00:00:00.000")
            } else {
                self.Due_Date =  getDateAndTimeInFormat(dateString: (dict.value(forKey: "Due_Date")as? String)! + " 00:00:00.000")
            }
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CUSTOMER_FOLLOW_UPS
    }
    
    required init(row: Row)
    {
        Follow_Up_Id = row["Follow_Up_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Code = row["DCR_Code"]
        Follow_Up_Text = row["Follow_Up_Text"]
        Due_Date = row["Due_Date"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Follow_Up_Id"] =  Follow_Up_Id
        container["DCR_Id"] =  DCR_Id
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code" ] =  DCR_Doctor_Visit_Code
        container["DCR_Code" ] =  DCR_Code
        container["Follow_Up_Text" ] =  Follow_Up_Text
        container["Due_Date" ] =  Due_Date
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Follow_Up_Id": Follow_Up_Id,
//            "DCR_Id": DCR_Id,
//            "DCR_Doctor_Visit_Id":DCR_Doctor_Visit_Id,
//            "DCR_Doctor_Visit_Code" : DCR_Doctor_Visit_Code,
//            "DCR_Code" : DCR_Code,
//            "Follow_Up_Text" : Follow_Up_Text,
//            "Due_Date" : Due_Date
//        ]
//    }

}
