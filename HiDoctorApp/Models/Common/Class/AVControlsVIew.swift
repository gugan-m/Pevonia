//
//  AVControlsVIew.swift
//  HiDoctorApp
//
//  Created by Admin on 5/24/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AVControlsVIew: UIView {

    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var backwardBtn: UIButton!
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var qualityTableView: UITableView!
    
    @IBOutlet weak var playProgressSlider: UISlider!
    
    @IBOutlet weak var videoEndtimeLabel: UILabel!
    @IBOutlet weak var videoStartTimeLabel: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var brightOrVolumeIV: UIImageView!
    
    @IBOutlet weak var brightOrVolumeLbl: UILabel!
    
    @IBOutlet weak var brightnOrVolumeVw: UIView!
    
    @IBOutlet weak var brightOrVolTxtLbl: UILabel!
    
    @IBOutlet weak var gestureView: UIView!
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        // fatalError("init(coder:) has not been implemented")
    }
    
    func setup()  {
        // 1. load the interface
        Bundle.main.loadNibNamed("AVControlsView", owner: self, options: nil)
        // 2. add as subview
        addSubview(parentView)
        // 3. allow for autolayout
        parentView.translatesAutoresizingMaskIntoConstraints = false
        // 4. add constraints to span entire view
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        
        volumeSlider.isHidden = true
        brightnessSlider.isHidden = true
        qualityTableView.isHidden = true
        settingsBtn.isHidden = true
        brightnOrVolumeVw.isHidden = true
        
        qualityTableView.register(UINib.init(nibName: "AVQualityTableViewCell", bundle: nil), forCellReuseIdentifier: "AVQualityTableViewCell")
        // volumeBar.frame = CGRect(x: self.containerView.frame.height/2 , y: self.containerView.frame.size.width - 20, width:  self.containerView.frame.size.width * 3 , height: CGFloat(20))
        
        // volumeBar.transform = self.volumeBar.transform.rotated(by: CGFloat(270.0/180 * .pi));
        //volumeBarHzConstraint.constant = containerView.frame.size.height + 50
        
    }


}
