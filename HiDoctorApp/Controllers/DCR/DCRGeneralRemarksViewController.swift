//
//  DCRGeneralRemarksViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/15/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRGeneralRemarksViewController: UIViewController, UITextViewDelegate
{
    @IBOutlet weak var prevRemarks: UILabel!
    @IBOutlet weak var remarksTxt: UITextView!
    @IBOutlet weak var lblGeneralRemarksHeader: UILabel!
    @IBOutlet weak var lblpreviousRemarkHeader: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    
    var generalRemarks : String = ""
    var isModifyPage : Bool = false
    var placeHolder : String = "Add your general remarks here"
    var isForTpStepper = false
    var isForTpAttendanceStepper = false
    var ifFromDCRAttendence: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addTapGestureForView()
        self.addKeyBoardObserver()
        addBackButtonView()
        self.addDoneButtonOnKeyboard()
        self.remarksTxt.autocorrectionType = .no
        
        prevRemarks.text = NOT_APPLICABLE
        
        if isModifyPage
        {
            let getPrevRemarks = BL_Stepper.sharedInstance.getPreviousGeneralRemarks()
            if getPrevRemarks != ""
            {
                prevRemarks.text = getPrevRemarks
            }
            generalRemarks = BL_Stepper.sharedInstance.getGeneralRemarksForModify()
            remarksTxt.text = generalRemarks
            submitBtn.setTitle("Save", for: UIControlState.normal)
            remarksTxt.textColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ifFromDCRAttendence {
            self.placeHolder = "Add your task here"
            self.lblpreviousRemarkHeader.text = "Previous Task"
            self.lblGeneralRemarksHeader.text = "Today's Task"
            self.title = "Submit your task"
        } else {
            placeHolder = "Add your general remarks here"
            self.lblpreviousRemarkHeader.text = "Previous Remarks"
            self.lblGeneralRemarksHeader.text = "General Remarks"
            self.title = "Submit your remarks"
        }
        remarksTxt.text = placeHolder
        remarksTxt.textColor = UIColor.lightGray
        submitBtn.layer.cornerRadius = 5
        remarksTxt.layer.borderWidth = 1
        remarksTxt.layer.borderColor = UIColor.lightGray.cgColor
        remarksTxt.layer.cornerRadius = 4
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitBtnAction(_ sender: AnyObject)
    {
        let formValidation : Bool = validation()
        
        if formValidation
        {
            _ = BL_Stepper.sharedInstance.updateDCRGeneralRemarks(remarksTxt: self.remarksTxt.text , dcrId : DCRModel.sharedInstance.dcrId)
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if remarksTxt.text == placeHolder
        {
            remarksTxt.textColor = UIColor.black
            remarksTxt.text = nil
        }
        self.remarksTxt.autocorrectionType = .no
    }
    
    func validation() -> Bool
    {
        var isValidation: Bool = true
        
        if remarksTxt.text == placeHolder
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter your remarks", viewController: self)
            isValidation = false
        }
            //        else if isSpecialCharacterExist()
            //        {
            //            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            //            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
            //            isValidation = false
            //        }
        else if (remarksTxt.text.count > generalRemarksLength)
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: generalRemarksLength, viewController: self)
            isValidation = false
        }
        
        return isValidation
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarksTxt.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxt.text!)
            }
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
        if remarksTxt.text == nil
        {
            remarksTxt.text = placeHolder
            remarksTxt.textColor = UIColor.lightGray
        }
        self.remarksTxt.resignFirstResponder()
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
                
                let viewPresentPosition = self.remarksTxt.convert(contentView.bounds, to: self.remarksTxt)
                
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
    
    /*func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     if text == "\n"
     {
     textView.resignFirstResponder()
     }
     return true
     }*/
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneBtnClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.remarksTxt.inputAccessoryView = doneToolbar
    }
    
    @objc func doneBtnClicked()
    {
        self.remarksTxt.resignFirstResponder()
    }
}
