//
//  ApprovalViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/22/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ApprovalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var approvalMenu : [MenuMasterModel] = []
    var sectionMenu = [String]()
    var contentMenuObj = NSMutableArray()
    var contentMenuList = NSMutableArray()
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if checkInternetConnectivity()
        {
            approvalMenu = BL_MenuAccess.sharedInstance.getApprovalMenus()
            self.navigationItem.title = "Approval"
        }
        
        addBackButtonView()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if checkInternetConnectivity()
        {
            for menuListId in approvalMenu
            {
                approvalCountApiCall(menuId: menuListId.Menu_Id, navigate: false)
            }
            self.contentMenuSeperate()
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func contentMenuSeperate()
    {
        for menuList in approvalMenu
        {
            if !sectionMenu.contains(menuList.Section_Name)
            {
                sectionMenu.append(menuList.Section_Name)
            }
        }
        
        for section in sectionMenu
        {
            for contentList in approvalMenu
            {
                let sectionName = contentList.Section_Name
                if section == sectionName
                {
                    contentMenuObj.add(contentList)
                }
            }
                contentMenuList.add(contentMenuObj)
                contentMenuObj = NSMutableArray()
        }
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func approvalCountApiCall(menuId: Int, navigate: Bool)
    {
        switch menuId
        {
        case MenuIDs.DCR_Approval.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.DCRApiCall(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        
//
//            if checkToShowApprovalSection()
//            {
//                moreHeaderObj = MoreListHeaderModel()
//                moreDescObj = MoreListDescriptionModel()
//                dataList = []
//                moreHeaderObj.sectionTitle = "Approval"
//
//                moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.ReportsSb
//                moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.ReportsUserListVcID
//                moreDescObj.icon = "icon-reject"
//                moreDescObj.descriptionTxt = "Reject"
//                dataList.append(moreDescObj)
//                moreHeaderObj.dataList = dataList
//                list.append(moreHeaderObj)
//            }
            
        case MenuIDs.Approval.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ReportsUserListVcID) as! ReportsUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.DCRApiCall(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }


            
        case MenuIDs.TP_Approval.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.TPApprovalApiCall(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        case MenuIDs.DCR_Leave_Approval.rawValue:
            if navigate
            {
//                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
//                vc.menuId = menuId
                let sb = UIStoryboard(name:commonListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = UserListScreenName.LeaveAccompanistList.rawValue
                vc.navigationTitle = "Choose User"
                vc.isCustomerMasterEdit = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.DCRLeaveApprovalApi(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        case MenuIDs.DCR_Lock_Release.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.DCRLockReleaseApi(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        case MenuIDs.DoctorApproval.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalRegionListVcID) as! ApprovalRegionViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case MenuIDs.ExpenseApproval.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ExpenseApprovalViewControllerID) as! ExpenseApprovalViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case MenuIDs.DCR_ActivityLock_Release.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                if checkInternetConnectivity()
                {
                    BL_MenuAccess.sharedInstance.DCRActivityLockReleaseApi(menuId: menuId)
                    { (apiResponseObject) in
                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                        {
                            self.addCountForMenu(menuId: menuId, count: apiResponseObject.Count)
                        }
                    }
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        case MenuIDs.TP_Freeze_Lock.rawValue:
            if navigate
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ApprovalUserListVcID) as! ApprovalUserListViewController
                vc.menuId = menuId
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            break
            
        }
    }
    
    func addCountForMenu(menuId: Int, count:Int){
        print(count)
        
        for menuList in approvalMenu
        {
            if menuList.Menu_Id == menuId
            {
                menuList.Count = count
            }
        }
        contentMenuObj = []
        contentMenuList = []
        self.contentMenuSeperate()
        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentMenuList.object(at: section) as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let appCell = tableView.dequeueReusableCell(withIdentifier: ApprovalCell, for: indexPath) as! ApprovalTableViewCell
        let appDict = ((contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row)) as! MenuMasterModel
        appCell.approvalTitleLbl.text = appDict.Menu_Name! as String
        
        if appDict.Count == -1
        {
            appCell.approvalCountLbl.isHidden = true
            appCell.rightArrowImg.isHidden = true
            appCell.approvalActivity.startAnimating()
        }
        else if appDict.Count == -99
        {
            appCell.approvalCountLbl.isHidden = true
            appCell.rightArrowImg.isHidden = false
            appCell.approvalActivity.isHidden=true
        }
        else
        {
            appCell.approvalCountLbl.isHidden = false
            appCell.rightArrowImg.isHidden = false
            appCell.approvalActivity.stopAnimating()
            appCell.approvalActivity.isHidden=true;
            
            if appDict.Count > 99
            {
                appCell.approvalCountLbl.text = "99+"
            }
            else
            {
            appCell.approvalCountLbl.text = String(appDict.Count)
            }
        }
        if(indexPath.section == 2)
        {
           
                appCell.approvalCountLbl.isHidden = true
                appCell.rightArrowImg.isHidden = false
                appCell.approvalActivity.isHidden=true
                appCell.imgView.image = UIImage(named:"icon-doctor")
          
        }
        else if(indexPath.section == 3)
        {
            appCell.approvalCountLbl.isHidden = true
            appCell.rightArrowImg.isHidden = false
            appCell.approvalActivity.isHidden=true
            appCell.imgView.image = UIImage(named:"icon-doctor")
        }
        appCell.approvalCountLbl.layer.masksToBounds = true
        appCell.approvalCountLbl.layer.cornerRadius = (appCell.approvalCountLbl.frame.width)/2
        
        return appCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: ApprovalSectionCell) as! ApprovalSectionTableViewCell
        sectionCell.sectionTitleLbl.text = sectionMenu[section] as String
        sectionCell.sectionContentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        //sectionCell.sectionTitleLbl.backgroundColor = UIColor.lightGray
        return sectionCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath)
        let dictObj = ((contentMenuList.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row)) as! MenuMasterModel
        selectedCell?.contentView.backgroundColor = UIColor.white
        
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                removeCustomActivityView()
                
                if apiResponseObj.list.count > 0
                {
                    self.navigateFunc(list: dictObj)
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
    
    func navigateFunc(list: MenuMasterModel)
    {
        approvalCountApiCall(menuId: list.Menu_Id as Int, navigate: true)
    }
}
