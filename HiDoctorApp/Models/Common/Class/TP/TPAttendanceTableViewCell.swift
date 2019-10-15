//
//  TPAttendanceTableViewCell.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPAttendanceTableViewCell: UITableViewCell , UITableViewDelegate, UITableViewDataSource
{
    
    
    // MARK:- Outlets
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var stepperNumberLabel: UILabel!
    @IBOutlet weak var sectionTitleImageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionToggleImageView: UIImageView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateSectionTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var emptyStateAddButton: UIButton!
    @IBOutlet weak var emptyStateSkipButton: UIButton!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var sectionCoverButton: UIButton!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    
    // MARK:- Variables
    var selectedIndex: Int!
    var parentTableView: UITableView!
    var stepperObj: DCRStepperModel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        stepperObj = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[self.selectedIndex]
        
        if (stepperObj.recordCount == 0)
        {
            return 0
        }
        else
        {
            if (stepperObj.isExpanded == false)
            {
                return 1
            }
            else
            {
                return stepperObj.recordCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(selectedIndex == 0 || selectedIndex == 2)
        {
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                return BL_TP_AttendanceStepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
            } else {
                if selectedIndex == 0 {
                   return BL_TP_AttendanceStepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
                } else {
                    return BL_TP_AttendanceStepper.sharedInstance.getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
                }
            }
        }
        else if (selectedIndex == 1)
        {
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                 return BL_TP_AttendanceStepper.sharedInstance.getSFCSingleCellHeight(selectedIndex: selectedIndex)
            } else {
                 return BL_TP_AttendanceStepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
            }
           
        }
        else if (selectedIndex == 3)
        {
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                return BL_TP_AttendanceStepper.sharedInstance.getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
            } else {
                return 0
            }
            
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (selectedIndex == 0 || selectedIndex == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:AttendanceSubCell) as! DCRAttendanceSubTableViewCell
            
            var line1Text: String = EMPTY
            var line2Text: String = EMPTY
            
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                if (selectedIndex == 0)
                {
                    let workPlaceList = BL_TP_AttendanceStepper.sharedInstance.workPlaceList
                    let workPlaceObj: StepperWorkPlaceModel = workPlaceList[indexPath.row]
                    
                    line1Text = workPlaceObj.key
                    line2Text = workPlaceObj.value
                }
                else if (selectedIndex == 2)
                {
                    line1Text = checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name)
                    line2Text = EMPTY
                }
                
                cell.line1Label.text = line1Text
                cell.line2Label.text = line2Text
                
                return cell
            } else {
                if (selectedIndex == 0)
                {
                    let workPlaceList = BL_TP_AttendanceStepper.sharedInstance.workPlaceList
                    let workPlaceObj: StepperWorkPlaceModel = workPlaceList[indexPath.row]
                    
                    line1Text = workPlaceObj.key
                    line2Text = workPlaceObj.value
                    
                    cell.line1Label.text = line1Text
                    cell.line2Label.text = line2Text
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceStepperRemarksCell) as! DCRStepperRemarksTableViewCell
                    
                    cell.line1Label.text = BL_TP_AttendanceStepper.sharedInstance.generalRemarks
                    cell.line2Label.text = EMPTY
                    
                    return cell
                }
            }
        }
        else if (selectedIndex == 1)
        {
            
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceSFCCell) as! DCRStepperSFCTableViewCell
                let sfcList = BL_TP_AttendanceStepper.sharedInstance.placesList
                let sfcObj: TourPlannerSFC = sfcList[indexPath.row]
                
                cell.fromPlaceLabel.text = sfcObj.From_Place
                cell.toPlaceLabel.text = sfcObj.To_Place
                cell.travelModeLabel.text = sfcObj.Travel_Mode.uppercased()
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier:AttendanceSubCell) as! DCRAttendanceSubTableViewCell
                
                var line1Text: String = EMPTY
                var line2Text: String = EMPTY
            
                line1Text = checkNullAndNilValueForString(stringData: BL_TP_AttendanceStepper.sharedInstance.objTPHeader?.Activity_Name)
                line2Text = EMPTY
                
                cell.line1Label.text = line1Text
                cell.line2Label.text = line2Text
                return cell
            }
        }
        else // if (selectedIndex == 3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceStepperRemarksCell) as! DCRStepperRemarksTableViewCell
            if BL_TP_AttendanceStepper.sharedInstance.isTravelEnabled(){
                
                cell.line1Label.text = BL_TP_AttendanceStepper.sharedInstance.generalRemarks
                cell.line2Label.text = EMPTY
            }
            return cell
        }
    }
}
