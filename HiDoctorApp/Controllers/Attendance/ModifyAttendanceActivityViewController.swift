//
//  ModifyAttendanceActivityViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ModifyAttendanceActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    var addBtn : UIBarButtonItem!
    var doneBtn : UIBarButtonItem!
    
    var activityList : [DCRAttendanceActivityModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        addBackButtonView()
        self.getDCRActivityList()
        self.navigationItem.title = "Activity List"
        self.addBarButtonItem()
        self.navigationItem.rightBarButtonItems = [doneBtn , addBtn]
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activityList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let activityObj = activityList[indexPath.row]
        let defaultHeight : CGFloat = 48
        let bottomViewHeight : CGFloat = 60 + 10
        let activityNameLblHeight = getTextSize(text: activityObj.Activity_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 40).height
        
        return defaultHeight + bottomViewHeight + activityNameLblHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifyActivityListCell, for: indexPath) as! ModifyAttendanceActivityTableViewCell
        let activityObj = activityList[indexPath.row]
        let activityName = activityObj.Activity_Name! as String
        let startTime = activityObj.Start_Time as String
        let endTime = activityObj.End_Time as String
        let activityTime = "\(startTime) - \(endTime)"
        cell.activityNameLbl.text = activityName
        cell.activityTimeLbl.text = activityTime
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        return cell
    }
    
    
    @IBAction func modifyBtnAction(_ sender: UIButton) {
        let indexPath = (sender as AnyObject).tag
        let activityObj = activityList[indexPath!]
        self.navigateToModifyAttendanceActivityPage(activityObj: activityObj)
    }
    
    
    @IBAction func removeBtnAction(_ sender: UIButton) {
        let indexPath = (sender as AnyObject).tag
        let activityObj = activityList[indexPath!]
       let activityName = activityObj.Activity_Name! as String
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove activity \"\(activityName)\"?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeActivityDetails(activityObj: activityObj)
            self.activityList.remove(at: indexPath!)
            self.reloadTableView()
            showToastView(toastText: "Activity details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    func getDCRActivityList()
    {
        activityList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceActivities()!
        self.reloadTableView()
    }
    
    func navigateToModifyAttendanceActivityPage(activityObj :DCRAttendanceActivityModel)
    {
        let sb = UIStoryboard(name: attendanceActivitySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddAttendanceActivityVcID) as! AddAttendanceActivityViewController
        vc.isComingFromModifyPage = true
        vc.modifyActivityObj = activityObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   @objc func addAttendanceBtnAction()
   {
    let sb = UIStoryboard(name:attendanceActivitySb, bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: AddAttendanceActivityVcID)
    self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func removeActivityDetails(activityObj : DCRAttendanceActivityModel)
    {
       BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceActivity(dcrAttendanceActivityId: activityObj.DCR_Attendance_Id)
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    func reloadTableView()
    {
        if self.activityList.count > 0
        {
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
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
    
    
    func addBarButtonItem()
    {
        addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addAttendanceBtnAction))
        doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.backButtonClicked))
    }
    
    
}
