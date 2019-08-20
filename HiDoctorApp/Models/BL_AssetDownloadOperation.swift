//
//  BL_AssetDownloadOperation.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Zip

class BL_AssetDownloadOperation: NSObject {

    static let sharedInstance = BL_AssetDownloadOperation()
    var queue = OperationQueue()
    var assetList: [AssetHeader] = []
    var statusList : [FileStatus] = []
    var downloadFailed: Bool = false
    var totalAssetCount = Int()
    var visibleLanding = Bool()
    var failedRetryCount : Int = 0
    
    func initiateOperation()
    {
        let filteredAssetList : [AssetHeader] = DBHelper.sharedInstance.getAssetsByDownloadStatus(downloadStatus: isFileDownloaded.progress.rawValue)
        
        if statusList.count > 0
        {
            statusList = []
        }
        
        for model in filteredAssetList
        {
            let statusModel = FileStatus()
            statusModel.fileId = model.daCode
            statusModel.status = false
            statusList.append(statusModel)
            
            print("Image download starts")
            imageDownload(model: model)
        }
    }
    
    func imageDownload(model: AssetHeader)
    {
        if let imageUrl = model.onlineUrl.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet)
        {
            if let url = URL(string: imageUrl)
            {
                if checkInternetConnectivity()
                {
                    let blockOperation = BlockOperation(block:
                    {
                        URLSession.shared.dataTask(with: url) {(data, response, error) in
                            
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
                                        self.failedRetryCount += 1
                                        if(self.failedRetryCount <= 3)
                                        {
                                            self.initiateOperation()
                                        }
                                        else
                                        {
                                            self.updateFailureStatus(model: model)
                                            self.failedRetryCount = 0
                                        }
                                    }
                                }
                                else
                                {
                                    if data != nil
                                    {
                                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                        {
                                            let assetFileData = data
                                            if model.thumbnailUrl != ""
                                            {
                                                if let assetThumbnailUrl = model.thumbnailUrl.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet)
                                                {
                                                    if let url = URL(string: assetThumbnailUrl)
                                                    {
                                                        if checkInternetConnectivity()
                                                        {
                                                            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                                                                URLSession.shared.dataTask(with: url) {(data, response, error) in
                                                                    DispatchQueue.main.async(execute: {
                                                                        if data != nil
                                                                        {
                                                                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                                                            {
                                                                                self.failedRetryCount = 0
                                                                                self.saveAssetFileInDB(fileData: assetFileData!, model: model)
                                                                                let fileNameSplittedString = model.thumbnailUrl.components(separatedBy: ".")
                                                                                if fileNameSplittedString.count > 0
                                                                                {
                                                                                    let fileName = "\(model.daCode!)-Thumbnail.\(fileNameSplittedString.last!)"
                                                                                    self.saveAssetFile(fileData: data!, fileName: fileName, subFolder: "\(model.daCode!)")
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
                                                                    })
                                                                }.resume()
                                                            }
                                                        }
                                                        else
                                                        {
                                                            self.showInternetErrorToast()
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
                                                self.saveAssetFileInDB(fileData: assetFileData!, model: model)
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
                            
                            }.resume()
                        
                    })
                    queue.addOperation(blockOperation)
                }
                else
                {
                    self.showInternetErrorToast()
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
    
    func saveAssetFileInDB(fileData: Data, model: AssetHeader)
    {
        let fileNameSplittedString = model.onlineUrl.components(separatedBy: "/")
        if fileNameSplittedString.count > 0
        {
            let fileName = fileNameSplittedString.last
            self.saveAssetFile(fileData: fileData, fileName: fileName!, subFolder: "\(model.daCode!)")
            let fileExtensionArr = fileName?.components(separatedBy: ".")
            if (fileExtensionArr?.count)! > 0
            {
                let fileExt = fileExtensionArr?.last
                if fileExt == zip
                {
                    self.saveUnzipHTMLFile(fileName: (fileExtensionArr?.first)!, subFolder: "\(model.daCode!)", model: model)
                }
                else
                {
                    DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: isFileDownloaded.completed.rawValue, fileName: fileName!, daCode: model.daCode)
                    BL_AssetModel.sharedInstance.updateDownloadedAsset(daCode: model.daCode, offlineUrl: fileName!, docType: model.docType, isDownloaded: isFileDownloaded.completed.rawValue)
                    self.updateSuccessStatus(model: model)
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
    
    func showInternetErrorToast()
    {
        if self.statusList.count > 0
        {
            self.statusList = []
        }
        showToastView(toastText: assetInternetDropOffMsg)
       
        if(BL_AssetDownloadOperation.sharedInstance.visibleLanding)
        {
            if(ifBannerIntialized())
            {
                dismissBanner()
            }
            DispatchQueue.main.async {
            showBanner(title: "Sorry", subTitle: assetInternetDropOffMsg, bgColor: BannerColors.red)
            }
        }
    }
    
    func updateFailureStatus(model: AssetHeader)
    {
        downloadFailed = true
        DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: isFileDownloaded.pending.rawValue, fileName: "", daCode: model.daCode)
        BL_AssetModel.sharedInstance.updateDownloadedAsset(daCode: model.daCode, offlineUrl: "", docType: model.docType, isDownloaded: isFileDownloaded.pending.rawValue)
        self.updateStatusInitiateOperation(fileId: model.daCode)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: assetNotification), object: nil, userInfo: nil)
    }
    
    func updateSuccessStatus(model: AssetHeader)
    {
        self.updateStatusInitiateOperation(fileId: model.daCode)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: assetNotification), object: nil, userInfo: nil)
    }
    
    func updateStatusInitiateOperation(fileId: Int)
    {
        self.updateFileStatus(fileId: fileId)
        
        if self.checkFileStatusCompleted()
        {
            if(checkInternetConnectivity())
            {
                if(ifBannerIntialized())
                {
                    if(BL_AssetDownloadOperation.sharedInstance.totalAssetCount > 0)
                    {
                        BL_AssetDownloadOperation.sharedInstance.totalAssetCount -= 1
                        let title =  String(BL_AssetDownloadOperation.sharedInstance.totalAssetCount) + " Assets"
                        DispatchQueue.main.async {
                            if(ifBannerIntialized())
                            {
                                if(BL_AssetDownloadOperation.sharedInstance.totalAssetCount > 0)
                                {
                                    bannerTitle(title: title )
                                }
                            }
                        }
                    }
                }
            }
            print("Cycle completed")
            if DBHelper.sharedInstance.getAssetsByDownloadStatus(downloadStatus: isFileDownloaded.progress.rawValue).count > 0
            {
                self.initiateOperation()
            }
            else
            {
                if(ifBannerIntialized())
                {
                    dismissBanner()
                }
                if self.statusList.count > 0
                {
                    self.statusList = []
                }
                
                if downloadFailed == true
                {
                    showToastView(toastText: assetDownloadFailedMsg)
                    BL_AssetDownloadOperation.sharedInstance.totalAssetCount = 0
                    //                    showBanner(title: "Sorry", subTitle: assetDownloadFailedMsg, color: BannerColors.red)
                }
                else
                {
                    //                    if(BL_AssetDownloadOperation.sharedInstance.visibleLanding)
                    //                    {
                    //                        if(ifBannerIntialized())
                    //                        {
                    //                            dismissBanner()
                    //                        }
                    //                        DispatchQueue.main.async {
                    //                            showBanner(title: "Success", subTitle: "Asset Downloaded", color: BannerColors.yellow)
                    //                        }
                    //                    }
                    BL_AssetDownloadOperation.sharedInstance.totalAssetCount = 0
                    
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
    
    func saveAssetFile(fileData: Data, fileName: String, subFolder: String)
    {
        getAppDelegate().createSubfolder(parentFolderName: Constants.DirectoryFolders.assetFolder, subFolderName: subFolder)
        
        let fileURL = assetFileInDocumentsDirectory(fileName: fileName, subFolder: subFolder)
        do
        {
            try fileData.write(to: URL(fileURLWithPath: fileURL), options: .atomic)
        }
        catch
        {
            print("Data write error \(error.localizedDescription)")
        }
    }
    
    func getAssetFileURL(fileName: String, subFolder: String) -> String
    {
        var outputFileName: String = ""
        
        if checkFileNameExists(fileName: fileName, subFolder: subFolder)
        {
            outputFileName = assetFileInDocumentsDirectory(fileName: fileName, subFolder: subFolder)
        }
        
        return outputFileName
    }
    
    func getAssetThumbnailURL(model: AssetHeader) -> String
    {
        var outputFileName: String = ""
        
        let fileNameSplittedString = model.thumbnailUrl.components(separatedBy: ".")
        if fileNameSplittedString.count > 0
        {
            let fileExt = fileNameSplittedString.last!
            let fileName = "\(model.daCode!)-Thumbnail.\(fileExt)"
            let subFolder = "\(model.daCode!)"
            if checkFileNameExists(fileName: fileName, subFolder: subFolder)
            {
                outputFileName = assetFileInDocumentsDirectory(fileName: fileName, subFolder: subFolder)
            }
        }
        
        return outputFileName
    }
    
    func getHTMLFileURL(fileName: String, subFolder: String,startHtmlPage : String) -> String
    {
        var outputFileName: String = ""
        
        let fileExtensionArr = fileName.components(separatedBy: ".")
        if fileExtensionArr.count > 0
        {
            if fileExtensionArr.last == zip
            {
                if checkFileNameExists(fileName: fileName, subFolder: subFolder)
                {
                    outputFileName = assetFileInDocumentsDirectory(fileName:  startHtmlPage, subFolder: subFolder)
                }
            }
        }
        
        return outputFileName
    }
    
    func deleteAssetFile(fileName: String, subFolder: String)
    {
        if checkFileNameExists(fileName: fileName, subFolder: subFolder)
        {
            let fileManager = FileManager.default
            
            let deletableFileURL = assetFileInDocumentsDirectory(fileName: fileName, subFolder: subFolder)
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
    
    func saveUnzipHTMLFile(fileName: String, subFolder: String, model: AssetHeader)
    {
        let modifiedFileName = "\(fileName).zip"
        let zipFilePath = assetFileInDocumentsDirectory(fileName: modifiedFileName, subFolder: "\(model.daCode!)")
        let unZipFilePath = assetFileInDocumentsDirectory(fileName: "", subFolder: "\(model.daCode!)")
        
        if (URL(string: zipFilePath) != nil && URL(string: unZipFilePath) != nil)
        {
            DispatchQueue.global(qos: .background).async
                { () in
                    
                    do {
                        
                        try Zip.unzipFile(URL(string: zipFilePath)!, destination: URL(string: unZipFilePath)!, overwrite: true, password: "", progress: { (progress) -> () in
                                if progress == 1.0
                                {
                                    DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: isFileDownloaded.completed.rawValue, fileName: modifiedFileName, daCode: model.daCode)
                                     BL_AssetModel.sharedInstance.updateDownloadedAsset(daCode: model.daCode, offlineUrl: modifiedFileName, docType: model.docType, isDownloaded: isFileDownloaded.completed.rawValue)
                                    self.updateSuccessStatus(model: model)
                            }
                        })
                        
                    }
                    catch {
                        print("Unzip HTML went wrong")
                        self.updateFailureStatus(model: model)
                    }
                    
                    DispatchQueue.main.async(execute: {() in
                    })
            }
        }
        else
        {
            self.updateFailureStatus(model: model)
        }
    }
    
    private func assetFileInDocumentsDirectory(fileName: String, subFolder: String) -> String
    {
        if fileName != EMPTY
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.assetFolder)/\(subFolder)/\(fileName)")!.path
        }
        else
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.assetFolder)/\(subFolder)")!.path
        }
    }
    
    private func checkFileNameExists(fileName: String, subFolder: String) -> Bool
    {
        var flag: Bool = false
        var fileURL : URL!
        
        if fileName != EMPTY
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.assetFolder)/\(subFolder)/\(fileName)")
        }
        else
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.assetFolder)/\(subFolder)")
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: (fileURL?.path)!)
        {
            flag = true
        }
        
        return flag
    }
    func clearAllValues()
    {
        queue.cancelAllOperations()
        self.queue = OperationQueue()
        self.assetList = []
        self.statusList = []
        self.downloadFailed = false
        self.totalAssetCount = 0
        self.visibleLanding = false
        self.failedRetryCount = 0
    }
}
