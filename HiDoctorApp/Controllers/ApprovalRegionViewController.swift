//
//  ApprovalRegionViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 28/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ApprovalRegionViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    var searchType: Int = 99
    var customerStatus: Int = 99
    var menuId = Int()
    var statusPickerView = UIPickerView()
    var reportingPickerView = UIPickerView()
    @IBOutlet weak var statusTxtField: UITextField!
    @IBOutlet weak var reportingTxtField: UITextField!
    var statusArray :[String] = []
    var reportRegionArray :[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addPickerView()
        
        statusArray = ["Select Status","Approved","Applied"]
        reportRegionArray = ["Select Reporting Region","All Reporting Regions","My Direct Reporting Regions"]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addPickerView()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ApprovalRegionViewController.doneBtnAction))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.statusTxtField.inputView = statusPickerView
        self.statusTxtField.inputAccessoryView = doneToolbar
        self.reportingTxtField.inputView = reportingPickerView
        self.reportingTxtField.inputAccessoryView = doneToolbar
        self.statusPickerView.backgroundColor = UIColor.clear
        self.statusPickerView.frame.size.height = timePickerHeight
        self.reportingPickerView.backgroundColor = UIColor.clear
        self.reportingPickerView.frame.size.height = timePickerHeight
        self.statusPickerView.delegate = self
        self.statusPickerView.dataSource = self
        self.reportingPickerView.delegate = self
        self.reportingPickerView.dataSource = self
        
    }
    
    @objc func doneBtnAction()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func resignResponderForTxtField()
    {
        self.statusTxtField.resignFirstResponder()
        self.reportingTxtField.resignFirstResponder()
    }
    
    @IBAction func searchType(_ sender: UISegmentedControl)
    {
        searchType = sender.selectedSegmentIndex
        
    }
    func navigateToApprovalUser()
    {
        
        let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
        vc.menuId = MenuIDs.DoctorApproval.rawValue
        vc.searchRegionType = searchType
        vc.customerStatus = customerStatus
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        
        if(statusTxtField.text == EMPTY || customerStatus == 0)
        {
            showAlertView(message: "Please Select Status")
        }
        else if(reportingTxtField.text == EMPTY || searchType == -1)
        {
            showAlertView(message: "Please Select Reporting Region")
        }
        else
        {
            navigateToApprovalUser()
        }
        
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    //MARK: - Picker View Delgates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == statusPickerView)
        {
            return statusArray.count
        }
        else if(pickerView == reportingPickerView)
        {
            return reportRegionArray.count
        }
        else
        {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == statusPickerView)
        {
            return statusArray[row]
        }
        else if(pickerView == reportingPickerView)
        {
            return reportRegionArray[row]
        }
        else
        {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == statusPickerView)
        {
            self.statusTxtField.text = statusArray[row]
            self.customerStatus = row
        }
        else if(pickerView == reportingPickerView)
        {
            self.reportingTxtField.text = reportRegionArray[row]
            self.searchType = row-1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }
}
