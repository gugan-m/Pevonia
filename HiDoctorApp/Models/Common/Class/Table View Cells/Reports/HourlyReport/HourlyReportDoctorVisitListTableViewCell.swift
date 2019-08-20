//
//  HourlyReportDoctorVisitListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportDoctorVisitListTableViewCell: UITableViewCell
{

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var visitCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
