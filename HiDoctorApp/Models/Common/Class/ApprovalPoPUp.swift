//
//  ApprovalPoPUp.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol  ApprovalPopUpDelegate
{
    func setPopUpBtnAction(type : ApprovalButtonType)
}

enum ApprovalButtonType : Int
{
    case cancel = 1
    case reject  = 2
    case approval = 3

}

class ApprovalPoPUp: UIView
{
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var validationLbl: UILabel!
    @IBOutlet weak var reasonTxtView: PlaceHolderForTextView!
    @IBOutlet weak var statusBtn : UIButton!
    
    @IBOutlet weak var btnEnable: UIButton!
    @IBOutlet weak var imgEnable: UIImageView!
    @IBOutlet weak var imgDiable: UIImageView!
    
    let approvalPopUpHeight : CGFloat = 200
    var delegate : ApprovalPopUpDelegate?
    var statusButtonType : ApprovalButtonType!
    var userObj : ApprovalUserMasterModel!
    var leaveUserObj : LeaveApprovalModel!
    

    
    class func loadNib() -> ApprovalPoPUp
    {
        return Bundle.main.loadNibNamed("ApprovalPopUp", owner:  self, options: nil)![0] as! ApprovalPoPUp
    }
    
    override func awakeFromNib()
    {
       super.awakeFromNib()
        
       self.reasonTxtView.layer.borderWidth = 1
       self.reasonTxtView.layer.borderColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        self.addDoneButtonOnKeyboard()
       self.reasonTxtView.layer.cornerRadius = 5
    }
    
