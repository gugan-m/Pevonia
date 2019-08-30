//
//  TPWorkPlaceDetailViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPWorkPlaceDetailViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource , AddWorkPlaceDelegate,CampaignPlannerDelegate
{
    
    @IBOutlet weak var workCategoryTxtField: UITextField!
    @IBOutlet weak var workPlaceLbl: UILabel!
    @IBOutlet weak var campaignPlanLbl: UILabel!
    @IBOutlet weak var campaignPlannerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var campaignPlannerView: UIView!
    
    var pickerView = UIPickerView()
    var workCategoryList : [WorkCategories] = []
    var workCategoryObj : WorkCategories?
    var placeName : String = ""
    var defaultCategoryName: String? = ""
    var variableCategoryName : String? = ""
    var isComingFromTPAttendance = false
    var cpModelObj : CampaignPlannerHeader?
    var defaultCPCode: String? = ""
    var showAlertCaptureLocationCount : Int = 0
    let defaultWorkPlaceText : String  = "Select WorkPlace"
    var isComingFromFlexiWorkPlace : Bool = false
    let defaultCampaignLblText = "Select \(appCp)"
    var isComingFromPlaceList : Bool = false
    var TPobject : TourPlannerHeader?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.toggleCPView()
        self.getWorkCategoryList()
        self.addPickerView()
        self.addTapGestureForView()
        self.setDefaultValues()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if !isComingFromPlaceList || !isComingFromFlexiWorkPlace
        {
            self.setValuesAccordingToSelectedCP()
        }
        
        showAlertCaptureLocationCount = 0
        
        self.setFlexiWorkPlace()
        addBackButtonView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    @IBAction func navigateWorkPlace(_ sender: Any)
    {
        self.navigateToWorkPlace()
    }
    
    @IBAction func navigateToNextScreenBtnAction(_ sender: AnyObject)
    {
        self.naviageToNextScreen(senderTag: sender.tag)
    }
    
    func naviageToNextScreen(senderTag : Int)
    {
        switch senderTag {
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
    
    func validateWorkPlaceDetails() -> Bool
    {
        if (workCategoryTxtField.text?.count)! > 0 && workCategoryTxtField.text != "SELECT WORK CATEGORY"{
            
            let workPlaceObj = StepperWorkPlaceModel()
            workPlaceObj.key = workCategory
            workPlaceObj.value = workCategoryTxtField.text
            
            if isComingFromTPAttendance
            {
                BL_TP_AttendanceStepper.sharedInstance.workPlaceList.removeAll()
                BL_TP_AttendanceStepper.sharedInstance.workPlaceList.append(workPlaceObj)
            }
            else
            {
                BL_TPStepper.sharedInstance.workPlaceList.removeAll()
                BL_TPStepper.sharedInstance.workPlaceList.append(workPlaceObj)
            }
        }
        else
        {
            let message = "Please select Work Category"
            AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
            return false
        }
        
        let workPlaceObj = StepperWorkPlaceModel()
        workPlaceObj.key = workPlace
        
        if (workPlaceLbl.text?.count)! > 0 && workPlaceLbl.text != "Select WorkPlace"
        {
            workPlaceObj.value = workPlaceLbl.text
        }
        else
        {
            workPlaceObj.value = "N/A"
        }
        
        if isComingFromTPAttendance
        {
            BL_TP_AttendanceStepper.sharedInstance.workPlaceList.append(workPlaceObj)
        }
        else
        {
            BL_TPStepper.sharedInstance.workPlaceList.append(workPlaceObj)
        }
        return true
    }
    
    @objc func pickerDoneBtnAction()
    {
        self.resignResponderForTxtField()
    }
    
    
    @objc func resignResponderForTxtField()
    {
        
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
    
    func setDefaultValues()
    {
        let cpId: Int = 0
        var cpCode: String?
        var cpName: String?
        var categoryId: Int?
        var categoryName: String?
        var workPlace: String?
        var categoryCode: String?
        var title = "Add Work Place Details"
        let tpHeaderObj = BL_WorkPlace.sharedInstance.getTPHeaderDetailForWorkPlace()
        
        // Get values from draft
        if (tpHeaderObj != nil)
        {
            // CP
            if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
            {
                cpCode = checkNullAndNilValueForString(stringData: tpHeaderObj!.CP_Code)
                cpName = checkNullAndNilValueForString(stringData:tpHeaderObj!.CP_Name)
                defaultCPCode = checkNullAndNilValueForString(stringData: tpHeaderObj!.CP_Code)
            }
            
            // Work Category
            if let catId = tpHeaderObj!.Category_Id
            {
                categoryId = catId
            }
            
            categoryCode = checkNullAndNilValueForString(stringData: tpHeaderObj!.Category_Code)
            categoryName = checkNullAndNilValueForString(stringData:tpHeaderObj!.Category_Name)
            
            // Work Place
            workPlace = checkNullAndNilValueForString(stringData:tpHeaderObj!.Work_Place)
            
            if (categoryName != EMPTY)
            {
                title = "Edit Work Place Details"
            }
        }
        
        // Set values in controls & Objects
        
        // CP
        if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
        {
            if (checkNullAndNilValueForString(stringData: cpName) == EMPTY)
            {
                cpCode = EMPTY
                cpName = defaultCampaignLblText
            }
            campaignPlanLbl.text = cpName!
            setValuetoCpModelObj(cpId: cpId, cpName: cpName!, cpCode: cpCode!)
        }
        
        // Work Category
        if (checkNullAndNilValueForString(stringData: categoryName) == EMPTY)
        {
            if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
            {
                categoryName = defaultWorkCategoryType
                
                let filtered = workCategoryList.filter{
                    $0.Category_Name.uppercased() == categoryName!.uppercased()
                }
                
                if (filtered.count > 0)
                {
                    categoryCode = filtered.first!.Category_Code
                    categoryId = filtered.first!.Category_Id
                }
            }
            else if (TPModel.sharedInstance.tpFlag == TPFlag.attendance.rawValue)
            {
                categoryCode = EMPTY
                categoryName = workCategoryTxtField.placeholder
            }
        }
        
        setSelectedRowInPicker(categoryName: categoryName)
        setValueToWorkCategoryObj(categoryId: categoryId, categoryName: categoryName, categoryCode: categoryCode)
        defaultCategoryName = workCategoryTxtField.text
        
        // Work Place
        if (checkNullAndNilValueForString(stringData: workPlace) == EMPTY)
        {
            if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
            {
                workPlace = getDefaultRegionValue()
            }
            else if (TPModel.sharedInstance.tpFlag == TPFlag.attendance.rawValue)
            {
                workPlace = defaultWorkPlaceText
            }
        }
        
        workPlaceLbl.text = workPlace!
        
        // Page tile
        self.title = title
        
//        if (tpHeaderObj != nil && !isComingFromTPAttendance)
//        {
//            if TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue
//            {
//                //  cpId = dcrHeaderObj?.CP_Id
//                cpCode = checkNullAndNilValueForString(stringData: tpHeaderObj?.CP_Code)
//                defaultCPCode = checkNullAndNilValueForString(stringData: tpHeaderObj?.CP_Code)
//                cpName = checkNullAndNilValueForString(stringData:tpHeaderObj?.CP_Name)
//                
//                self.setValuetoCpModelObj(cpId: cpId, cpName: cpName!, cpCode: cpCode!)
//                
//                if cpName == ""
//                {
//                    self.campaignPlanLbl.text = defaultCampaignLblText
//                }
//                else
//                {
//                    self.campaignPlanLbl.text = cpName
//                }
//            }
//            
//            if (checkNullAndNilValueForString(stringData: tpHeaderObj?.Category_Name) != EMPTY)
//            {
//                categoryId = tpHeaderObj?.Category_Id
//                categoryName = tpHeaderObj?.Category_Name
//                categoryCode =  tpHeaderObj?.Category_Code
//            }
//            
//            workPlace = checkNullAndNilValueForString(stringData: tpHeaderObj?.Work_Place)
//            self.title = "Edit Work Place Details"
//        }
//        else
//        {
//            if !isComingFromTPAttendance
//            {
//                workPlace = self.getDefaultRegionValue()
//                categoryName = self.getDefaultWorkCategoryValue()
//                categoryCode = defaultWorkCategoryCode
//            }
//            
//            self.title = "Add Work Place Details"
//        }
//        if !isComingFromTPAttendance
//        {
//            self.setSelectedRowInPicker(categoryName: categoryName)
//            self.setValueToWorkCategoryObj(categoryId: categoryId, categoryName: categoryName, categoryCode: categoryCode)
//            
//            
//            if workPlace == ""
//            {
//                self.workPlaceLbl.text =  self.getDefaultRegionValue()
//            }
//            else
//            {
//                self.workPlaceLbl.text = workPlace
//            }
//            
//            defaultCategoryName = workCategoryTxtField.text
//        }
    }
    
    func setValuetoCpModelObj(cpId : Int?, cpName : String, cpCode : String)
    {
        if cpCode != "" && cpName != ""
        {
            let dict : NSDictionary = ["CP_Code" : cpCode , "CP_Name" : cpName]
            let cpObj : CampaignPlannerHeader = CampaignPlannerHeader(dict: dict)
            self.cpModelObj = cpObj
        }
    }
    
    func checkUserAuthenticationForAccompanist()
    {
        if BL_TPStepper.sharedInstance.canUseAccompanistCp(entityName: "CP")
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
        vc.navigationScreenName = UserListScreenName.TPWorkPlace.rawValue
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigateToWorkPlace()
    {
        let workPlaceList = BL_WorkPlace.sharedInstance.getWorkPlaceDetails(date: TPModel.sharedInstance.tpDate)
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
        vc.placeList = workPlaceList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func validateWorkPlace()
    {
        if isComingFromTPAttendance && workPlaceLbl.text == defaultWorkPlaceText
        {
            showAlertView(message: "Please select work place")
        }
        else
        {
            self.validateWorkCategory()
        }
    }
    
    private func validateWorkCategory()
    {
        if (workCategoryTxtField.text == workCategoryTxtField.placeholder || workCategoryTxtField.text?.count == 0)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select work category", viewController: self)
        }
        else if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
        {
            if cpModelObj != nil && variableCategoryName != "" && variableCategoryName != workCategoryTxtField.text
            {
                AlertView.showAlertView(title: alertTitle, message: workCategoryValErrorMsg, viewController: self)
            }
            else
            {
                 updateWorkPlaceDetails()
            }
        }
        else
        {
             updateWorkPlaceDetails()
        }
    }
    
    func updateWorkPlaceDetails()
    {
        var cpname = ""
        var cpcode = ""
        
        if(cpModelObj?.CP_Name == nil &&  cpModelObj?.CP_Code == nil)
        {
            cpname = EMPTY
            cpcode = EMPTY
        }
        else
        {
            cpname = (cpModelObj?.CP_Name)!
            cpcode = (cpModelObj?.CP_Code)!
        }

        let dict: NSDictionary = ["TP_Id": 0, "TP_Date": TPModel.sharedInstance.tpDateString,"Category_Name": workCategoryObj!.Category_Name, "CP_Name": cpname,"CP_Code": cpcode,"Work_Area": workPlaceLbl.text!, "Category_Code": workCategoryObj!.Category_Code]
        let objTPHeader: TourPlannerHeader = TourPlannerHeader(dict: dict)
        
        BL_TPStepper.sharedInstance.updateWorkPlaceDetails(Date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag, workPlaceObj: objTPHeader)
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    func getTPHeaderModel() -> TourPlannerHeaderObjModel
    {
        var categoryName : String = ""
        
        let tpModelObj : TourPlannerHeaderObjModel = TourPlannerHeaderObjModel()
        
        tpModelObj.TP_Entry_Id = TPModel.sharedInstance.tpEntryId
        tpModelObj.TP_Date = TPModel.sharedInstance.tpDate
        
        if cpModelObj != nil
        {
            
            tpModelObj.CP_Name = ""
            // dcrModelObj.CP_Id = cpModelObj?.CP_Id
            tpModelObj.CP_Code = cpModelObj?.CP_Code
            if cpModelObj?.Category_Name != nil
            {
                categoryName = (cpModelObj?.Category_Name)!
            }
        }
        
        tpModelObj.Status =  TPStatus.drafted.rawValue
        tpModelObj.Work_Place = self.workPlaceLbl.text
        
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
        tpModelObj.Category_Id =  workCategoryModelObj?.Category_Id
        tpModelObj.Category_Name = workCategoryModelObj?.Category_Name
        
        return tpModelObj
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    func setSelectedWorkPlace(placeObj: PlaceMasterModel) {
        workPlaceLbl.text = placeObj.placeName
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
    
    
    func setValueToWorkCategoryObj(categoryId : Int?, categoryName : String?, categoryCode : String? )
    {
        workCategoryObj?.Category_Id = categoryId
        workCategoryObj?.Category_Name = categoryName
        workCategoryObj?.Category_Code = categoryCode
        
        self.workCategoryObj = WorkCategories(categoryCode: categoryCode!, categoryName: categoryName!)
        
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
            index = workCategoryList.index(where: { (obj) -> Bool in
                obj.Category_Name.uppercased() == name.uppercased()
            })!
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    func getWorkCategoryObj(categoryName : String) ->  WorkCategoresObjectModel
    {
        return BL_WorkPlace.sharedInstance.getWorkCategoryObjByCategoryName(workCategoryName: categoryName)!
    }
    private func getCPPrivilegeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAMPAIGN_PLANNER)
    }
    
    private func toggleCPView()
    {
        cpModelObj?.CP_Name = EMPTY
        cpModelObj?.CP_Code = EMPTY
        
        if (TPModel.sharedInstance.tpFlag == TPFlag.attendance.rawValue || getCPPrivilegeValue() == PrivilegeValues.NO.rawValue)
        {
            self.campaignPlannerHeightConst.constant = 0
            self.campaignPlannerView.clipsToBounds = true
        }
        else
        {
            self.campaignPlannerHeightConst.constant = 70
            self.campaignPlanLbl.text = defaultCampaignLblText
            self.campaignPlannerView.clipsToBounds = false
        }
    }
    
    func setValuesAccordingToSelectedCP()
    {
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
                    self.workCategoryObj = WorkCategories(categoryCode: workPlaceObj!.Category_Code, categoryName: workPlaceObj!.Category_Name!)
                    
                    self.workCategoryTxtField.text = workPlaceObj!.Category_Name
//                    self.workCategoryObj?.Category_Code = workPlaceObj!.Category_Code
//                    self.workCategoryObj?.Category_Name = workPlaceObj!.Category_Name
                    self.setSelectedRowInPicker(categoryName: workCategoryTxtField.text)
                    
                    variableCategoryName = workPlaceObj?.Category_Name
                }
                
                if workPlaceObj?.Work_Area != "" && workPlaceObj?.Work_Area != nil
                {
                    self.workPlaceLbl.text = workPlaceObj?.Work_Area
                }
            }
            else
            {
                self.campaignPlanLbl.text = defaultCampaignLblText
                self.cpModelObj = nil
            }
        }
    }
    private func validateCpDetails()
    {
        if campaignPlannerHeightConst.constant > 0
        {
            if BL_WorkPlace.sharedInstance.checkIfCPMandatory()
            {
                if checkNullAndNilValueForString(stringData: cpModelObj?.CP_Name) == EMPTY
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
    
}
