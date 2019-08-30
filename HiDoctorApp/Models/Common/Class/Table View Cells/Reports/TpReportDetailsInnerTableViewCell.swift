//
//  TpReportDetailsInnerTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol NavigationDelegate {
    func navigateToPlaylist()
}

class TpReportDetailsInnerTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sepHeightConst: NSLayoutConstraint!
    
    //MARK:-- Class
    var dataList : NSArray = []
    var workPlaceList : [StepperWorkPlaceModel] = []
    var sectionType : TpReportSectionHeader!
    var attendanceSectionType : TpAttendanceSectionHeader!
    
    var isCmngFromReportPage : Bool = false
    var delegate : NavigationDelegate!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.tableView.estimatedRowHeight = 500
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK:- TableView delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if sectionType == TpReportSectionHeader.WorkPlace || attendanceSectionType == TpAttendanceSectionHeader.WorkPlace
        {
            return workPlaceList.count
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if sectionType == TpReportSectionHeader.Travel || attendanceSectionType == TpAttendanceSectionHeader.Travel
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportSFCCell, for: indexPath) as! DCRStepperSFCTableViewCell
            
            let dict = dataList[indexPath.row] as! NSDictionary
            
            cell.fromPlaceLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "From_Place") as? String)
            cell.toPlaceLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "To_Place") as? String)
            var distance = checkNullAndNilValueForString(stringData: dict.object(forKey: "Distance") as? String)
            if distance == ""
            {
                distance = "0.0"
            }
            
            cell.distancePlaceLabel.text = distance
            cell.travelModeLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Travel_Mode") as? String)
            
            return cell
        }
        else if sectionType == TpReportSectionHeader.DoctorVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportDoctorVisitCell, for: indexPath) as! ApprovalDoctorVisitTableViewCell
            cell.doctorNameLbl.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String)
            cell.descriptionLbl.text = getDoctorVisitDetails(dict: dict)
            cell.sepViewHgtConstant.constant = 0.5
            cell.outerView.layer.masksToBounds = true
            cell.outerView.clipsToBounds = true
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(didTapAssetPlayBtn(button:)), for: .touchUpInside)
            if dataList.count == 1
            {
                cell.outerView.layer.cornerRadius = 5
                cell.sepViewHgtConstant.constant = 0
            }
            
            if indexPath.row == dataList.count - 1
            {
                cell.sepViewHgtConstant.constant = 0
            }
            
            
            cell.moreLblHeightConst.constant = 0
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportCommonCell, for: indexPath) as! WorkPlace_AccompanistTableViewCell
            
            var line1Text : String = ""
            var line2Text : String = ""
            
            cell.line1Lbl.font = UIFont(name: fontRegular, size: 13)
            
            if sectionType == TpReportSectionHeader.Accompanists
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                var employeName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
                let fromTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_Start_Time") as? String)
                let toTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_End_Time")as? String)
                var workingTime  : String = ""
                
                if fromTime == ""
                {
                    workingTime = NOT_APPLICABLE
                }
                else
                {
                    workingTime  = "\(fromTime) - \(toTime)"
                }
                
                if employeName == ""
                {
                    employeName = NOT_APPLICABLE
                }
                
                if workingTime == ""
                {
                    workingTime = NOT_APPLICABLE
                }
                
                line1Text = employeName
                line2Text = workingTime
            }
            else if sectionType == TpReportSectionHeader.WorkPlace || attendanceSectionType == TpAttendanceSectionHeader.WorkPlace
            {
                let workPlaceObj = workPlaceList[indexPath.row]
                
                cell.line1Lbl.font = UIFont(name: fontBold, size: 13)
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
            else if sectionType == TpReportSectionHeader.Product
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                cell.line1Lbl.font = UIFont(name: fontBold, size: 13)
                
                line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
                
                var quantity : String = ""
                var currentStock : String = ""
                
                quantity = checkNullAndNilValueForString(stringData: dict.object(forKey: "Quantity_Provided") as? String)
                
                if quantity == ""
                {
                    quantity = "null"
                }
                
                currentStock = checkNullAndNilValueForString(stringData: dict.object(forKey: "Current_Stock") as? String)
                
                if currentStock == ""
                {
                    currentStock = "null"
                }
                
                line2Text = "Quantity Provided : \(quantity) | Current_Stock : \(currentStock)"
            }
            else if attendanceSectionType == TpAttendanceSectionHeader.Activity
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            }
            
            cell.line1Lbl.text = line1Text
            cell.line2Lbl.text = line2Text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if sectionType ==  TpReportSectionHeader.Travel || attendanceSectionType == TpAttendanceSectionHeader.Travel
        {
            return BL_TpReport.sharedInstance.getSFCSingleCellHeight()
        }
        else if sectionType == TpReportSectionHeader.DoctorVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            return BL_TpReport.sharedInstance.getSingleDoctorVisitCellHeight() - 19 + BL_Approval.sharedInstance.getDoctorVisitDetails(dict: dict)
        }
        else if sectionType == TpReportSectionHeader.WorkPlace || attendanceSectionType == TpAttendanceSectionHeader.WorkPlace
        {
            return UITableViewAutomaticDimension //BL_Approval.sharedInstance.getLine2HeightForWorkPlace(text:detail.value) + BL_Approval.sharedInstance.getSingleCellHeight()
        }
        else
        {
            var section : Int = 0
            let dict = dataList[indexPath.row] as! NSDictionary
            
            if sectionType != nil
            {
                section = sectionType.rawValue
                
                if sectionType == TpReportSectionHeader.Product
                {
                    section = 6
                }
            }
            
            return BL_TpReport.sharedInstance.getSingleCellHeight() + BL_TpReport.sharedInstance.getLineHeightAccordingToType(sectionType: section, dict: dict)
        }
    }
    
    
    func getDoctorVisitDetails(dict : NSDictionary) -> String
    {
        var doctorDetails : String  = ""
        
        
        let Hospital_Name : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if Hospital_Name != ""
        {
            doctorDetails = Hospital_Name
        }
        
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
       // doctorDetails = doctorDetails + " | " + "MDL NO : \(mdlNumber)"
        
        let specialityName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Speciality_Name") as? String)
        if specialityName != ""
        {
            doctorDetails = doctorDetails + " | " + specialityName
        }
        
        var categoryName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category_Name") as? String)
        if categoryName == ""
        {
            categoryName = NOT_APPLICABLE
        }
        
        doctorDetails = doctorDetails + " | " + categoryName
        
        
        let regionName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Name") as? String)
        if regionName != ""
        {
            doctorDetails = doctorDetails + " | " + regionName
        }
        
        return doctorDetails
    }
    
    
    @objc func didTapAssetPlayBtn(button: UIButton){
        let dict = dataList[button.tag] as! NSDictionary
        print("dict",dict)
        BL_DoctorList.sharedInstance.regionCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Code") as? String)
        BL_DoctorList.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Code") as? String)
        BL_DoctorList.sharedInstance.doctorTitle = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String)
        
        let deletailedDBId = DBHelper.sharedInstance.getMaxCustomerDetailedId()
        
        if deletailedDBId != nil
        {
            BL_AssetModel.sharedInstance.detailedCustomerId = deletailedDBId! + 1
        }
        else
        {
            BL_AssetModel.sharedInstance.detailedCustomerId += 1
        }
        self.delegate.navigateToPlaylist()
        
    }
    
}
