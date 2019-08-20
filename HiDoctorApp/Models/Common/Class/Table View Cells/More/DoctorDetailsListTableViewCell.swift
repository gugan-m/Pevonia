//
//  DoctorDetailsListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorDetailsListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
   
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var sepView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

class DoctorTagCell: UITableViewCell
{
    @IBOutlet weak var remarksDate: UILabel!
    @IBOutlet weak var remarksDesc: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
