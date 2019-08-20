//
//  NotesCollectionViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 24/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var closeBut: UIButton!

    @IBOutlet weak var fileNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //set corner radius for read label
    }
    
}
