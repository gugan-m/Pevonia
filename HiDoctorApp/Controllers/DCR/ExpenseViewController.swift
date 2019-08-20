//
//  ExpenseViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController,ExpenseTypeListDelegate ,UITextFieldDelegate {

    @IBOutlet weak var remarksTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var expenseTypeLbl: UILabel!
    @IBOutlet weak var expenseTypeBtn : UIButton!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView : UIView!
    
    @IBOutlet weak var remarksCountLbl: UILabel!
    @IBOutlet weak var scrollViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var saveBtn : UIButton!
    
    var expenseTypeObj :ExpenseGroupMapping?
    var expenseModifyList : [ExpenseGroupMapping] = []
    var isFromExpenseList : Bool = false
    var expenseModifyObj : DCRExpenseModel!
    var selectedTag : Int = 1
    var expenseTypeName : String = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        if isFromExpenseList
        {
            self.navigationItem.title = "Edit Expenses Details"
            self.saveBtn.setTitle("SAVE", for: UIControlState.normal)
           if self.expenseModifyObj != nil
           {
             self.expenseTypeName = (expenseModifyObj?.Expense_Type_Name)!
           }
        }
        else
        {
            self.navigationItem.title = "Add Expenses Details"
            self.saveBtn.setTitle("SUBMIT", for: UIControlState.normal)
            self.remarksCountLbl.text = " 0/\(String(expenseRemarksMaxLength))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if isFromExpenseList
        {
            self.setExpenseModifyDetails()
        }
        else
        {
            self.setExpenseDetails()
        }
        self.addTapGestureForView()
        self.addKeyBoardObserver()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    
    }
    

    @IBAction func saveBtnAction(_ sender: Any)
    {
        
        if isValidated()
        {
            if isFromExpenseList
            {
                updateExpenseDetails()
            }
            else
            {
                saveExpensesDetails()
            }
        }
    }
    
  
    @IBAction func expenseTypeBtnAction(_ sender: Any)
    {
        self.assignAmountToObj()
        self.resignResponderForTxtField()
        let expense_sb = UIStoryboard(name: addExpenseDetailsSb, bundle: nil)
        let expense_nc = expense_sb.instantiateViewController(withIdentifier: ExpenseTypeListVcID) as! ExpensesTypeViewController
        expense_nc.delegate = self
        self.navigationController?.pushViewController(expense_nc, animated: true)
    }
    
    func assignAmountToObj()
    {
        let expenseAmount : String = (amountTxtField.text)!
        
        if isFromExpenseList && expenseAmount.count > 0
        {
            self.expenseModifyObj.Expense_Amount = NSString(string: expenseAmount).floatValue
        }
    }
    
    
     func setSelectedExpenseType(expenseObj : ExpenseGroupMapping?)
     {
        if expenseObj != nil
        {
            if isFromExpenseList && expenseModifyObj != nil
            {
                self.expenseModifyObj.Expense_Type_Code = expenseObj?.Expense_Type_Code
                self.expenseModifyObj?.Expense_Type_Name = expenseObj?.Expense_Type_Name
                self.expenseModifyObj?.Expense_Mode = expenseObj?.Expense_Mode
                self.expenseModifyObj?.Eligibility_Amount = expenseObj?.Eligibility_Amount
                self.expenseModifyObj?.Expense_Group_Id =
                    expenseObj?.Expense_Group_Id
            }
            else
            {
                self.expenseTypeObj = expenseObj
            }
        }
        self.prefillExpenseAmount(expenseObj:expenseObj!)

     }
    
     func setExpenseDetails()
     {
        if expenseTypeObj  != nil
        {
            self.expenseTypeLbl.text = expenseTypeObj?.Expense_Type_Name
        }
        else
        {
            self.expenseTypeLbl.text = "Select Expense Type"
        }
    }
    
    func prefillExpenseAmount(expenseObj : ExpenseGroupMapping)
    {
        let expenseAmount = BL_Expense.sharedInstance.getPrefillAmount(expenseTypeCode: expenseObj.Expense_Type_Code)
        if expenseAmount > 0
        {
            self.amountTxtField.text = String(expenseAmount)
        }
    }
    
    func validateExpenseDetails()
    {
        let expenseAmount : String = amountTxtField.text!
        
        if expenseTypeLbl.text == "Select Expense Type"
        {
            self.showAlertView(alertMessage: "Please select expense type")
        }
        else if BL_Expense.sharedInstance.isSameExpenseTypeAlreadyEntered(expenseTypeCode: getExpenseCode())
        {
             self.showAlertView(alertMessage: "Selected expense has been previously added")
             self.expenseTypeLbl.text = "Select Expense Type"
        }
        else if (amountTxtField.text?.count)! == 0
        {
            self.showAlertView(alertMessage:"Please enter amount")
        }
        else if (self.amountTxtField.text?.count)! > 0 && !isValidFloatNumber(value: (self.amountTxtField.text)!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Enter valid  Amount", viewController: self)
        }
        else if !maxNumberValidationCheck(value:amountTxtField.text!, maxVal: expenseMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Expense Amount", maxVal: expenseMaxVal, viewController: self)
        }
        else if !BL_Expense.sharedInstance.doEligibilityAmountValidation(enteredAmount:Float(expenseAmount), expenseTypeCode: getExpenseCode())
        {
            self.showAlertView(alertMessage: "Entered amount is more than eligibility amount")
        }
        else if (remarksTxtField.text?.count)! > 0 && isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Expense remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if (remarksTxtField.text?.count)! > expenseRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: expenseRemarksMaxLength, viewController: self)
        }
        else
        {
            self.saveExpensesDetails()
        }
    }
    
    func validateExpenseModifyDetails()
    {
        if expenseTypeLbl.text == "Select Expense Type"
        {
            self.showAlertView(alertMessage: "Please select expense type")
        }
        else if (BL_Expense.sharedInstance.isSameExpenseTypeAlreadyEntered(expenseTypeCode: (expenseModifyObj?.Expense_Type_Code)!)) && expenseTypeLbl.text != expenseTypeName
        {
            self.showAlertView(alertMessage: "Selected expense has been previously added")
            self.expenseTypeLbl.text = "Select Expense Type"
        }
        else if (amountTxtField.text?.count)! == 0
        {
            self.showAlertView(alertMessage:"Please enter amount")
        }
        else if (self.amountTxtField.text?.count)! > 0 && !isValidFloatNumber(value: (self.amountTxtField.text)!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Enter valid  Amount", viewController: self)
        }
        else if !maxNumberValidationCheck(value:amountTxtField.text!, maxVal: expenseMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Expense Amount", maxVal: expenseMaxVal, viewController: self)
        }
        else if !BL_Expense.sharedInstance.doEligibilityAmountValidation(enteredAmount:Float(amountTxtField.text!), expenseTypeCode: expenseModifyObj.Expense_Type_Code)
        {
            self.showAlertView(alertMessage: "Entered amount is more than eligibility amount")
        }
        else if (remarksTxtField.text?.count)! > 0 && isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Expense remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if (remarksTxtField.text?.count)! > expenseRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: expenseRemarksMaxLength, viewController: self)
        }
        else
        {
            self.updateExpenseDetails()
        }
    }
    
    func isValidated() -> Bool
    {
        var isValidated : Bool = true
        let remarksText : String = remarksTxtField.text!
        
        if expenseTypeLbl.text == "Select Expense Type"
        {
            self.showAlertView(alertMessage: "Please select expense type")
            isValidated = false
        }
        else if (BL_Expense.sharedInstance.isSameExpenseTypeAlreadyEntered(expenseTypeCode: getExpenseCode())) && !isFromExpenseList
        {
            self.showAlertView(alertMessage: "Selected expense has been previously added")
            self.expenseTypeLbl.text = "Select Expense Type"
            isValidated = false
        }
        else if (BL_Expense.sharedInstance.isSameExpenseTypeAlreadyEntered(expenseTypeCode: getExpenseCode())) && expenseTypeLbl.text != expenseTypeName && isFromExpenseList
        {
            self.showAlertView(alertMessage: "Selected expense has been previously added")
            self.expenseTypeLbl.text = "Select Expense Type"
            isValidated = false
        }
        else if (amountTxtField.text?.count)! == 0
        {
            self.showAlertView(alertMessage:"Please enter amount")
            isValidated = false
        }
        else if (self.amountTxtField.text?.count)! > 0 && !isValidFloatNumber(value: (self.amountTxtField.text)!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Enter valid  Amount", viewController: self)
            isValidated = false
        }
        else if !maxNumberValidationCheck(value:amountTxtField.text!, maxVal: expenseMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Expense Amount", maxVal: expenseMaxVal, viewController: self)
            isValidated = false
        }
        else if !BL_Expense.sharedInstance.doEligibilityAmountValidation(enteredAmount:Float(amountTxtField.text!), expenseTypeCode: getExpenseCode())
        {
            self.showAlertView(alertMessage: "Entered amount is more than eligibility amount")
            isValidated = false
        }
        else if condenseWhitespace(stringValue: remarksText).count == 0 && BL_Expense.sharedInstance.checkIsExpenseRemarksMandatory(expenseCode: getExpenseCode())
        {
            self.showAlertView(alertMessage: "Expense remarks is mandatory for \(expenseTypeLbl.text! as String)")
            isValidated = false
        }
        else if (remarksText.count) > 0 && isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Expense remarks", restrictedVal: restrictedCharacter, viewController: self)
            isValidated = false
        }
        else if (remarksText.count) > expenseRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: expenseRemarksMaxLength, viewController: self)
            isValidated = false
        }
        return isValidated
    }
    
    func showAlertView(alertMessage : String)
    {
        AlertView.showAlertView(title:alertTitle, message: alertMessage, viewController: self)
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (remarksTxtField.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                 return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxtField.text!)
            }
        }
        return false
    }
    
    func saveExpensesDetails()
    {
        if expenseTypeObj != nil
        {
            BL_Expense.sharedInstance.saveDcrExpense(expenseTypeCode: expenseTypeObj!.Expense_Type_Code!, expenseAmount: Float(amountTxtField.text!)!, remarks: remarksTxtField.text!,isPrefilled: 0 , isEditable: 1, expenseMode: expenseTypeObj!.Expense_Mode)
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    func setExpenseModifyDetails()
    {
        if expenseModifyObj != nil
        {
            
            self.expenseTypeLbl.text = expenseModifyObj?.Expense_Type_Name
            if expenseModifyObj.Expense_Amount != nil
            {
            let amount =  String(describing: expenseModifyObj.Expense_Amount!)
                self.amountTxtField.text = amount
            }
        
            
            if expenseModifyObj.Remarks != nil
            {
                let remarksText : String = expenseModifyObj.Remarks!
                self.remarksTxtField.text = remarksText
                self.remarksCountLbl.text = "\(remarksText.count)/\(expenseRemarksMaxLength)"
            }
            else
            {
                self.remarksCountLbl.text = " 0/\(String(expenseRemarksMaxLength))"
            }
            
            if expenseModifyObj?.Is_Prefilled == 1 && expenseModifyObj?.Is_Editable == 0
            {
                self.amountTxtField.isUserInteractionEnabled = false
                self.expenseTypeBtn.isUserInteractionEnabled = false
            }
            else if expenseModifyObj?.Is_Prefilled == 1 && expenseModifyObj?.Is_Editable == 1
            {
                self.expenseTypeBtn.isUserInteractionEnabled = false
                self.amountTxtField.isUserInteractionEnabled = true
            }
            
        }
        else
        {
            self.setExpenseDetails()
        }
        
    }
    
    func updateExpenseDetails()
    {
        if expenseModifyObj != nil
        {
            expenseModifyObj.Expense_Amount = Float(amountTxtField.text!)
            if condenseWhitespace(stringValue: (remarksTxtField.text)!).count > 0
            {
                expenseModifyObj.Remarks = remarksTxtField.text
            }
            else
            {
                expenseModifyObj.Remarks = EMPTY
            }

            
            BL_Expense.sharedInstance.updateDCRExpense(dcrExpenseObj: expenseModifyObj!)
        }
         _ = navigationController?.popViewController(animated: false)
    }
    
    func getExpenseModifyList()
    {
        let expenseList = BL_Expense.sharedInstance.getExpenseTypes()
        if (expenseList?.count)! > 0 &&  expenseModifyObj != nil
        {
            expenseModifyList = expenseList!.filter
            {
                $0.Expense_Type_Code == expenseModifyObj?.Expense_Type_Code
            }
        }
    }
   
    func getExpenseObj() -> ExpenseGroupMapping?
    {
        self.getExpenseModifyList()
        var obj : ExpenseGroupMapping?
        if expenseModifyList.count > 0
        {
           obj = expenseModifyList.first
        }
        return obj
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
    
    private func getExpenseCode() -> String
    {
        var expenseCode : String = EMPTY
        
        if isFromExpenseList
        {
            expenseCode = checkNullAndNilValueForString(stringData: expenseModifyObj?.Expense_Type_Code)
        }
        else
        {
            expenseCode = checkNullAndNilValueForString(stringData: expenseTypeObj?.Expense_Type_Code)
        }
        
        return expenseCode
    }
    
    @objc func backButtonClicked()
    {
         _ = navigationController?.popViewController(animated: false)
//         if isFromExpenseList
//         {
//             self.navigateToDCRHeader()
//         }
//         else
//         {
//        _ = navigationController?.popViewController(animated: false)
//        }
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ExpenseViewController.resignResponderForTxtField))
        view.addGestureRecognizer(tap)
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
                self.scrollViewBtmConst.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                //let currentScrollHeight = self.scrollView.frame.height - keyboardSize.height
                var currentView : UIView = UIView()
                
                if self.selectedTag == 1
                {
                    currentView = self.amountTxtField
                }
                else if selectedTag == 2
                {
                    currentView = self.remarksTxtField
                }
                
                let viewPresentPosition = currentView.convert(currentView.bounds, to: self.contentView)
                
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
    
    @objc func resignResponderForTxtField()
    {
        self.amountTxtField.resignFirstResponder()
        self.remarksTxtField.resignFirstResponder()
    }
    
    func navigateToDCRHeader()
    {
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            if viewControllers.count >= 3
            {
                let viewController1 = viewControllers[viewControllers.count - 3]
                if viewController1.isKind(of: WorkPlaceDetailsViewController.self)
                {
                    navigationController.popViewController(animated: false)
                    navigationController.popViewController(animated: true)
                }
                
            }
        }
        
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.tag == 1
        {
            remarksTxtField.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        self.selectedTag = textField.tag
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 2
        {
            let text = textField.text ?? ""
            let newLength = text.count + (string.count - range.length)
            
            if newLength > expenseRemarksMaxLength
            {
                let lengthDiff = expenseRemarksMaxLength - newLength
                let start = string.startIndex
                let end = string.index((string.endIndex), offsetBy: lengthDiff)
                let substring = string[start..<end]
                if substring != ""
                {
                    textField.text = "\(textField.text!)" + substring
                }
                self.remarksCountLbl.text = "\(expenseRemarksMaxLength)/\(expenseRemarksMaxLength)"
                return false
            }
            else
            {
                self.remarksCountLbl.text = "\(newLength)/\(expenseRemarksMaxLength)"
                return true
            }
        }
        else if textField.tag == 3
        {
            return isValidNumberForPobAmt(string : string)
        }
        return false
    }
    
    
}
