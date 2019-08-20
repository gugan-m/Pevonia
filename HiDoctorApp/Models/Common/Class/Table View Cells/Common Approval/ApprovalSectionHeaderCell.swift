//
//  ApprovalSectionHeaderCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalSectionHeaderCell: UITableViewCell {

    @IBOutlet weak var viewOnMap: UIButton!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var subTitleLabel : UILabel!
    @IBOutlet weak var sectionImgWidthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
