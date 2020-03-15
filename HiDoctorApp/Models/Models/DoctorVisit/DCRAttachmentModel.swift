//
//  DCRAttachmentModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 05/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRAttachmentModel: Record
{
    var attachmentId: Int!
    var dcrVisitCode: String?
    var dcrId: Int!
    var dcrCode: String?
    var doctorVisitId: Int!
    var attachmentSize: String?
    var attachmentBlobUrl: String?
    var attachmentName: String?
    var dcrDate: String!
    var doctorName: String!
    var doctorSpecialityName: String!
    var isSuccess: Int!
    var isFileDownloaded: Int!
    var isChemistAttachment: Bool = false
    
    init(dict: NSDictionary)
    {
        self.dcrVisitCode = dict.value(forKey: "DCR_Visit_Code") as? String
        self.dcrId = dict.value(forKey: "DCR_Id") as! Int
        self.dcrCode = dict.value(forKey: "DCR_Code") as? String
        self.doctorVisitId = dict.value(forKey: "Visit_Id") as! Int
        if let sizeVal = dict.value(forKey: "Attachment_Size")
        {
            self.attachmentSize = sizeVal as? String
        }
        else
        {
            self.attachmentSize = ""
        }
        self.attachmentBlobUrl = dict.value(forKey: "Blob_Url") as? String
        self.attachmentName = dict.value(forKey: "Uploaded_File_Name") as? String
        if let dcrDate = dict.value(forKey: "DCR_Actual_Date") as? String
        {
            self.dcrDate = dcrDate
        }
        else
        {
            self.dcrDate = ""
        }
        if let doctorName = dict.value(forKey: "Doctor_Name")
        {
            self.doctorName = doctorName as! String
        }
        else
        {
            self.doctorName = ""
        }
        if let specialityName = dict.value(forKey: "Speciality_Name")
        {
            self.doctorSpecialityName = specialityName as! String
        }
        else
        {
            self.doctorSpecialityName = ""
        }
        
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
        return TRAN_DCR_DOCTOR_VISIT_ATTACHMENT
    }
    
    required init(row: Row)
    {
        attachmentId = row["Id"]
        dcrVisitCode = row["DCR_Doctor_Visit_Code"]
        dcrId = row["DCR_Id"]
        dcrCode = row["DCR_Code"]
        doctorVisitId = row["DCR_Doctor_Visit_Id"]
        attachmentSize = row["Attachment_Size"]
        attachmentBlobUrl = row["Blob_Url"]
        attachmentName = row["Uploaded_File_Name"]
        dcrDate = row["DCR_Actual_Date"]
        doctorName = row["Doctor_Name"]
        doctorSpecialityName = row["Speciality_Name"]
        isSuccess = row["Is_Success"]
        isFileDownloaded = row["IsFile_Downloaded"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] =  attachmentId
        container["DCR_Doctor_Visit_Code"] =  dcrVisitCode
        container["DCR_Id"] =  dcrId
        container["DCR_Code"] = dcrCode
        container["DCR_Doctor_Visit_Id"] =  doctorVisitId
        container["Attachment_Size"] =  attachmentSize
        container["Blob_Url"] =  attachmentBlobUrl
        container["Uploaded_File_Name"] =  attachmentName
        container["DCR_Actual_Date"] =  dcrDate
        container["Doctor_Name"] =  doctorName
        container["Speciality_Name"] =  doctorSpecialityName
        container["Is_Success"] =  isSuccess
        container["IsFile_Downloaded"] =  isFileDownloaded
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": attachmentId,
//            "DCR_Doctor_Visit_Code": dcrVisitCode,
//            "DCR_Id": dcrId,
//            "DCR_Code":dcrCode,
//            "DCR_Doctor_Visit_Id": doctorVisitId,
//            "Attachment_Size": attachmentSize,
//            "Blob_Url": attachmentBlobUrl,
//            "Uploaded_File_Name": attachmentName,
//            "DCR_Actual_Date": dcrDate,
//            "Doctor_Name": doctorName,
//            "Speciality_Name": doctorSpecialityName,
//            "Is_Success": isSuccess,
//            "IsFile_Downloaded": isFileDownloaded
//        ]
//    }
}


class TPAttachmentModel: Record
{
    var attachmentId: Int?
    var attachmentSize: String?
    var isSuccess: Int!
    var isFileDownloaded: Int!
    var tpChecksumId: Int?
    var tpDoctorId: Int?
    var tpDoctorCode: String?
    var tpDoctorRegionCode: String?
    var attachmentBlobUrl: String?
    var tpId: Int!
    var attachmentName: String?
    
    
    init(dict: NSDictionary)
    {
        self.tpId = (dict.value(forKey: "TP_Id") as! Int)
        self.tpChecksumId = (dict.value(forKey: "Check_Sum_Id") as! Int)
        self.tpDoctorId = (dict.value(forKey: "TP_Doctor_Id") as! Int)
        self.attachmentName = dict.value(forKey: "Uploaded_File_Name") as? String
        self.attachmentBlobUrl = dict.value(forKey: "Blob_URL") as? String
        self.tpDoctorCode = dict.value(forKey: "Doctor_Code") as? String
        self.tpDoctorRegionCode = dict.value(forKey: "Doctor_Region_Code") as? String
       if let id = dict.value(forKey: "TP_Doctor_Attachment_Id") as? Int{
            self.attachmentId = id
       } else {
        self.attachmentId = 0
        }
        if let success = dict.value(forKey: "Is_Success") as? Int {
            self.isSuccess = success
        } else {
            self.isSuccess = 0
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_TP_DOCTOR_VISIT_ATTACHMENT
    }
    
    required init(row: Row)
    {
        tpChecksumId = row["Check_Sum_Id"]
        tpDoctorId = row["TP_Doctor_Id"]
        tpId = row["TP_Id"]
        attachmentName = row["Uploaded_File_Name"]
        attachmentBlobUrl = row["Blob_URL"]
        tpDoctorCode = row["Doctor_Code"]
        tpDoctorRegionCode = row["Doctor_Region_Code"]
        attachmentId = row["TP_Doctor_Attachment_Id"]
        isSuccess = row["Is_Success"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Check_Sum_Id"] =  tpChecksumId
        container["TP_Doctor_Id"] =  tpDoctorId
        container["TP_Id"] =  tpId
        container["Uploaded_File_Name"] = attachmentName
        container["Blob_URL"] =  attachmentBlobUrl
        container["Doctor_Code"] =  tpDoctorCode
        container["Doctor_Region_Code"] =  tpDoctorRegionCode
        container["TP_Doctor_Attachment_Id"] = attachmentId
        container["Is_Success"] = isSuccess
    }
}
