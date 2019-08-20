//
//  ApprovalDoctorDetailSubTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalDoctorDetailSubTableViewCell: UITableViewCell {

    @IBOutlet weak var moreBut: UILabel!
    @IBOutlet weak var moreLblHeight: NSLayoutConstraint!
    @IBOutlet weak var line2Lbl: UILabel!
    @IBOutlet weak var line1Lbl: UILabel!
    @IBOutlet weak var imgWidthConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
