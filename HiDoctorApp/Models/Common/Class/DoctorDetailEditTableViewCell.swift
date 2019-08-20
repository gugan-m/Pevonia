//
//  DoctorDetailEditTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 05/01/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DoctorDetailEditTableViewCell: UITableViewCell,UITextFieldDelegate{

    @IBOutlet var outterView: UIView!
    @IBOutlet var sepView: UIView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var editTxtField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        editTxtField.delegate = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
