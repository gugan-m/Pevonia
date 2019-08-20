//
//  StockiestsListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 27/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class StockiestsListTableViewCell: UITableViewCell {

    @IBOutlet weak var stockiestsNameLbl: UILabel!
    
    @IBOutlet weak var categoryNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
