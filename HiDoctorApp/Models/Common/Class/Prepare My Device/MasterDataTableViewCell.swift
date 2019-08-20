//
//  MasterDataTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/8/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class MasterDataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
