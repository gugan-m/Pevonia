//
//  BL_Logout.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class BL_Logout: NSObject
{
    static let sharedInstance = BL_Logout()
    
    func getPendingDCRCount() -> Int
    {
        return DBHelper.sharedInstance.getPendingDCRCount()
    }
    
    func getPendingTPCount() -> Int
    {
        return DBHelper.sharedInstance.getPendingTPCount()
    }
    
    func clearAllData()
    {
        clearAllDirectories()
        getAppDelegate().createDirectoryFolders()
        clearAllUserDefaults()
        clearAllCache()
        clearAllSharedInstances()
        clearAllLocalNotifications()
        clearAllTables()
        DatabaseMigration.sharedInstance.doV1Migration()
    }
    
    func logout(companyCode: String, companyId: String, userCode: String,sessionId: String ,completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.logout(companyCode: companyCode, companyId: companyId, userCode: userCode, sessionId: sessionId) { (logoutData) in
            completion(logoutData)
        }
    }
    
    private func clearAllUserDefaults()
    {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    private func clearAllCache()
    {
        ImageLoadingWithCache.sharedInstance.cache.removeAllObjects()
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies
        {
            for cookie in cookies
            {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    private func clearAllSharedInstances()
    {
        BL_Stepper.sharedInstance.clearAllArray()
        BL_DCR_Attendance_Stepper.sharedInstance.clearAllArray()
        BL_POB_Stepper.sharedInstance.clearAllArray()
        BL_TPCalendar.sharedInstance.clearAllArray()
        BL_TPStepper.sharedInstance.clearAllArray()
        BL_TP_AttendanceStepper.sharedInstance.clearAllArray()
        BL_TP_CopyTpStepper.sharedInstance.clearArray()
        BL_Mail_Message.sharedInstance.clearArray()
        BL_InitialSetup.sharedInstance.clearAllValues()
        BL_AssetDownloadOperation.sharedInstance.clearAllValues()
        BL_Common_Stepper.sharedInstance.clearAllValues()
        BL_Chemist_AttachmentOperation.sharedInstance.clearAllArray()
        BL_Dashboard.sharedInstance.clearAllValues()
        BL_DCR_Doctor_Visit.sharedInstance.clearAllArray()
        BL_DCRCalendar.sharedInstance.clearAllArray()
        BL_DoctorList.sharedInstance.clearAllArray()
        BL_NoticeBoard.sharedInstance.clearAllArray()
        BL_TPCalendar.sharedInstance.clearAllValues()
        BL_TpReport.sharedInstance.clearAllArray()
        PrivilegesAndConfigSettings.sharedInstance.clearAllArray()
        BL_UploadFeedback.sharedInstance.clearAllArray()
        BL_UploadDoctorVisitFeedback.sharedInstance.clearAllArray()
        BL_UploadAnalytics.sharedInstance.clearAllArray()
        BL_Upload_DCR.sharedInstance.clearAllArray()
        BL_Activity_Stepper.sharedInstance.clearAllArray()
    }
    
    func clearAllLocalNotifications()
    {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    private func clearAllDirectories()
    {
        let fileManager = FileManager.default
        var pathList: [String] = []
        let documentUrl = getDocumentsURL()
        
        pathList.append(documentUrl.appendingPathComponent("\(Constants.DirectoryFolders.attachmentFolder)")!.path)
        pathList.append(documentUrl.appendingPathComponent("\(Constants.DirectoryFolders.assetFolder)")!.path)
        pathList.append(documentUrl.appendingPathComponent("\(Constants.DirectoryFolders.noticeboardAttachmentFolder)")!.path)
        pathList.append(documentUrl.appendingPathComponent("\(Constants.DirectoryFolders.mailAttachmentFolder)")!.path)
        
        for path in pathList
        {
            if fileManager.fileExists(atPath: (path))
            {
                do
                {
                    try fileManager.removeItem(atPath: path)
                }
                catch
                {
                    print("Remove file error \(error)")
                }
            }
        }
    }
    
    private func clearAllTables()
    {
        let tablesList: [Row] = DBHelper.sharedInstance.getAllTableNames()
        
        for row in tablesList
        {
            let tableName: String = row["Table_Name"] as! String
            
            if (tableName.uppercased() != MST_VERSION_UPGRADE_INFO.uppercased())
            {
                DBHelper.sharedInstance.deleteFromTable(tableName: tableName)
            }
        }
        
//        let fileManager = FileManager.default
//        let path = getDBPath()
//        
//        if fileManager.fileExists(atPath: (path))
//        {
//            do
//            {
//                try fileManager.removeItem(atPath: path)
//            }
//            catch
//            {
//                print("Remove file error \(error)")
//            }
//        }
    }
}
