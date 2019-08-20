//
//  CommonLeaveApprovalViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class CommonLeaveApprovalViewController: UIViewController,ApprovalPopUpDelegate
{
    //MARK:- @IBOutlet
    @IBOutlet weak var leaveEntryLbl: UILabel!
    @IBOutlet weak var leaveTypeLbl: UILabel!
    @IBOutlet weak var leavereasontopConst: NSLayoutConstraint!
    @IBOutlet weak var leaveReasonLbl: UILabel!
    @IBOutlet weak var leaveReasonHgtConst: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var lowerheaderLbl: UILabel!
    @IBOutlet weak var lowerheaderLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var approveBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var unapproveReasonLbl: UILabel!
    @IBOutlet weak var unapproveReasonHgtConst: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var isComingFromTpPage : Bool =  false
    var isCmngFromReportPage : Bool = false
    var isMine : Bool = false
    var isCmngFromRejectPage : Bool = false
    var popUpView : ApprovalPoPUp!
    var delegate : SaveActionToastDelegate?
    var userObj : ApprovalUserMasterModel!
    var tpUserObj : ApprovalUserMasterModel!
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setDefaultDetails()
        setHeaderDetails()
        addCustomBackButtonToNavigationBar()
        startApiCall()
        if isComingFromTpPage == false && isCmngFromRejectPage == false && isCmngFromReportPage == false
        {
            self.addCustomViewTPButtonToNavigationBar()
        }
        let strCheckForLeave = UserDefaults.standard.string(forKey: "IsFromLeaveApprovalCheckBox")
        
        if (strCheckForLeave == "0")
        {
            UserDefaults.standard.set("", forKey: "IsFromLeaveApprovalCheckBox")
            UserDefaults.standard.synchronize()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Setting Defaults
    func setDefaultDetails()
    {
        var leaveEntry : String = userObj.Actual_Date
        var entryDate : Date!
        
        if leaveEntry == ""
        {
            leaveEntry = NOT_APPLICABLE
        }
        else
        {
            entryDate = getStringInFormatDate(dateString: leaveEntry)
            leaveEntry = convertDateIntoString(date: entryDate)
        }
        
        
        if isComingFromTpPage
        {
            self.leaveReasonHgtConst.constant = 0
            self.leavereasontopConst.constant = 0
            self.reasonView.isHidden = true
            self.unapproveReasonHgtConst.constant = 0
        }
        self.leaveEntryLbl.text = leaveEntry
        self.leaveTypeLbl.text = ""
        self.leaveReasonLbl.text = ""
        
        
        if isCmngFromReportPage
        {
            self.bottomViewHgtConst.constant = 0
            self.bottomView.isHidden = true
        }
        else
        {
            self.bottomViewHgtConst.constant = 45
            self.bottomView.isHidden = false
        }
    }
    
    func setHeaderDetails()
    {
        var activityType = "Applied"
        var actualDate : String = userObj.Actual_Date
        var headerText : String = ""
        
        
        if actualDate == ""
        {
            actualDate = NOT_APPLICABLE
        }
        else
        {
            
            let  entryDate = getStringInFormatDate(dateString: actualDate)
            
            actualDate = convertDateIntoString(date: entryDate)
        }
        
        if isCmngFromReportPage && isMine
        {
            activityType = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: userObj.DCR_Status)
            headerText = "Leave - \(actualDate) | \(activityType)"
        }
        else if isCmngFromReportPage || isCmngFromRejectPage
        {
           headerText = "Leave - \(actualDate)"
        }
        else
        {
            headerText = "Leave - \(actualDate) | \(activityType)"
        }
        
        if isCmngFromRejectPage
        {
            self.approveBtnWidth.constant = 0
        }
        let employeeName = userObj.Employee_Name as String
        if isComingFromTpPage == false && isCmngFromRejectPage == false && isCmngFromReportPage == false
        {
            self.lowerheaderLblHeightConstant.constant = 18
            self.headerViewHeightConstant.constant = 60
            self.headerLbl.text = "\(employeeName)"
            self.lowerheaderLbl.text = headerText
            self.title = "\(PEV_DCR) Approval"
        }
        else
        {
        self.lowerheaderLblHeightConstant.constant = 0
        self.headerViewHeightConstant.constant = 30
        self.headerLbl.text = headerText
        self.title = "\(employeeName)"
        }
    }
    
    //MARK:- API Call
    func startApiCall()
    {
        if isComingFromTpPage
        {
            tpLeaveApiCall()
        }
        else
        {
            if isMine
            {
                setDcrOfflineDetails()
            }
            else
            {
                dcrLeaveApiCall()
                if isComingFromTpPage == false && isCmngFromRejectPage == false && isCmngFromReportPage == false
                {
                getUserTpList()
                }
            }
        }
    }
    
    //MARK:- Setting Online and offline data
    func setDcrOfflineDetails()
    {
        self.setLeaveDetails(dict: BL_Reports.sharedInstance.getDCRLeaveDetails())
        
    }
    
    func dcrLeaveApiCall()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRWorkPlaceDetails(userObj: userObj) {
                (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    if apiResponseObj.list.count > 0
                    {
                        let dict = apiResponseObj.list.firstObject as! NSDictionary
                        self.setLeaveDetails(dict: dict)
                        if self.isCmngFromReportPage || self.isCmngFromRejectPage
                        {
                            let dcrStatus = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Status") as! String?))
                            var headerText = self.headerLbl.text! as String
                            headerText = "\(headerText)" + " | \(dcrStatus)"
                            self.headerLbl.text = headerText
                        }
                    }
                }
                else
                {
                    self.showErrorToastView()
                }
            }
        }
        else
        {
            showErrorToastView()
        }
    }
    
    func tpLeaveApiCall()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpWorkPlaceDetailsData(userObj: userObj) {
                (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    if apiResponseObj.list.count > 0
                    {
                        let dict = apiResponseObj.list.firstObject
                        self.setLeaveDetails(dict: dict as! NSDictionary)
                    }
                }
                else
                {
                    self.showErrorToastView()
                }
            }
        }
        else
        {
            self.showErrorToastView()
        }
    }
    
    func setLeaveDetails(dict : NSDictionary)
    {
        
        var leaveType : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "leaveTypeName") as? String)
        if isComingFromTpPage
        {
            leaveType = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
        }
        
        if leaveType == ""
        {
            leaveType = NOT_APPLICABLE
        }
        
        self.leaveTypeLbl.text = leaveType
        
        
        if !isComingFromTpPage
        {
            var leaveReason : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Reason") as? String)
            
            if leaveReason == EMPTY
            {
               leaveReason = NOT_APPLICABLE
            }
            
            self.leaveReasonLbl.text = leaveReason
            self.leaveReasonHgtConst.constant = getTextSizeForLeaveReason(leaveReason: leaveReason)
            
            var unapproveReason = checkNullAndNilValueForString(stringData : dict.object(forKey : "Unapprove_Reason") as? String)
            
            if unapproveReason == EMPTY
            {
                unapproveReason = NOT_APPLICABLE
            }
            else
            {
                unapproveReason = BL_Approval.sharedInstance.getTrimmedTextForUnapproveReason(reason: unapproveReason)
            }
            
            self.unapproveReasonLbl.text = unapproveReason
            self.unapproveReasonHgtConst.constant = getTextSizeForLeaveReason(leaveReason : unapproveReason)
        }
    }
    
    func getTextSizeForLeaveReason(leaveReason : String) -> CGFloat
    {
        let reasonHeight : CGFloat = 17
        
        if leaveReason != NOT_APPLICABLE
        {
            return getTextSize(text: leaveReason, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 90).height + reasonHeight
        }
        else
        {
            return reasonHeight + 17
        }
    }
    
    func showErrorToastView()
    {
        showToastView(toastText: "Problem in getting Leave Details")
    }
    
    //MARK:- Update Status
    @IBAction func rejectBtnAction(_ sender: Any)
    {
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.YES.rawValue)
        {
            AlertView.showAlertView(title: "Alert", message: "Leave Policy is enabled. You are not allowed to Approve/Reject leave from this page. Please go to Leave Approval Screen to Approve/Reject Leave.")
        }
        else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.NO.rawValue)
        {
        
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.reject)
        }
    }

   
    @IBAction func approveBtnAction(_ sender: Any)
    {
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.YES.rawValue)
        {
            AlertView.showAlertView(title: "Alert", message: "Leave Policy is enabled. You are not allowed to Approve/Reject leave from this page. Please go to Leave Approval Screen to Approve/Reject Leave.")
        }
        
        else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_POLICY) == PrivilegeValues.NO.rawValue)
        {
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.approval)
        }
    }
    
  
    //MARK:- Pop Up View
    private func showPopUpView(type : ApprovalButtonType)
    {
        popUpView = ApprovalPoPUp.loadNib()
        
        popUpView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2 ,  y:  SCREEN_HEIGHT, width: 250, height: popUpView.approvalPopUpHeight)
        popUpView.delegate = self
        popUpView.tag = 9000
        popUpView.userObj = userObj        
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
    private func addKeyBoardObserver()
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
    
    private func removeKeyBoardObserver()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
    }
    
    //MARK:- Setting POPUP button Action
    func setPopUpBtnAction(type : ApprovalButtonType)
    {
        removeKeyBoardObserver()
        if type == ApprovalButtonType.approval
        {
            if isComingFromTpPage
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
            if isComingFromTpPage
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
    
    //MARK:- Updating DCR aand TP Approval Status
    private func updateDCRStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
        let strCheck = UserDefaults.standard.string(forKey: "ApprovalENABLED")
        
        if (strCheck == "0"){
            userObj.IsChecked = 0
        }else{
            userObj.IsChecked = 1
        }
        
        BL_Approval.sharedInstance.updateDCRStatus(userList : [userObj] ,userObj: userObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.approved.rawValue, type : "DCR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.unApproved.rawValue, type : "DCR")
                }
                showToastView(toastText: toastText)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else if apiResponseObject.Status == 2
            {
                showToastView(toastText: apiResponseObject.Message)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 4, type : "DCR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 5, type : "DCR")
                }
                showToastView(toastText: toastText)
            }

        }
    }
    
    private func updateTPStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
        BL_Approval.sharedInstance.updateTpStatus(userList : [userObj] ,userObj: userObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.approved.rawValue, type : "TP")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.unApproved.rawValue, type : "TP")
                }
                showToastView(toastText: toastText)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 4, type : "TP")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 5, type : "TP")
                }
                showToastView(toastText: toastText)
            }
        }
    }
    
    //MARK:- Adding Custom Back button
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
    
    //MARK:- Adding Custom View Tour Planner button
    private func addCustomViewTPButtonToNavigationBar()
    {
        let ViewTPButton = UIButton(type: UIButtonType.custom)
        
        ViewTPButton.addTarget(self, action: #selector(self.ViewTPButtonClicked), for: UIControlEvents.touchUpInside)
        ViewTPButton.titleLabel?.font = UIFont(name: fontSemiBold, size: 15.0)
        ViewTPButton.setTitle("View TP", for: .normal)
        
        ViewTPButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: ViewTPButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func ViewTPButtonClicked()
    {
        if tpUserObj != nil
        {
            self.setNavigationToTpReport(detailObj: tpUserObj)
        }
        else
        {
            showToastView(toastText: "No TP(s) available")
        }
    }
    
    //MARK:- Navigate To TP Reports
    func setNavigationToTpReport(detailObj : ApprovalUserMasterModel)
    {
        let date = convertDateIntoString(dateString: detailObj.Actual_Date)
        BL_TpReport.sharedInstance.tpDate = date
        BL_TpReport.sharedInstance.tpId = 0
        BL_TpReport.sharedInstance.tpId = userObj.Activity_Id
        
        //Setting HeaderDetails in UserObj
        userObj.Entered_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Entered_Date , dateFormat: defaultServerDateFormat))
        userObj.Actual_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
        userObj.Activity = detailObj.Activity
        userObj.approvalStatus = detailObj.approvalStatus
        userObj.Activity = detailObj.Activity
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.TpReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TpReportDetailsVcID) as! TpReportDetailsViewController
        vc.userObj = userObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Get TP for DCR date
    func getUserTpList()
    {
        var userPerDayList : [ApprovalUserMasterModel] = []
            if checkInternetConnectivity()
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
                BL_Reports.sharedInstance.getTpHeaderDetailsDataForDCRApproval(userObj: userObj, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        if apiResponseObj.list.count > 0
                        {
                            userPerDayList = BL_Approval.sharedInstance.convertTPHeaderToCommonModel(list: apiResponseObj.list)
                            if userPerDayList.count > 0
                            {
                                self.tpUserObj = userPerDayList[0]
                            }
                        }
                    }
                    else
                    {
                        showToastView(toastText: "Check your network and try again")
                        
                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
    }
    
}
