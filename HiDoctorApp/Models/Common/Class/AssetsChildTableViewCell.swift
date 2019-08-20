//
//  AssetsChildTableViewCell.swift
//  HiDoctorApp
//
//  Created by Admin on 5/25/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsChildTableViewCell: UITableViewCell {

    @IBOutlet weak var indexView: RoundedCornerRadiusView!
    
    @IBOutlet weak var thumbNailImgVw: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var assetContainerView: UIView!

    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var imgVwleadingCnst: NSLayoutConstraint!
    
    @IBOutlet weak var storyImgVw: UIImageView!
    @IBOutlet weak var storytitleLabel: UILabel!
    @IBOutlet weak var storySubtitleLabel: UILabel!
    
    @IBOutlet weak var storyContainerView: UIView!
    
    @IBOutlet weak var expiryDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class AssetStorySectionTableViewCell : UITableViewCell
{
    @IBOutlet weak var assetNameLbl : UILabel!
    @IBOutlet weak var assetCountLbl : UILabel!
    @IBOutlet weak var menuBtn: MyButton!
    @IBOutlet weak var checkMarkImgVw: UIImageView!
    
    @IBOutlet weak var trailingImgVwCnst: NSLayoutConstraint!
    
    @IBOutlet weak var targetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkMarkImgVw.frame.size.width = 0
        trailingImgVwCnst.constant = 0
        
    }
    
}
