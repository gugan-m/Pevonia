//
//  CardView.swift
//  CardStack
//
//  Created by Zhou Hao on 11/3/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import UIKit

public protocol CardViewDelegate: class {
    func shouldMoveForwardView(_ cardView: CardView)
    func shouldMoveBackwardView(_ cardView: CardView)
    func cardViewDidSelected(_ cardView: CardView)
}

@IBDesignable
open class CardView: UIView {
    
    private var originCenter: CGPoint!
    private var dragged: Bool = false
    var index = 0
    weak var delegate: CardViewDelegate?
    
    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        willSet {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        willSet {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var isShadowed: Bool = false {
        willSet {
            if newValue {
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.6
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowRadius = 5
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector (self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
       // self.addGestureRecognizer(swipeLeft)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(drag(gesture:)))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func respondToSwipeGesture(gesture: UISwipeGestureRecognizer){
            guard isTopMost() else {
                return
            }
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                delegate?.shouldMoveBackwardView(self)
                break
            case UISwipeGestureRecognizerDirection.left:
                delegate?.shouldMoveForwardView(self)
                break
            default:
                break
            }
        
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        originCenter = self.center
        dragged = false
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isTopMost() else {
            return
        }

        if !dragged {
            self.delegate?.cardViewDidSelected(self)
        }
    }
    
    @objc func drag(gesture: UIPanGestureRecognizer) {
        
        guard isTopMost() else {
            return
        }
        
        let translation = gesture.translation(in: self)
        let vel: CGPoint = gesture.velocity(in: self)
        let direction = panGestureDirection(velocity: vel)

        if gesture.state == .ended {
          
            if direction == Direction.Right ||  direction == Direction.Left {
            if abs(translation.x) > bounds.width / 2.0  {
                //delegate?.shouldMoveForwardView(self)
                
                
                if direction == Direction.Left {
                    delegate?.shouldMoveForwardView(self)
                }
                if direction == Direction.Right{
                delegate?.shouldMoveBackwardView(self)
                }
   
            } else {
                // return back to original position
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                    self.center = self.originCenter
                }, completion: { (complete) in
                })
            }
            }else{
                // return back to original position
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                    self.center = self.originCenter
                }, completion: { (complete) in
                })
            }
            return

        }
        dragged = true
        self.center = CGPoint(x: originCenter.x + translation.x, y: originCenter.y + translation.y)
    }
 
    //MARK: - Private
    func isTopMost() -> Bool {
        return self.superview?.subviews.last == self
    }
    
    
}
