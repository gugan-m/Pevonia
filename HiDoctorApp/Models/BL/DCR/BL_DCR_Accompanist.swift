//
//  BL_DCR_Accompanist.swift
//  HiDoctorApp
//
//  Created by SwaaS on 17/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Accompanist: NSObject
{
    static let sharedInstance = BL_DCR_Accompanist()
    
    // MARK:- Public Functions
    func getAccompanistMasterList() -> [AccompanistModel]
    {
        return DBHelper.sharedInstance.getAccompanistMaster()
    }
    
    func getAccompanistMasterLists()-> [AccompanistModel]
    {
        return DBHelper.sharedInstance.getAccompanistMasterList()
    }
    
    func getDPMAccompanistList()-> [AccompanistModel]
    {
        let getUserDetails = DBHelper.sharedInstance.getUserDetail()
        return DBHelper.sharedInstance.getDPMAccompanistMasterList(fullIndex:getUserDetails?.Full_index! ?? "")
    }
    
    func getAccompanistTPFreezeMasterLists()-> [AccompanistModel]
    {
        return DBHelper.sharedInstance.getAccompanistMasterTPFreezeList()
    }
    
    func getDCRAccompanistList() -> [DCRAccompanistModel]?
    {
        return DBHelper.sharedInstance.getListOfDCRAccompanist(dcrId: getDCRId())
    }
    
    
    func getDCRAccompanistListWithoutVandNA() -> [DCRAccompanistModel]?
    {
        return DBHelper.sharedInstance.getListOfDCRAccompanistWithoutVandNA(dcrId: getDCRId())
    }
    
    func saveDCRAccompanistData(userMasterObj: UserMasterModel, isIndependentCall: String, startTime: String, endTime: String)
    {
        let dict: NSDictionary = ["DCR_Id": getDCRId(), "Acc_Region_Code": userMasterObj.Region_Code, "Acc_User_Code": userMasterObj.User_Code, "Acc_User_Name": userMasterObj.User_Name, "Acc_User_Type_Name": userMasterObj.User_Type_Name, "Is_Only_For_Doctor": isIndependentCall, "Acc_Start_Time": startTime, "Acc_End_Time": endTime, "DCR_Code": getDCRCode(), "Is_Customer_Data_Inherited": Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Yet_To_Download, "Employee_Name":userMasterObj.Employee_name]
        
        let dcrAccompanistModelObj: DCRAccompanistModel = DCRAccompanistModel(dict: dict)
        
        DBHelper.sharedInstance.insertDCRAccompanist(dcrAccompanistModelObj: dcrAccompanistModelObj)
        
        updateDCRStatusToDraft()
    }
    
    func updateDCRAccomapnistData(dcrAccompanistModelObj: DCRAccompanistModel) -> Bool
    {
        _ = DBHelper.sharedInstance.updateDCRAccompanist(dcrAccompanistModelObj: dcrAccompanistModelObj)
        
        updateDCRStatusToDraft()
        
        return true
    }
    
    func convertAccompanistListToUserList(accompanistList: [AccompanistModel],dcrAccompanistList :[DCRAccompanistModel]) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        for accompanistObj in accompanistList
        {
            let wrapperObj: UserMasterWrapperModel = UserMasterWrapperModel()
            let userObj: UserMasterModel = UserMasterModel()
            
            userObj.User_Code = accompanistObj.User_Code
            userObj.User_Name = accompanistObj.User_Name
            userObj.Employee_name = accompanistObj.Employee_name
            userObj.Region_Code = accompanistObj.Region_Code
            userObj.Region_Name = accompanistObj.Region_Name
            userObj.User_Type_Name = accompanistObj.User_Type_Name
            userObj.Division_Name = accompanistObj.Division_Name
            
            wrapperObj.userObj = userObj
            wrapperObj.isSelected = false
            
            let filteredArray = dcrAccompanistList.filter
            {
                accompanistObj.User_Code == $0.Acc_User_Code &&
                accompanistObj.Region_Code == $0.Acc_Region_Code
            }
            
            if (filteredArray.count > 0)
            {
                wrapperObj.isReadOnly = true
            }
            else
            {
                wrapperObj.isReadOnly = false
            }
            
            userList.append(wrapperObj)
        }
        
        return userList
    }
    
    func checkIsVacantRegion(userName : String,employeeName : String) -> Bool
    {
        var isVacantUser: Bool = false
        let userName = userName.uppercased()
        
        if (userName == VACANT || userName == NOT_ASSIGNED || employeeName == VACANT || employeeName == NOT_ASSIGNED)
        {
            isVacantUser = true
        }
        
        return isVacantUser
    }
    
    func getMinimumAccompanistCount() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_ACCOMPANIST_MANDATORY)
        var minimumAccompanist = 0
        
        if (privilegeValue != PrivilegeValues.EMPTY.rawValue)
        {
            if Int(privilegeValue) != nil
            {
                minimumAccompanist = Int(privilegeValue)!
            }
        }
        
        return minimumAccompanist
    }
    
    /*
     This function will return false if the required number of accompanists are not entered in the DCR. Show error messaage or hide relevant buttons in this case
     This funciton will return true if the required number of accompanist are entered in DCR
    */
    func doMinimumAccompanistValidation() -> Bool
    {
        let minimumAccompanist = getMinimumAccompanistCount()
        var isValidationSuccess: Bool = true
        
        if (minimumAccompanist > 0)
        {
            let dcrAccompanistCount = getDCRAccompanistListCount()
            
            if (dcrAccompanistCount < minimumAccompanist)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    
    
    func getDCRAccompanistListCount() -> Int
    {
        return DBHelper.sharedInstance.getAccompanistCountForDCRId(dcrId: getDCRId())
    }
    
    func getMaximumAccompanistCount() -> Int
    {
        let configValue = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.MAX_ACCOMPANIST_FOR_A_DAY)
        var maximumAccompanist = 4
        
        if (configValue != ConfigValues.EMPTY.rawValue)
        {
            if Int(configValue) != nil
            {
                maximumAccompanist = Int(configValue)!
            }
        }
        
        return maximumAccompanist
    }
    
    /*
     This function will return true if the user can enter further accompanists for the day. 
     This function will return false if the user has entered the maximum accompanists and he can't enter any more accompanists for the day
    */
    func doMaximumAccompanistValidation() -> Bool
    {
        let maximumAccompanist = getMaximumAccompanistCount()
        var isValidationSuccess: Bool = true
        
        let dcrAccompanistCount = DBHelper.sharedInstance.getAccompanistCountForDCRId(dcrId: getDCRId())
        
        if (dcrAccompanistCount >= maximumAccompanist)
        {
            isValidationSuccess = false
        }
        
        return isValidationSuccess
    }
    
    func isAccompanistDataAvailable(userCode: String, regionCode: String) -> Int
    {
        var completionStatus = 0
        
        let completeDownloadObj = DBHelper.sharedInstance.getAccompanistDownloadStatusForUser(userCode: userCode, regionCode: regionCode, downloadStatus: 1)
        
        if (completeDownloadObj != nil)
        {
            completionStatus = 1
        }
        
        return completionStatus
    }
    
    func removeDCRAccompanist(accompanistRegionCode: String,accompanistUserCode : String)
    {
        DBHelper.sharedInstance.deleteDCRAccompanist(userCode: accompanistUserCode, regionCode: accompanistRegionCode, dcrId: getDCRId())
    }
    
    func isAnyAccompaistDataUsedInDCR(dcrAccompanistObj : DCRAccompanistModel) -> String
    {
        let errorMessage : String = "you are trying to remove <b>\(dcrAccompanistObj.Employee_Name!)</b> from the accompanist list\n 1. If any visit of \(appDoctor)/\(appChemist) that belong to this accompanist/region is available in this DCR, system will remove the \(appDoctor)/\(appChemist) visit.\n2. If you have marked this accompanist/region name in \(appDoctor)/\(appChemist) accompanist, those records will be removed.\n3. The CP, SFC records and visit of \(appChemist) who belongs to this accompanist/region name will be removed.\n Click <b>OK</b> to continue\nClick <b>CANCEL to retain this accompanist/region and related \(appDoctor)/\(appChemist) visits."
        let accompanistRegionCode = dcrAccompanistObj.Acc_Region_Code
        let accompanistUserCode = checkNullAndNilValueForString(stringData: dcrAccompanistObj.Acc_User_Code)
        
        if getCPCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!) > 0 || getSFCCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!) > 0 || getDoctorCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!) > 0 || getDoctorAccompanistCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!, accompanistUserCode: accompanistUserCode) > 0 ||
            getChemistCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!) > 0 || getChemistAccompanistCountUsedInDCRByRegionCode(accompanistRegionCode: accompanistRegionCode!, accompanistUserCode: accompanistUserCode) > 0
        {
            return errorMessage
        }
       
        return EMPTY
    }
    
    func removeAccompanitsDataUsedInDCR(accompanistRegionCode: String,accompanistUserCode : String)
    {
        DBHelper.sharedInstance.deleteCPUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
        DBHelper.sharedInstance.deleteSFCUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
//        DBHelper.sharedInstance.deleteDoctorUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
//        DBHelper.sharedInstance.deleteDoctorAccompanistUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode, userCode: accompanistUserCode)
//        DBHelper.sharedInstance.deleteChemistAccompanistUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode , userCode : accompanistUserCode)
        DBHelper.sharedInstance.deleteDCRDoctorAccompanistsForAccDelete(dcrId: getDCRId(), accompanistRegionCode: accompanistRegionCode)
        let doctorVisits = DBHelper.sharedInstance.getDoctorUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
        
        for objDocVisit in doctorVisits
        {
            BL_DCR_Doctor_Visit.sharedInstance.deleteDCRDoctorVisit(dcrDoctorVisitId: objDocVisit.DCR_Doctor_Visit_Id, customerCode: checkNullAndNilValueForString(stringData: objDocVisit.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: objDocVisit.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString), doctorName: checkNullAndNilValueForString(stringData: objDocVisit.Doctor_Name))
        }
        
        let rcpaDoctorList = DBHelper.sharedInstance.getDoctorUsedInChemistRCPAByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
        if rcpaDoctorList.count > 0
        {
            for obj in rcpaDoctorList
            {
                DBHelper.sharedInstance.deleteChemistDayRCPA(chemistRCPAOwnId: obj.DCRChemistRCPAOwnId)
            }
        }
        
        let chemistDayVisits = DBHelper.sharedInstance.getChemistDayVisitsByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
        
        for objChemistDayVisit in chemistDayVisits
        {
            BL_Common_Stepper.sharedInstance.deleteChemistVisitDetailsForChemistDayVisitId(dcrId: objChemistDayVisit.DCRId, chemistVisitId: objChemistDayVisit.DCRChemistDayVisitId)
        }
        
        self.removeDCRAccompanist(accompanistRegionCode: accompanistRegionCode, accompanistUserCode: accompanistUserCode)
    }
    
    func checkIsDCRDoctorVisitHasEntry() -> Bool
    {
        var isEntered : Bool = false
        let doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
        
        if (doctorVisitList.count > 0)
        {
            isEntered = true
        }
        
        return isEntered
    }
 
    // MARK:- Private Functions
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDCRCode() -> String
    {
        return DCRModel.sharedInstance.dcrCode
    }
    
    private func updateDCRStatusToDraft()
    {
        DBHelper.sharedInstance.updateDCRStatus(dcrId: getDCRId(), dcrStatus: DCRStatus.drafted.rawValue, dcrCode: EMPTY)
        
        let dcrHeaderObj = DBHelper.sharedInstance.getDCRHeaderByDCRId(dcrId: getDCRId())
        
        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj!])
    }
    
    private func getCPCountUsedInDCRByRegionCode(accompanistRegionCode: String) -> Int
    {
        return DBHelper.sharedInstance.getCPCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
    }
    
    private func getSFCCountUsedInDCRByRegionCode(accompanistRegionCode : String) -> Int
    {
        return DBHelper.sharedInstance.getSFCCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
    }
    
    private func getDoctorCountUsedInDCRByRegionCode(accompanistRegionCode: String) -> Int
    {
        return DBHelper.sharedInstance.getDoctorCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
    }
    
    private func getDoctorAccompanistCountUsedInDCRByRegionCode(accompanistRegionCode: String,accompanistUserCode : String) -> Int
    {
        return DBHelper.sharedInstance.getDoctorAccompanistCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode,userCode :accompanistUserCode)
    }
    
    private func getChemistAccompanistCountUsedInDCRByRegionCode(accompanistRegionCode: String,accompanistUserCode : String) -> Int
    {
        return DBHelper.sharedInstance.getChemistAccompanistCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode,userCode :accompanistUserCode)
    }
    
    private func getChemistCountUsedInDCRByRegionCode(accompanistRegionCode : String) -> Int
    {
        return DBHelper.sharedInstance.getChemistCountUsedInDCRByRegionCode(dcrId: getDCRId(), regionCode: accompanistRegionCode)
    }
    
    func getAccompanistDoctorCount(accompanistRegionCode : String) -> Int
    {
        return DBHelper.sharedInstance.getAccompanistDoctorCount(regionCode: accompanistRegionCode)
    }
}
