//
//  LogoutViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 11/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


class LogoutViewController: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logout: UIButton!
    
    var cancelBtn : UIBarButtonItem!
    var userName: String!
    let LOGOUT_ERROR_MSG = "Sorry. Unable to process the logout request. Please try again later"
    let INVALID_PASSWORD_MSG = "Please enter the valid Password"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.addTarget(self, action: #selector(self.cancelAction), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        leftBarButtonItem.title = "Back"
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        addNavigationButton()
        self.setCornerRadius()
        self.confirmPasswordTxt.delegate = self
        self.addTapGestureForView()
        userName = condenseWhitespace(stringValue: getUserName())
        self.title = "Logout"
    }
    
    func setCornerRadius()
    {
        self.logout.layer.cornerRadius = 8
        self.logout.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNavigationButton()
    {
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        self.navigationItem.rightBarButtonItems = [cancelBtn]
    }
    
    func checkUserAuthentication(userName: String, password: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            let companyCode: String = getCompanyCode()
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objApiResponse) in
                removeCustomActivityView()
                
                if (objApiResponse.list.count > 0)
                {
                    showCustomActivityIndicatorView(loadingText: "Validating your password...")
                    
                    WebServiceHelper.sharedInstance.postUserDetails(companyCode: companyCode, userName: userName, password: password,isVersionCode:false, completion: self.checkUserAuthenticationCallback)
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func checkUserAuthenticationCallback(apiResponseObj: ApiResponseModel)
    {
        removeCustomActivityView()
        
        if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
        {
            if apiResponseObj.Count > 0
            {
                let listArray:NSArray = apiResponseObj.list
                
                if listArray.count > 0
                {
                    self.removeSession()
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: INVALID_PASSWORD_MSG, viewController: self)
                }
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: INVALID_PASSWORD_MSG, viewController: self)
            }
        }
        else if(apiResponseObj.Status == SERVER_ERROR_CODE)
        {
           AlertView.showAlertView(title: errorTitle, message: apiResponseObj.Message)
        }
        else if (apiResponseObj.Status == NO_INTERNET_ERROR_CODE)
        {
            AlertView.showNoInternetAlert()
        }
        else if (apiResponseObj.Status == LOCAL_ERROR_CODE)
        {
            AlertView.showAlertView(title: errorTitle, message: self.LOGOUT_ERROR_MSG)
        }
    }
    
    func removeSession()
    {
        let companyId = String(getCompanyId())
        let companyCode = getCompanyCode()
        let userCode = getUserCode()
        let sessionId = String(getSessionId())
        
        self.logoutSession(companyCode: "\(companyCode)", companyId: companyId, userCode: userCode, sessionId: "\(sessionId)")
    }
    
    @objc func cancelAction()
    {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func logoutSession(companyCode : String, companyId : String, userCode: String, sessionId : String)
    {
        if (isSingleDeviceLoginEnabled())
        {
            showCustomActivityIndicatorView(loadingText: "Signing out. Please wait...")
            
            BL_Logout.sharedInstance.logout(companyCode: companyCode, companyId: companyId, userCode: userCode, sessionId: sessionId) { (logoutData) in
                removeCustomActivityView()
                
                if (logoutData.Status == SERVER_SUCCESS_CODE)
                {
                    self.clearDataAndMoveToLoginScreen()
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: self.LOGOUT_ERROR_MSG)
                }
            }
        }
        else
        {
            clearDataAndMoveToLoginScreen()
        }
    }
    
    private func clearDataAndMoveToLoginScreen()
    {
        BL_Logout.sharedInstance.clearAllData()
        
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc:ViewController = sb.instantiateViewController(withIdentifier: companyVC) as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logout(_ sender: Any)
    {
        self.resignResponserForTextField()
        let password = condenseWhitespace(stringValue: confirmPasswordTxt.text!).replacingOccurrences(of: " ", with: "")
        
        if password == EMPTY
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter the Password", viewController: self)
        }
        else
        {
            checkUserAuthentication(userName: userName, password: password)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == self.confirmPasswordTxt
        {
            self.confirmPasswordTxt.resignFirstResponder()
        }
        return false
        
    }
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponserForTextField()
    {
        self.confirmPasswordTxt.resignFirstResponder()
    }
}

