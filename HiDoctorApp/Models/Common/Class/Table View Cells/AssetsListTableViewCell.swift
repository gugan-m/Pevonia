//
//  AssetsListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsListTableViewCell: UITableViewCell
{
     @IBOutlet weak var onlineImg: UIImageView!
    @IBOutlet weak var assetsImg: UIImageView!
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetsDetailLbl: UILabel!
    @IBOutlet weak var menuBtn: MyButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var videoPlayBackView: NSLayoutConstraint!
    @IBOutlet weak var videoPlayBackTimeLbl: UILabel!
    @IBOutlet weak var activityIndicatorWidth : NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkMarkImgVw: UIImageView!
    
    @IBOutlet weak var indexView: RoundedCornerRadiusView!
    
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var imgVwWidthCnst: NSLayoutConstraint!
    
    @IBOutlet weak var imgVwHgtCnst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.checkMarkImgVw.isHidden = true
        
        if SwifterSwift().isPhone{
            self.imgVwHgtCnst?.constant = 70
            self.imgVwWidthCnst?.constant = 105
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
