//
//  TPMeetingPointViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPMeetingPointViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
{
    @IBOutlet weak var meetingPointTV: UITextView!
    @IBOutlet weak var meetingPointTF: UITextField!
    @IBOutlet weak var meetingTimeTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet var textCountLabel: UILabel!
    
    var timePicker = UIDatePicker()
    var fromModify = false
    var  meetingModel:TourPlannerHeader?
    var placeHolder : String = "Enter Meeting Point here"
    let meetingTimePlaceHolderText: String = "Select time"
    
    //MARK:- ViewController Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateMeetingPlace()
        self.addTimePicker()
        self.addTapGestureForView()
        self.setPlaceHolderForTxtFld()
        self.addDoneButtonOnKeyboard()
        self.navigationItem.title = "\(PEV_TP) Meeting Point"
        meetingPointTV.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        addBackButtonView()
    }
    
    //MARK:- Functions for updating views
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
        timePicker = getTimePickerView()
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        if (fromModify == true) && (meetingModel?.Meeting_Time != EMPTY)
        {
            timePicker.date = convertStringToDate(string: meetingModel!.Meeting_Time!, timeZone: localTimeZone, format: timeFormat)
        }
        
        meetingTimeTF.inputAccessoryView = doneToolbar
        meetingTimeTF.inputView = timePicker
    }
    
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: timePicker)
        self.meetingTimeTF.resignFirstResponder()
        self.meetingPointTV.resignFirstResponder()
    }
    
    @objc func cancelBtnClicked()
    {
        self.meetingTimeTF.resignFirstResponder()
        self.meetingPointTV.resignFirstResponder()
    }
    
    func setTimeDetails(sender : UIDatePicker)
    {
        let time = sender.date
        self.meetingTimeTF.text = stringFromDate(date1: time)
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponderForTxtField()
    {
        self.meetingTimeTF.resignFirstResponder()
        self.meetingPointTV.resignFirstResponder()
    }
    
    func setPlaceHolderForTxtFld()
    {
        self.meetingPointTV.layer.cornerRadius = 5
        self.meetingPointTV.layer.borderColor = UIColor.lightGray.cgColor
        self.meetingPointTV.layer.borderWidth = 1
        self.meetingPointTV.autocorrectionType = .no
        
        if(fromModify)
        {
            let getTpMeetingObject = BL_TPStepper.sharedInstance.getMeetingDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)!
            
            meetingPointTV.text = getTpMeetingObject.Meeting_Place!
            
            if getTpMeetingObject.Meeting_Time == EMPTY
            {
                meetingTimeTF.text = meetingTimePlaceHolderText
            }
            else
            {
                meetingTimeTF.text = getTpMeetingObject.Meeting_Time
            }
        }
        else
        {
            meetingPointTV.text = placeHolder
            meetingPointTV.textColor = UIColor.gray
            meetingTimeTF.attributedPlaceholder = NSAttributedString(string: meetingTimePlaceHolderText,attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
    }
    
    //MARK:- Meeting Details Validation
    func validation() -> Bool
    {
        if ((meetingPointTV.text?.count)! > meetingPlaceLength)
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Meeting Point", maxVal: meetingPlaceLength, viewController: self)
            return false
        }
        
        if (BL_TPStepper.sharedInstance.isMeetingPlaceTimeMandatory())
        {
            if ((meetingPointTV.text == placeHolder) || (condenseWhitespace(stringValue: meetingPointTV.text) == EMPTY))
            {
                AlertView.showAlertView(title: alertTitle, message: "Please enter Meeting point")
                return false
            }
            
            if (meetingTimeTF.text == meetingTimePlaceHolderText || meetingTimeTF.text == EMPTY)
            {
                AlertView.showAlertView(title: alertTitle, message: "Please enter Meeting time")
                return false
            }
        }
        
        if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Meeting Point", restrictedVal: restrictedCharacter, viewController: self)
            return false
        }
        
        return true
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (meetingPointTV.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: meetingPointTV.text!)
            }
        }
        
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if meetingPointTV.text == placeHolder
        {
            meetingPointTV.textColor = UIColor.black
            meetingPointTV.text = nil
        }
        self.meetingPointTV.autocorrectionType = .no
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.autocorrectionType = .no
        return true
    }
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
            textView.text = "\(textView.text! )" + text
            newLength = textView.text.count
            self.textCountLabel.textColor = UIColor.red
            self.textCountLabel.text = "\(newLength)/\(meetingPlaceLength)"
        }
        
        if newLength > meetingPlaceLength-1 && text != ""
        {
            let index = textView.text.index(textView.text.startIndex, offsetBy: meetingPlaceLength)
            textView.text = textView.text.substring(to: index)
            newLength = textView.text.count
            self.textCountLabel.textColor = UIColor.red
            self.textCountLabel.text = "\(newLength)/\(meetingPlaceLength)"
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
        self.textCountLabel.textColor = UIColor.darkGray
        self.textCountLabel.text = "\(newLength)/\(meetingPlaceLength)"
        textView.autocorrectionType = .no
        return true
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneClicked))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.meetingPointTV.inputAccessoryView = doneToolbar
    }
    
    @objc func doneClicked()
    {
        self.meetingPointTV.resignFirstResponder()
    }

    
    //Save MeetingDetails
    @IBAction func didTapSaveBtn(_ sender: Any)
    {
        let formValidation : Bool = validation()
        
        if formValidation
        {
            if (meetingTimeTF.text?.count)! == 0 || (meetingTimeTF.text! == meetingTimePlaceHolderText)
            {
                meetingTimeTF.text = EMPTY
            }
            
            if (meetingPointTV.text == placeHolder)
            {
                meetingPointTV.text = EMPTY
            }
            
            if (meetingTimeTF.text != EMPTY || meetingPointTV.text != EMPTY)
            {
                BL_TPStepper.sharedInstance.updateMeetingPointAndTime(Date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag, meeting_place: meetingPointTV.text!, meeting_Time: meetingTimeTF.text!)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateMeetingPlace()
    {
        if fromModify == true
        {
            if(meetingModel == nil)
            {
                meetingModel = BL_TPStepper.sharedInstance.objTPHeader
                meetingPointTV.text = checkNullAndNilValueForString(stringData: meetingModel?.Meeting_Place!)
                self.textCountLabel.text = "\(meetingPointTV.text.count)/\(meetingPlaceLength)"
            }
        }
        else
        {
            self.textCountLabel.text = "0/\(meetingPlaceLength)"
        }
    }
}


