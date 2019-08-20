//
//  TravelListCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 25/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class TravelListCell: UITableViewCell {

    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var autoCircleText: UILabel!
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var toPlaceLabel: UILabel!
    @IBOutlet weak var travelMode: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var removeBtnWrapper: NSLayoutConstraint!
    @IBOutlet weak var removebtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
