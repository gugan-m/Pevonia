//
//  RCPAListTableCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 11/12/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class RCPAListTableCell: UITableViewCell {

    @IBOutlet weak var imgView: TintColorForImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
