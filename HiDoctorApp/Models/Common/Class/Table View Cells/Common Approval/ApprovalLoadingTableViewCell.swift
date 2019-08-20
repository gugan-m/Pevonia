//
//  ApprovalLoadingTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
