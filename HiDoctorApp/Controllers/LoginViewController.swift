//
//  LoginViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 21/10/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoWrapper: UIView!
    @IBOutlet weak var userFieldWrapper: UIView!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var pwdFieldWrapper: UIView!
    @IBOutlet weak var pwdField: UITextField!
    @IBOutlet weak var showPwdBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var contentViewYoffsetConst: NSLayoutConstraint!
    @IBOutlet weak var contentViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var forgotPwdBtn: UIButton!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    var textfieldYoffset: CGFloat = 0.0
    var pwdCharFlag: Bool = true
    var companyDict: NSDictionary = [:]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecog)
        
        setDefaults()
        
        // MARK: - For Adding all play list to show list initial set up

        UserDefaults.standard.set(true, forKey: "PlayList")
        getAppDelegate().createDirectoryFolders()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Default styles
    func setDefaults()
    {
        contentViewHeightConst.constant = self.view.frame.size.height - 20
        logoWrapper.layer.cornerRadius = 5.0
        userFieldWrapper.layer.cornerRadius = 20.0
        userFieldWrapper.layer.masksToBounds = true
        pwdFieldWrapper.layer.cornerRadius = 20.0
        pwdFieldWrapper.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = 5.0
        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 123.0/255.0, green: 163.0/255.0, blue: 205.0/255.0, alpha: 1.0)] 
        let changeBtnAttString = NSAttributedString(string: "Change", attributes: attributes)
        let forgotPwdAttString = NSAttributedString(string: "Forgot password?", attributes: attributes)
        changeBtn.setAttributedTitle(changeBtnAttString, for: UIControlState.normal)
        forgotPwdBtn.setAttributedTitle(forgotPwdAttString, for: UIControlState.normal)
        companyName.text = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Name") as? String)
        
        let companyUrl = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Url") as? String)
        
        let companyLogoURL = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Logo_Url") as? String)
        self.saveImageToFile(image: self.logoImageView.image!)
        
        if let checkedUrl = URL(string: companyLogoURL)
        {
            downloadImage(url: checkedUrl)
        }
    }
    
    // Keyboard notification methods
    @objc func keyboardWillShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            {
                let btmSpaceVal:CGFloat = self.view.frame.size.height - 20 - textfieldYoffset
                if keyboardSize.height > btmSpaceVal
                {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.contentView.frame.origin.y = (keyboardSize.height - btmSpaceVal) * -1
                        self.contentViewYoffsetConst.constant = (keyboardSize.height - btmSpaceVal) * -1
                        self.contentViewBtmConst.constant = keyboardSize.height
                        }, completion: { finished in
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations:
            {
            self.contentView.frame.origin.y = 0
            self.contentViewYoffsetConst.constant = 0
            self.contentViewBtmConst.constant = 0
            }, completion: { finished in
        })
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    // Textfield delagates
    @objc func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 100
        {
            textfieldYoffset = containerView.frame.origin.y + 310
        }
        else if textField.tag == 101
        {
            textfieldYoffset = containerView.frame.origin.y + 360
        }
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.tag == 100
        {
            pwdField.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    @IBAction func showPwdAction(_ sender: AnyObject)
    {
        pwdField.resignFirstResponder()
        
        if pwdCharFlag == true
        {
            if pwdField.text != ""
            {
                pwdCharFlag = false
                pwdField.isSecureTextEntry = false
                showPwdBtn.setImage(UIImage(named: "visiblity_icon"), for: UIControlState.normal)
            }
        }
        else
        {
            if pwdField.text != ""
            {
                pwdCharFlag = true
                pwdField.isSecureTextEntry = true
                showPwdBtn.setImage(UIImage(named: "visiblityoff_icon"), for: UIControlState.normal)
            }
        }
    }

    @IBAction func loginAction(_ sender: AnyObject)
    {
        hideKeyboard()
        
        let userName = condenseWhitespace(stringValue: userField.text!)
        let password = condenseWhitespace(stringValue: pwdField.text!).replacingOccurrences(of: " ", with: "")
        let charSet = Constants.CharSet.Numeric + Constants.CharSet.Alphabet
        
        if userName == EMPTY
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter the User ID", viewController: self)
        }
        else if password == EMPTY
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter the Password", viewController: self)
        }
        else if isSplCharAvailable(charSet: charSet, stringValue: userName)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter valid User ID", viewController: self)
        }
        else
        {
            checkUserAuthentication(userName: userName, password: password)
        }
    }
    
    @IBAction func forgotPwdAction(_ sender: AnyObject) {
        hideKeyboard()
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        var forgotPwdController:ForgotPwdViewController = ForgotPwdViewController()
        forgotPwdController = sb.instantiateViewController(withIdentifier: forgotPwdVC) as! ForgotPwdViewController
        forgotPwdController.companyDict = companyDict
        let navController = UINavigationController(rootViewController: forgotPwdController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func showActivityIndicator()
    {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    //MARK:- Async Image downloader
    private func downloadImage(url: URL)
    {
        WebServiceWrapper.sharedInstance.getDataFromUrl(url: url)
        {(data) in
            if data != nil
            {
                self.logoImageView.contentMode = .scaleAspectFit
                self.logoImageView.image = UIImage(data: data!)
                self.saveImageToFile(image: self.logoImageView.image!)
            }
        }
    }
    
    func checkUserAuthentication(userName: String, password: String)
    {
        if checkInternetConnectivity()
        {
            self.showActivityIndicator()
            let companyCode: String = companyDict.value(forKey: "Company_Code") as! String
            
            WebServiceHelper.sharedInstance.postUserDetails(companyCode: companyCode, userName: userName, password: password, isVersionCode: true, completion: checkUserAuthenticationCallback)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func checkUserAuthenticationCallback(apiResponseObj: ApiResponseModel)
    {
        self.hideActivityIndicator()
        
        if apiResponseObj.Status == 1
        {
            if apiResponseObj.Count > 0
            {
                let listArray:NSArray = apiResponseObj.list
                
                if listArray.count > 0
                {
//                    DBHelper.sharedInstance.insertCompanyDetails(dict: companyDict) 
                    let userDict:NSDictionary = listArray.firstObject as! NSDictionary
//                    DBHelper.sharedInstance.insertUserDetails(dict: userDict)
//                    navigateToNextScreen()
                    //.trimmingCharacters(in: .whitespacesAndNewlines)
                     var divisionCode = checkNullAndNilValueForString(stringData: userDict.value(forKey: "Division_Code") as? String)
                    
                    divisionCode = divisionCode.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    let companyUrl = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Url") as? String)
                    

                    if !divisionCode.contains(",")
                    {
                        //https://dev1.hidoctor.me/Images/Company_Logo/dev1.hidoctor.me_28.jpg
                        let FinalUrl = "https://\(companyUrl)/Images/Company_Logo/\(companyUrl)_\(divisionCode).jpg"
                        
                        if let checkedUrl = URL(string: FinalUrl)
                        {
                            downloadImage(url: checkedUrl)
                        }
                    }
                    
                     let dict = ["Employee_Number":userDict.value(forKey: "Employee_Number"),"Division_Name":userDict.value(forKey: "Division_Name"),"Email_Id":userDict.value(forKey: "Email_Id")]
                    UserDefaults.standard.set(dict, forKey: kennectUserDetails)
                    
                    self.checkUserHasAnyActiveSession(userDict: userDict, companyDict: companyDict)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Please enter the valid credentials", viewController: self)
                }
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: apiResponseObj.Message, viewController: self)
            }
        }
        else
        {
            AlertView.showAlertView(title: errorTitle, message: apiResponseObj.Message, viewController: self)
        }
    }
    
    private func checkUserHasAnyActiveSession(userDict: NSDictionary, companyDict: NSDictionary)
    {
        if (checkInternetConnectivity())
        {
            showActivityIndicator()
            
            let companyCode = companyDict.value(forKey: "Company_Code") as! String
            let companyId = companyDict.value(forKey: "Company_Id") as! Int
            let userCode = userDict.value(forKey: "User_Code") as! String
            
            WebServiceHelper.sharedInstance.checkUserSessionExist(companyCode: companyCode, companyId: companyId, userCode: userCode, completion: { (objApiResponse) in
                
                self.hideActivityIndicator()
                
                if (objApiResponse.Status == -1)
                {
                    self.showMultiLoginAlert(userDict: userDict, companyDict: companyDict)
                }
                else if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    self.insertUserDetail(userDict: userDict, sessionId: objApiResponse.Count)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Sorry. Unable to login", viewController: self)
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func showMultiLoginAlert(userDict: NSDictionary, companyDict: NSDictionary)
    {
        let alertMessage =  "It seems that you have already logged in with one or more other devices. \n\n Please upload all your pending DVRs and PRs before login from this device. \n\n Tap 'PROCEED' to clear logins on other devices and login only on this device. \n\n Tap 'CANCEL' to cancel login."
        
        let alertViewController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "PROCEED", style: UIAlertActionStyle.default, handler: { alertAction in
            self.clearAllPreviousSessions(userDict: userDict, companyDict: companyDict)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func popViewController(animated: Bool)
    {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    private func clearAllPreviousSessions(userDict: NSDictionary, companyDict: NSDictionary)
    {
        if (checkInternetConnectivity())
        {
            self.showActivityIndicator()
            
            let companyCode = companyDict.value(forKey: "Company_Code") as! String
            let companyId = companyDict.value(forKey: "Company_Id") as! Int
            let userCode = userDict.value(forKey: "User_Code") as! String
            
            WebServiceHelper.sharedInstance.clearAllSessions(companyCode: companyCode, companyId: companyId, userCode: userCode) { (objApiResponse) in
                
                self.hideActivityIndicator()
                
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    self.checkUserHasAnyActiveSession(userDict: userDict, companyDict: companyDict)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Sorry. Unable to login", viewController: self)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func insertUserDetail(userDict: NSDictionary, sessionId: Int)
    {
        DBHelper.sharedInstance.insertCompanyDetails(dict: companyDict)
        DBHelper.sharedInstance.insertUserDetails(dict: userDict)
        DBHelper.sharedInstance.updateSessionId(sessionId: sessionId)
        
        navigateToNextScreen()
    }
    
    @IBAction func changeCompany(_ sender: AnyObject) {
        hideKeyboard()
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: (self.navigationController?.view)!, cache: false)
        _ = navigationController?.popViewController(animated: false)
        UIView.commitAnimations()
    }
    
    func navigateToNextScreen()
    {
        DBHelper.sharedInstance.updateLoginCompleted()
        BL_InitialSetup.sharedInstance.setUserAndCompanyDetails()
        let appDelegate = getAppDelegate()
        BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
            if(response)
            {
                appDelegate.allocateConductAsRoot()
            }
            else
            {
                appDelegate.allocatePrepareAsRoot()
            }
        }
//        let alertViewController = UIAlertController(title: nil, message: Display_Messages.LOGIN_DATA_DOWNLOAD.DATA_DOWNLOAD_ALERT, preferredStyle: UIAlertControllerStyle.alert)
//        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
//
//            DBHelper.sharedInstance.updateLoginCompleted()
//            BL_InitialSetup.sharedInstance.setUserAndCompanyDetails()
//            let appDelegate = getAppDelegate()
//            BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
//                if(response)
//                {
//                    appDelegate.allocateConductAsRoot()
//                }
//                else
//                {
//                    appDelegate.allocatePrepareAsRoot()
//                }
//            }
//
//            alertViewController.dismiss(animated: true, completion: nil)
//        }))
//
//        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func saveImageToFile(image:UIImage)
    {
        let filePath = fileInDocumentsDirectory(filename: ImageFileName.companyLogo.rawValue)
        saveImage(image: image, path: filePath)
    }
    
}
