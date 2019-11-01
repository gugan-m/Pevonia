//
//  LandingViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 03/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class LandingViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,onBoardComplete
{
    @IBOutlet weak var quicknotes: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var collectionViewHgt: NSLayoutConstraint!
    
    var titleList : [LandingPageModel] = []
    var versionUpgradeList: [VersionUpgradeModel] = []
    var index: Int = 0
    var orientation = UIDeviceOrientation(rawValue: 0)
    var showAlertsBadge: Bool = false
    let assetDownloadObserver = "assetDownloadObserver"
    var alertsIndexPath: IndexPath!
    var alertArray : [String] = []
    var alertIndex = Int()
    var splashlist:[SplashModel] = []
    var splashlist1:[SplashModel] = []
    var splashlist2:[SplashModel] = []
    var check: Bool = false
    let lastAlertDate = UserDefaults.standard.string(forKey:"lastAlertDate")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        BL_PrepareMyDevice.sharedInstance.getbussinessStatusPotential()
        orientation = UIDevice.current.orientation
        
        NotificationCenter.default.addObserver(self, selector: #selector(alertAction(_:)), name: NSNotification.Name(rawValue: "onBoardAction"), object: nil)
        
        if SwifterSwift().isPad || SCREEN_HEIGHT > 650
        {
            if self.view.frame.size.height > self.view.frame.size.width
            {
                self.collectionViewHgt.constant = self.view.frame.size.height/3
            }
            else
            {
                self.collectionViewHgt.constant = self.view.frame.size.height/2.3
            }
        }
        else
        {
            if self.view.frame.size.height < self.view.frame.size.width
            {
                self.collectionViewHgt.constant = self.view.frame.size.height/2
            }
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setUserDetails()
        
        titleList = getCurrentList()
        //self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        assetDownloadObservers()
        
        self.askPermissionForLocationAccess()
       // setCompanyLogo()
        
    }
    
    @objc func didBecomeActive() {
        checkForceUpdate()
        
        
    }
    
    func pass(splashlist: [SplashModel]){
        for splash in splashlist {
            if(splashlist.count > 1)
            {
                splashlist2.append(splash)
            }
        }
        self.showAlert()
        UserDefaults.standard.set(getCurrentDate(), forKey: "lastAlertDate")
        
    }
    
    private func showAlert() {
        guard self.splashlist1.count > 0 else { return }
        let message = self.splashlist1.first?.desc
        let type1 = self.splashlist1.first?.type
        let file = self.splashlist1.first?.file
        let title = self.splashlist1.first?.title
        func removeAndShowNextMessage() {
            self.splashlist1.removeFirst()
            self.showAlert()
        }
        var alert = UIAlertController()
        if type1 == 0
        {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alert.addAction(UIAlertAction(title: "Close", style: .default){ (action) in
                print("pressed yes")
                // removeAndShowNextMessage()
                self.check  = true
            })
            if splashlist1.count > 1
            {
                alert.addAction(UIAlertAction(title: "Next screen", style: .cancel){ (action) in
                    print("pressed no")
                    removeAndShowNextMessage()
                })
            }
            
        }
        else if type1 == 1
        {   var imageURL = UIImage()
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            let url = URL(string:"https://nbfiles.blob.core.windows.net/"+getCompanyCode().lowercased()+"/"+file!)
            let data = try? Data(contentsOf:url!)
            
            // It is the best way to manage nil issue.
            imageURL = UIImage(data:data! as Data)!
            var image = imageURL
            alert.addImage(image: image)
            alert.addAction(UIAlertAction(title: "Close", style: .default){ (action) in
                print("pressed yes")
                //removeAndShowNextMessage()
                self.check = true
            })
            if splashlist1.count > 1
            {
                alert.addAction(UIAlertAction(title: "Next screen", style: .cancel){ (action) in
                    print("pressed no")
                    removeAndShowNextMessage()
                })
            }
        }
        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
    }
    
    
    func checksplash()
    {
        splash { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                
                self.pass(splashlist: self.splashlist1)
            }
        }
    }
    
    func checkForceUpdate()
    {
        checkForceUpdate { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                if (BL_MasterDataDownload.sharedInstance.onBoarCompleted == true || !checKOnBoardShown())
                {
                    if BL_MasterDataDownload.sharedInstance.autoDownload == false
                    {
                        self.checkMasterDataDownloaded()
                    }
                }
            }
            else
            {
                //show alert to update app
                let alertViewController = UIAlertController(title: "Update Available", message: Display_Messages.DCR_Inheritance_Messages.APP_FORCE_UPDATE_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    //  goToSettingsPage()
                    let url = URL(string: applicationituneUrl)!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
    @objc func willEnterForeground() {
        // print("will enter foreground")
    }
    
    @objc func alertAction(_ notification: NSNotification)
    {
        checkForceUpdate()
        checkCodeOfConduct()
        self.checkAlertRedirection()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        BL_AssetDownloadOperation.sharedInstance.visibleLanding = true
        self.assetBannerAction()
        // self.collectionView.reloadData()
        setCollectionViewHeight()
        self.getAlertsCount()
       // self.showOnboardName()
        let date = UserDefaults.standard.value(forKey: "lastAlertDate") as! String!
        
        let isEqual = (getCurrentDate() == date)
        setCompanyLogo()
        
        quicknotes.isHidden = true
        if date == nil || !isEqual
        {
            self.checksplash()
        }
        showVersionToastView(textColor : UIColor.white)
        //        self.getAlertsCount()
        // self.checkAlertRedirection()
        //uploadEDetailingAnalytics(isUploadDCR: false)
        
        checkForceUpdate { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                BL_Geo_Location.sharedInstance.uploadCustomerAddress { (status) in
                    print(status)
                }
                
                if (isSingleDeviceLoginEnabled())
                {
                    BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self) { (objApiResponse) in
                    }
                }
                
                if (checkInternetConnectivity())
                {
                    BL_Password.sharedInstance.getUserAccountDetails(viewController: self, completion: { (status) in
                        print(status)
                    })
                }
                else
                {
                    BL_Password.sharedInstance.doPasswordOfflineValidations(viewController: self)
                }
                
                if (BL_MasterDataDownload.sharedInstance.onBoarCompleted == true || !checKOnBoardShown())
                {
                    if BL_MasterDataDownload.sharedInstance.autoDownload == false
                    {
                        self.checkMasterDataDownloaded()
                    }
                    self.checkCodeOfConduct()
                    
                }
            }
            else
            {
                //show alert to update app
                
                let alertViewController = UIAlertController(title: "Update Available", message: Display_Messages.DCR_Inheritance_Messages.APP_FORCE_UPDATE_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    //  goToSettingsPage()
                    let url = URL(string: applicationituneUrl)!
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
        }
        
    }
    
    func checkAlertRedirection()
    {
        var getAlertValue = BL_MenuAccess.sharedInstance.getLandingAlertValue()
        getAlertValue = getAlertValue.replacingOccurrences(of: " ", with: "")
        
        alertArray = getAlertValue.components(separatedBy: ",")
        alertIndex = 0
        checkAlert()
    }
    
    func navigateAlert(title:String,message:String,storyBoard:String,viewController:String)
    {
        let alertViewController = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            
            self.navigateToNextScreen(stoaryBoard: storyBoard, viewController: viewController)
            
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func checkAlert()
    {
        BL_MenuAccess.sharedInstance.landingAlertUserDefaults()
        if(BL_MenuAccess.sharedInstance.unreadNoticeBoardCount > 0 || BL_MenuAccess.sharedInstance.inwardCount > 0 || BL_MenuAccess.sharedInstance.unreadMessageCount > 0 || BL_MenuAccess.sharedInstance.unreadTaskCount > 0)
        {
            if alertIndex < alertArray.count
            {
                if(alertArray[alertIndex] == LandingAlertValue.NOTICEBOARD.rawValue)
                {
                    if BL_MenuAccess.sharedInstance.unreadNoticeBoardCount == 0
                    {
                        self.alertIndex += 1
                        self.checkAlert()
                    }
                    else
                    {
                        //Show alert to redirect noticeboard view
                        navigateAlert(title: alertTitle, message: Display_Messages.Landing_Alert_Message.NOTICEBOARD, storyBoard: Constants.StoaryBoardNames.NoticeBoardSb, viewController: Constants.ViewControllerNames.NoticeBoardVCID)
                    }
                }
                else if(alertArray[alertIndex] == LandingAlertValue.INWARD.rawValue)
                {
                    if BL_MenuAccess.sharedInstance.inwardCount == 0
                    {
                        self.alertIndex += 1
                        self.checkAlert()
                    }
                    else
                    {
                        //Show alert to redirect Inward acknowledge view
                        navigateAlert(title: alertTitle, message: Display_Messages.Landing_Alert_Message.INWARD, storyBoard: commonListSb, viewController: InwardAccknowledgementID)
                    }
                    
                }
                else if(alertArray[alertIndex] == LandingAlertValue.MESSAGE.rawValue)
                {
                    if BL_MenuAccess.sharedInstance.unreadMessageCount == 0
                    {
                        self.alertIndex += 1
                        self.checkAlert()
                    }
                    else
                    {
                        //Show alert to redirect message view
                        navigateAlert(title: alertTitle, message: Display_Messages.Landing_Alert_Message.MESSAGE, storyBoard: Constants.StoaryBoardNames.MessageSb, viewController: Constants.ViewControllerNames.MessageVCID)
                    }
                }
                else if(alertArray[alertIndex] == LandingAlertValue.TASK.rawValue)
                {
                    if BL_MenuAccess.sharedInstance.unreadTaskCount == 0
                    {
                        self.alertIndex += 1
                        self.checkAlert()
                    }
                    else
                    {
                        //Show alert to redirect task view
                        navigateAlert(title: alertTitle, message: Display_Messages.Landing_Alert_Message.TASK, storyBoard: commonListSb, viewController: TaskListViewControllerID)
                    }
                    
                }
            }
        }
    }
    private func splash(completion: @escaping (_ status: Int) -> ())
    {
        if(checkInternetConnectivity())
        {
            WebServiceHelper.sharedInstance.getSplashScreenData { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    if apiObj.list.count>0
                    {   var splash = SplashModel()
                        for splashobj in apiObj.list
                        {
                            splash = SplashModel()
                            var file = (splashobj as! NSDictionary).value(forKey: "File_Path") as! String
                            var descrip = (splashobj as! NSDictionary).value(forKey: "Description") as! String
                            var title = (splashobj as! NSDictionary).value(forKey: "Title") as! String
                            if title.count < 1
                            {
                                title = "New Splash"
                            }
                            if  file.count > 0
                            {
                                if descrip.count > 1
                                {
                                    splash.file = file
                                    splash.type = 1
                                    splash.desc = descrip
                                    splash.title = title
                                }
                                else
                                {
                                    splash.file =  file
                                    splash.type = 1
                                    splash.desc = ""
                                    splash.title = title
                                }
                                
                            }
                            else if file.count < 1
                            {
                                splash.desc = descrip
                                splash.type = 0
                                splash.title = title
                                
                                
                            }
                            
                            self.splashlist1.append(splash)
                        }
                    }
                    completion(SERVER_SUCCESS_CODE)
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            //isAppUpdateAvailable
            
        }
    }
    
    private func checkForceUpdate(completion: @escaping (_ status: Int) -> ())
    {
        if(checkInternetConnectivity())
        {
            WebServiceHelper.sharedInstance.isAppUpdateAvailable { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    let getDetails = apiObj.list[0] as! NSDictionary
                    let isUpdateAvailable = getDetails.value(forKey:"isUpgradeRequired") as! String
                    let version = getDetails.value(forKey:"Version") as! String
                    if(getCurrentAppVersionOnly() != version)
                    {
                        if(isUpdateAvailable == "1")
                        {
                            UserDefaults.standard.set(true, forKey: ForeUpdateRequired)
                            completion(2)
                        }
                        else
                        {
                            UserDefaults.standard.set(false, forKey: ForeUpdateRequired)
                            completion(SERVER_SUCCESS_CODE)
                        }
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: ForeUpdateRequired)
                        completion(SERVER_SUCCESS_CODE)
                    }
                    
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            //isAppUpdateAvailable
            
        }
        else
        {
            if let getDate = UserDefaults.standard.value(forKey: ForeUpdateRequired) as? Bool
            {
                if(getDate)
                {
                    completion(2)
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            else
            {
                completion(SERVER_SUCCESS_CODE)
            }
        }
    }
    
    private func checkCodeOfConduct()
    {
        if let getDate = UserDefaults.standard.value(forKey: "CodeOfConduct") as? Date
        {
            let compare = NSCalendar.current.compare(getDate, to: Date(), toGranularity: .day)
            if(compare != .orderedSame && compare == .orderedAscending)
            {
                self.showCodeOFConduct()
            }
        }
        else
        {
            self.showCodeOFConduct()
        }
    }
    
    func showCodeOFConduct()
    {
        BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
            if(response)
            {
                // if yes show code of conduct page
                let sb = UIStoryboard(name:prepareMyDeviceSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: CodeOfConductViewControllerID) as! CodeOfConductViewController
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                vc.isComingFromCompanyLogin = false
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    func assetDownloadObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.assetDownloadObserverAction(_:)), name: NSNotification.Name(rawValue: assetDownloadObserver), object: nil)
    }
    
    @objc func assetDownloadObserverAction(_ notification: NSNotification)
    {
        //notification.
        if(BL_AssetDownloadOperation.sharedInstance.visibleLanding)
        {
            assetBannerAction()
        }
    }
    
    func assetBannerAction()
    {
        if(checkInternetConnectivity())
        {
            if(BL_AssetDownloadOperation.sharedInstance.totalAssetCount > 0)
            {
                if(ifBannerIntialized())
                {
                    dismissBanner()
                }
                DispatchQueue.main.async {
                    let title =  String(BL_AssetDownloadOperation.sharedInstance.totalAssetCount) + " Assets"
                    showBanner(title: "Downloading...", subTitle: title, bgColor: BannerColors.yellow)
                }
            }
            else
            {
                if(ifBannerIntialized())
                {
                    dismissBanner()
                }
            }
        }
        else
        {
            if (ifBannerIntialized())
            {
                dismissBanner()
            }
            
            if(BL_AssetDownloadOperation.sharedInstance.totalAssetCount > 0)
            {
                DispatchQueue.main.async {
                    showBanner(title: "Sorry", subTitle: assetInternetDropOffMsg, bgColor: BannerColors.red)
                }
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        setCollectionViewHeight()
    }
    
    override func viewDidLayoutSubviews()
    {
        removeVersionToastView()
        showVersionToastView(textColor: UIColor.white)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(ifBannerIntialized())
        {
            dismissBanner()
        }
        removeVersionToastView()
        BL_AssetDownloadOperation.sharedInstance.visibleLanding = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(ifBannerIntialized())
        {
            dismissBanner()
        }
    }
    func dismissBanners()
    {
        if(ifBannerIntialized())
        {
            dismissBanner()
        }
    }
    
    func setCompanyLogo()
    {
        let filePath = fileInDocumentsDirectory(filename: ImageFileName.companyLogo.rawValue)
        
        if let loadedImage = loadImageFromPath(path: filePath)
        {
            self.logoImageView.imageWithFade = loadedImage
            
        }
    }
    
    //MARK: - Collection view delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell : LandingCollectionViewCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: landingCellIdentifier, for: indexPath) as! LandingCollectionViewCell
        let obj = titleList[indexPath.row]
        cell.titleLbl.text = obj.title
        
        if SwifterSwift().isPad
        {
            cell.titleLbl.font = UIFont(name: "SFUIText-Regular", size: 15)
        }
        
        cell.imgView.image = UIImage(named: obj.titleImg)
        let pendingCount = BL_Upload_DCR.sharedInstance.getPendingDCRsForUpload().count
        cell.pendingCountLbl.font = UIFont(name: "SFUIText-Regular", size: 12)
        cell.batchTextHgtConstr.constant = 0
        
        if pendingCount > 10
        {
            cell.pendingCountLbl.text =  "9+"
        }
        else
        {
            cell.pendingCountLbl.text = String(pendingCount)
        }
        
        if obj.titleId == 5 && pendingCount > 0
        {
            if SwifterSwift().isPad
            {
                cell.imgWidthConst.constant = 30
                cell.imgHeightConst.constant = 30
                cell.imgVerticalConstraint.constant = -20
            }
            else
            {
                cell.imgWidthConst.constant = 20
            }
        }
        else
        {
            cell.imgWidthConst.constant = 0
        }
        
        if (obj.titleId == 9 && showAlertsBadge)
        {
            cell.pendingCountLbl.font = UIFont(name: "SFUIText-Regular", size: 25)
            cell.pendingCountLbl.text =  "*"
            cell.batchTextHgtConstr.constant = 6
            
            if SwifterSwift().isPad
            {
                cell.imgWidthConst.constant = 30
                cell.imgHeightConst.constant = 30
                cell.imgVerticalConstraint.constant = -20
            }
            else
            {
                cell.imgWidthConst.constant = 20
            }
        }
        
        cell.mainView.layer.cornerRadius = cell.mainView.frame.height/2
        cell.mainView.layer.borderColor = UIColor.white.cgColor
        
        if (obj.titleId == 9)
        {
            self.alertsIndexPath = indexPath
        }
        
        return cell
    }
    
    private func navigateToApprovalOrTP()
    {
        let objLandingPageModel = titleList[1]
        
        if (objLandingPageModel.title == TOUR_PLAN)
        {
            navigateToTpReport()
        }
        else
        {
            removeVersionToastView()
            self.navigateToNextScreen(stoaryBoard: ApprovalSb, viewController: ApprovalVcID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        removeVersionToastView()
        
        let titleObj  = titleList[indexPath.item]
        
        switch titleObj.titleId
        {
        case 0:
            self.navigateToNextScreen(stoaryBoard: DCRCalenderSb, viewController: DCRVcID)
            removeVersionToastView()
            break
        case 1:
            self.navigateToNextScreen(stoaryBoard: ApprovalSb, viewController: ApprovalVcID)
            break
        case 2:
            // navigateToTpReport()
            self.navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.TPCalendarSb ,viewController: Constants.ViewControllerNames.TPCalendarVCID)
            removeVersionToastView()
            break
        case 3:
            setDashboard()
            /*self.navigateToNextScreen(stoaryBoard: "Dashboard", viewController: "Dashboard")
             //            self.navigateToDashboardView()*/
            removeVersionToastView()
            
            break
        case 4:
            self.navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.ReportsSb, viewController: Constants.ViewControllerNames.ReportsVcID)
            removeVersionToastView()
            break
        case 5:
            if checkInternetConnectivity()
            {
                let analyticsList = DBHelper.sharedInstance.getAssetAnalytics()
                let pendingDCRAvailable = BL_DCR_Refresh.sharedInstance.isAnyPendingDCRToUpload()
                
                if (analyticsList.count > 0 || pendingDCRAvailable)
                {
                    
                    BL_DCRCalendar.sharedInstance.getDCRUploadError(viewController: self, isFromLandingUpload: true, enabledAutoSync: false)
                }
                else
                {
                    AlertView.showAlertView(title: infoTitle, message: "No applied / approved DVRs found to upload")
                    
                    
                }
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
            
            break
        case 6:
            self.navigateToNextScreen(stoaryBoard: MoreViewMasterSb, viewController: MoreViewControllerVcID)
            removeVersionToastView()
            break
        case 7:
            if isManager()
            {
                let sb = UIStoryboard(name:commonListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = UserListScreenName.CustomerList.rawValue
                vc.navigationTitle = "Choose User"
                vc.isCustomerMasterEdit = false
                vc.doctorListPageSoruce = Constants.Doctor_List_Page_Ids.Customer_List
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                CustomerModel.sharedInstance.regionCode = getRegionCode()
                CustomerModel.sharedInstance.userCode = getUserCode()
                CustomerModel.sharedInstance.navTitle = "\(appDoctorPlural) List"
                setSplitViewRootController(backFromAsset: false, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
            }
            
            break
        case 8:
            if (checkInternetConnectivity())
            {
                showCustomActivityIndicatorView(loadingText: authenticationTxt)
                
                BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objApiResponse) in
                    removeCustomActivityView()
                    
                    if (objApiResponse.list.count > 0)
                    {
                        let sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: masterDataVcID) as! MasterDataDownloadViewController
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
            break
        case 9:
            //            BL_DoctorList.sharedInstance.customerCode = ""
            //            BL_DoctorList.sharedInstance.regionCode  = ""
            //            BL_DoctorList.sharedInstance.doctorTitle = ""
            //            BL_AssetModel.sharedInstance.detailedCustomerId = 0
            //            //            let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            //            //            let vc = sb.instantiateViewController(withIdentifier:  Constants.ViewControllerNames.AssetsListVcID) as! AssetsListViewController
            //            let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            //            let vc = sb.instantiateViewController(withIdentifier: AssetParentVCID) as! AssetParentViewController
            //            vc.isComingFromDigitalAssets = true
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            break
            if (checkInternetConnectivity())
            {
                //                BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objAiResponse) in
                let sb = UIStoryboard(name: landingViewSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.LandingAlertVCId) as! LandingAlertsViewController
                self.navigationController?.pushViewController(vc, animated: true)
                //                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
            break
        case 10:
            break
        case 12:
            let sb = UIStoryboard(name: "calendar", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "pevoniaVCid") as! ViewCalendarController
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var size : CGFloat = 0.0
        var height : CGFloat = 0
        
        if SwifterSwift().isPhone
        {
            size = self.collectionView.frame.width/4.0
        }
        else
        {
            if titleList.count == 8
            {
                size = self.collectionView.frame.width/4.0
            }
            else
            {
                size = self.collectionView.frame.width/5.0
            }
        }
        
        height = collectionView.frame.size.height/2
        
        return CGSize(width: size, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func getCurrentList() -> [LandingPageModel]
    {
        let titleObj  = LandingPageModel()
        var landingList : [LandingPageModel] = []
        
        //landingList = titleObj.getMenuListForWithoutEDManager_Mobile()
        
        if SwifterSwift().isPhone
        {
            if isManager()
            {
                
                
                if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                        landingList = titleObj.getMenuListForWithEDManager_MobileNotes()
                    }
                    else{
                        landingList = titleObj.getMenuListForWithEDManager_Mobile()
                    }
                }
                else
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                        landingList = titleObj.getMenuListForWithoutEDManager_MobileNotes()
                    }
                    else
                    {
                        landingList = titleObj.getMenuListForWithoutEDManager_Mobile()
                    }
                }
                
            }
            else
            {
                if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                        landingList = titleObj.getMenuListForWithEDRep_MobileNotes()
                    }
                    else
                    {
                        landingList = titleObj.getMenuListForWithEDRep_Mobile()
                    }
                }
                else
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                        landingList = titleObj.getMenuListForWithoutEDRep_MobileNotes()
                    }
                    else
                    {
                        landingList = titleObj.getMenuListForWithoutEDRep_Mobile()
                    }
                }
            }
        }
        else
        {
            if isManager()
            {
                if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                        landingList = titleObj.getMenuListForWithEDManager_IPadNotes()
                    }
                    else
                    {
                    landingList = titleObj.getMenuListForWithEDManager_IPad()
                    }
                }
                else
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                    landingList = titleObj.getMenuListForWithoutEDManager_IPadNotes()
                    }
                    else
                    {
                    landingList = titleObj.getMenuListForWithoutEDManager_IPad()
                    }
                }
            }
            else
            {
                if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                    landingList = titleObj.getMenuListForWithEDRep_IPadNotes()
                    }
                    else
                    {
                        landingList = titleObj.getMenuListForWithEDRep_IPad()
                    }
                }
                else
                {
                    if (BL_MenuAccess.sharedInstance.isQuickNotesAvailable())
                    {
                    landingList = titleObj.getMenuListForWithoutEDRep_IPad()
                    }
                    else
                    {
                        landingList = titleObj.getMenuListForWithoutEDRep_IPadNotes()
                    }
                    
                }
            }
        }
        
        LandingDataManager.sharedManager.displayedArrayList = landingList
        
        return landingList
    }
    
    func navigateToNextScreen(stoaryBoard:String,viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToDashboardView()
    {
        if checkInternetConnectivity()
        {
            let sb = UIStoryboard(name: mainSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
            vc.siteURL = dashboardWebLink
            vc.webViewTitle = "Dashboard"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func setUserDetails()
    {
        let userName = BL_InitialSetup.sharedInstance.userName
        let userTypeName = BL_InitialSetup.sharedInstance.userTypeName
        self.userName.text = "\(userName!)(\(userTypeName!))"
    }
    
    func showOnboardName()
    {
        if checKOnBoardShown() == true
        {
            let onboard_sb = UIStoryboard(name:onBoardViewSb, bundle: nil)
            let onboard_vc = onboard_sb.instantiateViewController(withIdentifier: onboardViewVcID) as! OnBoardViewController
            onboard_vc.providesPresentationContextTransitionStyle = true
            onboard_vc.definesPresentationContext = true
            onboard_vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            onboard_vc.delegate = self
            self.present(onboard_vc, animated: false, completion: nil)
            
            // checksplash
        }
    }
    
    private func askPermissionForLocationAccess()
    {
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY) == PrivilegeValues.YES.rawValue)
        {
            let appDelegate = getAppDelegate()
            
            appDelegate.locationManager.requestWhenInUseAuthorization()
            appDelegate.locationManager.delegate = appDelegate
            appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            appDelegate.startUpdatingLocations()
        }
    }
    
    private func navigateToTpReport()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.UserPerDayReportsVcID) as! UserPerDayReportsViewController
        
        vc.isComingFromTpPage = true
        
        let userObj = BL_Reports.sharedInstance.getMineObject()
        let dict : ApprovalUserMasterModel = ApprovalUserMasterModel()
        dict.User_Code = userObj?.User_Code
        dict.User_Type_Name = userObj?.User_Type_Name
        dict.User_Name = userObj?.User_Name
        dict.Employee_Name = userObj?.Employee_name
        dict.Region_Name = userObj?.Region_Name
        dict.Region_Code = userObj?.Region_Code
        
        vc.userList = dict
        vc.isMine  = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetAlertUserDefaults()
    {
        UserDefaults.standard.set(0, forKey: UserDefaultsValues.NoticeBoard.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsValues.Message.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsValues.Inward.rawValue)
        UserDefaults.standard.set(0, forKey: UserDefaultsValues.Task.rawValue)
    }
    
    private func getAlertsCount()
    {
        if (checkInternetConnectivity())
        {
            showAlertsBadge = false
            
            BL_Alerts.sharedInstance.getUnreadMessageCount { (objApiResponse) in
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    if (objApiResponse.list.count > 0)
                    {
                        let dict = objApiResponse.list.firstObject as! NSDictionary
                        let count = dict.value(forKey: "Total_Unread_Messages") as! Int
                        UserDefaults.standard.set(count, forKey: UserDefaultsValues.Message.rawValue)
                        
                        if (count >= 0)
                        {
                            if(count > 0)
                            {
                                self.showAlertsBadge = true
                                //self.collectionView.reloadData()
                                self.collectionView.reloadItems(at: [self.alertsIndexPath])
                            }
                            if (checkInternetConnectivity())
                            {
                                BL_Alerts.sharedInstance.getUnreadNoticeCount(completion: { (objApiResponse) in
                                    if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                                    {
                                        if (objApiResponse.list.count > 0)
                                        {
                                            let dict = objApiResponse.list.firstObject as! NSDictionary
                                            let count = dict.value(forKey: "Total_Unread_Notice_Count") as! Int
                                            UserDefaults.standard.set(count, forKey: UserDefaultsValues.NoticeBoard.rawValue)
                                            
                                            if (count > 0)
                                            {
                                                self.showAlertsBadge = true
                                                //self.collectionView.reloadData()
                                                self.collectionView.reloadItems(at: [self.alertsIndexPath])
                                            }
                                            
                                            if (count >= 0)
                                            {
                                                WebServiceHelper.sharedInstance.getInwardChalanListWithProduct{ (apiObj) in
                                                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                                                    {
                                                        UserDefaults.standard.set(apiObj.list.count, forKey: UserDefaultsValues.Inward.rawValue)
                                                        if (apiObj.list.count > 0)
                                                        {
                                                            self.showAlertsBadge = true
                                                            //self.collectionView.reloadData()
                                                            self.collectionView.reloadItems(at: [self.alertsIndexPath])
                                                        }
                                                        
                                                        if (apiObj.Status == SERVER_SUCCESS_CODE)
                                                        {
                                                            WebServiceHelper.sharedInstance.getTaskANdFollowUPCount() { (apiObj) in
                                                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                                                {
                                                                    
                                                                    if(apiObj.list.count > 0)
                                                                    {
                                                                        let dict = apiObj.list.firstObject as! NSDictionary
                                                                        let count = dict.value(forKey: "Task_Count") as! Int
                                                                        UserDefaults.standard.set(apiObj.list.count, forKey: UserDefaultsValues.Task.rawValue)
                                                                        
                                                                        if (count > 0)
                                                                        {
                                                                            self.showAlertsBadge = true
                                                                            //self.collectionView.reloadData()
                                                                            self.collectionView.reloadItems(at: [self.alertsIndexPath])
                                                                        }
                                                                        self.checkAlertRedirection()
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                })
                            }
                        }
                        else
                        {
                            self.showAlertsBadge = true
                            //self.collectionView.reloadData()
                            self.collectionView.reloadItems(at: [self.alertsIndexPath])
                        }
                    }
                }
            }
        }
    }
    func getSplashScreen(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getSplashScreenData ()
            { (apiResponseObj) in
                completion(apiResponseObj)
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    if apiResponseObj.list.count>0
                    {   let splash = SplashModel()
                        for splashobj in apiResponseObj.list
                        {
                            splash.desc =  (splashobj as! NSDictionary).value(forKey: "Description") as! String
                            if(splash.desc.contains("blob"))
                            {
                                splash.type = 1
                            }
                            else
                            {
                                splash.type = 0
                            }
                            
                            self.splashlist1.append(splash)
                        }
                    }
                    
                }
        }
    }
    func showOnboardMasterDataDownloadAlert(message:String)
    {
        let onboard_sb = UIStoryboard(name:onBoardViewSb, bundle: nil)
        let onboard_vc = onboard_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.OnBoardMasterDataAlertVCID) as! MasterDataDownloadAlertViewController
        onboard_vc.message = message
        onboard_vc.providesPresentationContextTransitionStyle = true
        onboard_vc.definesPresentationContext = true
        onboard_vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(onboard_vc, animated: false, completion: nil)
        //self.navigationController?.pushViewController(onboard_vc, animated: true)
    }
    
    func checkMasterDataDownloaded()
    {
        
        if showMasterDataDownloadAlert()
        {
            
            if checkInternetConnectivity()
            {
                BL_MasterDataDownload.sharedInstance.getMasterDataDownloadAlertMessage(completion: { (apiObj) in
                    if apiObj.Status == SERVER_SUCCESS_CODE
                    {
                        if apiObj.list.count > 0
                        {
                            var message = String()
                            for (index,obj) in apiObj.list.enumerated()
                            {
                                let objValue = obj as! [String:Any]
                                let str = objValue["info"] as! String
                                //                                if(index+1 == apiObj.list.count)
                                //                                {
                                //                                    message += "\n" + "\(index+1).)" + str
                                //                                }
                                //                                else
                                //                                {
                                message += "\(index+1).)" + str + "\n"
                                //  }
                                
                                
                            }
                            UserDefaults.standard.set(message, forKey: MasterDataDownloadMessage)
                            self.showOnboardMasterDataDownloadAlert(message: message)
                            
                        }
                        else
                        {
                            BL_MasterDataDownload.sharedInstance.insertCurrentDateMasterDataDownloadCheckAPIStatus()
                            
                        }
                    }
                })
            }
            else
            {
                if BL_MasterDataDownload.sharedInstance.getMasterDataDownloadList().count > 0
                {
                    let mstobj = BL_MasterDataDownload.sharedInstance.getMasterDataDownloadList()[0]
                    if mstobj.Completed_Status == 1
                    {
                        let masterDataDownloadDays = Int(BL_MenuAccess.sharedInstance.getMasterDataDownloadDays())
                        let syncedDate = mstobj.API_Check_Date
                        
                        let differencDate = getNumberOfDaysBetweenTwoDates(firstDate: syncedDate ?? Date(), secondDate: Date())
                        if masterDataDownloadDays == 0
                        {
                            showMasterAlert()
                        }
                        else
                        {
                            if masterDataDownloadDays ?? 0 < differencDate
                            {
                                showMasterAlert()
                                
                            }
                        }
                    }
                }
                else
                {
                    self.showAlertForMasterInternet()
                }
            }
        }
        
        
    }
    
    private func showMasterAlert()
    {
        if let message = UserDefaults.standard.value(forKey: MasterDataDownloadMessage) as? String
        {
            if message.count > 0
            {
                let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    self.showAlertForMasterInternetRedirect()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                self.showAlertForMasterInternet()
            }
        }
        else
        {
            self.showAlertForMasterInternet()
        }
    }
    
    private func showMasterDataDownloadAlert() -> Bool
    {
        if BL_MasterDataDownload.sharedInstance.getMasterDataDownloadList().count > 0
        {
            if let mstobj = BL_MasterDataDownload.sharedInstance.getMasterDataDownloadList()[0] as?MasterDataDownloadCheckModel
            {
                if mstobj.Completed_Status == 1
                {
                    let masterDataDownloadDays = Int(BL_MenuAccess.sharedInstance.getMasterDataDownloadDays())
                    let syncedDate = mstobj.API_Check_Date
                    
                    let differencDate = getNumberOfDaysBetweenTwoDates(firstDate: syncedDate ?? Date(), secondDate: Date())
                    if masterDataDownloadDays == 0
                    {
                        let differDailyDate = getNumberOfDaysBetweenTwoDates(firstDate: mstobj.API_Check_Date, secondDate: Date())
                        if differDailyDate == 0
                        {
                            return false
                        }
                        else
                        {
                            return true
                        }
                    }
                    else
                    {
                        if masterDataDownloadDays ?? 0 < differencDate
                        {
                            return true
                        }
                        else
                        {
                            return false
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    private func showAlertForMasterInternet()
    {
        let alertViewController = UIAlertController(title: nil, message: "Please enable network settings to download the Master Data.", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showAlertForMasterInternetRedirect()
    {
        let alertViewController = UIAlertController(title: nil, message: "Please enable network settings to download the Master Data.", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.showUserSettings()
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func showUserSettings() {
        guard let urlGeneral = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlGeneral)
        }
    }
    
    private func setCollectionViewHeight()
    {
        orientation = UIDevice.current.orientation
        
        if SwifterSwift().isPad || SCREEN_HEIGHT > 650
        {
            self.collectionView.frame.size.height = self.collectionViewHgt.constant
        }
        else
        {
            if orientation == UIDeviceOrientation.landscapeLeft ||   orientation == UIDeviceOrientation.landscapeRight
            {
                self.collectionViewHgt.constant = 173
                //                self.collectionViewHgt.constant = self.view.frame.size.height/2.4
                //            }else if orientation == UIDeviceOrientation.landscapeRight{
                //                self.collectionViewHgt.constant = self.view.frame.size.height/1.7
            }
            else
            {
                self.collectionViewHgt.constant = 219
            }
        }
        self.collectionView.reloadData()
    }
    func setDashboard()
    {
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let existingDashboardAction = UIAlertAction(title: "Existing Dashboard", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            
            
            self.navigateToNextScreen(stoaryBoard: "Dashboard", viewController: "Dashboard")
            
        })
        actionSheetController.addAction(existingDashboardAction)
        
        
        let newDashboardAction = UIAlertAction(title: "New Dashboard", style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            let username = getUserName()
            let password = getUserPassword()
            let companyUrl = getCompanyName()
            let companyName = companyUrl.components(separatedBy: ".")
            let loginData = String(format: "%@/%@/%@", companyName.first!, username, password).data(using: String.Encoding.utf8)!
            let base64LoginData = loginData.base64EncodedString()
            let url = "\(dashboardBaseUrl)" + "\(base64LoginData)"
            //                let decodedData = Data(base64Encoded: base64LoginData)!
            //                let decodedString = String(data: decodedData, encoding: .utf8)!
            //
            //                print(decodedString)
            //
            self.navigateTowebView(siteUrl:url, title: "Dashboard")
        })
        actionSheetController.addAction(newDashboardAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            self.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.webViewTitle = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
        
    }
    
    func onBoardViewDismiss() {
        self.checkAlertRedirection()
    }
    
    func navigateToDCRUpload()
    {
        let navigationController = self.navigationController
        
        if (navigationController != nil)
        {
            let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: DCRUploadVcID) as! DCRUploadController
            navigationController?.pushViewController(vc, animated: true)
            
            removeVersionToastView()
        }
    }
    
    @IBAction func onclick() {
        let sb = UIStoryboard(name: "calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "pevoniaVCid") as! ViewCalendarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UIImageView {
    var imageWithFade:UIImage?{
        get{
            return self.image
        }
        set{
            UIView.transition(with: self,
                              duration: 1.0, options: .transitionCrossDissolve, animations: {
                                self.image = newValue
            }, completion: nil)
        }
    }
}
