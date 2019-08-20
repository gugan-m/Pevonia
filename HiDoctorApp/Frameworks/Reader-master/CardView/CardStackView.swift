//
//  CardStackView.swift
//  CardStack
//
//  Created by Zhou Hao on 11/3/17.
//  Copyright © 2017 Zhou Hao. All rights reserved.
//

import UIKit

public protocol CardStackViewDataSource: class {
    func nextCard(in: CardStackView) -> CardView?
    func previousCard(in: CardStackView) -> CardView?
    func cardStackView(_ cardStackView: CardStackView, cardAt index: Int) -> CardView
    func numOfCardInStackView(_ cardStackView: CardStackView) -> Int
}

public protocol CardStackViewDelegate: class {
    func cardStackView(_: CardStackView, didSelect card: CardView)
}

@IBDesignable
public class CardStackView: UIView, CardViewDelegate {

    public var currentCard = CardView()
    var firstTime = true

    // MARK: - Properties
    public weak var dataSource: CardStackViewDataSource? { // TODO: add to dataSource in Inspector
        didSet {
            reloadData()
        }
    }
    
    public weak var delegate: CardStackViewDelegate?
    
    // MARK: - Private properties
    private var nib : UINib?
    // MARK: - Inspectable properties
    @IBInspectable
    public var offsetY: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
        
    }
    
    @IBInspectable
    public var scaleFactor: Float = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    // MARK: - Public methods
    public func register(nib: UINib) {
        self.nib = nib
    }
    
    public func dequeueCardView() -> CardView {
        if let view = nib?.instantiate(withOwner: self, options: nil).first as? CardView {
            return view
        } else {
            return CardView()
        }
    }
    
    public func getCurrentCard() ->CardView{
        return currentCard
    }
    
    
    public func reloadData() {
        
        subviews.filter { $0.isKind(of: CardView.self) }.forEach { $0.removeFromSuperview() }
        
        if let dataSource = dataSource {
            let total = dataSource.numOfCardInStackView(self)
    
            var prevView: UIView?
            for i in 0..<total {
                let cardView = dataSource.cardStackView(self, cardAt: i)
                cardView.delegate = self
                if let prevView = prevView {
                    self.insertSubview(cardView, belowSubview: prevView)
                } else {
                    addSubview(cardView)
                }
                prevView = cardView
            }
            layoutIfNeeded()
//            if total > 0{
//            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.targetMethod), userInfo: nil, repeats: true)
//            }
        }
    }
    
    func targetMethod(){
        shouldMoveForwardView(currentCard)
    }
    
    // MARK: - CardViewDelegate
    
    public func shouldMoveForwardView(_ cardView: CardView) {
        if let nextCard = dataSource?.nextCard(in: self) {
            nextCard.delegate = self
            currentCard = nextCard
            cardView.removeFromSuperview()
            insertSubview(nextCard, at: 0)
            insertSubview(cardView, at: 0)
            bringSubview(toFront: nextCard)

        }
    }
    
    
    public func shouldMoveBackwardView(_ cardView: CardView) {
        if let previousCard = dataSource?.previousCard(in: self) {
            previousCard.delegate = self
            currentCard = previousCard
           // cardView.removeFromSuperview()
            //insertSubview(nextCard, at: 0)
            //insertSubview(cardView, at: 1)
            bringSubview(toFront: previousCard)
        }
    }
 
    public func cardViewDidSelected(_ cardView: CardView) {
        self.delegate?.cardStackView(self, didSelect: cardView)
    }
    
    // MARK: - Override
    override open func layoutSubviews() {
        // setup cards frame
        var index = 0
        let allCardViews = subviews.filter { $0.isKind(of: CardView.self) }
        for cardView in allCardViews.reversed() {
            UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .transitionFlipFromLeft, animations: {
                cardView.frame = self.rectAt(index: index)
                index += 1
            }, completion: { (complete) in
            })
//            cardView.frame = self.rectAt(index: index)
//            index += 1
            
            if index > 3{
                cardView.isHidden = true
            }else{
                cardView.isHidden = false

            }
        }
    }
    
    // MARK: - Private methods
    private func rectAt(index: Int) -> CGRect {
        
        if let dataSource = dataSource {
            _ = dataSource.numOfCardInStackView(self)
            
            let w = bounds.width
            let h = bounds.height - CGFloat(3 - 1) * offsetY
        
            let scale = CGFloat(pow(scaleFactor, Float(index)))
            let x = ( w - w * scale ) / 2.0
            let y = CGFloat(index)*offsetY + ( h - h * scale )
            return CGRect(x: x, y: y, width: w * scale, height: h * scale)
        }
        return CGRect.zero
    }
    
    
}
