//  HourlyReportDoctorListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

struct HourlyReportListIdentifier
{
    static let reportAccompanistList : Int = 1
}

protocol SetSelectedAccompanist
{
    func getSelectedAccompanist(obj : UserMasterModel)
}

class HourlyReportDoctorListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    var userList : [UserMasterModel] = []
    var currentList : [UserListModel] = []
    var screenId : Int = 0
    var delegate : SetSelectedAccompanist?
    var isFromIce = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 500
        setDefaultListToCurrentList()
        addCustomBackButtonToNavigationBar()
        searchBar.placeholder = "Search UserID / employees / territory"
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func setDefaultListToCurrentList()
    {
        if(isFromIce)
        {
            userList = BL_HourlyReport.sharedInstance.convertAccompanitsToUserMasterModel(accompanistList:  BL_HourlyReport.sharedInstance.getAllChildUser())
           // userList = addMineIntoSortedList(list: userList)
        }
        else
        {
            if screenId == HourlyReportListIdentifier.reportAccompanistList
            {
                userList = BL_HourlyReport.sharedInstance.convertAccompanitsToUserMasterModel(accompanistList:  BL_HourlyReport.sharedInstance.getAllChildUser())
                userList = addMineIntoSortedList(list: userList)
            }
        }
            
            self.title = "User List"
            
            let sortedList = BL_HourlyReport.sharedInstance.getSortedUserList(accompanistList: userList)
            
            changeCurrentArray(list: sortedList, type: 0)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let sectionKey = currentList[section].sectionKey
        if sectionKey == ""
        {
            return ""
        }
        return currentList[section].sectionKey
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let sectionKey = currentList[section].sectionKey

        if sectionKey == ""
        {
            return 0.01
        }
        return 34
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if section != 0
        {
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.lightGray
            header.contentView.backgroundColor = UIColor(red: 240/250, green: 240/250, blue: 240/250, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList[section].accompanistsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.HourlyReportDoctorListCell, for: indexPath) as! HourlyReportDoctorListTableViewCell
        let obj = currentList[indexPath.section].accompanistsList[indexPath.row]
        
        let username = obj.User_Name as String
        let designation = obj.User_Type_Name as String
        let regionName  = obj.Region_Name as String
        cell.doctorNameLbl.text = obj.Employee_name
        cell.userNameLbl.text = "User ID: \(username) | Designation: \(designation)"
        cell.designationLbl.text = "\(regionName)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userObj = currentList[indexPath.section].accompanistsList[indexPath.row]
        if(isFromIce)
        {
            showIceAlert(userCode: userObj.User_Code,userName:userObj.User_Name)
        }
        else
        {
            let obj : UserMasterModel = UserMasterModel()
            obj.Employee_name = userObj.Employee_name
            obj.User_Code = userObj.User_Code
            obj.User_Name = userObj.User_Name
            obj.User_Type_Name = userObj.User_Type_Name
            obj.Region_Code = userObj.Region_Code
            obj.Region_Name = userObj.Region_Name
            delegate?.getSelectedAccompanist(obj: obj)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK :-Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if let text = searchBar.text
        {
            searchListContent(text: text)
        }
        else
        {
            searchListContent(text: "")
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
        self.setDefaultValueToCurrentList()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    private func searchListContent(text : String)
    {
        var searchList : [UserMasterModel] = []
        if text != "" && userList.count > 0
        {
            searchList = userList.filter { (userObj) -> Bool in
                let loweredSeachString = text.lowercased()
                return userObj.Employee_name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userObj.User_Type_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData:userObj.User_Name).lowercased().contains(loweredSeachString)
            }
            changeCurrentArray(list: BL_HourlyReport.sharedInstance.getSortedUserList(accompanistList: searchList), type: 1)
        }
        else
        {
            self.setDefaultValueToCurrentList()
        }
    }
    
    
    private func changeCurrentArray(list : [UserListModel] , type : Int)
    {
        if list.count > 0
        {
            currentList = list
            showEmptyStateView(show: false)
            self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show: true)
            showEmptyStateLblText(type: type)
        }
    }

    private func showEmptyStateView(show : Bool)
    {
        self.contentView.isHidden = show
        self.emptyStateView.isHidden = !show
    }
    
    private func showEmptyStateLblText(type : Int)
    {
        var emptyStateTxt  :String = ""
        
        if type == 0
        {
            emptyStateTxt = "No Ride Along Found"
        }
        else
        {
            emptyStateTxt = "No Ride Along found. Clear your search and try again."
        }
        self.emptyStateLbl.text = emptyStateTxt
    }
    
    
    private func addMineIntoSortedList(list : [UserMasterModel]) -> [UserMasterModel]
    {
        var userList = list
        let mineObj = getUserModelObj()
        mineObj?.Employee_name = ""
        userList.insert(mineObj!, at: 0)
        return userList
    }
    
    private func setDefaultValueToCurrentList()
    {
        changeCurrentArray(list:BL_HourlyReport.sharedInstance.getSortedUserList(accompanistList: userList), type: 0)
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
   
    func showIceAlert(userCode:String,userName:String)
    {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "ICE", style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.IceFeedbackViewControllerID) as! IceFeedbackViewController
            vc.userCode = userCode
            vc.userName = userName
            self.navigationController?.pushViewController(vc, animated: true)
           // self.uploadImgFromCamera()
        })
        actionSheetController.addAction(cameraAction)
        
        let photoLibrary = UIAlertAction(title: "Task", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
           
            
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AllTaskViewControllerID) as! AllTaskViewController
            vc.userCode = userCode
            //            vc.userName = userName
            self.navigationController?.pushViewController(vc, animated: true)
            //self.showAlert()
        })
        actionSheetController.addAction(photoLibrary)
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            self.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }

}
