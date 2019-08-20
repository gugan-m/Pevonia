//
//  MessageSubjectCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 26/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MessageSubjectCell: UITableViewCell {

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var addToUser: UIButton!
    @IBOutlet weak var addCcUser: UIButton!
    @IBOutlet weak var toLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ccLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var ccLabel: UILabel!
    @IBOutlet weak var labelBut: UIButton!
    @IBOutlet weak var labelCcBut: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
