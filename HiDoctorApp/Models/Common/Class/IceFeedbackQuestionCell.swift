//
//  IceFeedbackQuestionCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 30/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceFeedbackQuestionCell: UITableViewCell {

    @IBOutlet weak var questionTextLbl: UILabel!
    @IBOutlet weak var arrowImage : UIImageView!
    @IBOutlet weak var expandButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class IceFeedbackListCell: UITableViewCell {
    
    @IBOutlet weak var evaluatedBy: UILabel!
    @IBOutlet weak var evaluatedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class IceHistoryListCell: UITableViewCell {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var remarksLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class IceHistoryHeaderCell: UITableViewCell {
    
    @IBOutlet weak var evaluatedBy: UILabel!
    @IBOutlet weak var evaluatedFor: UILabel!
    @IBOutlet weak var evaluatedDate: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var overAllRemarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class TaskListCell: UITableViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var status: UILabel!
     @IBOutlet weak var completedOn: UILabel!
     @IBOutlet weak var reviewedOn: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


