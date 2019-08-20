//
//  ReportsTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/12/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var nextRightArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
