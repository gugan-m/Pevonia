//
//  ChemistDayModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 14/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB


class DCRChemistAccompanist: Record
{
    var DCRChemistAccompanistId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var AccRegionCode : String!
    var AccUserName : String!
    var AccUserCode : String!
    var AccUserTypeName : String!
    var IsAccompaniedCall : Int!
    var IsOnlyForChemist : String!
    var EmployeeName: String?
    var RegionName : String?
    var UTC_DateTime: String?
    var Entered_TimeZone: String?
    var Entered_OffSet: String?
    var Created_DateTime: String?
//    var Is_TP_Frozen: Int = 0
    
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        self.AccRegionCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Region_Code")as? String)
        let accUserName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Name")as? String)
        self.AccUserName = accUserName
        var accUserCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Code")as? String)
        if accUserCode != EMPTY
        {
            self.AccUserCode = accUserCode
        }
        else
        {
            if  (accUserName == VACANT) || (accUserName == NOT_ASSIGNED)
            {
                accUserCode = self.AccUserName
                self.AccUserCode = accUserCode
            }
        }
        self.AccUserTypeName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_User_Type_Name")as? String)
        self.IsAccompaniedCall = dict.value(forKey: "Is_Accompanied_call") as? Int ?? 0
        
        if let isOnlyForchemistValue = dict.value(forKey: "Is_Only_For_Chemist") as? Int
        {
            self.IsOnlyForChemist = String(isOnlyForchemistValue)
        }
        if let isOnlyForChemvalue = dict.value(forKey: "Is_Only_For_Chemist") as? String
        {
            self.IsOnlyForChemist = isOnlyForChemvalue
        }
        
//        if let frozenTP = dict.value(forKey: "Is_TP_Frozen") as? Int
//        {
//            self.Is_TP_Frozen = frozenTP
//        }
//        else
//        {
//
//            self.Is_TP_Frozen = 0
//        }
        self.UTC_DateTime = getUTCDateForPunch()
        self.Entered_TimeZone = getcurrenttimezone()
        self.Entered_OffSet = getOffset()
        self.Created_DateTime = getCurrentDateAndTimeString()
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_ACCOMPANIST
    }
    
    required init(row: Row)
    {
        DCRChemistAccompanistId = row["DCR_Chemist_Accompanist_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        AccRegionCode = row["Acc_Region_Code"]
        AccUserName = row["Acc_User_Name"]
        AccUserCode = row["Acc_User_Code"]
        AccUserTypeName = row["Acc_User_Type_Name"]
        IsAccompaniedCall = row["Is_Accompanied_Call"]
        IsOnlyForChemist = row["Is_Only_For_Chemist"]
        EmployeeName = row["Employee_Name"]
        RegionName = row["Region_Name"]
       // Is_TP_Frozen = row["Is_TP_Frozen"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"]  = DCRId
        container["DCR_Code"]  = DCRCode
        container["Chemist_Visit_Id"]  = ChemistVisitId
        container["Chemist_Visit_Code"]  = ChemistVisitCode
        container["Acc_Region_Code"]  = AccRegionCode
        container["Acc_User_Code"]  = AccUserCode
        container["Acc_User_Name"]  = AccUserName
        container["Acc_User_Type_Name"]  = AccUserTypeName
        container["Is_Accompanied_Call"]  = IsAccompaniedCall
        container["Is_Only_For_Chemist"]  = IsOnlyForChemist
      //  container["Is_TP_Frozen"] = Is_TP_Frozen
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Acc_Region_Code" : AccRegionCode
//            ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Acc_User_Code" : AccUserCode,
//            "Acc_User_Name" : AccUserName,
//            "Acc_User_Type_Name" : AccUserTypeName,
//            "Is_Accompanied_Call" : IsAccompaniedCall,
//            "Is_Only_For_Chemist" : IsOnlyForChemist
//            ]
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

class DCRChemistSamplePromotion: Record
{
    var DCRChemistSampleId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var ProductCode : String!
    var ProductName : String!
    var QuantityProvided : Int!
    var CurrentStock : Int!
    var DivisionName : String!
    var ProductTypeCode: String!
    var ProductTypeName : String!
    var BatchName = String()
    var UTC_DateTime: String?
    var Entered_TimeZone: String?
    var Entered_OffSet: String?
    var Created_DateTime: String?
    
    

    
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        self.ProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code")as? String)
        self.ProductName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name")as? String)
        self.QuantityProvided = dict.value(forKey: "Quantity_Provided") as? Int ?? 0
        self.UTC_DateTime = getUTCDateForPunch()
        self.Entered_TimeZone = getcurrenttimezone()
        self.Entered_OffSet = getOffset()
        self.Created_DateTime = getCurrentDateAndTimeString()
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_SAMPLE_PROMOTION
    }
    
    required init(row: Row)
    {
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRChemistSampleId = row["DCR_Chemist_Sample_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        ProductCode = row["Product_Code"]
        ProductName = row["Product_Name"]
        QuantityProvided = row["Quantity_Provided"]
        CurrentStock = row["Current_Stock"]
        DivisionName = row["Division_Name"]
        ProductTypeCode = row["Product_Type_Code"]
        ProductTypeName = row["Product_Type_Name"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Chemist_Day_Visit_Id"]  = DCRChemistDayVisitId
        container["DCR_Id"]  = DCRId
        container["DCR_Code"]  = DCRCode
        container["Chemist_Visit_Id"]  = ChemistVisitId
        container["Chemist_Visit_Code"]  = ChemistVisitCode
        container["Product_Code"]  = ProductCode
        container["Product_Name"]  = ProductName
        container["Quantity_Provided"]  = QuantityProvided
    }
//        var persistentDictionary: [String : DatabaseValueConvertible?]
//        {
//        return[
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Product_Code" : ProductCode,
//            "Product_Name" : ProductName,
//            "Quantity_Provided" : QuantityProvided
//        ]
//    }
}

class DCRChemistDetailedProduct : Record
{
    var DCRChemistDetailId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var ProductCode : String!
    var ProductName : String!
    
    var UTC_DateTime: String?
    var Entered_TimeZone: String?
    var Entered_OffSet: String?
    var Created_DateTime: String?
    
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
       self.ProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sales_Product_Code")as? String)
        self.ProductName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sales_Product_Name")as? String)
        self.UTC_DateTime = getUTCDateForPunch()
        self.Entered_TimeZone = getcurrenttimezone()
        self.Entered_OffSet = getOffset()
        self.Created_DateTime = getCurrentDateAndTimeString()
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_DETAILED_PRODUCT
    }
    
    required init(row: Row)
    {
        DCRChemistDetailId = row["DCR_Chemist_Detail_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        ProductCode = row["Product_Code"]
        ProductName = row["Product_Name"]
        
        
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
       container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["Chemist_Visit_Id"] = ChemistVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["Product_Code"] = ProductCode
        container["Product_Name"] = ProductName
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return[
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Product_Code" : ProductCode,
//            "Product_Name" : ProductName
//
//        ]
//    }

}

class DCRChemistRCPAOwn : Record
{
    var DCRChemistRCPAOwnId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var ProductId : Int!
    var ProductCode : String!
    var ProductName : String!
    var Quantity : Float!
    var DoctorCode : String!
    var DoctorRegionCode: String!
    var DoctorName : String!
    var DoctorSpecialityName : String!
    var DoctorCategoryName : String!
    var DoctorMDLNumber: String!
    
    var UTC_DateTime: String?
    var Entered_TimeZone: String?
    var Entered_OffSet: String?
    var Created_DateTime: String?
    
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        self.ProductId = dict.value(forKey: "Chemist_RCPA_OWN_Product_Id") as? Int ?? 0
        self.ProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code")as? String)
        self.ProductName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name")as? String)
        self.Quantity = 0
        if let quantity = dict.value(forKey: "Qty") as? Int
        {
            self.Quantity = Float(quantity)
        }
        if let qty = dict.value(forKey: "Qty") as? Float
        {
           self.Quantity = qty 
        }
        self.DoctorCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code")as? String)
        self.DoctorRegionCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_RegionCode")as? String)
        self.DoctorName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name")as? String)
        self.DoctorSpecialityName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Speciality_Name")as? String)
        self.DoctorCategoryName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Category_Name")as? String)
        self.DoctorMDLNumber = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_MDLNumber")as? String)
        self.UTC_DateTime = getUTCDateForPunch()
        self.Entered_TimeZone = getcurrenttimezone()
        self.Entered_OffSet = getOffset()
        self.Created_DateTime = getCurrentDateAndTimeString()
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_RCPA_OWN
    }
    
    required init(row: Row)
    {
        DCRChemistRCPAOwnId = row["DCR_Chemist_RCPA_Own_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        ProductId = row["Own_Product_Id"]
        ProductCode = row["Product_Code"]
        ProductName = row["Product_Name"]
        Quantity = row["Quantity"]
        DoctorCode = row["Doctor_Code"]
        DoctorRegionCode = row["Doctor_Region_Code"]
        DoctorName = row["Doctor_Name"]
        DoctorSpecialityName = row["Doctor_Speciality_Name"]
        DoctorCategoryName = row["Doctor_Category_Name"]
        DoctorMDLNumber = row["Doctor_MDL_Number"]

        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
      
        container["DCR_Chemist_RCPA_Own_Id"] = DCRChemistRCPAOwnId
        container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["Chemist_Visit_Id"] = ChemistVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["Own_Product_Id"] = ProductId
        container["Product_Code"] = ProductCode
        container["Product_Name"] = ProductName
        container["Quantity"] = Quantity
        container["Doctor_Region_Code"] = DoctorRegionCode
        container["Doctor_Code"] = DoctorCode
        container["Doctor_Name"] = DoctorName
        container["Doctor_Speciality_Name"] = DoctorSpecialityName
        container["Doctor_Category_Name"] = DoctorCategoryName
        container["Doctor_MDL_Number"] = DoctorMDLNumber
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Chemist_RCPA_Own_Id": DCRChemistRCPAOwnId,
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Own_Product_Id" : ProductId,
//            "Product_Code" : ProductCode
//        ]
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Product_Name" : ProductName,
//            "Quantity" : Quantity,
//            "Doctor_Region_Code": DoctorRegionCode,
//            "Doctor_Code" : DoctorCode,
//            "Doctor_Name" : DoctorName,
//            "Doctor_Speciality_Name" : DoctorSpecialityName,
//            "Doctor_Category_Name" : DoctorCategoryName,
//            "Doctor_MDL_Number": DoctorMDLNumber
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class DCRChemistRCPACompetitor : Record
{
    var DCRChemistRCPACompetitorId : Int!
    var DCRChemistRCPAOwnId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var OwnProductCode : String!
    var CompetitorProductCode: String!
    var CompetitorProductName: String!
    var Quantity : Float!
    var UTC_DateTime: String?
    var Entered_TimeZone: String?
    var Entered_OffSet: String?
    var Created_DateTime: String?
    
    init(dict: NSDictionary)
    {
        self.DCRChemistRCPAOwnId = dict.value(forKey: "Chemist_RCPA_OWN_Product_Id") as? Int ?? 0
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        self.OwnProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Own_Product_Code") as? String)
        self.CompetitorProductCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Code") as? String)
        self.CompetitorProductName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Competitor_Product_Name") as? String)
        self.Quantity = 0
        if let quantity = dict.value(forKey: "Qty") as? Int
        {
            self.Quantity = Float(quantity)
        }
        if let qty = dict.value(forKey: "Qty") as? Float
        {
            self.Quantity = qty
        }
        self.UTC_DateTime = getUTCDateForPunch()
        self.Entered_TimeZone = getcurrenttimezone()
        self.Entered_OffSet = getOffset()
        self.Created_DateTime = getCurrentDateAndTimeString()
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_RCPA_COMPETITOR
    }
    
    required init(row: Row)
    {
        DCRChemistRCPACompetitorId = row["DCR_Chemist_RCPA_Competitor_Id"]
        DCRChemistRCPAOwnId = row["DCR_Chemist_RCPA_Own_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        OwnProductCode = row["Own_Product_Code"]
        CompetitorProductCode = row["Competitor_Product_Code"]
        CompetitorProductName = row["Competitor_Product_Name"]
        Quantity = row["Quantity"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
       container["DCR_Chemist_RCPA_Competitor_Id"] = DCRChemistRCPACompetitorId
        container["DCR_Chemist_RCPA_Own_Id"] = DCRChemistRCPAOwnId
        container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["Chemist_Visit_Id"] = ChemistVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["Own_Product_Code"] = OwnProductCode
        container["Competitor_Product_Code"] = CompetitorProductCode
        container["Competitor_Product_Name"] = CompetitorProductName
        container["Quantity"] = Quantity
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Chemist_RCPA_Competitor_Id": DCRChemistRCPACompetitorId,
//            "DCR_Chemist_RCPA_Own_Id": DCRChemistRCPAOwnId,
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode
//        ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Own_Product_Code" : OwnProductCode,
//            "Competitor_Product_Code" : CompetitorProductCode,
//            "Competitor_Product_Name" : CompetitorProductName,
//            "Quantity" : Quantity
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}

class DCRChemistAttachment : Record
{
    var DCRChemistAttachmentId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var DCRActualDate : Date!
    var BlobUrl : String!
    var UploadedFileName : String!
    var IsFileDownloaded : Int!
    var Is_Success: Int = 0
    
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        
        if let value = (dict.value(forKey: "DCR_Actual_Date")  as? String)
        {
            let dateArray =  value.components(separatedBy: " ")
            
            if(dateArray.count == 1)
            {
                self.DCRActualDate = getDateAndTimeInFormat(dateString: (dict.value(forKey: "DCR_Actual_Date") as? String)! + " 00:00:00.000")
            }
            else
            {
                self.DCRActualDate = getDateAndTimeInFormat(dateString: (dict.value(forKey: "DCR_Actual_Date") as? String)! + ".000")
            }
        }
        
        self.BlobUrl = checkNullAndNilValueForString(stringData: dict.value(forKey: "Blob_Url")as? String)
        self.UploadedFileName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Uploaded_File_Name")as? String)
        
        if let fileDownloaded = dict.value(forKey: "IsFile_Downloaded")
        {
            self.IsFileDownloaded = fileDownloaded as! Int
        }
        else
        {
            self.IsFileDownloaded = -1
        }
        
        self.Is_Success = -1
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_ATTACHMENT
    }
    
    required init(row: Row)
    {
        DCRChemistAttachmentId = row["DCR_Chemist_Attachment_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        DCRActualDate = row["DCR_Actual_Date"]
        BlobUrl = row["Blob_Url"]
        UploadedFileName = row["Uploaded_File_Name"]
        IsFileDownloaded = row["IsFile_Downloaded"]
        Is_Success = row["Is_Success"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["Chemist_Visit_Id"] = ChemistVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["DCR_Actual_Date"] = DCRActualDate
        container["Blob_Url"] = BlobUrl
        container["Uploaded_File_Name"] = UploadedFileName
        container["IsFile_Downloaded"] = IsFileDownloaded
        container["Is_Success"] = Is_Success
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode
//
//        ]
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "DCR_Actual_Date" : DCRActualDate,
//            "Blob_Url" : BlobUrl,
//            "Uploaded_File_Name" : UploadedFileName,
//            "IsFile_Downloaded": IsFileDownloaded,
//            "Is_Success": Is_Success
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }

}

class DCRChemistFollowup : Record
{
    var DCRChemistFollowupId : Int!
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var ChemistVisitId : Int!
    var ChemistVisitCode : String!
    var Task : String!
    var DueDate : Date!
   
    init(dict: NSDictionary)
    {
        self.DCRChemistDayVisitId = dict.value(forKey: "DCR_Chemist_Day_Visit_Id") as? Int ?? 0
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.ChemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int ?? 0
        let visitId =  dict.value(forKey: "CV_Visit_Id") as? Int ?? 0
        if visitId != 0
        {
            self.ChemistVisitCode = checkNullAndNilValueForString(stringData: String(visitId))
        }
        self.Task = checkNullAndNilValueForString(stringData: dict.value(forKey: "Tasks")as? String)
        self.DueDate = getDateAndTimeInFormat(dateString: (dict.value(forKey: "Due_Date")as? String)! + " 00:00:00.000")
        
        super.init()
        
    }
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_FOLLOWUP
    }
    
    required init(row: Row)
    {
        DCRChemistFollowupId = row["DCR_Chemist_Followup_Id"]
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        ChemistVisitId = row["Chemist_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        Task = row["Task"]
        DueDate = row["Due_Date"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
       
        container["DCR_Chemist_Day_Visit_Id"] = DCRChemistDayVisitId
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["Chemist_Visit_Id"] = ChemistVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["Task"] = Task
        container["Due_Date"] = DueDate
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//
//            "DCR_Chemist_Day_Visit_Id" : DCRChemistDayVisitId,
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "Chemist_Visit_Id" : ChemistVisitId
//        ]
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Task" : Task,
//            "Due_Date" : DueDate
//        ]
//        var combinedAttributes : NSMutableDictionary!
//
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
class ChemistDayVisit : Record
{
    var DCRChemistDayVisitId : Int!
    var DCRId : Int!
    var DCRCode : String!
    var CVVisitId : Int?
    var ChemistVisitCode : String!
    var ChemistCode : String!
    var RegionCode : String!
    var ChemistName : String!
    var RegionName : String!
    var CategoryCode : String!
    var CategoryName : String!
    var MDLNumber : String!
    var VisitMode : String!
    var VisitTime : String!
    var Remarks : String!
    var Latitude : Double!
    var Longitude : Double!
    
    init(dict: NSDictionary)
    {
        self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.DCRCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code")as? String)
        self.CVVisitId = dict.value(forKey: "Visit_Id") as? Int
        self.ChemistVisitCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Chemists_Code")as? String)
        self.ChemistCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemist_Code")as? String)
        self.RegionCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemists_Region_Code")as? String)
        self.ChemistName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemist_Name")as? String)
        self.RegionName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Name")as? String)
        self.CategoryCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code")as? String)
        self.CategoryName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name")as? String)
        self.MDLNumber = checkNullAndNilValueForString(stringData: dict.value(forKey: "Chemists_MDL_Number")as? String)
        self.VisitMode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Mode")as? String)
        self.VisitTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Time")as? String)
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks")as? String)
        self.Latitude = dict.value(forKey: "Chemists_Visit_latitude") as? Double ?? 0.0
        self.Longitude = dict.value(forKey: "Chemists_Visit_Longitude") as? Double ?? 0.0
        super.init()
        
    }
    override class var databaseTableName: String
    {
        return TRAN_DCR_CHEMIST_DAY_VISIT
    }
    required init(row: Row)
    {
        DCRChemistDayVisitId = row["DCR_Chemist_Day_Visit_Id"]
        DCRId = row["DCR_Id"]
        DCRCode = row["DCR_Code"]
        CVVisitId = row["CV_Visit_Id"]
        ChemistVisitCode = row["Chemist_Visit_Code"]
        ChemistCode = row["Chemist_Code"]
        RegionCode = row["Chemist_Region_Code"]
        ChemistName = row["Chemist_Name"]
        RegionName = row["Chemist_Region_Name"]
        CategoryCode = row["Category_Code"]
        CategoryName = row["Category_Name"]
        MDLNumber = row["MDL_Number"]
        VisitMode = row["Visit_Mode"]
        VisitTime = row["Visit_Time"]
        Remarks = row["Remarks"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Id"] = DCRId
        container["DCR_Code"] = DCRCode
        container["CV_Visit_Id"] = CVVisitId
        container["Chemist_Visit_Code"] = ChemistVisitCode
        container["Chemist_Code"] = ChemistCode
        container["Chemist_Region_Code"] = RegionCode
        container["Chemist_Name"] = ChemistName
        container["Chemist_Region_Name"] = RegionName
        container["Category_Code"] = CategoryCode
        container["Category_Name"] = CategoryName
        container["MDL_Number"] = MDLNumber
        container["Visit_Mode"] = VisitMode
        container["Visit_Time"] = VisitTime
        container["Remarks"] = Remarks
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DCR_Id" : DCRId,
//            "DCR_Code" : DCRCode,
//            "CV_Visit_Id" : CVVisitId,
//            "Chemist_Visit_Code" : ChemistVisitCode,
//            "Chemist_Code" : ChemistCode,
//            "Chemist_Region_Code" : RegionCode,
//            
//        ]
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Chemist_Name" : ChemistName,
//            "Chemist_Region_Name" : RegionName,
//            "Category_Code" : CategoryCode,
//            "Category_Name" : CategoryName,
//            "MDL_Number" : MDLNumber
//          
//        ]
//        let dict3: [String : DatabaseValueConvertible?] = [
//            "Visit_Mode" : VisitMode,
//            "Visit_Time" : VisitTime,
//            "Remarks" : Remarks,
//            "Latitude" : Latitude,
//            "Longitude" : Longitude,
//           
//        ]
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        
//        combinedAttributes.addEntries(from: dict2)
//        
//        combinedAttributes.addEntries(from: dict3)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }

}
