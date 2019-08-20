//
//  UnApprovalListTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/3/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class UnApprovalListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listContentLbl: UILabel!
    @IBOutlet weak var listIconImg: TintColorForImageView!
    @IBOutlet weak var imageCheckBox: UIImageView!
    @IBOutlet weak var checkboxView: UIView!
    @IBOutlet weak var isLocal: UIImageView!
    @IBOutlet weak var selectList: TintColorForImageView!
    @IBOutlet weak var selectionViewWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
