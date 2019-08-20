//
//  DoctorVisitAccompanistCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 02/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorVisitAccompanistCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var accompName: UILabel!
    @IBOutlet weak var callType: UILabel!
    @IBOutlet weak var independentStatus: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
