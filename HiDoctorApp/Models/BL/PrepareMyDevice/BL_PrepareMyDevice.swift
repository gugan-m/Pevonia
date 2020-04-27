//
//  BL_PrepareMyDevice.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_PrepareMyDevice: NSObject
{
    static let sharedInstance = BL_PrepareMyDevice()
    var accompanistList : [UserMasterModel] = []
    /*
     During Prepare my device, the API must be called in the following getTourPlannerHeader
     
     getUserPrivileges
     getCompanyConfigSettings
     getAccompanists
     getWorkCategories
     getSpecialties
     getLeaveTypeMaster
     getTravelModeMaster
     getExpenseGroupMapping
     getProjectActivityMaster
     getDetailProdcutMaster
     getUserProductMapping
     getDFCMaster
     getSFCData
     getCustomerData
     getCampaignPlannerHeader
     getCampaignPlannerSFC
     getCampaignPlannerDoctors
     getTourPlannerHeader
     getTourPlannerSFC
     getTourPlannerDoctor
     getTourPlannerAccompanist
     getTourPlannerProduct
     getDCRCalendarDetails
     getDCRHeaderDetails
     getDCRTravelledPlacesDetails
     getDCRAccompanistDetails
     getDCRDoctorVistiDetails
     getDCRSampleDetails
     getDCRDetailedProducts
     getDCRChemistVisitDetails
     getDCRRCPADetails
     getDCRStockistVisitDetails
     getDCRExpenseDetails
     getHolidayMaster
     */
    
    var currentPageIndex: Int = 0
    var totalPages: Int = 0
    var regionCodes: String = EMPTY
    var blist : [BStatusPotential] = [BStatusPotential]()
    var alist : [BStatusPotential] = [BStatusPotential]()
    
    
    // MARK:- Public Functions
    func getLastIncompleteApiDetails() -> String?
    {
        var apiName: String?
        
        let apiDownloadObj = DBHelper.sharedInstance.getLastIncompleteApiDetails()
        
        if (apiDownloadObj != nil)
        {
            apiName = apiDownloadObj?.Api_Name
        }
        
        return apiName
    }
    
    func startPrepareMyDevice()
    {
        deleteAllApiDownloadDetails()
    }
    
    func endPrepareMyDevice()
    {
        updateDCRIdsForNewlyDownloadedDCRs()
        //deleteAllApiDownloadDetails()
        updatePrepareMyDeviceCompleted()
    }
    
    func getErrorMessageForStatus(statusCode: Int, dataName: String) -> String
    {
        if (statusCode == 1)
        {
            return successTitle
        }
        else if (statusCode == 2)
        {
            return "No internet connection"
        }
        else if (statusCode == 3)
        {
            return "Sever error while downloading \(dataName). Please try again"
        }
        else if (statusCode == 4)
        {
            return "Unable to process \(dataName) data. Please try again"
        }
        else
        {
            return ""
        }
    }
    
    func getUserPrivileges(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.UserPrivileges.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getUserPrivileges { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getUserPrivilegesCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCompanyConfigSettings(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.companyConfiguration.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCompanyConfigSettings { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCompanyConfigSettingsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getUserModuleAccess(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.UserModuleAccess.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getUserModuleAccess { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getUserModuleAccessCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getWorkCategories(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.WorkCategories.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getWorkCategories { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getWorkCategoriesCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getSpecialties(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.Specialties.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getSpecialties { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getSpecialtiesCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getLeaveTypeMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.LeaveTypeMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getLeaveTypeMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getLeaveTypeMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTravelModeMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TravelModeMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTravelModeMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTravelModeMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getProjectActivityMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.ProjectActivityMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getProjectActivityMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getProjectActivityMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDetailProdcutMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DetailProdcutMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDetailedProductMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDetailProductMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCampaignPlannerHeader(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CampaignPlannerHeader.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCampaignPlannerHeader { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCampaignPlannerHeadeCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCampaignPlannerSFC(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CampaignPlannerSFC.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCampaignPlannerSFC { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCampaignPlannerSFCCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCampaignPlannerDoctors(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CampaignPlannerDoctors.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCampaignPlannerDoctors { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCampaignPlannerDoctorsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getExpenseGroupMapping(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.ExpenseGroupMapping.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getExpenseGroupMapping { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getExpenseGroupMappingCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerHeader(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerHeader.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerHeader (postData: getTourPlannerPostData()){ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerHeaderCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerSFC(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerSFC.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerSFC (postData: getTourPlannerPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerSFCCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerDoctor(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerDoctor.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData: getTourPlannerPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerDoctorCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerAccompanist(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerAccompanist.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerAccompanist (postData: getTourPlannerPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerAccompanistCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerProduct(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerProduct.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerProduct(postData: getTourPlannerPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerProductCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getTourPlannerUnfreezeDates(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerUnfreezeDate.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerUnfreezeDates(postData: getTourPlannerPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerUnfreezeDatesCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDFCMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DFCMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDFCMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDFCMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getUserProductMapping(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.UserProductMapping.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getUserProductMapping { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getUserProductMappingCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getAccompanists(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.Accompanists.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAccompanists { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAccompanistsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRCalendarDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRCalendarDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRCalendarDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRCalendarCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRLockDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRLockDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRLockLeaves { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRLockDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRHeaderDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRHeaderDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRHeaderDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRHeaderDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRTravelledPlacesDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRTravelledPlacesDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRTravelledPlacesDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRTravelledPlacesDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRAccompanistDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRAccompanistDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRAccompanistsDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                _ = self.getDCRAccompanistsDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                
                BL_DCR_Refresh.sharedInstance.getDCRAccompanistInheritance(refreshMode: DCRRefreshMode.EMPTY, endDate: EMPTY, completion: { (status) in
                    completion(status)
                })
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVistiDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRDoctorVisitDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitOrderDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitOrderDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        let postData = getOrderPostData()
        
        WebServiceHelper.sharedInstance.getDCRDoctorVisitOrderDetails(postData: postData) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitOrderDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRChemistVisitOrderDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRChemistVisitOrderDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        let postData = getOrderPostData()
        
        WebServiceHelper.sharedInstance.getDCRChemistVisitOrderDetails(postData: postData) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRChemistVisitOrderDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    
    func getDCRSampleDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRSampleDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRSampleDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRSampleDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDetailedProducts(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDetailedProducts.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRDetailedProducts { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDetailedProdutsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRChemistVisitDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRChemistVisitDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRChemistVisitDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRRCPADetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRRCPADetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRRCPADetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRRCPACallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRCustomerFollowUpDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRCustomerFollowUpDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        let postData = getFollowUpsPostData()
        WebServiceHelper.sharedInstance.getDCRCustomerFollowUpDetails(postData: postData) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRCustomerFollowUpDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRAttachmentDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRAttachmentDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        let postData = getDCRAttachmentPostData()
        WebServiceHelper.sharedInstance.getDCRAttachmentDetails(postData: postData) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRAttachmentDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRStockistVisitDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRStockistVisitDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRStockistVisitDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRStockistVisitCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRExpenseDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRExpenseDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRExpenseDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRExpenseDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRAttendanceActivities(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AttendanceActivities.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getDCRAttendanceActivities { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRAttendanceActivitiesCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getSFCData(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.SFCData.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getSFCData { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getSFCMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCustomerData(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CustomerData.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCustomerData { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCustomerMasterDataCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getHolidayMaster(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.HolidayMaster.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getHolidayMaster { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getHolidayMasterCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getCompetitorProducts(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CompetitorProducts.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getCompetitorProducts { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCompetitorProductCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorAccompanist(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorAccompanist.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        //        WebServiceHelper.sharedInstance.getDCRDoctorAccompanist { (apiResponseObj) in
        //            let statusCode = apiResponseObj.Status
        //
        //            if (statusCode == SERVER_SUCCESS_CODE)
        //            {
        //                let status = self.getDCRDoctorAccompanistCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
        //                completion(status)
        //            }
        //            else
        //            {
        //                completion(statusCode!)
        //            }
        //        }
        
        let postJsonString = getPostJsonString()
        
        WebServiceHelper.sharedInstance.getDCRDoctorAccompanistDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorAccompanistCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
            }
            
            completion(statusCode!)
        }
    }
    
    func getUserTypeMenuAccess(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.UserTypeMenuAccess.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getUserTypeMenuAccess { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getUserTypeMenuAccessCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    //MARK:- Edetailing
    
    func getAssetHeaderDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AssetMasterDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAssetHeaderDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAssetsHeaderCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getProspectDetail() {
        WebServiceHelper.sharedInstance.insertProspect {
            (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                if apiResponseObj.list.count > 0 {
                    executeQuery(query: "DELETE FROM \(TRAN_PROSPECTING)")
                    DBHelper.sharedInstance.insertProspect(dataArray: apiResponseObj.list)
                }
            }
        }
    }
    
    func getAssetAnalyticsDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AssetAnalyticsDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAssetAnalyticsDetails(postData: getAssetAnalyticsPostData()){ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAssetsAnalyticsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getAssetTagDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AssetTagDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAssetTagDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAssetsTagCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getStoryDetails(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.StoryDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAssetStoryDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if statusCode == SERVER_SUCCESS_CODE
            {
                let status = self.getStoryDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getAssetPartDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AssetsPartsDetails.rawValue
        
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAssetPartDetails { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAssetsPartsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getAssetProductMapping(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AssetProductMappingDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getEdetailingProductMappingData { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAssetProductMappingCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDoctorProductMapping(masterDataGroupName:String,selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        //        self.currentPageIndex = 0
        //        self.totalPages = 0
        //        self.regionCodes = EMPTY
        //
        //        let apiName: String = ApiName.DoctorProductMappingDetails.rawValue
        //        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        //
        //        self.getDoctorProductMappingPageInfo(masterDataGroupName: masterDataGroupName, selectedRegionCode: selectedRegionCode) { (status) in
        //            self.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        //            completion(status)
        //        }
        
        let apiName: String = ApiName.DoctorProductMappingDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        if (selectedRegionCode == EMPTY)
        {
            let accRegions = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
            self.regionCodes = getRegionCode() + ","
            
            for obj in accRegions
            {
                self.regionCodes += obj.Region_Code + ","
            }
        }
        else
        {
            self.regionCodes = selectedRegionCode + ","
        }
        
        //        self.regionCodes = String(self.regionCodes.dropLast())
        let dict:[String:Any] = ["Campaign_Code":"","CompanyCode":getCompanyCode(),"Current_Region_Code":self.regionCodes,"Customer_Code":"","Mapped_Region_Code":self.regionCodes,"Mapping_Type":"GEN_MAP","Mode":"DOCTOR_PRODUCT","Selected_Region_Code":self.regionCodes]
        WebServiceHelper.sharedInstance.getAllDoctorProductMapping(postData: dict, regionCodes: regionCodes) { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                let status = self.getAllDoctorProductMappingCallBack(apiResponseObj: objApiResponse, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
        }
    }
    
    func getAllMCDetails(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        
        let apiName: String = ApiName.AllMCDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getAllMCDetails{ (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                let status = self.getAllMCDetailsCallBack(apiResponseObj: objApiResponse, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
        }
        
    }
    
    func getDivisionMappingDetails(masterDataGroupName: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DivisionMappingDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.getDivisionMappingDetails{ (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                let status = self.getDivisionMappingDetailsCallBack(apiResponseObj: objApiResponse, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
        }
    }
    
    func getCustomerAddress(masterDataGroupName: String, selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        self.currentPageIndex = 0
        self.totalPages = 0
        self.regionCodes = EMPTY
        
        let apiName: String = ApiName.CustomerAddressDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        self.getCustomerAddressPageInfo(masterDataGroupName: masterDataGroupName, selectedRegionCode: selectedRegionCode) { (status) in
            self.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
            completion(status)
        }
    }
    
    //MARK:- ChemistDay
    func getDCRDoctorVisitChemistAccompanist(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitAPIGetDCRChemistAccompanist.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistAccompanist(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistAccompanistCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitChemistSamplePromotion(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitAPIGetDCRChemistSamplePromotion.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistSamplePromotion(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistSamplePromotionCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitChemistDetailedProductDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitAPIGetDCRChemistDetailedProductsDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistDetailedProductsDetails(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistDetailedProductDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitChemistRCPAOwnProductDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitAPIGetDCRChemistRCPAOwnProductDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistRCPAOwnProductDetails(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistRCPAOwnProductDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitChemistRCPACompetitorProductDetails(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRDoctorVisitAPIGetDCRChemistRCPACompetitorProductDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistRCPACompetitorProductDetails(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistRCPACompetitorProductDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    
    func getbussinessStatusPotential()
    {
        var regioncodearray: [String] = [""]
        accompanistList = BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedRegions()
        if(accompanistList.count > 0)
        {   regioncodearray.removeAll()
            for regioncode in accompanistList
            {
                regioncodearray.append(regioncode.Region_Code + ",")
            }
            regioncodearray.append(getRegionCode() + ",")
        }
        else
        {   regioncodearray.removeAll()
            regioncodearray.append(getRegionCode() + ",")
        }
        let dict = ["lstAccompanist": regioncodearray,"Request_Id":0] as [String : Any]
        WebServiceHelper.sharedInstance.getbusinessStatus(postData:dict) { (apiObj) in
            if(apiObj.Status == SERVER_SUCCESS_CODE)
            {
                var obj1: BussinessPotential!
                //var obj2: BussinessPotential!
                //let apilist: [BussinessPotential]
                let obj = apiObj.list[0] as! NSDictionary
                DBHelper.sharedInstance.deleteFromTable(tableName: BUSINESS_STATUS_POTENTIAL)
                //let apilist: [BussinessPotential] = ((apiObj.list[0]) as! NSDictionary).value(forKey: "lstBusinessStatusProduct") as! [BussinessPotential]
                //let Bstatus: [BussinessPotential] = ((apiObj.list[0]) as! NSDictionary).value(forKey: "lstBusinessStatusPrefillDoctor") as! [BussinessPotential]
                let lista =  obj.value(forKey: "lstBusinessStatusProduct") as! NSArray
                let listb = obj.value(forKey: "lstBusinessStatusPrefillDoctor") as! NSArray
                //  let potential = apilist.value(forKey: "lstBusinessStatusProduct") as! NSDictionary
                DBHelper.sharedInstance.insertBussinessP(array: listb)
                DBHelper.sharedInstance.insertBussinessP(array: lista)
                print("success")
            }
        }
    }
    
    func getDCRDoctorVisitChemistDayFollowups(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRChemistDayFollowups.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistDayFollowups(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistDayFollowupsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRDoctorVisitChemistDayAttachments(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.DCRChemistDayAttachments.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.postDCRChemistDayAttachments(postData: getChemistDayPostData()) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRDoctorVisitChemistDayAttachmentsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    
    
    func GetTPDoctorAttachments(masterDataGroupName:String,completion: @escaping (Int) -> ())
          {
              let apiName: String = ApiName.GetTPDoctorAttachments.rawValue
              
              BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
              let dict = [
               "TPStatus" : "ALL",
              "UserCode" : getUserCode(),
              "RegionCode" : getRegionCode(),
              "CompanyCode" : getCompanyCode()
              ]
              WebServiceHelper.sharedInstance.getTourPlannerDoctorAttachment(postData:dict ) { (apiResponseObj) in
                  let statusCode = apiResponseObj.Status
                  
                  if (statusCode == SERVER_SUCCESS_CODE)
                  {
                      let status = self.getTpDoctorAttachmentCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName)
                      completion(status)
                  }
                  else
                  {
                      completion(statusCode!)
                  }
              }
          }
    
    
    private func getTpDoctorAttachmentCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
       {
           if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
           {
               DBHelper.sharedInstance.insertTPAttachment(array: apiResponseObj.list)
           }
           
           BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
           
           return 1
       }
    
    
    
    
    // MARK:- Private Functions
    private func getDoctorProductMappingPageInfo(masterDataGroupName:String,selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        if (selectedRegionCode == EMPTY)
        {
            let accRegions = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
            self.regionCodes = getRegionCode() + ","
            
            for obj in accRegions
            {
                self.regionCodes += obj.Region_Code + ","
            }
        }
        else
        {
            self.regionCodes = selectedRegionCode + ","
        }
        
        //        self.regionCodes = String(self.regionCodes.dropLast())
        
        WebServiceHelper.sharedInstance.getDoctorProductMappingPageInfo(regionCodes: regionCodes) { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                if (objApiResponse.list.count > 0)
                {
                    guard let dict = objApiResponse.list.firstObject as? NSDictionary else
                    {
                        return
                    }
                    
                    self.totalPages = dict.value(forKey: "No_Of_Pages") as! Int
                    let totalRecords = dict.value(forKey: "Total_Records") as! Int
                    
                    var deleteRegionCodes: String = EMPTY
                    let regionCodeArray = self.regionCodes.components(separatedBy: ",")
                    
                    for regCode in regionCodeArray
                    {
                        if (regCode != EMPTY)
                        {
                            deleteRegionCodes += "'" + regCode + "',"
                        }
                    }
                    
                    if (deleteRegionCodes != EMPTY)
                    {
                        deleteRegionCodes = String(deleteRegionCodes.dropLast())
                    }
                    
                    DBHelper.sharedInstance.deleteProductMapping(regionCodes: deleteRegionCodes)
                    
                    if (totalRecords > 0)
                    {
                        let myGroup = DispatchGroup()
                        var statusCode: Int!
                        
                        for i in 1...self.totalPages
                        {
                            myGroup.enter()
                            self.currentPageIndex = i
                            
                            self.getDoctorProductMappingDetails(completion: { (status) in
                                statusCode = status
                                myGroup.leave()
                            })
                        }
                        
                        myGroup.notify(queue: .main) {
                            completion(statusCode)
                        }
                    }
                    else
                    {
                        completion(objApiResponse.Status)
                    }
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            else
            {
                completion(objApiResponse.Status)
            }
        }
    }
    
    private func getDoctorProductMappingDetails(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getDoctorProductMappingDetails(regionCodes: self.regionCodes, pageNo: self.currentPageIndex, completion: { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.insertDoctorProductMapping(array: objApiResponse.list)
            }
            completion(objApiResponse.Status)
        })
    }
    
    private func getMCDoctorProductMappingDetails(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getMCDoctorProductMappingDetails(regionCodes: self.regionCodes, pageNo: self.currentPageIndex, completion: { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.insertMCDoctorProductMapping(array: objApiResponse.list)
            }
            completion(objApiResponse.Status)
        })
    }
    
    private func getCustomerAddressPageInfo(masterDataGroupName:String, selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        self.regionCodes = EMPTY
        
        if (selectedRegionCode == EMPTY)
        {
            let accRegions = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
            self.regionCodes = getRegionCode() + ","
            
            for obj in accRegions
            {
                self.regionCodes += obj.Region_Code + ","
            }
        }
        else
        {
            let regionCodeArray = selectedRegionCode.components(separatedBy: ",")
            
            for regionCode in regionCodeArray
            {
                self.regionCodes += regionCode + ","
            }
        }
        
        let postData: [String: Any] = ["Region_Code": self.regionCodes]
        
        //        self.regionCodes = String(self.regionCodes.dropLast())
        
        WebServiceHelper.sharedInstance.getCustomerAddressCount(postData: postData) { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                if (objApiResponse.list.count > 0)
                {
                    guard let dict = objApiResponse.list.firstObject as? NSDictionary else
                    {
                        return
                    }
                    
                    self.totalPages = dict.value(forKey: "No_Of_Pages") as! Int
                    let totalRecords = dict.value(forKey: "Total_Records") as! Int
                    
                    var deleteRegionCodes: String = EMPTY
                    let regionCodeArray = self.regionCodes.components(separatedBy: ",")
                    
                    for regCode in regionCodeArray
                    {
                        if (regCode != EMPTY)
                        {
                            deleteRegionCodes += "'" + regCode + "',"
                        }
                    }
                    
                    if (deleteRegionCodes != EMPTY)
                    {
                        deleteRegionCodes = String(deleteRegionCodes.dropLast())
                    }
                    
                    DBHelper.sharedInstance.deleteCustomerAddress(regionCodes: deleteRegionCodes)
                    
                    DBHelper.sharedInstance.deleteHospitalAccountNumberInfo(regionCodes: deleteRegionCodes)
                    
                    if (totalRecords > 0)
                    {
                        let myGroup = DispatchGroup()
                        var statusCode: Int!
                        
                        for i in 1...self.totalPages
                        {
                            myGroup.enter()
                            self.currentPageIndex = i
                            
                            self.getCustomerAddressDetails(completion: { (status) in
                                statusCode = status
                                myGroup.leave()
                            })
                        }
                        
                        myGroup.notify(queue: .main) {
                            completion(statusCode)
                        }
                    }
                    else
                    {
                        completion(objApiResponse.Status)
                    }
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            else
            {
                completion(objApiResponse.Status)
            }
        }
    }
    
    private func getCustomerAddressDetails(completion: @escaping (Int) -> ())
    {
        let postData: [String: Any] = ["Region_Code": self.regionCodes, "PageNo": self.currentPageIndex]
        
        WebServiceHelper.sharedInstance.getCustomerAddressDetails(postData: postData, completion: { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                let insertList = self.prepareCustomerAddressData(list: objApiResponse.list)
                
                let accountNumberList = self.prepareAccountNumberData(responseList: objApiResponse.list)
                DBHelper.sharedInstance.insertCustomerAddress(array: insertList as NSArray)
               
                DBHelper.sharedInstance.insertHospitalAccountNumberData(array: accountNumberList as NSArray)

            }
            completion(objApiResponse.Status)
        })
    }
    func prepareAccountNumberData(responseList: NSArray) -> NSMutableArray
    {
        
        
        let accountNumberList: NSMutableArray = []
        
        for obj in responseList
        {
            let dict = obj as! NSDictionary
            var hospitalArray: NSArray = []
            
            if let array = dict.value(forKey: "lstHospitalInfo") as? NSArray
            {
                hospitalArray = array
            }
            
            if (hospitalArray.count > 0)
            {
//                let customerCode = hospitalArray.value(forKey: "Customer_Code") as? String
//                let regionCode = hospitalArray.value(forKey: "Region_Code") as? String
//                let hospitalName = hospitalArray.value(forKey: "Hospital_Name") as? String
               // let customerEntityType = dict.value(forKey: "CustomerEntityType") as? String
                
                for objAddress  in hospitalArray
                {
                    let addressDict = objAddress as! NSDictionary
                    let insertData: NSMutableDictionary = ["Customer_Code": (objAddress as! NSDictionary).value(forKey: "Customer_Code"), "Region_Code": (objAddress as! NSDictionary).value(forKey: "Region_Code"), "Hospital_Name": (objAddress as! NSDictionary).value(forKey: "Hospital_Name"), "Hospital_Address1": (objAddress as! NSDictionary).value(forKey: "Hospital_Address1"), "Hospital_Address2": (objAddress as! NSDictionary).value(forKey: "Hospital_Address2"), "Hospital_Local_Area": (objAddress as! NSDictionary).value(forKey: "Hospital_Local_Area"), "Hospital_City": (objAddress as! NSDictionary).value(forKey: "Hospital_City"), "Hospital_State": (objAddress as! NSDictionary).value(forKey: "Hospital_State"), "Hospital_Latitude": (objAddress as! NSDictionary).value(forKey: "Hospital_Latitude"), "Hospital_Longitude": (objAddress as! NSDictionary).value(forKey: "Hospital_Longitude"), "Hospital_Pincode": (objAddress as! NSDictionary).value(forKey: "Hospital_Pincode"), "Mapping_Status": (objAddress as! NSDictionary).value(forKey: "Mapping_Status"), "Hospital_Classification": (objAddress as! NSDictionary).value(forKey: "Hospital_Classification"), "Hospital_Account_Number": (objAddress as! NSDictionary).value(forKey: "Hospital_Account_Number")]
                    
                    
                    
                    insertData.addEntries(from: addressDict as! [AnyHashable : Any])
                    
                    accountNumberList.add(insertData)
                }
            }
            
        }
        
        return accountNumberList
    }
        
        
        
        
        
        
        
        
        
        
//        let hospitalDetails = (responseList as AnyObject).value(forKey:"lstHospitalInfo") as! NSArray
//        var inwardDataList :[CustomerHospitalInfoModel] = []
//
//        let dict = obj as! NSDictionary
//        var addressArray: NSArray = []
//        if let array = dict.value(forKey: "lstHospitalInfo") as? NSArray
//        {
//            addressArray = array
//        }
//
//        for obj in hospitalDetails
//        {
//
//            var sampleObj : CustomerHospitalInfoModel?
//
//            let accountNumber = hospitalDetails as! NSDictionary
//
//            sampleObj!.Region_Code = accountNumber.value(forKey: "Region_Code") as! String
//            sampleObj!.Customer_Code = accountNumber.value(forKey: "Customer_Code") as! String
////            sampleObj!.Hospital_Name = obj.value(forKey: "Hospital_Name") as! String
////            sampleObj!.Hospital_Address1 = obj.value(forKey: "Hospital_Address1") as! String
////            sampleObj!.Hospital_Address2 = obj.value(forKey: "Hospital_Address2") as! String
////            sampleObj!.Hospital_Local_Area = obj.value(forKey: "Hospital_Local_Area") as! String
////            sampleObj!.Hospital_City = obj.value(forKey: "Hospital_City") as! String
////            sampleObj!.Hospital_State = obj.value(forKey: "Hospital_State") as! String
////            sampleObj!.Hospital_Latitude = obj.value(forKey: "Hospital_Latitude") as! String
////            sampleObj!.Hospital_Longitude = obj.value(forKey: "Hospital_Longitude") as! String
////            sampleObj!.Hospital_Pincode = obj.value(forKey: "Hospital_Pincode") as! String
////            sampleObj!.Mapping_Status = obj.value(forKey: "Mapping_Status") as! Int
////            sampleObj!.Hospital_Classification = obj.value(forKey: "Hospital_Classification") as! String
////            sampleObj!.Hospital_Account_Number = obj.value(forKey: "Hospital_Account_Number") as! String
//
//            inwardDataList.append(sampleObj!)
//
//        }
//        return inwardDataList
    
    
    private func prepareCustomerAddressData(list: NSArray) -> NSMutableArray
    {
        let insertList: NSMutableArray = []
        
        for obj in list
        {
            let dict = obj as! NSDictionary
            var addressArray: NSArray = []
            
            if let array = dict.value(forKey: "lstAddressdetails") as? NSArray
            {
                addressArray = array
            }
            
            if (addressArray.count > 0)
            {
                let customerCode = dict.value(forKey: "CustomerCode") as? String
                let regionCode = dict.value(forKey: "RegionCode") as? String
                let customerEntityType = dict.value(forKey: "CustomerEntityType") as? String
                
                for objAddress  in addressArray
                {
                    let addressDict = objAddress as! NSDictionary
                    let insertData: NSMutableDictionary = ["Customer_Code_Global": customerCode, "Region_Code_Global": regionCode, "Customer_Entity_Type": customerEntityType]
                    insertData.addEntries(from: addressDict as! [AnyHashable : Any])
                    
                    insertList.add(insertData)
                }
            }
        }
        
        return insertList
    }
    
    func updateMasterDataDownloadedAlert(masterDataGroupName:String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.UpdateMasterDataDownloadedAlert.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        WebServiceHelper.sharedInstance.updateMasterDataDownloadedAlert { (apiResponseObj) in
            if apiResponseObj.Status == SERVER_SUCCESS_CODE
            {
                BL_MasterDataDownload.sharedInstance.updateCompletedStatusMasterDataDownloadCheck(completedStatus: 1)
                completion(apiResponseObj.Status)
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    func insertApiDownloadDetails(apiName: String, masterDataGroupName: String)
    {
        let apiDownloadDetail:NSMutableDictionary = NSMutableDictionary()
        
        apiDownloadDetail.setValue(apiName, forKey: "Api_Name")
        apiDownloadDetail.setValue(masterDataGroupName, forKey: "Master_Data_Group_Name")
        apiDownloadDetail.setValue(getCurrentDateAndTime(), forKey: "Download_Date")
        apiDownloadDetail.setValue(0, forKey: "Download_Status")
        
        DBHelper.sharedInstance.insertApiDownloadDetail(dict: apiDownloadDetail)
    }
    
    func updateApiDownloadDetails(apiName: String, masterDataGroupName: String)
    {
        DBHelper.sharedInstance.updateApiDownloadDetail(apiName: apiName, masterDataGroupName: masterDataGroupName)
    }
    
    private func deleteAllApiDownloadDetails()
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_API_DOWNLOAD_DETAILS)
    }
    
    private func updatePrepareMyDeviceCompleted()
    {
        DBHelper.sharedInstance.updatePMDCompleted()
    }
    
    // MARK:-- Privileges
    private func getUserPrivilegesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_PRIVILEGES)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertPrivileges(array: apiResponseObj.list)
            BL_InitialSetup.sharedInstance.setLabelDetailsonPrivileges()
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Company Config Settings
    private func getCompanyConfigSettingsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_CONFIG_SETTINGS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCompanyConfigSettings(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getUserModuleAccessCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        var configValue = ConfigValues.NO.rawValue
        
        if (isModuleNameExist(moduleName: ConfigNames.CHEMIST_DAY.rawValue, list: apiResponseObj.list))
        {
            configValue = ConfigValues.YES.rawValue
        }
        
        let dict: NSDictionary = ["Config_Name": ConfigNames.CHEMIST_DAY.rawValue, "Config_Value": configValue]
        
        DBHelper.sharedInstance.insertCompanyConfigSettings(array: [dict])
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func isModuleNameExist(moduleName: String, list: NSArray) -> Bool
    {
        var isModuleExist: Bool = false
        
        if (list.count > 0)
        {
            for obj in list
            {
                let dict = obj as! NSDictionary
                
                if let value = dict.value(forKey: "module_code") as? String
                {
                    if (value.uppercased() == moduleName.uppercased())
                    {
                        isModuleExist = true
                        break
                    }
                }
            }
        }
        
        return isModuleExist
    }
    
    // MARK:-- Work Categories
    private func getWorkCategoriesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_WORK_CATEGORY)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertWorkCategories(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Specialties
    private func getSpecialtiesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_SPECIALTIES)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertSpecialties(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Company Config Settings
    private func getLeaveTypeMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_LEAVE_TYPE_MASTER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertLeaveTypeMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Travel Mode Master
    private func getTravelModeMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TRAVEL_MODE_MASTER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTravelModeMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Project Activity Master
    private func getProjectActivityMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_PROJECT_ACTIVITY)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertProjectActivityMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Detail Product Master
    private func getDetailProductMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_DETAIL_PRODUCTS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDetailProductMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Campaign Planner
    private func getCampaignPlannerHeadeCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CP_HEADER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCampaignPlannerHeader(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getCPHeader() -> [CampaignPlannerHeader]
    {
        return DBHelper.sharedInstance.getAllCPHeader()
    }
    
    func updateCPIdInCPSFC()
    {
        let cpHeaderList = getCPHeader()
        
        for objCPHeader in cpHeaderList
        {
            DBHelper.sharedInstance.updateCPIdInCPSFC(cpId: objCPHeader.CP_Id, cpCode: objCPHeader.CP_Code)
        }
    }
    
    private func getCampaignPlannerSFCCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CP_SFC)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCampaignPlannerSFC(array: apiResponseObj.list)
        }
        
        self.updateCPIdInCPSFC()
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    func updateCPIdInCPDoctor()
    {
        let cpHeaderList = getCPHeader()
        
        for objCPHeader in cpHeaderList
        {
            DBHelper.sharedInstance.updateCPIdInCPDoctor(cpId: objCPHeader.CP_Id, cpCode: objCPHeader.CP_Code)
        }
    }
    
    private func getCampaignPlannerDoctorsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CP_DOCTORS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCampaignPlannerDoctors(array: apiResponseObj.list)
        }
        
        self.updateCPIdInCPDoctor()
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Expense Group Mapping
    private func getExpenseGroupMappingCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_EXPENSE_GROUP_MAPPING)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertExpenseGroupMapping(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Tour Planner
    func updateCPIdInTPHeader()
    {
        let cpHeaderList = getCPHeader()
        
        for objCPHeader in cpHeaderList
        {
            DBHelper.sharedInstance.updateCPIdInTPHeader(cpId: objCPHeader.CP_Id, cpCode: objCPHeader.CP_Code)
        }
    }
    
    func updateTourPlannerRefIdInTables()
    {
        let tpHeaderList = DBHelper.sharedInstance.getAllTPHeader()
        
        if (tpHeaderList.count > 0)
        {
            for objTP in tpHeaderList
            {
                DBHelper.sharedInstance.updateTPIdAndTPEntryIdInRefTabls(tpId: objTP.TP_Id, tpEntryId: objTP.TP_Entry_Id)
                if (objTP.Activity == TPFlag.fieldRcpa.rawValue)
                {
                    let tpDate = convertDateIntoServerStringFormat(date: objTP.TP_Date)
                    DBHelper.sharedInstance.updateTPDateInTPDoctorTable(tpId: objTP.TP_Id, tpDate: tpDate)
                }
            }
        }
    }
    
    private func getTourPlannerHeaderCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_HEADER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerHeader(array: apiResponseObj.list)
        }
        
        self.updateCPIdInTPHeader()
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerSFCCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_SFC)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerSFC(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerDoctorCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_DOCTOR)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerDoctor(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerAccompanistCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_ACCOMPANIST)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerAccompanist(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerProductCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_PRODUCT)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerProduct(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerUnfreezeDatesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_UNFREEZE_DATES)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerUnfreezeDates(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        updateTourPlannerRefIdInTables()
        
        return 1
    }
    
    // MARK:-- DFC Master
    private func getDFCMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_DFC)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDFCMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK-- User Product Mapping
    func getUserProductMappingCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_USER_PRODUCT)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_SAMPLE_BATCH_MAPPING)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertUserProductMapping(array: apiResponseObj.list)
            
            for apiObj in apiResponseObj.list
            {
                let apiObjData = apiObj as! NSDictionary
                let batchList = apiObjData.value(forKey: "lstuserproductbatch") as! NSArray
                if(batchList.count > 0)
                {
                    let batchDataList = NSMutableArray()
                    for batchObj in batchList
                    {
                        let batchData = batchObj as! NSDictionary
                        let dict = ["Product_Code":checkNullAndNilValueForString(stringData: apiObjData.value(forKey: "Product_Code") as? String),"Batch_Number":checkNullAndNilValueForString(stringData:batchData.value(forKey: "Batch_Number") as? String),"Expiry_Date":checkNullAndNilValueForString(stringData:batchData.value(forKey: "Expiry_Date") as? String),"Batch_Effective_From":checkNullAndNilValueForString(stringData:batchData.value(forKey: "Batch_Effective_From") as? String),"Batch_Effective_To":checkNullAndNilValueForString(stringData:batchData.value(forKey: "Batch_Effective_To")as? String),"Batch_Current_Stock":batchData.value(forKey: "Batch_Current_Stock")]
                        
                        batchDataList.add(dict)
                    }
                    
                    DBHelper.sharedInstance.insertSampleBatchMapping(array: batchDataList)
                }
            }
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- Accompanists
    private func getAccompanistsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_ACCOMPANIST)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_REGION_ENTITY_COUNT)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            let responseList = apiResponseObj.list
            let dict = responseList!.firstObject! as! NSDictionary
            let lstAccompanist = dict.value(forKey: "lstusermodel") as! NSArray
            let lstRegionEntityCount = dict.value(forKey: "lstCustomer") as! NSArray
            
            DBHelper.sharedInstance.insertAccompanist(array: lstAccompanist)
            DBHelper.sharedInstance.insertRegionEntityCount(array: lstRegionEntityCount)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    // MARK:-- DCR
    private func getDCRCalendarCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALENDAR_HEADER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRCalendarDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRLockDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        BL_DCR_Refresh.sharedInstance.getDCRLockLeavesCallBack(dataArray: apiResponseObj.list)
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    func updateCPIdInDCRHeader()
    {
        let cpHeaderList = getCPHeader()
        
        for objCPHeader in cpHeaderList
        {
            DBHelper.sharedInstance.updateCPIdInDCRHeader(cpId: objCPHeader.CP_Id, cpCode: objCPHeader.CP_Code)
            DBHelper.sharedInstance.updateCPNameInDCRHeader(cpName: objCPHeader.CP_Name, cpCode: objCPHeader.CP_Code)
        }
        
        self.updateCategoryNameInDFC()
    }
    
    func updateCategoryNameInDFC()
    {
        let workCategoryList = DBHelper.sharedInstance.getWorkCategoryList()
        
        if (workCategoryList != nil)
        {
            for objWorkCategory in workCategoryList!
            {
                DBHelper.sharedInstance.updateCategoryNameInDFC(categoryName: objWorkCategory.Category_Name, categoryCode: objWorkCategory.Category_Code)
            }
        }
    }
    
    private func getDCRHeaderDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_HEADER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRHeaderDetails(array: apiResponseObj.list)
        }
        
        self.updateCPIdInDCRHeader()
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRTravelledPlacesDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_TRAVELLED_PLACES)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRTravelledPlacesDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRAccompanistsDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_ACCOMPANIST)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRAccompanistsDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_DOCTOR_VISIT)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitOrderDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName:TRAN_DCR_DOCTOR_VISIT_POB_HEADER)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_DOCTOR_VISIT_POB_REMARKS)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_DOCTOR_VISIT_POB_DETAILS)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            insertOrderedDetails(array: apiResponseObj.list, isChemist: false)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRChemistVisitOrderDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            insertOrderedDetails(array: apiResponseObj.list, isChemist: true)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRSampleDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_SAMPLE_DETAILS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRSampleDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDetailedProdutsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_DETAILED_PRODUCTS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDetailedProducts(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRChemistVisitDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        let chemistPredicate =
            NSPredicate(format: "DCR_Visit_Code = nil");
        let filteredArray = apiResponseObj.list.filtered(using: chemistPredicate)
        let doctorPredicate = NSPredicate(format: "DCR_Visit_Code.length > 0");
        let docFilteredArray =  apiResponseObj.list.filtered(using: doctorPredicate)
        
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMISTS_VISIT)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_DAY_VISIT)
        
        if (docFilteredArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRChemistVisitDetails(array: docFilteredArray as NSArray)
        }
        
        if (filteredArray.count > 0)
        {
            DBHelper.sharedInstance.insertChemistDayVisit(array: filteredArray as NSArray)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRRCPACallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_RCPA_DETAILS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRRCPADetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRCustomerFollowUpDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName:TRAN_DCR_CUSTOMER_FOLLOW_UPS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRCustomerFollowUpDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRAttachmentDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        //DBHelper.sharedInstance.deleteFromTable(tableName:TRAN_DCR_DOCTOR_VISIT_ATTACHMENT)
        DBHelper.sharedInstance.deleteWebAttachments()
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            for dict in apiResponseObj.list
            {
                let dictionary = dict as! NSDictionary
                let apiDCRCode = dictionary.value(forKey: "DCR_Code") as! String
                var dcrId: Int = 0
                let dcrdetails = DBHelper.sharedInstance.getDCRDetails(dcrCode: apiDCRCode)
                
                if dcrdetails.count > 0
                {
                    dcrId = dcrdetails[0].DCR_Id
                }
                
                let mutableDict : NSMutableDictionary = [:]
                mutableDict.addEntries(from: dictionary as! [AnyHashable : Any])
                mutableDict.setValue(dcrId, forKey: "DCR_Id")
                DBHelper.sharedInstance.insertDCRAttachment(dict: mutableDict)
            }
            //DBHelper.sharedInstance.insertDCRAttachmentDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRStockistVisitCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_STOCKIST_VISIT)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRStockistVisitDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRExpenseDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_EXPENSE_DETAILS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRExpenseDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRAttendanceActivitiesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_ATTENDANCE_ACTIVITIES)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAttendanceActivities(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getCustomerMasterDataCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CUSTOMER_MASTER)
        DBHelper.sharedInstance.deleteFromTable(tableName:MST_CUSTOMER_MASTER_PERSONAL_INFO)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCustomerMaster(array: apiResponseObj.list)
            DBHelper.sharedInstance.insertCustomerMasterPersonalInfo(array: apiResponseObj.list)
            DBHelper.sharedInstance.insertCustomerMasterEdit(array: apiResponseObj.list)
            DBHelper.sharedInstance.insertCustomerMasterPersonalInfoEdit(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getSFCMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_SFC_MASTER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertSFCMaster(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getHolidayMasterCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_HOLIDAY_MASTER)
        DBHelper.sharedInstance.updateAllHolidayInCalendarHeader()
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertHolidayMaster(array: apiResponseObj.list)
            updateHolidayInCalendarHeader(holidayArray: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func updateHolidayInCalendarHeader(holidayArray: NSArray)
    {
        let insertArray: NSMutableArray = []
        let calendarHeaderData = DBHelper.sharedInstance.getDCRCalendarDetails()
        
        for obj in holidayArray
        {
            let dict = obj as! NSDictionary
            let dateString = dict.value(forKey: "Holiday_Date") as! String
            var filteredArray: [DCRCalendarModel] = []
            
            if (calendarHeaderData.count > 0)
            {
                filteredArray = calendarHeaderData.filter{
                    getStringInFormatDate(dateString: dateString) == $0.Activity_Date
                }
            }
            
            if (filteredArray.count > 0)
            {
                DBHelper.sharedInstance.updateHolidayInCalendarHeader(activityDate: dateString)
            }
            else
            {
                let calendarDict: NSDictionary = ["Activity_Date": dateString, "Activity_Count": 0, "Is_WeekEnd": 0, "Is_Holiday": 1, "Is_LockLeave": 0, "DCR_Status": 90]
                
                insertArray.add(calendarDict)
            }
        }
        
        if (insertArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRCalendarDetails(array: insertArray)
        }
    }
    
    private func getCompetitorProductCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_COMPETITOR_PRODUCT)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertCompetitorProducts(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorAccompanistCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_DOCTOR_ACCOMPANIST)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDoctorAccompanist(dataArray: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getUserTypeMenuAccessCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MENU_MASTER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertMenuMaster(dataArray: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getAssetsHeaderCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_ASSET_HEADER)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAssetHeaderDetails(array: apiResponseObj.list)
        }
        
        deleteDacodeInLocal()
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func deleteDacodeInLocal()
    {
        let daCodeModelList = DBHelper.sharedInstance.getNotExistsDaCode()
        var daCodeList : [Int] = []
        
        for obj in daCodeModelList
        {
            daCodeList.append(obj.daCode)
        }
        
        if daCodeList.count > 0
        {
            let daCodes =  BL_AssetModel.sharedInstance.getDaCode(daCodeArray:daCodeList)
            DBHelper.sharedInstance.deleteAssetsDownlodedByDacode(daCodes: daCodes)
        }
        
        for obj in daCodeModelList
        {
            BL_AssetDownloadOperation.sharedInstance.deleteAssetFile(fileName: "", subFolder:  "\(obj.daCode!)")
        }
        
        let htmlDownloadedAssets = DBHelper.sharedInstance.getDownloadedHTMLAssets()
        let htmlAssetMaster = DBHelper.sharedInstance.getHTMLAssetsinMaster()
        
        for model in htmlDownloadedAssets
        {
            if model.isDownloaded == isFileDownloaded.progress.rawValue
            {
                if htmlAssetMaster.contains(where: { $0.daCode == model.daCode && $0.isDownloaded == isFileDownloaded.pending.rawValue})
                {
                    DBHelper.sharedInstance.deleteAssetDownloaded(daCode: model.daCode)
                }
            }
        }
    }
    
    private func getAssetsAnalyticsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: "\(TRAN_ASSET_ANALYTICS_DETAILS)")
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            for modelObj in apiResponseObj.list
            {
                if let dict = modelObj as? NSDictionary
                {
                    let dateString = dict.value(forKey: "Detailed_DateTime") as! String
                    let convertedDate = getDateAndTimeFormatWithoutMilliSecond(dateString: dateString)
                    let convertedDateString = convertDateIntoServerStringFormat(date: convertedDate)
                    UserDefaults.standard.setValue((dict.object(forKey: "Max_Customer_Detailed_Id") as? Int), forKey: "Max_Detailed_Id")
                    let deletailedDBId = DBHelper.sharedInstance.getMaxCustomerDetailedId()
                    var detailedId : Int = 0
                    
                    if let detailId = UserDefaults.standard.object(forKey: "Max_Detailed_Id") as? Int
                    {
                        if deletailedDBId != nil
                        {
                            if detailId > deletailedDBId!
                            {
                                detailedId = detailId
                            }
                            else
                            {
                                detailedId = deletailedDBId!
                            }
                        }
                    }
                    else if deletailedDBId != nil
                    {
                        detailedId = deletailedDBId!
                    }
                    
                    let assetObj = AssetAnalyticsDetail(dict: dict)
                    assetObj.Detailed_DateTime = convertedDateString
                    detailedId += 1
                    assetObj.Customer_Detailed_Id = detailedId
                    if let playerStartTime = dict.value(forKey: "Player_Start_Time") as? Int
                    {
                        assetObj.Player_StartTime = "\(playerStartTime)"
                    }
                    else
                    {
                        assetObj.Player_StartTime = ""
                    }
                    if let playerEndTime = dict.value(forKey: "Player_End_Time") as? Int
                    {
                        assetObj.Player_EndTime = "\(playerEndTime)"
                    }
                    else
                    {
                        assetObj.Player_EndTime = ""
                    }
                    _ = DBHelper.sharedInstance.insertAssetAnalytics(assetObj: assetObj)
                }
            }
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getAssetsTagCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_ASSET_TAG_DETAILS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAssetTagDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getStoryDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_STORY_HEADER)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_STORY_CATEGORIES)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_STORY_SPECIALITIES)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_STORY_ASSETS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertStoryHeaderDetails(array: apiResponseObj.list)
            
            for dict in apiResponseObj.list
            {
                if let dictionary = dict as? NSDictionary
                {
                    if let specialityList = dictionary.value(forKey: "lstStorySpecialities") as? NSArray
                    {
                        DBHelper.sharedInstance.insertStorySpecialitiesDetails(array: specialityList)
                    }
                    
                    if let categoryList = dictionary.value(forKey: "lstStoryCategories") as? NSArray
                    {
                        DBHelper.sharedInstance.insertStoryCategoryDetails(array: categoryList)
                    }
                    
                    if let assetList = dictionary.value(forKey: "lstStoryAssetDetails") as? NSArray
                    {
                        DBHelper.sharedInstance.insertStoryAssetDetails(array: assetList)
                    }
                }
            }
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getAssetsPartsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_ASSET_PARTS)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAssetPartDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    private func getAssetProductMappingCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_ED_ASSET_PRODUCT_MAPPING)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDetailedProductDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    func updateDCRIdsForNewlyDownloadedDCRs()
    {
        let dcrHeaderList = DBHelper.sharedInstance.getNewlyDownloadedDCRHeader()
        
        if (dcrHeaderList != nil)
        {
            for dcrHeaderObj in dcrHeaderList!
            {
                let dcrCode = dcrHeaderObj.DCR_Code
                let flag = dcrHeaderObj.Flag
                let dcrId = dcrHeaderObj.DCR_Id
                let dcrActualDate = dcrHeaderObj.DCR_Actual_Date
                _ = getServerFormattedDateString(date: dcrActualDate!)
                
                if (flag == DCRFlag.fieldRcpa.rawValue)
                {
                    DBHelper.sharedInstance.updateDCRIdInFieldTables(dcrCode: dcrCode!, dcrId: dcrId!)
                    DBHelper.sharedInstance.updateDCRIdInOrderTable(dcrCode: dcrCode!, dcrId: dcrId!)
                }
                else if (flag == DCRFlag.attendance.rawValue)
                {
                    DBHelper.sharedInstance.updateDCRIdInAttendanceTables(dcrCode: dcrCode!, dcrId: dcrId!)
                }
            }
        }
        
        let dcrDoctorVisitList = DBHelper.sharedInstance.getNewlyDownloadedDCRDoctorVisits()
        
        if (dcrDoctorVisitList != nil)
        {
            for dcrDoctorVisitObj in dcrDoctorVisitList!
            {
                let dcrDoctorVisitCode = dcrDoctorVisitObj.DCR_Doctor_Visit_Code
                let dcrDoctorVisitId = dcrDoctorVisitObj.DCR_Doctor_Visit_Id
                
                DBHelper.sharedInstance.updateDCRDoctorVisitIdInDetailTables(dcrDoctorVisitCode: dcrDoctorVisitCode!, dcrDoctorVisitId: dcrDoctorVisitId!)
            }
        }
        
        let dcrChemistVisitList = DBHelper.sharedInstance.getNewlyDownloadedDCRChemistVisits()
        
        if (dcrChemistVisitList != nil)
        {
            for dcrChemistVisitObj in dcrChemistVisitList!
            {
                let dcrChemistVisitCode = dcrChemistVisitObj.DCR_Chemist_Visit_Code
                let dcrChemistVisitId = dcrChemistVisitObj.DCR_Chemist_Visit_Id
                
                DBHelper.sharedInstance.updateDCRChemistVisitIdInDetailTables(dcrChemistVisitCode: dcrChemistVisitCode!, dcrChemistVisitId: dcrChemistVisitId!)
            }
        }
        
        let chemistDayList = DBHelper.sharedInstance.getNewlyDownloadedDCRChemistDayVisits()
        
        if (chemistDayList.count > 0)
        {
            for dcrChemistVisitObj in chemistDayList
            {
                let dcrChemistVisitCode = dcrChemistVisitObj.CVVisitId
                let dcrChemistVisitId = dcrChemistVisitObj.DCRChemistDayVisitId
                
                DBHelper.sharedInstance.updateDCRChemistDayVisitIdInDetailTables(dcrChemistVisitCode: dcrChemistVisitCode!, dcrChemistVisitId: dcrChemistVisitId!)
            }
        }
        
        //        for dcrHeaderObj in dcrHeaderList!
        //        {
        //            let dcrCode = dcrHeaderObj.DCR_Code
        //            let flag = dcrHeaderObj.Flag
        //            let dcrId = dcrHeaderObj.DCR_Id
        //            let dcrActualDate = dcrHeaderObj.DCR_Actual_Date
        //            let dcrDateSting = getServerFormattedDateString(date: dcrActualDate!)
        let chemistDayVisitList = DBHelper.sharedInstance.getNewlyDownloadedDCRChemistDayVisits()
        let dcrDoctorVisitsList = DBHelper.sharedInstance.getNewlyDownloadedDCRDoctorVisits()!
        
        if (chemistDayList.count > 0)
        {
            for dcrChemistDayVisitObj in chemistDayVisitList
            {
                DBHelper.sharedInstance.updateChemistVisitIdInOrderTable(dcrCode: dcrChemistDayVisitObj.DCRCode, dcrId: dcrChemistDayVisitObj.DCRId, visitId: dcrChemistDayVisitObj.DCRChemistDayVisitId, chemistCode: dcrChemistDayVisitObj.ChemistCode, chemistName: dcrChemistDayVisitObj.ChemistName)
            }
        }
        
        if dcrDoctorVisitsList.count > 0
        {
            for dcrDoctorObj in dcrDoctorVisitsList
            {
                DBHelper.sharedInstance.updateDoctorVisitIdInOrderTable(dcrCode: dcrDoctorObj.DCR_Code,dcrId: dcrDoctorObj.DCR_Id,visitId: dcrDoctorObj.DCR_Doctor_Visit_Id,doctorCode: dcrDoctorObj.Doctor_Code!, doctorName: dcrDoctorObj.Doctor_Name)
            }
        }
        
        let dcrChemistDayRCPAOwnList = DBHelper.sharedInstance.getNewlyDownloadedDCRChemistRCPAOwn()
        
        for obj in dcrChemistDayRCPAOwnList
        {
            DBHelper.sharedInstance.updateRCPAOwnIdInCompetitorTable(ownId: obj.ProductId!, rcpaOwnProductId: obj.DCRChemistRCPAOwnId!)
        }
        
        let dcrAttendanceDoctorList = DBHelper.sharedInstance.getNewlyDownloadedDCRAttendanceDoctorVisits()
        
        if(dcrAttendanceDoctorList != nil)
        {
            for dcrAttendanceDoctorObj in dcrAttendanceDoctorList!
            {
                let dcrDoctorVisitCode = dcrAttendanceDoctorObj.DCR_Doctor_Visit_Code
                let dcrDoctorVisitId = dcrAttendanceDoctorObj.DCR_Doctor_Visit_Id
                DBHelper.sharedInstance.updateDCRAttendanceDoctorVisitIdInDetailTables(dcrDoctorVisitCode: dcrDoctorVisitCode!, dcrDoctorVisitId: dcrDoctorVisitId!)
            }
        }
        
        // Update Ref Id In Sample Batch
        
        let lstSamplesBatches = DBHelper.sharedInstance.getNewlyDownloadedDCRSampleBatch()
        
        for objSampleBatch in lstSamplesBatches
        {
            if (objSampleBatch.Entity_Type == sampleBatchEntity.Doctor.rawValue)
            {
                let doctorSampleList = DBHelper.sharedInstance.getDCRSampleProducts(dcrId: objSampleBatch.DCR_Id, doctorVisitId: objSampleBatch.Visit_Id)
                if (doctorSampleList != nil)
                {
                    let filteredArray = doctorSampleList!.filter{
                        $0.sampleObj.Product_Code == objSampleBatch.Product_Code
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        DBHelper.sharedInstance.updateSampleBatchRefId(refId: filteredArray.first!.sampleObj.DCR_Sample_Id, visitId: objSampleBatch.Visit_Id, productCode: objSampleBatch.Product_Code, entityType: objSampleBatch.Entity_Type)
                    }
                }
            }
            else if (objSampleBatch.Entity_Type == sampleBatchEntity.Chemist.rawValue)
            {
                let chemistSampleList = DBHelper.sharedInstance.getDCRChemistSampleProducts(dcrId: objSampleBatch.DCR_Id, chemistVisitId: objSampleBatch.Visit_Id)
                
                if (chemistSampleList != nil)
                {
                    let filteredArray = chemistSampleList!.filter{
                        $0.ProductCode == objSampleBatch.Product_Code
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        DBHelper.sharedInstance.updateSampleBatchRefId(refId: filteredArray.first!.DCRChemistSampleId, visitId: objSampleBatch.Visit_Id, productCode: objSampleBatch.Product_Code, entityType: objSampleBatch.Entity_Type)
                    }
                }
            }
                
            else if (objSampleBatch.Entity_Type == sampleBatchEntity.Attendance.rawValue)
            {
                let attendanceSampleList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: objSampleBatch.Visit_Id, dcrId: objSampleBatch.DCR_Id)
                
                if (attendanceSampleList.count > 0)
                {
                    let filteredArray = attendanceSampleList.filter{
                        $0.Product_Code == objSampleBatch.Product_Code
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        DBHelper.sharedInstance.updateSampleBatchRefId(refId: filteredArray.first!.DCR_Attendance_Sample_Id, visitId: objSampleBatch.Visit_Id, productCode: objSampleBatch.Product_Code, entityType: objSampleBatch.Entity_Type)
                    }
                }
            }
        }
    }
    
    private func getTourPlannerPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "TPStatus": "ALL", "Flag": "ALL"]
    }
    
    private func getFollowUpsPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "DCRStatus": "0,3,"]
    }
    
    private func getDCRAttachmentPostData() -> [String : Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "DCRStatus": "0,3,"]
    }
    
    private func getOrderPostData() -> [String: Any]
    {
        return ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "Region_Code": getRegionCode(), "Start_Date": "", "End_Date": "", "Order_Status": "ALL"]
    }
    
    private func getAssetAnalyticsPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "DCRStatus": "0,3,","Flag":"F"]
    }
    private func getChemistDayPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "DCRStatus": "0,3,","Flag": "F"]
    }
    
    private func insertOrderedDetails(array : NSArray,isChemist: Bool)
    {
        let orderedList = array
        let orderDetails: NSMutableArray = []
        let remarksList : NSMutableArray = []
        let orderedProductList : NSMutableArray = []
        var customerEntityType: String = Constants.CustomerEntityType.chemist
        
        if !isChemist
        {
            customerEntityType = Constants.CustomerEntityType.doctor
        }
        
        for dict in orderedList
        {
            var combinedAttributes : NSMutableDictionary!
            let orderDict = dict as! NSDictionary
            var orderEntryId : Int?
            let dict1 = ["DCR_Code":orderDict.value(forKey:"DCR_Code"),"DCR_Id":orderDict.value(forKey:"DCR_Id"),"Order_Id":orderDict.value(forKey:"Order_Id"),"Order_Status":orderDict.value(forKey:"Order_Status"),"Order_Mode":orderDict.value(forKey:"Order_Mode"),"Favouring_User_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Favouring_User_Code") as? String),"Favouring_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Favouring_Region_Code") as? String),"Visit_Id":orderDict.value(forKey:"Visit_Id")]
            let dict2 = ["Order_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Date") as? String),"DCR_Actual_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"DCR_Actual_Date") as? String),"Customer_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Code") as? String),"Customer_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Region_Code") as? String),"Customer_Name":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Name") as? String),"Customer_Speciality":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Speciality") as? String),"Customer_MDLNumber":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_MDLNumber") as? String),"Customer_CategoryCode":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_CategoryCode") as? String)]
            let dict3 = ["Stockiest_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Code") as? String),"Stockiest_Name":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Name") as? String),"Stockiest_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Region_Code") as? String),"Order_Due_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Due_Date") as? String),"Action_Mode":orderDict.value(forKey:"Action_Mode"),"Entity_Type":customerEntityType,"Order_Number":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Number") as? String)]
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2)
            combinedAttributes.addEntries(from: dict3)
            orderDetails.removeAllObjects()
            orderDetails.add(combinedAttributes)
            orderedProductList.removeAllObjects()
            remarksList.removeAllObjects()
            
            let headerObj = DCRDoctorVisitPOBHeaderModel(dict: combinedAttributes)
            if headerObj.Order_Status != Constants.OrderStatus.cancelled
            {
                orderEntryId = DBHelper.sharedInstance.insertPOBHeaderDetails(pobObj: headerObj)
                
                
                let remarksdict: NSDictionary = ["Remarks" : checkNullAndNilValueForString(stringData:orderDict.value(forKey: "Remarks") as? String), "DCR_Code":orderDict.value(forKey:"DCR_Code") as? String ?? EMPTY, "Order_Entry_Id": orderEntryId!]
                remarksList.add(remarksdict)
                if let orderedPOBList = (orderDict as AnyObject).object(forKey: "Orderdetails") as? NSArray
                {
                    for obj in orderedPOBList
                    {
                        let detailsDict = obj as! NSDictionary
                        let dict:NSDictionary = ["Order_Entry_Id":orderEntryId!,"DCR_Code":orderDict.value(forKey: "DCR_Code") as? String ?? EMPTY,"DCR_Id":orderDict.value(forKey: "DCR_Id") as? Int ?? 0,"Product_Name":detailsDict.value(forKey: "Product_Name")!,"Product_Code":detailsDict.value(forKey: "Product_Code")!,"Product_Qty":detailsDict.value(forKey: "Product_Qty") as? Double ?? 0.0,"Product_Unit_Rate":detailsDict.value(forKey: "Product_Unit_Rate") as? Double ?? 0.0,"Product_Amount":detailsDict.value(forKey: "Product_Amount") as? Double ?? 0.0]
                        orderedProductList.add(dict)
                    }
                }
                
                
                DBHelper.sharedInstance.insertDCRDoctorVisitOrderDetails(array: orderedProductList as NSArray)
                DBHelper.sharedInstance.insertDCRDoctorVisitOrderRemarksDetails(array: remarksList as NSArray)
            }
        }
    }
    
    //MARK:- ChemistDayCallBack Functions
    private func getDCRDoctorVisitChemistAccompanistCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_ACCOMPANIST)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistAccompanist(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistSamplePromotionCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_SAMPLE_PROMOTION)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistSamplePromotion(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistDetailedProductDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_DETAILED_PRODUCT)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDetailedProductDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistRCPAOwnProductDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_RCPA_OWN)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistRCPAOwnProductDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistRCPACompetitorProductDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_RCPA_COMPETITOR)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistRCPACompetitorProductDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistDayFollowupsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_FOLLOWUP)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDayFollowups(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDCRDoctorVisitChemistDayAttachmentsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CHEMIST_ATTACHMENT)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDayAttachments(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    //AlertsBuild
    
    func getMCDoctorProductMapping(masterDataGroupName:String, selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        self.currentPageIndex = 0
        self.totalPages = 0
        self.regionCodes = EMPTY
        
        let apiName: String = ApiName.MCDoctorProductMappingDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        self.getMCDoctorProductMappingPageInfo(masterDataGroupName: masterDataGroupName, selectedRegionCode: selectedRegionCode) { (status) in
            self.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
            completion(status)
        }
    }
    
    private func getMCDoctorProductMappingPageInfo(masterDataGroupName:String, selectedRegionCode: String, completion: @escaping (Int) -> ())
    {
        if (selectedRegionCode == EMPTY)
        {
            let accRegions = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
            self.regionCodes = getRegionCode() + ","
            
            for obj in accRegions
            {
                self.regionCodes += obj.Region_Code + ","
            }
        }
        else
        {
            self.regionCodes = selectedRegionCode + ","
        }
        
        //        self.regionCodes = String(self.regionCodes.dropLast())
        
        WebServiceHelper.sharedInstance.getMCDoctorProductMappingPageInfo(regionCodes: regionCodes) { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                if (objApiResponse.list.count > 0)
                {
                    guard let dict = objApiResponse.list.firstObject as? NSDictionary else
                    {
                        return
                    }
                    
                    self.totalPages = dict.value(forKey: "No_Of_Pages") as! Int
                    let totalRecords = dict.value(forKey: "Total_Records") as! Int
                    
                    var deleteRegionCodes: String = EMPTY
                    let regionCodeArray = self.regionCodes.components(separatedBy: ",")
                    
                    for regCode in regionCodeArray
                    {
                        if (regCode != EMPTY)
                        {
                            deleteRegionCodes += "'" + regCode + "',"
                        }
                    }
                    
                    if (deleteRegionCodes != EMPTY)
                    {
                        deleteRegionCodes = String(deleteRegionCodes.dropLast())
                    }
                    
                    DBHelper.sharedInstance.deleteMCProductMapping(regionCodes: deleteRegionCodes)
                    
                    if (totalRecords > 0)
                    {
                        let myGroup = DispatchGroup()
                        var statusCode: Int!
                        
                        for i in 1...self.totalPages
                        {
                            myGroup.enter()
                            self.currentPageIndex = i
                            
                            self.getMCDoctorProductMappingDetails(completion: { (status) in
                                statusCode = status
                                myGroup.leave()
                            })
                        }
                        
                        myGroup.notify(queue: .main) {
                            completion(statusCode)
                        }
                    }
                    else
                    {
                        completion(objApiResponse.Status)
                    }
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            else
            {
                completion(objApiResponse.Status)
            }
        }
    }
    //MARK:- Activity Functions
    func getCallActivityAndMCActivity(completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.CustomerActivity.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: "")
        
        WebServiceHelper.sharedInstance.getActivityDetails{ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getCallActivityCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    private func getCallActivityCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CALL_ACTIVITY)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_HEADER)
        // DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_MAPPED_REGION_TYPES)
        // DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_CATEGORY)
        // DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_SPECIALITY)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_BUSINESS_STATUS)
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_CALL_OBJECTIVE)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            let callActivity = (apiResponseObj.list[0] as AnyObject).value(forKey:"lstCustomerActivity") as! NSArray
            let mcActivityDataList = (apiResponseObj.list[0] as AnyObject).value(forKey:"lstCampaignHeader") as! NSArray
            let mcActivityDetaillist = (apiResponseObj.list[0] as AnyObject).value(forKey:"lstCampaignActivityDetails") as! NSArray
            let lstBusinessStatus = (apiResponseObj.list[0] as AnyObject).value(forKey:"lstBusinessStatus") as! NSArray
            let lstCallObjective = (apiResponseObj.list[0] as AnyObject).value(forKey:"lstCallObjective") as! NSArray
            
            //  var categoryDataList:[NSDictionary] = []
            //  var specialtyDataList:[NSDictionary] = []
            //  var regionDataList:[NSDictionary] = []
            var mcActivityList:[NSDictionary] = []
            
            /*            for(index, element) in mcActivityDataList.enumerated()
             {
             let mcActivityCategoryList = (element as AnyObject).value(forKey: "lstCategory") as! NSArray
             let mcActivitySpecialityList = (element as AnyObject).value(forKey: "lstSpeciality") as! NSArray
             let mcActivityRegionList = (element as AnyObject).value(forKey: "lstRegionType") as! NSArray
             for mcActivityCategory in mcActivityCategoryList
             {
             let CategoryData:NSDictionary = ["Campaign_Code":(mcActivityDataList[index] as AnyObject).value(forKey: "Campaign_Code") as! String,"Customer_Category_Code":(mcActivityCategory as AnyObject).value(forKey:"Customer_Category_Code") as! String]
             
             categoryDataList.append(CategoryData)
             }
             
             for mcActivitySpeciality in mcActivitySpecialityList
             {
             let CategoryData:NSDictionary = ["Campaign_Code":(mcActivityDataList[index] as AnyObject).value(forKey: "Campaign_Code") as! String,"Customer_Speciality_Code":(mcActivitySpeciality as AnyObject).value(forKey:"Customer_Speciality_Code") as! String]
             
             specialtyDataList.append(CategoryData)
             }
             
             for mcActivityRegion in mcActivityRegionList
             {
             let CategoryData:NSDictionary = ["Campaign_Code":(mcActivityDataList[index] as AnyObject).value(forKey: "Campaign_Code") as! String,"Region_Type_Code":(mcActivityRegion as AnyObject).value(forKey:"Region_Type_Code") as! String]
             
             regionDataList.append(CategoryData)
             }
             }*/
            
            for(index, element) in mcActivityDetaillist.enumerated()
            {
                let mcActivityData = (element as AnyObject).value(forKey: "lstActivityDetails") as! NSArray
                for mcActivity in mcActivityData
                {
                    let CategoryData:NSDictionary = ["Campaign_Code":(mcActivityDetaillist[index] as AnyObject).value(forKey: "Campaign_Code") as! String,"MC_Activity_Id":(mcActivity as AnyObject).value(forKey: "Activity_Id") as! Int,"MC_Activity_Name":(mcActivity as AnyObject).value(forKey: "Activity_Name") as! String]
                    
                    mcActivityList.append(CategoryData)
                }
            }
            
            DBHelper.sharedInstance.insertMCHeaderModelList(array: mcActivityDataList)
            // DBHelper.sharedInstance.insertMCRegionTypeModelList(array: regionDataList as NSArray)
            //DBHelper.sharedInstance.insertMCCategoryModelList(array: categoryDataList as NSArray)
            //DBHelper.sharedInstance.insertMCSpecialtyModelList(array: specialtyDataList as NSArray)
            DBHelper.sharedInstance.insertCallActivityModelList(array: callActivity)
            DBHelper.sharedInstance.insertMCActivityModelList(array: mcActivityList as NSArray)
            DBHelper.sharedInstance.insertBusinesStatus(array: lstBusinessStatus)
            DBHelper.sharedInstance.insertCallObjective(array: lstCallObjective)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    //MARK:- Competitor Functions
    func getAllCompetitorProducts(completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AllCompetitorProducts.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: "")
        
        WebServiceHelper.sharedInstance.getCompetitorMapping{ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAllCompetitorProductsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getAllProductsCompetitor(completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.AllProductCompetitor.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: "")
        WebServiceHelper.sharedInstance.getProductCompetitorMapping{ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getAllProductsCompetitorCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
        
    }
    
    private func getAllDoctorProductMappingCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_DOCTOR_PRODUCT_MAPPING)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            for obj in apiResponseObj.list
            {
                let dict = obj as! NSDictionary
                let dpmArray = dict.value(forKey:"lstDPMDoctorandProducts") as! NSArray
                DBHelper.sharedInstance.insertDoctorProductMapping(array: dpmArray)
            }
            
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getAllMCDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_MC_DETAILS)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            
            DBHelper.sharedInstance.insertAllMCDetails(array: apiResponseObj.list)
            
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getDivisionMappingDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_DIVISION_MAPPING_DETAILS)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            
            DBHelper.sharedInstance.insertDivisionMappingDetails(array: apiResponseObj.list)
            
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    func getDCRCompetitorDetails(completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.GetDCRCompetitorDetails.rawValue
        insertApiDownloadDetails(apiName: apiName, masterDataGroupName: "")
        
        WebServiceHelper.sharedInstance.getActivityDetails{ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getDCRCompetitorDetailsCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: "")
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    
    private func getAllCompetitorProductsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_COMPETITOR_MAPPING)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAllCompetitor(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getAllProductsCompetitorCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_COMPETITOR_PRODUCT_MASTER)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertAllProductCompetitor(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    
    private func getDCRCompetitorDetailsCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_COMPETITOR_DETAILS)
        
        // Insert new records in table
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertDCRCompetitorDetails(array: apiResponseObj.list)
        }
        
        updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        return 1
    }
    
    private func getPostJsonString() -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = getUserCode()
        dcrParameterModelObj.RegionCode = getRegionCode()
        dcrParameterModelObj.Flag = "F"
        dcrParameterModelObj.StartDate = ""
        dcrParameterModelObj.EndDate = ""
        dcrParameterModelObj.DCRStatus = "0,3,"
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        return jsonString
    }
}
