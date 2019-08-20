//
//  ApprovalMonthListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalMonthListTableViewCell: UITableViewCell {

    @IBOutlet weak var monthNameLbl: UILabel!
    @IBOutlet weak var monthCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
