//
//  AttendanceCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dcrlabel: UILabel!
    @IBOutlet weak var dcrStatus: UILabel!
    @IBOutlet weak var workPlace: UILabel!
    @IBOutlet weak var activityTick: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var wrapperViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var editBtnWrapper: UIView!
    @IBOutlet weak var unapprovedBylabel: UILabel!
    @IBOutlet weak var unApprovedHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btmViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var unapprovedView: UIView!
}
