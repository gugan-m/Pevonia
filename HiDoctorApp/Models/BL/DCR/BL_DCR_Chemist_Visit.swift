//
//  BL_DCR_Chemist_Visit.swift
//  HiDoctorApp
//
//  Created by SwaaS on 29/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Chemist_Visit: NSObject
{
    static let sharedInstance : BL_DCR_Chemist_Visit = BL_DCR_Chemist_Visit()
    
    //MARK:- Public Functions
    func getDCRChemistVisit() -> [DCRChemistVisitModel]?
    {
        return DBHelper.sharedInstance.getDCRChemistVisit(dcrDoctorVisitId: getDCRDoctorVisitId())
    }
    func getDCRChemistVisitfromDcrId() -> [DCRChemistVisitModel]?
    {
        return DBHelper.sharedInstance.getDCRChemistVisitfromDcrId(dcrId: getDCRId())
    }
    func canUseAccompanistsChemist() -> Bool
    {
        var returnValue: Bool = false
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).uppercased()
        let privArray = privilegeValue.components(separatedBy: ",")
        
        if (privArray.contains(CHEMIST))
        {
            returnValue = true
        }
        
        return returnValue
    }
    
    func dcrAccompanistsList() -> [DCRAccompanistModel]?
    {
        return BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists()
    }
    
    func getChemistMasterList(regionCode: String) -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getCustomerMasterList(regionCode: regionCode, customerEntityType: CHEMIST)
    }
    
    func saveDCRChemistVisit(chemistId: Int?, chemistCode: String?, chemistName: String?, pobAmount: Double?)
    {
        let chemistDict: NSDictionary = ["Visit_Id": getDCRDoctorVisitId(), "DCR_Id": getDCRId(), "Chemist_Id": chemistId!, "Chemist_Code": chemistCode!, "Chemist_Name": chemistName!, "POB_Amount": pobAmount!]
        
        let objDCRChemistVisit: DCRChemistVisitModel = DCRChemistVisitModel(dict: chemistDict)
        
        DBHelper.sharedInstance.insertDCRChemistVisit(dcrChemistVisitObj: objDCRChemistVisit)
//        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Chemist_Modified)
    }
    
    func updateDCRChemistVisit(dcrChemistVisitObj: DCRChemistVisitModel)
    {
        DBHelper.sharedInstance.updateDCRChemistVisit(dcrChemistVisitObj: dcrChemistVisitObj)
//        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Chemist_Modified)
    }
    
    func deleteDCRChemistVisit(dcrChemistVisitId: Int)
    {
        DBHelper.sharedInstance.deleteDCRChemistVisit(dcrChemistVisitId: dcrChemistVisitId)
    }
    
    func getDCRRCPADetails(dcrChemistVisitId: Int) -> [DCRRCPAModel]?
    {
        return DBHelper.sharedInstance.getDCRRCPADetails(dcrChemistVisitId: dcrChemistVisitId)
    }
    
    func deleteRCPADetails(dcrChemistVisitId: Int, productCode: String)
    {
        DBHelper.sharedInstance.deleteRCPADetails(dcrChemistVisitId: dcrChemistVisitId, productCode: productCode)
    }
    
    func saveRCPADetails(dcrChemistVisitId: Int, ownProductId: Int, ownProductCode : String , ownProductName : String,ownProductQty: Float, competitorProductArray: NSArray?)
    {
        var rcpaDict: NSDictionary!
        var rcpaList: [DCRRCPAModel] = []
        
        rcpaDict = ["DCR_Chemists_Id": dcrChemistVisitId, "Visit_Id": getDCRDoctorVisitId(), "DCR_Id": getDCRId(), "Own_Product_Id": ownProductId, "Own_Product_Code": ownProductCode, "Own_Product_Name": ownProductName, "Qty_Given": ownProductQty, "Product_Code": ownProductCode]
        
        var rcpaObj: DCRRCPAModel = DCRRCPAModel(dict: rcpaDict)
        
        rcpaList.append(rcpaObj)
        
        if (competitorProductArray != nil)
        {
            if (competitorProductArray!.count > 0)
            {
                for obj in competitorProductArray!
                {
                    let compDict: NSDictionary = obj as! NSDictionary
                    
                    let compProductId: Int? = Int((compDict.value(forKey: "Competitor_Product_Id") as? String)!)
                    let compProductCode: String? = compDict.value(forKey: "Competitor_Product_Code") as? String
                    let compProductName: String? = compDict.value(forKey: "Competitor_Product_Name") as? String
                    let qtyGiven: Float? = compDict.value(forKey: "Qty_Given") as? Float
                    
                    rcpaDict = ["DCR_Chemists_Id": dcrChemistVisitId, "Visit_Id": getDCRDoctorVisitId(), "DCR_Id": getDCRId(), "Own_Product_Id":ownProductId, "Own_Product_Code": EMPTY, "Own_Product_Name": ownProductName, "Qty_Given": qtyGiven, "Competitor_Product_Id": compProductId, "Competitor_Product_Code": compProductCode, "Competitor_Product_Name": compProductName, "Product_Code": ownProductCode]
                    
                    rcpaObj = DCRRCPAModel(dict: rcpaDict)
                    rcpaList.append(rcpaObj)
                }
            }
        }
        
        DBHelper.sharedInstance.insertDCRRCPADetails(rcpaList: rcpaList)
    }
    
    func updateRCPADetails(dcrChemistVisitId: Int, ownProductId:Int, productCode : String , ownProductName : String, ownProductQty: Float, competitorProductArray: NSArray?)
    {
        deleteRCPADetails(dcrChemistVisitId: dcrChemistVisitId, productCode: productCode )
        
        saveRCPADetails(dcrChemistVisitId: dcrChemistVisitId, ownProductId: ownProductId, ownProductCode: productCode, ownProductName : ownProductName, ownProductQty: ownProductQty, competitorProductArray: competitorProductArray)
    }
    
    func getCompetitorProducts(ownProductCode: String) -> [CompetitorProductModel]?
    {
        return DBHelper.sharedInstance.getCompetitorProducts(ownProductCode: ownProductCode)
    }
    
    func getDCRRCPAByOwnProductId(dcrChemistVisitId : Int , ownProductCode : String) -> [DCRRCPAModel]
    {
        return DBHelper.sharedInstance.getDCRRCPADetailsByOwnProductId(dcrChemistVisitId: dcrChemistVisitId, ownProductCode: ownProductCode)!
    }
    
    
    
    func saveFlexiChemist(chemistName: String)
    {
        let dict: NSDictionary = ["Flexi_Chemist_Name": chemistName]
        let flexiChemistObj: FlexiChemistModel = FlexiChemistModel(dict: dict)
        
        DBHelper.sharedInstance.insertFleixChemist(flexiChemistObj: flexiChemistObj)
    }
    
    func getFlexiChemist() -> [FlexiChemistModel]?
    {
        return DBHelper.sharedInstance.getFlexiChemistList()
    }
    
    func getLastDCRChemistVisitId() -> Int
    {
        return DBHelper.sharedInstance.getDCRChemistVisitId()
    }
    
    func getDCRRCPAUniqueOwnProducts(dcrChemistVisitId: Int) -> [DCRRCPAModel]?
    {
        return DBHelper.sharedInstance.getDCRRCPAUniqueOwnProducts(dcrChemistVisitId: dcrChemistVisitId)
    }
    
    //MARK:- Chemist Day Functions
    func getRCPAEnteredDoctorsList() -> [DCRChemistRCPAOwn]
    {
        return DBHelper.sharedInstance.getRCPAEnteredDoctorsList(chemistDayVisitId: getChemistDayVisitId())
    }
    
    func getRCPAEnteredDoctorsList(doctorCode: String, doctorRegionCode: String, doctorName: String, specialtyName: String) -> [DCRChemistRCPAOwn]
    {
        let chemistDayVisitId = getChemistDayVisitId()
        
        if (doctorCode != EMPTY)
        {
            return DBHelper.sharedInstance.getRCPADetailsByDoctorCode(chemistDayVisitId: chemistDayVisitId, doctorCode: doctorCode, doctorRegionCode: doctorRegionCode)
        }
        else
        {
            return DBHelper.sharedInstance.getRCPADetailsByDoctorName(chemistDayVisitId: chemistDayVisitId, doctorName: doctorName, doctorSpecialityName: specialtyName)
        }
    }
    
    func getDCRRCPAByOwnProductId(ownProductId: Int) -> [DCRChemistRCPACompetitor]
    {
        let chemistDayVisitId = getChemistDayVisitId()
        return DBHelper.sharedInstance.getChemistDayRCPACompetitor(chemistDayVisitId: chemistDayVisitId,rcpaOwn_Id: ownProductId)
    }
    
    func deleteChemistDayRCPA(chemistRCPAOwnId: Int)
    {
        DBHelper.sharedInstance.deleteChemistDayRCPA(chemistRCPAOwnId: chemistRCPAOwnId)
    }
    
    func saveChemistDayRCPADetails(objOwnProduct: DetailProductMaster, doctorCode: String, doctorRegionCode: String, doctorName: String, specialtyName: String, categoryName: String, mdlNumber: String, ownProductQty: Float, competitorProductArray: NSArray?)
    {
        let chemistDayVisitId = getChemistDayVisitId()
        let rcpaDict: NSDictionary = ["DCR_Chemist_Day_Visit_Id": chemistDayVisitId, "DCR_Id": getDCRId(), "Product_Id": objOwnProduct.Detail_Product_Id, "Product_Code": objOwnProduct.Product_Code, "Product_Name": objOwnProduct.Product_Name, "Qty": ownProductQty, "Customer_Code": doctorCode, "Customer_RegionCode": doctorRegionCode, "Customer_Name": doctorName, "Customer_Speciality_Name": specialtyName, "Customer_Category_Name": categoryName, "Customer_MDLNumber": mdlNumber,"DCR_Code":DCRModel.sharedInstance.dcrCode]
        
        let objRCAPAOwn: DCRChemistRCPAOwn = DCRChemistRCPAOwn(dict: rcpaDict)
        let chemistRCPAOwnId = DBHelper.sharedInstance.insertChemistDayRCPAOwn(objRCPAOwn: objRCAPAOwn)
        let compProdList: NSMutableArray = []
        
        if (competitorProductArray != nil)
        {
            if (competitorProductArray!.count > 0)
            {
                for obj in competitorProductArray!
                {
                    let compDict: NSDictionary = obj as! NSDictionary
                    
                    let compProductCode: String = compDict.value(forKey: "Competitor_Product_Code") as? String ?? EMPTY
                    let compProductName: String = compDict.value(forKey: "Competitor_Product_Name") as? String ?? EMPTY
                    let qtyGiven: Float = compDict.value(forKey: "Qty_Given") as? Float ?? 0
                    
                    let comprcpaDict = ["Chemist_RCPA_OWN_Product_Id": chemistRCPAOwnId, "DCR_Chemist_Day_Visit_Id": chemistDayVisitId, "DCR_Id": getDCRId(), "Own_Product_Code": objOwnProduct.Product_Code, "Competitor_Product_Code": compProductCode, "Competitor_Product_Name": compProductName, "Qty": qtyGiven,"DCR_Code":DCRModel.sharedInstance.dcrCode] as NSDictionary
                    
                    compProdList.add(comprcpaDict)
                }
                
                DBHelper.sharedInstance.insertDCRDoctorVisitChemistRCPACompetitorProductDetails(array: compProdList)
            }
        }
    }
    
    func updateChemistDayRCPADetails(chemistRCPAOwnId: Int, objOwnProduct: DetailProductMaster, doctorCode: String, doctorRegionCode: String, doctorName: String, specialtyName: String, categoryName: String, mdlNumber: String, ownProductQty: Float, competitorProductArray: NSArray?)
    {
        self.deleteChemistDayRCPA(chemistRCPAOwnId: chemistRCPAOwnId)
        self.saveChemistDayRCPADetails(objOwnProduct: objOwnProduct, doctorCode: doctorCode, doctorRegionCode: doctorRegionCode, doctorName: doctorName, specialtyName: specialtyName, categoryName: categoryName, mdlNumber: mdlNumber, ownProductQty: ownProductQty, competitorProductArray: competitorProductArray)
    }
    
    //MARK:- Private Functions
    private func getDCRDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.doctorVisitId
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getChemistDayVisitId() -> Int
    {
        return ChemistDay.sharedInstance.chemistVisitId
    }
}
