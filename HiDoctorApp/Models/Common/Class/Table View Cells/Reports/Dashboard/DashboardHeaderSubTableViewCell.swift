//
//  DashboardHeaderSubTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardHeaderSubTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DashboardAssetCustomerWiseSectionCell : UITableViewCell
{
    @IBOutlet weak var assetTypeLbl : UILabel!
    @IBOutlet weak var assetCountLbl : UILabel!
}
