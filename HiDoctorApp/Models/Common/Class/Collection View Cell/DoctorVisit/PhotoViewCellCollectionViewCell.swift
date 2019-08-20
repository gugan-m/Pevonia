//
//  PhotoViewCellCollectionViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class PhotoViewCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img : UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet var lblHgtConst: NSLayoutConstraint!
    @IBOutlet weak var countLbl : UILabel!
}
