//
//  TPKnowyourCalendarController.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPKnowyourCalendarController: UIViewController {

    
    @IBOutlet weak var appliedRoundView: UIView!
    @IBOutlet weak var approvedRoundView: UIView!
    @IBOutlet weak var draftedRoundView: UIView!
    @IBOutlet weak var unApprovedRoundView: UIView!
    @IBOutlet weak var weekendOffRoundView: UIView!
    @IBOutlet weak var todayRoundView: UIView!
    @IBOutlet weak var holidayRoundView: UIView!
    @IBOutlet weak var oneActivityRoundView: UIView!
    @IBOutlet weak var twoActivityRoundView: UIView!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaults()
    }
    
    func setDefaults()
    {
        self.navigationItem.title = "Know your Calendar"
        contentViewHeightConst.constant = self.view.frame.size.height - 64.0 - 40.0
        
        appliedRoundView.layer.cornerRadius = 12.5
        appliedRoundView.layer.masksToBounds = true
        appliedRoundView.backgroundColor = TPCellColor.appliedBgColor.color
        
        approvedRoundView.layer.cornerRadius = 12.5
        approvedRoundView.layer.masksToBounds = true
        approvedRoundView.backgroundColor = TPCellColor.approvedBgColor.color
        
        draftedRoundView.layer.cornerRadius = 12.5
        draftedRoundView.layer.masksToBounds = true
        draftedRoundView.backgroundColor = TPCellColor.draftedBgColor.color
        
        unApprovedRoundView.layer.cornerRadius = 12.5
        unApprovedRoundView.layer.masksToBounds = true
        unApprovedRoundView.backgroundColor = TPCellColor.unApprovedBgColor.color
        
        weekendOffRoundView.layer.cornerRadius = 12.5
        weekendOffRoundView.layer.masksToBounds = true
        weekendOffRoundView.backgroundColor = TPCellColor.weekEndBgColor.color
        
        todayRoundView.layer.cornerRadius = 12.5
        todayRoundView.layer.masksToBounds = true
        todayRoundView.backgroundColor = TPCellColor.todayBgColor.color
        
        holidayRoundView.layer.cornerRadius = 12.5
        holidayRoundView.layer.masksToBounds = true
        holidayRoundView.backgroundColor = TPCellColor.holidayBgColor.color
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
