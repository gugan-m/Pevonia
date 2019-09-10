


//
//  DoctorVisitViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 16/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//


import UIKit

class DoctorVisitViewController: UIViewController,UITextFieldDelegate,BusinessStatusSelectDelegate
{
    @IBOutlet weak var punchintime: UILabel!
    @IBOutlet weak var punchouttime: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serverTimeLbl: UILabel!
    @IBOutlet weak var serverViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var visitModeViewWidthConst: NSLayoutConstraint!
    @IBOutlet weak var visitModeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var visitTimePobHgtConst: NSLayoutConstraint!
    @IBOutlet weak var visitTimeWidthConst: NSLayoutConstraint!
    @IBOutlet weak var visitTimeTxtField: UITextField!
    @IBOutlet weak var remarksTxtField: UITextField!
    @IBOutlet weak var remarksCountLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var amBtn : UIButton!
    @IBOutlet weak var pmBtn : UIButton!
    @IBOutlet weak var pobAmtTxtField: UITextField!
    @IBOutlet weak var pobAmtViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var leadingSpaceToVisitTimeConst: NSLayoutConstraint!
    @IBOutlet weak var businessStatusViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var businessStatusView: UIView!
    @IBOutlet weak var businessStatusLabel: UILabel!
    @IBOutlet weak var callObjectiveViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var callObjectiveView: UIView!
    @IBOutlet weak var callObjectiveLabel: UILabel!
    @IBOutlet weak var campaignViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canpaignView: UIView!
    @IBOutlet weak var campaignLabel: UILabel!
    
    var isComingFromModifyPage : Bool = false
    var specialityName : String = EMPTY
    var doctorName : String = EMPTY
    var customerMasterObj:CustomerMasterModel!
    var visitTime : String = EMPTY
    var visitMode : String = AM
    var modifyDoctorVisitObj : DCRDoctorVisitModel!
    var modifyAttendanceDoctorVisitObj :DCRAttendanceDoctorModel!
    var showAlertCaptureLocationCount : Int = 0
    var visitTimePicker = UIDatePicker()
    var geoLocationSkipRemarks: String = EMPTY
    var currentLocation: GeoLocationModel!
    var objBusinessStatus: BusinessStatusModel?
    var lstBusinessStatus: [BusinessStatusModel] = []
    var lstCallObjective: [BusinessStatusModel] = []
    var objCallObjective: BusinessStatusModel?
    var isFromAttendance: Bool = false
    var campaignObj: MCHeaderModel?
    var campaignList: [MCHeaderModel] = []
    var campaignCode = String()
    var campaignName = String()
    var obj: BussinessPotential?
    var time: String = ""
    var objBusinessStatus_Dir: BusinessStatusModel?
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.getDCRDoctorVisitObj()
        self.setVisitViewIntialWidthConst()
        self.getBusinessStatusList()
        self.setDefaultDetails()
        addBackButtonView()
        //        if(!isFromAttendance)
        //        {
        campaignViewHeightConstraint.constant = 0
        canpaignView.isHidden = true
        campaignLabel.isHidden = true
        //       }
        //        else
        //        {
        setCampaignData()
        setBusinessStatusData()
        // }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        showAlertCaptureLocationCount = 0
        if ( BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate() && !isFromAttendance)
        {
            //self.visitTimeTxtField.isEnabled = false
            //self.visitTimeTxtField.alpha = 0.5
            var intime = "N/A"
            var outtime = "N/A"
            if (isComingFromModifyPage)
            {
                if (self.modifyDoctorVisitObj != nil)
                {
                    if(self.modifyDoctorVisitObj.Punch_Start_Time != "" && self.modifyDoctorVisitObj.Punch_Start_Time != nil)
                    {
                        intime = stringFromDate(date1: getDateFromString(dateString: self.modifyDoctorVisitObj.Punch_Start_Time!))
                    }
                    if(self.modifyDoctorVisitObj.Punch_End_Time != "" &&
                        self.modifyDoctorVisitObj.Punch_End_Time != nil)
                    {
                        outtime = stringFromDate(date1: getDateFromString(dateString: self.modifyDoctorVisitObj.Punch_End_Time!))
                    }
                }
            }
            else
            {
                if (self.modifyDoctorVisitObj != nil)
                {
                    if(self.modifyDoctorVisitObj.Punch_Start_Time != "" &&
                        self.modifyDoctorVisitObj.Punch_Start_Time != nil)
                    {
                        intime = stringFromDate(date1: getDateFromString(dateString: self.modifyDoctorVisitObj.Punch_Start_Time!))
                    }
                }
                else
                {
                    if (time != "")
                    {
                        intime = stringFromDate(date1: getDateFromString(dateString: time))
                    }
                }
                self.visitTimeTxtField.text = stringFromDate(date1: getDateFromString(dateString: time))
            }
            self.punchintime.text = "Punch In: \(intime)"
            self.punchouttime.text = "Punch Out: \(outtime)"
            
        }
        else
        {
            self.punchintime.isHidden = true
            self.punchouttime.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        self.showPOBAmtView()
        self.addTapGestureForView()
        self.addTimePicker()
        self.setDoctorVisitDetails()
    }
    
