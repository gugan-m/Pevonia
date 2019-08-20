//
//  ApproveErrorTableCellTwo.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 16/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ApproveErrorTableCellTwo: UITableViewCell {


     @IBOutlet weak var entityName  : UILabel!
    @IBOutlet weak var maximumDoctors  : UILabel!
    @IBOutlet weak var maximumDoctorsCount : UILabel!
    @IBOutlet weak var availableDoctors : UILabel!
    @IBOutlet weak var availableDoctorsCount : UILabel!
    @IBOutlet weak var selectedApproval : UILabel!
    @IBOutlet weak var selectedApprovalCount : UILabel!
    @IBOutlet weak var excessDoctors : UILabel!
    @IBOutlet weak var excessDoctorsCount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
