//
//  HourlyReportDateViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportDateViewController: UIViewController,SetSelectedAccompanist {

    
    @IBOutlet weak var employeeNameLbl: UILabel!
    @IBOutlet weak var fromDateTxtFld: TextField!
    @IBOutlet weak var toDateTxtFld: TextField!
    
    var defaultPlaceHolderText = "Show Employee Name"
    
    var fromDatePicker  = UIDatePicker()
    var toDatePicker = UIDatePicker()
    var selectedAccompanistObj : UserMasterModel!
    var fromDate : Date!
    var toDate : Date!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setDefaultDetails()
        addCustomBackButtonToNavigationBar()
        self.title = "Live Tracker Report"
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if selectedAccompanistObj != nil
        {
            self.employeeNameLbl.text = selectedAccompanistObj.Employee_name
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private function
    
    private func addFromDatePicker()
    {
        fromDatePicker = getDatePickerView()
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(HourlyReportDateViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(HourlyReportDateViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        fromDatePicker.tag = 1
        fromDateTxtFld.inputAccessoryView = doneToolbar
        fromDateTxtFld.inputView = fromDatePicker
    }
    
    private func addToDatePicker()
    {
        toDatePicker = getDatePickerView()
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(HourlyReportDateViewController.toPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(HourlyReportDateViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        toDatePicker.tag = 2
        toDateTxtFld.inputAccessoryView = doneToolbar
        toDateTxtFld.inputView = toDatePicker
    }
    
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        
        if sender.tag == 1
        {
            self.fromDateTxtFld.text = date
        }
        else
        {
            self.toDateTxtFld.text =  date
        }
    }
    
    private func getReportByApiCall()
    {
        if (checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading. Please wait...")
            BL_HourlyReport.sharedInstance.getHourlyReportSummary(userObj: selectedAccompanistObj, completion: { (objApiResponse) in
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    if (objApiResponse.list.count > 0)
                    {
                        let doctorVisitList = objApiResponse.list
                        BL_HourlyReport.sharedInstance.getDCRHeaderDetails(userObj: self.selectedAccompanistObj, completion: { (objApiResponse) in
                            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                            {
                              let dcrHeaderList  = BL_HourlyReport.sharedInstance.convertToDCRHeaderModel(headerDataArray: objApiResponse.list)
                                self.hideLoader()
                                let visitList = BL_HourlyReport.sharedInstance.filterHeaderAndVisitList(dcrHeaderList: dcrHeaderList, doctorVisitList: doctorVisitList!)
                                self.navigateToDoctorVisitListPage(doctorVisitList: visitList)
                            }
                            else
                            {
                                self.showApiErrorMessage(objApiResponse: objApiResponse)
                            }
                        })
                    }
                    else
                    {
                        self.hideLoader()
                        self.showAlertView(title: infoTitle, message: "No \(appDoctor)/\(appChemist) visits available for this date")
                    }
                }
                else
                {
                   self.showApiErrorMessage(objApiResponse: objApiResponse)
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
        
    private func hideLoader()
    {
        removeCustomActivityView()
    }
    
    private func showAlertView(title : String , message : String)
    {
        AlertView.showAlertView(title: title, message: message,viewController: self)
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
    
    private func showApiErrorMessage(objApiResponse: ApiResponseModel)
    {
        hideLoader()
        
        if (objApiResponse.Status == SERVER_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Unable to download live tracker report. Please try again")
        }
        else if (objApiResponse.Status == NO_INTERNET_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Internet connection error. Please try again")
        }
        else if (objApiResponse.Status == LOCAL_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Unable to download live tracker report. Please try again")
        }
    }

    private func setDefaultDetails()
    {
        addFromDatePicker()
        addToDatePicker()
        addTapGestureForView()
    }
    
    private func navigateToDoctorVisitListPage(doctorVisitList : [ReportDoctorVisitListModel])
    {
        let sb = UIStoryboard(name:Constants.StoaryBoardNames.ReportsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDoctorVisitVcID) as! HourlyReportDoctorVisitListViewController
        vc.doctorVisitList = doctorVisitList
        vc.userObj = selectedAccompanistObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setDateToModelObj()
    {
        self.selectedAccompanistObj.User_Start_Date = getServerFormattedDate(date: fromDatePicker.date)
        self.selectedAccompanistObj.User_End_Date = getServerFormattedDate(date: toDatePicker.date)
    }
    
    //MARK:- Public Functions
    
    @objc func fromPickerDoneAction()
    {
        fromDate = fromDatePicker.date
        setDateDetails(sender: fromDatePicker)
        resignResponderForTextField()
    }
    
    @objc func toPickerDoneAction()
    {
        toDate = toDatePicker.date
        setDateDetails(sender: toDatePicker)
        resignResponderForTextField()
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    
    @objc func resignResponderForTextField()
    {
        self.fromDateTxtFld.resignFirstResponder()
        self.toDateTxtFld.resignFirstResponder()
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponderForTextField))
        view.addGestureRecognizer(tap)
    }

    //MARK:- Button Action
    
    @IBAction func showEmployeeBtnAction(sender : UIButton)
    {
        resignResponderForTextField()
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDoctorListVcID) as! HourlyReportDoctorListViewController
        vc.screenId = HourlyReportListIdentifier.reportAccompanistList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showReportBtnAction(sender : UIButton)
    {
        let errorMessage = validation()
        if errorMessage != ""
        {
            AlertView.showAlertView(title: errorTitle, message: errorMessage, viewController: self)
        }
        else
        {
            self.setDateToModelObj()
            self.getReportByApiCall()
        }
    }
    
    //MARK:- Validation
    
    private func validation() -> String
    {
        var errorMessage : String = EMPTY
        
        if employeeNameLbl.text == defaultPlaceHolderText
        {
            errorMessage = "Please select employee name"
        }
        else if fromDateTxtFld.text?.count == 0
        {
            errorMessage = "Please select from date"
        }
        else if toDateTxtFld.text?.count == 0
        {
            errorMessage = "Please select to date"
        }
        else if !checkToDateIsGreaterandEqual(fromDate: fromDate, toDate: toDate)
        {
            errorMessage =  "\"To Date\" should be greater than or equal \"From Date\"."
        }
        
        return errorMessage
    }
    
    //Delegate
    func getSelectedAccompanist(obj: UserMasterModel)
    {
        selectedAccompanistObj = obj
    }
}
