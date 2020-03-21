//
//  TPLeaveEntryViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LeaveEntryNewViewController: UIViewController,UITextViewDelegate,leaveEntryListDelegate, UITextFieldDelegate
{
    //MARK:- IBoutlet
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var fromDateLbl: UITextField!
    @IBOutlet weak var leaveReason: UITextView!
    @IBOutlet weak var selectLeaveType: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var frameView: CornerRadiusWithShadowView!
    @IBOutlet weak var submitbtn: UIButton!
    
    //MARK:- Variables
    var toTimePicker = UIDatePicker()
    var leaveTypeName : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var leaveTypeCode : String = ""
    var leaveTypeId : String = ""
    var isInsertedFromDCR: Bool = false
    let placeHolderForLeaveType : String = "Select Not Working Type"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        submitbtn.layer.cornerRadius = 5
        self.addKeyBoardObserver()
        addBackButtonView()
        self.addTapGestureForView()
        self.addDoneButtonOnKeyboard()
        self.leaveReason.autocorrectionType = .no
        // Do any additional setup after loading the view.
        let tpDate = DCRModel.sharedInstance.dcrDate
        txtCount.text = "\(String(0))/\(tpLeaveReasonLength)"
        startDate = tpDate!
        self.title = convertDateIntoString(date: TPModel.sharedInstance.tpDate) + " (Not Working)"
        fromDateLbl.text = stringDateFormat(date1: tpDate!)
        fromDateLbl.isEnabled = false
        leaveReason.delegate = self
        
        if DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue
        {
            let unApprovedObj = BL_DCR_Leave.sharedInstance.getUnapprovedLeaveData(leaveDate: startDate)
            
            startDate = (unApprovedObj?.DCR_Actual_Date)!
            endDate = (unApprovedObj?.DCR_Actual_Date)!
            leaveTypeCode = (unApprovedObj?.Leave_Type_Code)!
            leaveTypeId = String((unApprovedObj?.Leave_Type_Id)!)
            leaveTypeName = BL_DCR_Leave.sharedInstance.getLeaveTypeName(leaveTypeCode: self.leaveTypeCode)
            
            fromDateLbl.text = stringDateFormat(date1: startDate)
            fromDateLbl.isEnabled = false
        
            selectLeaveType.text = leaveTypeName
            leaveReason.text = unApprovedObj?.Reason
            
            let reasonLen : Int = ((unApprovedObj?.Reason?.count)!)
            txtCount.text =  "\(String(reasonLen))/\(leaveReasonMaxLength)"
        }
        else
        {
            updateViews()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectLeaveType(_ sender: AnyObject)
    {
        let sb = UIStoryboard(name: leaveEntrySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: LeaveEntryDropDownVcID) as! LeaveEntryDropDownViewController
        vc.delegate = self
        UserDefaults.standard.set("2", forKey: "LeaveDCR")
        UserDefaults.standard.synchronize()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitAction(_ sender: AnyObject)
    {
        resignResponderForTxtField()
        let formValidation = self.validation()
//        if ()
//        {
//            
//        }
//        else
//        {
//        
//        dcrHeaderDict = ["DCR_Actual_Date": convertDateIntoServerStringFormat(date: nextDate), "Dcr_Entered_Date": enteredDate, "DCR_Status": String(DCRStatus.applied.rawValue), "Flag": DCRFlag.leave.rawValue, "Leave_Type_Id": Int(leaveTypeId), "Leave_Type_Code": leaveTypeCode, "Lattitude": latitude, "Longitude": longitude, "Reason": leaveReason, "Region_Code": getRegionCode(), "DCR_Code": dcrCode]
//        
//        let dcrHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dcrHeaderDict)
//        
//        DBHelper.sharedInstance.insertDCRHeader(dcrHeaderObj: dcrHeaderObj)
//        
//        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
//        }
        if formValidation
        {
            if (DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue) || (DCRModel.sharedInstance.dcrStatus == DCRStatus.drafted.rawValue)
            {
                showAlertToConfirmAppliedMode()
            }
            else
            {
                showAlertToConfirmUpdateLeaveAppliedMode()
            }
        }
    }
    
    //MARK:- Custom Button functions
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
    
    func doneBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    //MARK:- Convert Picker date to String
    func stringDateFormat(date1: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFomat
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: date1)
    }
    
    //MARK:- Validation
    func validation() -> Bool
    {
        var isValidation: Bool = true
        
//        if selectLeaveType.text == placeHolderForLeaveType
//        {
//            isValidation = false
//            AlertView.showAlertView(title: alertTitle, message: "Please select Not Working type", viewController: self)
//        }
//        else
//        if leaveReason.text?.count == 0
//        {
//            AlertView.showAlertView(title: alertTitle, message: "Please enter Not Working reason", viewController: self)
//            isValidation = false
//        }
//        else if condenseWhitespace(stringValue: leaveReason.text!).count == 0
//        {
//            isValidation = false
//            AlertView.showAlertView(title: alertTitle, message: "Please Enter Not Working reason", viewController: self)
//        }
//        else if isSpecialCharacterExist()
//        {
//            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
//            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Not Working reason", restrictedVal: restrictedCharacter, viewController: self)
//            isValidation = false
//        }
//        else if (leaveReason.text?.count)! > tpLeaveReasonLength
//        {
//            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Not Working reason", maxVal: tpLeaveReasonLength, viewController: self)
//            isValidation = false
//        }
        
//        if (isValidation)
//        {
//            let leaveTypes = BL_DCR_Leave.sharedInstance.getLeaveTypes()
//
//            if (leaveTypes != nil)
//            {
//                let filteredArray = leaveTypes!.filter{
//                    $0.Leave_Type_Name.uppercased() == selectLeaveType.text!.uppercased()
//                }
//
//                if (filteredArray.count == 0)
//                {
//                    isValidation = false
//                    AlertView.showAlertView(title: alertTitle, message: "Please choose a valid Not Working type", viewController: self)
//                }
//            }
//        }
        
        return isValidation
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (leaveReason.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: leaveReason.text!)
            }
        }
        return false
    }
    
    //MARK:- Textview Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let charList = ACCEPTABLE_CHARACTERS
        var newLength = textView.text.count
        
        if  text != "" && !charList.contains(text.last!)
        {
            return false
        }
        
        if (text == UIPasteboard.general.string)
        {
            let index = textView.text.index(textView.text.startIndex, offsetBy: tpLeaveReasonLength)
            textView.text = textView.text.substring(to: index)
            newLength = textView.text.count
            self.txtCount.textColor = UIColor.red
            self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
        }
        
        if newLength > tpLeaveReasonLength-1 && text != ""
        {
            let index = textView.text.index(textView.text.startIndex, offsetBy: tpLeaveReasonLength)
            textView.text = textView.text.substring(to: index)
            newLength = textView.text.count
            self.txtCount.textColor = UIColor.red
            self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
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
        
        self.txtCount.textColor = UIColor.darkGray
        self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
        return true
    }
    
    @objc func resignResponderForTxtField()
    {
        self.leaveReason.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.leaveReason.resignFirstResponder()
        return true
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
                
                let viewPresentPosition = self.leaveReason.convert(contentView.bounds, to: self.leaveReason)
                
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
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        self.leaveReason.inputAccessoryView = doneToolbar
    }
    
    @objc func doneClicked()
    {
        self.leaveReason.resignFirstResponder()
    }
    
    private func updateViews()
    {
        if TPModel.sharedInstance.tpStatus == TPStatus.unapproved.rawValue || TPModel.sharedInstance.tpStatus == TPStatus.drafted.rawValue
        {
            let unApprovedObj = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: DCRModel.sharedInstance.dcrDateString)
            
            if unApprovedObj != nil
            {
                startDate = (unApprovedObj?.TP_Date)!
                leaveTypeCode = (unApprovedObj?.Activity_Code)!
                leaveTypeId = String((unApprovedObj?.Project_Code)!)
                leaveTypeName = String((unApprovedObj?.Activity_Name)!)
                
                selectLeaveType.text = placeHolderForLeaveType
                
                if checkNullAndNilValueForString(stringData: leaveTypeName) != EMPTY
                {
//                    let leaveTypesList = BL_DCR_Leave.sharedInstance.getLeaveTypes()
//
//                    if (leaveTypesList != nil)
//                    {
//                        let filteredArray = leaveTypesList!.filter{
//                            $0.Leave_Type_Name.uppercased() == leaveTypeName.uppercased()
//                        }
//
//                        if (filteredArray.count > 0)
//                        {
//                            selectLeaveType.text = leaveTypeName
//                        }
//                    }
                    
                    selectLeaveType.text = leaveTypeName
                }
                
                if checkNullAndNilValueForString(stringData: unApprovedObj?.UnApprove_Reason) != EMPTY
                {
                    leaveReason.text = unApprovedObj?.Remarks
                    txtCount.text =  "\(String(leaveReason.text.count))/\(tpLeaveReasonLength)"
                }
            }
        }
        else
        {
            fromDateLbl.text = stringDateFormat(date1: startDate)
            fromDateLbl.isEnabled = false
            txtCount.text = "\0/\(tpLeaveReasonLength)"
            leaveReason.text = EMPTY
            selectLeaveType.text = placeHolderForLeaveType
        }
        
    }
    
    //MARK:- Custom Delegate Function
    func getLeaveEntrySelectedObj(obj: LeaveTypeMaster) {
        selectLeaveType.text = obj.Leave_Type_Name
        leaveTypeCode = obj.Leave_Type_Code
        leaveTypeName = obj.Leave_Type_Name
        leaveTypeId = String(obj.Leave_Type_Id)
    }
    func showAlertToConfirmAppliedMode()
    {
        let alertMessage =  "Your DVR for Not Working will be submitted in Applied status. Once submitted you cannot edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel'."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: CANCEL, style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            BL_TPStepper.sharedInstance.updateTourPlannerLeave(tpEntryId: TPModel.sharedInstance.tpEntryId, leave_type_code: self.leaveTypeCode, leave_type: "Approved in Paycom", leave_reason: self.leaveReason.text!)
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                self.showAlertToUploadTP()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
            }

            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    func showAlertToConfirmUpdateLeaveAppliedMode()
    {
        let alertMessage =  "Your DVR for Not Working will be submitted in Applied status. Once submitted you cannot edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel'."

        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: CANCEL, style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
         
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                self.showAlertToUploadTP()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
            }

            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToUploadTP()
    {
        
        let alertMessage = "Your DVR for Not Working is ready to be submitted to your Manager.\n\n Click 'Upload' to submit.\nClick 'Later' to submit later\n\nAlternatively,you can use 'Upload DVR 'option from the home screen to submit."
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateToUploadTP()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func navigateToUploadTP()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPUploadSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPUploadSelectVCID)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
