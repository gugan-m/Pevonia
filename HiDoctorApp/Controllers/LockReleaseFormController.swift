//
//  LockReleaseFormController.swift
//  HiDoctorApp
//
//  Created by Swaas on 04/09/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class LockReleaseFormController: UIViewController,SelectedUserDetailsDelegate {
   
    
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var requestReleaseTxt: UITextField!
    
    var userObj : UserMasterWrapperModel!
    var lockReleaseList: [LockReleaseResponseModel] = []
    var activityLockReleaseList: [ActivityLockReleaseResponseModel] = []
    var tpFreezeDataList : [TPFreezeLockDict] = []
    var isFromDCRActivityLock: Bool = false
    var selectedUserCode: String = EMPTY
    var isFromTPFreeze: Bool = false

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.remarkTextView.layer.cornerRadius = 5
        self.remarkTextView.layer.masksToBounds = true
        self.remarkTextView.layer.borderWidth = 0.8
        self.remarkTextView.layer.borderColor = UIColor.darkGray.cgColor
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if(isFromDCRActivityLock)
        {
        self.title = "\(PEV_DCR) Activity Lock Release"
        }
        else if(isFromTPFreeze)
        {
            self.title = "\(PEV_TP) Freeze Release"
        }
        else
        {
            self.title = "\(PEV_DCR) Lock Release"
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectUserAction(_ sender: UIButton)
    {
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "LockReleaseList"
        accom_vc.navigationTitle = "User List"
        accom_vc.selectedUserDetail = self
        accom_vc.lockSelectedUserCode = selectedUserCode
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }

    @IBAction func cancelAction(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func unLockAction(_ sender: UIButton)
    {
        if(self.requestReleaseTxt.text == EMPTY)
        {
            AlertView.showAlertView(title: "Alert", message: "Please Select Request Release Name", viewController: self)
        }
//        else if(self.remarkTextView.text == EMPTY)
//        {
//            AlertView.showAlertView(title: "Alert", message: "Please enter Reason", viewController: self)
//        }
        else if(self.remarkTextView.text.count > 250)
        {
            AlertView.showAlertView(title: alertTitle, message: "Reason for Unlock cannot exceed 250 characters", viewController: self)
        }
        else if isSpecialCharacterExist(remarks:self.remarkTextView.text)
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Reason for Unlock", restrictedVal: restrictedCharacter, viewController: self)
        }
        else
        {
            var remarkValue = String()
            if(self.remarkTextView.text == EMPTY)
            {
                remarkValue = NOT_APPLICABLE
            }
            else
            {
                remarkValue = self.remarkTextView.text
            }
            
            showCustomActivityIndicatorView(loadingText: "Loading...")
            let postData: NSMutableArray = []
            
            if(isFromDCRActivityLock)
            {
                for objLockRelease in activityLockReleaseList
                {
                    var flag = String()
                    if(objLockRelease.Lock_Type == "FIELD")
                    {
                        flag = "F"
                    }
                    else if(objLockRelease.Lock_Type == "ATTENDANCE")
                    {
                        flag = "A"
                    }
                    else
                    {
                        flag = "L"
                    }
                    let dict: NSDictionary = ["User_Code": objLockRelease.User_Code,"Company_Code":getCompanyCode(), "DCR_Actual_Date": objLockRelease.DCR_Actual_Date_Server, "Activity_Flag": flag,"Released_by":getUserCode(),"Request_Released_by":userObj.userObj.User_Code,"Released_Reason":remarkValue]
                    
                    postData.add(dict)
                }
                
                WebServiceHelper.sharedInstance.unlockDCRActivityLock(dataArray: postData) { (apiResponseObj) in
                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                    {
                        removeCustomActivityView()
                        self.showSuccessAlert()
                    }
                    else
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
                    }
                }
            }
            else if isFromTPFreeze
            {
                for objLockRelease in tpFreezeDataList
                {
                    let dict: NSDictionary = ["User_Code": objLockRelease.User_Code, "TP_Date": objLockRelease.TP_Date,"Company_Code":getCompanyCode(),"Activity_Code": objLockRelease.Activity_Code,"Released_By":getUserCode(),"Request_Released_By":userObj.userObj.User_Code,"Released_Reason":remarkValue,"CompanyId":getCompanyId()]
                    
                    postData.add(dict)
                }
                WebServiceHelper.sharedInstance.unlockTPFreeze(dataArray: postData) { (apiResponseObj) in
                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                    {
                        removeCustomActivityView()
                        self.showSuccessAlert()
                    }
                    else
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
                    }
                }
            }
            else
            {
                for objLockRelease in lockReleaseList
                {
                    let dict: NSDictionary = ["User_Code": objLockRelease.User_Code, "Locked_Date": objLockRelease.Locked_Date_Server, "DCR_Actual_Date": objLockRelease.DCR_Actual_Date_Server, "Lock_Type": objLockRelease.Lock_Type,"Released_By":getUserCode(),"Request_Released_By":userObj.userObj.User_Code,"Released_Reason":remarkValue]
                    
                    postData.add(dict)
                }
                
                WebServiceHelper.sharedInstance.unlockDCR(dataArray: postData) { (apiResponseObj) in
                    if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
                    {
                        removeCustomActivityView()
                        self.showSuccessAlert()
                    }
                    else
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
                    }
                }
            }
        }
    }
    
    func setSelectedAccompanistName(userObj: UserMasterWrapperModel) {
        
        self.userObj = userObj
        self.requestReleaseTxt.text = self.userObj.userObj.Employee_name
    }
    
    func isSpecialCharacterExist(remarks:String) -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarks.count > 0)
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarks)
            }
        }
        return false
    }
    
    private func showSuccessAlert()
    {
        var message = String()
        if(isFromDCRActivityLock)
        {
           message = "\(PEV_DCR) Activity unlocked successfully for the selected user(s)"
        }
        else if(isFromTPFreeze)
        {
            message = "\(PEV_TP) Freeze unlocked successfully for the selected user(s)"
        }
        else
        {
           message = "\(PEV_DCR) unlocked successfully for the selected user(s)"
        }
        
        let alertViewController = UIAlertController (title: "Success", message: message, preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigationController?.popViewController(animated: false)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    
}
