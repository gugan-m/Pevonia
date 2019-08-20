//
//  CustomActivityIndicator.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class CustomActivityIndicator: NSObject
{
    static let sharedInstance : CustomActivityIndicator =  CustomActivityIndicator()
    var loadingText : String = ""
    
    func showCustomActivityIndicatorView()
    {
        removeCustomActivityView()
        
        let backGroundView : UIView = UIView()
        backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        backGroundView.tag = 3000
        
        let originX : CGFloat = 20
        let customViewHeight : CGFloat = 70
        let customViewWidth : CGFloat = SCREEN_WIDTH - (2 * originX )
        let originY : CGFloat = (SCREEN_HEIGHT  - customViewHeight ) / 2
        
        let customView : UIView = UIView()
        customView.backgroundColor = UIColor.white
        customView.frame = CGRect(x: originX, y: originY, width: customViewWidth, height: customViewHeight)
        customView.layer.cornerRadius = 10
        
        
        let activitySize : CGFloat = 40
        let activityViewOriginX : CGFloat = 20
        let activityViewOriginY : CGFloat = (customViewHeight - activitySize) / 2
        
        let customActivityView = CustomActivityLoaderView()
        customActivityView.frame = CGRect(x: activityViewOriginX, y: activityViewOriginY, width: activitySize, height: activitySize)
        
        let toastLabel = UILabel()
        toastLabel.textAlignment = NSTextAlignment.left
        toastLabel.font = UIFont(name: fontRegular, size: 14)
        toastLabel.backgroundColor = UIColor.clear
        toastLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        toastLabel.textColor = UIColor.darkGray
        toastLabel.numberOfLines = 0
        toastLabel.text = loadingText
        
        let labelOriginX : CGFloat =  (2 * activityViewOriginX) + activitySize
        let labelWidth = customViewWidth - labelOriginX
        
        toastLabel.frame = CGRect(x: labelOriginX, y: 0, width: labelWidth, height: customViewHeight)
        
        customView.addSubview(customActivityView)
        customView.addSubview(toastLabel)
        
        let appDelegate = getAppDelegate()
        backGroundView.addSubview(customView)
        backGroundView.frame = appDelegate.window!.bounds
        appDelegate.window?.addSubview(backGroundView)
        
    }
    
    
    func hideCustomActivityIndictor()
    {
        if let customActivityView = getAppDelegate().window?.viewWithTag(3000)
        {
            loadingText = ""
            customActivityView.removeFromSuperview()
        }
    }

}
