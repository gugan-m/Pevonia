//
//  MarkerTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 03/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MarkerTableViewCell: UITableViewCell {

    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countlabel: UILabel!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countView.layer.cornerRadius = 12.5
        self.countView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
