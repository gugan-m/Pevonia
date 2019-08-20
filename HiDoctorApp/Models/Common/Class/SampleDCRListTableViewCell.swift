//
//  SampleDCRListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class SampleDCRListTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl : UILabel!
    @IBOutlet weak var productCountLbl : UILabel!
    @IBOutlet weak var upButton : UIButton!
    @IBOutlet weak var downButton : UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var sepViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var outerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
