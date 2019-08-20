//
//  UserToastView.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class UserToastView: UIView {
    
    var toastText : String = ""
    var textHeight : Int = 0
    
    override func draw(_ rect: CGRect)
    {
        let toastView : UIButton = UIButton()
        toastView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)

        let labelOriginY : CGFloat = 4
        let labelPadding :CGFloat = 20
        let toastLbl : UILabel = UILabel()
        toastLbl.frame = CGRect(x:labelPadding, y:labelOriginY,width:SCREEN_WIDTH - (labelPadding * 2 ),height:CGFloat(textHeight))
        
        toastLbl.font = UIFont(name: fontRegular, size: 15.0)
        toastLbl.textColor = UIColor.white
        toastLbl.textAlignment = NSTextAlignment.center
        toastLbl.backgroundColor = UIColor.clear
        toastLbl.numberOfLines = 0
        toastLbl.font = UIFont(name: fontRegular, size: 11)
        toastLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        toastLbl.text = toastText
        
       
        toastView.addSubview(toastLbl)
        
        let toastHeight = 25 + 8
        toastView.frame = CGRect(x:0, y:0, width:SCREEN_WIDTH,height:CGFloat(toastHeight))
        self.addSubview(toastView)
    }
    
}
