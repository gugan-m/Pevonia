//
//  MCListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 22/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class MCListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var saveBut : UIBarButtonItem!
    var mcList :[MCHeaderModel] = []
    var isFromMCEdit : Bool = false
    var isFromAttendance: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonView()
        self.tableView.estimatedRowHeight = 700
        if(!isFromMCEdit)
        {
            self.addSaveBtn()
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mcList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MCListTableViewCell") as! MCListTableViewCell
        let mcData = mcList[indexPath.row]
        cell.activityText.text = mcData.Campaign_Name
        cell.contentView.backgroundColor = UIColor.white
        if(!isFromMCEdit)
        {
            
            if(mcData.isSelected)
            {
                cell.selectionImageView.image = UIImage(named: "icon-check")
            }
            else
            {
                cell.selectionImageView.image = UIImage(named: "icon-uncheck")
            }
            if(mcData.isAdded)
            {
                cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                cell.selectionImageView.image = UIImage(named: "icon-check")
                
            }
        }
        else
        {
           cell.selectionImageView.image = UIImage(named: "")
        }
        //mcData.Campaign_Name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let mcData = mcList[indexPath.row]
        if(!isFromMCEdit)
        {
            
            for mcDatas in mcList
            {
                mcDatas.isSelected = false
            }
            
            mcData.isSelected = !mcData.isSelected
            self.tableView.reloadData()
        }
        else
        {
            let campaignCode = mcData.Campaign_Code
            var mcActivityList = DBHelper.sharedInstance.getMCActivityList(campaignCode:campaignCode!)
            var getDoctorMCActivityList : [DCRMCActivityCallType] = []
            if isFromAttendance
            {
                getDoctorMCActivityList = DBHelper.sharedInstance.getDoctorMcCallActivityList(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, campaignCode: campaignCode!, entityType: sampleBatchEntity.Attendance.rawValue)
            }
            else
            {
                getDoctorMCActivityList = DBHelper.sharedInstance.getDoctorMcCallActivityList(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, campaignCode: campaignCode!, entityType: sampleBatchEntity.Doctor.rawValue)
            }
            let mcFilterActivityList = getActivityObjListFormDoctor(mcActivityList: mcActivityList, doctorMCActivityList: getDoctorMCActivityList)
            if(mcFilterActivityList.count > 0)
            {
                let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ActivityListRemarkControllerID) as! ActivityListRemarkController
                vc.activityDataList = mcFilterActivityList
                vc.isFromCallActivityEdit = true
                vc.isFromMCActivity = true
                vc.mcCampaignCode = campaignCode!
                vc.mcCampaignName = mcData.Campaign_Name
                vc.isFromAttendance = isFromAttendance
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showAlertView(title: "Sorry", message: "No activity for \(mcData.Campaign_Name!)", viewController: self)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func getMCActivity(campaignCode:String)-> [ActivityListObj]
    {
        let mcActivityList = DBHelper.sharedInstance.getMCActivityList(campaignCode: campaignCode)
        
        
        var activityObjList:[ActivityListObj] = []
        
        for objMasterActivity in mcActivityList
        {
            
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = objMasterActivity.MC_Activity_Id
            objActivity.activityName = objMasterActivity.MC_Activity_Name
            
            activityObjList.append(objActivity)
        }
        
        return activityObjList
        
    }
    func getActivityObjList(mcActivityList: [MCActivityModel],doctorMCActivityList: [DCRMCActivityCallType]) -> [ActivityListObj]
    {
        var activityObjList:[ActivityListObj] = []
        let uniqueMcActivityList = mcActivityList.unique{
            $0.MC_Activity_Id
        }
        for objMasterActivity in uniqueMcActivityList
        {
            let filteredArray = doctorMCActivityList.filter{
                $0.MC_Activity_Id == objMasterActivity.MC_Activity_Id
            }
            
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = objMasterActivity.MC_Activity_Id
            objActivity.activityName = objMasterActivity.MC_Activity_Name
            objActivity.isAdded = false
            
            if (filteredArray.count > 0)
            {
                objActivity.isAdded = true
            }
            
            activityObjList.append(objActivity)
        }
        
        return activityObjList
    }
    
    func getActivityObjListFormDoctor(mcActivityList: [MCActivityModel],doctorMCActivityList: [DCRMCActivityCallType]) -> [ActivityListObj]
    {
        var activityObjList:[ActivityListObj] = []
       let uniqueMcActivityList = mcActivityList.unique{
            $0.MC_Activity_Id
        }
        for objMasterActivity in uniqueMcActivityList
        {
            let filteredArray = doctorMCActivityList.filter{
                $0.MC_Activity_Id == objMasterActivity.MC_Activity_Id
            }
            
            let objActivity: ActivityListObj = ActivityListObj()
            objActivity.activityId = objMasterActivity.MC_Activity_Id
            objActivity.activityName = objMasterActivity.MC_Activity_Name
            objActivity.isSelected = false
            objActivity.remarks = ""
            
            if (filteredArray.count > 0)
            {
                objActivity.isSelected = true
                objActivity.remarks = filteredArray[0].MC_Activity_Remarks
            }
            
            activityObjList.append(objActivity)
        }
        
        return activityObjList.filter{
            $0.isSelected == true
        }
    }
    
    //Mark:- Back Button
//    private func addBackButtonView()
//    {
//        let imgBackArrow = UIImage(named: "navigation-arrow")
//        
//        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
    
    func addSaveBtn()
    {
        
        saveBut = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItems = [saveBut]
    }
    
    @objc func saveAction()
    {
        let getSelectedList = mcList.filter{
            $0.isSelected == true
        }
        if(getSelectedList.count > 0)
        {
            let campaignCode = getSelectedList[0].Campaign_Code
            let mcActivityList = DBHelper.sharedInstance.getMCActivityList(campaignCode:campaignCode!)
            var getDoctorMCActivityList : [DCRMCActivityCallType] = []
            if isFromAttendance
            {
                getDoctorMCActivityList = DBHelper.sharedInstance.getDoctorMcCallActivityList(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, campaignCode: campaignCode!, entityType: sampleBatchEntity.Attendance.rawValue)
            }
            else
            {
                getDoctorMCActivityList = DBHelper.sharedInstance.getDoctorMcCallActivityList(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, campaignCode: campaignCode!, entityType: sampleBatchEntity.Doctor.rawValue)
            }
            let mcFilterActivityList = getActivityObjList(mcActivityList: mcActivityList, doctorMCActivityList: getDoctorMCActivityList)
            if(mcFilterActivityList.count > 0)
            {
                let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ActivityListRemarkControllerID) as! ActivityListRemarkController
                vc.activityDataList = mcFilterActivityList
                vc.isFromCallActivityEdit = false
                vc.isFromMCActivity = true
                vc.isFromAttendance = self.isFromAttendance
                vc.mcCampaignCode = campaignCode!
                vc.mcCampaignName = getSelectedList[0].Campaign_Name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showAlertView(title: "Sorry", message: "No activity for \(getSelectedList[0].Campaign_Name)", viewController: self)
            }
        }
        else
        {
            AlertView.showAlertView(title: "Sorry", message: "Please select to proceed" , viewController: self)
        }
    }
    
    
}
