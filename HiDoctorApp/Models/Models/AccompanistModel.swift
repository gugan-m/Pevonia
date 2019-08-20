//
//  AccompanistModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 07/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class AccompanistModel: Record
{
    var Accompanist_Id: Int!
    var User_Code: String!
    var User_Name: String!
    var Employee_name: String!
    var User_Type_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Division_Name: String!
    var Is_Child_User: Int!
    var Is_Immedidate_User: Int!
    var Child_User_Count: Int!
    var Full_index: String!
    var Hospital_Name: String!
   // var Hospital_Account_Number : String!
    
    init(dict: NSDictionary)
    {
        self.Accompanist_Id = dict.value(forKey: "Accompanist_Id") as! Int
        self.User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Code") as? String)
        self.User_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Name") as? String)
        self.Employee_name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Employee_Name") as? String)
        self.User_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Type_Name") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Name") as? String)
        self.Division_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Division_Name") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
      //  self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        self.Is_Child_User = dict.value(forKey: "Is_Child") as! Int
        self.Is_Immedidate_User = dict.value(forKey: "Is_Immediate") as! Int
        self.Child_User_Count = 0
        
        if let childCount = dict.value(forKey: "Child_User_Count") as? Int
        {
            self.Child_User_Count = childCount
        }
        self.Full_index = checkNullAndNilValueForString(stringData: dict.value(forKey: "Full_index") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        Accompanist_Id = row["Accompanist_Id"]
        User_Code = row["User_Code"]
        User_Name = row["User_Name"]
        Employee_name = row["Employee_name"]
        User_Type_Name = row["User_Type_Name"]
        Region_Code = row["Region_Code"]
        Region_Name = row["Region_Name"]
        Division_Name = row["Division_Name"]
        Is_Child_User = row["Is_Child_User"]
        Is_Immedidate_User = row["Is_Immedidate_User"]
        Child_User_Count = row["Child_User_Count"]
        Full_index = row["Full_index"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Accompanist_Id"] =  Accompanist_Id
        container["User_Code"] =  User_Code
        container["User_Name"] =  User_Name
        container["Employee_name"] =  Employee_name
        container["User_Type_Name"] =  User_Type_Name
        container["Region_Code"] =  Region_Code
        container["Region_Name"] =  Region_Name
        container["Division_Name"] =  Division_Name
        container["Is_Child_User"] =  Is_Child_User
        container["Is_Immedidate_User"] =  Is_Immedidate_User
        container["Child_User_Count"] = Child_User_Count
        container["Full_index"] = Full_index
        container["Hospital_Name"] = Hospital_Name
    //    container["Hospital_Account_Number"] = Hospital_Account_Number
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Accompanist_Id": Accompanist_Id,
//            "User_Code": User_Code,
//            "User_Name": User_Name,
//            "Employee_name": Employee_name,
//            "User_Type_Name": User_Type_Name,
//            "Region_Code": Region_Code,
//            "Region_Name": Region_Name,
//            "Division_Name": Division_Name,
//            "Is_Child_User": Is_Child_User,
//            "Is_Immedidate_User": Is_Immedidate_User
//        ]
//    }
}
