//
//  DCRStepperNewViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 15/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//


import UIKit

class DCRStepperNewViewController: UIViewController {//,SelectedAccompanistPopUpDelegate, AddSampleDelegate {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK:- Variables
    var stepperDataList: [DCRStepperModel] = []
    var previousScrollPosition: CGPoint!
    var showAlertCaptureLocationCount : Int = 0
    let htmlstr = ""
    var pickerview = UIPickerView()
    var workCategory : [WorkCategories] = []
    var selectedWorkPlace = ""
    var selectedWorkCategoryID = 0
    var generalText = ""
    var default_Blue = UIColor(red: 63.0/255.0, green: 81.0/255.0, blue: 181.0/255.0, alpha: 1.0)
    var visitedContactColor = UIColor(red: 0/255.0, green: 150.0/255.0, blue: 136/255.0, alpha: 1.0)
    var isProspect = false
    var isFromDVR = false
    var general = UITextField()
    let doctorvisitmodify = DoctorVisitModifyController()
    var IS_VIEW_MODE = false
    // MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        //        removeVersionToastView()
        //        super.viewDidLoad()
        
        self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + " (Field)"
        if (isProspect)
        {
            self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + " (Prospecting)"
        }
        workCategory = BL_WorkPlace.sharedInstance.getWorkCategoriesList()
        self.pickerview.delegate = self
       if IS_VIEW_MODE == true {
            self.tableView.isUserInteractionEnabled = false
            self.submitButton.isHidden = true
        } else {
            self.tableView.isUserInteractionEnabled = true
            self.submitButton.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        BL_Stepper.sharedInstance.generateDataArray()
        if BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name != nil {
            if BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name?.count == 0 {
//                selectedWorkPlace = workCategory[0].Category_Name
//                selectedWorkCategoryID =  workCategory[0].Category_Id
            } else {
                selectedWorkPlace = BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name ?? ""
                selectedWorkCategoryID = BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Id ?? 0
            }
        }
        reloadTableView()
        //        showAlertCaptureLocationCount = 0
        //
        //        showPendingAccompanistDataDownloadAlert()
        //
        //        if (BL_TPStepper.sharedInstance.isSFCUpdated)
        //        {
        //            BL_TPStepper.sharedInstance.isSFCUpdated = false
        //            showToastView(toastText: "Your SFC updated")
        //        }
    }
    
