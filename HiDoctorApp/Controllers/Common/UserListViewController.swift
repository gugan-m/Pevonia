//
//  UserListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol  SelectedAccompanistDetailsDelegate
{
    func setSelectedAccompanistName(accompanistObj : UserMasterWrapperModel)
}
protocol  SelectedMessageUserListDelegate
{
    func setSelectedMessageUserList(accompanistObj : [UserMasterWrapperModel],isFromCc:Bool)
}
protocol  SelectedUserDetailsDelegate
{
    func setSelectedAccompanistName(userObj : UserMasterWrapperModel)
}

enum UserListScreenName : String
{
    case DcrAccompanistList = "dcrAccompanistList"
    case DcrAddAccompanistList = "dcrAddAccompanistList"
    case AccompanistList = "accompanistList"
    case DCRChemistAccompanistList = "dcrChemistAccomapnistList"
    case CustomerList = "moreCustomerList"
    case TPAccompanist = "tpAccomanist"
    case TPWorkPlace = "tpWorkplace"
    case MessageUserList = "MessageUserList"
    case LockReleaseList = "LockReleaseList"
    case DPMAccompanistList = "DPMAccompanistList"
    case LeaveAccompanistList = "LeaveAccompanistList"
}

class UserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var refreshLabelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var refreshlabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var downloadBtn : UIButton!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var BottomViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    var nextBtn : UIBarButtonItem!
    var refreshBtn : UIBarButtonItem!
    var refreshDate:String!
    var userWrapperList : [UserMasterWrapperModel] = []
    var userCurrentList : [UserMasterWrapperModel] = []
    var userSortList : [UserMasterWrapperModel] = []
    var navigationScreenName : String = ""
    var searchStatus : Bool = false
    var navigationTitle : String = "\(PEV_ACCOMPANIST) List"
    var delegate : UserListButtonActionDelegate?
    var selectedAccompanyList : NSMutableArray = []
    var selectedUserList : NSMutableArray = [] //message user list
    var accompanistDelegate : SelectedAccompanistDetailsDelegate?
    var messageUserListDelegate : SelectedMessageUserListDelegate?
    var isTPModify: Bool = false
    var isSearch: Bool = false
    var toUserList : [UserMasterWrapperModel] = [] //from message
    var isFromCC : Bool = false
    var doctorLocalArea = EMPTY
    var isCustomerMasterEdit: Bool = false
    var doctorListPageSoruce:Int = Constants.Doctor_List_Page_Ids.Customer_List
    var isFromDCR: Bool = false
    var isFromComplaint: Bool = false
    var isFromComplaintTrack: Bool = false
    var selectedUserDetail: SelectedUserDetailsDelegate?
    var lockSelectedUserCode = String()
    var isTPFreeze : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navigationTitle
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = (UIColor.white).cgColor
        self.tableView.delegate = self
        searchBar.placeholder = "Search..."
        self.refreshLabelHeightConst.constant = 0
        self.BottomViewHeightConst.constant = 0
        self.tableView.estimatedRowHeight = 500
        self.searchBar.delegate = self
        
        getCurrentList()
        addBackButtonView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var defaultHeight : CGFloat = 20
        let constraintWidth = SCREEN_WIDTH - 61
        let accompanistObj = userCurrentList[indexPath.row]
        let accompanistDetail = accompanistObj.userObj
        let employeeName = accompanistDetail.Employee_name
        let username = accompanistDetail.User_Name
        let designation = accompanistDetail.User_Type_Name
        let regionName = accompanistDetail.Region_Name
     //   let HospitalName = accompanistDetail.Hospital_Name
        
        defaultHeight += getTextSize(text: employeeName, fontName: fontSemiBold, fontSize: 15, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text: "Username:\(username!) | ", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text:  "Designation:\(designation!) | \(regionName!)", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCurrentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListIndexTableViewCell
        
        let userValueobj = userCurrentList[indexPath.row]
        let accompanistDetail = userValueobj.userObj
        let employeeName = accompanistDetail.Employee_name as String
        let username = accompanistDetail.User_Name as String
        let designation = accompanistDetail.User_Type_Name as String
        let regionName  = accompanistDetail.Region_Name as String
       // let hospitalName  = accompanistDetail.Hospital_Name as String
        
        
        if (navigationScreenName == addTravelFromPlace || navigationScreenName == addTravelToPlace || navigationScreenName == doctorMasterVcID || navigationScreenName == ChemistDayVcID || navigationScreenName == TPStepperVCID || navigationScreenName == addTPTravelFromPlace || navigationScreenName == addTPTravelToPlace || navigationScreenName == UserListScreenName.DPMAccompanistList.rawValue)
        {
            cell.titleLbl.text = employeeName
            cell.detailLbl.text = "\(username) | \(designation)"
            cell.descriptionLbl.text = regionName
        } else
        {
            cell.titleLbl.text = employeeName
            if username != ""
            {
                cell.detailLbl.text = "User Name: \(username) | "
            }
            
            if designation != ""
            {
                cell.descriptionLbl.text = "Designation: \(designation) | \(regionName)"
            }
            
            if navigationScreenName == UserListScreenName.DcrAddAccompanistList.rawValue
            {
                if userValueobj.isReadOnly
                {
                    cell.outerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                }
                else
                {
                    cell.outerView.backgroundColor = UIColor.white
                }
            }
            
            if navigationScreenName == UserListScreenName.DcrAccompanistList.rawValue || navigationScreenName == UserListScreenName.DcrAddAccompanistList.rawValue || navigationScreenName == UserListScreenName.DCRChemistAccompanistList.rawValue || navigationScreenName == UserListScreenName.CustomerList.rawValue || navigationScreenName == UserListScreenName.TPWorkPlace.rawValue  || navigationScreenName == UserListScreenName.LockReleaseList.rawValue ||
                navigationScreenName == UserListScreenName.LeaveAccompanistList.rawValue           {
                cell.imgViewHeightConstraint.constant = 0
            }
            else
            {
                if userValueobj.isSelected
                {
                    cell.imgView.image = UIImage(named: "icon-tick")
                }
                else
                {
                    cell.imgView.image = UIImage(named: "icon-unselected")
                }
                if userValueobj.isReadOnly
                {
                    cell.imgView.image = UIImage(named: "icon-selected")
                    
                }
                
            }
            
            
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
        
        let accompanistObj = userCurrentList[indexPath.row]
        
        if (navigationScreenName == UserListScreenName.TPAccompanist.rawValue)
        {
            if(accompanistObj.isReadOnly==false)
            {
                if accompanistObj.isSelected  == false
                {
                    if selectedAccompanyList.count < 4
                    {
                        accompanistObj.isSelected = true
                        selectedAccompanyList.add(accompanistObj)
                        toggleTickButton()
                    }
                    else
                    {
                        accompanistObj.isSelected = false
                        AlertView.showAlertView(title: alertTitle, message: "You are allowed to choose maximum of four accompanists only", viewController: self)
                    }
                }
                else
                {
                    accompanistObj.isSelected = false
                    toggleTickButton()
                    
                    if selectedAccompanyList.count > 0
                    {
                        selectedAccompanyList.remove(accompanistObj)
                    }
                }
                
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
            
        }
        else if navigationScreenName == UserListScreenName.MessageUserList.rawValue
        {
            userCurrentList[indexPath.row].isSelected = !userCurrentList[indexPath.row].isSelected
            toggleTickButton()
//            
//            if accompanistObj.isSelected  == false
//            {
//                accompanistObj.isSelected = true
//               // userCurrentList[indexPath.row].isSelected = true
//                toggleTickButton()
//            }
//            else
//            {
//                accompanistObj.isSelected = false
//                toggleTickButton()
//            }
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

        }
        else if navigationScreenName == "accompanistList"
        {
            if accompanistObj.isSelected  == false
            {
                if selectedAccompanyList.count < 4
                {
                    accompanistObj.isSelected = true
                    selectedAccompanyList.add(accompanistObj)
                }
                else
                {
                    accompanistObj.isSelected = false
                    AlertView.showAlertView(title: alertTitle, message: "You are allowed to choose maximum of four \(PEV_ACCOMPANIST) only", viewController: self)
                }
            }
            else
            {
                accompanistObj.isSelected = false
                
                if selectedAccompanyList.count > 0
                {
                    selectedAccompanyList.remove(accompanistObj)
                }
            }
            
            self.setButtonTextColor()
            
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        else if navigationScreenName == "dcrAccompanistList" || navigationScreenName == UserListScreenName.TPWorkPlace.rawValue
        {
            let regionCode  = accompanistObj.userObj.Region_Code
            let cpList = BL_WorkPlace.sharedInstance.getCPList(regionCode:regionCode!)
            let sb = UIStoryboard(name: workPlaceDetailsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: CampaignListVcID) as! CampaignPlannerListViewController
            
            vc.campaignList = cpList
            vc.isFromAccompanistPage = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if navigationScreenName == UserListScreenName.DcrAddAccompanistList.rawValue && !accompanistObj.isReadOnly
        {
            accompanistDelegate?.setSelectedAccompanistName(accompanistObj: accompanistObj)
            _ = navigationController?.popViewController(animated: true)
        }
        else if navigationScreenName == UserListScreenName.DCRChemistAccompanistList.rawValue
        {
            let regionCode = accompanistObj.userObj.Region_Code
            
            if (doctorLocalArea == EMPTY)
            {
                let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
                vc.regionCode = regionCode!
                
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            else
            {
                let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ChemistListSectionVCID) as! ChemistListSectionViewController
                vc.regionCode = regionCode!
                vc.doctorLocalArea = doctorLocalArea
                
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
        }

        else if (navigationScreenName == addTravelFromPlace || navigationScreenName == addTravelToPlace)
        {
            let userValueObj = userWrapperList[indexPath.row]
            let accompanistDetail = userValueObj.userObj
            let regionCode = accompanistDetail.Region_Code as String
            let placeList = BL_SFC.sharedInstance.convertToSFCPlaceModel(regionCode: regionCode)
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:PlaceListViewController = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
            
            vc.navigationScreenname = navigationScreenName
            vc.placeList = placeList!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (navigationScreenName == addTPTravelFromPlace || navigationScreenName == addTPTravelToPlace)
        {
            let userValueObj = userWrapperList[indexPath.row]
            let accompanistDetail = userValueObj.userObj
            let regionCode = accompanistDetail.Region_Code as String
            let placeList = BL_TP_SFC.sharedInstance.convertToSFCPlaceModel(regionCode: regionCode)
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:PlaceListViewController = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
            
            vc.navigationScreenname = navigationScreenName
            vc.placeList = placeList!
            vc.getRegion = regionCode
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if navigationScreenName == doctorMasterVcID
        {
            let userValueObj = userWrapperList[indexPath.row]
            let accompanistDetail = userValueObj.userObj
            let regionCode = accompanistDetail.Region_Code as String
            let regionName = accompanistDetail.Region_Name as String
            
            if (self.isFromDCR && !BL_DCR_Doctor_Visit.sharedInstance.canInheritedUserAddDoctors(accUserCode: accompanistDetail.User_Code, isFlexi: false))
            {
                BL_DCR_Doctor_Visit.sharedInstance.showInhertianceNewDoctorAddErrorMsg()
                return
            }
            
            if(!isFromComplaint)
            {
            let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
            let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
                vc.regionCode = regionCode
                vc.regionName = regionName
                vc.dcrID  = DCRModel.sharedInstance.dcrId
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            else
            {
                if(isFromComplaintTrack)
                {
                    let sb = UIStoryboard(name: commonListSb, bundle: nil)
                    let vc:ComplaintListViewController = sb.instantiateViewController(withIdentifier: ComplaintListViewControllerID) as! ComplaintListViewController
                    //vc.regionCode = self.regionCode
                    vc.regionCode = regionCode
                    if let navigationController = self.navigationController
                    {
                        navigationController.popViewController(animated: false)
                        navigationController.pushViewController(vc, animated: false)
                    }
                }
                else
                {
                    
                    let sb = UIStoryboard(name: commonListSb, bundle: nil)
                    let vc:ComplaintCustomerListViewController = sb.instantiateViewController(withIdentifier: ComplaintCustomerListViewControllerID) as! ComplaintCustomerListViewController
                    vc.regionCode = regionCode
                    vc.regionName = regionName
                    vc.isFromComplaintTrack = isFromComplaintTrack
                    
                    if let navigationController = self.navigationController
                    {
                        navigationController.popViewController(animated: false)
                        navigationController.pushViewController(vc, animated: false)
                    }
                }
            }
        }
        else if navigationScreenName == ChemistDayVcID
        {
            let regionCode = accompanistObj.userObj.Region_Code
            
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
            vc.regionCode = regionCode!
            vc.isComingFromChemistDay = true
            
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
            
        }
        else if navigationScreenName == UserListScreenName.CustomerList.rawValue
        {
            BL_DoctorList.sharedInstance.customerCategoryArray.removeAllObjects()
            BL_DoctorList.sharedInstance.customerSpecialityArray.removeAllObjects()
            CustomerModel.sharedInstance.regionCode = accompanistObj.userObj.Region_Code
            CustomerModel.sharedInstance.userCode = accompanistObj.userObj.User_Code
            CustomerModel.sharedInstance.navTitle = accompanistObj.userObj.Employee_name
            setSplitViewRootController(backFromAsset: false, isCustomerMasterEdit: isCustomerMasterEdit, customerListPageSouce: self.doctorListPageSoruce)
        }
        else if navigationScreenName == TPStepperVCID
        {
            let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: TPDoctorMasterVCID) as! TPDoctorMasterViewController
            
            let userValueObj = userWrapperList[indexPath.row]
            let accompanistDetail = accompanistObj.userObj
            let regionCode = accompanistDetail.Region_Code as String
            vc.regionCode = regionCode
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if navigationScreenName == UserListScreenName.LockReleaseList.rawValue
        {
            let userValueObj = userWrapperList[indexPath.row]
            selectedUserDetail?.setSelectedAccompanistName(userObj: accompanistObj)
            self.navigationController?.popViewController(animated: false)
        }
        else if navigationScreenName == UserListScreenName.DPMAccompanistList.rawValue
        {
            let sb = UIStoryboard(name:"NoticeBoardViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DPMMainViewController") as! DPMMainViewController
            let userValueObj = userCurrentList[indexPath.row]
            let accompanistDetail = userValueObj.userObj
            let regionCode = accompanistDetail.Region_Code as String
            vc.selectedRegionCode = regionCode
            vc.selectedRegionName = accompanistDetail.Region_Name
            vc.selectedName = accompanistDetail.User_Name
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else if navigationScreenName == UserListScreenName.LeaveAccompanistList.rawValue
        {
            let sb = UIStoryboard(name:ApprovalSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "LeaveApprovalVCID") as! LeaveApprovalViewController
            let userValueObj = userCurrentList[indexPath.row]
            let accompanistDetail = userValueObj.userObj
            vc.selectedUserCode = accompanistDetail.User_Code
            vc.selectedRegionCode = accompanistDetail.Region_Code
            vc.selectedName = accompanistDetail.Employee_name
            vc.userTypeName = accompanistDetail.User_Type_Name
           // vc.approvalList = userValueObj.userObj
            UserDefaults.standard.set("0", forKey: "IsAppliedAndApproved")
            UserDefaults.standard.synchronize()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    private func getSortedList(userWrapperList : [UserMasterWrapperModel])
    {
        let sortedArray = userWrapperList.sorted { (($0 ).userObj.Employee_name).localizedCaseInsensitiveCompare((($1 ).userObj.Employee_name) as String) == ComparisonResult.orderedAscending }
        userSortList = sortedArray
        changeCurrentArray(list: userSortList , type : 2)
    }
    
    private func toggleTickButton()
    {
        if (navigationScreenName == UserListScreenName.TPAccompanist.rawValue)
        {
            
            
            let filtered = userCurrentList.filter{
                $0.isSelected == true || $0.isReadOnly == true
            }
            
            if (filtered.count >= 0 && !isTPModify)
            {
                self.navigationItem.rightBarButtonItems = [refreshBtn, nextBtn]
            }
            else if (isTPModify)
            {
                self.navigationItem.rightBarButtonItems = [refreshBtn, nextBtn]
            }
        }
        else if (navigationScreenName == UserListScreenName.MessageUserList.rawValue)
        {
            
            let filtered = userCurrentList.filter{
                $0.isSelected == true
            }
            if (filtered.count > 0 && !isTPModify)
            {
                self.navigationItem.rightBarButtonItems = [nextBtn]
            }

        }
    }
    
    func doneButtonAction() -> [UserMasterWrapperModel]
    {
        let filtered = userCurrentList.filter{
            $0.isSelected == true || $0.isReadOnly == true
        }
        
        return filtered
        
    }
    
    func changeCurrentArray(list:[UserMasterWrapperModel] , type : Int)
    {
        if list.count > 0
        {
            
            userCurrentList = list
            showEmptyStateView(show : false)
            if (navigationScreenName == UserListScreenName.TPAccompanist.rawValue)
            {
                filterSelectedList()
                if(!isSearch)
                {
                    let getSelectedList = doneButtonAction()
                    for getSelectedLists in getSelectedList
                    {
                        selectedAccompanyList.add(getSelectedLists)
                    }
                }
            }
            else if toUserList.count != 0
            {
                filterSelectedList()
            }
            self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show : true)
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
            emptyStateTxt = "No Accompanists Found"
        }
        else
        {
            emptyStateTxt = "No accompanists found. Clear your search and try again."
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
        isSearch = true
        if(searchText == "")
        {
            
        }
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
        self.changeCurrentArray(list: userWrapperList , type : 1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func searchListContent(text : String)
    {
        var userWrapperModelArray : [UserMasterWrapperModel] = []
        if text != "" && userWrapperList.count > 0
        {
            userWrapperModelArray = userWrapperList.filter { (userWrapperObj) -> Bool in
                let loweredSeachString = text.lowercased()
                return userWrapperObj.userObj.Employee_name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.User_Type_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.userObj.User_Name).lowercased().contains(loweredSeachString)
            }
            getSortedList(userWrapperList : userWrapperModelArray)
        }
        else
        {
            self.changeCurrentArray(list: userWrapperList , type : 1)
        }
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
    
    
    @IBAction func skipBtnAction(_ sender: AnyObject)
    {
        if navigationScreenName == "accompanistList"
        {
            BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
            let appdelegate = getAppDelegate()
            appdelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
        }
    }
    
    @IBAction func downloadBtnAction(_ sender: AnyObject)
    {
        let userMasterList = covertToUserMasterModel()
        if userMasterList.count > 0
        {
            self.navigationController?.navigationBar.isHidden = false
            let prepare_sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
            let prepare_vc = prepare_sb.instantiateViewController(withIdentifier: PrepareDeviceVcID) as! PrepareMyDeviceViewController
            prepare_vc.accompanistDataDownloadList = userMasterList
            prepare_vc.isComingFromAccompanistPage = true
            self.navigationController?.pushViewController(prepare_vc, animated: true)
        }
    }
    
    func getCurrentList()
    {
        if navigationScreenName == UserListScreenName.TPAccompanist.rawValue{
            self.syncRefreshDate()
            self.BottomViewHeightConst.constant = 0
            self.addRefreshBtn()
            self.addBarButtonItem()
            
            if(isTPModify)
            {
                userWrapperList =  BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
                
                self.navigationItem.rightBarButtonItems = [refreshBtn]
            }
            else
            {
                selectedAccompanyList.removeAllObjects()
                let accompanistList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterLists()
                //userWrapperList =  convertToUserMasterModel(accompanistList: BL_PrepareMyDeviceAccompanist.sharedInstance.getAllAccompanists()!)
                userWrapperList =  convertToUserMasterModel(accompanistList: accompanistList)
                self.navigationItem.rightBarButtonItems = [refreshBtn]
            }
        }
        else if navigationScreenName == UserListScreenName.MessageUserList.rawValue
        {
            showCustomActivityIndicatorView(loadingText: "Loading the User List..")
            self.addBarButtonItem()
            
            BL_Mail_Message.sharedInstance.getMailUsersList { (userListObject) in
                self.userWrapperList = userListObject
                self.changeCurrentArray(list: self.userWrapperList , type : 1)
                removeCustomActivityView()
            }
        }
        else if navigationScreenName == UserListScreenName.TPWorkPlace.rawValue
        {
            userWrapperList =  BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
            self.setUserObjectToList()
        }
        else if navigationScreenName == "accompanistList"
        {
            self.BottomViewHeightConst.constant = 50
            userWrapperList =  convertToUserMasterModel(accompanistList: BL_PrepareMyDeviceAccompanist.sharedInstance.getAllAccompanists()!)
        }
        else  if navigationScreenName == "dcrAccompanistList"
        {
            userWrapperList = convertToUserModel(accompanistList: BL_WorkPlace.sharedInstance.getListOfAccompanist())
            self.setUserObjectToList()
        }
        else if navigationScreenName == "dcrAddAccompanistList"
        {
            var accompanistList:[AccompanistModel] = []
            if isTPFreeze
            {
                accompanistList = BL_DCR_Accompanist.sharedInstance.getAccompanistTPFreezeMasterLists()
            }
            else
            {
                accompanistList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterLists()
            }
            let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
            userWrapperList = BL_DCR_Accompanist.sharedInstance.convertAccompanistListToUserList(accompanistList: accompanistList, dcrAccompanistList: dcrAccompanistList!)
        }
        else if navigationScreenName == UserListScreenName.DCRChemistAccompanistList.rawValue
        {
            userWrapperList = convertToUserModel(accompanistList: BL_DCR_Chemist_Visit.sharedInstance.dcrAccompanistsList()!)
            self.setUserObjectToList()
        }
        else if navigationScreenName == addTravelFromPlace || navigationScreenName == addTravelToPlace
        {
            userWrapperList = BL_SFC.sharedInstance.convertToSFCUserModel()!
        }
        else if navigationScreenName == addTPTravelFromPlace || navigationScreenName == addTPTravelToPlace
        {
            userWrapperList = BL_TP_SFC.sharedInstance.convertToSFCUserModel()!
        }
        else if navigationScreenName == doctorMasterVcID || navigationScreenName == ChemistDayVcID
        {
            if(!isFromComplaint)
            {
                userWrapperList = BL_DCR_Doctor_Visit.sharedInstance.convertToDoctorVisitUserModel()!
            }
            else
            {
                let accompanistList =  BL_DoctorList.sharedInstance.getAllChildUser()
                if accompanistList != nil
                {
                    userWrapperList  = convertToUserMasterModel(accompanistList:accompanistList!)
                }
                setUserObjectToList()
            }
        }
        else if navigationScreenName == TPStepperVCID{
            userWrapperList = BL_TP_Doctor_Visit.sharedInstance.convertToDoctorVisitUserModel()!
        }
        else if navigationScreenName == UserListScreenName.CustomerList.rawValue
        {
            let accompanistList =  BL_DoctorList.sharedInstance.getAllChildUser()
            if accompanistList != nil
            {
                userWrapperList  = convertToUserMasterModel(accompanistList:accompanistList!)
            }
            setUserObjectToList()
        }
        else if navigationScreenName == UserListScreenName.DPMAccompanistList.rawValue
        {
            selectedAccompanyList.removeAllObjects()
            let accompanistList = BL_DCR_Accompanist.sharedInstance.getDPMAccompanistList()
            //userWrapperList =  convertToUserMasterModel(accompanistList: BL_PrepareMyDeviceAccompanist.sharedInstance.getAllAccompanists()!)
            userWrapperList =  convertToUserMasterModel(accompanistList: accompanistList)
            self.setUserObjectToList()
            self.navigationItem.rightBarButtonItems = []
        }
        else if navigationScreenName == UserListScreenName.LockReleaseList.rawValue
        {
            if(checkInternetConnectivity())
            {
                showCustomActivityIndicatorView(loadingText: "Loading..")
                self.addBarButtonItem()
                
                //            BL_Mail_Message.sharedInstance.getMailUsersList { (userListObject) in
                //                self.userWrapperList = userListObject
                //                self.changeCurrentArray(list: self.userWrapperList , type : 1)
                //                removeCustomActivityView()
                //            }
                WebServiceHelper.sharedInstance.getUserParentHierarchy(userCode: lockSelectedUserCode) { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        var isDeleted : Bool = false
                        if apiObj.list.count > 0
                        {
                            var userWrapperList1 : [UserMasterWrapperModel] = []
                            self.userWrapperList = []
                            userWrapperList1 = self.convertParentHierarchy(arrayList: apiObj.list)
                            
                            for obj in userWrapperList1
                            {
                                if(!isDeleted)
                                {
                                    if(obj.userObj.User_Code == getUserCode())
                                    {
                                        isDeleted = true
                                        self.userWrapperList.append(obj)
                                    }
                                }
                                else
                                {
                                    self.userWrapperList.append(obj)
                                }
                                
                            }
                            self.changeCurrentArray(list: self.userWrapperList , type : 1)
                            removeCustomActivityView()
                        }
                        else
                        {
                            self.showEmptyStateView(show: true)
                            self.emptyStateLbl.text = "No User Found."
                        }
                    }
                    else
                    {
                        self.showEmptyStateView(show: true)
                        self.emptyStateLbl.text = "Problem While Connecting server"
                    }
                }
            }
            else
            {
                self.showEmptyStateView(show: true)
                self.emptyStateLbl.text = "No Internet Connection Please Check your connection"
            }
        }
        
        else if navigationScreenName == UserListScreenName.LeaveAccompanistList.rawValue
        {
            let accompanistList = BL_HourlyReport.sharedInstance.getAllChildUser()
            if accompanistList != nil
            {
                userWrapperList  = convertToUserMasterModel(accompanistList:accompanistList!)
            }
        }
        
        if navigationScreenName != UserListScreenName.MessageUserList.rawValue && navigationScreenName != UserListScreenName.LockReleaseList.rawValue
        {
        changeCurrentArray(list: userWrapperList , type : 1)
        }
    }
    
    func convertParentHierarchy(arrayList:NSArray) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        for obj in arrayList
        {
            let dict = obj as! NSDictionary
            let wrapObj : UserMasterWrapperModel = UserMasterWrapperModel()
            let userObj : UserMasterModel = UserMasterModel()
            userObj.Employee_name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Employee_Name") as? String)//accompanistObj.Employee_name
            userObj.Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Name") as? String)//accompanistObj.Region_Name
            userObj.User_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Code") as? String)// accompanistObj.User_Code
            userObj.Region_Code = EMPTY
            userObj.User_Type_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Type_Name") as? String)// accompanistObj.User_Type_Name
            userObj.User_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "User_Name") as? String)// accompanistObj.User_Name
            wrapObj.userObj = userObj
            wrapObj.isSelected = false
            userList.append(wrapObj)
            
        }
        return userList
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
                userObj.User_Code = accompanistObj.User_Code
                userObj.Region_Code = accompanistObj.Region_Code
                userObj.User_Type_Name = accompanistObj.User_Type_Name
                userObj.User_Name = accompanistObj.User_Name
                userObj.Employee_name = accompanistObj.Employee_name
                wrapObj.userObj = userObj
                wrapObj.isSelected = false
                userList.append(wrapObj)
            }
        }
        return userList
        
    }
    
    
    func convertToUserModel(accompanistList : [DCRAccompanistModel] ) -> [UserMasterWrapperModel]
    {
        var userList : [UserMasterWrapperModel] = []
        
        let userMaster = DBHelper.sharedInstance.getAccompanistMaster()
        for accompanistObj in accompanistList
        {
            let wrapObj : UserMasterWrapperModel = UserMasterWrapperModel()
            let userObj : UserMasterModel = UserMasterModel()
            userObj.User_Name = accompanistObj.Acc_User_Name
            userObj.User_Type_Name = accompanistObj.Acc_User_Type_Name
            userObj.Employee_name = accompanistObj.Employee_Name
            userObj.User_Code = accompanistObj.Acc_User_Code
            userObj.Region_Code = accompanistObj.Acc_Region_Code
            
            let filterValue = userMaster.filter{
                $0.Region_Code == accompanistObj.Acc_Region_Code && $0.User_Code == accompanistObj.Acc_User_Code
            }
            if filterValue.count > 0
            {
                userObj.Region_Name = filterValue.first?.Region_Name
            }
            else
            {
                userObj.Region_Name = EMPTY
            }
            
            wrapObj.userObj = userObj
            wrapObj.isSelected = false
            userList.append(wrapObj)
        }
        
        return userList
        
    }
    
    private func covertToUserMasterModel() -> [UserMasterModel]
    {
        var userMasterList : [UserMasterModel] = []
        if selectedAccompanyList.count > 0
        {
            for obj in selectedAccompanyList
            {
                var userObj : UserMasterModel = UserMasterModel()
                userObj = (obj as! UserMasterWrapperModel).userObj
                userMasterList.append(userObj)
            }
        }
        return userMasterList
    }
    
    func setButtonTextColor()
    {
        if selectedAccompanyList.count > 0
        {
            let textColor  = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1.0)
            self.downloadBtn.setTitleColor(textColor, for: UIControlState.normal)
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
        delegate?.setButtonActionForItem(type: navigationType.viewDisappear.rawValue)
        _ = navigationController?.popViewController(animated: false)
    }
    
    func setUserObjectToList()
    {
        let userDetailsObj = getUserModelObj()!
        let wrapObj : UserMasterWrapperModel = UserMasterWrapperModel()
        let userObj : UserMasterModel = UserMasterModel()
        userObj.Employee_name = "MINE"
        userObj.User_Name = userDetailsObj.User_Name
        userObj.User_Type_Name = userDetailsObj.User_Type_Name
        userObj.Region_Code = userDetailsObj.Region_Code
        userObj.Region_Name = userDetailsObj.Region_Name
        userObj.User_Code = userDetailsObj.User_Code
        wrapObj.isSelected = false
        wrapObj.userObj = userObj
        userWrapperList.insert(wrapObj, at: 0)
    }
    func addBarButtonItem()
    {
        nextBtn = UIBarButtonItem(image: UIImage(named: "icon-done"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextScreenBtnAction))
    }
    
    func addRefreshBtn(){
        
        refreshBtn = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshAction))
    }
    
    @objc func refreshAction()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading Accompanists data")
        if checkInternetConnectivity()
        {
            BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: EMPTY) {(status) in
                if status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.getCurrentList()
                    self.syncRefreshDate()
                    AlertView.showAlertView(title: "SUCCESS", message: "\(PEV_ACCOMPANIST) data are downloaded successfully")
                }
                else
                {
                    AlertView.showServerSideError()
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func syncRefreshDate()
    {
        let apiModel = BL_TPStepper.sharedInstance.getLastSyncDate(apiName: ApiName.Accompanists.rawValue)
        
        if(apiModel != nil)
        {
            if(apiModel.Download_Date != nil)
            {
                
                let date = convertDateIntoLocalDateString(date: apiModel.Download_Date)
                let time = stringFromDate(date1: apiModel.Download_Date)
                self.refreshDate = "Last Modified: \(date) \(time)"
                self.refreshlabel.text = self.refreshDate
                self.refreshLabelHeightConst.constant = 16
            }
            else
            {
                self.refreshlabel.text = EMPTY
                self.refreshLabelHeightConst.constant = 0
            }
        }
    }
    
    @objc func nextScreenBtnAction()
    {
        if navigationScreenName == UserListScreenName.TPAccompanist.rawValue
        {
            BL_TPStepper.sharedInstance.insertTPheaderDetails(Date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag)
            BL_TPStepper.sharedInstance.insertAccompanistData(accArray: selectedAccompanyList as! [UserMasterWrapperModel])
            self.navigationController?.popViewController(animated: true)
        }
        else if navigationScreenName == UserListScreenName.MessageUserList.rawValue
        {
            let getSelectedList = doneButtonAction()
            messageUserListDelegate?.setSelectedMessageUserList(accompanistObj: getSelectedList,isFromCc: self.isFromCC )
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func filterSelectedList()
    {
        var selectedList : [UserMasterWrapperModel] = []
        if(self.toUserList.count != 0)
        {
            for userList in self.toUserList
            {
                selectedAccompanyList.add(userList)
            }
            selectedList = self.toUserList
        }
        else
        {
            selectedList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId) as [UserMasterWrapperModel]
        }
        for objHeader in selectedList
        {
            let filteredContent = userCurrentList.filter{
                $0.userObj.User_Code == objHeader.userObj.User_Code && $0.userObj.User_Code == objHeader.userObj.User_Code
            }
            if (filteredContent.count > 0)
            {
                filteredContent.first!.isSelected = true
                if(!isTPModify && self.toUserList.count == 0)
                {
                    filteredContent.first?.isReadOnly = true
                }
            }
        }
    }
}

