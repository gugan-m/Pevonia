//
//  BL_Upload_DCR.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_Upload_DCR: NSObject
{
    static let sharedInstance = BL_Upload_DCR()
    var lasUploadData: NSArray = []
    var dcrDate: String!
    var isFromDCRUpload : Bool = false
    
    
    //MARK:- Public Functions
    func getPendingDCRsForUpload() -> [DCRHeaderModel]
    {
        return DBHelper.sharedInstance.getPendingDCRsForUpload()
    }
    
    func convertToUploadDetail() -> [DCRUploadDetail]
    {
        var uploadDetail : [DCRUploadDetail] = []
        
        let headerModelList = getPendingDCRsForUpload()
        for model in headerModelList
        {
            let uploadModel : DCRUploadDetail = DCRUploadDetail()
            uploadModel.dcrId = model.DCR_Id
            uploadModel.dcrDate = model.DCR_Actual_Date
            uploadModel.statusText = pendingStatus
            uploadModel.flag = model.Flag
            
            if model.Flag == DCRFlag.fieldRcpa.rawValue
            {
                uploadModel.flagLabel = "F"
            }
            else if model.Flag == DCRFlag.attendance.rawValue
            {
                uploadModel.flagLabel = "O"
            }
            else if model.Flag == DCRFlag.leave.rawValue
            {
                uploadModel.flagLabel = "N"
            }
            uploadDetail.append(uploadModel)
        }
        
        return uploadDetail
    }
    
    func clearAllArray()
    {
        lasUploadData = []
    }
    
    func updateDCRUploadDetail(index : Int, statusText : String, reason : String, showPopup : Bool, uploadDetail: [DCRUploadDetail], failedStatusCode: Int) -> [DCRUploadDetail]
    {
        var detailList : [DCRUploadDetail] = uploadDetail
        let model = detailList[index]
        model.statusText  = statusText
        model.reason = reason
        model.showPopup = showPopup
        model.failedStatusCode = failedStatusCode

        detailList[index] = model
        
        return detailList
    }
    
    /*
     dcrDate must be a string in yyyy-MM-dd format
    */
    func uploadDCR(dcrId: Int, dcrDate: String, checkSumId: Int, flag: Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        var uploadData: NSArray = []
        
        if (flag == DCRFlag.fieldRcpa.rawValue)
        {
            uploadData = getUploadDataForField(dcrId: dcrId, checkSum: checkSumId,dcrDate: dcrDate)
        }
        else if (flag == DCRFlag.attendance.rawValue)
        {
            uploadData = getUploadDataForAttendance(dcrId: dcrId, checkSum: checkSumId,dcrDate: dcrDate)
        }
        if (flag == DCRFlag.leave.rawValue)
        {
            uploadData = getUploadDataForLeave(dcrId: dcrId, checkSum: checkSumId,dcrDate: dcrDate)
        }
        
        WebServiceHelper.sharedInstance.uploadDCR(dcrDate: dcrDate, dataArray: uploadData) { (apiResponseObj) in
            self.lasUploadData = uploadData
            self.dcrDate = dcrDate
            completion(apiResponseObj)
        }
    }
    
    func updateDCRStatusAsDraft(dcrId: Int, dcrDate: Date)
    {
        DBHelper.sharedInstance.updateDCRStatus(dcrId: dcrId, dcrStatus: DCRStatus.drafted.rawValue, dcrCode: EMPTY)
        
        let dcrHeaderObj = DBHelper.sharedInstance.getDCRHeaderByDCRId(dcrId: dcrId)
        
        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj!])
    }
    
    func deleteDCR(dcrHeaderObj: DCRHeaderModel)
    {
        BL_DCR_Refresh.sharedInstance.deleteDCR(dcrHeaderObj: dcrHeaderObj, isCalledFromDCRRefresh: false)
    }
    
    func verifySyncedRecordCount(dict: NSDictionary) -> Bool
    {
        return compareSyncedDataCount(dict: dict)
    }
    
    func deleteDCRExpenses(dcrId: Int)
    {
        DBHelper.sharedInstance.deleteDCRExpense(dcrId: dcrId)
    }
    
    func downloadExpenseData(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getExpenseGroupMapping { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.deleteFromTable(tableName: MST_EXPENSE_GROUP_MAPPING)
                
                if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                {
                    DBHelper.sharedInstance.insertExpenseGroupMapping(array: apiResponseObj.list)
                }
            }
            
            completion(statusCode!)
        }
    }
    
    //MARK:- Private Functions
    //MARK:-- Get DCR Data
    private func getUploadDataForField(dcrId: Int, checkSum: Int,dcrDate : String) -> NSArray
    {
        let dict1: NSDictionary = ["checksum": checkSum, "lstDCRMasterStaging": getDCRHeaderList(dcrId: dcrId), "lstDCRAccompanistModel": getDCRAccompanistList(dcrId: dcrId), "lstTravelledPlaces": getDCRTravelledPlaces(dcrId: dcrId), "lstDCRVisitStaging": getDCRDoctorVisit(dcrId: dcrId), "lstAccompStaging": getDCRDoctorAccompanist(dcrId: dcrId), "lstSampleProductsStaging": getSampleDetails(dcrId: dcrId), "lstDetailedStaging": getDCRDetailedProducts(dcrId: dcrId)]
        let dict2: NSDictionary = ["lstChemistStaging": getDCRChemistVisit(dcrId: dcrId), "lstRCPAStaging": getRCPADetails(dcrId: dcrId),"lstFollowupsStaging": getDoctorVisitFollowUpDetails(dcrId: dcrId, dcrActualDate: dcrDate), "lstAttachmentStaging": getDoctorVisitAttachments(dcrId: dcrId), "lstStockiestStaging": getStockistVisitDetails(dcrId: dcrId), "lstExpenseStaging": getExpenseList(dcrId: dcrId), "lstTimeSheetActivityStaging": []]
        let dict3: NSDictionary = ["lstChemistAccompStaging": getChemistAccompanists(dcrId: dcrId), "lstSamplePromotionsStaging": getChemistSamples(dcrId: dcrId), "lstDCRChemistDetailedStagging": getChemistDetailedProducts(dcrId: dcrId), "lstChemistRCPAOwnProductsStaging": getChemistRCPAOwn(dcrId: dcrId), "lstChemistRCPACompetitorProductStaging": getChemistRCPACompetitor(dcrId: dcrId), "lstchemistFollowupstaging": getChemistFollowups(dcrId: dcrId), "lstChemistAttachmentStaging": getChemistAttachments(dcrId: dcrId)]
        let lstPOBHeader = DBHelper.sharedInstance.getPOBHeaderForUpload(dcrId: dcrId)
        let lstPOBDetails = DBHelper.sharedInstance.getPOBDetailsForUpload(dcrId: dcrId)
        let dict4: NSDictionary = ["lstOrderHeader": getPOBHeader(dcrId: dcrId), "lstOrderDetails": getPOBDetails(dcrId: dcrId, lstPOBHeader: lstPOBHeader, lstPOBDetails: lstPOBDetails), "lstDCRCallActivity": getDCRCallActivities(dcrId: dcrId), "lstDCRMCActivity": getDCRMCActivities(dcrId: dcrId), "lstDCRInheritanceAccompanist": getDCRInheritanceAccompanists(dcrId: dcrId), "lstCompetitorDetails": getDCRCompetitor(dcrId: dcrId),"lstAttendanceDoctorDetails":[],"lstAttendaceSamplesDetails":[],"lstAttendancecallactivity":[],"lstAttendanceMCactivity":[]]
        var combinedAttributes : NSMutableDictionary!
        
        combinedAttributes = NSMutableDictionary(dictionary: dict1)
        combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict4 as! [AnyHashable : Any])
        
        let dataArray: NSArray = [combinedAttributes]
        
        return dataArray
    }
    
    private func getUploadDataForAttendance(dcrId: Int, checkSum: Int,dcrDate : String) -> NSArray
    {
        let dict1: NSDictionary = ["checksum": checkSum, "lstDCRMasterStaging": getDCRHeaderList(dcrId: dcrId), "lstDCRAccompanistModel": [], "lstTravelledPlaces": getDCRTravelledPlaces(dcrId: dcrId), "lstDCRVisitStaging": [], "lstAccompStaging": [], "lstSampleProductsStaging": [], "lstDetailedStaging": []]
        let dict2: NSDictionary = ["lstChemistStaging": [], "lstRCPAStaging": [],"lstFollowupsStaging": [], "lstAttachmentStaging": [], "lstStockiestStaging": [], "lstExpenseStaging": getExpenseList(dcrId: dcrId), "lstTimeSheetActivityStaging": getAttendanceActivities(dcrId: dcrDate,dcridvalue: dcrId)]
        let dict3: NSDictionary = ["lstChemistAccompStaging": [], "lstSamplePromotionsStaging": [], "lstDCRChemistDetailedStagging": [], "lstChemistRCPAOwnProductsStaging": [], "lstChemistRCPACompetitorProductStaging": [], "lstchemistFollowupstaging": [], "lstChemistAttachmentStaging": []]
        let dict4: NSDictionary = ["lstOrderHeader": [], "lstOrderDetails": [], "lstDCRCallActivity": [], "lstDCRMCActivity": [], "lstDCRInheritanceAccompanist": [], "lstCompetitorDetails": [],"lstAttendanceDoctorDetails":getDCRAttendanceDoctor(dcrId: dcrId),"lstAttendaceSamplesDetails":getDCRAttendanceSample(dcrId: dcrId),"lstAttendancecallactivity":getAttendanceDCRCallActivities(dcrId: dcrId),"lstAttendanceMCactivity":getAttendanceDCRMCActivities(dcrId: dcrId)]
        var combinedAttributes : NSMutableDictionary!
        
        combinedAttributes = NSMutableDictionary(dictionary: dict1)
        combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict4 as! [AnyHashable : Any])
        
        let dataArray: NSArray = [combinedAttributes]
        
        return dataArray
    }
    
    private func getUploadDataForLeave(dcrId: Int, checkSum: Int,dcrDate : String) -> NSArray
    {
        let dict1: NSDictionary = ["checksum": checkSum, "lstDCRMasterStaging": getDCRHeaderList(dcrId: dcrId), "lstDCRAccompanistModel": [], "lstTravelledPlaces": [], "lstDCRVisitStaging": [], "lstAccompStaging": [], "lstSampleProductsStaging": [], "lstDetailedStaging": []]
        let dict2: NSDictionary = ["lstChemistStaging": [], "lstRCPAStaging": [],"lstFollowupsStaging": [], "lstAttachmentStaging": [], "lstStockiestStaging": [], "lstExpenseStaging": [], "lstTimeSheetActivityStaging": []]
        let dict3: NSDictionary = ["lstChemistAccompStaging": [], "lstSamplePromotionsStaging": [], "lstDCRChemistDetailedStagging": [], "lstChemistRCPAOwnProductsStaging": [], "lstChemistRCPACompetitorProductStaging": [], "lstchemistFollowupstaging": [], "lstChemistAttachmentStaging": []]
        let dict4: NSDictionary = ["lstOrderHeader": [], "lstOrderDetails": [], "lstDCRCallActivity": [], "lstDCRMCActivity": [], "lstDCRInheritanceAccompanist": [], "lstCompetitorDetails": [],"lstAttendanceDoctorDetails":[],"lstAttendaceSamplesDetails":[],"lstAttendancecallactivity":[],"lstAttendanceMCactivity":[]]
        var combinedAttributes : NSMutableDictionary!
        
        combinedAttributes = NSMutableDictionary(dictionary: dict1)
        combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
        combinedAttributes.addEntries(from: dict4 as! [AnyHashable : Any])
        
        let dataArray: NSArray = [combinedAttributes]
        
        return dataArray
    }
    
    private func getDCRHeaderList(dcrId: Int) -> NSMutableArray
    {
        let dcrHeaderList = DBHelper.sharedInstance.getDCRHeaderForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrHeaderObj in dcrHeaderList
        {
            let actualDate: String = convertDateIntoServerStringFormat(date: dcrHeaderObj.DCR_Actual_Date)
            var enteredDate: String = EMPTY
            var placeWorked: String = EMPTY
            var categoryId: Int = 0
            var categoryName: String = EMPTY
            var cpCode: String = EMPTY
            var cpId: Int = 0
            var cpName : String = EMPTY
            var startTime: String = EMPTY
            var endTime: String = EMPTY
            var leaveTypeCode: String = EMPTY
            var leaveReason: String = EMPTY
            var latitude: String = EMPTY
            var longitude: String = EMPTY
            var generalRemarks: String = EMPTY
            var Unapprove_Reason: String?
            
            if (dcrHeaderObj.Unapprove_Reason != nil)
            {
                Unapprove_Reason = dcrHeaderObj.Unapprove_Reason
            } else {
                Unapprove_Reason = ""
            }
            if (dcrHeaderObj.DCR_Entered_Date != nil)
            {
                enteredDate = convertDateIntoServerStringFormat(date: dcrHeaderObj.DCR_Entered_Date)
            }
            if (dcrHeaderObj.Place_Worked != nil)
            {
                placeWorked = dcrHeaderObj.Place_Worked!
            }
            if (dcrHeaderObj.Category_Id != nil)
            {
                categoryId = dcrHeaderObj.Category_Id!
            }
            if (dcrHeaderObj.Category_Name != nil)
            {
                categoryName = dcrHeaderObj.Category_Name!
            }
            if (dcrHeaderObj.CP_Id != nil)
            {
                cpId = dcrHeaderObj.CP_Id!
            }
            if (dcrHeaderObj.CP_Name != nil)
            {
                cpName = dcrHeaderObj.CP_Name!
            }
            if (dcrHeaderObj.CP_Code != nil)
            {
                cpCode = dcrHeaderObj.CP_Code!
            }
            if (dcrHeaderObj.Start_Time != nil)
            {
                startTime = dcrHeaderObj.Start_Time!
            }
            if (dcrHeaderObj.End_Time != nil)
            {
                endTime = dcrHeaderObj.End_Time!
            }
            if (dcrHeaderObj.Leave_Type_Code != nil)
            {
                leaveTypeCode = dcrHeaderObj.Leave_Type_Code!
            }
            if (dcrHeaderObj.Reason != nil)
            {
                leaveReason = dcrHeaderObj.Reason!
            }
            if (dcrHeaderObj.Lattitude != nil)
            {
                latitude = dcrHeaderObj.Lattitude!
            }
            if (dcrHeaderObj.Longitude != nil)
            {
                longitude = dcrHeaderObj.Longitude!
            }
            if (dcrHeaderObj.DCR_General_Remarks != nil)
            {
                generalRemarks = dcrHeaderObj.DCR_General_Remarks!
            }
            let appVersion = getCurrentAppVersion()
            let arrayData = appVersion.components(separatedBy: "(")
            let versionName = arrayData[0]
            let versionCode = arrayData[1].components(separatedBy: ")")[0]
            
            let dcrStatus = "\(dcrHeaderObj.DCR_Status!)"
            let dcrFlag = "\(dcrHeaderObj.Flag!)"
            
            let dict1: NSDictionary = ["DCR_Id": dcrHeaderObj.DCR_Id, "DCR_Code": EMPTY, "DCR_Actual_Date": actualDate, "DCR_Entered_Date": enteredDate, "DCR_Status": dcrStatus, "Flag": dcrFlag, "Place_Worked": placeWorked, "Category_Id": categoryId]
            
            let dict2: NSDictionary = ["Category_Name": categoryName, "Travelled_KMS": 0, "CP_Code": cpCode, "CP_Id": cpId,"CP_Name" : cpName, "Start_Time": startTime, "End_Time": endTime, "Approved_By": NSNull(), "Approved_Date": NSNull()]
            
            let dict3: NSDictionary = ["Unapprove_Reason": Unapprove_Reason, "Type": leaveTypeCode, "Reason": leaveReason, "Lattitude": latitude, "Longitude": longitude, "Region_Code": getRegionCode(), "Source_Of_Entry": "iOS", "DCR_General_Remarks": generalRemarks]
            
            let dict4: NSDictionary = ["IsTPFrozenData": dcrHeaderObj.Is_TP_Frozen,"versionName":versionName,"versionCode":versionCode,"UTC_DateTime":getUTCDateForPunch(),"Entered_TimeZone":getcurrenttimezone(),"Entered_OffSet":getOffset(),"Created_DateTime":getCurrentDateAndTimeString()]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict4 as! [AnyHashable : Any])
            
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getDCRAccompanistList(dcrId: Int) -> NSMutableArray
    {
        let dcrAccompanistList = DBHelper.sharedInstance.getDCRAccompanistForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrAccompanistObj in dcrAccompanistList
        {
            var accRegionCode: String = EMPTY
            var accUserName: String = EMPTY
            var accUserCode: String = EMPTY
            var accUserTypeName: String = EMPTY
            var isOnlyForDoctor: Int = 0
            var accStartTime: String = EMPTY
            var accEndTime: String = EMPTY
            
            if (dcrAccompanistObj.Acc_User_Code != nil)
            {
                accRegionCode = dcrAccompanistObj.Acc_Region_Code!
            }
            if (dcrAccompanistObj.Acc_User_Name != nil)
            {
                accUserName = dcrAccompanistObj.Acc_User_Name!
            }
            if (dcrAccompanistObj.Acc_User_Code != nil)
            {
                accUserCode = dcrAccompanistObj.Acc_User_Code!
            }
            if (dcrAccompanistObj.Acc_User_Type_Name != nil)
            {
                accUserTypeName = dcrAccompanistObj.Acc_User_Type_Name!
            }
            if (dcrAccompanistObj.Is_Only_For_Doctor != nil)
            {
                if (dcrAccompanistObj.Is_Only_For_Doctor != EMPTY)
                {
                    if (dcrAccompanistObj.Is_Only_For_Doctor.first == "R")
                    {
                        isOnlyForDoctor = 1
                    }
                    else
                    {
                        isOnlyForDoctor = Int(dcrAccompanistObj.Is_Only_For_Doctor)!
                    }
                }
            }
            if (dcrAccompanistObj.Acc_Start_Time != nil)
            {
                accStartTime = dcrAccompanistObj.Acc_Start_Time!
            }
            if (dcrAccompanistObj.Acc_End_Time != nil)
            {
                accEndTime = dcrAccompanistObj.Acc_End_Time!
            }
            
            var dict: NSMutableDictionary = ["DCR_Accompanist_Id": dcrAccompanistObj.DCR_Accompanist_Id, "DCR_Id": dcrAccompanistObj.DCR_Id, "Acc_Region_Code": accRegionCode, "Acc_User_Name": accUserName, "Acc_User_Code": accUserCode, "Acc_User_Type_Name": accUserTypeName, "Is_Only_For_Doctor": isOnlyForDoctor, "Acc_Start_Time": accStartTime, "Acc_End_Time": accEndTime]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRTravelledPlaces(dcrId: Int) -> NSMutableArray
    {
        let dcrSFCList = DBHelper.sharedInstance.getDCRTravelledPlacesForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for sfcObj in dcrSFCList
        {
            var distance: Float = 0
            var sfcCategoryName: String = EMPTY
            var distanceFareCode: String = EMPTY
            var sfcVersion: Int = 0
            var sfcRegionCode: String = EMPTY
            var flag: Int = 0
            
            if (sfcObj.Distance != nil)
            {
                distance = sfcObj.Distance
            }
            if (sfcObj.SFC_Category_Name != nil)
            {
                sfcCategoryName = sfcObj.SFC_Category_Name!
            }
            if (sfcObj.Distance_Fare_Code != nil)
            {
                distanceFareCode = sfcObj.Distance_Fare_Code!
            }
            if (sfcObj.SFC_Version != nil)
            {
                sfcVersion = sfcObj.SFC_Version!
            }
            if (sfcObj.Region_Code != nil)
            {
                sfcRegionCode = sfcObj.Region_Code!
            }
            if (sfcObj.Flag != nil)
            {
                flag = sfcObj.Flag!
            }
            
            let dict1: NSDictionary = ["DCR_Travel_Id": sfcObj.DCR_Travel_Id, "DCR_Code": "", "DCR_Id": sfcObj.DCR_Id, "From_Place": sfcObj.From_Place, "To_Place": sfcObj.To_Place, "Travel_Mode": sfcObj.Travel_Mode, "Distance": distance, "SFC_Category_Name": sfcCategoryName]
            
            let dict2: NSDictionary = ["Distance_Fare_Code": distanceFareCode, "SFC_Version": sfcVersion, "Route_Way": NSNull(), "SFC_Region_Code": sfcRegionCode, "Flag": flag, "Is_TP_Place": sfcObj.Is_TP_SFC]
            
            var combinedAttributes : NSMutableDictionary!
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getDCRDoctorVisit(dcrId: Int) -> NSMutableArray
    {
        let dcrDoctorVisitList = DBHelper.sharedInstance.getDCRDoctorVisitForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for doctorVisitObj in dcrDoctorVisitList
        {
            var dcrCode: String = EMPTY
            var dcrVisitCode: String = EMPTY
            var doctorId: Int = 0
            var doctorRegionCode: String = EMPTY
            var doctorCode: String = EMPTY
            var doctorName: String = EMPTY
            var mdlNumber: String = EMPTY
            var specialtyName: String = EMPTY
            var visitMode: String = EMPTY
            var visitTime: String = EMPTY
            var isCPDoc: String = EMPTY
            var pobAmount: Double = 0
            var categoryCode: String = EMPTY
            var isAccDoc: String = EMPTY
            var remarks: String = EMPTY
            var latitude: Double = 0
            var longitude: Double = 0
            var categoryName: String = EMPTY
            var regionName: String = EMPTY
            var businessStatusId: Int = 0
            var callObjectiveId: Int = 0
            var geoFencingRemarks: String = EMPTY
            var geoFencingPageSource: String = EMPTY
            var campaignCode: String = EMPTY
            var campaignName: String = EMPTY
            var Punch_Start_Time: String? = EMPTY
            var Punch_End_Time: String? = EMPTY
            var Punch_Status: Int? = 0
            var Punch_Offset: String? = EMPTY
            var Punch_TimeZone: String? = EMPTY
            var Punch_UTC_DateTime: String? = EMPTY
            
            if (doctorVisitObj.DCR_Code != nil)
            {
                dcrCode = doctorVisitObj.DCR_Code!
            }
            if (doctorVisitObj.DCR_Doctor_Visit_Code != nil)
            {
                dcrVisitCode = doctorVisitObj.DCR_Doctor_Visit_Code!
            }
            if (doctorVisitObj.Doctor_Id != nil)
            {
                doctorId = doctorVisitObj.Doctor_Id!
            }
            if (doctorVisitObj.Doctor_Region_Code != nil)
            {
                doctorRegionCode = doctorVisitObj.Doctor_Region_Code!
            }
            if (doctorVisitObj.Doctor_Code != nil)
            {
                doctorCode = doctorVisitObj.Doctor_Code!
            }
            if (doctorVisitObj.Doctor_Name != nil)
            {
                doctorName = doctorVisitObj.Doctor_Name
            }
            if (doctorVisitObj.MDL_Number != nil)
            {
                mdlNumber = doctorVisitObj.MDL_Number!
            }
            if (doctorVisitObj.Speciality_Name != nil)
            {
                specialtyName = doctorVisitObj.Speciality_Name!
            }
            if (doctorVisitObj.Visit_Mode != nil)
            {
                visitMode = doctorVisitObj.Visit_Mode!
            }
            if (doctorVisitObj.Visit_Time != nil)
            {
                visitTime = doctorVisitObj.Visit_Time!
            }
            if (doctorVisitObj.Is_CP_Doctor != nil)
            {
                isCPDoc = "\(doctorVisitObj.Is_CP_Doctor!)"
            }
            if (doctorVisitObj.POB_Amount != nil)
            {
                pobAmount = doctorVisitObj.POB_Amount!
            }
            if (doctorVisitObj.Category_Code != nil)
            {
                categoryCode = doctorVisitObj.Category_Code!
            }
            if (doctorVisitObj.Is_Acc_Doctor != nil)
            {
                isAccDoc = "\(doctorVisitObj.Is_Acc_Doctor!)"
            }
            if (doctorVisitObj.Remarks != nil)
            {
                remarks = doctorVisitObj.Remarks!
            }
            if (doctorVisitObj.Campaign_Code != nil)
            {
                campaignCode = doctorVisitObj.Campaign_Code!
            }
            if (doctorVisitObj.Campaign_Name != nil)
            {
                campaignName = doctorVisitObj.Campaign_Name!
            }
            
            
            if (checkNullAndNilValueForString(stringData: doctorVisitObj.Lattitude) != "")
            {
                if let lat = Double(doctorVisitObj.Lattitude!)
                {
                    latitude = lat
                }
                else
                {
                    let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                    
                    BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                }
            }
            
            if (checkNullAndNilValueForString(stringData: doctorVisitObj.Longitude) != "")
            {
                if let longi = Double(doctorVisitObj.Longitude!)
                {
                    longitude = longi
                }
                else
                {
                    let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                    
                    BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                }
            }
            
            if (doctorVisitObj.Category_Name != nil)
            {
                categoryName = doctorVisitObj.Category_Name!
            }
            if (doctorVisitObj.Doctor_Region_Name != nil)
            {
                regionName = doctorVisitObj.Doctor_Region_Name!
            }
            
            if (visitTime.count >= 3)
            {
                visitTime = String(visitTime.dropLast(3))
            }
            
            if (doctorVisitObj.Business_Status_ID != nil && doctorVisitObj.Business_Status_ID != defaultBusineessStatusId)
            {
                businessStatusId = doctorVisitObj.Business_Status_ID!
            }
            
            if (doctorVisitObj.Call_Objective_ID != nil && doctorVisitObj.Call_Objective_ID != defaultCallObjectiveId)
            {
                callObjectiveId = doctorVisitObj.Call_Objective_ID!
            }
            
            if (checkNullAndNilValueForString(stringData: doctorVisitObj.Geo_Fencing_Deviation_Remarks) != EMPTY)
            {
                geoFencingRemarks = doctorVisitObj.Geo_Fencing_Deviation_Remarks!
            }
            
            if (checkNullAndNilValueForString(stringData: doctorVisitObj.Geo_Fencing_Deviation_Remarks) != EMPTY)
            {
                geoFencingPageSource = doctorVisitObj.Geo_Fencing_Page_Source!
            }
            
            let dict1: NSDictionary = ["Visit_Id": doctorVisitObj.DCR_Doctor_Visit_Id, "DCR_Id": doctorVisitObj.DCR_Id, "DCR_Code": dcrCode, "DCR_Visit_Code": dcrVisitCode, "Doctor_Id": doctorId, "Doctor_Region_Code": doctorRegionCode, "Doctor_Code": doctorCode, "Doctor_Name": doctorName]
            
            let dict2: NSDictionary = ["MDL_Number": mdlNumber, "Speciality_Name": specialtyName, "Visit_Mode": visitMode, "Visit_Time": visitTime, "IS_CP_Doctor": isCPDoc, "POB_Amount": pobAmount, "Category_Code": categoryCode, "Is_Acc_Doctor": isAccDoc]
            
            let dict3: NSDictionary = ["Remarks": remarks, "Lattitude": latitude, "Longitude": longitude, "Category_Name": categoryName, "Region_Name": regionName, "Source_Of_Entry": "iOS", "Business_Status_ID": businessStatusId, "Call_Objective_ID": callObjectiveId, "Geo_Fencing_Deviation_Remarks": geoFencingRemarks, "Geo_Fencing_Page_Source": geoFencingPageSource, "Is_DCR_Inherited_Doctor": doctorVisitObj.Is_DCR_Inherited_Doctor!,"Campaign_Code":campaignCode,"Punch_Status": doctorVisitObj.Punch_Status,"Customer_Met_StartTime": doctorVisitObj.Punch_Start_Time,"Customer_Met_EndTime": doctorVisitObj.Punch_End_Time,"Punch_TimeZone": doctorVisitObj.Punch_TimeZone,"Punch_OffSet": doctorVisitObj.Punch_Offset,"UTC_DateTime": getUTCDateForPunch(),
                                       "Entered_TimeZone":getcurrenttimezone(),
                                       "Entered_OffSet":getOffset(),
                                       "Created_DateTime":getCurrentDateAndTimeString()]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }

    private func getDCRDoctorAccompanist(dcrId: Int) -> NSMutableArray
    {
        let dcrDoctorAccompanist = DBHelper.sharedInstance.getDCRDoctorAccompanistForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrDoctorAccompObj in dcrDoctorAccompanist
        {
            var accRegionCode: String = EMPTY
            var accUserName: String = EMPTY
            var accUserCode: String = EMPTY
            var accUserTypeName: String = EMPTY
            var isOnlyForDoctor: Int = 0
            var isAccompaniedCall: Int = 0
            
            if (dcrDoctorAccompObj.Acc_Region_Code != nil)
            {
                accRegionCode = dcrDoctorAccompObj.Acc_Region_Code!
            }
            if (dcrDoctorAccompObj.Acc_User_Name != nil)
            {
                accUserName = dcrDoctorAccompObj.Acc_User_Name!
            }
            if (dcrDoctorAccompObj.Acc_User_Type_Name != nil)
            {
                accUserTypeName = dcrDoctorAccompObj.Acc_User_Type_Name!
            }
            if (dcrDoctorAccompObj.Is_Only_For_Doctor != nil)
            {
                if (dcrDoctorAccompObj.Is_Only_For_Doctor == "1" || dcrDoctorAccompObj.Is_Only_For_Doctor == "Y")
                {
                    isOnlyForDoctor = 1
                }
                else if (dcrDoctorAccompObj.Is_Only_For_Doctor == "0" || dcrDoctorAccompObj.Is_Only_For_Doctor == "N")
                {
                    isOnlyForDoctor = 0
                }
            }
            if (dcrDoctorAccompObj.Acc_User_Code != nil)
            {
                accUserCode = dcrDoctorAccompObj.Acc_User_Code!
            }
            
            let accompaniedCall = checkNullAndNilValueForString(stringData: dcrDoctorAccompObj.Is_Accompanied)
            
            if (accompaniedCall != EMPTY)
            {
                isAccompaniedCall = Int(accompaniedCall)!
            }
            
            var dict: NSMutableDictionary = ["DCR_Doctor_Accompanist_Id": dcrDoctorAccompObj.DCR_Doctor_Accompanist_Id, "DCR_Id": dcrDoctorAccompObj.DCR_Id, "Visit_ID": dcrDoctorAccompObj.DCR_Doctor_Visit_Id, "Acc_Region_Code": accRegionCode, "Acc_User_Name": accUserName, "Acc_User_Code": accUserCode, "Acc_user_Type_Name": accUserTypeName, "Is_Only_For_Doctor": isOnlyForDoctor, "accompainedCall": isAccompaniedCall]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getSampleDetails(dcrId: Int) -> NSMutableArray
    {
        let dcrSampleList = DBHelper.sharedInstance.getDCRSampleDetailsForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for objDCRSample in dcrSampleList
        {
            var productId: Int = 0
            var qtyGiven: Int = 0
            var specialtyCode: String = EMPTY
            var currentStock: Int = 0
            
            if (objDCRSample.sampleObj.Product_Id != nil)
            {
                productId = objDCRSample.sampleObj.Product_Id!
            }
            if (objDCRSample.sampleObj.Quantity_Provided != nil)
            {
                qtyGiven = objDCRSample.sampleObj.Quantity_Provided!
            }
            if (objDCRSample.sampleObj.Speciality_Code != nil)
            {
                specialtyCode = objDCRSample.sampleObj.Speciality_Code!
            }
            if (objDCRSample.sampleObj.Current_Stock != nil)
            {
                currentStock = objDCRSample.sampleObj.Current_Stock!
            }
            let sampleBatchList = getDCRSampleBatchProducts(dcrId: dcrId, visitId: objDCRSample.sampleObj.DCR_Doctor_Visit_Id, productCode: objDCRSample.sampleObj.Product_Code, entityType: sampleBatchEntity.Doctor.rawValue)
            var dict: NSMutableDictionary = ["DCR_Sample_Id": objDCRSample.sampleObj.DCR_Sample_Id, "Visit_Id": objDCRSample.sampleObj.DCR_Doctor_Visit_Id, "DCR_Id": objDCRSample.sampleObj.DCR_Id, "Product_Id": productId, "Product_Code": objDCRSample.sampleObj.Product_Code, "Quantity_Provided": qtyGiven, "Speciality_Code": specialtyCode, "Product_Name": objDCRSample.sampleObj.Product_Name, "Current_Stock": currentStock,"lstuserproductbatch":sampleBatchList]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRSampleBatchProducts(dcrId:Int,visitId:Int,productCode:String,entityType:String)-> NSMutableArray
    {
        let dcrSampleList = DBHelper.sharedInstance.getDCRSampleBatchDetailsForUpload(dcrId: dcrId,visitId:visitId,productCode:productCode,entityType:entityType)
        let resultList: NSMutableArray = []
        
        for obj in dcrSampleList
        {
            var dict: NSMutableDictionary = ["Batch_Number": obj.Batch_Number, "Quantity_Provided": obj.Quantity_Provided]
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            resultList.add(dict)
        }

       return resultList
    }

    private func getDCRDetailedProducts(dcrId: Int) -> NSMutableArray
    {
        let dcrDetailedProducts = DBHelper.sharedInstance.getDCRDetailedProductsForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrDetailedProductObj in dcrDetailedProducts
        {
            var dcrCode: String = EMPTY
            var dcrVisitCode: String = EMPTY
            var productId: Int = 0
            var businessStatusId: Int = 0
            var businessStatusRemarks: String = EMPTY
            var potential: Float = 0
            
            if (dcrDetailedProductObj.DCR_Code != nil)
            {
                dcrCode = dcrDetailedProductObj.DCR_Code!
            }
            if (dcrDetailedProductObj.DCR_Doctor_Visit_Code != nil)
            {
                dcrVisitCode = dcrDetailedProductObj.DCR_Doctor_Visit_Code!
            }
            if (dcrDetailedProductObj.Product_Id != nil)
            {
                productId = dcrDetailedProductObj.Product_Id!
            }
            
            if (dcrDetailedProductObj.Business_Status_ID != nil && dcrDetailedProductObj.Business_Status_ID != defaultBusineessStatusId)
            {
                businessStatusId = dcrDetailedProductObj.Business_Status_ID
            }
            
            if (dcrDetailedProductObj.Remarks != nil)
            {
                businessStatusRemarks = dcrDetailedProductObj.Remarks!
            }
            
            potential = dcrDetailedProductObj.Business_Potential
            
            var dict: NSMutableDictionary = ["DCR_Detailed_Products_Id": dcrDetailedProductObj.DCR_Detailed_Products_Id, "Visit_Id": dcrDetailedProductObj.DCR_Doctor_Visit_Id, "DCR_Code": dcrCode, "DCR_Visit_Code": dcrVisitCode, "DCR_Id": dcrDetailedProductObj.DCR_Id, "Product_Id": productId, "Product_Code": dcrDetailedProductObj.Product_Code, "Business_Status_ID": businessStatusId, "Business_Status_Remarks": businessStatusRemarks, "BusinessPotential": potential]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRChemistVisit(dcrId: Int) -> NSMutableArray
    {
        let dcrChemistVisit = DBHelper.sharedInstance.getDCRChemistVisitForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrChemistVisitObj in dcrChemistVisit
        {
            var chemistId: Int = 0
            var chemistCode: String = EMPTY
            var chemistName: String = EMPTY
            var pobAmount: Double = 0
            let mdlNumber: String = EMPTY
            let remarks: String = EMPTY
            var visitId: Int = 0
            
            if (dcrChemistVisitObj.DCR_Doctor_Visit_Id != nil)
            {
                visitId = dcrChemistVisitObj.DCR_Doctor_Visit_Id!
            }
            if (dcrChemistVisitObj.Chemist_Id != nil)
            {
                chemistId = dcrChemistVisitObj.DCR_Chemist_Visit_Id
            }
            if (dcrChemistVisitObj.Chemist_Code != nil)
            {
                chemistCode = dcrChemistVisitObj.Chemist_Code!
            }
            if (dcrChemistVisitObj.Chemist_Name != nil)
            {
                chemistName = dcrChemistVisitObj.Chemist_Name!
            }
            if (dcrChemistVisitObj.POB_Amount != nil)
            {
                pobAmount = dcrChemistVisitObj.POB_Amount!
            }
//            if (dcrChemistVisitObj.Cv_Customer_MDL_Number != nil)
//            {
//                mdlNumber = dcrChemistVisitObj.Cv_Customer_MDL_Number
//            }
//            if (dcrChemistVisitObj.Cv_Remarks != nil)
//            {
//                remarks = dcrChemistVisitObj.Cv_Remarks
//            }
            
            let dict1: NSMutableDictionary = ["DCR_Chemists_Id": dcrChemistVisitObj.DCR_Chemist_Visit_Id, "Visit_Id": visitId, "DCR_Chemists_Code": EMPTY, "DCR_Id": dcrChemistVisitObj.DCR_Id, "Chemist_Code": chemistCode, "Chemist_Id": chemistId, "Chemist_Name": chemistName, "POB_Amount": pobAmount]
            let dict2: NSMutableDictionary = ["DCR_Code": EMPTY, "Chemists_Visit_latitude": 0.0, "Chemists_Visit_Longitude": 0.0, "Chemists_Region_Code": EMPTY, "Chemists_MDL_Number": mdlNumber, "Remarks": remarks, "Visit_Mode": EMPTY, "Visit_Time": EMPTY]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        let chemistDayVisits = getDCRChemistDayVisit(dcrId: dcrId)
        
        if (chemistDayVisits.count > 0)
        {
            resultList.addObjects(from: chemistDayVisits as! [Any])
        }
        
        return resultList
    }
    
    private func getRCPADetails(dcrId: Int) -> NSMutableArray
    {
        let dcrRCPADetails = DBHelper.sharedInstance.getDCRRCPADetailsForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrRCPAObj in dcrRCPADetails
        {
            var ownProductId: Int = 0
            var ownProductCode: String = EMPTY
            var qtyGiven: Float = 0
            var compProductId: Int = 0
            var compProductCode: String = EMPTY
            var compProductName: String = EMPTY
            var productCode: String = EMPTY
            
            if (dcrRCPAObj.Own_Product_Id != nil)
            {
                ownProductId = dcrRCPAObj.Own_Product_Id!
            }
            if (dcrRCPAObj.Own_Product_Code != nil)
            {
                ownProductCode = dcrRCPAObj.Own_Product_Code!
            }
            if (dcrRCPAObj.Qty_Given != nil)
            {
                qtyGiven = dcrRCPAObj.Qty_Given!
            }
            if (dcrRCPAObj.Competitor_Product_Id != nil)
            {
                compProductId = dcrRCPAObj.Own_Product_Id!
            }
            if (dcrRCPAObj.Competitor_Product_Code != nil)
            {
                compProductCode = dcrRCPAObj.Competitor_Product_Code!
            }
            if (dcrRCPAObj.Competitor_Product_Name != nil)
            {
                compProductName = dcrRCPAObj.Competitor_Product_Name!
            }
            if (dcrRCPAObj.Product_Code != nil)
            {
                productCode = dcrRCPAObj.Product_Code!
            }
            
            if (ownProductCode != EMPTY && compProductName == EMPTY)
            {
                compProductName = dcrRCPAObj.Own_Product_Name!
            }
            
            let dict1: NSDictionary = ["DCR_RCPA_Id": dcrRCPAObj.DCR_RCPA_Id, "DCR_Chemists_Id": dcrRCPAObj.DCR_Chemist_Visit_Id, "Visit_Id": dcrRCPAObj.DCR_Doctor_Visit_Id, "DCR_Code": "", "DCR_Visit_Code": "", "Chemist_Visit_Code": "", "DCR_ID": dcrRCPAObj.DCR_Id, "Own_Product_Id": ownProductId]
            let dict2: NSDictionary = ["Own_Product_Code": ownProductCode, "Qty_Given": qtyGiven, "Competitor_Product_Name": compProductName, "Competitor_Product_Code": compProductCode, "Competitor_Product_Id": compProductId, "Product_Code": productCode]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    func getDoctorVisitFollowUpDetails(dcrId : Int,dcrActualDate : String) -> NSMutableArray
    {
        let dcrFollowUpDetails = DBHelper.sharedInstance.getDCRFollowUpDetailsByDCRId(dcrId: dcrId)
        let resultList : NSMutableArray = []
        
        for obj in dcrFollowUpDetails
        {
            var dcrDoctorVisitCode : String = EMPTY
            var followUpText : String = EMPTY
            var dueDate : String = EMPTY
            
            if obj.DCR_Doctor_Visit_Code != nil
            {
                dcrDoctorVisitCode = obj.DCR_Doctor_Visit_Code
            }
            
            if obj.Follow_Up_Text !=  nil
            {
                followUpText = obj.Follow_Up_Text
            }
            
            if (obj.Due_Date != nil)
            {
                dueDate = convertDateIntoServerStringFormat(date: obj.Due_Date)
            }
            
            let dict1: NSDictionary = ["Visit_Id": obj.DCR_Doctor_Visit_Id, "Tasks":followUpText, "Due_Date": dueDate, "DCR_FollowUp_Id":obj.Follow_Up_Id, "DCR_Id": obj.DCR_Id,
                                       "UTC_DateTime":getUTCDateForPunch(),
                                       "Entered_TimeZone":getcurrenttimezone(),
                                       "Entered_OffSet":getOffset(),
                                       "Created_DateTime":getCurrentDateAndTimeString()
]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        return resultList
    }
    
    private func getDoctorVisitAttachments(dcrId: Int) -> NSMutableArray
    {
        let attachmentList = DBHelper.sharedInstance.getUploadableAttachments(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrAttachmentObj in attachmentList
        {
            let dcrCode: String = ""
            let dcrVisitCode: String!
            let blobUrl: String!
            var visitId: Int!
            var dcrId: Int!
            var uploadedFileName: String = ""
            let userCode: String = ""
            var dcrDate: String = ""
            let updatedDateTime: String = ""
            let checkSumId: Int = 0
            
            visitId = dcrAttachmentObj.doctorVisitId
            dcrId = dcrAttachmentObj.dcrId
            uploadedFileName = dcrAttachmentObj.attachmentName!
            dcrDate = dcrAttachmentObj.dcrDate
            blobUrl = dcrAttachmentObj.attachmentBlobUrl!
            dcrVisitCode = dcrAttachmentObj.dcrVisitCode!
            
            let dict1: NSDictionary = ["DCR_Code": dcrCode, "DCR_Visit_Code": dcrVisitCode, "Blob_Url": blobUrl, "Visit_Id": visitId, "DCR_Id": dcrId]
            let dict2: NSDictionary = ["Uploaded_File_Name": uploadedFileName, "User_Code": userCode, "DCR_Actual_Date": dcrDate, "Updated_Date_Time": updatedDateTime, "CheckSumId": checkSumId,
                                       "UTC_DateTime":getUTCDateForPunch(),
                                       "Entered_TimeZone":getcurrenttimezone(),
                                       "Entered_OffSet":getOffset(),
                                       "Created_DateTime":getCurrentDateAndTimeString()]
            
            var combinedAttributes : NSMutableDictionary!
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getStockistVisitDetails(dcrId: Int) -> NSMutableArray
    {
        //let dcrStockistList = DBHelper.sharedInstance.getDCRStockiestVisitList(dcrId: dcrId)
        
        let dcrStockistList = DBHelper.sharedInstance.getDCRStockistVisitForUpload(dcrId: dcrId)
        
        let resultList: NSMutableArray = []
        
        //getDCRStockistVisitForUpload
        
        for dcrStockistObj in dcrStockistList
        {
            var stockistId: Int = 0
            var pobAmount: Double = 0
            var collectionAmount: Double = 0
            var visitMode: String = EMPTY
            var remarks: String = EMPTY
            var visitTime: String = EMPTY
            
            var latitude = "0.0"
            var longitude = "0.0"
            
            
            if (dcrStockistObj.Stockiest_Id != nil)
            {
                stockistId = dcrStockistObj.Stockiest_Id!
            }
            if (dcrStockistObj.POB_Amount != nil)
            {
                pobAmount = dcrStockistObj.POB_Amount!
            }
            if (dcrStockistObj.Collection_Amount != nil)
            {
                collectionAmount = dcrStockistObj.Collection_Amount!
            }
            if (dcrStockistObj.Visit_Mode != nil)
            {
                visitMode = dcrStockistObj.Visit_Mode!
            }
            if (dcrStockistObj.Remarks != nil)
            {
                remarks = dcrStockistObj.Remarks!
            }
            if (dcrStockistObj.Visit_Time != nil)
            {
                visitTime = dcrStockistObj.Visit_Time!
            }
            
            
            if (dcrStockistObj.Latitude != nil)
            {
                latitude = dcrStockistObj.Latitude!
            }
            if (dcrStockistObj.Longitude != nil)
            {
                longitude = dcrStockistObj.Longitude!
            }
            
            
            
            
            
            let dict1: NSDictionary = ["DCR_Stockiest_Id": dcrStockistObj.DCR_Stockiest_Id, "DCR_Id": dcrStockistObj.DCR_Id, "Stockiest_Code": dcrStockistObj.Stockiest_Code, "Stockiest_Id": stockistId, "Stockiest_Name": dcrStockistObj.Stockiest_Name!, "POB_Amount": pobAmount]
            let dict2: NSDictionary = ["Collection_Amount": collectionAmount, "Visit_Mode": visitMode, "Remarks": remarks, "DCR_Code": "", "Visit_Time": visitTime]
            let dict3: NSDictionary = ["Latitude": latitude, "Longitude": longitude]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getExpenseList(dcrId: Int) -> NSMutableArray
    {
        let dcrExpenseList = DBHelper.sharedInstance.getDCRExpenseDetailsForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrExpenseObj in dcrExpenseList
        {
            var expenseMode: String = EMPTY
            var expenseClaimCode: String = EMPTY
            var eligibilityAmount: Float = 0
            var remarks: String = EMPTY
            
            if (dcrExpenseObj.Expense_Mode != nil)
            {
                expenseMode = dcrExpenseObj.Expense_Mode!
            }
            if (dcrExpenseObj.Expense_Claim_Code != nil)
            {
                expenseClaimCode = dcrExpenseObj.Expense_Claim_Code!
            }
            if (dcrExpenseObj.Eligibility_Amount != nil)
            {
                eligibilityAmount = dcrExpenseObj.Eligibility_Amount!
            }
            if (dcrExpenseObj.Remarks != nil)
            {
                remarks = dcrExpenseObj.Remarks!
            }
            
            let dict1: NSDictionary = ["DCR_Id": dcrExpenseObj.DCR_Id, "DCR_Code": "", "DCR_Expense_Type_Id": dcrExpenseObj.DCR_Expense_Id!, "DCR_Expense_Type_Code": dcrExpenseObj.Expense_Type_Code, "Expense_Amount": Double(dcrExpenseObj.Expense_Amount!),"Expense_Mode": expenseMode,"Expense_Claim_Code": expenseClaimCode]
            let dict2: NSDictionary = ["Eligibility_Amount": eligibilityAmount, "Expense_Group_Id": dcrExpenseObj.Expense_Group_Id!, "Remarks": remarks, "Expense_Type_Name": dcrExpenseObj.Expense_Type_Name!]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getAttendanceActivities(dcrId: String, dcridvalue: Int) -> NSMutableArray
    {
        let dcrAttendanceActivities = DBHelper.sharedInstance.getDCRAttendanceActivitiesForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrAttendanceObj in dcrAttendanceActivities
        {
            var remarks: String = EMPTY
            
            if (dcrAttendanceObj.Remarks != nil)
            {
                remarks = dcrAttendanceObj.Remarks!
            }
            
            var dict: NSMutableDictionary = ["DCR_Id": dcridvalue, "DCR_Attendance_Id": dcrAttendanceObj.DCR_Attendance_Id, "Activity_Code": dcrAttendanceObj.Activity_Code, "Project_Code": dcrAttendanceObj.Project_Code!, "Start_Time": dcrAttendanceObj.Start_Time!, "End_Time": dcrAttendanceObj.End_Time!, "Remarks": remarks,
                                             "UTC_DateTime":getUTCDateForPunch(),
                                             "Entered_TimeZone":getcurrenttimezone(),
                                             "Entered_OffSet":getOffset(),
                                             "Created_DateTime":getCurrentDateAndTimeString()]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getPOBHeader(dcrId: Int) -> NSMutableArray
    {
        let lstPOBHeader = DBHelper.sharedInstance.getPOBHeaderForUpload(dcrId: dcrId)
        let lstPOBDetails = DBHelper.sharedInstance.getPOBDetailsForUpload(dcrId: dcrId)
        let lstPOBRemarks = DBHelper.sharedInstance.getPOBRemarksForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for objPOB in lstPOBHeader
        {
            var visitId: Int = 0
            var orderId: Int = 0
            var clientOrderId: Int = 0
            var orderNumber: Int = 0
            var orderDate: String = EMPTY
            var dcrActualDate: String = EMPTY
            var customerCode: String = EMPTY
            var customerRegionCode: String = EMPTY
            var customerName: String = EMPTY
            var customerSpecialty: String = EMPTY
            var mdlNumber: String = EMPTY
            var categoryCode: String = EMPTY
            var stockistCode: String = EMPTY
            var stockistRegionCode: String = EMPTY
            var orderDueDate: String = EMPTY
            let orderMode: Int = 0
            var entityType: String = EMPTY
            var favouringUserCode: String = EMPTY
            var favouringRegionCode: String = EMPTY
            var remarks: String = EMPTY
            var actionMode: Int = 0
            
            
            
            if (objPOB.Visit_Id != nil)
            {
                visitId = objPOB.Visit_Id
            }
            if (objPOB.Order_Id != nil)
            {
                orderId = objPOB.Order_Id
            }
            if (objPOB.Order_Entry_Id != nil)
            {
                clientOrderId = objPOB.Order_Entry_Id
            }
            if (objPOB.Order_Number != nil)
            {
                orderNumber = objPOB.Order_Number
            }
            if (objPOB.Order_Date != nil)
            {
                orderDate = convertDateIntoServerStringFormat(date: objPOB.Order_Date)
            }
            if (objPOB.DCR_Actual_Date != nil)
            {
                dcrActualDate = convertDateIntoServerStringFormat(date: objPOB.DCR_Actual_Date)
            }
            if (objPOB.Customer_Code != nil)
            {
                customerCode = checkNullAndNilValueForString(stringData: objPOB.Customer_Code)
            }
            if (objPOB.Customer_Region_Code != nil)
            {
                customerRegionCode = checkNullAndNilValueForString(stringData: objPOB.Customer_Region_Code)
            }
            if (objPOB.Customer_Name != nil)
            {
                customerName = checkNullAndNilValueForString(stringData: objPOB.Customer_Name)
            }
            if (objPOB.Customer_MDL_Number != nil)
            {
                mdlNumber = checkNullAndNilValueForString(stringData: objPOB.Customer_MDL_Number)
            }
            if (objPOB.Speciality_Name != nil)
            {
                customerSpecialty = checkNullAndNilValueForString(stringData: objPOB.Speciality_Name)
            }
            if (objPOB.Customer_Category_Code != nil)
            {
                categoryCode = checkNullAndNilValueForString(stringData: objPOB.Customer_Category_Code)
            }
            if (objPOB.Stockiest_Code != nil)
            {
                stockistCode = checkNullAndNilValueForString(stringData: objPOB.Stockiest_Code)
            }
            if (objPOB.Stockiest_Region_Code != nil)
            {
                stockistRegionCode = checkNullAndNilValueForString(stringData: objPOB.Stockiest_Region_Code)
            }
            if (objPOB.Order_Due_Date != nil)
            {
                orderDueDate = convertDateIntoServerStringFormat(date: objPOB.Order_Due_Date)
            }
//            if (objPOB.Order_Mode != nil)
//            {
//                orderMode = objPOB.Order_Mode
//            }
            if (objPOB.Customer_Entity_Type != nil)
            {
                entityType = checkNullAndNilValueForString(stringData: objPOB.Customer_Entity_Type)
            }
            if (objPOB.Favouring_User_Code != nil)
            {
                favouringUserCode = checkNullAndNilValueForString(stringData: objPOB.Favouring_User_Code)
            }
            if (objPOB.Favouring_Region_Code != nil)
            {
                favouringRegionCode = checkNullAndNilValueForString(stringData: objPOB.Favouring_Region_Code)
            }
            if (objPOB.Action_Mode != nil)
            {
                actionMode = objPOB.Action_Mode
            }
            
            let filteredArray = lstPOBRemarks.filter{
                $0.Order_Entry_Id == clientOrderId
            }
            
            if (filteredArray.count > 0)
            {
                remarks = checkNullAndNilValueForString(stringData: filteredArray.first!.Remarks)
            }
            
            let pobDetailsArray = lstPOBDetails.filter{
                $0.Order_Entry_Id == clientOrderId
            }
            
            let dict1: NSMutableDictionary = ["DCR_Id": objPOB.DCR_Id!, "Visit_Id": visitId, "Order_Id": orderId, "Client_Order_Id": clientOrderId, "Order_Number": orderNumber, "Order_Date": orderDate, "DCR_Actual_Date": dcrActualDate, "Customer_Code": customerCode]
            let dict2: NSMutableDictionary = ["Customer_Region_Code": customerRegionCode, "Customer_Name": customerName, "Customer_Speciality": customerSpecialty, "Customer_MDLNumber": mdlNumber, "Customer_CategoryCode": categoryCode, "Stockiest_Code": stockistCode, "Stockiest_Region_Code": stockistRegionCode, "Order_Due_Date": orderDueDate]
            let dict3: NSMutableDictionary = ["Order_Status": 1, "Order_Mode": orderMode, "Entity_Type": entityType, "Favouring_User_Code": favouringUserCode, "Favouring_Region_Code": favouringRegionCode, "Remarks": remarks, "Source_Of_Entry": Source_Of_Entry, "Action_Mode": actionMode,"UTC_DateTime":getUTCDateForPunch(),
                                              "Entered_TimeZone":getcurrenttimezone(),
                                              "Entered_OffSet":getOffset(),
                                              "Created_DateTime":getCurrentDateAndTimeString()]
            let pobDetails = getPOBDetails(dcrId: dcrId, lstPOBHeader: lstPOBHeader, lstPOBDetails: pobDetailsArray)
            let dict4: NSMutableDictionary = ["Orderdetails": pobDetails]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict4 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getPOBDetails(dcrId: Int, lstPOBHeader: [DCRDoctorVisitPOBHeaderModel], lstPOBDetails: [DCRDoctorVisitPOBDetailsModel]) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        
        for objPOB in lstPOBDetails
        {
            var visitId: Int = 0
            var orderId: Int = 0
            var clientOrderId: Int = 0
            var orderDetailId: Int = 0
            var productCode: String = EMPTY
            var productName: String = EMPTY
            var qty: Double = 0
            var unitRate: Double = 0
            var amount: Double = 0
            
            if (objPOB.Order_Entry_Id != nil)
            {
                clientOrderId = objPOB.Order_Entry_Id
            }
            if (objPOB.Order_Detail_Id != nil)
            {
                orderDetailId = objPOB.Order_Detail_Id
            }
            if (objPOB.Product_Code != nil)
            {
                productCode = checkNullAndNilValueForString(stringData: objPOB.Product_Code)
            }
            if (objPOB.Product_Name != nil)
            {
                productName = checkNullAndNilValueForString(stringData: objPOB.Product_Name)
            }
            if (objPOB.Product_Qty != nil)
            {
                qty = objPOB.Product_Qty
            }
            if (objPOB.Product_Unit_Rate != nil)
            {
                unitRate = objPOB.Product_Unit_Rate
            }
            if (objPOB.Product_Amount != nil)
            {
                amount = objPOB.Product_Amount
            }
            
            let filteredArray = lstPOBHeader.filter{
                $0.Order_Entry_Id == clientOrderId
            }
            
            if (filteredArray.count > 0)
            {
                orderId = filteredArray.first!.Order_Id
                visitId = filteredArray.first!.Visit_Id
            }
            
            let dict1: NSMutableDictionary = ["DCR_Id": objPOB.DCR_Id!, "Visit_Id": visitId, "Client_Order_Id": clientOrderId, "Order_Id": orderId, "Order_Detail_ID": orderDetailId, "Product_Code": productCode, "Product_Name": productName, "Product_Qty": qty]
            let dict2: NSMutableDictionary = ["Product_Unit_Rate": unitRate, "Product_Amount": amount]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getDCRChemistDayVisit(dcrId: Int) -> NSMutableArray
    {
        let dcrChemistVisit = DBHelper.sharedInstance.getChemistDayVisitDetailsForUpload(dcrId: dcrId)
        let resultList: NSMutableArray = []
        
        for dcrChemistVisitObj in dcrChemistVisit
        {
            var chemistCode: String = EMPTY
            var chemistName: String = EMPTY
            var mdlNumber: String = EMPTY
            var remarks: String = EMPTY
            var visitMode: String = EMPTY
            var visitTime: String = EMPTY
            var latitude: String = "0.0"
            var longitude: String = "0.0"
            var regionCode: String = EMPTY
            
            if (dcrChemistVisitObj.ChemistCode != nil)
            {
                chemistCode = dcrChemistVisitObj.ChemistCode!
            }
            if (dcrChemistVisitObj.ChemistName != nil)
            {
                chemistName = dcrChemistVisitObj.ChemistName!
            }
            if (dcrChemistVisitObj.MDLNumber != nil)
            {
                mdlNumber = dcrChemistVisitObj.MDLNumber
            }
            if (dcrChemistVisitObj.Remarks != nil)
            {
                remarks = dcrChemistVisitObj.Remarks
            }
            if (dcrChemistVisitObj.VisitMode != nil)
            {
                visitMode = dcrChemistVisitObj.VisitMode
            }
            if (dcrChemistVisitObj.VisitTime != nil)
            {
                let chemVisitTimeArr = dcrChemistVisitObj.VisitTime
                let visitTimeWithoutMode = chemVisitTimeArr?.components(separatedBy: " ")
                visitTime = (visitTimeWithoutMode?[0])!
            }
            
            if (dcrChemistVisitObj.Latitude != nil)
            {
                latitude = String(dcrChemistVisitObj.Latitude)
            }
            if (dcrChemistVisitObj.Longitude != nil)
            {
                longitude = String(dcrChemistVisitObj.Longitude)
            }
            if (dcrChemistVisitObj.RegionCode != nil)
            {
                regionCode = dcrChemistVisitObj.RegionCode
            }
            
            let dict1: NSMutableDictionary = ["DCR_Chemists_Id": 0, "Visit_Id": 0, "DCR_Chemists_Code": EMPTY, "DCR_Id": dcrChemistVisitObj.DCRId, "Chemist_Code": chemistCode, "Chemist_Id": dcrChemistVisitObj.DCRChemistDayVisitId, "Chemist_Name": chemistName, "POB_Amount": 0]
            let dict2: NSMutableDictionary = ["DCR_Code": EMPTY, "Chemists_Visit_latitude": latitude, "Chemists_Visit_Longitude": longitude, "Chemists_Region_Code": regionCode, "Chemists_MDL_Number": mdlNumber, "Remarks": remarks, "Visit_Mode": visitMode, "Visit_Time": visitTime]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getChemistAccompanists(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistAccompanists = DBHelper.sharedInstance.getChemistAccompanistForUpload(dcrId: dcrId)
        
        for objChemistAccompanist in lstChemistAccompanists
        {
            var regionCode: String = EMPTY
            var userName: String = EMPTY
            var userCode: String = EMPTY
            var userTypeName: String = EMPTY
            
            if (objChemistAccompanist.AccRegionCode != nil)
            {
                regionCode = checkNullAndNilValueForString(stringData: objChemistAccompanist.AccRegionCode)
            }
            if (objChemistAccompanist.AccUserName != nil)
            {
                userName = checkNullAndNilValueForString(stringData: objChemistAccompanist.AccUserName)
            }
            if (objChemistAccompanist.AccUserCode != nil)
            {
                userCode = checkNullAndNilValueForString(stringData: objChemistAccompanist.AccUserCode)
            }
            if (objChemistAccompanist.AccUserTypeName != nil)
            {
                userTypeName = checkNullAndNilValueForString(stringData: objChemistAccompanist.AccUserTypeName)
            }
            
            let dict1: NSMutableDictionary = ["DCR_Id": objChemistAccompanist.DCRId, "CV_Visit_Id": objChemistAccompanist.DCRChemistDayVisitId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "Acc_Region_Code": regionCode, "Acc_User_Name": userName, "Acc_User_Code": userCode, "Acc_User_Type_Name": userTypeName]
            let dict2: NSMutableDictionary = ["Is_Only_For_Chemist": objChemistAccompanist.IsOnlyForChemist, "Is_Accompanied_call": objChemistAccompanist.IsAccompaniedCall,"UTC_DateTime":getUTCDateForPunch(),
                                              "Entered_TimeZone":getcurrenttimezone(),
                                              "Entered_OffSet":getOffset(),
                                              "Created_DateTime":getCurrentDateAndTimeString()]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getChemistSamples(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistSamples = DBHelper.sharedInstance.getChemistSamplestForUpload(dcrId: dcrId)
        
        for objChemistSample in lstChemistSamples
        {
            var productCode: String = EMPTY
            var productName: String = EMPTY
            var qty: Int = 0
            
            if (objChemistSample.ProductCode != nil)
            {
                productCode = checkNullAndNilValueForString(stringData: objChemistSample.ProductCode)
            }
            if (objChemistSample.ProductName != nil)
            {
                productName = checkNullAndNilValueForString(stringData: objChemistSample.ProductName)
            }
            if (objChemistSample.QuantityProvided != nil)
            {
                qty = objChemistSample.QuantityProvided
            }
            let sampleBatchList = getDCRSampleBatchProducts(dcrId: dcrId, visitId: objChemistSample.DCRChemistDayVisitId, productCode: productCode, entityType: sampleBatchEntity.Chemist.rawValue)
            
            var dict: NSMutableDictionary = ["DCR_Id": objChemistSample.DCRId, "CV_Visit_Id": objChemistSample.DCRChemistDayVisitId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "Product_Code": productCode, "Product_Name": productName, "Quantity_Provided": qty,
                                             "UTC_DateTime":getUTCDateForPunch(),
                                             "Entered_TimeZone":getcurrenttimezone(),
                                             "Entered_OffSet":getOffset(),
                                    "Created_DateTime":getCurrentDateAndTimeString(),"lstuserproductbatch":sampleBatchList]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getChemistDetailedProducts(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistDetailProducts = DBHelper.sharedInstance.getChemistDetailedProductsForUpload(dcrId: dcrId)
        
        for objChemistDetailProducts in lstChemistDetailProducts
        {
            var productCode: String = EMPTY
            var productName: String = EMPTY
            
            if (objChemistDetailProducts.ProductCode != nil)
            {
                productCode = checkNullAndNilValueForString(stringData: objChemistDetailProducts.ProductCode)
            }
            if (objChemistDetailProducts.ProductName != nil)
            {
                productName = checkNullAndNilValueForString(stringData: objChemistDetailProducts.ProductName)
            }
            
            var dict: NSMutableDictionary = ["Sales_Product_Code": productCode, "Sales_Product_Name": productName, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "CV_Visit_Id": objChemistDetailProducts.DCRChemistDayVisitId,"UTC_DateTime":getUTCDateForPunch(),
                                             "Entered_TimeZone":getcurrenttimezone(),
                                             "Entered_OffSet":getOffset(),
                                             "Created_DateTime":getCurrentDateAndTimeString()]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getChemistRCPAOwn(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistRCPAOwn = DBHelper.sharedInstance.getChemistRCPAOwnForUpload(dcrId: dcrId)
        
        for objChemistRCPA in lstChemistRCPAOwn
        {
            var productCode: String = EMPTY
            var productName: String = EMPTY
            var doctorCode: String = EMPTY
            var doctorName: String = EMPTY
            var specialtyName: String = EMPTY
            var categoryName: String = EMPTY
            var mdlNumber: String = EMPTY
            var qty: Float = 0
            var doctorRegionCode: String = EMPTY
            
            if (objChemistRCPA.ProductCode != nil)
            {
                productCode = checkNullAndNilValueForString(stringData: objChemistRCPA.ProductCode)
            }
            if (objChemistRCPA.ProductName != nil)
            {
                productName = checkNullAndNilValueForString(stringData: objChemistRCPA.ProductName)
            }
            if (objChemistRCPA.DoctorCode != nil)
            {
                doctorCode = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorCode)
            }
            if (objChemistRCPA.DoctorName != nil)
            {
                doctorName = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorName)
            }
            if (objChemistRCPA.DoctorSpecialityName != nil)
            {
                specialtyName = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorSpecialityName)
            }
            if (objChemistRCPA.DoctorCategoryName != nil)
            {
                categoryName = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorCategoryName)
            }
            if (objChemistRCPA.DoctorMDLNumber != nil)
            {
                mdlNumber = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorMDLNumber)
            }
            if (objChemistRCPA.Quantity != nil)
            {
                qty = objChemistRCPA.Quantity
            }
            if (objChemistRCPA.DoctorRegionCode != nil)
            {
                doctorRegionCode = checkNullAndNilValueForString(stringData: objChemistRCPA.DoctorRegionCode)
            }
            
            let dict1: NSMutableDictionary = ["DCR_Id": objChemistRCPA.DCRId, "CV_Visit_Id": objChemistRCPA.DCRChemistDayVisitId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "Product_Code": productCode, "Product_Name": productName, "Chemist_RCPA_OWN_Product_Id": objChemistRCPA.DCRChemistRCPAOwnId, "Customer_Code": doctorCode]
            let dict2: NSMutableDictionary = ["Customer_Name": doctorName, "Customer_Speciality_Name": specialtyName, "Customer_Category_Name": categoryName, "Customer_MDLNumber": mdlNumber, "Qty": qty, "POB": 0, "Customer_RegionCode": doctorRegionCode,"UTC_DateTime":getUTCDateForPunch(),
                                              "Entered_TimeZone":getcurrenttimezone(),
                                              "Entered_OffSet":getOffset(),
                                              "Created_DateTime":getCurrentDateAndTimeString()]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getChemistRCPACompetitor(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistRCPAOwn = DBHelper.sharedInstance.getChemistRCPACompetitorForUpload(dcrId: dcrId)
        
        for objChemistRCPA in lstChemistRCPAOwn
        {
            var ownProductCode: String = EMPTY
            var compProductName: String = EMPTY
            var compProductCode: String = EMPTY
            var qty: Float = 0
            
            if (objChemistRCPA.OwnProductCode != nil)
            {
                ownProductCode = checkNullAndNilValueForString(stringData: objChemistRCPA.OwnProductCode)
            }
            if (objChemistRCPA.CompetitorProductName != nil)
            {
                compProductName = checkNullAndNilValueForString(stringData: objChemistRCPA.CompetitorProductName)
            }
            if (objChemistRCPA.CompetitorProductCode != nil)
            {
                compProductCode = checkNullAndNilValueForString(stringData: objChemistRCPA.CompetitorProductCode)
            }
            if (objChemistRCPA.Quantity != nil)
            {
                qty = objChemistRCPA.Quantity
            }
            
            let dict1: NSMutableDictionary = ["Chemist_RCPA_OWN_Product_Id": objChemistRCPA.DCRChemistRCPAOwnId, "CV_Visit_Id": objChemistRCPA.DCRChemistDayVisitId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "Own_Product_Code": ownProductCode, "Competitor_Product_Name": compProductName, "Competitor_Product_Code": compProductCode, "DCR_ID": objChemistRCPA.DCRId,"UTC_DateTime":getUTCDateForPunch(),
                                              "Entered_TimeZone":getcurrenttimezone(),
                                              "Entered_OffSet":getOffset(),
                                              "Created_DateTime":getCurrentDateAndTimeString()]
            
            let dict2: NSMutableDictionary = ["Qty": qty]
            
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getChemistFollowups(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistFollowup = DBHelper.sharedInstance.getChemistFollowupsForUpload(dcrId: dcrId)
        
        for objChemistFollowup in lstChemistFollowup
        {
            var task: String = EMPTY
            var dueDate: String = EMPTY
            
            if (objChemistFollowup.Task != nil)
            {
                task = checkNullAndNilValueForString(stringData: objChemistFollowup.Task)
            }
            if (objChemistFollowup.DueDate != nil)
            {
                dueDate = convertDateIntoServerStringFormat(date: objChemistFollowup.DueDate)
            }
            
            var dict: NSMutableDictionary = ["Tasks": task, "CV_Visit_Id": objChemistFollowup.DCRChemistDayVisitId, "DCR_Id": objChemistFollowup.DCRId, "Due_Date": dueDate, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(),"UTC_DateTime":getUTCDateForPunch(),
                                             "Entered_TimeZone":getcurrenttimezone(),
                                             "Entered_OffSet":getOffset(),
                                             "Created_DateTime":getCurrentDateAndTimeString()]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getChemistAttachments(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstChemistAttachments = DBHelper.sharedInstance.getChemistAttachmentsForUpload(dcrId: dcrId)
        
        for objChemistAttachment in lstChemistAttachments
        {
            var uploadedFileName: String = EMPTY
            
            if let dcrActualDate = convertDateIntoServerStringFormat1(date: objChemistAttachment.DCRActualDate)
            {
                if (objChemistAttachment.UploadedFileName != nil)
                {
                    uploadedFileName = checkNullAndNilValueForString(stringData: objChemistAttachment.UploadedFileName)
                }
                
                var dict: NSMutableDictionary = ["Uploaded_File_Name": uploadedFileName, "DCR_Actual_Date": dcrActualDate, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode(), "CV_Visit_Id": objChemistAttachment.DCRChemistDayVisitId, "DCR_Id": objChemistAttachment.DCRId,
                                                 "UTC_DateTime":getUTCDateForPunch(),
                                                 "Entered_TimeZone":getcurrenttimezone(),
                                                 "Entered_OffSet":getOffset(),
                                                 "Created_DateTime":getCurrentDateAndTimeString()
]
                
                dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
                
                resultList.add(dict)
            }
            else
            {
                let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                
                BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
            }
        }
        
        return resultList
    }
    
    private func getDCRCallActivities(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstActivity = DBHelper.sharedInstance.getDCRCallActivityForUpload(dcrId: dcrId,entityType: sampleBatchEntity.Doctor.rawValue)
        
        for objActivity in lstActivity
        {
            var dict: NSMutableDictionary = ["Company_code": getCompanyCode(), "Flag": objActivity.Flag, "Customer_Entity_Type": objActivity.Customer_Entity_Type, "Customer_Entity_Type_Description": objActivity.Customer_Entity_Type_Description, "Customer_Activity_ID": objActivity.Customer_Activity_ID, "Activity_Remarks": objActivity.Activity_Remarks, "Company_Id": getCompanyId(), "Visit_Id": objActivity.DCR_Customer_Visit_Id]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRMCActivities(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstActivity = DBHelper.sharedInstance.getDCRMCActivityForUpload(dcrId: dcrId,entityType: sampleBatchEntity.Doctor.rawValue)
        
        
        for objActivity in lstActivity
        {
            var dict: NSMutableDictionary = ["Company_code": getCompanyCode(), "Flag": objActivity.Flag, "Customer_Entity_Type": objActivity.Customer_Entity_Type, "Customer_Entity_Type_Description": objActivity.Customer_Entity_Type_Description, "MC_Activity_Id": objActivity.MC_Activity_Id, "MC_Remark": objActivity.MC_Activity_Remarks, "Company_Id": getCompanyId(), "Visit_Id": objActivity.DCR_Customer_Visit_Id, "Campaign_Code": objActivity.Campaign_Code]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getAttendanceDCRCallActivities(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstActivity = DBHelper.sharedInstance.getDCRCallActivityForUpload(dcrId: dcrId,entityType: sampleBatchEntity.Attendance.rawValue)
        
        for objActivity in lstActivity
        {
            var dict: NSMutableDictionary = ["Company_code": getCompanyCode(), "Flag":"A", "Customer_Entity_Type": objActivity.Customer_Entity_Type, "Customer_Entity_Type_Description": objActivity.Customer_Entity_Type_Description, "Customer_Activity_ID": objActivity.Customer_Activity_ID, "Activity_Remarks": objActivity.Activity_Remarks, "Company_Id": getCompanyId(), "Visit_Id": objActivity.DCR_Customer_Visit_Id]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getAttendanceDCRMCActivities(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstActivity = DBHelper.sharedInstance.getDCRMCActivityForUpload(dcrId: dcrId,entityType: sampleBatchEntity.Attendance.rawValue)
        
        
        for objActivity in lstActivity
        {
            var dict: NSMutableDictionary = ["Company_code": getCompanyCode(), "Flag":"A", "Customer_Entity_Type": objActivity.Customer_Entity_Type, "Customer_Entity_Type_Description": objActivity.Customer_Entity_Type_Description, "MC_Activity_Id": objActivity.MC_Activity_Id, "MC_Remark": objActivity.MC_Activity_Remarks, "Company_Id": getCompanyId(), "Visit_Id": objActivity.DCR_Customer_Visit_Id, "Campaign_Code": objActivity.Campaign_Code]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRInheritanceAccompanists(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstActivity = DBHelper.sharedInstance.getDCRAccompanistForUpload(dcrId: dcrId)
        
        for objAccompanist in lstActivity
        {
            var dict: NSMutableDictionary = ["Acc_User_Code": checkNullAndNilValueForString(stringData: objAccompanist.Acc_User_Code), "Acc_User_Name": checkNullAndNilValueForString(stringData: objAccompanist.Acc_User_Name), "Acc_Region_Code": objAccompanist.Acc_Region_Code, "Is_Customer_Data_Inherited": objAccompanist.Is_Customer_Data_Inherited]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    func getDeleteDoctorAudit() -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstDoctor = DBHelper.sharedInstance.getDCRDeleteDoctorAudit()
        
        for objAudit in lstDoctor
        {
            var dict: NSMutableDictionary = ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "DCR_Actual_Date": objAudit.DCR_Actual_Date, "Doctor_Code": objAudit.Doctor_Code, "Doctor_Region_Code": objAudit.Doctor_Region_Code, "Doctor_Name": objAudit.Doctor_Name, "Delete_Source": "IOS"]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    func deleteDoctorAuditDetails()
    {
        DBHelper.sharedInstance.deleteEDetailedDeleteDoctorAudit()
    }
    
    //Mark:-- DCR Competitor Function
    private func getDCRCompetitor(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstCompetitor = DBHelper.sharedInstance.getDCRDetailedCompetitor(dcrId: dcrId)
        
        for objCompetitor in lstCompetitor
        {
            var dict: NSMutableDictionary = ["Company_Code": getCompanyCode(),"DCR_Id":dcrId,"Visit_Id": objCompetitor.DCR_Doctor_Visit_Id,"DCR_Visit_Code": "","DCR_Code":"", "Doctor_Code": checkNullAndNilValueForString(stringData: objCompetitor.Doctor_Code),"Competitor_Code":objCompetitor.Competitor_Code,"Competitor_Name": checkNullAndNilValueForString(stringData: objCompetitor.Competitor_Name), "Product_Name": checkNullAndNilValueForString(stringData: objCompetitor.Product_Name),"Product_Code":checkNullAndNilValueForString(stringData: objCompetitor.Product_Code), "Probability":objCompetitor.Probability,"value":objCompetitor.Value,"Remarks":checkNullAndNilValueForString(stringData: objCompetitor.Remarks),"Company_id":"","Sale_Product_Code":checkNullAndNilValueForString(stringData: objCompetitor.DCR_Product_Detail_Code)]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    //Mark:-- DCR Attendance Sample Function
    
    
    private func getDCRAttendanceDoctor(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstDoctorList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctor(dcrId: dcrId)
        var visitTime: String = EMPTY
        var visitMode: String = EMPTY
        var pobAmount: Double = 0
        var businessStatusId: Int = 0
        var callObjectiveId : Int = 0
        var campaignCode: String = EMPTY
        var remarks: String = EMPTY
        
        for doctorObj in lstDoctorList
        {
        
            let getDate = convertDateIntoServerStringFormat1(date: doctorObj.DCR_Actual_Date!) as? String
            if (doctorObj.Visit_Time != nil)
            {
                visitTime = doctorObj.Visit_Time!
            }
            if (doctorObj.Visit_Mode != nil)
            {
                visitMode = doctorObj.Visit_Mode!
            }
            if (doctorObj.POB_Amount != nil)
            {
                pobAmount = doctorObj.POB_Amount!
            }
            if (doctorObj.Business_Status_ID != nil && doctorObj.Business_Status_ID != defaultBusineessStatusId)
            {
                businessStatusId = doctorObj.Business_Status_ID
            }
            
            if (doctorObj.Call_Objective_ID != nil && doctorObj.Call_Objective_ID != defaultCallObjectiveId)
            {
                callObjectiveId = doctorObj.Call_Objective_ID!
            }
            
            if (doctorObj.Campaign_Code != nil)
            {
               campaignCode = doctorObj.Campaign_Code
            }
            
            if (doctorObj.Remarks != nil)
            {
                remarks = doctorObj.Remarks ?? EMPTY
            }
            
            
           
            
            var dict: NSMutableDictionary = ["Doctor_Code":doctorObj.Doctor_Code,"Doctor_Name":checkNullAndNilValueForString(stringData:doctorObj.Doctor_Name),"DCR_Code":checkNullAndNilValueForString(stringData:doctorObj.DCR_Code),"Doctor_Visit_Code":checkNullAndNilValueForString(stringData:doctorObj.DCR_Doctor_Visit_Code),"DCR_Actual_Date":checkNullAndNilValueForString(stringData:getDate),"Region_Code":checkNullAndNilValueForString(stringData:doctorObj.Doctor_Region_Code),"Region_Name":checkNullAndNilValueForString(stringData:doctorObj.Doctor_Region_Name),"MDL_Number":doctorObj.MDL_Number,"Speciality_Name":checkNullAndNilValueForString(stringData:doctorObj.Speciality_Name),"Speciality_Code":checkNullAndNilValueForString(stringData:doctorObj.Speciality_Code),"Category_Code":checkNullAndNilValueForString(stringData:doctorObj.Category_Code),"Category_Name":checkNullAndNilValueForString(stringData:doctorObj.Category_Name),"Visit_Id":doctorObj.DCR_Doctor_Visit_Id,"Visit_Time":visitTime,"Visit_Mode":visitMode,"POB_Amount":pobAmount,"Campaign_Code":campaignCode,"Business_Status_ID":businessStatusId,"Call_Objective_ID":callObjectiveId,"Source_Of_Entry":"iOS","Remarks":remarks,"Company_Code":getCompanyCode()]
        
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    private func getDCRAttendanceSample(dcrId: Int) -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let lstSampleList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(dcrId: dcrId)
       
        for sampleObj in lstSampleList
        {
            
            let getDate = convertDateIntoServerStringFormat1(date: sampleObj.DCR_Actual_Date!) as? String
             let sampleBatchList = getDCRSampleBatchProducts(dcrId: dcrId, visitId: sampleObj.DCR_Doctor_Visit_Id, productCode: sampleObj.Product_Code, entityType: sampleBatchEntity.Attendance.rawValue)
            var dict: NSMutableDictionary = ["DCR_Code":checkNullAndNilValueForString(stringData:sampleObj.DCR_Code),"DCR_Visit_Code":checkNullAndNilValueForString(stringData:sampleObj.DCR_Code),"DCR_Actual_Date":getDate,"Product_Code":checkNullAndNilValueForString(stringData:sampleObj.Product_Code),"Quantity_Provided":sampleObj.Quantity_Provided!,"Remark":"","Visit_Id":sampleObj.DCR_Doctor_Visit_Id,"lstuserproductbatch":sampleBatchList]
            
            dict = replaceEmptyStringToNullValues(combinedAttributes: dict)
            
            resultList.add(dict)
        }
        
        return resultList
    }
    
    
    //MARK:-- Other Functions
    private func compareSyncedDataCount(dict: NSDictionary) -> Bool
    {
        let serverObj = convertToApiResponseModel(dict: dict)
        let localObj: UploadDCRResponseModel = UploadDCRResponseModel()
        let uploadDict = self.lasUploadData[0] as! NSDictionary
        
        localObj.Total_Accomp_Count = (uploadDict.value(forKey: "lstDCRAccompanistModel") as! NSArray).count
        localObj.Total_Travelled_Places = (uploadDict.value(forKey: "lstTravelledPlaces") as! NSArray).count
        localObj.Total_Doctor_Count = (uploadDict.value(forKey: "lstDCRVisitStaging") as! NSArray).count
        localObj.Total_Sample_Details = (uploadDict.value(forKey: "lstSampleProductsStaging") as! NSArray).count
        localObj.Total_Detailed_Produts = (uploadDict.value(forKey: "lstDetailedStaging") as! NSArray).count
        localObj.Total_Chemist_Count = (uploadDict.value(forKey: "lstChemistStaging") as! NSArray).count
        localObj.Total_RCPA_Count = (uploadDict.value(forKey: "lstRCPAStaging") as! NSArray).count
        localObj.Total_Stockiest_Count = (uploadDict.value(forKey: "lstStockiestStaging") as! NSArray).count
        localObj.Total_Expense_Count = (uploadDict.value(forKey: "lstExpenseStaging") as! NSArray).count
        localObj.Total_Doctor_Accomp_Count = (uploadDict.value(forKey: "lstAccompStaging") as! NSArray).count
        
        if (localObj.Total_Accomp_Count == serverObj.Total_Accomp_Count && localObj.Total_Travelled_Places == serverObj.Total_Travelled_Places && localObj.Total_Doctor_Count == serverObj.Total_Doctor_Count && localObj.Total_Sample_Details == serverObj.Total_Sample_Details && localObj.Total_Detailed_Produts == serverObj.Total_Detailed_Produts && localObj.Total_Chemist_Count == serverObj.Total_Chemist_Count && localObj.Total_RCPA_Count == serverObj.Total_RCPA_Count && localObj.Total_Stockiest_Count == serverObj.Total_Stockiest_Count && localObj.Total_Doctor_Accomp_Count == serverObj.Total_Doctor_Accomp_Count)
        {
            return true
        }
        else
        {
            let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
            extProp.setValue(dict, forKey: "Server_Obj")
            extProp.setValue(uploadDict, forKey: "Local_Obj")
            
            BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
            
            return false
        }
    }
    
    private func convertToApiResponseModel(dict: NSDictionary) -> UploadDCRResponseModel
    {
        let objApiResponse: UploadDCRResponseModel = UploadDCRResponseModel()
        
        objApiResponse.Total_Accomp_Count = dict.value(forKey: "Total_Accomp_Count") as! Int
        objApiResponse.Total_Travelled_Places = dict.value(forKey: "Total_Travelled_Places") as! Int
        objApiResponse.Total_Doctor_Count = dict.value(forKey: "Total_Doctor_Count") as! Int
        objApiResponse.Total_Sample_Details = dict.value(forKey: "Total_Sample_Details") as! Int
        objApiResponse.Total_Detailed_Produts = dict.value(forKey: "Total_Detailed_Produts") as! Int
        objApiResponse.Total_Chemist_Count = dict.value(forKey: "Total_Chemist_Count") as! Int
        objApiResponse.Total_RCPA_Count = dict.value(forKey: "Total_RCPA_Count") as! Int
        objApiResponse.Total_Stockiest_Count = dict.value(forKey: "Total_Stockiest_Count") as! Int
        objApiResponse.Total_Expense_Count = dict.value(forKey: "Total_Expense_Count") as! Int
        objApiResponse.Total_Doctor_Accomp_Count = dict.value(forKey: "Total_Doctor_Accomp_Count") as! Int
        
        return objApiResponse
    }
    
    private func replaceEmptyStringToNullValues(combinedAttributes: NSMutableDictionary) -> NSMutableDictionary
    {
        for (key, value) in combinedAttributes
        {
            if (value is String)
            {
                if (value as! String == EMPTY)
                {
                    combinedAttributes.setValue(NSNull(), forKey: key as! String)
                }
            }
        }
        
        return combinedAttributes
    }
    
    func insertEdetailingDoctorDelete(arrayValue:NSArray, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.insertEdetailingDoctorDelete(dataArray:arrayValue)
        { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
}
