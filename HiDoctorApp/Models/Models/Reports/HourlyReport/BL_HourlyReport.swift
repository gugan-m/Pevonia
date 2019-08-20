//
//  BL_HourlyReport.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_HourlyReport: NSObject
{
    static let sharedInstance = BL_HourlyReport()
    
    //MARK:-- API Functions
    
    func getDCRHeaderDetails(userObj : UserMasterModel, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonString(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getGeoDCRHeaderDetails(userObj : UserMasterModel, status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonString(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRDoctorVisitDetails(userObj : UserMasterModel, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonString(userObj : userObj)
        
        WebServiceHelper.sharedInstance.getDCRDoctorVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getGeoDCRDoctorVisitDetails(userObj : UserMasterModel,status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonString(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRDoctorVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getGeoDCRChemistVisitDetails(userObj : UserMasterModel,status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonString(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetails(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRStockistVisitDetails(userObj : UserMasterModel,status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonString(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRStockistVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getGeoDCRChemistVisitDetailsApproval(userObj : ApprovalUserMasterModel,status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonStrings(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetails(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getGeoDCRStockistVisitDetailsApproval(userObj : ApprovalUserMasterModel,status : String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getGeoPostJsonStrings(userObj : userObj, status:status )
        
        WebServiceHelper.sharedInstance.getDCRStockistVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDoctorVisitDetailsByDate(userCode : String , startDate : String , completion: @escaping (ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDoctorVisitDetailsForDate(userCode: userCode, startDate: startDate) { (apiResponseObj) in
           completion(apiResponseObj)
        }
    }
    
    func getHourlyReportSummary(userObj : UserMasterModel , completion: @escaping (ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getHourlyReportSummary(userObj : userObj) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getTravelTrackingReport(userObj : UserMasterModel , completion: @escaping (ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getTravelTrackingReport(userObj : userObj) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    
    func convertToDCRHeaderModel(headerDataArray: NSArray) -> [DCRHeaderModel]
    {
        var dcrHeaderList: [DCRHeaderModel] = []
        
        for obj in headerDataArray
        {
            let dict = obj as! NSDictionary
            let objDCRHeader: DCRHeaderModel = DCRHeaderModel(dict: dict)
            if objDCRHeader.Flag == DCRFlag.fieldRcpa.rawValue
            {
                dcrHeaderList.append(objDCRHeader)
            }
        }
        
        return dcrHeaderList
    }
    
    func convertToDoctorVisitModel(doctorVisitArray: NSArray) -> [DCRDoctorVisitModel]
    {
        var doctorVisitList: [DCRDoctorVisitModel] = []
        
        for obj in doctorVisitArray
        {
            let dict = obj as! NSDictionary
            let objDoctorVisit: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: dict)
            
            doctorVisitList.append(objDoctorVisit)
        }
        
        return doctorVisitList
    }
    
    func convertToChemistVisitModel(doctorVisitArray: NSArray) -> [DCRDoctorVisitModel]
    {
    
        var chemistVisitList: [DCRDoctorVisitModel] = []
        
        for obj in doctorVisitArray
        {
            let dictObj = obj as! NSDictionary
            
            
            let dict = ["DCR_Actual_Date":dictObj.value(forKey: "DCR_Actual_Date"),"Doctor_Code":dictObj.value(forKey: "Chemist_Code"),"Category_Name":"","Doctor_Name":dictObj.value(forKey: "Chemist_Name"),"Speciality_Name":"","MDL_Number":dictObj.value(forKey: "Chemists_MDL_Number"),"Doctor_Region_Code":"","Doctor_Region_Name":dictObj.value(forKey: "Region_Name"),"Local_Area":"","Longitude":dictObj.value(forKey: "Chemists_Visit_Longitude"),"Lattitude":dictObj.value(forKey: "Chemists_Visit_latitude"),"Visit_Mode":dictObj.value(forKey: "Visit_Mode"),"Visit_Time":dictObj.value(forKey: "Visit_Time"),"DCR_Id":"0","Customer_Entity_Type":"C"]
            let objDoctorVisit: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: dict as NSDictionary)
            
            chemistVisitList.append(objDoctorVisit)
        }
        
        return chemistVisitList
    }
    
    func convertToStockistVisitModel(doctorVisitArray: NSArray) -> [DCRDoctorVisitModel]
    {
        
        var StockistVisitList: [DCRDoctorVisitModel] = []

        for obj in doctorVisitArray
        {
            let dictObj = obj as! NSDictionary


            let dict = ["DCR_Actual_Date":dictObj.value(forKey: "DCR_Actual_Date"),"Doctor_Code":dictObj.value(forKey: "Stockiest_Code"),"Category_Name":"","Doctor_Name":dictObj.value(forKey: "Stockiest_Name"),"Speciality_Name":"","MDL_Number":"","Doctor_Region_Code":"","Doctor_Region_Name":"","Local_Area":"","Longitude":dictObj.value(forKey: "Longitude"),"Lattitude":dictObj.value(forKey: "Latitude"),"Visit_Mode":dictObj.value(forKey: "Visit_Mode"),"Visit_Time":dictObj.value(forKey: "Visit_Time"),"DCR_Id":"0","Customer_Entity_Type":"S"]
            let objDoctorVisit: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: dict as NSDictionary)

            StockistVisitList.append(objDoctorVisit)
        }

        return StockistVisitList
    }
    
    

    
    private func getGeoPostJsonString(userObj : UserMasterModel, status: String) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = userObj.User_Code
        dcrParameterModelObj.RegionCode = userObj.Region_Code
        dcrParameterModelObj.Flag = "F"
        dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: userObj.User_Start_Date)
        dcrParameterModelObj.EndDate = convertDateIntoServerStringFormat(date: userObj.User_End_Date)
        dcrParameterModelObj.DCRStatus = status
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        return jsonString
    }
    
    private func getGeoPostJsonStrings(userObj : ApprovalUserMasterModel, status: String) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = userObj.User_Code
        dcrParameterModelObj.RegionCode = userObj.Region_Code
        dcrParameterModelObj.Flag = "F"
        dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: userObj.actualDate)
        dcrParameterModelObj.EndDate = convertDateIntoServerStringFormat(date: userObj.actualDate)
        dcrParameterModelObj.DCRStatus = status
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        return jsonString
    }
    
    private func getPostJsonString(userObj : UserMasterModel) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = userObj.User_Code
        dcrParameterModelObj.RegionCode = userObj.Region_Code
        dcrParameterModelObj.Flag = "F"
        dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: userObj.User_Start_Date)
        dcrParameterModelObj.EndDate = convertDateIntoServerStringFormat(date: userObj.User_End_Date)
        dcrParameterModelObj.DCRStatus = "ALL"
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        return jsonString
    }
    
    //MARK:- Accompanist List
    
    func convertAccompanitsToUserMasterModel(accompanistList : [AccompanistModel]?) -> [UserMasterModel]
    {
        var userMasterList : [UserMasterModel] = []

        if accompanistList != nil
        {
            for obj in accompanistList!
            {
                userMasterList.append(convertAccompanistObjToUserObj(obj: obj))
            }
        }
        return userMasterList
    }
    
    func getSortedUserList(accompanistList : [UserMasterModel]) -> [UserListModel]
    {
        var userSectionList : [UserListModel] = []
        var sectionKey : String = ""
        var userObj : UserListModel!
        
        for obj in accompanistList
        {
            var firstCharacter : NSString!
            
            if obj.Employee_name != ""
            {
                 firstCharacter = ((obj.Employee_name.capitalized as NSString).substring(to: 1) as NSString)
            }
            
            if obj.Employee_name  == "" || obj.Employee_name == "Mine"
            {
                userObj = UserListModel()
                userObj.sectionKey = ""
                obj.Employee_name = "Mine"
                userSectionList.append(userObj!)
            }
            else if sectionKey != firstCharacter as String
            {
                userObj = UserListModel()
                sectionKey = firstCharacter as String
                userObj.sectionKey = firstCharacter as String
                userSectionList.append(userObj!)
            }
            
            userObj.accompanistsList.append(obj)
        }
        
        return userSectionList
    }
    
    private func convertAccompanistObjToUserObj(obj : AccompanistModel) -> UserMasterModel
    {
        let userObj : UserMasterModel = UserMasterModel()
        
        userObj.Employee_name = condenseWhitespace(stringValue: obj.Employee_name)
        userObj.Division_Name = obj.Division_Name
        userObj.Region_Code = obj.Region_Code
        userObj.Region_Name = obj.Region_Name
        userObj.User_Name = obj.User_Name
        userObj.User_Type_Name = obj.User_Type_Name
        userObj.User_Code = obj.User_Code
        return userObj
    }
    
    func getAllChildUser() -> [AccompanistModel]?
    {
        return DBHelper.sharedInstance.getAllChildUsersExceptVacant()
    }
    
    func getDCRStatus(dcrStatus : String) -> String
    {
        var status : String = ""
        let type = Int(dcrStatus)
        
        if type == DCRStatus.applied.rawValue
        {
            status = applied
        }
        else if type == DCRStatus.drafted.rawValue
        {
            status = "Draft - Yet to be applied"
        }
        else if type == DCRStatus.approved.rawValue
        {
            status = approved
        }
        else if type == DCRStatus.unApproved.rawValue
        {
            status = unApproved
        }
        
        return status
    }
    
    //MARK:- Doctor Visit List
    
    func filterHeaderAndVisitList(dcrHeaderList : [DCRHeaderModel], doctorVisitList : NSArray) -> [ReportDoctorVisitListModel]
    {
        var dcrDoctorVisitList : [ReportDoctorVisitListModel] = []
        for obj in doctorVisitList
        {
            let dict = obj as! NSDictionary
            
            
            let visitObj : ReportDoctorVisitListModel = ReportDoctorVisitListModel()
            
            let date = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Actual_Date") as? String)
            
            visitObj.displayDate = date
            
            let filteredArray = dcrHeaderList.filter
            {
                $0.DCR_Actual_Date == getStringInFormatDate(dateString: date)
            }
            
            var status : String = ""
            
            if filteredArray.count > 0
            {
                let obj = filteredArray.first
                status = getDCRStatus(dcrStatus: (obj?.DCR_Status)!)
            }
            else
            {
                status = "Yet to be submitted"
            }
            
            visitObj.dcrStatus = status
            
            let visitCount = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Visit_Count") as? String)
            
            visitObj.doctorVisitCount = visitCount
            
            dcrDoctorVisitList.append(visitObj)
        }
        
        return dcrDoctorVisitList
    }
    
    
    func filterHeaderAndVisitListTravelReport( doctorVisitList : NSArray) -> [ReportDoctorVisitListModel]
    {
        var dcrDoctorVisitList : [ReportDoctorVisitListModel] = []
        for obj in doctorVisitList
        {
            let dict = obj as! NSDictionary
            
            
            let visitObj : ReportDoctorVisitListModel = ReportDoctorVisitListModel()
            
//            let date = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Actual_Date") as? String)
//            
//            visitObj.displayDate = date
            
//            let filteredArray = dcrHeaderList.filter
//            {
//                $0.DCR_Actual_Date == getStringInFormatDate(dateString: date)
//            }
//            
//            var status : String = ""
//            
//            if filteredArray.count > 0
//            {
//                let obj = filteredArray.first
//                status = getDCRStatus(dcrStatus: (obj?.DCR_Status)!)
//            }
//            else
//            {
//                status = "Yet to be submitted"
//            }
//            
//            visitObj.dcrStatus = status
//            
//            let visitCount = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Visit_Count") as? String)
//            
//            visitObj.doctorVisitCount = visitCount
            
            //dcrDoctorVisitList.append(visitObj)
        }
        
        return dcrDoctorVisitList
    }
    
    func filterHeaderAndVisitListGeo(dcrHeaderList : [DCRHeaderModel], doctorVisitList : [DCRDoctorVisitModel], chemistVisitList : [DCRDoctorVisitModel], stockistVisitList : [DCRDoctorVisitModel]) -> [ReportDoctorVisitListModel]
    {
        var dcrDoctorVisitList : [ReportDoctorVisitListModel] = []
        
        for obj in dcrHeaderList
        {
            let visitObj : ReportDoctorVisitListModel = ReportDoctorVisitListModel()
            let dateValue = convertDateIntoServerStringFormat(date : obj.DCR_Actual_Date)
            let date = checkNullAndNilValueForString(stringData: dateValue)
            visitObj.displayDate = date
            
            var filteredArray = doctorVisitList.filter
            {
                $0.DCR_Actual_Date == dateValue
            }
            
            let filteredChemistArray = chemistVisitList.filter
            {
                $0.DCR_Actual_Date == dateValue
            }
            
            let filteredStockistArray = stockistVisitList.filter
            {
                $0.DCR_Actual_Date == dateValue
            }
            
            var status : String = ""
            
            status = getDCRStatus(dcrStatus: (obj.DCR_Status)!)
            visitObj.dcrStatus = status
            
            let visitCount = "\(filteredArray.count + filteredChemistArray.count + filteredStockistArray.count)"
            
            visitObj.doctorVisitCount = visitCount
            visitObj.geoDoctorList = filteredArray
            visitObj.geoChemistList = filteredChemistArray
            visitObj.geoStockistList = filteredStockistArray
            
            var allList :[DCRDoctorVisitModel] = []
            
            if filteredArray.count > 0
            {
                if filteredChemistArray.count == 0
                {
                   allList = filteredArray
                }
                else
                {
                    for obj in filteredChemistArray
                    {
                        filteredArray.append(obj)
                    }
                    
                    allList = filteredArray
                }
            }
            else if filteredChemistArray.count > 0
            {
                allList = filteredChemistArray
            }
            else if filteredStockistArray.count > 0
            {
                allList = filteredStockistArray
            }
            
            visitObj.geoAllList = allList
            
            
            dcrDoctorVisitList.append(visitObj)
        }
               
        return dcrDoctorVisitList
    }
}

