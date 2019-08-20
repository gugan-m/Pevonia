//
//  UserListIndexTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class UserListIndexTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var detailLbl: UILabel!
    
    @IBOutlet weak var imgView : UIImageView!
    
    @IBOutlet weak var imgViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var outerView : UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
