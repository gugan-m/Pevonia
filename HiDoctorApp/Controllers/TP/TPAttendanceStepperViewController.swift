//
//  TPAttendanceStepperViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPAttendanceStepperViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitViewHgtConst: NSLayoutConstraint!
    
    // MARK:- Variables
    var pickerView = UIPickerView()
    var selectedActivity = ""
    var generalRemarks = ""
    var activityList : [ProjectActivityMaster] = []
    var stepperDataList: [DCRStepperModel] = []
    var projectObj : ProjectActivityMaster?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        removeVersionToastView()
        pickerView.delegate = self
        self.setSubmitViewHeightConst()
        addBackButtonView()
        self.title = convertDateIntoString(date: TPModel.sharedInstance.tpDate) + " (Office)"
        activityList = BL_DCR_Attendance.sharedInstance.getProjectActivityList()!
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.TPAttendanceStepperReload()
    }
    
    func TPAttendanceStepperReload()  {
        BL_TP_AttendanceStepper.sharedInstance.clearAllArray()
               BL_TP_AttendanceStepper.sharedInstance.generateDataArray()
               reloadTableView()
               selectedActivity = BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name ?? ""
        if selectedActivity.count == 0 && activityList.count != 0 {
            selectedActivity = activityList[0].Activity_Name
        }
        
               generalRemarks = BL_TP_AttendanceStepper.sharedInstance.generalRemarks
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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TPAttendanceTVCell) as! TPAttendanceTableViewCell
//
//        // Round View
//        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
//        cell.roundView.layer.masksToBounds = true
//        cell.stepperNumberLabel.text = String(indexPath.row + 1)
//
//        // Vertical view
//        cell.verticalView.isHidden = false
//        if (indexPath.row == BL_TP_AttendanceStepper.sharedInstance.stepperDataList.count - 1)
//        {
//            cell.verticalView.isHidden = true
//        }
//
//        let rowIndex = indexPath.row
//        var objStepperModel: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[rowIndex]
//
//        cell.selectedIndex = rowIndex
//
//        cell.cardView.isHidden = true
//        cell.emptyStateView.isHidden = true
//        cell.emptyStateView.clipsToBounds = true
//
//        if (objStepperModel.recordCount == 0)
//        {
//            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
//            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
//            if indexPath.row == 0 {
//                cell.emptyStateAddButton.isHidden = false
//            } else {
//               if BL_TP_AttendanceStepper.sharedInstance.stepperDataList[0].recordCount != 0 {
//                    cell.emptyStateAddButton.isHidden = false
//                } else {
//                    cell.emptyStateAddButton.isHidden = true
//                }
//            }
//            cell.emptyStateView.isHidden = false
//            cell.cardView.isHidden = true
//            cell.cardView.clipsToBounds = true
//            cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
//        }
//        else if objStepperModel.recordCount > 0
//        {
//            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
//            cell.emptyStateView.isHidden = true
//            cell.cardView.isHidden = false
//            cell.cardView.clipsToBounds = false
//            cell.rightButton.isHidden = false
//            cell.leftButton.isHidden = true
//            cell.parentTableView = tableView
//            cell.childTableView.reloadData()
//
//            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
//            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
//
//            cell.commonSectionTitleHeightConstraint.constant = 30
//            cell.sectionTitleView.isHidden = false
//        }
//
//        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
//        cell.sectionToggleImageView.isHidden = true
//        cell.sectionToggleImageView.clipsToBounds = true
//
//        if (objStepperModel.recordCount > 1)
//        {
//            if (objStepperModel.isExpanded == true)
//            {
//                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
//            }
//            else
//            {
//                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
//            }
//
//            cell.sectionToggleImageView.isHidden = false
//            cell.sectionToggleImageView.clipsToBounds = false
//        }
//
//        cell.moreView.isHidden = true
//        cell.moreView.clipsToBounds = true
//        cell.moreViewHeightConstraint.constant = 0
//        cell.buttonViewHeight.constant = 20
//
//        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > 1)
//        {
//            cell.moreView.isHidden = false
//            cell.moreView.clipsToBounds = false
//            cell.moreViewHeightConstraint.constant = 20
//        }
//        else
//        {
//            cell.buttonViewHeight.constant = 20
//        }
//
//        cell.sectionCoverButton.tag = rowIndex
//        cell.leftButton.tag = rowIndex
//        cell.rightButton.tag = rowIndex
//        cell.emptyStateAddButton.tag = rowIndex
//
//        return cell
//    }
    
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
        let alertMessage =  "Your PR Plan for Office is ready to submit in Applied status. Once submit you cannot edit your PR Plan.\n\n Press 'OK' to submit PR Plan.\n OR \n Press 'Cancel'."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: CANCEL, style: UIAlertActionStyle.default, handler: { alertAction in
            
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
        let alertMessage =  "Your PR Plan for Office is ready to be submitted to your Manager.\n\n Click 'Upload' to submit.\nClick 'Later' to submit later\n\nAlternatively,you can use 'Routing Upload'option from the PR Calendar screen to submit."
        
        let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: true)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "Upload", style: UIAlertActionStyle.default, handler: { alertAction in
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
    
//    @IBAction func emptyStateAddBtnAction(_ sender: AnyObject)
//    {
//        addNewEntry(index: sender.tag)
//    }
    
    @IBAction func AddBtnAction(_ sender: AnyObject)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func modifyBtnAction(_ sender: AnyObject)
    {
        modifyEntry(index: sender.tag)
    }
    
//    @IBAction func SectionExpandBtnAction(_ sender: UIButton)
//    {
//        let index = sender.tag
//        let stepperObj = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[index]
//
//        if (stepperObj.recordCount > 1)
//        {
//            stepperObj.isExpanded = !stepperObj.isExpanded
//            reloadTableViewAtIndexPath(index: index)
//        }
//    }
    
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled() {
            switch index
            {
            case 0: break
               // navigateToAddWorkPlaceDetails()
                // navigateToAddActivityDetails()
            case 1:
              //  navigateToAddTravelPlace()
                navigateToAddGeneralRemarks()//
            case 2: break
              //  navigateToAddActivityDetails()
            case 3:
               // navigateToAddGeneralRemarks()
                break
            default:
                print(1)
            }
        } else {
            switch index
            {
            case 0: break
            case 1:
                navigateToAddGeneralRemarks()
               // navigateToAddActivityDetails()
            case 2:
                break
                //navigateToAddGeneralRemarks()
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
            case 0: break
                //navigateToEditWorkPlaceDetails()
               // navigateToEditActiviytDetails()
            case 1:
                //navigateToEditTravelPlace()
                navigateToEditGeneralRemarks()
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
            case 0: break
               // navigateToEditWorkPlaceDetails()
               // navigateToEditActiviytDetails()
            case 1:
               // navigateToEditActiviytDetails()
                navigateToEditGeneralRemarks()
            case 2: break
               // navigateToEditGeneralRemarks()
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
      self.submitViewHgtConst.constant = 40
//      if  BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled() {
//        if (checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name) != EMPTY && BL_TP_AttendanceStepper.sharedInstance.placesList.count > 0)
//        {
//            self.submitViewHgtConst.constant = 40
//        }
//        else
//        {
//            self.submitViewHgtConst.constant = 0
//        }
//           } else {
//        if (checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Category_Name) != EMPTY && checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name) != EMPTY)
//        {
//            self.submitViewHgtConst.constant = 40
//        }
//        else
//        {
//            self.submitViewHgtConst.constant = 0
//        }
//        }
        
        
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


extension TPAttendanceStepperViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return BL_TP_AttendanceStepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPAttendanceActivityCell")  as! TPAttendanceActivityCell
            cell.txtselectActivity.inputView = self.pickerView
            cell.txtselectActivity.text = selectedActivity
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPAttendanceRemarkCell")  as! TPAttendanceRemarkCell
            cell.remarkTxtView.text = generalRemarks
            cell.remarkTxtView.layer.cornerRadius = 5.0
            cell.remarkTxtView.layer.borderWidth = 0.5
            cell.remarkTxtView.layer.borderColor = UIColor.lightGray.cgColor
            cell.remarkTxtView.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
              return 60
            } else {
           return  120
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPAttendanceHeaderCell") as! TPAttendanceHeaderCell
        let hdrObj = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[section]
        cell.lblHeaderTitle.text = hdrObj.sectionTitle
        cell.lblHeaderSubTitle.text = ""
        cell.lblCount.text = "\(section + 1)"
        if hdrObj.recordCount == 0 {
            cell.bgRoundView.backgroundColor = UIColor.lightGray
        } else {
            cell.bgRoundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPAttendanceFooterCell") as! TPAttendanceFooterCell
        cell.leftBtn.tag = section
        cell.rightBtn.tag = section
        cell.leftBtn.setTitle("Add Remarks", for: .normal)
        cell.rightBtn.setTitle("Edit", for: .normal)
        if section == 1 {
            if generalRemarks.count != 0 {
                cell.leftBtn.isHidden = true
                cell.rightBtn.isHidden = false
            } else {
                cell.leftBtn.isHidden = false
                cell.rightBtn.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 0
    }
}

extension TPAttendanceStepperViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityList[row].Activity_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedActivity = activityList[row].Activity_Name
        let dict:NSDictionary = ["Activity_Code":activityList[row].Activity_Code,"Activity_Name":activityList[row].Activity_Name,"Project_Code":activityList[row].Project_Code!,"Project_Name":EMPTY]
        
        projectObj = ProjectActivityMaster(dict: dict)
        BL_TP_AttendanceStepper.sharedInstance.updateAttendanceActivity(objActivity: projectObj!)
        self.TPAttendanceStepperReload()
    }
}

extension TPAttendanceStepperViewController : UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
         let str = "\(textView.text!)"
               BL_TP_AttendanceStepper.sharedInstance.updateRemarksDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, remarks: str)
               return true
    }
    
}
