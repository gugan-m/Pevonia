//
//  TPRefreshViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPRefreshViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource
{

    //MARK:- Outlet 
    @IBOutlet weak var monthYearTextField: TextField!
    
    //MARK:- Variable
    var monthList:NSArray = []
    var pickerView = UIPickerView()
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.monthYearTextField.rightViewMode = UITextFieldViewMode.always
        self.monthYearTextField.rightView = UIImageView(image: UIImage(named: "arrow"))
        addPickerView()
        getMonthList()
        addTapGestureForView()
        monthYearTextField.text = monthList[2] as? String
        self.title = "\(PEV_TP) Refresh"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Adding PickerView
    private func addPickerView()
    {
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(TPRefreshViewController.pickerDoneBtnAction))
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        self.monthYearTextField.inputView = pickerView
        self.monthYearTextField.inputAccessoryView = doneToolbar
        self.pickerView.backgroundColor = UIColor.clear
        self.pickerView.frame.size.height = timePickerHeight
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    
    @objc func pickerDoneBtnAction()
    {
        self.resignResponderForTxtField()
    }
    
    //MARK: - Picker View Delgates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return monthList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return (monthList[row] as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.monthYearTextField.text = (monthList[row] as! String)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return SCREEN_WIDTH
    }

    //MARK:- TextField Delegate
    @objc func resignResponderForTxtField()
    {
        self.monthYearTextField.resignFirstResponder()
    }
    
    //MARK:- Array Function
    func getMonthList()
    {
        let dictionary = BL_TPCalendar.sharedInstance.getTPMonth()
        monthList = dictionary.value(forKey: "monthArray") as! NSArray
        self.pickerView.reloadAllComponents()
        pickerView.selectRow(2, inComponent: 0, animated: false)
    }
    
    //MARK:- TPRefresh WebServiceCall
    @IBAction func refreshTP(_ sender: Any)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                removeCustomActivityView()
                
                if apiResponseObj.list.count > 0
                {
                    self.showActivityIndicator()
                    let refreshDate = self.monthYearTextField.text!.components(separatedBy: " - ")
                    let resfreshMonth: Int = getMonthNumberFromMonthString(monthString: refreshDate[0])
                    
                    BL_TPRefresh.sharedInstance.refreshTourPlanner(month: resfreshMonth, year: Int(refreshDate[1])!){(status) in
                        removeCustomActivityView()
                        
                        if status == SERVER_SUCCESS_CODE
                        {
                            showToastView(toastText: " TP refreshed Successfully")
                        }
                        else
                        {
                            showToastView(toastText: "Unable to refresh TP details")
                        }
                    }
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
    
    //MARK:- Functions for updating views
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    func showActivityIndicator()
    {
        showCustomActivityIndicatorView(loadingText: "Refreshing TP Data")
    }
}
