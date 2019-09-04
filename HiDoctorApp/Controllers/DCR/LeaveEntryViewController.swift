//
//  LeaveEntryViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class LeaveEntryViewController: UIViewController, UITextViewDelegate,leaveEntryListDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    @IBOutlet weak var txtCount: UILabel!
    @IBOutlet weak var leaveReason: UITextField!
    @IBOutlet weak var toDatelbl: UITextField!
    @IBOutlet weak var fromDateLbl: UITextField!
    @IBOutlet weak var tableviewAttachmentList: UITableView!
   // @IBOutlet weak var enterAttachments: UITextView!
    @IBOutlet weak var selectLeaveType: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewEmptyAttachment: UIView!
    @IBOutlet weak var frameView: CornerRadiusWithShadowView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnModify: UIButton!
    
    var toTimePicker = UIDatePicker()
    var leaveTypeName : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var leaveTypeCode : String = ""
    var leaveTypeId : String = ""
    var isInsertedFromTP: Bool = false
    //var leaveList :[DCRLeaveModel] = []
   // var tapGesture = UITapGestureRecognizer()
    var leaveList :[DCRLeaveModel] = []
    
    let placeHolderForLeaveType : String = "Select Leave Type"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableviewAttachmentList.dataSource = self
        self.tableviewAttachmentList.delegate = self
        self.tableviewAttachmentList.tableFooterView = UIView()
        submitbtn.layer.cornerRadius = 5
        self.addKeyBoardObserver()
        addBackButtonView()
        self.addTimePicker()
        self.addTapGestureForView()
        self.leaveReason.autocorrectionType = .no
        // Do any additional setup after loading the view.
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
        txtCount.text = "\(String(0))/\(leaveReasonMaxLength)"
        startDate = dcrDate!
        
        if DCRModel.sharedInstance.dcrStatus == DCRStatus.newDCR.rawValue
        {
            endDate = dcrDate!
        }
        
        if DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue || DCRModel.sharedInstance.dcrStatus == DCRStatus.newDCR.rawValue
        {
            let unApprovedObj = BL_DCR_Leave.sharedInstance.getUnapprovedLeaveData(leaveDate: startDate)
            
            startDate = (unApprovedObj?.DCR_Actual_Date)!
            endDate = (unApprovedObj?.DCR_Actual_Date)!
            leaveTypeCode = (unApprovedObj?.Leave_Type_Code)!
            leaveTypeId = String((unApprovedObj?.Leave_Type_Id)!)
            leaveTypeName = BL_DCR_Leave.sharedInstance.getLeaveTypeName(leaveTypeCode: self.leaveTypeCode)
            
            fromDateLbl.text = stringDateFormat(date1: startDate)
            fromDateLbl.isEnabled = false
            toDatelbl.text = stringDateFormat(date1: endDate)
            if DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue
            {
                toDatelbl.isEnabled = false
            }
            else
            {
                toDatelbl.isEnabled = true
            }
            
            selectLeaveType.text = leaveTypeName
            leaveReason.text = unApprovedObj?.Reason
            
            let reasonLen : Int = ((unApprovedObj?.Reason?.count)!)
            txtCount.text =  "\(String(reasonLen))/\(leaveReasonMaxLength)"
        }
        else
        {
            fromDateLbl.text = stringDateFormat(date1: dcrDate!)
            fromDateLbl.isEnabled = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.leaveattachmentname()
        
    }
    func leaveattachmentname()
    {
        leaveList = Bl_Attachment.sharedInstance.getDCRLeaveAttachment(dcrDate: DCRModel.sharedInstance.dcrDateString)!
        if(leaveList.count == 0)
        {
            btnModify.isHidden = true
            btnAdd.isHidden = false
            viewEmptyAttachment.isHidden = false
        }
        else if(leaveList.count == 5)
        {
            btnModify.isHidden = false
            btnAdd.isHidden = true
            viewEmptyAttachment.isHidden = true
        }
        else
        {
            btnModify.isHidden = false
            btnAdd.isHidden = false
            viewEmptyAttachment.isHidden = true
        }
        tableviewAttachmentList.reloadData()
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
        
        UserDefaults.standard.set("1", forKey: "LeaveDCR")
        UserDefaults.standard.synchronize()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
    @IBAction func submitAction(_ sender: AnyObject)
    {
        resignResponderForTxtField()
        
        let formValidation = self.validation()
        let onlineValidation = BL_DCR_Leave.sharedInstance.isOnlineValidationRequired(leaveTypeName  : leaveTypeName)
        let leaveReason = self.leaveReason.text
        
        if formValidation
        {
            if onlineValidation
            {
                if checkInternetConnectivity()
                {
                    let applyLeave = BL_DCR_Leave.sharedInstance.canApplyLeaveForTheseDates(startDate: startDate, endDate: endDate)
                    
                    if applyLeave == ""
                    {
                        showCustomActivityIndicatorView(loadingText: authenticationTxt)
                        
                        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                            removeCustomActivityView()
                            
                            if apiResponseObj.list.count > 0
                            {
                                showCustomActivityIndicatorView(loadingText: "Saving Leave Details")
                                
                                BL_DCR_Leave.sharedInstance.applyOnlineLeave(startDate: self.startDate, endDate: self.endDate, leaveTypeCode: self.leaveTypeCode, leaveTypeName: self.leaveTypeName, leaveReason: leaveReason!)
                                { (apiResponseObject : ApiResponseModel) in
                                    
                                    removeCustomActivityView()
                                    
                                    if apiResponseObject.Status == SERVER_SUCCESS_CODE
                                    {
                                        BL_DCR_Leave.sharedInstance.applyLeave(startDate: self.startDate, endDate: self.endDate, leaveTypeId: self.leaveTypeId, leaveTypeCode: self.leaveTypeCode, leaveReason: leaveReason!, leaveArray: apiResponseObject.list)
                                        if BL_Leave_AttachmentOperation.sharedInstance.statusList.count == 0
                                        {
                                            BL_Leave_AttachmentOperation.sharedInstance.initiateOperation()
                                        }
//                                        
                                        self.successAlert()
                                        //self.showAlertToConfirmAppliedMode()
                                    }
                                    else
                                    {
                                        if (apiResponseObject.Message == EMPTY)
                                        {
                                            AlertView.showAlertView(title: errorTitle, message: "Your leave application is not accepted, please try again", viewController: self)
                                        }
                                        else
                                        {
                                            AlertView.showAlertView(title: errorTitle, message: apiResponseObject.Message, viewController: self)
                                        }
                                    }
                                }
                            }
//                            else
//                            {
//                                AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                            }
                        })
                    }
                    else
                    {
                        AlertView.showAlertView(title: errorTitle, message: applyLeave, viewController: self)
                    }
                    
                    //
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
            else
            {
                self.showAlertToConfirmAppliedMode()
            }
        }
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
    
    private func addTimePicker()
    {
        let timePicker = UIDatePicker()
        let locale = NSLocale(localeIdentifier: "en_US")
        timePicker.locale = locale as Locale
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.minimumDate = DCRModel.sharedInstance.dcrDate
        timePicker.date = DCRModel.sharedInstance.dcrDate
        timePicker.frame.size.height = timePickerHeight
        timePicker.backgroundColor = UIColor.lightGray
        
        toTimePicker = timePicker
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LeaveEntryViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(LeaveEntryViewController.cancelBtnClicked))
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        toDatelbl.inputAccessoryView = doneToolbar
        toDatelbl.inputView = toTimePicker
        timePicker.addTarget(self, action: #selector(LeaveEntryViewController.setTimeDetails), for: UIControlEvents.valueChanged)
    }
    
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: toTimePicker)
        self.resignResponderForTxtField()
    }
    
    @objc func setTimeDetails(sender : UIDatePicker)
    {
        let datePic = sender.date
        endDate = datePic
        self.toDatelbl.text = stringDateFormat(date1: datePic)
    }
    
    func stringDateFormat(date1: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFomat
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: date1)
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func resignResponderForTxtField()
    {
        self.toDatelbl.resignFirstResponder()
        self.leaveReason.resignFirstResponder()
    }
    
    func getLeaveEntrySelectedObj(obj: LeaveTypeMaster) {
        selectLeaveType.text = obj.Leave_Type_Name
        leaveTypeCode = obj.Leave_Type_Code
        leaveTypeName = obj.Leave_Type_Name
        leaveTypeId = String(obj.Leave_Type_Id)
    }
    
    func validation() -> Bool
    {
        let noOfDays = self.dateValidation()
        var isValidation: Bool = true
        
        var fromDateMonth: String?
        let dateAsString = fromDateLbl.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: dateAsString!) {
            dateFormatter.dateFormat = "MM yyyy"
            print("date is \(dateFormatter.string(from: date))")
            
            fromDateMonth = dateFormatter.string(from: date)
        }
        
        
        var toDateMonth: String?
        let toDateAsString = toDatelbl.text
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd/MM/yyyy"
        if let todate = dateFormatter1.date(from: toDateAsString!) {
            dateFormatter1.dateFormat = "MM yyyy"
            print("date is \(dateFormatter1.string(from: todate))")
            
            toDateMonth = dateFormatter1.string(from: todate)
        }
        
        
        
        if toDatelbl.text == "To"
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select todate", viewController: self)
            isValidation = false
        }
        else if fromDateMonth != toDateMonth
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select date within month", viewController: self)
            isValidation = false
        }
        else if noOfDays > 7
        {
            AlertView.showAlertView(title: alertTitle, message: "Leave period should not exceed more than 7 days", viewController: self)
            isValidation = false
        }
        else if selectLeaveType.text == placeHolderForLeaveType
        {
            isValidation = false
            AlertView.showAlertView(title: alertTitle, message: "Please select leave type", viewController: self)
        }
        else if leaveReason.text?.count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter leave reason", viewController: self)
            isValidation = false
        }
        else if condenseWhitespace(stringValue: leaveReason.text!).count == 0
        {
            isValidation = false
            AlertView.showAlertView(title: alertTitle, message: "Please Enter leave reason", viewController: self)
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Leave reason", restrictedVal: restrictedCharacter, viewController: self)
            isValidation = false
        }
        else if (leaveReason.text?.count)! > leaveReasonMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Leave reason", maxVal: leaveReasonMaxLength, viewController: self)
            isValidation = false
        }
        
        return isValidation
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text ?? ""
        
        let newLength = text.count + (string.count - range.length)
    
        if newLength > leaveReasonMaxLength
        {
            let lengthDiff = leaveReasonMaxLength - newLength
            let start = string.startIndex
            let end = string.index((string.endIndex), offsetBy: lengthDiff)
            let substring = string[start..<end]
            if substring != ""
            {
                textField.text = "\(textField.text!)" + substring
            }
            self.txtCount.text = "\(leaveReasonMaxLength)/\(leaveReasonMaxLength)"
            return false
        }
        else
        {
            self.txtCount.text = "\(newLength)/\(leaveReasonMaxLength)"
            return true
        }
    }
    
    /*func checkIsFromDateIsGreater() -> Bool
    {
        if fromDateLbl.text?.compare(toDatelbl.text!) == .orderedDescending
        {
            return true
        }
         return false
    }*/
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
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponderForTxtField))
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
    
    func dateValidation() -> Int
    {
        let currentCalendar = Calendar.current
        
        
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: startDate) else { return 0 }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: endDate) else { return 0 }
        
        //print( end - start )
        return end - start
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.leaveReason.resignFirstResponder()
        return true
    }
    
    private func showSuccessAlert()
    {
        let alertViewController = UIAlertController (title: successTitle, message: "Leave applied successfully", preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: false)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    func successAlert()
    {
        let alertMessage =  "Leave applied successfully"
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            
            self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
         self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToConfirmAppliedMode()
    {
        let alertMessage =  "Your Offline Leave is ready to submit in Applied/Approved status. Once submit you can not edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel."
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
       
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            if (DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue)
            {
                BL_DCR_Leave.sharedInstance.updateLeave(leaveDate: self.endDate, leaveTypeId: self.leaveTypeId, leaveTypeCode: self.leaveTypeCode, leaveReason: self.leaveReason.text!, dcrCode: EMPTY)
            }
            else
            {
                BL_DCR_Leave.sharedInstance.applyLeave(startDate: self.startDate, endDate: self.endDate, leaveTypeId: self.leaveTypeId, leaveTypeCode: self.leaveTypeCode, leaveReason: self.leaveReason.text!, leaveArray: [])
            }
            
            let isAutoSyncEnabled = BL_Stepper.sharedInstance.isAutSyncEnabledForDCR()
            
            if (isAutoSyncEnabled)
            {
                if (checkInternetConnectivity())
                {
                    self.navigateToUploadDCR(enabledAutoSync: true)
                }
                else
                {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
            else
            {
                //self.showAlertToUploadDCR()
                 _ = self.navigationController?.popViewController(animated: true)
            }
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func showAlertToUploadDCR()
    {
        let alertMessage =  "Your Offline leave is ready to submit to your manager.\n\n Click 'Upload' to submit leave.\nClick 'Later' to submit later\n\nAlternatively, you can use 'Upload my DVR' option from the home screen to submit your applied leave."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "LATER", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "UPLOAD", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateToUploadDCR(enabledAutoSync: false)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func navigateToUploadDCR(enabledAutoSync: Bool)
    {
//        let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier:DCRUploadVcID) as! DCRUploadController
//        vc.enabledAutoSync = enabledAutoSync
//
//        if let navigationController = self.navigationController
//        {
//            navigationController.popViewController(animated: false)
//            navigationController.pushViewController(vc, animated: true)
//        }
        
         BL_DCRCalendar.sharedInstance.getDCRUploadError(viewController: self, isFromLandingUpload: false, enabledAutoSync: enabledAutoSync)
    }
    
    //MARK:- tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaveList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let lblAttachmentName = cell.viewWithTag(1) as! UILabel
        let leaveAttachmentName = leaveList[indexPath.row]
        lblAttachmentName.text = leaveAttachmentName.attachmentName
        return cell
    }
    
    //MARK:- Action
    
    
    @IBAction func actionAddAttachment(_ sender: Any) {
        validation()
        if Bl_Attachment.sharedInstance.getLeaveAttachmentCount() < maxFileUploadCount
        {
            Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
            Attachment.sharedInstance.isFromMessage = false
            Attachment.sharedInstance.isFromChemistDay = false
            Attachment.sharedInstance.isfromLeave = true
        }
    }
    
    @IBAction func actionModify(_ sender: Any) {
        
         navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.AttachmentSb, viewController: Constants.ViewControllerNames.AttachmentVCID)
    }
    
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController) as! AttachmentViewController
        vc.isfromLeave = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
