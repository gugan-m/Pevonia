//
//  TPAttendanceActivityViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPAttendanceActivityViewController: UIViewController ,selectedActivityListDelegate
{
    //MARK:- Outlet
    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    //MARK:- Variable
    let placeHolderForActivityName : String = "Select activity"
    var projectObj : ProjectActivityMaster?
    var modifyActivityObj : TourPlannerHeader?
    var isComingFromModify : Bool = false
    
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.updateActivityName()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setActivityDetails()
    }
    
    override func viewWillDisappear(_ animated : Bool)
    {
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK:- Activity Selection
    @IBAction func activityBtnAction(_ sender: UIButton)
    {
        let sb = UIStoryboard.init(name: attendanceActivitySb, bundle: nil)
        let nc = sb.instantiateViewController(withIdentifier: ActivityListVcID) as! ActivityListViewController
        nc.delegate = self
        nc.isComingForTPAttendance = true
        self.navigationController?.pushViewController(nc, animated: false)
    }
    
    //MARK:- Save Activity
    @IBAction func saveBtnAction(_ sender: UIButton)
    {
        if activityNameLbl.text == "" || activityNameLbl.text == placeHolderForActivityName
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select Activity", viewController: self)
        }
        else
        {
            BL_TP_AttendanceStepper.sharedInstance.updateAttendanceActivity(objActivity: projectObj!)
            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK:- Custom Button Functions
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
    
    //MARK:- Updating Activity
    func updateActivityName()
    {
        if isComingFromModify == true
        {
            modifyActivityObj = BL_TP_AttendanceStepper.sharedInstance.objTPHeader
            let dict:NSDictionary = ["Activity_Code":modifyActivityObj?.Activity_Code,"Activity_Name":modifyActivityObj?.Activity_Name,"Project_Code":modifyActivityObj?.Project_Code!,"Project_Name":EMPTY]
            
            projectObj = ProjectActivityMaster(dict: dict)
        }
        else
        {
            activityNameLbl.text = placeHolderForActivityName
        }
    }
    
    func getSelectedActivityListDelegate(obj : ProjectActivityMaster)
    {
        projectObj = obj
    }
    
    func setActivityDetails()
    {
        if projectObj != nil
        {
            self.activityNameLbl.text = projectObj?.Activity_Name!
        }
    }
}
