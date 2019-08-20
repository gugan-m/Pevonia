//
//  MCListTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 22/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class MCListTableViewCell: UITableViewCell {

     @IBOutlet weak var activityText: UILabel!
     @IBOutlet weak var selectionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
