//
//  BL_AttachmentOperation.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_AttachmentOperation: NSObject
{
    static let sharedInstance = BL_AttachmentOperation()
    let queue = OperationQueue()
    var fileList : [DCRAttachmentModel] = []
    var statusList : [FileStatus] = []
    
    func initiateOperation()
    {
        let filteredFileList = DBHelper.sharedInstance.getPendingAttachmentsToUpload()
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredFileList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.attachmentId
            statusModel.status = false
            statusList.append(statusModel)
            
            print("Image upload starts")
            imageUpload(model: model)
        }
    }
    
    func initiateTPOperation()
    {
        let filteredFileList = DBHelper.sharedInstance.getPendingTPAttachmentToUpload()
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredFileList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.attachmentId
            statusModel.status = false
            statusList.append(statusModel)
            
            print("Image upload starts")
            TPimageUpload(model: model)
        }
    }
    
    
    
    func TPimageUpload(model: TPAttachmentModel)
    {
        let filePath = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
        if filePath != ""
        {
            if let getFileData = NSData(contentsOfFile: filePath)
            {
                if checkInternetConnectivity()
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                    let _:String = formatter.string(from: getCurrentDateAndTime())
                    let outputFilename = "\(model.attachmentName!)"
                    
                    var fileExtension: String!
                    let fileSplittedString = model.attachmentName?.components(separatedBy: ".")
                    if (fileSplittedString?.count)! > 0
                    {
                        fileExtension = fileSplittedString?.last
                    }
                    else
                    {
                        fileExtension = png
                    }
                   
                    let urlString = wsRootUrl + wsUploadTPAttachment + "\(getCompanyCode())/" + "\(getUserCode())/" + getRegionCode()
                    print("URL \(urlString)")
                    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                    request.httpMethod = "POST"
                    request.timeoutInterval = 60.0
                    
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Post parameters
                    let attachmentInfo : [String : Any] = ["TP_Id": model.tpId, "TP_Doctor_Id": model.tpDoctorId, "Uploaded_File_Name": model.attachmentName]
                    let attachmentArr: NSMutableArray = NSMutableArray()
                    attachmentArr.add(attachmentInfo)
                    
                    var attachmentJson : String = ""
                    if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                        if let content = String(data: json, encoding: String.Encoding.utf8) {
                            // here `content` is the JSON dictionary containing the String
                            print(content)
                            attachmentJson = content
                        }
                    }
                    
                    let params = ["TPDoctorVisitAttachmentInfo": attachmentJson, "localFileName": outputFilename]
                    print("Params \(params)")
                    
                    var body = Data()
                    
                    for (key, value) in params {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append("\(value)\r\n")
                    }
                    
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"TPDoctorVisitFile\"; filename=\"\(outputFilename)\"\r\n")
                    let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                    body.append("Content-Type: \(contentType)\r\n\r\n")
                    body.append(getFileData as Data)
                    body.append("\r\n")
                    
                    body.append("--\(boundary)--\r\n")
                    
                    request.httpBody = body
                    
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    var task = URLSessionDataTask()
                    
                    let blockOperation = BlockOperation(block: {
                        
                        task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                            
                            OperationQueue.main.addOperation({
                                
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
                                            print(response)
                                            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                            {
                                                print(json)
                                                if let jsonDict = json as? NSDictionary
                                                {
                                                    if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                    {
                                                        if listarray.count > 0
                                                        {
                                                            let dictionary = listarray[0] as! NSDictionary
                                                            let blobUrl = dictionary["Blob_URL"] as! String
                                                            DBHelper.sharedInstance.updateTPAttachmentBlobUrl(attachmentId: model.attachmentId!, blobUrl: blobUrl)
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
                                
                            })
                        }
                        
                        task.resume()
                    })
                    
                    queue.addOperation(blockOperation)
                }
                else
                {
                    print("No internet connection")
                    self.showInternetErrorToast()
                }
            }
            else
            {
                print("Invalid file data")
                self.updateFailureStatus(model: model)
            }
        }
        else
        {
            print("File path is empty")
            self.updateFailureStatus(model: model)
        }
    }
    
    
    
    
    func imageUpload(model: DCRAttachmentModel)
    {
        let filePath = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
        if filePath != ""
        {
            if let getFileData = NSData(contentsOfFile: filePath)
            {
                if checkInternetConnectivity()
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                    let _:String = formatter.string(from: getCurrentDateAndTime())
                    let outputFilename = "\(model.attachmentName!)"
                    
                    var fileExtension: String!
                    let fileSplittedString = model.attachmentName?.components(separatedBy: ".")
                    if (fileSplittedString?.count)! > 0
                    {
                        fileExtension = fileSplittedString?.last
                    }
                    else
                    {
                        fileExtension = png
                    }
                    
                    let urlString = wsRootUrl + wsUploadDCRAttachment + "\(getCompanyCode())/" + "\(getUserCode())/" + getRegionCode()
                    print("URL \(urlString)")
                    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                    request.httpMethod = "POST"
                    request.timeoutInterval = 60.0
                    
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Post parameters
                    let attachmentInfo : [String : Any] = ["DCR_Code": "", "DCR_Visit_Code": model.dcrVisitCode!, "Blob_Url": "", "Visit_Id": "\(model.doctorVisitId!)", "DCR_Id": "\(model.dcrId!)", "Uploaded_File_Name": outputFilename, "User_Code": getUserCode(), "DCR_Actual_Date": model.dcrDate]
                    let attachmentArr: NSMutableArray = NSMutableArray()
                    attachmentArr.add(attachmentInfo)
                    
                    var attachmentJson : String = ""
                    if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                        if let content = String(data: json, encoding: String.Encoding.utf8) {
                            // here `content` is the JSON dictionary containing the String
                            print(content)
                            attachmentJson = content
                        }
                    }
                    
                    let params = ["DCRDoctorVisitAttachmentInfo": attachmentJson, "localFileName": outputFilename]
                    print("Params \(params)")
                    
                    var body = Data()
                    
                    for (key, value) in params {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append("\(value)\r\n")
                    }
                    
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"DCRDoctorVisitFile\"; filename=\"\(outputFilename)\"\r\n")
                    let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                    body.append("Content-Type: \(contentType)\r\n\r\n")
                    body.append(getFileData as Data)
                    body.append("\r\n")
                    
                    body.append("--\(boundary)--\r\n")
                    
                    request.httpBody = body
                    
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    var task = URLSessionDataTask()
                    
                    let blockOperation = BlockOperation(block: {
                        
                        task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                            
                            OperationQueue.main.addOperation({
                                
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
                                            print(response)
                                            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                            {
                                                print(json)
                                                if let jsonDict = json as? NSDictionary
                                                {
                                                    if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                    {
                                                        if listarray.count > 0
                                                        {
                                                            let dictionary = listarray[0] as! NSDictionary
                                                            let blobUrl = dictionary["Blob_Url"] as! String
                                                            DBHelper.sharedInstance.updateAttachmentBlobUrl(attachmentId: model.attachmentId, blobUrl: blobUrl)
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
                                
                            })
                        }
                        
                        task.resume()
                    })
                    
                    queue.addOperation(blockOperation)
                }
                else
                {
                    print("No internet connection")
                    self.showInternetErrorToast()
                }
            }
            else
            {
                print("Invalid file data")
                self.updateFailureStatus(model: model)
            }
        }
        else
        {
            print("File path is empty")
            self.updateFailureStatus(model: model)
        }
    }
    
    func doctorPhotoUpload(getFileData: NSData?, filePath: String, outputFilename: String, attachmentInfo:[String : Any], completion: @escaping (ApiResponseModel) -> ())
    {
        if checkInternetConnectivity()
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyhhmmssSSS"
            let _:String = formatter.string(from: getCurrentDateAndTime())
            //            let outputFilename = "\(model.attachmentName!)"
            
            var fileExtension: String = EMPTY
            
            if (filePath != EMPTY)
            {
                let fileSplittedString = filePath.components(separatedBy: ".")
                
                if (fileSplittedString.count > 0)
                {
                    fileExtension = fileSplittedString.last!
                }
                else
                {
                    fileExtension = png
                }
            }
            
            let urlString = wsRootUrl + "CustomerApi/UploadCustomerPersonelInfoWithPhotoV60/" + getCompanyCode() + "/" + getUserCode() + "/" + getRegionCode()
            
            print("URL \(urlString)")
            let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            request.httpMethod = "POST"
            request.timeoutInterval = wsTimeOutInterval
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // Post parameters
            //            let attachmentInfo : [String : Any] = ["DCR_Code": "", "DCR_Visit_Code": model.dcrVisitCode!, "Blob_Url": "", "Visit_Id": "\(model.doctorVisitId!)", "DCR_Id": "\(model.dcrId!)", "Uploaded_File_Name": outputFilename, "User_Code": getUserCode(), "DCR_Actual_Date": model.dcrDate]
            let attachmentArr: NSMutableArray = NSMutableArray()
            attachmentArr.add(attachmentInfo)
            
            var attachmentJson : String = ""
            if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                if let content = String(data: json, encoding: String.Encoding.utf8) {
                    // here `content` is the JSON dictionary containing the String
                    print(content)
                    attachmentJson = content
                }
            }
            
            let params = ["customerpersonlinfo": attachmentJson, "localFileName": outputFilename]
            print("Params \(params)")
            
            var body = Data()
            
            for (key, value) in params {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
            
            if (getFileData != nil)
            {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"customerPhotoFile\"; filename=\"\(outputFilename)\"\r\n")
                
                let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                body.append("Content-Type: \(contentType)\r\n\r\n")
                
                body.append(getFileData! as Data)
                body.append("\r\n")
                body.append("--\(boundary)--\r\n")
            }
            
            request.httpBody = body
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var task = URLSessionDataTask()
            
            let blockOperation = BlockOperation(block: {
                
                task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    OperationQueue.main.addOperation({
                        
                        if error != nil
                        {
                            let getError = error as NSError?
                            print("Service error \(String(describing: getError?.code))")
                            if getError?.code == -1009
                            {
                                completion(self.getNoInternetModel())
                            }
                            else
                            {
                                completion(self.getServerErrorModel())
                            }
                        }
                        else
                        {
                            if data != nil
                            {
                                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                {
                                    print(response)
                                    if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                    {
                                        print(json)
                                        if let jsonDict = json as? NSDictionary
                                        {
                                            let status = jsonDict.value(forKey: "Status") as? Int
                                            
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                {
                                                    if listarray.count > 0
                                                    {
                                                        if (getFileData != nil)
                                                        {
                                                            _ = BL_DoctorList.sharedInstance.writeFile(fileData: getFileData! as Data, blobUrl: filePath)
                                                        }
                                                        
                                                        completion(self.getSuccessModel(array: listarray))
                                                    }
                                                    else
                                                    {
                                                        completion(self.getServerErrorModel())
                                                    }
                                                }
                                                else
                                                {
                                                    completion(self.getServerErrorModel())
                                                }
                                            }
                                            else
                                            {
                                                completion(self.getServerErrorModel())
                                            }
                                        }
                                        else
                                        {
                                            completion(self.getServerErrorModel())
                                        }
                                    }
                                    else
                                    {
                                        completion(self.getServerErrorModel())
                                    }
                                }
                                else
                                {
                                    completion(self.getServerErrorModel())
                                }
                            }
                            else
                            {
                                completion(self.getServerErrorModel())
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
            print("No internet connection")
            completion(getNoInternetModel())
        }
    }
    
    private func getNoInternetModel() -> ApiResponseModel
    {
        let objApiResponse = ApiResponseModel()
        
        objApiResponse.Status = NO_INTERNET_ERROR_CODE
        objApiResponse.Message = internetOfflineMessage
        objApiResponse.Count = 0
        objApiResponse.list = []
        
        return objApiResponse
    }
    
    private func getServerErrorModel() -> ApiResponseModel
    {
        let objApiResponse = ApiResponseModel()
        
        objApiResponse.Status = SERVER_ERROR_CODE
        objApiResponse.Message = EMPTY
        objApiResponse.Count = 0
        objApiResponse.list = []
        
        return objApiResponse
    }
    
    private func getSuccessModel(array: NSArray) -> ApiResponseModel
    {
        let objApiResponse = ApiResponseModel()
        
        objApiResponse.Status = SERVER_SUCCESS_CODE
        objApiResponse.Message = EMPTY
        objApiResponse.Count = 0
        objApiResponse.list = array
        
        return objApiResponse
    }
    
    func updateFailureStatus(model: DCRAttachmentModel)
    {
        DBHelper.sharedInstance.updateAttachmentSuccessFlag(attachmentId: model.attachmentId, isSuccess: 0)
        self.updateStatusInitiateOperation(fileId: model.attachmentId)
        let userInfo : [String : Int] = ["id": model.attachmentId, "status": 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: attachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func updateSuccessStatus(model: DCRAttachmentModel)
    {
        DBHelper.sharedInstance.updateAttachmentSuccessFlag(attachmentId: model.attachmentId, isSuccess: 1)
        self.updateStatusInitiateOperation(fileId: model.attachmentId)
        let userInfo : [String : Int] = ["id": model.attachmentId, "status": 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: attachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func updateFailureStatus(model: TPAttachmentModel)
    {
        DBHelper.sharedInstance.updateTPAttachmentSuccessFlag(attachmentId: model.attachmentId!, isSuccess: 0)
        self.updateTPStatusInitiateOperation(fileId: model.attachmentId!)
        let userInfo : [String : Int] = ["id": model.attachmentId!, "status": 0]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: tpaAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func updateSuccessStatus(model: TPAttachmentModel)
    {
        DBHelper.sharedInstance.updateTPAttachmentSuccessFlag(attachmentId: model.attachmentId!, isSuccess: 1)
        self.updateTPStatusInitiateOperation(fileId: model.attachmentId!)
        let userInfo : [String : Int] = ["id": model.attachmentId!, "status": 1]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: tpaAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func showInternetErrorToast()
    {
        if self.statusList.count > 0
        {
            self.statusList = []
        }
        showAttachmentToastView(text: attachmentInternetDropOffMsg)
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            print("Cycle completed")
            if DBHelper.sharedInstance.getPendingAttachmentsToUpload().count > 0
            {
                self.initiateOperation()
            }
            else
            {
                if self.statusList.count > 0
                {
                    self.statusList = []
                }
                
                if DBHelper.sharedInstance.getFailureAttachmentCount() > 0
                {
                    showAttachmentToastView(text: attachmentFailedMsg)
                }
            }
        }
    }
    
    func updateTPStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            print("Cycle completed")
            if DBHelper.sharedInstance.getPendingTPAttachmentToUpload().count > 0
            {
                self.initiateTPOperation()
            }
            else
            {
                if self.statusList.count > 0
                {
                    self.statusList = []
                }
                
                if DBHelper.sharedInstance.getFailureTPAttachmentCount() > 0
                {
                    showAttachmentToastView(text: attachmentFailedMsg)
                }
            }
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

class BL_Chemist_AttachmentOperation: NSObject
{
    static let sharedInstance = BL_Chemist_AttachmentOperation()
    let queue = OperationQueue()
    var fileList : [DCRChemistAttachment] = []
    var statusList : [FileStatus] = []
    
    func initiateOperation()
    {
        let filteredFileList = DBHelper.sharedInstance.getPendingChemistAttachmentsToUpload()
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredFileList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.DCRChemistAttachmentId
            statusModel.status = false
            statusList.append(statusModel)
            
            imageUpload(model: model)
        }
    }
    
    func clearAllArray()
    {
        fileList.removeAll()
        statusList.removeAll()
    }
    
    func imageUpload(model: DCRChemistAttachment)
    {
        let filePath = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.UploadedFileName)
        
        if filePath != ""
        {
            if let getFileData = NSData(contentsOfFile: filePath)
            {
                if checkInternetConnectivity()
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                    let _:String = formatter.string(from: getCurrentDateAndTime())
                    let outputFilename = "\(model.UploadedFileName!)"
                    
                    var fileExtension: String!
                    let fileSplittedString = model.UploadedFileName?.components(separatedBy: ".")
                    if (fileSplittedString?.count)! > 0
                    {
                        fileExtension = fileSplittedString?.last
                    }
                    else
                    {
                        fileExtension = png
                    }
                    
                    let urlString = wsRootUrl + wsUploadChemistAttachment + "\(getCompanyCode())/" + "\(getUserCode())/" + getRegionCode()
                    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                    request.httpMethod = "POST"
                    request.timeoutInterval = wsTimeOutInterval
                    
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Post parameters
                    let attachmentInfo : [String : Any] = ["chemistVisit_Id": model.ChemistVisitId, "Uploaded_File_Name": outputFilename, "DCR_Code": EMPTY, "CV_Visit_Id": model.DCRChemistDayVisitId, "DCR_Id": model.DCRId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode()]
                    let attachmentArr: NSMutableArray = NSMutableArray()
                    attachmentArr.add(attachmentInfo)
                    
                    var attachmentJson : String = ""
                    if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                        if let content = String(data: json, encoding: String.Encoding.utf8) {
                            // here `content` is the JSON dictionary containing the String
                            print(content)
                            attachmentJson = content
                        }
                    }
                    
                    let params = ["DCRChemistVisitAttachmentInfo": attachmentJson, "localFileName": outputFilename]
                    print("Params \(params)")
                    
                    var body = Data()
                    
                    for (key, value) in params {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append("\(value)\r\n")
                    }
                    
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"DCRChemistVisitFile\"; filename=\"\(outputFilename)\"\r\n")
                    let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                    body.append("Content-Type: \(contentType)\r\n\r\n")
                    body.append(getFileData as Data)
                    body.append("\r\n")
                    
                    body.append("--\(boundary)--\r\n")
                    
                    request.httpBody = body
                    
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    var task = URLSessionDataTask()
                    
                    let blockOperation = BlockOperation(block: {
                        
                        task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                            
                            OperationQueue.main.addOperation({
                                
                                if error != nil
                                {
                                    let getError = error as NSError?
                                    
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
                                            print(response)
                                            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                            {
                                                print(json)
                                                if let jsonDict = json as? NSDictionary
                                                {
                                                    if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                    {
                                                        if listarray.count > 0
                                                        {
                                                            let dictionary = listarray[0] as! NSDictionary
                                                            let blobUrl = dictionary["Blob_Url"] as! String
                                                            DBHelper.sharedInstance.updateChemistAttachmentBlobUrl(attachmentId: model.DCRChemistAttachmentId, blobUrl: blobUrl)
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
                                
                            })
                        }
                        
                        task.resume()
                    })
                    
                    queue.addOperation(blockOperation)
                }
                else
                {
                    print("No internet connection")
                    self.showInternetErrorToast()
                }
            }
            else
            {
                print("Invalid file data")
                self.updateFailureStatus(model: model)
            }
        }
        else
        {
            print("File path is empty")
            self.updateFailureStatus(model: model)
        }
    }
    
    func updateFailureStatus(model: DCRChemistAttachment)
    {
        DBHelper.sharedInstance.updateChemistAttachmentSuccessFlag(attachmentId: model.DCRChemistAttachmentId, isSuccess: 0)
        
        self.updateStatusInitiateOperation(fileId: model.DCRChemistAttachmentId)
        let userInfo : [String : Int] = ["id": model.DCRChemistAttachmentId, "status": 0]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: chemistAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func updateSuccessStatus(model: DCRChemistAttachment)
    {
        DBHelper.sharedInstance.updateChemistAttachmentSuccessFlag(attachmentId: model.DCRChemistAttachmentId, isSuccess: 1)
        
        self.updateStatusInitiateOperation(fileId: model.DCRChemistAttachmentId)
        let userInfo : [String : Int] = ["id": model.DCRChemistAttachmentId, "status": 1]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: chemistAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func showInternetErrorToast()
    {
        if self.statusList.count > 0
        {
            self.statusList = []
        }
        
        showAttachmentToastView(text: attachmentInternetDropOffMsg)
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            if DBHelper.sharedInstance.getPendingChemistAttachmentsToUpload().count > 0
            {
                self.initiateOperation()
            }
            else
            {
                if self.statusList.count > 0
                {
                    self.statusList = []
                }
                
                if DBHelper.sharedInstance.getFailureChemistAttachmentCount() > 0
                {
                    showAttachmentToastView(text: attachmentFailedMsg)
                }
            }
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

class BL_Leave_AttachmentOperation: NSObject
{
    static let sharedInstance = BL_Leave_AttachmentOperation()
    let queue = OperationQueue()
    var fileList : [DCRLeaveModel] = []
    var statusList : [FileStatus] = []
    
    func initiateOperation()
    {
        let filteredFileList = DBHelper.sharedInstance.leaveAttachmentsToUpload()
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredFileList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.attachmentId
            statusModel.status = false
            statusList.append(statusModel)
            
            imageUpload(model: model)
        }
    }
    
    func clearAllArray()
    {
        fileList.removeAll()
        statusList.removeAll()
    }
    
    func imageUpload(model: DCRLeaveModel)
    {
        let filePath = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
        
        if filePath != ""
        {
            if let getFileData = NSData(contentsOfFile: filePath)
            {
                if checkInternetConnectivity()
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                    let _:String = formatter.string(from: getCurrentDateAndTime())
                    let outputFilename = "\(model.attachmentName!)"
                    
                    var fileExtension: String!
                    let fileSplittedString = model.attachmentName?.components(separatedBy: ".")
                    if (fileSplittedString?.count)! > 0
                    {
                        fileExtension = fileSplittedString?.last
                    }
                    else
                    {
                        fileExtension = png
                    }
                    
                    let urlString = wsRootUrl + wsUploadLeaveAttachment + "\(getCompanyCode())/" + "\(getUserCode())/" + getRegionCode()
                    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                    request.httpMethod = "POST"
                    request.timeoutInterval = wsTimeOutInterval
                    
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Post parameters
//                    let attachmentInfo : [String : Any] = ["chemistVisit_Id": model.ChemistVisitId, "Uploaded_File_Name": outputFilename, "DCR_Code": EMPTY, "CV_Visit_Id": model.DCRChemistDayVisitId, "DCR_Id": model.DCRId, "CV_User_Code": getUserCode(), "CV_Region_Code": getRegionCode()]
                    
                    let attachmentInfo : [String : Any] = ["Leave_Type_Code": "", "Company_Code": getCompanyCode(), "User_Code": getUserCode(), "From_Date": "", "To_Date": "", "Number_Of_Days": 0, "Leave_Status": String(DCRStatus.applied.rawValue), "Document_Url": "", "Uploaded_File_Name": outputFilename]

                    
                    let attachmentArr: NSMutableArray = NSMutableArray()
                    attachmentArr.add(attachmentInfo)
                    
                    var attachmentJson : String = ""
                    if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: []) {
                        if let content = String(data: json, encoding: String.Encoding.utf8) {
                            // here `content` is the JSON dictionary containing the String
                            print(content)
                            attachmentJson = content
                        }
                    }
                    
                    let params = ["DCRLeaveAttachmentInfo": attachmentJson, "localFileName": outputFilename]
                    print("Params \(params)")
                    
                    var body = Data()
                    
                    for (key, value) in params {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append("\(value)\r\n")
                    }
                    
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"DCRLeaveAttachmentFile\"; filename=\"\(outputFilename)\"\r\n")
                    let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                    body.append("Content-Type: \(contentType)\r\n\r\n")
                    body.append(getFileData as Data)
                    body.append("\r\n")
                    
                    body.append("--\(boundary)--\r\n")
                    
                    request.httpBody = body
                    
                    let session = URLSession(configuration: URLSessionConfiguration.default)
                    var task = URLSessionDataTask()
                    
                    let blockOperation = BlockOperation(block: {
                        
                        task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                            
                            OperationQueue.main.addOperation({
                                
                                if error != nil
                                {
                                    let getError = error as NSError?
                                    
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
                                            print(response)
                                            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                            {
                                                print(json)
                                                if let jsonDict = json as? NSDictionary
                                                {
                                                    if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                    {
                                                        if listarray.count > 0
                                                        {
                                                            let dictionary = listarray[0] as! NSDictionary
                                                            let blobUrl = dictionary["Document_Url"] as! String
                                                            DBHelper.sharedInstance.updateLeaveAttachmentBlobUrl(attachmentId: model.attachmentId, blobUrl: blobUrl)
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
                                
                            })
                        }
                        
                        task.resume()
                    })
                    
                    queue.addOperation(blockOperation)
                }
                else
                {
                    print("No internet connection")
                    self.showInternetErrorToast()
                }
            }
            else
            {
                print("Invalid file data")
                self.updateFailureStatus(model: model)
            }
        }
        else
        {
            print("File path is empty")
            self.updateFailureStatus(model: model)
        }
    }
    
    func updateFailureStatus(model: DCRLeaveModel)
    {
        DBHelper.sharedInstance.updateLeaveAttachmentSuccessFlag(attachmentId: model.attachmentId, isSuccess: 0)
        
        self.updateStatusInitiateOperation(fileId: model.attachmentId)
        let userInfo : [String : Int] = ["id": model.attachmentId, "status": 0]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: leaveAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func updateSuccessStatus(model: DCRLeaveModel)
    {
        DBHelper.sharedInstance.updateLeaveAttachmentSuccessFlag(attachmentId: model.attachmentId, isSuccess: 1)
        
        self.updateStatusInitiateOperation(fileId: model.attachmentId)
        let userInfo : [String : Int] = ["id": model.attachmentId, "status": 1]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: leaveAttachmentNotification), object: nil, userInfo: userInfo)
    }
    
    func showInternetErrorToast()
    {
        if self.statusList.count > 0
        {
            self.statusList = []
        }
        
        showAttachmentToastView(text: attachmentInternetDropOffMsg)
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            if DBHelper.sharedInstance.leaveAttachmentsToUpload().count > 0
            {
                self.initiateOperation()
            }
            else
            {
                if self.statusList.count > 0
                {
                    self.statusList = []
                }
                
                if DBHelper.sharedInstance.getFailureLeaveAttachmentCount() > 0
                {
                    showAttachmentToastView(text: attachmentFailedMsg)
                }
            }
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
