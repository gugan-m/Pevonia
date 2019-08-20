//
//  KnowyourCalendarController.swift
//  HiDoctorApp
//
//  Created by Vijay on 20/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class KnowyourCalendarController: UIViewController {
    @IBOutlet weak var appliedRoundView: UIView!
    @IBOutlet weak var approvedRoundView: UIView!
    @IBOutlet weak var draftedRoundView: UIView!
    @IBOutlet weak var unApprovedRoundView: UIView!
    @IBOutlet weak var dcrLockedRoundView: UIView!
    @IBOutlet weak var todayRoundView: UIView!
    @IBOutlet weak var holidayRoundView: UIView!
    @IBOutlet weak var oneActivityRoundView: UIView!
    @IBOutlet weak var twoActivityRoundView: UIView!

    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setDefaults()
        
    }
    
    func setDefaults()
    {
        self.navigationItem.title = "Know your Calendar"
        contentViewHeightConst.constant = self.view.frame.size.height - 64.0 - 40.0
        
        appliedRoundView.layer.cornerRadius = 12.5
        appliedRoundView.layer.masksToBounds = true
        appliedRoundView.backgroundColor = CellColor.appliedBgColor.color
        
        approvedRoundView.layer.cornerRadius = 12.5
        approvedRoundView.layer.masksToBounds = true
        approvedRoundView.backgroundColor = CellColor.approvedBgColor.color
        
        draftedRoundView.layer.cornerRadius = 12.5
        draftedRoundView.layer.masksToBounds = true
        draftedRoundView.backgroundColor = CellColor.draftedBgColor.color
        
        unApprovedRoundView.layer.cornerRadius = 12.5
        unApprovedRoundView.layer.masksToBounds = true
        unApprovedRoundView.backgroundColor = CellColor.unApprovedBgColor.color
        
        dcrLockedRoundView.layer.cornerRadius = 12.5
        dcrLockedRoundView.layer.masksToBounds = true
        dcrLockedRoundView.backgroundColor = UIColor.clear
        dcrLockedRoundView.layer.borderWidth = 2.0
        dcrLockedRoundView.layer.borderColor = CellColor.normalTextColor.color.cgColor
        
        todayRoundView.layer.cornerRadius = 12.5
        todayRoundView.layer.masksToBounds = true
        todayRoundView.backgroundColor = CellColor.todayBgColor.color
        
        holidayRoundView.layer.cornerRadius = 12.5
        holidayRoundView.layer.masksToBounds = true
        holidayRoundView.backgroundColor = CellColor.holidayBgColor.color
        
        oneActivityRoundView.layer.cornerRadius = 12.5
        oneActivityRoundView.layer.masksToBounds = true
        oneActivityRoundView.backgroundColor = CellColor.appliedBgColor.color
        
        twoActivityRoundView.layer.cornerRadius = 12.5
        twoActivityRoundView.layer.masksToBounds = true
        twoActivityRoundView.backgroundColor = CellColor.appliedBgColor.color
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
