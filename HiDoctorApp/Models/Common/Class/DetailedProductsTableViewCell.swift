//
//  DetailedProductsTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/28/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DetailedProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var DetailProductNameImg: UIImageView!
    @IBOutlet weak var DetailProductNameLbl: UILabel!
    @IBOutlet weak var selectedImgConst: NSLayoutConstraint!
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusBut: UIButton!
    @IBOutlet weak var remarkTextView: UITextView!
     @IBOutlet weak var remarkViewHegConst: NSLayoutConstraint!
    @IBOutlet weak var businessPotentialTxtFld : UITextField!
     @IBOutlet weak var statusViewHegConst: NSLayoutConstraint!
    @IBOutlet weak var textfieldViewHegConst: NSLayoutConstraint!
     @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var competitorBut: UIButton!
     @IBOutlet weak var competitorButHegConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //set border color and corner radius
//        remarkTextView.layer.borderWidth = 1
//        remarkTextView.layer.borderColor = UIColor.lightGray.cgColor
        statusViewHegConst.constant = 0
        businessPotentialTxtFld.isHidden = true
        if (remarkTextView != nil)
        {
            
            remarkTextView.layer.cornerRadius = 5
            remarkTextView.layer.masksToBounds = true
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CompetitorDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var competitorName: UILabel!
    @IBOutlet weak var productName: UILabel!
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



class CompetitiorListTableViewCell: UITableViewCell {
    @IBOutlet weak var competitorName: UILabel!
    @IBOutlet weak var bgView: UIView!
}

