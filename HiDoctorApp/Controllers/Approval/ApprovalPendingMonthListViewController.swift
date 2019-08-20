//
//  ApprovalPendingMonthListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalPendingMonthListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var emptyStateLblTxt : UILabel!
    
    var refreshControl: UIRefreshControl!
    var monthWiseList : NSArray = []
    var userObj :ApprovalUserMasterModel!
    var menuId : Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pullDownRefresh()
        self.setEmptyStateLbl(text: "")
        addBackButtonView()
        tableView.estimatedRowHeight = 100
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.title = "Pending for approval"
        self.headerLbl.text = userObj.Employee_Name + "(" + userObj.User_Type_Name + ")"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        startApiCall(type: 1)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    
    //MARK:- Private function
    
    private func startApiCall(type : Int)
    {
        if menuId == MenuIDs.TP_Approval.rawValue
        {
           getTpMonthWiseList(type: type)
        }
        else if menuId == MenuIDs.DCR_Approval.rawValue
        {
            getDCRMonthWiseList(type: type)
        }
    }
    
    private func getDCRMonthWiseList(type : Int)
    {
        if checkInternetConnectivity()
        {
            if type != 2
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
            }
            BL_Approval.sharedInstance.getDCRMonthWiseCount(userCode: checkNullAndNilValueForString(stringData: userObj.User_Code))
            {
                (apiResponseObj) in
                
                removeCustomActivityView()
                self.endRefresh()
                self.emptyStateLblTxt.text = "No \(PEV_DCR) data available for approval."
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    
                    self.checkIfIsListEmpty(list: apiResponseObj.list)
                    if type == 2
                    {
                        showToastView(toastText: "\(PEV_DCR) data refreshed successfully")
                    }
                }
                else
                {
                    if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
                    {
                        if type != 2
                        {
                            self.showEmptyStateView(show: true)
                            self.setEmptyStateLbl(text: "No Internet Connection")
                        }
                        else
                        {
                            showToastView(toastText: "No Internet Connection")
                        }
                    }
                    else
                    {
                        var emptyStateText : String = apiResponseObj.Message
                        self.showEmptyStateView(show: true)
                        
                        if emptyStateText == ""
                        {
                            emptyStateText = "Unable to fetch DCR approval data."
                        }
                        if type == 2
                        {
                            showToastView(toastText: emptyStateText)
                        }
                        else
                        {
                            self.setEmptyStateLbl(text: emptyStateText)
                        }
                    }
                    
                }
            }
        }
        else
        {
            if type == 2
            {
                endRefresh()
                showToastView(toastText: "No Internet Connection. Please try again.")
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        
    }
    
    private func getTpMonthWiseList(type : Int)
    {
        if checkInternetConnectivity()
        {
            if type != 2
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
            }
            BL_Approval.sharedInstance.getTpMonthWiseCount(userCode: checkNullAndNilValueForString(stringData: userObj.User_Code))
            {
                (apiResponseObj) in
                
                removeCustomActivityView()
                self.endRefresh()
                self.emptyStateLblTxt.text = "No \(PEV_TOUR_PLAN) data available for approval."
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    
                    self.checkIfIsListEmpty(list: apiResponseObj.list)
                    if type == 2
                    {
                        showToastView(toastText: "\(PEV_TP) data refreshed successfully")
                    }
                }
                else
                {
                    if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
                    {
                        if type != 2
                        {
                            self.showEmptyStateView(show: true)
                            self.setEmptyStateLbl(text: "No Internet Connection")
                        }
                        else
                        {
                            showToastView(toastText: "No Internet Connection")
                        }
                    }
                    else
                    {
                        var emptyStateText : String = apiResponseObj.Message
                        self.showEmptyStateView(show: true)
                        
                        if emptyStateText == ""
                        {
                            emptyStateText = "Unable to fetch \(PEV_TP) approval data."
                        }
                        if type == 2
                        {
                            showToastView(toastText: emptyStateText)
                        }
                        else
                        {
                            self.setEmptyStateLbl(text: emptyStateText)
                        }
                    }
                    
                }
            }
        }
        else
        {
            if type == 2
            {
                endRefresh()
                showToastView(toastText: "No Internet Connection. Please try again.")
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        
    }
    
    private func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(ApprovalPendingMonthListViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh()
    {
        self.startApiCall(type: 2)
    }
    
    private func checkIfIsListEmpty(list : NSArray)
    {
        if list.count > 0
        {
            monthWiseList = list
            self.tableView.reloadData()
            showEmptyStateView(show: false)
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    private func showEmptyStateView(show : Bool)
    {
       self.emptyStateView.isHidden = !show
       self.tableView.isHidden = show
    }
    
    private func setEmptyStateLbl(text : String)
    {
        self.emptyStateLblTxt.text = text
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
    
    private func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    //MARK:- Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return monthWiseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalPendingMonthListCell, for: indexPath) as! ApprovalMonthListTableViewCell
        
        let dict = monthWiseList[indexPath.row] as! NSDictionary
        
        var activityCount : Int = 0
        var month : Int = 0
        var year : String = ""
        

        if menuId == MenuIDs.TP_Approval.rawValue
        {
            month = (dict.object(forKey: "TP_Month") as? Int)!
            year  = (String(describing: dict.object(forKey: "TP_Year") as! Int)) as String
            if let count  = dict.object(forKey: "Count_Of_TP_Id") as? Int
            {
                
                activityCount = count
            }
            else
            {
                activityCount = 0
            }
        }
        else
        {
            month = (dict.object(forKey: "DCR_Month") as? Int)!
            year  = (String(describing: dict.object(forKey: "DCR_Year") as! Int)) as String
            if let count  = dict.object(forKey: "Count_Of_DCRId") as? Int
            {
                
                activityCount = count
            }
            else
            {
                activityCount = 0
            }
        }
        
        
        let monthName = BL_Approval.sharedInstance.getMonthNameByNumber(monthNumber: month)
        
        var monthCount : String = ""
        
        if activityCount > 99
        {
            monthCount = "99+"
        }
        else
        {
            monthCount = String(activityCount)
        }
        
        cell.monthNameLbl.text = "\(monthName) \(year)"
        cell.monthCountLbl.text = monthCount
        cell.monthCountLbl.layer.cornerRadius = 15
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if checkInternetConnectivity()
        {
            let dict = monthWiseList[indexPath.row] as! NSDictionary
            
            var month : String = ""
            var year : String = ""
            
            if menuId == MenuIDs.TP_Approval.rawValue
            {
             month = (String(describing : (dict.object(forKey: "TP_Month") as? Int)!) as String)
             year = (String(describing: dict.object(forKey: "TP_Year") as! Int)) as String
            }
            else
            {
                month = (String(describing : (dict.object(forKey: "DCR_Month") as? Int)!) as String)
                year = (String(describing: dict.object(forKey: "DCR_Year") as! Int)) as String
            }
            
            let date = "\(year)-\(month)-01"
            let endDate = BL_Approval.sharedInstance.getendDateOfMonth(month: month, year: year)
            userObj.Actual_Date = convertDateIntoDisplayFormat(date: getStringInFormatDate(dateString: date))
            userObj.Entered_Date = convertDateIntoDisplayFormat(date: endDate)
            let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: UnApprovalListVcID) as! UnApprovalViewController
            userObj.activityMonth = month
            userObj.activityYear = year
            
            vc.menuId = menuId
            vc.userList = userObj
            vc.isCmngFromApprovalPage = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    

    
}
