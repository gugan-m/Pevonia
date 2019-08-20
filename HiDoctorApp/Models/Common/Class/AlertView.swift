//
//  AlertView.swift
//  HiDoctorApp
//
//  Created by Vignaya on 10/19/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AlertView: NSObject {
    
    class func showAlertView(title: String?, message: String?)
    {
        let alert: UIAlertController
        
        alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    

    class func showServerSideError()
    {
        self.showAlertView(title: errorTitle, message: serverSideError)
    }
    
    class func showAlertView(title:String?, message:String, viewController:UIViewController)
    {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showNumberExceedAlertView(title: String?, subject : String!, maxVal : Float, viewController : UIViewController)
    {
        let message = String(format: "%@ should not exceed %.f", subject, maxVal)
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showMaxLengthExceedAlertView(title: String?, subject: String!, maxVal : Int, viewController : UIViewController)
    {
        let message = String(format: "No of characters restricted to %d for %@", maxVal, subject)
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showSpecialCharacterAlertview(title: String?, subject: String!, restrictedVal : String, viewController : UIViewController)
    {
        let message = String(format: "%@ characters restricted for %@", restrictedVal, subject)
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showNoInternetAlert()
    {
        let alertViewController = UIAlertController (title: internetOfflineTitle, message: internetOfflineMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showAlertToEnableGPS()
    {
        let alertViewController = UIAlertController (title: networkDisabledTitle, message: networkDisabledMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: nil))
        alertViewController.addAction(UIAlertAction(title: settings, style: UIAlertActionStyle.default, handler: { alertAction in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
            {
                UIApplication.shared.openURL(appSettings as URL)
            }
            
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showAlertToCaptureGPS()
    {
        let alertViewController = UIAlertController (title: networkDisabledTitle, message: networkDisabledMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: retry, style: UIAlertActionStyle.cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    class func showAlertToEnablePhotoAccess()
    {
        let alertViewController = UIAlertController (title: nil, message: photoDisabledMsg, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: nil))
        alertViewController.addAction(UIAlertAction(title: settings, style: UIAlertActionStyle.default, handler: { alertAction in
            if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
            {
                UIApplication.shared.openURL(appSettings as URL)
            }
            
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
}
