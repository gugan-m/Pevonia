//
//  TPAccompanistTableViewCell.swift
//  HiDoctorApp
//
//  Created by Admin on 7/25/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPAccompanistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var subTitleLbl : UILabel!
    @IBOutlet weak var selectedImageView : UIImageView!
    @IBOutlet weak var outerView : UIView!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
