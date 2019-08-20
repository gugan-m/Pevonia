//
//  DoctorVisitDetail.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorVisitDetail: UITableViewCell {
    
    @IBOutlet weak var visitMode: UILabel!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorDesc: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var modifyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
