//
//  DCRChemistVisitModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRChemistVisitModel: Record
{
    var DCR_Chemist_Visit_Id: Int!
    var DCR_Chemist_Visit_Code: String!
    var DCR_Doctor_Visit_Id: Int?
    var DCR_Doctor_Visit_Code: String!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Chemist_Id: Int?
    var Chemist_Code: String?
    var Chemist_Name: String?
    var POB_Amount: Double?
//    var Cv_Customer_Name: String!
//    var Cv_Customer_Region_Code: String!
//    var Cv_Customer_Code: String!
//    var Cv_Customer_Speciality: String!
//    var Cv_Customer_Category: String!
//    var Cv_Customer_MDL_Number: String!
//    var Cv_Customer_Visit_Time: String!
//    var Cv_Remarks: String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Chemist_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Chemists_Code") as? String)
        self.DCR_Doctor_Visit_Id = dict.value(forKey: "Visit_Id") as? Int ?? 0
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        if let chemistId = dict.value(forKey: "Chemist_Id") as? Int
        {
            self.Chemist_Id = chemistId
        }
        
        self.Chemist_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemist_Code") as? String)
        self.Chemist_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemist_Name") as? String)
        
        if let pobAmount = dict.value(forKey: "POB_Amount") as? Float
        {
            self.POB_Amount = Double(pobAmount)
        }
        if let pobAmount = dict.value(forKey: "POB_Amount") as? Double
        {
            self.POB_Amount = pobAmount
        }
//        self.Cv_Customer_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Name") as? String)
//        self.Cv_Customer_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Region_Code") as? String)
//        self.Cv_Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Code") as? String)
//        self.Cv_Customer_Speciality = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Speciality") as? String)
//        self.Cv_Customer_Category = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Category") as? String)
//        self.Cv_Customer_MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_MDL_Number") as? String)
//        self.Cv_Customer_Visit_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Customer_Visit_Time") as? String)
//        self.Cv_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Cv_Remarks") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMISTS_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Chemist_Visit_Id = row["DCR_Chemist_Visit_Id"]
        DCR_Chemist_Visit_Code = row["DCR_Chemist_Visit_Code"]
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Chemist_Id = row["Chemist_Id"]
        Chemist_Code = row["Chemist_Code"]
        Chemist_Name = row["Chemist_Name"]
        POB_Amount = row["POB_Amount"]
//        Cv_Customer_Name = row["Cv_Customer_Name")
//        Cv_Customer_Region_Code = row["Cv_Customer_Region_Code")
//        Cv_Customer_Code = row["Cv_Customer_Code")
//        Cv_Customer_Speciality = row["Cv_Customer_Speciality")
//        Cv_Customer_Category = row["Cv_Customer_Category")
//        Cv_Customer_MDL_Number = row["Cv_Customer_MDL_Number")
//        Cv_Customer_Visit_Time = row["Cv_Customer_Visit_Time")
//        Cv_Remarks = row["Cv_Remarks")
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Id"] = DCR_Doctor_Visit_Id
        container["DCR_Chemist_Visit_Code"] = DCR_Chemist_Visit_Code
        container["DCR_Doctor_Visit_Code"] = DCR_Doctor_Visit_Code
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["Chemist_Id"] = Chemist_Id
        container["Chemist_Code"] = Chemist_Code
        container["Chemist_Name"] = Chemist_Name
        container["POB_Amount"] = POB_Amount
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Doctor_Visit_Id": DCR_Doctor_Visit_Id,
//            "DCR_Chemist_Visit_Code": DCR_Chemist_Visit_Code,
//            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
//            "DCR_Id": DCR_Id,
//            "DCR_Code": DCR_Code,
//            "Chemist_Id": Chemist_Id,
//            "Chemist_Code": Chemist_Code,
//            "Chemist_Name": Chemist_Name,
//            "POB_Amount": POB_Amount
//        ]
    
        //        let dict2: [String : DatabaseValueConvertible?] = [
        //            "Cv_Customer_Name": Cv_Customer_Name,
        //            "Cv_Customer_Region_Code": Cv_Customer_Region_Code,
        //            "Cv_Customer_Code": Cv_Customer_Code,
        //            "Cv_Customer_Speciality": Cv_Customer_Speciality,
        //            "Cv_Customer_Category": Cv_Customer_Category,
        //            "Cv_Customer_MDL_Number": Cv_Customer_MDL_Number,
        //            "Cv_Customer_Visit_Time": Cv_Customer_Visit_Time,
        //            "Cv_Remarks": Cv_Remarks
        //        ]
        
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        //        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
