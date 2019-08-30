//
//  DCRAttendanceMainTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 09/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol AddAttendanceSampleDelegate
{
    func didTapAddSampleBtn(sender: UIButton)
    func removeDoctorButtonAction(sender: UIButton)
    func didSelectExpandableCell()
}
class DCRAttendanceMainTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource
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
    @IBOutlet weak var sectionCoverButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coverButtonView: UIView!
    
    // MARK:- Variables
    var selectedIndex: Int!
    var parentTableView: UITableView!
    var stepperObj: DCRStepperModel!
    var delegate : AddAttendanceSampleDelegate!
    
    
    override func awakeFromNib()
    {
        self.childTableView.delegate = self
        self.childTableView.dataSource = self
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
        stepperObj = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
        
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
        
        if(selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.workplaceindex || selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.activityindex || selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.expenseindex)
        {
            return BL_DCR_Attendance_Stepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.travelindex)
        {
            return BL_DCR_Attendance_Stepper.sharedInstance.getSFCSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if ( selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.generalindex)
        {
            return BL_DCR_Attendance_Stepper.sharedInstance.getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if(selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
        {
           // let dict = BL_DCR_Attendance_Stepper.sharedInstance.doctorList[indexPath.row]
          //  return BL_Approval.sharedInstance.getSingleDoctorVisitCellHeight() + BL_DCR_Attendance_Stepper.sharedInstance.getDoctorVisitDetails(dict: dict)
            
          //  return BL_DCR_Attendance_Stepper.sharedInstance.getDoctorSingleCellHeight(selectedIndex: indexPath.row)
            
             return BL_Stepper.sharedInstance.getDoctorSingleCellHeight()
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.generalindex)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceStepperRemarksCell) as! DCRStepperRemarksTableViewCell
            
            cell.line1Label.text = BL_DCR_Attendance_Stepper.sharedInstance.dcrHeaderObj!.DCR_General_Remarks
            cell.line2Label.text = EMPTY
            
            return cell
        }
        else if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.travelindex)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: AttendanceSFCCell) as! DCRStepperSFCTableViewCell
            let sfcList = BL_DCR_Attendance_Stepper.sharedInstance.sfcList
            let sfcObj:DCRTravelledPlacesModel = sfcList[indexPath.row]
            
            cell.fromPlaceLabel.text = sfcObj.From_Place
            cell.toPlaceLabel.text = sfcObj.To_Place
            cell.distancePlaceLabel.text = String(sfcObj.Distance)
            cell.travelModeLabel.text = sfcObj.Travel_Mode.uppercased()
            
            return cell
        }
            
        else if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex)
        {
            
//            let doctorList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList
//            let doctorObj: StepperAttendanceDoctorModel = doctorList[indexPath.row]
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalDoctorVisitCell, for: indexPath) as! ApprovalDoctorVisitTableViewCell
//            cell.doctorNameLbl.text = "DoctorName: \(checkNullAndNilValueForString(stringData: doctorObj.Customer_Name))"
//            cell.descriptionLbl.text = getDoctorVisitDetails(dict: doctorObj)
//            cell.sepViewHgtConstant.constant = 0.5
//            cell.outerView.layer.masksToBounds = true
//            cell.outerView.clipsToBounds = true
//
//            if doctorList.count == 1
//            {
//                cell.outerView.layer.cornerRadius = 5
//                cell.sepViewHgtConstant.constant = 0
//            }
//
//            if indexPath.row == doctorList.count - 1
//            {
//                cell.sepViewHgtConstant.constant = 0
//            }
//
//            return cell
//
            
            
            
            
            
            
            
            
            
            
            
            
            
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TPStepperDoctorTVCell") as! TPStepperDoctorTableViewCell
//            let doctorList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList
//            let doctorObj: StepperAttendanceDoctorModel = doctorList[indexPath.row]
//
//            cell.doctorNameLabel.text = doctorObj.Customer_Name
//            cell.sampleList = doctorObj.sampleList
//
//            if !doctorObj.isExpanded
//            {
//                cell.addSampleBtn.isHidden = true
//                cell.removeDoctorBtn.isHidden = true
//                cell.sampleLabel.isHidden = true
//                cell.companyIcon.isHidden = true
//
//                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
//            }
//            else
//            {
//                cell.addSampleBtn.isHidden = false
//                cell.removeDoctorBtn.isHidden = false
//                cell.sampleLabel.isHidden = false
//                cell.companyIcon.isHidden = false
//                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
//            }
//
//            var mdlNum = String()
//            // cell.visitTimeLabel.text = doctorObj.Visit_Mode
//            if(doctorObj.MDL_Number != nil)
//            {
//                mdlNum = doctorObj.MDL_Number!
//            }
//            else
//            {
//                mdlNum = NOT_APPLICABLE
//            }
//            cell.line1Text.text = "MDL NO: " + mdlNum + " | " + (doctorObj.Speciality_Name)!
//
//            var line2Text: String = ""
//
////            if (checkNullAndNilValueForString(stringData: doctorObj.) != "")
////            {
////                line2Text = doctorObj.Category_Name!
////            }
//
//            if (checkNullAndNilValueForString(stringData: doctorObj.Region_Name) != "")
//            {
//                if (line2Text != "")
//                {
//                    line2Text = line2Text + " | " + doctorObj.Region_Name!
//                }
//                else
//                {
//                    line2Text = doctorObj.Region_Name!
//                }
//            }
//
//            cell.line2Text.text = line2Text
//            cell.addSampleBtn.tag = indexPath.row
//            cell.addSampleBtn.setTitle("ADD/MODIFY SAMPLES", for: .normal)
//            cell.addSampleBtn.addTarget(self, action: #selector(didTapAddSampleBtn), for: .touchUpInside)
//            cell.removeDoctorBtn.tag = indexPath.row
//            cell.removeDoctorBtn.addTarget(self, action: #selector(removeDoctorButtonAction), for: .touchUpInside)
//            cell.tableView.reloadData()
//            sectionCoverButton.isHidden = true
//
//            return cell
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperDoctorCell") as! DCRStepperDoctorTableViewCell
            let doctorList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList
            let doctorObj = doctorList[indexPath.row]
            
            cell.doctorNameLabel.text = doctorObj.Doctor_Name
            
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_VISIT_MODE) == PrivilegeValues.AM_PM.rawValue)
            {
            
                if(doctorObj.Visit_Mode != nil && doctorObj.Visit_Mode != ""){
                cell.visitTimeLabel.text = doctorObj.Visit_Mode
                //cell.visitTimeLabel.text = doctorObj.Visit_Time
                }else{
                    cell.visitTimeLabel.text = "N/A"
                }
            
            }
            
            else
            {
                if(doctorObj.Visit_Time != nil && doctorObj.Visit_Time != ""){
                cell.visitTimeLabel.text = doctorObj.Visit_Time
                //cell.visitTimeLabel.text = doctorObj.Visit_Mode
                }else{
                    cell.visitTimeLabel.text = "N/A"
                }
            }
            
            
