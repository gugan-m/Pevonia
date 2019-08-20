//
//  PhotoViewCellTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class PhotoViewCellTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var imgName: UILabel!
    @IBOutlet var albumCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
