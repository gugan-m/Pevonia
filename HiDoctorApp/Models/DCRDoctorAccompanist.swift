//
//  DCRDoctorAccompanist.swift
//  HiDoctorApp
//
//  Created by swaasuser on 29/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDoctorAccompanist: Record
{
    var DCR_Doctor_Accompanist_Id: Int!
    var DCR_Id: Int!
    var Acc_Region_Code: String!
    var Acc_User_Code: String?
    var Acc_User_Name: String?
    var Acc_User_Type_Name: String?
    var Is_Only_For_Doctor: String!
    var Employee_Name: String?
    var Region_Name : String?
    var DCR_Doctor_Visit_Id : Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Code: String!
    var Is_Accompanied : String!
   // var Is_TP_Frozen: Int = 0
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.Acc_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Region_Code") as? String)
        let accUserName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Name") as? String)
        self.Acc_User_Name = accUserName
        var accUserCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Code")as? String)
        if accUserCode != EMPTY
        {
            self.Acc_User_Code = accUserCode
        }
        else
        {
            if  (accUserName == VACANT) || (accUserName == NOT_ASSIGNED)
            {
                accUserCode = self.Acc_User_Name!
                self.Acc_User_Code = accUserCode
            }
        }
        self.Acc_User_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Type_Name") as? String)
        
        if let isOnlyForDoctorValue = dict.value(forKey: "Is_Only_For_Doctor") as? Int
        {
            self.Is_Only_For_Doctor = String(isOnlyForDoctorValue)
        }
        if let isOnlyForDocvalue = dict.value(forKey: "Is_Only_For_Doctor") as? String
        {
            self.Is_Only_For_Doctor = isOnlyForDocvalue
        }
        
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "Visit_ID") as! Int
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Visit_Code") as? String)
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        if let accompaniedCall = (dict.object(forKey: "accompainedCall") as? Int)
        {
            self.Is_Accompanied  = String(accompaniedCall)
        }
        
//        if let frozenTP = dict.value(forKey: "Is_TP_Frozen") as? Int
//        {
//            self.Is_TP_Frozen = frozenTP
//        }
//        else
//        {
//
//            self.Is_TP_Frozen = 0
//        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Accompanist_Id = row["DCR_Doctor_Accompanist_Id"]
        DCR_Id = row["DCR_Id"]
        Acc_Region_Code = row["Acc_Region_Code"]
        Acc_User_Code = row["Acc_User_Code"]
        Acc_User_Name = row["Acc_User_Name"]
        Acc_User_Type_Name = row["Acc_User_Type_Name"]
        Is_Only_For_Doctor = row["Is_Only_For_Doctor"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        Employee_Name = row["Employee_Name"]
        Region_Name = row["Region_Name"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Code = row["DCR_Code"]
        Is_Accompanied = row["Is_Accompanied"]
      //  Is_TP_Frozen = row["Is_TP_Frozen"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Accompanist_Id"] = DCR_Doctor_Accompanist_Id
        container["DCR_Id"] = DCR_Id
        container["Acc_Region_Code"] = Acc_Region_Code
        container["Acc_User_Code"] = Acc_User_Code
        container["Acc_User_Name"] = Acc_User_Name
        container["Acc_User_Type_Name"] = Acc_User_Type_Name
        container["Is_Only_For_Doctor"] = Is_Only_For_Doctor
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Code"] = DCR_Code
        container["Is_Accompanied"] = Is_Accompanied
     //   container["Is_TP_Frozen"] = Is_TP_Frozen
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "DCR_Doctor_Accompanist_Id": DCR_Doctor_Accompanist_Id,
//            "DCR_Id": DCR_Id,
//            "Acc_Region_Code": Acc_Region_Code,
//            "Acc_User_Code": Acc_User_Code,
//            "Acc_User_Name": Acc_User_Name,
//            "Acc_User_Type_Name": Acc_User_Type_Name,
//            "Is_Only_For_Doctor": Is_Only_For_Doctor,
//            "DCR_Doctor_Visit_Id": DCR_Doctor_Visit_Id,
//            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
//            "DCR_Code": DCR_Code,
//            "Is_Accompanied":Is_Accompanied
//        ]
//    }
}
