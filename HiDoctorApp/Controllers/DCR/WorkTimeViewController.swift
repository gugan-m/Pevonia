//
//  WorkTimeViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/01/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class WorkTimeViewController: UIViewController {

    //MARK:- @IBoutlet
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var fromTimeTxtFld: UITextField!
    @IBOutlet weak var toTimeTxtFld: UITextField!
    
    //MARK:- Variable Declaration
    var fromTimePicker = UIDatePicker()
    var toTimePicker = UIDatePicker()
    var showAlertCaptureLocationCount : Int = 0
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTimePickerr()
        self.setPlaceHolderForTxtFld()
        self.addTapGestureForView()
        self.setDefaultValues()
        addBackButtonView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Set Values
    func setDefaultValues()
    {
        let dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        
        if (dcrHeaderObj != nil)
        {
            if checkNullAndNilValueForString(stringData: dcrHeaderObj?.Start_Time) != EMPTY && checkNullAndNilValueForString(stringData: dcrHeaderObj?.End_Time) != EMPTY
            {
                self.setValueForTimeTextField(fromTime: dcrHeaderObj?.Start_Time, toTime: dcrHeaderObj?.End_Time)
                self.title = "Edit Work Time Details"
            }
            
        }
        else
        {
            self.title = "Add Work Time Details"
        }
    }
    
    func setValueForTimeTextField(fromTime : String? , toTime : String?)
    {
        var fromTimeTxt : String = ""
        var toTimeTxt : String = ""
        if fromTime != nil
        {
            fromTimeTxt = fromTime!
        }
        else
        {
            fromTimeTxt = fromTime!
        }
        
        if toTime != nil
        {
            toTimeTxt = toTime!
        }
        self.fromTimeTxtFld.text = fromTimeTxt
        self.toTimeTxtFld.text = toTimeTxt
    }
    
    //MARK:- Time Picker Functions
    func addTimePickerr()
    {
        fromTimePicker = getTimePickerView()
        fromTimePicker.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkTimeViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkTimeViewController.cancelBtnClicked))
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        fromTimeTxtFld.inputAccessoryView = doneToolbar
        fromTimeTxtFld.inputView = fromTimePicker
        
        toTimePicker = getTimePickerView()
        toTimePicker.tag = 2
        //toTimePicker.minimumDate =
        let Toolbar = getToolBar()
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkTimeViewController.doneBtnAction))
        let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkTimeViewController.cancelBtnClicked))
        Toolbar.items = [flexSpace, doneBtn, cancelBtn]
        Toolbar.sizeToFit()
        toTimeTxtFld.inputAccessoryView = Toolbar
        toTimeTxtFld.inputView = toTimePicker
    }
    
    //MARK:- Cancel and Done button Actions
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: fromTimePicker)
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnAction()
    {
        self.setTimeDetails(sender:toTimePicker)
        self.resignResponderForTxtField()
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    //MARK:- Set Time Picker
    func setTimeDetails(sender : UIDatePicker)
    {
        let time = sender.date
        
        if sender.tag == 1
        {
            self.fromTimeTxtFld.text = stringFromDate(date1: time)
        }
        else
        {
            self.toTimeTxtFld.text = stringFromDate(date1: time)
        }
    }
    
    //MARK:- Validation Functions
    private func validateMandatoryWorkTime()
    {
        if BL_WorkPlace.sharedInstance.checkIfWorkTimeMandatory()
        {
            if fromTimeTxtFld.text?.count == 0
            {
                showAlertView(message: "Please Select From Time")
            }
            else if toTimeTxtFld.text?.count == 0
            {
                showAlertView(message: "Please Select To Time")
            }
            else
            {
                if self.compareAndValidateTime() == true
                {
                    self.updateWorktimeDetails(fromTime: fromTimeTxtFld.text!, toTime: toTimeTxtFld.text!)
                    self.backButtonClicked()
                }
            }
        }
        else
        {
            if self.compareAndValidateTime() == true
            {
                self.updateWorktimeDetails(fromTime: fromTimeTxtFld.text!, toTime: toTimeTxtFld.text!)
                self.backButtonClicked()
            }
        }
    }
    
    private func compareAndValidateTime() -> Bool
    {
        var isValidation: Bool = true
        let fromTimeText = fromTimeTxtFld.text
        let toTimeText  =  toTimeTxtFld.text
        
        if (fromTimeText?.count)! > 0
        {
            if toTimeText?.count == 0
            {
                showAlertView(message: "Please Select To Time")
                isValidation = false
            }
        }
        
        if (toTimeText?.count)! > 0
        {
            if fromTimeText?.count == 0
            {
                showAlertView(message: "Please Select From Time")
                isValidation = false
            }
        }
        
        if ((fromTimeTxtFld.text?.count)! > 0) && ((toTimeTxtFld.text?.count)! > 0)
        {
            if !BL_WorkPlace.sharedInstance.validateFromToTime(fromTime: fromTimeText!, toTime: toTimeText!)
            {
                showAlertView(message: " \"To Time\" should be greater than \"From Time\"")
                isValidation = false
            }
            
            if BL_WorkPlace.sharedInstance.validateExistingFromTime(fromTime: fromTimeText!) == true
            {
                let startTime = self.getFirstAndLastCustomerVisitTime(first: true)
                showAlertView(message: "\(startTime) is your first \(appDoctor) / \(appChemist) / \(appStockiest) visit time. The entered start time should be lesser than this time")
                isValidation = false
            }
            
            if BL_WorkPlace.sharedInstance.validateExistingToTime(toTime: toTimeText!) == true
            {
                let endTime = self.getFirstAndLastCustomerVisitTime(first: false)
                showAlertView(message: "\(endTime) is your last \(appDoctor) / \(appChemist) / \(appStockiest) visit time. The entered end time should be greater than this time ")
                isValidation = false
            }
            
            if toTimeText == fromTimeText
            {
                showAlertView(message: " \"To Time\" should not be same as \"From Time\"")
                isValidation = false
            }
        }
        return isValidation
    }
    
    private func updateWorktimeDetails(fromTime: String,toTime: String)
    {
        let dcrModel = getDCRHeaderModel()
        BL_WorkPlace.sharedInstance.updateDCRWorkTimeDetail(dcrHeaderModelObj: dcrModel)
    }
    
    func getDCRHeaderModel() -> DCRHeaderObjectModel
    {
        let dcrModelObj : DCRHeaderObjectModel = DCRHeaderObjectModel()
        
        dcrModelObj.DCR_Id = DCRModel.sharedInstance.dcrId
        dcrModelObj.Flag = DCRModel.sharedInstance.dcrFlag
        dcrModelObj.DCR_Actual_Date = DCRModel.sharedInstance.dcrDate
        dcrModelObj.Start_Time = self.fromTimeTxtFld.text
        dcrModelObj.End_Time = self.toTimeTxtFld.text
        dcrModelObj.DCR_Status = String(DCRStatus.drafted.rawValue)
        
        return dcrModelObj
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        self.validateMandatoryWorkTime()
       
    }
    
    //MARK:- ResignTextField Responder Functions
    @objc func resignResponderForTxtField()
    {
        self.fromTimeTxtFld.resignFirstResponder()
        self.toTimeTxtFld.resignFirstResponder()
    }
    
    func setPlaceHolderForTxtFld()
    {
        fromTimeTxtFld.attributedPlaceholder = NSAttributedString(string:"From Time",attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        toTimeTxtFld.attributedPlaceholder = NSAttributedString(string:"To Time",attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    //MARK:- Adding Custom TapGesture and Back Button
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WorkTimeViewController.resignResponderForTxtField))
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
    
    func getFirstAndLastCustomerVisitTime(first: Bool) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeForAssets
        let timeArray: [Date] = BL_Stepper.sharedInstance.getCustomerVisitTimeArray()
        var startTime = ""
        var endTime = ""
        let startdateString = dateFormatter.string(from: timeArray.first!)
        //startTime = ""
        startTime = getTimeIn12HrFormat(date: getDateFromString(dateString: startdateString), timeZone: NSTimeZone.local)
        
        let endDateString = dateFormatter.string(from: timeArray.last!)
        //startTime = ""
        endTime = getTimeIn12HrFormat(date: getDateFromString(dateString: endDateString), timeZone: NSTimeZone.local)
        if first
        {
            return startTime
        }
        else
        {
            return endTime
        }
    }
}
