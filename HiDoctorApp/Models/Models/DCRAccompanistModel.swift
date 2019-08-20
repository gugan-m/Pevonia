//
//  DCRAccompanistModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRAccompanistModel: Record
{
    var DCR_Accompanist_Id: Int!
    var DCR_Id: Int!
    var Acc_Region_Code: String!
    var Acc_User_Code: String?
    var Acc_User_Name: String?
    var Acc_User_Type_Name: String?
    var Is_Only_For_Doctor: String!
    var Acc_Start_Time: String?
    var Acc_End_Time: String?
    var DCR_Code: String?
    var Employee_Name: String?
    var Region_Name : String = EMPTY
    var isAccompanistDataDownloadLater: Bool = false
    var isAccompanied: String?
    var Is_Customer_Data_Inherited: Int!
    var Is_TP_Frozen: Int = 0
    
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.Acc_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Region_Code") as? String)
        self.Acc_User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Code") as? String)
        self.Acc_User_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Name") as? String)
        self.Acc_User_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Type_Name") as? String)
        self.Is_Only_For_Doctor = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Only_For_Doctor") as? String)
        let timeArray = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Start_Time") as? String).components(separatedBy: "_")
        
        if timeArray.count > 0
        {
            if timeArray.count > 1
            {
                self.Acc_Start_Time = timeArray[0]
                self.Acc_End_Time = timeArray[1]
            }
            else
            {
                self.Acc_Start_Time = timeArray[0]
                self.Acc_End_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_End_Time") as? String)
            }
        }
        else
        {
            self.Acc_Start_Time = EMPTY
            self.Acc_End_Time = EMPTY
        }
        
       // self.Acc_Start_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Start_Time") as? String)
        
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        self.Is_Customer_Data_Inherited = Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Yet_To_Download
        if let isInherited = dict.value(forKey: "Is_Customer_Data_Inherited") as? Int
        {
            self.Is_Customer_Data_Inherited = isInherited
        }
        if let frozenTP = dict.value(forKey: "Is_TP_Frozen") as? Int
        {
            self.Is_TP_Frozen = frozenTP
        }
        else
        {
    
            self.Is_TP_Frozen = 0
        }
        
        if let employeeName = dict.value(forKey: "Employee_Name") as? String
        {
            self.Employee_Name = employeeName
        }
        else
        {
            let userName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Name") as? String)
            
            if (userName == VACANT || userName == NOT_ASSIGNED)
            {
               self.Employee_Name = userName
            }
            else
            {
                self.Employee_Name = EMPTY
            }
        }
       
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        DCR_Accompanist_Id = row["DCR_Accompanist_Id"]
        DCR_Id = row["DCR_Id"]
        Acc_Region_Code = row["Acc_Region_Code"]
        Acc_User_Code = row["Acc_User_Code"]
        Acc_User_Name = row["Acc_User_Name"]
        Acc_User_Type_Name = row["Acc_User_Type_Name"]
        Is_Only_For_Doctor = row["Is_Only_For_Doctor"]
        Acc_Start_Time = row["Acc_Start_Time"]
        Acc_End_Time = row["Acc_End_Time"]
        DCR_Code = row["DCR_Code"]
        Employee_Name = row["Employee_Name"]
       // Region_Name = row["Region_Name"]
        isAccompanied = row["Accompained_Call"]
        Is_Customer_Data_Inherited = row["Is_Customer_Data_Inherited"]
        Is_TP_Frozen = row["Is_TP_Frozen"]


        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Accompanist_Id"] =  DCR_Accompanist_Id
        container["DCR_Id"] = DCR_Id
        container["Acc_Region_Code"] =  Acc_Region_Code
        container["Acc_User_Code"] =  Acc_User_Code
        container["Acc_User_Name"] =  Acc_User_Name
        container["Acc_User_Type_Name"] =  Acc_User_Type_Name
        container["Is_Only_For_Doctor"] =  Is_Only_For_Doctor
        container["Acc_Start_Time"] =  Acc_Start_Time
        container["Acc_End_Time"] =  Acc_End_Time
        container["DCR_Code"] =  DCR_Code
        container["Is_Customer_Data_Inherited"] = Is_Customer_Data_Inherited
        container["Is_TP_Frozen"] = Is_TP_Frozen
        container["Employee_Name"] = Employee_Name
    }
//     var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "DCR_Accompanist_Id": DCR_Accompanist_Id,
//            "DCR_Id": DCR_Id,
//            "Acc_Region_Code": Acc_Region_Code,
//            "Acc_User_Code": Acc_User_Code,
//            "Acc_User_Name": Acc_User_Name,
//            "Acc_User_Type_Name": Acc_User_Type_Name,
//            "Is_Only_For_Doctor": Is_Only_For_Doctor,
//            "Acc_Start_Time": Acc_Start_Time,
//            "Acc_End_Time": Acc_End_Time,
//            "DCR_Code": DCR_Code
//        ]
//    }
}
