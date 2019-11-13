//
//  GroupEdetailingCell.swift
//  HiDoctorApp
//
//  Created by SSPLLAP-011 on 07/11/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class GroupEdetailingCell: UITableViewCell {

    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPosition: UILabel!
    @IBOutlet weak var imgViewSelected: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
