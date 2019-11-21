//
//  CustomerTableViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 17/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol CustomerDelegate: class {
    func customerSelected()
}

class CustomerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SortDelegate, customerAddressSelecitonDelegate, GeoFencingSkipDelegate
{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var refreshBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var sortName: UILabel!
    @IBOutlet weak var sortTypeBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var topViewHgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var tpSubtitleLabel: UILabel!
    @IBOutlet weak var tpSubTitleView: UIView!
    @IBOutlet var topViewHeightCont: NSLayoutConstraint!
    @IBOutlet var customerHeaderView: UIView!
    @IBOutlet var segmentViewHeightConst: NSLayoutConstraint!
    
    weak var delegate : CustomerDelegate?
    var regionCode : String?
    var userCode: String?
    var searchBarWrapper : UIView!
    var searchBar : UISearchBar!
    var selectedIndex : Int = 5
    var isAscending : Bool = true
    var selectedName : String = "Name"
    var showSearchBar: Bool = false
    var backFromAsset: Bool = false
    var sectionTitle : [String] = []
    var userWrapperList : [CustomerMasterModel] = []
    var searchedWrappedList : [CustomerMasterModel] = []
    var userCurrentList : [CustomerSortedModel] = []
    var userSortList : [CustomerSortedModel] = []
    var rightBarButtonItem1: UIBarButtonItem!
    var rightBarButtonItem2: UIBarButtonItem!
    var refreshControl: UIRefreshControl!
    var isCustomerMasterEdit: Bool = false
    var doctorListPageSource: Int = Constants.Doctor_List_Page_Ids.Customer_List
    var showTitle = Bool()
    var customerLocation: GeoLocationModel?
    var geoFencingDeviationRemarks: String = EMPTY
    var customerAddressList: [CustomerAddressModel] = []
    var isMultiAddressDelegate: Bool = false
    var autoMoveToEDetailingPage: Bool = false
    var hideEDetailingButton: Bool = false
    var showOrganisation: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 500
        showOrganisation = (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER))
        //        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        //        tableView.estimatedSectionHeaderHeight = 60
        if (showOrganisation == PrivilegeValues.YES.rawValue)
        {
            selectedIndex = 4
            selectedName = "Account"
        }
        else
        {
            selectedIndex = 0
            selectedName = "Name"
        }
        subTitle.text = "\(appDoctorPlural) List"
        sortName.text = selectedName
        sortTypeBtn.setImage(UIImage(named: "icon-stepper-up-arrow"), for: .normal)
        pullDownRefresh()
        //        addBackButtonView()
        addCustomBackButtonToNavigationBar()
        let date = convertDateIntoServerDisplayformat(date: getCurrentDateAndTime())
        tpSubtitleLabel.text = "Today (\( date)) PR \(appDoctorPlural)"
        
        if(isCustomerMasterEdit)
        {
            self.topViewHeightCont.constant = 0
            self.segmentViewHeightConst.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (doctorListPageSource == Constants.Doctor_List_Page_Ids.Mark_Doctor_Location)
        {
            if (!checkInternetConnectivity())
            {
                AlertView.showNoInternetAlert()
                showEmptyStateView(show: false)
                setEmptyStateLbl(type: 3)
                return
            }
        }
        
        if userCurrentList.count == 0 && segmentControl.selectedSegmentIndex == 0
        {
            segmentControl.selectedSegmentIndex = 1
            
            if (isCustomerMasterEdit && !isMultiAddressDelegate)
            {
                getCustomerDataForEdit()
            }
            else
            {
                getCustomerData()
            }
            
            tpSubTitleView.isHidden = true
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
        }
        else if (isCustomerMasterEdit && !isMultiAddressDelegate)
        {
            getCustomerDataForEdit()
        }
        else //if (!isCustomerMasterEdit)
        {
            getCustomerData()
        }
        
        isMultiAddressDelegate = false
        
        getAddressList()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        showSearchBar(flag: false)
        
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        
        // searchBarWrapper.removeFromSuperview()
        // searchBar.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Customer master sorted data
    func getCustomerData()
    {
        regionCode = CustomerModel.sharedInstance.regionCode
        userCode = CustomerModel.sharedInstance.userCode
        self.title = CustomerModel.sharedInstance.navTitle
        
        if regionCode == getRegionCode()
        {
            getCustomerSortedData()
        }
        else
        {
            let doctorList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode!)
            if (doctorList?.count)! > 0
            {
                getCustomerSortedData()
            }
            else
            {
                getCustomerServerData()
            }
        }
    }
    
    private func getCustomerDataForEdit()
    {
        regionCode = CustomerModel.sharedInstance.regionCode
        userCode = CustomerModel.sharedInstance.userCode
        self.title = CustomerModel.sharedInstance.navTitle
        
        if (checkInternetConnectivity())
        {
            getCustomerServerDataForEdit()
        }
        else
        {
            getCustomerSortedDataForEdit()
        }
    }
    
    private func getCustomerSortedData()
    {
        if segmentControl.selectedSegmentIndex == 0
        {
            userWrapperList = BL_DCR_Doctor_Visit.sharedInstance.getConvertedTPDocForSelDateToCustomerModel()!
        }
        else
        {
            userWrapperList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode!)!
        }
        
        self.getSortedList(userWrapperList: userWrapperList , type : 1)
    }
    
    private func getCustomerSortedDataForEdit()
    {
        userWrapperList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterListForEdit(regionCode: regionCode!)
        
        self.getSortedList(userWrapperList: userWrapperList , type : 1)
    }
    
    private func getSortedList(userWrapperList : [CustomerMasterModel], type : Int)
    {
        if selectedIndex == 0
        {
            getNameSortedList(userWrapperList: userWrapperList)
        }
        else if selectedIndex == 1
        {
            getOtherSortedList(userWrapperList: userWrapperList)
            //getMdlNoSortedList(userWrapperList: userWrapperList)
        }
        else if selectedIndex == 2
        {
            getValidCategoryList(userWrapperList: userWrapperList)
            //getOtherSortedList(userWrapperList: userWrapperList)
        }
        else if selectedIndex == 3
        {
            getValidWorkplaceList(userWrapperList: userWrapperList)
           // getValidCategoryList(userWrapperList: userWrapperList)
        }
        else if selectedIndex == 4
        {
            getHospitalNameSortedList(userWrapperList: userWrapperList)
//            getValidWorkplaceList(userWrapperList: userWrapperList)
        }
        else if selectedIndex == 5
        {
            getHospitalNameSortedList(userWrapperList: userWrapperList)
        }
        
        changeCurrentArray(list: userSortList , type : type)
    }
    
    private func getAddressList()
    {
        if (doctorListPageSource == Constants.Doctor_List_Page_Ids.Mark_Doctor_Location)
        {
            customerAddressList = BL_Geo_Location.sharedInstance.getCustomerAddress(regionCode: CustomerModel.sharedInstance.regionCode, customerEntityType: DOCTOR)
        }
    }
    
    private func getNameSortedList(userWrapperList : [CustomerMasterModel])
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        for obj in userWrapperList
        {
            let capitalisedStr = condenseWhitespace(stringValue: obj.Customer_Name).capitalized as NSString
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
            let sortedArray = (arrayOfCharacter as NSArray).sorted { (($0 as! CustomerMasterModel).Customer_Name).localizedCaseInsensitiveCompare((($1 as! CustomerMasterModel).Customer_Name) as String) == ComparisonResult.orderedAscending }
            detailDict.setObject(sortedArray, forKey: eachCharacter)
        }
        
        let unsortedSection:[String] = detailDict.allKeys as! [String]
        
        if isAscending == true
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending })
        }
        else
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending })
        }
        
        userSortList.removeAll()
        
        for char in sectionTitle
        {
            let userObj  = CustomerSortedModel()
            userObj.sectionKey = char
            userObj.userList = detailDict.object(forKey: char) as! [CustomerMasterModel]
            userSortList.append(userObj)
        }
    }
    
    private func getMdlNoSortedList(userWrapperList : [CustomerMasterModel])
    {
        var mdlNoSortedList : [CustomerMasterModel] = []
        
        if userWrapperList.count > 0
        {
            if isAscending == true
            {
                mdlNoSortedList = (userWrapperList).sorted { (($0 ).MDL_Number).localizedCaseInsensitiveCompare((($1 ).MDL_Number) as String) == ComparisonResult.orderedAscending }
            }
            else
            {
                mdlNoSortedList = (userWrapperList).sorted { (($0 ).MDL_Number).localizedCaseInsensitiveCompare((($1 ).MDL_Number) as String) == ComparisonResult.orderedDescending }
            }
            
            let userObj = CustomerSortedModel()
            userObj.userList = mdlNoSortedList
            
            userSortList.removeAll()
            self.sectionTitle = []
            userSortList.append(userObj)
        }
        else
        {
            userSortList = []
        }
    }
    
    
    private func getHospitalNameSortedList(userWrapperList : [CustomerMasterModel])
    {
        
        var validDoctorList : [CustomerMasterModel] = []
        var invalidDoctorList : [CustomerMasterModel] = []
        
        for model in userWrapperList
        {
            let userObj = model as CustomerMasterModel
            if userObj.Hospital_Name != ""
            {
                validDoctorList.append(userObj)
            }
            else
            {
                invalidDoctorList.append(userObj)
            }
        }
        
        userSortList.removeAll()
        sectionTitle.removeAll()
        
        if validDoctorList.count > 0
        {
            getOtherSortedList(userWrapperList: validDoctorList)
        }
        
        if invalidDoctorList.count > 0
        {
            let userObj = CustomerSortedModel()
            userObj.sectionKey = others
            userObj.userList = invalidDoctorList
            
            sectionTitle.append(others)
            userSortList.append(userObj)
        }
    }
    
    private func getOtherSortedList(userWrapperList : [CustomerMasterModel])
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        
        for obj in userWrapperList
        {
            var capitalisedStr : NSString!
            if selectedIndex == 1
            {
                capitalisedStr = condenseWhitespace(stringValue: obj.Speciality_Name).capitalized as NSString
            }
            else if selectedIndex == 2
            {
                capitalisedStr = condenseWhitespace(stringValue: obj.Category_Name!).capitalized as NSString
            }
            else if selectedIndex == 3
            {
                capitalisedStr = condenseWhitespace(stringValue: obj.Local_Area!).capitalized as NSString
            }
            else if selectedIndex == 4
            {
                if obj.Hospital_Account_Number != ""
                {
                    var accountNumber = "(" + ((condenseWhitespace(stringValue: obj.Hospital_Account_Number!).capitalized as NSString) as String) + ")"
                    capitalisedStr = ((condenseWhitespace(stringValue: obj.Hospital_Name!).capitalized as NSString) as String) + "-" + accountNumber as NSString
                }
                else
                {
                    capitalisedStr = condenseWhitespace(stringValue: obj.Hospital_Name!).capitalized as NSString
                }
                //"\(condenseWhitespace(stringValue: obj.Hospital_Name!).capitalized as NSString)\n\(condenseWhitespace(stringValue: obj.Hospital_Account_Number!).capitalized as NSString)" as NSString
                //        header.textLabel?.numberOfLines = 0 //        header.textLabel?.frame = CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.height) //        header.textLabel?.lineBreakMode = .byTruncatingTail //        header.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
            }
            
            var nameList = detailDict.object(forKey: capitalisedStr) as? NSMutableArray
            if nameList == nil
            {
                nameList = NSMutableArray()
                detailDict.setObject(nameList!, forKey: capitalisedStr)
            }
            nameList?.add(obj)
        }
        
        for eachCharacter in detailDict.allKeys as! [NSString]
        {
            let arrayOfCharacter = detailDict.object(forKey: eachCharacter) as! NSArray
            let sortedArray = (arrayOfCharacter as NSArray).sorted { (($0 as! CustomerMasterModel).Customer_Name).localizedCaseInsensitiveCompare((($1 as! CustomerMasterModel).Customer_Name) as String) == ComparisonResult.orderedAscending }
            detailDict.setObject(sortedArray, forKey: eachCharacter)
        }
        
        let unsortedSection:[String] = detailDict.allKeys as! [String]
        
        if isAscending == true
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending })
        }
        else
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending })
        }
        
        userSortList.removeAll()
        
        for char in sectionTitle
        {
            let userObj  = CustomerSortedModel()
            userObj.sectionKey = char
            userObj.userList = detailDict.object(forKey: char) as! [CustomerMasterModel]
            userSortList.append(userObj)
        }
    }
    
    private func getValidWorkplaceList(userWrapperList : [CustomerMasterModel])
    {
        var validWorkPlaceList : [CustomerMasterModel] = []
        var invalidWorkplaceList : [CustomerMasterModel] = []
        
        for model in userWrapperList
        {
            let userObj = model as CustomerMasterModel
            if userObj.Local_Area != ""
            {
                validWorkPlaceList.append(userObj)
            }
            else
            {
                invalidWorkplaceList.append(userObj)
            }
        }
        
        userSortList.removeAll()
        sectionTitle.removeAll()
        
        if validWorkPlaceList.count > 0
        {
            getOtherSortedList(userWrapperList: validWorkPlaceList)
        }
        
        if invalidWorkplaceList.count > 0
        {
            let userObj = CustomerSortedModel()
            userObj.sectionKey = notAssignedSection
            userObj.userList = invalidWorkplaceList
            
            sectionTitle.append(notAssignedSection)
            userSortList.append(userObj)
        }
    }
    
    private func getValidCategoryList(userWrapperList : [CustomerMasterModel])
    {
        var validCategoryList : [CustomerMasterModel] = []
        var invalidCategoryList : [CustomerMasterModel] = []
        
        for model in userWrapperList
        {
            let userObj = model as CustomerMasterModel
            if userObj.Category_Name != ""
            {
                validCategoryList.append(userObj)
            }
            else
            {
                invalidCategoryList.append(userObj)
            }
        }
        
        userSortList.removeAll()
        sectionTitle.removeAll()
        
        if validCategoryList.count > 0
        {
            getOtherSortedList(userWrapperList: validCategoryList)
        }
        
        if invalidCategoryList.count > 0
        {
            let userObj = CustomerSortedModel()
            userObj.sectionKey = notAssignedSection
            userObj.userList = invalidCategoryList
            
            sectionTitle.append(notAssignedSection)
            userSortList.append(userObj)
        }
    }
    
    func changeCurrentArray(list:[CustomerSortedModel] , type : Int)
    {
        if list.count > 0
        {
            userCurrentList = list
            self.tableView.reloadData()
            
            if let detailViewController = self.delegate as? DoctorDetailsViewController
            {
                if backFromAsset == false
                {
                    var defaultSelection: Bool = true
                    
                    if (BL_Geo_Location.sharedInstance.isGeoLocationMandatoryPrivEnabled() && BL_Geo_Location.sharedInstance.isGeoFencingEnabled() && self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
                    {
                        defaultSelection = false
                    }
                    
                    if (defaultSelection)
                    {
                        let userList = userCurrentList[0].userList[0]
                        BL_DoctorList.sharedInstance.regionCode = userList.Region_Code
                        BL_DoctorList.sharedInstance.customerCode = userList.Customer_Code
                        BL_DoctorList.sharedInstance.doctorTitle = userList.Customer_Name
                        
                        detailViewController.isEmptyState = true
                        self.delegate?.customerSelected()
                    }
                    else
                    {
                        if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List && SwifterSwift().isPad)
                        {
                            detailViewController.isEmptyState = true
                            BL_DoctorList.sharedInstance.doctorTitle = EMPTY
                        }
                    }
                }
                
                if backFromAsset == true
                {
                    backFromAsset = false
                }
                
                //splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
            }
            
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
        if show == true
        {
            self.navigationItem.rightBarButtonItems = nil
            if(!showTitle)
            {
                self.title = CustomerModel.sharedInstance.navTitle
            }
            
        }
        else
        {
            if showSearchBar
            {
                self.navigationItem.rightBarButtonItems = nil
                self.title = ""
            }
            else
            {
                if segmentControl.selectedSegmentIndex == 0  {
                    self.navigationItem.rightBarButtonItems = nil
                    self.navigationItem.rightBarButtonItems = [rightBarButtonItem2]
                }else{
                    self.navigationItem.rightBarButtonItems = nil
                    self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
                }
                if(!showTitle)
                {
                    self.title = CustomerModel.sharedInstance.navTitle
                }
            }
        }
        self.emptyStateWrapper.isHidden = !show
        self.mainView.isHidden = false
        if(show)
        {
            self.tableView.isHidden = true
            self.tpSubTitleView.isHidden = true
            self.customerHeaderView.isHidden = true
        }
        else
        {
            self.tableView.isHidden = false
            self.tpSubTitleView.isHidden = true
            self.customerHeaderView.isHidden = false
        }
        
    }
    
    func setEmptyStateLbl(type : Int)
    {
        self.emptyStateWrapper.isHidden = false
        var emptyStateTxt  :String = ""
        
        if type == 1
        {
            if segmentControl.selectedSegmentIndex == 0
            {
                let date = convertDateIntoString(date: getCurrentDateAndTime())
                //"No PR \(appDoctorPlural) found for Today (\( date))"
                emptyStateTxt = "No PR \(appDoctorPlural) found for Today"
            }
            else
            {
                emptyStateTxt = "No \(appDoctorPlural) found"
            }
            
            refreshBtn.isHidden = false
            refreshBtnHeightConst.constant = 30.0
            if(!isCustomerMasterEdit)
            {
                self.topViewHeightCont.constant = 52
                self.segmentViewHeightConst.constant = 32
            }
            else
            {
                self.topViewHeightCont.constant = 0
                self.segmentViewHeightConst.constant = 0
            }
        }
        else
        {
            if segmentControl.selectedSegmentIndex == 0
            {
                let date = convertDateIntoServerDisplayformat(date: getCurrentDateAndTime())
                //"No PR \(appDoctorPlural) found for Today (\( date)). Clear your search and try again."
                emptyStateTxt = "No PR \(appDoctorPlural) found for Today. Clear your search and try again."
            }
            else
            {
                emptyStateTxt = "No \(appDoctorPlural) found. Clear your search and try again."
            }
            
            refreshBtn.isHidden = true
            refreshBtnHeightConst.constant = 0.0
        }
        self.emptyStateLbl.text = emptyStateTxt
        
        if segmentControl.selectedSegmentIndex == 0
        {
            refreshBtn.isHidden = true
        }
        else
        {
            refreshBtn.isHidden = false
        }
        
        if type == 3
        {
            self.emptyStateLbl.text = "No \(appDoctorPlural) found"
            
            refreshBtn.isHidden = true
            refreshBtnHeightConst.constant = 0
            self.topViewHeightCont.constant = 0
            self.segmentViewHeightConst.constant = 0
            self.navigationItem.rightBarButtonItems = []
        }
    }
    
    @IBAction func sortTypeAction(_ sender: Any)
    {
        if isAscending == true
        {
            isAscending = false
            sortTypeBtn.setImage(UIImage(named: "icon-stepper-down-arrow"), for: .normal)
        }
        else
        {
            isAscending = true
            sortTypeBtn.setImage(UIImage(named: "icon-stepper-up-arrow"), for: .normal)
        }
        
        if showSearchBar
        {
            getSortedList(userWrapperList: searchedWrappedList, type: 1)
        }
        else
        {
            getSortedList(userWrapperList: userWrapperList, type: 1)
        }
        
        resignSearchBar()
    }
    
    private func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing..")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh()
    {
        if(!isCustomerMasterEdit)
        {
            getCustomerServerData()
        }
        else
        {
            getCustomerServerDataForEdit()
        }
        
    }
    
    private func endRefresh()
    {
        removeCustomActivityView()
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    private func resignSearchBar()
    {
        if searchBar.isFirstResponder
        {
            searchBar.resignFirstResponder()
        }
    }
    
    
    @IBAction func didTapSegmentControlBtn(_ sender: Any) {
        
        if self.searchBar != nil{
            showSearchBar(flag: false)
            self.searchBar.resignFirstResponder()
        }
        let segmentBtn = sender as! UISegmentedControl
        if segmentBtn.selectedSegmentIndex == 0  {
            tpSubTitleView.isHidden = false
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.rightBarButtonItems = [rightBarButtonItem2]
        } else {
            tpSubTitleView.isHidden = true
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
        }
        getCustomerData()
        // tableView.scrollsToTop = true
        self.topViewHeightCont.constant = 52
        self.segmentViewHeightConst.constant = 32
        
    }
    
    //MARK :-Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.title = ""
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
                return userWrapperObj.Customer_Name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.MDL_Number).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Category_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Speciality_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Local_Area).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Account_Number).lowercased().contains(loweredSeachString)
            }
            searchedWrappedList = userWrapperModelArray
            //            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
            //            {
            //                getOtherSortedList(userWrapperList : userWrapperModelArray)
            //            }
            //            else
            //            {
            //                getNameSortedList(userWrapperList: userWrapperModelArray)
            //            }
            getSortedList(userWrapperList : userWrapperModelArray , type : 2)
        }
        else
        {
            searchedWrappedList = []
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
        showSearchBar(flag: false)
        
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.getSortedList(userWrapperList : userWrapperList , type : 1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if sectionTitle.count > 0
        {
            return sectionTitle.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if sectionTitle.count > 0
        {
            return sectionTitle[section]
        }
        else
        {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if sectionTitle.count > 0
        {
            return 34
        }
        else
        {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white//UIColor(red: 135/250, green: 206/250, blue: 250/250, alpha: 1.0)
        //        header.textLabel?.numberOfLines = 0
        //        header.textLabel?.frame = CGRect(x: 0, y: 0, width: header.frame.size.width, height: header.frame.size.height)
        //        header.textLabel?.lineBreakMode = .byWordWrapping
        //        header.textLabel?.font = UIFont.systemFont(ofSize: 14.0) 135-206-250
        header.contentView.backgroundColor = UIColor(red: 20/250, green: 126/250, blue: 251/250, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        if selectedIndex == 0
        {
            return sectionTitle.index(of: title)!
        }
        else
        {
            return 0
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        if selectedIndex == 0
        {
            return sectionTitle
        }
        else
        {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if userCurrentList.count > 0
        {
            return userCurrentList[section].userList.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListCell) as! DoctorListTableViewCell
        
        let userList = userCurrentList[indexPath.section].userList[indexPath.row]
        cell.doctorNameLbl.text = userList.Customer_Name
        var attString3 = NSMutableAttributedString()
        var status = String()
        if(!isCustomerMasterEdit)
        {
            status = ""
        }
        else
        {
            if(userList.Customer_Status == 1)
            {
                status = " | \(approved)"
            }
            else if(userList.Customer_Status == 2)
            {
                status = " | \(applied)"
            }
            else
            {
                status = ""
            }
        }
        //        var userDetail = "\(ccmNumberPrefix)\(checkNullAndNilValueForString(stringData: userList.MDL_Number) as String) | \(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
        //
        //
        //        if userList.Local_Area != ""
        //        {
        //            userDetail = "\(userDetail) | \(String(describing: userList.Local_Area!))" + status
        //        }
        //        else
        //        {
        //             userDetail = "\(userDetail) " + status
        //        }
        if (showOrganisation == PrivilegeValues.YES.rawValue)
        {
            if userList.Hospital_Account_Number != "" || userList.Hospital_Name != ""
            {
                var hospitalDetails = "\(checkNullAndNilValueForString(stringData: userList.Hospital_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Hospital_Account_Number) as String)"
                
//                var userDetail = "\n\(ccmNumberPrefix)\(checkNullAndNilValueForString(stringData: userList.MDL_Number) as String) | \(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
                
                var userDetail = "\n\(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
                
                
                if userList.Local_Area != ""
                {
                    userDetail = "\(userDetail) | \(String(describing: userList.Local_Area!))" + status
                }
                else
                {
                    userDetail = "\(userDetail) " + status
                }
                
                let attString1 = NSMutableAttributedString.init(string: userDetail)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                
                attString3.append(attString2)
                attString3.append(attString1)
            }
                
            else
            {
                //var hospitalDetails = "\(checkNullAndNilValueForString(stringData: userList.Hospital_Name) as String)"
//                var userDetail = "\n\(ccmNumberPrefix)\(checkNullAndNilValueForString(stringData: userList.MDL_Number) as String) | \(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
                
                 var userDetail = "\n\(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
                if userList.Local_Area != ""
                {
                    userDetail = "\(userDetail) | \(String(describing: userList.Local_Area!))" + status
                }
                else
                {
                    userDetail = "\(userDetail) " + status
                }
                let attString1 = NSMutableAttributedString.init(string: userDetail)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                //let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                
                //attString3.append(attString2)
                attString3.append(attString1)
            }
            
        }else{
            
            //var hospitalDetails = "\(checkNullAndNilValueForString(stringData: userList.Hospital_Name) as String)"
//            var userDetail = "\n\(ccmNumberPrefix)\(checkNullAndNilValueForString(stringData: userList.MDL_Number) as String) | \(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
            
             var userDetail = "\n\(checkNullAndNilValueForString(stringData: userList.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: userList.Region_Name) as String)"
            
            if userList.Local_Area != ""
            {
                userDetail = "\(userDetail) | \(String(describing: userList.Local_Area!))" + status
            }
            else
            {
                userDetail = "\(userDetail) " + status
            }
            let attString1 = NSMutableAttributedString.init(string: userDetail)
            let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
            //let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
            
            //attString3.append(attString2)
            attString3.append(attString1)
            
        }
        
        cell.doctorDetailsLbl.attributedText = attString3
        
        cell.wrapperView.backgroundColor = UIColor.white
        cell.locationImageView.isHidden = true
        cell.locationImageViewWidthConstraint.constant = 0
        
        if (doctorListPageSource == Constants.Doctor_List_Page_Ids.Mark_Doctor_Location)
        {
            cell.locationImageView.isHidden = false
            cell.locationImageViewWidthConstraint.constant = 24
            
            let filteredArray = customerAddressList.filter{
                $0.Customer_Code == userList.Customer_Code && $0.Region_Code == userList.Region_Code && $0.Latitude != 0 && $0.Longitude != 0
            }
            
            if (filteredArray.count > 0)
            {
                cell.locationImageView.image = UIImage(named: "ic_edit_location")
                cell.locationImageView.tintColor = UIColor.blue
            }
            else
            {
                cell.locationImageView.image = UIImage(named: "ic_add_location")
                cell.locationImageView.tintColor = UIColor.black
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let detailViewController = self.delegate as? DoctorDetailsViewController
        {
            let userList = userCurrentList[indexPath.section].userList[indexPath.row]
            BL_DoctorList.sharedInstance.selectedCustomer = userList
            BL_DoctorList.sharedInstance.regionCode = userList.Region_Code
            BL_DoctorList.sharedInstance.customerCode = userList.Customer_Code
            BL_DoctorList.sharedInstance.doctorTitle = userList.Customer_Name
            
            //self.delegate?.customerSelected()
            //splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
            self.customerLocation = nil
            self.geoFencingDeviationRemarks = EMPTY
            self.autoMoveToEDetailingPage = false
            self.hideEDetailingButton = false
            
            if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Doctor_Master_Edit)
            {
                moveToDoctorDetailPage()
            }
            else if (self.doctorListPageSource != Constants.Doctor_List_Page_Ids.Doctor_Master_Edit)
            {
                let currentAddress = getCurrentLocaiton()
                
                if (BL_Geo_Location.sharedInstance.isGeoLocationMandatoryPrivEnabled())
                {
                    let lstAddress = BL_Geo_Location.sharedInstance.getCustomerAddress(customerCode: userList.Customer_Code, regionCode: userList.Region_Code, customerEntityType: DOCTOR)
                    
                    if (lstAddress.count > 1)
                    {
                        if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
                        {
                            if (SwifterSwift().isPad)
                            {
                                moveToDoctorDetailPage()
                                self.autoMoveToEDetailingPage = true
                            }
                        }
                        moveToCustomerAddressView(addressList: lstAddress, indexPath: indexPath, currentLocation: currentAddress)
                    }
                    else
                    {
                        selectSingleAddress(indexPath: indexPath, customerAddressList: lstAddress, currentLocation: currentAddress)
                    }
                }
                else
                {
                    moveToDoctorDetailPage()
                }
            }
        }
        /*  else if (self.isCustomerMasterEdit)
         {
         let userList = userCurrentList[indexPath.section].userList[indexPath.row]
         BL_DoctorList.sharedInstance.regionCode = userList.Region_Code
         BL_DoctorList.sharedInstance.customerCode = userList.Customer_Code
         BL_DoctorList.sharedInstance.doctorTitle = userList.Customer_Name
         
         let sb = UIStoryboard(name:Constants.StoaryBoardNames.SplitViewSb, bundle: nil)
         let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomerVCID) as! CustomerTableViewController
         vc.backFromAsset = false
         vc.isCustomerMasterEdit = true
         
         self.navigationController?.pushViewController(vc, animated: true)
         }*/
    }
    
    private func moveToCustomerAddressView(addressList: [CustomerAddressModel], indexPath: IndexPath, currentLocation: GeoLocationModel)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomerAddressVCId) as! CustomerAddressViewController
        vc.addressList = addressList
        vc.objCustomer = userCurrentList[indexPath.section].userList[indexPath.row]
        vc.delegate = self
        vc.indexPath = indexPath
        vc.currentLocation = currentLocation
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectAddres(indexPath: IndexPath, customerAddressList: [CustomerAddressModel], currentLocation: GeoLocationModel)
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
        }
        
        self.isMultiAddressDelegate = true
        
        selectSingleAddress(indexPath: indexPath, customerAddressList: customerAddressList, currentLocation: currentLocation)
    }
    
    private func selectSingleAddress(indexPath: IndexPath, customerAddressList: [CustomerAddressModel], currentLocation: GeoLocationModel)
    {       let customerName = userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name
        
        if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
        {
            //let currentLocation = getCurrentLocaiton()
            let doctorLocationsList = convertCustomerAddressModelToGeoLocaitonModel(customerAddressList: customerAddressList)
            
            let objGeoValidation = BL_Geo_Location.sharedInstance.doGeoLocationAndFencingValidations(userLocation: currentLocation, doctorLocationsList: doctorLocationsList, viewController: self, customerName: customerName!)
            
            self.geoFencingDeviationRemarks = objGeoValidation.Remarks
            
            if (objGeoValidation.Customer_Location != nil)
            {
                confirmCustomerAddressAlert(indexPath: indexPath, currentLocaiton: currentLocation, objGeoValidation: objGeoValidation)
            }
            else
            {
                if (autoMoveToEDetailingPage && objGeoValidation.Status == 1)
                {
                    tapEventForiPad()
                }
                
                proceedDCR(indexPath: indexPath, currentLocation: currentLocation, objGeoValidation: objGeoValidation)
            }
            
        }
        else if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Mark_Doctor_Location)
        {
            if canShowLocationMandatoryAlert()
            {
                AlertView.showAlertToEnableGPS()
                return
            }
            
            if (customerAddressList.count > 0)
            {
                confirmAddressUpdate(indexPath: indexPath, objLocation: customerAddressList.first!)
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: "Sorry. No address details found for this \(appDoctor)")
            }
            
            if (SwifterSwift().isPad)
            {
                moveToDoctorDetailPage()
            }
        }
        else
        {
            moveToDoctorDetailPage()
        }
    }
    
    private func convertCustomerAddressModelToGeoLocaitonModel(customerAddressList: [CustomerAddressModel]) -> [GeoLocationModel]
    {
        var lstCustomerLocations: [GeoLocationModel] = []
        
        for objAddress in customerAddressList
        {
            let objGeoLocationModel = GeoLocationModel()
            
            objGeoLocationModel.Latitude = objAddress.Latitude
            objGeoLocationModel.Longitude = objAddress.Longitude
            objGeoLocationModel.Address_Id = objAddress.Address_Id
            
            lstCustomerLocations.append(objGeoLocationModel)
        }
        
        return lstCustomerLocations
    }
    
    private func showGeoFencingDeviationAlertWithSkip(indexPath: IndexPath, currentLocaiton: GeoLocationModel)
    {
        let customerName = userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name!
        
        let alertViewController = UIAlertController(title: alertTitle, message: "You are away from the \(customerName)'s location. \n\n Please tap on SKIP button to enter the reason for skip and then proceed further \n\n Please tap on CANCEL button not to proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            if (SwifterSwift().isPad)
            {
                if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
                {
                    self.hideEDetailingButton = true
                    self.moveToDoctorDetailPage()
                }
            }
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "SKIP", style: UIAlertActionStyle.default, handler: { alertAction in
            self.skipAction(indexPath: indexPath, currentLocaiton: currentLocaiton)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func skipAction(indexPath: IndexPath, currentLocaiton: GeoLocationModel)
    {
        let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.GeoFencingSkipRemarksVCId) as! GeoLocationSkipViewController
        vc.delegate = self
        vc.indexPath = indexPath
        vc.currentLocation = currentLocaiton
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        self.present(vc, animated: false, completion: nil)
    }
    
    private func confirmCustomerAddressAlert(indexPath: IndexPath, currentLocaiton: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        let customerName = userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name!
        
        let alertViewController = UIAlertController(title: alertTitle, message: "We have not found any location info for this address. Are you at \(customerName)'s location now ? \n\n Tap on YES button to update the current location as \(customerName)'s location \n\n Tap on NO button not to update any location info and proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.confrimAddressYesButtonAction(indexPath: indexPath, currentLocation: currentLocaiton, objGeoValidation: objGeoValidation)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            self.autoMoveToEDetailingPage = true
            self.tapEventForiPad()
            self.proceedDCR(indexPath: indexPath, currentLocation: currentLocaiton, objGeoValidation: objGeoValidation)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func confirmAddressUpdate(indexPath: IndexPath, objLocation: CustomerAddressModel)
    {
        let customerName = userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name!
        
        let alertViewController = UIAlertController(title: alertTitle, message: "Please confirm you are at \(customerName)'s location. \n\n Tap on YES button to update the current location as the \(customerName)'s location \n\n Tap on NO button to cancel this action", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.updateDoctorAddress(objCustomerAddress: objLocation)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func updateDoctorAddress(objCustomerAddress: CustomerAddressModel)
    {
        let objAddress = convertCustomerAddressModelToGeoLocaitonModel(customerAddressList: [objCustomerAddress])
        let currentAddress = getCurrentLocaiton()
        currentAddress.Address_Id = objAddress[0].Address_Id
        
        BL_Geo_Location.sharedInstance.updateCustomerLocation(customerLocation: currentAddress, pageSource: Constants.Geo_Fencing_Page_Names.MARK_DOCTOR_LOCATION)
        
        showCustomActivityIndicatorView(loadingText: "Updating location. Please wait...")
        
        BL_Geo_Location.sharedInstance.uploadCustomerAddress { (status) in
            removeCustomActivityView()
            if (status == SERVER_SUCCESS_CODE)
            {
                showToastView(toastText: "Address updated")
                self.getAddressList()
                self.tableView.reloadData()
            }
            else
            {
                showToastView(toastText: "Sorry. Unable to update the location")
            }
        }
    }
    
    private func confrimAddressYesButtonAction(indexPath: IndexPath, currentLocation: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        if (objGeoValidation.Customer_Location != nil)
        {
            self.customerLocation = objGeoValidation.Customer_Location
            BL_Geo_Location.sharedInstance.updateCustomerLocation(customerLocation: objGeoValidation.Customer_Location!, pageSource: Constants.Geo_Fencing_Page_Names.EDETAILING)
        }
        self.autoMoveToEDetailingPage = true
        self.tapEventForiPad()
        proceedDCR(indexPath: indexPath, currentLocation: currentLocation, objGeoValidation: objGeoValidation)
    }
    
    private func proceedDCR(indexPath: IndexPath, currentLocation: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        if (objGeoValidation.Status == 1)
        {
            moveToDoctorDetailPage()
        }
        else if (objGeoValidation.Status == 2)
        {
            self.showGeoFencingDeviationAlertWithSkip(indexPath: indexPath, currentLocaiton: currentLocation)
        }
        else if (objGeoValidation.Status == 3)
        {
            AlertView.showAlertToCaptureGPS()
        }
        else if (objGeoValidation.Status == 0)
        {
            if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
            {
                if (SwifterSwift().isPad)
                {
                    self.hideEDetailingButton = true
                    moveToDoctorDetailPage()
                }
            }
        }
    }
    
    func saveSkipRemarks(remarks: String, isCancelled: Bool, indexPath: IndexPath, currentLocation: GeoLocationModel)
    {
        self.geoFencingDeviationRemarks = remarks
        
        if (!isCancelled)
        {
            self.autoMoveToEDetailingPage = true
            tapEventForiPad()
            moveToDoctorDetailPage()
        }
        else
        {
            if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
            {
                if (SwifterSwift().isPad)
                {
                    self.hideEDetailingButton = true
                    moveToDoctorDetailPage()
                }
            }
        }
    }
    
    private func moveToDoctorDetailPage()
    {
        if (self.autoMoveToEDetailingPage && self.hideEDetailingButton == false)
        {
            tapEventForiPad()
        }
        
        if let detailViewController = self.delegate as? DoctorDetailsViewController
        {
            detailViewController.isEmptyState = false
            detailViewController.isCustomerMasterEdit = self.isCustomerMasterEdit
            detailViewController.doctorListPageSource = self.doctorListPageSource
            detailViewController.customerLocation = self.customerLocation
            detailViewController.geoFencingDeviationRemarks = self.geoFencingDeviationRemarks
            detailViewController.autoMoveToEDetailingPage = self.autoMoveToEDetailingPage
            detailViewController.hideEDetailingButton = self.hideEDetailingButton
            
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
        
        self.delegate?.customerSelected()
    }
    
    //MARK:- Scroll view delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        resignSearchBar()
    }
    
    //MARK:- Custom Navigation bar
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        let sortButton = UIButton(type: UIButtonType.custom)
        sortButton.addTarget(self, action: #selector(self.sortButtonClicked), for: UIControlEvents.touchUpInside)
        sortButton.setImage(UIImage(named: "icon-sort"), for: .normal)
        sortButton.sizeToFit()
        rightBarButtonItem1 = UIBarButtonItem(customView: sortButton)
        
        let searchButton = UIButton(type: UIButtonType.custom)
        searchButton.addTarget(self, action: #selector(self.searchButtonClicked), for: UIControlEvents.touchUpInside)
        searchButton.setImage(UIImage(named: "icon-search"), for: .normal)
        searchButton.sizeToFit()
        rightBarButtonItem2 = UIBarButtonItem(customView: searchButton)
        
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
        
        searchBarWrapper = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: searchBarWrapper.frame.size.width, height: 44.0))
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor.blue
        searchBar.placeholder = "Search.."
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(), for: UISearchBarIcon.search, state: UIControlState.normal)
        searchBar.tintColor = UIColor.black
        for view in searchBar.subviews {
            for subview in view.subviews {
                if let button = subview as? UIButton {
                    button.isEnabled = true
                    button.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
        searchBarWrapper.addSubview(searchBar)
        navigationController?.navigationBar.addSubview(searchBarWrapper)
    }
    
    @objc func backButtonClicked()
    {
        getAppDelegate().allocateRootViewController(sbName: landingViewSb, vcName:landingVcID)
    }
    
    @objc func sortButtonClicked()
    {
        let sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.SortVCID) as! SortViewController
        vc.delegate = self
        vc.selectedIndex = selectedIndex
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func searchButtonClicked()
    {
        showSearchBar(flag: true)
    }
    
    func showSearchBar(flag : Bool)
    {
        self.showTitle = flag
        if flag == true
        {
            searchBarWrapper.frame = CGRect(x: 10.0, y: 0.0, width: (self.view.frame.size.width - 20.0), height: 44.0)
            searchBar.frame = CGRect(x: 0.0, y: 0.0, width: searchBarWrapper.frame.size.width, height: 44.0)
            self.navigationItem.rightBarButtonItems = nil
            self.title = ""
            searchBar.becomeFirstResponder()
        }
        else
        {
            searchBarWrapper.frame = CGRect(x: 10.0, y: 0.0, width: 0.0, height: 44.0)
            searchBar.frame = CGRect(x: 10.0, y: 0.0, width: 0.0, height: 44.0)
            self.navigationItem.rightBarButtonItems = [rightBarButtonItem1, rightBarButtonItem2]
            self.title = CustomerModel.sharedInstance.navTitle
            resignSearchBar()
        }
        
        showSearchBar = flag
    }
    
    //MARK:- Custom delegate method
    func getSelectedIndex(index: Int, name: String)
    {
        selectedIndex = index
        selectedName = name
        sortName.text = selectedName
        
        isAscending = true
        getSortedList(userWrapperList: userWrapperList, type: 1)
    }
    
    //MARK:- Service call
    func getCustomerServerData()
    {
        if refreshControl.isRefreshing == false
        {
            showActivityIndicator()
        }
        
        WebServiceHelper.sharedInstance.getCustomerDataByRegionCode(userCode: userCode!, regionCode: regionCode!) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.deleteCustomerDataByRegionCode(regionCode: self.regionCode!, customerEntityType: DOCTOR)
                DBHelper.sharedInstance.deleteCustomerPersonalInfoByRegionCode(regionCode: self.regionCode!)
                
                if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                {
                    DBHelper.sharedInstance.insertCustomerMaster(array: apiResponseObj.list)
                    DBHelper.sharedInstance.insertCustomerMasterPersonalInfo(array: apiResponseObj.list)
                }
                
                BL_PrepareMyDevice.sharedInstance.getMCDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: self.regionCode!, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: self.regionCode!, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDevice.sharedInstance.getCustomerAddress(masterDataGroupName: EMPTY, selectedRegionCode: self.regionCode!, completion: { (status) in
                                    self.showErrorToast(statusCode: status)
                                })
                            }
                            else
                            {
                                self.showErrorToast(statusCode: status)
                            }
                        })
                    }
                    else
                    {
                        self.showErrorToast(statusCode: status)
                    }
                })
            }
            else
            {
                self.showErrorToast(statusCode: apiResponseObj.Status)
            }
            
            self.getCustomerSortedData()
            
            self.showSearchBar(flag: false)
        }
    }
    
    private func showErrorToast(statusCode: Int)
    {
        self.endRefresh()
        
        if (statusCode != SERVER_SUCCESS_CODE)
        {
            if statusCode == NO_INTERNET_ERROR_CODE
            {
                showToastView(toastText: internetOfflineMessage)
            }
            else
            {
                showToastView(toastText: "Unable to download the \(appDoctorPlural)..")
            }
        }
    }
    
    func getCustomerServerDataForEdit()
    {
        if refreshControl.isRefreshing == false
        {
            showActivityIndicator()
        }
        
        WebServiceHelper.sharedInstance.getCustomerDataByRegionCodeForEdit(userCode: userCode!, regionCode: regionCode!) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            removeCustomActivityView()
            self.endRefresh()
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                {
                    DBHelper.sharedInstance.deleteCustomerDataByRegionCodeForEdit(regionCode: self.regionCode!, customerEntityType: DOCTOR)
                    DBHelper.sharedInstance.deleteCustomerPersonalInfoByRegionCodeForEdit(regionCode: self.regionCode!)
                    DBHelper.sharedInstance.insertCustomerMasterEdit(array: apiResponseObj.list)
                    DBHelper.sharedInstance.insertCustomerMasterPersonalInfoEdit(array: apiResponseObj.list)
                }
                
                //                self.addCustomBackButtonToNavigationBar()
            }
            else
            {
                if statusCode == NO_INTERNET_ERROR_CODE
                {
                    showToastView(toastText: internetOfflineMessage)
                }
                else
                {
                    showToastView(toastText: "Unable to download the \(appDoctorPlural)..")
                }
            }
            
            self.getCustomerSortedDataForEdit()
            
            self.showSearchBar(flag: false)
        }
    }
    
    func showActivityIndicator()
    {
        if mainView.isHidden == false
        {
            mainView.isHidden = true
        }
        
        if emptyStateWrapper.isHidden == false
        {
            emptyStateWrapper.isHidden = true
        }
        
        showCustomActivityIndicatorView(loadingText: "Loading the \(appDoctorPlural)..")
    }
    
    @IBAction func refreshAction(_ sender: Any)
    {
        if checkInternetConnectivity()
        {
            if (isCustomerMasterEdit)
            {
                getCustomerServerDataForEdit()
            }
            else
            {
                getCustomerServerData()
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func tapEventForiPad()
    {
        if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List && SwifterSwift().isPad)
        {
            showToastView(toastText: "Thank You! Please tap on eDetailing button to proceed further")
            self.autoMoveToEDetailingPage = false
        }
    }
}