//            cell.line1Text.text = "\(ccmNumberCaption): " + ccmNumberPrefix + doctorObj.MDL_Number! + " | " + doctorObj.Hospital_Name + " | " + doctorObj.Speciality_Name
//
            cell.line1Text.text =  doctorObj.Hospital_Name + " | " + doctorObj.Speciality_Name
            
            var line2Text: String = ""
            
            if (checkNullAndNilValueForString(stringData: doctorObj.Category_Name) != "")
            {
                line2Text = doctorObj.Category_Name!
            }
            
            if (checkNullAndNilValueForString(stringData: doctorObj.Doctor_Region_Name) != "")
            {
                if (line2Text != "")
                {
                    line2Text = line2Text + " | " + doctorObj.Doctor_Region_Name!
                }
                else
                {
                    line2Text = doctorObj.Doctor_Region_Name!
                }
            }
            
            cell.line2Text.text = line2Text
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:AttendanceSubCell) as! DCRAttendanceSubTableViewCell
            
            var line1Text: String = ""
            var line2Text: String = ""
            
            
            if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.workplaceindex)
            {
                let workPlaceList = BL_DCR_Attendance_Stepper.sharedInstance.workPlaceList
                let workPlaceObj: StepperWorkPlaceModel = workPlaceList[indexPath.row]
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
            else if (selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.expenseindex)
            {
                let expenseList = BL_DCR_Attendance_Stepper.sharedInstance.expenseList
                let expenseObj: DCRExpenseModel = expenseList[indexPath.row]
                
                line1Text = expenseObj.Expense_Type_Name
                line2Text = "Rs. " + String(expenseObj.Expense_Amount)
            }
                
            else if(selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.activityindex)
            {
                let activityList = BL_DCR_Attendance_Stepper.sharedInstance.activityList
                let activityObj : DCRAttendanceActivityModel = activityList[indexPath.row]
                
                line1Text = activityObj.Activity_Name!
                line2Text = "\(activityObj.Start_Time!) - \(activityObj.End_Time!)"
            }
            cell.line1Label.text = line1Text
            cell.line2Label.text = line2Text
            
            return cell
        }
        
    }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            if selectedIndex == BL_DCR_Attendance_Stepper.sharedInstance.doctorindex
            {
//                BL_DCR_Attendance_Stepper.sharedInstance.doctorList[indexPath.row].isExpanded = !BL_DCR_Attendance_Stepper.sharedInstance.doctorList[indexPath.row].isExpanded
//                
                delegate.didSelectExpandableCell()
            }
        }
    
    func getDoctorVisitDetails(dict : StepperAttendanceDoctorModel) -> String
    {
        
        var doctorDetails : String  = ""
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.MDL_Number)
        
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
        //doctorDetails = "MDL NO : \(mdlNumber)"
        
        let hospitalName : String = checkNullAndNilValueForString(stringData: dict.Hospital_Name)
        if hospitalName != ""
        {
            doctorDetails = doctorDetails + " | " + hospitalName
        }
        
        let specialityName : String = checkNullAndNilValueForString(stringData: dict.Speciality_Name)
        if specialityName != ""
        {
            doctorDetails = doctorDetails + " | " + specialityName
        }
        
        var categoryName : String = checkNullAndNilValueForString(stringData: "")
        if categoryName == ""
        {
            categoryName = NOT_APPLICABLE
        }
        
        doctorDetails = doctorDetails + " | " + categoryName
        
        
        let regionName = checkNullAndNilValueForString(stringData: dict.Region_Name)
        if regionName != ""
        {
            doctorDetails = doctorDetails + " | " + regionName
        }
        
        return doctorDetails
    }
    
    @objc func didTapAddSampleBtn(sender: UIButton)
    {
        BL_DCR_Attendance_Stepper.sharedInstance.selectedDoctorIndex = sender.tag
        self.delegate?.didTapAddSampleBtn(sender: sender)
    }
    
    @objc func removeDoctorButtonAction(sender: UIButton)
    {
        BL_DCR_Attendance_Stepper.sharedInstance.selectedDoctorIndex = sender.tag
        self.delegate?.removeDoctorButtonAction(sender: sender)
    }
    
    
}

