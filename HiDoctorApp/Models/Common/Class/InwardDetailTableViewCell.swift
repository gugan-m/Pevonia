//
//  InwardDetailTableViewCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 28/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class InwardDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var sentQty: UILabel!
    @IBOutlet weak var receiveQty: UITextField!
    @IBOutlet weak var receivedSoFar: UILabel!
    @IBOutlet weak var pendingQty: UILabel!
    @IBOutlet weak var viewBut: UIButton!
     @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var batchNumberLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        remarks.layer.borderWidth = 0.7
        remarks.layer.borderColor = UIColor.lightGray.cgColor
        remarks.layer.cornerRadius = 5
        remarks.layer.masksToBounds = true
        viewBut.layer.cornerRadius = 5
        viewBut.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
