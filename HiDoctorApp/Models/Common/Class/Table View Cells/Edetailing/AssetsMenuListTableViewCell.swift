//
//  AssetsMenuListTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsMenuListTableViewCell: UITableViewCell
{
    @IBOutlet weak var menuImg: UIImageView!
    @IBOutlet weak var menuNameLbl: UILabel!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var switchBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var rightIconWidth: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorWidth: NSLayoutConstraint!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var sepViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var sectionCoverBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
