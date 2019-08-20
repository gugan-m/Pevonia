//
//  AccompanistModifyListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AccompanistModifyListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accompanistNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var independentLabel: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
