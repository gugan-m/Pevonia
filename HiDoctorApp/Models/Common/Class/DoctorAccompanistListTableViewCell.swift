//
//  DoctorAccompanistListTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/30/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorAccompanistListTableViewCell: UITableViewCell {
    @IBOutlet weak var accSelectImg: UIImageView!
    @IBOutlet weak var accompanistNameLbl: UILabel!
    @IBOutlet weak var accompanistAddrLbl: UILabel!
    @IBOutlet weak var accompanistPosLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
