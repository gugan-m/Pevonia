//
//  LockReleaseHistoryViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LockReleaseHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    
    var lockHistoryList: NSArray = []
    var approvalUserObj: ApprovalUserMasterModel!
    var isFromDCRActivityLock: Bool = false
    var isFromTPFreezeLock:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        doInitialSetup()
        getLockHistoryData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    //MARK:- Private Functions
    
    //MARK:-- Web Service Functions
    private func getLockHistoryData()
    {
        if isFromDCRActivityLock
        {
            if (checkInternetConnectivity())
            {
                showLoader()
                
                WebServiceHelper.sharedInstance.getDCRLockActivityHistory(userCode: approvalUserObj.User_Code, completion: { (apiResponseObj) in
                    self.hideLoader()
                    self.getLockHistoryDataCallBack(apiResponseObj: apiResponseObj)
                })
            }
            else
            {
                showEmptyStateView()
            }
        }
        else
        {
            if (checkInternetConnectivity())
            {
                showLoader()
                
                WebServiceHelper.sharedInstance.getDCRLockHistory(userCode: approvalUserObj.User_Code, regionCode: approvalUserObj.Region_Code, pageNo: 1, completion: { (apiResponseObj) in
                    self.hideLoader()
                    self.getLockHistoryDataCallBack(apiResponseObj: apiResponseObj)
                })
            }
            else
            {
                showEmptyStateView()
            }
        }
    }
    
    private func getLockHistoryDataCallBack(apiResponseObj: ApiResponseModel)
    {
        lockHistoryList = []
        
        if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
        {
            lockHistoryList = apiResponseObj.list
            if(lockHistoryList.count > 0)
            {
            reloadTableView()
            setUserName(name: approvalUserObj.Employee_Name)
            showMainView()
            }
            else
            {
                setEmptyStateTitle(message: "No Lock History found")
            }
        }
        else
        {
            showEmptyStateView()
        }
    }
    
    //MARK:-- Show Hide Functions
    private func showLoader()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading data. Please wait...")
    }
    
    private func hideLoader()
    {
        removeCustomActivityView()
    }
    
    private func showMainView()
    {
        emptyStateView.isHidden = true
        mainView.isHidden = false
    }
    
    private func showEmptyStateView()
    {
        setEmptyStateTitle(message: "Unable to connect internet")
        emptyStateView.isHidden = false
        mainView.isHidden = true
    }
    
    private func doInitialSetup()
    {
        addBackButtonView()
        setPageTitle()
        setEmptyStateTitle(message: EMPTY)
        setUserName(name: EMPTY)
    }
    
    //MARK:-- Label Title Functions
    private func setEmptyStateTitle(message: String)
    {
        emptyStateTitleLabel.text = message
    }
    
    private func setUserName(name: String)
    {
        userNameLabel.text = name
    }
    
    //MARK:-- Nav Bar Button Functions
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//        
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        
//        self.navigationItem.leftBarButtonItem = backButtonItem
//    }
//    
//    @objc func backButtonAction()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }
    
    private func setPageTitle()
    {
        self.title = "Lock History"
    }
    
    //MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return lockHistoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockHistoryCell") as! LockReleaseHistoryTableViewCell
        let dict = lockHistoryList.object(at: indexPath.row) as! NSDictionary
        var lockedDate: String = "N/A"
        var releasedDate: String = "N/A"
        var actualDate: String = "N/A"
        var releaseRequest: String = "N/A"
        var reason: String = "N/A"
        
        cell.releasedByValueLabel.text = (dict.value(forKey: "Released_By") as! String)
        
        if checkNullAndNilValueForString(stringData: dict.value(forKey: "Locked_Date") as? String) != EMPTY
        {
            lockedDate = convertDateIntoString(date: convertDateIntoString(dateString: dict.value(forKey: "Locked_Date") as! String))
        }
        
        if checkNullAndNilValueForString(stringData: dict.value(forKey: "Released_Date") as? String) != EMPTY
        {
            releasedDate = convertDateIntoString(date: convertDateIntoString(dateString: dict.value(forKey: "Released_Date") as! String))
        }
        
        if checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Actual_Date") as? String) != EMPTY
        {
            actualDate = convertDateIntoString(date: convertDateIntoString(dateString: dict.value(forKey: "DCR_Actual_Date") as! String))
        }
        
        if checkNullAndNilValueForString(stringData: dict.value(forKey: "Request_Released_By") as? String) != EMPTY
        {
           releaseRequest = checkNullAndNilValueForString(stringData: dict.value(forKey: "Request_Released_By") as? String)
        }
        
        if checkNullAndNilValueForString(stringData: dict.value(forKey: "Released_Reason") as? String) != EMPTY
        {
           reason = checkNullAndNilValueForString(stringData: dict.value(forKey: "Released_Reason") as? String)
        }
        
        
        
        cell.lockedDateValueLabel.text = lockedDate
        cell.releasedDateValueLabel.text = releasedDate
        cell.actualDateValueLabel.text = actualDate
        cell.lockTypeValueLabel.text = (dict.value(forKey: "Lock_Type") as! String).replacingOccurrences(of: "_", with: " ")
        cell.requestReleaseBy.text = releaseRequest
        cell.reason.text = reason
        
        cell.selectionStyle = .none
        
        return cell
    }
}
