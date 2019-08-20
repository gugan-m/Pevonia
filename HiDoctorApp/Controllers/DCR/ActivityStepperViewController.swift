//
//  ActivityStepperViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ActivityStepperViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var stepperIndex: ActivityStepperIndex!
    var isFromAttendance: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.loadTableView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BL_Activity_Stepper.sharedInstance.isFromAttendance = isFromAttendance
        BL_Activity_Stepper.sharedInstance.generateDataArray()
        self.tableView.reloadData()
    }
    
//    private func addBackButtonView()
//    {
//        
//        
//        let imgBackArrow = UIImage(named: "navigation-arrow")
//        
//        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
    
    func loadTableView()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: Constants.NibNames.StepperTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.StepperMainCell)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_Activity_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.StepperMainCell) as! ChemistDayStepperMain
        
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        cell.isFromActivity = true
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_Activity_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        
        let objStepperModel: DCRStepperModel = BL_Activity_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        
        cell.accompEmptyStateView.isHidden = true
        
        if (objStepperModel.recordCount == 0)
        {
            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
            
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
            cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            cell.emptyStateView.isHidden = false
            cell.cardView.isHidden = true
            cell.cardView.clipsToBounds = true
            
            if objStepperModel.showEmptyStateAddButton == true
            {
                cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            }
            else
            {
                cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            }
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
            cell.isFromActivity = true
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
        }
        
        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
        cell.sectionToggleImageView.isHidden = true
        cell.sectionToggleImageView.clipsToBounds = true
        
        var checkRecordCount = 1
        
        if (objStepperModel.recordCount > checkRecordCount)
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
        //        if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
        //        {
        //            cell.moreView.isHidden = true
        //            cell.moreViewHeightConstraint.constant = 0
        //            cell.sectionCoverButton.isHidden = true
        //            cell.coverBtnWidthConst.constant = 0.0
        //            if rowIndex == stepperIndex.accompanistIndex
        //            {
        //                cell.buttonViewHeight.constant = 0
        //                cell.leftButton.isHidden = true
        //                cell.rightButton.isHidden = true
        //            }
        //            else if rowIndex == stepperIndex.detailedProduct
        //            {
        //                cell.buttonViewHeight.constant = 40
        //                cell.leftButton.isHidden = false
        //                cell.rightButton.isHidden = false
        //            }
        //        }
        //        else
        //        {
        cell.leftButton.isHidden = false
        cell.rightButton.isHidden = false
        
        cell.sectionCoverButton.isHidden = false
        cell.coverBtnWidthConst.constant = SCREEN_WIDTH - 56.0
        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > checkRecordCount)
        {
            cell.moreView.isHidden = false
            cell.moreView.clipsToBounds = false
            cell.moreViewHeightConstraint.constant = 20
        }
        else
        {
            cell.buttonViewHeight.constant = 40
        }
        //  }
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        cell.emptyStateSkipButton.tag = rowIndex
        cell.emptyStateAddButton.addTarget(self, action: #selector(emptyStateAddButton(button:)), for: .touchUpInside)
        cell.emptyStateSkipButton.addTarget(self, action: #selector(emptyStateSkipButton(button:)), for: .touchUpInside)
        cell.sectionCoverButton.addTarget(self, action: #selector(coverButton(button:)), for: .touchUpInside)
        cell.leftButton.addTarget(self, action: #selector(emptyStateAddButton(button:)), for: .touchUpInside)
        cell.rightButton.addTarget(self, action: #selector(modifyAction(button:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_Activity_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_Activity_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
            
        else
        {
            if index == 0
            {
                return BL_Activity_Stepper.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
            else
            {
                return BL_Activity_Stepper.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
        }
    }
    
    @objc func emptyStateAddButton(button: UIButton){
        if (button.tag == 0)
        {
            //navigate to call activity Screen
            self.navigateToActivity()
        }
        else if (button.tag == 1)
        {
            //navigate to MC activity Screen
            self.navigateToMCActivity()
        }
        
    }
    
    @objc func emptyStateSkipButton(button: UIButton){
        switch button.tag
        {
        case 0:
            BL_Activity_Stepper.sharedInstance.skipIndex = button.tag + 1
            BL_Activity_Stepper.sharedInstance.generateDataArray()
            self.tableView.reloadData()
            break
            
        default:
            BL_Activity_Stepper.sharedInstance.skipIndex = 0
            break
            
        }
    }
    
    @objc func coverButton(button: UIButton)
    {
        if (button.tag == 0 || button.tag == 1)
        {
            let stepperObj = BL_Activity_Stepper.sharedInstance.stepperDataList[button.tag]
            
            if (stepperObj.recordCount > 1)
            {
                stepperObj.isExpanded = !stepperObj.isExpanded
                reloadTableViewAtIndexPath(index: button.tag)
            }
        }
        
    }
    
    @objc func modifyAction(button: UIButton){
        if (button.tag == 0)
        {
            //navigate to call activity Screen
            self.navigateToModifyActivity()
        }
        else if (button.tag == 1)
        {
            //navigate to MC activity Screen
            self.navigateToMCActivityModify()
        }
        
    }
    
    //Add Activity
    private func navigateToActivity()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ActivityListRemarkControllerID) as! ActivityListRemarkController
        vc.isFromAttendance = self.isFromAttendance
        let getActivityList = DBHelper.sharedInstance.getCallActivity()
        var getDoctorActivity: [DCRActivityCallType] = []
        if isFromAttendance
        {
           getDoctorActivity = DBHelper.sharedInstance.getCallActivityList(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Attendance.rawValue)
        }
        else
        {
            getDoctorActivity = DBHelper.sharedInstance.getCallActivityList(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Doctor.rawValue)
        }
        
        let activityDataList = getActivityObjList(activityList: getActivityList,doctorActivityList: getDoctorActivity)
        vc.activityDataList = activityDataList
        vc.isFromCallActivityEdit = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func navigateToModifyActivity()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ActivityListRemarkControllerID) as! ActivityListRemarkController
        let getActivityList = DBHelper.sharedInstance.getCallActivity()
        var getDoctorActivity: [DCRActivityCallType] = []
        vc.isFromAttendance = self.isFromAttendance
        if isFromAttendance
        {
            getDoctorActivity = DBHelper.sharedInstance.getCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Attendance.rawValue)
        }
        else
        {
            getDoctorActivity = DBHelper.sharedInstance.getCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Doctor.rawValue)
        }
        
        let activityDataList = getActivityObjListFormDoctor(activityList: getActivityList,doctorActivityList: getDoctorActivity)
        vc.activityDataList = activityDataList
        vc.isFromCallActivityEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MCListViewController
    private func navigateToMCActivity()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MCListViewControllerID) as! MCListViewController
        let mcList = DBHelper.sharedInstance.getMCList(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
        if isFromAttendance
        {
        vc.mcList = getMCActivityList(mcActivityList:mcList,doctorMCActivityList: DBHelper.sharedInstance.getMcCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Attendance.rawValue))
        }
        else
        {
        vc.mcList = getMCActivityList(mcActivityList:mcList,doctorMCActivityList: DBHelper.sharedInstance.getMcCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Doctor.rawValue))
        }
        vc.isFromMCEdit = false
        vc.isFromAttendance = isFromAttendance
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToMCActivityModify()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MCListViewControllerID) as! MCListViewController
        let mcList = DBHelper.sharedInstance.getMCList(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
        if isFromAttendance
        {
            vc.mcList = getDoctorMCActivity(doctorMCActivityList:DBHelper.sharedInstance.getMcCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Attendance.rawValue),mcActivityList:mcList)
            vc.isFromAttendance = isFromAttendance
        }
        else
        {
            vc.mcList = getDoctorMCActivity(doctorMCActivityList:DBHelper.sharedInstance.getMcCallActivityList(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitCode: DCRModel.sharedInstance.customerVisitId, entityType: sampleBatchEntity.Doctor.rawValue),mcActivityList:mcList)
        }
        
        vc.isFromMCEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getMCActivityList(mcActivityList:[MCHeaderModel],doctorMCActivityList:[DCRMCActivityCallType]) -> [MCHeaderModel]
    {
        for objMasterActivity in mcActivityList
        {
            let filteredArray = doctorMCActivityList.filter{
                $0.Campaign_Code == objMasterActivity.Campaign_Code
            }
            if (filteredArray.count > 0)
            {
            objMasterActivity.isAdded = false
            }
        }
        
        let uniqueMcActivity = mcActivityList.unique{
            $0.Campaign_Code
        }
        
        return uniqueMcActivity
    }
    
    func getDoctorMCActivity(doctorMCActivityList:[DCRMCActivityCallType],mcActivityList:[MCHeaderModel]) -> [MCHeaderModel]
    {
        var activityObjList:[MCHeaderModel] = []
        
        for objMasterActivity in mcActivityList
        {
            let filteredArray = doctorMCActivityList.filter{
                $0.Campaign_Code == objMasterActivity.Campaign_Code
            }
            
            if (filteredArray.count > 0)
            {
                let activityDict:NSDictionary = ["Campaign_Code": objMasterActivity.Campaign_Code, "Campaign_Name": objMasterActivity.Campaign_Name]
                let objActivity: MCHeaderModel = MCHeaderModel(dict: activityDict)
                
                activityObjList.append(objActivity)
            }
        }
        
        for mcobj in doctorMCActivityList
        {
            let activityDict:NSDictionary = ["Campaign_Code": mcobj.Campaign_Code, "Campaign_Name": mcobj.Campaign_Name]
            let objActivity: MCHeaderModel = MCHeaderModel(dict: activityDict)
            
            activityObjList.append(objActivity)
        }
        
        activityObjList = activityObjList.unique{
            $0.Campaign_Code
        }
        
        return activityObjList
    }
    
    func getActivityObjList(activityList: [CallActivity],doctorActivityList: [DCRActivityCallType]) -> [ActivityListObj]
    {
        var activityObjList:[ActivityListObj] = []
        
        for objMasterActivity in activityList
        {
            let filteredArray = doctorActivityList.filter{
                $0.Customer_Activity_ID == objMasterActivity.Call_Activity_Id
            }
            
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = objMasterActivity.Call_Activity_Id
            objActivity.activityName = objMasterActivity.Activity_Name
            objActivity.isAdded = false
            
            if (filteredArray.count > 0)
            {
                objActivity.isAdded = true
            }
            
            activityObjList.append(objActivity)
        }
        
        return activityObjList
    }
    
    func getActivityObjListFormDoctor(activityList: [CallActivity],doctorActivityList: [DCRActivityCallType]) -> [ActivityListObj]
    {
        var activityObjList:[ActivityListObj] = []
        
        for objMasterActivity in activityList
        {
            let filteredArray = doctorActivityList.filter{
                $0.Customer_Activity_ID == objMasterActivity.Call_Activity_Id
            }
            
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = objMasterActivity.Call_Activity_Id
            objActivity.activityName = objMasterActivity.Activity_Name
            objActivity.isSelected = false
            objActivity.remarks = ""
            
            if (filteredArray.count > 0)
            {
                objActivity.isSelected = true
                objActivity.remarks = filteredArray[0].Activity_Remarks
            }
            
            activityObjList.append(objActivity)
        }
        
        for activityObj in doctorActivityList
        {
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = activityObj.Customer_Activity_ID
            objActivity.activityName = activityObj.Customer_Activity_Name
            objActivity.isSelected = true
            objActivity.remarks = activityObj.Activity_Remarks
            
            activityObjList.append(objActivity)
            
        }
        
        return activityObjList.unique{
            $0.activityId
        }
        
    }
    
    func getDCRCustomerCode()-> String
    {
        return DCRModel.sharedInstance.customerCode
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
        
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
}
