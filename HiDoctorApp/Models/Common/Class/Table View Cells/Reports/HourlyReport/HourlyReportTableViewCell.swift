//
//  HourlyReportTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportTableViewCell: UITableViewCell
{
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var visitDateAndTimeLbl: UILabel!
    
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

class HourlyReportDetailTableViewCell: UITableViewCell
{
    @IBOutlet weak var enteredDateTimeLabel: UILabel!
    @IBOutlet weak var syncUpDateTimeLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var latitudeLongitudeLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
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
