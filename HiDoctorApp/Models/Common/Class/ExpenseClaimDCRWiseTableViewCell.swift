//
//  ExpenseClaimDCRWiseTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 27/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimDCRWiseTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var expenseAmountLbl: UILabel!
    @IBOutlet weak var deductionLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
