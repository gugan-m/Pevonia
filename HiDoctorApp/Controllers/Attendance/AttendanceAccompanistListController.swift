//
//  AttendanceAccompanistListController.swift
//  HiDoctorApp
//
//  Created by SwaaS SystemS on 23/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AttendanceAccompanistListController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //MARK:- @IBOutlet
    @IBOutlet var emptyStateLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    //MARK:- Variables
    var sectionTitle : [String] = []
    var userWrapperList : [UserMasterWrapperModel] = []
    var userCurrentList : [SortedValueModel] = []
    var userSortList : [SortedValueModel] = []
    var userSelectedList : NSMutableArray = []
    var searchStatus : Bool = false
    var item1 : UIBarButtonItem!
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.tableView.estimatedRowHeight = 500
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAccompanistListDetails()
        self.userSelectedList = []
        self.addBarButtonItem()
        self.setBarButtonItem()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView DataSource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var defaultHeight : CGFloat = 18
        let constraintWidth = SCREEN_WIDTH - 61
        let userList = userCurrentList[indexPath.section].userList[indexPath.row]
        let accompanistDetail = userList.userObj
        let employeeName = accompanistDetail.Employee_name
        let username = accompanistDetail.User_Name
        let designation = accompanistDetail.User_Type_Name
        let regionName = accompanistDetail.Region_Name
        
        defaultHeight += getTextSize(text: employeeName, fontName: fontSemiBold, fontSize: 15, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text: "Username:\(username) | ", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text:  "Designation:\(designation) | \(regionName)", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
        header.contentView.backgroundColor = UIColor(red: 245/250, green: 245/250, blue: 245/250, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCurrentList[section].userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListIndexTableViewCell
        let userList = userCurrentList[indexPath.section].userList[indexPath.row]
        let accompanistDetail = userList.userObj
        let employeeName = accompanistDetail.Employee_name as String
        let username = accompanistDetail.User_Name as String
        let designation = accompanistDetail.User_Type_Name as String
        let regionName  = accompanistDetail.Region_Name as String
        
        cell.titleLbl.text = employeeName
        cell.detailLbl.text = "User Name: \(username) | "
        
        
        if designation != ""
        {
            cell.descriptionLbl.text = "Designation: \(designation) | \(regionName)"
        }
        cell.imgView.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userList = userCurrentList[indexPath.section].userList[indexPath.row]
        let regionCode = userList.userObj.Region_Code
        let regionName = userList.userObj.Region_Name
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
        vc.regionCode = regionCode
        vc.regionName = regionName
        vc.isFromAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Get Downloaded Accompanists
    func getAccompanistListDetails()
    {
        userWrapperList = convertToUserMasterModel(accompanistList:getFilteredAccompanistList())
        self.getSortedList(userWrapperList: userWrapperList , type : 1)
    }
    
    //Convert Accompanist To UserMasterModel
    func convertToUserMasterModel(accompanistList : [AccompanistModel]) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        if accompanistList.count > 0
        {
            for accompanistObj in accompanistList
            {
                let wrapObj : UserMasterWrapperModel = UserMasterWrapperModel()
                let userObj : UserMasterModel = UserMasterModel()
                userObj.Employee_name = accompanistObj.Employee_name
                userObj.Region_Name = accompanistObj.Region_Name
                userObj.Region_Code = accompanistObj.Region_Code
                userObj.Division_Name = accompanistObj.Division_Name
                userObj.User_Type_Name = accompanistObj.User_Type_Name
                userObj.User_Code = accompanistObj.User_Code
                userObj.User_Name = accompanistObj.User_Name
                userObj.Employee_name = accompanistObj.Employee_name
                userObj.Is_Child_User = accompanistObj.Is_Child_User
                userObj.Is_Immedidate_User = accompanistObj.Is_Immedidate_User
                wrapObj.userObj = userObj
                wrapObj.isSelected = false
                userList.append(wrapObj)
            }
        }
        return userList
    }
    
    func getFilteredAccompanistList() -> [AccompanistModel]
    {
        var accompanistList : [AccompanistModel] = []
        let accomapnistMasteredList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        let downloadedAccomapanistList = BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedRegions()
        for accomapnistObj in accomapnistMasteredList
        {
            let filteredArray = downloadedAccomapanistList.filter
            {
                $0.Region_Code == accomapnistObj.Region_Code && $0.User_Code == accomapnistObj.User_Code
            }
            if filteredArray.count != 0
            {
                accompanistList.append(accomapnistObj)
            }
        }
        return accompanistList
    }
    
    private func getSortedList(userWrapperList : [UserMasterWrapperModel] , type : Int)
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        for obj in userWrapperList
        {
            let capitalisedStr = condenseWhitespace(stringValue: obj.userObj.Employee_name).capitalized as NSString
            let firstCharacter = capitalisedStr.substring(to: 1) as NSString
            var nameList = detailDict.object(forKey: firstCharacter) as? NSMutableArray
            if nameList == nil
            {
                nameList = NSMutableArray()
                detailDict.setObject(nameList!, forKey: firstCharacter)
            }
            nameList?.add(obj)
        }
        
        for eachCharacter in detailDict.allKeys as! [NSString]
            
        {
            let arrayOfCharacter = detailDict.object(forKey: eachCharacter) as! NSArray
            let sortedArray = (arrayOfCharacter as NSArray).sorted { (($0 as! UserMasterWrapperModel).userObj.Employee_name).localizedCaseInsensitiveCompare((($1 as! UserMasterWrapperModel).userObj.Employee_name) as String) == ComparisonResult.orderedAscending }
            detailDict.setObject(sortedArray, forKey: eachCharacter)
        }
        let unsortedSection:[String] = detailDict.allKeys as! [String]
        self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending })
        userSortList.removeAll()
        for char in sectionTitle
        {
            let userObj  = SortedValueModel()
            userObj.sectionKey = char
            userObj.userList = detailDict.object(forKey: char) as! [UserMasterWrapperModel]
            userSortList.append(userObj)
        }
        changeCurrentArray(list: userSortList , type : type)
    }
    
    func changeCurrentArray(list:[SortedValueModel] , type : Int)
    {
        if list.count > 0
        {
            userCurrentList = list
            self.tableView.reloadData()
            self.showEmptyStateView(show : false)
        }
        else
        {
            self.showEmptyStateView(show : true)
            self.setEmptyStateLbl(type: type)
        }
    }
    
    //MARK:- Functions to show and hide EmptyState
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateLabel.isHidden = !show
        self.tableView.isHidden = show
    }
    
    func setEmptyStateLbl(type : Int)
    {
        var emptyStateTxt  :String = ""
        
        if type == 1
        {
            emptyStateTxt = "No Accompanists Found"
        }
        else
        {
            emptyStateTxt = "No Accompanists Found"
        }
        self.emptyStateLabel.text = emptyStateTxt
    }
    
    func setSortedArray() -> [UserMasterWrapperModel]
    {
        return userWrapperList.sorted { (($0).userObj.Employee_name).localizedCaseInsensitiveCompare((($1).userObj.Employee_name) as String) == ComparisonResult.orderedAscending }
        
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
    
    func searchListContent(text : String)
    {
        var userWrapperModelArray = userWrapperList
        if text != ""
        {
            userWrapperModelArray = userWrapperList.filter { (userWrapperObj) -> Bool in
                let loweredSeachString = text.lowercased()
                return userWrapperObj.userObj.Employee_name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.User_Type_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.User_Name).lowercased().contains(loweredSeachString)
            }
            getSortedList(userWrapperList : userWrapperModelArray , type : 2)
        }
        else
        {
            self.getSortedList(userWrapperList : userWrapperList , type : 1)
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
        self.getSortedList(userWrapperList : userWrapperList , type : 1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func addBarButtonItem()
    {
        item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.item1BtnAction))
    }
    
    @objc func item1BtnAction()
    {
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:UserListIndexViewController = sb.instantiateViewController(withIdentifier: UserIndexListVcID) as! UserListIndexViewController
        vc.isFromAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setBarButtonItem()
    {
        let downloadedAccompanistCount = getDownloadedAccompanistCount()
        if downloadedAccompanistCount > 0
        {
            self.navigationItem.rightBarButtonItems = [item1]
        }
        else
        {
            self.navigationItem.rightBarButtonItems = [item1]
        }
    }
    
    func getDownloadedAccompanistCount() -> Int
    {
        return  BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedUserCount()
    }
}
