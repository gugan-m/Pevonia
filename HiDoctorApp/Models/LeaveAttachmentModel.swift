//
//  LeaveAttachmentModel.swift
//  HiDoctorApp
//
//  Created by Administrator on 09/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRLeaveModel: Record
{
    var attachmentId: Int!
    //var DCRId : Int!
    
    var fromdate: String!
    var toDate: String!
    var leaveTypeCode: String?
    var dcrDate: String!
    
    var attachmentName: String?
    var attachmentSize: String?
    var attachmentBlobUrl: String? //use only if required
    var leaveStatus: String?
    
    var noOfDays: String! // TOTAL NO.OF.DAYS LEAVE TAKEN
    var isSuccess: Int! //isuploaded
    var isFileDownloaded: Int!
    var documentUrl: String?
    
    //var Is_Success: Int = 0 - chemist
    //var isChemistAttachment: Bool = false

    init(dict: NSDictionary)
    {
        //self.DCRId = dict.value(forKey: "DCR_Id") as? Int ?? 0
        self.fromdate = dict.value(forKey: "From_Date") as? String
        self.toDate = dict.value(forKey: "To_Date") as? String
        self.leaveTypeCode = dict.value(forKey: "Leave_Type_Code") as? String
       
        if let dcrDate = dict.value(forKey: "DCR_Actual_Date") as? String
        {
            self.dcrDate = dcrDate
        }
        else
        {
            self.dcrDate = ""
        }
        self.attachmentBlobUrl = dict.value(forKey: "Blob_Url") as? String
        
        
        self.attachmentName = dict.value(forKey: "Uploaded_File_Name") as? String
        if let sizeVal = dict.value(forKey: "Attachment_Size")
        {
            self.attachmentSize = sizeVal as? String
        }
        else
        {
            self.attachmentSize = ""
        }
        
        self.leaveStatus = dict.value(forKey: "Leave_Status") as? String
        self.noOfDays = dict.value(forKey: "Number_Of_Days") as? String
        self.documentUrl = dict.value(forKey: "Document_Url") as? String
        
       

        self.isSuccess = -1

        if let fileDownloaded = dict.value(forKey: "IsFile_Downloaded")
        {
            self.isFileDownloaded = fileDownloaded as! Int
        }
        else
        {
            self.isFileDownloaded = -1
        }

        super.init()
    }

    override class var databaseTableName: String
    {
        return TRAN_DCR_LEAVE_ATTACHMENT
    }

    required init(row: Row)
    {
        attachmentId = row["Attachment_Id"]
       // DCRId = row["DCR_Id"]
        fromdate = row["From_Date"]
        toDate = row["To_Date"]
        leaveTypeCode = row["Leave_Type_Code"]
        leaveStatus = row["Leave_Status"]
        attachmentSize = row["Attachment_Size"]
        attachmentBlobUrl = row["Blob_Url"]
        attachmentName = row["Uploaded_File_Name"]
        dcrDate = row["DCR_Actual_Date"]
        documentUrl = row["Document_Url"]
        noOfDays = row["Number_Of_Days"]
        isSuccess = row["Is_Success"]
        isFileDownloaded = row["IsFile_Downloaded"]

        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {

        container["Attachment_Id"] =  attachmentId
       // container["DCR_Id"] = DCRId
        container["From_Date"] = fromdate
        container["To_Date"] = toDate
        container["Leave_Type_Code"] = leaveTypeCode
        container["Leave_Status"] =  leaveStatus
        container["Attachment_Size"] =  attachmentSize
        container["Blob_Url"] =  attachmentBlobUrl
        container["Uploaded_File_Name"] =  attachmentName
        container["DCR_Actual_Date"] =  dcrDate
        container["Document_Url"] =  documentUrl
        container["Number_Of_Days"] =  noOfDays
        container["Is_Success"] =  isSuccess
        container["IsFile_Downloaded"] =  isFileDownloaded
    }

}
