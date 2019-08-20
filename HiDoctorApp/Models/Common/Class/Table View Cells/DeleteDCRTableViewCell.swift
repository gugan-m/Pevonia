//
//  DeleteDCRTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 16/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DeleteDCRTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dcrDateLbl : UILabel!
    @IBOutlet weak var dcrTypeLbl : UILabel!
    @IBOutlet weak var dcrStatusLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class DeleteDCRFilterTableViewCell: UITableViewCell
{
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
