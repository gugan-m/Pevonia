//
//  GeoReportDateViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 02/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class GeoReportDateViewController: UIViewController,SetSelectedAccompanist,UIPickerViewDelegate {
    @IBOutlet weak var employeeNameLbl: UILabel!
    @IBOutlet weak var fromDateTxtFld: TextField!
    @IBOutlet weak var toDateTxtFld: TextField!
    var pickerView: UIPickerView!
    var statusArray = ["UNAPPROVED", "APPLIED", "APPROVED", "DRAFT", "ALL"]
    
    @IBOutlet weak var statusTextField: TextField!
    var defaultPlaceHolderText = "Show Employee Name"
    
    var fromDatePicker  = UIDatePicker()
    var toDatePicker = UIDatePicker()
    var selectedAccompanistObj : UserMasterModel!
    var fromDate : Date!
    var toDate : Date!
    var selectedRow: Int = 0
    var statusString : String = EMPTY
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultDetails()
        addCustomBackButtonToNavigationBar()
        self.title = "Geo Location Report"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        if selectedAccompanistObj != nil
        {
            self.employeeNameLbl.text = selectedAccompanistObj.Employee_name
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setDefaultDetails()
    {
        addFromDatePicker()
        addToDatePicker()
        addTapGestureForView()
        loadPickerview()
    }
    private func addFromDatePicker()
    {
        fromDatePicker = getDatePickerView()
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.cancelBtnClicked))
        
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
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.toPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.cancelBtnClicked))
        
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
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponderForTextField))
        view.addGestureRecognizer(tap)
    }
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
    @IBAction func showEmployeeBtnAction(sender : UIButton)
    {
        // resignResponderForTextField()
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
            errorMessage =  "\"To Date\" should be greater than or equal to \"From Date\"."
        }
        else if statusTextField.text == EMPTY || statusTextField.text == nil
        {
            errorMessage = "Please select Status"
        }
        return errorMessage
    }
    
    private func setDateToModelObj()
    {
        self.selectedAccompanistObj.User_Start_Date = getServerFormattedDate(date: fromDatePicker.date)
        self.selectedAccompanistObj.User_End_Date = getServerFormattedDate(date: toDatePicker.date)
    }
    //Delegate
    func getSelectedAccompanist(obj: UserMasterModel)
    {
        selectedAccompanistObj = obj
    }
    func loadPickerview()
    {
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        let selectedIndex : Int = 0
        selectedRow = selectedIndex
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        let pickerToolbar = UIToolbar()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddTravelDetailsController.doneClicked))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerToolbar.sizeToFit()
        self.statusTextField.inputView = pickerView
        self.statusTextField.inputAccessoryView = pickerToolbar
    }
    func doneClicked()
    {
        self.statusTextField.text = statusArray[selectedRow]
        self.statusTextField.resignFirstResponder()
    }
    // Pickerview delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return statusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return statusArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return SCREEN_WIDTH
    }
    
    private func getReportByApiCall()
    {
        if(selectedRow == 4)
        {
            self.statusString = "ALL"
        }
        else
        {
            self.statusString = "\(selectedRow),"
        }
        if (checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading. Please wait...")
            BL_HourlyReport.sharedInstance.getGeoDCRDoctorVisitDetails(userObj: selectedAccompanistObj, status: self.statusString, completion: { (objApiRespo) in
                if (objApiRespo.Status == SERVER_SUCCESS_CODE)
                {
                    let doctorVisitList = BL_HourlyReport.sharedInstance.convertToDoctorVisitModel(doctorVisitArray: objApiRespo.list)
                    
                    BL_HourlyReport.sharedInstance.getGeoDCRChemistVisitDetails(userObj: self.selectedAccompanistObj, status: self.statusString, completion: { (objApiResponse) in
                        if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                        {
                            var stockistVisitList1 : [ DCRDoctorVisitModel] = []
                            var chemistVisitList : [ DCRDoctorVisitModel] = []
                            if objApiResponse.list.count > 0
                            {
                                chemistVisitList = BL_HourlyReport.sharedInstance.convertToChemistVisitModel(doctorVisitArray: objApiResponse.list)
                                
                            }
                            else
                            {
                                
                            }
                            
                            BL_HourlyReport.sharedInstance.getDCRStockistVisitDetails(userObj: self.selectedAccompanistObj, status: self.statusString, completion: { (objApiResponse1) in
                                if (objApiResponse1.Status == SERVER_SUCCESS_CODE)
                                {
                                    
                                    if objApiResponse1.list.count > 0
                                    {
                                        stockistVisitList1 = BL_HourlyReport.sharedInstance.convertToStockistVisitModel(doctorVisitArray: objApiResponse1.list)
                                    }else{
                                        if objApiResponse.list.count == 0 && objApiRespo.list.count == 0 && objApiResponse1.list.count == 0
                                        {
                                            self.hideLoader()
                                            self.showAlertView(title: infoTitle, message: "No \(appDoctor)/\(appChemist)/\(appStockiest) visits available for this date")
                                        }
                                    }
                                
                                    BL_HourlyReport.sharedInstance.getGeoDCRHeaderDetails(userObj: self.selectedAccompanistObj,  status: self.statusString, completion: { (objApiResponse3) in
                                        if (objApiResponse3.Status == SERVER_SUCCESS_CODE)
                                        {
                                            let dcrHeaderList  = BL_HourlyReport.sharedInstance.convertToDCRHeaderModel(headerDataArray: objApiResponse3.list)
                                            
                                            self.hideLoader()
                                            let visitList = BL_HourlyReport.sharedInstance.filterHeaderAndVisitListGeo(dcrHeaderList: dcrHeaderList, doctorVisitList: doctorVisitList, chemistVisitList: chemistVisitList, stockistVisitList: stockistVisitList1)
                                            self.navigateToDoctorVisitListPage(doctorVisitList: visitList)
                                        }
                                        else
                                        {
                                            self.showApiErrorMessage(objApiResponse: objApiResponse3)
                                        }
                                    })

                                }
                                
                                
                                
                            })

                            
                                                    }
                    })
                }
                else
                {
                    self.showApiErrorMessage(objApiResponse: objApiRespo)
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
    
    private func navigateToDoctorVisitListPage(doctorVisitList : [ReportDoctorVisitListModel])
    {
        let sb = UIStoryboard(name:Constants.StoaryBoardNames.ReportsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDoctorVisitVcID) as! HourlyReportDoctorVisitListViewController
        vc.isComingFromGeo = true
        vc.doctorVisitList = doctorVisitList
        vc.userObj = selectedAccompanistObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showApiErrorMessage(objApiResponse: ApiResponseModel)
    {
        hideLoader()
        
        if (objApiResponse.Status == SERVER_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Unable to download report. Please try again")
        }
        else if (objApiResponse.Status == NO_INTERNET_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Internet connection error. Please try again")
        }
        else if (objApiResponse.Status == LOCAL_ERROR_CODE)
        {
            showAlertView(title: errorTitle, message: "Unable to download report. Please try again")
        }
    }
    
    private func showAlertView(title : String , message : String)
    {
        AlertView.showAlertView(title: title, message: message,viewController: self)
    }
    
}
