//
//  TourPlannerAccompanist.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class TourPlannerAccompanist: Record
{
    var TP_Id: Int!
    var TP_Accompanist_Id: Int!
    var TP_Date: Date!
    var Acc_User_Name: String!
    var Acc_User_Code: String!
    var Acc_Region_Code: String!
    var Acc_Region_Name: String!
    var Acc_User_Type_Name: String!
    var Is_Only_For_Doctor: String
    var User_Code: String?
    var TP_Entry_Id: Int!
    var Acc_Employee_Name: String!
    var Acc_User_Type_Code: String!

   
    init(dict: NSDictionary)
    {
        self.TP_Id = dict.value(forKey: "TP_Id") as? Int ?? 0
        self.TP_Entry_Id = dict.value(forKey: "TP_Entry_Id") as! Int

        //self.TP_Date = getStringInFormatDate(dateString: dict.value(forKey: "TP_Date") as! String)
        self.Acc_User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Code") as? String)
        self.Acc_User_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Name") as? String)
        self.Acc_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Region_Code") as? String)
        self.Acc_User_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Type_Name") as? String)
        self.Is_Only_For_Doctor = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Only_For_Doctor") as? String)
        self.Acc_Employee_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Employee_Name") as? String)
        self.Acc_User_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Type_Code") as? String)

        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        TP_Id = row["TP_Id"]
        //TP_Date = row["TP_Date")
        Acc_User_Code = row["Acc_User_Code"]
        Acc_User_Name = row["Acc_User_Name"]
        Acc_Region_Code = row["Acc_Region_Code"]
        Acc_User_Type_Name = row["Acc_User_Type_Name"]
        Is_Only_For_Doctor = row["Is_Only_For_Doctor"]
        User_Code = row["User_Code"]
        Acc_Employee_Name = row["Acc_Employee_Name"]
        Acc_User_Type_Code = row["Acc_User_Type_Code"]
        TP_Entry_Id = row["TP_Entry_Id"]
        TP_Accompanist_Id = row["TP_Accompanist_Id"]
        Acc_Region_Name = row["Region_Name"]

        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["TP_Id"] =  TP_Id
        //container["TP_Date"] =  TP_Date
        container["Acc_User_Code"] =  Acc_User_Code
        container["Acc_User_Name"] =  Acc_User_Name
        container["Acc_Region_Code"] =  Acc_Region_Code
        container["Acc_User_Type_Name"] =  Acc_User_Type_Name
        container["Is_Only_For_Doctor"] =  Is_Only_For_Doctor
        container["TP_Entry_Id"] =  TP_Entry_Id
        container["Acc_User_Type_Code"] =  Acc_User_Type_Code
        container["Acc_Employee_Name"] =  Acc_Employee_Name
        container["TP_Accompanist_Id"] = TP_Accompanist_Id

    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "TP_Id": TP_Id,
//            //"TP_Date": TP_Date,
//            "Acc_User_Code": Acc_User_Code,
//            "Acc_User_Name": Acc_User_Name,
//            "Acc_Region_Code": Acc_Region_Code,
//            "Acc_User_Type_Name": Acc_User_Type_Name,
//            "Is_Only_For_Doctor": Is_Only_For_Doctor,
//            "TP_Entry_Id": TP_Entry_Id,
//            "Acc_User_Type_Code": Acc_User_Type_Code,
//            "Acc_Employee_Name": Acc_Employee_Name,
//            "TP_Accompanist_Id":TP_Accompanist_Id
//
//        ]
//    }
}
