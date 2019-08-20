//
//  DCRViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit


class WorkPlaceDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CampaignPlannerDelegate,AddWorkPlaceDelegate
{
    
    @IBOutlet weak var campaignPlanLbl: UILabel!
    @IBOutlet weak var workCategoryTxtField: UITextField!
    @IBOutlet weak var workPlaceLbl: UILabel!
    @IBOutlet weak var fromTimeTxtFld: UITextField!
    @IBOutlet weak var toTimeTxtFld: UITextField!
    @IBOutlet weak var campaignPlannerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var campaignPlannerView : UIView!
    
    @IBOutlet weak var worktimeHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var workTimeView: UIView!
    
    var fromTimePicker = UIDatePicker()
    var toTimePicker = UIDatePicker()
    var pickerView = UIPickerView()
    var workCategoryList : [WorkCategories] = []
    let defaultCampaignLblText = "Select \(appCp)"
    var cpModelObj : CampaignPlannerHeader?
    var workCategoryObj : WorkCategories?
    var placeName : String = ""
    var isComingFromPlaceList : Bool = false
    var isComingFromFlexiWorkPlace : Bool = false
    var defaultCPCode: String? = ""
    var defaultCategoryName: String? = ""
    var variableCategoryName : String? = ""
    var showAlertCaptureLocationCount : Int = 0
    var isComingFromAttendanceStepper : Bool = false
    var showWorkTimeView: Bool = false
    let defaultWorkPlaceText : String  = "Select WorkPlace"
    var isComingFromLoad: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addTimePicker()
        self.addTapGestureForView()
        self.addPickerView()
        self.checkCampaignPrivelege()
        self.getWorkCategoryList()
        self.setPlaceHolderForTxtFld()
        self.setDefaultValues()
        self.isComingFromLoad = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if !isComingFromPlaceList || !isComingFromFlexiWorkPlace
        {
            if(!isComingFromLoad)
            {
                self.setValuesAccordingToSelectedCP()
            }
        }
        
        showAlertCaptureLocationCount = 0
        self.setFlexiWorkPlace()
        addBackButtonView()
        self.isComingFromLoad = false
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.resignResponderForTxtField()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnAction(_ sender: Any)
    {
        self.validateCpDetails()
    }
    
    @IBAction func navigateToNextScreenBtnAction(_ sender: AnyObject)
    {
        self.naviageToNextScreen(senderTag: sender.tag)
    }
    
