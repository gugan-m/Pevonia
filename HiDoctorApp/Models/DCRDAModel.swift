//
//  DCRDAModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDAModel: Record
{
    var id: Int!
    var dcrId: Int!
    var visitId: Int!
    var dcrVisitCode: String!
    var daCode: Int!
    var dcrDate: Date!
    var doctorCode: String!
    var doctorRegionCode: String!
    var totalPlayedTime: Int!
    var noOfParts: Int!
    var daName: String!
    var docType: Int!
    var noOfUniqueParts: Int!
    
    init(dict: NSDictionary)
    {
        self.dcrId = dict.value(forKey: "DCR_Id") as! Int
        self.visitId = dict.value(forKey: "DCR_Doctor_Visit_Id") as! Int
        
        if let visitCode = dict.value(forKey: "DCR_Visit_Code") as? String
        {
            self.dcrVisitCode = visitCode
        }
        else
        {
            self.dcrVisitCode = ""
        }
        
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        self.dcrDate = getStringInFormatDate(dateString: dict.value(forKey: "DCR_Date") as! String)
        self.doctorCode = dict.value(forKey: "Doctor_Code") as! String
        self.doctorRegionCode = dict.value(forKey: "Doctor_Region_Code") as! String        
        if let playedTime = dict.value(forKey: "Total_PlayedTime") as? Int
        {
            self.totalPlayedTime = playedTime
        }
        else
        {
            self.totalPlayedTime = 0
        }
        
        if let numberOfParts = dict.value(forKey: "NoOfParts") as? Int
        {
            self.noOfParts = numberOfParts
        }
        else
        {
            self.noOfParts = 0
        }
        
        if let name = dict.value(forKey: "DA_Name") as? String
        {
            self.daName = name
        }
        else
        {
            self.daName = ""
        }
        
        self.docType = dict.value(forKey: "Doc_Type") as! Int
        
        if let uniqueParts = dict.value(forKey: "NoOfUniqueParts") as? Int
        {
            self.noOfUniqueParts = uniqueParts
        }
        else
        {
            self.noOfUniqueParts = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DA_DATA
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        dcrId = row["DCR_Id"]
        visitId = row["DCR_Doctor_Visit_Id"]
        dcrVisitCode = row["DCR_Visit_Code"]
        daCode = row["DA_Code"]
        dcrDate = row["DCR_Date"]
        doctorCode = row["Doctor_Code"]
        doctorRegionCode = row["Doctor_Region_Code"]
        totalPlayedTime = row["Total_Played_Time"]
        noOfParts = row["No_Of_Parts_Viewed"]
        daName = row["DA_Name"]
        docType = row["Doc_Type"]
        noOfUniqueParts = row["NoOfUniqueParts"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["DCR_Id"] = dcrId
        container["DCR_Doctor_Visit_Id"] = visitId
        container["DCR_Visit_Code"] = dcrVisitCode
        container["DA_Code"] = daCode
        container["DCR_Date"] = dcrDate
        container["Doctor_Code"] = doctorCode
        container["Doctor_Region_Code"] = doctorRegionCode
        container["Total_Played_Time"] = totalPlayedTime
        container["No_Of_Parts_Viewed"] = noOfParts
        container["DA_Name"] = daName
        container["Doc_Type"] = docType
        container["NoOfUniqueParts"] = noOfUniqueParts
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Id": id,
//            "DCR_Id": dcrId,
//            "DCR_Doctor_Visit_Id": visitId,
//            "DCR_Visit_Code": dcrVisitCode,
//            "DA_Code": daCode,
//            "DCR_Date": dcrDate
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "Doctor_Code": doctorCode,
//            "Doctor_Region_Code": doctorRegionCode,
//            "Total_Played_Time": totalPlayedTime,
//            "No_Of_Parts_Viewed": noOfParts,
//            "DA_Name": daName,
//            "Doc_Type": docType,
//            "NoOfUniqueParts": noOfUniqueParts
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

class AssestProductMappingModel : Record
{
    var Asset_Product_Mapping_Id : Int!
    var DA_Code: Int!
    var Product_Code: String!
    var Updated_DateTime: Date!
    var Active_Status: Int?
    var Product_Name: String?
    
    init(dict: NSDictionary)
    {
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Updated_DateTime = getCurrentDateAndTime()
        self.Active_Status = dict.value(forKey: "Active_Status") as? Int ?? 0
                super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_ED_ASSET_PRODUCT_MAPPING
    }
    
    required init(row: Row)
    {
        Asset_Product_Mapping_Id = row["Asset_Product_Mapping_Id"]
        DA_Code = row["DA_Code"]
        Product_Code = row["Product_Code"]
        Updated_DateTime = row["Updated_DateTime"]
        Active_Status = row["Active_Status"]
        Product_Name = row["Product_Name"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Asset_Product_Mapping_Id"] = Asset_Product_Mapping_Id
        container["DA_Code"] = DA_Code
        container["Product_Code"] = Product_Code
        container["Updated_DateTime"] = Updated_DateTime
        container["Active_Status"] = Active_Status
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Asset_Product_Mapping_Id": Asset_Product_Mapping_Id,
//            "DA_Code": DA_Code,
//            "Product_Code": Product_Code,
//            "Updated_DateTime": Updated_DateTime,
//            "Active_Status": Active_Status
//
//        ]
//        return dict
//    }
}

class MCDoctorProductMappingModel : Record
{
    var MC_Doctor_Product_Mapping_Id : Int!
    var MC_Code: String!
    var MC_Name: String!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var Product_Code: String!
    var Product_Name: String!
    var Brand_Name: String!
    var Priority_Order: Int!
    var Effective_From: Date!
    var Effective_To: Date!
    var Ref_Type: String!
    
    init(dict: NSDictionary)
    {
        self.MC_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Code") as? String)
        self.MC_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Name") as? String)
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Customer_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Region_Code") as? String)
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Brand_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Brand_Name") as? String)
        self.Priority_Order = productDefaultPriorityOrder
        
        if let priorityOrder = dict.value(forKey: "Priority_Order") as? Int
        {
            if (priorityOrder > 0)
            {
                self.Priority_Order = priorityOrder
            }
        }
        
        let effective_From_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_From") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.Effective_From = getDateStringInFormatDate(dateString: effective_From_Date, dateFormat: defaultServerDateFormat)
        }
        
        let effective_To_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_To") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.Effective_To = getDateStringInFormatDate(dateString: effective_To_Date, dateFormat: defaultServerDateFormat)
        }
        
        self.Ref_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Ref_Type") as? String)
       
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_DOCTOR_PRODUCT_MAPPING
    }
    
    required init(row: Row)
    {
        MC_Doctor_Product_Mapping_Id = row["MC_Doctor_Product_Mapping_Id"]
        MC_Code = row["MC_Code"]
        MC_Name = row["MC_Name"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Brand_Name = row["Brand_Name"]
        Priority_Order = row["Priority_Order"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        Ref_Type = row["Ref_Type"]

        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["MC_Doctor_Product_Mapping_Id"] = MC_Doctor_Product_Mapping_Id
        container["MC_Code"] = MC_Code
        container["MC_Name"] = MC_Name
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Product_Code"] = Product_Code
        container["Product_Name"] = Product_Name
        container["Brand_Name"] = Brand_Name
        container["Priority_Order"] = Priority_Order
        container["Effective_From"] = Effective_From
        container["Effective_To"] = Effective_To
        container["Ref_Type"] = Ref_Type
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "MC_Doctor_Product_Mapping_Id": MC_Doctor_Product_Mapping_Id,
//            "MC_Code": MC_Code,
//            "MC_Name": MC_Name,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code
//        ]
//
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name,
//            "Brand_Name": Brand_Name,
//            "Priority_Order": Priority_Order,
//            "Effective_From": Effective_From,
//            "Effective_To": Effective_To
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
class DayWiseAssestsDetailedModel : Record
{
    var Asset_Detailed_Id : Int!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var DCR_Actual_Date: Date!
    var DA_Code: Int!
    var Product_Code: String!
    var Product_Name: String!
    var Active_Status: Int!
    
    init(dict: NSDictionary)
    {
        self.Customer_Code = dict.value(forKey: "Customer_Code") as! String
        self.Customer_Region_Code = dict.value(forKey: "Customer_Region_Code") as! String
        self.DCR_Actual_Date = getDateFromString(dateString: dict.value(forKey: "DCR_Actual_Date") as! String)
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Product_Code = dict.value(forKey: "Product_Code") as! String
        self.Product_Name = dict.value(forKey: "Product_Name") as! String
        self.Active_Status = dict.value(forKey: "Active_Status") as! Int
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DAY_WISE_ASSETS_DETAILED
    }
    
    required init(row: Row)
    {
        Asset_Detailed_Id = row["Asset_Detailed_Id"]
        Customer_Code = row["Customer_Code"]
        DA_Code = row["DA_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Active_Status = row["Active_Status"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Asset_Detailed_Id"] = Asset_Detailed_Id
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["DA_Code"] = DA_Code
        container["Product_Code"] = Product_Code
        container["Product_Name"] = Product_Name
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Active_Status"] = Active_Status
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Asset_Detailed_Id": Asset_Detailed_Id,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code,
//            "DA_Code": DA_Code,
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name,
//            "DCR_Actual_Date": DCR_Actual_Date,
//            "Active_Status": Active_Status
//        ]
//        return dict
//    }
}

class DoctorProductMappingModel : Record
{
    
    var Doctor_Product_Mapping_Id : Int!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var Product_Code: String!
    var Product_Name: String!
    var Brand_Name: String!
    var Priority_Order: Int!
    var Customer_Name: String!
    var Customer_Status: String!
    var MDL_Number: String!
    var Potential_Quantity: String!
    var Support_Quantity: String!
    var Ref_Type: String!
    var Created_By: String!
    var Mapped_Region_Code: String!
    var Selected_Region_Code: String!
    var MC_Code: String!
    var MC_Name: String!
    var MC_Effective_From: Date!
    var MC_Effective_To: Date!
    
    
    
    init(dict: NSDictionary)
    {
        
        if let customerCode = dict.value(forKey: "Doctor_Code") as? String
        {
            self.Customer_Code = customerCode
        }
        else
        {
            self.Customer_Code = dict.value(forKey: "Customer_Code") as? String
        }
        if let customerRegionCode = dict.value(forKey: "Doctor_Region_Code") as? String
        {
           self.Customer_Region_Code = customerRegionCode
        }
        else
        {
           self.Customer_Region_Code = dict.value(forKey: "Customer_Region_Code") as? String
        }
        self.Product_Code = dict.value(forKey: "Product_Code") as! String
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Brand_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Brand_Name") as? String)
        self.Priority_Order = productDefaultPriorityOrder
        
        if let priorityOrder = dict.value(forKey: "Product_Priority_No") as? Int
        {
            if (priorityOrder > 0)
            {
                self.Priority_Order = priorityOrder
            }
        }
        self.Customer_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name") as? String)
        self.Customer_Status = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Status") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Potential_Quantity = checkNullAndNilValueForString(stringData: dict.value(forKey: "Potential_Quantity") as? String)
        self.Support_Quantity = checkNullAndNilValueForString(stringData: dict.value(forKey: "Support_Quantity") as? String)
        self.Ref_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Ref_Type") as? String)
        self.Created_By = checkNullAndNilValueForString(stringData: dict.value(forKey: "Created_By") as? String)
        self.Mapped_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Mapped_Region_Code") as? String)
        self.Selected_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Selected_Region_Code") as? String)
        self.MC_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Code") as? String)
        self.MC_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Name") as? String)
        let effective_From_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Effective_From") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.MC_Effective_From = getDateStringInFormatDate(dateString: effective_From_Date, dateFormat: defaultServerDateFormat)
        }
        
        let effective_To_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Effective_To") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.MC_Effective_To = getDateStringInFormatDate(dateString: effective_To_Date, dateFormat: defaultServerDateFormat)
        }
        

        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DOCTOR_PRODUCT_MAPPING
    }
    
    required init(row: Row)
    {
        Doctor_Product_Mapping_Id = row["Doctor_Product_Mapping_Id"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Brand_Name = row["Brand_Name"]
        Priority_Order = row["Priority_Order"]
        Customer_Name = row["Customer_Name"]
        Customer_Status = row["Customer_Status"]
        MDL_Number = row["MDL_Number"]
        Potential_Quantity = row["Potential_Quantity"]
        Support_Quantity = row["Support_Quantity"]
        Ref_Type = row["Ref_Type"]
        Created_By = row["Created_By"]
        Mapped_Region_Code = row["Mapped_Region_Code"]
        Selected_Region_Code = row["Selected_Region_Code"]
        MC_Code = row["MC_Code"]
        MC_Name = row["MC_Name"]
        MC_Effective_From = row["MC_Effective_From"]
        MC_Effective_To = row["MC_Effective_To"]

        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Doctor_Product_Mapping_Id"] = Doctor_Product_Mapping_Id
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Product_Code"] = Product_Code
        container["Product_Name"] = Product_Name
        container["Brand_Name"] = Brand_Name
        container["Priority_Order"] = Priority_Order
        container["Customer_Name"] = Customer_Name
        container["Customer_Status"] = Customer_Status
        container["MDL_Number"] = MDL_Number
        container["Potential_Quantity"] = Potential_Quantity
        container["Support_Quantity"] = Support_Quantity
        container["Ref_Type"] = Ref_Type
        container["Created_By"] = Created_By
        container["Mapped_Region_Code"] = Mapped_Region_Code
        container["Selected_Region_Code"] = Selected_Region_Code
        container["MC_Code"] = MC_Code
        container["MC_Name"] = MC_Name
        container["MC_Effective_From"] = MC_Effective_From
        container["MC_Effective_To"] = MC_Effective_To
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Doctor_Product_Mapping_Id": Doctor_Product_Mapping_Id,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code,
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name,
//            "Brand_Name": Brand_Name,
//            "Priority_Order": Priority_Order
//        ]
//        return dict
//    }
}

class EDetailDoctorLocationInfoModel : Record
{
    var Doctor_Location_Id : Int!
    var Customer_Code: String!
    var Customer_Region_Code: String!
    var DCR_Actual_Date: Date!
    var Latitude: Double = 0.0
    var Longitude: Double = 0.0
    var Geo_Fencing_Deviation_Remarks: String!
    var Synced_Date_Time: String!
    
    init(dict: NSDictionary)
    {
        self.Customer_Code = dict.value(forKey: "Customer_Code") as! String
        self.Customer_Region_Code = dict.value(forKey: "Customer_Region_Code") as! String
        self.DCR_Actual_Date = getDateFromString(dateString: dict.value(forKey: "DCR_Actual_Date") as! String)
        self.Latitude = dict.value(forKey: "Latitude") as? Double ?? 0.0
        self.Longitude = dict.value(forKey: "Longitude") as? Double ?? 0.0
        self.Geo_Fencing_Deviation_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Geo_Fencing_Deviation_Remarks") as? String)
        self.Synced_Date_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Synced_Date_Time") as? String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_ED_DOCTOR_LOCATION_INFO
    }
    
    required init(row: Row)
    {
        Doctor_Location_Id = row["Doctor_Location_Id"]
        Customer_Code = row["Customer_Code"]
        Customer_Region_Code = row["Customer_Region_Code"]
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Geo_Fencing_Deviation_Remarks = row["Geo_Fencing_Deviation_Remarks"]
        Synced_Date_Time = row["Synced_Date_Time"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Doctor_Location_Id"] = Doctor_Location_Id
        container["Customer_Code"] = Customer_Code
        container["Customer_Region_Code"] = Customer_Region_Code
        container["DCR_Actual_Date"] = DCR_Actual_Date
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["Geo_Fencing_Deviation_Remarks"] = Geo_Fencing_Deviation_Remarks
        container["Synced_Date_Time"] = Synced_Date_Time
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Doctor_Location_Id": Doctor_Location_Id,
//            "Customer_Code": Customer_Code,
//            "Customer_Region_Code": Customer_Region_Code,
//            "DCR_Actual_Date": DCR_Actual_Date,
//            "Latitude": Latitude,
//            "Longitude": Longitude
//        ]
//        return dict
//    }
}

class SFCPrefillModel
{
    var From_Place: String!
    var To_Place: String!
}

class MCAllDetailsModel : Record
{
    var MC_Id : Int!
    var Campaign_Code: String!
    var Ref_Code: String!
    var Ref_Type: String!
    var Campaign_Name: String?
    
    init(dict: NSDictionary)
    {
        self.Campaign_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Campaign_Code") as? String)
        self.Ref_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Ref_Code") as? String)
        self.Ref_Type = checkNullAndNilValueForString(stringData:dict.value(forKey: "Ref_Type") as? String)
        self.Campaign_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "Campaign_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_DETAILS
    }
    
    required init(row: Row)
    {
        MC_Id = row["MC_Id"]
        Campaign_Code = row["Campaign_Code"]
        Ref_Code = row["Ref_Code"]
        Ref_Type = row["Ref_Type"]
        Campaign_Name = row["Campaign_Name"]
        
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["MC_Id"] = MC_Id
        container["Campaign_Code"] = Campaign_Code
        container["Ref_Code"] = Ref_Code
        container["Ref_Type"] = Ref_Type
    }
}

class DivisionMappingDetails : Record
{
    var Division_Id : Int!
    var Entity_Code: String!
    var Division_Code: String!
    var Ref_Type: String!
    
    init(dict: NSDictionary)
    {
        self.Entity_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Entity_Code") as? String)
        self.Division_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Division_Code") as? String)
        self.Ref_Type = checkNullAndNilValueForString(stringData:dict.value(forKey: "Ref_Type") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DIVISION_MAPPING_DETAILS
    }
    
    required init(row: Row)
    {
        Entity_Code = row["Entity_Code"]
        Division_Code = row["Division_Code"]
        Ref_Type = row["Ref_Type"]
        
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Entity_Code"] = Entity_Code
        container["Division_Code"] = Division_Code
        container["Ref_Type"] = Ref_Type
    }
}
