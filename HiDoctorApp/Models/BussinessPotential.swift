//
//  BussinessPotential.swift
//  HiDoctorApp
//
//  Created by SwaaS on 21/03/19.
//  Copyright © 2019 swaas. All rights reserved.
//
import UIKit
import GRDB

class BussinessPotential: Record
{
    var Doctor_Code: String?
    var Doctor_Region_Code: String?
    var Dcr_Date: String?
    var Business_Status_Id: Int?
    var Business_Status_Name: String?
    var Entity_Type: Int?
    var Entity_Description: String?
    var Division_Code: String?
    var Product_Code: String?
    var Business_Potential : Float?
    
    init(dict: NSDictionary)
    {
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Dcr_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Dcr_Date") as? String)
        self.Business_Status_Id = (dict.value(forKey: "Business_Status_Id") as? Int)!
        self.Business_Status_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Business_Status_Name") as? String)
        self.Entity_Type = (dict.value(forKey: "Entity_Type") as? Int)!
        self.Entity_Description = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Description") as? String)
        self.Division_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Division_Code") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Business_Potential = checkNullAndNilValueForFloat(floatData: dict.value(forKey: "Business_Potential") as? Float)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return BUSINESS_STATUS_POTENTIAL
    }
    
    required init(row: Row)
    {
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Dcr_Date = row["Dcr_Date"]
        Business_Status_Id = row["Business_Status_Id"]
        Business_Status_Name = row["Business_Status_Name"]
        Entity_Type = row["Entity_Type"]
        Entity_Description = row["Entity_Description"]
        Division_Code = row["Division_Code"]
        Product_Code = row["Product_Code"]
        Business_Potential = row["Business_Potential"]
    
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Doctor_Code"] = Doctor_Code
        container["Doctor_Region_Code"] = Doctor_Region_Code
        container["Dcr_Date"] = Dcr_Date
        container["Business_Status_Id"] = Business_Status_Id
        container["Business_Status_Name"] = Business_Status_Name
        container["Entity_Type"] = Entity_Type
        container["Entity_Description"] = Entity_Description
        container["Division_Code"] = Division_Code
        container["Product_Code"] = Product_Code
        container["Business_Potential"] = Business_Potential
    }
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        return [
    //            "DCR_Stockiest_Id": DCR_Stockiest_Id,
    //            "DCR_Id": DCR_Id,
    //            "DCR_Code": DCR_Code,
    //            "Stockiest_Id": Stockiest_Id,
    //            "Stockiest_Code": Stockiest_Code,
    //            "Stockiest_Name": Stockiest_Name,
    //            "POB_Amount": POB_Amount,
    //            "Collection_Amount": Collection_Amount,
    //            "Visit_Mode": Visit_Mode,
    //            "Remarks": Remarks
    //        ]
    //    }
}
