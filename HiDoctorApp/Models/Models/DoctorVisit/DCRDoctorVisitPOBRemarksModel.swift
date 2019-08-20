//
//  DCRDoctorVisitPOBRemarksModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDoctorVisitPOBRemarksModel: Record
{
    var Remarks_Entry_Id : Int!
    var Order_Entry_Id : Int!
    var DCR_Id: Int!
    var DCR_Code: String?
    var Remarks : String!
    
    init(dict : NSDictionary)
    {
        if let orderEntryId = dict.value(forKey: "Order_Entry_Id") as? Int
        {
            self.Order_Entry_Id = orderEntryId
        }
        self.DCR_Id = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.Remarks =  checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT_POB_REMARKS
    }
    
    required init(row: Row)
    {
        Remarks_Entry_Id = row["Remarks_Entry_Id"]
        Order_Entry_Id = row["Order_Entry_Id"]
        DCR_Id =  row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Remarks = row["Remarks"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Remarks_Entry_Id"] = Remarks_Entry_Id
        container["Order_Entry_Id"] = Order_Entry_Id
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Remarks"] = Remarks
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Remarks_Entry_Id":Remarks_Entry_Id,
//            "Order_Entry_Id":Order_Entry_Id,
//            "DCR_Id":DCR_Id,
//            "DCR_Code":DCR_Code,
//            "Remarks":Remarks
//        ]
//    }
}
