//
//  splashAlert.swift
//  HiDoctorApp
//
//  Created by Swaas on 05/03/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

extension UIAlertController{
    func addImage(image: UIImage)
    {
        
        let maxsize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        var ratio: CGFloat!
        if(imgSize.width > imgSize.height)
        {
            ratio = maxsize.width / imgSize.width
        }
        else
        {
            ratio = maxsize.height / imgSize.height
        }
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        
        if (imgSize.height > imgSize.width)
        {
            let left = (maxsize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}
