//
//  AppDelegate.swift
//  HiDoctorApp
//
//  Created by SwaaS on 13/10/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import CoreLocation
import Fabric
import Crashlytics
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate
{
    var window: UIWindow?
    var root_navigation: UINavigationController!
    private var reachability:Reachability!
    var locationManager = CLLocationManager()
    //var sharedApp: UIApplication!
    var bgLocationManager = CLLocationManager()
    var backgroundUploadTaskId: UIBackgroundTaskIdentifier!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //sharedApp = application
        
        // Location manager
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        startUpdatingLocations()
        
        addInternetCheckObserver()
        
        try! setupDatabase(application)
        
        Fabric.with([Crashlytics.self])
        
        IQKeyboardManager.shared.enable = true
        createDirectoryFolders()
        
        // Google maps key
        GMSServices.provideAPIKey("AIzaSyAm9ysNAM7PrFZtmMGJJxLMqaCY6c_USUM")
        GMSPlacesClient.provideAPIKey("AIzaSyAm9ysNAM7PrFZtmMGJJxLMqaCY6c_USUM")
        
        // NavigationBar Custom Settings
        UINavigationBar.appearance().barTintColor = brandColor
        UINavigationBar.appearance().tintColor = navigationBarText
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : navigationBarText]
        //UINavigationBar.appearance().setBackgroundImage(imageWithColor(color: brandColor), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        checkAppStatusAndLoadViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication)
    {
        NotificationCenter.default.post(name: Notification.Name("appEnteredBackground"), object: nil)
        stopUpdatingLocations()
        removeCustomActivityView()
        removeApprovalPopUp()
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        NotificationCenter.default.post(name: Notification.Name("appEnteredForeground"), object: nil)
        addInternetCheckObserver()
        startUpdatingLocations()
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        startUpdatingLocations()
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
           NotificationCenter.default.post(name: Notification.Name("appEnteredBackground"), object: nil)

        stopUpdatingLocations()
    }
    
    //MARK :- Internet Connection Methods
    func addInternetCheckObserver()
    {
        reachability = Reachability.reachabilityForInternetConnection()!
        
        if reachability != nil
        {
            networkStatus = reachability.isReachable()
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.checkForReachability), name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil);
        
        _ = reachability.startNotifier()
    }
    
    @objc func checkForReachability(notification:NSNotification)
    {
        if let networkReachability = notification.object as? Reachability
        {
            networkStatus = networkReachability.isReachable()
            
            if networkStatus
            {
                startUpdatingLocations()
                
                // Resume the attachment operation
                if BL_AttachmentOperation.sharedInstance.statusList.count == 0
                {
                    BL_AttachmentOperation.sharedInstance.initiateOperation()
                }
                
//                if BL_Leave_AttachmentOperation.sharedInstance.statusList.count == 0
//                {
//                    BL_Leave_AttachmentOperation.sharedInstance.initiateOperation()
//                }
                
                if (BL_Chemist_AttachmentOperation.sharedInstance.statusList.count == 0)
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "assetDownloadObserver"), object: nil)
                    BL_Chemist_AttachmentOperation.sharedInstance.initiateOperation()
                }
                
                // Resume the Asset download operation
                if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
                {
                    BL_AssetDownloadOperation.sharedInstance.initiateOperation()
                }
                
