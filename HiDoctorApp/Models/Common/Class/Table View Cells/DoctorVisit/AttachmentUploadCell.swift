//
//  AttachmentUploadCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 10/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AttachmentUploadCell: UITableViewCell {

    @IBOutlet weak var attachmentName: UILabel!
    @IBOutlet weak var attachmentSize: UILabel!
    @IBOutlet weak var attachmentDate: UILabel!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
