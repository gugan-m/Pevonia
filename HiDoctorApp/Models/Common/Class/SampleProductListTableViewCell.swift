//
//  SampleProductListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 20/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class SampleProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLbl : UILabel!
    @IBOutlet weak var productCountLbl : UILabel!
    @IBOutlet weak var selectedImageView : UIImageView!
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
