//
//  InwardRemarksTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 28/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class InwardRemarksTableViewCell: UITableViewCell {

    @IBOutlet weak var modifiedInwardDate: UILabel!
    @IBOutlet weak var modifiedOn: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var ackType: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
