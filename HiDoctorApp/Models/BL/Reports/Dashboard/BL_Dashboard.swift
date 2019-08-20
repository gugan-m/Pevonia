//
//  BL_Dashboard.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Dashboard: NSObject
{
    static let sharedInstance = BL_Dashboard()
    var dashboardDetails: NSArray = []
    var dashboardTeamDetails : NSArray = []
    var dashboardAppliedDCRDates: NSArray = []
    var dashboardMissedDoctors: NSArray = []
    var dashBoardPSDetails : NSArray = []
    var dashBoardCollectionValues : NSArray = []
    var dashBoardPSProductValues : NSArray = []
    var dashBoardAssetCountListValues : NSArray = []
    var totalAssetCount : Int?
    
    struct DashboardId
    {
        static let SelfId : Int = 0
        static let TeamId : Int = 1
    }
    
    //MARK:- Public Functions
    //MARK:-- Web Service Functions
    func callAllAPI(type : Int , completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        clearAllArray()
        
        if checkIsToShowPSDetails()
        {
            callAPIForPSDetails(type: type, completion: { (apiResponseObject) in
                completion(apiResponseObject)
            })
        }
        else
        {
            if type == DashboardId.SelfId
            {
                callAllAPIsForSelf(completion: { (apiResponseObject) in
                    completion(apiResponseObject)
                })
            }
            else
            {
                getDashboardDetailsForTeam(completion: { (apiResponseObject) in
                    completion(apiResponseObject)
                })
            }
        }
    }
    
    func callAPIForPSDetails(type : Int,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        getPSDetails(type: type) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                self.dashBoardPSDetails = apiResponseObj.list
                
                self.getPSProductDetails(type: type) { (apiResponseObj) in
                    
                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                    {
                        self.dashBoardPSProductValues = apiResponseObj.list
                        
                        self.getDashboardCollectionDetails(type: type) { (apiResponseObj) in
                            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                            {
                                self.dashBoardCollectionValues = apiResponseObj.list
                                self.psAPICallBack()
                                
                                if type == DashboardId.SelfId
                                {
                                    self.callAllAPIsForSelf(completion: { (apiResponseObject) in
                                        completion(apiResponseObject)
                                    })
                                }
                                else
                                {
                                    self.getDashboardDetailsForTeam(completion: { (apiResponseObject) in
                                        completion(apiResponseObject)
                                    })
                                }
                            }
                            else
                            {
                                completion(apiResponseObj)
                            }
                        }
                    }
                    else
                    {
                        completion(apiResponseObj)
                    }
                }
            }
            else
            {
                completion(apiResponseObj)
            }
        }
    }
    
    func callAllAPIsForSelf(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        clearAllArray()
        
        WebServiceHelper.sharedInstance.getDashboardDetailsForSelf { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                self.dashboardDetails = apiResponseObj.list
                
                WebServiceHelper.sharedInstance.getDashboardAppliedDCRDates(userCode: getUserCode(), regionCode: getRegionCode(), completion: { (apiResponseObj) in
                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                    {
                        self.dashboardAppliedDCRDates = apiResponseObj.list
                        
                        WebServiceHelper.sharedInstance.getDashboardMissedDoctors(userCode: getUserCode(), regionCode: getRegionCode(), completion: { (apiResponseObj) in
                            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                            {
                                self.dashboardMissedDoctors = apiResponseObj.list
                                self.getDashboardSelfAssetCount(completion: { (apiResponseObj) in
                                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                                    {
                                        self.dashBoardAssetCountListValues = apiResponseObj.list
                                        
                                        self.selfAPICallBack(userCode: getUserCode(), regionCode: getRegionCode())
                                        completion(apiResponseObj)
                                    }
                                    else
                                    {
                                        completion(apiResponseObj)
                                    }
                                })
                            }
                            else
                            {
                                completion(apiResponseObj)
                            }
                        })
                    }
                    else
                    {
                        completion(apiResponseObj)
                    }
                })
            }
            else
            {
                completion(apiResponseObj)
            }
        }
    }
    
    func getDashboardSelfAssetCount(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetailsForAsset(entityId: 1, type: 0) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDashboardTeamAssetCount(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetailsForAsset(entityId: 2, type: 1) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDashboardDetailsForTeam(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetails(userCode: getUserCode(), regionCode: getRegionCode(), summaryFlag: 1, entityId: Constants.DashboardEntityIDs.All_Entities) { (apiResponseObj) in
            if apiResponseObj.list.count > 0
            {
                self.dashboardTeamDetails = apiResponseObj.list
            }
            self.getDashboardTeamAssetCount(completion: { (apiResponseObj) in
                completion(apiResponseObj)
            })
        }
    }
    
    func getMissedDoctorRegions(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetails(userCode: userCode, regionCode: regionCode, summaryFlag: 0, entityId: Constants.DashboardEntityIDs.Doctor_Missed) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPendingDCRApprovalUserList(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetails(userCode: userCode, regionCode: regionCode, summaryFlag: 0, entityId: Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPendingTPApprovalUserList(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        self.getDashboardDetails(userCode: userCode, regionCode: regionCode, summaryFlag: 0, entityId: Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getAppliedDCRDates(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardAppliedDCRDates(userCode: userCode, regionCode: regionCode) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getMissedDoctorDetails(userCode: String, regionCode: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardMissedDoctors(userCode: userCode, regionCode: regionCode) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPSDetails(type : Int,completion : @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let postData = getPostDataForPS(type: type)
        WebServiceHelper.sharedInstance.getDashboardPSValues(postData: postData) { (apiReponseObj) in
            completion(apiReponseObj)
        }
    }
    
    func getPSProductDetails(type : Int,completion : @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let postData = getPostDataForPS(type: type)
        WebServiceHelper.sharedInstance.getDashboardPSDetailsValues(postData: postData) { (apiReponseObj) in
            completion(apiReponseObj)
        }
    }
    
    func getDashboardCollectionDetails(type : Int,completion : @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        let postData = getPostDataForPS(type: type)
        WebServiceHelper.sharedInstance.getDashboardCollectionValues(postData: postData) { (apiReponseObj) in
            completion(apiReponseObj)
        }
    }
    
    func getDashboardTop10Asset(type : Int,completion : @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardTopTenAssets(regionCode: "") { (apiReponseObj) in
            completion(apiReponseObj)
        }
    }
    
    func getDashboardTop10Doctor(type : Int,completion : @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardTopTenDoctors(regionCode: "") { (apiReponseObj) in
            completion(apiReponseObj)
        }
    }
    
    func getDashboardEdetailingHeight() -> CGFloat
    {
        if SwifterSwift().isPhone
        {
            return 312
        }
   
        return 552
    }
    
    
    //MARK:-- DB Functions
    func getDashbordHeaderFromLocal(userCode: String, regionCode: String) -> DashboardHeaderModel?
    {
        return DBHelper.sharedInstance.getDashboardHeader(userCode: userCode, regionCode: regionCode)
    }
    
    func getDashbordDetailFromLocal(userCode: String, regionCode: String) -> [DashboardModel]
    {
//        let dashboardId = getDashboardId(userCode: userCode, regionCode: regionCode)
//        let dashboardDetails = DBHelper.sharedInstance.getDashboardDetails(dashboardId: dashboardId)
//        var dashboardList: [DashboardModel] = []
//
//        for objDBDetails in dashboardDetails
//        {
//            let objDB: DashboardModel = DashboardModel()
//
//            objDB.entityId = objDBDetails.Entity_Id
//            objDB.entityName = getEntityNameByEntityId(entityId: objDBDetails.Entity_Id)
//            objDB.entityValue = getEntityValue(objDashboardDetails: objDBDetails)
//            objDB.iconName = getIconNameByEntityId(entityId: objDBDetails.Entity_Id)
//            objDB.isDrillDownRequired = isDrillDownRequired(objDashboardDetails: objDBDetails)
//
//            dashboardList.append(objDB)
//        }
//
//        if (userCode == getUserCode())
//        {
//            if (dashboardList.count > 0)
//            {
//                let filteredArray = dashboardList.filter{
//                    $0.entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval
//                }
//
//                if (filteredArray.count > 0)
//                {
//                    let index = dashboardList.index(of: filteredArray[0])
//
//                    if (index != nil)
//                    {
//                        dashboardList.remove(at: index!)
//                    }
//                }
//            }
//        }
//
//        dashboardList.sort { (obj1, obj2) -> Bool in
//            obj1.entityId < obj2.entityId
//        }
        
        var dashboardList: [DashboardModel] = []
        
        var objDB: DashboardModel = DashboardModel()
        
        objDB.entityId = 3
        objDB.entityName = getEntityNameByEntityId(entityId: 3)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 3)
        objDB.isDrillDownRequired = false
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 4
        objDB.entityName = getEntityNameByEntityId(entityId: 4)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 4)
        objDB.isDrillDownRequired = false
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 5
        objDB.entityName = getEntityNameByEntityId(entityId: 5)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 5)
        objDB.isDrillDownRequired = false
        dashboardList.append(objDB)
        
        
        return dashboardList
    }
    
    func getAppliedDCRDatesFromLocal(userCode: String, regionCode: String, isSelf: Bool) -> [DashboardDateDetailsModel]
    {
        let dashboardId = getDashboardId(userCode: userCode, regionCode: regionCode)
        var entityId = Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval
        
        if (!isSelf)
        {
            entityId = Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval
        }
        
        let objDashboardDetail = DBHelper.sharedInstance.getDashboardDetailIdByEntityId(entityId: entityId, dashboardId: dashboardId)
        
        return DBHelper.sharedInstance.getDashboardDateDetails(dashboardId: dashboardId, dashboardDetailId: objDashboardDetail!.Dashboard_Detail_Id)
    }
    
    func getMissedDoctorDetailsFromLocal() -> [DashboardMissedDoctorModel]
    {
        return DBHelper.sharedInstance.getDashboardMissedDoctors()
    }
    
    func checkIsToShowPSDetails() -> Bool
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.PS_DASHBOARD_IN_APP)
        var showPSDetails : Bool = false
        
        if privilegeValue == PrivilegeValues.YES.rawValue
        {
            showPSDetails = true
        }
        
        return showPSDetails
    }
    
    func getDashBoardPSDetails() -> [DashboardPSHeaderModel]
    {
        return DBHelper.sharedInstance.getPSDetails()
    }
    
    func getDashboardPSProductDetails() -> [DashboardPSDetailsModel]
    {
        return DBHelper.sharedInstance.getPSProductDetails()
    }
    
    func getDashBoardCollectionValues() -> [DashboardCollectionValuesModel]
    {
        return DBHelper.sharedInstance.getCollectionDetails()
    }
    
    func clearAllValues()
    {
        dashboardDetails = []
        dashboardTeamDetails = []
        dashboardAppliedDCRDates  = []
        dashboardMissedDoctors = []
        dashBoardPSDetails = []
        dashBoardCollectionValues = []
        dashBoardPSProductValues = []
        dashBoardAssetCountListValues = []
    }

    //MARK:- Private Functions
    private func clearAllArray()
    {
        dashboardDetails = []
        dashboardAppliedDCRDates = []
        dashboardMissedDoctors = []
    }
    
    private func getDashboardId(userCode: String, regionCode: String) -> Int
    {
        var dashboardId: Int = -1
        
        let objDashboardHeader = getDashboardHeader(userCode: userCode, regionCode: regionCode)
        
        if (objDashboardHeader != nil)
        {
            dashboardId = objDashboardHeader!.Dashboard_Id
        }
        
        return dashboardId
    }
    
    private func getDashboardHeader(userCode: String, regionCode: String) -> DashboardHeaderModel?
    {
        return DBHelper.sharedInstance.getDashboardHeader(userCode: userCode, regionCode: regionCode)
    }
    
    private func selfAPICallBack(userCode: String, regionCode: String)
    {
        let olDashboardId = getDashboardId(userCode: userCode, regionCode: regionCode)
        
        deleteAllDashboardData(dashboardId: olDashboardId)
        
        let dashboardId = insertDashboardHeader(userCode: userCode, regionCode: regionCode, headerList: self.dashboardDetails)
        
        insertDashboardDetails(dashboardId: dashboardId, detailList: self.dashboardDetails)
        
        insertDashboardDateDetails(dashboardId: dashboardId, entityId: Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval, dateDetails: self.dashboardAppliedDCRDates)
        
        insertDashboardMissedDoctors(dashboardId: dashboardId, missedDoctorsList: self.dashboardMissedDoctors)
    }
    
    private func deleteAllDashboardData(dashboardId: Int)
    {
        if (dashboardId > 0)
        {
            DBHelper.sharedInstance.deleteDashboardHeader(dashboardId: dashboardId)
            DBHelper.sharedInstance.deleteDashboardDetails(dashboardId: dashboardId)
            DBHelper.sharedInstance.deleteDashboardDateDetails(dashboardId: dashboardId)
            DBHelper.sharedInstance.deleteDashboardMissedDoctors(dashboardId: dashboardId)
        }
    }
    
    private func insertDashboardHeader(userCode: String, regionCode: String, headerList: NSArray) -> Int
    {
        var dashboardId: Int = 0
        
        if (headerList.count > 0)
        {
            let headerObj = headerList[0]
            
            dashboardId = DBHelper.sharedInstance.insertDashboardHeader(array: [headerObj], userCode: userCode, regionCode: regionCode)
        }
        
        return dashboardId
    }
    
    private func insertDashboardDetails(dashboardId: Int, detailList: NSArray)
    {
        DBHelper.sharedInstance.insertDashboardDetail(array: detailList, dashboardId: dashboardId)
    }
    
    private func insertDashboardDateDetails(dashboardId:Int, entityId: Int, dateDetails: NSArray)
    {
        let objDashboardDetail = DBHelper.sharedInstance.getDashboardDetailIdByEntityId(entityId: entityId, dashboardId: dashboardId)
        
        DBHelper.sharedInstance.insertDashboardDateDetail(array: dateDetails, dashboardDetailId: objDashboardDetail!.Dashboard_Detail_Id, dashboardId: dashboardId)
    }
    
    private func insertDashboardMissedDoctors(dashboardId:Int, missedDoctorsList: NSArray)
    {
        DBHelper.sharedInstance.insertDashboardMissedDoctor(array: missedDoctorsList)
    }
    
    func getDashboardDetails(userCode: String, regionCode: String, summaryFlag: Int, entityId: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardDetailsForTeam(userCode: userCode, regionCode: regionCode, summaryFlag: summaryFlag, entityId: entityId) { (apiRespobseObj) in
            completion(apiRespobseObj)
        }
    }
    
    func getDashboardDetailsForAsset(entityId : Int,type : Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        let postData = getPostDataForAssetWiseCount(entityId: entityId, userCode: getUserCode(), type: type)
        WebServiceHelper.sharedInstance.getDashboardAssetWiseCount(postData: postData) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDashboardSelfAssetList(assetsCountList : NSArray) -> [DashboardHeaderAssetModel]
    {
        var assetList : [DashboardHeaderAssetModel] = []
        
        var assetObj : DashboardHeaderAssetModel = DashboardHeaderAssetModel()
        totalAssetCount = 0

        if assetsCountList.count > 0
        {
            let dict = assetsCountList.firstObject as! NSDictionary
            
            if let totalAsset = dict.object(forKey: "Total_Assets") as? Int
            {
               totalAssetCount = totalAsset
            }
            
            assetObj.assetHeaderType = "Detailed Assets"
            var DetailedAssetCount = "0"
            if let detailedAsset = dict.object(forKey: "Detailed_Assets") as? Int
            {
                DetailedAssetCount = String(detailedAsset)
            }
            assetObj.assetCount = DetailedAssetCount
            assetList.append(assetObj)
            
            assetObj = DashboardHeaderAssetModel()
            assetObj.assetHeaderType = "Non-Detailed Assets"
            var nonDetailedAssetCount = "0"
            if let nonDetailedAsset = dict.object(forKey: "Non_Detailed_Assets") as? Int
            {
                nonDetailedAssetCount = String(nonDetailedAsset)
            }
            assetObj.assetCount = nonDetailedAssetCount
            assetList.append(assetObj)
        }
        
        return assetList
    }
    
    func getDashboardTeamAssetList(assetsCountList : NSArray) -> [DashboardHeaderAssetModel]
    {
        var assetList : [DashboardHeaderAssetModel] = []
        
        var assetObj : DashboardHeaderAssetModel = DashboardHeaderAssetModel()
        var totalDetailedAssets : Int = 0
        var totalNotDetailedAssets : Int = 0
        totalAssetCount = 0
        
        for assetDict in assetsCountList
        {
            let dict = assetDict as! NSDictionary
            if let totalAsset = dict.object(forKey: "Total_Assets") as? Int
            {
                totalAssetCount = totalAssetCount! + totalAsset
            }
            
            if let detailedAsset = dict.object(forKey: "Detailed_Assets") as? Int
            {
                totalDetailedAssets += detailedAsset
            }
            
            if let detailedAsset = dict.object(forKey: "Non_Detailed_Assets") as? Int
            {
                totalNotDetailedAssets += detailedAsset
            }

        }
        
        if assetsCountList.count > 0
        {
            assetObj = DashboardHeaderAssetModel()
            assetObj.assetHeaderType = "No Of Detailed Assets"
            assetObj.assetCount = String(totalDetailedAssets)
            assetList.append(assetObj)
            
            assetObj = DashboardHeaderAssetModel()
            assetObj.assetHeaderType = "No Of Non-Detailed Assets"
            assetObj.assetCount = String(totalNotDetailedAssets)
            assetList.append(assetObj)
        }
        
        return assetList
    }
    
    private func getEntityNameByEntityId (entityId: Int) -> String
    {
        var entityName: String = EMPTY
        
        if (entityId == Constants.DashboardEntityIDs.Doctor_Missed)
        {
            entityName = "Missed Doctors"
        }
        else if (entityId == Constants.DashboardEntityIDs.Doctor_Call_Avg)
        {
            entityName = "\(appDoctor) Call Avg."
        }
        else if (entityId == Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            entityName = "\(appChemist) Call Avg."
        }
        else if (entityId == Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval)
        {
            entityName = "Pending DCR Approval"
        }
        else if (entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval)
        {
            entityName = "Pending TP Approval"
        }
        else if (entityId == Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval)
        {
            entityName = "Pending DCR Approval"
        }
        else if (entityId == Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval)
        {
            entityName = "Pending TP Approval"
        }
        
        return entityName
    }
    
    private func getEntityValue(objDashboardDetails: DashboardDetailsModel) -> String
    {
        var entityValue: String = EMPTY
        let entityId = objDashboardDetails.Entity_Id
        
        if (entityId == Constants.DashboardEntityIDs.Doctor_Call_Avg || entityId == Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            if (objDashboardDetails.Current_Month_Value > 0)
            {
                entityValue = String(format: "%.2f", objDashboardDetails.Current_Month_Value)
            }
            else
            {
                entityValue = "0"
            }
            
            if (objDashboardDetails.Previous_Month_Value > 0)
            {
                entityValue = entityValue + "(" + String(format: "%.2f", objDashboardDetails.Previous_Month_Value) + ")"
            }
            else
            {
                entityValue = entityValue + "(0)"
            }
        }
        else
        {
            if (objDashboardDetails.Count > 0)
            {
                entityValue = String(objDashboardDetails.Count)
            }
            else
            {
                if (entityId == Constants.DashboardEntityIDs.Doctor_Missed)
                {
                    entityValue = "No Missed \(appDoctorPlural)"
                }
                else if (entityId == Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval)
                {
                    entityValue = "No Pending DCR Approval"
                }
                else if (entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval)
                {
                    entityValue = "No Pending TP Approval"
                }
            }
        }
        
        return entityValue
    }
    
    private func getEntityValueForTeam(dict: NSDictionary) -> String
    {
        var entityValue: String = EMPTY
        let entityId = dict.value(forKey: "EntityType") as! Int
        
        if (entityId == Constants.DashboardEntityIDs.Doctor_Call_Avg || entityId == Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            var curMonthString = String()
            var preMonthString = String()
            if let curMonthFloatValue = dict.value(forKey: "CurMonthValue") as? Float
            {
                curMonthString = String(curMonthFloatValue)
            }
            else if let curMonthDoubleValue = dict.value(forKey: "CurMonthValue") as? Double
            {
                curMonthString = String(curMonthDoubleValue)
            }
            if let preMonthFloatValue = dict.value(forKey: "PreMonthValue") as? Float
            {
                preMonthString = String(preMonthFloatValue)
            }
            else if let preMonthDoubleValue = dict.value(forKey: "PreMonthValue") as? Double
            {
                preMonthString = String(preMonthDoubleValue)
            }
            entityValue = curMonthString + "(" + preMonthString + ")"
        }
        else
        {
            if (dict.value(forKey: "Count") as! Int > 0)
            {
                entityValue = String(dict.value(forKey: "Count") as! Int)
            }
            else
            {
                if (entityId == Constants.DashboardEntityIDs.Doctor_Missed)
                {
                    entityValue = "No Missed Doctors"
                }
                else if (entityId == Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval)
                {
                    entityValue = "No Pending DCR Approval"
                }
                else if (entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval)
                {
                    entityValue = "No Pending TP Approval"
                }
            }
        }
        
        return entityValue
    }
    
    private func isDrillDownRequiredForTeam(dict: NSDictionary) -> Bool
    {
        var isDrillDown: Bool = false
        let entityId = dict.value(forKey: "EntityType") as! Int
        
        if (entityId != Constants.DashboardEntityIDs.Doctor_Call_Avg && entityId != Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            if let count = dict.value(forKey: "Count") as? Double
            {
                if (count > 0)
                {
                    isDrillDown = true
                }
            }
        }
        
        return isDrillDown
    }
    
    private func isDrillDownRequired(objDashboardDetails: DashboardDetailsModel) -> Bool
    {
        var isDrillDown: Bool = false
        let entityId = objDashboardDetails.Entity_Id
        
        if (entityId !=  Constants.DashboardEntityIDs.Doctor_Call_Avg && entityId != Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            if (objDashboardDetails.Count > 0)
            {
                isDrillDown = true
            }
        }
        
        return isDrillDown
    }
    
    private func getIconNameByEntityId(entityId: Int) -> String
    {
        var iconName: String = EMPTY
        
        if (entityId == Constants.DashboardEntityIDs.Doctor_Missed)
        {
            iconName = "icon-doctor-missed"
        }
        else if (entityId == Constants.DashboardEntityIDs.Chemist_Call_Avg)
        {
            iconName = "icon-chemist"
        }
        else if (entityId == Constants.DashboardEntityIDs.Doctor_Call_Avg)
        {
            iconName = "icon-doctor-missed"

        }
        else if (entityId == Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval)
        {
            iconName = "icon-dcr-pending"
        }
        else if (entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval || entityId == Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval)
        {
            iconName = "icon-dcr-pending"
        }
        
        return iconName
    }
    
    private func getPostDataForPS(type : Int) -> [String : Any]
    {
        return
            ["CompanyCode" : getCompanyCode() , "RegionCode" : getRegionCode() , "UserCode" : getUserCode(), "FromDate" : NSNull(),"ToDate": NSNull(),"SelfOrTeam" :type ]
    }
    
    private func getPostDataForAssetWiseCount(entityId : Int,userCode : String,type : Int) -> [String : Any]
    {
        return  [ "CompanyCode": getCompanyCode(),"UserCode": userCode,
        "SelforTeam": type,"IsSummary": 1,"EntityType": entityId]
    }
    
    private func psAPICallBack()
    {
        DBHelper.sharedInstance.deleteDashboardPSDetails()
        DBHelper.sharedInstance.insertPSDetails(dataArray: dashBoardPSDetails)
        DBHelper.sharedInstance.insertPSProductDetails(dataArray: dashBoardPSProductValues)
        DBHelper.sharedInstance.insertCollectionDetails(dataArray: dashBoardCollectionValues)
    }
    
    func convertDashboardModelForTeam(dashboardDetails: NSArray) -> [DashboardModel]
    {
        var dashboardList: [DashboardModel] = []
        
        for data in dashboardDetails
        {
            let objDB: DashboardModel = DashboardModel()
            let dict: NSDictionary = data as! NSDictionary
            let entityId = dict.value(forKey: "EntityType") as! Int
            
            objDB.entityId = entityId
            objDB.entityName = getEntityNameByEntityId(entityId: entityId)
            objDB.entityValue = getEntityValueForTeam(dict: dict)
            objDB.iconName = getIconNameByEntityId(entityId: entityId)
            objDB.isDrillDownRequired = isDrillDownRequiredForTeam(dict: dict)
            
            dashboardList.append(objDB)
        }
        
        dashboardList.sort { (obj1, obj2) -> Bool in
            obj1.entityId < obj2.entityId
        }
        
        return dashboardList
    }
    
    //MARK:- Cell Height
    
    func getSalesCellHeight() -> CGFloat
    {
        return 250
    }
    
    func getDashboardCellHeight() -> CGFloat
    {
        return 120
    }
    
    func getDashboardAssetSingleCellHeight() -> CGFloat
    {
        return 32
    }
    
    func getDashboardAssetMainCellHeight(assetList : [DashboardHeaderAssetModel]) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        for _ in assetList
        {
            childTableViewHeight += getDashboardAssetSingleCellHeight()
        }
        
        if assetList.count == 0
        {
            childTableViewHeight = 72
        }
        return childTableViewHeight + 48//title View height
    }
    
    func getProductMainCellHeight(array : [DashboardPSDetailsModel]) -> CGFloat
    {
        var childViewHeight : CGFloat = 0
        var totalHeight : CGFloat = getCommonProductCellHeight()
        
        for obj in array
        {
            childViewHeight += getProductSingleCellHeight(text: obj.Product_Name)
        }
        totalHeight += childViewHeight
        
        return totalHeight
    }
    
    func getSalesMainCellHeight(array : [DashboardPSHeaderModel]) -> CGFloat
    {
        var childViewHeight : CGFloat = 0
        var totalHeight : CGFloat = 0
        
        if array.count > 0
        {
            for obj in array
            {
                childViewHeight += getProductSingleCellHeight(text: checkNullAndNilValueForString(stringData: obj.Doc_Type_Name))
            }
            totalHeight += getCommonProductCellHeight() + childViewHeight + 80//collection sales height
        }
        else
        {
            totalHeight = getDashboardCellHeight()
        }
        
        return totalHeight
        
    }
    
    func getCommonProductCellHeight() -> CGFloat
    {
        let titleViewHeight : CGFloat = 40
        let salesHeaderHeight : CGFloat = 32
        let topSpaceHeaderLbl : CGFloat = 8
        let bottomSpaceHeaderLbl : CGFloat = 4
        let productHeaderLbl : CGFloat = 0
        let bottomProductHeaderLbl : CGFloat = 10
        
        return titleViewHeight + salesHeaderHeight + topSpaceHeaderLbl + bottomSpaceHeaderLbl + productHeaderLbl + bottomSpaceHeaderLbl + bottomProductHeaderLbl + 10 //Bottom space to table view
    }
    
    func getProductSingleCellHeight(text : String) -> CGFloat
    {
        var totalHeight : CGFloat = 0
        let topLblHgt : CGFloat = 4
        let bottomLblHgt : CGFloat = 4
        let remainingHeight = SCREEN_WIDTH - 155 - 24
        
        let line1LblHeight = getTextSize(text: text, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - remainingHeight - 24)).height
        
        totalHeight = line1LblHeight  + topLblHgt + bottomLblHgt
        
        return totalHeight
    }
    
    func getAmountInThousand(amount : Double) -> String
    {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value : amount))!
    }
    
    func getDashboardDetailOnline()-> [DashboardModel]
    {

        var dashboardList: [DashboardModel] = []
        
        var objDB: DashboardModel = DashboardModel()
        
        objDB.entityId = 3
        objDB.entityName = getEntityNameByEntityId(entityId: 3)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 3)
        objDB.isDrillDownRequired = false
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 4
        objDB.entityName = getEntityNameByEntityId(entityId: 4)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 4)
        objDB.isDrillDownRequired = true
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 6
        objDB.entityName = getEntityNameByEntityId(entityId: 6)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 6)
        objDB.isDrillDownRequired = true
        dashboardList.append(objDB)
        
        
        return dashboardList
    }
    
    func getDashboardDetailOnlinTeam()-> [DashboardModel]
    {
        
        var dashboardList: [DashboardModel] = []
        
        var objDB: DashboardModel = DashboardModel()
        
        objDB.entityId = 3
        objDB.entityName = getEntityNameByEntityId(entityId: 3)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 3)
        objDB.isDrillDownRequired = false
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 5
        objDB.entityName = getEntityNameByEntityId(entityId: 5)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 4)
        objDB.isDrillDownRequired = true
        dashboardList.append(objDB)
        
        objDB = DashboardModel()
        objDB.entityId = 7
        objDB.entityName = getEntityNameByEntityId(entityId: 7)
        objDB.entityValue = "0"
        objDB.iconName = getIconNameByEntityId(entityId: 7)
        objDB.isDrillDownRequired = true
        dashboardList.append(objDB)
        
        
        return dashboardList
    }
    
    func getDashboardAllSelfDetails(dashBoardList:[DashboardModel],completion: @escaping (_ dashboardList: [DashboardModel],_ status: Int) -> ())
    {
        showCustomActivityIndicatorView(loadingText: "Loading Dashboard...")
        
        WebServiceHelper.sharedInstance.getDashboardDetailsChemistCallAverageForSelf { (apiObj) in
            if(apiObj.Status == SERVER_SUCCESS_CODE)
            {
                let getChemistCallAvg = apiObj.list[0] as! NSDictionary
               // dashBoardList[0].currentCallAverage = getChemistCallAvg.value(forKey: "Current_Month_Count") as Any
                //dashBoardList[0].priviousCallAverage = getChemistCallAvg.value(forKey: "Previous_Month_Count") as Any
                if let value = getChemistCallAvg.value(forKey: "Current_Month_Count") as? Float
                {
                    dashBoardList[0].currentCallAverage = Double(value)
                }
                else if let doubleValue = getChemistCallAvg.value(forKey: "Current_Month_Count") as? Double
                {
                    dashBoardList[0].currentCallAverage = doubleValue
                }
                else
                {
                    dashBoardList[0].currentCallAverage = 0.0
                }

                if let value = getChemistCallAvg.value(forKey: "Previous_Month_Count") as? Float
                {
                    dashBoardList[0].priviousCallAverage = Double(value)
                }
                else if let doubleValue = getChemistCallAvg.value(forKey: "Previous_Month_Count") as? Double
                {
                    dashBoardList[0].priviousCallAverage = doubleValue
                }
                else
                {
                    dashBoardList[0].priviousCallAverage = 0.0
                }
                dashBoardList[0].dashboardAppliedList = []
                WebServiceHelper.sharedInstance.getDashboardDetailsDCRAppliedCountForSelf { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                    
                        dashBoardList[1].dashboardAppliedList = self.getDashboardListObj(apiObj: apiObj)
                        
                        
                        WebServiceHelper.sharedInstance.getDashboardDetailsTPAppliedCountForSelf { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                               dashBoardList[2].dashboardAppliedList = self.getDashboardListObj(apiObj: apiObj)
                                
                                completion(dashBoardList,SERVER_SUCCESS_CODE)
                            }
                            else
                            {
                                
                            }
                        }
                    }
                    else
                    {
                        completion([],SERVER_ERROR_CODE)
                    }
                    
                }
            }
            else
            {
                completion([],SERVER_ERROR_CODE)
            }
        }
    }
    
    func getDashboardAllTeamDetails(dashBoardList:[DashboardModel],completion: @escaping (_ dashboardList: [DashboardModel],_ status: Int) -> ())
    {
        showCustomActivityIndicatorView(loadingText: "Loading Dashboard...")
        
        WebServiceHelper.sharedInstance.getDashboardDetailsChemistCallAverageForTeam { (apiObj) in
            if(apiObj.Status == SERVER_SUCCESS_CODE)
            {
                let getChemistCallAvg = apiObj.list[0] as! NSDictionary
                // dashBoardList[0].currentCallAverage = getChemistCallAvg.value(forKey: "Current_Month_Count") as Any
                //dashBoardList[0].priviousCallAverage = getChemistCallAvg.value(forKey: "Previous_Month_Count") as Any
                if let value = getChemistCallAvg.value(forKey: "Current_Month_Count") as? Float
                {
                    dashBoardList[0].currentCallAverage = Double(value)
                }
                else if let doubleValue = getChemistCallAvg.value(forKey: "Current_Month_Count") as? Double
                {
                    dashBoardList[0].currentCallAverage = doubleValue
                }
                else
                {
                    dashBoardList[0].currentCallAverage = 0.0
                }
                
                if let value = getChemistCallAvg.value(forKey: "Previous_Month_Count") as? Float
                {
                    dashBoardList[0].priviousCallAverage = Double(value)
                }
                else if let doubleValue = getChemistCallAvg.value(forKey: "Previous_Month_Count") as? Double
                {
                    dashBoardList[0].priviousCallAverage = doubleValue
                }
                else
                {
                    dashBoardList[0].priviousCallAverage = 0.0
                }
                dashBoardList[0].dashboardAppliedList = []
                WebServiceHelper.sharedInstance.getDashboardDetailsDCRAppliedCountForTeam { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        
                        dashBoardList[1].dashboardAppliedList = self.getDashboardListObj(apiObj: apiObj)
                        
                        
                        WebServiceHelper.sharedInstance.getDashboardDetailsTPAppliedCountForTeam { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                dashBoardList[2].dashboardAppliedList = self.getDashboardListObj(apiObj: apiObj)
                                
                                completion(dashBoardList,SERVER_SUCCESS_CODE)
                            }
                            else
                            {
                                
                            }
                        }
                    }
                    else
                    {
                        completion([],SERVER_ERROR_CODE)
                    }
                    
                }
            }
            else
            {
                completion([],SERVER_ERROR_CODE)
            }
        }
    }
    
    private func getDashboardListObj(apiObj:ApiResponseModel)-> [DashBoardAppliedCount]
    {
        var dashBoardAppliedList :[DashBoardAppliedCount] = []
        
        for apiObjValue in apiObj.list
        {
            let dashBoardAppliedObj = apiObjValue as! NSDictionary
            let dashboardObj = DashBoardAppliedCount()
            dashboardObj.UserName = dashBoardAppliedObj.value(forKey: "UserName") as! String
            dashboardObj.Applied_Date = dashBoardAppliedObj.value(forKey: "Applied_Date") as! String
            dashboardObj.appliedDate = convertServerDateStringToDate(dateString: dashBoardAppliedObj.value(forKey: "Applied_Date") as! String)
            let month = getMonthNumberFromDate(date: convertServerDateStringToDate(dateString: dashBoardAppliedObj.value(forKey: "Applied_Date") as! String))
            let year = getYearFromDate(date: convertServerDateStringToDate(dateString: dashBoardAppliedObj.value(forKey: "Applied_Date") as! String))
            dashboardObj.month = month
            dashboardObj.year = year
            dashboardObj.Flag = dashBoardAppliedObj.value(forKey: "Flag") as! String
            dashBoardAppliedList.append(dashboardObj)
        }
        
        return dashBoardAppliedList
    }

}

class DashboardHeaderAssetModel : NSObject
{
    var assetHeaderType : String!
    var assetCount : String!
}
