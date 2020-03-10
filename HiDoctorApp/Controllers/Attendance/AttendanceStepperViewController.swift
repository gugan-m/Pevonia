//
//  AttendanceStepperViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AttendanceStepperViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,AddAttendanceSampleDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitViewHgtConst: NSLayoutConstraint!
    
    // MARK:- Variables
    var stepperDataList: [DCRStepperModel] = []
    var showAlertCaptureLocationCount : Int = 0
    

    override func viewDidLoad()
    {
      super.viewDidLoad()
        
      removeVersionToastView()
      self.setSubmitViewHeightConst()
      addBackButtonView()
      self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + "(Office)"
    }

    override func viewWillAppear(_ animated: Bool)
    {
        BL_DCR_Attendance_Stepper.sharedInstance.getCurrentArray()
        reloadTableView()
        showAlertCaptureLocationCount = 0
        
        if (BL_DCR_Attendance_Stepper.sharedInstance.isSFCUpdated)
        {
            BL_DCR_Attendance_Stepper.sharedInstance.isSFCUpdated = false
            showToastView(toastText: "Your SFC updated")
        }
        self.showSFCAlert()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    private func showSFCAlert()
    {
        if(BL_DCRCalendar.sharedInstance.tpPreFillAlert.count > 0)
        {
           self.showPreFillAlert()
        }
    }
    
    private func showPreFillAlert()
    {
        var message = EMPTY
        let followMsg = "Following reasons has been identified during auto populate of Approvd PR details in DVR."
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
           
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        BL_DCRCalendar.sharedInstance.tpPreFillAlert = []
    }
    
      // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
        
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
    

    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        
        if (stepperObj.recordCount == 0)
        {
            return BL_DCR_Attendance_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if (index == BL_DCR_Attendance_Stepper.sharedInstance.workplaceindex || index == BL_DCR_Attendance_Stepper.sharedInstance.activityindex || index == BL_DCR_Attendance_Stepper.sharedInstance.expenseindex)
            {
                return BL_DCR_Attendance_Stepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
            }
            else if (index == BL_DCR_Attendance_Stepper.sharedInstance.travelindex)
            {
                return BL_DCR_Attendance_Stepper.sharedInstance.getSFCCellHeight(selectedIndex: index)
            }
            else if (index == BL_DCR_Attendance_Stepper.sharedInstance.generalindex)
            {
                return BL_DCR_Attendance_Stepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
            }
            else if(index == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
            {
                
               // return BL_DCR_Attendance_Stepper.sharedInstance.getDoctorVisitCellHeight(dataList: BL_DCR_Attendance_Stepper.sharedInstance.doctorList, type: 2) + 10
                
                return BL_DCR_Attendance_Stepper.sharedInstance.getDoctorCellHeight(selectedIndex: index)
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceMainCell) as! DCRAttendanceMainTableViewCell
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        cell.sectionCoverButton.isHidden = false
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        cell.delegate = self
        
        if (objStepperModel.recordCount == 0)
        {
            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
            
            
            cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
            
            
            cell.emptyStateView.isHidden = false
            cell.cardView.isHidden = true
            cell.cardView.clipsToBounds = true
            
            cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
        }
        else if objStepperModel.recordCount > 0
        {
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateView.isHidden = true
            cell.cardView.isHidden = false
            cell.cardView.clipsToBounds = false
            
            cell.rightButton.isHidden = !objStepperModel.showRightButton
            cell.leftButton.isHidden = !objStepperModel.showLeftButton
            
            cell.commonSectionTitleHeightConstraint.constant = 30
            cell.sectionTitleView.isHidden = false
            cell.coverButtonView.isHidden = false
            
            if (rowIndex == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
            {
                //                cell.sectionTitleView.isHidden = true
                //                cell.sectionTitleView.clipsToBounds = false
                //                cell.commonSectionTitleHeightConstraint.constant = 0
                //                cell.sectionCoverButton.isHidden = false
                //                cell.coverButtonView.isHidden = true
                //                cell.rightButton.isHidden = true
                cell.sectionTitleView.isHidden = false
                cell.sectionTitleView.clipsToBounds = true
                cell.commonSectionTitleHeightConstraint.constant = 4
                cell.commonSectionTitleHeightConstraint.constant = 30
            }
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
            
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
        cell.buttonViewHeight.constant = 20
        
        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > 1)
        {
            cell.moreView.isHidden = false
            cell.moreView.clipsToBounds = false
            cell.moreViewHeightConstraint.constant = 20
        }
        else
        {
            cell.buttonViewHeight.constant = 20
        }
        
        if (rowIndex == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
        {
            cell.moreView.isHidden = true
            cell.moreView.clipsToBounds = true
            cell.moreViewHeightConstraint.constant = 0
            
        }
        
        
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        self.setSubmitViewHeightConst()
        return cell
    }
    
    //MARK: - Button Action
    
    @IBAction func submitDCRBtnAction(_ sender: AnyObject)
    {
        let errorMessage = BL_DCR_Attendance_Stepper.sharedInstance.doSubmitDCRValidations()
        
        if (errorMessage != EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: errorMessage, viewController: self)
        }
        else
        {
            var isLocationMandatory: Bool = false
            var captureLocationInSubmitDCR: Bool = false
            
            if (checkNullAndNilValueForString(stringData: BL_DCR_Attendance_Stepper.sharedInstance.dcrHeaderObj?.Lattitude) == EMPTY)
            {
                if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY) == PrivilegeValues.YES.rawValue)
                {
                    captureLocationInSubmitDCR = true
                }
                
                if (canShowLocationMandatoryAlert())
                {
                    isLocationMandatory = true
                }
            }
            
            if (isLocationMandatory)
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
                showAlertToConfirmAppliedMode(captureLocation: captureLocationInSubmitDCR)
            }
        }
    }
    
    func showAlertToConfirmAppliedMode(captureLocation:Bool)
    {
        let alertMessage =  "Your Offline Office is ready to submit in Applied/Approved status. Once submit you can not edit your DVR.\n\n Press 'OK' to submit DVR.\n OR \n Press 'Cancel."
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
        let alertMessage =  "Your Offline Office is ready to submit to your manager.\n\n Click 'Upload' to submit Office.\n Click 'Later' to submit later\n\n Alternatively, you can use 'Upload my DVR'option from the home screen to submit your applied Office."
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
  
    func navigateToUploadDCR(enabledAutoSync: Bool)
    {
//        let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier:DCRUploadVcID) as! DCRUploadController
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
    
    @IBAction func emptyStateAddBtnAction(_ sender: AnyObject)
    {
        addNewEntry(index: sender.tag)
    }
    
    
    @IBAction func AddBtnAction(_ sender: AnyObject)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func modifyBtnAction(_ sender: AnyObject)
    {
         modifyEntry(index: sender.tag)
    }
    

    @IBAction func SectionExpandBtnAction(_ sender: UIButton)
    {
        let index = sender.tag
        let stepperObj = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[index]
        
        if (stepperObj.recordCount > 1 && index != BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
        {
            stepperObj.isExpanded = !stepperObj.isExpanded
            reloadTableViewAtIndexPath(index: index)
        }
    }
    
    //MARK:-- Button Action Helper Methods
    
    
    func hideTravel_hideExpense(index: Int) {
        switch index
        {
        case 0:
            navigateToAddWorkPlaceDetails()
        case 1:
            navigateToAddActivityDetails()
        case 2:
            navigateToAddDoctor()
        case 3:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    func hideTravel_showExpense(index: Int) {
        switch index
        {
        case 0:
            navigateToAddWorkPlaceDetails()
        case 1:
            navigateToAddActivityDetails()
        case 2:
            navigateToAddDoctor()
        case 3:
            navigateToAddExpense()
        case 4:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    func showTravel_hideExpense(index: Int) {
        switch index
        {
        case 0:
            navigateToAddWorkPlaceDetails()
        case 1:
            navigateToAddTravelPlace()
        case 2:
            navigateToAddActivityDetails()
        case 3:
            navigateToAddDoctor()
        case 4:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    func showTravel_showExpense(index: Int) {
        switch index
        {
        case 0:
            navigateToAddWorkPlaceDetails()
        case 1:
            navigateToAddTravelPlace()
        case 2:
            navigateToAddActivityDetails()
        case 3:
            navigateToAddDoctor()
        case 4:
            navigateToAddExpense()
        case 5:
            navigateToAddGeneralRemarks()
        default:
            print(1)
        }
    }
    
    
    
    
    private func addNewEntry(index: Int)
    {
        if(BL_DCR_Attendance_Stepper().checkAttendanceSampleAvailable()){
            
            if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == false &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == false {
                
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                   self.showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_showExpense(index: index)
                }
            } else if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == true &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == false {
                
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_showExpense(index: index)
                }
                
            } else if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == false &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == true {
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_showExpense(index: index)
                }
            } else if BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == true &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == true {
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.showTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.showTravel_showExpense(index: index)
                }
                }
        }
        else {
            switch index
            {
            case 0:
                navigateToAddWorkPlaceDetails()
            case 1:
                navigateToAddTravelPlace()
            case 2:
                navigateToAddActivityDetails()
            case 3:
                navigateToAddExpense()
            case 4:
                navigateToAddGeneralRemarks()
            default:
                print(1)
            }
        }
    }
    
    func mod_hideTravel_hideExpense(index: Int){
        switch index
        {
        case 0:
            navigateToEditWorkPlaceDetails()
        case 1:
            navigateToEditActiviytDetails()
        case 2:
            navigateToEditDoctorVisit()
        case 3:
            navigateToEditGeneralRemarks()
        default:
            print(1)
        }
    }
    
    func mod_hideTravel_showExpense(index: Int)
    {
        switch index
        {
        case 0:
        navigateToEditWorkPlaceDetails()
        case 1:
        navigateToEditActiviytDetails()
        case 2:
        navigateToEditDoctorVisit()
        case 3:
        navigateToEditExpense()
        case 4:
        navigateToEditGeneralRemarks()
        default:
        print(1)
        }
    }
    
    func mod_showTravel_hideExpense(index: Int){
        switch index
        {
        case 0:
            navigateToEditWorkPlaceDetails()
        case 1:
            navigateToEditTravelPlace()
        case 2:
            navigateToEditActiviytDetails()
        case 3:
            navigateToEditDoctorVisit()
        case 4:
            navigateToEditGeneralRemarks()
        default:
            print(1)
        }
    }
    
    func mod_showTravel_showExpense(index: Int){
        switch index
        {
        case 0:
            navigateToEditWorkPlaceDetails()
        case 1:
            navigateToEditTravelPlace()
        case 2:
            navigateToEditActiviytDetails()
        case 3:
            navigateToEditDoctorVisit()
        case 4:
            navigateToEditExpense()
        case 5:
            navigateToEditGeneralRemarks()
        default:
            print(1)
        }
    }
    
  private func modifyEntry(index: Int)
    {
        if(BL_DCR_Attendance_Stepper().checkAttendanceSampleAvailable()) {
            if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == false &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == false {
                
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                   self.mod_hideTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_showExpense(index: index)
                }
                
                
            } else if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == true &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == false {
               
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_showExpense(index: index)
                }
                
                
            } else if  BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == false &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == true {
                
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_showExpense(index: index)
                }
                
                
            } else if BL_DCR_Attendance_Stepper.sharedInstance.isExpenceAllowed() == true &&  BL_DCR_Attendance_Stepper.sharedInstance.isTravelAllowed() == true {
                
                if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                     self.mod_showTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count == 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_hideExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count == 0 {
                    self.mod_hideTravel_showExpense(index: index)
                } else if BL_DCR_Attendance_Stepper.sharedInstance.expenseList.count != 0 && BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count != 0 {
                    self.mod_showTravel_showExpense(index: index)
                }
                
                
            }
        }
        else {
            switch index
            {
            case 0:
                navigateToEditWorkPlaceDetails()
            case 1:
                navigateToEditTravelPlace()
            case 2:
                navigateToEditActiviytDetails()
            case 3:
                navigateToEditExpense()
            case 4:
                navigateToEditGeneralRemarks()
            default:
                print(1)
        }
        }
    }

    
    // MARK:-- Navigation Functions
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToAddWorkPlaceDetails()
    {
        let sb = UIStoryboard(name: workPlaceDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DCRHeaderVcID) as! WorkPlaceDetailsViewController
        vc.isComingFromAttendanceStepper = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditWorkPlaceDetails()
    {
        let sb = UIStoryboard(name: workPlaceDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DCRHeaderVcID) as! WorkPlaceDetailsViewController
        vc.showWorkTimeView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddTravelPlace()
    {
        let intermediateStatus = BL_SFC.sharedInstance.checkAutoCompleteValidation()
        
        if (intermediateStatus != EMPTY)
        {
            showToastView(toastText: intermediateStatus)
        }
        else
        {
            navigateToNextScreen(stoaryBoard: addTravelDetailSb, viewController: addTravelDetailVcId)
        }

    }
    
    private func  navigateToAddDoctor()
    {
        if(isManager())
        {
            let sb = UIStoryboard(name: attendanceStepperSb, bundle: nil)
            let vc:AttendanceAccompanistListController = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttendanceAccompanistListVCID) as! AttendanceAccompanistListController
            //vc.isFromAttendance = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            let regionName = loggedUserModel?.Region_Name
            let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
            let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
            vc.regionCode = regionCode
            vc.regionName = regionName
            vc.isFromAttendance = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    private func navigateToEditDoctorVisit()
    {
        
        //navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitModifyVcID) as! DoctorVisitModifyController
        vc.isFromAttendanceDoctor = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditTravelPlace()
    {
        navigateToNextScreen(stoaryBoard: travelDetailListSb, viewController: travelDetailListVcID)
    }
    
    private func navigateToAddExpense()
    {
        navigateToNextScreen(stoaryBoard: addExpenseDetailsSb, viewController: AddExpenseVcID)
    }
    
    private func navigateToEditExpense()
    {
        navigateToNextScreen(stoaryBoard: addExpenseDetailsSb, viewController:ExpenseListVcID )
    }
    
    private func navigateToAddActivityDetails()
    {
        self.navigateToNextScreen(stoaryBoard:attendanceActivitySb, viewController: AddAttendanceActivityVcID)
    }
    
    private func navigateToEditActiviytDetails()
    {
        self.navigateToNextScreen(stoaryBoard: attendanceActivitySb, viewController: ModifyActivityListVcID)
    }
    
    private func navigateToAddGeneralRemarks()
    {
         let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
         let vc = sb.instantiateViewController(withIdentifier: DCRGeneralRemarksVcID) as! DCRGeneralRemarksViewController
         vc.ifFromDCRAttendence = true
         self.navigationController?.pushViewController(vc, animated: true)
    }
    private func navigateToAdd_Details(){
        if(isManager())
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = doctorMasterVcID
            vc.isFromDCR = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
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
    
    private func navigateToEditGeneralRemarks()
    {
        let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DCRGeneralRemarksVcID) as! DCRGeneralRemarksViewController
        vc.isModifyPage = true
        vc.ifFromDCRAttendence = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func setSubmitViewHeightConst()
    {
        if BL_DCR_Attendance_Stepper.sharedInstance.activityList.count > 0 //&& //BL_DCR_Attendance_Stepper.sharedInstance.sfcList.count > 0
        {
            self.submitViewHgtConst.constant = 40
        }
        else
        {
            self.submitViewHgtConst.constant = 0
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
    
    func didSelectExpandableCell()
    {
        self.tableView.reloadData()
    }
    func removeDoctorButtonAction(sender: UIButton)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: "Do you want to delete \(appDoctor) ?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            let doctorId = 0
                //BL_DCR_Attendance_Stepper.sharedInstance.doctorList[sender.tag].doctorId
            
            BL_SampleProducts.sharedInstance.addInwardQty(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: doctorId)
            
            BL_SampleProducts.sharedInstance.addBatchInwardQty(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: doctorId, entityType: sampleBatchEntity.Attendance.rawValue)
            BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceDoctorVisit(doctorVisitId: doctorId)
            BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceDoctorSample(doctorVisitId: doctorId)
            
            BL_DCR_Attendance_Stepper.sharedInstance.getCurrentArray()
            self.reloadTableView()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    func didTapAddSampleBtn(sender: UIButton)
    {
//        let doctorSampleList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList[sender.tag].sampleList
        let doctorVistId = 0
        //BL_DCR_Attendance_Stepper.sharedInstance.doctorList[sender.tag].doctorId
        //convertAttendanceSampleToDCRSample
        let doctorAttendance = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: doctorVistId, dcrId: DCRModel.sharedInstance.dcrId)
        
        let sample_sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let sample_nc = sample_sb.instantiateViewController(withIdentifier: sampleDCRListVcID) as! SampleDetailsViewController
        sample_nc.currentList = BL_DCR_Attendance.sharedInstance.convertAttendanceSampleToDCRSample(list: doctorAttendance)
        sample_nc.sampleBatchList = [] //doctorSampleList
        sample_nc.isComingFromTpPage = false
        sample_nc.isComingFromAttendanceDoctor = true
        sample_nc.isComingFromModifyPage = true
        
        
//        sample_nc.doctorVisitId = BL_DCR_Attendance_Stepper.sharedInstance.doctorList[sender.tag].doctorId
        
        self.navigationController?.pushViewController(sample_nc, animated: true)
    }
}
