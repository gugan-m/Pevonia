//
//  DoctorAssetTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 01/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorAssetTableViewCell: UITableViewCell
{
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var uniquePagesLbl: UILabel!
    @IBOutlet weak var viewedPagesLbl: UILabel!
    @IBOutlet weak var viewedDurationLbl: UILabel!
    
    @IBOutlet weak var viewedPagesWidthConst: NSLayoutConstraint!
    @IBOutlet weak var viewedPagesTopConst: NSLayoutConstraint!
    @IBOutlet weak var uniquePagesTopConst: NSLayoutConstraint!
    
    @IBOutlet weak var sepView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
