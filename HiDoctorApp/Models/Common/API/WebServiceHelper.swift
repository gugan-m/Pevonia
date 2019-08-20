//
//  WebServiceHelper.swift
//  WebServiceWrapperDemo
//
//  Created by SwaaS on 30/09/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject
{
    static let sharedInstance = WebServiceHelper()
    
    //MARK: - Login screen
    func getCompanyDetails(companyName: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCompanyApi + wsGetCompanyDetails + companyName
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty)
        { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func postUserDetails(companyCode: String, userName: String, password: String,isVersionCode:Bool, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUser + wsGetUserAuthentication
        let appVersion = getCurrentAppVersion()
        let arrayData = appVersion.components(separatedBy: "(")
        let versionName = arrayData[0]
        var versionCode = String()
        if isVersionCode
        {
            versionCode = arrayData[1].components(separatedBy: ")")[0]
        }
        else
        {
            versionCode = EMPTY
        }
        let OSversion = UIDevice.current.systemVersion
        
        let postData: [String: Any] = ["CompanyCode": companyCode, "UserName": userName, "Password": password, "DeviceType": "iOS", "DeviceOSVersion": OSversion, "Key": "1", "VersionCode": versionCode, "VersionName": versionName, "Device_Model":UIDevice.current.modelName,"Device_Name":UIDevice.current.name,"Device_Release_Version":"","Ref_Number":getUniqueNumber()]
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getRequestPassword(companyCode: String, userName: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let slashString = "/"
        let mutableCompCode = companyCode + slashString
        let urlString = wsRootUrl + wsUserApi + wsRequestPassword + mutableCompCode + userName
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty)
        { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func checkUserSessionExist(companyCode: String, companyId: Int, userCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserApi + "CheckMultiDeviceLogin/" + companyCode + "/" + String(companyId) + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func clearAllSessions(companyCode: String, companyId: Int, userCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserApi + "ClearAllSessions/" + companyCode + "/" + String(companyId) + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    // MARK:- Prepare My Device
    func getUserPrivileges(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserApi + wsGetUserPrivileges + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCompanyConfigSettings(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCompanyApi + wsGetConfigSettings + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getWorkCategories(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsWorkCategoriesApi + wsGetWorkCategories + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getSpecialties(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsSpecialityApi + wsGetSpeciality + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getLeaveTypeMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsLeaveTypeApi + wsGetLeaveTypeMaster + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTravelModeMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTravelModeApi + wsGetTravelModes + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getProjectActivityMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsProjectActivityApi + wsGetActivity + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDetailedProductMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        //        let urlString = wsRootUrl + wsProductApi + wsGetSaleProducts + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        let urlString = wsRootUrl + wsProductApi + wsGetSaleProductsForSKU + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCampaignPlannerHeader(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetCampaignPlannerHeader + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCampaignPlannerSFC(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetCampaignPlannerSFC + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCampaignPlannerDoctors(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetCampaignPlannerDoctors + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getExpenseGroupMapping(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRExpenseApi + wsGetExpenseTypeWithGroup + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    private func getTourPlannerPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "TPStatus": "ALL", "Flag": "ALL"]
    }
    
    func getTourPlannerHeader(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPHeaderDetailsV61
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerSFC(postData : [String : Any] ,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPSFCDetailsV61
        
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerDoctor(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPDoctorsDetailsV61
        
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerAccompanist(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlan + wsGetTPAccompanistDetailsForDCR
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerProduct(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPProducts
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerUnfreezeDates(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTP + wsUnfreeze + wsDates
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDFCMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDFCApi + wsGetDFC + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getUserProductMapping(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsProductApi + wsGetUserProducts_V59 + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanists(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetAccompanistData + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        print(urlString)
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRCalendarDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRCalenderApi + wsGetDCRCalenderDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRHeaderDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRHeaderDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRTravelledPlacesDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRTravelledPlaces + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRAccompanistsDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRAccomapnists + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRDoctorVisitDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDoctorVisitDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    
    
    func getDCRChemistVisitOrderDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsOrder + wsOrderListV63
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) {
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getDCRDoctorVisitOrderDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsOrder + "OrderList"
        
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) {
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getDCRSampleDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRSampleDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRDetailedProducts(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDetailedProductsDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRChemistVisitDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRChemistVisitDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRRCPADetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRRCPADetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRCustomerFollowUpDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCR + wsDoctorVisit + wsFollowups
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRAttachmentDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCR + wsDoctorVisit + wsAttachment
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRStockistVisitDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRStockiestVisitApi + wsGetDCRStockiestVisitDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRExpenseDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRExpenseApi + wsGetDCRExpenseDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRAttendanceActivities(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDcrTimesheetEntry + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getSFCData(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsSFCApi + wsGetSFCData + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCustomerData(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + wsGetCustomerData + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCustomerDataByRegionCode(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + wsGetCustomerData + getCompanyCode() + "/" + userCode + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCustomerDataByRegionCodeForEdit(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + wsGetCustomerData60 + getCompanyCode() + "/" + userCode + "/" + regionCode + "/1,2,"
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getHolidayMaster(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsHolidayApi + wsGetHolidayDetails + getCompanyCode() + "/" + getRegionCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCompetitorProducts(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsProductApi + wsGetCompetitor + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRDoctorAccompanist(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDoctorAccompanist + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        print(urlString)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getUserTypeMenuAccess(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserApi + wsGetUserTypeMenuAccess + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    
    //MARK:- Prepare my device - Accompanist data
    private func getAccompanistDataPostData(regionCodeArray: [String]) -> [String: Any]
    {
        let postData: [String: Any] = ["lstAccompanist": regionCodeArray]
        
        return postData
    }
    
    func getAccompanistCustomerData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + wsGetAccompanistCustomerData + getCompanyCode() + "/" + getUserCode() + "/NA"
        
        let postData = getAccompanistDataPostData(regionCodeArray: accompanistRegionCodeArray)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistDetailedProductData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "Product/Region/" + "GetAccSaleProductsForSKU/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        var accompRegionArray :[String] = accompanistRegionCodeArray
        if accompanistRegionCodeArray.count > 0
        {
            
            accompRegionArray.append(getRegionCode())
        }
        
        var postValue = accompRegionArray.joined(separator: ",")
        postValue.append(",")
        
        let postData: [String: Any] = ["lstAccompanist": [postValue],"Request_Id":0]
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistSFCData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsSFCApi + wsGetAccompanistSFCData + getCompanyCode() + "/" + getUserCode() + "/NA"
        
        let postData = getAccompanistDataPostData(regionCodeArray: accompanistRegionCodeArray)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistCPHeaderData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetAccompanistCPHeader + getCompanyCode() + "/" + getUserCode() + "/NA"
        
        let postData = getAccompanistDataPostData(regionCodeArray: accompanistRegionCodeArray)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistCPSFCData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetAccompanistCPSFC + getCompanyCode() + "/" + getUserCode() + "/NA"
        
        let postData = getAccompanistDataPostData(regionCodeArray: accompanistRegionCodeArray)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistCPDoctorData(accompanistRegionCodeArray: [String], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCampaignPlannerApi + wsGetAccompanistCPDoctor + getCompanyCode() + "/" + getUserCode() + "/NA"
        
        let postData = getAccompanistDataPostData(regionCodeArray: accompanistRegionCodeArray)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Leave Entry
    
    func insertOnlineLeave(postData: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRUploadApi + wsOnlineInsertLeave + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- DCR Refresh
    func getDCRCalendarDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRCalendarApi/" + wsGetDCRCalenderDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRHeaderDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRHeaderDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRAccompanistDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRAccompanistV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRAccompanistInheritance(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/DCRInheritanceAccompanist"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRTravelledPlacesV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRTravelledPlacesV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRTimesheetEntryV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRTimeSheetEntryV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDoctorVisitDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDoctorVisitDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRChemistVisitDetails(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "Userperday/ChemistVisit/Details"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRStockistVisitDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRStockiestVisitApi + wsGetDCRStockiestVisitDetailsV59

        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDoctorAccompanistDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDoctorAccompanistV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRSampleDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRSampleDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDetailedProductsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRDetailedProductsDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRChemistVisitDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRChemistVisitDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRRCPADetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRRCPADetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRCustomerFollowUpDetails(jsonString : String?,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCR + wsDoctorVisit + wsFollowups
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRAttachmentDetails(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCR + wsDoctorVisit + wsAttachment
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
//    func getDCRStockistVisitDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
//    {
//        let urlString = wsRootUrl + wsDCRStockiestVisitApi + wsGetDCRStockiestVisitDetailsV59
//
//        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
//            completion(apiResponseObj)
//        }
//    }
    
    func getDCRExpenseDetailsV59(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRExpenseApi + wsGetDCRExpenseDetailsV59
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getChemistDayAccompanist(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistAccompanist
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDaySamplePromotion(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistSamplePromotion
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDayDetailedproducts(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistDetailedProductsDetails
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDayRCPAOwn(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistRCPAOwnProductDetails
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDayRCPACompetitor(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistRCPACompetitorProductDetails
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDayFollowups(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrChemistDayFollowups
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistDayAttachments(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrChemistDayAttachments
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getChemistsVisits(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsGetDCRChemistVisitDetails //+ getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPOBOrderDetails(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsOrder + wsOrderList
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPOBOrderDetailsV63(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsOrder + wsOrderListV63
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRLockLeaves(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRCalenderApi + wsGetLockLeaves + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getUserProductsV59(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsProductApi + wsGetUserProducts_V59 + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRCallActivities(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/DCRCallActivityDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRMCActivities(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/MCCallActivityDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    //Attendance Activity
    func getAttendanceDCRCallActivities(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/AttendanceDCRCallActivityDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAttendanceDCRMCActivities(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/AttendanceMCCallActivityDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func uploadDCR(dcrDate: String, dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRUploadApi + wsUploadDCRStagingV59 + "/" + getCompanyCode() + "/" + getUserCode() + "/" + dcrDate
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    // Menu Approval Access
    
    func approvalDCRApiCall(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRMenuAccess + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty)
        { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func webTPApprovalApiCall(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPMenuAccess + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func webDCRLeaveApprovalApi(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRMenuAccess + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func webDCRLockReleaseApi(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetLockedDataAccess + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func webDCRActivityLockReleaseApi(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetActivityLockedDataAccess  + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTPUserWiseAppliedList(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPUserWiseAppliedList + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRUserWiseAppliedList(completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRUserWiseAppliedList + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getLockReleaseUserWiseAppliedList(completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + wsGetLockRealseUserWiseList + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObj) in completion (apiResponseObj)
        }
    }
    
    func getActivityLockReleaseUserWiseAppliedList(completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + wsActivityLockedUniqueUserList + getCompanyCode() + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObj) in completion (apiResponseObj)
        }
    }
    
    func getTPUnfreezeReleaseUserWiseAppliedList(completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + "/TP/Unfreeze/UsersList/" + getCompanyCode() + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObj) in completion (apiResponseObj)
        }
    }
    
    //MARK:-APPROVAL
    
    //MARK:- DCR
    
    func getDCRMonthWiseCount(userCode : String , completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRMonthWiseCount + getCompanyCode() + "/" + userCode + "/" + "\(String(DCRStatus.applied.rawValue)),"
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRAccompanistForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRAccompanistForUserPerday
        let postData = getUserPostData(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRHeaderDetailsForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRHeaderDetailsForUserPerdayReport
        let postData = getUserPostData(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRTravelledPlacesForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRTravelledPlacesForUserPerday
        let postData = getUserPostData(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDoctorVisitDetailsForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRDoctorVisitDetailsForUserPerday
        let postData = getAccompanistsPostData(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRChemistVisitDetailsForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + userperdayChemistVisitDetails
        let postData = getAccompanistsPostData(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
        
    }
    
    
    func getDCRStockiestVisitDetailsForUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRStockiestVisitDetailsForUserPerday
        let postData = getAccompanistsPostData(userObj: userObj)
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRExpenseDetailsUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
        
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRExpenseDetailsUserPerday
        let postData = getUserPostData(userObj: userObj)
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRActivityDetailsUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
        
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRTimeSheetEntryForUserPerday
        let postData = getUserPostData(userObj: userObj)
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getDCRAttendanceSampleUserPerday(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
        
    {
        
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/UserPerday/AttendanceSamples"
        let postData = getUserPostData(userObj: userObj)
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    
    func getUserPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code!, "RegionCode": userObj.Region_Code!, "StartDate": userObj.Actual_Date, "EndDate": userObj.Actual_Date!,"DCRStatus": "ALL","Flag" : userObj.Activity_Id!]
    }
    
    //MARK:-Tp
    
    func getUserWiseTPAppliedList(userCode: String, regionCode: String,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
        
    {
        let UrlString = wsRootUrl + wsTourPlannerApi + wsGetAppliedTPlistforPerUser + getCompanyCode() + "/" + userCode + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObj) in completion (apiResponseObj)
            
        }
    }
    
    func getTpMonthWiseCount(userCode: String,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsGetTPMonthWiseCount + "/" + getCompanyCode() + "/" + userCode + "/" + String(TPStatus.applied.rawValue)
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAccompanistsPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,  "Flag" : "F","RegionCode": userObj.Region_Code, "StartDate": userObj.Actual_Date, "EndDate": userObj.Actual_Date,"DCRStatus": "ALL"]
    }
    
    func checkTPLock(dataArray: NSDictionary, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "TourPlan/CheckUnavailabilitylock/Release"
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func uploadTP(tpDate: String, dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsTPUploadV62 + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + tpDate
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK: DCR Doctor details
    //DCR ACCOMPANIST​​ details
    
    func getDCRAccompanistForUserPerdayReport(userObj: ApprovalUserMasterModel, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRAccompanistForUserPerdayReport
        let postData = getUserPostData(userObj: userObj)
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //Get DCRDoctor Visit User Per Day Report
    
    func getDCRADoctorVisitDetails(DCRCode: String, doctorVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI +  wsGetDCRADoctorVisitDetails + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDoctorAccompanistForADoctorVisit(DCRCode: String, doctorVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRDoctorAccompanistForADoctorVisit + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRSampleDetailsForADoctorVisit(DCRCode: String, doctorVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRSampleDetailsForADoctorVisit + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getDCRDetailedProductsDetailsForADoctorVisit(DCRCode: String, doctorVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRDetailedProductsDetailsForADoctorVisit + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDigitalAssetsForADoctorVisit(userCode: String, customerCode: String,dcrDate : String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserperday + wsCustomer + wsDAAnalytics + wsList + wsV1 + "/"  + getCompanyCode() + "/" + userCode + "/" + "\(dcrDate)" + "/" + customerCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRChemistVisitDetailsForADoctorVisit(DCRCode: String, doctorVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRChemistVisitDetailsForADoctorVisit + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRRCPADetailsForADoctorAndChemistVisit(DCRCode: String, doctorVisitCode: String, chemistVisitCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserPerdayReportAPI + wsGetDCRRCPADetailsForADoctorAndChemistVisit + getCompanyCode() + "/" + DCRCode + "/" + doctorVisitCode + "/" + chemistVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRAttachmentDetails(userCode : String, doctorVisitCode : String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserperday + wsDoctor + wsDCR + wsAttachments + getCompanyCode() + "/" + userCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRFollowUpsDetails(userCode : String, doctorVisitCode : String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserperday + wsDoctor + wsDCR + wsFollowups + getCompanyCode() + "/" + userCode + "/" + doctorVisitCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    
    //MARK:- Approval Update Status
    
    func  updateDCRStatus(postData : NSArray , userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsUpdateDCRStatus +
            getCompanyCode()  + "/" +  userObj.User_Code  +  "/" + userObj.Region_Code  + "/" + userObj.activityMonth + "/" + userObj.activityYear
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func  updateTpStatus(postData : NSArray , userObj : ApprovalUserMasterModel, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsTourPlannerApi + wsUpdateTPStatus +
            getCompanyCode()  + "/" +  userObj.User_Code  +  "/" + userObj.activityMonth + "/" + userObj.activityYear
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Leave Approve/Reject Status
    
//    func  updateLeaveStatus(postData : NSArray , userObj : ApprovalUserMasterModel, leaveObj : LeaveApprovalModel, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
//    {
//
//        let urlString = wsRootUrl + wsLeaveAppoveAndReject + wsUpdateLeaveDCRStatus + getCompanyCode()  + "/" +  userObj.User_Code  +  "/" + userObj.Region_Code
//
//        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
//            completion(apiResponseObject)
//        }
//    }
    
    
    // test 1
    func  updateLeaveStatus1(postData : NSArray , leaveObj : LeaveApprovalModel, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        
        let leaveUrl = wsRootUrl + wsLeaveAppoveAndReject + wsUpdateLeaveDCRStatus + getCompanyCode()
            
        let leaveString = "/" +  leaveObj.userCode!  +  "/" + leaveObj.regionCode!
        
        let urlString = leaveUrl + leaveString
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    
    
    //MARK:- Lock Release
    func getLockLeaveDetailsForUser(userCode: String, regionCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsgetLockedDetailsForPeruser + getCompanyCode() + "/" + userCode + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getActivityLockLeaveDetailsForUser(userCode: String, regionCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + "DCRActivityLock/" + getCompanyCode() + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getTPFreezeDetailsForUser(userCode: String, selectedMonth: String,selectedYear:String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "TP/UnfreezeDetails/" + getCompanyCode() + "/" + userCode + "/" + selectedMonth + "/" + selectedYear
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func unlockDCR(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsUpdateDCRLockToRelease + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func unlockTPFreeze(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "TP/freezerelease/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func unlockDCRActivityLock(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsUpdateDCRActivityLockToRelease + getCompanyCode()
        
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: dataArray[0] as? [String : Any], stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRLockHistory(userCode : String , regionCode : String , pageNo : Int ,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl +  wsDCRHeaderApi + wsGetReleaseHistoryDetails + getCompanyCode() + "/" + userCode + "/" + regionCode + "/" + String(pageNo)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func getDCRLockActivityHistory(userCode : String,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl +  wsDCRHeaderApi + "DCRActivityLockHistory/" + getCompanyCode() + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    //MARK: DCR Approval
    func getSelectedUserDCRDetails(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + wsGetSelectedUserDCRDetails + getCompanyCode() + "/" + userCode + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty){ (apiResponseObj) in completion (apiResponseObj)
            
        }
    }
    
    //check user Authentication
    func getCheckUserExist(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        //      let UrlString = wsRootUrl + wsUserApi + wsCheckUserExist + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        //        let UrlString = wsRootUrl + wsUserApi + "CheckUserExistsWithSessionID/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + String(getSessionId())
        //
        //        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
        //            completion (apiResponseObj)
        //        }
        
        let urlString = wsRootUrl + wsUserApi + wsCheckUserExistWithSessionId
        let postData = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"regionCode":getRegionCode(),"sessionId":getSessionId(),"Password":getUserPassword()] as [String : Any]
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName:  ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
        //http://hdwebapi-dev.hidoctor.me/UserApi/CheckUserExistsWithSessionID/V2
    }
    
    //MARK:- Dashboard
    func getDashboardDetailsForSelf(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + wsGetDashboardDetails + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardAppliedDCRDates(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + wsGetAppliedDCRDates + getCompanyCode() + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardMissedDoctors(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + wsGetMissedDoctors + getCompanyCode() + "/" + userCode + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardDetailsForTeam(userCode: String, regionCode: String, summaryFlag: Int, entityId: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + wsGetDashboardDetails_V61 + getCompanyCode() + "/" + userCode + "/" + regionCode + "/" + String(summaryFlag) + "/" + String(entityId)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardPSValues(postData : [String : Any],completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDashboard + wsGetDashboardPSValues
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName:  ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardPSDetailsValues(postData : [String : Any],completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDashboard + wsGetDashboardPSProductValues
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName:  ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardCollectionValues(postData : [String : Any],completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDashboard + wsDashboardCollectionValues
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName:  ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardAssetWiseCount(postData : [String : Any],completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUser + wsAsset +  wsUsage + wsCount
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardAssetListForSelf(postData : [String : Any], completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUser + wsAsset + wsDashboardAssetDetails
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardTopTenAssets(regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboard + wsTop10Asset + getCompanyCode() + "/"  + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardTopTenDoctors(regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboard + wsTop10Doctor + getCompanyCode() + "/"  + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    
    
    //MARK:- User per day Report
    func getDCRHeaderDetailsV59Report(postData : [String: Any] , completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + wsGetDCRHeaderDetailsV59
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //MARK:- Change Password
    func updateResetPassword(userObj: UserChangePasswordModel, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsUserApi + wsUpdateResetPassword + getCompanyCode()
        
        let postData = updatePasword(userObj: userObj)
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func updatePasword(userObj : UserChangePasswordModel) -> [String: Any]
    {
        return ["New_Password":userObj.New_Password,
                "Old_Password":userObj.Old_Password,
                "User_Name":getUserName(),
                "User_Code":getUserCode()]
    }
    
    func checkDCRExist(userCode: String, dcrDate: String, flag: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + wsCheckDCRExist + getCompanyCode() + "/" + userCode + "/" + dcrDate + "/" + String(flag)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- DCR Doctor Visit Tracker
    func  sendHourlyReport(postData : NSArray, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + wsInsertDoctorVisitTracker +
            getCompanyCode()  + "/" +  getUserCode()  + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:-Hourly Report
    func getDoctorVisitDetailsForDate(userCode : String , startDate : String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsHDReportsApi + wsGethourlyRpt + getCompanyCode() + "/" + userCode + "/" + startDate + "/" + startDate
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getHourlyReportSummary(userObj : UserMasterModel, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsHDReportsApi + wsGethourlyRptSummary + getCompanyCode() + "/" + userObj.User_Code + "/" + convertDateIntoServerStringFormat(date: userObj.User_Start_Date) + "/" + convertDateIntoServerStringFormat(date: userObj.User_End_Date)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getTravelTrackingReport(userObj : UserMasterModel, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsGetTravelTrackReportSummary + getCompanyCode() + "/" + userObj.User_Code + "/" + convertDateIntoServerStringFormat(date: userObj.User_Start_Date) 
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    
    //MARK:- Edetailing
    func getAssetHeaderDetails(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsUser + wsAsset + wsHeader + wsList + wsV1
        let postData = getAssetPostData()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAssetTagDetails(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsUser + wsAsset + wsDetails + wsList + wsV1
        let postData = getAssetPostData()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAssetPartDetails(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsUser + wsAsset + wsImages + wsList + wsV1
        let postData = getAssetPostData()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty){ (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAssetAnalyticsDetails(postData : [String: Any], completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsAsset + wsCustomerwiseAnalyticsDetails + wsList + wsV1
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAssetAnalyticsDetail(postData: String?, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsAsset + wsCustomerwiseAnalyticsDetails + wsList + wsV1
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: postData, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAssetStoryDetails(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsStory
        let postData = getAssetStoryPostData()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDoctorProductMappingPageInfo(regionCodes: String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/CustomerProductmappedCount/V2/" + regionCodes + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getAllDoctorProductMapping(postData:[String:Any],regionCodes: String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/DPMDoctorAndProductsMapped"
        
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
        
    }
    
    func getDoctorProductMappingDetails(regionCodes: String, pageNo: Int, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/CustomerProductmappedDetails/V2/" + regionCodes + "/" + getCompanyCode() + "/" + getUserCode() + "/"  + String(pageNo) + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getMCDoctorProductMappingPageInfo(regionCodes: String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/MCCustomerProductmappingCount/V2/" + regionCodes + "/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getMCDoctorProductMappingDetails(regionCodes: String, pageNo: Int, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/MCCustomerProductmapping/V2/" + regionCodes + "/" + getCompanyCode() + "/" + getUserCode() + "/"  + String(pageNo) + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getCustomerAddressCount(postData: [String : Any], completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/CustomerGpsDataCount/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func getCustomerAddressDetails(postData: [String : Any], completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "CustomerApi/CustomerGpsData/V2/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func uploadCustomerAddress(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/CustomerGpsAddressUpdate/" + getCompanyCode() + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    private func getAssetPostData() -> [String : Any]
    {
        let userObj = getUserModelObj()
        return ["companyCode" : getCompanyCode(),"userCode": (userObj?.User_Code)!,"regionCode" :(userObj?.Region_Code)!,"userTypeCode" :"","companyId": getCompanyId(),"utcOffset" : getCurrentTimeZone()]
    }
    
    private func getAssetStoryPostData() -> [String : Any]
    {
        return ["Company_Code":getCompanyCode(),"Region_Code":getRegionCode()]
    }
    
    //MARK:- NOTICEBOARD
    func getNoticeBoardDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsNoticeBoardListV1
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    func postNoticeBoardDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsNoticeBoardReadV1
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    //MARK:- CopyTourPlanAccompanist
    
    func postCopyTourPlanAccompanist(postData : [String : Any], urlString:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Mail Messages
    func getMailMessages(postData : [String : Any], completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsMails + wsV1
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func getUserFromMessaging(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsMessaging + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) {(apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    func deleteMailMessage(messageType: String, rowStatus: Int, postData: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsMessagingApi + wsUpdateMessageStatus_V61 + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + String(rowStatus) + "/" + messageType
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func updateMessageStatusAsRead(messageCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "MessageApi/UpdateMessageReadStatusForIos/" + getCompanyCode() + "/" + getUserCode() + "/" + messageCode
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func sendMail(postData: NSDictionary, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "MessageApi/InsertMessage_V61/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Alerts
    func getUnreadNoticeCount(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "NoticeBoardApi/GetUnreadNoticeCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getUnreadMessageCount(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + "MessageApi/GetUnreadMessageCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- Logout
    func logout(companyCode: String, companyId: String, userCode: String, sessionId: String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        
        let urlString  = wsRootUrl + "UserApi/ClearSessionsBySessionId/" + companyCode + "/" + companyId + "/" + userCode + "/" + sessionId
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- EDetailing_Product_Mapping Api
    func getEdetailingProductMappingData(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let urlString  = wsRootUrl + wsAssetProductMappingDetails + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- GetSearchUserWiseAppliedCount
    func getDCRSearchUserWiseAppliedList(searchType: Int,searchText: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsDCRHeaderApi + "GetSearchDCRUserWiseAppliedCount_V77/" + getCompanyCode() + "/" + String(searchType) + "/" + searchText + "/" + getUserCode()
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getTPSearchUserWiseAppliedList(searchType: Int,searchText: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + wsTourPlannerApi + "GetSearchTPUserWiseAppliedCount_V77/" + getCompanyCode() + "/" + String(searchType) + "/" + searchText + "/" + getUserCode()
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    //MARK:- ChemistDay
    //get
    func getChemistVisitPerDay(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + chemistVisitPerDay + getCompanyCode() + "/" + dcrCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserperdayChemistVisitAccompanist(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitAccompanist + getCompanyCode() + "/" + dcrCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserperdayChemistVisitFollowups(visitId: String, userCode: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitFollowups +  getCompanyCode() + "/" + userCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserperdayChemistVisitAttachments(visitId: String, userCode: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitAttachments +  getCompanyCode() + "/" + userCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserperdayChemistVisitSamplePromotion(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitSamplePromotion + getCompanyCode() + "/" + dcrCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    func getUserperdayChemistVisitDetailedProducts(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitDetailedProducts + getCompanyCode() + "/" + dcrCode + "/" + visitId
        
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    func getUserperdayChemistVisitRCPAOwnProducts(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitRCPAOwnProducts + getCompanyCode() + "/" + dcrCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserperdayChemistVisitRCPACompetitorProducts(dcrCode: String,visitId: String ,completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userperdayChemistVisitRCPACompetitorProducts + getCompanyCode() + "/" + dcrCode + "/" + visitId
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    func getUserModuleAccess(completion: @escaping(_ apiResponseObj: ApiResponseModel) -> ())
    {
        let UrlString = wsRootUrl + userApiModuleWiseAccess + getCompanyCode() + "/" + getRegionCode()
        let encodeUrl = UrlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        
        WebServiceWrapper.sharedInstance.getApi(urlString: encodeUrl!, screenName: ScreenName.Empty){ (apiResponseObject) in
            completion (apiResponseObject)
        }
    }
    
    //post
    func postDCRChemistAccompanist(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistAccompanist
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func postDCRChemistSamplePromotion(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistSamplePromotion
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    func postDCRChemistDetailedProductsDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistDetailedProductsDetails
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func postDCRChemistRCPAOwnProductDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistRCPAOwnProductDetails
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func postDCRChemistRCPACompetitorProductDetails(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrDoctorVisitAPIGetDCRChemistRCPACompetitorProductDetails
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    func postDCRChemistDayFollowups(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrChemistDayFollowups
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    func postDCRChemistDayAttachments(postData : [String : Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + dcrChemistDayAttachments
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func getSpecialityNameList(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsCustomerApi + wsCustomerSpeciality + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getCustomerCategoryNameList(regionCode : String,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsCustomerApi + wsCustomerCategory + getCompanyCode() + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getMasterDataDownloadAlert(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + "GetMasterDataDownloadCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getMasterDataDownloadAlertMessage(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + "MasterDataDownloadInfo/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getSplashScreenData(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + "TodaySplashScreen/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func updateMasterDataDownloadedAlert(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsDCRHeaderApi + "UpdateMasterDataDownloadCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getPendingDoctorApprovalUserList(customerStatus: Int,searchType: Int,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + "Pending/Doctor/ApprovalCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + "\(customerStatus)/" + "\(searchType)"
        
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getPendingDoctorApprovalUserListSearch(customerStatus: Int,searchString: String,searchType: Int,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString1 = wsRootUrl + wsCustomerApi + "Search/Doctor/ApprovalCount/" + getCompanyCode() + "/" + getUserCode() + "/"
        let urlString2 = getRegionCode() + "/\(searchType)/" + "\(searchString)/" + "\(customerStatus)"
        let urlString = urlString1 + urlString2
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDoctorApprovalDoctorDetail(regionCode: String,customerStatus: Int,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + "Search/Doctor/Details/" + getCompanyCode() + "/" + regionCode + "/" + "\(customerStatus)"
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func doctorApproveReject(postData : [String:Any],regionCode: String,customerStatus: Int,userConformation: Int,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + "Doctor/Approval/Details/" + getCompanyCode() + "/\(regionCode)/" + "\(customerStatus)/" + getUserName() + "/" + getUserCode() + "/\(userConformation)"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getDoctorVisitCount(date: String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsCustomerApi + "Update/Doctor/VisitCount/" + getCompanyCode() + "/\(getUserCode())/" + "\(getRegionCode())/" + date
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func confirmPassword(password: String,completion: @escaping(_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "Confirm/Password"
        
        let postData: [String: Any] = ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "Password": password]
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    
    //MARK:- Password Policy
    func getUserAccountDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "User/AccountDetails/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Activity and MCActivity
    func getActivityDetails(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let userDetail = DBHelper.sharedInstance.getUserDetail()
        let userTypeName = userDetail?.userTypeCode as! String
        let urlString = wsRootUrl + "/CustomerApi/CallActivityBasedOnEntity/" + getCompanyCode() + "/" + getUserCode() + "/" + getUserTypeCode() + "/" + getRegionCode() + "/" + userTypeName
        //"https://api.myjson.com/bins/r9s7f"
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Inward Acknowledgement
    
    func getInwardChalanListWithProduct(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ProductApi/GetInwardACK/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getInwardRemarkDetails(detailId:Int,batchNumber:String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ProductApi/GetInwardAckRemarks/" + getCompanyCode() + "/" + "\(detailId)/" + batchNumber
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func postInwardAckDetails(postData:NSMutableArray,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ProductApi/SaveInwardAck/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
        
    }
    
    //MARK:- Expense Approvel
    func getExpenseApproval(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let postData : [String : Any] = ["CompanyCode":getCompanyCode(),"User_Code":getUserCode(),"User_Type_Code":getUserTypeCode(),"Search_Key":""]
        let urlString = wsRootUrl + "Pending/ExpenseClaimApproval"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
            
        }
    }
    func getDCRInhetitanceDoctors(postData: [String: Any], completion: @escaping(_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/DCRInheritance"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func checkAccompanistEnteredDCRForInheritance(accompanistUserCode: String, dcrDate: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitAPI/InheritanceAccompanistCount/" + getCompanyCode() + "/" + getUserCode() + "/" + accompanistUserCode + "/" + dcrDate
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getExpenseApprovalAttachmentList(claimCode:String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ExpenseClaim/Attachments/" + getCompanyCode() + "/" + claimCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //https://api.myjson.com/bins/10sbub
    func getExpenseApprovalDetailList(userCode:String,claimCode:String,fromDate:String,toDate:String,cycleCode:String,moveOrder:String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        //ExpenseClaimDetails/{companyCode}/{User_Code}/{claimCode}/{DCR_From_Date}/{DCR_To_Date}/{Cylce_Code}/{Move_Order}/{LoginUserCode
        let urlString = wsRootUrl + "ExpenseClaimDetails/" + getCompanyCode() + "/" + userCode + "/" + claimCode + "/" + fromDate + "/" + toDate + "/" + cycleCode + "/" + moveOrder + "/" + getUserCode()
        //"https://api.myjson.com/bins/1geuov"
        //https://api.myjson.com/bins/10sbub"
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getExpenseViewDetailList(userCode:String,claimCode:String,claimDate:String,flag:String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        //ClaimDetails/{companyCode}/{UserCode}/{claimCode}/{Flag}/{ClaimDate}
        let urlString = wsRootUrl + "ClaimDetails/" + getCompanyCode() + "/" + userCode + "/" + claimCode + "/" + flag + "/" + claimDate
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func approveExpenseClaim(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "Expense/Approve"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
            
        }
    }
    
    func bulkApproveExpenseClaim(paymentMode:String,postData:NSMutableArray,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "Expense/MultipleApprove/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + paymentMode
        
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func customerComplaintPost(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "CustomerApi/Customer/Complaint"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCustomerComplaints(regionCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/Customer/ComplaintDetails/" + getCompanyCode() + "/" + regionCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
        
    }
    
    func uploadErrorLog(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "UserApi/ErrorHandling/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- ICE/Task
    func getICEFeedbackQuestions(userCode: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/ActiveQuestions/" + getCompanyCode() + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
        
    }
    
    func getICEDate(userName:String,userCode:String,fromDate:String,toDate:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/JointWorkDates/" + getCompanyCode() + "/" + getUserCode() + "/" +  getUserName() + "/" + userCode + "/" + userName + "/" + fromDate + "/" + toDate
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getIceFeedBackList(userCode:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/FeedbackHistory/" + getCompanyCode() + "/" + userCode
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
        
    }
    
    func getFeedbackHistory(feedbackId:Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/FeedbackHistoryDetails/" + getCompanyCode() + "/" + "\(feedbackId)"
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
        
    }
    
    func postIceRatings(selectedUserCode:String,createdBy:String,evaluatedDate:String,postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "CustomerApi/FeedbackSave/" + getCompanyCode() + "/" + selectedUserCode + "/" + createdBy + "/" + evaluatedDate
        
        WebServiceWrapper.sharedInstance.postApi(urlString:urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTaskList(mode:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/UserTasks/" + getCompanyCode() + "/" + getUserName() + "/" + mode
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func createTask(userCode:String,postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "CustomerApi/TaskSave/" + getCompanyCode() + "/" + userCode + "/" + getUserName()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllTaskList(userCode:String,mode:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/GetTasks/" + getCompanyCode() + "/" + userCode + "/" + mode + "/" + getUserName()
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTaskHistory(userCode:String,completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/TaskHistory/" + getCompanyCode() + "/" + userCode + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func postTaskStatus(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/UpdateTask/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getCodeOfConduct(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "/CustomerApi/CodeOfConduct/" + getCompanyCode() + "/" + getUserCode() + "/" + getUserTypeCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func postCOdeOFConductAccknowledgement(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/SaveAcknowledegementInfo/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getFollowUpTaskList(mode:String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/GetFollowupTask/" + getCompanyCode() + "/" + getUserCode() + "/" + mode
        
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTaskANdFollowUPCount(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "CustomerApi/TaskCount/" + getCompanyCode() + "/" + getUserCode() + "/" + getUserName()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //DCRDoctorVisitApi/InsertEdetailingDoctorDelete/TEO00000010
    func insertEdetailingDoctorDelete(dataArray: NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitApi/InsertEdetailingDoctorDelete/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.postApiWithAnyObject(urlString: urlString, dataDictionary: dataArray, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Competitor Product
    func getCompetitorMapping(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/Competitor/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getProductCompetitorMapping(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/GetUserProducts/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllSpeciality(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/Speciality/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllBrand(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/Brand/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllCategory(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/Category/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllUOM(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/UOM/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getAllUOMType(completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        
        let urlString = wsRootUrl + "ProductApi/UOMType/" + getCompanyCode()
        WebServiceWrapper.sharedInstance.getApi(urlString:urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func newProductAndCompetitor(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ProductApi/InsertNewCompetitorMaster/" + getCompanyCode() + "/" + getUserName()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRCompetitor(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "ProductApi/DCRCompetitorDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //MARK:- Attendance Sample
    
    func getDCRAttendanceSample(jsonString: String?, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRDoctorVisitApi/AttendanceDoctorDetails"
        
        WebServiceWrapper.sharedInstance.postApiWithJSON(urlString: urlString, jsonString: jsonString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //MARK:- Master Data Download detail sync to server
    
    func syncMasterDataDownloadDetails(postData:[String:Any],completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + "DCRHeaderApi/SaveMasterData"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Dashboard api
    
    //DCRAppliedCount
    
    func getDashboardDetailsDCRAppliedCountForSelf(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "DCRAppliedCount/Self/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardDetailsDCRAppliedCountForTeam(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "DCRAppliedCount/Team/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //TPAppliedCount
    func getDashboardDetailsTPAppliedCountForSelf(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "TPAppliedCount/Self/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardDetailsTPAppliedCountForTeam(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "TPAppliedCount/Team/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //ChemistCallAverage
    func getDashboardDetailsChemistCallAverageForSelf(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "ChemistCallAverage/Self/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDashboardDetailsChemistCallAverageForTeam(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsDashboardApi + "ChemistCallAverage/Team/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- Force Update
    
    func isAppUpdateAvailable(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsCompanyApi + "GetAppDetails/" + getCompanyCode() + "/" + "iOS"
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- Inward Skip
    
    func inWardSkipRemarks(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let urlString = wsRootUrl + "ProductApi/InsertInwardAckSkipRemarks/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- User Parent Hierarchy
    
    func getUserParentHierarchy(userCode:String,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        let UrlString = wsRootUrl + wsParentHierarchy + getCompanyCode() + "/" + userCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    //MARK:- User Parent Hierarchy
    
    func getDCRUploadErrorMessage(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        
        let UrlString = wsRootUrl + wsDCRHeaderApi + "DcrUploadvalidation/" + getCompanyCode() + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
        
    }
    
    //MARK:- DPM General,Target,MC
    
    func getAllMCDetails(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        
        let UrlString = wsRootUrl + wsCustomerApi + "GetMCDPM/" + getCompanyCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
        
    }
    
    func getDPMParentUsers(selectedRegionCode:String,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        
        let UrlString = wsRootUrl + wsCustomerApi + "DPMParentHierarchyRegion/" + getCompanyCode() + "/" + selectedRegionCode + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getDPMParentUsersByCampaignCode(selectedRegionCode:String,campaignCode: String,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ()){
        
        let UrlString = wsRootUrl + wsCustomerApi + "DPMParentHierarchyCampaignCode/" + getCompanyCode() + "/" + selectedRegionCode + "/" + getRegionCode() + "/" + campaignCode
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func deleteDoctorProductMapping(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let urlString = wsRootUrl + wsCustomerApi + "Delete/DoctorProductMapping"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    // Division Mapping Details
    
    func getDivisionMappingDetails(completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let UrlString = wsRootUrl + wsCustomerApi + "GetDivisionEntityMapping/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: UrlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
        
    }
    
    // Save GM and TM
    func saveDPMCustomerMapping(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "Insert/DoctorProductMapping/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func saveDPMProductMapping(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "Insert/ProductDoctorMapping/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func saveDPMCampaignCustomerMapping(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "MC/DoctorProductMapping/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func saveDPMCampaignProductMapping(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "MC/ProductDoctorMapping/" + getCompanyCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func deleteDPMCampaignCustomer(postData:[String:Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "Delete/DoctorProductMapping"
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDocumentData(completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let urlString = wsRootUrl + wsCompanyApi + "MyDocuments/" + getCompanyCode() + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObj) in
            completion (apiResponseObj)
        }
    }
    
    func getbusinessStatus(postData:[String: Any],completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsCustomerApi + "GetBusinessStatusPrefill/" + getCompanyCode() + "/" + getUserTypeCode()
        
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func gethourlyReportCustomer(completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + wsDCRDoctorVisitApi + "CustomerVisitTracking/" + getCompanyCode() + "/" + getUserCode() + "/" + getCurrentDate()
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    //MARK:- Pending Leave Approval
    func pendingLeaveApproval(userCode: String, status: Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let urlString = wsRootUrl + wsLeaveApproval + wsPendingApprovalLeave + "/" + getCompanyCode() + "/" + userCode + "/" + String(status)
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getcalendarnotes(completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let temp: String = getCurrentDate() as String
        let year: String = String(temp.prefix(4))
        let tempmonth: String = String(temp.suffix(5))
        let month: String = String(tempmonth.prefix(2))
        let urlString = wsRootUrl + "QuickNoteApi/" + "Notifications/" + getCompanyCode() + "/" + getUserCode() + "/" + month + "/" + year
        
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func createnotes(postData: [String:Any] , key: String ,completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        
        let urlString = wsRootUrl + "QuickNoteApi/" + "Note/action/" + getCompanyCode() + "/" + getUserCode() + "/" + date + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.multipartpostApi(url: urlString, data: postData, key: key, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getcalendarnoteslist(completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        let temp: String = date
        let urlString = wsRootUrl + "QuickNoteApi/" + "Notes/" + getCompanyCode() + "/" + getUserCode() + "/" + temp + "/" + temp
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getcalendartaskslist(completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        let temp: String = date
        let urlString = wsRootUrl + "QuickNoteApi/" + "Tasks/" + getCompanyCode() + "/" + getUserCode() + "/" + temp + "/" + temp
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func createTasks(postData: [String:Any] , key: String ,completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        
        let urlString = wsRootUrl + "QuickNoteApi/" + "Task/action/" + getCompanyCode() + "/" + getUserCode() + "/" + date + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.multipartpostApi(url: urlString, data: postData, key: key, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func deletenotes(postData: [String:Any], id: Int, date: String, completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let urlString = wsRootUrl + "QuickNoteApi/Notes/action/deactivate/" + getCompanyCode() + "/" + getUserCode() + "/" + String(id) + "/" + date + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func updatestatustask(postData: [String:Any], id: Int, taskid: Int, date: String, completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        let urlString = wsRootUrl + "QuickNoteApi/Task/action/" + getCompanyCode() + "/" + getUserCode() + "/" + String(id) + "/" + String(taskid) + "/" + date + "/" + getUserCode()
        WebServiceWrapper.sharedInstance.postApi(urlString: urlString, dataDictionary: postData, stringData: nil, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func editnotes(postData: [String:Any] , key: String ,id: Int,completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        
        let urlString = wsRootUrl + "QuickNoteApi/" + "Notes/" + getCompanyCode() + "/" + getUserCode() + "/" + date + "/" + String(id) + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.multipartpostApi(url: urlString, data: postData, key: key, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func editTasks(postData: [String:Any] , key: String ,id: Int, completion: @escaping (_ apiResponseObj:ApiResponseModel)->(), date: String)
    {
        
        let urlString = wsRootUrl + "QuickNoteApi/" + "Task/" + getCompanyCode() + "/" + getUserCode() + "/" + date + "/" + String(id) + "/" + getUserCode()
        
        WebServiceWrapper.sharedInstance.multipartpostApi(url: urlString, data: postData, key: key, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    func getcalendarnotesyear(year: String ,completion: @escaping (_ apiResponseObj:ApiResponseModel)->())
    {
        
        let urlString = wsRootUrl + "QuickNoteApi/Calendar/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode() + "/" + year
        WebServiceWrapper.sharedInstance.getApi(urlString: urlString, screenName: ScreenName.Empty) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
}
