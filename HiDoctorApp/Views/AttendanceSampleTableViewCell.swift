//
//  AttendanceSampleTableViewCell.swift
//  HiDoctorApp
//
//  Created by Swaas on 27/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AttendanceSampleTableViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
