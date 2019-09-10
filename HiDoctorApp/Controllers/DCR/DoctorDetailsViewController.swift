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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        loadDefaultData()
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
        return doctorDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = UIView()
        footer.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListDetailsSectionCell) as! DoctorListSectionTableViewCell
        
        let obj = doctorDataList[section]
        
        cell.sectionNameLbl.text = obj.sectionTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doctorDataList[section].dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        reloadTableView()
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
        if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
            
        {
          if(!alert())
          {
            let doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforDoctorId(doctorCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
            if doctorCheck == 0
            {
                let currentLocation = getCurrentLocaiton()
                let initialAlert = "Punch-in time for " + BL_DoctorList.sharedInstance.doctorTitle + " is " + getcurrenttime() + ". You cannot Punch-in for other \(appDoctor) until you punch-out for " + BL_DoctorList.sharedInstance.doctorTitle
                //let indexpath = sender.tag
                let alertViewController = UIAlertController(title: "Punch In", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "Punch In", style: UIAlertActionStyle.default, handler: { alertAction in
                    self.moveToNextScreen()
                    //function
                    //    self.PunchInmoveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: EMPTY, currentLocation: currentLocation)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
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
                moveToNextScreen()
                return true
                
            }
            else
            {
                let assets = DBHelper.sharedInstance.getAssestAnalyticsByCustomer(dcrDate: getCurrentDate(), customerCode: BL_DoctorList.sharedInstance.customerCode, customeRegionCode: BL_DoctorList.sharedInstance.regionCode)
                if (assets != nil && assets.count > 0)
                {
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
        let string = ". You need to Punch-out " + obj.Doctor_Name  + " for other visits "
        let initialAlert = "Punch-In time for " + obj.Doctor_Name + " is " + stringFromDate(date1: getDateFromString(dateString: obj.Punch_Start_Time!) ) + string
    
        //let indexpath = sender.tag
        let alertViewController = UIAlertController(title: "Not allowed to visit", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)

    }
    func showpunchvalidationwithoutobj(doc: String, time: String)
    {
        let string = ". You need to Punch-out " + doc  + " for other visits "
        let initialAlert = "Punch-In time for " + doc + " is " + time + string
        
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
    
    private func moveToNextScreen()
    {
       
        if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
        {
            if(checkInternetConnectivity())
            {
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
            }
        }
        
        loadDefaultData()
    }
}
