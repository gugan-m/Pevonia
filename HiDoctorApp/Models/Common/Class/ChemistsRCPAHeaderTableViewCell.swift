//
//  ChemistsRCPAHeaderTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 05/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistsRCPAHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var stepImg : UIImageView!
    @IBOutlet weak var stepImgHgtConst : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
