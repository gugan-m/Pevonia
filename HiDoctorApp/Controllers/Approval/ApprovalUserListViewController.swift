//
//  ApprovalUserListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/28/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,searchResultListDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var emptyStateImg: UIImageView!
    @IBOutlet weak var emptyStateSecLbl: UILabel!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var customerStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var customerStatusView: UIView!
    
    @IBOutlet weak var customerStatusLbl: UILabel!
    @IBOutlet weak var customerStatusSwitch: UISwitch!
    var refreshControl: UIRefreshControl!
    var appUserList : [ApprovalUserMasterModel] = []
    var sectionMenu : [Character] = []
    var contentMenuList = NSMutableArray()
    var menuId : Int = Int()
    var searchList : [ApprovalUserMasterModel] = []
    var currentList : [ApprovalUserMasterModel] = []
    var searchType : Bool = true
    var searchText : String = EMPTY
    var searchUserType: Int  = 1
    var customerStatus: Int = 2
    var clearBut : UIBarButtonItem!
    var isSearch : Bool = false
    var searchRegionType = Int()
    var textField: UITextField?
    var monthDatePicker : MonthYearPickerView!
    var selectedMonth = Int()
    var selectedYear = Int()
    var fromDate = String()
    var toDate = String()
    var currentYear = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerStatusSwitch.isHidden = true
        self.customerStatusLbl.isHidden = true
        addBackButtonView()
        self.addTapGestureForView()
        self.pullDownRefresh()
        self.searchView.isHidden = true
        self.addSearchButton()
        isSearch = false
        setMontPicker()
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.endRefresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //hide applied and approved switch view based on MenuID
        if(menuId == MenuIDs.DoctorApproval.rawValue)
        {
            customerStatusViewHeight.constant = 43
            self.customerStatusSwitch.isHidden = false
            self.customerStatusLbl.isHidden = false
            
            if(customerStatus == 2)
            {
                customerStatusLbl.text = "Show Approved \(appDoctor)"
                customerStatusSwitch.setOn(false, animated: true)
            }
            else
            {
                customerStatusLbl.text = "Show Applied \(appDoctor)"
                customerStatusSwitch.setOn(true, animated: true)
            }
        }
        else
        {
            customerStatusViewHeight.constant = 0
            self.customerStatusSwitch.isHidden = true
            self.customerStatusLbl.isHidden = true
        }
        self.setDefaults(value:1)
        
    }
    func setDefaults(value:Int)
    {
        if searchText == EMPTY
        {
            self.navigationApiCall(type: value)
        }
        else
        {
            if(customerStatus == 2)
            {
                customerStatusLbl.text = "Show Approved \(appDoctor)"
                customerStatusSwitch.setOn(false, animated: true)
            }
            else
            {
                customerStatusLbl.text = "Show Applied \(appDoctor)"
                customerStatusSwitch.setOn(true, animated: true)
            }
            self.searchApiCall()
        }
    }
    func navigationApiCall(type : Int)
    {
        if checkInternetConnectivity()
        {
//            if type != 2
//            {
//                showCustomActivityIndicatorView(loadingText: "Loading...")
//            }
            switch menuId
            {
            case 8:
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_DCR) Approval"
                    BL_MenuAccess.sharedInstance.getDCRUserWiseListApiCall
                        {
                            (apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                                self.sectionArray(list: self.appUserList)
                                self.setEmptyStateLblTxt(text: "None of your direct reporting users are having pending DVR(s) for approval. Please click on search button to search your ALL Hierarchy Users")
                                self.endRefresh()
                                self.reloadTableView()
                                if type == 2
                                {
                                    self.showSuccessToast()
                                }
                            }
                            else
                            {
                                self.searchView.isHidden = true
                                self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                            }
                            removeCustomActivityView()
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                    
                }
            case 9:
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_TP) Approval"
                    // self.isComingFromTpPage = true
                    BL_MenuAccess.sharedInstance.getTPUserWiseListApiCall
                        {
                            (apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                                self.sectionArray(list: self.appUserList)
                                self.setEmptyStateLblTxt(text:"None of your direct reporting users are having pending \(PEV_TP)(s) for approval. Please click on search button to search your ALL Hierarchy Users")
                                self.endRefresh()
                                self.reloadTableView()
                                if type == 2
                                {
                                    self.showSuccessToast()
                                }
                            }else
                            {
                                self.searchView.isHidden = true
                                self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                            }
                            removeCustomActivityView()
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            case 11:
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_DCR) Lock Release"
                    BL_MenuAccess.sharedInstance.getLockReleaseUserWiseListApiCall
                        {
                            (apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                                self.sectionArray(list: self.appUserList)
                                self.endRefresh()
                                self.reloadTableView()
                                if type == 2
                                {
                                    self.showSuccessToast()
                                }
                            }
                            else
                            {
                                self.searchView.isHidden = true
                                self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                            }
                            removeCustomActivityView()
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
                
            case 21:
                if checkInternetConnectivity()
                {
                    if(searchRegionType == 0)
                    {
                       self.navigationItem.title = "All Reporting Regions"
                    }
                    else
                    {
                        self.navigationItem.title = "My Direct Reporting Regions"
                    }
                    BL_MenuAccess.sharedInstance.getPendingDoctorApprovalUserList(customerStatus:customerStatus,searchType:searchRegionType)
                    {
                        (apiResponseObj) in
                        if apiResponseObj.Status == SERVER_SUCCESS_CODE
                        {
                            if(apiResponseObj.list.count > 0)
                            {
                                self.customerStatusViewHeight.constant = 43
                                self.customerStatusSwitch.isHidden = false
                                self.customerStatusLbl.isHidden = false
                                self.searchView.isHidden = false
                            }
                            else
                            {
                                self.customerStatusViewHeight.constant = 43
                                self.customerStatusSwitch.isHidden = false
                                self.customerStatusLbl.isHidden = false
                            }
                            self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            if(self.customerStatus == 2)
                            {
                                self.setEmptyStateLblTxt(text: "None of your reporting users are having pending \(appDoctor)(s) for approval.")
                            }
                            else if(self.customerStatus == 1)
                            {
                               self.setEmptyStateLblTxt(text: "None of your reporting users are having approved \(appDoctor)(s).")
                            }
                            
                            self.endRefresh()
                            self.reloadTableView()
                            if type == 2
                            {
                                self.showSuccessToast()
                            }
                        }
                        else
                        {
                            self.customerStatusViewHeight.constant = 0
                            self.customerStatusSwitch.isHidden = true
                            self.customerStatusLbl.isHidden = true
                            self.searchView.isHidden = true
                            self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                        }
                        removeCustomActivityView()
                    }
                }
            case 28:
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_DCR) Activity Lock Release"
                    BL_MenuAccess.sharedInstance.getActivityLockReleaseUserWiseListApiCall
                        {
                            (apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                                self.sectionArray(list: self.appUserList)
                                self.endRefresh()
                                self.reloadTableView()
                                if type == 2
                                {
                                    self.showSuccessToast()
                                }
                            }
                            else
                            {
                                self.searchView.isHidden = true
                                self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                            }
                            removeCustomActivityView()
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            case 29:
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_TP) Unfreeze"
                    BL_MenuAccess.sharedInstance.getTPUnfreezeReleaseUserWiseListApiCall
                        {
                            (apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                                self.sectionArray(list: self.appUserList)
                                self.endRefresh()
                                self.reloadTableView()
                                if type == 2
                                {
                                    self.showSuccessToast()
                                }
                            }
                            else
                            {
                                self.searchView.isHidden = true
                                self.showMessageForApiReponse(apiResponseObj: apiResponseObj, type: type)
                            }
                            removeCustomActivityView()
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
                
            default:
                break
            }
        }
        else
        {
            if type == 2
            {
                endRefresh()
                showToastView(toastText: "No Internet Connection. Please try again.")
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    func sectionArray(list: [ApprovalUserMasterModel])
    {
        contentMenuList = NSMutableArray()
        sectionMenu = []
        if list.count > 0
        {
            for contentList in list
            {
                let empName = String(contentList.User_Name.capitalized)
                if !sectionMenu.contains((empName.first)!)
                {
                    sectionMenu.append((empName.first!))
                }
            }
            sectionMenu.sort(by: {(ch1, ch2) -> Bool in
                ch1 < ch2
            })
            
            var contentMenuObj = NSMutableArray()
            for secMenu in sectionMenu
            {
                for contentList in list
                {
                    if contentList.User_Name.capitalized.first == secMenu
                    {
                        contentMenuObj.add(contentList)
                    }
                }
                contentMenuList.add(contentMenuObj)
                contentMenuObj = NSMutableArray()
            }
            self.reloadTableView()
            if menuId == 8  || menuId == 9
            {
                self.searchView.isHidden = true
                self.searchViewHeightConst.constant = 0
            }
            else
            {
                if list.count > 0
                {
                    self.searchView.isHidden = false
                    self.searchViewHeightConst.constant = 40
                }
                else
                {
                    self.searchView.isHidden = true
                    self.searchViewHeightConst.constant = 0
                }
            }
            showEmptyStateView(show: false)
        }
        else
        {
            if(menuId == 21)
            {
//                if(self.customerStatus == 2)
//                {
//                    self.emptyStateLbl.text = "No users found for the entered search keyword"
//                    //pending \(appDoctor)(s) for approval."
//                }
//                else if(self.customerStatus == 1)
//                {
//                    self.emptyStateLbl.text = "No users found for Approved \(appDoctor)(s)."
//                }
                
                self.emptyStateLbl.text = "No users found for the entered search keyword"
            }
            else
            {
                self.emptyStateLbl.text = "No Ride Along found."
            }
            showEmptyStateView(show: true)
        }
        
    }
    
    func convertApprovalUserMasterModel(UserList: NSArray) -> [ApprovalUserMasterModel]
    {
        var count : Int = 0
        var custList : [ApprovalUserMasterModel] = []
        if UserList.count > 0
        {
            for userObj  in UserList
            {
                let dict = userObj as! NSDictionary
                let employeeObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
                
                employeeObj.Employee_Number = dict.object(forKey: "Employee_Number") as! String!
                employeeObj.Employee_Name = dict.object(forKey: "Employee_Name") as! String!
                employeeObj.User_Type_Name = dict.object(forKey: "User_Type_Name") as! String!
                employeeObj.Region_Code = dict.object(forKey: "Region_Code") as! String!
                employeeObj.Region_Name = dict.object(forKey: "Region_Name") as! String!
                employeeObj.User_Name = dict.object(forKey: "User_Name") as! String!
                employeeObj.User_Code = dict.object(forKey: "User_Code") as! String!
                
                if menuId == 9
                {
                    count = dict.object(forKey: "TP_Count") as! Int!
                }
                else if menuId == 8
                {
                    count = dict.object(forKey: "DCR_Count") as! Int!
                }
                else if menuId == 11 || menuId == 28
                {
                    count = dict.object(forKey: "Lock_Count") as! Int!
                }
                else if menuId == 21
                {
                    count = dict.object(forKey: "Pending_Approval_Count") as! Int!
                }
                else if menuId == 29
                {
                    count = -99
                }
                employeeObj.Count = count
                custList.append(employeeObj)
            }
        }
        return custList
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
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMenu.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentMenuList.object(at: section) as AnyObject).count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight : CGFloat = 65
        let sampleObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        
        let nameLblHgt = getTextSize(text: sampleObj.Employee_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 60).height
        
        return defaultHeight + nameLblHgt
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: ApprovalUserContentCell, for: indexPath) as! ApprovalUserContentTableViewCell
        userListCell.userCount.layer.masksToBounds = true
        userListCell.userCount.layer.cornerRadius = (userListCell.userCount.frame.width)/2
        let dictObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        userListCell.userName.text = (dictObj.Employee_Name)!
        userListCell.userId.text = "User Name: " + dictObj.User_Name + " |"
        userListCell.userDesignation.text = "Designation: " + (dictObj.User_Type_Name)! + " | " + (dictObj.Region_Name)!
        userListCell.userCount.isHidden = false
        if(dictObj.Count == -99)
        {
            userListCell.userCount.text = EMPTY
            userListCell.userCount.isHidden = true
        }
        else
        {
            userListCell.userCount.text = String(dictObj.Count)
        }
        userListCell.userCount.layer.cornerRadius = 15
        
        return userListCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: ApprovalUserSectionCell) as! ApprovalUserSectionTableViewCell
        sectionCell.sectionHeadLbl.text = String(sectionMenu[section])
        sectionCell.sectionContentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        //sectionCell.sectionTitleLbl.backgroundColor = UIColor.lightGray
        return sectionCell
    }
    
    func reloadTableView()
    {
        self.tableView.reloadData()
    }
    
    //MARK:-Search Bar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.sectionArray(list: appUserList)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if searchBar.text?.count == 0
        {
            self.sectionArray(list: appUserList)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func sortCurrentList(searchText:String)
    {
        
        searchList = appUserList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Employee_Name).lowercased()
            let userName = (obj.User_Name).lowercased()
            let designation = (obj.User_Type_Name).lowercased()
            let regionName = (obj.Region_Name).lowercased()
            if (empName.contains(lowerCaseText)) || (userName.contains(lowerCaseText)) || (designation.contains(lowerCaseText)) || (regionName.contains(lowerCaseText))
            {
                return true
            }
            self.searchView.isHidden = false
            return false
        }
        
        self.sectionArray(list: searchList)
        if(menuId == 21)
        {
            if(self.customerStatus == 2)
            {
            self.emptyStateLbl.text = "No users found for pending \(appDoctor)(s) for approval."
            }
            else
            {
                self.emptyStateLbl.text = "No users found for Approved \(appDoctor)(s)."
            }
        }
        else
        {
            self.emptyStateLbl.text = "No Ride Along found. Clear your search and try again."
        }
    }
    
    func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ApprovalUserListViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh()
    {
        if(menuId == MenuIDs.DoctorApproval.rawValue)
        {
            self.setDefaults(value:2)
        }
        else if menuId == MenuIDs.DCR_ActivityLock_Release.rawValue
        {
            
        }
        else
        {
            navigationApiCall(type: 2)
        }
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkInternetConnectivity()
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedCell = tableView.cellForRow(at: indexPath)
            let dictObj = ((contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row)) as! ApprovalUserMasterModel
            selectedCell?.contentView.backgroundColor = UIColor.white
            navigateFunc(list: dictObj)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func navigateFunc(list: ApprovalUserMasterModel)
    {
        if menuId == MenuIDs.DCR_Lock_Release.rawValue
        {
            let sb = UIStoryboard(name: "LockRelease", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "LockRelease") as! LockReleaseViewController
            self.navigationItem.title = "Back"
            vc.approvalUserObj = list
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuId == MenuIDs.DCR_Lock_Release.rawValue
        {
            let sb = UIStoryboard(name: "LockRelease", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "LockRelease") as! LockReleaseViewController
            self.navigationItem.title = "Back"
            vc.approvalUserObj = list
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuId == MenuIDs.DCR_ActivityLock_Release.rawValue
        {
            let sb = UIStoryboard(name: "LockRelease", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "LockRelease") as! LockReleaseViewController
            self.navigationItem.title = "Back"
            vc.approvalUserObj = list
            vc.isFromDCRActivityLock = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(menuId == MenuIDs.DoctorApproval.rawValue)
        {
            let sb = UIStoryboard(name: "LockRelease", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "LockRelease") as! LockReleaseViewController
            vc.approvalUserObj = list
            vc.customerStatus = self.customerStatus
            vc.isFromDoctorApproval = true
            self.navigationItem.title = "Back"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(menuId == MenuIDs.TP_Freeze_Lock.rawValue)
        {
            self.openAlertView(userCode:list.User_Code,list:list)
        }
        else
        {
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalMonthListVcID) as! ApprovalPendingMonthListViewController
            DCRModel.sharedInstance.userDetail = list
            vc.menuId = menuId
            vc.userObj = list
            self.navigationItem.title = "Back"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponserForTextField()
    {
        self.searchBar.resignFirstResponder()
    }
    
    func showMessageForApiReponse(apiResponseObj : ApiResponseModel , type : Int)
    {
        if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
        {
            if type != 2
            {
                self.showEmptyStateView(show: true)
                self.emptyStateLbl.text = "No Internet Connection"
            }
            else
            {
                showToastView(toastText: "No Internet Connection")
            }
        }
        else
        {
            var emptyStateText : String = apiResponseObj.Message
            self.showEmptyStateView(show: true)
            
            if emptyStateText == ""
            {
                emptyStateText = "Unable to fetch approval data."
            }
            if type == 2
            {
                showToastView(toastText: emptyStateText)
            }
            else
            {
                self.emptyStateLbl.text = emptyStateText
            }
        }
        
    }
    
    func setEmptyStateLblTxt(text : String)
    {
        self.emptyStateLbl.text = text
    }
    
    
    func showSuccessToast()
    {
        showToastView(toastText: "Refreshed Successfully")
    }
    
    @objc func searchAction() {
        
        isSearch = true
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.SearchApprovalVCID) as! SearchApprovalViewController
        vc.menuId = menuId
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func getSelectedActivityListDelegate(menuId: Int, searchtText: String, searchType: Bool,customerStatus: Int)
    {
        self.menuId = menuId
        self.searchText = searchtText
        self.searchType = searchType
        if(menuId == MenuIDs.DoctorApproval.rawValue)
        {
            if(customerStatus == 1)
            {
                self.customerStatus = 2
            }
            else
            {
                self.customerStatus = 1
            }
        }
        
    }
    func searchApiCall()
    {
        if checkInternetConnectivity()
        {
            if self.searchType == true
            {
                self.searchUserType = 1
            }
            else
            {
                self.searchUserType = 2
            }
            if menuId == MenuIDs.DCR_Approval.rawValue
            {
                
                showCustomActivityIndicatorView(loadingText: "Searching details")
                WebServiceHelper.sharedInstance.getDCRSearchUserWiseAppliedList(searchType: self.searchUserType, searchText: self.searchText) { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        if apiResponseObj.list.count > 0
                        {
                            
                            self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.showEmptyStateView(show: true)
                            self.emptyStateLbl.text = "No records found. Please click on search button to refine your search."
                        }
                        
                    }
                    else
                    {
                        self.showEmptyStateView(show: true)
                        self.emptyStateLbl.text = serverSideError
                    }
                }
            }
            else if menuId == MenuIDs.DoctorApproval.rawValue
            {
                showCustomActivityIndicatorView(loadingText: "Searching details")
                BL_MenuAccess.sharedInstance.getPendingDoctorApprovalUserListBySearch(customerStatus: customerStatus, searchType: self.searchUserType, searchString: self.searchText) { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        self.addClearButton()
                        if apiResponseObj.list.count > 0
                        {
                            self.customerStatusViewHeight.constant = 43
                            self.customerStatusSwitch.isHidden = false
                            self.customerStatusLbl.isHidden = false
                            self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.customerStatusViewHeight.constant = 0
                            self.customerStatusSwitch.isHidden = true
                            self.customerStatusLbl.isHidden = true
                            self.showEmptyStateView(show: true)
                            self.emptyStateLbl.text = "No records found. Please click on search button to refine your search."
                        }
                        
                    }
                    else
                    {
                        self.customerStatusViewHeight.constant = 0
                        self.customerStatusSwitch.isHidden = true
                        self.customerStatusLbl.isHidden = true
                        self.showEmptyStateView(show: true)
                        self.emptyStateLbl.text = serverSideError
                    }
                }
            }
            else
            {
                showCustomActivityIndicatorView(loadingText: "Searching details")
                WebServiceHelper.sharedInstance.getTPSearchUserWiseAppliedList(searchType: self.searchUserType, searchText:self.searchText) { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        if apiResponseObj.list.count > 0
                        {
                            self.appUserList = self.convertApprovalUserMasterModel(UserList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            self.tableView.reloadData()
                        }
                        else
                        {
                            self.showEmptyStateView(show: true)
                            self.emptyStateLbl.text = "No records found. Please click on search button to refine your search."
                        }
                    }
                    else
                    {
                        self.showEmptyStateView(show: true)
                        self.emptyStateLbl.text = serverSideError
                    }
                }
                
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
        
    }
    
    func addSearchButton()
    {
        if menuId == MenuIDs.DCR_Approval.rawValue || menuId == MenuIDs.TP_Approval.rawValue
            //|| menuId == MenuIDs.DoctorApproval.rawValue
        {
            
            let searchButton = UIButton(type: UIButtonType.custom)
            
            searchButton.addTarget(self, action: #selector(self.searchAction), for: UIControlEvents.touchUpInside)
            searchButton.setImage(UIImage(named: "icon-search"), for: .normal)
            searchButton.sizeToFit()
            let rightBarButtonItem = UIBarButtonItem(customView: searchButton)
            self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
            
        }
    }
    func addClearButton()
    {
        let searchButton = UIButton(type: UIButtonType.custom)
        
        searchButton.addTarget(self, action: #selector(self.searchAction), for: UIControlEvents.touchUpInside)
        searchButton.setImage(UIImage(named: "icon-search"), for: .normal)
        searchButton.sizeToFit()
        let rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        
        clearBut = UIBarButtonItem(title: "CLEAR", style: .plain, target: self, action: #selector(clearAction))
        self.navigationItem.rightBarButtonItems = [clearBut,rightBarButtonItem]
    }
    
    @objc func clearAction()
    {
        searchText = EMPTY
        isSearch = true
        customerStatus = 2
        customerStatusSwitch.setOn(false, animated: true)
        customerStatusLbl.text = "Show Approved \(appDoctor)(s)"
        addSearchButton()
        navigationApiCall(type : 1)
    }
    
    @IBAction func customerStatusSwitchBut(_ sender: UISwitch) {
        if(customerStatusSwitch.isOn)
        {
            customerStatus = 1
            customerStatusLbl.text = "Show Applied \(appDoctor)(s)"
            //do api call for approved
            if searchText == EMPTY
            {
                self.navigationApiCall(type: 1)
            }
            else
            {
                self.searchApiCall()
            }
        }
        else
        {
            customerStatus = 2
            customerStatusLbl.text = "Show Approved \(appDoctor)"
            //do api call for applied
            if searchText == EMPTY
            {
                self.navigationApiCall(type: 1)
            }
            else
            {
                self.searchApiCall()
            }
        }
    }
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            self.textField?.placeholder = "Select Month and Year";
            
            let doneToolbar = getToolBar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            doneToolbar.sizeToFit()
            
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ApprovalUserListViewController.fromPickerDoneAction))
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(ApprovalUserListViewController.cancelBtnClicked))
            
            doneToolbar.items = [flexSpace, done, cancel]
            
            
            self.textField?.inputAccessoryView = doneToolbar
            self.textField?.inputView = monthDatePicker
        }
    }
    
    func openAlertView(userCode:String,list:ApprovalUserMasterModel) {
        let alert = UIAlertController(title: "Alert", message: "Please select month and date to proceed", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
            if let textField = self.textField?.text
            {
                if textField != EMPTY
                {
                    let selectedDate = textField.components(separatedBy: "/")
                    let sb = UIStoryboard(name: "LockRelease", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "LockRelease") as! LockReleaseViewController
                    self.navigationItem.title = "Back"
                    vc.approvalUserObj = list
                    vc.isFromTpFreezeLock = true
                    vc.selectedYear = "\(self.selectedYear)"
                    vc.selectedMonth = "\(self.selectedMonth)"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    AlertView.showAlertView(title: "Alert", message: "Please select month and date to proceed")
                }
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setMontPicker()
    {
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        var month  = calendar.component(.month, from: currentDate)
        let day  = calendar.component(.day, from: currentDate)
        
        if(month < 10)
        {
            let monthValue = "0\(month)"
            month = Int(monthValue)!
        }
        
        monthDatePicker = MonthYearPickerView()
        currentYear = year
        selectedMonth = month
        fromDate = "\(year)-\(month)-1"
        toDate = "\(year)-\(month)-\(day)"
        selectedYear = year
        self.textField?.text = "\(month)/\(year)"
    
        monthDatePicker.onDateSelected = { (month: Int, year: Int) in
            self.fromDate = "\(year)-\(month)-1"
            let lastDays = lastDay(ofMonth: month, year: year)
            self.toDate = "\(year)-\(month)-\(lastDays)"
            self.textField?.text = "\(month)/\(year)"
            self.selectedMonth = month
            self.selectedYear = year
        }
        
    }
    
    @objc func fromPickerDoneAction()
    {
        self.textField?.text = "\(selectedMonth)/\(self.selectedYear)"
        resignResponderForTextField()
    }
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    @objc func resignResponderForTextField()
    {
        self.textField?.resignFirstResponder()
    }
}
extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
    }
}
