//
//  ApprovalTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/22/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalTableViewCell: UITableViewCell {

    @IBOutlet weak var approvalCountLbl: UILabel!
    @IBOutlet weak var approvalActivity: UIActivityIndicatorView!
    @IBOutlet weak var approvalTitleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var rightArrowImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        approvalCountLbl.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
