//
//  ExpenseDCRDetailsEditController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 02/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseDCRDetailsEditController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var dcrDate: UILabel!
    @IBOutlet weak var workCategory: UILabel!
    @IBOutlet weak var doctorVisited: UILabel!
    @IBOutlet weak var tpSFCDetail: UILabel!
    @IBOutlet weak var dcrSFCDetail: UILabel!
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var dcrStatus: UILabel!
    @IBOutlet weak var expenseType: UILabel!
    @IBOutlet weak var claimAmount: UILabel!
    @IBOutlet weak var dcrRemarks: UILabel!
    @IBOutlet weak var previousDeduction: UILabel!
    @IBOutlet weak var currentDeduction: UITextField!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dcrSFCButton: UIButton!
    @IBOutlet weak var tpSFCButton: UIButton!
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    var expenseDetileList : [ExpenseViewDCRWiseDetailList] = []
     var expenseAdditionalList : [ExpenseClaimAdditionalTypeList] = []
    var selectedIndexPath = Int()
    var isFromAdditionalView = Bool()
    var expenseSFCList :[ExpenseClaimSFC] = []
    var expenseTPSFCList :[ExpenseClaimSFC] = []
    var expenseApprovalData = ExpenseApproval()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense Deduction"
        
        currentDeduction.delegate = self
        remarkTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        self.remarkTextView.layer.cornerRadius = 5
        self.remarkTextView.layer.masksToBounds = true
        self.remarkTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.remarkTextView.layer.borderWidth = 0.8
        self.expenseDetileList = BL_ExpenseClaim.sharedInstance.expenseDCRDetailList
        self.expenseAdditionalList = BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
        self.setDefaults()

        // Do any additional setup after loading the view.
    }

   func setDefaults()
   {
    
    if(isFromAdditionalView)
    {
        dcrSFCButton.isHidden = true
        tpSFCButton.isHidden = true
        let getSelectedExpenseData = self.expenseAdditionalList[selectedIndexPath]
        let dcrDate = convertDateIntoString(dateString: getSelectedExpenseData.Dcr_Actual_Date)
        let appFormat = convertDateIntoString(date: dcrDate)
        let activity = getSelectedExpenseData.Dcr_Activity_Flag
        var displayActivity = String()
        if(activity == "F")
        {
            displayActivity = "Field"
        }
        else if(activity == "L")
        {
            displayActivity = "Leave"
        }
        else if(activity == "A")
        {
            displayActivity = "Attendance"
        }
        
        let getRemarkSize = getTextSize(text: getSelectedExpenseData.Remarks_By_User, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 28).height
        let getexpenseTpeSize = getTextSize(text: getSelectedExpenseData.Expense_Type_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 160).height
        self.workCategory.text = getSelectedExpenseData.Category
        self.activity.text = displayActivity
        self.dcrDate.text = appFormat
        self.doctorVisited.text = ""
        self.dcrStatus.text = ""
        self.expenseType.text = getSelectedExpenseData.Expense_Type_Name
        self.claimAmount.text = "\(getSelectedExpenseData.Expense_Amount!)"
        self.previousDeduction.text = "\(getSelectedExpenseData.previousDeduction)"
        self.dcrRemarks.text = getSelectedExpenseData.Remarks_By_User
        if(getSelectedExpenseData.Remarks_By_User == "")
        {
            self.dcrRemarks.text = "N/A"
        }
        self.topViewHeightConstraint.constant = CGFloat(320) + CGFloat(getRemarkSize) + CGFloat(getexpenseTpeSize)
        
        if(self.expenseAdditionalList[selectedIndexPath].isEdited)
        {
            self.currentDeduction.text = "\(self.expenseAdditionalList[selectedIndexPath].Deduction_Amount! - getSelectedExpenseData.previousDeduction)"
            self.remarkTextView.text = self.expenseAdditionalList[selectedIndexPath].Managers_Approval_Remark
        }
        else
        {
            self.currentDeduction.text = ""
            self.remarkTextView.text = ""
        }
        
    }
    else
    {
        dcrSFCButton.isHidden = false
        tpSFCButton.isHidden = false
        self.getSFCDetails()
        let getSelectedExpenseData = self.expenseDetileList[selectedIndexPath]
        let dcrDate = convertDateIntoString(dateString: getSelectedExpenseData.DCR_Date)
        let appFormat = convertDateIntoString(date: dcrDate)
        let activity = getSelectedExpenseData.DCR_Activity_Flag
        var displayActivity = String()
        if(activity == "F")
        {
            displayActivity = "Field"
        }
        else if(activity == "L")
        {
            displayActivity = "Leave"
        }
        else if(activity == "A")
        {
            displayActivity = "Attendance"
        }
        
        
        let dcrStatusText = getSelectedExpenseData.DCR_Status
        var displayStatus = String()
        if(dcrStatusText == "0")
        {
            displayStatus = "UnApproved"
        }
        else if(dcrStatusText == "1")
        {
            displayStatus = "Applied"
        }
        else if(dcrStatusText == "2")
        {
            displayStatus = "Approved"
        }
        else if(dcrStatusText == "3")
        {
            displayStatus = "Draft"
        }
        
        
        let getRemarkSize = getTextSize(text: getSelectedExpenseData.Remarks_By_User, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 16).height
        let getexpenseTpeSize = getTextSize(text: getSelectedExpenseData.Expense_Type_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 160).height
        self.workCategory.text = getSelectedExpenseData.Category
        self.activity.text = displayActivity
        self.dcrDate.text = appFormat
        self.doctorVisited.text = "\(getSelectedExpenseData.Doctor_Visit_Count!)"
        self.dcrStatus.text = displayStatus
        self.expenseType.text = getSelectedExpenseData.Expense_Type_Name
        self.claimAmount.text = "\(getSelectedExpenseData.Expense_Amount!)"
        self.previousDeduction.text = "\(getSelectedExpenseData.previousDeduction)"
        self.dcrRemarks.text = getSelectedExpenseData.Remarks_By_User
        if(getSelectedExpenseData.Remarks_By_User == "")
        {
            self.dcrRemarks.text = "N/A"
        }
        self.topViewHeightConstraint.constant = CGFloat(320) + CGFloat(getRemarkSize) + CGFloat(getexpenseTpeSize)
        if(self.expenseDetileList[selectedIndexPath].isEdited)
        {
            self.currentDeduction.text = "\(self.expenseDetileList[selectedIndexPath].Deduction_Amount!-getSelectedExpenseData.previousDeduction)"
            self.remarkTextView.text = self.expenseDetileList[selectedIndexPath].Managers_Approval_Remark
        }
        else
        {
            self.currentDeduction.text = ""
            self.remarkTextView.text = ""
        }
    }
    
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
       
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string == "-")
        {
            if(textField.text?.contains("-"))!
            {
                return false
            }
        }
        
        if(string == ".")
        {
            if(textField.text?.contains("."))!
            {
                return false
            }
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789-.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: scrollView)
        var contentOffset:CGPoint = scrollView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        scrollView.contentOffset = contentOffset
        return true
    }
  
 
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize?.height)!
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += (keyboardSize?.height)!
        }
    }
    
    @IBAction func save(_ sender: Any)
    {
        
        self.view.endEditing(true)
        if(!isFromAdditionalView)
        {
            let getSelectedExpenseData = self.expenseDetileList[selectedIndexPath]
            if(currentDeduction.text != "" && currentDeduction != nil && currentDeduction.text != "-")
            {
                let deductionAmount = Float(currentDeduction.text!)
                let previousDeduction = expenseDetileList[selectedIndexPath].Deduction_Amount
                if(previousDeduction! + Float(deductionAmount!) <= expenseDetileList[selectedIndexPath].Expense_Amount)
                {
                    expenseDetileList[selectedIndexPath].Deduction_Amount  =  getSelectedExpenseData.previousDeduction + Float(deductionAmount!)
                    
                    expenseDetileList[selectedIndexPath].Managers_Approval_Remark = remarkTextView.text
                    
                    
                    for expenseData in expenseDetileList
                    {
                        expenseData.Approved_Amount = expenseData.Expense_Amount - expenseData.Deduction_Amount
                    }
                    
                    for expenseData in BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
                    {
                        expenseData.Approved_Amount = expenseData.Expense_Amount - expenseData.Deduction_Amount
                    }
                    expenseDetileList[selectedIndexPath].isEdited = true
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Deduction Amount is greater than Expense Amount", viewController: self)
                }
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: "Please Enter Deduction Amount to save", viewController: self)
            }
        }
        else
        {
            let getSelectedExpenseData = self.expenseAdditionalList[selectedIndexPath]
            if(currentDeduction.text != "" && currentDeduction != nil)
            {
                let deductionAmount = Float(currentDeduction.text!)
                let previousDeduction = expenseAdditionalList[selectedIndexPath].Deduction_Amount
                if(previousDeduction! + Float(deductionAmount!) <= expenseAdditionalList[selectedIndexPath].Expense_Amount)
                {
                    expenseAdditionalList[selectedIndexPath].Deduction_Amount  = getSelectedExpenseData.previousDeduction + Float(deductionAmount!)  
                    
                    expenseAdditionalList[selectedIndexPath].Managers_Approval_Remark = remarkTextView.text
                    
                    for expenseData in expenseDetileList
                    {
                        expenseData.Approved_Amount = expenseData.Expense_Amount - expenseData.Deduction_Amount
                    }
                    
                    for expenseData in BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
                    {
                        expenseData.Approved_Amount = expenseData.Expense_Amount - expenseData.Deduction_Amount
                    }
                    expenseAdditionalList[selectedIndexPath].isEdited = true
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Deduction Amount is greater than Expense Amount", viewController: self)
                }
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: "Please Enter Deduction Amount to save", viewController: self)
            }
        }
        
        
    }
    
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        
        // Pull a bunch of info out of the notification
        if let scrollView = scrollView, let userInfo = notification.userInfo,  let endValue = userInfo[UIKeyboardFrameEndUserInfoKey], let durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps the scroll view
            // We can do this because our scroll view's frame is already in our view's coordinate system
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset to avoid the keyboard
            // Don't forget the scroll indicator too!
            scrollView.contentInset.bottom = keyboardOverlap
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
            
            let duration = (durationValue as AnyObject).doubleValue
            UIView.animate(withDuration: duration!, delay: 0, options: .beginFromCurrentState, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func getSFCDetails()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Expense data...")
            WebServiceHelper.sharedInstance.getExpenseViewDetailList(userCode: expenseApprovalData.Favouring_User_Code, claimCode: expenseApprovalData.Claim_Code, claimDate: BL_ExpenseClaim.sharedInstance.expenseDCRDetailList[selectedIndexPath].DCR_Date, flag: BL_ExpenseClaim.sharedInstance.expenseDCRDetailList[selectedIndexPath].DCR_Activity_Flag, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        let expenseViewData = apiObj.list[0] as! NSDictionary
                        let dcrSfcExpense = expenseViewData.value(forKey: "lstDcrSfcDetails") as! NSArray
                        let tpSfcExpense = expenseViewData.value(forKey: "lstTPSfcDetails") as! NSArray
                        //self.expenseDCRDetailList = []
                         var expenseSFCObj = ExpenseClaimSFC()
                        
                        for expenseObj in dcrSfcExpense
                        {
                            expenseSFCObj = ExpenseClaimSFC()
                            expenseSFCObj.Distance = (expenseObj as AnyObject).value(forKey: "Distance") as! Int
                            expenseSFCObj.Category = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Category") as? String)
                            expenseSFCObj.Distance_Fare_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Distance_Fare_Code") as? String)
                            expenseSFCObj.From_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "From_Place") as? String)
                            expenseSFCObj.To_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "To_Place") as? String)
                            expenseSFCObj.Travel_Mode = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Travel_Mode") as? String)
                            
                            
                            self.expenseSFCList.append(expenseSFCObj)
                        }
                        
                        for expenseObj in tpSfcExpense
                        {
                            expenseSFCObj = ExpenseClaimSFC()
                            expenseSFCObj.Distance = (expenseObj as AnyObject).value(forKey: "Distance") as! Int
                            expenseSFCObj.Category = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Category") as? String)
                            expenseSFCObj.Distance_Fare_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Distance_Fare_Code") as? String)
                            expenseSFCObj.From_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "From_Place") as? String)
                            expenseSFCObj.To_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "To_Place") as? String)
                            expenseSFCObj.Travel_Mode = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Travel_Mode") as? String)
                            
                            
                            self.expenseTPSFCList.append(expenseSFCObj)
                        }
                        
                    }
                   // self.getExpenceDataList()
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    @IBAction func dcrSFC(_ sender: Any)
    {
        if(expenseSFCList.count > 0)
        {
            let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimSFCListViewControllerID") as! ExpenseClaimSFCListViewController
            vc.expenseSFCList = expenseSFCList
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            showToastView(toastText: "No \(PEV_DCR) SFC found")
        }
        
    }
    @IBAction func tpSFC(_ sender: Any)
    {
        if(expenseTPSFCList.count > 0)
        {
            let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimSFCListViewControllerID") as! ExpenseClaimSFCListViewController
            vc.expenseSFCList = expenseTPSFCList
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            showToastView(toastText: "No TP SFC found")
        }
        
        
    }

}
