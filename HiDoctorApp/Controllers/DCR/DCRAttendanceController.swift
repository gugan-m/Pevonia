//
//  DCRAttendanceController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 24/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit

class DCRAttendanceController:UIViewController,UITextViewDelegate,leaveEntryListDelegate, UITextFieldDelegate,UIPickerViewDelegate , UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.activityList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityList[row].Activity_Name
    }
    
   
    @IBOutlet weak var pickerViewtext: UITextField!
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedActivity = activityList[row].Activity_Name
        let dict:NSDictionary = ["Activity_Code":activityList[row].Activity_Code,"Activity_Name":activityList[row].Activity_Name,"Project_Code":activityList[row].Project_Code!,"Project_Name":EMPTY]
        pickerViewtext.text = activityList[row].Activity_Name
        self.ActivityCode = activityList[row].Activity_Code
        self.ProjectCode = activityList[row].Project_Code
        projectObj = ProjectActivityMaster(dict: dict)
    
    }
    
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
    var IS_VIEW_MODE = false
    var isBAckSpace = false
    
    //MARK:- Variables
    var toTimePicker = UIDatePicker()
    var leaveTypeName : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var leaveTypeCode : String = ""
    var leaveTypeId : String = ""
    var ActivityCode = ""
    var ProjectCode = ""
    var isInsertedFromDCR: Bool = false
    let placeHolderForLeaveType : String = "Select Not Working Type"
    var projectObj : ProjectActivityMaster!
    var activityList : [ProjectActivityMaster] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .white

        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        pickerViewtext.inputView = picker
        pickerViewtext.inputAccessoryView = toolBar
         activityList = BL_DCR_Attendance.sharedInstance.getProjectActivityList()!
        submitbtn.layer.cornerRadius = 5
        pickerViewtext.text = activityList[0].Activity_Name
        self.ActivityCode = activityList[0].Activity_Code
        self.ProjectCode = activityList[0].Project_Code
        self.addKeyBoardObserver()
        addBackButtonView()
        self.addTapGestureForView()
        self.addDoneButtonOnKeyboard()
        self.leaveReason.autocorrectionType = .no
        // Do any additional setup after loading the view.
        let tpDate = DCRModel.sharedInstance.dcrDate
        txtCount.text = "\(String(0))/\(tpLeaveReasonLength)"
        startDate = DCRModel.sharedInstance.dcrDate
        self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + " (office)"
       // fromDateLbl.text = stringDateFormat(date1: DCRModel.sharedInstance.dcrDate!)
        //fromDateLbl.isEnabled = false
        leaveReason.delegate = self
        
       
        if DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue
        {
            
           // selectLeaveType.text = leaveTypeName
            leaveReason.text = ""
            
            
        }
        else
        {
            updateViews()
        }
        
        if IS_VIEW_MODE {
            self.scrollView.isUserInteractionEnabled = false
            self.submitbtn.isHidden = true
        } else {
            self.scrollView.isUserInteractionEnabled = true
             self.submitbtn.isHidden = false
        }
        
        
    }
    func donePicker() {

        pickerViewtext.resignFirstResponder()

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
           if textView.text.count == 1 {
               textView.text = " • " + textView.text
           }
        if isBAckSpace == false {
            if textView.text.last == "\n" {
               textView.text =  textView.text + " • "
            }
        }
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
                showAlertToConfirmAppliedMode()
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

          if text == "" {
            isBAckSpace = true
          } else {
            isBAckSpace = false
        }
//         if !charList.contains(text.last!)
//        {
//            return true
//        }
//
        
//        if (text == UIPasteboard.general.string)
//        {
//            let index = textView.text.index(textView.text.startIndex, offsetBy: tpLeaveReasonLength)
//            textView.text = textView.text.substring(to: index)
//            newLength = textView.text.count
//            self.txtCount.textColor = UIColor.red
//            self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
//        }
//
//        if newLength > tpLeaveReasonLength-1 && text != ""
//        {
//            let index = textView.text.index(textView.text.startIndex, offsetBy: tpLeaveReasonLength)
//            textView.text = textView.text.substring(to: index)
//            newLength = textView.text.count
//            self.txtCount.textColor = UIColor.red
//            self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
//            return false
//        }
//
//        if text != ""
//        {
//            newLength += 1
//        }
//        else
//        {
//            newLength -= 1
//        }
//
//        if newLength < 0
//        {
//            newLength = 0
//        }
//
//        self.txtCount.textColor = UIColor.darkGray
//        self.txtCount.text = "\(newLength)/\(tpLeaveReasonLength)"
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
          let unApprovedObj = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: DCRModel.sharedInstance.dcrDateString)
                     
                     if unApprovedObj != nil
                     {
                         //startDate = (unApprovedObj?.TP_Date)!
                         //leaveTypeCode = (unApprovedObj?.Activity_Code)!
                        // leaveTypeId = String((unApprovedObj?.Project_Code)!)
                         //leaveTypeName = String((unApprovedObj?.Activity_Name)!)
                         
                         //selectLeaveType.text = placeHolderForLeaveType
                         
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
                             
                             //selectLeaveType.text = leaveTypeName
                         }
                        self.ActivityCode = unApprovedObj?.Activity_Code ?? ""
                        self.ProjectCode = unApprovedObj?.Project_Code ?? ""
                        for i in activityList
                        {
                            if self.ActivityCode == i.Activity_Code
                            {
                                self.pickerViewtext.text = i.Activity_Name
                            }
                        }
                        
                         leaveReason.text = unApprovedObj?.Remarks
                         if checkNullAndNilValueForString(stringData: unApprovedObj?.UnApprove_Reason) != EMPTY
                         {
                             leaveReason.text = unApprovedObj?.Remarks
                             txtCount.text =  "\(String(leaveReason.text.count))/\(tpLeaveReasonLength)"
                         }
                     }
                 else
                 {
                    // fromDateLbl.text = stringDateFormat(date1: startDate)
                     //fromDateLbl.isEnabled = false
                     txtCount.text = "\0/\(tpLeaveReasonLength)"
                     leaveReason.text = EMPTY
                  //   selectLeaveType.text = placeHolderForLeaveType
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
        let alertMessage =  "Your DVR for Office will be submitted in Applied status. Once submitted you cannot edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel'."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: CANCEL, style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            let dcrActivityList = DBHelper.sharedInstance.getDCRAttendanceActivities(dcrId: DCRModel.sharedInstance.dcrId)
            print(dcrActivityList!.count)
               if (DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue)
                    {
                        DBHelper.sharedInstance.updateDCRAttendanceActivity1(Project_Code: self.ProjectCode, Activity_Code: self.ActivityCode, startTime: "", endTime: "", remarks: self.leaveReason.text!, Dcr_id: DCRModel.sharedInstance.dcrId)
                        BL_DCR_Leave.sharedInstance.updateOffice(leaveDate: DCRModel.sharedInstance.dcrDate, leaveTypeId: "", leaveTypeCode: "", leaveReason: self.leaveReason.text, dcrCode: DCRModel.sharedInstance.dcrCode ?? "")
                    }
                    else
               {
                
                
                if dcrActivityList != nil && dcrActivityList?.count == 0 {
                   // BL_DCR_Leave.sharedInstance.applyOffice(dcrDate: DCRModel.sharedInstance.dcrDate, endDate: DCRModel.sharedInstance.dcrDate, leaveTypeId: "", leaveTypeCode: "", leaveReason: self.leaveReason.text, dcrCode: DCRModel.sharedInstance.dcrCode ?? "")
                    DBHelper.sharedInstance.updateDCRAttendance(dcrId: DCRModel.sharedInstance.dcrId, leaveReason: self.leaveReason.text, status: String(DCRStatus.applied.rawValue))
                    
                    BL_DCR_Attendance.sharedInstance.saveDCRAttendanceActivity1(Project_Code: self.ProjectCode, Activity_Code: self.ActivityCode, startTime: "", endTime: "", remarks: self.leaveReason.text!, dcrId: DCRModel.sharedInstance.dcrId)
                } else {
                   // DBHelper.sharedInstance.updateDCRAttendanceActivity1(Project_Code: self.ProjectCode, Activity_Code: self.ActivityCode, startTime: "", endTime: "", remarks: self.leaveReason.text!, Dcr_id: DCRModel.sharedInstance.dcrId)
                    DBHelper.sharedInstance.updateDCRAttendance(dcrId: DCRModel.sharedInstance.dcrId, leaveReason: self.leaveReason.text, status: String(DCRStatus.applied.rawValue))
                    BL_DCR_Leave.sharedInstance.updateOffice(leaveDate: DCRModel.sharedInstance.dcrDate, leaveTypeId: "", leaveTypeCode: "", leaveReason: self.leaveReason.text, dcrCode: DCRModel.sharedInstance.dcrCode ?? "")
                }
                
               
              
                //BL_DCR_Leave.sharedInstance.updateOffice(leaveDate: DCRModel.sharedInstance.dcrDate, leaveTypeId: "", leaveTypeCode: "", leaveReason: self.leaveReason.text, dcrCode: DCRModel.sharedInstance.dcrCode ?? "")
            }
            self.showAlertToUploadTP()

            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    func showAlertToConfirmUpdateLeaveAppliedMode()
    {
        let alertMessage =  "Your DVR for Office will be submitted in Applied status. Once submitted you cannot edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel'."

        
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
        
        let alertMessage = "Your DVR for Office is ready to be submitted to your Manager.\n\n Click 'Upload' to submit.\nClick 'Later' to submit later\n\nAlternatively,you can use 'Upload DVR 'option from the home screen to submit."
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { alertAction in
             self.navigateToUploadDCR(enabledAutoSync: true)
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
}
