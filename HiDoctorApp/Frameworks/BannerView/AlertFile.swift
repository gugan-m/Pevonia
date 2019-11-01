//
//  AlertFile.swift
//  sampleBanner
//
//  Created by Kamaraj on 24/01/18.
//  Copyright © 2018 Kamaraj. All rights reserved.
//

import Foundation
import UIKit

var banner : Banner! = nil

struct BannerColors {
    static let red = UIColor(red:198.0/255.0, green:26.00/255.0, blue:27.0/255.0, alpha:1.000)
    static let green = UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000)
    static let yellow = UIColor(red:23.0/255.0, green:72.0/255.0, blue:122.0/255.0, alpha:1.000)
    static let blue = UIColor(red:31.0/255.0, green:136.0/255.0, blue:255.0/255.0, alpha:1.000)
}
func showBanner(title:String,subTitle:String,bgColor:UIColor)
{
    banner = Banner(title: title, subtitle: subTitle, image: UIImage(named: "Icon"), backgroundColor:bgColor)
    banner.dismissesOnTap = false
    banner.show()
}

func showBanner(title:String,subTitle:String,color:UIColor)
{
    banner = Banner(title: title, subtitle: "Digital Resource Downloaded", image: UIImage(named: "Icon"), backgroundColor:color)
    banner.dismissesOnTap = false
    banner.show(duration: 3.0)
}

func ifBannerIntialized() -> Bool
{
    if(banner != nil)
    {
        return true
    }
    else
    {
        return false
    }
}

func dismissBanner()
{
    banner.dismiss()
    banner = nil
}

func bannerTitle(title:String)
{
    banner.detailLabel.text = title
}

func bannerBgColor(color : UIColor)
{
    banner.backgroundColor = color
}
