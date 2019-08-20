//
//  LandingCollectionViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 03/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class LandingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgWidthConst: NSLayoutConstraint!
    @IBOutlet weak var pendingCountLbl: UILabel!
    @IBOutlet weak var batchTextHgtConstr: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgVerticalConstraint: NSLayoutConstraint!
}