    func isEdetailedDoctor() -> Bool
    {
        
        if(isComingFromModifyPage)
        {
            if(modifyDoctorVisitObj.Doctor_Region_Code != nil && modifyDoctorVisitObj.Doctor_Code != nil)
            {
                let value = BL_DCR_Doctor_Visit.sharedInstance.isEdetailedDoctor(customerCode: modifyDoctorVisitObj.Doctor_Code!, regionCode: modifyDoctorVisitObj.Doctor_Region_Code!, date: DCRModel.sharedInstance.dcrDateString)
                
                return value
            }
            else
            {
                return false
            }
        }
        else
        {
            if let customerObj = customerMasterObj
            {
                if(customerMasterObj.Customer_Code != nil && customerMasterObj.Region_Code != nil)
                {
                    let value = BL_DCR_Doctor_Visit.sharedInstance.isEdetailedDoctor(customerCode: customerMasterObj.Customer_Code, regionCode: customerMasterObj.Region_Code, date: DCRModel.sharedInstance.dcrDateString)
                    
                    return value
                }
                else
                {
                    return false
                }
            }
            else
            {
                return false
            }
        }
        
        return false
    }
    func setVisitMode()
    {
        self.visitModeViewWidthConst.constant = 155
        self.visitModeHgtConst.constant = 40
        self.leadingSpaceToVisitTimeConst.constant = 0
        self.setModifyVisitDetails(type: 11)
    }
    func setVisitTimeMode()
    {
        self.visitModeHgtConst.constant = 0
        self.visitTimePobHgtConst.constant = 50
        self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
        if isCurrentDate()
        {
            self.setModifyVisitDetails(type: 3)
        }
        else
        {
            self.setModifyVisitDetails(type: 14)
        }
        
    }
    func setVisitModeDetailView()
    {
        let visitTimeEntry = getVisitTimeMode()
        
        if(isFromAttendance)
        {
            if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
            {
                self.visitModeViewWidthConst.constant = 155
                self.visitModeHgtConst.constant = 40
                self.leadingSpaceToVisitTimeConst.constant = 0
                self.setModifyAttendanceVisitDetails(type: 1)
            }
            else
            {
                self.visitModeHgtConst.constant = 0
                self.visitTimePobHgtConst.constant = 50
                self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                self.setModifyAttendanceVisitDetails(type: 2)
            }
            
        }
        else
        {
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            {
                //            self.visitModeHgtConst.constant = 0
                //            self.visitTimePobHgtConst.constant = 50
                //            self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                //            self.setModifyVisitDetails(type: 3)
                self.setVisitTimeMode()
            }
            else if(isEdetailedDoctor() && BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
            {
                //prefill time or mode and non editable
                if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
                {
                    self.setVisitMode()
                }
                else
                {
                    self.setVisitTimeMode()
                }
            }
            else if(!isEdetailedDoctor() && BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
            {
                //prefill time or mode and editable
                
                if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
                {
                    self.visitModeViewWidthConst.constant = 155
                    self.visitModeHgtConst.constant = 40
                    self.leadingSpaceToVisitTimeConst.constant = 0
                    self.setModifyVisitDetails(type: 12)
                }
                else
                {
                    self.visitModeHgtConst.constant = 0
                    self.visitTimePobHgtConst.constant = 50
                    self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                    self.setModifyVisitDetails(type: 14)
                }
            }
            else if(isEdetailedDoctor())
            {
                //prefill time or mode and non editable
                if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
                {
                    self.setVisitMode()
                }
                else
                {
                    self.setVisitTimeMode()
                }
            }
            else
            {
                if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
                {
                    self.visitModeViewWidthConst.constant = 155
                    self.visitModeHgtConst.constant = 40
                    self.leadingSpaceToVisitTimeConst.constant = 0
                    self.setModifyVisitDetails(type: 1)
                }
                else
                {
                    self.visitModeHgtConst.constant = 0
                    self.visitTimePobHgtConst.constant = 50
                    self.visitTimeWidthConst.constant = (SCREEN_WIDTH - 30)/2
                    self.setModifyVisitDetails(type: 2)
                }
            }
            
            
            
            if (isComingFromModifyPage && modifyDoctorVisitObj != nil)
            {
                if (BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEnabled())
                {
                    if (modifyDoctorVisitObj.Is_DCR_Inherited_Doctor == 1)
                    {
                        if (visitTimeEntry == PrivilegeValues.AM_PM.rawValue)
                        {
                            self.amBtn.isUserInteractionEnabled = false
                            self.pmBtn.isUserInteractionEnabled = false
                        }
                        else
                        {
                            self.visitTimeTxtField.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        }
    }
    
    func showPOBAmtView()
    {
        if BL_DCR_Doctor_Visit.sharedInstance.showPOBAmtView()
        {
            self.pobAmtViewHgtConst.constant = 50
            self.visitTimePobHgtConst.constant = 50
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
    
    func setModifyAttendanceVisitDetails(type : Int)
    {
        if isComingFromModifyPage && modifyAttendanceDoctorVisitObj != nil
        {
            visitTime = modifyAttendanceDoctorVisitObj.Visit_Time!
            visitMode = modifyAttendanceDoctorVisitObj.Visit_Mode!
            
            if type == 0
            {
                self.serverTimeLbl.text = visitTime
            }
            else if type == 1
            {
                self.setVisitMode(mode: visitMode)
            }
            else
            {
                self.visitTimeTxtField.text = visitTime
            }
        }
        else
        {
            if type == 1
            {
                self.setVisitMode(mode: AM)
            }  else if type == 2
            {
                self.visitTime = getServerTime()
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitTime
            }
        }
        
        setBusinessStatusView()
        setBusinessStatusData()
        setCallObjectiveView()
        setCallObjectiveData()
        setCampaignData()
    }
    
    func setModifyVisitDetails(type : Int)
    {
        if isComingFromModifyPage && modifyDoctorVisitObj != nil
        {
            visitTime = modifyDoctorVisitObj.Visit_Time!
            visitMode = modifyDoctorVisitObj.Visit_Mode!
            
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
                    self.visitTimeTxtField.text = visitTime
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                }
                else
                {
                    self.visitTime = getServerTime()
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    self.visitTimeTxtField.text = self.visitTime
                }
                
                
                self.visitTimeTxtField.isUserInteractionEnabled = false
            }
            else if type == 11
            {
                
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.setVisitMode(mode: visitMode)
                self.amBtn.isUserInteractionEnabled = false
                self.pmBtn.isUserInteractionEnabled = false
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
                    self.visitTimeTxtField.text = visitTime
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
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
                self.visitTimeTxtField.text = visitTime
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
            else if type == 11
            {
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.setVisitMode(mode: visitMode)
                self.amBtn.isUserInteractionEnabled = false
                self.pmBtn.isUserInteractionEnabled = false
            }
            else if type == 12
            {
                
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.setVisitMode(mode: visitMode)
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
        
        setBusinessStatusView()
        setBusinessStatusData()
        setCallObjectiveView()
        setCallObjectiveData()
        setCampaignData()
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
    
    func getVisitTimeEntryMode() -> String
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitTimeEntryMode()
    }
    
    func getVisitTimeMode() -> String
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode()
    }
    
    func IsManualVisitMode() -> Bool
    {
        var isManual : Bool = true
        let configValue = BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitTimeEntryMode()
        if configValue == ConfigValues.SERVER_TIME.rawValue
        {
            self.serverViewWidthConst.constant = 75
            let time =  getServerTime()
            self.serverTimeLbl.text = time
            self.visitTime = time
            self.visitMode = getVisitModeType(visitTime: time)
            self.setModifyVisitDetails(type: 0)
        }
        else
        {
            isManual = true
        }
        return isManual
    }
    
    func setVisitViewIntialWidthConst()
    {
        self.serverViewWidthConst.constant = 0
        self.visitModeViewWidthConst.constant = 0
        self.visitModeHgtConst.constant = 0
        self.visitTimePobHgtConst.constant = 0
        self.visitTimeWidthConst.constant = 0
        self.pobAmtViewHgtConst.constant = 0
        self.leadingSpaceToVisitTimeConst.constant = 8
    }
    
    func setDoctorVisitDetails()
    {
        var navigationTitle : String = ""
        var remarksTxtCount : String = ""
        
        if isFromAttendance
        {
            if isComingFromModifyPage
            {
                navigationTitle = modifyAttendanceDoctorVisitObj.Doctor_Name!
                if modifyAttendanceDoctorVisitObj.Remarks != nil
                {
                    self.remarksTxtField.text = modifyAttendanceDoctorVisitObj.Remarks!
                }
                
                if modifyAttendanceDoctorVisitObj.POB_Amount != nil
                {
                    self.pobAmtTxtField.text = String(modifyAttendanceDoctorVisitObj.POB_Amount!)
                }
                remarksTxtCount =  String(describing: self.remarksTxtField.text!.count)
            }
            else
            {
                if doctorName != ""
                {
                    navigationTitle =  doctorName
                }
                else if customerMasterObj != nil
                {
                    navigationTitle = customerMasterObj.Customer_Name
                }
                // self.amBtn.isSelected = true
                remarksTxtCount = "0"
            }
        }
        else
        {
            if isComingFromModifyPage
            {
                navigationTitle = modifyDoctorVisitObj.Doctor_Name!
                if modifyDoctorVisitObj.Remarks != nil
                {
                    self.remarksTxtField.text = modifyDoctorVisitObj.Remarks!
                }
                
                if modifyDoctorVisitObj.POB_Amount != nil
                {
                    self.pobAmtTxtField.text = String(modifyDoctorVisitObj.POB_Amount!)
                }
                remarksTxtCount =  String(describing: self.remarksTxtField.text!.count)
            }
            else
            {
                if doctorName != ""
                {
                    navigationTitle =  doctorName
                }
                else if customerMasterObj != nil
                {
                    navigationTitle = customerMasterObj.Customer_Name
                }
                // self.amBtn.isSelected = true
                remarksTxtCount = "0"
            }
        }
        
        self.navigationItem.title = navigationTitle
        self.remarksCountLbl.text = "\(remarksTxtCount)/\(doctorRemarksMaxLength)"
    }
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
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
    
    @IBAction func saveBtnAction(_ sender: UIButton)
    {
        self.resignTxtField()
        if checkIsVisitModeValidate() && self.visitTimeTxtField.text?.count == 0
        {
            self.showAlertView(alertMessage: "Please enter visit time")
        }
        else if (self.pobAmtTxtField.text?.count)! > 0 && !isValidFloatNumber(value: self.pobAmtTxtField.text!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Enter valid POB Amount", viewController: self)
        }
        else if (self.pobAmtTxtField.text?.count)! > 0 && !maxNumberValidationCheck(value: pobAmtTxtField.text!, maxVal: doctorPOBMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "POB Amount", maxVal: doctorPOBMaxVal, viewController: self)
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if (remarksTxtField.text?.count)! > doctorRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: doctorRemarksMaxLength, viewController: self)
        }
        else
        {
            self.checkIsLocationMandatory()
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
            
        }
    }
    
    func saveVisitModeDetails()
    {
        let pobAmt = NSString(string:pobAmtTxtField.text!).doubleValue
        if self.campaignName == defaultCampaignName
        {
            self.campaignName = EMPTY
        }
        if(isFromAttendance)
        {
            if isComingFromModifyPage
            {
                self.setValueToAttendanceModifyObj()
                BL_DCR_Attendance.sharedInstance.updateDCRAttendanceDoctorVisit(dcrDoctorVisitObj: modifyAttendanceDoctorVisitObj, viewController: self)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                let customerCode = DCRModel.sharedInstance.customerCode
                let remarksText =  condenseWhitespace(stringValue: remarksTxtField.text!)
                var statusId: Int = defaultBusineessStatusId
                var statusName: String = EMPTY
                
                if (objBusinessStatus != nil)
                {
                    statusId = objBusinessStatus!.Business_Status_ID!
                    statusName = objBusinessStatus!.Status_Name!
                }else{
                    if(objBusinessStatus_Dir != nil){
                        statusId = objBusinessStatus_Dir!.Business_Status_ID!
                        statusName = objBusinessStatus_Dir!.Status_Name!
                    }
                }
                
                if  DCRModel.sharedInstance.customerCode == nil || DCRModel.sharedInstance.customerCode == ""
                {
                    var visittime = ""
                    var visitmode = ""
                  
                        if(BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue)
                            || (BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue){
                            
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                            
                        }else{
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                                visittime = ""
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                        }
                  
                    
                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiAttendanceDoctorVisitDetails(doctorName: customerMasterObj.Customer_Name, specialityName: customerMasterObj.Speciality_Name, visitTime: visittime, visitMode: visitmode, pobAmount: pobAmt, remarks:remarksText, regionCode: customerMasterObj.Region_Code, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignCode:checkNullAndNilValueForString(stringData: self.campaignCode),campaignName:self.campaignName)
                    DCRModel.sharedInstance.customerCode = ""
                    _ = self.navigationController?.popViewController(animated: false)
                }
                else
                {
                    BL_DCR_Doctor_Visit.sharedInstance.saveAttendanceVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: pobAmt, remarks: remarksText,regionCode: customerMasterObj.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignCode:self.campaignCode,specialityCode:customerMasterObj.Speciality_Code, campaignName:self.campaignName)
                    _ = self.navigationController?.popViewController(animated: false)
                }
            }
        }
        else
        {
            if isComingFromModifyPage
            {
                //                if !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
                //                {
                self.setValueToModifyObj()
                BL_DCR_Doctor_Visit.sharedInstance.updateDCRDoctorVisit(dcrDoctorVisitObj: modifyDoctorVisitObj, viewController: self)
                // }
                
                _ = self.navigationController?.popViewController(animated: false)
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                {
                    let customerCode = DCRModel.sharedInstance.customerCode
                    let remarksText =  condenseWhitespace(stringValue: remarksTxtField.text!)
                    let statusId: Int = defaultBusineessStatusId
                    let statusName: String = EMPTY
                    let postData: NSMutableArray = []
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":customerCode ?? EMPTY,"Doctor_Name":self.modifyDoctorVisitObj.Doctor_Name,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":self.modifyDoctorVisitObj.Speciality_Name,"Category_Code": self.modifyDoctorVisitObj.Category_Code ?? EMPTY,"MDL_Number":self.modifyDoctorVisitObj.MDL_Number!,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":1,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                    
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
                                
                                
                                //self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else if(compare == .orderedDescending)
                            {
                                removeCustomActivityView()
                                
                                //self.insertDCRDoctorAccompanists()
                                _ = self.navigationController?.popViewController(animated: false)
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: "\(PEV_DCR) Date is not a current date", viewController: self)
                            }
                        }
                        else
                        {
                            removeCustomActivityView()
                            AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                        }
                    })
                }
                
                
            }
            else
            {
                let customerCode = DCRModel.sharedInstance.customerCode
                let remarksText =  condenseWhitespace(stringValue: remarksTxtField.text!)
                var statusId: Int = defaultBusineessStatusId
                var statusName: String = EMPTY
                
                if (objBusinessStatus != nil)
                {
                    statusId = objBusinessStatus!.Business_Status_ID!
                    statusName = objBusinessStatus!.Status_Name!
                }else{
                    if(objBusinessStatus_Dir != nil){
                        statusId = objBusinessStatus_Dir!.Business_Status_ID!
                        statusName = objBusinessStatus_Dir!.Status_Name!
                    }
                    
                }
                
                //                let doctorVisits = DBHelper.sharedInstance.getEdetailingModified(drcCustomerCode: DCRModel.sharedInstance.customerCode, regionCode: getRegionCode())
                
                if  customerCode == ""
                {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    
                    if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                    {
                        let postData: NSMutableArray = []
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":self.doctorName,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":self.specialityName,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                        
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
                                    
                                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: self.doctorName, specialityName: self.specialityName, visitTime: visitTime, visitMode: dateTimeArray[2], pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode)
                                    self.insertDCRDoctorAccompanists()
                                    _ = self.navigationController?.popViewController(animated: false)
                                }
                                else if(compare == .orderedDescending)
                                {
                                    removeCustomActivityView()
                                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: self.doctorName, specialityName: self.specialityName, visitTime: self.visitTime, visitMode: self.visitMode, pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode)
                                    self.insertDCRDoctorAccompanists()
                                    _ = self.navigationController?.popViewController(animated: false)
                                }
                                else
                                {
                                    removeCustomActivityView()
                                    AlertView.showAlertView(title: alertTitle, message: "\(PEV_DCR) Date is not a current date", viewController: self)
                                }
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                        })
                    }
                    else if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                    {
                        
                        var visittime = ""
                        var visitmode = ""
                        
                        if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() || BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ){
                            
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                            
                        }else{
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                                visittime = ""
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                        }
                        var localTimeZoneName: String { return TimeZone.current.identifier }
                        BL_DCR_Doctor_Visit.sharedInstance.savePunchInFlexiDoctorVisitDetails( doctorName: doctorName, specialityName: specialityName, visitTime: stringFromDate(date1: getDateFromString(dateString: time)), visitMode: visitmode, pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode, Punch_Start_Time: time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch())
                        insertDCRDoctorAccompanists()
                        _ = self.navigationController?.popViewController(animated: false)
                    }
                    else
                    {
                        
                        BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: doctorName, specialityName: specialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode)
                        insertDCRDoctorAccompanists()
                        _ = self.navigationController?.popViewController(animated: false)
                    }
                }
                else
                {
                    
                    
                    if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                    {
                        let postData: NSMutableArray = []
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":customerCode ?? EMPTY,"Doctor_Name":customerMasterObj.Customer_Name,"regionCode":customerMasterObj.Region_Code,"Speciality_Name":customerMasterObj.Speciality_Name,"Category_Code":customerMasterObj.Category_Code ?? EMPTY,"MDL_Number":customerMasterObj.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":customerMasterObj.Region_Code,"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                        
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
                                    
                                    BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: dateTimeArray[2], pobAmount: pobAmt, remarks: remarksText,regionCode: self.customerMasterObj.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: self.campaignName, campaignCode: self.campaignCode)
                                    self.insertDCRDoctorAccompanists()
                                    _ = self.navigationController?.popViewController(animated: false)
                                }
                                else if(compare == .orderedDescending)
                                {
                                    BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: customerCode, visitTime: self.visitTime, visitMode: self.visitMode, pobAmount: pobAmt, remarks: remarksText,regionCode: self.customerMasterObj.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: self.campaignName, campaignCode: self.campaignCode)
                                    self.insertDCRDoctorAccompanists()
                                    _ = self.navigationController?.popViewController(animated: false)
                                }
                                else
                                {
                                    AlertView.showAlertView(title: alertTitle, message: "\(PEV_DCR) Date is not a current date", viewController: self)
                                }
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                        })
                    }
                    else if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                    {
                        
                        
                        var visittime = ""
                        var visitmode = ""
                        
                        if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() || BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ){
                            
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                            
                        }else{
                            if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                                visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                visitmode = visittime.substring(from: lastcharacterIndex)
                                visittime = ""
                            }else{
                                visittime = ""
                                visitmode = ""
                            }
                        }
                        
                        var localTimeZoneName: String { return TimeZone.current.identifier }
                        BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails( customerCode: customerCode, visitTime: stringFromDate(date1: getDateFromString(dateString: time)), visitMode: visitmode, pobAmount: pobAmt, remarks: remarksText, regionCode: customerMasterObj.Region_Code, viewController: self, geoFencingSkipRemarks: "", latitude: 0.0, longitude: 0.0, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: self.campaignName, campaignCode: self.campaignCode, Punch_Start_Time: time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch() )
                        insertDCRDoctorAccompanists()
                        _ = self.navigationController?.popViewController(animated: false)
                    }
                    else
                    {
                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: pobAmt, remarks: remarksText,regionCode: customerMasterObj.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: campaignName, campaignCode: self.campaignCode)
                        insertDCRDoctorAccompanists()
                        _ = self.navigationController?.popViewController(animated: false)
                    }
                }
                
            }
        }
    }
    func insertDCRDoctorAccompanists()
    {
        
        //BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
        
        BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanistVandNA())
    }
    func setValueToModifyObj()
    {
        self.modifyDoctorVisitObj.Visit_Mode = visitMode
        self.modifyDoctorVisitObj.Visit_Time = visitTime
        self.modifyDoctorVisitObj.Remarks = condenseWhitespace(stringValue: self.remarksTxtField.text!)
        
        if (self.pobAmtTxtField.text?.count)! > 0
        {
            let pobAmt = NSString(string:pobAmtTxtField.text!).doubleValue
            self.modifyDoctorVisitObj.POB_Amount = pobAmt
        }
        else
        {
            self.modifyDoctorVisitObj.POB_Amount = 0
        }
        
        self.modifyDoctorVisitObj.Business_Status_ID = defaultBusineessStatusId
        self.modifyDoctorVisitObj.Business_Status_Name = EMPTY
        self.modifyDoctorVisitObj.Business_Status_Active_Status = defaultBusinessStatusActviveStatus
        
        if (self.objBusinessStatus != nil)
        {
            self.modifyDoctorVisitObj.Business_Status_ID = self.objBusinessStatus!.Business_Status_ID!
            self.modifyDoctorVisitObj.Business_Status_Name = self.objBusinessStatus!.Status_Name!
        }
        
        self.modifyDoctorVisitObj.Call_Objective_ID = defaultCallObjectiveId
        self.modifyDoctorVisitObj.Call_Objective_Name = EMPTY
        self.modifyDoctorVisitObj.Call_Objective_Active_Status = defaultCallObjectiveActviveStatus
        
        if (self.objCallObjective != nil)
        {
            self.modifyDoctorVisitObj.Call_Objective_ID = self.objCallObjective!.Business_Status_ID!
            self.modifyDoctorVisitObj.Call_Objective_Name = self.objCallObjective!.Status_Name!
        }
        
        if (campaignName != EMPTY && campaignCode != EMPTY)
        {
            self.modifyDoctorVisitObj.Campaign_Code = self.campaignCode
            self.modifyDoctorVisitObj.Campaign_Name = self.campaignName
        }
        
        if self.campaignName == ""
        {
            self.modifyDoctorVisitObj.Campaign_Name = ""
        }
        
    }
    
    func setValueToAttendanceModifyObj()
    {
        self.modifyAttendanceDoctorVisitObj.Visit_Mode = visitMode
        self.modifyAttendanceDoctorVisitObj.Visit_Time = visitTime
        self.modifyAttendanceDoctorVisitObj.Remarks = condenseWhitespace(stringValue: self.remarksTxtField.text!)
        
        if (self.pobAmtTxtField.text?.count)! > 0
        {
            let pobAmt = NSString(string:pobAmtTxtField.text!).doubleValue
            self.modifyAttendanceDoctorVisitObj.POB_Amount = pobAmt
        }
        else
        {
            self.modifyAttendanceDoctorVisitObj.POB_Amount = 0
        }
        
        self.modifyAttendanceDoctorVisitObj.Business_Status_ID = defaultBusineessStatusId
        self.modifyAttendanceDoctorVisitObj.Business_Status_Name = EMPTY
        self.modifyAttendanceDoctorVisitObj.Business_Status_Active_Status = defaultBusinessStatusActviveStatus
        
        if (self.objBusinessStatus != nil)
        {
            self.modifyAttendanceDoctorVisitObj.Business_Status_ID = self.objBusinessStatus!.Business_Status_ID!
            self.modifyAttendanceDoctorVisitObj.Business_Status_Name = self.objBusinessStatus!.Status_Name!
        }
        
        self.modifyAttendanceDoctorVisitObj.Call_Objective_ID = defaultCallObjectiveId
        self.modifyAttendanceDoctorVisitObj.Call_Objective_Name = EMPTY
        self.modifyAttendanceDoctorVisitObj.Call_Objective_Active_Status = defaultCallObjectiveActviveStatus
        
        if (self.objCallObjective != nil)
        {
            self.modifyAttendanceDoctorVisitObj.Call_Objective_ID = self.objCallObjective!.Business_Status_ID!
            self.modifyAttendanceDoctorVisitObj.Call_Objective_Name = self.objCallObjective!.Status_Name!
        }
        
        if (campaignCode != EMPTY && campaignCode != EMPTY)
        {
            self.modifyAttendanceDoctorVisitObj.Campaign_Code = self.campaignCode
            self.modifyAttendanceDoctorVisitObj.Campaign_Name = self.campaignName
        }
        
        if self.campaignName == EMPTY
        {
            self.modifyAttendanceDoctorVisitObj.Campaign_Name = ""
        }
        
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
                    if isFromAttendance
                    {
                        self.modifyAttendanceDoctorVisitObj.Remarks = remarksTxtField.text!
                    }
                    else
                    {
                        self.modifyDoctorVisitObj.Remarks = remarksTxtField.text!
                    }
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
    
    private func addTimePicker()
    {
        visitTimePicker = getTimePickerView()
        visitTimePicker.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DoctorVisitViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(DoctorVisitViewController.cancelBtnClicked))
        
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
        self.pobAmtTxtField.resignFirstResponder()
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
            if newLength > doctorRemarksMaxLength
            {
                let lengthDiff = doctorRemarksMaxLength - newLength
                let start = string.startIndex
                let end = string.index((string.endIndex), offsetBy: lengthDiff)
                let substring = string[start..<end]
                if substring != ""
                {
                    textField.text = "\(textField.text!)" + substring
                }
                self.remarksCountLbl.text = "\(doctorRemarksMaxLength)/\(doctorRemarksMaxLength)"
                return false
            }
            else
            {
                self.remarksCountLbl.text = "\(newLength)/\(doctorRemarksMaxLength)"
                return true
            }
        }
        else if textField.tag == 3
        {
            if(string == ".")
            {
                if(textField.text?.contains("."))!
                {
                    
                    return false
                }
            }
            
            if(textField.text?.contains("."))!
            {
                // var stringValue = String()
                if var str = textField.text
                {
                    str.insert(string.first ?? " ", at: str.index(str.startIndex, offsetBy: range.location))
                    let stringArray = str.components(separatedBy: ".")
                    
                    if Int(stringArray[0]) ?? 0 > Int(doctorPOBMaxVal)
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    
                    if Int(stringArray[1]) ?? 0 > 99
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    if stringArray[1].count > 2
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            else
            {
                if textField.text?.count ?? 0 > 10
                {
                    if(string != ".")
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
                //return isValidNumberForPobAmt(string : string)
                
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        
        return true
    }
    
    func getDCRDoctorVisitObj()
    {
        if isFromAttendance
        {
            let dcrDoctorVisitList = BL_Doctor_Attendance_Stepper.sharedInstance.doctorVisitList
            
            if dcrDoctorVisitList.count > 0
            {
                let dcrDoctorVisitObj = dcrDoctorVisitList.first
                self.isComingFromModifyPage = true
                self.modifyAttendanceDoctorVisitObj = dcrDoctorVisitObj
            }
        }
        else
        {
            let dcrDoctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList
            if dcrDoctorVisitList.count > 0
            {
                let dcrDoctorVisitObj = dcrDoctorVisitList.first
                self.isComingFromModifyPage = true
                self.modifyDoctorVisitObj = dcrDoctorVisitObj
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
    
    @IBAction func businessStatusButtonTapAction()
    {
        showBusinessStatusList(isCallObjective: false)
    }
    
    @IBAction func callObjectiveButtonTapAction()
    {
        showBusinessStatusList(isCallObjective: true)
    }
    
    @IBAction func campaignButtonTapAction()
    {
        showCampaignList()
    }
    
    private func showBusinessStatusList(isCallObjective: Bool)
    {
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.BusinessStatusVcId) as! BusinessStatusViewController
        
        if (!isCallObjective)
        {
            vc.businessStatusList = lstBusinessStatus
        }
        else
        {
            vc.businessStatusList = lstCallObjective
        }
        vc.delegate = self
        vc.isCallObjective = isCallObjective
        vc.isCampaignSelect = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func showCampaignList()
    {
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.BusinessStatusVcId) as! BusinessStatusViewController
        vc.delegate = self
        vc.isCallObjective = false
        vc.isCampaignSelect = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func getBusinessStatusList()
    {
        lstBusinessStatus = BL_DCR_Doctor_Visit.sharedInstance.getDoctorBusinessStatusList()
        lstCallObjective = BL_DCR_Doctor_Visit.sharedInstance.getDoctorCallObjectiveList()
    }
    
    private func setBusinessStatusView()
    {
        businessStatusView.isHidden = true
        businessStatusViewHeightConstraint.constant = 0
        businessStatusLabel.text = EMPTY
        var showBusinessStatus: Bool = false
        if isFromAttendance
        {
            if (isComingFromModifyPage)
            {
                if (modifyAttendanceDoctorVisitObj != nil)
                {
                    if (modifyAttendanceDoctorVisitObj!.Business_Status_ID! != defaultBusineessStatusId)
                    {
                        let filteredArray = lstBusinessStatus.filter{
                            $0.Business_Status_ID == modifyAttendanceDoctorVisitObj!.Business_Status_ID!
                        }
                        
                        if (filteredArray.count == 0) // The selected item is not available now.
                        {
                            
                            let obj = createBusinessStatusObj(id: modifyAttendanceDoctorVisitObj!.Business_Status_ID!, name: modifyAttendanceDoctorVisitObj!.Business_Status_Name!)
                            lstBusinessStatus.append(obj)
                            
                            showBusinessStatus = true
                        }
                    }
                }
            }
        }
        else
        {
            if (isComingFromModifyPage)
            {
                if (modifyDoctorVisitObj != nil)
                {
                    if (modifyDoctorVisitObj!.Business_Status_ID! != defaultBusineessStatusId)
                    {
                        let filteredArray = lstBusinessStatus.filter{
                            $0.Business_Status_ID == modifyDoctorVisitObj!.Business_Status_ID!
                        }
                        
                        if (filteredArray.count == 0) // The selected item is not available now.
                        {
                            
                            let obj = createBusinessStatusObj(id: modifyDoctorVisitObj!.Business_Status_ID!, name: modifyDoctorVisitObj!.Business_Status_Name!)
                            lstBusinessStatus.append(obj)
                            
                            showBusinessStatus = true
                        }
                    }
                }
            }
        }
        
        
        if (!showBusinessStatus)
        {
            if (lstBusinessStatus.count > 1)
            {
                showBusinessStatus = true
            }
        }
        
        if (showBusinessStatus)
        {
            businessStatusView.isHidden = false
            businessStatusViewHeightConstraint.constant = 65
        }
    }
    
    private func setCallObjectiveView()
    {
        callObjectiveView.isHidden = true
        callObjectiveViewHeightConstraint.constant = 0
        callObjectiveLabel.text = EMPTY
        var showBusinessStatus: Bool = false
        
        if isFromAttendance
        {
            if (isComingFromModifyPage)
            {
                if (modifyAttendanceDoctorVisitObj != nil)
                {
                    if (modifyAttendanceDoctorVisitObj!.Call_Objective_ID! != defaultCallObjectiveId)
                    {
                        let filteredArray = lstCallObjective.filter{
                            $0.Business_Status_ID == modifyAttendanceDoctorVisitObj!.Call_Objective_ID!
                        }
                        
                        if (filteredArray.count == 0) // The selected item is not available now.
                        {
                            let obj = createBusinessStatusObj(id: modifyAttendanceDoctorVisitObj!.Call_Objective_ID!, name: modifyAttendanceDoctorVisitObj!.Call_Objective_Name!)
                            lstCallObjective.append(obj)
                            
                            showBusinessStatus = true
                        }
                    }
                }
            }
        }
        else
        {
            if (modifyDoctorVisitObj != nil)
            {
                if (modifyDoctorVisitObj!.Call_Objective_ID! != defaultCallObjectiveId)
                {
                    let filteredArray = lstCallObjective.filter{
                        $0.Business_Status_ID == modifyDoctorVisitObj!.Call_Objective_ID!
                    }
                    
                    if (filteredArray.count == 0) // The selected item is not available now.
                    {
                        let obj = createBusinessStatusObj(id: modifyDoctorVisitObj!.Call_Objective_ID!, name: modifyDoctorVisitObj!.Call_Objective_Name!)
                        lstCallObjective.append(obj)
                        
                        showBusinessStatus = true
                    }
                }
            }
        }
        
        if (!showBusinessStatus)
        {
            if (lstCallObjective.count > 1)
            {
                showBusinessStatus = true
            }
        }
        
        if (showBusinessStatus)
        {
            callObjectiveView.isHidden = false
            callObjectiveViewHeightConstraint.constant = 65
        }
    }
    
    private func createBusinessStatusObj(id: Int, name: String) -> BusinessStatusModel
    {
        let dict: NSDictionary = ["Business_Status_Id": id, "Status_Name": name, "Entity_Type_Description": DOCTOR, "Entity_Type": Constants.Call_Objective_Entity_Type_Ids.Doctor]
        let objStatus = BusinessStatusModel(dict: dict)
        
        return objStatus
    }
    
    private func setBusinessStatusData()
    {
        self.businessStatusLabel.text = defaultBusinessStatusName
        
        if isFromAttendance
        {
            if (modifyAttendanceDoctorVisitObj != nil)
            {
                if (modifyAttendanceDoctorVisitObj.Business_Status_ID != defaultBusineessStatusId)
                {
                    let filteredArray = self.lstBusinessStatus.filter{
                        $0.Business_Status_ID == modifyAttendanceDoctorVisitObj!.Business_Status_ID!
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        self.objBusinessStatus = filteredArray.first!
                    }
                }
                if(modifyAttendanceDoctorVisitObj.Business_Status_Name != nil){
                    objBusinessStatus?.Status_Name = modifyAttendanceDoctorVisitObj?.Business_Status_Name
                    objBusinessStatus?.Business_Status_ID = modifyAttendanceDoctorVisitObj?.Business_Status_ID
                    self.businessStatusLabel.text = objBusinessStatus?.Status_Name
                }
                else
                {
                    self.businessStatusLabel.text = defaultBusinessStatusName
                    objBusinessStatus = nil
                }
            }
            else
            {
                if DCRModel.sharedInstance.customerCode != nil
                {
                    
                    obj = DBHelper.sharedInstance.getbusinessstatus1(customercode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 1)
                    if (obj != nil)
                    {
                        // statusId = obj!.Business_Status_Id!
                        //statusName = obj!.Business_Status_Name!
                        self.businessStatusLabel.text = obj?.Business_Status_Name
                        objBusinessStatus?.Status_Name = obj?.Business_Status_Name
                        objBusinessStatus?.Business_Status_ID = obj?.Business_Status_Id
                        let dic = ["Business_Status_Id" : obj?.Business_Status_Id ?? 0,"Status_Name" : obj?.Business_Status_Name ?? EMPTY] as [String : Any]
                        objBusinessStatus_Dir = BusinessStatusModel(dict : dic as NSDictionary)
                        
                    }
                    else
                    {
                        self.businessStatusLabel.text = defaultBusinessStatusName
                        objBusinessStatus = nil
                    }
                }
            }
        }
        else
        {
            if (modifyDoctorVisitObj != nil)
            {
                if (modifyDoctorVisitObj.Business_Status_ID != defaultBusineessStatusId)
                {
                    let filteredArray = self.lstBusinessStatus.filter{
                        $0.Business_Status_ID == modifyDoctorVisitObj!.Business_Status_ID!
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        self.objBusinessStatus = filteredArray.first!
                    }
                    
                    if(modifyDoctorVisitObj.Business_Status_Name != nil){
                        objBusinessStatus?.Status_Name = modifyDoctorVisitObj?.Business_Status_Name
                        objBusinessStatus?.Business_Status_ID = modifyDoctorVisitObj?.Business_Status_ID
                        self.businessStatusLabel.text = objBusinessStatus?.Status_Name
                    }else{
                        self.businessStatusLabel.text = defaultBusinessStatusName
                        objBusinessStatus = nil
                    }
                }else{
                    self.businessStatusLabel.text = defaultBusinessStatusName
                    objBusinessStatus = nil
                }
                
            }else{
                obj = DBHelper.sharedInstance.getbusinessstatus1(customercode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 1)
                if (obj != nil)
                {
                    // statusId = obj!.Business_Status_Id!
                    //statusName = obj!.Business_Status_Name!
                    self.businessStatusLabel.text = obj?.Business_Status_Name
                    objBusinessStatus?.Status_Name = obj?.Business_Status_Name
                    objBusinessStatus?.Business_Status_ID = obj?.Business_Status_Id
                    let dic = ["Business_Status_Id" : obj?.Business_Status_Id ?? 0,"Status_Name" : obj?.Business_Status_Name ?? EMPTY] as [String : Any]
                    objBusinessStatus_Dir = BusinessStatusModel(dict : dic as NSDictionary)
                    
                }
                else
                {
                    self.businessStatusLabel.text = defaultBusinessStatusName
                    objBusinessStatus = nil
                }
            }
        }
        
        
    }
    
    private func setCallObjectiveData()
    {
        self.callObjectiveLabel.text = defaultCallObjectiveName
        
        if isFromAttendance
        {
            if (modifyAttendanceDoctorVisitObj != nil)
            {
                if (modifyAttendanceDoctorVisitObj.Call_Objective_ID != defaultCallObjectiveId)
                {
                    let filteredArray = self.lstCallObjective.filter{
                        $0.Business_Status_ID == modifyAttendanceDoctorVisitObj!.Call_Objective_ID!
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        self.objCallObjective = filteredArray.first!
                    }
                }
            }
        }
        else
        {
            if (modifyDoctorVisitObj != nil)
            {
                if (modifyDoctorVisitObj.Call_Objective_ID != defaultCallObjectiveId)
                {
                    let filteredArray = self.lstCallObjective.filter{
                        $0.Business_Status_ID == modifyDoctorVisitObj!.Call_Objective_ID!
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        self.objCallObjective = filteredArray.first!
                    }
                }
            }
        }
        
        if (objCallObjective != nil)
        {
            self.callObjectiveLabel.text = objCallObjective!.Status_Name
            
            if (objCallObjective!.Status_Name == defaultCallObjectiveName)
            {
                objCallObjective = nil
            }
        }
    }
    private func setCampaignData()
    {
        if DCRModel.sharedInstance.customerCode != nil && DCRModel.sharedInstance.customerCode != ""
        {
            let campaignHeaderList = DBHelper.sharedInstance.getMCListForDoctor(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
            if campaignHeaderList.count > 0
            {
                campaignViewHeightConstraint.constant = 65
                canpaignView.isHidden = false
                campaignLabel.isHidden = false
            }
            else
            {
                campaignViewHeightConstraint.constant = 0
                canpaignView.isHidden = true
                campaignLabel.isHidden = true
            }
            self.campaignLabel.text = defaultCampaignName
            if isFromAttendance
            {
                if (modifyAttendanceDoctorVisitObj != nil)
                {
                    if (modifyAttendanceDoctorVisitObj.Campaign_Code != defaultCampaignName)
                    {
                        self.campaignCode = modifyAttendanceDoctorVisitObj!.Campaign_Code!
                        self.campaignName = modifyAttendanceDoctorVisitObj!.Campaign_Name!
                        if self.campaignName != EMPTY
                        {
                            self.campaignLabel.text = self.campaignName
                            campaignViewHeightConstraint.constant = 65
                            canpaignView.isHidden = false
                            campaignLabel.isHidden = false
                        }
                    }
                }
            }
            else
            {
                if (modifyDoctorVisitObj != nil)
                {
                    if (modifyDoctorVisitObj.Campaign_Code != defaultCampaignName)
                    {
                        self.campaignCode = modifyDoctorVisitObj!.Campaign_Code!
                        self.campaignName = modifyDoctorVisitObj!.Campaign_Name!
                        // self.campaignLabel.text = self.campaignName
                        if self.campaignName != EMPTY
                        {
                            self.campaignLabel.text = self.campaignName
                        }
                    }
                }
            }
        }
    }
    
    func selectBusinessActivity(indexPath: IndexPath?, selectedStatus: BusinessStatusModel, isCallObjective: Bool)
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: true)
        }
        
        if (!isCallObjective)
        {
            self.objBusinessStatus = selectedStatus
            if isFromAttendance
            {
                //                if (self.modifyAttendanceDoctorVisitObj != nil)
                //                {
                //                    self.modifyAttendanceDoctorVisitObj.Business_Status_ID = self.objBusinessStatus!.Business_Status_ID!
                //                    self.modifyAttendanceDoctorVisitObj.Business_Status_Name = self.objBusinessStatus!.Status_Name!
                //                }
                let dic = ["Business_Status_Id" : selectedStatus.Business_Status_ID ?? 0,
                           "Status_Name" : selectedStatus.Status_Name ?? EMPTY] as [String : Any]
                objBusinessStatus_Dir = BusinessStatusModel(dict : dic as NSDictionary)
                self.businessStatusLabel.text = selectedStatus.Status_Name
            }
            else
            {
                //                if (self.modifyDoctorVisitObj != nil)
                //                {
                //                    self.modifyDoctorVisitObj.Business_Status_ID = self.objBusinessStatus!.Business_Status_ID!
                //                    self.modifyDoctorVisitObj.Business_Status_Name = self.objBusinessStatus!.Status_Name!
                //                }
                let dic = ["Business_Status_Id" : selectedStatus.Business_Status_ID ?? 0,
                           "Status_Name" : selectedStatus.Status_Name ?? EMPTY] as [String : Any]
                objBusinessStatus_Dir = BusinessStatusModel(dict : dic as NSDictionary)
                self.businessStatusLabel.text = selectedStatus.Status_Name
                
            }
            
            // setBusinessStatusData()
        }
        else
        {
            self.objCallObjective = selectedStatus
            
            if isFromAttendance
            {
                if (self.modifyAttendanceDoctorVisitObj != nil)
                {
                    self.modifyAttendanceDoctorVisitObj.Call_Objective_ID = self.objCallObjective!.Business_Status_ID!
                    self.modifyAttendanceDoctorVisitObj.Call_Objective_Name = self.objCallObjective!.Status_Name!
                }
            }
            else
            {
                if (self.modifyDoctorVisitObj != nil)
                {
                    self.modifyDoctorVisitObj.Call_Objective_ID = self.objCallObjective!.Business_Status_ID!
                    self.modifyDoctorVisitObj.Call_Objective_Name = self.objCallObjective!.Status_Name!
                }
            }
            
            setCallObjectiveData()
        }
    }
    
    func seletCampaign(indexpath: IndexPath?, campaignObj: MCHeaderModel) {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: true)
        }
        if isFromAttendance
        {
            if (self.modifyAttendanceDoctorVisitObj != nil)
            {
                self.modifyAttendanceDoctorVisitObj.Campaign_Code = campaignObj.Campaign_Code
                self.modifyAttendanceDoctorVisitObj.Campaign_Name = campaignObj.Campaign_Name
            }
        }
        else
        {
            if (self.modifyDoctorVisitObj != nil)
            {
                self.modifyDoctorVisitObj.Campaign_Code = campaignObj.Campaign_Code
                self.modifyDoctorVisitObj.Campaign_Name = campaignObj.Campaign_Name
                
            }
        }
        
        self.campaignObj = campaignObj
        self.campaignCode = campaignObj.Campaign_Code
        self.campaignName = campaignObj.Campaign_Name
        self.campaignLabel.text =  self.campaignObj?.Campaign_Name
    }
}













