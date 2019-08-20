//
//  TPStepperViewController.swift
//  HiDoctorApp
//  Created by Admin on 7/24/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPStepperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SelectedAccompanistPopUpDelegate, AddSampleDelegate {
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitTPBorderView: UIView!
    @IBOutlet weak var submitButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitTPBorderViewHeightConstraint: NSLayoutConstraint!
    var previousScrollPosition: CGPoint!
    
    // MARK:- Variables
    var stepperDataList: [DCRStepperModel] = []
    var showAlertCaptureLocationCount : Int = 0
    
    // MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        removeVersionToastView()
        super.viewDidLoad()
        self.title = convertDateIntoString(date: TPModel.sharedInstance.tpDate) + " (Field)"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        BL_TPStepper.sharedInstance.clearAllArray()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        BL_TPStepper.sharedInstance.generateDataArray()
        reloadTableView()
        showAlertCaptureLocationCount = 0
        
        showPendingAccompanistDataDownloadAlert()
        
        if (BL_TPStepper.sharedInstance.isSFCUpdated)
        {
            BL_TPStepper.sharedInstance.isSFCUpdated = false
            showToastView(toastText: "Your SFC updated")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    
    // MARK:- Private Functions
    private func showPendingAccompanistDataDownloadAlert()
    {
        if (checkInternetConnectivity())
        {
            if (BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData())
            {
                let pendingList = BL_TPStepper.sharedInstance.accompanistDataDownloadPendingUsersList()
                
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
    }
    
    private func downloadAccompanistData(selectedAccompanistList: [DCRAccompanistModel])
    {
        showLoader()
        
        BL_TPStepper.sharedInstance.downloadAccompanistData(selectedAccompanistList: selectedAccompanistList) { (status) in
            
            if (status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: "Download Accompanist from TP"), completion: { (apiObj) in
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
        BL_TPStepper.sharedInstance.updateAccompanistDataDownloadAsLater(selectedAccompanistList: selectedAccompanistList)
    }
    
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
        previousScrollPosition = CGPoint.zero
        toggleSubmitButton()
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
        
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "tpAccomanist"
        accom_vc.navigationTitle = "User List"
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }
    
    private func navigateToEditAccompanist()
    {
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "tpAccomanist"
        accom_vc.navigationTitle = "User List"
        accom_vc.isTPModify = true
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }
    
    private func navigateToAddMeetingPointDetails()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPMeetingPointVCID) as! TPMeetingPointViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditMeetingPointDetails()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPMeetingPointVCID) as! TPMeetingPointViewController
        vc.fromModify = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddWorkPlaceDetails()
    {
        navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPWorkPlaceDetailVCID)
    }
    
    private func navigateToEditWorkPlaceDetails()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPWorkPlaceDetailVCID) as! TPWorkPlaceDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //navigateToNextScreen(stoaryBoard: workPlaceDetailsSb, viewController: DCRHeaderVcID)
    }
    
    private func navigateToAddTravelPlace()
    {
        BL_TP_SFC.sharedInstance.fromPlace = EMPTY
        BL_TP_SFC.sharedInstance.toPlace = EMPTY

        navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPTravelDetailsVCID)
    }
    
    private func navigateToEditTravelPlace()
    {
        let tbStepperSB = UIStoryboard(name: TourPlannerSB, bundle: nil)
        let tpTravel_vc = tbStepperSB.instantiateViewController(withIdentifier: TPTravelListVcId) as! TPTravelDetailListViewController
        //tpTravel_vc.isComingFromModify = true
        self.navigationController?.pushViewController(tpTravel_vc, animated: true)
    }
    
    private func navigateToAddDoctor()
    {
        if BL_TPStepper.sharedInstance.canUseAccompanistCp(entityName: "DOCTOR")
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = TPStepperVCID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: TPDoctorMasterVCID) as! TPDoctorMasterViewController
            vc.regionCode = getRegionCode()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func navigateToEditDoctor()
    {
        navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
    }
    
    private func navigateToAddGeneralRemarks()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPGeneralRemarksVCID) as! TPGeneralRemarksViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditGeneralRemarks()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPGeneralRemarksVCID) as! TPGeneralRemarksViewController
        vc.isComingFromModify = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        switch index
        {
        case 0:
            navigateToAddAccompanist()
        case 1:
            removeMeetingPlaceDetails()
        case 2:
            navigateToAddWorkPlaceDetails()
        case 3:
            navigateToAddTravelPlace()
        case 4:
            navigateToAddDoctor()
        case 5:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    private func modifyEntry(index: Int)
    {
        switch index
        {
        case 0:
            navigateToEditAccompanist()
        case 1:
            navigateToEditMeetingPointDetails()
        case 2:
            navigateToEditWorkPlaceDetails()
        case 3:
            navigateToEditTravelPlace()
        case 5:
            navigateToEditGeneralRemarks()
        default:
            print(1)
        }
    }
    
    private func emptyStateAddNewEntry(index: Int)
    {
        switch index
        {
        case 0:
            navigateToAddAccompanist()
        case 1:
            navigateToAddMeetingPointDetails()
        case 2:
            navigateToAddWorkPlaceDetails()
        case 3:
            navigateToAddTravelPlace()
        case 4:
            navigateToAddDoctor()
        case 5:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    private func skipItem(index: Int)
    {
        switch index
        {
            case 0:
                BL_TPStepper.sharedInstance.stepperDataList[1].showEmptyStateAddButton = true
                BL_TPStepper.sharedInstance.stepperDataList[1].showEmptyStateSkipButton = !BL_TPStepper.sharedInstance.isMeetingPlaceTimeMandatory()
                reloadTableViewAtIndexPath(index: 1) // Show work place details's
            case 1:
                BL_TPStepper.sharedInstance.stepperDataList[2].showEmptyStateAddButton = true
                reloadTableViewAtIndexPath(index: 2)
            default:
                print(1)
        }
    }
    
    private func showsubmitButton()
    {
        submitButton.isHidden = false
        submitTPBorderView.isHidden = false
        
        submitButtonHeightConstraint.constant = 40
        submitTPBorderViewHeightConstraint.constant = 1
    }
    
    private func hidesubmitButton()
    {
        submitButton.isHidden = true
        submitTPBorderView.isHidden = true
        
        submitButtonHeightConstraint.constant = 0
        submitTPBorderViewHeightConstraint.constant = 0
    }
    
    func showAlertToConfirmAppliedMode()
    {
        let alertMessage =  "Your Offline TP is ready to submit in Applied status. Once submitted you can not edit your TP.\n\n Press 'Ok' to submit TP.\n OR \n Press 'Cancel'."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            
            BL_TPStepper.sharedInstance.submitTP()
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                self.showAlertToUploadDCR()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToUploadDCR()
    {
        let alertMessage =  "Your Offline TP is ready to submit to your manager.\n\n Click 'Upload' to submit TP.\nClick 'Later' to submit later\n\nAlternatively, you can use 'Upload my TP' option from the TP calendar screen to submit your applied TP."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "LATER", style: UIAlertActionStyle.default, handler: { alertAction in
          _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "UPLOAD", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateToUploadTP()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func navigateToUploadTP()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPUploadSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPUploadSelectVCID) as! TPUploadSelectionViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        return BL_TPStepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_TPStepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_TPStepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if (index == 0)
            {
                return BL_TPStepper.sharedInstance.getAccompanistCellHeight(selectedIndex: index)
            }
            if ( index == 1 || index == 2 )
            {
                return BL_TPStepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
            }
            else if (index == 3)
            {
                return BL_TPStepper.sharedInstance.getSFCCellHeight(selectedIndex: index)
            }
            else if (index == 4)
            {
                return BL_TPStepper.sharedInstance.getDoctorCellHeight(selectedIndex: index)
            }
            else if (index == 5)
            {
                return BL_TPStepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPStepperMainCell") as! TPStepperMainTableViewCell
        let selectedAcompanist = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        cell.copyTPViewBut.isHidden = true
        cell.copyTPViewCopyBut.isHidden = true
        cell.copyTpHeightConstraint.constant = 0
        cell.copyeditTpHeightConstraint.constant = 0
        cell.isFromTp = true
        let messageText = "More than one accompanist has planned joint visit on this day. Do you want to copy his \(PEV_TOUR_PLAN)?"
        let getheight = getTextSize(text: messageText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-120).height
        let calculateHeihgt = 50 - getheight
        
        if(indexPath.row == 0)
        {
            if((selectedAcompanist.count != 0) && (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).count > 0))
            {
                cell.copyTpHeightConstraint.constant = 156 - calculateHeihgt
                cell.copylabelheight.constant = getheight
                cell.copyeditTpHeightConstraint.constant = 40
                cell.copyTPViewBut.isHidden = false
                cell.copyTPViewBut.addTarget(self, action: #selector(TPStepperViewController.viewCopyTourPlan(sender:)), for: .touchUpInside)
                cell.copyTPViewCopyBut.addTarget(self, action: #selector(TPStepperViewController.CopyTourPlan(sender:)), for: .touchUpInside)
                
                if(selectedAcompanist.count > 1 )
                {
                    cell.copyTPViewCopyBut.isHidden = true
                    cell.copyLabel.text = messageText
                }
                else
                {
                    cell.copyTPViewCopyBut.isHidden = false
                    cell.copyLabel.text = "\(selectedAcompanist[0].userObj.User_Name!) has planned joint visit on this day. Do you want to copy his \(PEV_TOUR_PLAN)"
                }
            }
        }
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_TPStepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        cell.delegate = self
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
            
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
        }
        
        cell.doctorSectionTitleView.isHidden = true
        cell.sectionTitleView.isHidden = true
        cell.doctorSectionTitleView.clipsToBounds = true
        
        if (objStepperModel.recordCount > 0)
        {
            if (rowIndex != 4)
            {
                cell.sectionTitleView.isHidden = false
                cell.doctorSectionTitleView.clipsToBounds = true
                cell.doctorTitleTopConstraint.constant = 4
                cell.commonSectionTitleHeightConstraint.constant = 30
            }
            else
            {
                cell.doctorSectionTitleView.isHidden = true
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
        
        if objStepperModel.recordCount > 0
        {
            if indexPath.row == 4
            {
                cell.sectionCoverBtnView.isHidden = true
            }
            else
            {
                cell.sectionCoverBtnView.isHidden = false
            }
        }
        else
        {
            cell.sectionCoverBtnView.isHidden = false
        }
        
        if objStepperModel.recordCount == 1
        {
            cell.sectionToggleImageView.isHidden = true
            cell.sectionCoverBtnView.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("index",indexPath.row)
    }
    
    func didTapAddSampleBtn(sender: UIButton)
    {
        let tpSampleList = BL_TPStepper.sharedInstance.doctorList[sender.tag].sampleList1
        
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPSampleListVCID) as! TPSampleListViewController
        
        vc.userDCRProductList = tpSampleList
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeDoctorButtonAction(sender: UIButton)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: "Do you want to delete \(appDoctor) ?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            let tpDoctorId = BL_TPStepper.sharedInstance.doctorList[sender.tag].tpDoctorId
            
            BL_TPStepper.sharedInstance.deleteDoctorFromTP(tp_Doctor_Id: tpDoctorId!)
            BL_TPStepper.sharedInstance.generateDataArray()
            self.reloadTableView()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func didSelectExpandableCell()
    {
        self.tableView.reloadData()
    }
    
    // MARK:- Button Actions
    @IBAction func sectionExpanCoverButtonAction(sender: UIButton)
    {
        let index = sender.tag
        let stepperObj = BL_TPStepper.sharedInstance.stepperDataList[index]
        
        if (stepperObj.recordCount > 1 && index != 4)
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
        emptyStateAddNewEntry(index: sender.tag)
    }
    
    @IBAction func emptyStateSkipButtonAction(sender: UIButton)
    {
        skipItem(index: sender.tag)
    }
    
    @IBAction func submitButtonAction()
    {
        let errorMessage = BL_TPStepper.sharedInstance.doSubmitTPValidations()
        
        if (errorMessage != EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: errorMessage, viewController: self)
        }
        else
        {
            showAlertToConfirmAppliedMode()
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
    }
    
    private func insertDoctorDetails()
    {
        //BL_DCR_Doctor_Visit.sharedInstance.insertAssetDetailedDoctorInVisit(dcrDate: DCRModel.sharedInstance.dcrDate)
    }
    
    func navigateToAccompanistVC()
    {
        let accList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId) as [UserMasterWrapperModel]
        
        if accList.count == 1
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPCopyTourPlanVCID) as! TPCopyTourPlannerViewController
            vc.accDataArray = accList[0].userObj
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPCopyTourPlanAccompanistListVCID) as! AccompanistListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func copyAccompanistDetails()
    {
        if checkInternetConnectivity()
        {
            let accArray = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId) as [UserMasterWrapperModel]
            let accObj = accArray[0].userObj
            
            showActivityIndicator()
            //BL_TP_CopyTpStepper.sharedInstance.clearArray()
            BL_TP_CopyTpStepper.sharedInstance.postCopyTourPlanAccompanistDetails(user_code: accObj.User_Code , start_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate), end_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate), region_Code: accObj.Region_Code) { (StatusMsg,Status,list) in
                
                removeCustomActivityView()
                
                if Status == SERVER_SUCCESS_CODE
                {
                    //let headerArray = BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc
                    if BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc.count > 0
                    {
                        if BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].copyAccess == 1
                        {
                            BL_TP_CopyTpStepper.sharedInstance.updateAccHeaderDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, cp_Code: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].cp_Code, category_Code: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].category_Code, work_Place: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].work_Area, cp_Name: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].cp_Name, meeting_Place: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].meeting_Place!, meeting_Time: checkNullAndNilValueForString(stringData: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].meeting_Time), category_Name: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].work_Category_Name, remarks: checkNullAndNilValueForString(stringData: BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc[0].remarks))
                            
                            BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistSFC(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
                            BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistDoctor(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
                            BL_TP_CopyTpStepper.sharedInstance.insertAccompanistDetails()
                            BL_TPStepper.sharedInstance.generateDataArray()
                            self.reloadTableView()
                            
                            showToastView(toastText: "Copied Accompanist \(PEV_TOUR_PLAN)")
                        }
                        else
                        {
                            showToastView(toastText: "This feature is not applicable for this Accompanist")
                        }
                    }
                    else
                    {
                        showToastView(toastText: "No tp(s) found")
                    }
                }
                else
                {
                    showToastView(toastText: StatusMsg)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func showActivityIndicator()
    {
        showCustomActivityIndicatorView(loadingText: "Loading Accompanist data..")
    }
    
    func toggleSubmitButton()
    {
        if (checkNullAndNilValueForString(stringData: BL_TPStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && BL_TPStepper.sharedInstance.placesList.count > 0)
        {
            showsubmitButton()
        }
        else
        {
            hidesubmitButton()
        }
    }
    
    @objc func viewCopyTourPlan(sender: UIButton)
    {
        navigateToAccompanistVC()
    }
    
    @objc func CopyTourPlan(sender: UIButton)
    {
        copyAccompanistDetails()
    }
    
    private func removeMeetingPlaceDetails()
    {
        BL_TPStepper.sharedInstance.updateMeetingPointAndTime(Date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag, meeting_place: EMPTY, meeting_Time: EMPTY)
        
        BL_TPStepper.sharedInstance.generateDataArray()
        reloadTableView()
    }
}
