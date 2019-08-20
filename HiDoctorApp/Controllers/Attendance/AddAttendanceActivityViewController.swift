//
//  AddAttendanceActivityViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddAttendanceActivityViewController: UIViewController,selectedActivityListDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var remarksTxtFld: UITextField!
    @IBOutlet weak var fromTxtFld: UITextField!
    @IBOutlet weak var scrollViewBtm: NSLayoutConstraint!
    @IBOutlet weak var toTxtFld: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    let placeHolderForActivityName : String = "Select activity"
    var fromTimePicker = UIDatePicker()
    var toTimePicker = UIDatePicker()
    var projectObj : ProjectActivityMaster!
    var modifyActivityObj : DCRAttendanceActivityModel!
    var isComingFromModifyPage : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.addTapGestureForView()
        self.setDefaultDetails()
        self.addTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       self.addKeyBoardObserver()
       self.setActivityDetails()
    }
    
    override func viewWillDisappear(_ animated : Bool)
    {
        self.removeKeyBoardObserver()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    @IBAction func activityBtnAction(_ sender: UIButton)
    {
        let sb = UIStoryboard.init(name: attendanceActivitySb, bundle: nil)
        let nc = sb.instantiateViewController(withIdentifier: ActivityListVcID) as! ActivityListViewController
        nc.delegate = self
        self.navigationController?.pushViewController(nc, animated: false)
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
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func resignResponserForTextField()
    {
        self.remarksTxtFld.resignFirstResponder()
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
    
    private func removeKeyBoardObserver()
    {
        let center = NotificationCenter.default
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollViewBtm.constant = keyboardSize.height
                self.view.layoutIfNeeded()

                let viewPresentPosition = self.remarksTxtFld.convert(contentView.bounds, to: self.remarksTxtFld)
                
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
    
    func setDefaultDetails()
    {
        if isComingFromModifyPage
        {
            if modifyActivityObj != nil
            {
                self.activityNameLbl.text = modifyActivityObj.Activity_Name!
                self.fromTxtFld.text = modifyActivityObj.Start_Time!
                self.toTxtFld.text = modifyActivityObj.End_Time!
                if modifyActivityObj.Remarks != nil
                {
                    self.remarksTxtFld.text = modifyActivityObj.Remarks
                }
            }
        }
        
        self.setPlaceHolderForFromTxtFld()
        self.setPlaceHolderForToTxtFld()
    }
    
    func setPlaceHolderForFromTxtFld()
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "icon-time")
        imageView.contentMode = UIViewContentMode.center
        imageView.tintColor = UIColor.lightGray
        self.fromTxtFld.leftView = imageView
        self.fromTxtFld.leftViewMode = UITextFieldViewMode.always
    }
    
    func setPlaceHolderForToTxtFld()
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "icon-time")
        imageView.contentMode = UIViewContentMode.center
        self.toTxtFld.leftView = imageView
        imageView.tintColor = UIColor.lightGray
        self.toTxtFld.leftViewMode = UITextFieldViewMode.always
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton)
    {
        self.resignResponderForTxtField()

        if activityNameLbl.text == placeHolderForActivityName
        {
           showAlertView(alertText: "Please select activity")
        }
        else if (fromTxtFld.text?.count)! == 0
        {
            showAlertView(alertText: "Please select start time")
        }
        else if (toTxtFld.text?.count)! == 0
        {
            showAlertView(alertText : "Please select end time")
        }
        else if !validateFromToTime(fromTime: fromTxtFld.text!, toTime: toTxtFld.text!)
        {
            showAlertView(alertText : " \"End Time\" should be greater than \"Start Time\".")
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Attendance remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if ((remarksTxtFld.text?.count)! > attendanceActivityRemarksLength)
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: attendanceActivityRemarksLength, viewController: self)
        }
        else
        {
            self.saveActivityDetails()
        }
    }
    
    func showAlertView(alertText : String)
    {
        AlertView.showAlertView(title: alertTitle, message: alertText, viewController: self)
    }
    
    private func addTimePicker()
    {
        fromTimePicker = getTimePickerView()
        fromTimePicker.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddAttendanceActivityViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddAttendanceActivityViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        fromTxtFld.inputAccessoryView = doneToolbar
        fromTxtFld.inputView = fromTimePicker
        
        
        let Toolbar = getToolBar()
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddAttendanceActivityViewController.doneBtnAction))
        
        let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddAttendanceActivityViewController.cancelBtnClicked))
        toTimePicker = getTimePickerView()
        toTimePicker.tag = 2
        Toolbar.items = [flexSpace, doneBtn, cancelBtn]
        Toolbar.sizeToFit()
        toTxtFld.inputAccessoryView = Toolbar
        toTxtFld.inputView = toTimePicker
    }
    
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: fromTimePicker)
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnAction()
    {
        self.setTimeDetails(sender: toTimePicker)
        self.resignResponderForTxtField()
    }

    
    func resignResponderForTxtField()
    {
        self.fromTxtFld.resignFirstResponder()
        self.toTxtFld.resignFirstResponder()
    }
    
    func setTimeDetails(sender : UIDatePicker)
    {
        let time = sender.date
        
        if sender.tag == 1
        {
            self.fromTxtFld.text = stringFromDate(date1: time)
        }
        else
        {
            self.toTxtFld.text = stringFromDate(date1: time)
        }
    }
    
    
    func saveActivityDetails()
    {
        if isComingFromModifyPage
        {
            self.setModifyDetails()
            BL_DCR_Attendance.sharedInstance.updateDCRAttendanceActivity(dcrAttendanceActivityObj: modifyActivityObj)
        }
        else
        {
            BL_DCR_Attendance.sharedInstance.saveDCRAttendanceActivity(objProjectActivityModel: projectObj, startTime: fromTxtFld.text!, endTime: toTxtFld.text!, remarks: remarksTxtFld.text!)
        }
        _ = navigationController?.popViewController(animated: false)
    }
    
    func getSelectedActivityListDelegate(obj : ProjectActivityMaster)
    {
        projectObj = obj
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (remarksTxtFld.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                if isComingFromModifyPage
                {
                    self.modifyActivityObj.Remarks = remarksTxtFld.text!
                }
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxtFld.text!)
            }
        }
        return false
    }
    
    func setActivityDetails()
    {
        if projectObj != nil
        {
            self.activityNameLbl.text = projectObj.Activity_Name!
        }
    }
    
    func setModifyDetails()
    {
        if modifyActivityObj != nil
        {
            if projectObj != nil
            {
                self.modifyActivityObj.Activity_Code = checkNullAndNilValueForString(stringData: projectObj.Activity_Code)
                self.modifyActivityObj.Activity_Name = checkNullAndNilValueForString(stringData: projectObj.Activity_Name)
                self.modifyActivityObj.Project_Code = checkNullAndNilValueForString(stringData: projectObj.Project_Code)
                self.modifyActivityObj.Project_Name =    checkNullAndNilValueForString(stringData: projectObj.Project_Name)
            }
            self.modifyActivityObj.Start_Time = fromTxtFld.text
            self.modifyActivityObj.End_Time = toTxtFld.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /*if textField.tag == 2
        {
            let text = textField.text ?? ""
            
            var newLength = text.count + (string.count - range.length)
            
            if newLength > attendanceActivityRemarksLength
            {
                let lengthDiff = attendanceActivityRemarksLength - newLength
                let start = string.startIndex
                let end = string.index((string.endIndex), offsetBy: lengthDiff)
                let substring = string[start..<end]
                
                if substring != ""
                {
                    textField.text = "\(textField.text!)" + substring
                }
                
                return false
            }
            
            if (text == UIPasteboard.general.string)
            {
                textField.text = "\(textField.text! )" + text
                newLength = (textField.text?.count)!
                if newLength > attendanceActivityRemarksLength
                {
                    let lengthDiff = attendanceActivityRemarksLength - newLength
                    let start = string.startIndex
                    let end = string.index((string.endIndex), offsetBy: lengthDiff)
                    let substring = string[start..<end]
                    if substring != ""
                    {
                        textField.text = "\(textField.text!)" + substring
                    }
                    return false
                }
            }
        }*/
        return true
    }
}
