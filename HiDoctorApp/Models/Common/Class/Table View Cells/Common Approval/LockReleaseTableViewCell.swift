//
//  LockReleaseTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 04/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LockReleaseTableViewCell: UITableViewCell
{
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var selectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var lockDateLabel: UILabel!
    @IBOutlet weak var actualDateLabel: UILabel!
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionWrapperView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
