//
//  ViewExtensionModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class RoundedCornerRadiusView : UIView
{
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
}

class CornerRadiusView : UIView
{
    override func layoutSubviews() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
class BorderedCornerRadiusView : UIView
{
    override func layoutSubviews()
    {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
    }
}
@IBDesignable
class CornerRadiusWithShadowView : UIView
{
    
        @IBInspectable var cornerRadius: CGFloat = 4
        
        @IBInspectable var shadowOffsetWidth: Int = 0
        @IBInspectable var shadowOffsetHeight: Int = 2
        @IBInspectable var shadowColor: UIColor? = UIColor.lightGray
        @IBInspectable var shadowOpacity: Float = 0.5
        
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
}

@IBDesignable
class eDetailingCornerRadiusWithShadowView : UIView
{
    @IBInspectable var cornerRadius: CGFloat = 4
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.6
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
}

class CornerRadiusForButton : UIButton
{
    override func layoutSubviews() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}

class TintColorForImageView : UIImageView
{
    override func layoutSubviews() {
        self.tintColor = UIColor.lightGray
    }
}

class WhiteTintColorForImageView : UIImageView
{
    override func layoutSubviews() {
        self.tintColor = UIColor.white
    }
}

extension Dictionary {
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

class TriangleView : UIView {
    private var colorDotLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if colorDotLayer == nil {
            colorDotLayer = CAShapeLayer()
            colorDotLayer?.fillColor = UIColor.red.cgColor
            layer.addSublayer(colorDotLayer!)
        }
        let bounds: CGRect = self.bounds
        let radius: CGFloat = (bounds.size.width - 6) / 2
        let a = radius * sqrt(CGFloat(3.0)) / 2
        let b: CGFloat = radius / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: -radius))
        path.addLine(to: CGPoint(x: a, y: b))
        path.addLine(to: CGPoint(x: -a, y: b))
        path.close()
        path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
        colorDotLayer?.path = path.cgPath
    }
    
   override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//extension UINavigationController{
//    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
//        if let visibleViewController = visibleViewController{
//            return visibleViewController.supportedInterfaceOrientations
//        }
//        return UIInterfaceOrientationMask.portrait
//    }
//}
