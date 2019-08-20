//
//  IntermediateAccompanistTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/7/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class IntermediateAccompanistTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
