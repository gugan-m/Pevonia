//
//  ChemistSectionDetailTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistSectionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var chemistsNameLbl: UILabel!
    @IBOutlet weak var chemistsPlaceLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
