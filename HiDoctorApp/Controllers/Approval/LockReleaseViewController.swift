//
//  LockReleaseViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 04/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LockReleaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate
{
    //MARK:- Outlet Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var buttonViewHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cancelButt: UIButton!
    @IBOutlet weak var unLockButt: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    
    var sectionMenu : [Character] = []
    var refreshControl: UIRefreshControl!
    
    var approvalUserObj: ApprovalUserMasterModel!
    var lockReleaseArray: [NSDictionary] = []
    var activityLockArray: [NSDictionary] = []
    var editMode: Bool = false
    var isFromDoctorApproval : Bool = false
    var customerStatus = Int()
    var doctorApprovalList = [DoctorApprovalModelDict]()
    var doctorApprovalSearchList = [DoctorApprovalModelDict]()
    var doctorApprovalArray = [DoctorApprovalModelArray]()
    var tpFreezeDataList : [TPFreezeLockDict] = []
    var isFromDCRActivityLock : Bool = false
    var isFromTpFreezeLock: Bool = false
    var selectedMonth = String()
    var selectedYear = String()
    
    //MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchView.isHidden = true
        self.searchViewHeightConst.constant = 0
        if(isFromDoctorApproval)
        {
            if(customerStatus == 1)
            {
               unLockButt.isHidden = true
            }
            else
            {
                unLockButt.isHidden = false
            }
            cancelButt.setTitle("Reject", for: .normal)
            unLockButt.setTitle("Approve", for: .normal)
            pullDownRefresh()
            self.searchView.isHidden = false
            self.searchViewHeightConst.constant = 40
        }
        else
        {
            cancelButt.setTitle("Cancel", for: .normal)
            unLockButt.setTitle("Unlock", for: .normal)
        }
        doInitialSetup()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)
        if(isFromDCRActivityLock)
        {
          self.title = "\(PEV_DCR) Activity Lock Release"
        }
        else if(isFromTpFreezeLock)
        {
          self.title = "\(PEV_TP) Unfreeze"
        }
        else
        {
            self.title = "\(PEV_DCR) Lock Release"
        }
        getLockReleaseData(type:1)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Functions
    
    //MARK:-- Web Service Functions
    private func getLockReleaseData(type:Int)
    {
        if(isFromDoctorApproval)
        {
            if (checkInternetConnectivity())
            {
                if(type == 1)
                {
                    showLoader()
                }
                
                BL_Approval.sharedInstance.getDoctorApprovalDoctorDetail(regionCode: approvalUserObj.Region_Code, customerStatus: customerStatus) { (apiResponseObj) in
                    if(type == 1)
                    {
                        self.hideLoader()
                    }
                    self.getLockReleaseDataCallBack(apiResponseObj: apiResponseObj)
                    if type == 2
                    {
                        self.showSuccessToast()
                    }
                    self.endRefresh()
                }
                
            }
            else
            {
                showEmptyStateView()
            }
        }
        else if(isFromTpFreezeLock)
        {
            if (checkInternetConnectivity())
            {
                showLoader()
                
                BL_Approval.sharedInstance.gettpFreezeDetailsForUser(userCode: approvalUserObj.User_Code, selectedMonth: selectedMonth, selectedYear: selectedYear) { (apiResponseObj) in
                    self.hideLoader()
                    self.getLockReleaseDataCallBack(apiResponseObj: apiResponseObj)
                }
            }
            else
            {
                showEmptyStateView()
            }
        }
        else if(isFromDCRActivityLock)
        {
            if (checkInternetConnectivity())
            {
                showLoader()
                
                BL_Approval.sharedInstance.getActivityLockLeaveDetailsForUser(userCode: approvalUserObj.User_Code, regionCode: approvalUserObj.Region_Code) { (apiResponseObj) in
                    self.hideLoader()
                    self.getLockReleaseDataCallBack(apiResponseObj: apiResponseObj)
                }
            }
            else
            {
                showEmptyStateView()
            }
        }
        else
        {
            if (checkInternetConnectivity())
            {
                showLoader()
                
                BL_Approval.sharedInstance.getLockLeaveDetailsForUser(userCode: approvalUserObj.User_Code, regionCode: approvalUserObj.Region_Code) { (apiResponseObj) in
                    self.hideLoader()
                    self.getLockReleaseDataCallBack(apiResponseObj: apiResponseObj)
                }
            }
            else
            {
                showEmptyStateView()
            }
        }
    }
    
    private func getLockReleaseDataCallBack(apiResponseObj: ApiResponseModel)
    {
        if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
        {
            if(isFromDoctorApproval)
            {
                guard let data = try? JSONSerialization.data(withJSONObject: apiResponseObj.list, options: []) else {
                    return
                }
                let doctorApprovalData = String(data: data, encoding: String.Encoding.utf8)
                doctorApprovalList = try! JSONDecoder().decode([DoctorApprovalModelDict].self, from: (doctorApprovalData?.data(using: .utf8)!)!)
                self.generateDoctorApprovalData(doctorApprovalList: doctorApprovalList)
                addSelectBut()
            }
            else if(isFromTpFreezeLock)
            {
                guard let data = try? JSONSerialization.data(withJSONObject: apiResponseObj.list, options: []) else {
                    return
                }
                //TPFreezeLockDict
                tpFreezeDataList = try! JSONDecoder().decode([TPFreezeLockDict].self, from: data)
                if(tpFreezeDataList.count>0)
                {
                    emptyStateView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
                else
                {
                   
                    setEmptyStateTitle(message:"No PRFreeze lock found")
                    emptyStateView.isHidden = false
                    self.tableView.isHidden = true
                }
                
                addMenuButton()
                
            }
            else if(isFromDCRActivityLock)
            {
                generateActivityLockReleaseData(list: apiResponseObj.list)
                addMenuButton()
            }
            else
            {
                generateLockReleaseData(list: apiResponseObj.list)
                addMenuButton()
            }
            if(!isFromTpFreezeLock)
            {
                reloadTableView()
                setUserName(name: approvalUserObj.Employee_Name)
                showMainView()
            }
        }
        else
        {
            showEmptyStateView()
        }
    }
    
    private func generateDoctorApprovalData(doctorApprovalList:[DoctorApprovalModelDict])
    {
        sectionMenu = []
        doctorApprovalArray = []
        if doctorApprovalList.count > 0
        {
            for contentList in doctorApprovalList
            {
                let empName = String(contentList.Customer_Name!.capitalized.first!)
                if !sectionMenu.contains((empName.first)!)
                {
                    sectionMenu.append((empName.first!))
                }
            }
            sectionMenu.sort(by: {(ch1, ch2) -> Bool in
                ch1 < ch2
            })
            
            var doctorApprove = [DoctorApprovalModelDict]()
            for secMenu in sectionMenu
            {
                print(secMenu)
                for contentList in doctorApprovalList
                {
                    if contentList.Customer_Name!.capitalized.first == secMenu
                    {
                        doctorApprove.append(contentList)
                    }
                }
                let dict = ["first":"\(secMenu)","DoctorApprovalModelDictList":doctorApprove] as [String : Any]
                let doctorApprovalData = DoctorApprovalModelArray(dict: dict as NSDictionary)
                doctorApprovalArray.append(doctorApprovalData)
                doctorApprove = []
                if(doctorApprovalArray.count>0)
                {
                    emptyStateView.isHidden = true
                    self.tableView.isHidden = false
                }
                else
                {
                    emptyStateView.isHidden = false
                    self.tableView.isHidden = true
                }
            }
        }
        else
        {
            setEmptyStateTitle(message:"No \(appDoctor) found")
            emptyStateView.isHidden = false
            self.tableView.isHidden = true
        }
}
    private func generateLockReleaseData(list: NSArray)
    {
        var lockReleaseData: [LockReleaseResponseModel] = []
        lockReleaseArray = []
        
        if (list.count > 0)
        {
            for obj in list
            {
                let dict = obj as! NSDictionary
                
                lockReleaseData.append(LockReleaseResponseModel.init(dict: dict))
            }
            
            var uniqueMonths: [Date] = []
            
            for objLockRelease in lockReleaseData
            {
                if (!uniqueMonths.contains(objLockRelease.Sort_Date))
                {
                    uniqueMonths.append(objLockRelease.Sort_Date)
                }
            }
            
            uniqueMonths.sort(by: { (date1, date2) -> Bool in
                date1 > date2
            })
            
            for date in uniqueMonths
            {
                let month = getMonthNumberFromDate(date: date)
                let year = getYearFromDate(date: date)
                let monthName = getMonthName(monthNumber: month) + " " + String(year)
                
                var dataArray = lockReleaseData.filter{
                    $0.Month_Number == month && $0.Year == year
                }
                
                dataArray = dataArray.sorted(by: { (obj1, obj2) -> Bool in
                    obj1.Server_Date < obj2.Server_Date
                })
                
                let dict: NSDictionary = ["Month_Name": monthName, "Data_Array": dataArray]
                
                lockReleaseArray.append(dict)
            }
        }
        
    }
    
    private func generateActivityLockReleaseData(list: NSArray)
    {
        var lockReleaseData: [ActivityLockReleaseResponseModel] = []
        activityLockArray = []
        
        if (list.count > 0)
        {
            for obj in list
            {
                let dict = obj as! NSDictionary
                
                lockReleaseData.append(ActivityLockReleaseResponseModel.init(dict: dict))
            }
            
            var uniqueMonths: [Date] = []
            
            for objLockRelease in lockReleaseData
            {
                if (!uniqueMonths.contains(objLockRelease.Sort_Date))
                {
                    uniqueMonths.append(objLockRelease.Sort_Date)
                }
            }
            
            uniqueMonths.sort(by: { (date1, date2) -> Bool in
                date1 > date2
            })
            
            for date in uniqueMonths
            {
                let month = getMonthNumberFromDate(date: date)
                let year = getYearFromDate(date: date)
                let monthName = getMonthName(monthNumber: month) + " " + String(year)
                
                var dataArray = lockReleaseData.filter{
                    $0.Month_Number == month && $0.Year == year
                }
                
                dataArray = dataArray.sorted(by: { (obj1, obj2) -> Bool in
                    obj1.Server_Date < obj2.Server_Date
                })
                
                let dict: NSDictionary = ["Month_Name": monthName, "Data_Array": dataArray]
                
                activityLockArray.append(dict)
            }
        }
        else
        {
           setEmptyStateTitle(message: "No Lock Data Found")
        }
        
    }
    
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    //MARK:-- Show Hide Functions
    private func showLoader()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading data. Please wait...")
    }
    
    private func hideLoader()
    {
        removeCustomActivityView()
    }
    
    private func showMainView()
    {
        emptyStateView.isHidden = true
        mainView.isHidden = false
    }
    
    private func showEmptyStateView()
    {
        setEmptyStateTitle(message: "Unable to connect internet")
        emptyStateView.isHidden = false
        mainView.isHidden = true
    }
    
    private func doInitialSetup()
    {
        addBackButtonView()
        setEmptyStateTitle(message: EMPTY)
        setUserName(name: EMPTY)
        hideButtonView()
    }
    
    private func showButtonView()
    {
        buttonViewHeightContstraint.constant = 45
        buttonView.isHidden = false
    }
    
    private func hideButtonView()
    {
        buttonViewHeightContstraint.constant = 0
        buttonView.isHidden = true
    }
    
    //MARK:-- Label Title Functions
    private func setEmptyStateTitle(message: String)
    {
        emptyStateTitleLabel.text = message
    }
    
    private func setUserName(name: String)
    {
        if(isFromDoctorApproval)
        {
            var customerstatusValue = String()
            if(customerStatus == 2)
            {
                customerstatusValue = "Applied \(appDoctor)"
            }
            else
            {
                customerstatusValue = "Approved \(appDoctor)"
            }
        userNameLabel.text = approvalUserObj.User_Name + "|" + approvalUserObj.Region_Name + "|" + customerstatusValue
            //approvalUserObj.Region_Name
            
        }
        else
        {
        userNameLabel.text = name
        }
    }
    
    //MARK:-- Nav Bar Button Functions
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//
//        self.navigationItem.leftBarButtonItem = backButtonItem
        
