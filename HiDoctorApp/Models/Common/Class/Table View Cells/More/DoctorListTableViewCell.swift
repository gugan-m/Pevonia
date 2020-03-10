//
//  DoctorListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorListTableViewCell: UITableViewCell
{
    @IBOutlet weak  var doctorNameLbl : UILabel!
    @IBOutlet weak  var doctorDetailsLbl : UILabel!
    @IBOutlet weak  var wrapperView : UIView!
    @IBOutlet weak  var locationImageView : UIImageView!
    @IBOutlet weak  var locationImageViewWidthConstraint : NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TPDoctorListTableViewCell: UITableViewCell
{
    @IBOutlet weak  var doctorNameLbl : UILabel!
    @IBOutlet weak  var doctorDetailsLbl : UILabel!
    @IBOutlet weak  var wrapperView : UIView!
    @IBOutlet weak  var locationImageView : UIImageView!
    @IBOutlet weak  var locationImageViewWidthConstraint : NSLayoutConstraint!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
