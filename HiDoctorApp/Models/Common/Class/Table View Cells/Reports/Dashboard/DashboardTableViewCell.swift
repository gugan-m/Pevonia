//
//  DashboardTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell
{
    @IBOutlet weak var entityNameLabel: UILabel!
    @IBOutlet weak var entityValueLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var coverButton: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
