//
//  ActivityListRemarksTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ActivityListRemarksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var activityText: UILabel!
    @IBOutlet weak var activityTextView: UITextView!
     @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityTextView.layer.borderWidth = 1
        activityTextView.layer.borderColor = UIColor.darkGray.cgColor
        activityTextView.layer.cornerRadius = 4
        activityTextView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
