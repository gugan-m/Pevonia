//
//  ExpenseClaimSectionCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 18/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimSectionCell: UITableViewCell {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