    func setDefaultDetails()
    {
        var buttonTitle : String = ""
        var validationText : String = ""
        var headerText : String  = ""
        if statusButtonType == ApprovalButtonType.reject
        {
            buttonTitle = "Reject"
            validationText = "Mandatory"
            self.validationLbl.textColor = UIColor.red
            headerText = "Reason For Rejection"
        }
        else if statusButtonType ==  ApprovalButtonType.approval
        {
            buttonTitle = "Approve"
            validationText = "Optional"
            self.validationLbl.textColor = UIColor.darkGray
            headerText = "Reason For Approval"
        }
        
        self.statusBtn.setTitle(buttonTitle, for: UIControlState.normal)
        self.validationLbl.text = validationText
        self.headerLbl.text = headerText
        
        self.imgEnable.isHidden = true
        self.imgDiable.isHidden = true
        
        if (userObj != nil){
            
            if(userObj.UnapprovalActivity == "ENABLED"){
                
                UserDefaults.standard.set("0", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                userObj.IsChecked = 0
                self.imgEnable.isHidden = false
                self.imgDiable.isHidden = true
            
            }else{
                UserDefaults.standard.set("1", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                
                userObj.IsChecked = 1
                self.imgEnable.isHidden = true
                self.imgDiable.isHidden = true
                self.btnEnable.isHidden = true
            }
            
        }
    }
    func setDefaultDetailsForLeave()
    {
        var buttonTitle : String = ""
        var validationText : String = ""
        var headerText : String  = ""
        if statusButtonType == ApprovalButtonType.reject
        {
            buttonTitle = "Reject"
            validationText = "Mandatory"
            self.validationLbl.textColor = UIColor.red
            headerText = "Reason For Rejection"
        }
        else if statusButtonType ==  ApprovalButtonType.approval
        {
            buttonTitle = "Approve"
            validationText = "Optional"
            self.validationLbl.textColor = UIColor.darkGray
            headerText = "Reason For Approval"
            self.imgEnable.isHidden = true
            self.imgDiable.isHidden = true
            self.btnEnable.isHidden = true
        }
        
        self.statusBtn.setTitle(buttonTitle, for: UIControlState.normal)
        self.validationLbl.text = validationText
        self.headerLbl.text = headerText
        
        self.imgEnable.isHidden = true
        self.imgDiable.isHidden = true
        
        if (leaveUserObj != nil){
            
            if(leaveUserObj.DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK == "ENABLED"){
                
                UserDefaults.standard.set("0", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                leaveUserObj.IsChecked = 0
                if statusButtonType == ApprovalButtonType.reject
                {
                self.imgEnable.isHidden = false
                self.imgDiable.isHidden = true
                }
                else
                {
                    self.imgEnable.isHidden = true
                    self.imgDiable.isHidden = true
                    
                }
                
            }else{
                UserDefaults.standard.set("1", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                
                leaveUserObj.IsChecked = 1
                self.imgEnable.isHidden = true
                self.imgDiable.isHidden = true
                self.btnEnable.isHidden = true
            }
            
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneBtnClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.reasonTxtView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneBtnClicked()
    {
        self.reasonTxtView.resignFirstResponder()
    }

    @IBAction func cancelBtnAction(_ sender: Any)
    {
        self.reasonTxtView.resignFirstResponder()
        delegate?.setPopUpBtnAction(type :ApprovalButtonType.cancel)
    }
    
    @IBAction func actionCheckMark(_ sender: Any) {
        
        let strCheck = UserDefaults.standard.string(forKey: "ApprovalENABLED")
        if (strCheck == "0"){
//            self.imgEnable.isHidden = true
//            self.imgDiable.isHidden = false
//            UserDefaults.standard.set("1", forKey: "ApprovalENABLED")
//            UserDefaults.standard.synchronize()
           
            let strCheckForLeave = UserDefaults.standard.string(forKey: "IsFromLeaveApprovalCheckBox")

            if (strCheckForLeave == "0")
            {
                leaveUserObj.IsChecked = 1
                self.imgEnable.isHidden = true
                self.imgDiable.isHidden = false
                UserDefaults.standard.set("1", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set("1", forKey: "IsFromLeaveApprovalCheckBox")
                UserDefaults.standard.synchronize()
            }
            
            else
            {
                userObj.IsChecked = 1
                self.imgEnable.isHidden = true
                self.imgDiable.isHidden = false
                UserDefaults.standard.set("1", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set("", forKey: "IsFromLeaveApprovalCheckBox")
                UserDefaults.standard.synchronize()
            }
            //leaveUserObj.IsChecked = 1
            //userObj.IsChecked = 1
        }else{
//            self.imgEnable.isHidden = false
//            self.imgDiable.isHidden = true
//            UserDefaults.standard.set("0", forKey: "ApprovalENABLED")
//            UserDefaults.standard.synchronize()
            
            let strCheck = UserDefaults.standard.string(forKey: "IsFromLeaveApprovalCheckBox")

            if (strCheck == "1"){
//                UserDefaults.standard.set("0", forKey: "IsFromLeaveApprovalCheckBox")
//                UserDefaults.standard.synchronize()
                leaveUserObj.IsChecked = 0
                self.imgEnable.isHidden = false
                self.imgDiable.isHidden = true
                UserDefaults.standard.set("0", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
                UserDefaults.standard.set("0", forKey: "IsFromLeaveApprovalCheckBox")
                UserDefaults.standard.synchronize()
            }else{
                userObj.IsChecked = 0
                self.imgEnable.isHidden = false
                self.imgDiable.isHidden = true
                UserDefaults.standard.set("0", forKey: "ApprovalENABLED")
                UserDefaults.standard.synchronize()
//                UserDefaults.standard.set("", forKey: "IsFromLeaveApprovalCheckBox")
//                UserDefaults.standard.synchronize()
            }
            //leaveUserObj.IsChecked = 0
            //userObj.IsChecked = 0
        }
    }
    
    @IBAction func rejectBtnAction(_ sender: Any)
    {
        if statusButtonType == ApprovalButtonType.reject
        {
            if reasonTxtView.text.isEmpty || condenseWhitespace(stringValue: reasonTxtView.text).isEmpty
            {
                self.reasonTxtView.placeholderColor = UIColor.red
                self.reasonTxtView.text = nil
                self.reasonTxtView.placeholder = "Enter Your Reason..."
            }
            else if isSpecialCharacterExist()
            {
                self.reasonTxtView.resignFirstResponder()
                let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                 showToastView(toastText: " \(restrictedCharacter) characters restricted for Rejection Reason")
            }
            else
            {
                self.reasonTxtView.resignFirstResponder()
                delegate?.setPopUpBtnAction(type: ApprovalButtonType.reject)
            }
        }
        else
        {
            self.reasonTxtView.resignFirstResponder()
            if isSpecialCharacterExist()
            {
                let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                showToastView(toastText: " \(restrictedCharacter) characters restricted for Approval Reason")
            }
            else
            {
                delegate?.setPopUpBtnAction(type: ApprovalButtonType.approval)
            }
        }
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (reasonTxtView.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: reasonTxtView.text!)
            }
        }
        return false
    }

    
}
