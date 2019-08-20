//
//  DCRStepperSFCTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRStepperSFCTableViewCell: UITableViewCell
{
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var toPlaceLabel: UILabel!
    @IBOutlet weak var distancePlaceLabel: UILabel!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var trendLabel: UILabel!
    @IBOutlet weak var regionName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
