//
//  MoreContentTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/21/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class MoreContentTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentTxtLbl: UILabel!
    @IBOutlet weak var contentIconImg: UIImageView!
    @IBOutlet weak var ErrorIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
