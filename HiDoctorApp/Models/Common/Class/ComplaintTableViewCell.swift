//
//  ComplaintTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customerName : UILabel!
    @IBOutlet weak var problemTxt : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var regionLbl : UILabel!
    @IBOutlet weak var typeLbl : UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
