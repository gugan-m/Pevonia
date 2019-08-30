//
//  SendIssuesViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import MessageUI

class SendIssuesViewController: UIViewController, IssueTypeDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate
{
    @IBOutlet weak var issueTypeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var scrollViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView : UIView!
    
    @IBOutlet weak var issueTypeLbl: UILabel!
    
    let defaultIssueType = "Choose issue type"
    let toEmailId = supportEmail
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        addKeyBoardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        removeKeyBoardObserver()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func doInitialSetup()
    {
        self.title = "Send issues to support"
        addBackButtonView()
        addTapGesture()
        setBorderForTextView()
        addDoneButtonOnKeyboard()
        getIssueType(issueType: defaultIssueType)
    }
    
    private func addTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//        
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        
//        self.navigationItem.leftBarButtonItem = backButtonItem
//    }
    
    private func setBorderForTextView()
    {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 3
        textView.layer.masksToBounds = true
        
        textView.delegate = self
    }
    
    @objc func backButtonAction()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getIssueType(issueType: String)
    {
        issueTypeLbl.text = issueType
    }
    
    private func validateForm() -> Bool
    {
        if (issueTypeLbl.text == defaultIssueType)
        {
            AlertView.showAlertView(title: "Error", message: "Please choose an issue type")
            return false
        }
        
        if (textView.text.count == 0)
        {
            AlertView.showAlertView(title: "Error", message: "Please enter your message")
            return false
        }
        
        if condenseWhitespace(stringValue: (textView.text)).isEmpty
        {
            AlertView.showAlertView(title: "Error", message: "Please enter your message")
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "segueIssueType")
        {
            let vc = segue.destination as! IssueTypeViewController
            vc.delegdate = self
        }
    }
    
    @IBAction func issueTypeButtonAction()
    {
        self.performSegue(withIdentifier: "segueIssueType", sender: self)
    }
    
    @IBAction func submitButtonAction()
    {
        dismissKeyboard()
        
        if (validateForm())
        {
            if checkInternetConnectivity()
            {
                let subject = "Pevonia Intl"
                let htmlString = getHtmlString()

                if MFMailComposeViewController.canSendMail()
                {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    
                    composeVC.setToRecipients([toEmailId])
                    composeVC.setSubject(subject)
                    composeVC.setMessageBody(htmlString, isHTML: true)
                    
                    self.present(composeVC, animated: true, completion: nil)
                }
                else
                {
                    AlertView.showAlertView(title: "Error", message: "Your email id is not configured.")
                }
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    //MARK:- Key board functions
    
    override func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.isTranslucent = true
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.dismissKeyboard))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        if (textView.text.count == 0)
        {
            placeHolderLabel.isHidden = false
        }
        else
        {
            placeHolderLabel.isHidden = true
        }
    }
    
    //MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        if result ==  MFMailComposeResult.sent
        {
            self.emptyTextField()
            controller.dismiss(animated:true)
            AlertView.showAlertView(title: "Success", message: "Your message has been sent to Pevonia Intl support team successfully. Pevonia Intl support team will contact you shortly.")
        }
        else if result == MFMailComposeResult.failed
        {
           controller.dismiss(animated:true)
           AlertView.showAlertView(title: "Error", message: "Sorry. Unable to send your email. Please try again.")
        }
        else
        {
            controller.dismiss(animated:true)
        }
    }
    
    
    func emptyTextField()
    {
        self.issueTypeLbl.text = defaultIssueType
        self.placeHolderLabel.isHidden = false
        self.textView.text = nil
    }
    
    //MARK:- Keyboard Method
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollViewBtmConst.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                
                let viewPresentPosition = self.textView.convert(contentView.bounds, to: self.textView)
                
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
        self.scrollViewBtmConst.constant = 0
    }
    
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
    
    private func removeKeyBoardObserver()
    {
        let center = NotificationCenter.default

        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK:- Details into Html
    
    func getHtmlString() -> String
    {
        let userObj = getUserModelObj()
        
        userObj?.Employee_name = checkNullAndNilValueForString(stringData: userObj?.Employee_name)
        userObj?.User_Name = checkNullAndNilValueForString(stringData: userObj?.User_Name)
        userObj?.User_Type_Name = checkNullAndNilValueForString(stringData: userObj?.User_Type_Name)
        
        let versionNumber = getCurrentAppVersion()
        let iosVersion = UIDevice.current.systemVersion
        let module = issueTypeLbl.text! as String
        let modelName = UIDevice.current.modelName
        var description : String = ""
        
        let attrStr = NSAttributedString(string: textView.text)
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        
        do
        {
            let htmlData = try attrStr.data(from: NSMakeRange(0, attrStr.length), documentAttributes:documentAttributes)
            if let str = String(data:htmlData, encoding:String.Encoding.utf8)
            {
                description = "\(str)"
            }
        }
        catch
        {
            print("error creating HTML from Attributed String")
        }
        
        
        var htmlString: String = "<body style=\"text-align: justify; color: #888; padding: 0px\">"
        
        htmlString += "<head><style>table tr th{padding: 0 0 5px 0;}</style></head><body><table style= \"width:100%;height : 500;text-align : left;font-size:13px;\"><tr><th><u>Issue/Query Details:</u></th></tr><tr><td style = \"padding: 0 10px 15px 20px;\"><i>Module Name</i> : \(module)</td></tr><tr><td style = \"padding: 0 10px 0 20px\"><i>Issue Details</i>:</td></tr><tr><td style = \"padding: 0 0 15px 60px;font-size:11px;\">\(description)</td></tr><tr><th><u>User Details:</u></th></tr><tr><td><i>Employee Name</i> : \((userObj?.Employee_name)! as String)</td></tr><tr><td><i>User Name</i> : \((userObj?.User_Name)! as String)</td></tr><tr><td style = \"padding: 0 0 15px 0\"><i>User Type</i> : \((userObj?.User_Type_Name)! as String)</td></tr><tr><th><u>Device Details:</u></th></tr><tr><td><i>iOS Version Number</i> : \(iosVersion)</td></tr><tr><td><i>iPhone Model</i> : \(modelName)</td></tr><tr><td style = \"padding: 0 0 15px 0\"><i>App Version Number</i> : \(versionNumber)</td></tr></table>"
        
        htmlString += "</body>"
        
        return htmlString
    }
}
