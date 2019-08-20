//
//  HourlyReportDoctorListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportDoctorListTableViewCell: UITableViewCell
{

    @IBOutlet weak var doctorNameLbl : UILabel!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var designationLbl : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
