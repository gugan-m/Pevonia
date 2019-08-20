//
//  DCRExpenseModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRExpenseModel: Record
{
    var DCR_Expense_Id: Int!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Expense_Type_Code: String!
    var Expense_Type_Name: String!
    var Expense_Amount: Float!
    var Expense_Mode: String!
    var Eligibility_Amount: Float?
    var Expense_Group_Id: Int!
    var Expense_Claim_Code: String?
    var Remarks: String?
    var Is_Prefilled: Int?
    var Is_Editable: Int?
    var Flag: Int!
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Expense_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Expense_Type_Code") as? String)
        self.Expense_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Type_Name") as? String)
        self.Expense_Amount =  Float(dict.value(forKey: "Expense_Amount") as! String)
        self.Expense_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Mode") as? String)
        
        if let eigibilityAmount = dict.value(forKey: "Eligibility_Amount") as? Float
        {
            self.Eligibility_Amount = eigibilityAmount
        }
        
        self.Expense_Group_Id = dict.value(forKey: "Expense_Group_Id") as! Int
        
        self.Expense_Claim_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Claim_Code") as? String)
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Expense_Remarks") as? String)
        
        if let isPrefilled = dict.value(forKey: "Is_Prefilled") as? Int
        {
            self.Is_Prefilled = isPrefilled
        }
        else
        {
            self.Is_Prefilled = 0
        }
        
        if let isEditable = dict.value(forKey: "Is_Editable") as? Int
        {
            self.Is_Editable = isEditable
        }
        else
        {
            self.Is_Editable = 0
        }
        
        self.Flag = dict.value(forKey: "Flag") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_EXPENSE_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_Expense_Id = row["DCR_Expense_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Expense_Type_Code = row["Expense_Type_Code"]
        Expense_Type_Name = row["Expense_Type_Name"]
        Expense_Amount = row["Expense_Amount"]
        Expense_Mode = row["Expense_Mode"]
        Eligibility_Amount = row["Eligibility_Amount"]
        Expense_Group_Id = row["Expense_Group_Id"]
        Expense_Claim_Code = row["Expense_Claim_Code"]
        Remarks = row["Remarks"]
        Is_Prefilled = row["Is_Prefilled"]
        Is_Editable = row["Is_Editable"]
        Flag = row["Flag"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Expense_Id"] = DCR_Expense_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Expense_Type_Code"] = Expense_Type_Code
        container["Expense_Type_Name"] = Expense_Type_Name
        container["Expense_Amount"] = Expense_Amount
        container["Expense_Mode"] = Expense_Mode
        container["Eligibility_Amount"] = Eligibility_Amount
        container["Expense_Group_Id"] = Expense_Group_Id
        container["Expense_Claim_Code"] = Expense_Claim_Code
        container["Remarks"] = Remarks
        container["Is_Prefilled"] = Is_Prefilled
        container["Is_Editable"] = Is_Editable
        container["Flag"] = Flag
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Expense_Id": DCR_Expense_Id,
//            "DCR_Id": DCR_Id,
//            "DCR_Code": DCR_Code,
//            "Expense_Type_Code": Expense_Type_Code,
//            "Expense_Type_Name": Expense_Type_Name,
//            "Expense_Amount": Expense_Amount,
//            "Expense_Mode": Expense_Mode,
//            "Eligibility_Amount": Eligibility_Amount
//        ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Expense_Group_Id": Expense_Group_Id,
//            "Expense_Claim_Code": Expense_Claim_Code,
//            "Remarks": Remarks,
//            "Is_Prefilled": Is_Prefilled,
//            "Is_Editable": Is_Editable,
//            "Flag": Flag
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
