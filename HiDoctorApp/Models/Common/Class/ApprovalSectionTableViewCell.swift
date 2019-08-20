//
//  ApprovalSectionTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/23/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionContentView: UIView!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
