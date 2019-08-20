//
//  DeleteAccompanistViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DeleteAccompanistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    
    var accompanistList : [UserMasterModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getAccompanistList()
        addBackButtonView()
        self.navigationItem.title = "Remove Accomapanist data"
        self.tableView.estimatedRowHeight = 500
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return  1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var defaultHeight : CGFloat = 20
        let constraintWidth = SCREEN_WIDTH - 61
        let accompanistDetail = accompanistList[indexPath.row]
        let employeeName = accompanistDetail.Employee_name
        let username = accompanistDetail.User_Name as String
        let designation = accompanistDetail.User_Type_Name as String
        let regionName = accompanistDetail.Region_Name as String
        
        defaultHeight += getTextSize(text: employeeName, fontName: fontSemiBold, fontSize: 15, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text: "Username:\(username) | ", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text:  "Designation:\(designation) | \(regionName)", fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return accompanistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeleteAccompanistListCell, for: indexPath) as! UserListIndexTableViewCell
        
        let accompanistDetail = accompanistList[indexPath.row]
        let employeeName = accompanistDetail.Employee_name as String
        let username = accompanistDetail.User_Name as String
        let designation = accompanistDetail.User_Type_Name as String
        let regionName  = accompanistDetail.Region_Name as String
 
            cell.titleLbl.text = employeeName
            cell.detailLbl.text = "\(username) | \(designation)"
            cell.descriptionLbl.text = "Designation: \(designation) | \(regionName)"
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let accompanistDetail = accompanistList[indexPath.row]
        showAlertToRemove(accompanistObj: accompanistDetail, indexPath: indexPath.row)
    }
    
    func getAccompanistList()
    {
        accompanistList = BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedRegions()
        self.reloadTableView()
    }
    
    func showAlertToRemove(accompanistObj : UserMasterModel , indexPath : Int)
    {
        let alertViewController = UIAlertController(title: nil, message: "Do you want to delete data of \"\(accompanistObj.Employee_name!)(\(accompanistObj.Region_Name as String))\"?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeAccompanistDetails(accompanistObj: accompanistObj)
            self.accompanistList.remove(at: indexPath)
            self.reloadTableView()
            showToastView(toastText: "\(PEV_ACCOMPANIST) removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func reloadTableView()
    {
        if accompanistList.count > 0
        {
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateView.isHidden = false
        }
    }
    
    func removeAccompanistDetails(accompanistObj : UserMasterModel)
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.deleteAccompanistData(regionCode: accompanistObj.Region_Code, userCode: accompanistObj.User_Code)
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
