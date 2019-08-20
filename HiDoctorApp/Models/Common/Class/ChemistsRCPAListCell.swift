//
//  ChemistsRCPAListCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 05/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistsRCPAListCell: UITableViewCell {

    @IBOutlet weak var rcpaNameLbl: UILabel!
    @IBOutlet weak var popAmountLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