    //    override func didReceiveMemoryWarning()
    //    {
    //        super.didReceiveMemoryWarning()
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool)
    //    {
    //
    //    }
    //
    //    // MARK:- Private Functions
    //    private func showPendingAccompanistDataDownloadAlert()
    //    {
    //        if (checkInternetConnectivity())
    //        {
    //            if (BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData())
    //            {
    //                let pendingList = BL_TPStepper.sharedInstance.accompanistDataDownloadPendingUsersList()
    //
    //                if (pendingList.count > 0)
    //                {
    //                    let popUp_sb = UIStoryboard(name:dcrStepperSb, bundle: nil)
    //                    let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AccompanistPopUpVcID) as! AccompanistPopUpViewController
    //                    popUp_Vc.dcrAccompanistList = pendingList
    //                    popUp_Vc.delegate = self
    //                    popUp_Vc.providesPresentationContextTransitionStyle = true
    //                    popUp_Vc.definesPresentationContext = true
    //                    popUp_Vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    //                    self.present(popUp_Vc, animated: false, completion: nil)
    //                }
    //            }
    //        }
    //    }
    //
    private func downloadAccompanistData(selectedAccompanistList: [DCRAccompanistModel])
    {
        showLoader()
        
        BL_TPStepper.sharedInstance.downloadAccompanistData(selectedAccompanistList: selectedAccompanistList) { (status) in
            
            if (status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: "Download Accompanist from PR"), completion: { (apiObj) in
                    self.hideLoader()
                    self.showToast(message: "\(PEV_ACCOMPANIST) data downloaded successfully")
                    
                    BL_TPStepper.sharedInstance.getAccompanistDataPendingList()
                    self.tableView.reloadData()
                })
            }
            else
            {
                self.showToast(message: "Error while downloading accompanist data. Please try again later")
            }
        }
    }
    
    private func getPostData(sectionName: String) -> [String: Any]
    {
        let postData :[String:Any] = ["Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Section_Name":sectionName,"Download_Date":getCurrentDateAndTimeString(),"Downloaded_Acc_Region_Codes":BL_PrepareMyDeviceAccompanist.sharedInstance.getRegionCodeStringWithOutQuotes()]
        
        return postData
    }
    //
    //    private func showAlert(message: String)
    //    {
    //        let delayTime = DispatchTime.now() + 0.1
    //
    //        DispatchQueue.main.asyncAfter(deadline: delayTime)
    //        {
    //            AlertView.showAlertView(title: alertTitle, message: message)
    //        }
    //    }
    //
    private func showLoader()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading data. Please wait...")
    }
    
    private func hideLoader()
    {
        removeCustomActivityView()
    }
    
    private func showToast(message: String)
    {
        showToastView(toastText: message)
    }
    //
    //    private func updateAccompanistDownloadLater(selectedAccompanistList: [DCRAccompanistModel])
    //    {
    //        BL_TPStepper.sharedInstance.updateAccompanistDataDownloadAsLater(selectedAccompanistList: selectedAccompanistList)
    //    }
    //
    //    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
        previousScrollPosition = CGPoint.zero
        //  toggleSubmitButton()
    }
    //
    //    private func reloadTableViewAtIndexPath(index: Int)
    //    {
    //        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
    //
    //        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    //    }
    //
    //    // MARK:-- Navigation Functions
    //    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    //    {
    //        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: viewController)
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    //    private func navigateToAddAccompanist()
    //    {
    //
    //        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
    //        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
    //        accom_vc.navigationScreenName = "tpAccomanist"
    //        accom_vc.navigationTitle = "User List"
    //        self.navigationController?.pushViewController(accom_vc, animated: false)
    //    }
    //
    //    private func navigateToEditAccompanist()
    //    {
    //        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
    //        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
    //        accom_vc.navigationScreenName = "tpAccomanist"
    //        accom_vc.navigationTitle = "User List"
    //        accom_vc.isTPModify = true
    //        self.navigationController?.pushViewController(accom_vc, animated: false)
    //    }
    //
    //    private func navigateToAddMeetingPointDetails()
    //    {
    //        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: TPMeetingPointVCID) as! TPMeetingPointViewController
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    //    private func navigateToEditMeetingPointDetails()
    //    {
    //        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: TPMeetingPointVCID) as! TPMeetingPointViewController
    //        vc.fromModify = true
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    //    private func navigateToAddWorkPlaceDetails()
    //    {
    //        navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPWorkPlaceDetailVCID)
    //    }
    //
    //    private func navigateToEditWorkPlaceDetails()
    //    {
    //        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: TPWorkPlaceDetailVCID) as! TPWorkPlaceDetailViewController
    //        self.navigationController?.pushViewController(vc, animated: true)
    //        //navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: DCRHeaderVcID)
    //    }
    //
    //    private func navigateToAddTravelPlace()
    //    {
    //        BL_TP_SFC.sharedInstance.fromPlace = EMPTY
    //        BL_TP_SFC.sharedInstance.toPlace = EMPTY
    //
    //        navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPTravelDetailsVCID)
    //    }
    //
    //    private func navigateToEditTravelPlace()
    //    {
    //        let tbStepperSB = UIStoryboard(name: TourPlannerSB, bundle: nil)
    //        let tpTravel_vc = tbStepperSB.instantiateViewController(withIdentifier: TPTravelListVcId) as! TPTravelDetailListViewController
    //        //tpTravel_vc.isComingFromModify = true
    //        self.navigationController?.pushViewController(tpTravel_vc, animated: true)
    //    }
    //
    //    private func navigateToAddDoctor()
    //    {
    //        if BL_TPStepper.sharedInstance.canUseAccompanistCp(entityName: "DOCTOR")
    //        {
    //            let sb = UIStoryboard(name: commonListSb, bundle: nil)
    //            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
    //            vc.navigationScreenName = TPStepperVCID
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //        else
    //        {
    //            let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
    //            let vc = sb.instantiateViewController(withIdentifier: TPDoctorMasterVCID) as! TPDoctorMasterViewController
    //            vc.regionCode = getRegionCode()
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    //
    //    private func navigateToEditDoctor()
    //    {
    //        navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
    //    }
    //
    private func updategeneralremarks()
        {
            
            if (generalText.count > 0)
            {
                BL_Stepper.sharedInstance.dcrHeaderObj?.DCR_General_Remarks = generalText
                _ = BL_Stepper.sharedInstance.updateDCRGeneralRemarks(remarksTxt: generalText , dcrId : BL_Stepper.sharedInstance.dcrId)
                showToast(message: "Updated remarks succesfully")
            }
            else
            {
                showToast(message: "Please enter remarks")
            }
        }
        

    
    private func navigateToAddDoctorAccompanist()
    {
        let addAccompanist_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let addAccomapanist_vc = addAccompanist_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        addAccomapanist_vc.navigationScreenName = UserListScreenName.DcrAddAccompanistList.rawValue
        addAccomapanist_vc.navigationTitle = "User List"
        self.navigationController?.pushViewController(addAccomapanist_vc, animated: true)
    }
    private func navigateToAddContact() {
        if (isFromDVR)
        {
            navigateToNextScreen(stoaryBoard: detailProductSb, viewController: DoctorAccompanistVcID)
        }
        else
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = TPStepperVCID
            vc.navigationTitle = "User Selection"
            //vc.isFromDVR = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func addflexi()
    {
        //        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: "AddFlexiDoctorVcId") as! AddFlexiDoctor
        //        vc.isfromChemistDay = true
        //        self.navigationController?.pushViewController(vc, animated: true)
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddNewProspectViewController") as! AddNewProspectViewController
        vc.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func navigateToAddUser() {
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "TPFieldStepper"
        accom_vc.navigationTitle = "User Selection"
        accom_vc.isFromDVR = true
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        
        switch index {
        case 0:
            navigateToAddUser()
        case 1:
            if (isProspect)
            {
                addflexi()
            }
            else
            {
                navigateToAddDoctor()
            }
        case 2:
            break
        case 3:
            tableView.reloadData()
            DispatchQueue.main.async {
                self.updategeneralremarks()
            }
            
        case 4:
            break
        default:
            break
        }
        
        
    }
    //
    
    private func navigateToAddDoctor()
    {
        let objDCRInheritanceValidation = BL_DCR_Doctor_Visit.sharedInstance.doDCRInheritanceValidations()
        proceedToAddDoctor()
        
        //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_ERROR)
        //        {
        //            showAccompanistMandatoryAlert()
        //        }
        //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_CONFIRMATION)
        //        {
        //            showAccompanistOptionalAlert()
        //        }
        //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.INTERNET_MANDATORY_ERROR)
        //        {
        //            showInternetMandatoryAlert()
        //        }
        //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.INTERNET_OPTIONAL_ERROR)
        //        {
        //            showInternetOptionalAlert(accUserCodes: objDCRInheritanceValidation.Message)
    }
    //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACC_DATA_NOT_DOWNLOADED_ERROR)
    //        {
    //            let message = Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_DATA_MANDATORY_ERROR_MESSAGE.replacingOccurrences(of: "@ACC_USERS", with: objDCRInheritanceValidation.Message)
    //           // showAccDataNotDownloadAlert(message: message)
    //        }
    //        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.MAKE_API_CALL)
    //        {
    //            showCustomActivityIndicatorView(loadingText: Display_Messages.DCR_Inheritance_Messages.API_CALL_LOADING_MESSAGE)
    //            BL_DCR_Doctor_Visit.sharedInstance.getAccompanistDCRDoctorVisit(viewController: self, accompanistsUsersCodes: objDCRInheritanceValidation.Message, completion: { (objResponse) in
    //                self.dcrInheritanceCallBack(objResponse: objResponse)
    //            })
    //        }
    //}
    
    //    private func dcrInheritanceCallBack(objResponse: ApiResponseModel)
    //    {
    //        if (checkNullAndNilValueForString(stringData: objResponse.Message) != EMPTY)
    //        {
    //            showDCRInheirtanceAlert(message: objResponse.Message, apiResponseStatus: objResponse.Status)
    //        }
    //
    //        BL_Stepper.sharedInstance.generateDataArray()
    //        //self.reloadTableView()
    //
    //        removeCustomActivityView()
    //    }
    
    //    private func showDCRInheirtanceAlert(message: String, apiResponseStatus: Int)
    //    {
    //        let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
    //
    //        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
    //            if (apiResponseStatus != 2)
    //            {
    //                //self.proceedToAddDoctor()
    //                //self.navigateToEditDoctor()
    //            }
    //            alertViewController.dismiss(animated: true, completion: nil)
    //        }))
    //
    //        present(alertViewController, animated: true, completion: nil)
    //    }
    
    private func proceedToAddDoctor()
    {
        let showAccompanistScreen = BL_DCR_Doctor_Visit.sharedInstance.canUseAccompanistsDoctor()
        let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getAccompanistsList()
        
        //let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsListWithoutVandNA()
        
        if showAccompanistScreen == true && (dcrAccompCount?.count)! > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = "TPFieldStepper"
            vc.navigationTitle = "Whose Contacts ?"
            vc.isFromDCR = true
            vc.isFromDVR = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            //            if (!BL_DCR_Doctor_Visit.sharedInstance.canInheritedUserAddDoctors(accUserCode: getUserCode(), isFlexi: false))
            //            {
            //                BL_DCR_Doctor_Visit.sharedInstance.showInhertianceNewDoctorAddErrorMsg()
            //                return
            //            }
            
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            let regionName = loggedUserModel?.Region_Name
            let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
            let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
            vc.regionCode = regionCode
            vc.regionName = regionName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func modifyEntry(index: Int)
    {
        
        switch index {
        case 0:
            break
        case 1:
            navigateToAddContact()
        case 2:
            navigateToAddDoctor()
        case 3:
            break
        case 4:
            break
        // navigateToEditGeneralRemarks()
        default:
            break
        }
        
        
    }
    
    //
    //    private func emptyStateAddNewEntry(index: Int)
    //    {
    //
    //        if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //            switch index
    //            {
    //            case 0:
    //                navigateToAddAccompanist()
    //            case 1:
    //                navigateToAddMeetingPointDetails()
    //            case 2:
    //                navigateToAddWorkPlaceDetails()
    //            case 3:
    //                navigateToAddTravelPlace()
    //            case 4:
    //                navigateToAddDoctor()
    //            case 5:
    //                navigateToAddGeneralRemarks()
    //            default:
    //                print(1)
    //            }
    //        } else {
    //            switch index
    //            {
    //            case 0:
    //                navigateToAddAccompanist()
    //            case 1:
    //                navigateToAddMeetingPointDetails()
    //            case 2:
    //                navigateToAddWorkPlaceDetails()
    //            case 3:
    //                 navigateToAddDoctor()
    //            case 4:
    //               navigateToAddGeneralRemarks()
    //            default:
    //                print(1)
    //            }
    //        }
    //
    //    }
    //
    //    private func skipItem(index: Int)
    //    {
    //        switch index
    //        {
    //            case 0:
    //                BL_TPStepper.sharedInstance.stepperDataList[1].showEmptyStateAddButton = true
    //                BL_TPStepper.sharedInstance.stepperDataList[1].showEmptyStateSkipButton = !BL_TPStepper.sharedInstance.isMeetingPlaceTimeMandatory()
    //                reloadTableViewAtIndexPath(index: 1) // Show work place details's
    //            case 1:
    //                BL_TPStepper.sharedInstance.stepperDataList[2].showEmptyStateAddButton = true
    //                reloadTableViewAtIndexPath(index: 2)
    //            default:
    //                print(1)
    //        }
    //    }
    //
    //
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func navigateToAddAccompanist()
    {
        navigateToNextScreen(stoaryBoard: accompanistDetailsSb, viewController: AddAccompanistVcID)
    }
    
    func showAlertToConfirmAppliedMode(captureLocation: Bool)
    {
        let alertMessage =  "Your Offline DVR is ready to submit in Applied/Approved status. Once submitted you can not edit your DVR.\n\n Press 'Ok' to submit DVR.\n OR \n Press 'Cancel."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            let isAutoSyncEnabled = BL_Stepper.sharedInstance.isAutSyncEnabledForDCR()
            
            BL_Stepper.sharedInstance.submitDCR(captureLocation: captureLocation)
            
            //            if (isAutoSyncEnabled)
            //            {
            //                if (checkInternetConnectivity())
            //                {
            //                    self.navigateToUploadDVR(enabledAutoSync: true)
            //                }
            //                else
            //                {
            //                    self.popViewController(animated: true)
            //                }
            //            }
            //            else
            //            {
            self.showAlertToUploadDVR()
            //            }
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToUploadDVR()
    {
        let alertMessage =  "Your Offline DVR is ready to submit to your manager.\n\n Click 'Upload' to submit DVR.\n Click 'Later' to submit later\n\n Alternatively, you can use 'Upload my DVR' option from the home screen to submit your applied DVR."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "LATER", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "UPLOAD", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeUnVisitedContacts()
            BL_DCRCalendar.sharedInstance.getDCRUploadError(viewController: self, isFromLandingUpload: false, enabledAutoSync: false)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    
    
    //
    //    func popViewController(animated: Bool)
    //    {
    //        _ = self.navigationController?.popViewController(animated: animated)
    //    }
    //
    //    // MARK:- Table View Delegates
    //    func numberOfSections(in tableView: UITableView) -> Int
    //    {
    //        return 1
    //    }
    //
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //    {
    //        return BL_TPStepper.sharedInstance.stepperDataList.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    //    {
    //        let stepperObj = BL_TPStepper.sharedInstance.stepperDataList[indexPath.row]
    //        let index = indexPath.row
    //
    //        if (stepperObj.recordCount == 0)
    //        {
    //            return BL_TPStepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
    //        }
    //        else
    //        {
    //            if (index == 0)
    //            {
    //                return BL_TPStepper.sharedInstance.getAccompanistCellHeight(selectedIndex: index)
    //            }
    //            if  index == 1
    //            {
    //                return BL_TPStepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
    //            }
    //            else if index == 2{
    //                return BL_TPStepper.sharedInstance.getCommonCellHeight(selectedIndex: index) //+ 20
    //            }
    //            else if (index == 3)
    //            {
    //                  if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //                    return BL_TPStepper.sharedInstance.getSFCCellHeight(selectedIndex: index)
    //                  } else {
    //                    return  BL_TPStepper.sharedInstance.getDoctorCellHeight(selectedIndex: index)
    //                }
    //
    //            }
    //            else if (index == 4)
    //            {
    //                 if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //                     return BL_TPStepper.sharedInstance.getDoctorCellHeight(selectedIndex: index)
    //                 } else {
    //                    return BL_TPStepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
    //                }
    //            }
    //            else if (index == 5)
    //            {
    //                if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //                    return BL_TPStepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
    //                } else {
    //                    return 0
    //                }
    //            }
    //            else
    //            {
    //                return 0
    //            }
    //        }
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    //    {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "TPStepperMainCell") as! TPStepperMainTableViewCell
    //        let selectedAcompanist = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
    //        cell.copyTPViewBut.isHidden = true
    //        cell.copyTPViewCopyBut.isHidden = true
    //        cell.copyTpHeightConstraint.constant = 0
    //        cell.copyeditTpHeightConstraint.constant = 0
    //        cell.isFromTp = true
    //        let messageText = "More than one Ride Along has planned joint visit on this day.Do you want to copy his \(PEV_TOUR_PLAN)?"
    //        let getheight = getTextSize(text: messageText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-120).height
    //        let calculateHeihgt = 50 - getheight
    //
    //        if(indexPath.row == 0)
    //        {
    //            if((selectedAcompanist.count != 0) && (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).count > 0))
    //            {
    //                cell.copyTpHeightConstraint.constant = 156 - calculateHeihgt
    //                cell.copylabelheight.constant = getheight
    //                cell.copyeditTpHeightConstraint.constant = 40
    //                cell.copyTPViewBut.isHidden = false
    //                cell.copyTPViewBut.addTarget(self, action: #selector(TPStepperViewController.viewCopyTourPlan(sender:)), for: .touchUpInside)
    //                cell.copyTPViewCopyBut.addTarget(self, action: #selector(TPStepperViewController.CopyTourPlan(sender:)), for: .touchUpInside)
    //
    //                if(selectedAcompanist.count > 1 )
    //                {
    //                    cell.copyTPViewCopyBut.isHidden = true
    //                    cell.copyLabel.text = messageText
    //                }
    //                else
    //                {
    //                    cell.copyTPViewCopyBut.isHidden = false
    //                    cell.copyLabel.text = "\(selectedAcompanist[0].userObj.User_Name!) has planned joint visit on this day. Do you want to copy his \(PEV_TOUR_PLAN)"
    //                }
    //            }
    //        }
    //
    //        // Round View
    //        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
    //        cell.roundView.layer.masksToBounds = true
    //        cell.stepperNumberLabel.text = String(indexPath.row + 1)
    //
    //        // Vertical view
    //        cell.verticalView.isHidden = false
    //        if (indexPath.row == BL_TPStepper.sharedInstance.stepperDataList.count - 1)
    //        {
    //            cell.verticalView.isHidden = true
    //        }
    //
    //        let rowIndex = indexPath.row
    //        let objStepperModel: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[rowIndex]
    //
    //        cell.selectedIndex = rowIndex
    //        cell.delegate = self
    //        cell.cardView.isHidden = true
    //        cell.emptyStateView.isHidden = true
    //        cell.emptyStateView.clipsToBounds = true
    //
    //        if (objStepperModel.recordCount == 0)
    //        {
    //            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
    //            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
    //
    //            cell.doctorSectionTitleLabel.text = objStepperModel.doctorEmptyStateTitle
    //            cell.doctorSectionSubTitleLabel.text = objStepperModel.doctorEmptyStatePendingCount
    //
    //            cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
    //            cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
    //
    //            cell.emptyStateView.isHidden = false
    //            cell.cardView.isHidden = true
    //            cell.cardView.clipsToBounds = true
    //
    //            cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
    //        }
    //        else
    //        {
    //            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
    //
    //            cell.emptyStateView.isHidden = true
    //            cell.cardView.isHidden = false
    //            cell.cardView.clipsToBounds = false
    //
    //            cell.rightButton.isHidden = !objStepperModel.showRightButton
    //            cell.leftButton.isHidden = !objStepperModel.showLeftButton
    //
    //            cell.childTableView.reloadData()
    //
    //            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
    //            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
    //        }
    //
    //        cell.doctorSectionTitleView.isHidden = true
    //        cell.sectionTitleView.isHidden = true
    //        cell.doctorSectionTitleView.clipsToBounds = true
    //
    //        if (objStepperModel.recordCount > 0)
    //        {
    //
    //             if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //                if (rowIndex != 4)
    //                {
    //                    cell.sectionTitleView.isHidden = false
    //                    cell.doctorSectionTitleView.clipsToBounds = true
    //                    cell.doctorTitleTopConstraint.constant = 4
    //                    cell.commonSectionTitleHeightConstraint.constant = 30
    //                }
    //                else
    //                {
    //                    cell.doctorSectionTitleView.isHidden = true
    //                    cell.doctorSectionTitleView.clipsToBounds = false
    //                    cell.doctorTitleTopConstraint.constant = 41
    //                    cell.doctorSectionTitleLabel.text = objStepperModel.doctorEmptyStateTitle
    //                    cell.doctorSectionSubTitleLabel.text = objStepperModel.doctorEmptyStatePendingCount
    //                    cell.commonSectionTitleHeightConstraint.constant = 0
    //                }
    //
    //             } else {
    //                if (rowIndex != 3)
    //                {
    //                    cell.sectionTitleView.isHidden = false
    //                    cell.doctorSectionTitleView.clipsToBounds = true
    //                    cell.doctorTitleTopConstraint.constant = 4
    //                    cell.commonSectionTitleHeightConstraint.constant = 30
    //                }
    //                else
    //                {
    //                    cell.doctorSectionTitleView.isHidden = true
    //                    cell.doctorSectionTitleView.clipsToBounds = false
    //                    cell.doctorTitleTopConstraint.constant = 41
    //                    cell.doctorSectionTitleLabel.text = objStepperModel.doctorEmptyStateTitle
    //                    cell.doctorSectionSubTitleLabel.text = objStepperModel.doctorEmptyStatePendingCount
    //                    cell.commonSectionTitleHeightConstraint.constant = 0
    //                }
    //            }
    //        }
    //
    //        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
    //        cell.sectionToggleImageView.isHidden = true
    //        cell.sectionToggleImageView.clipsToBounds = true
    //
    //        if (objStepperModel.isExpanded == true)
    //        {
    //            cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
    //        }
    //        else
    //        {
    //            cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
    //        }
    //
    //        cell.sectionToggleImageView.isHidden = false
    //        cell.sectionToggleImageView.clipsToBounds = false
    //
    //        cell.moreView.isHidden = true
    //        cell.moreView.clipsToBounds = true
    //        cell.moreViewHeightConstraint.constant = 0
    //        cell.buttonViewHeight.constant = 60
    //
    //        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > 1)
    //        {
    //            cell.moreView.isHidden = false
    //            cell.moreView.clipsToBounds = false
    //            cell.moreViewHeightConstraint.constant = 20
    //        }
    //        else
    //        {
    //            cell.buttonViewHeight.constant = 40
    //        }
    //
    //        cell.sectionCoverButton.tag = rowIndex
    //        cell.leftButton.tag = rowIndex
    //        cell.rightButton.tag = rowIndex
    //        cell.emptyStateAddButton.tag = rowIndex
    //        cell.emptyStateSkipButton.tag = rowIndex
    //
    //        if objStepperModel.recordCount > 0
    //        {
    //              if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //                if indexPath.row == 4
    //                {
    //                    cell.sectionCoverBtnView.isHidden = true
    //                }
    //                else
    //                {
    //                    cell.sectionCoverBtnView.isHidden = false
    //                }
    //              } else {
    //                if indexPath.row == 3
    //                {
    //                    cell.sectionCoverBtnView.isHidden = true
    //                }
    //                else
    //                {
    //                    cell.sectionCoverBtnView.isHidden = false
    //                }
    //            }
    //        }
    //        else
    //        {
    //            cell.sectionCoverBtnView.isHidden = false
    //        }
    //
    //        if objStepperModel.recordCount == 1
    //        {
    //            cell.sectionToggleImageView.isHidden = true
    //            cell.sectionCoverBtnView.isHidden = true
    //        }
    //        return cell
    //    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //    {
    //        print("index",indexPath.row)
    //    }
    //
    //    func didTapAddSampleBtn(sender: UIButton)
    //    {
    //        let tpSampleList = BL_TPStepper.sharedInstance.doctorList[sender.tag].sampleList1
    //
    //        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: TPSampleListVCID) as! TPSampleListViewController
    //
    //        vc.userDCRProductList = tpSampleList
    //
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //
    //    func removeDoctorButtonAction(sender: UIButton)
    //    {
    //        let alertViewController = UIAlertController(title: alertTitle, message: "Do you want to delete \(appDoctor) ?", preferredStyle: UIAlertControllerStyle.alert)
    //        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
    //            alertViewController.dismiss(animated: true, completion: nil)
    //        }))
    //        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
    //            let tpDoctorId = BL_TPStepper.sharedInstance.doctorList[sender.tag].tpDoctorId
    //
    //            BL_TPStepper.sharedInstance.deleteDoctorFromTP(tp_Doctor_Id: tpDoctorId!)
    //            BL_TPStepper.sharedInstance.generateDataArray()
    //            self.reloadTableView()
    //            alertViewController.dismiss(animated: true, completion: nil)
    //        }))
    //        self.present(alertViewController, animated: true, completion: nil)
    //
    //    }
    //
    //    func didSelectExpandableCell()
    //    {
    //        self.tableView.reloadData()
    //    }
    //
    //    // MARK:- Button Actions
    //    @IBAction func sectionExpanCoverButtonAction(sender: UIButton)
    //    {
    //        let index = sender.tag
    //        let stepperObj = BL_TPStepper.sharedInstance.stepperDataList[index]
    //
    //        if (stepperObj.recordCount > 1 && index != 4)
    //        {
    //            stepperObj.isExpanded = !stepperObj.isExpanded
    //            reloadTableViewAtIndexPath(index: index)
    //        }
    //    }
    //
    private func PunchInmoveToDCRDoctorVisitStepper(indexPath: IndexPath, geoFencingSkipRemarks: String, currentLocation: GeoLocationModel)
    {
        
        var localTimeZoneName: String { return TimeZone.current.identifier }
        //vc.customerMasterModel = BL_Stepper.sharedInstance.doctorList[indexPath.row]
        
        let punch_start = getStringFromDateforPunch(date: getCurrentDateAndTime())
        let punch_status = 1
        let punch_UTC = getUTCDateForPunch()
        let punch_timezone = localTimeZoneName
        let punch_timeoffset = getOffset()
        let dcrid = BL_Stepper.sharedInstance.dcrId
        //            DCRModel.sharedInstance.customerId = currentList[indexPath.row].Customer_Id
        DCRModel.sharedInstance.doctorVisitId = 0
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        let doctorlist = DBHelper.sharedInstance.getDCRDoctorVisitid(dcrId: DCRModel.sharedInstance.dcrId, doctorcode: BL_Stepper.sharedInstance.doctorList[indexPath.row].Doctor_Code!)
        let visitid = doctorlist[0].DCR_Doctor_Visit_Id
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Punch_Start_Time = '\(punch_start)', Punch_Status = 1 , Punch_Offset = '\(punch_timeoffset)', Punch_TimeZone = '\(punch_timezone)',Punch_UTC_DateTime = '\(punch_UTC)' WHERE DCR_Id = \(dcrid!) AND DCR_Doctor_Visit_Id = \(visitid!)")
        
    }
    func checkPunchin(indexPath: IndexPath) -> Bool
    {
        let doctorlist = DBHelper.sharedInstance.getDCRDoctorVisitid(dcrId: DCRModel.sharedInstance.dcrId, doctorcode: BL_Stepper.sharedInstance.doctorList[indexPath.row].Doctor_Code!)
        if (doctorlist[0].Punch_Start_Time != nil && doctorlist[0].Punch_Start_Time?.count ?? 0 > 0 )
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    @IBAction func leftButtonAction(sender: UIButton)
    {
        addNewEntry(index: sender.tag)
    }
    //
    @IBAction func rightButtonAction(sender: UIButton)
    {
        modifyEntry(index: sender.tag)
    }
    //
    //    @IBAction func emptyStateAddButtonAction(sender: UIButton)
    //    {
    //        emptyStateAddNewEntry(index: sender.tag)
    //    }
    //
    //    @IBAction func emptyStateSkipButtonAction(sender: UIButton)
    //    {
    //        skipItem(index: sender.tag)
    //    }
    //
    @IBAction func submitButtonAction()
    {
        if BL_Stepper.sharedInstance.doctorList.count == 0
        {
            if isProspect{
                AlertView.showAlertView(title: alertTitle, message: "Atleast one Prospect is needed for the DVR", viewController: self)
            } else {
                AlertView.showAlertView(title: alertTitle, message: "Add atleast one Contact", viewController: self)
            }
            
        } else if isWorkTimeNeeded() == false {
            AlertView.showAlertView(title: alertTitle, message: "Please visit atleast one contact before submiting your DVR", viewController: self)
        } else if selectedWorkPlace.count == 0 {
            AlertView.showAlertView(title: alertTitle, message: "Please select Work Category", viewController: self)
        }
        else
        {
            showAlertToConfirmAppliedMode(captureLocation: false)
        }
    }
    
    func isWorkTimeNeeded() -> Bool{
        if BL_Stepper.sharedInstance.doctorList.count != 0
        {
            let filterArr = BL_Stepper.sharedInstance.doctorList.filter({$0.Visit_Mode == "" && $0.Visit_Time == ""})
            if filterArr.count != 0  && filterArr.count == BL_Stepper.sharedInstance.doctorList.count {
                return false
            }
        }
        return true
    }
    
    func removeUnVisitedContacts() {
        if BL_Stepper.sharedInstance.doctorList.count != 0
        {
            let filterArr = BL_Stepper.sharedInstance.doctorList.filter({$0.Visit_Mode == "" && $0.Visit_Time == ""})
            if filterArr.count != 0 {
                for model in filterArr {
                    BL_DCR_Doctor_Visit.sharedInstance.deleteDCRDoctorVisit(dcrDoctorVisitId: model.DCR_Doctor_Visit_Id, customerCode: checkNullAndNilValueForString(stringData: model.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: model.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString), doctorName: model.Doctor_Name)
                }
            }
        }
    }
    
    
    //
    //    func getselectedAccompanist(selectedAccompanist: [DCRAccompanistModel], type: Int)
    //    {
    //        if type == 1
    //        {
    //            updateAccompanistDownloadLater(selectedAccompanistList: selectedAccompanist)
    //        }
    //        else
    //        {
    //            downloadAccompanistData(selectedAccompanistList: selectedAccompanist)
    //        }
    //    }
    //
    //    private func insertDoctorDetails()
    //    {
    //        //BL_DCR_Doctor_Visit.sharedInstance.insertAssetDetailedDoctorInVisit(dcrDate: DCRModel.sharedInstance.dcrDate)
    //    }
    //
    //    func navigateToAccompanistVC()
    //    {
    //        let accList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId) as [UserMasterWrapperModel]
    //
    //        if accList.count == 1
    //        {
    //            let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
    //            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPCopyTourPlanVCID) as! TPCopyTourPlannerViewController
    //            vc.accDataArray = accList[0].userObj
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //        else
    //        {
    //            let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
    //            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPCopyTourPlanAccompanistListVCID) as! AccompanistListViewController
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    //
    //    func copyAccompanistDetails()
    //    {
    //        if checkInternetConnectivity()
    //        {
    //            let accArray = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId) as [UserMasterWrapperModel]
    //            let accObj = accArray[0].userObj
    //
    //            showActivityIndicator()
    //            //BL_TP_CopyTpStepper.sharedInstance.clearArray()
    //            BL_TP_CopyTpStepper.sharedInstance.postCopyTourPlanAccompanistDetails(user_code: accObj.User_Code , start_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate), end_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate), region_Code: accObj.Region_Code) { (StatusMsg,Status,list) in
    //
    //                removeCustomActivityView()
    //
    //                if Status == SERVER_SUCCESS_CODE
    //                {
    //                    //let headerArray = BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc
    //                    if BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc.count > 0
    //                    {
    //                        if BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].copyAccess == 1
    //                        {
    //                            BL_TP_CopyTpStepper.sharedInstance.updateAccHeaderDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, cp_Code: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].cp_Code, category_Code: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].category_Code, work_Place: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].work_Area, cp_Name: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].cp_Name, meeting_Place: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].meeting_Place!, meeting_Time: checkNullAndNilValueForString(stringData: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].meeting_Time), category_Name: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].work_Category_Name, remarks: checkNullAndNilValueForString(stringData: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].remarks))
    //
    //                            BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistSFC(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
    //                            BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistDoctor(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
    //                            BL_TP_CopyTpStepper.sharedInstance.insertAccompanistDetails()
    //                            BL_TPStepper.sharedInstance.generateDataArray()
    //                            self.reloadTableView()
    //
    //                            showToastView(toastText: "Copied Ride Along \(PEV_TOUR_PLAN)")
    //                        }
    //                        else
    //                        {
    //                            showToastView(toastText: "This feature is not applicable for this Ride Along")
    //                        }
    //                    }
    //                    else
    //                    {
    //                        showToastView(toastText: "No PR(s) found")
    //                    }
    //                }
    //                else
    //                {
    //                    showToastView(toastText: StatusMsg)
    //                }
    //            }
    //        }
    //        else
    //        {
    //            AlertView.showNoInternetAlert()
    //        }
    //    }
    //
    //    func showActivityIndicator()
    //    {
    //        showCustomActivityIndicatorView(loadingText: "Loading Ride Along data..")
    //    }
    //
    //    func toggleSubmitButton()
    //    {
    //         if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //            if (checkNullAndNilValueForString(stringData: BL_TPStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && BL_TPStepper.sharedInstance.placesList.count > 0)
    //            {
    //                showsubmitButton()
    //            }
    //            else
    //            {
    //                hidesubmitButton()
    //            }
    //         } else {
    //            if (checkNullAndNilValueForString(stringData: BL_TPStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY)
    //            {
    //                showsubmitButton()
    //            }
    //            else
    //            {
    //                hidesubmitButton()
    //            }
    //        }
    //    }
    //
    //    @objc func viewCopyTourPlan(sender: UIButton)
    //    {
    //        navigateToAccompanistVC()
    //    }
    //
    //    @objc func CopyTourPlan(sender: UIButton)
    //    {
    //        copyAccompanistDetails()
    //    }
    //
    //    private func removeMeetingPlaceDetails()
    //    {
    //        BL_TPStepper.sharedInstance.updateMeetingPointAndTime(Date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag, meeting_place: EMPTY, meeting_Time: EMPTY)
    //
    //        BL_TPStepper.sharedInstance.generateDataArray()
    //        reloadTableView()
    //    }
    
    func isCurrentDate() -> Bool
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
    func functionName (notification: NSNotification) {
        doctorvisitmodify.modifyBtnAction(position: 0)
    }
    func modifydoctor(position: Int)
        
    {
        let doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
        let model = doctorVisitList[position]
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
        //        DCRModel.sharedInstance.customerId = model.Doctor_Id
        DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
        DCRModel.sharedInstance.customerRegionCode = model.Doctor_Region_Code
        DCRModel.sharedInstance.doctorVisitId = model.DCR_Doctor_Visit_Id
        DCRModel.sharedInstance.customerVisitId = model.DCR_Doctor_Visit_Id
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        if DCRModel.sharedInstance.customerCode != ""
        {
            let custObj = BL_DCR_Doctor_Visit.sharedInstance.getLocalArea(customerCode: model.Doctor_Code!, regionCode: model.Doctor_Region_Code!)
            let local_Area = checkNullAndNilValueForString(stringData: custObj?.Local_Area)
            let dict : NSMutableDictionary = [:]
            
            dict.setValue(model.Doctor_Code, forKey: "Customer_Code")
            dict.setValue(model.Doctor_Name, forKey: "Customer_Name")
            dict.setValue(model.Doctor_Region_Name, forKey: "Region_Name")
            dict.setValue(model.Speciality_Name, forKey: "Speciality_Name")
            dict.setValue(model.Category_Name, forKey: "Category_Name")
            dict.setValue(model.MDL_Number, forKey: "MDL_Number")
            dict.setValue(model.Hospital_Name, forKey: "Hospital_Name")
            dict.setValue(local_Area, forKey: "Local_Area")
            dict.setValue(model.Sur_Name, forKey: "Sur_Name")
            dict.setValue(model.Category_Code, forKey: "Category_Code")
            
            let customerModel = CustomerMasterModel.init(dict: dict)
            vc.customerMasterModel = customerModel
            
            BL_DoctorList.sharedInstance.regionCode = checkNullAndNilValueForString(stringData: model.Doctor_Region_Code)
            BL_DoctorList.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
        }
        else
        {
            vc.flexiDoctorName = model.Doctor_Name
            vc.flexiSpecialityName = model.Speciality_Name
            
            BL_DoctorList.sharedInstance.regionCode = EMPTY
            BL_DoctorList.sharedInstance.customerCode = EMPTY
        }
        
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func remove_Accompanist(_ sender: UIButton) {
        
        let acc_Name = BL_Stepper.sharedInstance.accompanistList[sender.tag].Acc_User_Name
        let alertController = UIAlertController(title: "\(acc_Name!)", message: "Will be removed from ride along", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let acc_Code = BL_Stepper.sharedInstance.accompanistList[sender.tag].Acc_User_Code
            if acc_Code != nil {
                BL_DCR_Accompanist.sharedInstance.removeDCRAccompanist(accompanistRegionCode: BL_Stepper.sharedInstance.accompanistList[sender.tag].Acc_Region_Code, accompanistUserCode: acc_Code!)
                DBHelper.sharedInstance.funcupdateaccompanistremoved(dcrId: BL_Stepper.sharedInstance.dcrId, accompanistCode: acc_Code!)
                BL_Stepper.sharedInstance.generateDataArray()
                self.reloadTableView()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func removeContacts(_ sender: UIButton) {
        
        let model = BL_Stepper.sharedInstance.doctorList[sender.tag]
        let doc_Name = BL_Stepper.sharedInstance.doctorList[sender.tag].Doctor_Name
        let alertController = UIAlertController(title: "\(doc_Name!)", message: "Will be removed from this plan", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let dcrid = BL_Stepper.sharedInstance.doctorList[sender.tag].DCR_Id
            BL_DCR_Doctor_Visit.sharedInstance.deleteDCRDoctorVisit(dcrDoctorVisitId: model.DCR_Doctor_Visit_Id, customerCode: checkNullAndNilValueForString(stringData: model.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: model.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString), doctorName: model.Doctor_Name)
            
            showToastView(toastText: "Contact deleted successfully")
            BL_Stepper.sharedInstance.generateDataArray()
            self.reloadTableView()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
}

extension DCRStepperNewViewController : UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    //------> Display Cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.section == 1
        {
            let MeetingObjCell = tableView.dequeueReusableCell(withIdentifier: TPField_MeetingObjectiveCell) as! TPFieldMeetingObjectiveCell
            let doctorObj = BL_Stepper.sharedInstance.doctorList[indexPath.row]
            MeetingObjCell.txtContactName.text = doctorObj.Doctor_Name
            
            if doctorObj.Visit_Mode.count != 0 || doctorObj.Visit_Time?.count != 0 {
                MeetingObjCell.txtContactName.textColor = self.visitedContactColor
            } else {
                MeetingObjCell.txtContactName.textColor = UIColor.black
            }
            
            var line2Text: String = ""
            
            if doctorObj.Hospital_Name! != ""{
                line2Text = doctorObj.Hospital_Name! + " | "
            } else {
                line2Text = doctorObj.Hospital_Name!
            }
            
//            if doctorObj.Speciality_Name! != ""{
//                line2Text = (doctorObj.Speciality_Name)! + " | "
//            }
//            
//            if (checkNullAndNilValueForString(stringData: doctorObj.Category_Name) != "")
//            {
//                line2Text = doctorObj.Category_Name! + " | "
//            }
            
            if (checkNullAndNilValueForString(stringData: doctorObj.Doctor_Region_Name) != "")
            {
                if (line2Text != "")
                {
                    line2Text = line2Text + doctorObj.Doctor_Region_Name!
                }
                else
                {
                    line2Text = doctorObj.Doctor_Region_Name!
                }
            }
            MeetingObjCell.txtContactDetails.text = line2Text
            MeetingObjCell.btnRemoveDoctor.tag = indexPath.row
            return MeetingObjCell
        }
        else if indexPath.section == 0
        {
            let RideAlongCell = tableView.dequeueReusableCell(withIdentifier: TPField_RideAlongcell) as! TPFieldRideAlongCell
            RideAlongCell.lblAccompanist.text = BL_Stepper.sharedInstance.accompanistList[indexPath.row].Acc_User_Name
            RideAlongCell.btnRemoveRideAlong.tag = indexPath.row
            return RideAlongCell
        }
        else if indexPath.section == 2
        {
            let WorkCaregoryCell = tableView.dequeueReusableCell(withIdentifier: TPField_WorkCategoryCell) as! TPFieldWorkCategoryCell
            if selectedWorkPlace.count == 0 {
              //  WorkCaregoryCell.txtWorkCategory.text = self.workCategory[0].Category_Name
            } else {
                WorkCaregoryCell.txtWorkCategory.text = self.selectedWorkPlace
            }
            WorkCaregoryCell.txtWorkCategory.inputView = self.pickerview
            return WorkCaregoryCell
        }
        else if indexPath.section == 3
        {
            let remarksCell = tableView.dequeueReusableCell(withIdentifier: TPRemarkCell) as! TPFieldRemarksCell
            
            if (BL_Stepper.sharedInstance.dcrHeaderObj?.DCR_General_Remarks != nil )
            {
                
                remarksCell.txtViewRemarks.text = BL_Stepper.sharedInstance.dcrHeaderObj?.DCR_General_Remarks
            }
            remarksCell.consTextViewHeight.constant = remarksCell.txtViewRemarks.contentSize.height + 40
            remarksCell.txtViewRemarks.delegate = self
            //remarksCell.consTextViewHeight.constant = remarksCell.txtViewRemarks.contentSize.height + 20
            self.generalText = remarksCell.txtViewRemarks.text
            return remarksCell
        }
        else
        {
            return UITableViewCell.init()
        }
        
        
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        generalText = textField.text ?? ""
    }
    //------> Total number of sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return BL_Stepper.sharedInstance.stepperDataList.count
        
    }
    
    //------> Total number of rows in each section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return BL_Stepper.sharedInstance.accompanistList.count
        } else if section == 1 {
            return BL_Stepper.sharedInstance.doctorList.count
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 0
        } else {
            return 0
        }
    }
    
    //------> To display header view.
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: TPFieldHeaderCell) as! TPFieldStepperHeaderCell
        headerCell.lblSectionTitle.text = BL_Stepper.sharedInstance.stepperDataList[section].sectionTitle
        if section == 1 {
            let subTitle = NSMutableAttributedString()
            let hdr = NSMutableAttributedString(string: BL_Stepper.sharedInstance.stepperDataList[section].emptyStateSubTitle)
            let count = NSMutableAttributedString(string: "  \(BL_Stepper.sharedInstance.doctorList.count)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0)])
            subTitle.append(hdr)
            subTitle.append(count)
            headerCell.lblectionSubTitle.attributedText = subTitle
        } else {
            headerCell.lblectionSubTitle.text = BL_Stepper.sharedInstance.stepperDataList[section].emptyStateSubTitle
        }
        switch section {
        case 1:
            if BL_Stepper.sharedInstance.doctorList.count != 0 {
                headerCell.lblSectionCount.backgroundColor = default_Blue
            } else {
                headerCell.lblSectionCount.backgroundColor = UIColor.lightGray
            }
        case 2:
            if BL_Stepper.sharedInstance.doctorList.count != 0 {
                headerCell.lblSectionCount.backgroundColor = default_Blue
            } else {
                headerCell.lblSectionCount.backgroundColor = UIColor.lightGray
            }
        case 0:
            if BL_Stepper.sharedInstance.accompanistList.count != 0 {
                headerCell.lblSectionCount.backgroundColor = default_Blue
            } else {
                headerCell.lblSectionCount.backgroundColor = UIColor.lightGray
            }
        case 3:
            if self.selectedWorkPlace.count != 0 {
                headerCell.lblSectionCount.backgroundColor = default_Blue
            } else {
                headerCell.lblSectionCount.backgroundColor = UIColor.lightGray
            }
        case 4:
            break
        default:
            break
        }
        headerCell.lblSectionCount.text = "\(section + 1)"
        return headerCell
        
    }
    
    //------> To display footer view.
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: TPFieldFooterCell) as! TPFieldStepperFooterCell
        if isProspect{
            if  section == 1 {
                footerCell.leftButton.setTitle("Add Prospect", for: .normal)
            } else {
                footerCell.leftButton.setTitle(BL_Stepper.sharedInstance.stepperDataList[section].leftButtonTitle, for: .normal)
            }
        } else {
            footerCell.leftButton.setTitle(BL_Stepper.sharedInstance.stepperDataList[section].leftButtonTitle, for: .normal)
        }
        
        footerCell.leftButton.tag = section
        footerCell.rightButton.tag = section
        if section == 4 {
            footerCell.rightButton.isHidden = false
        } else {
            footerCell.rightButton.isHidden = true
        }
        return footerCell
        
    }
    
    //------> Set height for each row.
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            return 40
        } else if indexPath.section == 2 {
            return 40
        } else if indexPath.section == 1 {
            return 70
        } else if indexPath.section == 3 {
            return 80
        } else if indexPath.section == 4 {
            if generalText.count != 0 {
                return 60
            } else {
                return 0
            }
        } else {
            return 0
        }
        
        
    }
    
    //------> Set height for each footer.
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 60
        } else if section == 2 {
            return 0
        } else if section == 1 {
            return 60
        } else if section == 3 {
            return 60
        } else if section == 4 {
            return 0
        } else {
            return 0
        }
        
        
    }
    
    //------> Set height for each header.
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 90
        } else if section == 2 {
            return 50
        } else if section == 1 {
            return 90
        } else if section == 3 {
            return 40
        } else if section == 4 {
            return 50
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            let doctorObj = BL_Stepper.sharedInstance.doctorList[indexPath.row]
            if (isCurrentDate() && checkPunchin(indexPath: indexPath))
            {
                
                let currentLocation = getCurrentLocaiton()
                let initialAlert = "Check-in time for " + doctorObj.Doctor_Name + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + doctorObj.Doctor_Name
                //let indexpath = sender.tag
                let alertViewController = UIAlertController(title: "Check In", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "Check In", style: UIAlertActionStyle.default, handler: { alertAction in
                    //function
                    self.PunchInmoveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: EMPTY, currentLocation: currentLocation)
                    self.modifydoctor(position: indexPath.row)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
                
            }
            else
            {
                modifydoctor(position: indexPath.row)
            }
            
        }
        
    }
}


extension DCRStepperNewViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workCategory[row].Category_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWorkPlace = self.workCategory[row].Category_Name
        selectedWorkCategoryID = self.workCategory[row].Category_Id
        let dcrheaderobj = DCRHeaderObjectModel()
        dcrheaderobj.DCR_Id = BL_Stepper.sharedInstance.dcrId
        if (row == 1)
        {
            dcrheaderobj.Category_Id = selectedWorkCategoryID
            dcrheaderobj.Category_Name = selectedWorkPlace
        }
        else
        {
            dcrheaderobj.Category_Id = selectedWorkCategoryID
            dcrheaderobj.Category_Name = selectedWorkPlace
        }
        DBHelper.sharedInstance.updateDCRWorkCategory(dcrHeaderObj: dcrheaderobj)
        self.tableView.reloadData()
        
        self.view.endEditing(true)
    }
    
    
}
extension DCRStepperNewViewController : UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let str = "\(textView.text!)"
        BL_Stepper.sharedInstance.dcrHeaderObj?.DCR_General_Remarks = str
        generalText = str
        return true
    }
}

