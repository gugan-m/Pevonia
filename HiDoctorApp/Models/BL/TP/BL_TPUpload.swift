//
//  BL_TPUpload.swift
//  HiDoctorApp
//
//  Created by Vijay on 14/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class BL_TPUpload: NSObject
{
    static let sharedInstance = BL_TPUpload()
    
    func getMonthWisePendingTPCount() -> [TPUploadModel]
    {
        var pendingTPList: [TPUploadModel] = []
        let monthList: [Row] = DAL_TPUpload.sharedInstance.getPendingUploadMonthWiseCount()
        
        for row in monthList
        {
            let count: Int = row["Count"]
            let monthYear: String = row["Month-Year"]
            let array = monthYear.components(separatedBy: "-")
            let objTPUpload: TPUploadModel = TPUploadModel()
            
            objTPUpload.Month = Int(array[0])
            objTPUpload.Year = Int(array[1])
            objTPUpload.Count = count
            
            pendingTPList.append(objTPUpload)
        }
        
        return pendingTPList
    }
    
    func getPendingTPForSelectedMonth(month: Int, year: Int) -> [TourPlannerHeader]
    {
        return DAL_TPUpload.sharedInstance.getPendingUploadTPsList(month: month, year: year)
    }
    
    func uploadTP(objTPHeader: TourPlannerHeader, completion: @escaping (ApiResponseModel) -> ())
    {
        let postData: NSArray = getUploadData(tpEntryId: objTPHeader.TP_Entry_Id, objTPHeader: objTPHeader)
        
        WebServiceHelper.sharedInstance.uploadTP(tpDate: getServerFormattedDateString(date: objTPHeader.TP_Date), dataArray: postData) { (objApiResponse) in
            self.uploadTPCallBack(tpEntryId: objTPHeader.TP_Entry_Id, objApiResponse: objApiResponse)
            completion(objApiResponse)
        }
    }
    
    func uploadBulkTP(TPHeaderList: [TourPlannerHeader], completion: @escaping (ApiResponseModel) -> ())
    {
        let getDate = TPHeaderList.last
        let getMonth = getMonthNumberFromDate(date: (getDate?.TP_Date)!)
        let getYear = getYearFromDate(date: (getDate?.TP_Date)!)
        
        let dates = BL_TPRefresh.sharedInstance.getStartAndEndDateForMonth(month: getMonth, year: getYear)
        let endDate = dates.1
        
        let postData: NSArray = getUploadBulkData(tpHeaderList:TPHeaderList)
        
        WebServiceHelper.sharedInstance.uploadTP(tpDate: endDate , dataArray: postData) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func checkTPLock(month: Int, year: Int, completion: @escaping (ApiResponseModel) -> ())
    {
        let postData: NSDictionary = ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "TPMonth": month, "TPYear": year]
        
        WebServiceHelper.sharedInstance.checkTPLock(dataArray: postData) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    private func uploadTPCallBack(tpEntryId: Int, objApiResponse: ApiResponseModel)
    {
        let status = objApiResponse.Status
        var tpId: Int = 0
        var tpStatus: Int!
        let uploadMessage: String = objApiResponse.Message
        
        if (status == 0) //0 = Error
        {
            tpId = 0
            tpStatus = TPStatus.applied.rawValue
        }
        else if (status == 2)// 2 = Business error due to some reason
        {
            tpId = 0
            tpStatus = TPStatus.drafted.rawValue
        }
        else if (status == 1 || status == 3) // 1 = Success, 3 = Skipped
        {
            tpStatus = TPStatus.applied.rawValue
            
            if (objApiResponse.list.count > 0)
            {
                let dict = objApiResponse.list.firstObject as! NSDictionary
                
                if let id = dict.value(forKey: "TP_Id") as? Int
                {
                    tpId = id
                }
            }
        }
        
        updateTPId(tpEntryId: tpEntryId, tpId: tpId, tpStatus: tpStatus, uploadMessage: uploadMessage)
    }
    
    private func updateTPId(tpEntryId: Int, tpId: Int, tpStatus: Int, uploadMessage: String)
    {
        DAL_TPUpload.sharedInstance.updateTPId(tpEntryId: tpEntryId, tpId: tpId, tpStatus: tpStatus, uploadMessage: uploadMessage)
    }
    
    private func getUploadData(tpEntryId: Int, objTPHeader: TourPlannerHeader) -> NSArray
    {
        let dict: NSDictionary = ["lstTPHeaderStaging": getHeaderList(tpEntryId: tpEntryId, objTPHeader: objTPHeader), "lstTPAccompanist": getAccompanistList(tpEntryId: tpEntryId), "lstTpSFCStaging": getSFCList(tpEntryId: tpEntryId) , "lstTPDoctorsStaging": getDoctorList(tpEntryId: tpEntryId), "lstTPProductsStaging": getProductList(tpEntryId: tpEntryId),"lstTPDoctorAttachmentStaging":getAttchmentList(tpEntryId: tpEntryId)]
        
        let dataArray: NSArray = [dict]
        
        return dataArray
    }
    
    private func getUploadBulkData(tpHeaderList: [TourPlannerHeader]) -> NSArray
    {
        let dataArray : NSMutableArray = []
        for tpHeaderObj in tpHeaderList
        {
            let dict: NSDictionary = ["lstTPHeaderStaging": getHeaderList(tpEntryId: tpHeaderObj.TP_Entry_Id, objTPHeader: tpHeaderObj), "lstTPAccompanist": getAccompanistList(tpEntryId: tpHeaderObj.TP_Entry_Id ), "lstTpSFCStaging": getSFCList(tpEntryId: tpHeaderObj.TP_Entry_Id) , "lstTPDoctorsStaging": getDoctorList(tpEntryId: tpHeaderObj.TP_Entry_Id), "lstTPProductsStaging": getProductList(tpEntryId: tpHeaderObj.TP_Entry_Id),"lstTPDoctorAttachmentStaging":getAttchmentList(tpEntryId: tpHeaderObj.TP_Entry_Id)]
            
            dataArray.add(dict)
            
        }
        let bulkArray = NSArray(array: dataArray)
        return bulkArray
    }
    
    private func getHeaderList(tpEntryId: Int, objTPHeader: TourPlannerHeader) -> NSMutableArray
    {
        let tpHeaderList = [objTPHeader]
        let resultList: NSMutableArray = []
        
        for objTPHeader in tpHeaderList
        {
            var cpCode: String = EMPTY
            var workArea: String = EMPTY
            var categoryName: String = EMPTY
            var meetingPlace: String = EMPTY
            var meetingTime: String = EMPTY
            var remarks: String = EMPTY
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.CP_Code) != EMPTY)
            {
                cpCode = objTPHeader.CP_Code!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.Work_Place) != EMPTY)
            {
                workArea = objTPHeader.Work_Place!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.Category_Name) != EMPTY)
            {
                categoryName = objTPHeader.Category_Name!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.Meeting_Place) != EMPTY)
            {
                meetingPlace = objTPHeader.Meeting_Place!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.Meeting_Time) != EMPTY)
            {
                meetingTime = objTPHeader.Meeting_Time!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader.Remarks) != EMPTY)
            {
                remarks = objTPHeader.Remarks!
            }
            
            let tpDate: String = getServerFormattedDateString(date: objTPHeader.TP_Date!)
            
            let dict1: NSDictionary = ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "CP_Code": cpCode, "TP_Date": tpDate, "TP_Status": String(objTPHeader.Status!)]
            let dict2: NSDictionary = ["Work_Area": workArea, "Project_Code": objTPHeader.Project_Code!, "Activity": objTPHeader.Activity!, "Activity_Code": objTPHeader.Activity_Code!, "Category_Name": categoryName]
            let dict3: NSDictionary = ["Region_Code": getRegionCode(), "Meeting_Place": meetingPlace, "Meeting_Time": meetingTime, "Remarks": remarks, "TP_Id": objTPHeader.TP_Id!]
            let dict4: NSDictionary = ["TP_Entry_Id": objTPHeader.TP_Entry_Id!, "Check_Sum_Id": NSNull(), "Source_Of_Entry": 3, "Entered_by": getUserName(),"TP_Type": TPModel.sharedInstance.tp_Type]
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
    
    private func getAccompanistList(tpEntryId: Int) -> NSMutableArray
    {
        let tpAccompanistList = DAL_TP_Stepper.sharedInstance.getSelectedAccompanistsDetails(tp_Entry_Id: tpEntryId)
        let resultList: NSMutableArray = []
        
        for objTPAcc in tpAccompanistList
        {
            var accUserName: String = EMPTY
            var accUserCode: String = EMPTY
            var accRegionCode: String = EMPTY
            var accUserTypeName: String = EMPTY
            var accUserTypeCode: String = EMPTY
            var isOnlyForDoctor: String = EMPTY
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Acc_User_Name) != EMPTY)
            {
                accUserName = objTPAcc.Acc_User_Name
            }
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Acc_User_Code) != EMPTY)
            {
                accUserCode = objTPAcc.Acc_User_Code
            }
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Acc_Region_Code) != EMPTY)
            {
                accRegionCode = objTPAcc.Acc_Region_Code
            }
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Acc_User_Type_Name) != EMPTY)
            {
                accUserTypeName = objTPAcc.Acc_User_Type_Name
            }
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Acc_User_Type_Code) != EMPTY)
            {
                accUserTypeCode = objTPAcc.Acc_User_Type_Code
            }
            
            if (checkNullAndNilValueForString(stringData: objTPAcc.Is_Only_For_Doctor) != EMPTY)
            {
                isOnlyForDoctor = objTPAcc.Is_Only_For_Doctor
            }
            
            let dict1: NSDictionary = ["TP_Id": objTPAcc.TP_Id, "TP_Entry_Id": tpEntryId, "User_Code": getUserCode(), "Acc_User_Name": accUserName, "Acc_User_Code": accUserCode]
            let dict2: NSDictionary = ["Acc_Region_Code": accRegionCode, "Acc_User_Type_Name": accUserTypeName, "Acc_UserTypeCode": accUserTypeCode, "Is_Only_For_Doctor": isOnlyForDoctor, "Mode_Of_Entry": NSNull()]
            let dict3: NSDictionary = ["Acc_Start_Time": NSNull(), "Acc_End_Time": NSNull(), "DCR_Code": NSNull()]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getSFCList(tpEntryId: Int) -> NSMutableArray
    {
        let tpSFCList = DAL_TP_Stepper.sharedInstance.getTPSelectedSFCDetails(tp_Entry_Id: tpEntryId)
        let resultList: NSMutableArray = []
        
        if (tpSFCList != nil)
        {
            for objTPSFC in tpSFCList!
            {
                var distanceFareCode: String = EMPTY
                var sfcVerison: Int = 0
                var sfcRegionCode: String = EMPTY
                var distance: Float = 0.0
                var categoryName: String = EMPTY
                
                if (checkNullAndNilValueForString(stringData: objTPSFC.Distance_fare_Code) != EMPTY)
                {
                    distanceFareCode = objTPSFC.Distance_fare_Code!
                }
                
                if (checkNullAndNilValueForString(stringData: objTPSFC.Region_Code) != EMPTY)
                {
                    sfcRegionCode = objTPSFC.Region_Code!
                }
                
                if let dist = objTPSFC.Distance
                {
                    distance = dist
                }
                
                if let versionNo = objTPSFC.SFC_Version
                {
                    sfcVerison = versionNo
                }
                
                if (checkNullAndNilValueForString(stringData: objTPSFC.SFC_Category_Name) != EMPTY)
                {
                    categoryName = objTPSFC.SFC_Category_Name!
                }
                
                let dict1: NSDictionary = ["TP_Id": objTPSFC.TP_Id, "Distance_Fare_Code": distanceFareCode, "From_Place": objTPSFC.From_Place]
                let dict2: NSDictionary = ["To_Place": objTPSFC.To_Place, "SFC_Version": sfcVerison, "Travel_Mode": objTPSFC.Travel_Mode, "SFC_Category_Name": categoryName, "Distance": distance]
                let dict3: NSDictionary = ["Fare_Amount": NSNull(), "SFC_Visit_Count": NSNull(), "SFC_Region_Code": sfcRegionCode]
                var combinedAttributes : NSMutableDictionary!
                
                combinedAttributes = NSMutableDictionary(dictionary: dict1)
                combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
                combinedAttributes.addEntries(from: dict3 as! [AnyHashable : Any])
                combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
                
                resultList.add(combinedAttributes)
            }
        }
        
        return resultList
    }
    
    private func getDoctorList(tpEntryId: Int) -> NSMutableArray
    {
        let tpDoctorList = DAL_TP_Stepper.sharedInstance.getSelectedDoctor(tp_Entry_Id: tpEntryId)
        let resultList: NSMutableArray = []
        
        for objTPDoctor in tpDoctorList
        {
            var doctorCode: String = EMPTY
            var regionCode: String = EMPTY
            var categoryCode: String = EMPTY
            var Call_Objective_Name: String = EMPTY
            var Call_Objective_Id: Int = 0
            
            
            if (checkNullAndNilValueForString(stringData: objTPDoctor.Doctor_Code) != EMPTY)
            {
                doctorCode = objTPDoctor.Doctor_Code!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPDoctor.Doctor_Region_Code) != EMPTY)
            {
                regionCode = objTPDoctor.Doctor_Region_Code!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPDoctor.Category_Code) != EMPTY)
            {
                categoryCode = objTPDoctor.Category_Code!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPDoctor.Call_Objective_Name) != EMPTY)
                       {
                           Call_Objective_Name = objTPDoctor.Category_Code!
                       }
                       
                       if objTPDoctor.Call_Objective_Id != nil
                       {
                           Call_Objective_Id = objTPDoctor.Call_Objective_Id!
                       }
            
            let dict: NSDictionary = ["TP_Id": objTPDoctor.TP_Id, "Doctor_Code": doctorCode, "Doctor_Region_Code": regionCode, "Category_Code": categoryCode,"Call_Objective_Id": Call_Objective_Id,"Call_Objective_Name": Call_Objective_Name]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict)
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getProductList(tpEntryId: Int) -> NSMutableArray
    {
        let tpProductList = DAL_TP_Stepper.sharedInstance.getSelectedSamples(tp_Entry_Id: tpEntryId)
        let resultList: NSMutableArray = []
        
        for objTPProduct in tpProductList
        {
            var doctorCode: String = EMPTY
            var regionCode: String = EMPTY
            
            if (checkNullAndNilValueForString(stringData: objTPProduct.Doctor_Code) != EMPTY)
            {
                doctorCode = objTPProduct.Doctor_Code!
            }
            
            if (checkNullAndNilValueForString(stringData: objTPProduct.Doctor_Region_Code) != EMPTY)
            {
                regionCode = objTPProduct.Doctor_Region_Code!
            }
            
            let dict1: NSDictionary = ["TP_Id": objTPProduct.TP_Id, "TP_Doctor_Id": NSNull(), "Product_Code": objTPProduct.Product_Code!, "Quantity": objTPProduct.Quantity_Provided!]
            let dict2: NSDictionary = ["Doctor_Code": doctorCode, "Doctor_Region_Code": regionCode]
            var combinedAttributes : NSMutableDictionary!
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
    }
    
    private func getAttchmentList(tpEntryId: Int) -> NSMutableArray
    {
        let tpAttachmentList = DAL_TP_Stepper.sharedInstance.getTPAttachmentList(tpId: tpEntryId)
        let resultList: NSMutableArray = []
        
        for objAttachment in tpAttachmentList!
        {
            var doctorCode: String = EMPTY
            var regionCode: String = EMPTY
            
            if (checkNullAndNilValueForString(stringData: objAttachment.tpDoctorCode) != EMPTY)
            {
                doctorCode = objAttachment.tpDoctorCode!
            }
            
            if (checkNullAndNilValueForString(stringData: objAttachment.tpDoctorRegionCode) != EMPTY)
            {
                regionCode = objAttachment.tpDoctorRegionCode!
            }
            
            let dict1: NSDictionary = [
                   "TP_Id": objAttachment.tpId,
                   "Check_Sum_Id": objAttachment.tpChecksumId ?? 0,
                   "TP_Doctor_Id": 0,
                   "Uploaded_File_Name": objAttachment.attachmentName ?? "",
                   "Blob_URL": NSNull()]
            let dict2: NSDictionary = ["Doctor_Code": doctorCode, "Doctor_Region_Code": regionCode]
            var combinedAttributes : NSMutableDictionary!
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            combinedAttributes = replaceEmptyStringToNullValues(combinedAttributes: combinedAttributes)
            
            resultList.add(combinedAttributes)
        }
        
        return resultList
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
    func isSFCMinCountValidInTP()->Bool{
        if(PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SFC_MINCOUNTVALID_IN_TP) == PrivilegeValues.YES.rawValue){
            return true
        }
        else
        {
            return false
        }
    }
}
class TPSFCList: NSObject
{
    var From_Place: String!
    var To_Place: String!
    var Category_Place: String!
    var Entered_Count: Int!
    var Max_Limit: Int!

}
