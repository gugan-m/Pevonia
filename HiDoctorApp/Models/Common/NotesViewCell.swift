//
//  NotesViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 19/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class NotesViewCell: UITableViewCell {
    
    @IBOutlet weak var closebtn: UIButton!
    
    @IBOutlet weak var dateview: CornerRadiusWithShadowView!
    @IBOutlet weak var Description : UILabel!
    
    @IBOutlet weak var outerView : UIView!
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var statusview: CornerRadiusWithShadowView!
    
    @IBOutlet weak var statusinput: UITextField!
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var duedatellbl: UILabel!
    @IBOutlet weak var status: UIButton!
    @IBOutlet weak var date: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        status.addSubview(statusinput)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
