//
//  BL_DetailedProducts.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DetailedProducts: NSObject
{
    static let sharedInstance : BL_DetailedProducts = BL_DetailedProducts()
    
    class func getMasterDetailedProducts(productTypeName: String, date: String) -> [DetailProductMaster]
    {
        let masterDetailedList =  DBHelper.sharedInstance.getDetailedProducts(productTypeName: productTypeName, date: date,regionCode:getRegionCode())
        var resultList: [DetailProductMaster] = []
        
        for objDetailedProduct in masterDetailedList
        {
            let filteredArray = resultList.filter{
                $0.Product_Code == objDetailedProduct.Product_Code
            }
            
            if (filteredArray.count == 0)
            {
                resultList.append(objDetailedProduct)
            }
        }
        
        return resultList
    }
    
    class func getMasterDetailedProductsPOB(productTypeName:String,date:String) -> [DetailProductMasterSectionModel]
    {
        let masterDetailedList =  DBHelper.sharedInstance.getDetailedProductsPOB(productTypeName:productTypeName,date:date)
        var resultList: [DetailProductMasterSectionModel] = []
        var lstProducts: [DetailProductMaster] = []
        
        for objDetailedProduct in masterDetailedList
        {
            let filteredArray = lstProducts.filter{
                $0.Product_Code == objDetailedProduct.Product_Code
            }
            
            if (filteredArray.count == 0)
            {
                lstProducts.append(objDetailedProduct)
            }
        }
        
        let objProductSectionModel = DetailProductMasterSectionModel()
        objProductSectionModel.Section_Title = ""
        objProductSectionModel.lstDetailedProducs = lstProducts
        resultList.append(objProductSectionModel)
        
        return resultList
    }
    
    func getMasterDetailedProducts(productTypeName: String, date: String) -> [DetailProductMasterSectionModel]
    {
        let masterList = BL_DetailedProducts.getMasterDetailedProducts(productTypeName: productTypeName, date: date)
        var resultList: [DetailProductMasterSectionModel] = []
        var objProductSectionModel: DetailProductMasterSectionModel = DetailProductMasterSectionModel()
        
        objProductSectionModel = DetailProductMasterSectionModel()
        objProductSectionModel.Section_Title = ""
        objProductSectionModel.lstDetailedProducs = masterList
        resultList.append(objProductSectionModel)
        
        return resultList
    }
    
    func getMasterDetailedProductsWithGroupBy(customerCode: String, regionCode: String, dcrActualDate: String) -> [DetailProductMasterSectionModel]
    {
        let marketingCampaignProducts = DBHelper.sharedInstance.getMCDoctorProductMapping(customerCode: customerCode, regionCode: regionCode, date: dcrActualDate, refType: Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign)
        let targetProducts = DBHelper.sharedInstance.getTargetProductMapping(customerCode: customerCode, regionCode: regionCode, refType: Constants.Doctor_Product_Mapping_Ref_Types.TARGET_MAPPING)
        let doctorProducts = DBHelper.sharedInstance.getTargetProductMapping(customerCode: customerCode, regionCode: regionCode, refType: Constants.Doctor_Product_Mapping_Ref_Types.GENERAL)
        let masterList = BL_DetailedProducts.getMasterDetailedProducts(productTypeName: "ACTIVITY", date: dcrActualDate)
        
        var mcList: [DetailProductMaster] = []
        var targetList: [DetailProductMaster] = []
        var docorProductMappingList: [DetailProductMaster] = []
        var nonMappingList: [DetailProductMaster] = []
        var resultList: [DetailProductMasterSectionModel] = []
        
        for objMaster in masterList
        {
            let objWrapper: DCRDetailedProductsWrapperModel = DCRDetailedProductsWrapperModel()
            
            objWrapper.objBusinessStatus = nil
            objWrapper.businessPotential = EMPTY
            objWrapper.remarks = EMPTY
            
            objMaster.objWrapper = objWrapper
            
            let mcFilteredArray = marketingCampaignProducts.filter{
                $0.Product_Code == objMaster.Product_Code
            }
            
            if (mcFilteredArray.count > 0)
            {
                mcList.append(objMaster)
            }
            else
            {
                let targetFilterArray = targetProducts.filter{
                    $0.Product_Code == objMaster.Product_Code
                }
                
                if (targetFilterArray.count > 0)
                {
                    targetList.append(objMaster)
                }
                else
                {
                    let doctorProdcutFilterArray = doctorProducts.filter{
                        $0.Product_Code == objMaster.Product_Code
                    }
                    
                    if (doctorProdcutFilterArray.count > 0)
                    {
                        docorProductMappingList.append(objMaster)
                    }
                    else
                    {
                        nonMappingList.append(objMaster)
                    }
                }
            }
        }
        
        var objProductSectionModel: DetailProductMasterSectionModel = DetailProductMasterSectionModel()
        
        if (mcList.count > 0)
        {
            objProductSectionModel = DetailProductMasterSectionModel()
            objProductSectionModel.Section_Title = "Marketing Campaign Products"
            objProductSectionModel.lstDetailedProducs = mcList
            resultList.append(objProductSectionModel)
        }
        
        if (targetList.count > 0)
        {
            objProductSectionModel = DetailProductMasterSectionModel()
            objProductSectionModel.Section_Title = "Target Products"
            objProductSectionModel.lstDetailedProducs = targetList
            resultList.append(objProductSectionModel)
        }
        
        if (docorProductMappingList.count > 0)
        {
            objProductSectionModel = DetailProductMasterSectionModel()
            objProductSectionModel.Section_Title = "\(appDoctor) Product Mapping"
            objProductSectionModel.lstDetailedProducs = docorProductMappingList
            resultList.append(objProductSectionModel)
        }
        
        if (nonMappingList.count > 0)
        {
            objProductSectionModel = DetailProductMasterSectionModel()
            objProductSectionModel.Section_Title = "Other Products"
            objProductSectionModel.lstDetailedProducs = nonMappingList
            resultList.append(objProductSectionModel)
        }
        
        return resultList
    }
    
    func insertDetailedProducts(detailedProductList : [DetailProductMaster], doctorVisitId: Int)
    {
        let dcrDetailedProductList = convertToDCRDetailedProductsModel(detailedProductList: detailedProductList, doctorVisitId: doctorVisitId)
        DBHelper.sharedInstance.insertDetailedProducts(dcrDetailedProducts: dcrDetailedProductList)
    }
    
    func updateDetailedProducts(detailedProductList : [DetailProductMaster], doctorVisitId: Int)
    {
        let dcrDetailedProductList = convertToDCRDetailedProductsModel(detailedProductList: detailedProductList, doctorVisitId: doctorVisitId)
        let savedDetailedProducts = DBHelper.sharedInstance.getDCRDetailedProducts(dcrId: getDcrId(), doctorVisitId: doctorVisitId)
        let doctorVisitObj = DBHelper.sharedInstance.getDoctorVisitDetailByDoctorVisitId(doctorVisitId: doctorVisitId)
        
        for objDetailedProduct in savedDetailedProducts
        {
            let filteredArray = detailedProductList.filter{
                $0.Product_Code == objDetailedProduct.Product_Code
            }
            
            if (filteredArray.count == 0) // Means deleted the already entered product now.
            {
                if (doctorVisitObj != nil)
                {
                    DBHelper.sharedInstance.updateDayWiseDetailedProductStatus(dcrDate: getDCRDate(), customerCode: checkNullAndNilValueForString(stringData: doctorVisitObj?.Doctor_Code), customerRegionCode: checkNullAndNilValueForString(stringData: doctorVisitObj?.Doctor_Region_Code), productCode: objDetailedProduct.Product_Code, status: 0)
                }
                
                DBHelper.sharedInstance.deleteDCRCompetitorProducts(doctorVisitId: doctorVisitId, productCode: objDetailedProduct.Product_Code)
            }
        }
        
        DBHelper.sharedInstance.deleteDCRDetailedProducts(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId())
        DBHelper.sharedInstance.insertDetailedProducts(dcrDetailedProducts: dcrDetailedProductList)
    }
    
    func convertToDCRDetailedProductsModel(detailedProductList : [DetailProductMaster], doctorVisitId: Int) -> [DCRDetailedProductsModel]
    {
        var detailedDCRProductsList : [DCRDetailedProductsModel] = []
        
        for detailedProductObj in detailedProductList
        {
            var potential: Float = 0
            
            if (checkNullAndNilValueForString(stringData: detailedProductObj.objWrapper.businessPotential) != EMPTY)
            {
                potential = Float(detailedProductObj.objWrapper.businessPotential)!
            }
            else
            {
                potential = Float(defaultBusinessPotential)!
            }
            
            let dict: NSMutableDictionary = ["DCR_Id": getDcrId(), "DCR_Code": getDcrCode(), "Visit_Id": doctorVisitId, "Product_Id":detailedProductObj.Detail_Product_Id, "Product_Code": detailedProductObj.Product_Code, "Product_Name": detailedProductObj.Product_Name, "Business_Status_Remarks": detailedProductObj.objWrapper.remarks, "BusinessPotential": potential]
            
            if let objStatus = detailedProductObj.objWrapper.objBusinessStatus
            {
                let statusDict: NSDictionary = ["Business_Status_ID": objStatus.Business_Status_ID!, "Status_Name": objStatus.Status_Name, "Status": 1]
                dict.addEntries(from: statusDict as! [AnyHashable : Any])
            }
            
            let detailedDict : DCRDetailedProductsModel = DCRDetailedProductsModel(dict: dict)
            
            detailedDCRProductsList.append(detailedDict)
        }
        
        return detailedDCRProductsList
    }
    
    func getDCRDetailedProducts(dcrId: Int, doctorVisitId: Int) -> [DetailProductMaster]
    {
        var dcrSelectedList : [DetailProductMaster] = []
        let dcrDetailedList =  DBHelper.sharedInstance.getDCRDetailedProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
        dcrSelectedList = convertToDetailedProductsModel(detailedProductList:dcrDetailedList)
        return dcrSelectedList
    }
    
    func getChemistDetailedProducts() -> [DetailProductMaster]
    {
        var chemistSelectedList : [DetailProductMaster] = []
        let chemistDetailedList =  DBHelper.sharedInstance.getDCRChemistSelectedDetailedProductList(dcrId: getDcrId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        chemistSelectedList = convertDCRChemistDetailedProductToDetailedProductsModel(detailedProductList : chemistDetailedList)
        return chemistSelectedList

    }
    
    func convertToDetailedProductsModel(detailedProductList : [DCRDetailedProductsModel]) -> [DetailProductMaster]
    {
        var detailedProductsList : [DetailProductMaster] = []
        
        for detailedProductObj in detailedProductList
        {
            let objWrapper: DCRDetailedProductsWrapperModel = DCRDetailedProductsWrapperModel()
            objWrapper.businessPotential = String(detailedProductObj.Business_Potential)
            objWrapper.remarks = detailedProductObj.Remarks
            objWrapper.objBusinessStatus = nil
            objWrapper.objBusinessStatusEdit = nil
            
            if (detailedProductObj.Business_Status_ID != nil && detailedProductObj.Business_Status_ID != defaultBusineessStatusId)
            {
                let dict: NSDictionary = ["Business_Status_Id": detailedProductObj.Business_Status_ID, "Status_Name": detailedProductObj.Business_Status_Name, "Entity_Type_Description": "PRODUCT", "Entity_Type": Constants.Business_Status_Page__Ids.Detailed_Products]
                let objBusinessStatus: BusinessStatusModel = BusinessStatusModel(dict: dict)
                objWrapper.objBusinessStatus = objBusinessStatus
                
                let objBusinessStatusEdit: BusinessStatusModel = BusinessStatusModel(dict: dict)
                objWrapper.objBusinessStatusEdit = objBusinessStatusEdit
            }
            
            let dict: NSDictionary = ["Detail_Product_Id": detailedProductObj.Product_Id, "Product_Code": detailedProductObj.Product_Code, "Product_Name": detailedProductObj.Product_Name, "Speciality_Code": ""]
            let detailedDict : DetailProductMaster = DetailProductMaster(dict: dict)
            detailedDict.objWrapper = objWrapper
            detailedProductsList.append(detailedDict)
        }
        
        return detailedProductsList
    }
    
    func convertDCRChemistDetailedProductToDetailedProductsModel(detailedProductList : [DCRChemistDetailedProduct]) -> [DetailProductMaster]
    {
        var detailedProductsList : [DetailProductMaster] = []
        for detailedProductObj in detailedProductList
        {
            let dict: NSDictionary = ["Detail_Product_Id": "", "Product_Code": detailedProductObj.ProductCode, "Product_Name": detailedProductObj.ProductName, "Speciality_Code": ""]
            let detailedDict : DetailProductMaster = DetailProductMaster(dict: dict)
            detailedProductsList.append(detailedDict)
        }
        
        return detailedProductsList
    }

    func convertPOBsalesIntoDetailedProductMaster(pobDetailedList: [DCRDoctorVisitPOBDetailsModel]) -> [DetailProductMaster]?
    {
        var detailedProductList: [DetailProductMaster] = []
        for obj in pobDetailedList
        {
            let dict:[String : Any] = ["Product_Code": obj.Product_Code,"Product_Name": obj.Product_Name,"Unit_Rate": obj.Product_Unit_Rate]
            
            let detailedObj: DetailProductMaster = DetailProductMaster(dict: dict as NSDictionary)
            detailedProductList.append(detailedObj)
        }
        
        return detailedProductList
    }
    
    func convertRCPAOwnToDetailedProductMaster(rcpaList:[DCRChemistRCPAOwn]) -> [DetailProductMaster]?
    {
        var detailedProductList: [DetailProductMaster] = []
        for obj in rcpaList
        {
            let dict:[String : Any] = ["Product_Code": obj.ProductCode,"Product_Name": obj.ProductName]
            
            let detailedObj: DetailProductMaster = DetailProductMaster(dict: dict as NSDictionary)
            detailedProductList.append(detailedObj)
        }
        
        return detailedProductList
    }

    func convertToPOBSales(list : [DetailProductMaster]) -> [DCRDoctorVisitPOBDetailsModel]
    {
        var selectedProductList : [DCRDoctorVisitPOBDetailsModel] = []
        if list.count > 0
        {
            for obj in list
            {
                let dict :[String:Any] = ["Product_Code":obj.Product_Code,"Product_Name":obj.Product_Name,"Product_Unit_Rate":obj.Unit_Rate]
                let pobDetailsObj = DCRDoctorVisitPOBDetailsModel(dict: dict as NSDictionary)
                selectedProductList.append(pobDetailsObj)
            }
        }
        return selectedProductList
    }
    
    func convertToDCRChemistDetailedProducts(selectedList : [DetailProductMaster]) -> [[String:Any]]
    {
        var chemistDetailedList:[[String:Any]] = []
        if selectedList.count > 0
        {
            for obj in selectedList
            {
                let dict :[String:Any] = ["DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Chemist_Day_Visit_Id":ChemistDay.sharedInstance.chemistVisitId,"Chemist_Visit_Code":"","Sales_Product_Name":obj.Product_Name,"Sales_Product_Code":obj.Product_Code,"Chemist_User_Code":ChemistDay.sharedInstance.customerCode,"Chemist_Region_Code":ChemistDay.sharedInstance.regionCode,"DCR_Code":DCRModel.sharedInstance.dcrCode]
                chemistDetailedList.append(dict)
            }
        }
        return chemistDetailedList
    }
    
    func updateChemistDetailedProducts(detailedProductList : [DetailProductMaster], chemistVisitId: Int)
    {
        let dcrDetailedProductList = convertToDCRChemistDetailedProducts(selectedList: detailedProductList)
        let savedDetailedProducts = DBHelper.sharedInstance.getDCRChemistSelectedDetailedProductList(dcrId: getDcrId(), chemistVisitId: chemistVisitId)
        let chemistVisitObj = DBHelper.sharedInstance.getChemistVisitDetailByChemistVisitId(chemistVisitId : chemistVisitId)
        
        for objDetailedProduct in savedDetailedProducts
        {
            let filteredArray = detailedProductList.filter{
                $0.Product_Code == objDetailedProduct.ProductCode
            }
            
            if (filteredArray.count == 0) // Means deleted the already entered product now.
            {
                if (chemistVisitObj != nil)
                {
                    DBHelper.sharedInstance.updateDayWiseDetailedProductStatus(dcrDate: getDCRDate(), customerCode: checkNullAndNilValueForString(stringData: chemistVisitObj?.ChemistCode), customerRegionCode: checkNullAndNilValueForString(stringData: chemistVisitObj?.RegionCode), productCode: objDetailedProduct.ProductCode, status: 0)
                }
            }
        }
        
        DBHelper.sharedInstance.deleteDCRChemistDetailedProducts(dcrId: getDcrId(), chemistVisitId: chemistVisitId)
        DBHelper.sharedInstance.insertDCRDoctorVisitChemistDetailedProductDetails(array: dcrDetailedProductList as NSArray)
    }
    
    func getChemistDayRCPAProducts(doctorCode:String,doctorRegionCode: String,doctorname: String,docSpeciality: String) -> [DetailProductMaster]
    {
        var chemistSelectedList : [DetailProductMaster] = []
        var rcpaProductList:[DCRChemistRCPAOwn] = []
        
        if doctorCode != EMPTY
        {
            rcpaProductList = DBHelper.sharedInstance.getRCPADetailedProduct(dcrId: getDcrId(),chemistVisitId: ChemistDay.sharedInstance.chemistVisitId,doctorCode: doctorCode,regionCode: doctorRegionCode)
        }
        else
        {
            rcpaProductList = DBHelper.sharedInstance.getRCPADetailedProductForFlexiDoctor(dcrId: getDcrId(),chemistVisitId: ChemistDay.sharedInstance.chemistVisitId,doctorname: doctorname,docSpeciality: docSpeciality)
        }
        if rcpaProductList.count > 0
        {
            chemistSelectedList = convertRCPAOwnToDetailedProductMaster(rcpaList:rcpaProductList)!
        }
        return chemistSelectedList
    }
    
    func convertToDCRChemistRCPA(selectedList : [DetailProductMaster],customerObj: CustomerMasterModel) -> [DCRChemistRCPAOwn]
    {
        var chemistDetailedList:[DCRChemistRCPAOwn] = []
        if selectedList.count > 0
        {
            for obj in selectedList
            {
                let dict :[String:Any] = ["DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Chemist_Day_Visit_Id":ChemistDay.sharedInstance.chemistVisitId,"Chemist_Visit_Code":"","Product_Name":obj.Product_Name,"Product_Code":obj.Product_Code,"Customer_Code":customerObj.Customer_Code,"Doctor_Region_Code":checkNullAndNilValueForString(stringData:customerObj.Region_Code),"Customer_Speciality_Name":checkNullAndNilValueForString(stringData:customerObj.Speciality_Name),"Customer_Category_Name":checkNullAndNilValueForString(stringData:customerObj.Category_Name),"Customer_Name":checkNullAndNilValueForString(stringData:customerObj.Customer_Name),"Customer_MDLNumber":checkNullAndNilValueForString(stringData:customerObj.MDL_Number),"DCR_Code":DCRModel.sharedInstance.dcrCode]
                let rcpaObj = DCRChemistRCPAOwn(dict: dict as NSDictionary)
                
                chemistDetailedList.append(rcpaObj)
            }
        }
        return chemistDetailedList
    }

    //MARK:-Private Function
    
     func getDcrId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDcrCode() -> String
    {
        return DCRModel.sharedInstance.dcrCode
    }
    
     func getDCRDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.doctorVisitId
    }
    
    private func getDCRDate() -> String
    {
        return DCRModel.sharedInstance.dcrDateString
    }
    
    func isDetailedCompetitorPrivilegeEnabled() -> Bool
    {
        var isPrivEnabled: Bool = false
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.COLLECT_RETAIL_COMPETITOR_INFO)
        
        if (privValue != EMPTY)
        {
            let lockDay = Int(privValue)
            
            if (lockDay! > 0)
            {
                isPrivEnabled = true
            }
        }
        
        return isPrivEnabled
    }
    
    func getCompetitorList() ->[CompetitorModel]
    {
        return DBHelper.sharedInstance.getCompetitorList()
    }
    
    func getCompetitorProductList(competitorCode:Int) ->[ProductModel]
    {
        return DBHelper.sharedInstance.getCompetitorProductList(competitorCode:competitorCode)
    }
    
    func insertDcrDetailedCompetitor(dict: NSDictionary)
    {
        DBHelper.sharedInstance.insertDcrDetailedCompetitor(dict:dict)
    }
    
    func getDcrDetailedCompetitorList(dcrId:Int,dcrDoctorVisitId:Int,productCode:String) -> [DCRCompetitorDetailsModel]
    {
        return DBHelper.sharedInstance.getDcrDetailedCompetitorList(dcrId: dcrId, doctorVisitId: dcrDoctorVisitId, productCode: productCode)
    }
    
    func updateDcrDetailedCompetitor(dcrDetailCompetitorObj: DCRCompetitorDetailsModel,competitorDetailId:Int)
    {
        DBHelper.sharedInstance.updateDcrDetailedCompetitor(dcrDetailCompetitorObj: dcrDetailCompetitorObj, competitorDetailId: competitorDetailId)
    }
    
    func deleteDCRDetailedCompetitor(competitorDetailId:Int)
    {
        DBHelper.sharedInstance.deleteDCRDetailedCompetitor(competitorDetailId: competitorDetailId)
    }
    
}
class BL_CompetitorProducts: NSObject
{
    static let sharedInstance : BL_CompetitorProducts = BL_CompetitorProducts()
    var specialityArray : NSMutableArray = NSMutableArray()
    var categoryArray : NSMutableArray = NSMutableArray()
    var brandArray : NSMutableArray = NSMutableArray()
    var uomArray : NSMutableArray = NSMutableArray()
    var uomTypeArray : NSMutableArray = NSMutableArray()
    
    func getDcrDetailCompetitorList(productCode:String) -> [DCRCompetitorDetailsModel]
    {
        let dcrDetailCompetitorList = BL_DetailedProducts.sharedInstance.getDcrDetailedCompetitorList(dcrId: BL_DetailedProducts.sharedInstance.getDcrId(), dcrDoctorVisitId: BL_DetailedProducts.sharedInstance.getDCRDoctorVisitId(), productCode: productCode)
        
        return dcrDetailCompetitorList
    }
    

}
