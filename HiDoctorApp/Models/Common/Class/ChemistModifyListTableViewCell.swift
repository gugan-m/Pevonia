//
//  ChemistModifyListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistModifyListTableViewCell: UITableViewCell
{
    @IBOutlet weak var chemistNameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
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
