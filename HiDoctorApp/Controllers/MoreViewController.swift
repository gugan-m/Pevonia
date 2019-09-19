//
//  MoreViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/21/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var moreList : [MoreListHeaderModel] = []
    let markDoctorLocation: String = PEV_MARK_DOCTOR_LOCATION
    let doctorComplaint :  String = "\(appDoctor) Complaints"
    let customerMasterEdit: String = "\(appDoctor) Master"
    let inwaerAcckow: String = "Inward Acknowledgement"
    let doctorProductMapping: String = PEV_DOCTOR_PRODUCT_MAPPING
    let iceTask = "ICE/Task"
    
    var strToken : String!
    var obj : MenuMasterModel?
    var Index = 0
    
    var arrEncrytedValue: NSArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addBackButtonView()
        self.navigationItem.title = "More"
        moreList = getMoreDataList()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMoreDataList() -> [MoreListHeaderModel]
    {
        var moreHeaderObj : MoreListHeaderModel = MoreListHeaderModel()
        var moreDescObj : MoreListDescriptionModel = MoreListDescriptionModel()
        var dataList : [MoreListDescriptionModel] = []
        var list : [MoreListHeaderModel] = []
        
        //1
//        if checkToShowTpSection()
//        {
//            moreHeaderObj.sectionTitle = "Activity"
//            
//            moreDescObj.stoaryBoardName = ""
//            moreDescObj.viewControllerIdentifier = ""
//            moreDescObj.icon = "icon-stepper-cycle"
//            moreDescObj.descriptionTxt = "Tour Planner"
//            dataList.append(moreDescObj)
//            moreHeaderObj.dataList = dataList
//            list.append(moreHeaderObj)
//        }
        //2
        if checkToShowApprovalSection()
        {
            moreHeaderObj = MoreListHeaderModel()
            moreDescObj = MoreListDescriptionModel()
            dataList = []
            moreHeaderObj.sectionTitle = "Approval"

            moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.ReportsSb
            moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.ReportsUserListVcID
            moreDescObj.icon = "icon-reject"
            moreDescObj.descriptionTxt = "Reject"
            dataList.append(moreDescObj)
            moreHeaderObj.dataList = dataList
            list.append(moreHeaderObj)
        }
        
        
        let displayedList = LandingDataManager.sharedManager.displayedArrayList
        
        let filteredArray = displayedList.filter {
            return $0.titleId == 4
        }
        
        if filteredArray.count == 0
        {
            moreHeaderObj = MoreListHeaderModel()
            moreDescObj = MoreListDescriptionModel()
            dataList = []
            moreHeaderObj.sectionTitle = "Reports"
            moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.ReportsSb
            moreDescObj.viewControllerIdentifier =  Constants.ViewControllerNames.ReportsVcID
            moreDescObj.icon = "icon-more-report"
            moreDescObj.descriptionTxt = "Reports"
            dataList.append(moreDescObj)
            moreHeaderObj.dataList = dataList
            list.append(moreHeaderObj)
            
        }
        
        moreHeaderObj = MoreListHeaderModel()
        dataList = []
        
        if (BL_MenuAccess.sharedInstance.isCustomerMasterScreenAvailable())
        {
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Partner"
            moreDescObj.icon = "icon-doctor"
            moreDescObj.descriptionTxt = customerMasterEdit
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.SplitViewVCID
            dataList.append(moreDescObj)
        }
        
        
        if(BL_MenuAccess.sharedInstance.isDPMAvailable())
        {
            moreHeaderObj = MoreListHeaderModel()
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Partner"
            
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = "DPM"
            moreDescObj.icon = "icon-Product"
            moreDescObj.descriptionTxt = doctorProductMapping
            dataList.append(moreDescObj)
        }
        
        if (BL_Geo_Location.sharedInstance.isGeoLocationMandatoryPrivEnabled() && BL_Geo_Location.sharedInstance.doesUserHasLocationEditPermission())
        {
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Partner"
            moreDescObj.icon = "icon-location"
            moreDescObj.descriptionTxt = markDoctorLocation
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.SplitViewVCID
            dataList.append(moreDescObj)
        }
        
        if (BL_MenuAccess.sharedInstance.isCustomerComplaintAvailable())
        {
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Partner"
            moreDescObj.icon = "icon-doctor"
            moreDescObj.descriptionTxt = doctorComplaint
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.ComplaintViewControllerID
            dataList.append(moreDescObj)
        }
        
        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        
        
        
        //3
        moreHeaderObj = MoreListHeaderModel()
        moreDescObj = MoreListDescriptionModel()
        dataList = []
        moreHeaderObj.sectionTitle = "Data"
        
        moreDescObj.stoaryBoardName = prepareMyDeviceSb
        moreDescObj.viewControllerIdentifier = masterDataVcID
        moreDescObj.icon = "icon-master-cloud"
        moreDescObj.descriptionTxt = "Master data download"
        dataList.append(moreDescObj)
      
        
        if(BL_MenuAccess.sharedInstance.isInwardAcknowledgementNeededPrivEnable())
        {
            moreHeaderObj = MoreListHeaderModel()
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Data"
        
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = InwardAccknowledgementID
            moreDescObj.icon = "ic_inward"
            moreDescObj.descriptionTxt = inwaerAcckow
            dataList.append(moreDescObj)
        }
        
        
        if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
        {
            //4
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Data"
            moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.AssetsListSb
            moreDescObj.viewControllerIdentifier = AssetParentVCID
            moreDescObj.icon = "icon-asset-active"
            moreDescObj.descriptionTxt = PEV_DIGITAL_ASSETS
            dataList.append(moreDescObj)
        }
        
        if checkToShowManageAccompanist()
        {
            moreDescObj = MoreListDescriptionModel()
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = UserIndexListVcID
            moreDescObj.icon = "icon-two-user"
            moreDescObj.descriptionTxt = "Manage \(PEV_ACCOMPANIST) data"
            dataList.append(moreDescObj)
        }
        
        if BL_MenuAccess.sharedInstance.isMyDocumentAvailable()
        {
            moreDescObj = MoreListDescriptionModel()
            moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.NoticeBoardSb
            moreDescObj.viewControllerIdentifier = "MyDocument"
            moreDescObj.icon = "icon-two-user"
            moreDescObj.descriptionTxt = "My Documents"
            dataList.append(moreDescObj)
        }
        
        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        moreHeaderObj = MoreListHeaderModel()
        dataList = []
        
        if(BL_MenuAccess.sharedInstance.isInChamberEffectivenssAvailable() || BL_MenuAccess.sharedInstance.isTaskAvailabel())
        {
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "KRA"
            moreDescObj.icon = "icon-task"
            moreDescObj.descriptionTxt = iceTask
            moreDescObj.stoaryBoardName = commonListSb
            moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.HourlyReportDoctorListVcID
            dataList.append(moreDescObj)
        }
        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        moreHeaderObj = MoreListHeaderModel()
        dataList = []
        
        //miscellaneous
        if BL_MenuAccess.sharedInstance.isKennectAvailable()
        {
            moreDescObj = MoreListDescriptionModel()
            moreHeaderObj.sectionTitle = "Miscellaneous"
            moreDescObj.stoaryBoardName = "ERROR_LOG"
            moreDescObj.viewControllerIdentifier = "Kennect"
            moreDescObj.icon = "icon_kennect"
            moreDescObj.descriptionTxt = "Money Tree"
            dataList.append(moreDescObj)
        }
        
//        moreHeaderObj.dataList = dataList
//        list.append(moreHeaderObj)
//        moreHeaderObj = MoreListHeaderModel()
//        dataList = []
        
        if BL_MenuAccess.sharedInstance.isResonsive()
        {
         //  obj = DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
            var strDetails = DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
            
            if strDetails != nil
            {
                
//                let morelist : MoreListDescriptionModel = (MoreListDescriptionModel() as AnyObject) as! MoreListDescriptionModel
                
           //     for obj2 in (morelist as! [[AnyObject]])
//                let objDetails = DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
                
                
                for i in 0..<strDetails.count
                {
                    
                    moreDescObj = MoreListDescriptionModel()
                    moreHeaderObj.sectionTitle = "Miscellaneous"
                    moreDescObj.stoaryBoardName = "ERROR_LOG"
                    moreDescObj.icon = "icon-task"
                    moreDescObj.viewControllerIdentifier = "Responsive"
                    moreDescObj.descriptionTxt = strDetails[i].Menu_Name
//                moreDescObj = MoreListDescriptionModel()
//                moreHeaderObj.sectionTitle = "Miscellaneous"
//                moreDescObj.stoaryBoardName = "ERROR_LOG"
//                moreDescObj.icon = "icon-task"
//                moreDescObj.viewControllerIdentifier = "Responsive"
//                moreDescObj.descriptionTxt = (self.obj?.Menu_Name)!
                    dataList.append(moreDescObj)
                }
//                var menuList: [MoreListHeaderModel] = []
//
//                for obj1 in menuList
//                {
//                 //moreDescObj.descriptionTxt = (self.obj?.Menu_Name)!
//
//
//
//                    obj1.dataList[0].descriptionTxt  = (self.obj?.Menu_Name)!
//                    obj1.sectionTitle = "Miscellaneous"
//                    obj1.dataList[0].stoaryBoardName = "ERROR_LOG"
//                    obj1.dataList[0].icon = "icon-task"
//                    obj1.dataList[0].viewControllerIdentifier = "Responsive"
//                    dataList.append(obj1.dataList[0])
//                }
//
            //  dataList.append(moreDescObj)

            }

            
            
            
            
            
        }
        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        moreHeaderObj = MoreListHeaderModel()
        dataList = []

        
        moreHeaderObj = MoreListHeaderModel()
        moreDescObj = MoreListDescriptionModel()
        dataList = []
        moreHeaderObj.sectionTitle = "Messaging"
        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.NoticeBoardSb
        moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.NoticeBoardVCID
        
        moreDescObj.icon = "ic_notice-board@1,5x.png"
        moreDescObj.descriptionTxt = "Notice Board"
        dataList.append(moreDescObj)
        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = Constants.StoaryBoardNames.MessageSb
        moreDescObj.viewControllerIdentifier = Constants.ViewControllerNames.MessageVCID
        
        moreDescObj.icon = "icon-message"
        moreDescObj.descriptionTxt = "Message"
        dataList.append(moreDescObj)
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        
//        //6
//        
//        moreHeaderObj = MoreListHeaderModel()
//        moreDescObj = MoreListDescriptionModel()
//        dataList = []
//        moreHeaderObj.sectionTitle = "Settings"
//        
//        moreDescObj.stoaryBoardName = MoreViewMasterSb
//        moreDescObj.viewControllerIdentifier = ChangePasswordVcID
//        moreDescObj.icon = "icon-key"
//        moreDescObj.descriptionTxt = "Change password"
//        dataList.append(moreDescObj)
//        moreHeaderObj.dataList = dataList
//        list.append(moreHeaderObj)

        //6
        
        moreHeaderObj = MoreListHeaderModel()
        moreDescObj = MoreListDescriptionModel()
        dataList = []
        moreHeaderObj.sectionTitle = "Help & Others"
        
        moreDescObj.stoaryBoardName = MoreViewMasterSb
        moreDescObj.viewControllerIdentifier = "SendIssuesVC"
        moreDescObj.icon = "icon-mail"
        moreDescObj.descriptionTxt = PEV_SEND_YOUR_ISSUES_TO_SUPPORT
        dataList.append(moreDescObj)
        

        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = "HELP"
        moreDescObj.viewControllerIdentifier = ""
        moreDescObj.icon = "icon-help"
        moreDescObj.descriptionTxt = "Help"
        dataList.append(moreDescObj)
        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = MoreViewMasterSb
        moreDescObj.viewControllerIdentifier = AboutUsVcID
        moreDescObj.icon = "icon-info"
        moreDescObj.descriptionTxt = "About us"
        dataList.append(moreDescObj)
        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = "ERROR_LOG"
        moreDescObj.viewControllerIdentifier = "ERROR_LOG"
        moreDescObj.icon = "ic_alert"
        moreDescObj.descriptionTxt = "Upload Error"
        dataList.append(moreDescObj)
        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)
        
        moreHeaderObj = MoreListHeaderModel()
        moreDescObj = MoreListDescriptionModel()
        dataList = []
        moreHeaderObj.sectionTitle = "Settings"
        
        moreDescObj.stoaryBoardName = MoreViewMasterSb
        moreDescObj.viewControllerIdentifier = ChangePasswordVcID
        moreDescObj.icon = "icon-key"
        moreDescObj.descriptionTxt = "Change password"
        dataList.append(moreDescObj)
        
        moreDescObj = MoreListDescriptionModel()
        moreDescObj.stoaryBoardName = MoreViewMasterSb
        moreDescObj.viewControllerIdentifier = LogoutVcID
        moreDescObj.icon = "icon_logout"
        moreDescObj.descriptionTxt = "Logout"
        dataList.append(moreDescObj)

        
        moreHeaderObj.dataList = dataList
        list.append(moreHeaderObj)

        list = checkForExistingMenuList(list: list)
        return list
    }
    
    func checkToShowTpSection() -> Bool
    {
        var show : Bool = false
        let approvalMenuList = BL_MenuAccess.sharedInstance.getApprovalMenus()
        
        if approvalMenuList.count > 0
        {
            show = true
        }
        return show
    }
    
    func checkToShowApprovalSection() -> Bool
    {
        var show : Bool = false
        
        if BL_DCRReject.sharedInstance.checkIsRejectPrevilegeEnabled()
        {
            show = true
        }
        return  show
    }
    
    func checkToShowManageAccompanist() -> Bool
    {
        var show : Bool = false
        
        if BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData()
        {
            show = true
        }
        return  show
    }
    
    func checkForExistingMenuList( list : [MoreListHeaderModel]) -> [MoreListHeaderModel]{
        
        let displayedList = LandingDataManager.sharedManager.displayedArrayList
        
        var displayedMenuList = [String]()
        
        for menu in displayedList{
           let title =  menu.title.replacingOccurrences(of: " ", with: "")
            displayedMenuList.append(title.lowercased())
        }
        
        var modifiedList = [MoreListHeaderModel]()
        for header in list{
            
            let newHeader = MoreListHeaderModel()
            let dataList = header.dataList
            var newDataList = [MoreListDescriptionModel]()

            for data in dataList
            {
                var desc = data.descriptionTxt
                desc =  data.descriptionTxt.replacingOccurrences(of: " ", with: "")
                
                if !displayedMenuList.contains(desc.lowercased())
                {
                   newDataList.append(data)
                }
            }
            
            if newDataList.count > 0
            {
                newHeader.dataList = newDataList
                newHeader.sectionTitle = header.sectionTitle
                modifiedList.append(newHeader)
            }
            
        }
        return modifiedList
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return moreList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return moreList[section].dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreContentCell, for: indexPath) as! MoreContentTableViewCell
        
        let obj = moreList[indexPath.section].dataList[indexPath.row]
        
        let cellName = obj.descriptionTxt
        let cellIcon = obj.icon
        
        cell.contentIconImg.image = UIImage(named: cellIcon)
        cell.ContentTxtLbl.text = cellName
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.ErrorIconImageView.isHidden = true
        cell.ErrorIconImageView.image = nil
        
        if (obj.viewControllerIdentifier == "ERROR_LOG")
        {
            let count = BL_Error_Log.sharedInstance.getErrorLogCount()
            
            if (count > 0)
            {
                cell.contentIconImg.image = UIImage(named: "ic_alert_red")
                cell.ErrorIconImageView.image = UIImage(named: "icon_cloud_upload")
                cell.ErrorIconImageView.isHidden = false
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: MoreSectionCell) as! MoreSectionTableViewCell
        let obj =  moreList[section]
        
        sectionCell.sectionTitleLbl.text = obj.sectionTitle
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
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.contentView.backgroundColor = UIColor.white
        
        let obj = moreList[indexPath.section].dataList[indexPath.row]
        
        if(obj.viewControllerIdentifier == LogoutVcID)
        {
            let tpCount = BL_Logout.sharedInstance.getPendingTPCount()
            let dcrCount = BL_Logout.sharedInstance.getPendingDCRCount()
            
            let initialAlert = "Do you want to logout?"
            
            let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                _ = self.navigationController?.popViewController(animated: false)
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                
                if (dcrCount > 0 || tpCount > 0)
                {
                    self.showLogoutAlert(dcrCount: dcrCount, tpCount: tpCount, obj: obj)
                }
                else
                {
                    self.navigateFunc(obj: obj)
                }
                
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertViewController, animated: true, completion: nil)
        }
        else if (obj.viewControllerIdentifier == Constants.ViewControllerNames.SplitViewVCID)
        {
            BL_DoctorList.sharedInstance.customerCategoryArray.removeAllObjects()
            BL_DoctorList.sharedInstance.customerSpecialityArray.removeAllObjects()
            
            var pageSource = Constants.Doctor_List_Page_Ids.Doctor_Master_Edit
            
            if (obj.descriptionTxt == markDoctorLocation)
            {
                pageSource = Constants.Doctor_List_Page_Ids.Mark_Doctor_Location
                
                if (!checkInternetConnectivity())
                {
                    AlertView.showNoInternetAlert()
                    return
                }
            }
            
            if isManager()
            {
                let sb = UIStoryboard(name:commonListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = UserListScreenName.CustomerList.rawValue
                vc.navigationTitle = "Choose User"
                vc.isCustomerMasterEdit = true
                vc.doctorListPageSoruce = pageSource
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                CustomerModel.sharedInstance.regionCode = getRegionCode()
                CustomerModel.sharedInstance.userCode = getUserCode()
                CustomerModel.sharedInstance.navTitle = "\(appDoctorPlural) List"
                
                setSplitViewRootController(backFromAsset: false, isCustomerMasterEdit: true, customerListPageSouce: pageSource)
            }
        }
        else if(obj.viewControllerIdentifier == InwardAccknowledgementID)
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: InwardAccknowledgementID) as! InwardChalanListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (obj.viewControllerIdentifier == "ERROR_LOG")
        {
            let count = BL_Error_Log.sharedInstance.getErrorLogCount()
            
            if (count > 0)
            {
                uploadError()
            }
            else
            {
                AlertView.showAlertView(title: alertTitle, message: Display_Messages.Error_Log.NO_ERROR_FOUND)
            }
        }
        else if (obj.viewControllerIdentifier == "Kennect")
        {
            connetToKennect()
        }
            
        else if (obj.viewControllerIdentifier == "Responsive")
        {
            Index = indexPath.row
            menulist()
        }

        else if obj.viewControllerIdentifier == "MyDocument"
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.NoticeBoardSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MyDocument")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (obj.viewControllerIdentifier ==   Constants.ViewControllerNames.HourlyReportDoctorListVcID)
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDoctorListVcID) as! HourlyReportDoctorListViewController
            vc.isFromIce = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(obj.viewControllerIdentifier ==   "DPM")
        {
            if isManager()
            {
                let sb = UIStoryboard(name:commonListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = UserListScreenName.DPMAccompanistList.rawValue
                vc.navigationTitle = "Choose User"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let sb = UIStoryboard(name:"NoticeBoardViewController", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DPMMainViewController") as! DPMMainViewController
                 vc.selectedRegionCode = getRegionCode()
                vc.selectedRegionName = getRegionName()
                vc.selectedName = getUserName()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else
        {
            navigateFunc(obj: obj)
        }
    }
    
    func navigateFunc(obj: MoreListDescriptionModel)
    {
        let stoaryBoardName = obj.stoaryBoardName
        let viewController = obj.viewControllerIdentifier
        
        if stoaryBoardName == ApprovalSb
        {
            if checkInternetConnectivity()
            {
                let sb = UIStoryboard(name: stoaryBoardName, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: viewController)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else if stoaryBoardName == prepareMyDeviceSb
        {
            if checkInternetConnectivity()
            {
                showCustomActivityIndicatorView(loadingText: authenticationTxt)
                
                BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    
                    if apiResponseObj.list.count > 0
                    {
                        let sb = UIStoryboard(name: stoaryBoardName, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: viewController)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
//                    else
//                    {
//                        AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else if stoaryBoardName == Constants.StoaryBoardNames.NoticeBoardSb
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.NoticeBoardSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.NoticeBoardVCID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if stoaryBoardName == Constants.StoaryBoardNames.MessageSb
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.MessageSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageVCID)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        else if stoaryBoardName == Constants.StoaryBoardNames.ReportsSb && viewController == Constants.ViewControllerNames.ReportsUserListVcID
        {
            let sb = UIStoryboard(name: stoaryBoardName, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: viewController) as! ReportsUserListViewController
            vc.isComingFromRejectPage = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (stoaryBoardName == "HELP")
        {
            if (checkInternetConnectivity())
            {
                var redirectUrl: String = Constants.HelpURLs.RepUrl
                
                if (isManager())
                {
                    redirectUrl = Constants.HelpURLs.ManagerUrl
                }
                
                let sb = UIStoryboard(name: mainSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                vc.webViewTitle = "Help"
                vc.siteURL = redirectUrl
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else if viewController == ChangePasswordVcID
        {
            if checkInternetConnectivity()
            {
                let sb = UIStoryboard(name: stoaryBoardName, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: viewController)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else if viewController == Constants.ViewControllerNames.DoctorListVcID
        {
            if isManager()
            {
                let sb = UIStoryboard(name:commonListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = UserListScreenName.CustomerList.rawValue
                vc.navigationTitle = "Choose User"
                vc.isCustomerMasterEdit = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                CustomerModel.sharedInstance.regionCode = getRegionCode()
                CustomerModel.sharedInstance.userCode = getUserCode()
                CustomerModel.sharedInstance.navTitle = "\(appDoctorPlural) List"
                setSplitViewRootController(backFromAsset: false, isCustomerMasterEdit: true, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
            }
            
//            if BL_DCR_Doctor_Visit.sharedInstance.canUseAccompanistsDoctor()
//            {
//                let sb = UIStoryboard(name:commonListSb, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
//                vc.navigationScreenName = UserListScreenName.CustomerList.rawValue
//                vc.navigationTitle = "Choose User"
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            else
//            {
//                let sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DoctorListVcID) as! DoctorListViewController
//                vc.regionCode = getRegionCode()
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
        else if viewController == AssetParentVCID
        {
            BL_DoctorList.sharedInstance.customerCode = ""
            BL_DoctorList.sharedInstance.regionCode  = ""
            BL_DoctorList.sharedInstance.doctorTitle = ""
            BL_AssetModel.sharedInstance.detailedCustomerId = 0
            
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: AssetParentVCID) as! AssetParentViewController
            vc.isComingFromDigitalAssets = true
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else if stoaryBoardName != ""
        {
            let sb = UIStoryboard(name: stoaryBoardName, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: viewController)
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func showLogoutAlert(dcrCount: Int, tpCount: Int, obj: MoreListDescriptionModel)
    {
        var message = "You have "
        
        if (dcrCount > 0 && tpCount > 0)
        {
            message += "\(dcrCount) DVR(s) and \(tpCount) TPs"
        }
        else if (dcrCount > 0)
        {
            message += "\(dcrCount) DVRs"
        }
        else if (tpCount > 0)
        {
            message += "\(tpCount) PRs"
        }
        
        message += " pending to upload. \n\nTap 'PROCEED' to ignore upload and logout \n\n Tap 'CANCEL' to stop logout"
        
        let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            _ = self.navigationController?.popViewController(animated: false)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "PROCEED", style: UIAlertActionStyle.default, handler: { alertAction in
            self.navigateFunc(obj: obj)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func uploadError()
    {
        showCustomActivityIndicatorView(loadingText: Display_Messages.Error_Log.UPLOAD_LOADER_TEXT)
        
        BL_Error_Log.sharedInstance.sycnErrorLogs { (status) in
            removeCustomActivityView()
            
            if (status == SERVER_SUCCESS_CODE)
            {
                AlertView.showAlertView(title: alertTitle, message: Display_Messages.Error_Log.UPLOAD_SUCCESS_MSG)
                self.tableView.reloadData()
            }
            else
            {
                AlertView.showAlertView(title: alertTitle, message: Display_Messages.Error_Log.UPLOAD_ERROR_MSG)
            }
        }
    }
    
    
    func connetToKennect()
    {
        showCustomActivityIndicatorView(loadingText: "Connecting to Money Tree...")
        WebServiceWrapper.sharedInstance.postKennectApi(urlString: kennectAuthUrl, dataDictionary: ["tenantGID": BL_InitialSetup.sharedInstance.userId]) { (responseObj) in
            
            if let token = responseObj["token"] as? String
            {
                if let okValue = responseObj["ok"] as? Bool
                {
                    if okValue
                    {
                        //save token
                        UserDefaults.standard.set(token, forKey: kennectToken)
                        let empDetails = UserDefaults.standard.value(forKey: kennectUserDetails) as! [String:Any]
                        //                        let userData = ["employerGID":empDetails["Employee_Number"],"email":empDetails["Email_Id"],"managerName":empDetails["Manager_Name"],"name":BL_InitialSetup.sharedInstance.userName,"HQ":BL_InitialSetup.sharedInstance.regionName,"terrId":BL_InitialSetup.sharedInstance.regionCode]
                        let userData = ["employerGID":empDetails["Employee_Number"],"email":empDetails["Email_Id"],"name":BL_InitialSetup.sharedInstance.userName,"divisionName":empDetails["Division_Name"],"role":BL_InitialSetup.sharedInstance.userTypeName]
                        let postData = ["data":userData,"tenantGID":BL_InitialSetup.sharedInstance.userId,"modelname":"employee_info","mode":"update"] as [String : Any]
                        
                        WebServiceWrapper.sharedInstance.postKennectApi2(urlString: kennectUserInfo, dataDictionary: postData, completion: { (responsesObj) in
                            
                            removeCustomActivityView()
                            if let okValue = responsesObj["ok"] as? Bool
                            {
                                if okValue == true
                                {
                                    let sb = UIStoryboard(name: mainSb, bundle: nil)
                                    //let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                    let VC1 = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
                                    
                                    VC1.siteURL = "https://betkennect.xyz/appx#load=app&pref=wlc_incentulator&token=\(token)"
                                   // VC1.isFromKennect = true
                                    VC1.webViewTitle = "Money Tree"
                                    
                                    
                               
                                    self.present(navController, animated:false, completion: nil)
                                    
                                    //self.navigationController?.pushViewController(vc, animated: true)
                                    //getAppDelegate().root_navigation.pushViewController(vc, animated: true)
                                    
                                }else{
                                    AlertView.showAlertView(title: errorTitle, message: "Invalid Token", viewController: self)
                                }
                            }
                        })
                    }
                }
            }
            else if let status = responseObj["status"] as? Int
            {
                removeCustomActivityView()
                if status == SERVER_ERROR_CODE
                {
                    AlertView.showAlertView(title: alertTitle, message: "Problem while connecting... Please try again later.")
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: "Internet Problem Please try again with good internet connection")
                }
            }
        }
    }

    func menulist()
    {
        
//     self.obj = DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
//
//
//        WebServiceWrapper.sharedInstance.responsiveApi(Company_Id: getCompanyId(), Region_Code: getRegionCode(), User_Code: getUserCode()) { (responseObj) in
        
//    }

        
        
        let companyObj = DBHelper.sharedInstance.getCompanyDetails()
        let companyUrl = companyObj?.companyURL
        
            
           // let Url = String(format: "https://hdwebapi-dev.hidoctor.me/UserApi/GetEncryptedUrl")
        let Url = String(format: "\(wsRootUrl)UserApi/GetEncryptedUrl")
            guard let serviceUrl = URL(string: Url) else { return }
        let parameterDictionary = ["Company_Id" : getCompanyId(), "Region_Code" : getRegionCode(), "User_Code" : getUserCode(), "Company_Code" : getCompanyCode(), "User_Name" : getUserName(), "User_Type_Code" : getUserTypeCode(), "User_Type_Name" : getUserTypeName(), "SubDomain_Name" : companyUrl!] as [String : Any]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        if let jsonDict = json as? NSDictionary
                        {
                            let Message = jsonDict.value(forKey: "Message") as? String
                            if (Message == "SUCCESS"){
                                let list = jsonDict.value(forKey: "list") as? NSDictionary
                                
                                print(list!)
                                
                                let str = list!.value(forKey: "Encrypted_Url")

                                var strDetailss = DBHelper.sharedInstance.getMenuMasterByMenuType(MenuType: "3", MenuCategory: "Responsive")
                                
                                
                                
                                //company url call
                                
                                let companyObj = DBHelper.sharedInstance.getCompanyDetails()
     
                                
                                var strmdmUrl : String
                                
                                
                                if BL_MenuAccess.sharedInstance.isKennectAvailable()
                                {
                                
                                  strmdmUrl = strDetailss[self.Index - 1].MdmMenuUrl
                                }
                                
                                else
                                {
                                    strmdmUrl = strDetailss[self.Index].MdmMenuUrl
                                }
                                
                                if (strmdmUrl.contains("https://"))
                                {
                                    
                                    let FinalUrl = "\(strmdmUrl)\(str!)" as String
                                 print(FinalUrl)
                                    
                                    let sb = UIStoryboard(name: mainSb, bundle: nil)
                                    let VC1 = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
                                    
                                    VC1.siteURL = FinalUrl 
                                    
                                    if BL_MenuAccess.sharedInstance.isKennectAvailable()
                                    {
                                        VC1.webViewTitle = strDetailss[self.Index - 1].Menu_Name
                                    }
                                    
                                    else
                                    {
                                        VC1.webViewTitle = strDetailss[self.Index].Menu_Name
                                    }
                                    
                                    
                                    
                                    self.present(navController, animated:false, completion: nil)
                                }
                                
                                else
                                {
                                    
                                    
                                    let companyUrl = companyObj!.companyURL
                                    let url = "https://" + companyUrl! + "/"
                                    let FinalUrl = url + "\(strmdmUrl)\(str!)" as String
                                    
                                    let sb = UIStoryboard(name: mainSb, bundle: nil)
                                    let VC1 = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                    let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
                                    
                                    VC1.siteURL = FinalUrl
                                    
                                    if BL_MenuAccess.sharedInstance.isKennectAvailable()
                                    {
                                        VC1.webViewTitle = strDetailss[self.Index - 1].Menu_Name
                                    }
                                        
                                    else
                                    {
                                        VC1.webViewTitle = strDetailss[self.Index].Menu_Name
                                    }
                                    
                                    self.present(navController, animated:false, completion: nil)
                                }
                                
                            }else{
                                
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                }.resume()
    

        
    }
    

    
}
