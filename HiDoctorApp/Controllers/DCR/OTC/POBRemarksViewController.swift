//
//  POBRemarksViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBRemarksViewController: UIViewController,UITextViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet var remarksTextView: UITextView!
    @IBOutlet var scrollViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable
    var placeHolder : String = "Add your remarks here"
    var isComingFromModify = false
    var remarksModel : DCRDoctorVisitPOBRemarksModel?
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Function to save remarks
    @IBAction func submitAction(_ sender: Any) {
        let formValidation : Bool = validation()
        
        if formValidation
        {
            if isComingFromModify == true
            {
                BL_POB_Stepper.sharedInstance.updatePOBRemarks(orderEntryId: (remarksModel?.Order_Entry_Id)!, remarks: remarksTextView.text!)
            }
            else
            {
                BL_POB_Stepper.sharedInstance.insertPOBRemarks(orderEntryId:BL_POB_Stepper.sharedInstance.orderEntryId, remarks: remarksTextView.text!)
            }
            
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Validating Activity
    func validation() -> Bool
    {
        var isValidation: Bool = true
        
        if remarksTextView.text == placeHolder
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter your remarks", viewController: self)
            isValidation = false
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
            isValidation = false
        }
        else if (remarksTextView.text.count > pobRemarksLength)
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: pobRemarksLength, viewController: self)
            isValidation = false
        }
        else if (remarksTextView.text.count ==  0)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter remarks", viewController: self)
        }
        return isValidation
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarksTextView.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTextView.text!)
            }
        }
        return false
    }
    
    //MARK:- Custom Button Functions
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
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
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneBtnClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.remarksTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneBtnClicked()
    {
        if remarksTextView.text == EMPTY
        {
            remarksTextView.text = placeHolder
            remarksTextView.textColor = UIColor.lightGray
        }
        self.remarksTextView.resignFirstResponder()
    }
    
    //MARK:- TextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if remarksTextView.text == placeHolder
        {
            remarksTextView.textColor = UIColor.black
            remarksTextView.text = nil
        }
        self.remarksTextView.autocorrectionType = .no
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let charList = ACCEPTABLE_CHARACTERS
        var newLength = textView.text.count
        if text == "\n"  // Recognizes enter key in keyboard
        {
            textView.text = "\(textView.text!)\n"
            return false
        }
        if  text != "" && !charList.contains(text.last!)
        {
            return false
        }
        if (text == UIPasteboard.general.string)
        {
            textView.text = "\(textView.text! )" + text
            newLength = textView.text.count
        }
        
        if newLength > pobRemarksLength-1 && text != ""
        {
            let index = textView.text.index(textView.text.startIndex, offsetBy: pobRemarksLength)
            textView.text = textView.text.substring(to: index)
            newLength = textView.text.count
            return false
        }
        
        if text != ""
        {
            newLength += 1
        }
        else
        {
            newLength -= 1
        }
        
        if newLength < 0
        {
            newLength = 0
        }
        textView.autocorrectionType = .no
        return true
        
    }
    
    @objc func resignResponserForTextField()
    {
        if remarksTextView.text == EMPTY
        {
            remarksTextView.text = placeHolder
            remarksTextView.textColor = UIColor.lightGray
        }
        self.remarksTextView.resignFirstResponder()
    }

    //MARK:- Update Views
    func updateTextView()
    {
        if isComingFromModify == true
        {
            remarksModel = BL_POB_Stepper.sharedInstance.getPOBRemarks(orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
            remarksTextView.text = remarksModel?.Remarks
        }
        else
        {
            remarksTextView.text = placeHolder
        }
    }
    
    func setDefaults()
    {
        remarksTextView.text = placeHolder
        remarksTextView.textColor = UIColor.lightGray
        remarksTextView.layer.cornerRadius = 5
        remarksTextView.layer.borderWidth = 1
        remarksTextView.layer.borderColor = UIColor.lightGray.cgColor
        remarksTextView.layer.cornerRadius = 4
        remarksTextView.delegate = self
        self.navigationItem.title =  "Remarks"
        self.addTapGestureForView()
        addBackButtonView()
        self.addDoneButtonOnKeyboard()
        self.updateTextView()
        self.remarksTextView.autocorrectionType = .no
    }
    
}
