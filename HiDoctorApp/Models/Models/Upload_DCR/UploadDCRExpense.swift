//
//  UploadDCRExpense.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRExpense: Record
{
    var DCR_Id: Int!
    var DCR_Code: String?
    var DCR_Expense_Type_Id: Int!
    var DCR_Expense_Type_Code: String!
    var Expense_Amount: Double!
    var Expense_Mode: String?
    var Expense_Claim_Code: String?
    var Eligibility_Amount: Double?
    var Expense_Group_Id: Int!
    var Remarks: String?
    var Expense_Type_Name: String?
    var Flag: Int?
    var isPrefill: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_EXPENSE_DETAILS
    }
    
    required init(row: Row)
    {
        DCR_Expense_Type_Id = row["DCR_Expense_Id"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        DCR_Expense_Type_Code = row["Expense_Type_Code"]
        Expense_Type_Name = row["Expense_Type_Name"]
        Expense_Amount = row["Expense_Amount"]
        Expense_Mode = row["Expense_Mode"]
        Eligibility_Amount = row["Eligibility_Amount"]
        Expense_Group_Id = row["Expense_Group_Id"]
        Expense_Claim_Code = row["Expense_Claim_Code"]
        Remarks = row["Remarks"]
        
        super.init(row: row)
    }
}
