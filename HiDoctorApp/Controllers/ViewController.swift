//
//  ViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 13/10/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoWrapper: UIView!
    @IBOutlet weak var textFieldWrapper: UIView!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentViewYoffsetConst: NSLayoutConstraint!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var contentViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var textfieldYoffset: CGFloat = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        showVersionToastView(textColor : UIColor.white)
    }
    
    // Default styles
    func setDefaults() {
        contentViewHeightConst.constant = self.view.frame.size.height - 20.0
        logoWrapper.layer.cornerRadius = 5.0
        textFieldWrapper.layer.cornerRadius = 20.0
        textFieldWrapper.layer.masksToBounds = true
        nextButton.layer.cornerRadius = 5.0

//        let titleAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline), NSAttributedStringKey.foregroundColor: UIColor.purple]
//        let attributes = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle, NSAttributedStringKey.foregroundColor:UIColor(red: 123.0/255.0, green: 163.0/255.0, blue: 205.0/255.0, alpha: 1.0)] as [NSAttributedStringKey : Any]
//        let attributes : [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(red: 123.0/255.0, green: 163.0/255.0, blue: 205.0/255.0, alpha: 1.0)]
//        let attributedString = NSAttributedString(string: "Need Help?", attributes: attributes)
//        helpBtn.setAttributedTitle(attributedString, for: UIControlState.normal)
    }
    
    // Keyboard notification methods
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let btmSpaceVal:CGFloat = self.view.frame.size.height - 20.0 - textfieldYoffset
                if keyboardSize.height > btmSpaceVal {
                    UIView.animate(withDuration: 0.5, animations: {
                            //self.view.isUserInteractionEnabled = false
                            self.contentView.frame.origin.y = (keyboardSize.height - btmSpaceVal) * -1
                            self.contentViewYoffsetConst.constant = (keyboardSize.height - btmSpaceVal) * -1
                            self.contentViewBtmConst.constant = keyboardSize.height
                        }, completion: { finished in
                            //self.view.isUserInteractionEnabled = true
                    })
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
                //self.view.isUserInteractionEnabled = false
                self.contentView.frame.origin.y = 0
                self.contentViewYoffsetConst.constant = 0
                self.contentViewBtmConst.constant = 0
            }, completion: { finished in
                //self.view.isUserInteractionEnabled = true
        })
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    // Textfield delagates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textfieldYoffset = containerView.frame.origin.y + 310
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton)
    {
        hideKeyboard()
        
        let companyName = condenseWhitespace(stringValue: companyField.text!)
        let charSet = Constants.CharSet.Alphabet + Constants.CharSet.Numeric + "-"
        
        if companyName == EMPTY
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter company name", viewController: self)
        }
        else if isSplCharAvailable(charSet: charSet, stringValue: companyName)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter valid company name", viewController: self)
        }
        else
        {
            checkCompanyName(companyName: companyName)
        }
    }
    
    @IBAction func helpAction(_ sender: AnyObject)
    {
        hideKeyboard()
        
//        if let helpurl = NSURL(string: Constants.HelpURLs.LoginHelpUrl) as? URL
//        {
//            if UIApplication.shared.canOpenURL(helpurl)
//            {
//                UIApplication.shared.openURL(helpurl)
//            }
//            else
//            {
//                AlertView.showAlertView(title: errorTitle, message: "Cannot open the link", viewController: self)
//            }
//        }
//        else
//        {
//            AlertView.showAlertView(title: errorTitle, message: "Cannot open the link", viewController: self)
//        }
        
        if checkInternetConnectivity()
        {
            let sb = UIStoryboard(name: mainSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
            vc.siteURL = Constants.HelpURLs.LoginHelpUrl
            vc.webViewTitle = "Help"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
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
    
    func checkCompanyName(companyName: String)
    {
        if checkInternetConnectivity()
        {
            self.showActivityIndicator()
            
//            WebServiceHelper.sharedInstance.getCompanyDetails(companyName: companyName + companySubDomain, completion: checkCompanyNameCallback)
            
            WebServiceHelper.sharedInstance.getCompanyDetails(companyName: companyName, completion: checkCompanyNameCallback)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func checkCompanyNameCallback(apiResponseObj: ApiResponseModel)
    {
        self.hideActivityIndicator()
        
        if apiResponseObj.Status == SERVER_SUCCESS_CODE
        {
            if apiResponseObj.Count > 0
            {
                let listArray:NSArray = apiResponseObj.list
                
                if listArray.count > 0
                {
                    let sb = UIStoryboard(name: mainSb, bundle: nil)
                    var loginController:LoginViewController = LoginViewController()
                   
                    loginController = sb.instantiateViewController(withIdentifier: loginVC) as! LoginViewController
                    loginController.companyDict = listArray.firstObject as! NSDictionary
                    
                    UIView.beginAnimations("animation", context: nil)
                    UIView.setAnimationDuration(0.8)
                    
                    if (self.navigationController?.view != nil)
                    {
                        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: (self.navigationController?.view)!, cache: false)
                    }
                    
                    self.navigationController?.pushViewController(loginController, animated: false)
                    
                    UIView.commitAnimations()
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
        else
        {
            if (apiResponseObj.Message != EMPTY)
            {
                AlertView.showAlertView(title: errorTitle, message: apiResponseObj.Message, viewController: self)
            }
            else
            {
                AlertView.showServerSideError()
            }
        }
    }
}

