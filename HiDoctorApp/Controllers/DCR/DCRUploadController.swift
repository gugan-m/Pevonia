//
//  DCRUploadController.swift
//  HiDoctorApp
//
//  Created by Vijay on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRUploadController: UIViewController, UITableViewDelegate, UITableViewDataSource, DCRRefreshDelegate {
    
    func getInwardAlert(statusCode: Int, isNavigate: Bool) {
        if(isNavigate)
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: InwardAccknowledgementID) as! InwardChalanListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadAttachmentBtn: UIButton!
    @IBOutlet weak var uploadAttachmentHeightConst: NSLayoutConstraint!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var eDetailingViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var syncAllBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadDCROnlyBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var syncAllButton: UIButton!
    @IBOutlet weak var eDetailingView: UIView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dividerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
   
    
    
    var uploadDetailList: [DCRUploadDetail]!
    var inProgressFlag : Bool = false
    var retryFlag : Bool = false
    var refreshRetryFlag : Bool = false
    var index : Int = 0
    let uploadLoaderText: String = "Uploading DVR data.."
    let downloadLoaderText: String = "Downloading DVR data.."
    var enabledAutoSync: Bool = false
    var orientation = UIDeviceOrientation(rawValue: 0)
    var isSkiped: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        uploadAnalyticsDuringDCRRefresh = false
        navigateToAttachmentUpload = true
        // Do any additional setup after loading the view.
        addCustomBackButtonToNavigationBar()
        orientation = UIDevice.current.orientation
        BL_Upload_DCR.sharedInstance.isFromDCRUpload = true
        setDefaults()
        
        if (enabledAutoSync)
        {
            uploadDCROnly()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    
    func setDefaults()
    {
        self.navigationItem.title = "Upload DVR"
        uploadDetailList = BL_Upload_DCR.sharedInstance.convertToUploadDetail()
        
        if (uploadDetailList.count > 0)
        {
            uploadBtn.isUserInteractionEnabled = true
        }
        else
        {
            uploadBtn.isUserInteractionEnabled = false
        }
        
        uploadAttachmentBtn.isHidden = true
        uploadAttachmentHeightConst.constant = 0.0
        
//        if DBHelper.sharedInstance.getUploadableAttachments().count > 0
//        {
//            uploadAttachmentBtn.isHidden = false
//            uploadAttachmentHeightConst.constant = 30.0
//        }
//        else
//        {
//            uploadAttachmentBtn.isHidden = true
//            uploadAttachmentHeightConst.constant = 0.0
//        }
        
        self.toggleButton()
    }
    
    func toggleButton()
    {
        let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
        toggleButtons(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return uploadDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadDCRCell") as! DCRUploadCell
        let model = uploadDetailList[indexPath.row]
        let dateLabel = String(format:"%@ (%@)", convertDateIntoString(date: model.dcrDate), model.flagLabel)
        
        cell.dateLabel.text = dateLabel
        
        if model.reason != ""
        {
            cell.statusLabel.text = "View Reason"
        }
        else
        {
            cell.statusLabel.text = model.statusText
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let model = uploadDetailList[indexPath.row]
        
        if model.showPopup == true
        {
            DCRRefreshAlert()
        }
        else if model.reason != ""
        {
            if (model.failedStatusCode == 4)
            {
                DispatchQueue.main.async(execute: {
                    let alertViewController = UIAlertController(title: errorTitle, message: model.reason, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.default, handler: { alertAction in
                        alertViewController.dismiss(animated: true, completion: nil)
                        self.downloadExpenseData(model: model)
                    }))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                })
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    AlertView.showAlertView(title: errorTitle, message: model.reason, viewController: self)
                })
            }
        }
    }
    
    func DCRRefreshAlert()
    {
        let alert = UIAlertController(title: "Alert", message: dcrUploadSeqValMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "PROCEED", style: .default, handler: { (action: UIAlertAction!) in
            self.navigateToDCRrefresh()
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToDCRrefresh()
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: RefreshVcID) as! DCRRefreshController
        
        vc.refreshMode = DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA
        
        let model = uploadDetailList[index]
        let dcrDateVal = convertDateIntoServerStringFormat(date: model.dcrDate)
        
        vc.endDate = dcrDateVal
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func uploadBtnAction(_ sender: AnyObject)
    {
        //startUpload()
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading....")
            let postData = BL_Upload_DCR.sharedInstance.getDeleteDoctorAudit()
            if(postData.count > 0)
            {
                BL_Upload_DCR.sharedInstance.insertEdetailingDoctorDelete(arrayValue:postData) { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
                        removeCustomActivityView()
                        self.uploadDCROnly()
                    }
                    else
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: errorTitle, message: "Unable to upload DVR", viewController: self)
                    }
                }
            }
            else
            {
                BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
                removeCustomActivityView()
                self.uploadDCROnly()
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
        let postData = BL_Upload_DCR.sharedInstance.getDeleteDoctorAudit()
        if(postData.count > 0)
        {
            BL_Upload_DCR.sharedInstance.insertEdetailingDoctorDelete(arrayValue:postData) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
                    removeCustomActivityView()
                    let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
                    
                    self.uploadDCRAndAnalytics(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: "Unable to upload DVR", viewController: self)
                }
            }
        }
        else
        {
            BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
            removeCustomActivityView()
            let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
            
            self.uploadDCRAndAnalytics(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
        }
    
    }
    
    @IBAction func syncAllBtnAction(_ sender: AnyObject)
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading....")
            let postData = BL_Upload_DCR.sharedInstance.getDeleteDoctorAudit()
            if(postData.count > 0)
            {
                BL_Upload_DCR.sharedInstance.insertEdetailingDoctorDelete(arrayValue:postData) { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
                        removeCustomActivityView()
                        let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
                        
                        self.uploadDCRAndAnalytics(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
                    }
                    else
                    {
                        removeCustomActivityView()
                        AlertView.showAlertView(title: errorTitle, message: "Unable to upload DVR", viewController: self)
                    }
                }
            }
            else
            {
                BL_Upload_DCR.sharedInstance.deleteDoctorAuditDetails()
                removeCustomActivityView()
                let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
                
                self.uploadDCRAndAnalytics(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
//        let pendingList = DBHelper.sharedInstance.getAssetAnalytics()
//
//        uploadDCRAndAnalytics(analyticsCount: pendingList.count, dcrCount: self.uploadDetailList.count)
    }
    
    private func startUpload()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objApiResponse) in
                
                removeCustomActivityView()
                
                if (objApiResponse.list.count > 0)
                {
                    self.upload()
                }
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
    
    private func upload()
    {
        if !inProgressFlag
        {
            inProgressFlag = true
            setButtonText(title: progressStatus)
            showCustomActivityIndicatorView(loadingText: uploadLoaderText)
            uploadDCRList()
        }
        else if retryFlag || refreshRetryFlag
        {
            if retryFlag
            {
                setButtonText(title: progressStatus)
                retryFlag = false
                showCustomActivityIndicatorView(loadingText: uploadLoaderText)
                uploadDCRList()
            }
            else if refreshRetryFlag
            {
                setButtonText(title: refreshStatus)
                refreshRetryFlag = false
                dcrRefresh()
            }
        }
    }
    
    private func doWorkPlaceLengthValidaiton(model: DCRUploadDetail) -> Bool
    {
        if model.flagLabel == "F" || model.flagLabel == "A"
        {
            let dcrHeaderList = DBHelper.sharedInstance.getDCRHeaderForUpload(dcrId: model.dcrId)
            for dcrHeaderObj in dcrHeaderList
            {
                if (checkNullAndNilValueForString(stringData: dcrHeaderObj.Place_Worked).count > flexiPlaceMaxLength)
                {
                    let errorMsg: String = "You have entered more than \(flexiPlaceMaxLength) characters in Work Place. The DVR is in draft status now. Please change the work place before proceeding further"
                    self.setButtonText(title: failedStatus)
                    self.updateUploadDetail(statusMsg: failedStatus, reason: errorMsg, showPopup: false, failedStatusCode: 0)
                    BL_Upload_DCR.sharedInstance.updateDCRStatusAsDraft(dcrId: dcrHeaderObj.DCR_Id, dcrDate: dcrHeaderObj.DCR_Actual_Date)
                    
                    return false
                }
            }
        }
        return true
    }
    
    private func doAttendanceRemarksLengthValidation(model: DCRUploadDetail) -> Bool
    {
        if model.flagLabel == "A"
        {
            let attendanceActivities = DBHelper.sharedInstance.getDCRAttendanceActivitiesForUpload(dcrId: model.dcrId)
            for attendanceActivity in attendanceActivities
            {
                if (checkNullAndNilValueForString(stringData: attendanceActivity.Remarks).count > attendanceActivityRemarksLength)
                {
                    let errorMsg: String = "You have entered more than \(attendanceActivityRemarksLength) characters for the activity \(checkNullAndNilValueForString(stringData: attendanceActivity.Activity_Name)). The DVR is in draft status now. Please correct the remarks before proceeding further"
                    self.setButtonText(title: failedStatus)
                    self.updateUploadDetail(statusMsg: failedStatus, reason: errorMsg, showPopup: false, failedStatusCode: 0)
                    BL_Upload_DCR.sharedInstance.updateDCRStatusAsDraft(dcrId: model.dcrId, dcrDate: model.dcrDate)
                    
                    return false
                }
            }
        }
        return true
    }
    // tranxit
    func uploadDCRList()
    {
        let model = uploadDetailList[index]
        let dcrDateVal: String? = convertDateIntoServerStringFormat(date: model.dcrDate)
        
        if (doAttendanceRemarksLengthValidation(model: model))
        {
            if let dcrDate = dcrDateVal
            {
                BL_Upload_DCR.sharedInstance.uploadDCR(dcrId: model.dcrId, dcrDate: dcrDate, checkSumId: 0, flag: model.flag) { (apiResponseModel) in
                    if apiResponseModel.Status == SERVER_ERROR_CODE
                    {
                        let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                        
                        BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                        
                        if (apiResponseModel.Message == "Your DCR has been Locked for this day, Due to delay in uploading DCR. Please contact H.O. to release the lock.") || (apiResponseModel.Message == "Your DCR has been Locked, due to unapproved DCR activity Lock.")
                        {
                            self.updateUploadDetail(statusMsg: skippedStatus, reason: apiResponseModel.Message, showPopup: false, failedStatusCode: apiResponseModel.Status)
                            
                            self.index = self.index + 1
                            
                            if self.index < self.uploadDetailList.count
                            {
                                self.uploadDCRList()
                            }
                            else
                            {
                                self.dcrRefresh()
                            }
                        }
                        else
                        {
                            self.setButtonText(title: failedStatus)
                            self.updateUploadDetail(statusMsg: failedStatus, reason: apiResponseModel.Message, showPopup: false, failedStatusCode: apiResponseModel.Status)
                        }
                    }
                    else if apiResponseModel.Status == NO_INTERNET_ERROR_CODE || apiResponseModel.Status == 99
                    {
                        self.retryFlag = true
                        self.setButtonText(title: retryStatus)
                        self.updateUploadDetail(statusMsg: failedStatus, reason: "Please check your internet connection", showPopup: false, failedStatusCode: apiResponseModel.Status)
                    }
                    else if apiResponseModel.Status == 1
                    {
                        if apiResponseModel.list.count > 0
                        {
                            let dictionary = apiResponseModel.list[0] as! NSDictionary
                            if BL_Upload_DCR.sharedInstance.verifySyncedRecordCount(dict: dictionary)
                            {
                                DBHelper.sharedInstance.deleteAnalyticsByDCRDate(dcrDate: dcrDateVal!)
                                
                                if let array = dictionary.value(forKey: "lstDCRAttachment") as? NSArray
                                {
                                    for dict in array
                                    {
                                        if let getDict = dict as? NSDictionary
                                        {
                                            let dcrId = getDict.value(forKey: "DCR_Id") as! Int
                                            let doctorVisitId = getDict.value(forKey: "Visit_Id") as! Int
                                            let dcrVisitCode = getDict.value(forKey: "DCR_Visit_Code") as! String
                                            DBHelper.sharedInstance.updateAttachmentDCRVisitCode(dcrId: dcrId, doctorVisitId: doctorVisitId, dcrVisitCode: dcrVisitCode)
                                        }
                                    }
                                }
                                
                                if let array = dictionary.value(forKey: "lstDCRChemistAttachment") as? NSArray
                                {
                                    for dict in array
                                    {
                                        if let getDict = dict as? NSDictionary
                                        {
                                            let chemistDayVisitId = getDict.value(forKey: "CV_Visit_Id") as! Int
                                            let cvVisitId = getDict.value(forKey: "chemistVisit_Id") as! Int
                                            DBHelper.sharedInstance.updateChemistAttachmentVisitId(chemistDayVisitId: chemistDayVisitId, cvVisitId: cvVisitId)
                                        }
                                    }
                                }
                                
                                self.updateUploadDetail(statusMsg: successStatus, reason: "", showPopup: false, failedStatusCode: apiResponseModel.Status)
                                self.index = self.index + 1
                                
                                if self.index < self.uploadDetailList.count
                                {
                                    self.uploadDCRList()
                                }
                                else
                                {
                                    self.dcrRefresh()
                                }
                            }
                            else
                            {
                                let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                                extProp.setValue(apiResponseModel.Message, forKey: "API_RESPONSE_MESSAGE")
                                
                                BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                                
                                self.setButtonText(title: failedStatus)
                                self.updateUploadDetail(statusMsg: failedStatus, reason: "Count mismatch", showPopup: false, failedStatusCode: apiResponseModel.Status)
                            }
                        }
                        else
                        {
                            let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                            extProp.setValue(apiResponseModel.Message, forKey: "API_RESPONSE_MESSAGE")
                            
                            BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                            
                            self.setButtonText(title: failedStatus)
                            self.updateUploadDetail(statusMsg: failedStatus, reason: apiResponseModel.Message, showPopup: false, failedStatusCode: apiResponseModel.Status)
                        }
                    }
                    else if apiResponseModel.Status == 2
                    {
                        self.setButtonText(title: failedStatus)
                        self.updateUploadDetail(statusMsg: failedStatus, reason: apiResponseModel.Message, showPopup: false, failedStatusCode: apiResponseModel.Status)
                        
                        BL_Upload_DCR.sharedInstance.updateDCRStatusAsDraft(dcrId: model.dcrId, dcrDate: model.dcrDate)
                    }
                    else if apiResponseModel.Status == 3
                    {
                        self.updateUploadDetail(statusMsg: skippedStatus, reason: "", showPopup: false, failedStatusCode: apiResponseModel.Status)
                        self.index = self.index + 1
                        
                        if self.index < self.uploadDetailList.count
                        {
                            self.uploadDCRList()
                        }
                        else
                        {
                            self.dcrRefresh()
                        }
                    }
                    else if apiResponseModel.Status == 5
                    {
                        self.setButtonText(title: failedStatus)
                        self.updateUploadDetail(statusMsg: failedStatus, reason: apiResponseModel.Message, showPopup: true, failedStatusCode: apiResponseModel.Status)
                    }
                    else if (apiResponseModel.Status == 4)
                    {
                        self.setButtonText(title: failedStatus)
                        self.updateUploadDetail(statusMsg: failedStatus, reason: apiResponseModel.Message, showPopup: false, failedStatusCode: apiResponseModel.Status)
                    }
                }
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: errorTitle, message: Display_Messages.Error_Log.ERROR_OCCURED_ALERT, viewController: self)
                
                let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                
                BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.DCR, subModuleName: Constants.Module_Names.DCR, screenName: Constants.Screen_Names.UPLOAD_DCR, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
            }
        }
    }
    
    func updateUploadDetail(statusMsg : String, reason: String, showPopup : Bool, failedStatusCode: Int)
    {
        if statusMsg == failedStatus
        {
            removeCustomActivityView()
        }
        
        self.uploadDetailList = BL_Upload_DCR.sharedInstance.updateDCRUploadDetail(index: self.index, statusText: statusMsg, reason: reason, showPopup: showPopup, uploadDetail: self.uploadDetailList, failedStatusCode: failedStatusCode)
        
        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
        
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    func dcrRefresh()
    {
        setButtonText(title: refreshStatus)
        refreshAPICall()
    }
    
    private func refreshAPICall()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: downloadLoaderText)
            BL_Geo_Location.sharedInstance.uploadCustomerAddress(completion: { (status) in
                BL_DCR_Refresh.sharedInstance.dcrRefreshAPICall(refreshMode: DCRRefreshMode.MERGE_LOCAL_AND_SERVER_DATA, endDate: "")
                BL_DCR_Refresh.sharedInstance.delegate = self
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func getServiceStatus(message: String, statusCode: Int)
    {
        //removeCustomActivityView()
        showToastView(toastText: message)
        if statusCode == NO_INTERNET_ERROR_CODE
        {
            setButtonText(title: retryStatus)
            refreshRetryFlag = true
        }
        
        if statusCode == SERVER_SUCCESS_CODE
        {
            setButtonText(title: completedStatus)
            self.uploadBtn.isUserInteractionEnabled = false
        }
    }
    
    func setButtonText(title : String)
    {
        uploadBtn.setTitle(title, for: UIControlState.normal)
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
    
    @IBAction func uploadAttachmentAction(_ sender: Any)
    {
        if (DBHelper.sharedInstance.getUploadableAttachments().count > 0 || DBHelper.sharedInstance.getChemistUploadableAttachments().count > 0)
        {
            if let navigationController = self.navigationController
            {
                let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentUploadVCID)
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func downloadExpenseData(model: DCRUploadDetail)
    {
        BL_Upload_DCR.sharedInstance.updateDCRStatusAsDraft(dcrId: model.dcrId, dcrDate: model.dcrDate)
        
        showCustomActivityIndicatorView(loadingText: "Downloading expense data.")
        
        BL_Upload_DCR.sharedInstance.deleteDCRExpenses(dcrId: model.dcrId)
        BL_Upload_DCR.sharedInstance.updateDCRStatusAsDraft(dcrId: model.dcrId, dcrDate: model.dcrDate)
        
        BL_Upload_DCR.sharedInstance.downloadExpenseData(completion: { (status) in
            removeCustomActivityView()
            showToastView(toastText: "Updated expense data downloaded. The DVR is in draft mode. Please edit & resubmit the DCR")
        })
    }
    
    private func uploadDCROnly()
    {
        uploadAnalyticsDuringDCRRefresh = false
        navigateToAttachmentUpload = true
        self.startUpload()
    }
    
    private func uploadDCRAndAnalytics(analyticsCount: Int, dcrCount: Int)
    {
        uploadAnalyticsDuringDCRRefresh = true
        navigateToAttachmentUpload = true
        
        if (dcrCount == 0 && analyticsCount == 0)
        {
            AlertView.showAlertView(title: infoTitle, message: "Sorry. No data found to upload", viewController: self)
            return
        }
        
        if (dcrCount > 0 && analyticsCount > 0)
        {
            self.startUpload()
        }
        else if (dcrCount == 0 && analyticsCount > 0)
        {
            showCustomActivityIndicatorView(loadingText: "Please wait...")
            navigateToAttachmentUpload = false
            BL_UploadAnalytics.sharedInstance.checkAnalyticsStatus()
        }
    }
    
    private func toggleButtons(analyticsCount: Int, dcrCount: Int)
    {
        if (analyticsCount > 0 && dcrCount > 0)
        {
            showAllAndUploadButton()
            showEDetailingLabel()
        }
        else if (analyticsCount == 0 && dcrCount > 0)
        {
            showUploadDCROnlyButton()
            hideEDetailingLabel()
        }
        else if (analyticsCount > 0 && dcrCount == 0)
        {
            showSyncAllButton()
            showEDetailingLabel()
        }
    }
    
    private func showAllAndUploadButton()
    {
        let width = (self.view.frame.width - 60) / 2
        syncAllBtnWidthConstraint.constant = width
        uploadDCROnlyBtnWidthConstraint.constant = width
        
        uploadBtn.isHidden = false
        syncAllButton.isHidden = false
    }
    
    private func showUploadDCROnlyButton()
    {
        var horizontalWidth = self.view.frame.width/2
        var width = self.view.frame.width
        if UIDevice.current.orientation.isPortrait {
            horizontalWidth = self.view.bounds.size.width/2
            width = self.view.bounds.size.width
            //frame.width
        }
        else
        {
            horizontalWidth = self.view.bounds.size.width/2
            width = self.view.bounds.size.width
        }
        syncAllBtnWidthConstraint.constant = 0
        uploadDCROnlyBtnWidthConstraint.constant = width - 20
        dividerViewWidthConstraint.constant = -horizontalWidth
        uploadBtn.isHidden = false
        syncAllButton.isHidden = true
    }
    
    private func showSyncAllButton()
    {
        let horizontalWidth = self.view.frame.width/2
        let width = self.view.frame.width
        syncAllBtnWidthConstraint.constant = width - 20
        uploadDCROnlyBtnWidthConstraint.constant = 0
        dividerViewWidthConstraint.constant = horizontalWidth
        uploadBtn.isHidden = true
        syncAllButton.isHidden = false
    }
    
    private func hideEDetailingLabel()
    {
        eDetailingViewHeighConstraint.constant = 0
        eDetailingView.isHidden = true
    }
    
    private func showEDetailingLabel()
    {
        eDetailingViewHeighConstraint.constant = 25
        eDetailingView.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        toggleButton()
    }
}
