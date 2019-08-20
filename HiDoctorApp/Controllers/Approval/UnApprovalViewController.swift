//
//  UnApprovalViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/3/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit



class UnApprovalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApprovalPopUpDelegate{
    
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var bottomView: UIView!
    var delegate : SaveActionToastDelegate?
    
    @IBOutlet weak var bottomBoxHeight: NSLayoutConstraint!
    var refreshControl: UIRefreshControl!
    var contentList: [ApprovalUserMasterModel] = []
    var currentList : [ApprovalUserMasterModel] = []
    var selectedList : NSMutableArray = []
    var userList : ApprovalUserMasterModel!
    var menuId : Int!
    var userSelectedList : [ApprovalUserMasterModel] = []
    var isSelectAll : Bool = false
    var isSelect : Bool = false
    var isCmngFromTpPage : Bool = false
    var isCmngFromApprovalPage : Bool = false
    var popUpView : ApprovalPoPUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.employeeName.text = userList.Employee_Name + "(" + userList.User_Type_Name + ")"
        self.emptyStateLbl.text = ""
        navigationTitle()
        self.pullDownRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toggleBottomAlert()
        addBackButtonView()
        self.listApiCall(type: 1)
        navigationTitle()
        self.menuBarItem()
    }
    
    func listApiCall(type : Int)
    {
        if checkInternetConnectivity()
        {
            if menuId == MenuIDs.TP_Approval.rawValue
            {
                if type != 2
                {
                    showCustomActivityIndicatorView(loadingText: "Loading")
                }
                BL_Approval.sharedInstance.getTpWorkPlaceDetailsData(userObj: userList)
                {
                    (apiResponseObj) in
                    removeCustomActivityView()

                    
                    self.emptyStateLbl.text = "No \(PEV_TOUR_PLAN) data available for approval."
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        self.contentList = self.convertUserAppliedList(list: apiResponseObj.list)
                        self.endRefresh()
                        self.changeCurrentList(list: self.contentList)
                        self.isCmngFromTpPage = true
                        if type == 2
                        {
                            showToastView(toastText: "\(PEV_TP) data refreshed successfully")
                        }
                    }
                    else
                    {
                        if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
                        {
                            if type != 2
                            {
                                self.showEmptyStateView(show: true)
                                self.emptyStateLbl.text = "No Internet Connection"
                            }
                            else
                            {
                                showToastView(toastText: "No Internet Connection")
                            }
                        }
                        else
                        {
                            var emptyStateText : String = apiResponseObj.Message
                            self.showEmptyStateView(show: true)
                            
                            if emptyStateText == ""
                            {
                                emptyStateText = "Unable to fetch \(PEV_TP) approval data."
                            }
                            if type == 2
                            {
                                showToastView(toastText: emptyStateText)
                            }
                            else
                            {
                                self.emptyStateLbl.text = emptyStateText
                            }
                        }
                        
                    }
                }
            }
            else if menuId == MenuIDs.DCR_Approval.rawValue
            {
                if type != 2
                {
                    showCustomActivityIndicatorView(loadingText: "Loading")
                }
                userList.Activity_Id = 1
                BL_Approval.sharedInstance.getDCRHeaderDetailsV59Report(userObj: userList)
                {
                    (apiResponseObj) in
                     self.emptyStateLbl.text = "No \(PEV_DCR) data available for approval."
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        self.contentList = self.convertUserAppliedList(list: apiResponseObj.list)
                        removeCustomActivityView()
                        self.endRefresh()
                        if type == 2
                        {
                            showToastView(toastText: "\(PEV_DCR) data refreshed successfully")
                        }
                        self.changeCurrentList(list: self.contentList)
                    }
                    else
                    {
                        if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
                        {
                            if type != 2
                            {
                                self.showEmptyStateView(show: true)
                                self.emptyStateLbl.text = "No Internet Connection"
                            }
                            else
                            {
                                showToastView(toastText: "No Internet Connection")
                            }
                        }
                        else
                        {
                            var emptyStateText : String = apiResponseObj.Message
                            self.showEmptyStateView(show: true)
                            
                            if emptyStateText == ""
                            {
                                emptyStateText = "Unable to fetch \(PEV_DCR) approval data."
                            }
                            if type == 2
                            {
                                showToastView(toastText: emptyStateText)
                            }
                            else
                            {
                                self.emptyStateLbl.text = emptyStateText
                            }
                        }
                        
                    }
                }
            }
        }
        else
        {
            if type == 2
            {
            endRefresh()
            showToastView(toastText: "No Internet Connection. Please try again.")
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var activityName : String = ""
        let Cell = tableView.dequeueReusableCell(withIdentifier: UnApprovalListCell, for: indexPath) as! UnApprovalListTableViewCell
        let dict = currentList[indexPath.row]
        if (isSelectAll) || (isSelect)
        {
            if isSelect
            {
                if userSelectedList.contains(dict)
                {
                    Cell.imageCheckBox.image = UIImage(named: "icon-check")
                }
                else
                {
                    Cell.imageCheckBox.image = UIImage(named: "icon-uncheck")
                }
            }
            else
            {
                Cell.imageCheckBox.image = UIImage(named: "icon-check")
            }
        }
        else
        {
            Cell.imageCheckBox.image = UIImage(named: "icon-uncheck")
        }
        
        if dict.Activity == 1
        {
            Cell.listIconImg.image = UIImage(named: "icon-stepper-work-area")
            activityName = "Field"
        }
        else if dict.Activity == 3
        {
            Cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Leave"
        }
        else if dict.Activity == 2
        {
            Cell.listIconImg.image = UIImage(named: "icon-calendar")
            activityName = "Attendance"
        }
        
        let tpDate = getStringInFormatDate(dateString: dict.Actual_Date)
        let dateStr = convertDateIntoString(date: tpDate)
        
        Cell.listContentLbl.text = dateStr + " - " + activityName
        
        Cell.selectList.image = UIImage(named: "icon-right-arrow")
        
        if (isSelectAll) || (isSelect)
        {
            Cell.selectionViewWidth.constant = 40
            Cell.checkboxView.isHidden = false
        }
        else
        {
            Cell.selectionViewWidth.constant = 0
            Cell.checkboxView.isHidden = true
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkInternetConnectivity()
        {
            let detailObj = currentList[indexPath.row]
            
            detailObj.User_Name = userList.User_Name
            detailObj.User_Code = userList.User_Code
            detailObj.Employee_Name = userList.Employee_Name
            detailObj.activityYear = userList.activityYear
            detailObj.activityMonth = userList.activityMonth

            DCRModel.sharedInstance.dcrDateString = detailObj.Actual_Date
            if (isSelectAll) || (isSelect)
            {
                if selectedList.contains(detailObj)
                {
                    selectedList.remove(detailObj)
                }
                else
                {
                    selectedList.add(detailObj)
                }
                userSelectedList = convertSelectList(selectList: selectedList)
                changeCurrentList(list: contentList)
                toggleBottomAlert()
                navigationTitle()
            }
            else
            {
                
                if detailObj.Activity == DCRFlag.attendance.rawValue
                {
                    let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonAttendanceDetailsVcID) as! CommonApprovalAttendanceControllerViewController
                    detailObj.Entered_Date = detailObj.Actual_Date
                    detailObj.Region_Code = userList.Region_Code
                    vc.ifIsComingFromTpPage = isCmngFromTpPage
                    vc.userObj = detailObj
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if detailObj.Activity == DCRFlag.leave.rawValue
                {
                    let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonLeaveApprovalVcID) as! CommonLeaveApprovalViewController
                    detailObj.Entered_Date = detailObj.Actual_Date
                    detailObj.Region_Code = userList.Region_Code
                    vc.userObj = detailObj
                    vc.isComingFromTpPage = isCmngFromTpPage
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    if !isCmngFromTpPage
                    {
                        detailObj.Actual_Date = convertDateIntoDisplayFormat(date: getStringInFormatDate(dateString: detailObj.Actual_Date))
                    }
                    let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonApprovalDetailsVcID) as! ApprovalDetailsViewController
                    detailObj.Region_Code = userList.Region_Code
                    detailObj.Entered_Date = detailObj.Actual_Date
                    vc.userObj = detailObj
                    vc.ifIsComingFromTpPage = isCmngFromTpPage
                    vc.isCmngFromApprovalPage = isCmngFromApprovalPage
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func convertUserAppliedList(list: NSArray) -> [ApprovalUserMasterModel]
    {
        var appliedList : [ApprovalUserMasterModel] = []
        if list.count > 0
        {
            for userObjList in list
            {
                let dict = userObjList as! NSDictionary
                
                let appliedListObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
                let nullCheck = dict.object(forKey: "Region_Code") as? String
                appliedListObj.User_Name = self.userList.User_Name
                if checkNullAndNilValueForString(stringData: nullCheck) == ""
                {
                    appliedListObj.Region_Code = self.userList.Region_Code
                }
                else
                {
                    appliedListObj.Region_Code = dict.object(forKey: "Region_Code") as! String!
                }
                
                appliedListObj.User_Code = dict.object(forKey: "User_Code") as! String!
                appliedListObj.UnapprovalActivity = dict.object(forKey: "DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK") as! String!
                if menuId == MenuIDs.DCR_Approval.rawValue
                {
                    appliedListObj.Activity = dict.object(forKey: "Flag") as! Int!
                    appliedListObj.DCR_Code = dict.object(forKey: "DCR_Code") as! String!
                    appliedListObj.Activity_Id = dict.object(forKey: "Flag") as! Int
                    appliedListObj.Actual_Date = dict.object(forKey: "DCR_Actual_Date") as! String!
                    appliedListObj.actualDate =  convertDateIntoString(dateString:  dict.object(forKey: "DCR_Actual_Date") as! String!)
                    appliedListObj.Entered_Date = dict.object(forKey: "DCR_Entered_Date") as! String!
                    appliedList.append(appliedListObj)
                }
                else if menuId == MenuIDs.TP_Approval.rawValue
                {
                    if let tpId = dict.object(forKey: "TP_Id") as? Int
                    {
                        if tpId > 0
                        {
                            appliedListObj.Activity = Int(checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity") as? String))
                            appliedListObj.Activity_Id = dict.object(forKey: "TP_Id") as! Int!
                            appliedListObj.Actual_Date = dict.object(forKey: "TP_Date") as! String!
                            appliedListObj.actualDate = convertDateIntoString(dateString: dict.object(forKey: "TP_Date") as! String!)
                            appliedListObj.TP_Day = dict.object(forKey: "TP_Day") as! String!
                            appliedListObj.Entered_Date = dict.object(forKey: "Entered_Date") as! String!
                            appliedList.append(appliedListObj)
                        }
                    }
                }
            }
        }
        return appliedList
    }
    
    @objc func showActionSheet()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        if currentList.count > 0
        {
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.BULK_DCR_APPROVAL) == PrivilegeValues.YES.rawValue)
            {
                let selectAllAction = UIAlertAction(title: "Select", style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.selectAction()
                })
                
                optionMenu.addAction(selectAllAction)
            }
        }
        
        let refreshAction = UIAlertAction(title: "Refresh", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.changeCurrentList(list: self.contentList)
            self.listApiCall(type: 1)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.isSelect = false
            self.isSelectAll = false
            self.tableView.reloadData()
        })
        
        optionMenu.addAction(refreshAction)
        optionMenu.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            self.present(optionMenu, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = optionMenu.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
    }
    
    func changeCurrentList(list: [ApprovalUserMasterModel])
    {
        if list.count > 0
        {
            self.currentList = list.sorted(by: { (obj1, obj2) -> Bool in
                obj1.actualDate < obj2.actualDate
            })
            
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
        }
        
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func convertSelectList(selectList: NSMutableArray) -> [ApprovalUserMasterModel]
    {
        var selectedProductList : [ApprovalUserMasterModel] = []
        if selectList.count > 0
        {
            for obj in selectList
            {
                selectedProductList.append(obj as! ApprovalUserMasterModel)
            }
        }
        return selectedProductList
    }
    
    func navigationTitle()
    {
        if userSelectedList.count > 0
        {
            navigationItem.title = String(userSelectedList.count) + " Selected"
        }
        else if userSelectedList.count == 0
        {
            navigationItem.title = "Pending Approvals"
        }
    }
    
    @objc func selectAllAction()
    {
        isSelectAll = true
        selectedList = NSMutableArray()
        self.navigationItem.title = ""
        
        for contentObj in contentList
        {
            self.selectedList.add(contentObj)
        }
        
        userSelectedList = convertSelectList(selectList: selectedList)
        self.toggleBottomAlert()
        changeCurrentList(list: contentList)
        self.addDeselectAllButton()
        self.navigationTitle()
    }
    
    @objc func cancelAction()
    {
        isSelectAll = false
        isSelect = false
        addBackButtonView()
        self.menuBarItem()
        selectedList = NSMutableArray()
        userSelectedList = []
        self.toggleBottomAlert()
        self.tableView.reloadData()
        self.navigationTitle()
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
    private func addDeselectAllButton()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.deSelectAllAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Deselect All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func deSelectAllAction()
    {
        isSelectAll = false
        isSelect = true
        self.selectAction()
        selectedList = NSMutableArray()
        userSelectedList = []
        self.toggleBottomAlert()
        self.changeCurrentList(list: self.contentList)
        self.navigationItem.title = ""
    }
    
    func selectAction()
    {
        self.navigationItem.title = ""
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.selectAllAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Select All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(UnApprovalViewController.cancelAction))
        self.isSelect = true
        self.tableView.reloadData()
    }
    func menuBarItem()
    {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "icon-menubar"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.showActionSheet), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func toggleBottomAlert()
    {
        if userSelectedList.count > 0
        {
            self.bottomView.isHidden = false
            self.bottomBoxHeight.constant = 45
        }
        else
        {
            self.bottomView.isHidden = true
            self.bottomBoxHeight.constant = 0
        }
    }
    // PullDown Refresh
    func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(UnApprovalViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh()
    {
        self.listApiCall(type: 2)
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    
    //MARK:- Pop Up View
    
    private func showPopUpView(type : ApprovalButtonType)
    {
        popUpView = ApprovalPoPUp.loadNib()
        
        popUpView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2 ,  y:  SCREEN_HEIGHT, width: 250, height: popUpView.approvalPopUpHeight)
        popUpView.delegate = self
        
        popUpView.statusButtonType = type
        popUpView.setDefaultDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let blackScreen : UIView = UIView(frame: appDelegate.window!.bounds)
        blackScreen.backgroundColor = UIColor.black
        blackScreen.alpha = 0.6
        blackScreen.tag = 3000
        appDelegate.window!.addSubview(blackScreen)
        appDelegate.window!.addSubview(popUpView)
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
        }
    }
    
    func hidePopUpView()
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.popUpView.frame.origin.y = SCREEN_HEIGHT
        }) { (value) -> Void in
            self.popUpView.removeFromSuperview()
            let appDelegate = getAppDelegate()
            let blackScreen = appDelegate.window?.viewWithTag(3000)
            blackScreen?.removeFromSuperview()
        }
    }
    
    //MARK:- KeyBoard function
    
    func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                let remainingHeight = SCREEN_HEIGHT - keyboardSize.height
                self.popUpView.frame.origin.y = (remainingHeight - self.popUpView.approvalPopUpHeight)/2
            }
        }
    }
    
    private func removeKeyBoardObserver()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
    }
    
    func setPopUpBtnAction(type : ApprovalButtonType)
    {
        removeKeyBoardObserver()
        if type == ApprovalButtonType.approval
        {
            if isCmngFromTpPage
            {
                updateTPStatus(approvalStatus : 1)
            }
            else
            {
                updateDCRStatus(approvalStatus : 2)
            }
        }
        else if type == ApprovalButtonType.reject
        {
            if isCmngFromTpPage
            {
                updateTPStatus(approvalStatus : 0)
            }
            else
            {
                updateDCRStatus(approvalStatus : 0)
            }
        }
        hidePopUpView()
    }
    
    private func updateDCRStatus(approvalStatus : Int)
    {
        for userList in userSelectedList
        {
            userList.approvalStatus = approvalStatus
        }
        showCustomActivityIndicatorView(loadingText: "Updating..")
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.updateDCRStatus(userList : userSelectedList ,userObj: userList, reason: popUpView.reasonTxtView.text) { (apiResponseObject) in
                removeCustomActivityView()
                self.cancelAction()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    if approvalStatus == 0
                    {
                        AlertView.showAlertView(title: "Success", message: "\(PEV_DCR) rejected successfully for the selected date(s)", viewController: self)
                    }
                    else
                    {
                        AlertView.showAlertView(title: "Success", message: "\(PEV_DCR) approved successfully for the selected date(s)", viewController: self)
                    }
                    self.listApiCall(type: 1)
                }
                else
                {
                    showToastView(toastText: "Updated Failed.Please try again")
                }
            }
        }
        else
        {
            showToastView(toastText: "No Internet Connection")
        }
    }
    
