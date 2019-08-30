//
//  DCRRejectViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DCRRejectViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var emptyStateLbl : UILabel!
    
    @IBOutlet weak var headerLbltxt: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emptyStateViewHgt: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    
    
    var approvedDateList : [ApprovalUserMasterModel] = []
    
    var userObj : ApprovalUserMasterModel!
    var datePicker : UIDatePicker = UIDatePicker()
    var isCmngFromApprovalPage : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        hideContentView()
        setPlaceHolderForPickerTxtFld()
        addDatePicker()
        addCustomBackButtonToNavigationBar()
        self.title = "\(PEV_DCR) Reject"
        self.headerLbltxt.text = userObj.Employee_Name
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if isCmngFromApprovalPage
        {
            self.getApprovedDateList()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
    //MARK:-Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return approvedDateList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var activityName : String = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DCRRejectCell, for: indexPath) as! DCRRejectTableViewCell
        let obj = approvedDateList[indexPath.row]
        
        if obj.Activity == 1
        {
            cell.imgView.image = UIImage(named: "icon-stepper-work-area")
            activityName = "Field" + " - RCPA "
        }
        else if obj.Activity == 3
        {
            cell.imgView.image = UIImage(named: "icon-calendar")
            activityName = "Leave"
        }
        else if obj.Activity == 2
        {
            cell.imgView.image = UIImage(named: "icon-calendar")
            activityName = "Attendance"
        }
        let dateStr = convertDateIntoString(date: getDateStringInFormatDate(dateString:  obj.Actual_Date, dateFormat: defaultServerDateFormat))
        
        cell.dateLbl.text = dateStr + " - " + activityName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if checkInternetConnectivity()
        {
            isCmngFromApprovalPage = true
            let obj = approvedDateList[indexPath.row]
            obj.Employee_Name = userObj.Employee_Name
            obj.Entered_Date = obj.Actual_Date
            obj.Region_Code = userObj.Region_Code
            obj.User_Code = userObj.User_Code
            obj.Activity_Id = obj.Activity
            
            let dateArray = obj.Entered_Date.components(separatedBy: "-")
            
            if dateArray.count > 0
            {
                obj.activityYear = dateArray[0]
                obj.activityMonth = dateArray[1]
            }
            
            if obj.Activity == DCRFlag.attendance.rawValue
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonAttendanceDetailsVcID) as! CommonApprovalAttendanceControllerViewController
                vc.userObj = obj
                vc.isCmngFromRejectPage = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if obj.Activity == DCRFlag.leave.rawValue
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonLeaveApprovalVcID) as! CommonLeaveApprovalViewController
                vc.userObj = obj
                vc.isCmngFromRejectPage = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                
                obj.Actual_Date = convertDateIntoDisplayFormat(date: getStringInFormatDate(dateString: obj.Actual_Date))
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.commonApprovalDetailsVcID) as! ApprovalDetailsViewController
                vc.userObj = obj
                vc.isCmngFromRejectPage = true
                self.navigationController?.pushViewController(vc, animated: true)
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
                
                appliedListObj.Activity = dict.object(forKey: "Flag") as! Int!
                appliedListObj.DCR_Code = dict.object(forKey: "DCR_Code") as! String!
                appliedListObj.Actual_Date = dict.object(forKey: "DCR_Actual_Date") as! String!
                appliedListObj.Entered_Date = dict.object(forKey: "DCR_Entered_Date") as! String!
                appliedList.append(appliedListObj)
            }
        }
        return appliedList
    }

    
    @IBAction func getDCRBtnAction(_ sender: Any)
    {
        resignResponsder()
        if dateTxtField.text?.count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select DVR date", viewController: self)
        }
        else
        {
            userObj.Entered_Date = convertPickerDateIntoDefault(date: datePicker.date, format: defaultServerDateFormat)
            userObj.Actual_Date = convertPickerDateIntoDefault(date: datePicker.date, format: defaultServerDateFormat)
            self.getApprovedDateList()
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
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:-Api Call
    
    func getApprovedDateList()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading..")
            BL_DCRReject.sharedInstance.getDCRHeaderDetailsV59Report(userObj: userObj) {
                (apiResponseObject) in
                removeCustomActivityView()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    let list = self.convertUserAppliedList(list: apiResponseObject.list)
                    self.changeCurrentArray(approvalList: list)
                }
                else
                {
                    var toastText : String  = ""
                    let message = apiResponseObject.Message
                    
                    if apiResponseObject.Status == NO_INTERNET_ERROR_CODE
                    {
                        toastText = "No Internet Connection"
                    }
                    else if message != ""
                    {
                        toastText = message!
                    }
                    else
                    {
                        toastText = "Unable to fetch DVR approval data"
                    }
                    
                    showToastView(toastText: toastText)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }

    func changeCurrentArray(approvalList : [ApprovalUserMasterModel])
    {
        if approvalList.count > 0
        {
            self.approvedDateList = approvalList
            showEmptyStateView(show: false)
            self.emptyStateViewHgt.constant = 0
            self.tableViewTopConst.constant = 20
            reloadTableView()
        }
        else
        {
            setEmptyStateLblTxt()
            self.tableViewHgtConst.constant  = 0
            let height = self.scrollView.frame.height - 166
            self.emptyStateViewHgt.constant = height
            self.tableViewTopConst.constant = 0
            showEmptyStateView(show: true)
        }
    }
    
    func reloadTableView()
    {
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableViewHgtConst.constant = tableView.contentSize.height
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
    }
    
    
    func setEmptyStateLblTxt()
    {
        self.emptyStateLbl.text = "No approved DVR(s) found."
    }

    func hideContentView()
    {
        self.emptyStateView.isHidden = true
        self.tableView.isHidden = true
    }
    
    func showToast(text : String)
    {
        showToastView(toastText: text)
    }
    
    func setPlaceHolderForPickerTxtFld()
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "icon-calendar")
        imageView.contentMode = UIViewContentMode.center
        self.dateTxtField.leftView = imageView
        imageView.tintColor = UIColor.lightGray
        self.dateTxtField.leftViewMode = UITextFieldViewMode.always
        self.dateTxtField.placeholder = "\(PEV_DCR) Date"
    }
    
    func addDatePicker()
    {
        let Toolbar = getToolBar()
        
         let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DCRRejectViewController.doneBtnAction))
        
        let cancelBtn: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(DCRRejectViewController.cancelBtnClicked))
        
        let timePicker = UIDatePicker()
        let locale = NSLocale(localeIdentifier: "en_US")
        timePicker.locale = locale as Locale
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.frame.size.height = timePickerHeight
        timePicker.backgroundColor = UIColor.lightGray
        datePicker = timePicker
        Toolbar.items = [flexSpace, doneBtn, cancelBtn]
        Toolbar.sizeToFit()
        dateTxtField.inputAccessoryView = Toolbar
        dateTxtField.inputView = datePicker
    }
    
    @objc func cancelBtnClicked()
    {
       resignResponsder()
    }
   
    @objc func doneBtnAction()
    {
        self.setDateDetails(sender: datePicker)
        resignResponsder()
    }
    
    
    @objc func resignResponsder()
    {
        self.dateTxtField.resignFirstResponder()
    }

    func setDateDetails(sender : UIDatePicker)
    {
             let date = sender.date
        
            self.dateTxtField.text = convertPickerDateIntoDefault(date: date, format: defaultDateFomat)
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponsder))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
}
