//
//  ActivityListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol  selectedActivityListDelegate
{
    func getSelectedActivityListDelegate(obj : ProjectActivityMaster)
}

class ActivityListViewController: UIViewController,UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var emptyStateTitleLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var searchBarHgtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    var currentList : [ProjectActivityMaster] = []
    var searchList : [ProjectActivityMaster] = []
    var activityList : [ProjectActivityMaster] = []
    var delegate : selectedActivityListDelegate?
    var selectedActivityCode : NSMutableArray = []
    var isComingForTPAttendance = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.getActivityList()
        self.navigationItem.title = "Activity List"
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        addBackButtonView()
        self.setSelectedActivityCode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceActivityListCell, for: indexPath)
        let obj = currentList[indexPath.row]
        cell.textLabel?.text = obj.Activity_Name as String
        cell.textLabel?.textColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1.0)
        if selectedActivityCode.contains(obj.Activity_Code)
        {
            cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
        else
        {
           cell.contentView.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let activityObj = currentList[indexPath.row]

        if !selectedActivityCode.contains(activityObj.Activity_Code)
        {
        delegate?.getSelectedActivityListDelegate(obj: activityObj)
        _ = navigationController?.popViewController(animated: false)
        }
    }
    
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
        self.changeCurrentArray(list: activityList,type : 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = activityList.filter{ (obj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let activityName = obj.Activity_Name.lowercased()
            return activityName.contains(lowerCasedText)
        }
        self.changeCurrentArray(list: searchList,type : 1)
    }
    
    func changeCurrentArray(list : [ProjectActivityMaster],type : Int)
    {
        if list.count > 0
        {
            self.showEmptyStateView(show: false)
            currentList = list
            self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show: true)
            self.setEmptyStateLbl(type: type)
        }
    }
    
    
    func showEmptyStateView(show:Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func setEmptyStateLbl(type : Int)
    {
        var text : String = ""
        if type == 0
        {
            text = "No Activity found"
            self.searchBarHgtConstraint.constant = 0
        }
        else
        {
            text = "No Activity found..Clear your search and try again"
            self.searchBarHgtConstraint.constant = 44
        }
        
        self.emptyStateTitleLbl.text = text
    }
    
    func getActivityList()
    {
        activityList = BL_DCR_Attendance.sharedInstance.getProjectActivityList()!
        self.changeCurrentArray(list: activityList,type : 0)
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
    
    
    func setSelectedActivityCode()
    {
        if (isComingForTPAttendance)
        {
            selectedActivityCode.add(checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Code))
        }
        else
        {
            let dcrActivityList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceActivities()
            
            for obj in dcrActivityList!
            {
                selectedActivityCode.add(obj.Activity_Code)
            }
        }
    }
}
