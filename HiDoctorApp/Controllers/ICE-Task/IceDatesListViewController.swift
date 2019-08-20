//
//  IceDatesListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 31/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceDatesListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myJointDates : UILabel!
    @IBOutlet weak var userJointWithMe : UILabel!
    @IBOutlet weak var emptyStatelabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var selectDateYears : UITextField!
    
    var selectedState = Int()
    var myJointDatesList = NSArray()
    var userJointWithMeList = NSArray()
    var userName = String()
    var userCode = String()
    var expiryDatePicker : MonthYearPickerView!
    var selectedMonth = Int()
    var fromDate = String()
    var toDate = String()
    var currentYear = Int()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       self.setDefaults()
        self.tableView.tableFooterView = UIView()
        
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        var month  = calendar.component(.month, from: currentDate)
        let day  = calendar.component(.day, from: currentDate)
        
        if(month < 10)
        {
            let monthValue = "0\(month)"
            month = Int(monthValue)!
        }
        
        currentYear = year
        selectedMonth = month
        fromDate = "\(year)-\(month)-1"
        toDate = "\(year)-\(month)-\(day)"
        self.selectDateYears.text = "\(month)/\(year)"
        getDateList(fromDate: fromDate, toDate: toDate)
        
        
        expiryDatePicker = MonthYearPickerView()
        
        
            expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
//                if(month < 10)
//                {
//                    let monthValue = "0\(month)"
//                    month = Int(monthValue)!
//                }
                self.fromDate = "\(year)-\(month)-1"
                let lastDay = self.lastDay(ofMonth: month, year: year)
                self.toDate = "\(year)-\(month)-\(lastDay)"
                self.selectDateYears.text = "\(month)/\(year)"
            
        }
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceDatesListViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceDatesListViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        
        selectDateYears.inputAccessoryView = doneToolbar
        selectDateYears.inputView = expiryDatePicker

        // Do any additional setup after loading the view.
    }

 
    

    @IBAction func myJointDatesBut (_ sender: UIButton)
    {
        myJointDates.textColor = UIColor.blue
        userJointWithMe.textColor = UIColor.gray
        selectedState = 0
        if(myJointDatesList.count > 0)
        {
            self.emptyStatelabel.text = ""
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        else
        {
            self.emptyStatelabel.text = "No Working Dates"
            self.tableView.isHidden = true
        }
        
    }
    
    @IBAction func userJointWithMe (_ sender: UIButton)
    {
        myJointDates.textColor = UIColor.gray
        userJointWithMe.textColor = UIColor.blue
        selectedState = 1
        
        if(userJointWithMeList.count > 0)
        {
            self.emptyStatelabel.text = ""
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
        else
        {
            self.emptyStatelabel.text = "No Working Dates"
            self.tableView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedState == 0)
        {
            return myJointDatesList.count
        }
        else
        {
            return userJointWithMeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DateCell") as! UITableViewCell
        let dateLbl =  cell.viewWithTag(1) as! UILabel
        
        if(selectedState == 0)
        {
            let myObj = myJointDatesList[indexPath.row] as! NSDictionary
            let dateToValue = convertDateIntoString(dateString: (myObj.value(forKey: "Jointdates") as? String)!)
            let appFormatModifiyFromDate = convertDateIntoString(date: dateToValue)
            dateLbl.text = appFormatModifiyFromDate
            
        }
        else
        {
            let myObj = userJointWithMeList[indexPath.row] as! NSDictionary
            let dateToValue = convertDateIntoString(dateString: (myObj.value(forKey: "Jointdates") as? String)!)
            let appFormatModifiyFromDate = convertDateIntoString(date: dateToValue)
            dateLbl.text = appFormatModifiyFromDate
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myObj = myJointDatesList[indexPath.row] as! NSDictionary
        let dateToValue = convertDateIntoString(dateString: (myObj.value(forKey: "Jointdates") as? String)!)
        let appFormatModifiyFromDate = convertDateIntoString(date: dateToValue)
        if(selectedState == 0)
        {
            BL_ICE_Task.sharedInstance.selectedDate = (myObj.value(forKey: "Jointdates") as? String)!
                //appFormatModifiyFromDate
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    func setDefaults()
    {
        myJointDates.textColor = UIColor.black
        userJointWithMe.textColor = UIColor.gray
        myJointDates.layer.cornerRadius = 5
        myJointDates.layer.masksToBounds = true
        myJointDates.layer.borderColor = UIColor.gray.cgColor
        myJointDates.layer.borderWidth = 0.7
        myJointDates.text = "My Working Date(s) with \(userName)"
        userJointWithMe.text = "\(userName) Working Date(s) with me"
        
        userJointWithMe.layer.cornerRadius = 5
        userJointWithMe.layer.masksToBounds = true
        userJointWithMe.layer.borderColor = UIColor.gray.cgColor
        userJointWithMe.layer.borderWidth = 0.7
    }
    
    func getDateList(fromDate:String,toDate: String)
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getICEDate(userName: userName, userCode: userCode, fromDate: fromDate, toDate: toDate) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        let getDateList = apiObj.list[0] as! NSDictionary
                        self.myJointDatesList = getDateList.value(forKey: "lstParentDates") as! NSArray
                        self.userJointWithMeList = getDateList.value(forKey: "lstChildDates") as! NSArray
                        self.emptyStatelabel.text = ""
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                    else
                    {
                        self.emptyStatelabel.text = "No Working Dates"
                        self.tableView.isHidden = true
                    }
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)

                    
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }
    
    @objc func fromPickerDoneAction()
    {
        self.getDateList(fromDate: self.fromDate, toDate: self.toDate)
        resignResponderForTextField()
    }
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    @objc func resignResponderForTextField()
    {
        self.selectDateYears.resignFirstResponder()
    }
}
