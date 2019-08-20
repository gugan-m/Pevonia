//
//  ChimestDayVisitController.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistDayVisitController: UIViewController,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serverTimeLbl: UILabel!
    @IBOutlet weak var serverViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var visitModeViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var visitModeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var visitTimePobHgtConst: NSLayoutConstraint!
    @IBOutlet weak var visitTimeTxtField: UITextField!
    @IBOutlet weak var remarksTxtField: UITextField!
    @IBOutlet weak var remarksCountLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var amBtn : UIButton!
    @IBOutlet weak var pmBtn : UIButton!
    @IBOutlet weak var leadingSpaceToVisitTimeConst: NSLayoutConstraint!
    
    var isComingFromModifyPage : Bool = false
    var specialityName : String = EMPTY
    var chemistName : String = EMPTY
    var customerMasterObj:CustomerMasterModel!
    var showAlertCaptureLocationCount : Int = 0
    var visitTime : String = EMPTY
    var visitMode : String = AM
    var visitTimePicker = UIDatePicker()
    var modifyChemistVisitObj : ChemistDayVisit!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDCRChemistVisitObj()
        self.setVisitViewIntialWidthConst()
        self.setDefaultDetails()
        addBackButtonView()
        self.remarksTxtField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        showAlertCaptureLocationCount = 0
    }

    @IBAction func visitModeBtn(_ sender: UIButton)
    {
        if sender.tag == 1
        {
            amBtn.isSelected = !amBtn.isSelected
            pmBtn.isSelected = false
        }
        else
        {
            pmBtn.isSelected = !pmBtn.isSelected
            amBtn.isSelected = false
        }
        self.setVisitModeValue()
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton)
    {
        self.resignTxtField()
        if checkIsVisitModeValidate() && self.visitTimeTxtField.text?.count == 0
        {
            self.showAlertView(alertMessage: "Please enter visit time")
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if (remarksTxtField.text?.count)! > chemistRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: chemistRemarksMaxLength, viewController: self)
        }
        else
        {
            if (remarksTxtField.text == EMPTY || remarksTxtField.text == nil)
            {
                remarksTxtField.text = EMPTY
            }
            self.checkIsLocationMandatory()
        }

    }
    
    func setVisitModeValue()
    {
        if amBtn.isSelected
        {
            visitMode = AM
        }
        else
        {
            visitMode = PM
        }
    }
    
    func setDefaultDetails()
    {
        self.setVisitModeDetailView()
        self.addTapGestureForView()
        self.addTimePicker()
        self.setchemistVisitDetails()
    }

    func setVisitModeDetailView()
    {
        let visitTimeEntry = getVisitTimeMode()
        if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
        {
            //            self.visitModeHgtConst.constant = 0
            //            self.visitTimePobHgtConst.constant = 50
            //            self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
            //           self.setModifyVisitDetails(type: 3)
            self.setVisitTimeMode()
        }
        else if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
        {
            //prefill time or mode and editable
            
            if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
            {
                self.visitModeViewWidthConst.constant = 155
                self.visitModeHgtConst.constant = 40
               // self.leadingSpaceToVisitTimeConst.constant = 0
                self.setModifyVisitDetails(type: 12)
            }
            else
            {
                self.visitModeHgtConst.constant = 0
                self.visitTimePobHgtConst.constant = 50
                //self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                self.setModifyVisitDetails(type: 14)
            }
        }
        else
        {
            
            if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
            {
                self.visitModeViewWidthConst.constant = 155
                self.visitModeHgtConst.constant = 40
                //self.leadingSpaceToVisitTimeConst.constant = 0
                self.setModifyVisitDetails(type: 1)
            }
            else
            {
                self.visitModeHgtConst.constant = 0
                self.visitTimePobHgtConst.constant = 50
                // self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                self.setModifyVisitDetails(type: 2)
            }
        }
    }
    
    func setVisitTimeMode()
    {
        self.visitModeHgtConst.constant = 0
        self.visitTimePobHgtConst.constant = 50
       // self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
        if isCurrentDate()
        {
            self.setModifyVisitDetails(type: 3)
        }
        else
        {
            self.setModifyVisitDetails(type: 14)
        }
    }
    
    func setchemistVisitDetails()
    {
        var navigationTitle : String = ""
        var remarksTxtCount : String = ""
        
        if isComingFromModifyPage
        {
            navigationTitle = modifyChemistVisitObj.ChemistName!
            if modifyChemistVisitObj.Remarks != nil
            {
                self.remarksTxtField.text = modifyChemistVisitObj.Remarks!
            }
            
            remarksTxtCount =  String(describing: self.remarksTxtField.text!.count)
        }
        else
        {
            if chemistName != ""
            {
                navigationTitle =  chemistName
            }
            else if customerMasterObj != nil
            {
                navigationTitle = customerMasterObj.Customer_Name
                chemistName = customerMasterObj.Customer_Name
            }
            self.amBtn.isSelected = true
            remarksTxtCount = "0"
        }
        self.navigationItem.title = navigationTitle
        self.remarksCountLbl.text = "\(remarksTxtCount)/\(chemistRemarksMaxLength)"
    }
        

    
    private func addTimePicker()
    {
        visitTimePicker = getTimePickerView()
        visitTimePicker.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ChemistDayVisitController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(ChemistDayVisitController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        visitTimeTxtField.inputAccessoryView = doneToolbar
        visitTimeTxtField.inputView = visitTimePicker
    }
    
    @objc func cancelBtnClicked()
    {
        self.visitTimeTxtField.resignFirstResponder()
    }
    
    @objc func doneBtnClicked()
    {
        let time = self.visitTimePicker.date
        let selectedVisitTime = stringFromDate(date1: time)
        self.visitTimeTxtField.text = selectedVisitTime
        self.visitMode = self.getVisitModeType(visitTime: selectedVisitTime)
        self.visitTime = selectedVisitTime
        self.visitTimeTxtField.resignFirstResponder()
    }
    
    @objc func resignTxtField()
    {
        self.visitTimeTxtField.resignFirstResponder()
        self.remarksTxtField.resignFirstResponder()
    }

    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignTxtField))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField.tag == 2
        {
            let text = textField.text ?? ""
            let newLength = text.count + (string.count - range.length)
            if newLength > chemistRemarksMaxLength
            {
                let lengthDiff = chemistRemarksMaxLength - newLength
                let start = string.startIndex
                let end = string.index((string.endIndex), offsetBy: lengthDiff)
                let substring = string[start..<end]
                if substring != ""
                {
                    textField.text = "\(textField.text!)" + substring
                }
                self.remarksCountLbl.text = "\(chemistRemarksMaxLength)/\(chemistRemarksMaxLength)"
                return false
            }
            else
            {
                self.remarksCountLbl.text = "\(newLength)/\(chemistRemarksMaxLength)"
                return true
            }
        }
        else if textField.tag == 3
        {
            return isValidNumberForPobAmt(string : string)
            
        }
        
        return false
    }

    
    func getVisitTimeMode() -> String
    {
        return BL_Common_Stepper.sharedInstance.getChemistVisitMode()
    }
    func getVisitModeType(visitTime : String) -> String
    {
        let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
        return visitTime.substring(from: lastcharacterIndex)
    }
    
    func getVisitTime(visitTime : String) -> String
    {
        return String(visitTime.dropLast(2))
    }
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
    }
    
    func setVisitMode(mode : String)
    {
        if mode == AM
        {
            self.amBtn.isSelected = true
        }
        else
        {
            self.pmBtn.isSelected = true
        }
    }
    
    
    func setVisitViewIntialWidthConst()
    {
        self.serverViewWidthConst.constant = 0
        self.visitModeViewWidthConst.constant = 0
        self.visitModeHgtConst.constant = 0
        self.visitTimePobHgtConst.constant = 0
        //self.visitTimeWidthConst.constant = 0
        //self.pobAmtViewHgtConst.constant = 0
       // self.leadingSpaceToVisitTimeConst.constant = 8
    }
    func setModifyVisitDetails(type : Int)
    {
        if isComingFromModifyPage && modifyChemistVisitObj != nil
        {
            visitTime = modifyChemistVisitObj.VisitTime!
            visitMode = modifyChemistVisitObj.VisitMode!
            if type == 0
            {
                self.serverTimeLbl.text = visitTime
            }
            else if type == 1
            {
                self.setVisitMode(mode: visitMode)
            }
            else if type == 3
            {
                if visitTime != EMPTY
                {
                    if visitTime.contains(" ")
                    {
                        self.visitTimeTxtField.text = visitTime
                        self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    }
                    else
                    {
                        self.visitTimeTxtField.text = visitTime + " " + visitMode
                        self.visitMode = self.getVisitModeType(visitTime: visitTime + " " + visitMode)
                    }
                }
                else
                {
                    self.visitTime = getServerTime()
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    self.visitTimeTxtField.text = self.visitTime
                }
                
                
                self.visitTimeTxtField.isUserInteractionEnabled = false
            }
            else if type == 12
            {
                
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.setVisitMode(mode: visitMode)
                self.amBtn.isUserInteractionEnabled = true
                self.pmBtn.isUserInteractionEnabled = true
            }
                
            else if type == 14
            {
                if visitTime != EMPTY
                {
                    if visitTime.contains(" ")
                    {
                        self.visitTimeTxtField.text = visitTime
                        self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    }
                    else
                    {
                        self.visitTimeTxtField.text = visitTime + " " + visitMode
                        self.visitMode = self.getVisitModeType(visitTime: visitTime + " " + visitMode)
                    }
                }
                else
                {
                    self.visitTime = getServerTime()
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    self.visitTimeTxtField.text = self.visitTime
                }
                
                self.visitTimeTxtField.isUserInteractionEnabled = true
            }
            else
            {
                
                if(visitTime.contains("AM") || visitTime.contains("PM"))
                {
                    self.visitTimeTxtField.text = visitTime
                }
                else
                {
                    self.visitTimeTxtField.text = visitTime + " " +  visitMode
                }
                
                
            }
        }
        else
        {
            if type == 3
            {
                self.visitTime = getServerTime()
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.visitTimeTxtField.text = self.visitTime
                
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = false
                }
            }
            else if type == 1
            {
                self.setVisitMode(mode: AM)
            }
            else if type == 12
            {
                
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.setVisitMode(mode: visitMode)
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.amBtn.isUserInteractionEnabled = true
                self.pmBtn.isUserInteractionEnabled = true
            }
            else if type == 14
            {
                self.visitTime = getServerTime()
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitTime
                
                self.visitTimeTxtField.isUserInteractionEnabled = true
            }
        }
    }

    private func isCurrentDate() -> Bool
    {
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    
    
    
    
    func checkIsLocationMandatory()
    {
        if canShowLocationMandatoryAlert()
        {
            AlertView.showAlertToEnableGPS()
        }
        else if !checkIsCapturingLocation() && showAlertCaptureLocationCount < AlertLocationCaptureCount
        {
            showAlertCaptureLocationCount += 1
            AlertView.showAlertToCaptureGPS()
        }
        else
        {
            self.saveVisitModeDetails()
            //_ = navigationController?.popViewController(animated: false)
        }
    }
    
    func saveVisitModeDetails()
    {
        if isComingFromModifyPage
        {
            
            
            if !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            {
                self.setValueToModifyObj()
                var latitude = getLatitude()
                var longitude = getLongitude()
                if(latitude == EMPTY || longitude == EMPTY)
                {
                    latitude = "0.0"
                    longitude = "0.0"
                }
                modifyChemistVisitObj.Latitude = Double(latitude)!
                modifyChemistVisitObj.Longitude = Double(longitude)!
                BL_Common_Stepper.sharedInstance.updateDCRchemistVisit(dcrChemistVisitObj: modifyChemistVisitObj, viewController: self)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                
                var isCurrentDate: Bool = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                if dateFormatter.string(from: DCRModel.sharedInstance.dcrDate) == dateFormatter.string(from: Date())
                    
                {
                    isCurrentDate = true
                }
                
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate
                {

                    let customerCode = ChemistDay.sharedInstance.customerCode
                    var postData: NSMutableArray = []
                    var dict:[String:Any] = [:]
                    
                    if  customerCode == ""
                    {
                        postData = []
                        dict = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":modifyChemistVisitObj.ChemistName,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":EMPTY,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":1,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"C"]
                        
                        postData.add(dict)
                    }
                    else
                    {
                        postData = []
                        dict = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":modifyChemistVisitObj.ChemistCode,"Doctor_Name":modifyChemistVisitObj.ChemistName,"regionCode":modifyChemistVisitObj.RegionCode,"Speciality_Name":EMPTY,"Category_Code":modifyChemistVisitObj.CategoryCode ?? EMPTY,"MDL_Number":modifyChemistVisitObj.MDLNumber,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":1,"Doctor_Region_Code":modifyChemistVisitObj.RegionCode,"Customer_Entity_Type":"C"]
                        postData.add(dict)
                        
                    }
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            let getVisitDetails = apiObj.list[0] as! NSDictionary
                            let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
                            var dateTimeArray = getVisitTime.components(separatedBy: " ")
                            let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
                            let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
                            if(compare == .orderedSame || compare == .orderedDescending)
                            {
                                self.setValueToModifyObj()
                                var latitude = getLatitude()
                                var longitude = getLongitude()
                                if(latitude == EMPTY || longitude == EMPTY)
                                {
                                    latitude = "0.0"
                                    longitude = "0.0"
                                }
                                self.modifyChemistVisitObj.Latitude = Double(latitude)!
                                self.modifyChemistVisitObj.Longitude = Double(longitude)!
                                BL_Common_Stepper.sharedInstance.updateDCRchemistVisit(dcrChemistVisitObj: self.modifyChemistVisitObj, viewController: self)
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: "DCR Date is not a current date", viewController: self)
                            }
                        }
                        else
                        {
                            removeCustomActivityView()
                            AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                        }
                    })
                }
                else{
                    
                    self.setValueToModifyObj()
                    var latitude = getLatitude()
                    var longitude = getLongitude()
                    if(latitude == EMPTY || longitude == EMPTY)
                    {
                        latitude = "0.0"
                        longitude = "0.0"
                    }
                    modifyChemistVisitObj.Latitude = Double(latitude)!
                    modifyChemistVisitObj.Longitude = Double(longitude)!
                    BL_Common_Stepper.sharedInstance.updateDCRchemistVisit(dcrChemistVisitObj: modifyChemistVisitObj, viewController: self)
                    _ = self.navigationController?.popViewController(animated: false)
                }
                
            }
            
        }
        else
        {
            let customerCode = ChemistDay.sharedInstance.customerCode
            
            let remarksText =  condenseWhitespace(stringValue: remarksTxtField.text!)
            
            if  customerCode == ""
            {
                var isCurrentDate: Bool = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                if dateFormatter.string(from: DCRModel.sharedInstance.dcrDate) == dateFormatter.string(from: Date())
                
                {
                    isCurrentDate = true
                }
                
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate
                {
                    var latitudedeValue = "0.0"
                    var longitudeValue = "0.0"
                    if getLatitude() != EMPTY
                    {
                        latitudedeValue = getLatitude()
                    }
                    if getLongitude() != EMPTY
                    {
                        longitudeValue = getLongitude()
                    }
                    let postData: NSMutableArray = []
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":self.chemistName,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":self.specialityName,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":latitudedeValue,"Longitude":longitudeValue,"Modified_Entity":0,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"C","Source_Of_Entry":"iOS"]
                    
                    postData.add(dict)
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            let getVisitDetails = apiObj.list[0] as! NSDictionary
                            let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
                            var dateTimeArray = getVisitTime.components(separatedBy: " ")
                            let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
                            let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
                            if(compare == .orderedSame)
                            {
                                removeCustomActivityView()
                                let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
                                let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
                                
                                BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: self.chemistName, specialityName: self.specialityName, visitTime: visitTime, visitMode: self.visitMode, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self)
                                
                                self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else if(compare == .orderedDescending)
                            {
                                removeCustomActivityView()
                                BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: self.chemistName, specialityName: self.specialityName, visitTime: self.visitTime, visitMode: self.visitMode, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self)
                                
                                self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: "DCR Date is not a current date", viewController: self)
                            }
                        }
                        else
                        {
                            removeCustomActivityView()
                            AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                        }
                    })
                }
                else
                {
                    BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: chemistName, specialityName: specialityName, visitTime: visitTime, visitMode: visitMode, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self)
                    self.insertDCRDoctorAccompanists()
                    _ = self.navigationController?.popViewController(animated: false)
                }
            }
            else
            {
                var isCurrentDate: Bool = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                if dateFormatter.string(from: DCRModel.sharedInstance.dcrDate) == dateFormatter.string(from: Date())
                    
                    //if DCRModel.sharedInstance.dcrDate == Date()
                {
                    isCurrentDate = true
                }
                
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate
                {
                    let userObj = getUserModelObj()
                    var latitudedeValue = "0.0"
                    var longitudeValue = "0.0"
                    if getLatitude() != EMPTY
                    {
                        latitudedeValue = getLatitude()
                    }
                    if getLongitude() != EMPTY
                    {
                        longitudeValue = getLongitude()
                    }
                    let postData: NSMutableArray = []
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":customerCode ?? EMPTY,"Doctor_Name":customerMasterObj.Customer_Name,"regionCode":customerMasterObj.Region_Code,"Speciality_Name":customerMasterObj.Speciality_Name,"Category_Code":customerMasterObj.Category_Code ?? EMPTY,"MDL_Number":customerMasterObj.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":latitudedeValue,"Longitude":longitudeValue,"Modified_Entity":0,"Doctor_Region_Code":customerMasterObj.Region_Code,"Customer_Entity_Type":"C","Source_Of_Entry":"iOS"]
                    
                    postData.add(dict)
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            let getVisitDetails = apiObj.list[0] as! NSDictionary
                            let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
                            var dateTimeArray = getVisitTime.components(separatedBy: " ")
                            let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
                            let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
                            if(compare == .orderedSame)
                            {
                                let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
                                let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
                                
                                BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: self.visitMode, entityType:self.customerMasterObj.Customer_Entity_Type, remarks: remarksText,regionCode: self.customerMasterObj.Region_Code, viewController: self)
                                self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else if(compare == .orderedDescending)
                            {
                                BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: customerCode, visitTime: self.visitTime, visitMode: self.visitMode, entityType:self.customerMasterObj.Customer_Entity_Type, remarks: remarksText,regionCode: self.customerMasterObj.Region_Code, viewController: self)
                                self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else
                            {
                                AlertView.showAlertView(title: alertTitle, message: "DCR Date is not a current date", viewController: self)
                            }
                        }
                        else
                        {
                            removeCustomActivityView()
                            AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                        }
                    })
                }
                else
                {
                    BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: visitMode, entityType:customerMasterObj.Customer_Entity_Type, remarks: remarksText,regionCode: customerMasterObj.Region_Code, viewController: self)
                    self.insertDCRDoctorAccompanists()
                    _ = self.navigationController?.popViewController(animated: false)
                }
            }
            
            
        }
    }
    
    
    func insertDCRDoctorAccompanists()
    {
        if(BL_Common_Stepper.sharedInstance.stepperIndex.accompanistIndex != 0)
        {
            //BL_DCR_Chemist_Accompanists.sharedInstance.insertDCRChemistAccompanists(dcrAccompanistList: BL_DCR_Chemist_Accompanists.sharedInstance.getDCRAccompanists())
            
            BL_DCR_Chemist_Accompanists.sharedInstance.insertDCRChemistAccompanists(dcrAccompanistList: BL_DCR_Chemist_Accompanists.sharedInstance.getDCRAccompanistsVandNA())
        }
    }
    
    func setValueToModifyObj()
    {
        self.modifyChemistVisitObj.VisitMode = visitMode
        self.modifyChemistVisitObj.VisitTime = visitTime
        self.modifyChemistVisitObj.Remarks = condenseWhitespace(stringValue: self.remarksTxtField.text!)
        
    }

    func checkIsVisitModeValidate() -> Bool
    {
        var isValidate : Bool = false
        
        let visitTimeEntry = getVisitTimeMode()
        if visitTimeEntry == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue
        {
            isValidate = true
        }
        
        return isValidate
    }
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if (remarksTxtField.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                if isComingFromModifyPage
                {
                    self.modifyChemistVisitObj.Remarks = remarksTxtField.text!
                }
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxtField.text!)
            }
        }
        return false
    }
    
    
    func showAlertView(alertMessage : String)
    {
        AlertView.showAlertView(title: alertTitle, message: alertMessage, viewController: self)
    }
    
    
    
    
    func getDCRChemistVisitObj()
    {
        let dcrChemistVisitList = BL_Common_Stepper.sharedInstance.chemistVisitList
        if dcrChemistVisitList.count > 0
        {
            let dcrChemistVisitObj = dcrChemistVisitList.first
            self.isComingFromModifyPage = true
            self.modifyChemistVisitObj = dcrChemistVisitObj
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

    
    
    
    
}
