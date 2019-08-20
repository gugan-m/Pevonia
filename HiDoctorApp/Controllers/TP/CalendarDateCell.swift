//
//  CalendarDateCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 07/25/17.
//  Copyright © 2017 Swaas Systems. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDateCell: JTAppleCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var arrowImg: UIImageView!
    
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date)
    {
        if cellState.dateBelongsTo == .thisMonth
        {
            self.isHidden = false
        }
        else
        {
            self.isHidden = true
        }
        
        dateLbl.text = cellState.text
        configureTextColor(cellState, date: date)
        configueViewIntoBubbleView(cellState, date: date)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.wrapperView.layer.cornerRadius = self.wrapperView.bounds.size.width / 2
    }
    
    
    func cellSelectionChanged(_ cellState: CellState, date: Date)
    {
        if cellState.isSelected == true
        {
            if wrapperView.isHidden == true
            {
                configueViewIntoBubbleView(cellState, date: getServerFormattedDate(date: date))
            }
            else
            {
                let stringDate = convertDateIntoServerStringFormat(date: getServerFormattedDate(date: date))
                let calendarModelList : TourPlannerHeader? = BL_TPCalendar.sharedInstance.getTPData(date: stringDate)
                
                if calendarModelList != nil
                {
                    if BL_TPCalendar.sharedInstance.isToday(date: date) || calendarModelList?.Status == TPStatus.applied.rawValue || calendarModelList?.Status == TPStatus.approved.rawValue || calendarModelList?.Status == TPStatus.unapproved.rawValue || calendarModelList?.Status == TPStatus.drafted.rawValue || calendarModelList?.Is_Holiday == 1 || calendarModelList?.Is_Weekend == 1
                    {
                        configueViewIntoBubbleView(cellState, date: date)
                        
                    }
                }
                else
                {
                    if BL_TPCalendar.sharedInstance.isToday(date: date)
                    {
                        configueViewIntoBubbleView(cellState, date: date)
                    }
                }
                
            }
        }
            //            else
            //            {
            //                let calendarModelList : TourPlannerHeader? = BL_TPCalendar.sharedInstance.getTPData(date: date)
            //
            //                if calendarModelList != nil
            //                {
            //                    if BL_TPCalendar.sharedInstance.isToday(date: date) || calendarModelList?.Status == TPStatus.applied.rawValue || calendarModelList?.Status == TPStatus.approved.rawValue || calendarModelList?.Status == TPStatus.unapproved.rawValue || calendarModelList?.Status == TPStatus.drafted.rawValue || calendarModelList?.Is_Holiday == 1 || calendarModelList?.Is_Weekend == 1
            //                    {
            //                        configueViewIntoBubbleView(cellState, date: date)
            //
            //                        dateLbl.textColor = TPCellColor.selectedTextColor.color
            //
            //                        arrowImg.isHidden = false
            //
            //                        wrapperView.backgroundColor = TPCellColor.textSelectedBgColor.color
            //
            //                    }
            //
            //                }
            //                else
            //                {
            //
            //                    if BL_TPCalendar.sharedInstance.isToday(date: date)
            //                    {
            //                        configueViewIntoBubbleView(cellState, date: date)
            //                    }
            //
            //                }
            //            }
            //        }
        else
        {
            configueViewIntoBubbleView(cellState, date: date, animateDeselection: true)
        }
    }
    
    func configureTextColor(_ cellState: CellState, date: Date)
    {
        let selectedDate = getServerFormattedDate(date: date)
        let filtered = BL_TPCalendar.sharedInstance.tourPlannerHeader.filter{
            $0.TP_Date == selectedDate
        }
        
        var calendarModelList : TourPlannerHeader?
        
        if (filtered.count > 0)
        {
            calendarModelList = filtered.first!
        }
        
        if calendarModelList != nil
        {
            if BL_TPCalendar.sharedInstance.isToday(date: date)
            {
                wrapperView.backgroundColor = TPCellColor.todayBgColor.color
                dateLbl.textColor = TPCellColor.todayTextColor.color
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Status == TPStatus.drafted.rawValue
            {
                wrapperView.backgroundColor = TPCellColor.draftedBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Status == TPStatus.approved.rawValue
            {
                wrapperView.backgroundColor = TPCellColor.approvedBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Status == TPStatus.applied.rawValue
            {
                wrapperView.backgroundColor = TPCellColor.appliedBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Status == TPStatus.unapproved.rawValue
            {
                wrapperView.backgroundColor = TPCellColor.unApprovedBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Is_Weekend == 1
            {
                wrapperView.backgroundColor = TPCellColor.weekEndBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else if calendarModelList?.Is_Holiday == 1
            {
                wrapperView.backgroundColor = TPCellColor.holidayBgColor.color
                dateLbl.textColor = TPCellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                arrowImg.isHidden = true
            }
            else
            {
                wrapperView.backgroundColor = UIColor.clear
                
                if cellState.isSelected
                {
                    dateLbl.textColor = TPCellColor.normalTextColor.color
                    arrowImg.isHidden = false
                }
                else if cellState.dateBelongsTo == .thisMonth
                {
                    dateLbl.textColor = TPCellColor.selectedTextColor.color
                    arrowImg.isHidden = true
                }
            }
        }
        else
        {
            if cellState.isSelected
            {
                dateLbl.textColor = TPCellColor.normalTextColor.color
                arrowImg.isHidden = false
            }
            else if cellState.dateBelongsTo == .thisMonth
            {
                dateLbl.textColor = TPCellColor.selectedTextColor.color
                arrowImg.isHidden = true
            }
        }
    }
    
    func configureTextColor(_ cellState: CellState)
    {
        if cellState.isSelected
        {
            dateLbl.textColor = TPCellColor.normalTextColor.color
            arrowImg.isHidden = false
        }
        else if cellState.dateBelongsTo == .thisMonth
        {
            dateLbl.textColor = TPCellColor.selectedTextColor.color
            arrowImg.isHidden = true
        }
    }
    
    func configueViewIntoBubbleView(_ cellState: CellState, date: Date, animateDeselection: Bool = false)
    {
        let selectedDate = getServerFormattedDate(date: date)
        let filtered = BL_TPCalendar.sharedInstance.tourPlannerHeader.filter{
            $0.TP_Date == selectedDate
        }
        
        var calendarModelList : TourPlannerHeader?
        
        if (filtered.count > 0)
        {
            calendarModelList = filtered.first!
        }
        
        if cellState.isSelected
        {
            self.wrapperView.isHidden = false
            configureTextColor(cellState)
        }
        else
        {
            if animateDeselection
            {
                configureTextColor(cellState)
                
                if wrapperView.isHidden == false
                {
                    self.wrapperView.isHidden = true
                    self.wrapperView.alpha = 1
                    
                    if calendarModelList != nil
                    {
                        if BL_TPCalendar.sharedInstance.isToday(date: date)
                        {
                            self.wrapperView.isHidden = false
                            wrapperView.backgroundColor = TPCellColor.todayBgColor.color
                            dateLbl.textColor = TPCellColor.todayTextColor.color
                            arrowImg.isHidden = true
                            
                        }
                        else if calendarModelList?.Status == TPStatus.drafted.rawValue
                        {
                            self.wrapperView.isHidden = false
                            wrapperView.backgroundColor = TPCellColor.draftedBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        } else if calendarModelList?.Status == TPStatus.approved.rawValue
                        {
                            self.wrapperView.isHidden = false
                            wrapperView.backgroundColor = TPCellColor.approvedBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        } else if calendarModelList?.Status == TPStatus.applied.rawValue
                        {
                            self.wrapperView.isHidden = false
                            
                            wrapperView.backgroundColor = TPCellColor.appliedBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        } else if calendarModelList?.Status == TPStatus.unapproved.rawValue
                        {
                            self.wrapperView.isHidden = false
                            
                            wrapperView.backgroundColor = TPCellColor.unApprovedBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        }
                        else if calendarModelList?.Is_Weekend == 1
                        {
                            wrapperView.backgroundColor = TPCellColor.weekEndBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        }
                        else if calendarModelList?.Is_Holiday == 1
                        {
                            self.wrapperView.isHidden = false
                            
                            wrapperView.backgroundColor = TPCellColor.holidayBgColor.color
                            dateLbl.textColor = TPCellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            arrowImg.isHidden = true
                            
                        }
                        else
                        {
                            wrapperView.backgroundColor = UIColor.clear
                            if cellState.isSelected
                            {
                                dateLbl.textColor = TPCellColor.normalTextColor.color
                                arrowImg.isHidden = false
                            } else if cellState.dateBelongsTo == .thisMonth
                            {
                                dateLbl.textColor = TPCellColor.selectedTextColor.color
                                arrowImg.isHidden = true
                            }
                        }
                        
                    }
                    else
                    {
                        if BL_TPCalendar.sharedInstance.isToday(date: date)
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = TPCellColor.selectedTextColor.color
                            dateLbl.textColor = TPCellColor.todayTextColor.color
                        }
                    }
                }
            }
            else
            {
                if calendarModelList != nil
                {
                    if BL_TPCalendar.sharedInstance.isToday(date: date) || calendarModelList?.Status == TPStatus.applied.rawValue || calendarModelList?.Status == TPStatus.approved.rawValue || calendarModelList?.Status == TPStatus.unapproved.rawValue || calendarModelList?.Status == TPStatus.drafted.rawValue || calendarModelList?.Is_Holiday == 1 || calendarModelList?.Is_Weekend == 1
                    {
                        wrapperView.isHidden = false
                    } else {
                        wrapperView.isHidden = true
                    }
                }
                else
                {
                    if BL_TPCalendar.sharedInstance.isToday(date: date)
                    {
                        wrapperView.isHidden = false
                    }
                    else
                    {
                        
                        wrapperView.isHidden = true
                    }
                }
            }
        }
        
        if calendarModelList != nil
        {
            if BL_TPCalendar.sharedInstance.isToday(date: date)
            {
                if(cellState.isSelected)
                {
                    setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                }
                else
                {
                    setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.todayBgColor.color, arrowImage: true)
                }
            }
            else if calendarModelList?.Status == TPStatus.drafted.rawValue
            {
                if(cellState.isSelected)
                {
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                        
                        
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                        
                    else
                    {
                        setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                    }
                }
                else
                {
                    
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                    
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                    
                    else
                    
                    {
                    setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.draftedBgColor.color, arrowImage: true)
                    }
                }
                
                
            } else if calendarModelList?.Status == TPStatus.approved.rawValue
            {
                if(cellState.isSelected)
                {
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                        
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                        
                    else
                    {
                        setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                    }
                }
                else
                {
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                       
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                        
                    else
                        
                    {
                    setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.approvedBgColor.color, arrowImage: true)
                }
                    
                }
                
            } else if calendarModelList?.Status == TPStatus.applied.rawValue
            {
                if(cellState.isSelected)
                {
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                    
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                        
                    else
                    {
                        setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                    }
//                    setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                }
                else
                {
                    
                    if calendarModelList?.Is_Weekend == 1
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                    }
                        
                    else if calendarModelList?.Is_Holiday == 1
                        
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                        
                    else
                        
                    {
                    setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.appliedBgColor.color, arrowImage: true)
                
                    }
                    }
                
                
            } else if calendarModelList?.Status == TPStatus.unapproved.rawValue
            {
                if((calendarModelList?.Activity)! > 0)
                {
                    if(cellState.isSelected)
                    {
                        if calendarModelList?.Is_Weekend == 1
                        {
                            setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                        }
                         
                        else if calendarModelList?.Is_Holiday == 1
                            
                        {
                            setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                        }
                            
                        else
                        {
                            setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                        }
                    }
                    else
                    {
                        
                        if calendarModelList?.Is_Weekend == 1
                        {
                            setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: false)
                        }
                            
                        else if calendarModelList?.Is_Holiday == 1
                            
                        {
                            setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                        }
                            
                        else
                            
                        {
                           
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.unApprovedBgColor.color, arrowImage: true)
                        }
                    
                    }
                }
                else if calendarModelList?.Is_Weekend == 1
                {
                    if(cellState.isSelected)
                    {
                        setColor(textColor: TPCellColor.todayTextColor.color, wrapperColor: TPCellColor.selectedTextColor.color, arrowImage: false)
                        
                    }
                    else
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.weekEndBgColor.color, arrowImage: true)
                    }
                    
                }
                else if calendarModelList?.Is_Holiday == 1
                {
                    if(cellState.isSelected)
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: false)
                    }
                    else
                    {
                        setColor(textColor: TPCellColor.selectedTextColor.color, wrapperColor: TPCellColor.holidayBgColor.color, arrowImage: true)
                    }
                    
                }
                
            }
            else
            {
                wrapperView.backgroundColor = UIColor.clear
                if cellState.isSelected
                {
                    dateLbl.textColor = TPCellColor.selectedTextColor.color
                    arrowImg.isHidden = false
                } else if cellState.dateBelongsTo == .thisMonth
                {
                    dateLbl.textColor = TPCellColor.normalTextColor.color
                    arrowImg.isHidden = true
                }
            }
            
        }
            
        else
        {
            
            if BL_TPCalendar.sharedInstance.isToday(date: date)
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = TPCellColor.selectedTextColor.color
                    dateLbl.textColor = TPCellColor.normalTextColor.color
                    arrowImg.isHidden = false
                } else
                {
                    wrapperView.backgroundColor = TPCellColor.todayBgColor.color
                    dateLbl.textColor = TPCellColor.todayTextColor.color
                    arrowImg.isHidden = true
                }
            }
            else
            {
                if cellState.selectedPosition() == .middle
                {
                    wrapperView.backgroundColor = UIColor.clear
                } else
                {
                    wrapperView.backgroundColor = TPCellColor.selectedTextColor.color
                }
            }
        }
        
    }
    func setColor(textColor: UIColor,wrapperColor: UIColor,arrowImage:Bool)
    {
        wrapperView.backgroundColor = wrapperColor
        dateLbl.textColor = textColor
        arrowImg.isHidden = arrowImage
    }
}
