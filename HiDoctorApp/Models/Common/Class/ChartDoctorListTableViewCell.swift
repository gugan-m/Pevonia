//
//  ChartDoctorListTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ChartDoctorListTableViewCell: UITableViewCell {

    @IBOutlet weak var userName : UILabel!
    @IBOutlet weak var countLabel : UILabel!
     @IBOutlet weak var descriptionLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countLabel.layer.cornerRadius = 15
        countLabel.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
