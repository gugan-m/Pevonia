//
//  ModifyAttendanceActivityTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ModifyAttendanceActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var activityTimeLbl: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
