//
//  LandingAlertsDetailViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LandingAlertsDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topLbl: UILabel!
    
    //MARK:- Variable
    var titleText: String = ""
    var doctorList :[CustomerMasterModel] = []
    var isAnniversary: Bool = false
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = titleText
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let dates = BL_Alerts.sharedInstance.getDates()
        //        self.topLbl.text = "From: \(convertDateIntoString(date:BL_Alerts.sharedInstance.getDates().0))    To: \(convertDateIntoString(date:BL_Alerts.sharedInstance.getDates().1))"
        self.topLbl.text = "\(appDoctorPlural.capitalizingFirstLetter()) \(titleText.lowercased()) between \(convertDateIntoString(date:dates.0)) and \(convertDateIntoString(date:dates.1))"
        addBackButtonView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    //MARK:- TableViewDataSource and Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.LandingAlertDetailCell, for: indexPath) as! LandingDetailTableViewCell
        let doctorData = self.doctorList[indexPath.row]
        cell.doctorName.text = doctorData.Customer_Name
        let strHospitalName = checkNullAndNilValueForString(stringData: doctorData.Hospital_Name!) as? String
        cell.doctorDetail.text = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName!, doctorData.MDL_Number!, doctorData.Speciality_Name!, doctorData.Category_Name!, doctorData.Region_Name!)
        let date: Date!
        
        if (isAnniversary)
        {
            date = doctorData.Anniversary_Date!
        }
        else
        {
            date = doctorData.DOB!
        }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let monthName = getMonthName(monthNumber: month)
        let day = calendar.component(.day, from: date)
        
        cell.dateLbl.text = monthName +  " " + String(day)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
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
}
