//
//  ReportsUserListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/16/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ReportsUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var childUserList : [AccompanistModel] = []
    var appUserList : [AccompanistModel] = []
    var searchList : [AccompanistModel] = []
    var currentList : [AccompanistModel] = []
    var isComingFromRejectPage : Bool = false
    var isComingFromTpPage : Bool = false
    var menuId : Int = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.addTapGestureForView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.childUserListFunc()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func childUserListFunc()
    {
        if isComingFromRejectPage
        {
            childUserList = BL_Reports.sharedInstance.getChildUsers()
            self.title = "Choose User"
        }
        else
        {
            childUserList = BL_Reports.sharedInstance.getAllChildUsers()
        }
        changeCurrentList(list: childUserList)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ApprovalUserContentCell, for: indexPath) as! ApprovalUserContentTableViewCell
        let dict = currentList[indexPath.row]
        cell.userName.text = dict.Employee_name as String
        cell.userId.text = "User Name: " + (dict.User_Name as String)
        cell.userDesignation.text = "Designation: " + (dict.User_Type_Name as String) + " | " + (dict.Region_Name as String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight : CGFloat = 60
        let dict = currentList[indexPath.row]
        let nameLblHgt = getTextSize(text: dict.Employee_name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height
        
        return defaultHeight + nameLblHgt
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictObj = currentList[indexPath.row]
        let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
        
        userObj.Employee_Name = dictObj.Employee_name
        userObj.User_Name = dictObj.User_Name
        userObj.User_Type_Name = dictObj.User_Type_Name
        userObj.User_Code = dictObj.User_Code
        userObj.Region_Code = dictObj.Region_Code
        userObj.Region_Name = dictObj.Region_Name
        
        if !isComingFromRejectPage
        {
        let empName = dictObj.Employee_name as String
        if empName == "Mine"
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.UserPerDayReportsVcID) as! UserPerDayReportsViewController
            vc.isMine = true
            vc.userList = userObj
            vc.isComingFromTpPage = self.isComingFromTpPage
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if checkInternetConnectivity()
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.UserPerDayReportsVcID) as! UserPerDayReportsViewController
                vc.isMine = false
                vc.userList = userObj
                vc.isComingFromTpPage = self.isComingFromTpPage
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        }
        else
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.RejectViewControllerSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DCRRejectVcID) as! DCRRejectViewController
            vc.userObj = userObj
            self.navigationController?.pushViewController(vc, animated: true)
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
        self.changeCurrentList(list: self.childUserList)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if searchBar.text?.count == 0
        {
            self.changeCurrentList(list: self.childUserList)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func sortCurrentList(searchText:String)
    {
        
        searchList = childUserList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Employee_name).lowercased()
            let userName = (obj.User_Name).lowercased()
            let designation = (obj.User_Type_Name).lowercased()
            let regionName = (obj.Region_Name).lowercased()
            if (empName.contains(lowerCaseText)) || (userName.contains(lowerCaseText)) || (designation.contains(lowerCaseText)) || (regionName.contains(lowerCaseText))
            {
                return true
            }
            self.searchView.isHidden = false
            self.emptyStateLbl.text = "No result found. Clear your search and try again."
            return false
        }
        
        self.changeCurrentList(list: searchList)
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
    
    func changeCurrentList(list: [AccompanistModel])
    {
        if list.count > 0
        {
            currentList = list
            self.searchView.isHidden = false
            self.showEmptyState(show: false)
            self.tableView.reloadData()
        }
        else
        {
            self.showEmptyState(show: true)
        }
    }
    func showEmptyState(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
}
