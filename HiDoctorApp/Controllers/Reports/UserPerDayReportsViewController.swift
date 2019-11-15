//  UserPerDayReportsViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/16/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class UserPerDayReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    var isMine : Bool = false
    var userList : ApprovalUserMasterModel!
    var userPerDayList : [ApprovalUserMasterModel] = []
    var isComingFromTpPage : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.hideView()
        self.setCurrentList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setCurrentList()
    {
        if isComingFromTpPage
        {
            self.getUserTpList()
        }
        else
        {
            self.userPerList()
        }
    }
    
    
    func getUserTpList()
    {
        self.title = "\(PEV_TOUR_PLAN) Reports"
        if isMine
        {

        let tpList = BL_Reports.sharedInstance.getTpList()
        userPerDayList = getSortedAppliedList(list: convertTpHeaderToCommonModel(list : tpList))
            self.emptyStateLbl.text = "No offline and Online PR(s) are available"
        checkEmpty(list: userPerDayList)
        }
        else
        {
            if checkInternetConnectivity()
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
                BL_Reports.sharedInstance.getTpHeaderDetailsData(userObj: userList, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                       self.userPerDayList = self.getSortedAppliedList(list: self.convertTPHeaderToCommonModel(list: apiResponseObj.list))
                       self.emptyStateLbl.text = "No PR(s) are available"
                       self.checkEmpty(list: self.userPerDayList)
                    }
                    else
                    {
                        self.emptyStateLbl.text =  "Check your network and try again"
                        self.showEmptyStateView(show: true)
                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
            
        }
    }
    
    func userPerList()
    {
        self.title = "User Per Day Reports"

        if isMine
        {
            userPerDayList = getSortedAppliedList(list: convertDCRHeaderToCommonModel(list: BL_Reports.sharedInstance.getAppliedDCRs()))
            self.emptyStateLbl.text = "No offline and Online DVR(s) are available"
            checkEmpty(list: userPerDayList)
        }
        else
        {
            if checkInternetConnectivity()
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
                BL_Reports.sharedInstance.getDCRHeaderDetailsV59Report(userObj: userList, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        self.userPerDayList = self.getSortedAppliedList(list: self.convertDcrToCommonHeaderModel(list: apiResponseObj.list))
                        self.emptyStateLbl.text = "No DVR(s) are available"
                        self.checkEmpty(list: self.userPerDayList)
                    }
                    else
                    {
                        self.emptyStateLbl.text =  "Check your network and try again"
                        self.showEmptyStateView(show: true)
                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    func getSortedAppliedList(list : [ApprovalUserMasterModel]) -> [ApprovalUserMasterModel]
    {
        let sortList = list.sorted(by: {
            $0.actualDate < $1.actualDate
        })
        return sortList
    }
    
    func converDCRHeaderModel(list: NSArray) -> [DCRHeaderModel]?
    {
        var DCRHeaderList : [DCRHeaderModel] = []
        if list.count > 0
        {
            for listObj in list
            {
                let dict = listObj as! NSDictionary
                
                let obj : NSDictionary = ["DCR_Id" : dict.object(forKey: "DCR_Id") as! Int ,"DCR_Actual_Date": dict.object(forKey: "DCR_Actual_Date") as! String
                    , "Dcr_Entered_Date" : dict.object(forKey: "Dcr_Entered_Date") as! String , "Flag" : dict.object(forKey: "Flag") as! Int ,"DCR_Code" :  dict.object(forKey: "DCR_Code") as! String , "DCR_Status" : dict.object(forKey: "DCR_Status") as! String ]
                
                let employeeObj : DCRHeaderModel = DCRHeaderModel(dict: obj)
                DCRHeaderList.append(employeeObj)
            }
        }
        return DCRHeaderList
    }
    
    func convertDcrToCommonHeaderModel(list : NSArray) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            
            let dict = obj as! NSDictionary
            
            userObj.Activity_Id = dict.object(forKey: "DCR_Id") as! Int
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: dict.object(forKey: "DCR_Actual_Date") as! String , dateFormat: defaultServerDateFormat))
             userObj.actualDate = getStringInFormatDate(dateString: dict.object(forKey: "DCR_Actual_Date") as! String)
            
            if let enteredDate = dict.object(forKey: "Dcr_Entered_Date") as? String
            {
                userObj.Entered_Date =  convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: enteredDate , dateFormat: defaultServerDateFormat))
            }
            
            //dict.object(forKey: "Dcr_Entered_Date") as! String
            userObj.Activity = dict.object(forKey: "Flag") as! Int
            userObj.DCR_Code = dict.object(forKey: "DCR_Code") as! String
            userObj.DCR_Status = dict.object(forKey: "DCR_Status") as! String
            currentList.append(userObj)
        }
        
        return currentList
    }
    func convertTPHeaderToCommonModel(list : NSArray) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            let dict = obj as! NSDictionary
            if(dict.object(forKey: "TP_Id") as! Int != 0)
            {
            userObj.Activity_Id = dict.object(forKey: "TP_Id") as! Int
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: dict.object(forKey: "TP_Date") as! String , dateFormat: defaultServerDateFormat))
            userObj.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: dict.object(forKey: "TP_Date") as! String , dateFormat: defaultServerDateFormat))
            userObj.actualDate = convertDateIntoString(dateString: dict.object(forKey: "TP_Date") as! String)
            let tpCode = dict.object(forKey: "TP_Id") as! Int
            userObj.DCR_Code = String(describing: tpCode)
            userObj.approvalStatus = dict.object(forKey: "TP_Status") as! Int
             let activityValue = dict.object(forKey: "Activity") as! Int
            userObj.Activity = Int(activityValue)
            currentList.append(userObj)
            }
        }
        
        return currentList
    }
    func convertDCRHeaderToCommonModel(list : [DCRHeaderModel]) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            
            userObj.Activity_Id = obj.DCR_Id
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: obj.DCR_Actual_Date)
            if userObj.Entered_Date != nil
            {
            userObj.Entered_Date = convertDateIntoServerStringFormat(date: obj.DCR_Entered_Date)
            }
            userObj.actualDate = getServerFormattedDate(date: obj.DCR_Actual_Date)
            userObj.Activity = obj.Flag
            userObj.DCR_Code = obj.DCR_Code
            userObj.DCR_Status = obj.DCR_Status
            currentList.append(userObj)
        }
        
        return currentList
    }
    
    func convertTpHeaderToCommonModel(list : [TourPlannerHeader]) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            
            userObj.Activity_Id = obj.TP_Entry_Id
            userObj.Actual_Date = convertDateIntoServerStringFormat(date: obj.TP_Date)
            userObj.Entered_Date = convertDateIntoServerStringFormat(date: obj.TP_Date)
            userObj.actualDate = getServerFormattedDate(date: obj.TP_Date)
            userObj.Activity = obj.Activity
            userObj.DCR_Code = ""
            userObj.approvalStatus = obj.Status
            currentList.append(userObj)
        }
        
        return currentList
    }
    
    func checkEmpty(list: [ApprovalUserMasterModel])
    {
        if list.count > 0
        {
            showEmptyStateView(show: false)
            self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userPerDayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var activityName : String = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: UnApprovalListCell, for: indexPath) as! UnApprovalListTableViewCell
        let dict = userPerDayList[indexPath.row]
        let dcrCode = checkNullAndNilValueForString(stringData: dict.DCR_Code)
        if dcrCode != ""
        {
            cell.isLocal.image = UIImage(named: "icon-cloud")
        }
        else
        {
            cell.isLocal.image = UIImage(named: "")
        }
        
        if dict.Activity == 1
        {
            cell.listIconImg.image = UIImage(named: "icon-stepper-work-area")
            activityName = "Field"
        }
        else if dict.Activity == 3
        {
            cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Not Working"
        }
        else if dict.Activity == 2
        {
            cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Office"
        }
        let actualDate = convertDateIntoString(date: getDateStringInFormatDate(dateString: dict.Actual_Date , dateFormat: defaultServerDateFormat))
        cell.listContentLbl.text = actualDate + " - " + activityName
        cell.selectList.image = UIImage(named: "icon-right-arrow")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailObj = userPerDayList[indexPath.row]
        DCRModel.sharedInstance.dcrDateString = detailObj.Actual_Date
        DCRModel.sharedInstance.userDetail = userList
        
        //let dcrCode = checkNullAndNilValueForString(stringData: detailObj.DCR_Code)
        let dcrCode = checkNullAndNilValueForString(stringData: detailObj.DCR_Code) as? String
        if dcrCode != ""
        {
            if checkInternetConnectivity()
            {
                showCustomActivityIndicatorView(loadingText: authenticationTxt)
                
                BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    
                    if apiResponseObj.list.count > 0
                    {
                        if self.isComingFromTpPage
                        {
                            self.setNavigationToTpReport(detailObj: detailObj)
                        }
                        else
                        {
                            self.setNavigationForUserPerDay(detailObj: detailObj)
                        }
                    }
//                    else
//                    {
//                        AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else
        {
            if self.isComingFromTpPage
            {
                self.setNavigationToTpReport(detailObj: detailObj)
            }
            else
            {
                self.setNavigationForUserPerDay(detailObj: detailObj)
            }
        }
    }
    
    func setNavigationToTpReport(detailObj : ApprovalUserMasterModel)
    {
        //let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
       // DCRModel.sharedInstance.dcrId = detailObj.Activity_Id
        
        //userObj.User_Code = userList.User_Code
        //userObj.Region_Code = userList.Region_Code
        //userObj.Employee_Name = userList.Employee_name
        //userObj.Activity = detailObj.Activity
        
        userList.Activity = detailObj.Activity
        userList.approvalStatus = detailObj.approvalStatus
        let date = convertDateIntoString(dateString: detailObj.Actual_Date)
        BL_TpReport.sharedInstance.tpDate = date
        BL_TpReport.sharedInstance.tpId = 0
        BL_TpReport.sharedInstance.tpId = detailObj.Activity_Id
    
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.TpReportSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TpReportDetailsVcID) as! TpReportDetailsViewController
            userList.Entered_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Entered_Date , dateFormat: defaultServerDateFormat))
            userList.Actual_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
            vc.userObj = userList
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setNavigationForUserPerDay(detailObj : ApprovalUserMasterModel)
    {
        DCRModel.sharedInstance.dcrId = detailObj.Activity_Id
        
        var isApplied : Bool = false
        
        let dcrCode = checkNullAndNilValueForString(stringData: detailObj.DCR_Code)
        
        if isMine && dcrCode == ""
        {
            isApplied = true
        }
        userList.DCR_Status = detailObj.DCR_Status
        userList.Activity_Id = detailObj.Activity

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
                userList.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                userList.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.userObj = userList
                vc.isMine = isApplied
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
                userList.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                userList.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.isCmngFromReportPage = true
                
                vc.isMine = isApplied
                vc.userObj = userList
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
                if detailObj.Entered_Date != nil
                {
                userList.Entered_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Entered_Date , dateFormat: defaultServerDateFormat))
                }
                userList.Actual_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
                vc.isCmngFromReportPage = true
                vc.isMine = isApplied
                vc.userObj = userList
                self.navigationController?.pushViewController(vc, animated: true)
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

    func hideView()
    {
        self.contentView.isHidden = true
        self.emptyStateView.isHidden = true
    }
}
