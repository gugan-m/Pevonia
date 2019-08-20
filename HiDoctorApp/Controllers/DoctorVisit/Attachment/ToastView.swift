//
//  ToastView.swift
//  HiDoctorApp
//
//  Created by Vijay on 10/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib()
    {
        //setCornerRadius(view: topView, corners: [.topLeft, .topRight])
    }
    
    func updateViewProperties()
    {
        let lblHeight = getTextSize(text: errorLbl.text, fontName: fontSemiBold, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 40).height
        
        self.frame.size.height = 55 + lblHeight
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        hideAttachmentToastView()
    }
    
}
