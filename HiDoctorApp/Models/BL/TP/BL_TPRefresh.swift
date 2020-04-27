//
//  BL_TPRefresh.swift
//  HiDoctorApp
//
//  Created by Vijay on 14/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TPRefresh: NSObject
{
    static let sharedInstance = BL_TPRefresh()
    
    func refreshTourPlanner(month: Int, year: Int, completion: @escaping (Int) -> ())
    {
        
        
        let dictionary = BL_TPCalendar.sharedInstance.getTPMonth()
           let startDate1 = dictionary.value(forKey: "startDate") as! Date
           let endDate1 = dictionary.value(forKey: "endDate") as! Date
         
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = defaultServerDateFormat
        let startDate = dateFormatter.string(from: startDate1)
        let d2 = dateFormatter.string(from: endDate1)
        let arr = d2.split(separator: "-")
        let mon = Int(arr[1])
        let yer = Int(arr[0])
        let dates = getStartAndEndDateForMonth(month: mon! , year: yer!)
        let endDate = dates.1
        self.downloadTpData(startDate: startDate, endDate: endDate) { (status) in
            completion(status)
        }
    }
    
    func downloadTpData(startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        getTourPlannerHeader(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                self.getTourPlannerAccompanist(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        self.getTourPlannerSFC(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                self.getTourPlannerDoctor(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate, completion: { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        self.getTourPlannerProduct(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate, completion: { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                self.getTourPlannerUnfreezeDates(masterDataGroupName: EMPTY, startDate: startDate, endDate: endDate, completion: { (status) in
                                                   
                                                    if (status == SERVER_SUCCESS_CODE)
                                                    {
//                                                        self.GetTPDoctorAttachments(masterDataGroupName: EMPTY,completion: {
//                                                            (status) in
//                                                            if (status == SERVER_SUCCESS_CODE)
//                                                            {
                                                                self.updateIDsInRelatedTables()
//                                                            }
                                                            completion(status)
//                                                        })
                                                    } else {
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
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
     func getStartAndEndDateForMonth(month: Int, year: Int) -> (String, String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultServerDateFormat
        
        let date = dateFormatter.date(from: String(year) + "-" + String(month) + "-01")
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date!)
        let startOfMonth = Calendar.current.date(from: comp)!
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
        
        return (dateFormatter.string(from: startOfMonth),dateFormatter.string(from: endOfMonth!))
    }
    
    private func getTourPlannerHeader(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerHeader.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerHeader (postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)){ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                let status = self.getTourPlannerHeaderCallBack(apiResponseObj: apiResponseObj, apiName: apiName, masterDataGroupName: masterDataGroupName, startDate: startDate, endDate: endDate)
                completion(status)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    /*
 BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: EMPTY, completion: { (status) in
 if (status == SERVER_SUCCESS_CODE)
 {
 
     WebServiceHelper.sharedInstance.getTourPlannerAccompanist (postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
 else
 {
 completion(status)
 }
 })*/
    private func getTourPlannerAccompanist(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerAccompanist.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: EMPTY, completion: { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                
                WebServiceHelper.sharedInstance.getTourPlannerAccompanist (postData: self.getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
            else
            {
                completion(status)
            }
        
        
    })
    }
    
    private func getTourPlannerSFC(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerSFC.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerSFC (postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
    
    private func getTourPlannerDoctor(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerDoctor.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
    
    private func getTourPlannerProduct(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerProduct.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerProduct(postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
    
    private func getTourPlannerUnfreezeDates(masterDataGroupName:String, startDate: String, endDate: String, completion: @escaping (Int) -> ())
    {
        let apiName: String = ApiName.TourPlannerUnfreezeDate.rawValue
        
        BL_PrepareMyDevice.sharedInstance.insertApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        WebServiceHelper.sharedInstance.getTourPlannerUnfreezeDates(postData: getTourPlannerPostData(startDate: startDate, endDate: endDate)) { (apiResponseObj) in
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
    
    private func GetTPDoctorAttachments(masterDataGroupName:String,completion: @escaping (Int) -> ())
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
    
    private func getTourPlannerPostData(startDate: String, endDate: String) -> [String: Any]
    {
        if (startDate != EMPTY && endDate != EMPTY)
        {
            return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": startDate, "EndDate": endDate, "TPStatus": "ALL", "Flag": "ALL"]
        }
        else
        {
            return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "StartDate": NSNull(), "EndDate": NSNull(), "TPStatus": "ALL", "Flag": "ALL"]
        }
    }
    
    private func getTourPlannerHeaderCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String, startDate: String, endDate: String) -> Int
    {
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_PRODUCT)
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_DOCTOR)
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_SFC)
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_ACCOMPANIST)
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_HEADER)
         DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_UNFREEZE_DATES)
      // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_TP_DOCTOR_VISIT_ATTACHMENT)
        
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            var insertList: NSMutableArray = []
            
            for obj in apiResponseObj.list
            {
                let dict = obj as! NSDictionary
                let tpDate = dict.value(forKey: "TP_Date") as! String
                
                let tpHeaderObj: TourPlannerHeader?
                
                tpHeaderObj = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: tpDate)
                
                if (tpHeaderObj != nil)
                {
                    if (tpHeaderObj!.TP_Id > 0)
                    {
                        DBHelper.sharedInstance.deleteTourPlannerData(startDate: tpDate, endDate: tpDate)
                        insertList.add(dict)
                    }
                    else if(tpHeaderObj!.Is_Weekend == 1 || tpHeaderObj!.Is_Holiday == 1)
                    {
                        DBHelper.sharedInstance.deleteTourPlannerData(startDate: tpDate, endDate: tpDate)
                        insertList.add(dict)
                    }
                }
                else
                {
                    insertList.add(dict)
                }
            }
            
            DBHelper.sharedInstance.insertTourPlannerHeader(array: insertList)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerAccompanistCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerAccompanist(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerSFCCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerSFC(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerDoctorCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerDoctor(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerProductCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerProduct(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTourPlannerUnfreezeDatesCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            DBHelper.sharedInstance.insertTourPlannerUnfreezeDates(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    private func getTpDoctorAttachmentCallBack(apiResponseObj: ApiResponseModel, apiName: String, masterDataGroupName:String) -> Int
    {
        if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
        {
            
            for data in apiResponseObj.list {
                let dict = data as! NSDictionary
                if let tpid = dict["TP_Id"] as? Int {
                    DBHelper.sharedInstance.deleteTpAttachmentByTpID(tp_ID: tpid)
                }
            }
            
            
            DBHelper.sharedInstance.insertTPAttachment(array: apiResponseObj.list)
        }
        
        BL_PrepareMyDevice.sharedInstance.updateApiDownloadDetails(apiName: apiName, masterDataGroupName: masterDataGroupName)
        
        return 1
    }
    
    
    private func updateIDsInRelatedTables()
    {
        BL_PrepareMyDevice.sharedInstance.updateCPIdInTPHeader()
        BL_PrepareMyDevice.sharedInstance.updateTourPlannerRefIdInTables()
    }
}
