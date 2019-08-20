//
//  BL_InitialSetup.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import Crashlytics

class BL_InitialSetup: NSObject
{
    static let sharedInstance = BL_InitialSetup()
    
    var userCode: String!
    var regionCode: String!
    var companyCode: String!
    var regionName : String!
    var userTypeName : String!
    var employeeName : String!
    var isManager: Bool!
    var userName : String!
    var userStartDate : Date!
    var userId: Int!
    var companyId: Int!
    var companyName: String!
    var password: String!
    var sessionId: Int!
    var regionTypeCode: String!
    var userTypeCode: String!
    var codeOfConductObj:ApiResponseModel!
    func doInitialSetUp()
    {
        self.setUserAndCompanyDetails()
        self.setLabelDetailsonPrivileges()
        self.setConfigSettings()
        self.setDCRAttachmentConfigSettings()
        self.setUserLogForFabric()
        DatabaseMigration.sharedInstance.insertOnBoard()
    }
    
    func isCodeOfConductAvailable() -> Bool
    {
        return false
    }
    
    func setUserAndCompanyDetails()
    {
        self.setUserDetails()
        self.setCompanyDetails()
    }
    
    func setLabelDetailsonPrivileges()
    {
        self.setPrivileges()
        
        appDoctor = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPDOCTOR_CAPTION).capitalized
        appDoctorPlural = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPDOCTOR_CAPTION).capitalized + "(s)"
        appChemist = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPCHEMIST_CAPTION).capitalized
        appChemistPlural = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPCHEMIST_CAPTION).capitalized + "(s)"
        appStockiest = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPSTOCKIEST_CAPTION).capitalized
        appStockiestPlural = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPSTOCKIEST_CAPTION).capitalized + "(s)"
    }
    
    func clearAllValues()
    {
        self.userCode = nil
        self.regionCode = nil
        self.companyCode = nil
        self.regionName = nil
        self.userTypeName = nil
        self.employeeName = nil
        self.isManager = nil
        self.userName = nil
        self.userStartDate = nil
        self.userId = nil
        self.companyId = nil
        self.companyName = nil
        self.password = nil
        self.sessionId = nil
        self.regionTypeCode = nil
    }
    
    private func setPrivileges()
    {
        PrivilegesAndConfigSettings.sharedInstance.setPrivilege()
    }
    
    private func setConfigSettings()
    {
        PrivilegesAndConfigSettings.sharedInstance.setConfigSettings()
    }
    
    private func setDCRAttachmentConfigSettings()
    {
        if let maxFileSizeVal = Float(PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_ATTACHMENT_PER_FILE_SIZE))
        {
            maxFileSize = maxFileSizeVal
        }
        
        if let maxFileUploadCountVal = Int(PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_ATTACHMENTS_FILES_COUNT))
        {
            maxFileUploadCount = maxFileUploadCountVal
        }
    }
    
    private func setUserDetails()
    {
        let userDetail = DBHelper.sharedInstance.getUserDetail()
        
        self.userCode = userDetail?.userCode
        self.regionCode = userDetail?.regionCode
        self.regionName = userDetail?.regionName
        self.userTypeName = userDetail?.userTypeName
        self.userName = userDetail?.userName
        self.password = userDetail?.userPassword
        self.employeeName = userDetail?.employeeName
        self.userStartDate = userDetail?.startDate
        self.regionTypeCode = userDetail?.Region_Type_Code
        self.userTypeCode = userDetail?.userTypeCode
        
        if userDetail?.userId != nil
        {
            self.userId = userDetail?.userId
        }
        
        if (userDetail?.appUserFlag == 1)
        {
            self.isManager =  true
        }
        else
        {
            self.isManager = false
        }
        
        if let sessionId = userDetail?.sessionId
        {
            self.sessionId = sessionId
        }
        else
        {
            self.sessionId = -1
        }
    }
    
    private func setCompanyDetails()
    {
        let companyDetails = DBHelper.sharedInstance.getCompanyDetails()
        
        self.companyCode = companyDetails?.companyCode
        self.companyName = companyDetails?.companyName
        if companyDetails?.companyId != nil
        {
            self.companyId = companyDetails?.companyId
        }
    }
    
    private func setUserLogForFabric()
    {
        Crashlytics.sharedInstance().setUserName(self.userName)
        Crashlytics.sharedInstance().setUserIdentifier(self.companyCode + "_" + self.userCode + "_" + self.regionCode)
    }
     func checkCodeOfConduct(completion: @escaping (Bool)-> ())
    {
        WebServiceHelper.sharedInstance.getCodeOfConduct { (apiObj) in
            if(apiObj.Status == SERVER_SUCCESS_CODE)
            {
                if(apiObj.Count > 0)
                {
                    self.codeOfConductObj = ApiResponseModel()
                    self.codeOfConductObj = apiObj
                    completion(true)
                }
                else
                {
                    UserDefaults.standard.set(Date(),forKey: "CodeOfConduct")
                    self.codeOfConductObj = nil
                    completion(false)
                }
            }
            else
            {
                let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                
                BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.CODEOFCONDUCT, subModuleName: Constants.Module_Names.CODEOFCONDUCT, screenName: Constants.Screen_Names.CODE_OF_CONDUCT, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                completion(false)
            }
        }
        
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

