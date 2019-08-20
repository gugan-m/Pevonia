//
//  DCRStepperCommonTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRStepperCommonTableViewCell: UITableViewCell
{
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    
    override func awakeFromNib()
    {
        line2Label.adjustsFontSizeToFitWidth = true
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}

class DCRStepperRemarksTableViewCell: UITableViewCell
{
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
