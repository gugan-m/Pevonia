//
//  PreparePendingDeviceViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 24/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class PreparePendingDeviceViewController: UIViewController
{
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var userTypeLbl : UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var ErrorBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var apiStatusLbl: UILabel!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateView : UIView!
    
    var versionUpgradeList: [VersionUpgradeModel] = []
    var index: Int = 0
    var companyDict: NSDictionary = [:]
    var userName: String!
    var password: String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        activityIndicator.isHidden = true
        self.showIndicatorView(show: false)
        self.showErrorBtn(show: false)
        self.setDefaultDetails()
//        let companyLogoURL = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Logo_Url") as? String)
//        self.saveImageToFile(image: self.companyLogo.image!)
//
//        if let checkedUrl = URL(string: companyLogoURL)
//        {
//            downloadImage(url: checkedUrl)
//        }
        showDownloadData()
        setCompanyLogo()
        
        userName = condenseWhitespace(stringValue: getUserName())
        password = condenseWhitespace(stringValue: getUserPassword())
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    //MARK:- Private function
    
    private func showDownloadData()
    {
        let alertViewController = UIAlertController(title: nil, message: Display_Messages.LOGIN_DATA_DOWNLOAD.DATA_DOWNLOAD_ALERT, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            
            self.checkInternetConnection()
            self.activityIndicator.isHidden = false
            self.showIndicatorView(show: true)
            self.setDefaultDetails()
            showVersionToastView(textColor : UIColor.white)
            
            self.checkUserAuthentication(userName: self.userName, password: self.password)
            
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showIndicatorView(show:Bool)
    {
        if show
        {
            self.activityIndicator.startAnimating()
        }
        else
        {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func checkInternetConnection()
    {
        if checkInternetConnectivity()
        {
            showEmptyStateView(show : false)
            
            self.versionUpgradeList.removeAll()
            self.versionUpgradeList = BL_Version_Upgrade.sharedInstance.getIncompleteVersionUpgrades()
            
            if (self.versionUpgradeList.count > 0)
            {
                self.index = 0
                doVersionUpgrade()
            }
            else
            {
                self.moveToHomePage()
            }
        }
        else
        {
            showEmptyStateView(show : true)
        }
    }
    
    private func showNoInternetAlert()
    {
         AlertView.showNoInternetAlert()
    }
    
    private func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    private func showErrorBtn(show:Bool)
    {
        if show
        {
            self.ErrorBtnHeightConst.constant = 50
            self.loadingLbl.text = ""
        }
        else
        {
            self.ErrorBtnHeightConst.constant = 0
            self.loadingLbl.text = "Preparing your device please wait..."
        }
        
        hideActivityIndicator(hide: show)
    }
    
    private func hideActivityIndicator(hide : Bool)
    {
        self.activityIndicator.isHidden = hide
    }
    
    private func setDefaultDetails()
    {
        var userName : String = ""
        var regionName : String = ""
        var userTypeName : String = ""
        var companyName : String = ""
        
        let userObj = getUserModelObj()
        
        if userObj != nil
        {
            userName = (userObj?.User_Name)!
            regionName = (userObj?.Region_Name)!
            userTypeName = (userObj?.User_Type_Name)!
        }
        
        let companyObj = DBHelper.sharedInstance.getCompanyDetails()
        companyName = (companyObj?.companyName)!
        
        self.userTypeLbl.text = "\(regionName)(\(userTypeName))"
        self.userNameLbl.text = userName.uppercased()
        self.companyNameLbl.text = companyName
        
        //setCompanyLogo()
    }
    
    private func downloadImage(url: URL)
    {
        WebServiceWrapper.sharedInstance.getDataFromUrl(url: url)
        {(data) in
            if data != nil
            {
                self.companyLogo.contentMode = .scaleAspectFit
                self.companyLogo.image = UIImage(data: data!)
                self.saveImageToFile(image: self.companyLogo.image!)
            }
        }
    }
    func saveImageToFile(image:UIImage)
    {
        let filePath = fileInDocumentsDirectory(filename: ImageFileName.companyLogo.rawValue)
        saveImage(image: image, path: filePath)
    }
    
    func getUserName() -> String
    {
        return BL_InitialSetup.sharedInstance.userName
    }
    
    func getUserPassword() -> String
    {
        return BL_InitialSetup.sharedInstance.password
    }
    
    
    func checkUserAuthentication(userName: String, password: String)
    {
        if checkInternetConnectivity()
        {
            //self.showActivityIndicator()
            let companyCode = BL_InitialSetup.sharedInstance.companyCode
            
            WebServiceHelper.sharedInstance.postUserDetails(companyCode: companyCode!, userName: userName, password: password, isVersionCode: true, completion: checkUserAuthenticationCallback)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    
    private func checkUserAuthenticationCallback(apiResponseObj: ApiResponseModel)
    {
        let listArray:NSArray = apiResponseObj.list
        if listArray.count > 0
    
        {
            let userDict:NSDictionary = listArray.firstObject as! NSDictionary
    
            var divisionCode = checkNullAndNilValueForString(stringData: userDict.value(forKey: "Division_Code") as? String)
    
            divisionCode = divisionCode.trimmingCharacters(in: .whitespacesAndNewlines)
    
           // let companyUrl = checkNullAndNilValueForString(stringData: companyDict.value(forKey: "Company_Url") as? String)
             let companyObj = DBHelper.sharedInstance.getCompanyDetails()
             let companyUrl = companyObj!.companyURL
    
            if !divisionCode.contains(",")
    
            {
                let FinalUrl = "https://\(companyUrl!)/Images/Company_Logo/\(companyUrl!)_\(divisionCode).jpg"
    
                if let checkedUrl = URL(string: FinalUrl)
    
                {
    
                    downloadImage(url: checkedUrl)
                }
            }
    
    }
    
    }
    
    
    private func setCompanyLogo()
    {
        let filePath = fileInDocumentsDirectory(filename: ImageFileName.companyLogo.rawValue)
        if let loadedImage = loadImageFromPath(path: filePath)
        {
            self.companyLogo.image = loadedImage
        }
    }
    
    private func setApiStatusLbl(statusMsg : String)
    {
        self.apiStatusLbl.text = statusMsg
    }
    
    private func doVersionUpgrade()
    {
        if (checkInternetConnectivity())
        {
            let objVersionUpgrade = versionUpgradeList[index]
            self.setApiStatusLbl(statusMsg : "System is downloading necessary data for the updated version. Please wait...")
            
            if (objVersionUpgrade.Version_Number == DatabaseMigrationString.version2.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForV2(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.eDetailingVersion.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForV3(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.eDetailingVersion2.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForV4(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.TPVersion.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForTPVersion(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.FDC_Pilot.rawValue)
            {
                self.checkUserHasAnyActiveSession()
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.ChemistDay.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForChemistDayVersion(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.AlertBuild.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.doVersionUpgradeForAlertBuildVersion(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.PasswordPolicy.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForPasswordPolicyBuild(versionNumber: objVersionUpgrade.Version_Number, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.DOCTORPOB.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForDoctorPOBBuild(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.DOCTORINHERITANCE.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForInheritanceBuild(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.ICE.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForICEBuild(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.HOURLY_REPORT_CHANGE.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForHourlyReportChanges(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.SAMPLEBATCH.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForSampleBatchChanges(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.INWARDBATCH.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForInwardBatchChanges(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.ATTENDANCEACTIVITY.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForAttendanceActivityChanges(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.ACCOMPANISTCHANGE.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForAccompanistChanges(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else if (objVersionUpgrade.Version_Number == DatabaseMigrationString.MCINDOCTORVISIT.rawValue)
            {
                BL_Version_Upgrade.sharedInstance.versionUpgradeForMCInDoctorVistSection(versionNumber: objVersionUpgrade.Version_Number, viewController: self, completion: { (status) in
                    self.doVersionUpgradeCallBack(statusCode: status, versionNumber: objVersionUpgrade.Version_Number)
                })
            }
            else
            {
                self.doVersionUpgradeCallBack(statusCode: SERVER_SUCCESS_CODE, versionNumber: objVersionUpgrade.Version_Number)
            }
        }
        else
        {
            self.setApiStatusLbl(statusMsg :internetOfflineMessage)
            self.showErrorBtn(show: true)
        }
    }
    
    private func doVersionUpgradeCallBack(statusCode: Int, versionNumber: String)
    {
        if (statusCode == SERVER_SUCCESS_CODE)
        {
            index += 1
            
            if (index < self.versionUpgradeList.count)
            {
                doVersionUpgrade()
            }
            else
            {
                BL_InitialSetup.sharedInstance.doInitialSetUp()
                
                BL_Password.sharedInstance.getUserAccountDetailsForPMD(viewController: self, completion: { (serverTime) in
                    self.showIndicatorView(show: false)
                    self.setApiStatusLbl(statusMsg:"System has successfully downloaded all necessary data")
                    
                    self.checkPasswordPolicy(serverTime: serverTime)
                })
            }
        }
        else
        {
            let statusMsg =  self.getErrorMessageForStatus(statusCode: statusCode, dataName: "System")
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    private func moveToHomePage()
    {
        let delayTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.navigationController?.isNavigationBarHidden = false
            let appDelegate = getAppDelegate()
            appDelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
        }
    }
    
    private func checkPasswordPolicy(serverTime: String)
    {
        let delayTime = DispatchTime.now() + 1
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            BL_Password.sharedInstance.checkPasswordStatusForPMD(viewController: self, serverTime: serverTime)
        }
    }

    private func checkUserHasAnyActiveSession()
    {
        if (checkInternetConnectivity())
        {
            showIndicatorView(show: true)
            
            let companyCode = getCompanyCode()
            let companyId = getCompanyId()
            let userCode = getUserCode()
            
            WebServiceHelper.sharedInstance.checkUserSessionExist(companyCode: companyCode, companyId: companyId, userCode: userCode, completion: { (objApiResponse) in
                
                self.showIndicatorView(show: false)
                
                if (objApiResponse.Status == -1)
                {
                    self.showMultiLoginAlert()
                }
                else if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    DBHelper.sharedInstance.updateSessionId(sessionId: objApiResponse.Count)
                    
                    self.showIndicatorView(show: true)
                    
                    BL_Version_Upgrade.sharedInstance.doVersionUpgradeForFDCPilotVersion(versionNumber: DatabaseMigrationString.FDC_Pilot.rawValue, completion: { (status) in
                        self.doVersionUpgradeCallBack(statusCode: status, versionNumber: DatabaseMigrationString.FDC_Pilot.rawValue)
                    })
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Sorry. Unable to upgrade to new version", viewController: self)
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func showMultiLoginAlert()
    {
        let alertMessage =  "It seems that you have already logged in with one or more other devices. \n\n Please upload all your pending DVRs and PRs before using this device. \n\n Tap 'PROCEED' to clear logins on other devices and use only this device. \n\n Tap 'CANCEL' to cancel."
        
        let alertViewController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "PROCEED", style: UIAlertActionStyle.default, handler: { alertAction in
            self.clearAllPreviousSessions()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func popViewController(animated: Bool)
    {
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    private func clearAllPreviousSessions()
    {
        if (checkInternetConnectivity())
        {
            showIndicatorView(show: true)
            
            let companyCode = getCompanyCode()
            let companyId = getCompanyId()
            let userCode = getUserCode()
            
            WebServiceHelper.sharedInstance.clearAllSessions(companyCode: companyCode, companyId: companyId, userCode: userCode) { (objApiResponse) in
                
                self.showIndicatorView(show: false)
                
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    self.checkUserHasAnyActiveSession()
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Sorry. Unable to upgrade to new version", viewController: self)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    //MARK: - Status
    func getErrorMessageForStatus(statusCode: Int, dataName: String) -> String
    {
        if (statusCode == SERVER_SUCCESS_CODE)
        {
            return "\(dataName) downloaded"
        }
        else if (statusCode == SERVER_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return "Server error while downloading \(dataName) data. Please try again"
        }
        else if (statusCode == NO_INTERNET_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return internetOfflineMessage
        }
        else if (statusCode == LOCAL_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return "Unable to process \(dataName) data. Please try again"
        }
        else
        {
            return ""
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func errorBtnAction(_ sender: AnyObject)
    {
        if checkInternetConnectivity()
        {
            showErrorBtn(show : false)
            setApiStatusLbl(statusMsg : "")
            checkInternetConnection()
        }
        else
        {
            showNoInternetAlert()
        }
    }
    
    @IBAction func emptyStateErrorBtnAction(_ sender: AnyObject)
    {
        if checkInternetConnectivity()
        {
            showEmptyStateView(show : false)
            checkInternetConnection()
        }
        else
        {
            showEmptyStateView(show : true)
        }
    }
}
