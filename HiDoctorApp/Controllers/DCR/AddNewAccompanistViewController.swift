//
//  AddNewAccompanistViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol SaveActionToastDelegate {
    func showUpdateToastView()
}
class AddNewAccompanistViewController: UIViewController,SelectedAccompanistDetailsDelegate
{
    @IBOutlet weak var accompanistNameLbl: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTxtField: UITextField!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn : UIButton!
    @IBOutlet weak var selectAccompanitsBtnAction: UIButton!
    @IBOutlet weak var accompanitsView: UIView!
    
    var fromTimePicker = UIDatePicker()
    var toTimePicker = UIDatePicker()
    var modifyAccompanistObj : DCRAccompanistModel?
    var isComingFromModifyPage : Bool = false
    var selectedAccompanistObj : UserMasterModel?
    var isIndePendent : String = "0"
    var delegate : SaveActionToastDelegate?
    var accompanistMasterList : [AccompanistModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addTimePicker()
        self.setPlaceHolderForTxtFld()
        self.addTapGestureForView()
        accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setAccompanistDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextScreenBtnAction(_ sender: Any)
    {
//        if (BL_Stepper.sharedInstance.isTPFreeseDay == false)
//        {
            let addAccompanist_sb = UIStoryboard(name: commonListSb, bundle: nil)
            let addAccomapanist_vc = addAccompanist_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            addAccomapanist_vc.accompanistDelegate = self
            addAccomapanist_vc.navigationScreenName = UserListScreenName.DcrAddAccompanistList.rawValue
            addAccomapanist_vc.isTPFreeze = BL_Stepper.sharedInstance.isTPFreeseDay
            addAccomapanist_vc.navigationTitle = "User List"
            self.navigationController?.pushViewController(addAccomapanist_vc, animated: true)
       // }
    }
    
    @IBAction func switchBtnAction(_ sender: Any)
    {
        if switchBtn.isOn
        {
            self.isIndePendent = "1"
        }
        else
        {
            self.isIndePendent = "0"
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        self.validateAccompanistDetails()
    }
    
    private func validateAccompanistDetails()
    {
        if self.accompanistNameLbl.text == "Select Ride Along"
        {
            showAlertView(message: "Please select Ride Along")
        }
        else
        {
            self.compareAndValidateTime()
        }
    }
    
    func saveAccompanistDetails()
    {
        if isComingFromModifyPage
        {
            if self.isIndePendent == "1"
            {
                let errorMsg  = "All the \(appDoctor) visit of this DVR will be marked as 'Accompanied Call' with this Ride Along name.If you wish to mark any visit as independent visit, please go to the \(appDoctor) visit screen and modify that \(appDoctor) visit"
                let alertViewController = UIAlertController(title: infoTitle, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                    self.delegate?.showUpdateToastView()
                    self.modifyAccompanistObj?.Is_Only_For_Doctor = self.isIndePendent

//                    if (self.selectedAccompanistObj?.Employee_name)! != VACANT && (self.selectedAccompanistObj?.Employee_name)! != NOT_ASSIGNED && (self.selectedAccompanistObj?.Employee_name)! != NOT_ASSIGNED_VALUE
//
//                    {
                    
                    _ = BL_DCR_Accompanist.sharedInstance.updateDCRAccomapnistData(dcrAccompanistModelObj:self.modifyAccompanistObj!)
                    _ = BL_DCR_Doctor_Accompanists.sharedInstance.updateDCRDoctorAccompanist(dcrAccompanistObj :self.modifyAccompanistObj!)
                    _ = BL_DCR_Chemist_Accompanists.sharedInstance.updateDCRChemistAccompanist(dcrAccompanistObj :self.modifyAccompanistObj!)
                        
                   // }
                    alertViewController.dismiss(animated: true, completion: nil)
                    _ = self.navigationController?.popViewController(animated: false)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
            else
            {
                delegate?.showUpdateToastView()
                modifyAccompanistObj?.Is_Only_For_Doctor = isIndePendent
                _ = BL_DCR_Accompanist.sharedInstance.updateDCRAccomapnistData(dcrAccompanistModelObj:modifyAccompanistObj! )
                _ = BL_DCR_Doctor_Accompanists.sharedInstance.updateDCRDoctorAccompanist(dcrAccompanistObj :self.modifyAccompanistObj!)
                _ = BL_DCR_Chemist_Accompanists.sharedInstance.updateDCRChemistAccompanist(dcrAccompanistObj :self.modifyAccompanistObj!)
                BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                _ = self.navigationController?.popViewController(animated: false)
            }
        }
        else
        {
            checkIsIFDCRDoctorVisitHasEntry()
        }
    }
    
    func checkIsIFDCRDoctorVisitHasEntry()
    {
        if BL_DCR_Accompanist.sharedInstance.checkIsDCRDoctorVisitHasEntry()
        {
            var errorMsg: String = EMPTY
            var isOnlyForDoctor: String = self.isIndePendent
            
            errorMsg  = "All the \(appDoctor) visit of this DVR will be marked as 'Accompanied Call' with this Ride Along name.If you wish to mark any visit as independent visit, please go to the \(appDoctor) visit screen and modify that \(appDoctor) visit"
            
            if (BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEnabled())
            {
                if (self.selectedAccompanistObj != nil)
                {
                    if (self.selectedAccompanistObj!.Child_User_Count == 0)
                    {
                        errorMsg = Display_Messages.DCR_Inheritance_Messages.NEW_ACCOMPANIST_ADD_MESSAGE
                        isOnlyForDoctor = "1"
                    }
                }
            }
            
            let alertViewController = UIAlertController(title: infoTitle, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                self.saveDCRAccompanistData()

                
//
                if (self.selectedAccompanistObj?.Employee_name)! != VACANT && (self.selectedAccompanistObj?.Employee_name)! != NOT_ASSIGNED && (self.selectedAccompanistObj?.Employee_name)! != NOT_ASSIGNED_VALUE

                {
                
                
                BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRAccompanistToDoctorAccompanist(dcrAccompanistObj: self.selectedAccompanistObj!, isIndependentCall: isOnlyForDoctor)
                 BL_DCR_Chemist_Accompanists.sharedInstance.insertDCRAccompanistToChemistAccompanist(dcrAccompanistObj: self.selectedAccompanistObj!, isIndependentCall: self.isIndePendent)
//                    BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                    
                }
                BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                alertViewController.dismiss(animated: true, completion: nil)
                _ = self.navigationController?.popViewController(animated: false)
            }))
            
            self.present(alertViewController, animated: true, completion: nil)
        }
        else
        {
            saveDCRAccompanistData()
            BL_Stepper.sharedInstance.getAccompanistDataPendingList()
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
    
    func saveDCRAccompanistData()
    {
        BL_DCR_Accompanist.sharedInstance.saveDCRAccompanistData(userMasterObj: selectedAccompanistObj!, isIndependentCall:isIndePendent , startTime: fromTxtField.text!, endTime: toTextField.text!)
    }
    
    
    private func compareAndValidateTime()
    {
        let fromTimeText = fromTxtField.text
        let toTimeText  =  toTextField.text
        var accompanistUserCode: String = EMPTY
        var employeeName: String = EMPTY
        var regionCode: String = EMPTY
        
        if (self.isComingFromModifyPage && self.modifyAccompanistObj != nil)
        {
            accompanistUserCode = self.modifyAccompanistObj!.Acc_User_Code!
            employeeName = self.modifyAccompanistObj!.Employee_Name!
            regionCode = self.modifyAccompanistObj!.Acc_Region_Code!
        }
        else if (self.selectedAccompanistObj != nil)
        {
            accompanistUserCode = self.selectedAccompanistObj!.User_Code
            employeeName = self.selectedAccompanistObj!.Employee_name
            regionCode = self.selectedAccompanistObj!.Region_Code
        }
        
        if (fromTimeText?.count)! > 0 && toTimeText?.count == 0
        {
            showAlertView(message: "Please Enter Working To Time")
        }
        else if (toTimeText?.count)! > 0 && fromTimeText?.count == 0
        {
            showAlertView(message: "Please Enter Working From Time")
        }
        else if ((fromTimeText?.count)! > 0) && ((toTimeText?.count)! > 0) && !BL_WorkPlace.sharedInstance.validateFromToTime(fromTime: fromTimeText!, toTime: toTimeText!)
        {
            showAlertView(message: " \"To Time\" should be greater than \"From Time\"")
        }
        else if (BL_DCR_Doctor_Visit.sharedInstance.getDCRInheritancePrivilegeValue() == PrivilegeValues.ONE.rawValue && self.isIndePendent == "1" && BL_DCR_Doctor_Visit.sharedInstance.isLeafUser(userCode: accompanistUserCode, regionCode: regionCode)) // Inheritance mandatory
        {
            if (checkInternetConnectivity())
            {
                showCustomActivityIndicatorView(loadingText: "Please wait...")
                BL_DCR_Doctor_Visit.sharedInstance.checkAccompanistEnteredDCRForInheritance(accompanistUserCode: accompanistUserCode, dcrDate: DCRModel.sharedInstance.dcrDateString, completion: { (objApiResponse) in
                    removeCustomActivityView()
                    if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                    {
                        if (objApiResponse.Count > 0)
                        {
                            var errorMessage = Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_VALIDATION_ERROR_MESSAGE
                            errorMessage = errorMessage.replacingOccurrences(of: "@ACC_USER", with: employeeName)
                            
                            AlertView.showAlertView(title: errorTitle, message: errorMessage)
                        }
                        else
                        {
                            self.saveAccompanistDetails()
                        }
                    }
                    else
                    {
                        AlertView.showAlertView(title: errorTitle, message: Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_VALIDATION_API_ERROR_MESSAGE)
                    }
                })
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_VALIDATION_USER_OFFLINE_MESSAGE)
            }
        }
        else
        {
            self.saveAccompanistDetails()
        }
    }
    
    private func addTimePicker()
    {
        fromTimePicker = getTimePickerView()
        fromTimePicker.tag = 1
        fromTimePicker.backgroundColor = UIColor.lightGray
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddNewAccompanistViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddNewAccompanistViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        fromTxtField.inputAccessoryView = doneToolbar
        fromTxtField.inputView = fromTimePicker
        
        let Toolbar = getToolBar()
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddNewAccompanistViewController.doneBtnAction))
        
        let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddNewAccompanistViewController.cancelBtnClicked))
        toTimePicker = getTimePickerView()
        toTimePicker.tag = 2
        toTimePicker.backgroundColor = UIColor.lightGray
        
