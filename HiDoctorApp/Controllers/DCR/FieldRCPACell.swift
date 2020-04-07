//
//  FieldRCPACell.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class FieldRCPACell: UITableViewCell {

    
    @IBOutlet weak var chemistView: UIView!
    @IBOutlet weak var rcpaView: UIView!
    @IBOutlet weak var stockistView: UIView!
    @IBOutlet weak var expenseView: UIView!
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var dcrLabel: UILabel!
    @IBOutlet weak var dcrStatus: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doctorVisitCount: UILabel!
    @IBOutlet weak var plannedDoctorVisit: UILabel!
    @IBOutlet weak var expensesTick: UIImageView!
    @IBOutlet weak var stockiestTick: UIImageView!
    @IBOutlet weak var rcpaTick: UIImageView!
    @IBOutlet weak var cpName: UILabel!
    @IBOutlet weak var workPlace: UILabel!
    @IBOutlet weak var chemistTick: UIImageView!
    @IBOutlet weak var editBtnWrapper: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var wrapperViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var unapprovedBylabel: UILabel!
    @IBOutlet weak var unApprovedHeightConst: NSLayoutConstraint!
    @IBOutlet weak var btmViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var unapprovedView: UIView!
    @IBOutlet weak var chemistEntryLbl: UILabel!
    @IBOutlet weak var stockiestEntryLbl: UILabel!
    @IBOutlet weak var expenseEntryLbl: UILabel!
    
    @IBOutlet weak var btnViewRCPA: UIButton!
    override func awakeFromNib() {
        chemistEntryLbl.text = "\(appChemist) Entry"
        stockiestEntryLbl.text = "\(appStockiest) Entry"
    }
}
