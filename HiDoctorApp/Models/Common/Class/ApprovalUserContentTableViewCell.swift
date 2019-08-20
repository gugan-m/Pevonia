//
//  ApprovalUserContentTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/28/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalUserContentTableViewCell: UITableViewCell {

    @IBOutlet weak var userCount: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userDesignation: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // userCount.layer.cornerRadius = (userCount.frame.width)/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
