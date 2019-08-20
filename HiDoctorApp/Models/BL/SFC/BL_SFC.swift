//
//  BL_SFC.swift
//  HiDoctorApp
//
//  Created by Vijay on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_SFC: NSObject {

    static let sharedInstance = BL_SFC()
    var fromPlace : String = ""
    var toPlace: String = ""
    
    // MARK: - Get Privilage Values
    func getIntermediatePlacePrivVal() -> [String]
    {
        let privVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.INTERMEDIATE_PLACES).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func getCircleRouteAppCategoryPrivVal() -> [String]
    {
        let privVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CIRCLE_ROUTE_APPLICABLE_CATEGORY).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func getSFCValidationPrivVal() -> [String]
    {
        let privVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SFC_VALIDATION).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func getSFCCategoryDontCheckPrivVal() -> [String]
    {
        let privVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SFC_CATEGORY_DONT_CHECK).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func getShowAccompDataPrivVal() -> [String]
    {
        let privVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    // MARK: - Accompanist functions
    private func getAccompanistData() -> [DCRAccompanistModel]?
    {
        let accompanistList = DAL_SFC.sharedInstance.getDCRAccompanistList(dcrId: DCRModel.sharedInstance.dcrId)
        return accompanistList
    }
    
    func isAccompanistScreenHidden() -> Bool
    {
        var flag : Bool = true
        let showAccompPrivVal:[String] = getShowAccompDataPrivVal()
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
                userModel.Employee_name = accompanistObj.Employee_Name
                userModel.User_Name = accompanistObj.Acc_User_Name
                userModel.User_Type_Name = accompanistObj.Acc_User_Type_Name
                userModel.Region_Name = accompanistObj.Region_Name
                userModel.Region_Code = accompanistObj.Acc_Region_Code
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
        } else
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            regionCodeList.append(regionCode!)
            let modelList = DAL_SFC.sharedInstance.getAccompanistRegionCodes()
            if (modelList?.count)! > 0
            {
                for model in modelList!
                {
                    regionCodeList.append(model.Acc_Region_Code)
                }
            }
        }
        
        return regionCodeList
    }
    
    // MARK: - Place functions
    func convertToSFCPlaceModel(regionCode: String) -> [PlaceMasterModel]?
    {
        var placeList : [PlaceMasterModel] = []
        var categoryName : String!
        
        if getRegionCode() == regionCode
        {
            let sfcValidationVal = getSFCValidationPrivVal()
            if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
            {
                categoryName = DCRModel.sharedInstance.expenseEntityName
            }
            else
            {
                categoryName = ""
            }
        }
        else
        {
            let sfcValidationVal = getSFCValidationPrivVal()
            let categoryDontCheckVal = getSFCCategoryDontCheckPrivVal()
            if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
            {
                if categoryDontCheckVal.contains(PrivilegeValues.DCR.rawValue)
                {
                    categoryName = ""
                }
                else
                {
                    categoryName = DCRModel.sharedInstance.expenseEntityName
                }
            }
            else
            {
                categoryName = ""
            }
        }
        
        let sfcList = DAL_SFC.sharedInstance.getPlaceList(regionCode: regionCode, categoryName: categoryName)
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
        var flag : Bool = true
        
        let sfcValidationVal = getSFCValidationPrivVal()
        if !sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            flag = false
        }

        return flag
    }
    
    //MARK: - SFC Detail functions
    func getSFCDetail() -> [SFCMasterModel]?
    {
        var modelList : [SFCMasterModel] = []
        var categoryName : String!
        
        let sfcValidationVal = getSFCValidationPrivVal()
        let categoryDontCheckVal = getSFCCategoryDontCheckPrivVal()
        if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            if categoryDontCheckVal.contains(PrivilegeValues.DCR.rawValue)
            {
                categoryName = ""
            }
            else
            {
                categoryName = DCRModel.sharedInstance.expenseEntityName
            }
        }
        else
        {
            categoryName = ""
        }
        
        let fromPlace = BL_SFC.sharedInstance.fromPlace
        let toPlace = BL_SFC.sharedInstance.toPlace
        let regionCodeList = getAccRegionCodes()
        
        modelList = DAL_SFC.sharedInstance.getSFCDetailsBasedonPlaces(fromPlace: fromPlace, toPlace: toPlace, regionCodeList: regionCodeList, categoryName: categoryName)!
        
        return modelList
    }
    
    func getSFCDetailsbasedOnTravelMode(fromPlace: String, toPlace: String, travelMode: String) -> [SFCMasterModel]
    {
        var modelList : [SFCMasterModel] = []
        var categoryName : String!
        
        let sfcValidationVal = getSFCValidationPrivVal()
        let categoryDontCheckVal = getSFCCategoryDontCheckPrivVal()
        if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            if categoryDontCheckVal.contains(PrivilegeValues.DCR.rawValue)
            {
                categoryName = ""
            }
            else
            {
                categoryName = DCRModel.sharedInstance.expenseEntityName
            }
        }
        else
        {
            categoryName = ""
        }
        
        let regionCodeList = getAccRegionCodes()
        modelList = DAL_SFC.sharedInstance.getSFCDetailsBasedonPlacesandTravelmode(fromPlace: fromPlace, toPlace: toPlace, regionCodeList: regionCodeList, categoryName: categoryName, travelMode: travelMode)!
        
        
        return modelList
    }
    
    func sfcValidationCheck(fromPlace : String, toPlace : String, travelMode : String) -> String
    {
        var message : String = ""
        
        var categoryParam : String!
        
        let sfcValidationVal = getSFCValidationPrivVal()
        let categoryDontCheckVal = getSFCCategoryDontCheckPrivVal()
        if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            if categoryDontCheckVal.contains(PrivilegeValues.DCR.rawValue)
            {
                categoryParam = ""
            }
            else
            {
                categoryParam = DCRModel.sharedInstance.expenseEntityName
            }
        }
        else
        {
            categoryParam = ""
        }
        
        let regionCodeList = getAccRegionCodes()
        
        let categoryName = DCRModel.sharedInstance.expenseEntityName

        if sfcValidationVal.contains(categoryName!)
        {
            let status = DAL_SFC.sharedInstance.getSFCValidationCheck(fromPlace: fromPlace, toPlace: toPlace, travelMode: travelMode, regionCodeList: regionCodeList, categoryName: categoryParam)
            if status > 0
            {
                message = ""
            }
            else
            {
                message = sfcValidationErrorMsg
            }
        }
        else
        {
            message = ""
        }
        
        return message
    }
    
    func insertSFCDetail(dict : NSMutableDictionary)
    {
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        
        let privVal = getIntermediatePlacePrivVal()
        let circularPrivVal = getCircleRouteAppCategoryPrivVal()
        let sfcValidationVal = getSFCValidationPrivVal()
        
        if circularPrivVal.contains(categoryName!) && !privVal.contains(categoryName!) && categoryName != defaultWorkCategoryType && sfcValidationVal.contains(categoryName!)
        {
            DAL_SFC.sharedInstance.insertSFCDetails(dict: dict)
            dict.setValue(BL_SFC.sharedInstance.fromPlace, forKey: "To_Place")
            dict.setValue(BL_SFC.sharedInstance.toPlace, forKey: "From_Place")
            dict.setValue(1, forKey: "Is_Circular_Route_Complete")
            DAL_SFC.sharedInstance.insertSFCDetails(dict: dict)
        } else
        {
            DAL_SFC.sharedInstance.insertSFCDetails(dict: dict)
        }
    }
    
    func insertTPSFCDetails(tpSFC: [TourPlannerSFC])
    {
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        
        let privVal = getIntermediatePlacePrivVal()
        let circularPrivVal = getCircleRouteAppCategoryPrivVal()
        let sfcValidationVal = getSFCValidationPrivVal()
        let sfcList : NSMutableArray = []
        
        if categoryName == defaultWorkCategoryType
        {
            let model = tpSFC[0]
            let dictionary : NSMutableDictionary = [:]
            dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
            dictionary.setValue(model.From_Place, forKey: "From_Place")
            dictionary.setValue(model.To_Place, forKey: "To_Place")
            dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
            dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
            dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
            dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
            dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
            dictionary.setValue("", forKey: "DCR_Code")
            dictionary.setValue(model.Region_Code, forKey: "SFC_Region_Code")
            dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
            dictionary.setValue(1, forKey: "Is_TP_Place")
            sfcList.add(dictionary)
        }
        else
        {
            if !privVal.contains(categoryName!)
            {
                if sfcValidationVal.contains(categoryName!) && circularPrivVal.contains(categoryName!)
                {
                    let model = tpSFC[0]
                    let dictionary : NSMutableDictionary = [:]
                    
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(model.Region_Code, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    dictionary.setValue(1, forKey: "Is_TP_Place")
                    sfcList.add(dictionary)
                    
                    let dict : NSMutableDictionary = [:]
                    dict.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dict.setValue(model.From_Place, forKey: "To_Place")
                    dict.setValue(model.To_Place, forKey: "From_Place")
                    dict.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dict.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dict.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dict.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dict.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dict.setValue("", forKey: "DCR_Code")
                    dict.setValue(model.Region_Code, forKey: "SFC_Region_Code")
                    dict.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    dict.setValue(1, forKey: "Is_Circular_Route_Complete")
                    sfcList.add(dict)
                }
                else
                {
                    let model = tpSFC[0]
                    let dictionary : NSMutableDictionary = [:]
                    
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(model.Region_Code, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    dictionary.setValue(1, forKey: "Is_TP_Place")
                    sfcList.add(dictionary)
                }
            }
            else
            {
                for model in tpSFC
                {
                    let dictionary : NSMutableDictionary = [:]
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(model.Region_Code, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    dictionary.setValue(1, forKey: "Is_TP_Place")
                    sfcList.add(dictionary)
                }
            }
        }
        DBHelper.sharedInstance.insertDCRTravelledPlacesDetails(array: sfcList)
    }
    
    func insertCPSFCDetails(cpSFC: [CampaignPlannerSFC])
    {
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        
        let privVal = getIntermediatePlacePrivVal()
        let circularPrivVal = getCircleRouteAppCategoryPrivVal()
        let sfcValidationVal = getSFCValidationPrivVal()
        
        let sfcList : NSMutableArray = []
        if categoryName == defaultWorkCategoryType
        {
            let model = cpSFC[0]
            let cpHeaderobj = DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: model.CP_Code)
            let dictionary : NSMutableDictionary = [:]
            var cpRegionCode = getRegionCode()
            
            if (cpHeaderobj != nil)
            {
                cpRegionCode = cpHeaderobj!.Region_Code
            }
            
            dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
            dictionary.setValue(model.From_Place, forKey: "From_Place")
            dictionary.setValue(model.To_Place, forKey: "To_Place")
            dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
            dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
            dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
            dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
            dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
            dictionary.setValue("", forKey: "DCR_Code")
            dictionary.setValue(cpRegionCode, forKey: "SFC_Region_Code")
            dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
            sfcList.add(dictionary)
        }
        else
        {
            if !privVal.contains(categoryName!)
            {
                if sfcValidationVal.contains(categoryName!) && circularPrivVal.contains(categoryName!)
                {
                    let model = cpSFC[0]
                    let cpHeaderobj = DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: model.CP_Code)
                    let dictionary : NSMutableDictionary = [:]
                    var cpRegionCode = getRegionCode()
                    
                    if (cpHeaderobj != nil)
                    {
                        cpRegionCode = cpHeaderobj!.Region_Code
                    }
                    
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(cpRegionCode, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                    
                    let dict : NSMutableDictionary = [:]
                    dict.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dict.setValue(model.From_Place, forKey: "To_Place")
                    dict.setValue(model.To_Place, forKey: "From_Place")
                    dict.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dict.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dict.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dict.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dict.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dict.setValue("", forKey: "DCR_Code")
                    dict.setValue(cpRegionCode, forKey: "SFC_Region_Code")
                    dict.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    dict.setValue(1, forKey: "Is_Circular_Route_Complete")
                    sfcList.add(dict)
                }
                else
                {
                    let model = cpSFC[0]
                    let cpHeaderobj = DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: model.CP_Code)
                    let dictionary : NSMutableDictionary = [:]
                    var cpRegionCode = getRegionCode()
                    
                    if (cpHeaderobj != nil)
                    {
                        cpRegionCode = cpHeaderobj!.Region_Code
                    }
                    
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(cpRegionCode, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                }
            }
            else
            {
                for model in cpSFC
                {
                    let cpHeaderobj = DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: model.CP_Code)
                    let dictionary : NSMutableDictionary = [:]
                    var cpRegionCode = getRegionCode()
                    
                    if (cpHeaderobj != nil)
                    {
                        cpRegionCode = cpHeaderobj!.Region_Code
                    }
                    
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(model.From_Place, forKey: "From_Place")
                    dictionary.setValue(model.To_Place, forKey: "To_Place")
                    dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
                    dictionary.setValue(String(format:"%f", model.Distance), forKey: "Distance")
                    dictionary.setValue(model.Distance_fare_Code, forKey: "Distance_Fare_Code")
                    dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue("", forKey: "DCR_Code")
                    dictionary.setValue(cpRegionCode, forKey: "SFC_Region_Code")
                    dictionary.setValue(model.SFC_Category_Name, forKey: "SFC_Category_Name")
                    sfcList.add(dictionary)
                }
            }
        }
        DBHelper.sharedInstance.insertDCRTravelledPlacesDetails(array: sfcList)
    }
    
    func checkIntermediateEntry() -> Bool
    {
        var flag : Bool = false
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        let privVal = getIntermediatePlacePrivVal()
        
        if privVal.contains(categoryName!)
        {
            flag = true
        }
        
        return flag
    }
    
    func checkIntermediateStatus() -> Bool
    {
        var flag : Bool!
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        let privVal = getIntermediatePlacePrivVal()
        
        if categoryName == defaultWorkCategoryType
        {
            flag = false
        }
        else if privVal.contains(categoryName!)
        {
            flag = true
        }
        else if !privVal.contains(categoryName!)
        {
            flag = false
        }
        
        return flag
    }
    
    func checkAutoCompleteValidation() -> String
    {
        var message : String = ""
        
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        if categoryName != defaultWorkCategoryType
        {
            let travelledPlaces = DAL_SFC.sharedInstance.getTravelledDetailList()
            
            for model in travelledPlaces!
            {
                if model.Is_Circular_Route_Complete == 1
                {
                    message = sfcCircularRouteErrorMsg
                    break
                }
            }
        }
        
        return message
    }
    
    func saveTravelledPlaces() -> String
    {
        var message : String = ""
        
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        if categoryName != defaultWorkCategoryType
        {
            let travelledPlaces = DAL_SFC.sharedInstance.getTravelledDetailList()
            
            for model in travelledPlaces!
            {
                let fromPlace = model.From_Place
                let toPlace = model.To_Place
                
                var duplicateCount : Int = 0
                for modeldata in travelledPlaces!
                {
                    if fromPlace == modeldata.From_Place && toPlace == modeldata.To_Place
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
            
            if message == ""
            {
                let circularPrivVal = getCircleRouteAppCategoryPrivVal()
                let sfcValidationVal = getSFCValidationPrivVal()
                if circularPrivVal.contains(categoryName!) && sfcValidationVal.contains(categoryName!)
                {
                    var leftArr : [String] = []
                    var rightArr : [String] = []
                    
                    for model in travelledPlaces!
                    {
                        leftArr.append(model.From_Place)
                        rightArr.append(model.To_Place)
                    }
                    
                    if !containSameElements(firstArray : leftArr, secondArray : rightArr)
                    {
                        message = circularValidationCheck
                    }
                }
            }
        }
        
        
        return message
    }

    func canEditDistance() -> Bool
    {
        var flag : Bool = false
        
        let dcrDate = DCRModel.sharedInstance.dcrDate
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        
        let expenseMappingList = DAL_SFC.sharedInstance.checkDistanceEditStatus(dcrDate: dcrDate!, categoryName: categoryName!)
        if expenseMappingList.count > 0
        {
            let distanceEdit = expenseMappingList[0].Distance_Edit
            if distanceEdit == 1
            {
                flag = true
            }
            else if distanceEdit == 2
            {
                flag = true
            }else if distanceEdit == 0{
                flag = false
            }
        }
        else
        {
            flag = true
        }
        
        return flag
    }
    
}
