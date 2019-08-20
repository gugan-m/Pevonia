//
//  TPStepperMainTableViewCell.swift
//  HiDoctorApp
//
//  Created by Admin on 7/24/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol AddSampleDelegate
{
    func didTapAddSampleBtn(sender: UIButton)
    func removeDoctorButtonAction(sender: UIButton)
    func didSelectExpandableCell()
}

class TPStepperMainTableViewCell: UITableViewCell ,UITableViewDelegate, UITableViewDataSource
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
    @IBOutlet var childTableView: UITableView!
    @IBOutlet weak var doctorSectionTitleView: UIView!
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var sectionCoverButton: UIButton!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doctorTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sectionCoverBtnView: UIView!
    @IBOutlet weak var copyTpView: UIView!
    @IBOutlet weak var copyTpHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var copylabelheight: NSLayoutConstraint!
    @IBOutlet weak var copyTPViewCopyBut: UIButton!
    @IBOutlet weak var copyTPViewBut: UIButton!
    @IBOutlet weak var copyeditTpHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var copyTPbottomWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var copyTPButtonView: UIView!
    // MARK:- Variables
    var selectedIndex: Int!
    var stepperObj: DCRStepperModel!
    var delegate : AddSampleDelegate!
    var isFromTp: Bool = false
    
    // MARK:- Life Cycle Events
    override func awakeFromNib()
    {
        super.awakeFromNib()
        childTableView.delegate = self
        self.copyTPViewBut.isHidden = true
        self.copyTPViewCopyBut.isHidden = true
        self.copyTpHeightConstraint.constant = 0
        self.copyeditTpHeightConstraint.constant = 0
        self.copyTpView.layer.cornerRadius = 5
        self.copyTPButtonView.roundCorners([.bottomLeft,.bottomRight], radius: 5)
        self.copyTpView.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Table View Delegates
    
    func reloadTableViewAtIndexPath(row: Int)
    {
        let indexPath: NSIndexPath = NSIndexPath(row: row, section: 0)
        
        childTableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        stepperObj = BL_TPStepper.sharedInstance.stepperDataList[self.selectedIndex]
        
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
        if ( selectedIndex == 0  || selectedIndex == 1 || selectedIndex == 2)
        {
            return BL_TPStepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if (selectedIndex == 3)
        {
            return BL_TPStepper.sharedInstance.getSFCSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if (selectedIndex == 4 && isFromTp)
        {
            return BL_TPStepper.sharedInstance.getDoctorSingleCellHeight(selectedIndex: indexPath.row)
        }
        else if (selectedIndex == 4)
        {
            return BL_TPStepper.sharedInstance.getDoctorSingleCellHeight(selectedIndex: indexPath.row)
        }
        else if (selectedIndex == 5)
        {
            return BL_TPStepper.sharedInstance.getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (selectedIndex == 0 || selectedIndex == 1 || selectedIndex == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperCommonCell") as! DCRStepperCommonTableViewCell
            
            var line1Text: String = ""
            var line2Text: String = ""
            
            if (selectedIndex == 0)
            {
                let accompanistList = BL_TPStepper.sharedInstance.accompanistList
                let accompanistObj:UserMasterModel = accompanistList[indexPath.row].userObj
                
                line1Text = accompanistObj.Employee_name + "(" + checkNullAndNilValueForString(stringData: accompanistObj.User_Type_Name) + ")"
                
                cell.line1Label.text = line1Text
            }
            else if (selectedIndex == 1)
            {
                let meetingPlaceList = BL_TPStepper.sharedInstance.meetingPlaceList
                let meetingPlaceObj: StepperMeetingPlaceModel = meetingPlaceList[indexPath.row]
                line1Text = meetingPlaceObj.key
                line2Text = meetingPlaceObj.value
            }
            else if (selectedIndex == 2)
            {
                let workPlaceList = BL_TPStepper.sharedInstance.workPlaceList
                let workPlaceObj: StepperWorkPlaceModel  = workPlaceList[indexPath.row]
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
                        
            cell.line1Label.text = line1Text
            cell.line2Label.text = line2Text
            
            return cell
        }
        else if (selectedIndex == 3)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperSFCCell") as! DCRStepperSFCTableViewCell
            let sfcList = BL_TPStepper.sharedInstance.placesList
            let sfcObj:TourPlannerSFC = sfcList[indexPath.row]
            
            cell.fromPlaceLabel.text = sfcObj.From_Place
            cell.toPlaceLabel.text = sfcObj.To_Place
            cell.travelModeLabel.text = sfcObj.Travel_Mode.uppercased()
            
            return cell
        }
        else if (selectedIndex == 4)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPStepperDoctorTVCell") as! TPStepperDoctorTableViewCell
            let doctorList = BL_TPStepper.sharedInstance.doctorList
            let doctorObj: StepperDoctorModel = doctorList[indexPath.row]
            
            cell.doctorNameLabel.text = doctorObj.Customer_Name
            cell.isFromTp = true
            cell.sampleList1 = doctorObj.sampleList1
            
            if !doctorObj.isExpanded
            {
                cell.addSampleBtn.isHidden = true
                cell.removeDoctorBtn.isHidden = true
                cell.sampleLabel.isHidden = true
                cell.companyIcon.isHidden = true
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
            }
            else
            {
                cell.addSampleBtn.isHidden = false
                cell.removeDoctorBtn.isHidden = false
                cell.sampleLabel.isHidden = false
                cell.companyIcon.isHidden = false
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
            }
            
            // cell.visitTimeLabel.text = doctorObj.Visit_Mode
            cell.line1Text.text = doctorObj.Hospital_Name! + " | " + "MDL NO: " + doctorObj.MDL_Number! + " | " + (doctorObj.Speciality_Name)!
            
            var line2Text: String = ""
            
            if (checkNullAndNilValueForString(stringData: doctorObj.Category_Name) != "")
            {
                line2Text = doctorObj.Category_Name!
            }
            
            if (checkNullAndNilValueForString(stringData: doctorObj.Region_Name) != "")
            {
                if (line2Text != "")
                {
                    line2Text = line2Text + " | " + doctorObj.Region_Name!
                }
                else
                {
                    line2Text = doctorObj.Region_Name!
                }
            }
            
            cell.line2Text.text = line2Text
            cell.addSampleBtn.tag = indexPath.row
            cell.addSampleBtn.addTarget(self, action: #selector(didTapAddSampleBtn), for: .touchUpInside)
            cell.removeDoctorBtn.tag = indexPath.row
            cell.removeDoctorBtn.addTarget(self, action: #selector(removeDoctorButtonAction), for: .touchUpInside)
            cell.tableView.reloadData()
            return cell
        }   
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepperRemarksCell") as! DCRStepperRemarksTableViewCell
            
            cell.line1Label.text = BL_TPStepper.sharedInstance.generalRemarks
            cell.line2Label.text = EMPTY
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedIndex == 4
        {
            BL_TPStepper.sharedInstance.doctorList[indexPath.row].isExpanded = !BL_TPStepper.sharedInstance.doctorList[indexPath.row].isExpanded
            
            delegate.didSelectExpandableCell()
        }
    }
    
    @objc func didTapAddSampleBtn(sender: UIButton)
    {
        BL_TPStepper.sharedInstance.selectedDoctorIndex = sender.tag
        self.delegate?.didTapAddSampleBtn(sender: sender)
    }
    
    @objc func removeDoctorButtonAction(sender: UIButton)
    {
        BL_TPStepper.sharedInstance.selectedDoctorIndex = sender.tag
        self.delegate?.removeDoctorButtonAction(sender: sender)
    }
    
    @IBAction func viewAccompanistTP(_ sender: UIButton)
    {
        TPStepperViewController().navigateToAccompanistVC()
    }
    
    @IBAction func copyAccompanistTpDetails(_ sender: Any)
    {
        
    }
}
