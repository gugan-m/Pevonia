//
//  Bl_Attachment.swift
//  HiDoctorApp
//
//  Created by Vijay on 20/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class Bl_Attachment: NSObject
{
    static let sharedInstance = Bl_Attachment()
    
    //MARK:- Insert/Get/Delete the attachment from the DB
    func insertAttachment(attachmentName: String, attachmentSize: String)
    {
        let dict : NSDictionary = ["DCR_Visit_Code": "", "DCR_Id": DCRModel.sharedInstance.dcrId, "Visit_Id": DCRModel.sharedInstance.doctorVisitId, "Attachment_Size": attachmentSize, "Blob_Url": "", "Uploaded_File_Name": attachmentName, "DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString, "Doctor_Name": DCRModel.sharedInstance.doctorName, "Speciality_Name": DCRModel.sharedInstance.doctorSpeciality, "IsFile_Downloaded": 1]
        let attachmentModel = DCRAttachmentModel.init(dict: dict)
        DBHelper.sharedInstance.insertAttachmentDetail(dcrAttachmentModel: attachmentModel)
    }
    
    func insertTPAttachment(attachmentName: String, doctor_Id: Int, doctor_Code: String, doctor_Regioncode:String)
    {
        let dict : NSDictionary = ["TP_Entry_Id": TPModel.sharedInstance.tpEntryId,"TP_Id": 0, "Check_Sum_Id": 0, "TP_Doctor_Id": 0, "Uploaded_File_Name": attachmentName, "Blob_URL": "", "Doctor_Code": doctor_Code, "Doctor_Region_Code": doctor_Regioncode]
        let tpAttachmentModel = TPAttachmentModel.init(dict: dict)
        DBHelper.sharedInstance.insertTPAttachmentDetail(dcrAttachmentModel: tpAttachmentModel)
    }
    
    func insertChemistAttachment(attachmentName: String, attachmentSize: String)
    {
        let dict : NSDictionary = ["DCR_Id": DCRModel.sharedInstance.dcrId, "DCR_Chemist_Day_Visit_Id": ChemistDay.sharedInstance.chemistVisitId, "Blob_Url": "", "Uploaded_File_Name": attachmentName, "DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString,"IsFile_Downloaded": 1]
        let attachmentModel = DCRChemistAttachment(dict: dict)
        DBHelper.sharedInstance.insertChemistAttachmentDetail(dcrChemistAttachmentModel: attachmentModel)
    }
    
    func insertLeaveAttachment(attachmentName: String, attachmentSize: String, fromDate: Date, toDate: Date, leaveTypeCode: String, leaveTypeName: String)
    {
        let dict : NSDictionary = ["Document_Url": "", "Uploaded_File_Name": attachmentName, "DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString,"IsFile_Downloaded": 1, "Leave_Type_Code": leaveTypeCode, "Company_Code": getCompanyCode(), "User_Code": getUserCode(), "From_Date": fromDate, "To_Date": toDate, "Leave_Status": String(DCRStatus.applied.rawValue)]
        let attachmentModel = DCRLeaveModel(dict: dict)
        DBHelper.sharedInstance.insertLeaveAttachmentDetail(dcrLeaveModel: attachmentModel)
    }
    
    
    func getDCRLeaveAttachment(dcrDate: String) -> [DCRLeaveModel]?
    {
        return DBHelper.sharedInstance.getLeaveAttachmentDetails(dcrDate: dcrDate)
    }
    func getDCRLeaveAttachmentDetails() -> [DCRLeaveModel]?
    {
        return Bl_Attachment.sharedInstance.getDCRLeaveAttachment(dcrDate: DCRModel.sharedInstance.dcrDateString)
    }
    
    func getDCRAttachment(dcrId: Int, doctorVisitId: Int) -> [DCRAttachmentModel]?
    {
        return DBHelper.sharedInstance.getAttachmentDetails(dcrId: dcrId, doctorVisitId: doctorVisitId)
    }
    
    func getTPAttachment(tp_entryId: Int, doctor_Code: String) -> [TPAttachmentModel]?
    {
        return DBHelper.sharedInstance.getTPAttachmentDetails(tp_entryId: tp_entryId, doctor_Code: doctor_Code)
    }
    
    func getDCRChemistAttachment(dcrId: Int, chemistVisitId: Int) -> [DCRChemistAttachment]?
    {
        return DBHelper.sharedInstance.getChemistAttachmentDetails(dcrId: dcrId, chemistVisitId: chemistVisitId)
    }
    
    func convertToDCRAttachmentModel(list:[DCRChemistAttachment]) -> [DCRAttachmentModel]
    {
        var chemistAttachmentList : [DCRAttachmentModel] = []
        
        for attachObj in list
        {
            let dict : NSDictionary = ["DCR_Id": attachObj.DCRId,"Blob_Url": attachObj.BlobUrl, "Uploaded_File_Name": attachObj.UploadedFileName, "DCR_Actual_Date": attachObj.DCRActualDate, "IsFile_Downloaded":1,"Speciality_Name":"","Doctor_Name":"","Attachment_Size":"","Visit_Id":attachObj.DCRChemistAttachmentId]
            let chemistAttachment : DCRAttachmentModel = DCRAttachmentModel(dict: dict)
            chemistAttachmentList.append(chemistAttachment)
        }
        
        return chemistAttachmentList
    }
    
//    func convertToDCRLeaveAttachmentModel(list:[DCRLeaveModel]) -> [DCRAttachmentModel]
//    {
//        var leaveAttachmentList : [DCRAttachmentModel] = []
//
//        for attachObj in list
//        {
//            let dict : NSDictionary = ["Document_Url": attachObj.documentUrl!, "Uploaded_File_Name": attachObj.attachmentName!, "DCR_Actual_Date": attachObj.dcrDate, "IsFile_Downloaded":1,"Attachment_Size":""]
//            let leaveAttachment : DCRAttachmentModel = DCRAttachmentModel(dict: dict)
//            leaveAttachmentList.append(leaveAttachment)
//        }
//
//        return leaveAttachmentList
//    }
//
    func deleteTPAttachment(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.deleteTpAttachment(tp_ID: id,attachment_Name: fileName)
        deleteAttachmentFile(fileName: fileName)
    }

    func deleteAttachment(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.deleteAttachment(attachmentId: id)
        deleteAttachmentFile(fileName: fileName)
    }
    //deleteLeaveAttachment
    
    func deleteLeaveAttachment(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.deleteLeaveAttachment(attachmentId: id)
        deleteAttachmentFile(fileName: fileName)
    }
    
    
    func deleteChemistAttachment(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.deleteChemistAttachment(attachmentId: id)
        deleteAttachmentFile(fileName: fileName)
    }
    
    func getAttachmentCount() -> Int
    {
        return DBHelper.sharedInstance.getAttachmentCountPerDoctor(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
    }
    
    func getTPAttachmentCount() -> Int
    {
        return DBHelper.sharedInstance.getTPAttachmentCountPerDoctor(TP_Id: TPModel.sharedInstance.tpId, TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
    }
    
    func getChemistAttachmentCount() -> Int
    {
        return DBHelper.sharedInstance.getAttachmentCountPerChemist(dcrId: DCRModel.sharedInstance.dcrId, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
    }
    
    func getLeaveAttachmentCount() -> Int
    {
        return DBHelper.sharedInstance.getAttachmentCountForLeave(dcrDate: DCRModel.sharedInstance.dcrDateString)
    }
    
    
    func updateAttachmentDownloadStatus(id: Int, isDownloaded: Int)
    {
        DBHelper.sharedInstance.updateAttachmentDownloadStatus(attachmentId: id, isDownloaded: isDownloaded)
    }
    
    func updateChemsistAttachmentDownloadStatus(id: Int, isDownloaded: Int)
    {
        DBHelper.sharedInstance.updateAttachmentDownloadStatus(attachmentId: id, isDownloaded: isDownloaded)
    }
    
    func updateLeaveAttachmentDownloadStatus(id: Int, isDownloaded: Int)
    {
        DBHelper.sharedInstance.updateLeaveAttachmentDownloadStatus(attachmentId: id, isDownloaded: isDownloaded)
    }
    
    func updateAttachmentName(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.updateAttachmentName(attachmentId: id, fileName: fileName)
    }
    
    //updateLeaveAttachmentName
    func updateLeaveAttachmentName(id: Int, fileName: String)
    {
        DBHelper.sharedInstance.updateLeaveAttachmentName(attachmentId: id, fileName: fileName)
    }
    
    func updateAttendanceStatus(id: Int, status: Int, attachmentModel: [DCRAttachmentModel], isChemistAttachment: Bool) -> [DCRAttachmentModel]
    {
        let modelList : [DCRAttachmentModel] = attachmentModel
        let filteredArray = modelList.filter{
            $0.attachmentId == id && $0.isChemistAttachment == isChemistAttachment
        }
        
        if (filteredArray.count > 0)
        {
            filteredArray.first!.isSuccess = status
        }
        
        return modelList
    }
    
    func updateTPAttachmentStatus(id: Int, status: Int, attachmentModel: [TPAttachmentModel]) -> [TPAttachmentModel]
    {
        let modelList : [TPAttachmentModel] = attachmentModel
        let filteredArray = modelList.filter{
            $0.attachmentId == id
        }
        
        if (filteredArray.count > 0)
        {
            filteredArray.first!.isSuccess = status
        }
        
        return modelList
    }
    
    //MARK:- Convert MB to KB to Bytes
    func convertToBytes(number: Float) -> String
    {
        if number >= 1.0
        {
            return String(format: "%.2f MB", number)
        }
        else
        {
            let kbConversion = number * 1024
            if kbConversion >= 1.0
            {
                return String(format: "%.2f KB", kbConversion)
            }
            else
            {
                let byteConversion = kbConversion * 1024
                return String(format: "%.2f B", byteConversion)
            }
        }
    }
    
    //MARK:- Document directory - Get/Save/Delete files
    private func attachmentFileInDocumentsDirectory(fileName: String) -> String
    {
        let fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.attachmentFolder)/\(fileName)")
        return fileURL!.path
    }
    
    private func checkFileNameExists(fileName: String) -> Bool
    {
        var flag: Bool = false
        
        let fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.attachmentFolder)/\(fileName)")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: (fileURL?.path)!)
        {
            flag = true
        }
        
        return flag
    }
    
    func saveAttachmentFile(fileData: Data, fileName: String)
    {
        let fileURL = attachmentFileInDocumentsDirectory(fileName: fileName)
        do
        {
            try fileData.write(to: URL(fileURLWithPath: fileURL), options: .atomic)
        }
        catch
        {
            print("Data write error \(error.localizedDescription)")
        }
    }
    
    func deleteAttachmentFile(fileName: String)
    {
        if checkFileNameExists(fileName: fileName)
        {
            let fileManager = FileManager.default

            let deletableFileURL = attachmentFileInDocumentsDirectory(fileName: fileName)
            do
            {
                try fileManager.removeItem(atPath: deletableFileURL)
            }
            catch
            {
                print("Remove file error \(error)")
            }
        }
    }
    
    func getAttachmentFileURL(fileName: String) -> String
    {
        var outputFileName: String = ""
        
        if checkFileNameExists(fileName: fileName)
        {
            outputFileName = attachmentFileInDocumentsDirectory(fileName: fileName)
        }
        
        return outputFileName
    }
    
    //MARK:- Image Resizing methods
    func thumbImageResize(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imageResize(imageObj:UIImage)-> UIImage?
    {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        let maxSize : CGFloat = 480
        let imageSize = imageObj.size
        var sizeChange:CGSize
        sizeChange = imageObj.size
        if (imageSize.width > maxSize || imageSize.height > maxSize) {
            if (imageSize.width > imageSize.height) {
                sizeChange.width = maxSize;
                sizeChange.height = (imageSize.height*maxSize)/imageSize.width;
            } else {
                sizeChange.height = maxSize;
                sizeChange.width = (imageSize.width*maxSize)/imageSize.height;
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let scaledImgData =  UIImagePNGRepresentation(scaledImage!)
        if scaledImgData != nil {
            let imgData = NSData(data:scaledImgData!)
            let convertedImage = UIImage(data: imgData as Data)
            if convertedImage != nil {
                return convertedImage!
            }
            return scaledImage!
        }
        return scaledImage!
    }
    
    //MARK:- Blob file upload - Get File Content Type
    func getFileContentType(fileExtension: String) ->  String
    {
        var contentType : String!
        
        switch fileExtension {
        case png:
            contentType = "image/\(png)"
        case jpg:
            contentType = "image/\(jpg)"
        case jpeg:
            contentType = "image/\(jpeg)"
        case bmp:
            contentType = "image/x-ms-bmp"
        case gif:
            contentType = "image/\(gif)"
        case tif:
            contentType = "image/\(tif)"
        case tiff:
            contentType = "image/\(tiff)"
        case pdf:
            contentType = "image/\(pdf)"
        case docx:
            contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case doc:
            contentType = "application/msword"
        case xls:
            contentType = "application/vnd.ms-excel"
        case xlsx:
            contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        default:
            contentType = "application/octet-stream"
        }
        
        return contentType
    }
    
    func loadAttachmentImg(urlString: String, completion: @escaping (_ data: Data?, _ url: String) -> ())
    {
        if let imageUrl = urlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet)
        {
            if let url = URL(string: imageUrl)
            {
                URLSession.shared.dataTask(with: url) {(data, response, error) in
                    
                    if error != nil
                    {
                        completion(nil, urlString)
                        return
                    }
                    
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            completion(data, urlString)
                        }
                        else
                        {
                            completion(nil, urlString)
                        }
                    }
                    else
                    {
                        completion(nil, urlString)
                    }
                    }.resume()
            }
            else
            {
                completion(nil, urlString)
            }
        }
        else
        {
            completion(nil, urlString)
        }
    }
}
