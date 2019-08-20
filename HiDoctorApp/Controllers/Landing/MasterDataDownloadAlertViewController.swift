//
//  MasterDataDownloadAlertViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 24/01/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class MasterDataDownloadAlertViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    var message = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setDefaults()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downloadMasterData(_ sender: Any) {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self) { (objApiResponse) in
                removeCustomActivityView()
                if objApiResponse.list.count > 0
                {
                    self.navigateToAutoDownload()
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        BL_MasterDataDownload.sharedInstance.updateSkipCountMasterDataDownloadCheck()
         self.dismiss(animated: false, completion: nil)
    }
    
    func setDefaults()
    {
        let show = BL_MasterDataDownload.sharedInstance.showSkipButtonInMasterDataDownload()
        self.cancelButton.isHidden = !show
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.showDownloadAlert()
        }))
        self.present(alert, animated: true, completion: nil)
        
      //  if message != EMPTY
      //  {
//            let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
//            
//            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
//                if checkInternetConnectivity()
//                {
//                    showCustomActivityIndicatorView(loadingText: authenticationTxt)
//                    BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self) { (objApiResponse) in
//                        removeCustomActivityView()
//                        if objApiResponse.list.count > 0
//                        {
//                            self.navigateToAutoDownload()
//                        }
//                    }
//                }
//                else
//                {
//                    AlertView.showNoInternetAlert()
//                }
//            }))
//            
//            
//            
//            self.present(alertViewController, animated: true, completion: nil)
            
//            let alertViewController = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
//
//                if checkInternetConnectivity()
//                {
//                    showCustomActivityIndicatorView(loadingText: authenticationTxt)
//                    BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self) { (objApiResponse) in
//                        removeCustomActivityView()
//                        if objApiResponse.list.count > 0
//                        {
//                            self.navigateToAutoDownload()
//                        }
//                    }
//                }
//                else
//                {
//                    AlertView.showNoInternetAlert()
//                }
//
//                alertViewController.dismiss(animated: true, completion: nil)
//            }))
//
//            self.present(alertViewController, animated: true, completion: nil)
    //    }
    }
    
    func navigateToAutoDownload()
    {
        BL_MasterDataDownload.sharedInstance.autoDownload = true
        let landingSb = UIStoryboard(name:landingViewSb, bundle: nil)
        let VC1 = landingSb.instantiateViewController(withIdentifier: landingVcID)
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:false, completion: nil)
        
        let sb = UIStoryboard(name:prepareMyDeviceSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: masterDataVcID) as! MasterDataDownloadViewController
        vc.autoDownloadMasterData = true
        VC1.navigationController?.pushViewController(vc, animated: true)

    }
    
    func showDownloadAlert()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self) { (objApiResponse) in
                removeCustomActivityView()
                if objApiResponse.list.count > 0
                {
                    self.navigateToAutoDownload()
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
}
