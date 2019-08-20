//
//  DCRCalendarCellView.swift
//  HiDoctorApp
//
//  Created by Vijay on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DCRCalendarCellView: JTAppleCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    func setupCellBeforeDisplay(_ cellState: CellState, date: Date)
    {
        if cellState.dateBelongsTo == .thisMonth
        {
            self.isHidden = false
        } else
        {
            self.isHidden = true
        }
        
        dateLabel.text = cellState.text
        configureTextColor(cellState, date: date)
        configueViewIntoBubbleView(cellState, date: date)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.wrapperView.layer.cornerRadius = self.wrapperView.bounds.size.width / 2
    }
    
    func configureTextColor(_ cellState: CellState, date: Date)
    {
        let calendarModelList : [DCRCalendarModel] = BL_DCRCalendar.sharedInstance.getDCRData(date: date)
        if calendarModelList.count > 0
        {
            let calendarModel = calendarModelList[0] as DCRCalendarModel
            if BL_DCRCalendar.sharedInstance.isToday(date: date)
            {
                wrapperView.backgroundColor = CellColor.todayBgColor.color
                dateLabel.textColor = CellColor.todayTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            } else if calendarModel.DCR_Status == DCRStatus.drafted.rawValue
            {
                wrapperView.backgroundColor = CellColor.draftedBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            } else if calendarModel.DCR_Status == DCRStatus.approved.rawValue
            {
                wrapperView.backgroundColor = CellColor.approvedBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            } else if calendarModel.DCR_Status == DCRStatus.applied.rawValue
            {
                wrapperView.backgroundColor = CellColor.appliedBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            } else if calendarModel.DCR_Status == DCRStatus.unApproved.rawValue
            {
                wrapperView.backgroundColor = CellColor.unApprovedBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            } else if calendarModel.Is_Holiday == 1
            {
                wrapperView.backgroundColor = CellColor.holidayBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            
            else if calendarModel.Is_WeekEnd == 1
            {
                wrapperView.backgroundColor = CellColor.draftedBgColor.color
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            
            
            else
            {
                wrapperView.backgroundColor = UIColor.clear
                lockImageView.isHidden = false
                wrapperView.layer.borderWidth = 0.0
                if cellState.isSelected
                {
                    dateLabel.textColor = CellColor.textSelectedColor.color
                } else if cellState.dateBelongsTo == .thisMonth
                {
                    dateLabel.textColor = CellColor.normalTextColor.color
                } else
                {
                    dateLabel.textColor = CellColor.prevMonthTextColor.color
                }
            }
            
            if calendarModel.Activity_Count == 1
            {
                dotLabel.isHidden = false
                dotLabel.text = "."
            } else if calendarModel.Activity_Count == 2
            {
                dotLabel.isHidden = false
                dotLabel.text = ".."
            } else {
                dotLabel.isHidden = true
            }
            
            if calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1 || calendarModel.Is_LockLeave == 1
                //calendarModel.Is_LockLeave == 1
            {
                wrapperView.backgroundColor = UIColor.clear
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 2.0
                wrapperView.layer.borderColor = CellColor.normalTextColor.color.cgColor
                lockImageView.isHidden = false
            }
            
        } else
        {
            if BL_DCRCalendar.sharedInstance.isToday(date: date)
            {
                wrapperView.backgroundColor = CellColor.todayBgColor.color
                dateLabel.textColor = CellColor.todayTextColor.color
            } else
            {
                wrapperView.backgroundColor = UIColor.clear
                if cellState.isSelected
                {
                    dateLabel.textColor = CellColor.textSelectedColor.color
                } else if cellState.dateBelongsTo == .thisMonth
                {
                    dateLabel.textColor = CellColor.normalTextColor.color
                } else
                {
                    dateLabel.textColor = CellColor.prevMonthTextColor.color
                }
            }
            
            wrapperView.layer.borderWidth = 0.0
            lockImageView.isHidden = true
            dotLabel.isHidden = true
            
            if calendarModelList.count > 0
            {
                let calendarModel = calendarModelList[0] as DCRCalendarModel
                if calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1 || calendarModel.Is_LockLeave == 1
                    //calendarModel.Is_LockLeave == 1
                {
                    wrapperView.backgroundColor = UIColor.clear
                    dateLabel.textColor = CellColor.normalTextColor.color
                    wrapperView.layer.borderWidth = 2.0
                    wrapperView.layer.borderColor = CellColor.normalTextColor.color.cgColor
                    lockImageView.isHidden = false
                }
            }
        }
    }
    
    func configureTextColor(_ cellState: CellState)
    {
        if cellState.isSelected
        {
            dateLabel.textColor = CellColor.textSelectedColor.color
        }
        else if cellState.dateBelongsTo == .thisMonth
        {
            dateLabel.textColor = CellColor.normalTextColor.color
        }
        else
        {
            dateLabel.textColor = CellColor.prevMonthTextColor.color
        }
    }
    
    func cellSelectionChanged(_ cellState: CellState, date: Date)
    {
        if cellState.isSelected == true
        {
            if wrapperView.isHidden == true
            {
                configueViewIntoBubbleView(cellState, date: date)
            }
            else
            {
                let calendarModelList : [DCRCalendarModel] = BL_DCRCalendar.sharedInstance.getDCRData(date: date)
                
                if calendarModelList.count > 0
                {
                    let calendarModel = calendarModelList[0] as DCRCalendarModel
                    BL_DCRCalendar.sharedInstance.selectedStatus = calendarModel.DCR_Status
                    if BL_DCRCalendar.sharedInstance.isToday(date: date) || calendarModel.DCR_Status == DCRStatus.applied.rawValue || calendarModel.DCR_Status == DCRStatus.approved.rawValue || calendarModel.DCR_Status == DCRStatus.unApproved.rawValue || calendarModel.DCR_Status == DCRStatus.drafted.rawValue || calendarModel.Is_Holiday == 1 || calendarModel.Is_WeekEnd == 1 || calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1 || calendarModel.Is_LockLeave == 1
                    {
                        configueViewIntoBubbleView(cellState, date: date)
                    }
                }
                else
                {
                    if BL_DCRCalendar.sharedInstance.isToday(date: date)
                    {
                        configueViewIntoBubbleView(cellState, date: date)
                    }
                }
                
            }
        }
        else
        {
            configueViewIntoBubbleView(cellState, date: date, animateDeselection: true)
        }
    }
    
    func configueViewIntoBubbleView(_ cellState: CellState, date: Date, animateDeselection: Bool = false)
    {
        let calendarModelList : [DCRCalendarModel] = BL_DCRCalendar.sharedInstance.getDCRData(date: date)
        
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
                    
                    if calendarModelList.count > 0
                    {
                        let calendarModel = calendarModelList[0] as DCRCalendarModel
                        
                        if BL_DCRCalendar.sharedInstance.isToday(date: date)
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.todayBgColor.color
                            dateLabel.textColor = CellColor.todayTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.DCR_Status == DCRStatus.drafted.rawValue
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.draftedBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.DCR_Status == DCRStatus.approved.rawValue
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.approvedBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.DCR_Status == DCRStatus.applied.rawValue
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.appliedBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.DCR_Status == DCRStatus.unApproved.rawValue
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.unApprovedBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.Is_Holiday == 1
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.holidayBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                        else if calendarModel.Is_WeekEnd == 1
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.draftedBgColor.color
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                    }
                    else
                    {
                        if BL_DCRCalendar.sharedInstance.isToday(date: date)
                        {
                            self.wrapperView.isHidden = false
                            self.wrapperView.backgroundColor = CellColor.todayBgColor.color
                            dateLabel.textColor = CellColor.todayTextColor.color
                            wrapperView.layer.borderWidth = 0.0
                            lockImageView.isHidden = true
                        }
                    }
                    
                    if calendarModelList.count > 0
                    {
                        let calendarModel = calendarModelList[0] as DCRCalendarModel
                        if calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1
                            || calendarModel.Is_LockLeave == 1
                        {
                            wrapperView.isHidden = false
                            wrapperView.backgroundColor = UIColor.clear
                            dateLabel.textColor = CellColor.normalTextColor.color
                            wrapperView.layer.borderWidth = 2.0
                            wrapperView.layer.borderColor = CellColor.normalTextColor.color.cgColor
                            lockImageView.isHidden = false
                        }
                    }
                }
            }
            else
            {
                if calendarModelList.count > 0
                {
                    let calendarModel = calendarModelList[0] as DCRCalendarModel
                    if BL_DCRCalendar.sharedInstance.isToday(date: date) || calendarModel.DCR_Status == DCRStatus.applied.rawValue || calendarModel.DCR_Status == DCRStatus.approved.rawValue || calendarModel.DCR_Status == DCRStatus.unApproved.rawValue || calendarModel.DCR_Status == DCRStatus.drafted.rawValue || calendarModel.Is_Holiday == 1 || calendarModel.Is_WeekEnd == 1 || calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1 || calendarModel.Is_LockLeave == 1
                    {
                        wrapperView.isHidden = false
                    }
                    else
                    {
                        wrapperView.isHidden = true
                    }
                }
                else
                {
                    if BL_DCRCalendar.sharedInstance.isToday(date: date)
                    {
                        wrapperView.isHidden = false
                    } else
                    {
                        wrapperView.isHidden = true
                    }
                }
            }
        }
        
        if calendarModelList.count > 0
        {
            let calendarModel = calendarModelList[0] as DCRCalendarModel
            
            if BL_DCRCalendar.sharedInstance.isToday(date: date)
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.todayBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else if calendarModel.DCR_Status == DCRStatus.drafted.rawValue
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.draftedBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else if calendarModel.DCR_Status == DCRStatus.approved.rawValue
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.approvedBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else if calendarModel.DCR_Status == DCRStatus.applied.rawValue
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.appliedBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else if calendarModel.DCR_Status == DCRStatus.unApproved.rawValue
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.unApprovedBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else if calendarModel.Is_Holiday == 1
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                } else
                {
                    wrapperView.backgroundColor = CellColor.holidayBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
                
            else if calendarModel.Is_WeekEnd == 1
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                } else
                {
                    wrapperView.backgroundColor = CellColor.draftedBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
                
            else if calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1
                || calendarModel.Is_LockLeave == 1
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                    wrapperView.layer.borderWidth = 0.0
                    lockImageView.isHidden = true
                }
                else
                {
                    wrapperView.backgroundColor = UIColor.clear
                    wrapperView.layer.borderWidth = 2.0
                    wrapperView.layer.borderColor = CellColor.normalTextColor.color.cgColor
                    lockImageView.isHidden = false
                }
                
            }
            else
            {
                if cellState.selectedPosition() == .middle
                {
                    wrapperView.backgroundColor = UIColor.clear
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            
            if calendarModel.Is_Attendance_Lock == 1 || calendarModel.Is_Field_Lock == 1 || calendarModel.Is_LockLeave == 1
                //calendarModel.Is_LockLeave == 1
            {
                wrapperView.backgroundColor = UIColor.clear
                dateLabel.textColor = CellColor.normalTextColor.color
                wrapperView.layer.borderWidth = 2.0
                wrapperView.layer.borderColor = CellColor.normalTextColor.color.cgColor
                lockImageView.isHidden = false
            }
            
        }
        else
        {
            if BL_DCRCalendar.sharedInstance.isToday(date: date)
            {
                if cellState.isSelected
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.todayBgColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
            else
            {
                if cellState.selectedPosition() == .middle
                {
                    wrapperView.backgroundColor = UIColor.clear
                }
                else
                {
                    wrapperView.backgroundColor = CellColor.normalTextColor.color
                }
                wrapperView.layer.borderWidth = 0.0
                lockImageView.isHidden = true
            }
        }
    }
}
