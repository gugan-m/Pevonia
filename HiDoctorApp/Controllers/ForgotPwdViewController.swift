//
//  ForgotPwdViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 21/10/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userFieldWrapper: UIView!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var companyFieldWrapper: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var requestPwdBtn: UIButton!
    
    var companyDict: NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecog)
        
        setDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Default styles
    func setDefaults() {
        userFieldWrapper.layer.borderColor = UIColor.black.cgColor
        userFieldWrapper.layer.borderWidth = 1.0
        userFieldWrapper.layer.cornerRadius = 20.0
        userFieldWrapper.layer.masksToBounds = true
        companyFieldWrapper.layer.borderColor = UIColor.black.cgColor
        companyFieldWrapper.layer.borderWidth = 1.0
        companyFieldWrapper.layer.cornerRadius = 20.0
        companyFieldWrapper.layer.masksToBounds = true
        requestPwdBtn.layer.cornerRadius = 5.0
        companyLabel.text = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Name") as? String)
    }
    
    // Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
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
    
    @IBAction func forgotPwdAction(_ sender: AnyObject)
    {
        hideKeyboard()
        
        if (checkInternetConnectivity())
        {
            if condenseWhitespace(stringValue: userField.text!) == EMPTY
            {
                AlertView.showAlertView(title: alertTitle, message: "Please enter the User ID", viewController: self)
            }
            else
            {
                requestPassword()
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }

    func requestPassword()
    {
        if checkInternetConnectivity()
        {
            self.showActivityIndicator()
            
            let companyCode: String = companyDict.value(forKey: "Company_Code") as! String
            
            WebServiceHelper.sharedInstance.getRequestPassword(companyCode: companyCode, userName: userField.text!, completion: requestPasswordCallback)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func requestPasswordCallback(apiResponseObj: ApiResponseModel)
    {
        self.hideActivityIndicator()
    
        if apiResponseObj.Status == SERVER_SUCCESS_CODE
        {
            AlertView.showAlertView(title: successTitle, message: "The access credentials has been sent to the mail associated with your account. Please Check your mail", viewController: self)
        }
        else
        {
            if (apiResponseObj.Status == SERVER_ERROR_CODE)
            {
                if (apiResponseObj.Message == EMPTY)
                {
                    AlertView.showAlertView(title: errorTitle, message: "Invalid User", viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: apiResponseObj.Message, viewController: self)
                }
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: serverSideError, viewController: self)
            }
        }
    }
    
    @IBAction func closeBtnAction(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
