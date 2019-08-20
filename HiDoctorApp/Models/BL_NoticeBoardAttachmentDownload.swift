//
//  BL_NoticeBoardAttachmentDownload.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_NoticeBoardAttachmentDownload: NSObject {
    
    static let sharedInstance = BL_NoticeBoardAttachmentDownload()
    
    //MARk:- Download Attachment
    func downloadAttachment(url:String ,completion: @escaping (_ data:Data?) -> ())
    {
        let encodedUrl  = url.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
        let noticeUrl = URL(string: encodedUrl!)
        WebServiceWrapper.sharedInstance.getDataFromUrl(url: noticeUrl!){ (data) in
            completion(data)
    }
    }
    //MARK:- Save Attachment file
        func saveAttachment(fileData:Data,fileName:String)
    {
    
        let  fileURL = noticeAssetFileInDocumentsDirectory(fileName: fileName)
        do
        {
            try fileData.write(to: URL(fileURLWithPath: fileURL), options: .atomic)
        }
        catch
        {
            print("Data write error \(error.localizedDescription)")
        }
       
    }
    //MARK:- Get attachment path
     func noticeAssetFileInDocumentsDirectory(fileName: String) -> String
    {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.noticeboardAttachmentFolder)/\(fileName)")!.path
        }
    func checkFileNameExists(fileName: String) -> Bool
    {
        var flag: Bool = false
        let fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.noticeboardAttachmentFolder)/\(fileName)")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: (fileURL?.path)!)
            {
                flag = true
            }
        return flag
    }

}

