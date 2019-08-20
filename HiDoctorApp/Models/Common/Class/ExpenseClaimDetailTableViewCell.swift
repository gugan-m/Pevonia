//
//  ExpenseClaimDetailTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 18/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var valueTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
