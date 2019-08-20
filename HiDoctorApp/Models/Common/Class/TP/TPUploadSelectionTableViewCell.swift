//
//  TPUploadSelectionTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPUploadSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet var monthWithActivityFlagLbl: UILabel!
    
    @IBOutlet var tpActivityCountLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCornerRadius()
        // Initialization code
    }
    func setCornerRadius()
    {
        tpActivityCountLbl.layer.cornerRadius = 15
        tpActivityCountLbl.layer.masksToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