//        let imgBackArrow = UIImage(named: "navigation-arrow")
//        
//        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
    
    private func addMenuButton()
    {
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.menuButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-menubar"), for: .normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    private  func addSelectBut()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(selectButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Select", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    private func addSelectAllButton()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.selectAllButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Select All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func addDeselectAllButton()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.deSelectAllButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Deselect All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func backButtonAction()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    @objc func menuButtonAction()
    {
        let alert = UIAlertController(title: "Choose", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
//        alert.addAction(UIAlertAction(title: "Select", style: UIAlertActionStyle.default, handler: { alertAction in
//            self.selectButtonAction()
//        }))
        
        alert.addAction(UIAlertAction(title: "Refresh", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.refresh()
        }))
        if(!isFromTpFreezeLock)
        {
            alert.addAction(UIAlertAction(title: "View History", style: UIAlertActionStyle.default, handler:{  alertAction in
                self.viewHistoryAction()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{  alertAction in
            alert .dismiss(animated: true, completion: nil)
        }))
        
        if SwifterSwift().isPhone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func selectButtonAction()
    {
        setTableViewInEditMode()
    }
    
    @objc func selectAllButtonAction()
    {
        toggleSelection(select: true)
        setTableViewInEditMode()
        addDeselectAllButton()
    }
    
    @objc func deSelectAllButtonAction()
    {
        toggleSelection(select: false)
        setTableViewInEditMode()
        addSelectAllButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "segueLockHistory")
        {
            let viewController = segue.destination as! LockReleaseHistoryViewController
            
            viewController.approvalUserObj = self.approvalUserObj
        }
    }
    
    //MARK:-- Action Sheet Actions
    private func setTableViewInEditMode()
    {
        self.editMode = true
        addSelectAllButton()
        reloadTableView()
    }
    
    private func refresh()
    {
        getLockReleaseData(type:1)
    }
    
    private func viewHistoryAction()
    {
        //LockHistoryVC
        let sb = UIStoryboard(name: "LockRelease", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LockHistoryVC") as! LockReleaseHistoryViewController
        vc.approvalUserObj = self.approvalUserObj
        vc.isFromDCRActivityLock = isFromDCRActivityLock
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "segueLockHistory", sender: nil)
    }
    
    //MARK:-- Select Actions
    private func toggleSelection(select: Bool)
    {
        if(isFromDoctorApproval)
        {
            for dict in doctorApprovalArray
            {
                let dataArray = dict.List 
                for doctorData in dataArray
                {
                    doctorData.isSelected = select
                }
            }
        }
        else
        {
            for dict in lockReleaseArray
            {
                let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
                
                for objLockRelease in dataArray
                {
                    objLockRelease.isSelected = select
                }
            }
        }
        
        toggleButtonView()
    }
    
    private func toggleSelectAllButton()
    {
        var isAllSelected: Bool = true
        
        for dict in lockReleaseArray
        {
            let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
            
            for objLockRelease in dataArray
            {
                if (!objLockRelease.isSelected)
                {
                    isAllSelected = false
                    break
                }
            }
            
            if (!isAllSelected)
            {
                break
            }
        }
        
        if (isAllSelected)
        {
            addDeselectAllButton()
        }
        else
        {
            addSelectAllButton()
        }
        
        toggleButtonView()
    }
    
    private func toggleButtonView()
    {
         var selectedCount: Int = 0
        if(isFromDoctorApproval)
        {
            for doctorApproval in doctorApprovalArray
            {
                let dataArray = doctorApproval.List as! [DoctorApprovalModelDict]
                
                for doctorData in dataArray
                {
                    if(doctorData.isSelected)
                    {
                        selectedCount += 1
                        break
                    }
                }
                if (selectedCount > 0)
                {
                    break
                }
            }
        }
        else
        {
            
            for dict in lockReleaseArray
            {
                let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
                
                for objLockRelease in dataArray
                {
                    if (objLockRelease.isSelected)
                    {
                        selectedCount += 1
                        break
                    }
                }
                
                if (selectedCount > 0)
                {
                    break
                }
            }
        }
        if (selectedCount > 0)
        {
            showButtonView()
        }
        else
        {
            hideButtonView()
        }
    }
    
    //MARK:-- Unlock Functions
    
    @IBAction func cancelButtonAction()
    {
        
        if(isFromDoctorApproval)
        {
            var doctorApprovalList: [DoctorApprovalModelDict] = []
            
            for doctorApprovalData in doctorApprovalArray
            {
                for doctorData in doctorApprovalData.List
                {
                    if(doctorData.isSelected)
                    {
                        doctorApprovalList.append(doctorData)
                    }
                }
            }
            showApproveAlert(doctorApprovalData: doctorApprovalList,status:0)
        }
        else
        {
            toggleSelection(select: false)
            addMenuButton()
            self.editMode = false
            reloadTableView()
        }
    }
    
    @IBAction func unlockButtonAction()
    {
        if(isFromDoctorApproval)
        {
            var doctorApprovalList: [DoctorApprovalModelDict] = []
            
            for doctorApprovalData in doctorApprovalArray
            {
                for doctorData in doctorApprovalData.List
                {
                    if(doctorData.isSelected)
                    {
                       doctorApprovalList.append(doctorData)
                    }
                }
            }
            showApproveAlert(doctorApprovalData: doctorApprovalList,status:1)
        }
        else
        {
            var lockReleaseList: [LockReleaseResponseModel] = []
            
            for dict in lockReleaseArray
            {
                let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
                
                for objLockRelease in dataArray
                {
                    if (objLockRelease.isSelected)
                    {
                        lockReleaseList.append(objLockRelease)
                    }
                }
            }
            
            showUnlockConfirmationAlert(lockReleaseList: lockReleaseList)
        }
    }
    
    private func showApproveAlert(doctorApprovalData: [DoctorApprovalModelDict],status:Int)
    {
//        var alertString = String()
//        if(status == 0)
//        {
//            alertString = "REJECT   "
//        }
//        else
//        {
//            alertString = "APPROVE"
//        }
//        let alertViewController = UIAlertController (title: "Confirm", message: "Do you want to \(alertString)?", preferredStyle: .alert)
//
//        alertViewController.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: nil))
//
//        alertViewController.addAction(UIAlertAction(title: "\(alertString)", style: UIAlertActionStyle.default, handler: { alertAction in
            self.doctorApprove(doctorApprovalData: doctorApprovalData,status:status)
//        }))
//
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func doctorApprove(doctorApprovalData: [DoctorApprovalModelDict],status:Int)
    {
        customActivityIndicatory(self.view, startAnimate: true, viewController: self)
        let doctorData: NSMutableArray = []
        for doctorApproval in doctorApprovalData
        {
            let dict: NSDictionary = ["Customer_Code": doctorApproval.Customer_Code]
            doctorData.add(dict)
        }
        let postData : [String:Any] = ["lstCustomerCode":doctorData]
        
        WebServiceHelper.sharedInstance.doctorApproveReject(postData: postData, regionCode: approvalUserObj.Region_Code, customerStatus: status, userConformation: 0){
            (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: "", completion: { (status) in
                    if(status == SERVER_SUCCESS_CODE)
                    {
                        _ = customActivityIndicatory(self.view, startAnimate: false, viewController: self)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else
                    {
                        AlertView.showAlertView(title: "Error", message: "Error while Approve Please Try again")
                    }
                })
               
            }
            else
            {
                var mcError = NSArray()
                var spltyError = NSArray()
                var mdlError = NSArray()
                var categoryError = NSArray()
                let apiResponseList = apiResponseObj.list! as NSArray
                if(apiResponseList.count > 0)
                {
                   _ = customActivityIndicatory(self.view, startAnimate: false, viewController: self)
                    mdlError = (apiResponseList[0] as AnyObject).value(forKey:"lstMDLError") as! NSArray
                    spltyError = (apiResponseList[0] as AnyObject).value(forKey:"lstSpltyError") as! NSArray
                    categoryError = (apiResponseList[0] as AnyObject).value(forKey:"lstCategoryError") as! NSArray
                    mcError = (apiResponseList[0] as AnyObject).value(forKey:"lstMCError") as! NSArray
                    
                    if(mdlError.count > 0)
                    {
                        guard let data = try? JSONSerialization.data(withJSONObject: mdlError, options: []) else {
                            return
                        }
                        let doctorApprovalData = String(data: data, encoding: String.Encoding.utf8)
                        let errorList = try! JSONDecoder().decode([ApproveErrorTypeOne].self, from: (doctorApprovalData?.data(using: .utf8)!)!)
                        let sb = UIStoryboard(name: "LockRelease", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ApproveErrorone") as! ApproveErrorTypeOneController
                        vc.approvalUserObj = self.approvalUserObj
                        vc.approveErrorList = errorList
                        vc.errorMessage = apiResponseObj.Message
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    }
                    else if(spltyError.count > 0)
                    {
                        guard let data = try? JSONSerialization.data(withJSONObject: spltyError, options: []) else {
                            return
                        }
                        let doctorApprovalData = String(data: data, encoding: String.Encoding.utf8)
                        let errorList = try! JSONDecoder().decode([ApproveErrorTypeTwo].self, from: (doctorApprovalData?.data(using: .utf8)!)!)
                        let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: DoctorApproveErrorVcID) as! ApproveErrorTypeTwoController
                        vc.approveErrorList = errorList
                        vc.errorMessage = apiResponseObj.Message
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if(categoryError.count > 0)
                    {
                        guard let data = try? JSONSerialization.data(withJSONObject: categoryError, options: []) else {
                            return
                        }
                        let doctorApprovalData = String(data: data, encoding: String.Encoding.utf8)
                        let errorList = try! JSONDecoder().decode([ApproveErrorTypeTwo].self, from: (doctorApprovalData?.data(using: .utf8)!)!)
                        let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                         let vc = sb.instantiateViewController(withIdentifier: DoctorApproveErrorVcID) as! ApproveErrorTypeTwoController
                        vc.approveErrorList = errorList
                        vc.errorMessage = apiResponseObj.Message
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else if(mcError.count > 0)
                    {
                        guard let data = try? JSONSerialization.data(withJSONObject: mcError, options: []) else {
                            return
                        }
                        let doctorApprovalData1 = String(data: data, encoding: String.Encoding.utf8)
                        let errorList = try! JSONDecoder().decode([ApproveErrorTypeOne].self, from: (doctorApprovalData1?.data(using: .utf8)!)!)
                        let sb = UIStoryboard(name: "LockRelease", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ApproveErrorone") as! ApproveErrorTypeOneController
                        vc.approvalUserObj = self.approvalUserObj
                        
                        var filteredList: [ApproveErrorTypeOne] = []
                        
                        for obj in errorList
                        {
                            let duplicate = filteredList.filter{
                                $0.Customer_Code == obj.Customer_Code
                            }
                            
                            if (duplicate.count == 0)
                            {
                                var campaignName = EMPTY
                                
                                let filter = errorList.filter{
                                    $0.Customer_Code == obj.Customer_Code
                                }
                                
                                for filterObj in filter{
                                    campaignName += filterObj.Campaign_Name + ","
                                }
                                
                                if (campaignName != EMPTY)
                                {
                                    campaignName = String(campaignName.dropLast())
                                }
                                
                                obj.Campaign_Name = campaignName
                                
                                filteredList.append(obj)
                            }
                        }
                        
                        vc.approveErrorList = filteredList
                        
                        vc.errorMessage = apiResponseObj.Message
                        vc.doctorApprovalData = doctorApprovalData
                        vc.isFromMC = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
//                self.showErrorAlert(apiResponseObj: apiResponseObj)
            }
            
        }
        
    }
    private func showUnlockConfirmationAlert(lockReleaseList: [LockReleaseResponseModel])
    {
        let alertViewController = UIAlertController (title: "Confirm", message: "Do you want to unlock DVR lock?", preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: nil))
        
        alertViewController.addAction(UIAlertAction(title: "UNLOCK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.releaseLock(lockReleaseList: lockReleaseList)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func releaseLock(lockReleaseList: [LockReleaseResponseModel])
    {
        let postData: NSMutableArray = []
        
        for objLockRelease in lockReleaseList
        {
            let dict: NSDictionary = ["User_Code": objLockRelease.User_Code, "Locked_Date": objLockRelease.Locked_Date_Server, "DCR_Actual_Date": objLockRelease.DCR_Actual_Date_Server, "Lock_Type": objLockRelease.Lock_Type]
            
            postData.add(dict)
        }
        
        WebServiceHelper.sharedInstance.unlockDCR(dataArray: postData) { (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                self.showSuccessAlert()
            }
            else
            {
                AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
            }
        }
    }
    
    private func showSuccessAlert()
    {
        let alertViewController = UIAlertController (title: "Success", message: "\(PEV_DCR) unlocked successfully for the selected user(s)", preferredStyle: .alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            self.cancelButtonAction()
            self.getLockReleaseData(type:1)
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(apiResponseObj: ApiResponseModel)
    {
        AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
    }
    
    // MARK:- Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(isFromDoctorApproval)
        {
            return doctorApprovalArray.count
        }
        else if isFromDCRActivityLock
        {
            return activityLockArray.count
        }
        else if isFromTpFreezeLock
        {
           return 1
        }
        else
        {
            return lockReleaseArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 25
       
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockReleaseHeaderCell") as! LockReleaseTableViewCell
        cell.sectionWrapperView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        if(isFromDoctorApproval)
        {
            let doctorData: DoctorApprovalModelArray = doctorApprovalArray[section]
            cell.sectionTitleLabel.text = doctorData.CustomerFirstChar as String
            return cell
        }
        else if(isFromDCRActivityLock)
        {
            let dict: NSDictionary = activityLockArray[section]
            cell.sectionTitleLabel.text = (dict.value(forKey: "Month_Name") as! String)
            
            return cell
        }
        else if(isFromTpFreezeLock)
        {
            cell.sectionTitleLabel.text = EMPTY
            return cell
        }
        else
        {
            let dict: NSDictionary = lockReleaseArray[section]
            cell.sectionTitleLabel.text = (dict.value(forKey: "Month_Name") as! String)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isFromDoctorApproval)
        {
            let doctorData: DoctorApprovalModelArray = doctorApprovalArray[section]
            let dataArray = doctorData.List as [DoctorApprovalModelDict]
            return dataArray.count
        }
        else if isFromDCRActivityLock
        {
            let dict: NSDictionary = activityLockArray[section]
            let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
            return dataArray.count
        }
        else if isFromTpFreezeLock
        {
              return tpFreezeDataList.count
        }
        else
        {
            let dict: NSDictionary = lockReleaseArray[section]
            let dataArray = dict.value(forKey: "Data_Array") as! [ActivityLockReleaseResponseModel]
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(!isFromDCRActivityLock && !isFromTpFreezeLock)
        {
            return 50
        }
        else if isFromTpFreezeLock
        {
            let obj = self.tpFreezeDataList[indexPath.row]
            let str2 = "Category - " + obj.Category + "\n"
            let str1 = "Actual Date - " + obj.TP_Date + "\n"
            let str3 = "\(appCp) - " + obj.CP_name + "\n"
            let str4 = "Work Area - " + obj.Work_Area
            var str = String()
            str = str1 + str2 + str3 + str4
            return getTextSize(text: str, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 44).height + 10
        }
        else
        {
            let dict: NSDictionary = activityLockArray[indexPath.section]
            let dataArray = dict.value(forKey: "Data_Array") as! [ActivityLockReleaseResponseModel]
            let objLockRelease = dataArray[indexPath.row]
            let str1 = "Actual Date - " + objLockRelease.DCR_Actual_Date + "\n"
            let str2 = "Unapproved By - " + objLockRelease.unApproveBy + "\n"
            let str3 = "Unapproved Reason - " + objLockRelease.unApproveReason
            var str = String()
            str = str1 + str2 + str3
            return getTextSize(text: str, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 44).height + 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockReleaseCell") as! LockReleaseTableViewCell
        if(isFromDoctorApproval)
        {
            let doctorData: DoctorApprovalModelArray = doctorApprovalArray[indexPath.section]
            let dataArray = doctorData.List as [DoctorApprovalModelDict]
            let objdoctorData = dataArray[indexPath.row]
            cell.lockDateLabel.text = objdoctorData.Customer_Name
            var MDLNum = String()
            var specialityName = String()
            var categoryNamwe = String()
            if let mdlNum = objdoctorData.MDL_Number
            {
               // MDLNum = mdlNum
            }
            
            if let speciality = objdoctorData.Speciality_Name
            {
                if MDLNum != EMPTY
                {
                specialityName = " | \(speciality)"
                }
                else
                {
                   specialityName = "\(speciality)"
                }
            }
            
            if let category = objdoctorData.Category_Name
            {
                if specialityName != EMPTY
                {
                    categoryNamwe = " | \(category)"
                }
                else
                {
                    categoryNamwe = "\(category)"
                }
            }
           // cell.actualDateLabel.text = MDLNum + specialityName + categoryNamwe
            cell.actualDateLabel.text = specialityName + categoryNamwe
            
            if (!editMode)
            {
                cell.selectionViewWidthConstraint.constant = 0
                cell.selectionView.isHidden = true
            }
            else
            {
                cell.selectionViewWidthConstraint.constant = 40
                cell.selectionView.isHidden = false
            }
            
            if (objdoctorData.isSelected)
            {
                cell.selectionImageView.image = UIImage(named: "icon-check")
            }
            else
            {
                cell.selectionImageView.image = UIImage(named: "icon-uncheck")
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        }
        else
        {
            if !isFromDCRActivityLock && !isFromTpFreezeLock
            {
                let dict: NSDictionary = lockReleaseArray[indexPath.section]
                let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
                let objLockRelease = dataArray[indexPath.row]
                
                var lockType = objLockRelease.Lock_Type
                lockType = lockType?.replacingOccurrences(of: "_", with: " ")
                
                cell.lockDateLabel.text = lockType! + " - " + objLockRelease.Locked_Date
                cell.actualDateLabel.text = "Actual Date - " + objLockRelease.DCR_Actual_Date
                
                if (objLockRelease.isSelected)
                {
                    cell.selectionImageView.image = UIImage(named: "icon-check")
                }
                else
                {
                    cell.selectionImageView.image = UIImage(named: "icon-uncheck")
                }
            }
            else if isFromTpFreezeLock
            {
                let obj = self.tpFreezeDataList[indexPath.row]
                let tpDate = convertDateIntoString(date: convertDateIntoString(dateString: obj.TP_Date))
                var cpValue = String()
                if(obj.CP_name == EMPTY)
                {
                    cpValue = NOT_APPLICABLE
                }
                else
                {
                    cpValue = obj.CP_name
                }
                let category = "Category - " + obj.Category + "\n"
                let str1 = "Actual Date - " + tpDate + "\n"
                let str2 = "\(appCp) - " + cpValue + "\n"
                let str3 = "Work Area - " + obj.Work_Area
                var str = String()
                str = str1 + str2 + str3
                cell.lockDateLabel.text = obj.Activity_Code + " - " + category
                cell.actualDateLabel.text = str
                
                if (!editMode)
                {
                    cell.selectionViewWidthConstraint.constant = 0
                    cell.selectionView.isHidden = true
                }
                else
                {
                    cell.selectionViewWidthConstraint.constant = 40
                    cell.selectionView.isHidden = false
                }
                
                
                cell.selectionStyle = .none
                
                return cell
            }
            else
            {
               // ActivityLockReleaseResponseModel
                
                let dict: NSDictionary = activityLockArray[indexPath.section]
                let dataArray = dict.value(forKey: "Data_Array") as! [ActivityLockReleaseResponseModel]
                let objLockRelease = dataArray[indexPath.row]
                
                var lockType = objLockRelease.Lock_Type
                lockType = lockType?.replacingOccurrences(of: "_", with: " ")
                
                cell.lockDateLabel.text = lockType! + " - " + objLockRelease.Locked_Date
                let str1 = "Actual Date - " + objLockRelease.DCR_Actual_Date + "\n"
                let str2 = "Unapproved By - " + objLockRelease.unApproveBy + "\n"
                let str3 = "Unapproved Reason - " + objLockRelease.unApproveReason
                var str = String()
                str = str1 + str2 + str3
                cell.actualDateLabel.text = str
                
            }
            
            if (!editMode)
            {
                cell.selectionViewWidthConstraint.constant = 0
                cell.selectionView.isHidden = true
            }
            else
            {
                cell.selectionViewWidthConstraint.constant = 40
                cell.selectionView.isHidden = false
            }
            
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(isFromDoctorApproval)
        {
            let doctorData: DoctorApprovalModelArray = doctorApprovalArray[indexPath.section]
            let dataArray = doctorData.List as [DoctorApprovalModelDict]
            let doctorSelectData = dataArray[indexPath.row]
            if (editMode)
            {
                doctorSelectData.isSelected = !doctorSelectData.isSelected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                
                toggleSelectAllButton()
            }
        }
        else
        {
            if(isFromDCRActivityLock)
            {
                let dict: NSDictionary = activityLockArray[indexPath.section]
                let dataArray = dict.value(forKey: "Data_Array") as! [ActivityLockReleaseResponseModel]
                let objLockRelease = dataArray[indexPath.row]
                
                //showUnlockConfirmationAlert(lockReleaseList: [objLockRelease])
                self.title = EMPTY
                let sb = UIStoryboard(name:"LockRelease", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: LockReleaseFormControllerID) as! LockReleaseFormController
                vc.lockReleaseList = []
                vc.activityLockReleaseList = [objLockRelease]
                vc.isFromDCRActivityLock = isFromDCRActivityLock
                vc.selectedUserCode = approvalUserObj.User_Code
                self.navigationController?.pushViewController(vc, animated: true)
                // self.present(onboard_vc, animated: false, completion: nil)
            }
            else if(isFromTpFreezeLock)
            {
                let objRelease = tpFreezeDataList[indexPath.row]
                self.title = EMPTY
                let sb = UIStoryboard(name:"LockRelease", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: LockReleaseFormControllerID) as! LockReleaseFormController
                vc.lockReleaseList = []
                vc.activityLockReleaseList = []
                vc.tpFreezeDataList = [objRelease]
                vc.isFromTPFreeze = true
                vc.selectedUserCode = approvalUserObj.User_Code
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let dict: NSDictionary = lockReleaseArray[indexPath.section]
                let dataArray = dict.value(forKey: "Data_Array") as! [LockReleaseResponseModel]
                let objLockRelease = dataArray[indexPath.row]
                
                //showUnlockConfirmationAlert(lockReleaseList: [objLockRelease])
                self.title = EMPTY
                let sb = UIStoryboard(name:"LockRelease", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: LockReleaseFormControllerID) as! LockReleaseFormController
                vc.lockReleaseList = [objLockRelease]
                vc.isFromDCRActivityLock = isFromDCRActivityLock
                vc.selectedUserCode = approvalUserObj.User_Code
                self.navigationController?.pushViewController(vc, animated: true)
                // self.present(onboard_vc, animated: false, completion: nil)
            }
        }
    }
    func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(LockReleaseViewController.pullRefresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func pullRefresh()
    {
        getLockReleaseData(type: 2)
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    func showSuccessToast()
    {
        showToastView(toastText: "Refreshed Successfully")
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
        self.generateDoctorApprovalData(doctorApprovalList: doctorApprovalList)
        reloadTableView()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if (searchBar.text?.count == 0 || searchText == EMPTY)
        {
            self.generateDoctorApprovalData(doctorApprovalList: doctorApprovalList)
            reloadTableView()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        
        doctorApprovalSearchList = doctorApprovalList.filter {
            (obj) -> Bool in
            var lowerCaseText = searchText.lowercased()
            var empName = String()
            var empCode = String()
            var speciality = String()
            var category = String()
            var mdlNum = String()
            if(obj.Customer_Name != nil || obj.Customer_Name != EMPTY)
            {
                empName  = (obj.Customer_Name).lowercased()
            }
            if(obj.Customer_Code != nil || obj.Customer_Code != EMPTY)
            {
                empCode = (obj.Customer_Code).lowercased()
            }
            if(obj.Speciality_Name != nil || obj.Speciality_Name != EMPTY)
            {
                speciality = (obj.Speciality_Name).lowercased()
            }
            if(obj.Category_Name != nil || obj.Category_Name != EMPTY)
            {
                category = (obj.Category_Name).lowercased()
            }
            if(obj.MDL_Number != nil || obj.MDL_Number != EMPTY)
            {
                mdlNum = (obj.MDL_Number).lowercased()
            }
            if (empName.contains(lowerCaseText)) || (empCode.contains(lowerCaseText)) || (speciality.contains(lowerCaseText)) || (category.contains(lowerCaseText)) {
                return true
            }
            self.searchView.isHidden = false
            return false
        }
        
        self.generateDoctorApprovalData(doctorApprovalList: doctorApprovalSearchList)
        reloadTableView()
        setEmptyStateTitle(message: "No \(appDoctor) found. Clear your search and try again.")
        
    }
}
