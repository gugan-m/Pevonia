//
//  DCRStepperMainTableViewCell.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit


class DCRStepperMainTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource
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
    @IBOutlet weak var doctorSectionTitleLabel: UILabel!
    @IBOutlet weak var doctorSectionSubTitleLabel: UILabel!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var doctorSectionTitleView: UIView!
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var sectionCoverButton: UIButton!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doctorTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    
    // MARK:- Variables
    var selectedIndex: Int!
    var selectedEntityId: Int!
    var parentTableView: UITableView!
    var stepperObj: DCRStepperModel!
    
    // MARK:- Life Cycle Events
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
        stepperObj = BL_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
        
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
        if (selectedEntityId == DCR_Stepper_Entity_Id.Accompanist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.WorkPLace.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Chemist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Stockist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Expense.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Work_Time.rawValue)
        {
            return BL_Stepper.sharedInstance.getCommonSingleCellHeight()
        }
        else if (selectedEntityId == DCR_Stepper_Entity_Id.SFC.rawValue)
        {
            return BL_Stepper.sharedInstance.getSFCSingleCellHeight()
        }
        else if (selectedEntityId == DCR_Stepper_Entity_Id.Doctor.rawValue)
        {
            return BL_Stepper.sharedInstance.getDoctorSingleCellHeight()
        }
        else if (selectedEntityId == DCR_Stepper_Entity_Id.GeneralRemarks.rawValue)
        {
            return BL_Stepper.sharedInstance.getGeneralRemarksSingleCellHeight()
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (selectedEntityId == DCR_Stepper_Entity_Id.Accompanist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.WorkPLace.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Chemist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Stockist.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Expense.rawValue || selectedEntityId == DCR_Stepper_Entity_Id.Work_Time.rawValue)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCommonCell") as! DCRStepperCommonTableViewCell
            
            var line1Text: String = ""
            var line2Text: String = ""
            
            if (selectedEntityId == DCR_Stepper_Entity_Id.Accompanist.rawValue)
            {
                let accompanistList = BL_Stepper.sharedInstance.accompanistList
                let accompanistObj: DCRAccompanistModel = accompanistList[indexPath.row]
                
                line1Text = accompanistObj.Employee_Name! + "(" + checkNullAndNilValueForString(stringData: accompanistObj.Acc_User_Type_Name) + ")"
                line2Text = accompanistObj.Acc_Start_Time! + " - " + accompanistObj.Acc_End_Time!
                
                if (accompanistObj.Is_Only_For_Doctor == "1")
                {
                    line2Text += "|" + INDEPENDENTENT_CALL
                }
            }
            else if (selectedEntityId == DCR_Stepper_Entity_Id.WorkPLace.rawValue)
            {
                let workPlaceList = BL_Stepper.sharedInstance.workPlaceList
                let workPlaceObj: StepperWorkPlaceModel = workPlaceList[indexPath.row]
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
            else if (selectedEntityId == DCR_Stepper_Entity_Id.Chemist.rawValue)
            {
                let chemistList = BL_Stepper.sharedInstance.chemistDayHeaderList
                let objChemist: ChemistDayVisit = chemistList[indexPath.row]
                
                line1Text = objChemist.ChemistName
                
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
                    
                {
//                    line2Text = objChemist.MDLNumber + " | " + objChemist.RegionName +  " | " + objChemist.VisitTime! + objChemist.VisitMode!
                    line2Text = objChemist.RegionName +  " | " + objChemist.VisitTime! + objChemist.VisitMode!
                }
                else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_CHEMIST_VISIT_MODE) == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue) && (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
                {
                  //  line2Text = objChemist.MDLNumber + " | " + objChemist.RegionName +  " | " + objChemist.VisitTime! + objChemist.VisitMode!
                    line2Text =  objChemist.RegionName +  " | " + objChemist.VisitTime! + objChemist.VisitMode!
                }
                    
                else
                {
                  //  line2Text = objChemist.MDLNumber + " | " + objChemist.RegionName +  " | "  + objChemist.VisitMode!
                    line2Text =  objChemist.RegionName +  " | "  + objChemist.VisitMode!
                }
                
            }
            else if (selectedEntityId == DCR_Stepper_Entity_Id.Stockist.rawValue)
            {
                
                let stockistList = BL_Stepper.sharedInstance.stockistList
                let stockistObj: DCRStockistVisitModel = stockistList[indexPath.row]
                
                line1Text = stockistObj.Stockiest_Name
                
                
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
                    
                {
                    line2Text = "POB:" + String(stockistObj.POB_Amount!) + " | Collection:" + String(stockistObj.Collection_Amount!) +  " | " + stockistObj.Visit_Time! + stockistObj.Visit_Mode!
                }
                else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_STOCKIEST_VISIT_TIME) == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue) && (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
                {
                    line2Text = "POB:" + String(stockistObj.POB_Amount!) + " | Collection:" + String(stockistObj.Collection_Amount!) +  " | " + stockistObj.Visit_Time! + stockistObj.Visit_Mode!
                }
                else
                {
                    line2Text = "POB:" + String(stockistObj.POB_Amount!) + " | Collection:" + String(stockistObj.Collection_Amount!) +  " | " + stockistObj.Visit_Mode!
                }
                
                
                
                
            }
            else if (selectedEntityId == DCR_Stepper_Entity_Id.Expense.rawValue)
            {
                let expenseList = BL_Stepper.sharedInstance.expenseList
                let expenseObj: DCRExpenseModel = expenseList[indexPath.row]
                
                line1Text = expenseObj.Expense_Type_Name
                line2Text = "Rs. " + String(expenseObj.Expense_Amount)
            }
            else if (selectedEntityId == DCR_Stepper_Entity_Id.Work_Time.rawValue)
            {
                line1Text = "Start time & End time"
                
                let startTime = BL_Stepper.sharedInstance.dcrHeaderObj?.Start_Time
                let endTime = BL_Stepper.sharedInstance.dcrHeaderObj?.End_Time
                
                if (checkNullAndNilValueForString(stringData: startTime) != EMPTY && checkNullAndNilValueForString(stringData: endTime) != EMPTY)
                {
                    line2Text = startTime! + " - " + endTime!
                }
                else
                {
                    line2Text = NOT_APPLICABLE
                }
            }
            
            cell.line1Label.text = line1Text
            cell.line2Label.text = line2Text
            
            return cell
        }
        else if (selectedEntityId == DCR_Stepper_Entity_Id.SFC.rawValue)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperSFCCell") as! DCRStepperSFCTableViewCell
            let sfcList = BL_Stepper.sharedInstance.sfcList
            let sfcObj:DCRTravelledPlacesModel = sfcList[indexPath.row]
            
            cell.fromPlaceLabel.text = sfcObj.From_Place
            cell.toPlaceLabel.text = sfcObj.To_Place
            cell.distancePlaceLabel.text = String(sfcObj.Distance)
            cell.travelModeLabel.text = sfcObj.Travel_Mode.uppercased()
            
            return cell
        }
        else if (selectedEntityId == DCR_Stepper_Entity_Id.GeneralRemarks.rawValue)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperRemarksCell") as! DCRStepperRemarksTableViewCell
            
            cell.line1Label.text = BL_Stepper.sharedInstance.dcrHeaderObj!.DCR_General_Remarks
            cell.line2Label.text = EMPTY
            
            return cell
        }
        else //if (selectedEntityId == DCR_Stepper_Entity_Id.Doctor.rawValue)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperDoctorCell") as! DCRStepperDoctorTableViewCell
            let doctorList = BL_Stepper.sharedInstance.doctorList
            let doctorObj = doctorList[indexPath.row]
            let visittimeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_VISIT_MODE)
            
            
            cell.doctorNameLabel.text = doctorObj.Doctor_Name
            
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            {
                if(doctorObj.Visit_Time != nil){
                    cell.visitTimeLabel.text = doctorObj.Visit_Time
                }else{
                    if(doctorObj.Visit_Mode != nil){
                        cell.visitTimeLabel.text = doctorObj.Visit_Mode
                    }else{
                        cell.visitTimeLabel.text = "N/A"
                    }
                    
                }
                
            }
            else if (visittimeValue != PrivilegeValues.AM_PM.rawValue)
            {
                if(doctorObj.Visit_Time != nil){
                    cell.visitTimeLabel.text = doctorObj.Visit_Time
                }else{
                    if(doctorObj.Visit_Mode != nil){
                        cell.visitTimeLabel.text = doctorObj.Visit_Mode
                    }else{
                        cell.visitTimeLabel.text = "N/A"
                    }
                    
                }
                
            }
            else
            {
                cell.visitTimeLabel.text = doctorObj.Visit_Mode
            }
            
            
            
            let strHospitalName = checkNullAndNilValueForString(stringData: doctorObj.Hospital_Name) as? String
//            cell.line1Text.text = strHospitalName! + " | " + "\(ccmNumberCaption): " + ccmNumberPrefix + doctorObj.MDL_Number! + " | " + doctorObj.Speciality_Name
            cell.line1Text.text = strHospitalName!  + " | " + doctorObj.Speciality_Name
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
}
    }

