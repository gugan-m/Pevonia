//
//  ExpenseGroupMapping.swift
//  HiDoctorApp
//
//  Created by SwaaS on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class ExpenseGroupMapping: Record
{
    var Expense_Type_Code: String!
    var Expense_Type_Name: String!
    var Expense_Group_Id: Int!
    var Expense_Group_Detail_Id: Int!
    var Expense_Mode: String!
    var Expense_Entity: String!
    var Expense_Entity_Code: String!
    var Eligibility_Amount: Float!
    var Can_Split_Amount: String!
    var Period: String!
    var Is_Validation_On_Eligibility: String!
    var Effective_From: Date!
    var Effective_To: Date!
    var SFC_Type: String!
    var Is_Prefill: String!
    var Record_Status: String!
    var Distance_Edit: Int!
    var Sum_Distance_Needed: Int!
    var Is_Remarks_Mandatory:Int!
    
    init(dict: NSDictionary)
    {
        self.Expense_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Type_Code") as? String)
        self.Expense_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Type_Name") as? String)
        self.Expense_Group_Id = Int(dict.value(forKey: "Expense_Group_Id") as! String)
        self.Expense_Group_Detail_Id = Int( dict.value(forKey: "Expense_Group_Detail_Id") as! String)
        self.Expense_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Mode") as? String)
        self.Expense_Entity = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Entity") as? String)
        self.Expense_Entity_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Entity_Code") as? String)
        
        if let eligibilityAmountFloat = dict.value(forKey: "Eligibility_Amount") as? Float
        {
            self.Eligibility_Amount = eligibilityAmountFloat
        }
        else if let eligibilityAmountDouble = dict.value(forKey: "Eligibility_Amount") as? Double
        {
            self.Eligibility_Amount = Float(eligibilityAmountDouble)
        }
        else
        {
            self.Eligibility_Amount = 0
        }
       // self.Eligibility_Amount = dict.value(forKey: "Eligibility_Amount") as! Float
        self.Can_Split_Amount = checkNullAndNilValueForString(stringData: dict.value(forKey: "Can_Split_Amount") as? String)
        self.Period = checkNullAndNilValueForString(stringData: dict.value(forKey: "Period") as? String)
        self.Is_Validation_On_Eligibility = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Validation_On_Eligibility") as? String)
        self.Effective_From = getStringInFormatDate(dateString: dict.value(forKey: "Effective_From") as! String)
        self.Effective_To = getStringInFormatDate(dateString: dict.value(forKey: "Effective_To") as! String)
        self.SFC_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "SFC_Type") as? String)
        self.Is_Prefill = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Prefill") as? String)
        self.Record_Status = checkNullAndNilValueForString(stringData: dict.value(forKey: "Record_Status") as? String)
        self.Distance_Edit = Int(dict.value(forKey: "Distance_Edit") as! String)
        self.Sum_Distance_Needed = Int(dict.value(forKey: "Sum_Distance_Needed") as! String)
        if let remarksMandatory = dict.value(forKey: "IsMandatory") as? Int
        {
            self.Is_Remarks_Mandatory = remarksMandatory
        }
        else
        {
            self.Is_Remarks_Mandatory = 0
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_EXPENSE_GROUP_MAPPING
    }
    
    required init(row: Row)
    {
        Expense_Type_Code = row["Expense_Type_Code"]
        Expense_Type_Name = row["Expense_Type_Name"]
        Expense_Group_Id = row["Expense_Group_Id"]
        Expense_Group_Detail_Id = row["Expense_Group_Detail_Id"]
        Expense_Mode = row["Expense_Mode"]
        Expense_Entity = row["Expense_Entity"]
        Expense_Entity_Code = row["Expense_Entity_Code"]
        Eligibility_Amount = row["Eligibility_Amount"]
        Can_Split_Amount = row["Can_Split_Amount"]
        Period = row["Period"]
        Is_Validation_On_Eligibility = row["Is_Validation_On_Eligibility"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        SFC_Type = row["SFC_Type"]
        Is_Prefill = row["Is_Prefill"]
        Record_Status = row["Record_Status"]
        Distance_Edit = row["Distance_Edit"]
        Sum_Distance_Needed = row["Sum_Distance_Needed"]
        Is_Remarks_Mandatory = row["Is_Remarks_Mandatory"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        
        container["Expense_Type_Code"] = Expense_Type_Code
        container["Expense_Type_Name"] = Expense_Type_Name
        container["Expense_Group_Id"] = Expense_Group_Id
        container["Expense_Group_Detail_Id"] = Expense_Group_Detail_Id
        container["Expense_Mode"] = Expense_Mode
        container["Expense_Entity"] = Expense_Entity
        container["Expense_Entity_Code"] = Expense_Entity_Code
        container["Eligibility_Amount"] = Eligibility_Amount
        container["Can_Split_Amount"] = Can_Split_Amount
        container["Period"] = Period
        container["Is_Validation_On_Eligibility"] = Is_Validation_On_Eligibility
        container["Effective_From"] = Effective_From
        container["Effective_To"] = Effective_To
        container["SFC_Type"] = SFC_Type
        container["Is_Prefill"] = Is_Prefill
        container["Record_Status"] = Record_Status
        container["Distance_Edit"] = Distance_Edit
        container["Sum_Distance_Needed"] = Sum_Distance_Needed
        container["Is_Remarks_Mandatory"] = Is_Remarks_Mandatory
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Expense_Type_Code": Expense_Type_Code,
//            "Expense_Type_Name": Expense_Type_Name,
//            "Expense_Group_Id": Expense_Group_Id,
//            "Expense_Group_Detail_Id": Expense_Group_Detail_Id,
//            "Expense_Mode": Expense_Mode,
//            "Expense_Entity": Expense_Entity,
//            "Expense_Entity_Code": Expense_Entity_Code,
//            "Eligibility_Amount": Eligibility_Amount,
//            "Can_Split_Amount": Can_Split_Amount
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "Period": Period,
//            "Is_Validation_On_Eligibility": Is_Validation_On_Eligibility,
//            "Effective_From": Effective_From,
//            "Effective_To": Effective_To,
//            "SFC_Type": SFC_Type,
//            "Is_Prefill": Is_Prefill,
//            "Record_Status": Record_Status,
//            "Distance_Edit": Distance_Edit,
//            "Sum_Distance_Needed": Sum_Distance_Needed,
//            "Is_Remarks_Mandatory":Is_Remarks_Mandatory
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        
//        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
