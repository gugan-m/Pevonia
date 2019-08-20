//
//  ApprovalDoctorVisitTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ApprovalDoctorVisitTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var sepViewHgtConstant:
    NSLayoutConstraint!
    
    @IBOutlet weak var moreLblHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var moreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if (BL_TpReport.sharedInstance.tpDate != nil )
        {
            
            if BL_TpReport.sharedInstance.tpDate == getServerFormattedDate(date: getCurrentDateAndTime()) &&    BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased() {
                playBtn?.isHidden = false
            }
            else
            {
                playBtn?.isHidden = true
            }
        }
        else{
            
            playBtn?.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
