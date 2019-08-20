//
//  ChartDoctorListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ChartDoctorListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    var doctorCountList : [DoctorCountDataModel] = []
    var isNonVist = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for doctorData in doctorCountList
        {
            if(doctorData.User_Code == getUserCode())
            {
                doctorData.Employee_Name = "Mine"
            }
        }
        if(!isNonVist)
        {
            doctorCountList = doctorCountList.filter
                {
                    $0.Visit_Count > 0
            }
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.estimatedRowHeight = 500
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorCountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartDoctorListCell") as! ChartDoctorListTableViewCell
        cell.userName.text = doctorCountList[indexPath.row].Employee_Name as String
        if(!self.isNonVist)
        {
            cell.countLabel.text = String(doctorCountList[indexPath.row].Visit_Count)
        }
        else
        {
            cell.countLabel.isHidden = true
        }
        
        // cell.description.text =
        var userName = doctorCountList[indexPath.row].User_Name!
        var regionName = doctorCountList[indexPath.row].Region_Name!
        var userType =  doctorCountList[indexPath.row].User_Type_Name!
        
        if(userName != EMPTY)
        {
            userName = "\(userName) | "
        }
        if(regionName != EMPTY)
        {
            regionName  = "\(regionName)"
        }
        if(userType != EMPTY)
        {
            userType = "\(userType) | "
        }
        cell.descriptionLabel.text = userName + userType + regionName
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!isNonVist)
        {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportVcID) as! ShowHourlyReportViewController
        vc.selectedDate = BL_MasterDataDownload.sharedInstance.getCurrentDate()
        vc.selectedEmployeeName = doctorCountList[indexPath.row].Employee_Name
        vc.selectedUserCode = doctorCountList[indexPath.row].User_Code
        vc.isComingFromGeo = false
        vc.geoDoctorList = []
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
