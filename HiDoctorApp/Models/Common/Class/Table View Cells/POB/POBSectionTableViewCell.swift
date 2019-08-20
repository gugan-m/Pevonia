//
//  POBSectionTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBSectionTableViewCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var sectionTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class POBDetailTableViewCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var detailsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
    class POBAmountDetailTableViewCell: UITableViewCell {
        
        //MARK:- @IBOutlet
        @IBOutlet weak var productsCountLabel: UILabel!
        @IBOutlet weak var amountLabel: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
}
