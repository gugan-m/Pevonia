//
//  AddChemistRCPATableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 06/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddChemistRCPATableViewCell: UITableViewCell {

    @IBOutlet weak var stepUpBtn: UIButton!
    @IBOutlet weak var stepDownBtn: UIButton!
    @IBOutlet weak var productQtyLbl: UILabel!
    @IBOutlet weak var compProductQtyTextFiedl: UITextField!
    @IBOutlet weak var productNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
