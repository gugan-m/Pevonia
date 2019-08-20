//
//  DoctorMasterCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorMasterCell: UITableViewCell {

    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CustomerAddressCell: UITableViewCell
{
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
