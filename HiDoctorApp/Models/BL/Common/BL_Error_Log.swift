//
//  BL_Error_Log.swift
//  HiDoctorApp
//
//  Created by SwaaS on 18/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class BL_Error_Log: NSObject
{
    static let sharedInstance = BL_Error_Log()
    
    func LogError(moduleName: String, subModuleName: String, screenName: String, controlName: String, additionalInfo: NSDictionary, exception: NSException)
    {
        //Log_Id INTEGER PRIMARY KEY AUTOINCREMENT, Event_Id INTEGER, Priority INTEGER, Severity TEXT, Timestamp TEXT, MachineName TEXT, AppDomainName TEXT, ProcessID TEXT, ProcessName TEXT, ThreadName TEXT, Message TEXT, ExtendedProperties TEXT
        
//        i.   Logvalue.EventID – (Future use – Hard code as 0)
//        ii.   Logvalue.Priority – (Future use – Hard code as 0)
//        iii.   Logvalue.Severity – ((Error, Warning, Info)
//            iv.   Logvalue.Title – Company URL of the user
//            v.   Logvalue.Timestamp – Local date time
//            vi.   Logvalue.MachineName – (App Version no ~ Android version no ~ Phone Model no)
//            vii.   Logvalue.AppDomainName – (Module Name - DCR)
//            viii.   Logvalue.ProcessID – (Sub-module name –Doctor Addition)
//            ix.   Logvalue.ProcessName – (Screen name – Add more doctors)
//            x.   Logvalue.ThreadName – (Specific sub screen name or control name – POB)
//            xi.   Logvalue.Message – (Stack Trace of the error)
//            xii.   Logvalue.ExtendedProperties – (Context sensitive - Key–Value – UserCode:<>, RegionCode:<>, AccompanistCode:<> etc)
        
        var extendedInfoString: String = EMPTY
        
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: additionalInfo)
            if let json = String(data: jsonData, encoding: .utf8) {
                extendedInfoString = json
                print(json)
            }
        }
        catch
        {
            print("something went wrong with parsing json")
        }
        
        let machineName: String = getCurrentAppVersion() + "~" + UIDevice.current.systemVersion + "~" + UIDevice.current.modelName
        let dict: NSDictionary = ["Event_Id": 0, "Priority": 0, "Severity": "ERROR", "Timestamp": getCurrentDateAndTimeString(), "MachineName": machineName, "AppDomainName": moduleName, "ProcessID": subModuleName, "ProcessName": screenName, "ThreadName": controlName, "Message": Thread.callStackSymbols.joined(separator: "\n"), "ExtendedProperties": extendedInfoString]
        let objErrorLog = ErrorLogModel(dict: dict)
        
        DBHelper.sharedInstance.insertErrorLog(objErrorLog: objErrorLog)
    }
    
    func getErrorLogCount() -> Int
    {
        return DBHelper.sharedInstance.getErrorLogCount()
    }
    
    func getErrorLogs() -> [ErrorLogModel]
    {
        return DBHelper.sharedInstance.getErrorLogs()
    }
    
    func sycnErrorLogs(completion: @escaping (Int) -> ())
    {
        let errorList: NSArray = getUpSyncList()
        print(errorList)
        
        WebServiceHelper.sharedInstance.uploadErrorLog(dataArray: errorList) { (objResponse) in
            if (objResponse.Status == SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.deleteErrorLog()
            }
            
            completion(objResponse.Status)
        }
    }
    
    private func getUpSyncList() -> NSMutableArray
    {
        let resultList: NSMutableArray = []
        let errorList = getErrorLogs()
        
        if (errorList.count > 0)
        {
            let companyInfo = DBHelper.sharedInstance.getCompanyDetails()
            let companyUrl: String = companyInfo!.companyURL!
            
            for objError in errorList
            {
                let dict: NSDictionary = ["EventID": objError.Event_Id, "Priority": objError.Priority, "Severity": objError.Severity, "Title": companyUrl, "Timestamp": objError.Timestamp, "MachineName": objError.MachineName, "AppDomainName": objError.AppDomainName, "ProcessID": objError.ProcessID, "ProcessName": objError.ProcessName, "ThreadName": objError.ThreadName, "Message": objError.Message, "ExtendedProperties": objError.ExtendedProperties]
                
                resultList.add(dict)
            }
        }
        
        return resultList
    }
}
