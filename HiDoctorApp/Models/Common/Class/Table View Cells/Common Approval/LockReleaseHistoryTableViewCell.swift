//
//  LockReleaseHistoryTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LockReleaseHistoryTableViewCell: UITableViewCell
{
    @IBOutlet weak var releasedByValueLabel: UILabel!
    @IBOutlet weak var lockedDateValueLabel: UILabel!
    @IBOutlet weak var actualDateValueLabel: UILabel!
    @IBOutlet weak var releasedDateValueLabel: UILabel!
    @IBOutlet weak var lockTypeValueLabel: UILabel!
    @IBOutlet weak var requestReleaseBy: UILabel!
    @IBOutlet weak var reason: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