        Toolbar.items = [flexSpace, doneBtn, cancelBtn]
        Toolbar.sizeToFit()
        toTextField.inputAccessoryView = Toolbar
        toTextField.inputView = toTimePicker
    }
    
    func setTimeDetails(sender : UIDatePicker)
    {
        let time = sender.date
        
        if sender.tag == 1
        {
            self.fromTxtField.text = stringFromDate(date1: time)
        }
        else
        {
            self.toTextField.text = stringFromDate(date1: time)
        }
    }
    
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: fromTimePicker)
        self.assignValueToObj()
        self.resignResponderForTxtField()
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func doneBtnAction()
    {
        self.setTimeDetails(sender:toTimePicker)
        self.assignValueToObj()
        self.resignResponderForTxtField()
    }
    
    func assignValueToObj()
    {
        if (toTextField.text?.count)! > 0 && (fromTxtField.text?.count)! > 0
        {
            if isComingFromModifyPage
            {
                modifyAccompanistObj?.Acc_Start_Time = fromTxtField.text
                modifyAccompanistObj?.Acc_End_Time = toTextField.text
            }
        }
    }
    
    func setAccompanistDetails()
    {
        var accompanistName : String = "Select Ride Along"
        var startTime : String = ""
        var endTime : String = ""
        var isSelected : Bool = false
        var navigationTitle = "Add New Ride Along"
        var saveBtnTitle : String = "SUBMIT"
        
        self.accompanitsView.alpha = 1.0
        self.accompanitsView.backgroundColor = UIColor.white
        self.selectAccompanitsBtnAction.isUserInteractionEnabled = true
        
        if modifyAccompanistObj != nil && isComingFromModifyPage
        {
            navigationTitle = "Edit Ride Along"
            saveBtnTitle = "SAVE"
            self.accompanitsView.alpha = 0.5
            self.selectAccompanitsBtnAction.isUserInteractionEnabled = false
            self.accompanitsView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            
            accompanistName = (modifyAccompanistObj?.Employee_Name)!
            startTime = (modifyAccompanistObj?.Acc_Start_Time)!
            endTime = (modifyAccompanistObj?.Acc_End_Time)!
            
            self.isIndePendent = (modifyAccompanistObj?.Is_Only_For_Doctor)!
            
            let filterAccompanist = self.accompanistMasterList.filter{
                $0.Region_Code == modifyAccompanistObj?.Acc_Region_Code
            }
            
            let accompanistDoctorCount = BL_DCR_Accompanist.sharedInstance.getAccompanistDoctorCount(accompanistRegionCode : (modifyAccompanistObj?.Acc_Region_Code)!)
            if modifyAccompanistObj?.Is_Only_For_Doctor == "1"
            {
                isSelected = true
                if checkIsVacantRegion(userName: checkNullAndNilValueForString(stringData: modifyAccompanistObj?.Acc_User_Name), employeeName:checkNullAndNilValueForString(stringData:  modifyAccompanistObj?.Employee_Name))
                {
                    disableSwitchBtn()
                }
                else if filterAccompanist.count > 0
                {
                    if filterAccompanist[0].Is_Child_User == 0
                    {
                        disableSwitch()
                    }
                    else if accompanistDoctorCount == 0 ||  self.isIndePendent == "1"
                    {
                        disableSwitch()
                    }
                }
                else if accompanistDoctorCount == 0
                {
                    disableSwitch()
                }
            }
            else if filterAccompanist.count > 0
            {
                if filterAccompanist[0].Is_Child_User == 0
                {
                    disableSwitch()
                }
                else if accompanistDoctorCount == 0 ||  self.isIndePendent == "1"
                {
                    disableSwitch()
                }
            }
            else if accompanistDoctorCount == 0
            {
                disableSwitch()
            }
        }
        
        if selectedAccompanistObj != nil
        {
            let accompanistDoctorCount = BL_DCR_Accompanist.sharedInstance.getAccompanistDoctorCount(accompanistRegionCode :(selectedAccompanistObj?.Region_Code)!)
            
            if (checkIsVacantRegion(userName: checkNullAndNilValueForString(stringData: selectedAccompanistObj?.User_Name), employeeName: checkNullAndNilValueForString(stringData: selectedAccompanistObj?.Employee_name)))
            {
                disableSwitchBtn()
                
            }
            
            else if selectedAccompanistObj?.Is_Child_User == 0 || accompanistDoctorCount == 0
            {
                disableSwitch()
            }
            
            accompanistName = (selectedAccompanistObj?.Employee_name)!
        }
        
        self.navigationItem.title = navigationTitle
        self.accompanistNameLbl.text = accompanistName
        self.fromTxtField.text = startTime
        self.toTextField.text = endTime
        self.switchBtn.isOn = isSelected
        self.saveBtn.setTitle(saveBtnTitle, for: UIControlState.normal)
    }
    
    func setSelectedAccompanistName(accompanistObj: UserMasterWrapperModel)
    {
        selectedAccompanistObj = accompanistObj.userObj
        
        let accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        if (accompanistMasterList.count > 0)
        {
            let filteredArray = accompanistMasterList.filter{
                $0.User_Code == selectedAccompanistObj?.User_Code
            }
            
            if (filteredArray.count > 0)
            {
                selectedAccompanistObj?.Child_User_Count = filteredArray.first!.Child_User_Count
                selectedAccompanistObj?.Is_Child_User = filteredArray.first!.Is_Child_User
            }
        }
        
        if isComingFromModifyPage
        {
            self.assignSelectedObjToModifyObj(accompanistObj:accompanistObj)
        }
    }
    
    func assignSelectedObjToModifyObj(accompanistObj: UserMasterWrapperModel)
    {
        self.modifyAccompanistObj?.Acc_User_Code = accompanistObj.userObj.User_Code
        self.modifyAccompanistObj?.Acc_Region_Code = accompanistObj.userObj.Region_Code
        self.modifyAccompanistObj?.Acc_User_Name = accompanistObj.userObj.User_Name
        self.modifyAccompanistObj?.Acc_User_Type_Name = accompanistObj.userObj.User_Type_Name
        self.modifyAccompanistObj?.Employee_Name = accompanistObj.userObj.Employee_name
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewAccompanistViewController.resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponderForTxtField()
    {
        self.fromTxtField.resignFirstResponder()
        self.toTextField.resignFirstResponder()
    }
    
    func setPlaceHolderForTxtFld()
    {
        fromTxtField.attributedPlaceholder = NSAttributedString(string:"From Time",
                                                                attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        toTextField.attributedPlaceholder = NSAttributedString(string:"To Time",
                                                               attributes:[NSAttributedStringKey.foregroundColor: UIColor.darkGray])
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
    
    private func checkIsVacantRegion(userName : String,employeeName : String) -> Bool
    {
        return  BL_DCR_Accompanist.sharedInstance.checkIsVacantRegion(userName : userName,employeeName : employeeName)
    }
    
    private func disableSwitchBtn()
    {
        self.switchBtn.isEnabled =  false
        self.switchBtn.alpha = 0.5
        self.isIndePendent = "1"
    }
    
    private func disableSwitch()
    {
        self.switchBtn.isEnabled =  false
        self.switchBtn.alpha = 0.5
    }
    
    
}
