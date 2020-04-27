//
//  BL_MasterDataDownload.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_MasterDataDownload: NSObject
{
    static let sharedInstance = BL_MasterDataDownload()
    var autoDownload: Bool = false
    let objBL_PMD = BL_PrepareMyDevice()
    let objBL_PMD_Accompanist = BL_PrepareMyDeviceAccompanist()
    var onBoarCompleted = Bool()
    
    func masterDataDownloadTime() -> [ApiDownloadDetailModel]?
    {
        return DBHelper.sharedInstance.getMasterDataDownloadTime()
    }
    func downloadhourlyreport() -> [HourlyReportModel]?
    {
        return DBHelper.sharedInstance.getHourlyreportdata()
    }
    func downloadSystemSettings(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getUserPrivileges(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD.getCompanyConfigSettings(masterDataGroupName: masterDataGroupName) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.objBL_PMD.getLeaveTypeMaster(masterDataGroupName: masterDataGroupName) { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                self.objBL_PMD.getProjectActivityMaster(masterDataGroupName: masterDataGroupName) { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        self.objBL_PMD.getUserModuleAccess(masterDataGroupName: masterDataGroupName, completion: { (status) in
                                            completion(status)
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                }
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadHolidayData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getHolidayMaster(masterDataGroupName: masterDataGroupName) { (status) in
            completion(status)
        }
    }
    
    func downloadCustomerData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD_Accompanist.beginDownloadFromMasterDataDownload()
        
        objBL_PMD.getCustomerData(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD.getSpecialties(masterDataGroupName: masterDataGroupName) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.objBL_PMD_Accompanist.getCustomerData(isCalledFromMasterDataDownload: true, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                                    if status == SERVER_SUCCESS_CODE
                                    {
                                        BL_PrepareMyDevice.sharedInstance.getMCDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY) { (status) in
                                            if status == SERVER_SUCCESS_CODE
                                            {
                                                BL_Geo_Location.sharedInstance.uploadCustomerAddress(completion: { (status) in
                                                    if (status == SERVER_SUCCESS_CODE)
                                                    {
                                                        BL_PrepareMyDevice.sharedInstance.getCustomerAddress(masterDataGroupName: masterDataGroupName, selectedRegionCode: EMPTY, completion: { (status) in
                                                            if (status == SERVER_SUCCESS_CODE)
                                                            {
                                                                BL_PrepareMyDevice.sharedInstance.getCallActivityAndMCActivity(completion: { (status) in
                                                                    if (status == SERVER_SUCCESS_CODE)
                                                                    {
                                                                        BL_PrepareMyDevice.sharedInstance.getDivisionMappingDetails(masterDataGroupName: masterDataGroupName, completion: { (status) in
                                                                            if (status == SERVER_SUCCESS_CODE)
                                                                            {
                                                                                BL_PrepareMyDevice.sharedInstance.getAllMCDetails(masterDataGroupName: masterDataGroupName) {(status) in
                                                                                    
                                                                                    if status == 1
                                                                                    {
                                                                                        self.objBL_PMD_Accompanist.endAccomapnistDataDownload()
                                                                                        completion(status)
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        completion(status)
                                                                                    }
                                                                                }
                                                                            }
                                                                            else
                                                                            {
                                                                                completion(status)
                                                                            }
                                                                        })
                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        completion(status)
                                                                    }
                                                                    
                                                                    
                                                                })
                                                            }
                                                            else
                                                            {
                                                                completion(status)
                                                            }
                                                        })
                                                    }
                                                    else
                                                    {
                                                        completion(status)
                                                    }
                                                })
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        }
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                            
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadExpenseData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getWorkCategories(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD.getTravelModeMaster(masterDataGroupName: masterDataGroupName) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.objBL_PMD.getDFCMaster(masterDataGroupName: masterDataGroupName) { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                self.objBL_PMD.getExpenseGroupMapping(masterDataGroupName: masterDataGroupName) { (status) in
                                    BL_PrepareMyDevice.sharedInstance.updateCategoryNameInDFC()
                                    completion(status)
                                }
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadProductData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getUserProductMapping(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD.getDetailProdcutMaster(masterDataGroupName: masterDataGroupName) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        //                        self.objBL_PMD.getUserProductMapping(masterDataGroupName: masterDataGroupName) { (status) in
                        //                            if(status == SERVER_SUCCESS_CODE)
                        //                            {
                        BL_PrepareMyDevice.sharedInstance.getAllCompetitorProducts(completion: { (status) in
                            if(status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDevice.sharedInstance.getAllProductsCompetitor(completion: { (status) in
                                    if(status == SERVER_SUCCESS_CODE)
                                    {
                                        BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                                        
                                BL_PrepareMyDeviceAccompanist.sharedInstance.getAccDetailedProductData(completion: { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                BL_DCR_Refresh.sharedInstance.updateProductCurrentStock()
                                                completion(status)
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                        //                            }
                        //                            else
                        //                            {
                        //                                completion(status)
                        //                            }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadCPTPData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getCampaignPlannerHeader(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD.getCampaignPlannerSFC(masterDataGroupName: masterDataGroupName) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.objBL_PMD.getCampaignPlannerDoctors(masterDataGroupName: masterDataGroupName) { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                self.objBL_PMD_Accompanist.beginDownloadFromMasterDataDownload()
                                
                                self.objBL_PMD_Accompanist.getCampaignPlannerHeader(isCalledFromMasterDataDownload: true, completion: { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        self.objBL_PMD_Accompanist.getCampaignPlannerSFC(isCalledFromMasterDataDownload: true, completion: { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                self.objBL_PMD_Accompanist.getCampaignPlannerDoctor(isCalledFromMasterDataDownload: true, completion: { (status) in
                                                    self.objBL_PMD_Accompanist.endAccomapnistDataDownload()
                                                    completion(status)
                                                })
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadSFCAndAccompanistData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getSFCData(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD_Accompanist.beginDownloadFromMasterDataDownload()
                
                self.objBL_PMD_Accompanist.getSFCData(isCalledFromMasterDataDownload: true, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDeviceAccompanist.sharedInstance.getAccDetailedProductData(completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                                    
                                    BL_PrepareMyDeviceAccompanist.sharedInstance.getAccDetailedProductData(completion: { (status) in
                                        if (status == SERVER_SUCCESS_CODE)
                                        {
                                            self.objBL_PMD.getAccompanists(masterDataGroupName: masterDataGroupName) { (status) in
                                                if (status == SERVER_SUCCESS_CODE)
                                                {
                                                    self.objBL_PMD_Accompanist.endAccomapnistDataDownload()
                                                    completion(status)
                                                }
                                                else
                                                {
                                                    completion(status)
                                                }
                                            }
                                        }
                                        else
                                        {
                                            completion(status)
                                        }
                                    })
                            }
                            else
                            {
                               completion(status)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func downloadSFCData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getSFCData(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.objBL_PMD_Accompanist.beginDownloadFromMasterDataDownload()
                
                self.objBL_PMD_Accompanist.getSFCData(isCalledFromMasterDataDownload: true, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.objBL_PMD_Accompanist.endAccomapnistDataDownload()
                        
                        completion(status)
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func getUserTypeMenuAccess(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getUserTypeMenuAccess(masterDataGroupName: masterDataGroupName) { (status) in
           completion(status)
        }
    }
    
    func getDigitalAssetsData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        objBL_PMD.getAssetHeaderDetails(masterDataGroupName: masterDataGroupName) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.objBL_PMD.getAssetTagDetails(masterDataGroupName: masterDataGroupName) { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        BL_PrepareMyDevice.sharedInstance.getAssetProductMapping(masterDataGroupName: masterDataGroupName, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                
                                completion(status)
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                        
                        completion(status)
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func getStoryData(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
        {
            objBL_PMD.getStoryDetails(masterDataGroupName: masterDataGroupName) { (status) in
                
                if status == SERVER_SUCCESS_CODE
                {
                    //BL_AssetModel.sharedInstance.assignAllPlayListToShowList()
                    completion(status)
                }
                else
                {
                    completion(status)
                }
            }
        }
        else
        {
            completion(SERVER_SUCCESS_CODE)
        }
    }
    
    func dowloadAllData(masterDataGroupName1: String, completion: @escaping (Int) -> ())
    {
        self.downloadSystemSettings(masterDataGroupName: masterDataGroupName.SystemSettings.rawValue) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.downloadHolidayData(masterDataGroupName: masterDataGroupName.HolidayData.rawValue) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.downloadCustomerData(masterDataGroupName: masterDataGroupName.DoctorData.rawValue) { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                self.downloadExpenseData(masterDataGroupName: masterDataGroupName.ExpenseData.rawValue) { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        self.downloadProductData(masterDataGroupName: masterDataGroupName.ProductData.rawValue) { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                self.downloadCPTPData(masterDataGroupName: masterDataGroupName.CpTpDetails.rawValue) { (status) in
                                                    if (status == SERVER_SUCCESS_CODE)
                                                    {
                                                        self.downloadSFCAndAccompanistData(masterDataGroupName: masterDataGroupName.SFCAccompanistData.rawValue) { (status) in
                                                            if (status == SERVER_SUCCESS_CODE)
                                                            {
                                                                self.getDigitalAssetsData(masterDataGroupName: masterDataGroupName.DigitalAssets.rawValue) { (status) in
                                                                    if (status == SERVER_SUCCESS_CODE)
                                                                    {
                                                                        self.allDataContd(masterDataGroupName: masterDataGroupName.MenuData.rawValue, completion: { (status) in
                                                                            
                                                                            
                                                                            
                                                                            
                                                                            completion(status)
                                                                        })
                                                                    }
                                                                    else
                                                                    {
                                                                        completion(status)
                                                                    }
                                                                }
                                                            }
                                                            else
                                                            {
                                                                completion(status)
                                                            }
                                                        }
                                                    }
                                                    else
                                                    {
                                                        completion(status)
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        }
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                }
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    private func allDataContd(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        self.getStoryData(masterDataGroupName: masterDataGroupName) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.getUserTypeMenuAccess(masterDataGroupName: masterDataGroupName, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPSFC()
                        BL_PrepareMyDevice.sharedInstance.updateCPIdInCPDoctor()
                        BL_PrepareMyDevice.sharedInstance.getProspectDetail()
                        self.updateMasterDataDownloadedAlert(completion: { (status) in
                            completion(status)
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func getCurrentDate() -> String
    {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateformatter.string(from: date)
        return dateString
    }
    
    func insertCurrentDateMasterDataDownloadCheckAPIStatus()
    {
        let dict:NSDictionary = ["API_Check_Date":getCurrentDate(),"Skip_Count":0,"Completed_Status":1]
        let masterDataCheckObj = MasterDataDownloadCheckModel(dict: dict)
        DBHelper.sharedInstance.insertMasterDataDownloadCheckStatus(objMasterData: masterDataCheckObj)
    }
    
    func updateSkipCountMasterDataDownloadCheck()
    {
        let skipcount: Int = self.getSkipCountForMasterDataDownloadAlert() + 1
        DBHelper.sharedInstance.updateSkipCountMasterDataDownloadCheck(currentDate: getCurrentDate(), skipCount: skipcount)
    }
    
    func updateCompletedStatusMasterDataDownloadCheck(completedStatus: Int)
    {
//        if self.getMasterDataDownloadCheckList().count > 0
//        {
//            DBHelper.sharedInstance.updateCompletedStatusMasterDataDownloadCheck(currentDate: getCurrentDate(), completedStatus: completedStatus)
//        }
//        else
//        {
            let dict:NSDictionary = ["API_Check_Date":getCurrentDate(),"Skip_Count":0,"Completed_Status":1]
            let masterDataCheckObj = MasterDataDownloadCheckModel(dict: dict)
            DBHelper.sharedInstance.insertMasterDataDownloadCheckStatus(objMasterData: masterDataCheckObj)
       // }
    }
    
    func getMasterDataDownloadCheckList() -> [MasterDataDownloadCheckModel]
    {
        return DBHelper.sharedInstance.getMasterDataDownloadCheckList(currentDate: getCurrentDate())
    }
    
    func getMasterDataDownloadList() -> [MasterDataDownloadCheckModel]
    {
        return DBHelper.sharedInstance.getMasterDataDownloadCheckList()
    }
    
    func toMakeMasterDataDownloadCheckAPICall() -> Bool
    {
        var makeAPICall : Bool = true
        if self.getMasterDataDownloadList().count > 0
        {
            let mstobj = self.getMasterDataDownloadCheckList()[0]
            if mstobj.Completed_Status == 1
            {
                makeAPICall = false
            }
        }
        return makeAPICall
    }
    
    func getMasterDataDownloadAlert(completion: @escaping (_ Status: Int) -> ())
    {
        WebServiceHelper.sharedInstance.getMasterDataDownloadAlert ()
            { (apiResponseObj) in
                let statusCode = apiResponseObj.Status
                
                if (statusCode == SERVER_SUCCESS_CODE)
                {
                    if apiResponseObj.Count > 0
                    {
                        completion(SERVER_SUCCESS_CODE)
                    }
                    else
                    {
                        BL_MasterDataDownload.sharedInstance.updateCompletedStatusMasterDataDownloadCheck(completedStatus: 1)
                        completion(2)
                    }
                }
                else
                {
                    completion(SERVER_ERROR_CODE)
                }
        }
    }
    
    func getMasterDataDownloadAlertMessage(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getMasterDataDownloadAlertMessage ()
            { (apiResponseObj) in
               completion(apiResponseObj)
        }
    }
    
    func updateMasterDataDownloadedAlert(completion: @escaping (_ Status: Int) -> ())
    {
        if self.checkforCompletedStatusInMasterDownloadAlert() == false
        {
            WebServiceHelper.sharedInstance.updateMasterDataDownloadedAlert()
                { (apiResponseObj) in
                    let statusCode = apiResponseObj.Status
                    
                    if (statusCode == SERVER_SUCCESS_CODE)
                    {
                        BL_MasterDataDownload.sharedInstance.updateCompletedStatusMasterDataDownloadCheck(completedStatus: 1)
                    }
                completion(apiResponseObj.Status)
            }
        }
        else
        {
            completion(SERVER_SUCCESS_CODE)
        }
    }
    
    func getMasterDataDownloadAlertMaxSkipConfigValue() -> Int
    {
        var configValue = 0
        let derivedValue =  checkNullAndNilValueForString(stringData: PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.MASTER_DATA_DOWNLOAD_ALERT_MAX_SKIP))
        if derivedValue != EMPTY
        {
            configValue = Int(derivedValue)!
        }
        return configValue
    }
    
    func getSkipCountForMasterDataDownloadAlert() -> Int
    {
        var count = 0
        if self.getMasterDataDownloadCheckList().count > 0
        {
            let objMaster = self.getMasterDataDownloadCheckList()[0]
            count = objMaster.Skip_Count
        }
        return count
    }
    
    func showSkipButtonInMasterDataDownload() -> Bool
    {
        var show : Bool = true
        if getMasterDataDownloadAlertMaxSkipConfigValue() != 0
        {
            if (getSkipCountForMasterDataDownloadAlert() == self.getMasterDataDownloadAlertMaxSkipConfigValue()) || (getSkipCountForMasterDataDownloadAlert() > self.getMasterDataDownloadAlertMaxSkipConfigValue())
            {
                show = false
            }
        }
        else if getMasterDataDownloadAlertMaxSkipConfigValue() == 0
        {
            show = false
        }
        return show
    }
    
    func checkforCompletedStatusInMasterDownloadAlert() -> Bool
    {
        var completed: Bool = false
        
        if self.getMasterDataDownloadCheckList().count > 0
        {
            let objMaster = self.getMasterDataDownloadCheckList()[0]
            if objMaster.Completed_Status == 1
            {
                completed = true
            }
        }
        return completed
    }
}


