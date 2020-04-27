//
//  BL_PrepareMyDeviceAccompanist.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_PrepareMyDeviceAccompanist: NSObject
{
    static let sharedInstance = BL_PrepareMyDeviceAccompanist()
    
    func getFrequentAccompanists() -> [AccompanistModel]?
    {
        return DBHelper.sharedInstance.getImmediateChildUsers()
    }
    
    func getAllAccompanists() -> [AccompanistModel]?
    {
        return DBHelper.sharedInstance.getAllAccompanists()
    }
    
    func getIncompleteAccompanistDataDownloadDetail() -> AccompanistDataDownloadModel?
    {
        return DBHelper.sharedInstance.getLastIncompleteAccompanistDataDownloadDetails()
    }
    
    func canDownloadAccompanistData() -> Bool
    {
        let privilegeValue = getShowAccompanistDataPrivilegeValue()
        
        if (privilegeValue != EMPTY)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func beginAccompanistDataDownload(selectedAccompanists: [UserMasterModel])
    {   
        let currentTime = getCurrentDateAndTime()
        let requestId = getNextRequestId()
        
        for objAccompanist in selectedAccompanists
        {
            let objDownloadData = AccompanistDataDownloadModel()
            
            objDownloadData.Request_Id = requestId
            objDownloadData.User_Code = objAccompanist.User_Code
            objDownloadData.Region_Code = objAccompanist.Region_Code
            objDownloadData.Is_Doctor_Data_Downloaded = 0
            objDownloadData.Is_Chemist_Data_Downloaded = 0
            objDownloadData.Is_SFC_Data_Downloaded = 0
            objDownloadData.Is_CP_Data_Downloaded = 0
            objDownloadData.Is_All_Data_Downloaded = 0
            objDownloadData.Download_DateTime = currentTime
            
            //DBHelper.sharedInstance.updateAccompanistDownloadStatusToError(userCode: objAccompanist.User_Code, regionCode:objAccompanist.Region_Code)
            
            DBHelper.sharedInstance.insertAccompanistDataDownloaDetails(objAccompanistDataDownload: objDownloadData)
        }
        
        DCRModel.sharedInstance.accompanistDownloadRequestId = requestId
    }
    
    func endAccomapnistDataDownload()
    {
        updateAllDataDownloaded()
        
        BL_Version_Upgrade.sharedInstance.updateAllVersionUpgradeAsCompleted()
        BL_InitialSetup.sharedInstance.doInitialSetUp()
    }
    
    func getCustomerData(isCalledFromMasterDataDownload: Bool, completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        WebServiceHelper.sharedInstance.getAccompanistCustomerData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                _ = self.getCustomerDataCallBack(isCalledFromMasterDataDownload: isCalledFromMasterDataDownload, apiResponseObj: apiResponseObj)
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getTPCustomerData(regionCodeArr: [String], completion: @escaping (Int) -> ())
       {
           WebServiceHelper.sharedInstance.getAccompanistCustomerData(accompanistRegionCodeArray: regionCodeArr) { (apiResponseObj) in
               if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
               {
                _ = self.getTPCustomerDataCallBack(regionCodeArr: regionCodeArr, apiResponseObj: apiResponseObj)
                   completion(SERVER_SUCCESS_CODE)
               }
               else
               {
                   completion(apiResponseObj.Status)
               }
           }
       }
    
    func getAccDetailedProductData(completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        let apiName: String = ApiName.DetailProdcutMaster.rawValue
        WebServiceHelper.sharedInstance.getAccompanistDetailedProductData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                if apiResponseObj.list.count > 0
                {
                    DBHelper.sharedInstance.deleteFromTable(tableName: MST_DETAIL_PRODUCTS)
                    
                    if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                    {
                        DBHelper.sharedInstance.insertDetailProductMaster(array: apiResponseObj.list)
                    }
                    
                    BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName.ProductData.rawValue)
                    
                }
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getSFCData(isCalledFromMasterDataDownload: Bool, completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        WebServiceHelper.sharedInstance.getAccompanistSFCData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                _ = self.getSFCDataCallBack(isCalledFromMasterDataDownload: isCalledFromMasterDataDownload, apiResponseObj: apiResponseObj)
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getCampaignPlannerHeader(isCalledFromMasterDataDownload: Bool, completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        WebServiceHelper.sharedInstance.getAccompanistCPHeaderData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                _ = self.getCampaignPlannerHeaderCallBack(isCalledFromMasterDataDownload: isCalledFromMasterDataDownload, apiResponseObj: apiResponseObj)
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getCampaignPlannerSFC(isCalledFromMasterDataDownload: Bool, completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        WebServiceHelper.sharedInstance.getAccompanistCPSFCData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                _ = self.getCampaignPlannerSFCCallBack(isCalledFromMasterDataDownload: isCalledFromMasterDataDownload, apiResponseObj: apiResponseObj)
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getCampaignPlannerDoctor(isCalledFromMasterDataDownload: Bool, completion: @escaping (Int) -> ())
    {
        let regionCodes = getAccompanistRegionCodes()
        
        WebServiceHelper.sharedInstance.getAccompanistCPDoctorData(accompanistRegionCodeArray: regionCodes) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                _ = self.getCampaignPlannerDoctorCallBack(isCalledFromMasterDataDownload: isCalledFromMasterDataDownload, apiResponseObj: apiResponseObj)
                completion(SERVER_SUCCESS_CODE)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func getAccompanistDataDownloadedUserCount() -> Int
    {
        let accompanistDataDownloadList = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
       
        return accompanistDataDownloadList.count
    }
    
    func getAccompanistDataDownloadedRegions() -> [UserMasterModel]
    {
        let accompanistDataDownloadedList = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
        let accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        var userMasterList: [UserMasterModel] = []
        
        if (accompanistDataDownloadedList.count > 0)
        {
            if (accompanistMasterList != nil)
            {
                for objAccDownload in accompanistDataDownloadedList
                {
                    let filteredArray = accompanistMasterList.filter{
                        $0.Region_Code == objAccDownload.Region_Code && $0.User_Code == objAccDownload.User_Code
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        let objUserMaster: UserMasterModel = UserMasterModel()
                        let objAcc: AccompanistModel = filteredArray[0]
                        
                        objUserMaster.Employee_name = objAcc.Employee_name
                        objUserMaster.User_Name = objAcc.User_Name
                        objUserMaster.Region_Name = objAcc.Region_Name
                        objUserMaster.User_Type_Name = objAcc.User_Type_Name
                        objUserMaster.User_Code = objAcc.User_Code
                        objUserMaster.Region_Code = objAcc.Region_Code
                        objUserMaster.Division_Name = objAcc.Division_Name
                        
                        userMasterList.append(objUserMaster)
                    }
                }
            }
        }
        
        return userMasterList
    }
    
    func deleteAccompanistData(regionCode: String, userCode: String)
    {
        let regCodes: String = "'" + regionCode + "'"
        
        deleteCustomerMasterData(regionCodes: regCodes)
        deleteSFCMasterData(regionCodes: regCodes)
        deleteCPData(regionCodes: regCodes)
        
        DBHelper.sharedInstance.deleteCustomerAddress(regionCodes: regCodes)
        DBHelper.sharedInstance.deleteAccompanistDownloadDetails(regionCode: regionCode, userCode: userCode)
    }
    
    func getLastDownloadedUsers() -> [UserMasterModel]
    {
        let accompanistList = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
        var userMasterList: [UserMasterModel] = []
        
        if (accompanistList.count > 0)
        {
            for objAccDownload in accompanistList
            {
                let accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
                
                let filteredArray = accompanistMasterList.filter{
                    $0.Region_Code == objAccDownload.Region_Code && $0.User_Code == objAccDownload.User_Code
                }
                
                if (filteredArray.count > 0)
                {
                    let objUserMaster: UserMasterModel = UserMasterModel()
                    let objAcc: AccompanistModel = filteredArray[0]
                    
                    objUserMaster.Employee_name = objAcc.Employee_name
                    objUserMaster.User_Name = objAcc.User_Name
                    objUserMaster.Region_Name = objAcc.Region_Name
                    objUserMaster.User_Type_Name = objAcc.User_Type_Name
                    objUserMaster.User_Code = objAcc.User_Code
                    objUserMaster.Region_Code = objAcc.Region_Code
                    objUserMaster.Division_Name = objAcc.Division_Name
                    
                    userMasterList.append(objUserMaster)
                }
            }
        }
        
        return userMasterList
    }
    
    func beginDownloadFromMasterDataDownload()
    {
        let userMasterList = getLastDownloadedUsers()
        
        beginAccompanistDataDownload(selectedAccompanists: userMasterList)
    }
    
    // MARK:- Private Functions
    private func getNextRequestId() -> Int
    {
        var requestId = DBHelper.sharedInstance.getAccompanistDownloadMaxRequestId()
        
        if (requestId == nil)
        {
            requestId = 0
        }
        
        requestId! += 1
        
        return requestId!
    }
    
    private func getCurrentRequestId() -> Int
    {
        if (DCRModel.sharedInstance.accompanistDownloadRequestId != nil)
        {
            return DCRModel.sharedInstance.accompanistDownloadRequestId
        }
        else
        {
            return -1
        }
    }
    
    private func getShowAccompanistDataPrivilegeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA)
    }
    
    private func deleteAccompanistDataDownload()
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS)
    }
    
    private func updatePMDAccompanistCompleted()
    {
        DBHelper.sharedInstance.updatePMDAccompanistCompleted()
    }
    
    private func getAccompanistRegionCodes() -> [String]
    {
        var regionCodeArray: [String] = []
        let userDetails = DBHelper.sharedInstance.AccompanistDownloadUserDetails(requestId: getCurrentRequestId())
        
        for accompObj in userDetails
        {
            regionCodeArray.append(accompObj.Region_Code)
        }
        
        return regionCodeArray
    }
    
    private func getRegionCodeString() -> String
    {
        var regionCodes: String = EMPTY
        let regionCodeArray = getAccompanistRegionCodes()
        
        for regCode in regionCodeArray
        {
            regionCodes = regionCodes + "'" + regCode + "',"
        }
        
        if (regionCodes != EMPTY)
        {
            regionCodes = regionCodes.substring(to: regionCodes.index(before: regionCodes.endIndex))
        }
        
        return regionCodes
    }
    
    func getRegionCodeStringWithOutQuotes() -> String
    {
        var regionCodes: String = EMPTY
        let userMasterList = getLastDownloadedUsers()
        
        for regCode in userMasterList
        {
            regionCodes = regionCodes + "" + regCode.Region_Code + ","
        }
        
        if (regionCodes != EMPTY)
        {
            regionCodes = regionCodes.substring(to: regionCodes.index(before: regionCodes.endIndex))
        }
        
        return regionCodes
    }
    
    private func cpCodesInRegions(regionCodes: String) -> String
    {
        var cpCodes: String = EMPTY
        let cpHeaderList = DBHelper.sharedInstance.getCPHeaderByRegionCodes(regionCodes: regionCodes)
        
        if (cpHeaderList != nil)
        {
            for objCPHeader in cpHeaderList!
            {
                cpCodes = cpCodes + "'" + objCPHeader.CP_Code + "',"
            }
            
            if (cpCodes != EMPTY)
            {
                cpCodes = cpCodes.substring(to: cpCodes.index(before: cpCodes.endIndex))
            }
        }
        
        return cpCodes
    }
    
    private func updateCustomerDataCompleted()
    {
        let requestId = getCurrentRequestId()
        
        DBHelper.sharedInstance.updateAccompanistDoctorDataDownloaded(requestId: requestId)
        DBHelper.sharedInstance.updateAccompanistChemistDataDownloaded(requestId: requestId)
    }
    
    private func updateSFCDataCompleted()
    {
        DBHelper.sharedInstance.updateAccompanistSFCDataDownloaded(requestId: getCurrentRequestId())
    }
    
    private func updateCPDataDownloaded()
    {
        DBHelper.sharedInstance.updateAccompanistCPDataDownloaded(requestId: getCurrentRequestId())
    }
    
    private func updateAllDataDownloaded()
    {
        updateCPId()
        updateCustomerDataCompleted()
        updateSFCDataCompleted()
        updateCPDataDownloaded()
        
        DBHelper.sharedInstance.updateAccompanistAllDataDownloaded(requestId: getCurrentRequestId())
        
        DBHelper.sharedInstance.updatePMDAccompanistCompleted()
    }
    
    private func deleteCustomerMasterData(regionCodes: String)
    {
        DBHelper.sharedInstance.deleteCustomerMasterData(regionCodes: regionCodes)
    }
    
    private func deleteSFCMasterData(regionCodes: String)
    {
        DBHelper.sharedInstance.deleteSFCMasterData(regionCodes: regionCodes)
    }
    
    private func deleteCPData(regionCodes: String)
    {
        let cpCodes = cpCodesInRegions(regionCodes: regionCodes)
        
        DBHelper.sharedInstance.deleteCPDoctors(cpCodes: cpCodes)
        DBHelper.sharedInstance.deleteCPSFC(cpCodes: cpCodes)
        DBHelper.sharedInstance.deleteCPHeader(cpCodes: cpCodes)
    }
    
    private func getCustomerDataCallBack(isCalledFromMasterDataDownload: Bool, apiResponseObj: ApiResponseModel) -> Bool
    {
        let regionCodes = getRegionCodeString()
        
        deleteCustomerMasterData(regionCodes: regionCodes)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCustomerMaster(array: apiResponseObj.list)
        }
        
        if (!isCalledFromMasterDataDownload)
        {
            updateCustomerDataCompleted()
        }
        
        return true
    }
    
    private func getTPCustomerDataCallBack(regionCodeArr: [String], apiResponseObj: ApiResponseModel) -> Bool
    {
        var regionCodes: String = EMPTY
        let regionCodeArray = regionCodeArr
        
        for regCode in regionCodeArray
        {
            regionCodes = regionCodes + "'" + regCode + "',"
        }
        
        if (regionCodes != EMPTY)
        {
            regionCodes = regionCodes.substring(to: regionCodes.index(before: regionCodes.endIndex))
        }
        
        deleteCustomerMasterData(regionCodes: regionCodes)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCustomerMaster(array: apiResponseObj.list)
        }
        return true
    }
    
    
    
    
    
    
    
    private func getSFCDataCallBack(isCalledFromMasterDataDownload: Bool, apiResponseObj: ApiResponseModel) -> Bool
    {
        let regionCodes = getRegionCodeString()
        
        deleteSFCMasterData(regionCodes: regionCodes)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertSFCMaster(array: apiResponseObj.list)
        }
        
        if (!isCalledFromMasterDataDownload)
        {
            updateSFCDataCompleted()
        }
        
        return true
    }
    
    private func getCampaignPlannerHeaderCallBack(isCalledFromMasterDataDownload: Bool, apiResponseObj: ApiResponseModel) -> Bool
    {
        let regionCodes = getRegionCodeString()
        
        deleteCPData(regionCodes: regionCodes)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCampaignPlannerHeader(array: apiResponseObj.list)
        }
        
        return true
    }
    
    private func getCampaignPlannerSFCCallBack(isCalledFromMasterDataDownload: Bool, apiResponseObj: ApiResponseModel) -> Bool
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCampaignPlannerSFC(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPSFC()
        
        return true
    }
    
    private func getCampaignPlannerDoctorCallBack(isCalledFromMasterDataDownload: Bool, apiResponseObj: ApiResponseModel) -> Bool
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
             DBHelper.sharedInstance.insertCampaignPlannerDoctors(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPDoctor()
        
        if (!isCalledFromMasterDataDownload)
        {
            updateCPDataDownloaded()
        }
        
        return true
    }
    
    private func updateCPId()
    {
        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPSFC()
        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPDoctor()
        BL_PrepareMyDevice.sharedInstance.updateCPIdInTPHeader()
        BL_PrepareMyDevice.sharedInstance.updateCPIdInDCRHeader()
    }
}
