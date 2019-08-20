//
//  TravelModeSuggestionCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 25/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class TravelModeSuggestionCell: UITableViewCell {

    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var toPlaceLabel: UILabel!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
