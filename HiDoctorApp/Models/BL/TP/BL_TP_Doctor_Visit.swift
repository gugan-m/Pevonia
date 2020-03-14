//
//  BL_TP_Doctor_Visit.swift
//  HiDoctorApp
//
//  Created by Admin on 8/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TP_Doctor_Visit: NSObject {
    static let sharedInstance = BL_TP_Doctor_Visit()
    var cpTab : Bool = false
    var tpTab : Bool = false
    
    func convertToDoctorVisitUserModel() -> [UserMasterWrapperModel]?
    {
        var userList : [UserMasterWrapperModel] = []
        let accompanistList = getTPAccompanistsList()
        
        let loggedUserModel = getUserModelObj()
        loggedUserModel?.Employee_name = "Mine"
        let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
        wrapperModel.userObj = loggedUserModel!
        
        userList.append(wrapperModel)
        
        if (accompanistList?.count)! > 0
        {
            for accompanistObj in accompanistList!
            {
                let userModel : UserMasterModel = UserMasterModel()
                userModel.Employee_name = accompanistObj.Acc_Employee_Name
                userModel.User_Name = accompanistObj.Acc_User_Name
                userModel.User_Type_Name = accompanistObj.Acc_User_Type_Name
                userModel.Region_Name = accompanistObj.Acc_Region_Name
                userModel.Region_Code = accompanistObj.Acc_Region_Code
                let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
                wrapperModel.userObj = userModel
                userList.append(wrapperModel)
            }
        }
        
        return userList
    }

    func convertToTPDoctorVisitUserModel() -> [UserMasterWrapperModel]?
    {
        var userList : [UserMasterWrapperModel] = []
        let accompanistList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterLists()
        
        let loggedUserModel = getUserModelObj()
        loggedUserModel?.Employee_name = "Mine"
        let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
        wrapperModel.userObj = loggedUserModel!
        
        userList.append(wrapperModel)
        
        if (accompanistList.count) > 0
        {
            for accompanistObj in accompanistList
            {
                let userModel : UserMasterModel = UserMasterModel()
                userModel.Employee_name = accompanistObj.Employee_name
                userModel.User_Name = accompanistObj.User_Name
                userModel.User_Type_Name = accompanistObj.User_Type_Name
                userModel.Region_Name = accompanistObj.Region_Name
                userModel.Region_Code = accompanistObj.Region_Code
                let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
                wrapperModel.userObj = userModel
                userList.append(wrapperModel)
            }
        }
        
        return userList
    }
    
    func getTPAccompanistsList() -> [TourPlannerAccompanist]?
    {
            let accompanistList = DAL_TP_SFC.sharedInstance.getTPAccompanistList(tpId: TPModel.sharedInstance.tpEntryId)
            return accompanistList
    }
    
    

    
    func getCPDoctorsForSelectedDate() -> [CustomerMasterModel]?
    {
        var cpDoctorList: [CampaignPlannerDoctors]?
        let tpHeader = BL_WorkPlace.sharedInstance.getTPHeaderDetailForWorkPlace()
        let cpCode = checkNullAndNilValueForString(stringData: tpHeader?.CP_Code)
        
        if (cpCode != "")
        {
            cpDoctorList = BL_TPStepper.sharedInstance.getCPDoctorsByCpCode(cpCode: cpCode)
        }
        
        var customerMasterList: [CustomerMasterModel] = []
        
        if (cpDoctorList != nil)
        {
            for cpDoctorObj in cpDoctorList!
            {
                let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCodeAndRegionCode(customerCode: cpDoctorObj.Doctor_Code, regionCode: cpDoctorObj.Doctor_Region_Code, customerEntityType: DOCTOR)
                
                if (customerObj != nil)
                {
                    customerMasterList.append(customerObj!)
                }
            }
        }
        
        return customerMasterList
    }

    func getDoctorSuffixColumnName() -> [String]
    {
        let privVal = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_SUFIX_COLUMNS).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func getDoctorMasterList(regionCode: String) -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getCustomerMasterList(regionCode: regionCode, customerEntityType: DOCTOR)
    }
    
    func getTPDoctorMasterList() -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getTPCustomerMasterList(customerEntityType: DOCTOR)
    }
}
