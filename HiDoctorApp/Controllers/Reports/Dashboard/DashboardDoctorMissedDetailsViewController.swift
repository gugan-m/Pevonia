//
//  DashboardDoctorMissedDetailsViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardDoctorMissedDetailsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    var missedDoctorList : [DashboardUserMasterModel] = []
    var userObj : ApprovalUserMasterModel!
    var sectionMenu : [Character] = []
    var contentMenuList = NSMutableArray()
    var searchList : [DashboardUserMasterModel] = []
    var currentList : [DashboardUserMasterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureForView()
        addBackButtonView()
        self.searchView.isHidden = false
        self.title = "Missed \(appDoctor)"
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
            BL_Dashboard.sharedInstance.getMissedDoctorDetails(userCode: userObj.User_Code, regionCode: userObj.Region_Code) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.missedDoctorList = self.convertDashboardHeader(list: apiResponseObj.list)
                    self.sectionArray(list: self.missedDoctorList)
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
    func convertDashboardHeader(list: NSArray) -> [DashboardUserMasterModel]
    {
        var regionList : [DashboardUserMasterModel] = []
        if list.count > 0
        {
            for listObj in list
            {
                let currentList : DashboardUserMasterModel = DashboardUserMasterModel()
                let obj = listObj as! NSDictionary
                
                currentList.Region_Name = checkNullAndNilValueForString(stringData: obj.object(forKey: "Region_Name") as? String)
                currentList.Region_Code = checkNullAndNilValueForString(stringData: obj.object(forKey: "Region_Code") as? String)
                currentList.Speciality_Name = checkNullAndNilValueForString(stringData: obj.object(forKey: "Speciality_Name") as? String)
                currentList.Customer_Name = checkNullAndNilValueForString(stringData: obj.object(forKey: "Customer_Name") as? String)
                currentList.Speciality_Code = checkNullAndNilValueForString(stringData:  obj.object(forKey: "Speciality_Code") as? String)
                currentList.Category_Code = checkNullAndNilValueForString(stringData: obj.object(forKey: "Category_Code") as? String)
                currentList.Category_Name = checkNullAndNilValueForString(stringData: obj.object(forKey: "Category_Name") as? String)
                currentList.MDL_Number = checkNullAndNilValueForString(stringData: obj.object(forKey: "MDL_Number") as? String)
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
    
    func sectionArray(list: [DashboardUserMasterModel])
    {
        contentMenuList = NSMutableArray()
        sectionMenu = []
        if list.count > 0
        {
            
            for contentList in list
            {
                let empName = String(contentList.Customer_Name)
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
                    if contentList.Customer_Name.first == secMenu
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
            self.emptyLbl.text = "No \(appDoctor) found."
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
        self.sectionArray(list: missedDoctorList)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if searchBar.text?.count == 0
        {
            self.sectionArray(list: missedDoctorList)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    func sortCurrentList(searchText:String)
    {
        
        searchList = missedDoctorList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Customer_Name).lowercased()
            let speciality = (obj.Speciality_Name).lowercased()
            if (empName.contains(lowerCaseText)) || (speciality.contains(lowerCaseText))
            {
                return true
            }
            self.searchView.isHidden = false
            self.emptyLbl.text = "No \(appDoctorPlural) found. Please clear the search and try again."
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
        let defaultHeight : CGFloat = 60
        let sampleObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! DashboardUserMasterModel
        
        let nameLblHgt = getTextSize(text: sampleObj.Customer_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height
        
        return defaultHeight + nameLblHgt
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: ApprovalUserContentCell, for: indexPath) as! ApprovalUserContentTableViewCell
        
        let dictObj = (contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as! DashboardUserMasterModel
        
        userListCell.userName.text = (dictObj.Customer_Name)!
        let MDLNo = dictObj.MDL_Number
        let speciality = dictObj.Speciality_Name
        let category = dictObj.Category_Name
        
        userListCell.userId.text = MDLNo! + " | " + speciality! + " | " + category!
        userListCell.userDesignation.text = dictObj.Region_Name
        
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
}
