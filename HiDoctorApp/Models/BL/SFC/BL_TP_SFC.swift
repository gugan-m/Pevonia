//
//  BL_TP_SFC.swift
//  HiDoctorApp
//
//  Created by Admin on 8/9/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TP_SFC: NSObject {
    
    static let sharedInstance = BL_TP_SFC()
    var fromPlace : String = ""
    var toPlace: String = ""
    
    // MARK: - Accompanist functions
    private func getAccompanistData() -> [UserMasterWrapperModel]?
    {
        let accompanistList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        return accompanistList
    }
    
    func isAccompanistScreenHidden() -> Bool
    {
        var flag : Bool = true
        let showAccompPrivVal:[String] = BL_SFC.sharedInstance.getShowAccompDataPrivVal()
        
        if showAccompPrivVal.contains(PrivilegeValues.SFC.rawValue)
        {
            let accompData = getAccompanistData()
            
            if (accompData?.count)! > 0
            {
                flag = false
            }
        }
        
        return flag
    }
    
    func convertToSFCUserModel() -> [UserMasterWrapperModel]?
    {
        var userList : [UserMasterWrapperModel] = []
        let accompanistList = getAccompanistData()
        
        let loggedUserModel = getUserModelObj()
        loggedUserModel?.Employee_name = "Mine"
        
        let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
        wrapperModel.userObj = loggedUserModel!
        
        userList.append(wrapperModel)
        
        if (accompanistList?.count)! > 0
        {
            for accompanistObj in accompanistList!
            {
                let userModel : UserMasterModel = UserMasterModel()
                userModel.Employee_name = accompanistObj.userObj.Employee_name
                userModel.User_Name = accompanistObj.userObj.User_Name
                userModel.User_Type_Name = accompanistObj.userObj.User_Type_Name
                userModel.Region_Name = accompanistObj.userObj.Region_Name
                userModel.Region_Code = accompanistObj.userObj.Region_Code
                
                let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
                wrapperModel.userObj = userModel
                
                userList.append(wrapperModel)
            }
        }
        
        return userList
    }
    
    func getAccRegionCodes() -> [String]
    {
        var regionCodeList : [String] = []
        
        if isAccompanistScreenHidden()
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            
            regionCodeList.append(regionCode!)
        }
        else
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            
            regionCodeList.append(regionCode!)
            
            let modelList = getAccompanistData()
            
            if (modelList != nil)
            {
                for model in modelList!
                {
                    regionCodeList.append(model.userObj.Region_Code)
                }
            }
        }
        
        return regionCodeList
    }
    
    // MARK: - Place functions
    private func getCurrentEntityName() -> String
    {
        return checkNullAndNilValueForString(stringData: TPModel.sharedInstance.expenseEntityName)
    }
    
    private func isSFCValidationRequired() -> Bool
    {
        let privValue = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        
        if privValue.contains(getCurrentEntityName().uppercased())
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func getCategoryDontCheckCategoryName() -> String
    {
        let categoryDontCheckVal = BL_SFC.sharedInstance.getSFCCategoryDontCheckPrivVal()
        var categoryName : String!
        
        if (isSFCValidationRequired())
        {
            if categoryDontCheckVal.contains(PrivilegeValues.TP.rawValue)
            {
                categoryName = EMPTY
            }
            else
            {
                categoryName = getCurrentEntityName()
            }
        }
        else
        {
            categoryName = EMPTY
        }
        
        return categoryName
    }
    
    func convertToSFCPlaceModel(regionCode: String) -> [PlaceMasterModel]?
    {
        var placeList : [PlaceMasterModel] = []
        var categoryName : String!
        
        if getRegionCode() == regionCode
        {
            if (isSFCValidationRequired())
            {
                categoryName = getCurrentEntityName()
            }
            else
            {
                categoryName = EMPTY
            }
        }
        else
        {
            categoryName = getCategoryDontCheckCategoryName()
        }
        
        let sfcList = DAL_TP_SFC.sharedInstance.getPlaceList(regionCode: regionCode, categoryName: categoryName)
        
        for sfcObj in sfcList!
        {
            let placeModel : PlaceMasterModel = PlaceMasterModel()
            placeModel.placeName = sfcObj.From_Place
            placeList.append(placeModel)
        }
        
        return placeList
    }
    
    func placeListAddBtnHidden() -> Bool
    {
        return isSFCValidationRequired()
    }
    
    //MARK: - SFC Detail functions
    func getSFCDetail() -> [SFCMasterModel]?
    {
        var modelList : [SFCMasterModel] = []
        let categoryName : String = getCategoryDontCheckCategoryName()
        let fromPlace = BL_TP_SFC.sharedInstance.fromPlace
        let toPlace = BL_TP_SFC.sharedInstance.toPlace
        let regionCodeList = getAccRegionCodes()
        
        modelList = DAL_TP_SFC.sharedInstance.getSFCDetailsBasedonPlaces(fromPlace: fromPlace, toPlace: toPlace, regionCodeList: regionCodeList, categoryName: categoryName)!
        
        return modelList
    }
    
    func getSFCDetailsbasedOnTravelMode(fromPlace: String, toPlace: String, travelMode: String) -> [SFCMasterModel]
    {
        var modelList : [SFCMasterModel] = []
        let categoryName : String = getCategoryDontCheckCategoryName()
        let regionCodeList = getAccRegionCodes()
        
        modelList = DAL_TP_SFC.sharedInstance.getSFCDetailsBasedonPlacesandTravelmode(fromPlace: fromPlace, toPlace: toPlace, regionCodeList: regionCodeList, categoryName: categoryName, travelMode: travelMode)!
        
        
        return modelList
    }
    
    func sfcValidationCheck(fromPlace : String, toPlace : String, travelMode : String) -> String
    {
        var message : String = ""
        let categoryParam : String = getCategoryDontCheckCategoryName()
        let regionCodeList = getAccRegionCodes()
        let categoryName = TPModel.sharedInstance.expenseEntityName
        
        if (isSFCValidationRequired())
        {
            let status = DAL_TP_SFC.sharedInstance.getSFCValidationCheck(fromPlace: fromPlace, toPlace: toPlace, travelMode: travelMode, regionCodeList: regionCodeList, categoryName: categoryParam)
            
            if status > 0
            {
                message = EMPTY
            }
            else
            {
                message = sfcValidationErrorMsg
            }
        }
        else
        {
            message = EMPTY
        }
        
        return message
    }
    
    func insertSFCDetail(dict : NSMutableDictionary)
    {
//        let categoryName = TPModel.sharedInstance.expenseEntityName
//        
//        let privVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
//        let sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
//        
//        if !privVal.contains(categoryName!) && categoryName != defaultWorkCategoryType && sfcValidationVal.contains(categoryName!)
//        {
//            DAL_TP_SFC.sharedInstance.insertSFCDetails(dict: dict)
//            
//            dict.setValue(self.fromPlace, forKey: "To_Place")
//            dict.setValue(self.toPlace, forKey: "From_Place")
//            
//            DAL_TP_SFC.sharedInstance.insertSFCDetails(dict: dict)
//        }
//        else
//        {
//            DAL_TP_SFC.sharedInstance.insertSFCDetails(dict: dict)
//        }
        
        DAL_TP_SFC.sharedInstance.insertSFCDetails(dict: dict)
    }
    
    private func getSFCRegionCode(sfcCode: String, versionNo: Int) -> String
    {
        var regionCode: String = getRegionCode()
        let sfcObj = DAL_SFC.sharedInstance.getSFCMasterBySFCCode(sfcCode: sfcCode, versionNo: versionNo)
        
        if (sfcObj != nil)
        {
            regionCode = sfcObj!.Region_Code
        }
        
        return regionCode
    }
    
    func insertCPSFCDetails(cpSFC: [CampaignPlannerSFC])
    {
        let categoryName = TPModel.sharedInstance.expenseEntityName
        let privVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
        let sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        let sfcList : NSMutableArray = []
        
        if categoryName == defaultWorkCategoryType
        {
            let model = cpSFC[0]
            let dictionary : NSMutableDictionary = [:]
            
            dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
            dictionary.setValue(model.From_Place, forKey: "From_Place")
            dictionary.setValue(model.To_Place, forKey: "To_Place")
            dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
            dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
            dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
            dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
            dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
            dictionary.setValue(0, forKey: "TP_Id")
            dictionary.setValue(getSFCRegionCode(sfcCode: model.Distance_fare_Code, versionNo: model.SFC_Version), forKey: "SFC_Region_Code")
            dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
            
            sfcList.add(dictionary)
        }
        else
        {
            if !privVal.contains(categoryName!)
            {
                if sfcValidationVal.contains(categoryName!)
                {
                    let model = cpSFC[0]
                    let dictionary : NSMutableDictionary = [:]
                    
                    dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
                    dictionary.setValue(0, forKey: "TP_Id")
                    dictionary.setValue(getSFCRegionCode(sfcCode: model.Distance_fare_Code, versionNo: model.SFC_Version), forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                    
                    let dict : NSMutableDictionary = [:]
                    dict.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                    dict.setValue(model.From_Place, forKey: "To_Place")
                    dict.setValue(model.To_Place, forKey: "From_Place")
                    dict.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dict.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dict.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dict.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dict.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
                    dict.setValue(0, forKey: "TP_Id")
                    dict.setValue(getSFCRegionCode(sfcCode: model.Distance_fare_Code, versionNo: model.SFC_Version), forKey: "SFC_Region_Code")
                    dict.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dict)
                }
                else
                {
                    let model = cpSFC[0]
                    let dictionary : NSMutableDictionary = [:]
                    
                    dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
                    dictionary.setValue(0, forKey: "TP_Id")
                    dictionary.setValue(getSFCRegionCode(sfcCode: model.Distance_fare_Code, versionNo: model.SFC_Version), forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                }
            }
            else
            {
                for model in cpSFC
                {
                    let dictionary : NSMutableDictionary = [:]
                    dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
                    dictionary.setValue(0, forKey: "TP_Id")
                    dictionary.setValue(getSFCRegionCode(sfcCode: model.Distance_fare_Code, versionNo: model.SFC_Version), forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                }
            }
        }
        
        DBHelper.sharedInstance.insertTourPlannerSFC(array: sfcList)
    }
    
    func checkIntermediateEntry() -> Bool
    {
        var flag : Bool = false
        let categoryName = getCurrentEntityName().uppercased()
        let privVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
        
        if privVal.contains(categoryName)
        {
            flag = true
        }
        
        return flag
    }
    
    func checkIntermediateStatus() -> Bool
    {
        var flag : Bool!
        let categoryName = getCurrentEntityName().uppercased()
        let privVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
        
        if categoryName == defaultWorkCategoryType.uppercased()
        {
            flag = false
        }
        else if privVal.contains(categoryName)
        {
            flag = true
        }
        else if !privVal.contains(categoryName)
        {
            flag = false
        }
        
        return flag
    }
    
    func getTPEnteredSFCList() -> [TourPlannerSFC]
    {
        return DAL_TP_SFC.sharedInstance.getTravelledDetailList()
    }
    
    func saveTravelledPlaces() -> String
    {
        var message : String = ""
        let categoryName = getCurrentEntityName().uppercased()
        
        if categoryName != defaultWorkCategoryType.uppercased()
        {
            let travelledPlaces = getTPEnteredSFCList()
            
            for model in travelledPlaces
            {
                let fromPlace = model.From_Place
                let toPlace = model.To_Place
                var duplicateCount : Int = 0
                
                for modeldata in travelledPlaces
                {
                    if fromPlace == modeldata.From_Place.uppercased() && toPlace == modeldata.To_Place.uppercased()
                    {
                        duplicateCount = duplicateCount + 1
                    }
                }
                
                if duplicateCount > 1
                {
                    message = sfcDuplicationErrorMsg
                    break
                }
            }
        }
        
        BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
        
        return message
    }
    
    func deleteAllTravelDetails()
    {
        DAL_TP_SFC.sharedInstance.deleteAllTravelDetails(tpEntryId: TPModel.sharedInstance.tpEntryId)
        BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
    }
}
