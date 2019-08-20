//
//  IceFeedbackAnswerCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 30/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceFeedbackAnswerCell: UITableViewCell {
    
    @IBOutlet weak var answerTextLbl: UILabel!
    @IBOutlet weak var radioImage : UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
