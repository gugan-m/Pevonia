//
//  ReportsViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/12/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    var reportsList = NSMutableArray()
    var liveTrackerForManager = "Live Field Users Report"
    var geoLocationReport = "Geo Location Report"
    var liveTrackerReport = "Live Tracker Report"
    var userperdayreport = "User per day report"
    var tourplannerreport = "\(PEV_TOUR_PLAN) report"
    
    var traveltrackingreport = "Travel Tracking Report"
    
    
    
    var approvalMenu : [MenuMasterModel] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableData()
        addBackButtonView()
        self.title = "Reports"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableData()
    {
        reportsList =
            [
                [
                    "icon" : "icon-report-tp",
                    "reportText" : "\(PEV_TOUR_PLAN) report"
                ],
                [
                    "icon" : "icon-doctor",
                    "reportText" : "User per day report"
                ]
        ]
        checkIsToAddHourlyReport()
//        if (MenuIDs.traveltrackingreport.rawValue == 34){
//           checkIsLiveTrackingReport()
//        }
        
//        if(isManager){
//            checkIsLiveTrackingReport()
//        }
        
        let userDetail = DBHelper.sharedInstance.getUserDetail()
        if (userDetail?.appUserFlag == 1)
        {
           // manager flow
            checkIsLiveTrackingReport()
        }
        else
        {
            
        }
        
            
        checkIsToAddGeoLocatioReport()
        checkIsLiveTrackingChart()
    }
    
    func checkIsToAddHourlyReport()
    {
        if BL_Reports.sharedInstance.checkIsIfHourlyReportExistInMenu()
        {
            let dict = [
                "icon" : "icon-report-hourly",
                "reportText" : "Live Tracker Report"
            ]
            reportsList.add(dict)
        }
    }
    
    func checkIsLiveTrackingReport()
    {
        if BL_Reports.sharedInstance.checkIsIfTraveltrackingreportExistInMenu()
        {
            let dict = [
                "icon" : "icon-report-hourly",
                "reportText" : "Travel Tracking Report"
            ]
            reportsList.add(dict)
        }
    }
    
    func checkIsToAddGeoLocatioReport()
    {
        if BL_Reports.sharedInstance.checkIsIfGeoLocationReportExistInMenu()
        {
            let dict = [
                "icon" : "ic_maps_marker",
                "reportText" : geoLocationReport
            ]
            reportsList.add(dict)
        }
    }
   func checkIsLiveTrackingChart()
   {
        if BL_Reports.sharedInstance.checkIsIfLiveTrackForManagerReportExistInMenu()
        {
            let dict = [
                "icon" : "icon-report-hourly",
                "reportText" : liveTrackerForManager
            ]
            reportsList.add(dict)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reportsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ReportsCell, for: indexPath) as! ReportsTableViewCell
        let dict = reportsList.object(at: indexPath.row) as? NSDictionary
        cell.iconImg.image = UIImage(named: (dict?["icon"] as? String)!)
        cell.textLbl.text = dict?["reportText"] as? String
        cell.nextRightArrow.image = UIImage(named: "icon-right-arrow")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        let reportData = self.reportsList[indexPath.row] as! NSDictionary
        
        if((reportData.value(forKey:"reportText")as! String == tourplannerreport && isManager()) || (reportData.value(forKey:"reportText")as! String == userperdayreport && isManager()))
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ReportsUserListVcID) as! ReportsUserListViewController
            if(reportData.value(forKey:"reportText")as! String == tourplannerreport)
            {
                vc.isComingFromTpPage = true
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(reportData.value(forKey:"reportText")as! String == userperdayreport ||  reportData.value(forKey:"reportText")as! String == tourplannerreport)
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.UserPerDayReportsVcID) as! UserPerDayReportsViewController
            if(reportData.value(forKey:"reportText")as! String == tourplannerreport)
            {
             vc.isComingFromTpPage = true
            }
            let userObj = BL_Reports.sharedInstance.getMineObject()
            let dict : ApprovalUserMasterModel = ApprovalUserMasterModel()
            dict.User_Code = userObj?.User_Code
            dict.User_Type_Name = userObj?.User_Type_Name
            dict.User_Name = userObj?.User_Name
            dict.Employee_Name = userObj?.Employee_name
            dict.Region_Name = userObj?.Region_Name
            dict.Region_Code = userObj?.Region_Code
            
            vc.userList = dict
            vc.isMine  = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if(reportData.value(forKey:"reportText")as! String == liveTrackerReport)
        {
            UserDefaults.standard.set("1", forKey: "GeoCheck")
            UserDefaults.standard.synchronize()
            
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDateVcID) as! HourlyReportDateViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(reportData.value(forKey:"reportText")as! String == traveltrackingreport)
        {
            UserDefaults.standard.set("1", forKey: "GeoCheck")
            UserDefaults.standard.synchronize()
    
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TravelTrackingReportDateVcID) as! TravelTrackingReportViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
            
        else if(reportData.value(forKey:"reportText")as! String == geoLocationReport)
        {
            
            UserDefaults.standard.set("2", forKey: "GeoCheck")
            UserDefaults.standard.synchronize()

            
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.GeoReportDateVcID) as! GeoReportDateViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(reportData.value(forKey:"reportText")as! String == liveTrackerForManager)
        {
            
            UserDefaults.standard.set("1", forKey: "GeoCheck")
            UserDefaults.standard.synchronize()
            
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ChartReportDataVcID) as! ChartReportDataViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
//        if (indexPath.row == 1 && isManager()) || (indexPath.row == 0 && isManager())
//        {
//            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ReportsUserListVcID) as! ReportsUserListViewController
//            if indexPath.row == 0
//            {
//                vc.isComingFromTpPage = true
//            }
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if indexPath.row == 0 || indexPath.row == 1
//        {
//            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.UserPerDayReportsVcID) as! UserPerDayReportsViewController
//            if indexPath.row == 0
//            {
//                vc.isComingFromTpPage = true
//            }
//
//            let userObj = BL_Reports.sharedInstance.getMineObject()
//            let dict : ApprovalUserMasterModel = ApprovalUserMasterModel()
//            dict.User_Code = userObj?.User_Code
//            dict.User_Type_Name = userObj?.User_Type_Name
//            dict.User_Name = userObj?.User_Name
//            dict.Employee_Name = userObj?.Employee_name
//            dict.Region_Name = userObj?.Region_Name
//            dict.Region_Code = userObj?.Region_Code
//
//            vc.userList = dict
//            vc.isMine  = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if (indexPath.row == 2)
//        {
//            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDateVcID) as! HourlyReportDateViewController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else if (indexPath.row == 3)
//        {
//            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.GeoReportDateVcID) as! GeoReportDateViewController
//            self.navigationController?.pushViewController(vc, animated: true)
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
