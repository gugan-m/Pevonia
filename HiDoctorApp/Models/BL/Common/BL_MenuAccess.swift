//
//  BL_MenuAccess.swift
//  HiDoctorApp
//
//  Created by SwaaS on 22/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_MenuAccess: NSObject
{
    static let sharedInstance = BL_MenuAccess()
    
    var unreadNoticeBoardCount = Int()
    var inwardCount = Int()
    var unreadMessageCount = Int()
    var unreadTaskCount = Int()
    
    //MARK:- Public Functions
    func getApprovalMenus() -> [MenuMasterModel]
    {
        var approvalMenus = getMenus(menuIds: getApprovalMenuIDs())
        
        let filteredArray = approvalMenus.filter{
            $0.Menu_Id == MenuIDs.DCR_Leave_Approval.rawValue
        }
        
        if (filteredArray.count > 0)
        {
            if (isPayRollIntegrated())
            {
                let index = approvalMenus.index(where: { (objMenu) -> Bool in
                    objMenu.Menu_Id == MenuIDs.DCR_Leave_Approval.rawValue
                })
                
                approvalMenus.remove(at: index!)
            }
        }
        
        for objMenu in approvalMenus
        {
            if (objMenu.Menu_Id == MenuIDs.DCR_Approval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Activity.rawValue
                objMenu.Menu_Name = "Daily Visit Report"
            }
            else if (objMenu.Menu_Id == MenuIDs.DCR_Leave_Approval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Activity.rawValue
            }
            else if (objMenu.Menu_Id == MenuIDs.Approval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Activity.rawValue
                objMenu.Menu_Name = "Reject Report"
            }
            else if (objMenu.Menu_Id == MenuIDs.TP_Approval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Plan.rawValue
                objMenu.Menu_Name =  "Partner Routing"
            }
            else if (objMenu.Menu_Id == MenuIDs.DCR_Lock_Release.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Plan.rawValue
                objMenu.Menu_Name = "DVR Lock Release"
            }
            else if (objMenu.Menu_Id == MenuIDs.DoctorApproval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Customer.rawValue
                objMenu.Menu_Name = "\(appDoctor) Approval"
            }
            else if (objMenu.Menu_Id == MenuIDs.ExpenseApproval.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Others.rawValue
                objMenu.Menu_Name = "Expense Approval"
            }
            else if (objMenu.Menu_Id == MenuIDs.DCR_ActivityLock_Release.rawValue)
            {
                objMenu.Section_Name = MenuSectionName.Plan.rawValue
                objMenu.Menu_Name = "DVR Activity Lock Release"
            }
            else if (objMenu.Menu_Id == MenuIDs.TP_Freeze_Lock.rawValue)
            {
                objMenu.Count = -99
                objMenu.Section_Name = MenuSectionName.Plan.rawValue
                objMenu.Menu_Name = "PR Freeze Release"
            }
        }
        
        return approvalMenus
    }
    
    func DCRApiCall(menuId: Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.approvalDCRApiCall(){
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func TPApprovalApiCall(menuId: Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.webTPApprovalApiCall()
        {
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func DCRLeaveApprovalApi(menuId: Int, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.webDCRLeaveApprovalApi()
        {
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func DCRLockReleaseApi(menuId: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.webDCRLockReleaseApi()
        {
            (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func DCRActivityLockReleaseApi(menuId: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.webDCRActivityLockReleaseApi()
            {
                (apiResponseObj) in
                completion(apiResponseObj)
        }
    }
    
    func isCustomerMasterScreenAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.Customer_Master_Screen.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isInChamberEffectivenssAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.InChamberEffectiviness.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isTaskAvailabel() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.Task.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isCustomerComplaintAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.Customer_Complaints.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isQuickNotesAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.QuickNotes.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isCustomerLocationEditAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.canEditCustomerLocation.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isKennectAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.Kennect.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isDPMAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.Doctor_Product_Mapping.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isMyDocumentAvailable() -> Bool
    {
        let menuIDs = getMenus(menuIds: String(MenuIDs.MyDocument.rawValue))
        
        if (menuIDs.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    func isResonsive() -> Bool
    {
        let menuIDs = getResponsiveMenus(MenuType: "3", MenuCategory: "Responsive")
        
        if (menuIDs != nil)
        {
            return true
        }
        else
        {
            return false
        }
    }

    //MARK:- Private Functions
    private func getApprovalMenuIDs() -> String
    {
        let menuIDs: String = String(MenuIDs.DCR_Approval.rawValue) + "," + String(MenuIDs.TP_Approval.rawValue) + "," + String(MenuIDs.DCR_Leave_Approval.rawValue) + "," + String(MenuIDs.DCR_Lock_Release.rawValue) + "," + String(MenuIDs.DoctorApproval.rawValue) + "," + String(MenuIDs.ExpenseApproval.rawValue) + "," + String(MenuIDs.DCR_ActivityLock_Release.rawValue) + "," + String(MenuIDs.TP_Freeze_Lock.rawValue)
        
        return menuIDs
    }
    
    private func getMenus(menuIds: String) -> [MenuMasterModel]
    {
        return DBHelper.sharedInstance.getMenuMasterByMenuIDs(menuIds: menuIds)
    }
    
    private func getResponsiveMenus(MenuType: String, MenuCategory: String) -> [MenuMasterModel]
    {
        return DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
    }

    
    
    
    private func isPayRollIntegrated() -> Bool
    {
        var result: Bool = false
        
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.IsPayRollIntegrated)
        
        if (privilegeValue == ConfigValues.YES.rawValue)
        {
            result = true
        }
        
        return result
    }
    
    //DCR UserWise Applied List API
    
    func getDCRUserWiseListApiCall(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDCRUserWiseAppliedList
        {
            (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getTPUserWiseListApiCall(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getTPUserWiseAppliedList { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    func getLockReleaseUserWiseListApiCall(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getLockReleaseUserWiseAppliedList
            {
                (apiResponseObj) in
                completion(apiResponseObj)
        }
    }
    
    func getActivityLockReleaseUserWiseListApiCall(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getActivityLockReleaseUserWiseAppliedList
            {
                (apiResponseObj) in
                completion(apiResponseObj)
        }
    }
    
    func getTPUnfreezeReleaseUserWiseListApiCall(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getTPUnfreezeReleaseUserWiseAppliedList
            {
                (apiResponseObj) in
                completion(apiResponseObj)
        }
    }
    
    // Unapproval List API
    
    func getUserWiseTPAppliedList(userList: ApprovalUserMasterModel,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getUserWiseTPAppliedList(userCode: userList.User_Code, regionCode: userList.Region_Code)
            {
                (apiResponseObj) in
                completion(apiResponseObj)
        }
    }
    
    func getSelectedUserDCRDetails(userList: ApprovalUserMasterModel, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getSelectedUserDCRDetails(userCode: userList.User_Code, regionCode: userList.Region_Code)
        {
            (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    // User Authentication
    func getCheckUserExist(viewController: UIViewController, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        if (checkInternetConnectivity())
        {
            WebServiceHelper.sharedInstance.getCheckUserExist { (apiResponseObj) in
                
                let appDelegate = getAppDelegate()
                
                if let navigationController = appDelegate.root_navigation
                {
                    let vc = navigationController.viewControllers.last
                    
                    if (vc != nil)
                    {
                        if (vc == viewController)
                        {
                            if (apiResponseObj.Status == NO_INTERNET_ERROR_CODE)
                            {
                                AlertView.showNoInternetAlert()
                                completion(apiResponseObj)
                            }
                            else if (apiResponseObj.Status == LOCAL_ERROR_CODE)
                            {
                                AlertView.showAlertView(title: errorTitle, message: "Sorry. Unable to verify user authentication. Please try again later")
                                completion(apiResponseObj)
                            }
                            else if (apiResponseObj.Status == SERVER_PASSWORD_CHANGE_CODE)
                            {
                                self.confirmPassword(viewController: viewController)
                                completion(apiResponseObj)
                            }
                            else
                            {
                                if (apiResponseObj.list.count > 0)
                                {
                                    completion(apiResponseObj)
                                }
                                else
                                {
                                    let alertViewController = UIAlertController(title: alertTitle, message: authenticationMsg, preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                                        self.logout(viewController: viewController)
                                        alertViewController.dismiss(animated: true, completion: nil)
                                    }))
                                    
                                    viewController.present(alertViewController, animated: true, completion: nil)
                                    
                                    completion(apiResponseObj)
                                }
                            }
                        }
                        else
                        {
                            completion(apiResponseObj)
                        }
                    }
                    else
                    {
                        completion(apiResponseObj)
                    }
                }
                else
                {
                    completion(apiResponseObj)
                }
            }
        }
    }
    
     func logout(viewController: UIViewController)
    {
        if let navigationController = getAppDelegate().root_navigation
        {
            BL_Logout.sharedInstance.clearAllData()
            
            let sb = UIStoryboard(name: mainSb, bundle: nil)
            let vc:ViewController = sb.instantiateViewController(withIdentifier: companyVC) as! ViewController
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func confirmPassword(viewController: UIViewController)
    {
        BL_Password.sharedInstance.moveToConfirmPasswordScreen(viewController: viewController,msgToDisplay: "Your password has been changed. Please confirm your password to procced")
        
    }
    
    //MARK:- Change Password
    func updateResetPassword(userObj: UserChangePasswordModel, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.updateResetPassword(userObj: userObj) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    // Doctorapproval List API
    
    func getPendingDoctorApprovalUserList(customerStatus: Int,searchType: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getPendingDoctorApprovalUserList(customerStatus: customerStatus,searchType: searchType) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getPendingDoctorApprovalUserListBySearch(customerStatus: Int,searchType:Int,searchString: String, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getPendingDoctorApprovalUserListSearch(customerStatus: customerStatus, searchString: searchString, searchType: searchType) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //Mark:- Inward Accknowledgement needed priv
    func isInwardAcknowledgementNeededPrivEnable()  -> Bool
    {

        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.INWARD_ACKNOWLEDGEMENT_NEEDED)
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func is_Group_eDetailing_Allowed()  -> Bool
    {
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ALLOW_GROUP_EDETAILING)
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func is_Punch_In_Out_Enabled()  -> Bool
    {
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.IS_DCR_PUNCH_IN_OUT_ENABLED)
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    //Mark:- MasterDataDownload
    func getMasterDataDownloadDays() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAN_CHECK_MASTER_DATA_DOWNLOAD_IN_DAYS).uppercased()
    }
    func getassetsplayinsequence() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAN_PLAY_ASSETS_IN_SEQUENCE).uppercased()
    }
    //Mark:- Landing page alert
    func getLandingAlertValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ALERT_LANDING_PAGE_REDIRECT).uppercased()
    }
    
    func landingAlertUserDefaults()
    {
        if let noticeUnRead = UserDefaults.standard.value(forKey: UserDefaultsValues.NoticeBoard.rawValue) as? Int
        {
           unreadNoticeBoardCount = noticeUnRead
        }
        else
        {
            unreadNoticeBoardCount = 0
        }
        
        if let messageUnRead = UserDefaults.standard.value(forKey: UserDefaultsValues.Message.rawValue) as? Int
        {
            unreadMessageCount = messageUnRead
        }
        else
        {
            unreadMessageCount = 0
        }
        
        if let inwardUnRead = UserDefaults.standard.value(forKey: UserDefaultsValues.Inward.rawValue) as? Int
        {
            inwardCount = inwardUnRead
        }
        else
        {
            inwardCount = 0
        }
        
        if let taskUnRead = UserDefaults.standard.value(forKey: UserDefaultsValues.Task.rawValue) as? Int
        {
            unreadTaskCount = taskUnRead
        }
        else
        {
           unreadTaskCount = 0
        }
    }
    
}
