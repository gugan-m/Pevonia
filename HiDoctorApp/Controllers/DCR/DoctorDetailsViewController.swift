//
//  DoctorDetailsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import CoreLocation

class DoctorDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var btmWrapper: UIView!
    @IBOutlet weak var btmWrapperHeightConst: NSLayoutConstraint!
    @IBOutlet weak var eDetailingButton: UIButton!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    //For Group e-Detailing

    @IBOutlet weak var backGroungBlurView: UIView!
    @IBOutlet weak var viewGroupEdetailing: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var searchBarGroupEdetailing: UISearchBar!
    @IBOutlet weak var tblViewGroupEdetailing: UITableView!
    
    
    var doctorDataList : [DoctorListModel] = []
    var profileImgUrl : String!
    var isEmptyState: Bool = false
    var locationAlertCount: Int = 0
    var editBtn : UIBarButtonItem!
    var isCustomerMasterEdit : Bool = false
    var doctorListPageSource: Int = Constants.Doctor_List_Page_Ids.Customer_List
    var customerLocation: GeoLocationModel?
    var geoFencingDeviationRemarks: String = EMPTY
    var autoMoveToEDetailingPage: Bool = false
    var hideEDetailingButton: Bool = false
    var similarCustomerList: [CustomerMasterModel] = []
    var selected_similarCustomerList: [CustomerMasterModel] = []
    
    override func viewDidLoad()
    {
        BL_AssetModel.sharedInstance.selected_CustomersForEdetailing = []
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        hideGroupEdetail_View()
        loadDefaultData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let account_Type = BL_DoctorList.sharedInstance.selectedCustomer?.Hospital_Name ?? ""
        let customer_Id = BL_DoctorList.sharedInstance.selectedCustomer?.Customer_Id ?? 0
        self.similarCustomerList = BL_DoctorList.sharedInstance.getDoctorListForGroupEdetailing(type: account_Type)!
        self.similarCustomerList = self.similarCustomerList.filter{$0.Customer_Id != customer_Id}
        self.labelTitle.text = "Do you want to add other Partner(s)?\n\nPlease select the Partner(s) from the below list and click ADD\n\n If you don't want to add other Partner(s),click on CANCEL to proceed."
    }
    
    func showGroupEdetail_View() {
        self.viewGroupEdetailing.isHidden = false
        self.tblViewGroupEdetailing.reloadData()
    }
    
    func hideGroupEdetail_View() {
        self.viewGroupEdetailing.isHidden = true
    }
    
    func loadDefaultData()
    {
        if self.view != nil
        {
            self.tableView.estimatedRowHeight = 2000
            self.setDoctorProfileImg()
            
            self.title = BL_DoctorList.sharedInstance.doctorTitle
            
            if (isCustomerMasterEdit && doctorListPageSource != Constants.Doctor_List_Page_Ids.Mark_Doctor_Location)
            {
                editBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(self.editButton))
                self.navigationItem.rightBarButtonItems = [editBtn]
            }
            
            self.setDefaultDetails()
            
            if isEmptyState == false
            {
                scrollView.isHidden = false
                emptyStateWrapper.isHidden = true
            }
            else
            {
                scrollView.isHidden = true
                emptyStateWrapper.isHidden = false
            }
            
            if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
            {
                if isEmptyState == false
                {
                    btmWrapper.isHidden = false
                    btmWrapperHeightConst.constant = 80.0
                }
                else
                {
                    btmWrapper.isHidden = true
                    btmWrapperHeightConst.constant = 0.0
                    
                    if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
                    {
                        if (SwifterSwift().isPad)
                        {
                            self.emptyStateLabel.text = "Please tap on any \(appDoctor) to view details"
                            self.hideeDetailingButton()
                        }
                    }
                }
            }
            else
            {
                btmWrapper.isHidden = true
                btmWrapperHeightConst.constant = 0.0
            }
        }
        
        if(isCustomerMasterEdit)
        {
            btmWrapper.isHidden = true
            btmWrapperHeightConst.constant = 0.0
        }
        
