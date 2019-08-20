//
//  NoticeBoardTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class NoticeBoardTableViewCell: UITableViewCell {

    
    
    @IBOutlet var noticeTitle: UILabel!
    
    @IBOutlet var noticeMSg: UILabel!
    
    @IBOutlet var dateImage: UIImageView!
    
    @IBOutlet var personImage: UIImageView!
    
    @IBOutlet var fromDatetoDate: UILabel!
    
    @IBOutlet var msgDistributionType: UILabel!
    
    @IBOutlet var Msgpriority: UIImageView!
    
    @IBOutlet var msgPriorityLbl: UILabel!
    
    @IBOutlet var msgView: CornerRadiusWithShadowView!
    
    @IBOutlet var msgPriorityView: UIView!
    
    @IBOutlet weak var msgPriorLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DPMCusProListCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}

class DPMMappedListCell: UITableViewCell {
    
    @IBOutlet var titleOne: UILabel!
    @IBOutlet var titleTwo: UILabel!
    @IBOutlet var titleThree: UILabel!
    @IBOutlet var titleFour: UILabel!
    @IBOutlet var titleFive: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

class DPMMappingListCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var prescriptionLBl: UILabel!
    @IBOutlet var potentialLbl: UILabel!
    @IBOutlet var priorityLbl: UILabel!
    @IBOutlet var prescriptionTxt: UITextField!
    @IBOutlet var potentialTxt: UITextField!
    @IBOutlet var priorityTxt: UITextField!
    @IBOutlet var selectedImg: UIImageView!
    @IBOutlet var selectedBut: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
