//
//  DashboardPendingUserListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 13/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardPendingUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var appUserList : [ApprovalUserMasterModel] = []
    var sectionMenu : [Character] = []
    var contentMenuList = NSMutableArray()
    var searchList : [ApprovalUserMasterModel] = []
    var currentList : [ApprovalUserMasterModel] = []
    var isComingFromTpPage : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.addTapGestureForView()
        self.pullDownRefresh()
        self.tableView.estimatedRowHeight = 500
        self.searchView.isHidden = true
       // self.startApiCall(type: 1)

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.endRefresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startApiCall(type : Int)
    {
        if checkInternetConnectivity()
        {
            if type != 2
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
            }
            if !isComingFromTpPage
            {
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_DCR) Pending Approval"
                    BL_Dashboard.sharedInstance.getPendingDCRApprovalUserList(userCode: getUserCode(), regionCode: getRegionCode())
                    {
                        (apiResponseObj) in
                        if apiResponseObj.Status == SERVER_SUCCESS_CODE
                        {
                            self.appUserList = self.convertApprovalUserMasterModel(userList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            self.setEmptyStateLblTxt(text: "No pending \(PEV_DCR) available for approval")
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
            }
            else
            {
                if checkInternetConnectivity()
                {
                    self.navigationItem.title = "\(PEV_TP) Pending Approval"
                    BL_Dashboard.sharedInstance.getPendingTPApprovalUserList(userCode: getUserCode(), regionCode: getRegionCode())
                    {
                        (apiResponseObj) in
                        if apiResponseObj.Status == SERVER_SUCCESS_CODE
                        {
                            self.appUserList = self.convertApprovalUserMasterModel(userList: apiResponseObj.list)
                            self.sectionArray(list: self.appUserList)
                            self.setEmptyStateLblTxt(text: "No pending \(PEV_TP) available for approval")
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
                let empName = String(contentList.User_Name)
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
                    if contentList.User_Name.first == secMenu
                    {
                        contentMenuObj.add(contentList)
                    }
                }
                contentMenuList.add(contentMenuObj)
                contentMenuObj = NSMutableArray()
            }
            self.reloadTableView()
            self.searchView.isHidden = false
            showEmptyStateView(show: false)
        }
        else
        {
            self.emptyStateLbl.text = "No Ride Along found."
            showEmptyStateView(show: true)
        }
        
    }
    
    func convertApprovalUserMasterModel(userList: NSArray) -> [ApprovalUserMasterModel]
    {
        var count : Int = 0
        var custList : [ApprovalUserMasterModel] = []
        if userList.count > 0
        {
            for userObj  in userList
            {
                let dict = userObj as! NSDictionary
                let employeeObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
                count = dict.object(forKey: "Count") as! Int!
          
                 if count > 0
                 {
                    employeeObj.Employee_Name = checkNullAndNilValueForString(stringData: dict.object(forKey: "EmployeeName") as? String)
                    employeeObj.Region_Code = checkNullAndNilValueForString(stringData: dict.object(forKey: "RegionCode") as? String)
                    employeeObj.Region_Name = checkNullAndNilValueForString(stringData: dict.object(forKey: "RegionName") as? String)
                    employeeObj.User_Name = checkNullAndNilValueForString(stringData: dict.object(forKey: "UserName") as? String)
                    employeeObj.User_Code = checkNullAndNilValueForString(stringData: dict.object(forKey: "UserCode") as! String!)
                    employeeObj.Count = count
                    custList.append(employeeObj)
                }
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentMenuList.object(at: section) as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashBoardUserListCell, for: indexPath) as! ApprovalUserContentTableViewCell
        userListCell.userCount.layer.masksToBounds = true
        userListCell.userCount.layer.cornerRadius = (userListCell.userCount.frame.width)/2
        let dictObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        userListCell.userName.text = (dictObj.Employee_Name)!
        userListCell.userId.text = "User Name: " + dictObj.User_Name + " |"
        let userTypeName = checkNullAndNilValueForString(stringData: dictObj.User_Type_Name)
        if userTypeName != ""
        {
        userListCell.userDesignation.text = "Designation: " + userTypeName + " | " + (dictObj.Region_Name)!
        }
        else
        {
            userListCell.userDesignation.text = "Territory: " + (dictObj.Region_Name)!
        }
        
        userListCell.userCount.text = String(dictObj.Count)
        userListCell.userCount.layer.cornerRadius = 15
        
        return userListCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashboardUserSectionCell) as! ApprovalUserSectionTableViewCell
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
            let empName  = checkNullAndNilValueForString(stringData: (obj.Employee_Name)).lowercased()
            let userName = checkNullAndNilValueForString(stringData: (obj.User_Name)).lowercased()
            let designation = checkNullAndNilValueForString(stringData: (obj.User_Type_Name)).lowercased()
            let regionName = (obj.Region_Name).lowercased()
            if (empName.contains(lowerCaseText)) || (userName.contains(lowerCaseText)) || (designation.contains(lowerCaseText)) || (regionName.contains(lowerCaseText))
            {
                return true
            }
            self.searchView.isHidden = false
            return false
        }
        
        self.sectionArray(list: searchList)
        self.emptyStateLbl.text = "No pending approval found. Clear your search and try again."
    }
    
    func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(DashboardPendingUserListViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh()
    {
        
        self.startApiCall(type: 2)
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isComingFromTpPage
        {
            if checkInternetConnectivity()
            {
                tableView.deselectRow(at: indexPath, animated: true)
                let selectedCell = tableView.cellForRow(at: indexPath)
                let dictObj = ((contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row)) as! ApprovalUserMasterModel
                selectedCell?.contentView.backgroundColor = UIColor.white
                navigateFunc(obj: dictObj)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    func navigateFunc(obj: ApprovalUserMasterModel)
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingApprovalVcID) as! DashBoardPendingApprovalViewController
        vc.isComingFromTeamPage = true
        vc.regionCode = obj.Region_Code
        vc.userCode = obj.User_Code
        self.navigationController?.pushViewController(vc, animated: true)
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
                emptyStateText = "Unable to fetch pending approval data."
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
}