//                //Resume the Upload asset analytics operation
//                if BL_UploadAnalytics.sharedInstance.statusList.count == 0
//                {
//                    BL_UploadAnalytics.sharedInstance.uploadAssetAnalytics()
//                }
//
//                //Resume the Upload feedback operation
//                if BL_UploadFeedback.sharedInstance.statusList.count == 0
//                {
//                    BL_UploadFeedback.sharedInstance.uploadFeedbackAnalytics()
//                }
//
//                //Resume the Upload Doctor visit feedback operation
//                if BL_UploadFeedback.sharedInstance.statusList.count == 0
//                {
//                    BL_UploadDoctorVisitFeedback.sharedInstance.uploadDoctorVisitFeedback()
//                }
            }
        }
    }
    
    //MARK :- Root View Controller
    func allocateRootViewController(sbName : String , vcName : String)
    {
        let root_sb = UIStoryboard(name: sbName, bundle: nil)
        let root_vc = root_sb.instantiateViewController(withIdentifier: vcName) as UIViewController
        root_navigation = UINavigationController(rootViewController: root_vc)
        loadRootViewController()
    }
    
    func allocatePrepareAsRoot()
    {
        let root_sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
        let root_vc = root_sb.instantiateViewController(withIdentifier: PrepareDeviceVcID) as! PrepareMyDeviceViewController
        root_vc.isComingFromCompanyLogin = true
        root_navigation = UINavigationController(rootViewController: root_vc)
    
        loadRootViewController()
    }
    
    func allocateConductAsRoot()
    {
        let root_sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
        let root_vc = root_sb.instantiateViewController(withIdentifier: CodeOfConductViewControllerID) as! CodeOfConductViewController
        root_vc.isComingFromCompanyLogin = true
        root_navigation = UINavigationController(rootViewController: root_vc)
        
        loadRootViewController()
    }
    
    func loadRootViewController()
    {
        window?.rootViewController = root_navigation
        window?.makeKeyAndVisible()
    }
    
    func checkAppStatusAndLoadViewController()
    {
        let appStatus = checkAppStatus()
     
        // Load View Controllers
        
        if (appStatus == AppStatusEnum.HOME)
        {
            BL_InitialSetup.sharedInstance.doInitialSetUp()
            
            allocateRootViewController(sbName: landingViewSb, vcName:landingVcID)
            
            // Resume the attachment operation
            if BL_AttachmentOperation.sharedInstance.statusList.count == 0
            {
                BL_AttachmentOperation.sharedInstance.initiateOperation()
            }
            
            if (BL_Chemist_AttachmentOperation.sharedInstance.statusList.count == 0)
            {
                BL_Chemist_AttachmentOperation.sharedInstance.initiateOperation()
            }
            
//            if BL_Leave_AttachmentOperation.sharedInstance.statusList.count == 0
//            {
//                BL_Leave_AttachmentOperation.sharedInstance.initiateOperation()
//            }
            
            // Resume the Asset download operation
            if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
            {
                let filteredAssetList : [AssetHeader] = DBHelper.sharedInstance.getAssetsByInProgressStatus(downloadStatus: isFileDownloaded.progress.rawValue)
                BL_AssetDownloadOperation.sharedInstance.totalAssetCount = filteredAssetList.count
                BL_AssetDownloadOperation.sharedInstance.initiateOperation()
            }
        }
        else if (appStatus == AppStatusEnum.PMD_PENDING)
        {
           
                BL_InitialSetup.sharedInstance.doInitialSetUp()
                self.allocateRootViewController(sbName: landingViewSb, vcName:Constants.ViewControllerNames.PreparePendingDeviceVcID)
           
        }
        else if (appStatus == AppStatusEnum.Login)
        {
            BL_Logout.sharedInstance.clearAllLocalNotifications()
            allocateRootViewController(sbName: mainSb, vcName:companyVC)
        }
        else if (appStatus == AppStatusEnum.PMD)
        {
            BL_InitialSetup.sharedInstance.setUserAndCompanyDetails()
            
            
            
            BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
                if(response)
                {
                    self.allocateRootViewController(sbName: prepareMyDeviceSb, vcName:CodeOfConductViewControllerID)
                }
                else
                {
                    self.allocateRootViewController(sbName: prepareMyDeviceSb, vcName:PrepareDeviceVcID)
                }
            }
           
        }
        else if (appStatus == AppStatusEnum.PMD_ACCOMPANIST)
        {
            BL_InitialSetup.sharedInstance.doInitialSetUp()
            
            let root_sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
            let root_vc = root_sb.instantiateViewController(withIdentifier: PrepareDeviceVcID) as! PrepareMyDeviceViewController
            
            root_vc.isComingFromAccompanistPage = true
            root_vc.isComingFromAppDelegate = true
            root_navigation = UINavigationController(rootViewController: root_vc)
            
            loadRootViewController()
        }
    }
    
    // MARK: - Current location delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let locValue = manager.location
        {
            currentLat = String(locValue.coordinate.latitude)
            currentLong = String(locValue.coordinate.longitude)
        }
    }
    
    func startUpdatingLocations()
    {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    private func stopUpdatingLocations()
    {
        locationManager.stopUpdatingLocation()
    }
    
    //MARK:- Document directory - Create Parent folder
    func createDirectoryFolders()
    {
        createParentFolder(folderName: Constants.DirectoryFolders.assetFolder)
        createParentFolder(folderName: Constants.DirectoryFolders.attachmentFolder)
        createParentFolder(folderName: Constants.DirectoryFolders.noticeboardAttachmentFolder)
        createParentFolder(folderName: Constants.DirectoryFolders.mailAttachmentFolder)
        createParentFolder(folderName: Constants.DirectoryFolders.doctorProfileFolder)
        createSubfolder(parentFolderName: Constants.DirectoryFolders.assetFolder, subFolderName: Constants.SubDirectories.PDFCache)
    }
    
    private func createParentFolder(folderName: String)
    {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let attachmentDirectoryPath = documentDirectoryPath.appending("/\(folderName)")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: attachmentDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: attachmentDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating Parent folder in documents dir: \(error)")
                }
            }
        }
    }
    
    //MARK:- Document directory - Create Subfolder folder
    func createSubfolder(parentFolderName: String, subFolderName: String)
    {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let attachmentDirectoryPath = documentDirectoryPath.appending("/\(parentFolderName)/\(subFolderName)")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: attachmentDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: attachmentDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating Subfolder in documents dir: \(error)")
                }
            }
        }
    }
}
extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            break;
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            break;
            
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
            break;
        }
        
    }
    
}
