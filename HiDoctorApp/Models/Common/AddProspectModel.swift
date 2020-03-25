//
//  AddProspectModel.swift
//  HiDoctorApp
//
//  Created by SSPLLAP-011 on 24/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit
import GRDB

class AddProspectModel: Record {
      
    var Flag : String!
    var Prospect_Id : Int!
    var Company_Code : String!
    var Company_Id : Int!
    var Account_Name : String!
    var Contact_Name : String!
    var Address : String!
    var City : String!
    var State : String!
    var Phone_No : String!
    var Email : String!
    var Prospect_Status : String!
    var DCR_Date : String!
    var Created_Region_Code : String!
    var Created_By : String!
    var Created_DateTime : String!
    var Title : String!
    var Zip: Int!
    var isSelected = false
    
     init(dict: NSDictionary)
     {
        self.Flag = (dict.value(forKey: "Flag") as? String ?? "")
        self.Zip = (dict.value(forKey: "Zip") as? Int ?? 0)
        self.Prospect_Id = (dict.value(forKey: "Prospect_Id") as? Int ?? 0)
        self.Company_Code = (dict.value(forKey: "Company_Code") as! String)
        self.Company_Id = (dict.value(forKey: "Company_Id") as? Int ?? 0)
        self.Account_Name = (dict.value(forKey: "Account_Name") as! String)
        self.Contact_Name = (dict.value(forKey: "Contact_Name") as! String)
        self.Address = (dict.value(forKey: "Address") as! String)
        self.City = (dict.value(forKey: "City") as! String)
        self.State = (dict.value(forKey: "State") as! String)
        self.Phone_No = (dict.value(forKey: "Phone_No") as! String)
        self.Email = (dict.value(forKey: "Email") as! String)
        self.Prospect_Status = (dict.value(forKey: "Prospect_Status") as! String)
        self.DCR_Date = (dict.value(forKey: "DCR_Date") as! String)
        self.Created_Region_Code = (dict.value(forKey: "Created_Region_Code") as! String)
        self.Created_By = (dict.value(forKey: "Created_By") as! String)
        self.Created_DateTime = "\(dict.value(forKey: "Created_DateTime"))"
        self.Title = (dict.value(forKey: "Title") as! String)
         super.init()
     }

     override class var databaseTableName: String
     {
         return TRAN_PROSPECTING
     }

     required init(row: Row)
     {
        Flag = row["Flag"]
        Prospect_Id = row["Prospect_Id"]
        Company_Code = row["Company_Code"]
        Company_Id = row["Company_Id"]
        Account_Name = row["Account_Name"]
        Contact_Name = row["Contact_Name"]
        Address = row["Address"]
        City = row["City"]
        State = row["State"]
        Phone_No = row["Phone_No"]
        Email = row["Email"]
        Prospect_Status = row["Prospect_Status"]
        DCR_Date = row["DCR_Date"]
        Created_Region_Code = row["Created_Region_Code"]
        Created_By = row["Created_By"]
        Created_DateTime = row["Created_DateTime"]
        Title = row["Title"]
        Zip = row["Zip"]
      super.init(row: row)
     }
    
    override func encode(to container: inout PersistenceContainer) {
        container["Flag"] =  Flag
        container["Prospect_Id"] =  Prospect_Id
        container["Company_Code"] =  Company_Code
        container["Company_Id"] =  Company_Id
        container["Account_Name"] =  Account_Name
        container["Contact_Name"] =  Contact_Name
        container["Address"] =  Address
        container["City"] =  City
        container["State"] =  State
        container["Phone_No"] =  Phone_No
        container["Prospect_Status"] =  Prospect_Status
        container["DCR_Date"] =  DCR_Date
        container["Created_Region_Code"] =  Created_Region_Code
        container["Created_By"] =  Created_By
        container["Created_DateTime"] =  Created_DateTime
        container["Title"] = Title
        container["Email"] = Email
        container["Zip"] = Zip
    }
}
