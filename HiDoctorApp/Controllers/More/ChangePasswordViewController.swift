//
//  ChangePasswordViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/30/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var changePwdBtn: UIButton!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    @IBOutlet weak var oldPasswordTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayLabel: UILabel!
    
    var UserObj : UserChangePasswordModel = UserChangePasswordModel()
    
    var messageString = String()
    var forcePasswordChange = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyBoardObserver()
        self.addTapGestureForView()
        self.title = "Change Password"
        displayLabel.text = messageString
        changePwdBtn.layer.cornerRadius = 5
        addBackButtonView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func changePasswordAction(_ sender: AnyObject)
    {
        resignResponserForTextField()
        
        let validationStr = self.textFeildValidation()
        
        if validationStr
        {
            UserObj.New_Password = newPasswordTxt.text
            UserObj.Old_Password = oldPasswordTxt.text
            UserObj.User_Name = getUserName()
            UserObj.User_Code = getUserCode()
            
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                removeCustomActivityView()
                
                if apiResponseObj.list.count > 0
                {
                    showCustomActivityIndicatorView(loadingText: "Updating Password")
                    BL_MenuAccess.sharedInstance.updateResetPassword(userObj: self.UserObj) { (apiResponseObj) in
                        
                        if apiResponseObj.Status == SERVER_SUCCESS_CODE
                        {
                            WebServiceHelper.sharedInstance.confirmPassword(password: self.UserObj.New_Password!, completion: { (apiResponseObject) in
                                if(apiResponseObject.Status == SERVER_SUCCESS_CODE)
                                {
                                    BL_Password.sharedInstance.getUserAccountDetailsForVersionUpgrader(completion: { (status) in
                                        if(status == SERVER_SUCCESS_CODE)
                                        {
                                            let skipPassword = UserDefaults.standard
                                            skipPassword.set(0, forKey: "SkipPassword")
                                            removeCustomActivityView()
                                            showToastView(toastText: "Password updated successfully")
                                            if(!self.forcePasswordChange)
                                            {
                                                _ = self.navigationController?.popViewController(animated: true)
                                            }
                                            else
                                            {
                                                let appDelegate = getAppDelegate()
                                                appDelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
                                            }
                                        }
                                        else
                                        {
                                            removeCustomActivityView()
                                            AlertView.showAlertView(title: alertTitle, message: apiResponseObj.Message, viewController: self)
                                        }
                                    })
                                }
                                else
                                {
                                    removeCustomActivityView()
                                    AlertView.showAlertView(title: alertTitle, message: apiResponseObj.Message, viewController: self)
                                }
                            })
                        }
                        else
                        {
                            removeCustomActivityView()
                            AlertView.showAlertView(title: alertTitle, message: apiResponseObj.Message, viewController: self)
                        }
                        
                    }
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: alertTitle, message: apiResponseObj.Message, viewController: self)
                }
            })
            
            //                else
            //                {
            //                    AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
            //                }
            //           })
        }
    }
    
    func textFeildValidation() -> Bool
    {
        var validation : Bool = true
        let userDetail = BL_Password.sharedInstance.getUserAccountDetails()
        
        if oldPasswordTxt.text == EMPTY
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Old Password", viewController: self)
            validation = false
        }
        else if condenseWhitespace(stringValue: oldPasswordTxt.text!).isEmpty
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Old Password", viewController: self)
            validation = false
        }
//        else if isSpecialCharacterExist(txtLbl: oldPasswordTxt)
//        {
//            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
//            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Old Password", restrictedVal: restrictedCharacter, viewController: self)
//            validation = false
//        }
        else if newPasswordTxt.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter New Password", viewController: self)
            validation = false
        }
        else if condenseWhitespace(stringValue: newPasswordTxt.text!).isEmpty
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter New Password", viewController: self)
            validation = false
        }
//        else if isSpecialCharacterExist(txtLbl: newPasswordTxt)
//        {
//            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
//            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "New Password", restrictedVal: restrictedCharacter, viewController: self)
//            validation = false
//        }
        else if confirmPasswordTxt.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Confirm Password", viewController: self)
            validation = false
        }
        else if condenseWhitespace(stringValue: confirmPasswordTxt.text!).isEmpty
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Confirm Password", viewController: self)
            validation = false
        }
        else if confirmPasswordTxt.text != newPasswordTxt.text
        {
            AlertView.showAlertView(title: alertTitle, message: "New Password and Confirm Password did not match", viewController: self)
            validation = false
        }
        else if oldPasswordTxt.text == newPasswordTxt.text ||  oldPasswordTxt.text == confirmPasswordTxt.text
        {
            AlertView.showAlertView(title: alertTitle, message: "Old Password and New Password can't be same", viewController: self)
            validation = false
        }
       
        
        return validation
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponserForTextField()
    {
        self.oldPasswordTxt.resignFirstResponder()
        self.confirmPasswordTxt.resignFirstResponder()
        self.newPasswordTxt.resignFirstResponder()
    }
    
    //MARK:- KeyBoard function
    
    func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollViewBtm.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                
                let viewPresentPosition = self.newPasswordTxt.convert(contentView.bounds, to: self.confirmPasswordTxt)
                
                let scrollViewHeight = self.scrollView.frame.height
                
                let finalContentOffset = (viewPresentPosition.origin.y + viewPresentPosition.height) - scrollViewHeight
                var contentOffset = self.scrollView.contentOffset
                
                if finalContentOffset > 0
                {
                    contentOffset.y = finalContentOffset
                }
                self.scrollView.contentOffset = contentOffset
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.scrollViewBtm.constant = 0
    }
    
    func isSpecialCharacterExist(txtLbl: UITextField) -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (txtLbl.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: txtLbl.text!)
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.oldPasswordTxt {
            self.newPasswordTxt.becomeFirstResponder()
        }
        else if textField == self.newPasswordTxt
        {
            self.confirmPasswordTxt.becomeFirstResponder()
        }
        else if textField == self.confirmPasswordTxt
        {
            self.confirmPasswordTxt.resignFirstResponder()
        }
        return false
        
    }
    
    func showUpdateToastView()
    {
        
    }
}


