//
//  DashBoardPendingApprovalViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/24/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashBoardPendingApprovalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    var pendingList : [ApprovalUserMasterModel] = []
    var isComingFromTeamPage : Bool = false
    var isMine : Bool = true
    var userCode : String = ""
    var regionCode : String = ""
    
    var dashboardAppliedList :[DashBoardAppliedCount] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.emptyStateLbl.text = ""
        self.getApprovalDetails()
        self.navigationItem.title = "Pending For Approval Dates"
    }
    
    func getApprovalDetails()
    {
//        if isComingFromTeamPage
//        {
//            getTeamAppliedDates()
//        }
//        else
//        {
//            getAppliedDCRDates()
//        }
    }
    
    func getTeamAppliedDates()
    {
        showCustomActivityIndicatorView(loadingText: "Loading...")
        
        if checkInternetConnectivity()
        {
            self.navigationItem.title = "\(PEV_DCR) Pending Approval"
            BL_Dashboard.sharedInstance.getAppliedDCRDates(userCode: userCode, regionCode: regionCode)
            {
                (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list = self.getSortedAppliedList(list: self.convertToApprovalMasterModel(list: apiResponseObj.list))
                    self.checkEmpty(list: list)
                    self.setEmptyStateLblTxt(text: "No pending \(PEV_DCR) available for approval")
                    self.reloadTableViewData()
                }
                else
                {
                    self.showMessageForApiReponse(apiResponseObj: apiResponseObj)
                }
                removeCustomActivityView()
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
        
    }
    
    
    func getAppliedDCRDates()
    {
        let list = getSortedAppliedList(list: convertDCRHeaderToCommonModel(list: BL_Dashboard.sharedInstance.getAppliedDCRDatesFromLocal(userCode: getUserCode(), regionCode: getRegionCode(), isSelf: true)))
        checkEmpty(list: list)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dashboardAppliedList.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var activityName : String = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: UnApprovalListCell, for: indexPath) as! UnApprovalListTableViewCell
        let dict = dashboardAppliedList[indexPath.row]
        if dict.Flag == "F"
        {
            cell.listIconImg.image = UIImage(named: "icon-stepper-work-area")
            activityName = "Field"
        }
        else if dict.Flag == "L"
        {
            cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Not Working"
        }
        else if dict.Flag == "A"
        {
            cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Office"
        }
        let dateStr = convertDateIntoString(date: getDateStringInFormatDate(dateString:  dict.Applied_Date, dateFormat: defaultServerDateFormat))
        
        cell.listContentLbl.text = dateStr + " - " + activityName
        cell.selectList.image = UIImage(named: "icon-right-arrow")
       
            cell.selectionViewWidth.constant = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        if !isComingFromTeamPage
//        {
//            let detailObj = pendingList[indexPath.row]
//            self.navigateUserPerDay(detailObj: detailObj)
//        }
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func checkEmpty(list: [ApprovalUserMasterModel])
    {
        if list.count > 0
        {
            pendingList = list
            showEmptyStateView(show: false)
            //self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    func getSortedAppliedList(list : [ApprovalUserMasterModel]) -> [ApprovalUserMasterModel]
    {
        var sortedList : [ApprovalUserMasterModel] = []
        
        sortedList = list.sorted(by: {
            $0.Actual_Date > $1.Actual_Date
        })
        return sortedList
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
    
    
    func convertDCRHeaderToCommonModel(list : [DashboardDateDetailsModel]) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            
            let dateString = convertDateIntoServerStringFormat(date: obj.Activity_Date)
            
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString:  dateString, dateFormat: defaultServerDateFormat))
            userObj.Activity = obj.Activity
            userObj.Region_Code = getRegionCode()
            userObj.DCR_Status = "Applied"
            userObj.User_Name = getUserName()
            userObj.User_Code = getUserCode()
            userObj.Employee_Name = "Mine"
            currentList.append(userObj)
        }
        
        return currentList
    }
    
    func convertToApprovalMasterModel(list : NSArray) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        for obj in list
        {
            let dict = obj as! NSDictionary
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            
            let dateString = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Date") as? String)
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString:  dateString, dateFormat: defaultServerDateFormat))
            userObj.Activity = dict.object(forKey: "Activity") as? Int
            currentList.append(userObj)
        }
        return currentList
    }
    
    
    func navigateUserPerDay(detailObj: ApprovalUserMasterModel)
    {
        DCRModel.sharedInstance.dcrId = detailObj.Activity_Id
        
        var isApplied : Bool = false
        
        let dcrCode = checkNullAndNilValueForString(stringData: detailObj.DCR_Code)
        
        if isMine && dcrCode == ""
        {
            isApplied = true
        }
        
        if detailObj.Activity == DCRFlag.attendance.rawValue
        {
            if !isApplied && !checkInternetConnectivity()
            {
                AlertView.showNoInternetAlert()
            }
            else
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonAttendanceDetailsVcID) as! CommonApprovalAttendanceControllerViewController
                detailObj.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                detailObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.userObj = detailObj
               // vc.isMine = isApplied
                vc.isCmngFromReportPage = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else if detailObj.Activity == DCRFlag.leave.rawValue
        {
            if !isApplied  && !checkInternetConnectivity()
            {
                AlertView.showNoInternetAlert()
            }
            else
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonLeaveApprovalVcID) as! CommonLeaveApprovalViewController
                detailObj.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                detailObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.isCmngFromReportPage = true
               // vc.isMine = isApplied
                vc.userObj = detailObj
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            if !isApplied  && !checkInternetConnectivity()
            {
                AlertView.showNoInternetAlert()
            }
            else
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonApprovalDetailsVcID) as! ApprovalDetailsViewController
                detailObj.Entered_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                detailObj.Actual_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.isCmngFromReportPage = true
              //  vc.isMine = isApplied
                vc.userObj = detailObj
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func reloadTableViewData()
    {
        self.tableView.reloadData()
    }
    
    func showMessageForApiReponse(apiResponseObj : ApiResponseModel)
    {
        if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
        {
            
            self.showEmptyStateView(show: true)
            setEmptyStateLblTxt(text: "No Internet Connection")
        }
        else
        {
            var emptyStateText : String = apiResponseObj.Message
            self.showEmptyStateView(show: true)
            
            if emptyStateText == ""
            {
                emptyStateText = "Unable to fetch pending approval data."
            }
            else
            {
                setEmptyStateLblTxt(text: emptyStateText)
            }
        }
    }
    
    func setEmptyStateLblTxt(text : String)
    {
        self.emptyStateLbl.text = text
    }
    
}
class DashBoardPendingMonthApprovalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    
    var dashBoardListArray: [NSDictionary] = []
    
    var dashboardAppliedList :[DashBoardAppliedCount] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        getMontList()
        self.emptyStateLbl.text = ""
        self.navigationItem.title = "Pending For Approval Months"
    }
    
    func getMontList()
    {
        var uniqueMonths: [Date] = []
        var monthNum:[Int] = []
        
        for objDashboardApplied in dashboardAppliedList
        {
            if (!uniqueMonths.contains(objDashboardApplied.appliedDate))
            {
                let month = getMonthNumberFromDate(date: objDashboardApplied.appliedDate)
//                if(!monthNum.contains(month))
//                {
//                    monthNum.append(month)
                    uniqueMonths.append(objDashboardApplied.appliedDate)
              //  }
            }
        }
            
            uniqueMonths.sort(by: { (date1, date2) -> Bool in
                date1 > date2
            })
        for date in uniqueMonths
        {
            let month = getMonthNumberFromDate(date: date)
            let year = getYearFromDate(date: date)
            let monthName = getMonthName(monthNumber: month) + " " + String(year)
            
            var dataArray = dashboardAppliedList.filter{
                 $0.month == month && $0.year == year
            }
            
            dataArray = dataArray.sorted(by: { (obj1, obj2) -> Bool in
                obj1.appliedDate < obj2.appliedDate
            })
            
            let dict: NSDictionary = ["Month_Name": monthName, "Data_Array": dataArray]
            if(!dashBoardListArray.contains(dict))
            {
                dashBoardListArray.append(dict)
            }
        }
        self.tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashBoardListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UnApprovalListCell, for: indexPath) as! UnApprovalListTableViewCell
        let dict: NSDictionary = dashBoardListArray[indexPath.row]
        cell.listContentLbl.text = (dict.value(forKey: "Month_Name") as! String)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingApprovalVcID) as! DashBoardPendingApprovalViewController
        let dict: NSDictionary = dashBoardListArray[indexPath.row]
        vc.dashboardAppliedList = (dict.value(forKey: "Data_Array") as! [DashBoardAppliedCount])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
