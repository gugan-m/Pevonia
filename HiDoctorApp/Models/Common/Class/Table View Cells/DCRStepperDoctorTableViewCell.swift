//
//  DCRStepperDoctorTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRStepperDoctorTableViewCell: UITableViewCell
{
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var visitTimeLabel: UILabel!
    @IBOutlet weak var line1Text: UILabel!
    @IBOutlet weak var line2Text: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
    
