//
//  ChemistSectionTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionContentView: UIView!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
