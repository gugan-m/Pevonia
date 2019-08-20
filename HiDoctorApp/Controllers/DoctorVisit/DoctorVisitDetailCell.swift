//
//  DoctorVisitDetailCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorVisitDetailCell: UITableViewCell {

    @IBOutlet weak var visitMode: UILabel!
    @IBOutlet weak var visitModeLabel: UILabel!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var remarkslabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class BusinessStatusCell: UITableViewCell
{
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
