//
//  TpReportDetailsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TpReportDetailsViewController: UIViewController,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource, NavigationDelegate
{
    //MARK:- Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarView: CornerRadiusWithShadowView!
    @IBOutlet weak var calendarViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var tpDateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leaveEntryLbl: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var leaveViewHgtConst: NSLayoutConstraint!

    @IBOutlet weak var headerView: CornerRadiusWithShadowView!
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    @IBOutlet weak var refreshBtn: UIButton!
    
    var dateList : [TpReportCalendarModel] = []
    var tpReportDataList : [TpReportListModel] = []
    var userObj : ApprovalUserMasterModel!
    var isMine :Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.calendarViewHgtConst.constant = 0
        self.updateTableView()
        addBackButtonView()
        print(userObj.Employee_Name)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Collection View Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.TpCalendarCell, for: indexPath) as! TpCalendarCollectionViewCell
        let calendarObj = dateList[indexPath.row]
        
        cell.dateLbl.text =  calendarObj.tpDate
        let day = NSString(string : calendarObj.tpDay).substring(to: 1) as NSString
        cell.dayLbl.text = day as String
        return cell
    }
    
    //MARK:- Set Default Details
    
    func setDefaultDetails()
    {
        self.emptyStateView.isHidden = true
        self.mainView.isHidden = false
        self.setDefaultHeight(type: userObj.Activity)
        self.setDateList()
        self.setTpHeaderDetails()
        self.getCurrentDataList()
    }

    func setDateList()
    {
        dateList = BL_TpReport.getDateList()
    }
    
    func setTpHeaderDetails()
    {
        self.title = "\(PEV_TOUR_PLAN) Details"
    }
    
    func getCurrentDataList()
    {
        var activityType : String = ""
        
        if userObj.Activity == DCRFlag.fieldRcpa.rawValue
        {
            self.getTpFieldDetails()
            activityType = DCRActivityName.fieldRcpa.rawValue
        }
        else if userObj.Activity == DCRFlag.attendance.rawValue
        {
            self.getTpAttendanceDetails()
            activityType = DCRActivityName.attendance.rawValue
        }
        else
        {
            activityType = DCRActivityName.leave.rawValue
            self.setLeaveEntryDetails()
        }
        
        let tpDate = convertDateIntoString(date: BL_TpReport.sharedInstance.tpDate)
        self.tpDateLbl.text = "\(activityType) - \(tpDate)"
        if(userObj.approvalStatus == TPStatus.unapproved.rawValue)
        {
        headerView.backgroundColor = TPCellColor.unApprovedBgColor.color
          statusLabel.text = unApproved
        }
        else if(userObj.approvalStatus == TPStatus.approved.rawValue)
        {
            headerView.backgroundColor = TPCellColor.approvedBgColor.color
           statusLabel.text = approved
        }
        else if(userObj.approvalStatus == TPStatus.applied.rawValue)
        {
            headerView.backgroundColor = TPCellColor.appliedBgColor.color
            statusLabel.text = applied
        }
        else if(userObj.approvalStatus == TPStatus.drafted.rawValue)
        {
            headerView.backgroundColor = TPCellColor.draftedBgColor.color
           statusLabel.text = drafted
        }
    }
    
    func getTpFieldDetails()
    {
        tpReportDataList = BL_TpReport.sharedInstance.getTpReportDataList()
        self.setDetailsToTpFieldList()
    }
    
  
    func getTpAttendanceDetails()
    {
        tpReportDataList = BL_TpReport.sharedInstance.getTpAttendanceDataList()
        self.setDetailsToTpAttendanceList()
    }
    
    func setDetailsToTpFieldList()
    {
    
        tpReportDataList[0].dataList = BL_TpReport.sharedInstance.getTpAccompanistDetails(userName: userObj.Employee_Name)
        tpReportDataList[1].dataList = BL_TpReport.sharedInstance.getTpWorkPlaceDetails(userName: userObj.Employee_Name)
        tpReportDataList[2].dataList = BL_TpReport.sharedInstance.getTpSFCDetails(userName: userObj.Employee_Name)
        if(userObj.approvalStatus == TPStatus.drafted.rawValue){
            tpReportDataList[3].dataList = BL_TpReport.sharedInstance.getTpDoctorDetails(userName: userObj.Employee_Name, type : 3, tpDate : BL_TpReport.sharedInstance.tpDate)
        }else{
            
            tpReportDataList[3].dataList = BL_TpReport.sharedInstance.getTpDoctorDetails(userName: userObj.Employee_Name, type : 2, tpDate : BL_TpReport.sharedInstance.tpDate)
        }
        self.reloadTableView()
        
    }
    
  
    func setDetailsToTpAttendanceList()
    {
        
        tpReportDataList[0].dataList = BL_TpReport.sharedInstance.getTpWorkPlaceDetails(userName: userObj.Employee_Name)
        tpReportDataList[1].dataList = BL_TpReport.sharedInstance.getTpSFCDetails(userName: userObj.Employee_Name)
        tpReportDataList[2].dataList = BL_TpReport.sharedInstance.getTpActivityDetails(userName: userObj.Employee_Name)
        
        self.reloadTableView()
    }
    
    func setLeaveEntryDetails()
    {

        let leaveList = BL_TpReport.sharedInstance.getTpLeaveDetails(userName: userObj.Employee_Name)
        
        if leaveList.count > 0
        {
            let dict = leaveList.firstObject as! NSDictionary
            
            self.leaveTypeLbl.text = dict.object(forKey: "Activity_Name") as? String
            self.leaveEntryLbl.text = convertDateIntoString(date: BL_TpReport.sharedInstance.tpDate)
        }
    }
    
    
    func setDefaultHeight(type : Int)
    {
        var tableViewHeight : CGFloat = 0
        var leaveViewHeight : CGFloat = 0
        
        
        if userObj.Activity == DCRFlag.fieldRcpa.rawValue || userObj.Activity == DCRFlag.attendance.rawValue
        {
            tableViewHeight = 150
            leaveViewHeight = 0
        }
        else
        {
            tableViewHeight = 0
            leaveViewHeight = 133
        }
  
        self.tableViewHeight.constant = tableViewHeight
        self.leaveViewHgtConst.constant = leaveViewHeight
    }
    
    //MARK:- TableView delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return tpReportDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let approvalObj = tpReportDataList[section]
        
        if userObj.Activity == DCRFlag.fieldRcpa.rawValue
        {
            if section == 2 {
                return 0
            } else {
                return 40
            }
        }
        else if userObj.Activity == DCRFlag.attendance.rawValue
        {
            if section == 1 {
                return 0
            } else {
                return 40
            }
        }
        
        if approvalObj.dataList.count > 0
        {
            if approvalObj.sectionType == TpReportSectionHeader.DoctorVisit
            {
                return 55
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportSectionHeaderCell) as! ApprovalSectionHeaderCell
        let tpObj = tpReportDataList[section]
        cell.titleLabel.text = tpObj.sectionTitle
        cell.subTitleLabel.text = ""
        cell.sectionImgWidthConst.constant = 30
        
        if tpObj.dataList.count > 0
        {
            if tpObj.sectionType == TpReportSectionHeader.DoctorVisit
            {
                cell.subTitleLabel.text = "\(tpObj.dataList.count) \(appDoctor) Visits"
            }
        }
        let icon = tpObj.titleImage
        cell.imgView.image = UIImage(named:icon)
        
        if userObj.Activity == DCRFlag.fieldRcpa.rawValue
        {
            if section == 2 {
                cell.titleLabel.isHidden = true
                cell.subTitleLabel.isHidden = true
                cell.imgView.isHidden = true
            } else {
                cell.titleLabel.isHidden = false
                cell.subTitleLabel.isHidden = false
                cell.imgView.isHidden = false
            }
        }
        else if userObj.Activity == DCRFlag.attendance.rawValue
        {
            if section == 1 {
                cell.titleLabel.isHidden = true
                cell.subTitleLabel.isHidden = true
                cell.imgView.isHidden = true
            } else {
                cell.titleLabel.isHidden = false
                cell.subTitleLabel.isHidden = false
                cell.imgView.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let tpDetail = tpReportDataList[indexPath.section]
        let dataList = tpDetail.dataList
        let defaultHeight : CGFloat = 4
        

        if tpDetail.dataList.count == 0
        {
            if userObj.Activity == DCRFlag.fieldRcpa.rawValue
            {
                if indexPath.section == 2 {
                   return 0
                } else {
                    return BL_TpReport.sharedInstance.getEmptyStateCellHeight()
                }
            }
            else if userObj.Activity == DCRFlag.attendance.rawValue
            {
                if indexPath.section == 1 {
                    return 0
                } else {
                    return BL_TpReport.sharedInstance.getEmptyStateCellHeight()
                }
            } else {
                return BL_TpReport.sharedInstance.getEmptyStateCellHeight()
            }
        }
        else
        {
            if tpDetail.sectionType == TpReportSectionHeader.Travel || tpDetail.attendanceSectionType == TpAttendanceSectionHeader.Travel
            {
                return BL_TpReport.sharedInstance.getSFCCellHeight(dataList: dataList) + defaultHeight
            }
            else if tpDetail.sectionType == TpReportSectionHeader.DoctorVisit
            {
                
                    return BL_TpReport.sharedInstance.getDoctorVisitCellHeight(dataList: dataList, type: 2) + defaultHeight
            }
            else if tpDetail.sectionType == TpReportSectionHeader.WorkPlace
            {
                let dataList  = BL_TpReport.sharedInstance.getWorkPlaceListModel(dict: tpDetail.dataList.firstObject as! NSDictionary , type : 1)
                return BL_TpReport.sharedInstance.getCommonHeightforWorkPlaceDetails(dataList: dataList) + defaultHeight
            }
            else if tpDetail.attendanceSectionType == TpAttendanceSectionHeader.WorkPlace
            {
                let dataList  = BL_TpReport.sharedInstance.getWorkPlaceListModel(dict: tpDetail.dataList.firstObject as! NSDictionary , type : 2)
                return BL_TpReport.sharedInstance.getCommonHeightforWorkPlaceDetails(dataList: dataList) + defaultHeight
            }
            else
            {
                var sectionType : Int = 0
                
                if userObj.Activity == DCRFlag.fieldRcpa.rawValue
                {
                    sectionType = tpDetail.sectionType.rawValue
                }
                else
                {
                    sectionType = tpDetail.attendanceSectionType.rawValue
                }
                
                if tpDetail.attendanceSectionType == TpAttendanceSectionHeader.Activity
                {
                    sectionType = 5
                }
                
                return BL_TpReport.sharedInstance.getCommonCellHeight(dataList: tpDetail.dataList , sectionType:sectionType) + defaultHeight
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let tpDetail = tpReportDataList[indexPath.section]

        if tpDetail.dataList.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportEmptyStateCell, for: indexPath) as! ApprovalEmptyStateTableViewCell
             cell.emptyStateTiltleLbl.text = tpDetail.emptyStateText
            if userObj.Activity == DCRFlag.fieldRcpa.rawValue
            {
                if indexPath.section == 2 {
                    cell.emptyStateTiltleLbl.isHidden = true
                } else {
                    cell.emptyStateTiltleLbl.isHidden = false
                }
            }
            else if userObj.Activity == DCRFlag.attendance.rawValue
            {
                if indexPath.section == 1 {
                    cell.emptyStateTiltleLbl.isHidden = true
                } else {
                    cell.emptyStateTiltleLbl.isHidden = false
                }
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportDetailInnerCell, for: indexPath) as! TpReportDetailsInnerTableViewCell
            cell.dataList = tpDetail.dataList
            cell.delegate = self
            var type : Int = 1
            
            if tpDetail.attendanceSectionType == TpAttendanceSectionHeader.WorkPlace
            {
                type = 2
            }
            
            cell.workPlaceList = BL_TpReport.sharedInstance.getWorkPlaceListModel(dict: tpDetail.dataList.firstObject as! NSDictionary,type: type)
            
            cell.sectionType = tpDetail.sectionType
            cell.attendanceSectionType = tpDetail.attendanceSectionType
            
            if  tpDetail.attendanceSectionType == TpAttendanceSectionHeader.Activity || tpDetail.sectionType == TpReportSectionHeader.Product
            {
                cell.sepHeightConst.constant = 0
            }
            
            cell.tableView.reloadData()
            
            return cell
        }
    }
    

    func reloadTableView()
    {
        self.tableView.reloadData()
        self.tableViewHeight.constant = self.tableView.contentSize.height
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
    
    func navigateToPlaylist() {
        navigateToAssetListScreen()
    }
    
    func navigateToAssetListScreen(){
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AssetParentVCID) as! AssetParentViewController
        vc.isComingFromTP = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func updateTableView()
    {
        if userObj.Employee_Name == "Mine"
        {
            self.setDefaultDetails()
        }
        else
        {
            if checkInternetConnectivity()
            {
                self.refreshBtn.isHidden = true
                self.showActivityIndicator()
                BL_TpReport.sharedInstance.getTPDataFromApi(userObj: userObj) {(apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        if BL_TpReport.sharedInstance.activityCount == 3 || BL_TpReport.sharedInstance.activityCount == 2 || BL_TpReport.sharedInstance.activityCount == 1
                        {
                            self.setDefaultDetails()
                          //self.tableView.reloadData()
                        }
                        
                    }
                    else
                    {
                       self.showEmptyStateView(message: apiResponseObj.Message)
                    }
                }
            }
            else
            {
                    AlertView.showNoInternetAlert()
            }
        }
    }
    
    func showActivityIndicator()
    {
        if self.mainView.isHidden == false
        {
            self.mainView.isHidden  == true
        }
        if self.emptyStateView.isHidden == true
        {
            self.emptyStateView.isHidden == false
            
        }
        self.emptyStateLabel.isHidden == true
        showCustomActivityIndicatorView(loadingText: "Loading PR Reports....")
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
        self.updateTableView()
    }
    func showEmptyStateView(message: String)
    {
        self.mainView.isHidden = true
        self.emptyStateView.isHidden = false
        self.emptyStateLabel.text = message
        self.refreshBtn.isHidden = false
        
    }
}
