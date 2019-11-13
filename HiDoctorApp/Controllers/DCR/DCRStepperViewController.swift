//
//  DCRStepperViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRStepperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SelectedAccompanistPopUpDelegate
{
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitDCRButton: UIButton!
    @IBOutlet weak var submitDCRBorderView: UIView!
    @IBOutlet weak var submitDCRButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitDCRBorderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tpFreeViewHgtConstnt: NSLayoutConstraint!
    var previousScrollPosition: CGPoint!
    
    // MARK:- Variables
    var stepperDataList: [DCRStepperModel] = []
    var showAlertCaptureLocationCount : Int = 0
    
    // MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        removeVersionToastView()
        super.viewDidLoad()
        self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + " (Field)"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //setStatusBarColor(color: brandColor)
        
        //        showNavigationBar()
        
        BL_Stepper.sharedInstance.generateDataArray()
        toggleTPFreezeView()
        reloadTableView()
        showAlertCaptureLocationCount = 0
        
        // showPendingAccompanistDataDownloadAlert()
        
        if (BL_Stepper.sharedInstance.isSFCUpdated)
        {
            BL_Stepper.sharedInstance.isSFCUpdated = false
            showToastView(toastText: "Your SFC updated")
        }
        showResignedAccompanistAlert()
        checkaccompanist()
        // insertDoctorDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //        showNavigationBar()
    }
    
    // MARK:- Private Functions
    @objc func checkaccompanist()
    {
        let list = BL_Stepper.sharedInstance.getDCRAccompanistDetails()
        if list != nil
        {
            if list!.count > 0 && list!.count > 4
            {
                let alertViewController = UIAlertController(title: "Alert", message: "You entered ride along is exceed the limit. Pevonia CRM dose not allow more than 4 ride along per day.", preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Modify Ride Along", style: UIAlertActionStyle.default, handler: { alertAction in
                    self.navigateToEditAccompanist()
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                self.present(alertViewController, animated: true, completion: nil)
                
            }
        }
    }
    private func showResignedAccompanistAlert()
    {
        //        if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count > 0 && BL_DCRCalendar.sharedInstance.resignedAccompanists.count > 0)
        //        {
        //            showResignedAccompanistAlert(buttonAction: true)
        //        }
        //        else if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count == 0 && BL_DCRCalendar.sharedInstance.resignedAccompanists.count > 0)
        //        {
        //            showResignedAccompanistAlert(buttonAction: false)
        //        }
        //        else if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count > 0 && BL_DCRCalendar.sharedInstance.resignedAccompanists.count == 0)
        //        {
        //            showPendingAccompanistDataDownloadAlert()
        //        }
        
        if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count > 0 && BL_DCRCalendar.sharedInstance.tpPreFillAlert.count > 0)
        {
            showResignedAccompanistAlert(buttonAction: true)
        }
        else if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count == 0 && BL_DCRCalendar.sharedInstance.tpPreFillAlert.count > 0)
        {
            showPreFillAlert(buttonAction: false)
        }
        else if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count > 0 && BL_DCRCalendar.sharedInstance.resignedAccompanists.count == 0)
        {
            showPendingAccompanistDataDownloadAlert()
        }
        else if BL_DCRCalendar.sharedInstance.tpPreFillAlert.count > 0
        {
            showPreFillAlert(buttonAction: false)
        }
    }
    
    private func showResignedAccompanistAlert(buttonAction: Bool)
    {
        var message = EMPTY
        if(BL_DCRCalendar.sharedInstance.resignedAccompanists.count == 0)
        {
            showPreFillAlert(buttonAction: true)
        }
        else
        {
            for str in BL_DCRCalendar.sharedInstance.resignedAccompanists
            {
                message += str + "\n"
            }
        }
        
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if (buttonAction)
            {
                self.showPendingAccompanistDataDownloadAlert()
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        BL_DCRCalendar.sharedInstance.resignedAccompanists = []
    }
    
    private func showPreFillAlert(buttonAction: Bool)
    {
        var message = EMPTY
        let followMsg = "Following reasons have been identified during auto populate of Approved PR details in DVR."
        let review = "kindly review the same."
        BL_DCRCalendar.sharedInstance.tpPreFillAlert.insert(followMsg, at: 0)
        BL_DCRCalendar.sharedInstance.tpPreFillAlert.append(review)
        for (index,str) in BL_DCRCalendar.sharedInstance.tpPreFillAlert.enumerated()
        {
            if(index == 0)
            {
                message += str + "\n"
            }
            else if(index+1 == BL_DCRCalendar.sharedInstance.tpPreFillAlert.count)
            {
                message += "\n" + str
            }
            else
            {
                message += "\(index).)" + str + "\n"
            }
        }
        
        
        let alertController = UIAlertController(title: alertTitle , message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            if (buttonAction)
            {
                self.showPendingAccompanistDataDownloadAlert()
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        BL_DCRCalendar.sharedInstance.tpPreFillAlert = []
    }
    
    private func showPendingAccompanistDataDownloadAlert()
    {
        if (checkInternetConnectivity())
        {
            if (BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData())
            {
                let pendingList = BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList()
                
                if (pendingList.count > 0)
                {
                    let popUp_sb = UIStoryboard(name:dcrStepperSb, bundle: nil)
                    let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AccompanistPopUpVcID) as! AccompanistPopUpViewController
                    popUp_Vc.dcrAccompanistList = pendingList
                    popUp_Vc.delegate = self
                    popUp_Vc.providesPresentationContextTransitionStyle = true
                    popUp_Vc.definesPresentationContext = true
                    popUp_Vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                    self.present(popUp_Vc, animated: false, completion: nil)
                }
            }
        }
        self.checkaccompanist()
    }
    
    private func downloadAccompanistData(selectedAccompanistList: [DCRAccompanistModel])
    {
        showLoader()
        
        BL_Stepper.sharedInstance.downloadAccompanistData(selectedAccompanistList: selectedAccompanistList,viewController:self) { (status) in
            
            
            if (status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: "Download Accompanist from DCR"), completion: { (apiObj) in
                    self.hideLoader()
                    self.showToast(message: "\(PEV_ACCOMPANIST) data downloaded successfully")
                    
                    BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                    self.tableView.reloadData()
                })
            }
            else
            {
                self.showToast(message: "Error while downloading ride along data. Please try again later")
            }
        }
        self.checkaccompanist()
    }
    
    private func getPostData(sectionName: String) -> [String: Any]
    {
        let postData :[String:Any] = ["Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Section_Name":sectionName,"Download_Date":getCurrentDateAndTimeString(),"Downloaded_Acc_Region_Codes":BL_PrepareMyDeviceAccompanist.sharedInstance.getRegionCodeStringWithOutQuotes()]
        
        return postData
    }
    
    private func showAlert(message: String)
    {
        let delayTime = DispatchTime.now() + 0.1
        
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            AlertView.showAlertView(title: alertTitle, message: message)
        }
    }
    
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
    
    private func updateAccompanistDownloadLater(selectedAccompanistList: [DCRAccompanistModel])
    {
        BL_Stepper.sharedInstance.updateAccompanistDataDownloadAsLater(selectedAccompanistList: selectedAccompanistList)
        checkaccompanist()
    }
    
    private func toggleTPFreezeView()
    {
        if (BL_Stepper.sharedInstance.isTPFreeseDay)
        {
            showTPFreezeView()
        }
        else
        {
            hideTPFreezeView()
        }
    }
    
    private func showTPFreezeView()
    {
        let text = "The approved PR details(i.e. Ride Along Name, Work Category, Work Place and SFC Details) are not allowed to be changed. To change any of these details, we request you to contact your HO."
        let textSize = getTextSize(text: text, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 16).height
        let totalHeight: CGFloat = 28 + textSize
        
        self.tpFreeViewHgtConstnt.constant = totalHeight
    }
    
    private func hideTPFreezeView()
    {
        self.tpFreeViewHgtConstnt.constant = 0
    }
    
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
        previousScrollPosition = CGPoint.zero
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
        
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
    
    // MARK:-- Navigation Functions
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
    
    private func navigateToEditAccompanist()
    {
        navigateToNextScreen(stoaryBoard: accompanistDetailsSb, viewController: AccompanistModifyListVcID)
    }
    
    private func navigateToAddWorkPlaceDetails()
    {
        navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: DCRHeaderVcID)
    }
    
    private func navigateToEditWorkPlaceDetails()
    {
        navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: DCRHeaderVcID)
    }
    
    private func navigateToAddTravelPlace()
    {
        let intermediateStatus = BL_SFC.sharedInstance.checkAutoCompleteValidation()
        
        if (intermediateStatus != EMPTY)
        {
            showToast(message: intermediateStatus)
        }
        else
        {
            navigateToNextScreen(stoaryBoard: addTravelDetailSb, viewController: addTravelDetailVcId)
        }
    }
    
    private func navigateToEditTravelPlace()
    {
        navigateToNextScreen(stoaryBoard: travelDetailListSb, viewController: travelDetailListVcID)
    }
    ///
    private func navigateToAddChemistDay()
    {
        let showAccompanistScreen = BL_DCR_Chemist_Visit.sharedInstance.canUseAccompanistsChemist()
        let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsList()
        //let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsListWithoutVandNA()
        
        if showAccompanistScreen == true && (dcrAccompCount?.count)! > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = ChemistDayVcID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
            vc.isComingFromChemistDay = true
            vc.regionCode = getRegionCode()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func navigateToEditChemistDay()
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitModifyVcID) as! DoctorVisitModifyController
        vc.isForChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctor()
    {
        let objDCRInheritanceValidation = BL_DCR_Doctor_Visit.sharedInstance.doDCRInheritanceValidations()
        
        if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.PROCEED)
        {
            proceedToAddDoctor()
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_ERROR)
        {
            showAccompanistMandatoryAlert()
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_CONFIRMATION)
        {
            showAccompanistOptionalAlert()
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.INTERNET_MANDATORY_ERROR)
        {
            showInternetMandatoryAlert()
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.INTERNET_OPTIONAL_ERROR)
        {
            showInternetOptionalAlert(accUserCodes: objDCRInheritanceValidation.Message)
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.ACC_DATA_NOT_DOWNLOADED_ERROR)
        {
            let message = Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_DATA_MANDATORY_ERROR_MESSAGE.replacingOccurrences(of: "@ACC_USERS", with: objDCRInheritanceValidation.Message)
            showAccDataNotDownloadAlert(message: message)
        }
        else if (objDCRInheritanceValidation.Status == Constants.DCR_Inheritance_Status_Codes.MAKE_API_CALL)
        {
            showCustomActivityIndicatorView(loadingText: Display_Messages.DCR_Inheritance_Messages.API_CALL_LOADING_MESSAGE)
            BL_DCR_Doctor_Visit.sharedInstance.getAccompanistDCRDoctorVisit(viewController: self, accompanistsUsersCodes: objDCRInheritanceValidation.Message, completion: { (objResponse) in
                self.dcrInheritanceCallBack(objResponse: objResponse)
            })
        }
    }
    
    private func dcrInheritanceCallBack(objResponse: ApiResponseModel)
    {
        if (checkNullAndNilValueForString(stringData: objResponse.Message) != EMPTY)
        {
            showDCRInheirtanceAlert(message: objResponse.Message, apiResponseStatus: objResponse.Status)
        }
        
        BL_Stepper.sharedInstance.generateDataArray()
        self.reloadTableView()
        
        removeCustomActivityView()
    }
    
    private func showDCRInheirtanceAlert(message: String, apiResponseStatus: Int)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            if (apiResponseStatus != 2)
            {
                //self.proceedToAddDoctor()
                self.navigateToEditDoctor()
            }
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func proceedToAddDoctor()
    {
        let showAccompanistScreen = BL_DCR_Doctor_Visit.sharedInstance.canUseAccompanistsDoctor()
        let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsList()
        
        //let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsListWithoutVandNA()
        
        if showAccompanistScreen == true && (dcrAccompCount?.count)! > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = doctorMasterVcID
            vc.isFromDCR = true
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
    
    private func showAccompanistMandatoryAlert()
    {
        let alertViewController = UIAlertController(title: errorTitle, message: Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_MANDATORY_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showAccompanistOptionalAlert()
    {
        let alertViewController = UIAlertController(title: alertTitle, message: Display_Messages.DCR_Inheritance_Messages.ACCOMPANIST_OPTIONAL_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.proceedToAddDoctor()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showInternetMandatoryAlert()
    {
        let alertViewController = UIAlertController(title: errorTitle, message: Display_Messages.DCR_Inheritance_Messages.INTERNET_MANDATORY_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "GO TO SETTINGS", style: UIAlertActionStyle.default, handler: { alertAction in
            //  goToSettingsPage()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showInternetOptionalAlert(accUserCodes: String)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: Display_Messages.DCR_Inheritance_Messages.INTERNET_OPTIONAL_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "GO TO SETTINGS", style: UIAlertActionStyle.default, handler: { alertAction in
            //  goToSettingsPage()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.updateAccDataDownloadStatusAsError(accUserCodes: accUserCodes)
            self.proceedToAddDoctor()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func updateAccDataDownloadStatusAsError(accUserCodes: String)
    {
        BL_DCR_Doctor_Visit.sharedInstance.updateAccompanistDownloadStatus(userCodes: accUserCodes, dcrId: DCRModel.sharedInstance.dcrId, status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
    }
    
    private func showAccDataNotDownloadAlert(message: String)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.showAccDataNotDownloadAlertOkButtonAction()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showAccDataNotDownloadAlertOkButtonAction()
    {
        BL_Stepper.sharedInstance.getAccompanistDataPendingList()
        
        if (BL_Stepper.sharedInstance.accompanistDataDownloadPendingUsersList().count > 0)
        {
            showPendingAccompanistDataDownloadAlert()
        }
    }
    
    private func navigateToEditDoctor()
    {
        navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
    }
    
    private func navigateToAddStockist()
    {
        navigateToNextScreen(stoaryBoard: stockiestsSb, viewController: StockiestsListVcID)
    }
    
    private func navigateToEditStockist()
    {
        navigateToNextScreen(stoaryBoard: stockiestsSb, viewController: StockiestsModifyListVcID)
    }
    
    private func navigateToAddExpense()
    {
        navigateToNextScreen(stoaryBoard: addExpenseDetailsSb, viewController: AddExpenseVcID)
    }
    
    private func navigateToEditExpense()
    {
        navigateToNextScreen(stoaryBoard: addExpenseDetailsSb, viewController:ExpenseListVcID )
    }
    
    private func navigateToAddGeneralRemarks()
    {
        navigateToNextScreen(stoaryBoard: dcrStepperSb, viewController:DCRGeneralRemarksVcID )
    }
    
    private func navigateToEditGeneralRemarks()
    {
        let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DCRGeneralRemarksVcID) as! DCRGeneralRemarksViewController
        vc.isModifyPage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddWorkTimeDetails()
    {
        navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: Constants.ViewControllerNames.WorkTimeViewVCID)
    }
    
    private func navigateToEditWorkTimePlaceDetails()
    {
        navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: Constants.ViewControllerNames.WorkTimeViewVCID)
    }
    
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        let entityId = BL_Stepper.sharedInstance.stepperDataList[index].Entity_Id
        
        switch entityId
        {
        case DCR_Stepper_Entity_Id.Accompanist.rawValue:
            navigateToAddAccompanist()
        case DCR_Stepper_Entity_Id.WorkPLace.rawValue:
            navigateToAddWorkPlaceDetails()
        case DCR_Stepper_Entity_Id.SFC.rawValue:
            navigateToAddTravelPlace()
        case DCR_Stepper_Entity_Id.Doctor.rawValue:
            navigateToAddDoctor()
        case DCR_Stepper_Entity_Id.Chemist.rawValue:
            navigateToAddChemistDay()
        case DCR_Stepper_Entity_Id.Stockist.rawValue:
            navigateToAddStockist()
        case DCR_Stepper_Entity_Id.Expense.rawValue:
            navigateToAddExpense()
        case DCR_Stepper_Entity_Id.GeneralRemarks.rawValue:
            navigateToAddGeneralRemarks()
        case DCR_Stepper_Entity_Id.Work_Time.rawValue:
            navigateToAddWorkTimeDetails()
        default:
            print(1)
        }
    }
    
    private func modifyEntry(index: Int)
    {
        let entityId = BL_Stepper.sharedInstance.stepperDataList[index].Entity_Id
        
        switch entityId
        {
        case DCR_Stepper_Entity_Id.Accompanist.rawValue:
            navigateToEditAccompanist()
        case DCR_Stepper_Entity_Id.WorkPLace.rawValue:
            navigateToEditWorkPlaceDetails()
        case DCR_Stepper_Entity_Id.SFC.rawValue:
            navigateToEditTravelPlace()
        case DCR_Stepper_Entity_Id.Doctor.rawValue:
            navigateToEditDoctor()
        case DCR_Stepper_Entity_Id.Chemist.rawValue:
            navigateToEditChemistDay()
        case DCR_Stepper_Entity_Id.Stockist.rawValue:
            navigateToEditStockist()
        case DCR_Stepper_Entity_Id.Expense.rawValue:
            navigateToEditExpense()
        case DCR_Stepper_Entity_Id.GeneralRemarks.rawValue:
            navigateToEditGeneralRemarks()
        case DCR_Stepper_Entity_Id.Work_Time.rawValue:
            navigateToEditWorkTimePlaceDetails()
        default:
            print(1)
        }
    }
    
    private func skipItem(index: Int)
    {
        let entityId = BL_Stepper.sharedInstance.stepperDataList[index].Entity_Id
        
        switch entityId
        {
        case DCR_Stepper_Entity_Id.Accompanist.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show work place details's
        case DCR_Stepper_Entity_Id.Doctor.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateSkipButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show Chemist details
        case DCR_Stepper_Entity_Id.Chemist.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateSkipButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show Stockist details
        case DCR_Stepper_Entity_Id.Stockist.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateSkipButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show Expense details
        case DCR_Stepper_Entity_Id.Expense.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show General remarks details
        case DCR_Stepper_Entity_Id.GeneralRemarks.rawValue:
            BL_Stepper.sharedInstance.stepperDataList[index + 1].showEmptyStateAddButton = true
            reloadTableViewAtIndexPath(index: index + 1) // Show work time details
        default:
            print(1)
        }
    }
    
    private func showSubmitDCRButton()
    {
        submitDCRButton.isHidden = false
        submitDCRBorderView.isHidden = false
        
        submitDCRButtonHeightConstraint.constant = 40
        submitDCRBorderViewHeightConstraint.constant = 1
    }
    
    private func hideSubmitDCRButton()
    {
        submitDCRButton.isHidden = true
        submitDCRBorderView.isHidden = true
        
        submitDCRButtonHeightConstraint.constant = 0
        submitDCRBorderViewHeightConstraint.constant = 0
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
            
            if (isAutoSyncEnabled)
            {
                if (checkInternetConnectivity())
                {
                    self.navigateToUploadDCR(enabledAutoSync: true)
                }
                else
                {
                    self.popViewController(animated: true)
                }
            }
            else
            {
                self.showAlertToUploadDCR()
            }
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToUploadDCR()
    {
        let alertMessage =  "Your Offline DVR is ready to submit to your manager.\n\n Click 'Upload' to submit DVR.\n Click 'Later' to submit later\n\n Alternatively, you can use 'Upload my DVR' option from the home screen to submit your applied DVR."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "LATER", style: UIAlertActionStyle.default, handler: { alertAction in
            self.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "UPLOAD", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateToUploadDCR(enabledAutoSync: false)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToChangeWorkTime(captureLocation: Bool)
    {
        let headerObj = BL_Stepper.sharedInstance.dcrHeaderObj
        let startTime = checkNullAndNilValueForString(stringData: headerObj?.Start_Time)
        let endTime = checkNullAndNilValueForString(stringData: headerObj?.End_Time)
        var alertMsg: String = EMPTY
        
        if (startTime != EMPTY && endTime != EMPTY)
        {
            alertMsg = "Your work time is \(String(describing: startTime)) to \(String(describing: endTime))"
        }
        else
        {
            alertMsg = "DVR work time is not available"
        }
        
        let alertMessage =  "\(alertMsg) \n\n Tap on PROCEED to submit the DVR \n\n OR \n\n Tap on CHANGE to change work time"
        
        let alertViewController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CHANGE", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateToEditWorkTimePlaceDetails()
        }))
        
        alertViewController.addAction(UIAlertAction(title: "PROCEED", style: UIAlertActionStyle.default, handler: { alertAction in
            self.showAlertToConfirmAppliedMode(captureLocation: captureLocation)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func navigateToUploadDCR(enabledAutoSync: Bool)
    {
        //        let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier:DCRUploadVcID) as! DCRUploadController
        //
        //        vc.enabledAutoSync = enabledAutoSync
        //
        //        if let navigationController = self.navigationController
        //        {
        //            navigationController.popViewController(animated: false)
        //            navigationController.pushViewController(vc, animated: false)
        //        }
        
        BL_DCRCalendar.sharedInstance.getDCRUploadError(viewController: self, isFromLandingUpload: false, enabledAutoSync: enabledAutoSync)
    }
    
    func popViewController(animated: Bool)
    {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let entityId = stepperObj.Entity_Id
        let selectedIndex = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: selectedIndex)
        }
        else
        {
            if (entityId == DCR_Stepper_Entity_Id.Accompanist.rawValue || entityId == DCR_Stepper_Entity_Id.Chemist.rawValue || entityId == DCR_Stepper_Entity_Id.Stockist.rawValue || entityId == DCR_Stepper_Entity_Id.Expense.rawValue || entityId == DCR_Stepper_Entity_Id.Work_Time.rawValue)
            {
                return BL_Stepper.sharedInstance.getCommonCellHeight(selectedIndex: selectedIndex)
            }
            else if entityId == DCR_Stepper_Entity_Id.WorkPLace.rawValue {
                 return BL_Stepper.sharedInstance.getCommonCellHeight(selectedIndex: selectedIndex)// + 20
            }
            else if (entityId == DCR_Stepper_Entity_Id.SFC.rawValue)
            {
                return BL_Stepper.sharedInstance.getSFCCellHeight(selectedIndex: selectedIndex)
            }
            else if (entityId == DCR_Stepper_Entity_Id.Doctor.rawValue)
            {
                return BL_Stepper.sharedInstance.getDoctorCellHeight(selectedIndex: selectedIndex)
            }
            else if (entityId == DCR_Stepper_Entity_Id.GeneralRemarks.rawValue)
            {
                return BL_Stepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: selectedIndex)
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepperMainCell") as! DCRStepperMainTableViewCell
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        cell.selectedEntityId = objStepperModel.Entity_Id
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        
        if (objStepperModel.recordCount == 0)
        {
            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
            
            cell.doctorSectionTitleLabel.text = objStepperModel.doctorEmptyStateTitle
            cell.doctorSectionSubTitleLabel.text = objStepperModel.doctorEmptyStatePendingCount
            
            cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
            cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
            
            cell.emptyStateView.isHidden = false
            cell.cardView.isHidden = true
            cell.cardView.clipsToBounds = true
            
            cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        }
        else
        {
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateView.isHidden = true
            cell.cardView.isHidden = false
            cell.cardView.clipsToBounds = false
            
            cell.rightButton.isHidden = !objStepperModel.showRightButton
            cell.leftButton.isHidden = !objStepperModel.showLeftButton
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
        }
        
        cell.doctorSectionTitleView.isHidden = true
        cell.sectionTitleView.isHidden = true
        cell.doctorSectionTitleView.clipsToBounds = true
        
        if (objStepperModel.recordCount > 0)
        {
            if (objStepperModel.Entity_Id != DCR_Stepper_Entity_Id.Doctor.rawValue)
            {
                cell.sectionTitleView.isHidden = false
                cell.doctorSectionTitleView.clipsToBounds = true
                cell.doctorTitleTopConstraint.constant = 4
                cell.commonSectionTitleHeightConstraint.constant = 30
            }
            else
            {
                cell.doctorSectionTitleView.isHidden = false
                cell.doctorSectionTitleView.clipsToBounds = false
                cell.doctorTitleTopConstraint.constant = 41
                cell.doctorSectionTitleLabel.text = objStepperModel.doctorEmptyStateTitle
                cell.doctorSectionSubTitleLabel.text = objStepperModel.doctorEmptyStatePendingCount
                cell.commonSectionTitleHeightConstraint.constant = 0
            }
        }
        
        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
        cell.sectionToggleImageView.isHidden = true
        cell.sectionToggleImageView.clipsToBounds = true
        
        if (objStepperModel.recordCount > 1)
        {
            if (objStepperModel.isExpanded == true)
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
            }
            else
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
            }
            
            cell.sectionToggleImageView.isHidden = false
            cell.sectionToggleImageView.clipsToBounds = false
        }
        
        cell.moreView.isHidden = true
        cell.moreView.clipsToBounds = true
        cell.moreViewHeightConstraint.constant = 0
        cell.buttonViewHeight.constant = 60
        
        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > 1)
        {
            cell.moreView.isHidden = false
            cell.moreView.clipsToBounds = false
            cell.moreViewHeightConstraint.constant = 20
        }
        else
        {
            cell.buttonViewHeight.constant = 40
        }
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        cell.emptyStateSkipButton.tag = rowIndex
        
        if ((BL_Stepper.sharedInstance.doctorList.count > 0 || BL_Stepper.sharedInstance.chemistDayHeaderList.count > 0) && BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name != nil && BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name != EMPTY && BL_Stepper.sharedInstance.sfcList.count > 0 || BL_Stepper.sharedInstance.isTravelAllowed() == false)
        {
            showSubmitDCRButton()
        }
        else
        {
            hideSubmitDCRButton()
        }
        
        return cell
    }
    
    // MARK:- Button Actions
    @IBAction func sectionExpanCoverButtonAction(sender: UIButton)
    {
        let index = sender.tag
        let stepperObj = BL_Stepper.sharedInstance.stepperDataList[index]
        let entityId = BL_Stepper.sharedInstance.stepperDataList[index].Entity_Id
        
        if (stepperObj.recordCount > 1 && entityId != DCR_Stepper_Entity_Id.Doctor.rawValue)
        {
            stepperObj.isExpanded = !stepperObj.isExpanded
            reloadTableViewAtIndexPath(index: index)
        }
    }
    
    @IBAction func leftButtonAction(sender: UIButton)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func rightButtonAction(sender: UIButton)
    {
        modifyEntry(index: sender.tag)
    }
    
    @IBAction func emptyStateAddButtonAction(sender: UIButton)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func emptyStateSkipButtonAction(sender: UIButton)
    {
        skipItem(index: sender.tag)
    }
    
    @IBAction func submitDCRButtonAction()
    {
        let errorMessage = BL_Stepper.sharedInstance.doSubmitDCRValidations()
        
        if (errorMessage != EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: errorMessage, viewController: self)
        }
        else
        {
            //            var isLocationMandatory: Bool = false
            var captureLocationInSubmitDCR: Bool = false
            //
            //            if (checkNullAndNilValueForString(stringData: BL_Stepper.sharedInstance.dcrHeaderObj?.Lattitude) == EMPTY)
            //            {
            //                if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY) == PrivilegeValues.YES.rawValue)
            //                {
            //                    captureLocationInSubmitDCR = true
            //                }
            //
            //                if (canShowLocationMandatoryAlert())
            //                {
            //                    isLocationMandatory = true
            //                }
            //            }
            //
            //            if (isLocationMandatory)
            //            {
            //                AlertView.showAlertToEnableGPS()
            //            }
            //            else if !checkIsCapturingLocation() && showAlertCaptureLocationCount < AlertLocationCaptureCount
            //            {
            //                showAlertCaptureLocationCount += 1
            //                AlertView.showAlertToCaptureGPS()
            //            }
            //            else
            //            {
            //               showAlertToChangeWorkTime(captureLocation: captureLocationInSubmitDCR)
            //            }
            if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
            {
                self.showAlertToConfirmAppliedMode(captureLocation: captureLocationInSubmitDCR)
            }
            else
            {
                showAlertToChangeWorkTime(captureLocation: captureLocationInSubmitDCR)
            }
        }
    }
    
    func getselectedAccompanist(selectedAccompanist: [DCRAccompanistModel], type: Int)
    {
        if type == 1
        {
            updateAccompanistDownloadLater(selectedAccompanistList: selectedAccompanist)
            
        }
        else
        {
            downloadAccompanistData(selectedAccompanistList: selectedAccompanist)
        }
        perform(#selector(self.checkaccompanist), with: nil, afterDelay: 0.25)
    }
    
    private func insertDoctorDetails()
    {
        //BL_DCR_Doctor_Visit.sharedInstance.insertAssetDetailedDoctorInVisit(dcrDate: DCRModel.sharedInstance.dcrDate)
    }
    
    //MARK: - Scrollview delegate
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView)
    //    {
    //        if (scrollView.contentOffset.y < scrollView.contentSize.height - tableView.frame.size.height)
    //        {
    //            self.toggleNavigationBar(scrollView: scrollView)
    //        }
    //    }
    //
    //    func toggleNavigationBar(scrollView: UIScrollView)
    //    {
    //        let currentPosition: CGPoint = scrollView.contentOffset
    //
    //        if (previousScrollPosition == nil)
    //        {
    //            previousScrollPosition = CGPoint.zero
    //        }
    //
    //        if (currentPosition.y < 0)
    //        {
    //            showNavigationBar()
    //        }
    //        else if (currentPosition.y == 0)
    //        {
    //            showNavigationBar()
    //        }
    //        else if (currentPosition.y > 0 && previousScrollPosition.y != currentPosition.y)
    //        {
    //            if (previousScrollPosition.y < currentPosition.y)
    //            {
    //                hideNavigationBar()
    //            }
    //            else
    //            {
    //                showNavigationBar()
    //            }
    //        }
    //        else if (currentPosition.y == scrollView.contentSize.height)
    //        {
    //            hideNavigationBar()
    //        }
    //
    //        previousScrollPosition = currentPosition
    //    }
    //
    //    func hideNavigationBar()
    //    {
    //        UIView.animate(withDuration: 0.3) {
    //            self.navigationController?.setNavigationBarHidden(true, animated: true)
    //        }
    //    }
    //
    //    func showNavigationBar()
    //    {
    //        UIView.animate(withDuration: 0.3) {
    //            self.navigationController?.setNavigationBarHidden(false, animated: true)
    //        }
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        //  if distanceFromBottom < height {
        if ((BL_Stepper.sharedInstance.doctorList.count > 0 || BL_Stepper.sharedInstance.chemistDayHeaderList.count > 0) && BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name != nil && BL_Stepper.sharedInstance.dcrHeaderObj?.Category_Name != EMPTY && BL_Stepper.sharedInstance.sfcList.count > 0 || BL_Stepper.sharedInstance.isTravelAllowed() == false)
        {
            showSubmitDCRButton()
        }
        else
        {
            hideSubmitDCRButton()
        }
        //  }
        //  else
        //   {
        //hideSubmitDCRButton()
        //  }
    }
    
}