@IBAction func approvalButtonAction(_ sender: AnyObject)
    {
        if ((PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.YES.rawValue))
        {
            
            if (isLeaveChecked())
            {
                
                AlertView.showAlertView(title: "Alert", message: "Leave Policy is enabled. You are not allowed to Approve/Reject leave from this page. Please go to Leave Approval Screen to Approve/Reject Leave.")
            }
            else
            {
                addKeyBoardObserver()
                self.showPopUpView(type: ApprovalButtonType.approval)
            }
        }
        else
        {
            
            addKeyBoardObserver()
            self.showPopUpView(type: ApprovalButtonType.approval)
        }
    }
    @IBAction func rejectButtonAction(_ sender: AnyObject)
    {
        if ((PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.YES.rawValue))
        {
            
            if (isLeaveChecked())
            {
                
                AlertView.showAlertView(title: "Alert", message: "Leave Policy is enabled. You are not allowed to Approve/Reject leave from this page. Please go to Leave Approval Screen to Approve/Reject Leave.")
            }
            else
            {
                addKeyBoardObserver()
                self.showPopUpView(type: ApprovalButtonType.reject)
            }
        }
        else
        {
            
            addKeyBoardObserver()
            self.showPopUpView(type: ApprovalButtonType.reject)
        }
    }
    private func updateTPStatus(approvalStatus : Int)
    {
        for userList in userSelectedList
        {
            userList.approvalStatus = approvalStatus
        }
        showCustomActivityIndicatorView(loadingText: "Updating..")
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.updateTpStatus(userList : userSelectedList ,userObj: userList, reason: popUpView.reasonTxtView.text) { (apiResponseObject) in
                removeCustomActivityView()
                self.cancelAction()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    if approvalStatus == 0
                    {
                        AlertView.showAlertView(title: "Success", message: "\(PEV_TP) rejected successfully for the selected date(s)", viewController: self)
                    }
                    else
                    {
                        AlertView.showAlertView(title: "Success", message: "\(PEV_TP) approved successfully for the selected date(s)", viewController: self)
                    }
                    self.listApiCall(type: 1)
                }
                else
                {
                    showToastView(toastText: "Updated Failed.Please try again")
                }
            }
        }
        else
        {
            showToastView(toastText: "No Internet Connection")
        }
    }
    
    
    func isLeaveChecked() -> Bool
    {
        
        if (userSelectedList != nil)
        {
            for obj in userSelectedList
            {
                if (obj.Activity == 3)
                {
                    return true
                }
            }
        }

        return false
    }
    
    
}
