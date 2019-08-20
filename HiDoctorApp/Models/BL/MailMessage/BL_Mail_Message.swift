//
//  BL_Mail_Message.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Mail_Message: NSObject
{
    static let sharedInstance = BL_Mail_Message()
    var lstHeader: [MailMessageHeader] = []
    var lstContent: [MailMessageContent] = []
    var lstAgent: [MailMessageAgent] = []
    var lstAttachment: [MailMessageAttachment] = []
    let imageArray: [String] = [jpg, jpeg, png, bmp, gif, tif, tiff]
    let excelArray: [String] = [xls, xlsx]
    let wordArray: [String] = [doc, docx]
    var selectedImage: [String] = []
    var forwardImage = Int()
    var composeText = NSAttributedString()
    var subjectText = String()
    var messageList: [MailMessageWrapperModel] = []
    let queue = OperationQueue()
    
    func getMailMessages(messageType: Int, pageNumber: Int, searchText: String, completion: @escaping (ApiResponseModel) -> ())
    {
        let postData = getMailMessagePostData(messageMode: messageType, pageNumber: pageNumber, searchText: searchText)
        
        WebServiceHelper.sharedInstance.getMailMessages(postData: postData) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func processMailMessageResponse(messageType: Int, lstMail: NSArray, pageNumber: Int, searchText: String) -> [MailMessageWrapperModel]
    {
        if (messageType == Constants.MessageType.inbox && pageNumber == 1 && searchText == "NA")
        {
            insertMailInLocalDB(lstMail: lstMail)
        }
        
        convertToClassModels(lstMail: lstMail)
        
        return createResultList()
    }
    
    func getMailMessageFromLocal(messageType: Int) -> [MailMessageWrapperModel]
    {
        clearArray()
        
        lstHeader = DBHelper.sharedInstance.getMailMessageHeader()
        lstContent = DBHelper.sharedInstance.getMailMessageContent()
        lstAgent = DBHelper.sharedInstance.getMailMessageAgent()
        lstAttachment =  DBHelper.sharedInstance.getMailMessageAttachments()
        
        return createResultList()
    }
    
    func downloadAttachment(blobUrl: String, msgCode: String, msgIndex: Int, attachmentIndex: Int, completion: @escaping (Int, Int, String) -> ())
    {
        let encodedUrl  = blobUrl.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        let attachmentUrl = URL(string: encodedUrl!)
        
        WebServiceWrapper.sharedInstance.getDataFromUrl(url: attachmentUrl!){ (data) in
            var localPath: String = EMPTY
            
            if (data != nil)
            {
                localPath = self.writeFile(fileData: data!, msgCode: msgCode, blobUrl: blobUrl)
                
                if (localPath != EMPTY)
                {
                    DBHelper.sharedInstance.updateMailAttachmentLocalPath(localPath: localPath, blobUrl: blobUrl, msgCode: msgCode)
                }
            }
            
            completion(msgIndex, attachmentIndex, localPath)
        }
    }
    
    func getMailUsersList(completion: @escaping ([UserMasterWrapperModel]) -> ())
    {
        var userList: [UserMasterWrapperModel] = []
        
        WebServiceHelper.sharedInstance.getUserFromMessaging { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                userList = self.convertToUserMasterWrapperModel(apiList: apiResponseObj.list)
            }
            
            completion(userList)
        }
    }
    
    func updateMessageAsRead(messageCode: String, completion: @escaping (ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.updateMessageStatusAsRead(messageCode: messageCode) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func deleteMessage(msgList: [MailMessageWrapperModel], messageType: Int, completion: @escaping (ApiResponseModel) -> ())
    {
        let postData: NSMutableArray = []
        var rowStatus: Int = 0
        var messageTypeString: String = EMPTY
        
        if (messageType == Constants.MessageType.inbox)
        {
            messageTypeString = Constants.MessageList.inbox.uppercased()
            rowStatus = 0
        }
        else if (messageType == Constants.MessageType.sent)
        {
            messageTypeString = Constants.MessageList.sent.uppercased()
            rowStatus = 1
        }
        else if (messageType == Constants.MessageType.trash)
        {
            messageTypeString = Constants.MessageList.trash.uppercased()
            rowStatus = 3
        }
        else if (messageType == Constants.MessageType.draft)
        {
            messageTypeString = Constants.MessageList.draft.uppercased()
            rowStatus = 2
        }
        
        for objMail in msgList
        {
            let dict: NSDictionary = ["Company_Code": getCompanyCode(), "Msg_Code": objMail.objMailMessageHeader.Msg_Code, "Target_Address": getUserCode(), "Sender": objMail.objMailMessageHeader.Sender_User_Code]
            
            postData.add(dict)
        }
        
        if (postData.count > 0)
        {
            WebServiceHelper.sharedInstance.deleteMailMessage(messageType: messageTypeString, rowStatus: rowStatus, postData: postData, completion: { (objApiResponse) in
                completion(objApiResponse)
            })
        }
    }
    
    func sendAttachment(filePath: String, completion: @escaping (String) -> ())
    {
        if filePath != EMPTY
        {
            if let getFileData = NSData(contentsOfFile: filePath)
            {
                if checkInternetConnectivity()
                {
                    let outputFilename = getFileComponent(fileName: filePath, separatedBy: "/")
                    let fileExtension: String = getFileComponent(fileName: filePath, separatedBy: ".")
                    let urlString = wsRootUrl + "MessageApi/UploadMailAttachment/" + "\(getCompanyCode())/" + "\(getUserCode())/" + getRegionCode()
                    let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                    request.httpMethod = wsPOST
                    request.timeoutInterval = wsTimeOutInterval
                    
                    let boundary = generateBoundaryString()
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    // Post parameters
                    let attachmentInfo : [String : Any] = ["Attachment_Id": 0, "Entity_Type": 1, "Entity_Code": 0, "File_Name": "\(outputFilename)", "Blob_URL": EMPTY]
                    let attachmentArr: NSMutableArray = NSMutableArray()
                    attachmentArr.add(attachmentInfo)
                    
                    var attachmentJson : String = ""
                    if let json = try? JSONSerialization.data(withJSONObject: attachmentArr, options: [])
                    {
                        if let content = String(data: json, encoding: String.Encoding.utf8)
                        {
                            // here `content` is the JSON dictionary containing the String
                            attachmentJson = content
                        }
                    }
                    
                    let params = ["MailAttachmentInfo": attachmentJson, "localFileName": outputFilename]
                    var body = Data()
                    
                    for (key, value) in params
                    {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.append("\(value)\r\n")
                    }
                    
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"MailAttachmentFile\"; filename=\"\(outputFilename)\"\r\n")
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
                                        completion(EMPTY)
                                    }
                                    else
                                    {
                                        completion(EMPTY)
                                    }
                                }
                                else
                                {
                                    if data != nil
                                    {
                                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                        {
                                            if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                            {
                                                if let jsonDict = json as? NSDictionary
                                                {
                                                    if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                    {
                                                        if listarray.count > 0
                                                        {
                                                            let dictionary = listarray[0] as! NSDictionary
                                                            let blobUrl = dictionary["Blob_URL"] as! String
                                                            
                                                            completion(blobUrl)
                                                        }
                                                        else
                                                        {
                                                            completion(EMPTY)
                                                        }
                                                    }
                                                    else
                                                    {
                                                        completion(EMPTY)
                                                    }
                                                }
                                                else
                                                {
                                                    completion(EMPTY)
                                                }
                                            }
                                            else
                                            {
                                                completion(EMPTY)
                                            }
                                        }
                                        else
                                        {
                                            completion(EMPTY)
                                        }
                                    }
                                    else
                                    {
                                        completion(EMPTY)
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
                    completion(EMPTY)
                }
            }
            else
            {
                completion(EMPTY)
            }
        }
        else
        {
            completion(EMPTY)
        }
    }
    
    func sendMail(messageSubject: String, messageContent: String, lstAgent: [MailMessageAgent]?, targetUserList:[UserMasterWrapperModel],targetCcUserList:[UserMasterWrapperModel], isNewMail: Bool, msgId: Int, attachmentBlobUrlList: [String], completion: @escaping (ApiResponseModel) -> ())
    {
        var targetEmpNames: String = EMPTY
        var targetUserCodes: String = EMPTY
        var targetCcEmpNames: String = EMPTY
        var targetCcUserCodes: String = EMPTY
        let lstAgentArray: NSMutableArray = []
        var isRead = 0
        
        for objUserWrapperModel in targetUserList
        {
            targetEmpNames += objUserWrapperModel.userObj.Employee_name + ","
            targetUserCodes += objUserWrapperModel.userObj.User_Code + ","
        }
        
        for objUserWrapperModel in targetCcUserList
        {
            targetCcEmpNames += objUserWrapperModel.userObj.Employee_name + ","
            targetCcUserCodes += objUserWrapperModel.userObj.User_Code + ","
        }
        
//        if (lstAgent != nil)
//        {
//            for objAgent in lstAgent!
//            {
//                let dict: NSDictionary = ["AddressType": objAgent.Address_Type, "EmployeeName": objAgent.Target_Employee_Name, "MsgCode": objAgent.Msg_Code, "MsgId": msgId, "UserCode": objAgent.Target_UserCode, "isRead": objAgent.Is_Read]
//                lstAgentArray.add(dict)
//            }
//        }
        
        if (targetEmpNames != EMPTY)
        {
            targetEmpNames = String(targetEmpNames.dropLast())
            targetUserCodes = String(targetUserCodes.dropLast())
        }
        
        if (targetCcEmpNames != EMPTY)
        {
            targetCcEmpNames = String(targetCcEmpNames.dropLast())
            targetCcUserCodes = String(targetCcUserCodes.dropLast())
        }
        
        if (!isNewMail)
        {
            isRead = 1
        }
        
        let postDataDict1: NSDictionary = ["Subject": messageSubject, "Message_Content": messageContent, "Date_From": getCurrentDateAndTimeString(), "Sent_Status": "Send", "Sent_Type": "STRAIGHT", "To_Employee_Name": targetEmpNames, "To_User_Names": targetUserCodes]
        
        let postDataDict2: NSDictionary = ["CC_User_Names":targetCcUserCodes,"IsRead": isRead, "Is_Sent": 0, "Msg_Code": EMPTY, "Msg_Id": msgId, "Is_Richtext": "733", "lstAgent":[]]
        
        var combinedAttributes : NSMutableDictionary!
        
        combinedAttributes = NSMutableDictionary(dictionary: postDataDict1)
        combinedAttributes.addEntries(from: postDataDict2 as! [AnyHashable : Any])
        
        if (attachmentBlobUrlList.count > 0)
        {
            var index: Int = 0
            let mutableDict: NSMutableDictionary = [:]
            
            for blobUrl in attachmentBlobUrlList
            {
                index += 1
                mutableDict.addEntries(from: ["Attachment_Path" + String(index): blobUrl])
            }
            
            combinedAttributes.addEntries(from: mutableDict as! [AnyHashable : Any])
        }
        WebServiceHelper.sharedInstance.sendMail(postData: combinedAttributes) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func clearArray()
    {
        lstHeader.removeAll()
        lstContent.removeAll()
        lstAgent.removeAll()
        lstAttachment.removeAll()
    }
    
    private func getMailMessagePostData(messageMode: Int, pageNumber: Int, searchText: String) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": getUserCode(), "RegionCode": getRegionCode(), "mailMode": messageMode, "pageNum": pageNumber, "pageSize": 10, "searchKeyWord": "NA"]
    }
    
    private func insertMailInLocalDB(lstMail: NSArray)
    {
        deleteExistingMails()
        
        convertToClassModels(lstMail: lstMail)
        
        DBHelper.sharedInstance.insertMailHeader(array: lstHeader)
        DBHelper.sharedInstance.insertMailContent(array: lstContent)
        DBHelper.sharedInstance.insertMailAgent(array: lstAgent)
        DBHelper.sharedInstance.insertMailAttachment(array: lstAttachment)
        
        let dbList = DBHelper.sharedInstance.getMailMessageHeader()
        
        for objHeader in dbList
        {
            DBHelper.sharedInstance.updateMsgIdIdInRefTabls(msgId: objHeader.Msg_Id, msgCode: objHeader.Msg_Code)
        }
    }
    
    private func deleteExistingMails()
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_MAIL_MSG_ATTACHMENT)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_MAIL_MSG_CONTENT)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_MAIL_MSG_AGENT)
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_MAIL_MESSAGE_HEADER)
    }
    
    private func convertToClassModels(lstMail: NSArray)
    {
        clearArray()
        
        for obj in lstMail
        {
            let dict = obj as! NSDictionary
            
            convertToMailMessageHeaderModel(dict: dict)
            convertToMailMessageContentModel(dict: dict)
            convertToMailMessageAttachmentModel(dict: dict)
            convertToMailMessageAgentModel(dict: dict)
        }
    }
    
    private func convertToMailMessageHeaderModel(dict: NSDictionary)
    {
        let headerDict: NSDictionary = ["Msg_Code": dict.value(forKey: "Msg_Code") as! String, "Date_From": dict.value(forKey: "Date_From_Format") as! String, "Sent_Type": dict.value(forKey: "Sent_Type") as! String, "Sent_Status": dict.value(forKey: "Sent_Status") as! String, "Employee_Name": dict.value(forKey: "Employee_Name") as! String, "User_Code": dict.value(forKey: "User_Code") as! String]
        
        let objHeader: MailMessageHeader = MailMessageHeader(dict: headerDict)
        
        lstHeader.append(objHeader)
    }
    
    private func convertToMailMessageContentModel(dict: NSDictionary)
    {
        let contentDict: NSDictionary = ["Msg_Code": dict.value(forKey: "Msg_Code") as! String, "Subject": dict.value(forKey: "Subject") as! String, "Message_Content": dict.value(forKey: "Message_Content") as! String]
        
        let objContent: MailMessageContent = MailMessageContent(dict: contentDict)
        
        lstContent.append(objContent)
    }
    
    private func convertToMailMessageAttachmentModel(dict: NSDictionary)
    {
        checkAttachmentAvailable(key: "Attachment_Path1", dict: dict)
        checkAttachmentAvailable(key: "Attachment_Path2", dict: dict)
        checkAttachmentAvailable(key: "Attachment_Path3", dict: dict)
        checkAttachmentAvailable(key: "Attachment_Path4", dict: dict)
        checkAttachmentAvailable(key: "Attachment_Path5", dict: dict)
    }
    
    private func checkAttachmentAvailable(key: String, dict: NSDictionary)
    {
        if (checkNullAndNilValueForString(stringData: dict.value(forKey: key) as? String) != EMPTY)
        {
            let msgCode: String = dict.value(forKey: "Msg_Code") as! String
            let blobUrl: String = dict.value(forKey: key) as! String
            let fileName: String = getFileComponent(fileName: blobUrl, separatedBy: "/")
            let attachmentLocalPath: String = getFileUrlFromDocumentsDirectory(fileName: fileName, subFolder: msgCode)
            let attachmentDict: NSDictionary = ["Msg_Code": msgCode, "Local_Attachment_Path": attachmentLocalPath, "Blob_Url": blobUrl]
            let objAttachment: MailMessageAttachment = MailMessageAttachment(dict: attachmentDict)
            
            objAttachment.AttachmentType = getAttachmentType(filePath: blobUrl)
            objAttachment.FileName = fileName
            
            lstAttachment.append(objAttachment)
        }
    }
    
    func getFileUrlFromDocumentsDirectory(fileName: String, subFolder: String) -> String
    {
        if fileName != EMPTY
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.mailAttachmentFolder)/\(subFolder)/\(fileName)")!.path
        }
        else
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.mailAttachmentFolder)/\(subFolder)")!.path
        }
    }
    
    private func getAttachmentType(filePath: String) -> String
    {
        var type: String = EMPTY
        
        if (checkNullAndNilValueForString(stringData: filePath) != EMPTY)
        {
            let fileExtension = getFileComponent(fileName: filePath, separatedBy: ".").lowercased()
            
            if (imageArray.contains(fileExtension))
            {
                type = Constants.AttachmentType.image
            }
            else if (excelArray.contains(fileExtension))
            {
                type = Constants.AttachmentType.excel
            }
            else if (wordArray.contains(fileExtension))
            {
                type = Constants.AttachmentType.word
            }
            else if (fileExtension == pdf)
            {
                type = Constants.AttachmentType.pdf
            }
            else if (fileExtension == zip)
            {
                type = Constants.AttachmentType.zip
            }
        }
        
        return type
    }
    
    private func getFileComponent(fileName: String, separatedBy: String) -> String
    {
        var component: String = EMPTY
        let componentsArr = fileName.components(separatedBy: separatedBy)
        
        if let ext = componentsArr.last
        {
            component = ext
        }
        
        return component
    }
    
    private func convertToMailMessageAgentModel(dict: NSDictionary)
    {
        if let agentArray = dict.value(forKey: "lstAgent") as? NSArray
        {
            for obj in agentArray
            {
                let dict = obj as! NSDictionary
                
                let objDict: NSDictionary = ["MsgCode": dict.value(forKey: "MsgCode") as! String, "UserCode": dict.value(forKey: "UserCode") as! String, "EmployeeName": dict.value(forKey: "EmployeeName") as! String, "AddressType": dict.value(forKey: "AddressType") as! String, "isRead": dict.value(forKey: "isRead") as! Int]
                
                let objAgent: MailMessageAgent = MailMessageAgent(dict: objDict)
                
                lstAgent.append(objAgent)
            }
        }
    }
    
    private func createResultList() -> [MailMessageWrapperModel]
    {
        var lstMailWrapperModel: [MailMessageWrapperModel] = []
        
        lstHeader = lstHeader.sorted(by: { $0.Date_From > $1.Date_From })
        let msgCodes = Set(lstHeader.map { $0.Msg_Code})
        //let uniqueMsgCodes = Array(Set(msgCodes))
        
        for msgCode in msgCodes
        {
            let objWrapper: MailMessageWrapperModel = MailMessageWrapperModel()
            var objHeader: MailMessageHeader!
            
            let filteredHeader = lstHeader.filter{
                $0.Msg_Code == msgCode
            }
            
            if (filteredHeader.count > 0)
            {
                objHeader = filteredHeader.first!
            }
            
            objWrapper.objMailMessageHeader = objHeader
            
            let filteredContent = lstContent.filter{
                $0.Msg_Code == objHeader.Msg_Code
            }
            
            if (filteredContent.count > 0)
            {
                objWrapper.objMailMessageContent = filteredContent.first
            }
            
            objWrapper.lstMailMessageAgents = []
            objWrapper.lstMailMessageAttachments = []
            
            let filteredAgent = lstAgent.filter{
                $0.Msg_Code == objHeader.Msg_Code
            }
            
            let uniqueAgent = filteredAgent.unique{$0.Target_UserCode}
            if (uniqueAgent.count > 0)
            {
                objWrapper.lstMailMessageAgents = uniqueAgent
            }
            
            let filteredAttachments = lstAttachment.filter{
                $0.Msg_Code == objHeader.Msg_Code
            }
            
            var msgAttachments: [MailMessageAttachment] = []
            
            if (filteredAttachments.count > 0)
            {
                for objAttachment in filteredAttachments
                {
                    let filteredArray = msgAttachments.filter{
                        $0.Blob_Url.uppercased() == objAttachment.Blob_Url.uppercased()
                    }
                    
                    if (filteredArray.count == 0)
                    {
                        msgAttachments.append(objAttachment)
                    }
                }
                
                objWrapper.lstMailMessageAttachments = msgAttachments
            }
            
            lstMailWrapperModel.append(objWrapper)
        }
        
        lstMailWrapperModel = lstMailWrapperModel.sorted(by: { $0.objMailMessageHeader.Date_From > $1.objMailMessageHeader.Date_From })
        
        return lstMailWrapperModel
    }
    
    func writeFile(fileData: Data, msgCode: String, blobUrl: String) -> String
    {
        if (!doesFileExist(fileName: EMPTY, subFolder: msgCode))
        {
            getAppDelegate().createSubfolder(parentFolderName: Constants.DirectoryFolders.mailAttachmentFolder, subFolderName: msgCode)
        }
        
        let fileName: String = getFileComponent(fileName: blobUrl, separatedBy: "/")
        let localPath: String = getFileUrlFromDocumentsDirectory(fileName: fileName, subFolder: msgCode)
        
        if (doesFileExist(fileName: fileName, subFolder: msgCode))
        {
            let fileManager = FileManager.default
            
            do
            {
                try fileManager.removeItem(atPath: localPath)
            }
            catch
            {
                print("Remove file error \(error)")
                return EMPTY
            }
        }
        
        do
        {
            try fileData.write(to: URL(fileURLWithPath: localPath), options: .atomic)
        }
        catch
        {
            print("Data write error \(error.localizedDescription)")
            return EMPTY
        }
        
        return localPath
    }
    
    private func doesFileExist(fileName: String, subFolder: String) -> Bool
    {
        var flag: Bool = false
        var fileURL : URL!
        
        if fileName != EMPTY
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.mailAttachmentFolder)/\(subFolder)/\(fileName)")
        }
        else
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.mailAttachmentFolder)/\(subFolder)")
        }
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: (fileURL?.path)!)
        {
            flag = true
        }
        
        return flag
    }
    func convertToUserMasterWrapperModelarray(messageHeader: MailMessageHeader) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        let objWrapperModel: UserMasterWrapperModel = UserMasterWrapperModel()
        let objUserMaster: UserMasterModel = UserMasterModel()
        objUserMaster.Employee_name = messageHeader.Sender_Employee_Name
        objUserMaster.User_Code = messageHeader.Sender_User_Code
        objUserMaster.User_Name = ""
        objUserMaster.User_Type_Name = ""
        objUserMaster.Region_Name = ""
        objWrapperModel.userObj = objUserMaster
        
        userList.append(objWrapperModel)
        return userList
    }
    
    private func convertToUserMasterWrapperModel(apiList: NSArray) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        if (apiList.count > 0)
        {
            for obj in apiList
            {
                let dict = obj as! NSDictionary
                let objWrapperModel: UserMasterWrapperModel = UserMasterWrapperModel()
                let objUserMaster: UserMasterModel = UserMasterModel()
                
                objUserMaster.Employee_name = dict.value(forKey: "Employee_Name") as! String
                objUserMaster.User_Code = dict.value(forKey: "User_Code") as! String
                objUserMaster.User_Name = dict.value(forKey: "User_Name") as! String
                objUserMaster.User_Type_Name = ""
                objUserMaster.Region_Name = ""
                
                objWrapperModel.userObj = objUserMaster
                
                userList.append(objWrapperModel)
            }
        }
        
        return userList
    }
    func convertToUserMasterWrapperModelagent(agentList: [MailMessageAgent]) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        if (agentList.count > 0)
        {
            for obj in agentList
            {
                let objWrapperModel: UserMasterWrapperModel = UserMasterWrapperModel()
                let objUserMaster: UserMasterModel = UserMasterModel()
                objUserMaster.Employee_name = obj.Target_Employee_Name as String
                objUserMaster.User_Code = obj.Target_UserCode as String
                objUserMaster.User_Name = obj.Target_Employee_Name as String
                objUserMaster.User_Type_Name = ""
                objUserMaster.Region_Name = ""
                
                objWrapperModel.userObj = objUserMaster
                
                userList.append(objWrapperModel)
            }
            
        }
        return userList
    }

}

func generateBoundaryString() -> String
{
    return "Boundary-\(NSUUID().uuidString)"
}

extension Data
{
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String)
    {
        if let data = string.data(using: .utf8)
        {
            append(data)
        }
    }
}
