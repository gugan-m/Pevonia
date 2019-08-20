//
//  AttachmentTableviewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 20/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AttachmentTableviewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageSizeLbl: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var imageWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgBtn: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
