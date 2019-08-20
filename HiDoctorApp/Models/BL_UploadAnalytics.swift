//
//  BL_UploadAnalytics.swift
//  HiDoctorApp
//
//  Created by Vijay on 01/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_UploadAnalytics: NSObject
{
    static let sharedInstance = BL_UploadAnalytics()
    
    var queue = OperationQueue()
    var assetAnalyticsList : [AssetAnalyticsDetail] = []
    var statusList : [FileStatus] = []
    var dcrRefreshInProgress : Bool = false
    
    func uploadAssetAnalytics()
    {
        if dcrRefreshInProgress == true
        {
            dcrRefreshInProgress = false
        }
        
        if assetAnalyticsList.count > 0
        {
            assetAnalyticsList = []
        }
        assetAnalyticsList = DBHelper.sharedInstance.getAssetAnalytics()
        
        initiateOperation()
    }
    
    func clearAllArray()
    {
        queue = OperationQueue()
        assetAnalyticsList.removeAll()
        statusList.removeAll()
        dcrRefreshInProgress = false
    }
    
    func checkAnalyticsStatus()
    {
        if dcrRefreshInProgress == true
        {
            dcrRefreshInProgress = false
        }
        
        if statusList.count == 0
        {
            uploadAssetAnalytics()
        }
        else
        {
            if assetAnalyticsList.count > 0
            {
                assetAnalyticsList = []
            }
            assetAnalyticsList = DBHelper.sharedInstance.getAssetAnalytics()
        }
    }
    
    private func initiateOperation()
    {
        var filteredAnalyticsList : [AssetAnalyticsDetail] = []
        for i in 0..<assetAnalyticsList.count
        {
            if i < uploadAnalyticsMaxConcOperationCount
            {
                filteredAnalyticsList.append(assetAnalyticsList[i])
            }
        }
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredAnalyticsList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.Asset_Id
            statusModel.status = false
            statusList.append(statusModel)
            
            print("Analytics upload starts")
            uploadAnalyticsServiceCall(model: model)
        }
        
        let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
        
        if (pendingList.count == 0)
        {
            print ("All Asset Analytics Completed")
            BL_UploadFeedback.sharedInstance.checkFeedbackAnalyticsStatus()
        }
    }
    
    private func uploadAnalyticsServiceCall(model: AssetAnalyticsDetail)
    {
        if (checkInternetConnectivity())
        {
            let urlString = wsRootUrl + wsAsset + wsUpload + wsCustomerwiseAnalyticsDetails
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = wsPOST
            request.timeoutInterval = wsTimeOutInterval
            
            let currentDateTime = getCurrentDateAndTime()
            var latitude: Float = 0.0
            var longitude: Float = 0.0
            if model.Latitude != nil && model.Latitude != ""
            {
                if let getLatitude = Float(model.Latitude)
                {
                    latitude = getLatitude
                }
            }
            if model.Longitude != nil && model.Longitude != ""
            {
                if let getLongitude = Float(model.Longitude)
                {
                    longitude = getLongitude
                }
            }
            
            let dict1: [String : Any] = ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "Customer_Detailed_Id": model.Customer_Detailed_Id, "DA_Code": model.DA_Code, "Detailed_DateTime": "\(model.Detailed_DateTime!)", "Part_Id": model.Part_Id]
            let dict2: [String : Any] = ["Part_URL": "\(model.Part_URL!)", "SessionId": model.Session_Id, "Detailed_StartTime": "\(model.Detailed_StartTime!)", "Detailed_EndTime": "\(model.Detailed_EndTime!)", "Player_Start_Time": "\(model.Player_StartTime!)"]
            let dict3: [String : Any] = ["Player_End_Time": "\(model.Player_EndTime!)", "Played_Time_Duration": model.Played_Time_Duration, "Time_Zone": "\(model.Time_Zone!)", "isPreview": model.Is_Preview, "isSynced": model.Is_Synced]
            let dict4: [String : Any] = ["HDUser_Id": getHDUserId(), "Customer_Code": "\(model.Customer_Code!)", "Customer_Region_Code": "\(model.Customer_Region_Code!)", "Customer_Speciality_Name": "\(model.Customer_Speciality_Name!)", "Customer_Category_Name": "\(model.Customer_Category_Name!)"]
            let dict5: [String : Any] = ["Customer_Category_Code": "\(model.Customer_Category_Code!)", "Customer_Speciality_Code": "\(model.Customer_Speciality_Code!)", "Customer_Name": "\(model.Customer_Name!)", "Sur_Name": "\(model.Sur_Name!)", "Local_Area": "\(model.Local_Area!)", "Customer_MDL_Number": model.MDL_Number ?? ""]
            let dict6: [String : Any] = ["PlayMode": "\(model.PlayMode!)", "Likes": 0, "Rating": 0, "Latitude": latitude, "Longitude": longitude, "Source_Of_Entry": Source_Of_Entry]
            let dict7: [String: Any] = ["UD_StoryID": 0, "MC_StoryID": model.MC_Story_Id, "DA_Type": model.Doc_Type]
            let dataDictionary: [String : Any] = dict1.merged(with: dict2).merged(with: dict3).merged(with: dict4).merged(with: dict5).merged(with: dict6).merged(with: dict7)
            print(dataDictionary)

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: dataDictionary, options: .prettyPrinted)
            }
            catch
            {
                updateFailureStatus(model: model)
            }
            
            var task = URLSessionDataTask()
            
            let blockOperation = BlockOperation(block:
            {
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    OperationQueue.main.addOperation({
                        
                        if self.dcrRefreshInProgress == true
                        {
                            if self.statusList.count > 0
                            {
                                self.statusList = []
                            }
                        }
                        else
                        {
                            if error != nil
                            {
                                let getError = error as NSError?
                                print("Service error \(String(describing: getError?.code))")
                                if getError?.code == -1009
                                {
                                    self.showInternetErrorToast()
                                }
                                else
                                {
                                    self.updateFailureStatus(model: model)
                                }
                            }
                            else
                            {
                                if data != nil
                                {
                                    if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                    {
                                        if let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                                        {
                                            if let jsonDict = json as? NSDictionary
                                            {
                                                if let status = jsonDict.value(forKey: "Status") as? Int
                                                {
                                                    if status == 1
                                                    {
                                                        self.updateSuccessStatus(model: model, currentDateTime: currentDateTime)
                                                    }
                                                    else
                                                    {
                                                        self.updateFailureStatus(model: model)
                                                    }
                                                }
                                                else
                                                {
                                                    self.updateFailureStatus(model: model)
                                                }
                                            }
                                            else
                                            {
                                                self.updateFailureStatus(model: model)
                                            }
                                        }
                                        else
                                        {
                                            self.updateFailureStatus(model: model)
                                        }
                                    }
                                    else
                                    {
                                        self.updateFailureStatus(model: model)
                                    }
                                }
                                else
                                {
                                    self.updateFailureStatus(model: model)
                                }
                            }
                        }
                    })
                }
                
                task.resume()
            })
            
            queue.addOperation(blockOperation)
        }
        else
        {
            showInternetErrorToast()
        }
    }
    
    func showInternetErrorToast()
    {
        if self.statusList.count > 0
        {
            self.statusList = []
        }
        showToastView(toastText: assetAnalyticsInternetDropOffMsg)
    }
    
    func updateFailureStatus(model: AssetAnalyticsDetail)
    {
        updateAssetAnalyticsArray(model: model)
        
        updateStatusInitiateOperation(fileId: model.Asset_Id)
    }
    
    func updateSuccessStatus(model: AssetAnalyticsDetail, currentDateTime: Date)
    {
        let convertedDate = getStringInFormatDate(dateString: model.Detailed_DateTime)
        let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
        if dcrDetail.count > 0
        {
            let dcrId = dcrDetail[0].DCR_Id
            let checkCustomer = DBHelper.sharedInstance.checkCustomerForDCRIdCustomerCode(dcrId: dcrId!, customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code)
            if checkCustomer == 0
            {
                if dcrDetail[0].DCR_Status == "\(DCRStatus.applied.rawValue)" || dcrDetail[0].DCR_Status == "\(DCRStatus.approved.rawValue)"
                {
                    DBHelper.sharedInstance.deleteAnalyticsByAssetId(assetId: model.Asset_Id)
                }
                else
                {
                    DBHelper.sharedInstance.updateAssetAnalytics(assetId: model.Asset_Id, isSynched: 1, synchedDatetime: currentDateTime)
                }
            }
            else
            {
                DBHelper.sharedInstance.updateAssetAnalytics(assetId: model.Asset_Id, isSynched: 1, synchedDatetime: currentDateTime)
            }
        }
        else
        {
            DBHelper.sharedInstance.updateAssetAnalytics(assetId: model.Asset_Id, isSynched: 1, synchedDatetime: currentDateTime)
        }
        updateAssetAnalyticsArray(model: model)
        
        updateStatusInitiateOperation(fileId: model.Asset_Id)
    }
    
    func updateAssetAnalyticsArray(model: AssetAnalyticsDetail)
    {
        if let index = assetAnalyticsList.index(where: {$0.Asset_Id == model.Asset_Id})
        {
            assetAnalyticsList.remove(at: index)
        }
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            print("Cycle completed")
            self.initiateOperation()
        }
    }
    
    func updateFileStatus(fileId: Int)
    {
        if let index = statusList.index(where: {$0.fileId == fileId})
        {
            statusList[index].status = true
        }
    }
    
    func checkFileStatusCompleted() -> Bool
    {
        var flag = true
        
        let filteredStatusList = statusList.filter( { (statusModel: FileStatus) -> Bool in
            return statusModel.status == false
        })
        if filteredStatusList.count > 0
        {
            flag = false
        }
        
        return flag
    }
}
