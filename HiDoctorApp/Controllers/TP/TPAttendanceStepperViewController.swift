//
//  TPAttendanceStepperViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPAttendanceStepperViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitViewHgtConst: NSLayoutConstraint!
    
    // MARK:- Variables
    var stepperDataList: [DCRStepperModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        removeVersionToastView()
        
        self.setSubmitViewHeightConst()
        addBackButtonView()
        self.title = convertDateIntoString(date: TPModel.sharedInstance.tpDate) + " (Office)"
        
        BL_TP_AttendanceStepper.sharedInstance.clearAllArray()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        BL_TP_AttendanceStepper.sharedInstance.generateDataArray()
        
        reloadTableView()
        
        if (BL_TP_AttendanceStepper.sharedInstance.isSFCUpdated)
        {
            BL_TP_AttendanceStepper.sharedInstance.isSFCUpdated = false
            
            showToastView(toastText: "Your SFC updated")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        setSubmitViewHeightConst()
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
        return BL_TP_AttendanceStepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_TP_AttendanceStepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if (index == 0 || index == 2)
            {
                if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                    return BL_TP_AttendanceStepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
                } else {
                    if index == 0 {
                         return BL_TP_AttendanceStepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
                    } else {
                        return BL_TP_AttendanceStepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
                    }
                }
            }
            else if (index == 1)
            {
                if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                    return BL_TP_AttendanceStepper.sharedInstance.getSFCCellHeight(selectedIndex: index)
                } else {
                    return BL_TP_AttendanceStepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
                }
                
            }
            else if (index == 3)
            {
                if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                     return BL_TP_AttendanceStepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
                } else {
                    return 0
                }
               
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: TPAttendanceTVCell) as! TPAttendanceTableViewCell
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_TP_AttendanceStepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        
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
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
            
            cell.commonSectionTitleHeightConstraint.constant = 30
            cell.sectionTitleView.isHidden = false
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
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        
        return cell
    }
    
    //MARK: - Button Action
    
    @IBAction func submitDCRBtnAction(_ sender: AnyObject)
    {
        let errorMessage = BL_TP_AttendanceStepper.sharedInstance.doSubmitTPValidations()
        
        if (errorMessage != EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: errorMessage, viewController: self)
        }
        else
        {
            showAlertToConfirmAppliedMode()
        }
    }
    
    func showAlertToConfirmAppliedMode()
    {
        let alertMessage =  "Your Offline Office is ready to submit in Applied status. Once submit you can not edit your PR.\n\n Press 'OK' to submit PR.\n OR \n Press 'Cancel'."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            BL_TP_AttendanceStepper.sharedInstance.submitTP()
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                self.showAlertToUploadTP()
            }
            else
            {
                _ = self.navigationController?.popViewController(animated: true)
            }

        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showAlertToUploadTP()
    {
        let alertMessage =  "Your Offline Office is ready to submit to your manager.\n\n Click 'Upload' to submit Office.\nClick 'Later' to submit later\n\nAlternatively,you can use 'Routing Upload'option from the PR calendar screen to submit your applied Office."
        
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
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPUploadSelectVCID)
        self.navigationController?.pushViewController(vc, animated: false)
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
        let stepperObj = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[index]
        
        if (stepperObj.recordCount > 1)
        {
            stepperObj.isExpanded = !stepperObj.isExpanded
            reloadTableViewAtIndexPath(index: index)
        }
    }
    
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled() {
            switch index
            {
            case 0:
                navigateToAddWorkPlaceDetails()
            case 1:
                navigateToAddTravelPlace()
            case 2:
                navigateToAddActivityDetails()
            case 3:
                navigateToAddGeneralRemarks()
            default:
                print(1)
            }
        } else {
            switch index
            {
            case 0:
                navigateToAddWorkPlaceDetails()
            case 1:
                navigateToAddActivityDetails()
            case 2:
                navigateToAddGeneralRemarks()
            default:
                print(1)
            }
        }
    }
    
    private func modifyEntry(index: Int)
    {
        if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled() {
            switch index
            {
            case 0:
                navigateToEditWorkPlaceDetails()
            case 1:
                navigateToEditTravelPlace()
            case 2:
                navigateToEditActiviytDetails()
            case 3:
                navigateToEditGeneralRemarks()
            default:
                print(1)
            }
        } else {
            switch index
            {
            case 0:
                navigateToEditWorkPlaceDetails()
            case 1:
                navigateToEditActiviytDetails()
            case 2:
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
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPWorkPlaceDetailVCID) as! TPWorkPlaceDetailViewController
        vc.isComingFromTPAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditWorkPlaceDetails()
    {
        navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPWorkPlaceDetailVCID)
    }
    
    private func navigateToAddTravelPlace()
    {
        BL_TP_SFC.sharedInstance.fromPlace = EMPTY
        BL_TP_SFC.sharedInstance.toPlace = EMPTY

        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPTravelDetailsVCID) as! TPTravelDetailsViewController
        vc.isFromTPAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditTravelPlace()
    {
        let tbStepperSB = UIStoryboard(name: TourPlannerSB, bundle: nil)
        let tpTravel_vc = tbStepperSB.instantiateViewController(withIdentifier: TPTravelListVcId) as! TPTravelDetailListViewController
        //tpTravel_vc.isComingFromModify = true
        self.navigationController?.pushViewController(tpTravel_vc, animated: true)
    }
    
    private func navigateToAddActivityDetails()
    {
        self.navigateToNextScreen(stoaryBoard:TPStepperSb, viewController: TPAttendanceActivityVCID)
    }
    
    private func navigateToEditActiviytDetails()
    {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPAttendanceActivityVCID) as! TPAttendanceActivityViewController
        vc.isComingFromModify = true
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func setSubmitViewHeightConst()
    {
        
      if  BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled() {
        if (checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name) != EMPTY && BL_TP_AttendanceStepper.sharedInstance.placesList.count > 0)
        {
            self.submitViewHgtConst.constant = 40
        }
        else
        {
            self.submitViewHgtConst.constant = 0
        }
           } else {
        if (checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name) != EMPTY)
        {
            self.submitViewHgtConst.constant = 40
        }
        else
        {
            self.submitViewHgtConst.constant = 0
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
}
