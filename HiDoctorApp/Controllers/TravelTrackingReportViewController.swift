//
//  TravelTrackingReportViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/04/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class TravelTrackingReportViewController: UIViewController,SetSelectedAccompanist {

    @IBOutlet weak var employeeNameLbl: UILabel!
    @IBOutlet weak var fromDateTxtFld: TextField!
    
    var defaultPlaceHolderText = "Show Employee Name"
    
    var fromDatePicker  = UIDatePicker()
    var selectedAccompanistObj : UserMasterModel!
    var fromDate : Date!
    
    var hourlyReportList: [HourlyReportDoctorVisitModel] = []
    
    var arrDoctor: NSArray = []
    var arrChemist: NSArray = []
    var arrStockist: NSArray = []
    var arrTravelTracking: NSArray = []
    
    var arrDoctor1: NSArray = []
    
    var dict: NSDictionary = [:]
    var obj : travelTrackingReport?


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDefaultDetails()
        addCustomBackButtonToNavigationBar()
        self.title = "Travel Tracking Report"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if selectedAccompanistObj != nil
        {
            self.employeeNameLbl.text = selectedAccompanistObj.Employee_name
        }
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
    
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        
        if sender.tag == 1
        {
            self.fromDateTxtFld.text = date
        }
    }
    
    
    private func getReportByApiCall()
    {
        if (checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading. Please wait...")
            BL_HourlyReport.sharedInstance.getTravelTrackingReport(userObj: selectedAccompanistObj, completion: { (objApiResponse) in
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {

                    self.dict = objApiResponse.list?[0] as! NSDictionary
                    
                    if  let doctor = self.dict["lstDoctorVisitTracking"] as? [[String:AnyObject]] {
                        print(doctor)
                        self.arrDoctor = doctor as NSArray
                    }
                    if let stockist = self.dict["lstStockistVisitTracking"] as? [[String:AnyObject]] {
                        print(stockist)
                        self.arrStockist = stockist as NSArray
                    }
                    if let chemist = self.dict["lstChemistVisitTracking"] as? [[String:AnyObject]] {
                        print(chemist)
                        self.arrChemist = chemist as NSArray
                    }
                    if let travelList = self.dict["lstTravelTracking"] as? [[String:AnyObject]] {
                        print(travelList)
                        self.arrTravelTracking = travelList as NSArray
                    }
                    
                    if (self.arrTravelTracking.count > 0){
                        
                        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyTravelTrackingReportGoogleMapViewVc) as! TravelTrackingReportMapViewController
                        vc.arrDoctor = self.arrDoctor
                        vc.arrChemist = self.arrChemist
                        vc.arrStockist = self.arrStockist
                        vc.arrTravelReport = self.arrTravelTracking
                        
                        self.hideLoader()
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.hideLoader()
                        self.showAlertView(title: "Alert!", message: "No Reports Found")
                    }
                }
                else
                {
                    self.hideLoader()
                    self.showAlertView(title: "Alert!", message: "No Reports Found")
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
            showAlertView(title: errorTitle, message: "Unable to download travel tracking report. Please try again")
        }
        else if (objApiResponse.Status == NO_INTERNET_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Internet connection error. Please try again")
        }
        else if (objApiResponse.Status == LOCAL_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Unable to download travel tracking report. Please try again")
        }
    }
    
    private func setDefaultDetails()
    {
        addFromDatePicker()
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
    //    self.selectedAccompanistObj.User_End_Date = getServerFormattedDate(date: toDatePicker.date)
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
    
    //MARK:- Public Functions
    
    @objc func fromPickerDoneAction()
    {
        fromDate = fromDatePicker.date
        setDateDetails(sender: fromDatePicker)
        resignResponderForTextField()
    }
    
//    @objc func toPickerDoneAction()
//    {
//        toDate = toDatePicker.date
//        setDateDetails(sender: toDatePicker)
//        resignResponderForTextField()
//    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    
    @objc func resignResponderForTextField()
    {
        self.fromDateTxtFld.resignFirstResponder()
       // self.toDateTxtFld.resignFirstResponder()
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponderForTextField))
        view.addGestureRecognizer(tap)
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
//        else if toDateTxtFld.text?.count == 0
//        {
//            errorMessage = "Please select to date"
//        }
//        else if !checkToDateIsGreaterandEqual(fromDate: fromDate, toDate: toDate)
//        {
//            errorMessage =  "\"To Date\" should be greater than or equal \"From Date\"."
//        }
        
        return errorMessage
    }
    
    //Delegate
    func getSelectedAccompanist(obj: UserMasterModel)
    {
        selectedAccompanistObj = obj
    }


}
