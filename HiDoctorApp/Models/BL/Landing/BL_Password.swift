//
//  BL_Password.swift
//  HiDoctorApp
//
//  Created by SwaaS on 16/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class BL_Password: NSObject
{
    static let sharedInstance = BL_Password()
    private let REMIND_ME_KEY = "PASSWORD_EXPIRY_NOTIFICATION_REMINDER"
    private let PASSWORD_EXPIRED_NOTIFICATION_KEY = "SkipPassword"
    private let ACCOUNT_LOCKED_ERROR_MESSAGE = "Your account is locked due to incorrect entry of password. Please contact our support team (support@swaas.net or 044 - 4340 7474) to release the lock."
    private let PASSWORD_CHANGED_ERROR_MESSAGE = "You have changed your password from some other device. Please confirm your password in order to proceed further"
    private let FIRSTTIME_PASSWORD_CHANGE_ERROR_MESSAGE = "You have to change your password"
    private let CONFIRM_PASSWORD_MESSAGE = "Your account is locked. Please confirm your password to release the lock"
    
    //MARK:- Public Functions
    func getUserAccountDetails(viewController: UIViewController, completion : @escaping (_ apiResponseObj : Int) -> ())
    {
        WebServiceHelper.sharedInstance.getUserAccountDetails { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                self.getUserAccountDetailsCallBack(list: objApiResponse.list, viewController: viewController)
            }
            
            completion(objApiResponse.Status)
        }
    }
    
    func getUserAccountDetailsForVersionUpgrader(completion : @escaping (_ apiResponseObj : Int) -> ())
    {
        WebServiceHelper.sharedInstance.getUserAccountDetails { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                self.confirmPasswordSuccess(list: objApiResponse.list)
            }
            
            completion(objApiResponse.Status)
        }
    }
    
    func getUserRegionTypeAccountDetailsForVersionUpgrade(completion : @escaping (_ apiResponseObj : Int) -> ())
    {
        WebServiceHelper.sharedInstance.getUserAccountDetails { (objApiResponse) in
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                self.updateRegionType(list: objApiResponse.list)
                BL_InitialSetup.sharedInstance.setUserAndCompanyDetails()
            }
            
            completion(objApiResponse.Status)
        }
    }
    
    func updateRegionType(list: NSArray)
    {
        if let dict = list.firstObject as? NSDictionary
        {
            let regionTypeCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Type_Code") as? String)
            let regionTypeName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Type_Name") as? String)
           
            DBHelper.sharedInstance.updateUserDetailRegionType(regionTypeCode: regionTypeCode, regionTypeName: regionTypeName)
        }
    }
    
    func getUserAccountDetailsForPMD(viewController: UIViewController, completion : @escaping (_ apiResponseObj : String) -> ())
    {
        WebServiceHelper.sharedInstance.getUserAccountDetails { (objApiResponse) in
            var serverTime: String = EMPTY
            
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                serverTime = self.PMDCallBack(list: objApiResponse.list)
            }
            
            completion(serverTime)
        }
    }
    
    func doPasswordOfflineValidations(viewController: UIViewController)
    {
        let userObj = getUserAccountDetails()
        
        if (userObj.IsAccountLocked == 1) // Account is locked for invalid password entry
        {
            moveToLockScreen(viewController: viewController, msgToDisplay: ACCOUNT_LOCKED_ERROR_MESSAGE)
        }
        else if (userObj.IsAccountLocked == 2) // Account is NOT locked. But user has changed password from other device. So let user to confirm password
        {
            moveToConfirmPasswordScreen(viewController: viewController, msgToDisplay: PASSWORD_CHANGED_ERROR_MESSAGE)
        }
        else if (userObj.IsAccountLocked == 3) // Password is expired. Show the password expired alert
        {
            showPasswordExpirySkipAlert(viewController: viewController)
        }
        else
        {
            checkPasswordStatus(viewController: viewController)
        }
    }
    
    func PMDCallBack(list: NSArray) -> String
    {
        var serverTime: String = EMPTY
        
        if let dict = list.firstObject as? NSDictionary
        {
            serverTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Current_Date") as? String)
        }
        
        return serverTime
    }
    
    func confirmPasswordSuccess(list: NSArray)
    {
        if let dict = list.firstObject as? NSDictionary
        {
            let passwordUpdateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Last_Password_Updated_Date") as? String)
            let accountLockTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Account_Locked_DateTime") as? String)
            let isAccountLocked = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Account_Locked") as? String)
            let password = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Pass") as? String)
            BL_InitialSetup.sharedInstance.password = password 
            var lockStatus: Int = 0
            
            if (isAccountLocked == "Y")
            {
                lockStatus = 1
            }
            
            DBHelper.sharedInstance.updateUserDetailsWithPassword(lastPasswordUpdateDate: passwordUpdateTime, accountLockedDate: accountLockTime, isAccountLocked: lockStatus,password:password)
        }
    }
    
    //MARK:- Private Functions
    //MARK:-- Validation Functions
    private func getUserAccountDetailsCallBack(list: NSArray, viewController: UIViewController)
    {
        let appDelegate = getAppDelegate()
        var viewControllerRef = UIViewController()
        let topController = appDelegate.window?.visibleViewController() as! UIViewController
        viewControllerRef = topController
        
        if let dict = list.firstObject as? NSDictionary
        {
            let passwordUpdateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Last_Password_Updated_Date") as? String)
            let accountLockTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Account_Locked_DateTime") as? String)
            let isAccountLocked = checkNullAndNilValueForString(stringData: dict.value(forKey: "Is_Account_Locked") as? String)
            let serverTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Current_Date") as? String)
            let fullIndex = checkNullAndNilValueForString(stringData: dict.value(forKey: "Full_index") as? String)
            var lockStatus: Int = 0
            let userObj = getUserAccountDetails()
            
            if (isAccountLocked == "Y")
            {
                lockStatus = 1
            }
            
            DBHelper.sharedInstance.updateUserDetails(lastPasswordUpdateDate: passwordUpdateTime, accountLockedDate: accountLockTime, isAccountLocked: lockStatus,fullIndex:fullIndex)
            
            if (isPasswordPolicyEnabled())
            {
                if (lockStatus == 1) // Account is locked.
                {
                    let lockReleaseDuration = getLockReleaseDuration()
                    
                    if (lockReleaseDuration > 0) // Automatic lock release
                    {
                        if (accountLockTime != EMPTY)
                        {
                            let lockedTime = getDateAndTimeInFormat(dateString: accountLockTime)
                            let currentTime = getDateAndTimeInFormat(dateString: serverTime)
                            let diffInMins = getNumberOfMinutesBetweenTwoDates(firstDate: lockedTime, secondDate: currentTime)
                            
                            if (diffInMins > lockReleaseDuration) // Lock release duration is over. Account can be released. Let the user to confirm the password.
                            {
                                moveToConfirmPasswordScreen(viewController: viewControllerRef,msgToDisplay: CONFIRM_PASSWORD_MESSAGE)
                            }
                            else
                            {
                                moveToLockScreen(viewController: viewControllerRef, msgToDisplay: ACCOUNT_LOCKED_ERROR_MESSAGE) // Account can't b released. Take user to account lock screen
                            }
                        }
                        else
                        {
                            moveToLockScreen(viewController: viewControllerRef, msgToDisplay: ACCOUNT_LOCKED_ERROR_MESSAGE)
                        }
                    }
                    else
                    {
                        moveToLockScreen(viewController: viewControllerRef, msgToDisplay: ACCOUNT_LOCKED_ERROR_MESSAGE) // Manual lock release is required. Take user to account lock screen
                    }
                }
                else if (userObj.LastPasswordUpdatedDate != passwordUpdateTime) // User changed the password from some other device. Request the user to confirm the password
                {
                    DBHelper.sharedInstance.updateUserDetails(lastPasswordUpdateDate: passwordUpdateTime, accountLockedDate: accountLockTime, isAccountLocked: 2, fullIndex: fullIndex) // Lock status = 2 means, password is changed. It is required when the user comes again with offline
                    
                    moveToConfirmPasswordScreen(viewController: viewControllerRef,msgToDisplay: PASSWORD_CHANGED_ERROR_MESSAGE)
                }
                else if (passwordUpdateTime == EMPTY && isFirstTimePasswordChangeRequired()) // Check the user has changed the password after login
                {
                    moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: FIRSTTIME_PASSWORD_CHANGE_ERROR_MESSAGE)
                }
                else if (isPasswordExpired(serverDateTime: serverTime)) // Check the password has expired or not
                {
                    DBHelper.sharedInstance.updateUserDetails(lastPasswordUpdateDate: passwordUpdateTime, accountLockedDate: accountLockTime, isAccountLocked: 3, fullIndex: fullIndex) // Lock status = 3 means, password is expired. It is required when the user comes again with offline
                    
                    showPasswordExpirySkipAlert(viewController: viewController)
                    // moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: "Your password is expired. Please change it now")
                }
                else
                {
                    let notificaitonDays: Int = getPasswordExpiryNotificationDays(serverDateTime: serverTime)
                    
                    if (notificaitonDays > 0) // Check to show the password expiry notification days
                    {
                        if (!isPasswordExpiryNotificationAlreadyShown(serverDateTime: serverTime)) // Do not show the alert if it is shown already for today
                        {
                            showPasswordExpiryNotificationAlert(viewController: viewController, noOfDays: notificaitonDays)
                        }
                    }
                }
            }
        }
    }
    
    func isPasswordPolicyEnabled() -> Bool
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.PASSWORD_POLICY).uppercased()
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func getPasswordSkipCount() -> Int
    {
        var skipCount = 0
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_PASSWORD_EXPIRED_ALERT_MAX_SKIP_COUNT)
       
        if (privValue != EMPTY)
        {
            if let days = Int(privValue)
            {
                skipCount = days
            }
        }
        
        return skipCount
    }
    
    private func getPasswordExpiryDays() -> Int
    {
        var expiryDays = 0
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.PASSWORD_EXPIRY_DAYS)
        
        if (privValue != EMPTY)
        {
            if let days = Int(privValue)
            {
                expiryDays = days
            }
        }
        
        return expiryDays
    }
    
    private func getLockReleaseDuration() -> Int
    {
        var duration = 0
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.PASSWORD_LOCK_RELEASE_DURATION)
        
        if (privValue != EMPTY)
        {
            if let mins = Int(privValue)
            {
                duration = mins
            }
        }
        
        return duration
    }
    
    private func getNumberOfDaysAfterPasswordChanged(serverDateTime: String) -> Int
    {
        var days: Int = -1
        
        let objUser = getUserAccountDetails()
        let lastPasswordUpdateDate = checkNullAndNilValueForString(stringData: objUser.LastPasswordUpdatedDate)
        
        if (lastPasswordUpdateDate != EMPTY)
        {
            let lastPwdArray = lastPasswordUpdateDate.components(separatedBy: " ")
            let serverTimeArray = serverDateTime.components(separatedBy: " ")
            //let currenetDate = getCurrentDate()
            let date1 = convertDateIntoString(dateString: lastPwdArray[0])
            let date2 = convertDateIntoString(dateString: serverTimeArray[0])
            
            days = getNumberOfDaysBetweenTwoDates(firstDate: date1, secondDate: date2)
        }
        
        return days
    }
    
     func getUserAccountDetails() -> UserModel
    {
        return DBHelper.sharedInstance.getUserDetail()!
    }
    
    private func isAccountLocked() -> Bool
    {
        let objUser = getUserAccountDetails()
        
        if (objUser.IsAccountLocked == 1)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isFirstTimePasswordChangeRequired() -> Bool
    {
        if (isPasswordPolicyEnabled())
        {
            let objUser = getUserAccountDetails()
            
            if (checkNullAndNilValueForString(stringData: objUser.LastPasswordUpdatedDate) == EMPTY)
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    private func isPasswordExpired(serverDateTime: String) -> Bool
    {
        var isExpired: Bool = false
        
        if (isPasswordPolicyEnabled())
        {
            let passwordExpiryDays = getPasswordExpiryDays()
            
            if (passwordExpiryDays > 0)
            {
                let numberOfDaysPassed = getNumberOfDaysAfterPasswordChanged(serverDateTime: serverDateTime)
                
                if (numberOfDaysPassed > passwordExpiryDays)
                {
                    isExpired = true
                }
            }
        }
        
        return isExpired
    }
    
    private func getPasswordExpiryNotificationDays(serverDateTime: String) -> Int
    {
        var notificationDays: Int = 0
        
        if (isPasswordPolicyEnabled())
        {
            let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.PASSWORD_EXPIRY_NOTIFICATION_DAYS)
            
            if (privValue != EMPTY)
            {
                if let expiryNotificationDays = Int(privValue)
                {
                    if (expiryNotificationDays > 0)
                    {
                        var numberOfDaysPassed = getNumberOfDaysAfterPasswordChanged(serverDateTime: serverDateTime)
                        
                        if (numberOfDaysPassed >  0)
                        {
                            numberOfDaysPassed = numberOfDaysPassed - 1
                            let passwordExpiryDays = getPasswordExpiryDays()
                            let diffDays = passwordExpiryDays - numberOfDaysPassed
                            
                            if (expiryNotificationDays >= diffDays)
                            {
                                notificationDays = diffDays
                            }
                        }
                    }
                }
            }
        }
        
        return notificationDays
    }
    
    func checkPasswordStatus(viewController: UIViewController)
    {
        if (isFirstTimePasswordChangeRequired()) // Check the user has changed the password after login
        {
            moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: FIRSTTIME_PASSWORD_CHANGE_ERROR_MESSAGE)
        }
    }
    
    func checkPasswordStatusForPMD(viewController: UIViewController, serverTime: String)
    {
        if (isFirstTimePasswordChangeRequired()) // Check the user has changed the password after login
        {
            moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: FIRSTTIME_PASSWORD_CHANGE_ERROR_MESSAGE)
        }
//        else if (isPasswordExpired(serverDateTime: serverTime)) // Check the password has expired or not
//        {
//          //  moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: "Your password is expired. Please change it now")
//            showPasswordExpirySkipAlert(viewController: viewController)
//        }
        else
        {
            let appDelegate = getAppDelegate()
            appDelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
        }
    }
    
    //MARK:-- Navigation functions
    
    private func moveToChangePassword(viewController: UIViewController,forcePasswordChange: Bool,  msgToDisplay: String)
    {
        if (forcePasswordChange)
        {
            let storyBoard = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ChangePasswordVcID) as! ChangePasswordViewController
            vc.forcePasswordChange = forcePasswordChange
            vc.messageString = msgToDisplay
            viewController.present(vc, animated: false, completion: nil)
        }
        else
        {
            let storyBoard = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: ChangePasswordVcID) as! ChangePasswordViewController
            vc.forcePasswordChange = forcePasswordChange
            vc.messageString = msgToDisplay
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func moveToLockScreen(viewController: UIViewController,msgToDisplay: String)
    {
        let storyBoard = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: PasswordLockVCID) as! PasswordLockViewController
        vc.messageString = msgToDisplay
        viewController.present(vc, animated: false, completion: nil)
    }
    
    func moveToConfirmPasswordScreen(viewController: UIViewController,msgToDisplay: String)
    {
        let storyBoard = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: ConfirmPasswordVCID) as! ConfirmPasswordViewController
        vc.messageString = msgToDisplay
        viewController.present(vc, animated: false, completion: nil)
    }
    
    private func showPasswordExpiryNotificationAlert(viewController: UIViewController, noOfDays: Int)
    {
        var day = "days"
        if(noOfDays == 1)
        {
           day = "day"
        }
        let alertViewController = UIAlertController(title: alertTitle, message: "Your password is going to expire in \(noOfDays) \(day). Do you want to change it now ?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CHAGE PASSWORD", style: UIAlertActionStyle.default, handler: { alertAction in
            self.moveToChangePassword(viewController: viewController,forcePasswordChange: false, msgToDisplay: EMPTY)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "REMIND ME TOMORROW", style: UIAlertActionStyle.default, handler: { alertAction in
            self.remindeMeAction()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showPasswordExpirySkipAlert(viewController: UIViewController)
    {
        let skipPassword = UserDefaults.standard
        var getPasswordValue = 0
        
        if (skipPassword.object(forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY) != nil)
        {
            getPasswordValue = skipPassword.integer(forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY)
        }
        else
        {
            skipPassword.set(0, forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY)
        }
        
        if (getPasswordValue >= getPasswordSkipCount())
        {
            self.moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: "Your password is expired")
        }
        else
        {
            let alertViewController = UIAlertController(title: alertTitle, message: "Your password is expired. Do you want to change it now? You can skip maximum of \(getPasswordSkipCount() - getPasswordValue) time(s) only", preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "CHAGE PASSWORD", style: UIAlertActionStyle.default, handler: { alertAction in
                self.moveToChangePassword(viewController: viewController,forcePasswordChange: false, msgToDisplay: EMPTY)
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            alertViewController.addAction(UIAlertAction(title: "SKIP", style: UIAlertActionStyle.default, handler: { alertAction in
                self.skipAction(viewController: viewController)
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            viewController.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    private func skipAction(viewController: UIViewController)
    {
        let skipPassword = UserDefaults.standard
        var getPasswordValue = Int()
        
        if (skipPassword.object(forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY) == nil)
        {
            getPasswordValue += 1
            skipPassword.set(getPasswordValue, forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY)
        }
        else
        {
            getPasswordValue = skipPassword.integer(forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY)
            
            if (getPasswordValue >= getPasswordSkipCount())
            {
                self.moveToChangePassword(viewController: viewController,forcePasswordChange: true, msgToDisplay: EMPTY)
                //skipPassword.set(0, forKey: "SkipPassword")
            }
            else
            {
                getPasswordValue += 1
                skipPassword.set(getPasswordValue, forKey: PASSWORD_EXPIRED_NOTIFICATION_KEY)
            }
       }
    }
    
    private func isPasswordExpiryNotificationAlreadyShown(serverDateTime: String) -> Bool
    {
        var isShown: Bool = false
        
        if let value = UserDefaults.standard.string(forKey: REMIND_ME_KEY)
        {
            let dateArray = serverDateTime.components(separatedBy: " ")
            let currentDate = dateArray[0]
            
            if (value == currentDate)
            {
                isShown = true
            }
        }
        
        return isShown
    }
    
    private func remindeMeAction()
    {
        let currentDate = getCurrentDate()
        UserDefaults.standard.set(currentDate, forKey: REMIND_ME_KEY) //setObject
    }
}
