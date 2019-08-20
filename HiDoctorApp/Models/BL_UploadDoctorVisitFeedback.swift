//
//  BL_UploadDoctorVisitFeedback.swift
//  HiDoctorApp
//
//  Created by Admin on 8/31/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_UploadDoctorVisitFeedback: NSObject {
    static let sharedInstance = BL_UploadDoctorVisitFeedback()
    
    var queue = OperationQueue()
    var feedbackList : [DoctorVisitFeedback] = []
    var statusList : [FileStatus] = []
    var dcrRefreshInProgress : Bool = false
    
    func uploadDoctorVisitFeedback()
    {
        if dcrRefreshInProgress == true
        {
            dcrRefreshInProgress = false
        }
        
        if feedbackList.count > 0
        {
            feedbackList = []
        }
        feedbackList = DBHelper.sharedInstance.getDoctorVisitFeedback()
        
        initiateOperation()
    }
    
    func clearAllArray()
    {
        queue = OperationQueue()
        feedbackList.removeAll()
        statusList.removeAll()
        dcrRefreshInProgress = false
    }
    
    func checkDoctorVisitFeedbackStatus()
    {
        if dcrRefreshInProgress == true
        {
            dcrRefreshInProgress = false
        }
        
        if statusList.count == 0
        {
            uploadDoctorVisitFeedback()
        }
        else
        {
            if feedbackList.count > 0
            {
                feedbackList = []
            }
            feedbackList = DBHelper.sharedInstance.getDoctorVisitFeedback()
        }
    }
    
    private func initiateOperation()
    {
        var filteredAnalyticsList : [DoctorVisitFeedback] = []
        for i in 0..<feedbackList.count
        {
            if i < uploadFeedbackMaxConcOperationCount
            {
                filteredAnalyticsList.append(feedbackList[i])
            }
        }
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredAnalyticsList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.id
            statusModel.status = false
            statusList.append(statusModel)
            
            print("Feedback upload starts")
            uploadFeedbackServiceCall(model: model)
        }
        
        let pendingList = DBHelper.sharedInstance.getDoctorVisitFeedback()
        
        if (pendingList.count == 0)
        {
            print("All Doctor Visit Feedback Completed")
            showToastView(toastText: "eDetailing Analytics uploaded")
            removeCustomActivityView()
            
            if (navigateToAttachmentUpload)
            {
                navigateToAttachmentUpload = false
                navigateToUploaAttachment()
            }
        }
    }
    
    func uploadFeedbackServiceCall(model: DoctorVisitFeedback)
    {
        if checkInternetConnectivity()
        {
            let urlString = wsRootUrl + wsDoctor + wsVisitFeedback
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            request.httpMethod = wsPOST
            request.timeoutInterval = wsTimeOutInterval
            
            let dict1: [String: Any] = ["Company_Code": getCompanyCode(), "Customer_Region_Code": getRegionCode(), "User_Code": getUserCode(), "Customer_Code": model.customerCode, "Detailed_Date": model.detailedDate, "Visit_Rating": model.visitRating]
            let dict2: [String: Any] = ["Visit_Feedback": model.VisitFeedBack, "Source_Of_Entry": model.sourceOfEntry, "Is_Synched": model.is_Synced, "Time_Zone": model.timeZone, "Updated_Datetime": model.updated_Date_Time]
            let dataDictionary: [String: Any] = dict1.merged(with: dict2)
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
                                                        self.updateSuccessStatus(model: model)
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
        showToastView(toastText: docVisitFeedbackAnalyticsInternetDropOffMsg)
    }
    
    func updateFailureStatus(model: DoctorVisitFeedback)
    {
        updateFeedbackArray(model: model)
        updateStatusInitiateOperation(fileId: model.id)
    }
    
    func updateSuccessStatus(model: DoctorVisitFeedback)
    {
        DBHelper.sharedInstance.updateDoctorVisitFeedbackStatus(feedbackId: model.id, isSynched: 1)
        updateFeedbackArray(model: model)
        updateStatusInitiateOperation(fileId: model.id)
    }
    
    func updateFeedbackArray(model: DoctorVisitFeedback)
    {
        if let index = feedbackList.index(where: {$0.id == model.id})
        {
            feedbackList.remove(at: index)
        }
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            print("feedback Cycle completed")
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
