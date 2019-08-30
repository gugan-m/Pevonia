//
//  NotesKnowYourCalendar.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/08/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class NotesKnowYourCalendar: UIViewController{
    @IBOutlet weak var appliedRoundView: UIView! //notes task
    @IBOutlet weak var approvedRoundView: UIView! // notes
    @IBOutlet weak var draftedRoundView: UIView! // tasks
    @IBOutlet weak var unApprovedRoundView: UIView! //holiday
    @IBOutlet weak var weekendOffRoundView: UIView! // weekend
    @IBOutlet weak var todayRoundView: UIView! // today
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaults()
        
        // Do any additional setup after loading the view.
    }
    func setDefaults()
    {
        self.navigationItem.title = "Know your Calendar"
       
        
        appliedRoundView.layer.cornerRadius = 12.5
        appliedRoundView.layer.masksToBounds = true
        appliedRoundView.backgroundColor = UIColor(red: 28/255, green: 0/255, blue: 191/255, alpha: 1.0)
        
        approvedRoundView.layer.cornerRadius = 12.5
        approvedRoundView.layer.masksToBounds = true
        approvedRoundView.backgroundColor = UIColor(red: 0/255, green: 107/255, blue: 7/255, alpha: 1.0)
        
        draftedRoundView.layer.cornerRadius = 12.5
        draftedRoundView.layer.masksToBounds = true
        draftedRoundView.backgroundColor = UIColor(red: 206/255, green: 89/255, blue: 0/255, alpha: 1.0)
        
        
        unApprovedRoundView.layer.cornerRadius = 12.5
        unApprovedRoundView.layer.masksToBounds = true
        unApprovedRoundView.backgroundColor = UIColor(red: 216/255, green: 98/255, blue: 224/255, alpha: 1.0)
        
        weekendOffRoundView.layer.cornerRadius = 12.5
        weekendOffRoundView.layer.masksToBounds = true
        weekendOffRoundView.backgroundColor = UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1.0)
        
        todayRoundView.layer.cornerRadius = 12.5
        todayRoundView.layer.masksToBounds = true
        todayRoundView.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
