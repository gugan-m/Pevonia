//
//  DoctorVisitStepperCommon.swift
//  HiDoctorApp
//
//  Created by Vijay on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorVisitStepperCommon: UITableViewCell {
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreButHeightConstraints: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DoctorVisitAsset: UITableViewCell {
    
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var line3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
