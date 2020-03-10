//
//  UserListIndexViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol UserListButtonActionDelegate {
    func setButtonActionForItem(type:String)
}


enum navigationType : String
{
    case refreshBtn = "refreshBtnAction"
    case moreBtn = "moreBtnAction"
    case viewDisappear = "viewDisappear"
}

class UserListIndexViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate,AccompanistDownloadSuccessDelegate
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadBtn : UIButton!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    
    var sectionTitle : [String] = []
    var userWrapperList : [UserMasterWrapperModel] = []
    var userCurrentList : [SortedValueModel] = []
    var userSortList : [SortedValueModel] = []
    var userSelectedList : NSMutableArray = []
    var searchStatus : Bool = false
    var navigationTitle : String = "User List"
    var delegate : UserListButtonActionDelegate?
    var navigationScreenName : String = ""
    var isComingFromAccompanistPage : Bool = false
    var isFromAttendance:Bool = false
    var item1 : UIBarButtonItem!
    var item2 : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = navigationTitle
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = (UIColor.white).cgColor
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        self.title = "\(PEV_ACCOMPANIST)"
        self.addBarButtonItem()
        self.navigationController?.isNavigationBarHidden = false
        addBackButtonView()
        self.tableView.estimatedRowHeight = 500
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.getAccompanistListDetails()
        self.userSelectedList = []
        self.setBarButtonItem()
        if isComingFromAccompanistPage
        {
            showToastView(toastText: "\(PEV_ACCOMPANIST) Data downloaded successfully")
            isComingFromAccompanistPage = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        if userList.isSelected
        {
            cell.imgView.image = UIImage(named: "icon-tick")
        }
        else
        {
            cell.imgView.image = UIImage(named: "icon-unselected")
        }
        return cell
    }
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
//    {
//        return sectionTitle.index(of: title)!
//    }
//    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]?
//    {
//        return sectionTitle
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userList = userCurrentList[indexPath.section].userList[indexPath.row]
        if userList.isSelected  == false
        {
            if userSelectedList.count < 4
            {
                userList.isSelected = true
                userSelectedList.add(userList.userObj)
            }
            else
            {
                AlertView.showAlertView(title: infoTitle, message: "You can download 4 Ride ALong at a time. After downloading selected list, Choose again and download", viewController: self)
            }
        }
        else
        {
            userList.isSelected = false
            if userSelectedList.count > 0
            {
                userSelectedList.remove(userList.userObj)
            }
        }
        self.setButtonTextColor()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    

    private func getSortedList(userWrapperList : [UserMasterWrapperModel] , type : Int)
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        for obj in userWrapperList
        {
            let capitalisedStr = condenseWhitespace(stringValue: obj.userObj.Employee_name).capitalized as NSString
            var firstCharacter = NSString()
            if(capitalisedStr as String == EMPTY)
            {
                let capitalisedStr1 = condenseWhitespace(stringValue: obj.userObj.User_Name).capitalized as NSString
                firstCharacter = capitalisedStr1.substring(to: 1) as NSString
            }
            else
            {
                firstCharacter = capitalisedStr.substring(to: 1) as NSString
            }
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
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
    }
    
    func setEmptyStateLbl(type : Int)
    {
        var emptyStateTxt  :String = ""
        
        if type == 1
        {
            emptyStateTxt = "No Ride Along Found"
        }
        else
        {
           emptyStateTxt = "No Ride Along found. Clear your search and try again."
        }
        self.emptyStateLbl.text = emptyStateTxt
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
    
    /*
     *This method is common for both bar button item
     *tag 1 = bar item 1 , tag 2 = bar item 2
     */
    
    @IBAction func barItemBtnAction(_ sender: AnyObject)
    {
       if sender.tag == 1
       {
         delegate?.setButtonActionForItem(type: navigationType.moreBtn.rawValue)
       }
       else
       {
          delegate?.setButtonActionForItem(type: navigationType.refreshBtn.rawValue)
       }
    }
    

    func getAccompanistListDetails()
    {
        userWrapperList = convertToUserMasterModel(accompanistList:getFilteredAccompanistList())
        self.getSortedList(userWrapperList: userWrapperList , type : 1)
    }
    
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
    
    func addBarButtonItem()
    {
        item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(self.item1BtnAction))
        item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.item2BtnAction))
    }
    
    
    @objc func item1BtnAction()
    {
        let sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DeleteAccompanistVcID)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func item2BtnAction()
    {
        
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
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    func getDownloadedAccompanistCount() -> Int
    {
      return  BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedUserCount()
    }
    
    @IBAction func downloadBtnAction(_ sender: UIButton)
    {
        let errorMsg = validationForDownloadAccompanistRegion()
        let countErrorMsg = validationForDownloadAccompanistCount()
        if countErrorMsg != ""
        {
           AlertView.showAlertView(title: alertTitle, message: countErrorMsg, viewController: self)
        }
        else if errorMsg != ""
        {
            AlertView.showAlertView(title: alertTitle, message: errorMsg, viewController: self)
        }
        else if userSelectedList.count > 0
        {
            if checkInternetConnectivity()
            {
                navigationToPrepareMyDevice()
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    
    func navigationToPrepareMyDevice()
    {
        let sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: PrepareDeviceVcID) as! PrepareMyDeviceViewController
        vc.accompanistDataDownloadList = covertToUserMasterModel()
        vc.isComingFromManageAccompanist = true
        vc.delegate = self
        if isFromAttendance
        {
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: true)
            }
        }
        else
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setButtonTextColor()
    {
        if userSelectedList.count > 0
        {
            let textColor  = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1.0)
            self.downloadBtn.setTitleColor(textColor, for: UIControlState.normal)
            self.downloadBtn.isUserInteractionEnabled  = true
        }
        else
        {
            let textColor  = UIColor.darkGray
           self.downloadBtn.setTitleColor(textColor, for: UIControlState.normal)
           self.downloadBtn.isUserInteractionEnabled = false
        }
    }
    
    private func covertToUserMasterModel() -> [UserMasterModel]
    {
        var userMasterList : [UserMasterModel] = []
        if userSelectedList.count > 0
        {
            for obj in userSelectedList
            {
                userMasterList.append(obj as! UserMasterModel)
            }
        }
        return userMasterList
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
            if filteredArray.count == 0
            {
                accompanistList.append(accomapnistObj)
            }
        }
        return accompanistList
    }
    
    func validationForDownloadAccompanistRegion() -> String
    {
        var errorMessage : String = ""
        let downloadedAccomapanistList = BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedRegions()
        for accomapnistObj in userSelectedList
        {
            let filteredArray = downloadedAccomapanistList.filter
                {
                    $0.Region_Code == (accomapnistObj as! UserMasterModel).Region_Code
                }
            if filteredArray.count > 0
            {
                errorMessage = "Selected Ride Along already exist"
            }
        }
        return errorMessage
    }
    
    func validationForDownloadAccompanistCount() -> String
    {
        var errorMessage : String = ""
        let downloadAccompanistCount = getDownloadedAccompanistCount()
        let userSelectedListCount  = userSelectedList.count
        let totalCount = downloadAccompanistCount + userSelectedListCount
        if totalCount > 12
        {
            errorMessage = "You are already downloaded 12 Ride Along,If you want to download selected Ride Along. Delete any other accomapanist from Ride Along menu."
        }
        return errorMessage
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
    
    func showToastViewForAccompanistDownload()
    {
        self.isComingFromAccompanistPage = true
    }

}
