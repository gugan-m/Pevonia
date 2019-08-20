//
//  LandingDetailTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LandingDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var doctorName: UILabel!
    
    @IBOutlet weak var doctorDetail: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
