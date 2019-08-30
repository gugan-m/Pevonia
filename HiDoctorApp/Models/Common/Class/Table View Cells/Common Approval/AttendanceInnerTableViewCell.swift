//
//  AttendanceInnerTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AttendanceInnerTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var sepViewHgtConst: NSLayoutConstraint!
    
    //MARK:-- Class
    var dataList : NSArray = []
    var recordCount : Int!
    var sectionType : AttendanceHeaderType!
    var isMine : Bool = false
    var isComingFromTpPage : Bool = false
    var workPlaceList : [StepperWorkPlaceModel] = []
    var isOnline = Bool()
    var userObj : ApprovalUserMasterModel!
    
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
        if sectionType == AttendanceHeaderType.WorkPlace
        {
            if isComingFromTpPage
            {
                return 2
            }
            
            return 5
        }
     
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if sectionType == AttendanceHeaderType.Travel
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceSFCCell, for: indexPath) as! DCRStepperSFCTableViewCell
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
        else  if sectionType == AttendanceHeaderType.Doctor
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TpReportDoctorVisitCell, for: indexPath) as! ApprovalDoctorVisitTableViewCell
            cell.doctorNameLbl.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String)
            cell.descriptionLbl.text = getDoctorAttendanceSampleDetails(dict: dict)
            cell.sepViewHgtConstant.constant = 0.5
            cell.outerView.layer.masksToBounds = true
            cell.outerView.clipsToBounds = true
            cell.playBtn.tag = indexPath.row
            cell.accessoryType = .disclosureIndicator
            if dataList.count == 1
            {
                cell.outerView.layer.cornerRadius = 5
                cell.sepViewHgtConstant.constant = 0
            }
            
            if indexPath.row == dataList.count - 1
            {
                cell.sepViewHgtConstant.constant = 0
            }
            
            cell.backgroundColor = UIColor.clear
            cell.moreLblHeightConst.constant = 0
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceCommonCell, for: indexPath) as! WorkPlace_AccompanistTableViewCell
            
            var line1Text : String = ""
            var line2Text : String = ""
            
             cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
            
            if sectionType == AttendanceHeaderType.WorkPlace
            {

                let workPlaceObj = workPlaceList[indexPath.row]
                
                 cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
            else if  sectionType == AttendanceHeaderType.Expenses
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Expense_Type_Name") as? String)
                
                var expenseAmount : String = ""
                
                if isMine
                {
                    if let amount = dict.object(forKey: "Expense_Amount") as? Float
                    {
                        expenseAmount = String(amount)
                    }
                }
                else
                {
                    expenseAmount = checkNullAndNilValueForString(stringData: dict.object(forKey: "Expense_Amount") as? String)
                }
                
                line2Text = "Rs. \(expenseAmount)"
            }
            else
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
                if !isComingFromTpPage
                {
                    let workStartTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Start_Time") as? String)
                    
                    if workStartTime != ""
                    {
                        let  workToTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "End_Time") as? String)
                        line2Text = "\(workStartTime) - \(workToTime)"
                    }
                }
            }
            
            cell.line1Lbl.text = line1Text
            cell.line2Lbl.text = line2Text
            return cell
        }
    }
    func getDoctorAttendanceSampleDetails(dict : NSDictionary) -> String{
        var doctorDetails : String  = ""
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
     //   doctorDetails = "MDL NO : \(mdlNumber)"
        
        let HospitalName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if HospitalName != ""
        {
            doctorDetails = doctorDetails + " | " + HospitalName
        }
        
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(sectionType == AttendanceHeaderType.Doctor){
            let dict = dataList[indexPath.row] as! NSDictionary
            let dcrCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Code") as? String)
            let doctorVisitCode =  dict.object(forKey: "DCR_Visit_Code") as? Int
            DCRModel.sharedInstance.dcrId = dict.object(forKey: "DCR_Id") as? Int
            
            if let doctorVisitId = dict.object(forKey: "DCR_Doctor_Visit_Id") as? Int
            {
                DCRModel.sharedInstance.doctorVisitId = doctorVisitId
                BL_Reports.sharedInstance.doctorVisitId = doctorVisitId
                DCRModel.sharedInstance.customerVisitId = doctorVisitId
            }
            else if let doctorVisitId = dict.object(forKey: "Doctor_Visit_Id") as? Int
            {
                DCRModel.sharedInstance.doctorVisitId = doctorVisitId
                BL_Reports.sharedInstance.doctorVisitId = doctorVisitId
                DCRModel.sharedInstance.customerVisitId = doctorVisitId
            }
            
            DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Code") as? String)
            DCRModel.sharedInstance.customerRegionCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Region_Code") as? String)
            
            if !checkInternetConnectivity() && dcrCode != ""
            {
                showToastView(toastText: "No internet connection. Please try again")
            }
            else
            {
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalDoctorDetailVcID) as! ApprovalDoctorDetailsViewController
                if let visitCode = doctorVisitCode
                {
                    vc.doctorVisitCode = "\(visitCode)"
                }
                else
                {
                    vc.doctorVisitCode = EMPTY
                }
                vc.DCRCode = dcrCode
                vc.userCode = userObj.User_Code
                vc.dcrDate = userObj.Actual_Date
                vc.isFromAttendance = true
                vc.userObj = userObj
                vc.selectedIndex = indexPath.row
                getAppDelegate().root_navigation.pushViewController(vc, animated: true)
            }
//            let sampleList = dict.value(forKey: "Sample_List") as! [DCRAttendanceSampleDetailsModel]
//            let sb = UIStoryboard(name: Constants.StoaryBoardNames.commonApprovalDetailsSb, bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier:Constants.ViewControllerNames.AttendanceReportVCID) as! AttendanceSampleReportViewController
//            vc.sampleList = sampleList
//            if(!isMine)
//            {
//                let sampleList = dict.value(forKey: "Sample_List") as! NSArray
//               vc.sampleBatchList = sampleList
//            }
//            else
//            {
//                let sampleList = dict.value(forKey: "Sample_List") as! [DCRAttendanceSampleDetailsModel]
//                vc.sampleBatchList = BL_Reports.sharedInstance.getDCRAttendanceDoctorSampleDetails(sampleList: sampleList)
//            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if sectionType ==  AttendanceHeaderType.Travel
        {
            return BL_Approval.sharedInstance.getSFCSingleCellHeight()
        }
        else if sectionType == AttendanceHeaderType.WorkPlace
        {
            return UITableViewAutomaticDimension
        }
        else if sectionType == AttendanceHeaderType.Doctor{
            let dict = dataList[indexPath.row] as! NSDictionary
            
            return BL_TpReport.sharedInstance.getSingleDoctorVisitCellHeight() - 19 + BL_Approval.sharedInstance.getDoctorVisitDetails(dict: dict)
        }
        else
        {
            var section : Int = 0
            let dict = dataList[indexPath.row] as! NSDictionary
            
            if sectionType == AttendanceHeaderType.Expenses
            {
                section = 5
            }
            else if sectionType == AttendanceHeaderType.Activity
            {
                if isComingFromTpPage
                {
                    section = 7
                }
                else
                {
                    section = 8
                }
            }
            
             return BL_Approval.sharedInstance.getSingleCellHeight() + BL_Approval.sharedInstance.getLineHeightAccordingToType(sectionType: section, dict: dict)
        }
        
    }

}

