/*
 * CalendarDayCell.swift
 * Created by Michael Michailidis on 02/04/2015.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

open class CalendarDayCell: UICollectionViewCell {
    
    override open var description: String {
        let dayString = self.textLabel.text ?? " "
        return "<DayCell (text:\"\(dayString)\")>"
    }
    
    var eventsCount = 0 {
        didSet {
            self.dotsView.isHidden = (eventsCount == 0)
            self.setNeedsLayout()
        }
    }
    
    
    var isToday : Bool = true {
        didSet {
            switch isToday {
            case true:
                self.bgView.backgroundColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
                self.textLabel.textColor    = CalendarView.Style.cellTextColorToday
            case false:
                self.bgView.backgroundColor = CalendarView.Style.cellColorDefault
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }
    
    var isWeekend: Bool = true {
        didSet {
           // if self.isSelected || self.isToday { return }
            switch isWeekend {
            case true:
                self.bgView.layer.cornerRadius = 30.0
                self.bgView.backgroundColor = UIColor(red: 122/255, green: 122/255, blue: 122/255, alpha: 1.0)
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            case false:
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }
    
    var isHoliday: Bool = true {
        didSet {
            //if self.isSelected || self.isToday { return }
            switch isHoliday {
            case true:
                self.bgView.layer.cornerRadius = 30.0
                self.bgView.backgroundColor = UIColor(red: 216/255, green: 98/255, blue: 224/255, alpha: 1.0)
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            case false:
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }
    
    var isNotes: Bool = true {
        didSet {
           // if self.isSelected || self.isToday { return }
            switch isNotes {
            case true:
                self.bgView.layer.cornerRadius = 30.0
                self.bgView.backgroundColor = UIColor(red: 0/255, green: 107/255, blue: 7/255, alpha: 1.0)
                self.textLabel.textColor = CalendarView.Style.cellColorToday
            case false:
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }
    var isTask: Bool = true {
        didSet {
            //if self.isSelected || self.isToday { return }
            switch isTask {
            case true:
                
                self.bgView.backgroundColor = UIColor(red: 28/255, green: 0/255, blue: 191/255, alpha: 1.0)
                self.bgView.layer.cornerRadius = 5.0
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            case false:
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }
    var isBoth: Bool = true {
        didSet {
            //if self.isSelected || self.isToday { return }
            switch isBoth {
            case true:
                self.bgView.layer.cornerRadius = 5.0
                self.bgView.backgroundColor = UIColor(red: 206/255, green: 89/255, blue: 0/255, alpha: 1.0)
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            case false:
                self.textLabel.textColor = CalendarView.Style.cellTextColorDefault
            }
        }
    }

    override open var isSelected : Bool {
        didSet {
            switch isSelected {
            case true:
                self.bgView.layer.borderColor = CalendarView.Style.cellSelectedBorderColor.cgColor
                self.bgView.layer.borderWidth = CalendarView.Style.cellSelectedBorderWidth
                self.bgView.backgroundColor = CalendarView.Style.cellSelectedColor
                self.textLabel.textColor = CalendarView.Style.cellSelectedTextColor
            case false:
                self.bgView.layer.borderColor = CalendarView.Style.cellBorderColor.cgColor
                self.bgView.layer.borderWidth = CalendarView.Style.cellBorderWidth
                self.bgView.backgroundColor = CalendarView.Style.cellColorDefault
            }
        }
    }
    
    
    
    
    let textLabel   = UILabel()
    let dotsView    = UIView()
    let bgView      = UIView()
    
    override init(frame: CGRect) {
        
        self.textLabel.textAlignment = NSTextAlignment.center
        
        
        self.dotsView.backgroundColor = CalendarView.Style.cellEventColor
        
        self.textLabel.font = CalendarView.Style.cellFont
        
        
        super.init(frame: frame)
        
        self.addSubview(self.bgView)
        self.addSubview(self.textLabel)
        
        self.addSubview(self.dotsView)
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        var elementsFrame = self.bounds.insetBy(dx: 3.0, dy: 3.0)
        
        if CalendarView.Style.cellShape.isRound { // square of
            let smallestSide = min(elementsFrame.width, elementsFrame.height)
            elementsFrame = elementsFrame.insetBy(
                dx: (elementsFrame.width - smallestSide) / 2.0,
                dy: (elementsFrame.height - smallestSide) / 2.0
            )
        }
        
        self.bgView.frame           = elementsFrame
        self.textLabel.frame        = elementsFrame
        
        let size                            = self.bounds.height * 0.08 // always a percentage of the whole cell
        self.dotsView.frame                 = CGRect(x: 0, y: 0, width: size, height: size)
        self.dotsView.center                = CGPoint(x: self.textLabel.center.x, y: self.bounds.height - (2.5 * size))
        self.dotsView.layer.cornerRadius    = size * 0.5 // round it
        
        switch CalendarView.Style.cellShape {
        case .square:
            self.bgView.layer.cornerRadius = 2.0
        case .round:
            self.bgView.layer.cornerRadius = 18.0
        case .bevel(let radius):
            self.bgView.layer.cornerRadius = radius
        }
    }
}