//        if (self.autoMoveToEDetailingPage)
//        {
//            self.autoMoveToEDetailingPage = false
//
//            if (SwifterSwift().isPad)
//            {
//                eDetailingAction(UIButton())
//            }
//        }
        
        if (!self.isEmptyState)
        {
            if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
            {
                showeDetailingButton()
            }
        }
        
        if (self.hideEDetailingButton)
        {
            hideeDetailingButton()
            self.hideEDetailingButton = false
        }
    }
    
    @objc func editButton()
    {
        let sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DoctorDetailsEditVcID) as! DoctorDetailsEditViewController
        vc.title = BL_DoctorList.sharedInstance.doctorTitle
       
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == tblViewGroupEdetailing {
           return 1
        } else {
           return doctorDataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == tblViewGroupEdetailing {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if tableView == tblViewGroupEdetailing {
            return 0
        } else {
           return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if tableView == tblViewGroupEdetailing {
            return UIView()
        } else {
            let footer = UIView()
            footer.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            return footer
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == tblViewGroupEdetailing {
            return UIView()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListDetailsSectionCell) as! DoctorListSectionTableViewCell
            
            let obj = doctorDataList[section]
            
            cell.sectionNameLbl.text = obj.sectionTitle
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblViewGroupEdetailing {
            return self.similarCustomerList.count
        } else {
            return doctorDataList[section].dataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblViewGroupEdetailing {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.GroupeDetailingCell) as? GroupEdetailingCell
            cell!.customerName.text = self.similarCustomerList[indexPath.row].Customer_Name
           
            var customerDetails = ""
            
            if self.similarCustomerList[indexPath.row].Speciality_Name != nil && self.similarCustomerList[indexPath.row].Speciality_Name != ""{
                customerDetails += self.similarCustomerList[indexPath.row].Speciality_Name + " | "
            } else {
                customerDetails += customerDetails
            }
            if self.similarCustomerList[indexPath.row].Category_Name != nil && self.similarCustomerList[indexPath.row].Category_Name != ""{
                customerDetails += self.similarCustomerList[indexPath.row].Category_Name! + " | "
            } else {
                customerDetails += customerDetails
            }
            if self.similarCustomerList[indexPath.row].Region_Name != nil && self.similarCustomerList[indexPath.row].Region_Name != ""{
                customerDetails += self.similarCustomerList[indexPath.row].Region_Name!
            } else {
                customerDetails += customerDetails
            }
            
            if self.similarCustomerList[indexPath.row].isSelected == true {
                cell!.imgViewSelected.image = UIImage(named: "icon-attachment-tick")
            } else {
                cell!.imgViewSelected.image = UIImage(named: "icon-unselected")
            }
            cell!.customerPosition.text = customerDetails
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListDetailsCell, for: indexPath) as! DoctorDetailsListTableViewCell
            
            let obj = doctorDataList[indexPath.section].dataList[indexPath.row]
            var description : String = NOT_APPLICABLE
            
            if obj.value != nil || (obj.value != "")
            {
                description = obj.value
            }
            cell.headerNameLbl.text = obj.headerTitle
            cell.descriptionLbl.text = description
            cell.sepView.isHidden = false
            if indexPath.row == doctorDataList[indexPath.section].dataList.count - 1
            {
                cell.sepView.isHidden = true
                let maskPathBottom  = UIBezierPath(roundedRect: cell.outerView.bounds, byRoundingCorners: [.bottomLeft,.bottomRight] ,cornerRadii: CGSize(width: 10, height: 10))
                let shapeLayerBottom = CAShapeLayer()
                shapeLayerBottom.frame = cell.outerView.bounds
                shapeLayerBottom.path = maskPathBottom.cgPath
                cell.outerView.layer.mask = shapeLayerBottom
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  tableView == tblViewGroupEdetailing {
            if self.similarCustomerList[indexPath.row].isSelected == true {
                self.similarCustomerList[indexPath.row].isSelected = false
            } else {
                self.similarCustomerList[indexPath.row].isSelected = true
            }
            self.tblViewGroupEdetailing.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if tableView == tblViewGroupEdetailing {
          reloadTableView()
        } else {
           reloadTableView()
        }
    }
    
    func setDefaultDetails()
    {
        if (isCustomerMasterEdit)
        {
            doctorDataList = BL_DoctorList.sharedInstance.getDoctorDataList(isEdit: true)
            doctorDataList[0].dataList = BL_DoctorList.sharedInstance.getDoctorOfficialDetailsForEdit()
            doctorDataList[1].dataList = BL_DoctorList.sharedInstance.getDoctorPersonalDetailsListForEdit()
            doctorDataList[2].dataList = BL_DoctorList.sharedInstance.getDoctorHospitalDetailsListForEdit()
            doctorDataList[3].dataList = BL_DoctorList.sharedInstance.getDoctorOtherDetailsForEdit()
        }
        else
        {
            doctorDataList = BL_DoctorList.sharedInstance.getDoctorDataList(isEdit: false)
            doctorDataList[0].dataList = BL_DoctorList.sharedInstance.getDoctorOfficialDetails()
            doctorDataList[1].dataList = BL_DoctorList.sharedInstance.getDoctorPersonalDetailsList()
            doctorDataList[2].dataList = BL_DoctorList.sharedInstance.getDoctorHospitalDetailsList()
            doctorDataList[3].dataList = BL_DoctorList.sharedInstance.getDoctorOtherDetails()
            doctorDataList[4].dataList = BL_DoctorList.sharedInstance.getMCDoctorProductMappingDetails()
            doctorDataList[5].dataList = BL_DoctorList.sharedInstance.getDoctorProductMappingDetails()
        }
        
        if self.tableView != nil
        {
            self.tableView.reloadData()
        }
    }
    
    func reloadTableView()
    {
        self.tableView.layoutIfNeeded()
        self.tableViewHgtConst.constant = tableView.contentSize.height + btmWrapperHeightConst.constant
    }
    
    func setDoctorProfileImg()
    {
        if (isCustomerMasterEdit)
        {
            profileImgUrl = BL_DoctorList.sharedInstance.getDoctorProfileImgUrlForEdit()
        }
        else
        {
            profileImgUrl = BL_DoctorList.sharedInstance.getDoctorProfileImgUrl()
        }
        
        if profileImgUrl != ""
        {
            if (checkInternetConnectivity())
            {
                ImageLoader.sharedLoader.imageForUrl(urlString: profileImgUrl) {(image) in
                    if(image != nil)
                    {
                        self.profilePic.image = image
                    }
                    else
                    {
                        self.profilePic.image = UIImage(named: "profile-placeholder-image")
                    }
                }
            }
            else
            {
                let imageUrl = profileImgUrl.components(separatedBy: "/")
                let imageName = imageUrl.last!
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first
                {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(Constants.DirectoryFolders.doctorProfileFolder+"/\(imageName)")
                    
                    self.profilePic.image = UIImage(contentsOfFile: imageURL.path)
                }
                
            }
        }
        else
        {
            self.profilePic.image = UIImage(named: "profile-placeholder-image")
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
    
    @IBAction func eDetailingAction(_ sender: Any)
    {
        
        if BL_MenuAccess.sharedInstance.is_Group_eDetailing_Allowed(){
            
            if similarCustomerList.count > 0
            {
                showGroupEdetail_View()
            } else {
               // showToastView(toastText: "Group  Edetailing is not possible.No customers have matched.")
                checkin()
            }
        } else {
            checkin()
        }
    }
    
    func checkin(){
        if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
                
            {
              if(!alert())
              {
                var dcrId = 0
                let convertedDate = getStringInFormatDate(dateString: getCurrentDate())
                let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
                if dcrDetail.count > 0
                {
                    dcrId = dcrDetail[0].DCR_Id
                }
                let doctorCheck = DBHelper.sharedInstance.getAllDetailsWith(dcrId: dcrId, customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
                if doctorCheck == nil
                {
                    let currentLocation = getCurrentLocaiton()
                    let initialAlert = "Check-in time for " + BL_DoctorList.sharedInstance.doctorTitle + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + BL_DoctorList.sharedInstance.doctorTitle
                    //let indexpath = sender.tag
                    let alertViewController = UIAlertController(title: "Check In", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                        alertViewController.dismiss(animated: true, completion: nil)
                    }))
                    
                    alertViewController.addAction(UIAlertAction(title: "Check In", style: UIAlertActionStyle.default, handler: { alertAction in
                        BL_DoctorList.sharedInstance.modifyEntity = 0
                        self.moveToNextScreen()
                        BL_DoctorList.sharedInstance.punchInTime = getStringFromDateforPunch(date: getCurrentDateAndTime())
                        
                        //function
                        //    self.PunchInmoveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: EMPTY, currentLocation: currentLocation)
                        alertViewController.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                }else{
                     BL_DoctorList.sharedInstance.modifyEntity = 1
                    BL_DoctorList.sharedInstance.punchInTime = (doctorCheck?.Punch_Start_Time!)!
                }
                }
            }
            else {
            var deletailedDBId = DBHelper.sharedInstance.getMaxCustomerDetailedId(customerCode: BL_DoctorList.sharedInstance.customerCode, customerRegionCode: BL_DoctorList.sharedInstance.regionCode, detailingDate: getCurrentDate())
            
            if (deletailedDBId == nil)
            {
                deletailedDBId = 0
            }
            BL_AssetModel.sharedInstance.detailedCustomerId = deletailedDBId! + 1
            
            checkLocationAndGeoFencing()
        }
    }
    
    
    
    func alert() -> Bool
    {
        var model : [DCRDoctorVisitModel] = []
        var dcrId = 0
        let convertedDate = getStringInFormatDate(dateString: getCurrentDate())
        let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
        if dcrDetail.count > 0
        {
            dcrId = dcrDetail[0].DCR_Id
        }
        model = DBHelper.sharedInstance.getDCRDoctorVisitPunchTimeValidation(dcrId: dcrId)
        
        if(model != nil && model.count > 0)
        {
            
            let doctorobj : DCRDoctorVisitModel = model[0]
            if (doctorobj.Doctor_Code != nil && doctorobj.Doctor_Region_Name != nil)
            {
            if( BL_DoctorList.sharedInstance.customerCode == doctorobj.Doctor_Code)
            {
                moveToNextScreen()
                return true
            }
            else
            {
                showpunchvalidation(obj: doctorobj)
                return true
            }
            }
            else
            {
                return false
            }
        }
        else
        {
           
            let assets = DBHelper.sharedInstance.getPunchtimevalidationforselectedcustomers(dcrDate: dcrId, customerCode: BL_DoctorList.sharedInstance.customerCode, customeRegionCode: BL_DoctorList.sharedInstance.regionCode)
            if (assets != nil && assets.count > 0 )
            {
                  BL_DoctorList.sharedInstance.modifyEntity = 1
                BL_DoctorList.sharedInstance.punchInTime = (assets[0].Punch_Start_Time!)
                moveToNextScreen()
                return true
                
            }
            else
            {
                let assets = DBHelper.sharedInstance.getAssestAnalyticsByCustomer(dcrDate: getCurrentDate(), customerCode: BL_DoctorList.sharedInstance.customerCode, customeRegionCode: BL_DoctorList.sharedInstance.regionCode)
                if (assets != nil && assets.count > 0)
                {
                      BL_DoctorList.sharedInstance.modifyEntity = 1
                     BL_DoctorList.sharedInstance.punchInTime = (assets[0].Punch_Start_Time!)
                    moveToNextScreen()
                    return true
                }
                else
                {
                    let assets = DBHelper.sharedInstance.getAssestAnalyticscheckpunchout(dcrDate: getCurrentDate())
                    
                    if(assets != nil && assets.count > 0)
                    {
                       
                        showpunchvalidationwithoutobj(doc: assets[0].Customer_Name, time: stringFromDate(date1: getDateFromString(dateString: assets[0].Punch_Start_Time!)))
                        return true
                    }
                   
                }
                
            }
            
        }
        return false
    }
    func showpunchvalidation(obj: DCRDoctorVisitModel)
    {
        let string = ". You need to Check-out " + obj.Doctor_Name  + " for other visits "
        let initialAlert = "Check-In time for " + obj.Doctor_Name + " is " + stringFromDate(date1: getDateFromString(dateString: obj.Punch_Start_Time!) ) + string
    
        //let indexpath = sender.tag
        let alertViewController = UIAlertController(title: "Not allowed to visit", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)

    }
    func showpunchvalidationwithoutobj(doc: String, time: String)
    {
        let string = ". You need to Check-out " + doc  + " for other visits "
        let initialAlert = "Check-In time for " + doc + " is " + time + string
        
        //let indexpath = sender.tag
        let alertViewController = UIAlertController(title: "Not allowed to visit", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    func updatepunchout(dcrID: String, Customercode: String)
    {
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        executeQuery(query: "UPDATE \(TRAN_ASSET_ANALYTICS_DETAILS) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE Detailed_DateTime = \(dcrID) AND Customer_Code = '\(Customercode)'")
    }
    func updatepunchoutforDCRDoctor(dcrID: Int, Customercode: String)
    {
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE DCR_Id = \(dcrID) AND Doctor_Code = '\(Customercode)'")
    }
    
    @IBAction func showProfilePicBtnAction(_ sender: Any)
    {
        if profileImgUrl != ""
        {
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.FileViewSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ImageViewVcID) as! ImageViewController
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.providesPresentationContextTransitionStyle = true
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            vc.urlString = profileImgUrl
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func checkLocationAndGeoFencing()
    {
        locationAlertCount = 0
        
        if (self.customerLocation != nil)
        {
            BL_Geo_Location.sharedInstance.updateCustomerLocation(customerLocation: self.customerLocation!, pageSource: Constants.Geo_Fencing_Page_Names.EDETAILING)
        }
        
        moveToNextScreen()
    }
    
    private func insertDoctorVisitTracker(completion : @escaping (_ status : Int) -> ())
    {
        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTrackerByCustomerCode(customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode, modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: 0.0, viewController: self, geoFencingDeviationRemarks: self.geoFencingDeviationRemarks){(status) in
            completion(status)
        }
    }
    
    private func insertDoctorVisitTracker_GroupEdetailing(cus_code: String,region_Code: String,completion : @escaping (_ status : Int) -> ())
    {
        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTrackerByCustomerCode(customerCode: cus_code, regionCode: region_Code, modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: 0.0, viewController: self, geoFencingDeviationRemarks: self.geoFencingDeviationRemarks){(status) in
            completion(status)
        }
    }
    
    func group_HourlyReport(count: Int) {
        
        var arr_count:Int = count
        let data = self.selected_similarCustomerList[arr_count]
        
        var dcrId = 0
        let convertedDate = getStringInFormatDate(dateString: getCurrentDate())
        let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
        if dcrDetail.count > 0
        {
            dcrId = dcrDetail[0].DCR_Id
        }
        let doctorCheck = DBHelper.sharedInstance.getAllDetailsWith(dcrId: dcrId, customerCode: selected_similarCustomerList[arr_count].Customer_Code, regionCode: selected_similarCustomerList[arr_count].Region_Code)
        if doctorCheck == nil
        {
            showCustomActivityIndicatorView(loadingText: "Check-in for \(data.Customer_Name!)")
            self.insertDoctorVisitTracker_GroupEdetailing(cus_code: data.Customer_Code, region_Code: data.Region_Code, completion: { (status) in
               if arr_count == self.selected_similarCustomerList.count-1 {
                   removeCustomActivityView()
                   self.deleteShowList()
                   getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
               } else {
                       arr_count = arr_count + 1
                       self.group_HourlyReport(count: arr_count)
               }
            })
        } else {
            if arr_count == self.selected_similarCustomerList.count-1 {
                removeCustomActivityView()
                self.deleteShowList()
                getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
            } else {
                    arr_count = arr_count + 1
                    self.group_HourlyReport(count: arr_count)
            }
        }
    }
    
    private func moveToNextScreen()
    {
       
        if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
        {
            if(checkInternetConnectivity())
            {
                var count = 0
                if BL_MenuAccess.sharedInstance.is_Group_eDetailing_Allowed() && self.selected_similarCustomerList.count != 0 {
                    
                    if  self.selected_similarCustomerList.count != 0 {
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        self.insertDoctorVisitTracker { (status) in
                            if(status == SERVER_SUCCESS_CODE)
                            {
                                self.group_HourlyReport(count: 0)
                            }
                            else
                            {
                                removeCustomActivityView()
                                 AlertView.showAlertView(title: alertTitle, message: "EDetailing Date is not a current date", viewController: self)
                            }
                        }
                    } else {
                        removeCustomActivityView()
                        self.deleteShowList()
                        getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
                    }
                    
                } else {
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    self.insertDoctorVisitTracker { (status) in
                        if(status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            self.deleteShowList()
                            getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
                        }
                        else
                        {
                            removeCustomActivityView()
                             AlertView.showAlertView(title: alertTitle, message: "EDetailing Date is not a current date", viewController: self)
                        }
                    }
                }
            }
            else
            {
                AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
            }
        }
        else
        {
//            self.insertDoctorVisitTracker{ (status) in
//                if(status == SERVER_SUCCESS_CODE)
//                {
//                    self.deleteShowList()
//                    getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
//                }
//            }
            self.deleteShowList()
              getAppDelegate().allocateRootViewController(sbName: Constants.StoaryBoardNames.AssetsListSb, vcName: AssetParentVCID)
        }
    }
    
    private func deleteShowList()
    {
        //DBHelper.sharedInstance.clearTempList()
        BL_AssetModel.sharedInstance.assignAllPlayListToShowList(customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
    }
    
    private func hideeDetailingButton()
    {
        self.eDetailingButton.isHidden = true
        self.btmWrapper.isHidden = true
        self.btmWrapperHeightConst.constant = 0
    }
    
    func canAllowUserToGroupEdetailing() -> Bool {
        for data in similarCustomerList{
            if data.isSelected == true {
                return true
            }
        }
        return false
    }
   
    @IBAction func addAction_GroupEdetailing(_ sender: UIButton) {
        
        if !canAllowUserToGroupEdetailing() {
            let alertViewController = UIAlertController(title: "Add Partner(s)", message: "Please select the Partner(s) from the list", preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { alertAction in
                 alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        } else {
            
            
            selected_similarCustomerList = self.similarCustomerList.filter{ $0.isSelected == true  }
            BL_AssetModel.sharedInstance.selected_CustomersForEdetailing = selected_similarCustomerList
            var dcrId = 0
            let convertedDate = getStringInFormatDate(dateString: getCurrentDate())
            let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
            if dcrDetail.count > 0
            {
                dcrId = dcrDetail[0].DCR_Id
            }
            let doctorCheck = DBHelper.sharedInstance.getAllDetailsWith(dcrId: dcrId, customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
            if doctorCheck == nil
            {
                
                           
                           print(selected_similarCustomerList.count)
                           self.checkin()
            } else {
                    self.group_HourlyReport(count: 0)
              }
                                       
         }
    }
    
    @IBAction func cancelAction_GroupEdeailing(_ sender: UIButton) {
        
        self.checkin()
        hideGroupEdetail_View()
    }
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
    }
    
    private func showeDetailingButton()
    {
        if (BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased())
        {
            self.eDetailingButton.isHidden = false
            self.btmWrapper.isHidden = false
            self.btmWrapperHeightConst.constant = 80
        }
        else
        {
            hideeDetailingButton()
        }
    }
}

extension DoctorDetailsViewController: CustomerDelegate
{
    func customerSelected()
    {
        if(isCustomerMasterEdit)
        {
            
        }
        
        if (self.doctorListPageSource == Constants.Doctor_List_Page_Ids.Customer_List)
        {
            if (SwifterSwift().isPad)
            {
                if (self.hideEDetailingButton)
                {
                    hideeDetailingButton()
                }
                BL_AssetModel.sharedInstance.selected_CustomersForEdetailing.removeAll()
                let account_Type = BL_DoctorList.sharedInstance.selectedCustomer?.Hospital_Name ?? ""
                let customer_Id = BL_DoctorList.sharedInstance.selectedCustomer?.Customer_Id ?? 0
                self.similarCustomerList = BL_DoctorList.sharedInstance.getDoctorListForGroupEdetailing(type: account_Type)!
                self.similarCustomerList = self.similarCustomerList.filter{$0.Customer_Id != customer_Id}
                       hideGroupEdetail_View()
            }
        }
       
        loadDefaultData()
    }
}

// Group eDetailing

extension DoctorDetailsViewController {
    
  //Button Actions
    
    
    
    
}
