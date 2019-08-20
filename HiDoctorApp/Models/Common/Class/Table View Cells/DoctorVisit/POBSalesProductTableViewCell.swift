//
//  POBSalesProductTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 24/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBSalesProductTableViewCell: UITableViewCell,UITextFieldDelegate
{
    //MARK:- @IBOutlet
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productQtyTxtField: UITextField!
    @IBOutlet weak var removeBtn : UIButton!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var unitRateLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    //MARK:- LifeCycle
    override func awakeFromNib()
    {
       super.awakeFromNib()
       self.removeBtn.imageView?.tintColor = UIColor.darkGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
