//
//  ExpenseApprovalTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 13/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseApprovalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var levelNumLbl : UILabel!
    @IBOutlet weak var requestIDLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var statusLbl : UILabel!
    @IBOutlet weak var appliedAmountLbl : UILabel!
    @IBOutlet weak var actualAmountLbl : UILabel!
    @IBOutlet weak var fromToLbl : UILabel!
    @IBOutlet weak var locationLbl : UILabel!
    @IBOutlet weak var attachmentCountLbl : UILabel!
    @IBOutlet weak var attachmentView : UIView!
    @IBOutlet weak var userNameRoleLbl: UILabel!
    @IBOutlet weak var showAttachmentBut : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.levelNumLbl.layer.cornerRadius = 8
        self.levelNumLbl.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
