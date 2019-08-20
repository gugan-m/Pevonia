//
//  ExpenseClaimTypeListTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 18/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimTypeListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var claimAmountLbl: UILabel!
    @IBOutlet weak var claimAmountDet: UILabel!
    @IBOutlet weak var approvedAmountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
