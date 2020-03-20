//
//  TPUploadDetailsViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPUploadDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Outlet
    @IBOutlet var uploadDetailsTableView: UITableView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var startUploadBtn: UIButton!
    @IBOutlet weak var backToCalHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnUploadAttachment: UIButton!
    //MARK:- Variable
    var navigationTitle : String = ""
    var uploadList:[TourPlannerHeader] = []
    var inProgressFlag : Bool = false
    var retryFlag : Bool = false
    var index : Int = 0
    var uploadLoaderText = "Uploading PR Details"
    var selectedMonth: Int!
    var selectedYear: Int!
    var userDetails: UserModel!
    var isHidoctorLastDate = Bool()
    var tpSFCErrorList:[TPSFCList] = []
    var errorMessage = String()
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad()
    {
        self.errorView.isHidden = true
        self.okBtn.isHidden = true
        self.tableView.isHidden = true
        self.tableView.tableFooterView = UIView()
        super.viewDidLoad()
        self.title = navigationTitle
        addBackButtonView()
        userDetails = DBHelper.sharedInstance.getUserDetail()
        self.setDefaults()
        self.showBackButton()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView datasource and delegate methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if( tableView == self.tableView)
        {
            return tpSFCErrorList.count
        }
        else
        {
            if(BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                return 1
            }
            else
            {
                return uploadList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if( tableView == self.tableView)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell1") as! UITableViewCell
            let titleValue = cell.viewWithTag(1) as! UILabel
            titleValue.text = errorMessage
            return cell
        }
        else
        {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if( tableView == self.tableView)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            let dict = self.tpSFCErrorList[indexPath.row]
            let categoryName = cell.viewWithTag(1) as! UILabel
            let fromPlace = cell.viewWithTag(2) as! UILabel
            let toPlace = cell.viewWithTag(3) as! UILabel
            let enteredCount = cell.viewWithTag(4) as! UILabel
            let maxLimit = cell.viewWithTag(5) as! UILabel
            
            categoryName.text = "Category Place: " + dict.Category_Place
            fromPlace.text = "From Place: " + dict.From_Place
            toPlace.text = "To Place: " + dict.To_Place
            enteredCount.text = "Entered Count: " + "\(dict.Entered_Count!)"
            maxLimit.text = "Limit: " + "\(dict.Max_Limit!)"
            
            return cell
        }
        else
        {
            let cell = uploadDetailsTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TPUploadDetailCell, for: indexPath) as! TPUploadDetailsTableViewCell
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                let uploadObj = uploadList[indexPath.row]
                
                if uploadObj.Activity == 1
                {
                    cell.dateLbl.text = "\(convertDateIntoString(date: uploadObj.TP_Date!)) - \(fieldRcpa)"
                }
                else if uploadObj.Activity == 2
                {
                    cell.dateLbl.text = "\(convertDateIntoString(date: uploadObj.TP_Date!)) - \(attendance)"
                }
                else
                {
                    cell.dateLbl.text = "\(convertDateIntoString(date: uploadObj.TP_Date!)) - \(leave)"
                }
                
                if (isLessthanHidoctorStartDate(dateToCompare: uploadObj.TP_Date!))
                {
                    cell.statusLabel.text = "Not allowed to enter PR before your joining Date."
                    cell.statusLabel.textColor = UIColor.red
                    //cell.cellBgView.backgroundColor = UIColor.lightGray
                }
                else
                {
                    cell.statusLabel.text = "PENDING"
                    //cell.cellBgView.backgroundColor = UIColor.clear
                    
                    if uploadObj.Status != -1
                    {
                        if (uploadObj.Upload_Status == 1)
                        {
                            cell.statusLabel.text = "Success"
                            cell.statusLabel.textColor = UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                        }
                        else if (uploadObj.Upload_Status == 0 || uploadObj.Upload_Status == 2)
                        {
                            cell.statusLabel.text = "Failed - View Reason"
                            cell.statusLabel.textColor = UIColor.red
                        }
                        else if (uploadObj.Upload_Status == 3)
                        {
                            cell.statusLabel.text = "Skipped - View Reason"
                            cell.statusLabel.textColor = UIColor.red
                        }
                    }
                }
                return cell
            }
            else
            {
                let uploadObj = uploadList[indexPath.row]
                
                cell.statusLabel.text = "PENDING"
               // cell.cellBgView.backgroundColor = UIColor.clear
                
                cell.dateLbl.text = "\(getMonthName(monthNumber: selectedMonth!)) \(selectedYear!)"
                if uploadObj.Status != -1
                {
                    if (uploadObj.Upload_Status == 1)
                    {
                        cell.statusLabel.text = "Success"
                        cell.statusLabel.textColor = UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                    }
                    else if (uploadObj.Upload_Status == 0 || uploadObj.Upload_Status == 2)
                    {
                        cell.statusLabel.text = "Failed - View Reason"
                        cell.statusLabel.textColor = UIColor.red
                    }
                    else if (uploadObj.Upload_Status == 3)
                    {
                        cell.statusLabel.text = "Skipped - View Reason"
                        cell.statusLabel.textColor = UIColor.red
                    }
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == self.tableView)
        {
            return getTextSize(text: errorMessage, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 44).height + 30
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.tableView)
        {
            return 125
        }
        else
        {
            return 64
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if( tableView == self.uploadDetailsTableView)
        {
            if(!BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
            {
                let uploadObj = uploadList[indexPath.row]
                
                if uploadObj.Status != -1 && uploadObj.Upload_Msg != EMPTY
                {
                    AlertView.showAlertView(title: alertTitle, message: uploadObj.Upload_Msg)
                }
            }
            else
            {
                let uploadObj = uploadList[indexPath.row]
                
                if(uploadObj.Upload_Status != 1 && uploadObj.Upload_Status != -1)
                {
                    self.tableView.reloadData()
                    self.errorView.isHidden = false
                    self.okBtn.isHidden = false
                    self.tableView.isHidden = false
                }
            }
        }
    }
    
    //MARK:- Upload Action
    func uploadAction()
    {
        if (checkInternetConnectivity())
        {
            startUploadBtn.setTitle(" IN PROGRESS", for: .normal)
            startUploadBtn.backgroundColor = UIColor.orange
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                removeCustomActivityView()
                
                if (apiResponseObj.Status == SERVER_SUCCESS_CODE && apiResponseObj.list.count > 0)
                {
                    showCustomActivityIndicatorView(loadingText: self.uploadLoaderText)
                    
                    if(BL_TPUpload.sharedInstance.isSFCMinCountValidInTP())
                    {
                        if (self.uploadList.count > 0)
                        {
                            BL_TPUpload.sharedInstance.uploadBulkTP(TPHeaderList: self.uploadList, completion: { (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    for uploadObj in self.uploadList
                                    {
                                        
                                        uploadObj.Upload_Status = SERVER_SUCCESS_CODE
                                        uploadObj.Upload_Msg = "Success"
                                        
                                        DAL_TP_Stepper.sharedInstance.deleteTP(tpEntryId: uploadObj.TP_Entry_Id)
                                    }
                                    
                                    self.uploadDetailsTableView.reloadData()
                                    self.tpRefresh()
                                    removeCustomActivityView()
                                        
                                }
                                else if(apiObj.Status == 3)
                                {
                                    if(apiObj.list.count > 0)
                                    {
                                        let dictValue = apiObj.list[0] as! NSDictionary
                                        if let categoryPlace = dictValue.value(forKey: "Category_Place") as? String
                                        {
                                            var tpSfcList:[TPSFCList] = []
                                            for obj in apiObj.list
                                            {
                                                let tpsfcObj = TPSFCList()
                                                let dict = obj as! NSDictionary
                                                
                                                tpsfcObj.Category_Place = dict.value(forKey: "Category_Place") as! String
                                                tpsfcObj.Entered_Count = dict.value(forKey: "Entered_Count") as! Int
                                                tpsfcObj.From_Place = dict.value(forKey: "From_Place") as! String
                                                tpsfcObj.Max_Limit = dict.value(forKey: "Limit") as! Int
                                                tpsfcObj.To_Place = dict.value(forKey: "To_Place") as! String
                                                
                                                tpSfcList.append(tpsfcObj)
                                                
                                            }
                                            self.tpSFCErrorList = tpSfcList
                                        }
                                        else
                                        {
                                           self.tpSFCErrorList = []
                                        }
                                    }
                                    else
                                    {
                                        self.tpSFCErrorList = []
                                    }
                                    removeCustomActivityView()
                                    for uploadObj in self.uploadList
                                    {
                                        DAL_TPUpload.sharedInstance.updateStatus(tpEntryId: uploadObj.TP_Entry_Id!)
                                    }
                                    for uploadObj in self.uploadList
                                    {
                                        
                                        uploadObj.Upload_Status = SERVER_ERROR_CODE
                                        uploadObj.Upload_Msg = "Failed "
                                    }
                                    
                                    self.uploadDetailsTableView.reloadData()
                                    self.showAlert(apiObj: apiObj)
                                }
                                else if(apiObj.Status == 2)
                                {
                                    self.tpSFCErrorList = []
                                    removeCustomActivityView()
                                    for uploadObj in self.uploadList
                                    {
                                        DAL_TPUpload.sharedInstance.updateStatus(tpEntryId: uploadObj.TP_Entry_Id!)
                                    }
                                    for uploadObj in self.uploadList
                                    {
                                        
                                        uploadObj.Upload_Status = SERVER_ERROR_CODE
                                        uploadObj.Upload_Msg = "Failed "
                                    }
                                    
                                    self.uploadDetailsTableView.reloadData()
                                    self.showAlert(apiObj: apiObj)
                                }
                                else if(apiObj.Status == SERVER_ERROR_CODE)
                                {
                                    
                                    removeCustomActivityView()
                                    self.showAlert(apiObj: apiObj)
                                }
                                else
                                {
                                    removeCustomActivityView()
                                }
                            })
                        }
                        else
                        {
                            removeCustomActivityView()
                            let alertMessage =  "No PR found."
                            
                            let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                            
                            alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                                self.refreshTp()
                                alertViewController.dismiss(animated: true, completion: nil)
                            }))
                            
                            self.present(alertViewController, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        self.index = 0
                        
                        if (self.uploadList.count > 0)
                        {
                            self.uploadTP()
                        }
                    }
                }
//                else if (apiResponseObj.Status == NO_INTERNET_ERROR_CODE && apiResponseObj.Count == 0)
//                {
//                    AlertView.showNoInternetAlert()
//                }
//                else
//                {
//                    AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func showAlert(apiObj:ApiResponseModel)
    {
        self.startUploadBtn.setTitle("COMPLETED", for: .normal)
        self.startUploadBtn.backgroundColor = UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
        self.showBackButton()
        errorMessage = apiObj.Message
        let message = String()
        let alertViewController = UIAlertController(title: errorTitle, message: apiObj.Message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
          //  self.refreshTp()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func uploadTP()
    {
        let getTpData = uploadList[self.index]
        
        if(!isLessthanHidoctorStartDate(dateToCompare: getTpData.TP_Date))
        {
            BL_TPUpload.sharedInstance.uploadTP(objTPHeader: uploadList[self.index]) {
                (apiResponseObj) in
                self.uploadTPCallBack(apiResponseObj: apiResponseObj)
            }
        }
        else
        {
            isHidoctorLastDate = true
            if (self.index + 1 < uploadList.count)
            {
                BL_TPStepper.sharedInstance.deleteTP(tpEntryId: getTpData.TP_Entry_Id)
                BL_TPCalendar.sharedInstance.getTPCalendarModel()
                self.index += 1
                
                uploadTP()
            }
            else
            {
                removeCustomActivityView()
                let alertMessage =  "Cannot upload before Pevonia CRM start date PR(s)."
                
                let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    self.refreshTp()
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
    }

    
    private func refreshTp()//if(before hidoctor start date exist
    {
        removeCustomActivityView()
        showCustomActivityIndicatorView(loadingText: "Refreshing PR")
        
        BL_TPRefresh.sharedInstance.refreshTourPlanner(month: self.selectedMonth, year: self.selectedYear, completion: { (status) in
            removeCustomActivityView()
            
            let filtered = self.uploadList.filter{
                $0.Upload_Status == SERVER_ERROR_CODE
            }
            
            if (filtered.count == 0)
            {
                self.startUploadBtn.isEnabled = false
            }
            
            self.startUploadBtn.setTitle("COMPLETED", for: .normal)
            self.startUploadBtn.backgroundColor = UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
            self.showBackButton()
        })
    }
    private func isLessthanHidoctorStartDate(dateToCompare: Date)-> Bool
    {
        var userStartDate = Date()
        if let getstartDate = userDetails?.startDate
        {
            userStartDate = getstartDate
        }
        
        if (userStartDate <= dateToCompare)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    private func uploadTPCallBack(apiResponseObj: ApiResponseModel)
    {
        uploadList[index].Upload_Status = apiResponseObj.Status
        uploadList[index].Upload_Msg = apiResponseObj.Message
        
        if(uploadList[index].Upload_Status == 1 || uploadList[index].Upload_Status == 3)
        {
            DAL_TP_Stepper.sharedInstance.deleteTP(tpEntryId: uploadList[index].TP_Entry_Id)
        }
        
        let indexPath = IndexPath(row: self.index, section: 0)
        uploadDetailsTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        if (self.index + 1 < uploadList.count)
        {
            self.index += 1
            
            uploadTP()
        }
        else
        {
            if(isHidoctorLastDate)
            {
                removeCustomActivityView()
                let alertMessage =  "Cannot upload before Pevonia CRM start date PR(s)."
                
                let alertViewController = UIAlertController(title: infoTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    showCustomActivityIndicatorView(loadingText: "Refreshing PR")
                    BL_TPUpload.sharedInstance.checkTPLock(month: self.selectedMonth, year: self.selectedYear, completion: { (objApiResponse) in
//                        if(objApiResponse.Status == SERVER_SUCCESS_CODE)
//                        {
                        self.refreshTp()
//                        }
                    })
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
                
                
            }
            else
            {
               tpRefresh()
                
            }
        }
    }
    
    @IBAction func uploadActionBtn(_ sender: Any) {
        self.uploadAction()
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.errorView.isHidden = true
        self.okBtn.isHidden = true
        self.tableView.isHidden = true
    }
    
    //MARK:- Updating Views
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func tpRefresh() {
        BL_TPUpload.sharedInstance.checkTPLock(month: self.selectedMonth, year: self.selectedYear, completion: { (objApiResponse) in
            
            removeCustomActivityView()
            showCustomActivityIndicatorView(loadingText: "Refreshing PR")
            
            BL_TPRefresh.sharedInstance.refreshTourPlanner(month: self.selectedMonth, year: self.selectedYear, completion: { (status) in
                removeCustomActivityView()
                
                let filtered = self.uploadList.filter{
                    $0.Upload_Status == SERVER_ERROR_CODE
                }
                
                if (filtered.count == 0)
                {
                    self.startUploadBtn.isEnabled = false
                }
                
                self.startUploadBtn.setTitle("COMPLETED", for: .normal)
                self.startUploadBtn.backgroundColor = UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
                self.showBackButton()
            })
        })
    }
    
    @objc func backButtonClicked()
    {
        if let navigationController = self.navigationController
        {
            let vcList = navigationController.viewControllers
            var index = 0
            var isFound: Bool = false
            
            for currentVC: UIViewController in vcList
            {
                if (currentVC is TPStepperViewController)
                {
                    isFound = true
                    break
                }
                else if (currentVC is TPAttendanceStepperViewController)
                {
                    isFound = true
                    break
                }
                else if (currentVC is TPLeaveEntryViewController)
                {
                    isFound = true
                    break
                }
                
                index += 1
            }
            
            if (isFound)
            {
                self.navigationController?.viewControllers.remove(at: index)
            }
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    func setDefaults()
    {
        startUploadBtn.backgroundColor = UIColor.lightGray
        startUploadBtn.setTitle("UPLOAD", for: .normal)
    }
    
    @IBAction func act_UploadAttachment(_ sender: UIButton) {
         let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentUploadVCID) as! DCRAttachmentUploadController
        vc.isfromTP = true
        self.navigationController!.pushViewController(vc, animated: true)
        
    }

    @IBAction func backToCalendarAction(_ sender: Any)
    {
        if let navigationController = self.navigationController
        {
            let index = navigationController.viewControllers.count - 2
            self.navigationController?.viewControllers.remove(at: index)
        }
        
        backButtonClicked()
    }
    
    func showBackButton()
    {
        let attachmentList = DBHelper.sharedInstance.getUploadableTPAttachments()
        
        if startUploadBtn.title(for: .normal) == "COMPLETED"
        {
            if attachmentList.count != 0{
                backToCalHeightConstraint.constant = 0
                self.btnUploadAttachment.isHidden = false
            } else {
                self.btnUploadAttachment.isHidden = true
                backToCalHeightConstraint.constant = 50
            }
        }
        else
        {
            self.btnUploadAttachment.isHidden = true
           backToCalHeightConstraint.constant = 0
        }
    }
}
