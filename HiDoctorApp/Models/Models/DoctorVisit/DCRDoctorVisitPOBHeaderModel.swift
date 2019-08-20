//
//  DCRDoctorVisitPOB_Header.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB


class DCRDoctorVisitPOBHeaderModel: Record
{
    var Order_Entry_Id : Int!
    var Order_Id : Int!
    var Order_Number : Int!
    var Order_Date : Date!
    var DCR_Id : Int?
    var DCR_Code: String?
    var DCR_Actual_Date : Date!
    var Stockiest_Name: String!
    var Stockiest_Code : String!
    var Stockiest_Region_Code : String!
    var Customer_Name : String!
    var Customer_Code : String!
    var Customer_Region_Code : String!
    var Customer_MDL_Number : String!
    var Customer_Category_Code : String!
    var Speciality_Name : String!
    var Visit_Id : Int!
    var Order_Due_Date : Date!
    var Order_Status : Int!
    var Order_Mode : Int!
    var Action_Mode : Int!
    var Favouring_User_Code : String!
    var Favouring_Region_Code : String!
    var Customer_Entity_Type : String!
    
    
    init(dict: NSDictionary)
    {
        if(dict.value(forKey: "Order_Id") == nil)
        {
           self.Order_Id = -1
        }
        else if let orderId = dict.value(forKey: "Order_Id") as? Int
        {
            self.Order_Id = orderId
        }
            //dict.value(forKey: "Order_Id") as! Int
        self.Order_Number =  Int(checkNullAndNilValueForString(stringData: dict.value(forKey: "Order_Number") as? String))
        let orderDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Order_Date") as? String)
        let orderDateArray = orderDate.components(separatedBy: "T")
        if orderDate != EMPTY
        {
            self.Order_Date = getStringInFormatDate(dateString: orderDateArray[0])
            
        }
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        if dict.value(forKey:"DCR_Actual_Date") != nil
        {
            let dcrActualDate =  checkNullAndNilValueForString(stringData: dict.value(forKey:"DCR_Actual_Date") as? String)
            let dcrDateArray = dcrActualDate.components(separatedBy: "T")
            if dcrActualDate != EMPTY
            {
                self.DCR_Actual_Date = getStringInFormatDate(dateString: dcrDateArray[0])
            }
        }
        self.Stockiest_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Name") as? String)
        self.Stockiest_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Code") as? String)
        self.Customer_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name") as? String)
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Stockiest_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Region_Code") as? String)
        self.Customer_Region_Code =  checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Region_Code") as? String)
        self.Customer_MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_MDLNumber") as? String)
        self.Customer_Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_CategoryCode") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Speciality") as? String)
        if let visitId = dict.value(forKey: "Visit_Id") as? Int
        {
            self.Visit_Id = visitId
        }
        let orderDueDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Order_Due_Date") as? String)
        let orderedDueDateArray = orderDueDate.components(separatedBy: "T")
        if orderDueDate != EMPTY
        {
           self.Order_Due_Date = getStringInFormatDate(dateString: orderedDueDateArray[0])
            
        }
        if let orderStatus = dict.value(forKey: "Order_Status") as? Int
        {
            self.Order_Status = orderStatus
        }
        if let orderMode = dict.value(forKey: "Order_Mode") as? Int
        {
            self.Order_Mode = orderMode
        }
        self.Action_Mode = dict.value(forKey: "Action_Mode") as? Int ?? 0
        self.Favouring_User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Favouring_User_Code") as? String)
        self.Favouring_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Favouring_Region_Code") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Type") as? String)

        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT_POB_HEADER
    }
    
    required init(row: Row)
    {
        
        Order_Entry_Id = row["Order_Entry_Id"]
        Order_Id = row["Order_Id"]
        Order_Number = row["Order_Number"]
        Order_Date = row["Order_Date"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Stockiest_Name = row["Stockiest_Name"]
        Stockiest_Code = row["Stockiest_Code"]
        Stockiest_Region_Code = row["Stockiest_Region_Code"]
        Customer_Name = row["Customer_Name"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Customer_MDL_Number = row["Customer_MDL_Number"]
        Customer_Category_Code = row["Customer_Category_Code"]
        Speciality_Name = row["Speciality_Name"]
        Visit_Id = row["Visit_Id"]
        Order_Due_Date = row["Order_Due_Date"]
        Order_Status = row["Order_Status"]
        Order_Mode = row["Order_Status"]
        Action_Mode = row["Action_Mode"]
        Favouring_User_Code = row["Favouring_User_Code"]
        Favouring_Region_Code = row["Favouring_Region_Code"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Order_Entry_Id"] = Order_Entry_Id
        container["Order_Number"] = Order_Number
        container["Order_Id"] = Order_Id
        container["Order_Date"] = Order_Date
        container["DCR_Id" ] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Stockiest_Name"] = Stockiest_Name
        container["Stockiest_Code"] = Stockiest_Code
        container["Stockiest_Region_Code"] = Stockiest_Region_Code
        container["Customer_Name"] = Customer_Name
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Customer_MDL_Number"] = Customer_MDL_Number
        container["Customer_Category_Code"] = Customer_Category_Code
        container["Speciality_Name"] = Speciality_Name
        container["Visit_Id"] = Visit_Id
        container["Order_Due_Date"] =  Order_Due_Date
        container["Order_Status"] =  Order_Status
        container["Order_Mode"] = Order_Mode
        container["Action_Mode"] = Action_Mode
        container["Favouring_User_Code"] = Favouring_User_Code
        container["Favouring_Region_Code"] =  Favouring_Region_Code
        container["Customer_Entity_Type"] =  Customer_Entity_Type
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1:[String : DatabaseValueConvertible?] = [
//            "Order_Entry_Id":Order_Entry_Id,
//            "Order_Number":Order_Number,
//            "Order_Id":Order_Id,
//            "Order_Date":Order_Date,
//            "DCR_Id" : DCR_Id,
//            "DCR_Code":DCR_Code,
//            "DCR_Actual_Date":DCR_Actual_Date,
//            "Stockiest_Name":Stockiest_Name,
//            "Stockiest_Code":Stockiest_Code
//            ]
//        
//        let dict2: [String : DatabaseValueConvertible?] = [
//            
//            "Stockiest_Region_Code":Stockiest_Region_Code,
//            "Customer_Name":Customer_Name,
//            "Customer_Code":Customer_Code,
//            "Customer_Region_Code":Customer_Region_Code,
//            "Customer_MDL_Number":Customer_MDL_Number,
//            "Customer_Category_Code":Customer_Category_Code,
//            "Speciality_Name":Speciality_Name,
//            "Visit_Id":Visit_Id
//            ]
//        
//        let dict3: [String : DatabaseValueConvertible?] = [
//            
//            "Order_Due_Date": Order_Due_Date,
//            "Order_Status": Order_Status,
//            "Order_Mode":Order_Mode,
//            "Action_Mode":Action_Mode,
//            "Favouring_User_Code":Favouring_User_Code,
//            "Favouring_Region_Code": Favouring_Region_Code,
//            "Customer_Entity_Type": Customer_Entity_Type
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//        combinedAttributes.addEntries(from: dict3)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
    
}


