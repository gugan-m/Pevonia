//
//  AccompanistPopUpTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 01/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AccompanistPopUpTableViewCell: UITableViewCell {

    @IBOutlet weak var accompanistNameLbl : UILabel!
    
    @IBOutlet weak var selectedImg : UIImageView!
    
    @IBOutlet weak var regionNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
