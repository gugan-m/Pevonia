//
//  DashboardAssetDoctorCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardAssetDoctorCell: UITableViewCell {

    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorDetail: UILabel!
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

class TopDoctorAssetCell: UITableViewCell {
    
    @IBOutlet weak var assetThumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var noTimesLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
