//
//  TPUploadDetailsTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPUploadDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var imageviewCalendar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
