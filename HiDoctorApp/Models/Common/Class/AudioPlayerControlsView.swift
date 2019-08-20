//
//  AudioPlayerControlsView.swift
//  Sample
//
//  Created by Admin on 6/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AudioPlayerControlsView: UIView {

    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    
    
    @IBOutlet weak var playProgressSlider: UISlider!
    
    @IBOutlet weak var audioEndtimeLabel: UILabel!
    @IBOutlet weak var audioStartTimeLabel: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var thumbNailImageVw: UIImageView!
    
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
        Bundle.main.loadNibNamed("AudioPlayerControlsView", owner: self, options: nil)
        // 2. add as subview
        addSubview(parentView)
        // 3. allow for autolayout
        parentView.translatesAutoresizingMaskIntoConstraints = false
        // 4. add constraints to span entire view
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        
       
        // volumeBar.frame = CGRect(x: self.containerView.frame.height/2 , y: self.containerView.frame.size.width - 20, width:  self.containerView.frame.size.width * 3 , height: C2GFloat(20))
        
        // volumeBar.transform = self.volumeBar.transform.rotated(by: CGFloat(270.0/180 * .pi));
        //volumeBarHzConstraint.constant = containerView.frame.size.height + 50
        
    }



}