    func naviageToNextScreen(senderTag : Int)
    {
        switch senderTag
        {
        case 1:
            self.checkUserAuthenticationForAccompanist()
            break
        case 3:
            self.navigateToWorkPlace()
            break
        default:
            print("")
        }
    }
    
    
    private func addTimePicker()
    {
        if isComingFromAttendanceStepper || showWorkTimeView
        {
            self.worktimeHeightConstant.constant = 70
            self.workTimeView.isHidden = false
            fromTimePicker = getTimePickerView()
            fromTimePicker.tag = 1
            let doneToolbar = getToolBar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkPlaceDetailsViewController.doneBtnClicked))
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkPlaceDetailsViewController.cancelBtnClicked))
            
            doneToolbar.items = [flexSpace, done, cancel]
            doneToolbar.sizeToFit()
            
            fromTimeTxtFld.inputAccessoryView = doneToolbar
            fromTimeTxtFld.inputView = fromTimePicker
            
            
            let Toolbar = getToolBar()
            
            let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkPlaceDetailsViewController.doneBtnAction))
            
            let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkPlaceDetailsViewController.cancelBtnClicked))
            toTimePicker = getTimePickerView()
            toTimePicker.tag = 2
            Toolbar.items = [flexSpace, doneBtn, cancelBtn]
            Toolbar.sizeToFit()
            toTimeTxtFld.inputAccessoryView = Toolbar
            toTimeTxtFld.inputView = toTimePicker
        }
        else
        {
            self.worktimeHeightConstant.constant = 0
            self.workTimeView.isHidden = true
        }
    }
    
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
    
    @objc func pickerDoneBtnAction()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: fromTimePicker)
        self.resignResponderForTxtField()
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnAction()
    {
        self.setTimeDetails(sender:toTimePicker)
        self.resignResponderForTxtField()
    }
    
    
    @objc func resignResponderForTxtField()
    {
        self.fromTimeTxtFld.resignFirstResponder()
        self.toTimeTxtFld.resignFirstResponder()
        self.workCategoryTxtField.resignFirstResponder()
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WorkPlaceDetailsViewController.resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    private func addPickerView()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(WorkPlaceDetailsViewController.pickerDoneBtnAction))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.workCategoryTxtField.inputView = pickerView
        self.workCategoryTxtField.inputAccessoryView = doneToolbar
        self.pickerView.backgroundColor = UIColor.clear
        self.pickerView.frame.size.height = timePickerHeight
        self.pickerView.delegate = self
    }
    
    //MARK: - Picker View Delgates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workCategoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return workCategoryList[row].Category_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.workCategoryTxtField.text = workCategoryList[row].Category_Name
        self.workCategoryObj = workCategoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }
    
    func getWorkCategoryList()
    {
        workCategoryList = getDefaultWorkCategoryObj()
        let categoryList = BL_WorkPlace.sharedInstance.getWorkCategoriesList()
        for obj in categoryList
        {
            workCategoryList.append(obj)
        }
        self.pickerView.reloadAllComponents()
    }
    
    func getDefaultWorkCategoryObj() -> [WorkCategories]
    {
        let dict : NSDictionary = ["Category_Id":0,"Category_Name": self.workCategoryTxtField.placeholder!]
        let categoryObj : WorkCategories = WorkCategories(dict: dict)
        return [categoryObj]
    }
    
    func checkCampaignPrivelege()
    {
        let dcrId = DCRModel.sharedInstance.dcrId
        
        if BL_WorkPlace.sharedInstance.checkToShowCpDropDown(dcrId:String(describing: dcrId))
        {
            self.campaignPlannerHeightConst.constant = 70
            self.campaignPlanLbl.text = defaultCampaignLblText
            self.campaignPlannerView.clipsToBounds = false
        }
        else
        {
            self.campaignPlannerHeightConst.constant = 0
            self.campaignPlannerView.clipsToBounds = true
        }
    }
    
    func setDefaultValues()
    {
        let cpId: Int = 0
        var cpCode: String?
        var cpName: String?
        var categoryId: Int?
        var categoryName: String?
        var workPlace: String?
        
        let dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        
        if (dcrHeaderObj != nil) && !isComingFromAttendanceStepper
        {
            if DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue
            {
                //  cpId = dcrHeaderObj?.CP_Id
                cpCode = checkNullAndNilValueForString(stringData: dcrHeaderObj?.CP_Code)
                defaultCPCode = checkNullAndNilValueForString(stringData: dcrHeaderObj?.CP_Code)
                cpName = checkNullAndNilValueForString(stringData:dcrHeaderObj?.CP_Name)
                
                self.setValuetoCpModelObj(cpId: cpId, cpName: cpName!, cpCode: cpCode!)
                
                if cpName == ""
                {
                    self.campaignPlanLbl.text = defaultCampaignLblText
                }
                else
                {
                    self.campaignPlanLbl.text = cpName
                }
            }
            
            categoryId = dcrHeaderObj?.Category_Id
            categoryName = dcrHeaderObj?.Category_Name
            workPlace = checkNullAndNilValueForString(stringData: dcrHeaderObj?.Place_Worked)
            self.setValueForTimeTextField(fromTime: dcrHeaderObj?.Start_Time, toTime: dcrHeaderObj?.End_Time)
            self.title = "Edit Work Place Details"
        }
        else
        {
            if !isComingFromAttendanceStepper
            {
                workPlace = self.getDefaultRegionValue()
                categoryName = self.getDefaultWorkCategoryValue()
            }
            self.title = "Add Work Place Details"
        }
        
        if !isComingFromAttendanceStepper
        {
            self.setSelectedRowInPicker(categoryName: categoryName)
            self.setValueToWorkCategoryObj(categoryId: categoryId, categoryName: categoryName)
            
            if workPlace == ""
            {
                self.workPlaceLbl.text =  self.getDefaultRegionValue()
            }
            else
            {
                self.workPlaceLbl.text = workPlace
            }
            defaultCategoryName = workCategoryTxtField.text
        }
    }
    
    func setValuesAccordingToSelectedCP()
    {
        workCategoryTxtField.isUserInteractionEnabled = true
        
        if cpModelObj != nil
        {
            let cpCode = checkNullAndNilValueForString(stringData: cpModelObj?.CP_Code)
            
            if cpCode != ""
            {
                var cpName =  checkNullAndNilValueForString(stringData: cpModelObj?.CP_Name)
                
                if cpName == ""
                {
                    cpName = defaultCampaignLblText
                }
                
                self.campaignPlanLbl.text = cpName
                
                let workPlaceObj = BL_WorkPlace.sharedInstance.getCPHeaderByCPCode(cpCode: cpCode)
                
                if workPlaceObj?.Category_Name !=  nil && workPlaceObj?.Category_Name != ""
                {
                    self.workCategoryTxtField.text = workPlaceObj?.Category_Name
                    self.workCategoryObj?.Category_Name = workPlaceObj?.Category_Name
                    self.setSelectedRowInPicker(categoryName: workCategoryTxtField.text)
                    variableCategoryName = workPlaceObj?.Category_Name
                }
                
                if workPlaceObj?.Work_Area != "" && workPlaceObj?.Work_Area != nil
                {
                    self.workPlaceLbl.text = workPlaceObj?.Work_Area
                }
                
                if (cpModelObj!.Region_Code == getRegionCode())
                {
                    workCategoryTxtField.isUserInteractionEnabled = false
                }
            }
            else
            {
                self.campaignPlanLbl.text = defaultCampaignLblText
                self.cpModelObj = nil
            }
        }
    }
    
    func checkUserAuthenticationForAccompanist()
    {
        if BL_WorkPlace.sharedInstance.checkToShowAccompanistListForCP()
        {
            self.navigateToUserAccompanistPage()
        }
        else
        {
            self.naviagteToCpListPage()
        }
    }
    
    func navigateToUserAccompanistPage()
    {
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        vc.navigationScreenName = UserListScreenName.DcrAccompanistList.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func naviagteToCpListPage()
    {
        let regionCode  = BL_InitialSetup.sharedInstance.regionCode
        let cpList = BL_WorkPlace.sharedInstance.getCPList(regionCode:regionCode!)
        let sb = UIStoryboard(name: workPlaceDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: CampaignListVcID) as! CampaignPlannerListViewController
        
        vc.delegate = self
        vc.campaignList = cpList
        
        self.isComingFromLoad = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToWorkPlace()
    {
        let workPlaceList = BL_WorkPlace.sharedInstance.getWorkPlaceDetails(date: DCRModel.sharedInstance.dcrDate)
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
        vc.placeList = workPlaceList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setPlaceHolderForTxtFld()
    {
        if isComingFromAttendanceStepper
        {
            fromTimeTxtFld.attributedPlaceholder = NSAttributedString(string:"From Time",
                                                                      attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
            toTimeTxtFld.attributedPlaceholder = NSAttributedString(string:"To Time",
                                                                    attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
    }
    
    func setSelectedCpName(cpModel : CampaignPlannerHeader?)
    {
        if cpModel != nil
        {
            self.campaignPlanLbl.text = cpModel?.CP_Name
            self.cpModelObj = cpModel
        }
        else
        {
            self.campaignPlanLbl.text = "Select \(appCp)"
        }
    }
    
    //MARK: - Validation
    private func validateCpDetails()
    {
        if campaignPlannerHeightConst.constant > 0
        {
            if BL_WorkPlace.sharedInstance.checkIfCPMandatory()
            {
                if campaignPlanLbl.text == defaultCampaignLblText
                {
                    showAlertView(message: "Please enter the \(appCp)")
                }
                else if !BL_WorkPlace.sharedInstance.checkIfCpExistsInMaster(cpCode: cpModelObj?.CP_Code) && campaignPlanLbl.text != defaultCampaignLblText
                    
                {
                    showAlertForInvalidCp()
                }
                    
                else
                {
                    self.validateWorkPlace()
                }
            }
            else if !BL_WorkPlace.sharedInstance.checkIfCpExistsInMaster(cpCode: cpModelObj?.CP_Code) && campaignPlanLbl.text != defaultCampaignLblText
            {
                showAlertForInvalidCp()
            }
            else
            {
                self.validateWorkPlace()
            }
        }
        else
        {
            self.validateWorkPlace()
        }
    }
    
    private func validateWorkPlace()
    {
        if isComingFromAttendanceStepper && workPlaceLbl.text == defaultWorkPlaceText
        {
            showAlertView(message: "Please select work place")
        }
        if checkNullAndNilValueForString(stringData: workPlaceLbl.text).count > flexiPlaceMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Place name", maxVal: flexiPlaceMaxLength, viewController: self)
        }
        else
        {
            self.validateWorkCategory()
        }
    }
    
    private func validateWorkCategory()
    {
        if workCategoryTxtField.text == workCategoryTxtField.placeholder || workCategoryTxtField.text?.count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select work category", viewController: self)
        }
        else if DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue
        {
            if cpModelObj != nil && variableCategoryName != "" && variableCategoryName != workCategoryTxtField.text
            {
                if (isSFCValidationEnabled() && !isSFCCategoryDontCheckPrivEnabled())
                {
                    AlertView.showAlertView(title: alertTitle, message: workCategoryValErrorMsg, viewController: self)
                }
                else
                {
                    self.validateMandatoryWorkTime()
                }
            }
            else
            {
                self.validateMandatoryWorkTime()
            }
        }
        else
        {
            self.validateMandatoryWorkTime()
        }
    }
    
    private func isSFCValidationEnabled() -> Bool
    {
        let privArray = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        var isValidationRequired = false
        
        if (privArray.contains(workCategoryTxtField.text!.uppercased()))
        {
            isValidationRequired = true
        }
        
        return isValidationRequired
    }
    
    private func isSFCCategoryDontCheckPrivEnabled() -> Bool
    {
        let privArray = BL_SFC.sharedInstance.getSFCCategoryDontCheckPrivVal()
        var isEnabled = false
        
        if (privArray.contains("DCR"))
        {
            isEnabled = true
        }
        
        return isEnabled
    }
    
    private func validateMandatoryWorkTime()
    {
        if isComingFromAttendanceStepper || showWorkTimeView
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
                    self.compareAndValidateTime()
                }
            }
            else
            {
                self.compareAndValidateTime()
            }
        }
        else
        {
            self.compareAndValidateTime()
        }
    }
    
    private func compareAndValidateTime()
    {
        if isComingFromAttendanceStepper || showWorkTimeView
        {
            let fromTimeText = fromTimeTxtFld.text
            let toTimeText  =  toTimeTxtFld.text
            
            if (fromTimeText?.count)! > 0
            {
                if toTimeText?.count == 0
                {
                    showAlertView(message: "Please Select To Time")
                }
            }
            
            if (toTimeText?.count)! > 0
            {
                if fromTimeText?.count == 0
                {
                    showAlertView(message: "Please Select From Time")
                }
            }
            
            if ((fromTimeTxtFld.text?.count)! > 0) && ((toTimeTxtFld.text?.count)! > 0)
            {
                if !BL_WorkPlace.sharedInstance.validateFromToTime(fromTime: fromTimeText!, toTime: toTimeText!)
                {
                    showAlertView(message: " \"To Time\" should be greater than \"From Time\"")
                }
                else
                {
                    self.checkIsToEnableLocation()
                }
            }
            else
            {
                self.checkIsToEnableLocation()
            }
        }
        else
        {
            self.checkIsToEnableLocation()
        }
    }
    
    func checkIsToEnableLocation()
    {
//        if canShowLocationMandatoryAlert()
//        {
//            AlertView.showAlertToEnableGPS()
//        }
//        else if !checkIsCapturingLocation() && showAlertCaptureLocationCount < AlertLocationCaptureCount
//        {
//            showAlertCaptureLocationCount += 1
//            AlertView.showAlertToCaptureGPS()
//        }
//        else
//        {
            updateWorkPlaceDetails()
   //     }
    }
    
    func updateWorkPlaceDetails()
    {
        let dcrModel = getDCRHeaderModel()
        BL_WorkPlace.sharedInstance.updateDCRWorkPlaceDetail(dcrHeaderModelObj: dcrModel)
        let obj = getWorkCategoryObj(categoryName: dcrModel.Category_Name!)
        
        DCRModel.sharedInstance.expenseEntityCode = obj.Category_Code
        DCRModel.sharedInstance.expenseEntityName = dcrModel.Category_Name!
        
        if DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue
        {
            if DCRModel.sharedInstance.dcrStatus == DCRStatus.newDCR.rawValue
            {
                if cpModelObj != nil
                {
                    DBHelper.sharedInstance.deleteSFCDetailsWorkplace()
                    BL_WorkPlace.sharedInstance.updateCPDetails(cpCode: cpModelObj?.CP_Code)
                }
                else if defaultCategoryName != "" && defaultCategoryName != workCategoryTxtField.text
                {
                    DBHelper.sharedInstance.deleteSFCDetailsWorkplace()
                }
            }
            else if DCRModel.sharedInstance.dcrStatus == DCRStatus.drafted.rawValue || DCRModel.sharedInstance.dcrStatus == DCRStatus.unApproved.rawValue
            {
                if cpModelObj != nil && defaultCPCode != cpModelObj?.CP_Code
                {
                    DBHelper.sharedInstance.deleteSFCDetailsWorkplace()
                    BL_WorkPlace.sharedInstance.updateCPDetails(cpCode: cpModelObj?.CP_Code)
                }
                else if (cpModelObj == nil && defaultCPCode != "") || (defaultCategoryName != "" && defaultCategoryName != workCategoryTxtField.text)
                {
                    DBHelper.sharedInstance.deleteSFCDetailsWorkplace()
                }
            }
        }
        else if DCRModel.sharedInstance.dcrFlag == DCRFlag.attendance.rawValue
        {
            if defaultCategoryName != "" && defaultCategoryName != workCategoryTxtField.text
            {
                DBHelper.sharedInstance.deleteSFCDetailsWorkplace()
            }
        }
        
        DCRModel.sharedInstance.dcrStatus = Int(dcrModel.DCR_Status)!
        let dcrHeaderModel = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderModel!])
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    func getDCRHeaderModel() -> DCRHeaderObjectModel
    {
        var categoryName : String = ""
        let dcrModelObj : DCRHeaderObjectModel = DCRHeaderObjectModel()
        
        dcrModelObj.DCR_Id = DCRModel.sharedInstance.dcrId
        dcrModelObj.Flag = DCRModel.sharedInstance.dcrFlag
        dcrModelObj.DCR_Actual_Date = DCRModel.sharedInstance.dcrDate
        
        if cpModelObj != nil
        {
            if cpModelObj?.CP_Name != defaultCampaignLblText
            {
                dcrModelObj.CP_Name = cpModelObj?.CP_Name
            }
            else
            {
                dcrModelObj.CP_Name = ""
            }
            // dcrModelObj.CP_Id = cpModelObj?.CP_Id
            dcrModelObj.CP_Code = cpModelObj?.CP_Code
            if cpModelObj?.Category_Name != nil
            {
                categoryName = (cpModelObj?.Category_Name)!
            }
        }
        else if self.campaignPlanLbl.text != defaultCampaignLblText
        {
            dcrModelObj.CP_Name = self.campaignPlanLbl.text!
        }
        
        if isComingFromAttendanceStepper || showWorkTimeView
        {
        dcrModelObj.Start_Time = self.fromTimeTxtFld.text
        dcrModelObj.End_Time = self.toTimeTxtFld.text
        }
        else
        {
            dcrModelObj.Start_Time = EMPTY
            dcrModelObj.End_Time = EMPTY
        }
        dcrModelObj.DCR_Status = String(DCRStatus.drafted.rawValue)
        dcrModelObj.Place_Worked = self.workPlaceLbl.text
        
        if workCategoryObj != nil
        {
            if workCategoryObj?.Category_Name == ""
            {
                categoryName = defaultWorkCategoryType
            }
            else
            {
                categoryName = (workCategoryObj?.Category_Name)!
            }
        }
        else
        {
            categoryName = getDefaultWorkCategoryValue()
        }
        
        let workCategoryModelObj = BL_WorkPlace.sharedInstance.getWorkCategoryObjByCategoryName(workCategoryName: categoryName)
        dcrModelObj.Category_Id =  workCategoryModelObj?.Category_Id
        dcrModelObj.Category_Name = workCategoryModelObj?.Category_Name
        
        return dcrModelObj
    }
    
    func showAlertForInvalidCp()
    {
        let alertView = UIAlertController(title: alertTitle, message: "Selected \(appCp) is invalid", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: { (alertAction) in
            let cpCount = BL_WorkPlace.sharedInstance.getCPList(regionCode: getRegionCode()).count
            if cpCount == 0
            {
                self.campaignPlanLbl.text = self.defaultCampaignLblText
                self.cpModelObj?.CP_Name = ""
            }
            alertView.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    func setSelectedWorkPlace(placeObj : PlaceMasterModel)
    {
        self.workPlaceLbl.text = placeObj.placeName
        self.isComingFromPlaceList = true
    }
    
    func setFlexiWorkPlace()
    {
        if isComingFromFlexiWorkPlace
        {
            self.workPlaceLbl.text = placeName
        }
    }
    
    func getDefaultWorkCategoryValue() -> String
    {
        var categoryName : String
        
        if self.workCategoryTxtField.text != defaultWorkCategoryType && (self.workCategoryTxtField.text?.count)! > 0
        {
            categoryName = self.workCategoryTxtField.text!
        }
        else
        {
            categoryName = defaultWorkCategoryType
        }
        return categoryName
    }
    
    func getDefaultRegionValue() -> String
    {
        return BL_InitialSetup.sharedInstance.regionName
    }
    
    func setValuetoCpModelObj(cpId : Int?, cpName : String, cpCode : String)
    {
        workCategoryTxtField.isUserInteractionEnabled = true
        
        if cpCode != "" && cpName != ""
        {
            let cpObj = DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: cpCode)
            //            let dict : NSDictionary = ["CP_Code" : cpCode , "CP_Name" : cpName]
            //            let cpObj : CampaignPlannerHeader = CampaignPlannerHeader(dict: dict)
            self.cpModelObj = cpObj
            
            if (cpObj != nil)
            {
                self.variableCategoryName = cpModelObj!.Category_Name!
                
                if (cpObj!.Region_Code == getRegionCode())
                {
                    workCategoryTxtField.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func setValueToWorkCategoryObj(categoryId : Int?, categoryName : String?)
    {
        workCategoryObj?.Category_Id = categoryId
        workCategoryObj?.Category_Name = categoryName
        
        if categoryName != nil
        {
            if categoryName == ""
            {
                self.workCategoryTxtField.text = getDefaultWorkCategoryValue()
            }
            else
            {
                self.workCategoryTxtField.text = categoryName
            }
            
        }
        else
        {
            self.workCategoryTxtField.text = getDefaultWorkCategoryValue()
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
    
    
    func setSelectedRowInPicker(categoryName : String?)
    {
        
        var index : Int  = 0
        var name : String = ""
        if categoryName != nil
        {
            name = categoryName!
        }
        else
        {
            name = getDefaultWorkCategoryValue()
        }
        
        if name == ""
        {
            name = getDefaultWorkCategoryValue()
        }
        
        if workCategoryList.count > 0
        {
            if let indexValue = workCategoryList.index(where: { (obj) -> Bool in
                obj.Category_Name.uppercased() == name.uppercased()
            })
            {
                index = indexValue
            }
            
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
    }
    
    func getWorkCategoryObj(categoryName : String) ->  WorkCategoresObjectModel
    {
        return BL_WorkPlace.sharedInstance.getWorkCategoryObjByCategoryName(workCategoryName: categoryName)!
    }
    
    
}
