//
//  ApprovalEmptyStateTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalEmptyStateTableViewCell: UITableViewCell {

    
    @IBOutlet weak var emptyStateTiltleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
