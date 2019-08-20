//
//  CustomImageView.swift
//  HiDoctorApp
//
//  Created by Admin on 6/27/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class CustomImageView: UIView , UIScrollViewDelegate{

    @IBOutlet weak var imagePinchScrollVw: UIScrollView!
    
    @IBOutlet weak var imageVw: UIImageView!
    
    @IBOutlet var parentView: UIView!
    
    
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
        Bundle.main.loadNibNamed("CustomImageView", owner: self, options: nil)
        // 2. add as subview
        addSubview(parentView)
        // 3. allow for autolayout
        parentView.translatesAutoresizingMaskIntoConstraints = false
        // 4. add constraints to span entire view
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": parentView]))
        
   
        imagePinchScrollVw.contentOffset = CGPoint(x: 0, y: 0)
        imagePinchScrollVw.zoomScale = 1.0
        self.imagePinchScrollVw.minimumZoomScale = 1
        self.imagePinchScrollVw.maximumZoomScale = 2.0
        self.imagePinchScrollVw.contentSize = self.imageVw.frame.size;
        self.imagePinchScrollVw.delegate = self;
        self.imageVw.contentMode = .scaleAspectFit
        
        self.imageVw.setNeedsDisplay()
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageVw
    }


}
