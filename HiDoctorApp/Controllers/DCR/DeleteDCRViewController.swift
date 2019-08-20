//
//  DeleteDCRViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 16/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DeleteDCRViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    
    var dcrList : [DCRHeaderModel] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 500
        self.title = "Delete DCR"
        addCustomBackButtonToNavigationBar()
        addFilterButtonToNavigationBar()
        
        if DCRModel.sharedInstance.deleteDCRFilterList != nil && DCRModel.sharedInstance.deleteDCRFilterList.count > 0
        {
            DCRModel.sharedInstance.deleteDCRFilterList = []
        }
        
        DCRModel.sharedInstance.deleteDCRFilterList = ["\(DCRStatus.unApproved.rawValue)", "\(DCRStatus.applied.rawValue)", "\(DCRStatus.approved.rawValue)", "\(DCRStatus.drafted.rawValue)"]
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDeleteDCRList()
        
        tableView.reloadData()
    }
    
    func setDeleteDCRList()
    {
        dcrList = BL_DeleteDCR.sharedInstance.getDCRHeaderForDeleteDCR(filterArr: DCRModel.sharedInstance.deleteDCRFilterList)
        if dcrList.count > 0
        {
            self.tableView.reloadData()
            showEmptyStateView(show: false)
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dcrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DeleteDCRListCell, for: indexPath) as! DeleteDCRTableViewCell
        
        let obj = dcrList[indexPath.row]
        
        cell.dcrDateLbl.text = convertDateIntoString(date: obj.DCR_Actual_Date)
        cell.dcrTypeLbl.text =  getDCRActivityName(dcrFlag : obj.Flag)
        cell.dcrStatusLbl.text = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: String(obj.DCR_Status))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let deleteObj = dcrList[indexPath.row]
        deleteSelectedDCR(obj: deleteObj)
    }
    
    func deleteSelectedDCR(obj : DCRHeaderModel)
    {
        let alertMessage = "This action will delete this DCR \(convertDateIntoString(date: obj.DCR_Actual_Date)) - \(getDCRActivityName(dcrFlag : obj.Flag)) permanently. Do you want to continue?"
        
        let alertViewController = UIAlertController(title: infoTitle, message:alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "DELETE", style: UIAlertActionStyle.default, handler: { alertAction in
            self.checkUserAutenticate(deleteObj: obj)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
       
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func checkUserAutenticate(deleteObj :DCRHeaderModel)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                
                removeCustomActivityView()
                
                if apiResponseObj.list.count > 0
                {
                    self.checkDCRExist(obj: deleteObj)
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
    
    func checkDCRExist(obj : DCRHeaderModel)
    {
        if checkInternetConnectivity()
        {
            BL_DeleteDCR.sharedInstance.checkDCRExist(dcrDate: convertDateIntoServerStringFormat(date: obj.DCR_Actual_Date), flag: obj.Flag)
            {  (apiResponseObj) in
                
                if apiResponseObj.Status == 1 && apiResponseObj.Count == 0
                {
                    BL_DeleteDCR.sharedInstance.deleteDCR(dcrHeaderObj: obj)
                    showToastView(toastText: "Selected DCR has been deleted successfully")
                    DBHelper.sharedInstance.deleteFromTable(tableName: Hourly_Report_Visit)
                    DBHelper.sharedInstance.deleteLeaveAttachmentDCR(dcrDate: convertDateIntoServerStringFormat(date: obj.DCR_Actual_Date))
                    self.setDeleteDCRList()
                }
                else
                {
                    self.showResponseErrorMessage(message: apiResponseObj.Message)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func showResponseErrorMessage(message : String)
    {
        let alertMessage : String  =  "You cannot delete processed DCR. So please request you to contact HO to delete the same.\n\n Click 'Ok' to exit."
        
        AlertView.showAlertView(title: alertTitle, message: alertMessage, viewController: self)
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
    
    private func addFilterButtonToNavigationBar()
    {
        let filterButton = UIButton(type: UIButtonType.custom)
        
        filterButton.addTarget(self, action: #selector(self.filterButtonClicked), for: UIControlEvents.touchUpInside)
        filterButton.setImage(UIImage(named: "icon-filter"), for: .normal)
        filterButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func filterButtonClicked()
    {
        let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: deleteDCRFilterVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
    }

}
