//
//  ApprovalInnerTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit


class ApprovalInnerTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Variables
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var sepHeightConst: NSLayoutConstraint!
    @IBOutlet weak var shadowView: CornerRadiusWithShadowView!
    
    //MARK:-- Class
    var dataList : NSArray = []
    var workPlaceList : [StepperWorkPlaceModel] = []
    var recordCount : Int!
    var sectionType : SectionHeaderType!
    var tpSectionType : TpSectionHeaderType!
    var isCmngFromReportPage : Bool = false
    var isMine : Bool = false
    var delegate : SelectedDoctorDetailsDelegate?
    var shadowLayer : CAShapeLayer = CAShapeLayer()

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
        if sectionType == SectionHeaderType.WorkPlace
        {
            return 6
        }
        else if tpSectionType == TpSectionHeaderType.WorkPlace
        {
            return 3
        }
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if sectionType == SectionHeaderType.Travel || tpSectionType == TpSectionHeaderType.Travel
        {
             let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalSFCCell, for: indexPath) as! DCRStepperSFCTableViewCell
            let dict = dataList[indexPath.row] as! NSDictionary
         
            cell.fromPlaceLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "From_Place") as? String)
            cell.toPlaceLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "To_Place") as? String)
              var distance = checkNullAndNilValueForString(stringData: dict.object(forKey: "Distance") as? String)
            
            if distance == ""
            {
                distance = "0.0"
            }
            
            if tpSectionType == TpSectionHeaderType.Travel
            {
                if let dis = dict.object(forKey: "Distance") as? Double
                {
                    distance = String(dis)
                }
            }
            
            cell.distancePlaceLabel.text = distance
            cell.travelModeLabel.text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Travel_Mode") as? String)
            
            return cell
        }
        else if sectionType == SectionHeaderType.DoctorVisit || tpSectionType == TpSectionHeaderType.DoctorVisit

        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalDoctorVisitCell, for: indexPath) as! ApprovalDoctorVisitTableViewCell
            cell.doctorNameLbl.text = "DoctorName: \(checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String))"
            cell.descriptionLbl.text = getDoctorVisitDetails(dict: dict)
            cell.sepViewHgtConstant.constant = 0.5
            cell.outerView.layer.masksToBounds = true
            cell.outerView.clipsToBounds = true
            
            if dataList.count == 1
            {
                cell.outerView.layer.cornerRadius = 5
                cell.sepViewHgtConstant.constant = 0
            }
            
            if indexPath.row == dataList.count - 1
            {
                cell.sepViewHgtConstant.constant = 0
            }
            
            if tpSectionType == TpSectionHeaderType.DoctorVisit
            {
               cell.moreLblHeightConst.constant = 0
            }
            
            return cell
        }
        else if sectionType == SectionHeaderType.ChemistVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalDoctorVisitCell, for: indexPath) as! ApprovalDoctorVisitTableViewCell
            cell.doctorNameLbl.text = "ChemistName: \(checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String))"
            
            //cell.descriptionLbl.text = getDoctorVisitDetails(dict: dict)
            cell.descriptionLbl.text = EMPTY
            cell.moreLbl.isHidden = false
            cell.moreLbl.text = "More..."
            
            if (dict.value(forKey: "Is_Chemist_Day") as! String == "0")
            {
                if let pobAmount = dict.value(forKey: "POB_Amount") as? Float
                {
                    cell.descriptionLbl.text = "POB: \(pobAmount)"
                }
                else if let pobAmount = dict.value(forKey: "POB_Amount") as? Double
                {
                    cell.descriptionLbl.text = "POB: \(pobAmount)"
                }
               // cell.descriptionLbl.text = "POB: \(dict.value(forKey: "POB_Amount") as! Float)"
                cell.moreLbl.isHidden = true
                cell.moreLbl.text = ""
            }
            
            cell.sepViewHgtConstant.constant = 0.5
            cell.outerView.layer.masksToBounds = true
            cell.outerView.clipsToBounds = true
            
            if dataList.count == 1
            {
                cell.outerView.layer.cornerRadius = 5
                cell.sepViewHgtConstant.constant = 0
            }
            
            if indexPath.row == dataList.count - 1
            {
                cell.sepViewHgtConstant.constant = 0
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalAccompanistsCell, for: indexPath) as! WorkPlace_AccompanistTableViewCell
            
            var line1Text : String = ""
            var line2Text : String = ""
            
            cell.line1Lbl.font = UIFont(name: fontRegular, size: 13)
            
            if sectionType == SectionHeaderType.Accompanists || tpSectionType == TpSectionHeaderType.Accompanists

            {
                cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                let dict = dataList[indexPath.row] as! NSDictionary
                var employeName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
                var fromTime : String = ""
                var toTime : String = ""
                
                
                let timeArray = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_Start_Time") as? String).components(separatedBy: "_")
                
                if timeArray.count > 0
                {
                    if timeArray.count > 1
                    {
                       fromTime = timeArray[0]
                       toTime = timeArray[1]
                    }
                    else
                    {
                        fromTime = timeArray[0]
                        toTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_End_Time") as? String)
                    }
                }
                else
                {
                    fromTime = EMPTY
                    toTime = EMPTY
                }

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
            else if sectionType == SectionHeaderType.WorkPlace || tpSectionType == TpSectionHeaderType.WorkPlace

            {
                let workPlaceObj = workPlaceList[indexPath.row]
                
                 cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                
                line1Text = workPlaceObj.key
                line2Text = workPlaceObj.value
            }
            else if sectionType == SectionHeaderType.Stockiest
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)

                var stockiestName : String = ""
                
                stockiestName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Stockiest_Name") as? String)
                if stockiestName == ""
                {
                    stockiestName = NOT_APPLICABLE
                }
                
                var pobAmount : String = ""
                
                if let pob = dict.value(forKey: "POB_Amount") as? Double
                {
                    pobAmount = String(pob)
                }
                
               if pobAmount == ""
               {
                 pobAmount = NOT_APPLICABLE
               }
                
                var collectionAmount : String = ""
                if let collection = dict.value(forKey: "Collection_Amount") as? Double
                {
                    collectionAmount = String(collection)
                }

                
                if collectionAmount == ""
                {
                    collectionAmount = NOT_APPLICABLE
                }
                
                line1Text = stockiestName
                line2Text  = "POB : \(pobAmount) - Collection Amount : \(collectionAmount)"
            }
            else if  sectionType == SectionHeaderType.Expense
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                
                line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Expense_Type_Name") as? String)
                
                var expenseAmount : String = ""
                
                if isCmngFromReportPage && isMine
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
            else if tpSectionType == TpSectionHeaderType.Product
            {
                let dict = dataList[indexPath.row] as! NSDictionary
                
                cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                
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
                     line2Text = "Quantity Provided : \(quantity)"
                 }
                 else
                 {
                     line2Text = "Quantity Provided : \(quantity) | Current_Stock : \(currentStock)"
                 }

            }
       
            cell.line1Lbl.text = line1Text
            cell.line2Lbl.text = line2Text
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if sectionType ==  SectionHeaderType.Travel || tpSectionType == TpSectionHeaderType.Travel
        {
            return BL_Approval.sharedInstance.getSFCSingleCellHeight()
        }
        else if sectionType == SectionHeaderType.DoctorVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            return BL_Approval.sharedInstance.getSingleDoctorVisitCellHeight() + BL_Approval.sharedInstance.getDoctorVisitDetails(dict: dict)
        }
        else if sectionType == SectionHeaderType.ChemistVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            return BL_Approval.sharedInstance.getSingleDoctorVisitCellHeight() + BL_Approval.sharedInstance.getChemistVisitHeight(dict: dict)
        }
        else if  tpSectionType == TpSectionHeaderType.DoctorVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            return BL_Approval.sharedInstance.getSingleDoctorVisitCellHeight() - 22 + BL_Approval.sharedInstance.getDoctorVisitDetails(dict: dict)
        }
        else if sectionType == SectionHeaderType.WorkPlace  || tpSectionType == TpSectionHeaderType.WorkPlace
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
            }
            else
            {
                if tpSectionType == TpSectionHeaderType.Product
                {
                    section = 6
                }
                else
                {
                    section = tpSectionType.rawValue
                }
            }
            
            return BL_Approval.sharedInstance.getSingleCellHeight() + BL_Approval.sharedInstance.getLineHeightAccordingToType(sectionType: section, dict: dict)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if sectionType ==  SectionHeaderType.DoctorVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            let dcrCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Code") as? String)
            let doctorVisitCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Visit_Code") as? String)
            DCRModel.sharedInstance.dcrId = dict.object(forKey: "DCR_Id") as? Int
            
            if let doctorId = dict.object(forKey: "Doctor_Visit_Id") as? Int
            {
                DCRModel.sharedInstance.doctorVisitId = doctorId
                BL_Reports.sharedInstance.doctorVisitId = doctorId
                DCRModel.sharedInstance.customerVisitId = doctorId
            }
            else if let doctorId = dict.object(forKey: "DCR_Doctor_Visit_Id") as? Int
            {
                DCRModel.sharedInstance.doctorVisitId = doctorId
                BL_Reports.sharedInstance.doctorVisitId = doctorId
                DCRModel.sharedInstance.customerVisitId = doctorId
            }
            DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Code") as? String)
            DCRModel.sharedInstance.customerRegionCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Region_Code") as? String)
            delegate?.getSelectedDoctorDetails(dcrCode: dcrCode, doctorVisitCode: doctorVisitCode , entityType : Constants.CustomerEntityType.doctor)
        }
        else if sectionType ==  SectionHeaderType.ChemistVisit
        {
            let dict = dataList[indexPath.row] as! NSDictionary
            
            if (dict.value(forKey: "Is_Chemist_Day") as! String == "1")
            {
                let dcrCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Code") as? String)
                let chemistVisitId = "\(dict.object(forKey: "Visit_Id") as! Int)"
                ChemistDay.sharedInstance.chemistVisitId = dict.object(forKey: "Visit_Id") as? Int
                ChemistDay.sharedInstance.customerName = dict.object(forKey: "Chemist_Name") as? String
                DCRModel.sharedInstance.dcrId = dict.object(forKey: "DCR_Id") as? Int
                DCRModel.sharedInstance.customerVisitId = dict.object(forKey: "Visit_Id") as? Int
                DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
                delegate?.getSelectedDoctorDetails(dcrCode: dcrCode, doctorVisitCode:  chemistVisitId, entityType : Constants.CustomerEntityType.chemist)
            }
        }
    }
    
    func getDoctorVisitDetails(dict : NSDictionary) -> String
    {
        var doctorDetails : String  = ""
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        
        if tpSectionType == TpSectionHeaderType.DoctorVisit
        {
            mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL") as? String)
        }
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
        doctorDetails = "MDL NO : \(mdlNumber)"
        
        //organisation
        var HospitalName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if HospitalName != ""
        {
            doctorDetails = doctorDetails + " | " + HospitalName
        }
        doctorDetails = doctorDetails + " | " + HospitalName
        
        
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
    
}
