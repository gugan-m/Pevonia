//
//  DetailProductMaster.swift
//  HiDoctorApp
//
//  Created by SwaaS on 04/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DetailProductMaster: Record
{
    var Detail_Product_Id: Int!
    var Product_Code: String!
    var Product_Name: String!
    var Speciality_Code: String!
    //var Division_Name: String!
    var Unit_Rate: Double!
    var Region_Code: String!
    var Price_Group_Code: String!
    var objWrapper: DCRDetailedProductsWrapperModel!
    var stepperDisplayData: String = EMPTY
    var detailedCompetitorReportList :[DCRCompetitorDetailsModel] = []
    var Product_Type_Name: String!
    var Effective_From: Date!
    var Effective_To: Date!
    var isViewEnable: Bool = false //DPM
    var noOfPrescription: String = EMPTY //DPM
    var potentialPrescription: String =  EMPTY //DPM
    var priorityOrder: Int = 0
    
    
    init(dict: NSDictionary)
    {
        self.Detail_Product_Id = dict.value(forKey: "Detail_Product_Id") as? Int ?? 0
        self.Product_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Code") as? String)
        self.Product_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        //self.Division_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_To") as? String)
        self.Unit_Rate = dict.value(forKey: "Unit_Rate") as! Double!
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Price_Group_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Price_Group_Code") as? String)
        
         self.Product_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Type_Name") as? String)
        
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

        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_DETAIL_PRODUCTS
    }
    
    required init(row: Row)
    {
        Detail_Product_Id = row["Detail_Product_Id"]
        Product_Code = row["Product_Code"]
        Product_Name = row["Product_Name"]
        Speciality_Code = row["Speciality_Code"]
        //Division_Name = row["Division_Name"]
        Unit_Rate = row["Unit_Rate"]
        Region_Code = row["Region_Code"]
        Price_Group_Code = row["Price_Group_Code"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        Product_Type_Name = row["Product_Type_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Detail_Product_Id"] =  Detail_Product_Id
        container["Product_Code"] =  Product_Code
        container["Product_Name"] =  Product_Name
        container["Speciality_Code"] =  Speciality_Code
        container["Unit_Rate"] =  Unit_Rate
        container["Region_Code"] =  Region_Code
        container["Price_Group_Code"] =  Price_Group_Code
        container["Effective_From"] = Effective_From
        container["Effective_To"] = Effective_To
        container["Product_Type_Name"] = Product_Type_Name
        //"Division_Name"] =  Division_Name
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Detail_Product_Id": Detail_Product_Id,
//            "Product_Code": Product_Code,
//            "Product_Name": Product_Name,
//            "Speciality_Code": Speciality_Code,
//            "Unit_Rate": Unit_Rate,
//            "Region_Code": Region_Code,
//            "Price_Group_Code": Price_Group_Code
//            //"Division_Name": Division_Name
//        ]
 //   }
}

class DCRDetailedProductsWrapperModel
{
    var objBusinessStatus: BusinessStatusModel?
    var objBusinessStatusEdit: BusinessStatusModel?
    var remarks: String!
    var businessPotential: String = defaultBusinessPotential
}

class DetailProductMasterSectionModel
{
    var lstDetailedProducs: [DetailProductMaster] = []
    var Section_Title: String!
}
