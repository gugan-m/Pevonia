//
//  DashboardDoctorMissedRegionsViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardDoctorMissedRegionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    var doctorList : [ApprovalUserMasterModel] = []
    var sectionMenu : [Character] = []
    var contentMenuList = NSMutableArray()
    var searchList : [ApprovalUserMasterModel] = []
    var currentList : [ApprovalUserMasterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureForView()
        addBackButtonView()
        self.searchView.isHidden = false
        self.title = "Missed Patner's Regions"
        self.pageLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pageLoad()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "loading...")
            BL_Dashboard.sharedInstance.getMissedDoctorRegions(userCode: getUserCode(), regionCode: getRegionCode()) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.doctorList = self.convertDashboardHeader(list: apiResponseObj.list)
                    self.sectionArray(list: self.doctorList)
                    self.tableView.reloadData()
                }
                else
                {
                    removeCustomActivityView()
                    self.searchView.isHidden = true
                    self.showEmptyStateView(show: true)
                    if apiResponseObj.Status == LOCAL_ERROR_CODE
                    {
                        self.emptyLbl.text = "Local Server Error"
                    }
                    else if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
                    {
                        self.emptyLbl.text = "No Internet Connection"
                    }
                    else if apiResponseObj.Status == SERVER_ERROR_CODE
                    {
                        self.emptyLbl.text = "Server Problem"
                    }
                }
            }
        }
    }
    func convertDashboardHeader(list: NSArray) -> [ApprovalUserMasterModel]
    {
        var regionList : [ApprovalUserMasterModel] = []
        if list.count > 0
        {
            for listObj in list
            {
                let currentList : ApprovalUserMasterModel = ApprovalUserMasterModel()
                let obj = listObj as! NSDictionary
                
                currentList.Region_Code = obj.object(forKey: "RegionCode") as! String
                currentList.User_Code = obj.object(forKey: "UserCode") as! String
                currentList.Employee_Name = obj.object(forKey: "EmployeeName") as! String
                currentList.User_Name = obj.object(forKey: "UserName") as! String
                currentList.Region_Name = obj.object(forKey: "RegionName") as! String
                currentList.Actual_Date = obj.object(forKey: "LastUpdatedDate") as! String
                currentList.Count = obj.object(forKey: "Count") as! Int
                regionList.append(currentList)
            }
        }
        return regionList
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
    
    func sectionArray(list: [ApprovalUserMasterModel])
    {
        contentMenuList = NSMutableArray()
        sectionMenu = []
        if list.count > 0
        {
            
            for contentList in list
            {
                let empName = String(contentList.Region_Name)
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
                    if contentList.Region_Name.first == secMenu
                    {
                        contentMenuObj.add(contentList)
                    }
                }
                contentMenuList.add(contentMenuObj)
                contentMenuObj = NSMutableArray()
            }
            self.tableView.reloadData()
            self.searchView.isHidden = false
            showEmptyStateView(show: false)
        }
        else
        {
            self.searchView.isHidden = false
            self.emptyLbl.text = "No Regions found."
            showEmptyStateView(show: true)
        }
        
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.contentView.isHidden = show
        self.emptyStateView.isHidden = !show
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
        self.sectionArray(list: doctorList)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if searchBar.text?.count == 0
        {
            self.sectionArray(list: doctorList)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func sortCurrentList(searchText:String)
    {
        
        searchList = doctorList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Region_Name).lowercased()
            if (empName.contains(lowerCaseText))
            {
                return true
            }
            self.emptyLbl.text = "No Region found. Please clear the search and try again."
            self.searchView.isHidden = false
            return false
        }
        
        self.sectionArray(list: searchList)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMenu.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentMenuList.object(at: section) as AnyObject).count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight : CGFloat = 40
        let sampleObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        
        let nameLblHgt = getTextSize(text: sampleObj.Region_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 60).height
        
        return defaultHeight + nameLblHgt
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: ApprovalUserContentCell, for: indexPath) as! ApprovalUserContentTableViewCell
        userListCell.userCount.layer.masksToBounds = true
        userListCell.userCount.layer.cornerRadius = (userListCell.userCount.frame.width)/2
        let dictObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        
        userListCell.userName.text = (dictObj.Region_Name)!
        userListCell.userCount.text = String(dictObj.Count)
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
        return sectionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! ApprovalUserMasterModel
        
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardDoctorMissedDetailsVcID) as! DashboardDoctorMissedDetailsViewController
        vc.userObj = dictObj
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
