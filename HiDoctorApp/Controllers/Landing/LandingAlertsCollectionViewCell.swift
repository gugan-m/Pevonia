//
//  LandingAlertsCollectionViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LandingAlertsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countView: RoundedCornerRadiusView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pendingLblCount: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var imgVerticalConst: NSLayoutConstraint!
}
