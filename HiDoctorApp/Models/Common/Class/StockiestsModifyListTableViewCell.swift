//
//  StockiestsModifyListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 27/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class StockiestsModifyListTableViewCell: UITableViewCell {

    @IBOutlet weak var stockiestsNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        
        amountLbl.adjustsFontSizeToFitWidth = true
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
