//
//  ExpensesListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ExpensesListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var expenseTypeLbl: UILabel!
    @IBOutlet weak var expenseAmountLbl: UILabel!

    @IBOutlet weak var sepViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var removeBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var modifyBtnHeight: NSLayoutConstraint!
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
