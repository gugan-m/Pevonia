//
//  FollowUpsViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 17/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AddFollowUpsViewController: UIViewController,UITextViewDelegate
{
    
    @IBOutlet var remarksTxtView: UITextView!
    @IBOutlet var remarksCountLbl: UILabel!
    @IBOutlet var dueDateTxtField: UITextField!
    
    var dueDatePicker : UIDatePicker!
    var modifyFollowUpObj : DCRFollowUpModel?
    var modifyChemistFollowupObj: DCRChemistFollowup?
    var dueDate : String?
    var isFromChemistDay : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDefaultDetails()
        addCustomBackButtonToNavigationBar()
        addDoneButtonOnKeyboard()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func setDefaultDetails()
    {
        addFromDatePicker()
        addTapGestureForView()
        setPlaceHolderForFromTxtFld()
        setModifyDetails()
        remarksTxtView.layer.borderWidth = 1
        remarksTxtView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        remarksTxtView.layer.cornerRadius = 4
    }
    
    
    func setModifyDetails()
    {
        var dueDate : Date!
        if !isFromChemistDay
        {
            if modifyFollowUpObj != nil
            {
                dueDate = (modifyFollowUpObj?.Due_Date)!
                self.remarksTxtView.text = modifyFollowUpObj?.Follow_Up_Text
                let count = String(describing: modifyFollowUpObj!.Follow_Up_Text.count) as String
                self.remarksCountLbl.text = "\(count)/\(followUpRemarksLength)"
                setDefaultRowinDatePicker(dueDate: dueDate)
                self.title = "Edit Follow-Ups"
            }
            else
            {
                dueDate = DCRModel.sharedInstance.dcrDate
                self.title = "Add Follow-Ups"
            }
        }
        else
        {
            if modifyChemistFollowupObj != nil
            {
                dueDate = (modifyChemistFollowupObj?.DueDate)!
                self.remarksTxtView.text = modifyChemistFollowupObj?.Task
                let count = String(describing: modifyChemistFollowupObj!.Task.count) as String
                self.remarksCountLbl.text = "\(count)/\(followUpRemarksLength)"
                setDefaultRowinDatePicker(dueDate: dueDate)
                self.title = "Edit Follow-Ups"
            }
            else
            {
                dueDate = DCRModel.sharedInstance.dcrDate
                self.title = "Add Follow-Ups"
            }
        }
        self.dueDateTxtField.text = convertDateInRequiredFormat(date: dueDate, format: defaultDateFomat)
    }
    
    
    
    
    @IBAction func submitBtnAction(_ sender: UIButton)
    {
        if isValidated()
        {
            if !isFromChemistDay
            {
                if modifyFollowUpObj != nil
                {
                    updateFollowUpDetails()
                }
                else
                {
                    saveFollowUpDetails()
                }
            }
            else
            {
                if modifyChemistFollowupObj != nil
                {
                    updateFollowUpDetails()
                }
                else
                {
                    saveFollowUpDetails()
                }
            }
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
    
    func saveFollowUpDetails()
    {
        if dueDate == nil
        {
            dueDate = convertDateIntoServerStringFormat(date:DCRModel.sharedInstance.dcrDate)
        }
        if !isFromChemistDay
        {
            BL_DCR_Follow_Up.sharedInstance.saveDCRFollowUpDetail(remarksText:remarksTxtView.text, dueDate: dueDate!)
        }
        else
        {
            BL_DCR_Follow_Up.sharedInstance.saveChemistDayFollowUpDetail(remarksText: remarksTxtView.text, dueDate: dueDate!)
        }
    }
    
    func updateFollowUpDetails()
    {
        if !isFromChemistDay
        {
            modifyFollowUpObj?.Follow_Up_Text = remarksTxtView.text
            
            if dueDate != nil
            {
                modifyFollowUpObj?.Due_Date = getStringInFormatDate(dateString: dueDate!)
            }
            
            BL_DCR_Follow_Up.sharedInstance.updateDCRFollowUpDetail(followUpObj: modifyFollowUpObj!)
        }
        else
        {
            modifyChemistFollowupObj?.Task = remarksTxtView.text
            if dueDate != nil
            {
                modifyChemistFollowupObj?.DueDate = getStringInFormatDate(dateString: dueDate!)
            }
            BL_DCR_Follow_Up.sharedInstance.updateChemistDayFollowups(followUpObj: modifyChemistFollowupObj!)
        }
    }
    
    func isValidated() -> Bool
    {
        var isValidated : Bool = true
        let remarksText = remarksTxtView.text
        
        if condenseWhitespace(stringValue: remarksText!).count == 0
        {
            self.showAlertView(message: "Please enter remarks")
            isValidated = false
        }
        else if (remarksText?.count)! > 0 && isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Follow-Up remarks", restrictedVal: restrictedCharacter, viewController: self)
            isValidated = false
        }
        else if (remarksText?.count)! > followUpRemarksLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: followUpRemarksLength, viewController: self)
            isValidated = false
        }
        else if dueDateTxtField.text?.count == 0
        {
            self.showAlertView(message: "Please select due date")
            isValidated = false
        }
        return isValidated
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponder))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponder()
    {
        self.remarksTxtView.resignFirstResponder()
        self.dueDateTxtField.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        
        let remarksText = textView.text ?? ""
        let newLength = remarksText.count + (text.count - range.length)
        
        if newLength > followUpRemarksLength
        {
            let lengthDiff = followUpRemarksLength - newLength
            let start = text.startIndex
            let end = text.index((text.endIndex), offsetBy: lengthDiff)
            let substring = text[start..<end]
            if substring != ""
            {
                textView.text = "\(textView.text!)" + substring as String
            }
            self.remarksCountLbl.text = "\(followUpRemarksLength)/\(followUpRemarksLength)"
            return false
        }
        else
        {
            self.remarksCountLbl.text = "\(newLength)/\(followUpRemarksLength)"
            return true
        }
    }
    
    //MARK:- Private function
    
    private func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    private func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (remarksTxtView.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxtView.text!)
            }
        }
        return false
    }
    
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        self.dueDateTxtField.text = date
    }
    
    private func addFromDatePicker()
    {
        dueDatePicker = getDatePickerView()
        dueDatePicker.minimumDate = DCRModel.sharedInstance.dcrDate
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddFollowUpsViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddFollowUpsViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        dueDateTxtField.inputAccessoryView = doneToolbar
        dueDateTxtField.inputView = dueDatePicker
    }
    
    @objc func fromPickerDoneAction()
    {
        dueDate = convertDateInRequiredFormat(date: dueDatePicker.date, format: defaultServerDateFormat)
        setDateDetails(sender: dueDatePicker)
        resignResponder()
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponder()
    }
    
    private func setPlaceHolderForFromTxtFld()
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "icon-calendar")
        imageView.contentMode = UIViewContentMode.center
        imageView.tintColor = UIColor.lightGray
        self.dueDateTxtField.leftView = imageView
        self.dueDateTxtField.leftViewMode = UITextFieldViewMode.always
    }
    
    private func setDefaultRowinDatePicker(dueDate : Date)
    {
        dueDatePicker.setDate(dueDate, animated: false)
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
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddFollowUpsViewController.doneBtnClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.remarksTxtView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneBtnClicked()
    {
        resignResponder()
    }
    
}
