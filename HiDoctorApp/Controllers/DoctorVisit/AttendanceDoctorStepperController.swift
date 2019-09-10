//
//  AttendanceDoctorStepperController.swift
//  HiDoctorApp
//
//  Created by Swaas on 21/09/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AttendanceDoctorStepperController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var saveDoctorView: UIView!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var doctorVisitDate: UILabel!
    @IBOutlet weak var tableviewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var saveBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var eDetailingButton: UIButton!
    @IBOutlet weak var eDetailingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingViewHeightConstraint: NSLayoutConstraint!
    
    let mainCellIdentifier = "doctorVisitMain"
    var customerMasterModel:CustomerMasterModel!
    var flexiSpecialityName : String = ""
    var flexiDoctorName : String = ""
    var stepperIndex: DoctorVisitStepperIndex!
    var doctorStepperString = String()
    var objBusinessStatus: BusinessStatusModel?
    var currentLocation: GeoLocationModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideEDetailingButon()
        addBackButtonView()
        setDefaults()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        BL_Activity_Stepper.sharedInstance.isFromAttendance = true
        BL_Doctor_Attendance_Stepper.sharedInstance.generateDataArray()
        stepperIndex = BL_Doctor_Attendance_Stepper.sharedInstance.stepperIndex
        self.tableView.reloadData()
        
        
    }
    
    private func hideEDetailingButon()
    {
        eDetailingButton.isHidden = true
        eDetailingView.isHidden = true
        eDetailingWidthConstraint.constant = 0
        doctorVisitDate.isHidden = false
        
        let height = CGFloat(8 + getDetailLabelHeight() + 12 + 14 + 20)
        
        eDetailingViewHeightConstraint.constant = 0
        headerViewHeightConstraint.constant = height
    }
    
    private func getDetailLabelHeight() -> CGFloat
    {
        let height = getTextSize(text: doctorDetail.text, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 32).height
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier) as! DoctorVisitStepperMain
        
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        cell.stepperIndex = BL_Doctor_Attendance_Stepper.sharedInstance.stepperIndex
        cell.isFromAttendance = true
        let rowIndex = indexPath.row
        
        let objStepperModel: DCRStepperModel = BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        
        cell.accompEmptyStateView.isHidden = true
        
        if (objStepperModel.recordCount == 0)
        {
            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
            
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
            cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            cell.emptyStateView.isHidden = false
            cell.cardView.isHidden = true
            cell.cardView.clipsToBounds = true
            
            if objStepperModel.showEmptyStateAddButton == true
            {
                cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            }
            else
            {
                cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            }
        }
        else
        {
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateView.isHidden = true
            cell.cardView.isHidden = false
            cell.cardView.clipsToBounds = false
            
            cell.rightButton.isHidden = !objStepperModel.showRightButton
            cell.leftButton.isHidden = !objStepperModel.showLeftButton
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
        }
        
        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
        cell.sectionToggleImageView.isHidden = true
        cell.sectionToggleImageView.clipsToBounds = true
        
        var checkRecordCount = 1
        
        if (objStepperModel.recordCount > checkRecordCount)
        {
            
            if (objStepperModel.isExpanded == true)
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
            }
            else
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
            }
            
            cell.sectionToggleImageView.isHidden = false
            cell.sectionToggleImageView.clipsToBounds = false
            
        }
        
        cell.moreView.isHidden = true
        cell.moreView.clipsToBounds = true
        cell.moreViewHeightConstraint.constant = 0
        cell.buttonViewHeight.constant = 60
        //        if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
        //        {
        //            cell.moreView.isHidden = true
        //            cell.moreViewHeightConstraint.constant = 0
        //            cell.sectionCoverButton.isHidden = true
        //            cell.coverBtnWidthConst.constant = 0.0
        //            if rowIndex == stepperIndex.accompanistIndex
        //            {
        //                cell.buttonViewHeight.constant = 0
        //                cell.leftButton.isHidden = true
        //                cell.rightButton.isHidden = true
        //            }
        //            else if rowIndex == stepperIndex.detailedProduct
        //            {
        //                cell.buttonViewHeight.constant = 40
        //                cell.leftButton.isHidden = false
        //                cell.rightButton.isHidden = false
        //            }
        //        }
        //        else
        //        {
        cell.leftButton.isHidden = false
        cell.rightButton.isHidden = false
        
        cell.sectionCoverButton.isHidden = false
        cell.coverBtnWidthConst.constant = SCREEN_WIDTH - 56.0
        if (objStepperModel.isExpanded == false && objStepperModel.recordCount > checkRecordCount)
        {
            cell.moreView.isHidden = false
            cell.moreView.clipsToBounds = false
            cell.moreViewHeightConstraint.constant = 20
        }
        else
        {
            cell.buttonViewHeight.constant = 40
        }
        //  }
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        cell.emptyStateSkipButton.tag = rowIndex

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_Doctor_Attendance_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
            
        else
        {
            if index == stepperIndex.doctorVisitIndex
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getDoctorVisitDetailHeight(selectedIndex: index)
            }
            else if index == stepperIndex.sampleIndex
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getSampleBatchHeight(selectedIndex: index)
            }
                else if index == stepperIndex.activity
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
            else
            {
                
                return 0
            }
        }
    }
    
    @objc func emptyStateAddButton(button: UIButton){
        
        if (button.tag == 0)
        {
            //navigate to doctor visit Screen
            navigateToAddDoctorVisit()
        }
        else if (button.tag == 1)
        {
            //navigate sample Screen
            navigateToAddDoctorSample()
        }
        else if (button.tag == 2)
        {
            //navigate activity Screen
            navigateToAddActivity()
        }
    }
    
   
    
   
    @IBAction func leftButtonAction(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 0:
            self.navigateToAddDoctorVisit()
            break
            
        case 1:
            self.navigateToAddDoctorSample()
            break
            
        case 2:
            navigateToAddActivity()
            break
            
        default:
            break
        }
    }
    
    @IBAction func rightButtonAction(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 0:
            self.navigateToEditDoctorVisit()
            break
            
        case 1:
            self.navigateToModifyDoctorSample()
            break
            
        case 2:
            navigateToAddActivity()
            break
            
        default:
            break
        }
    }
    
    @IBAction func emptyStateAddAction(_ sender: AnyObject)
    {
        switch sender.tag
        {
        case 0:
            self.navigateToAddDoctorVisit()
            break
            
        case 1:
            self.navigateToAddDoctorSample()
            break
            
        case 2:
            navigateToAddActivity()
            break
            
        default:
            break
        }
    }
    
    @IBAction func emptyStateSkipAction(_ sender: AnyObject)
    {
        //
        switch sender.tag
        {
        case 0:
            if DCRModel.sharedInstance.customerCode == nil || DCRModel.sharedInstance.customerCode == ""
            {
                var visittime = ""
                var visitmode = ""
                
                    if(BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ||
                        BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue){
                        
                        if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                            visittime = stringFromDate(date1: Date())
                            let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                            visitmode = visittime.substring(from: lastcharacterIndex)
                        }else{
                            visittime = ""
                            visitmode = ""
                        }
                        
                    }else{
                        if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                            visittime = stringFromDate(date1: Date())
                            let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                            visitmode = visittime.substring(from: lastcharacterIndex)
                            visittime = ""
                        }else{
                            visittime = ""
                            visitmode = ""
                        }
                    }
        
                
                    let userObj = getUserModelObj()
                BL_DCR_Doctor_Visit.sharedInstance.saveFlexiAttendanceDoctorVisitDetails(doctorName: customerMasterModel.Customer_Name, specialityName: customerMasterModel.Speciality_Name, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignCode: customerMasterModel.Speciality_Code, campaignName: EMPTY)
                  DCRModel.sharedInstance.customerCode = ""
            }
            else
            {
             
                
                var statusId: Int = defaultBusineessStatusId
                var statusName: String = EMPTY
                
                var visittime = ""
                var visitmode = ""
                
                if(BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue
                    ||
                    BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue){
                    
                    if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                        visittime = stringFromDate(date1: Date())
                        let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                        visitmode = visittime.substring(from: lastcharacterIndex)
                    }else{
                        visittime = ""
                        visitmode = ""
                    }
                    
                }else{
                    if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled()){
                        visittime = stringFromDate(date1: Date())
                        let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                        visitmode = visittime.substring(from: lastcharacterIndex)
                        visittime = ""
                    }else{
                        visittime = ""
                        visitmode = ""
                    }
                }

                
                if (objBusinessStatus != nil)
                {
                    statusId = objBusinessStatus!.Business_Status_ID!
                    statusName = objBusinessStatus!.Status_Name!
                }
                
                
                
                BL_DCR_Doctor_Visit.sharedInstance.saveAttendanceVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: EMPTY, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignCode: EMPTY, specialityCode: customerMasterModel.Speciality_Code, campaignName: EMPTY)
                
            }
            BL_Doctor_Attendance_Stepper.sharedInstance.skipIndex = sender.tag
            BL_Doctor_Attendance_Stepper.sharedInstance.generateDataArray()
            self.tableView.reloadData()
            break
            
        case 1:
            BL_Doctor_Attendance_Stepper.sharedInstance.skipIndex = sender.tag
            BL_Doctor_Attendance_Stepper.sharedInstance.generateDataArray()
            self.tableView.reloadData()
            break
            
        default:
            BL_Activity_Stepper.sharedInstance.skipIndex = 0
            break
            
        }
    }
    
    func getVisitTimeMode() -> String
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode()
    }
    
    
    // MARK:-- Navigation Functions
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func navigateToAddDoctorVisit()
    {
        var doctorName : String = ""
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitVcID) as! DoctorVisitViewController
        vc.specialityName = self.flexiSpecialityName
        vc.currentLocation = self.currentLocation
        if DCRModel.sharedInstance.customerCode == nil || DCRModel.sharedInstance.customerCode == ""
        {
            doctorName = customerMasterModel.Customer_Name
        }
        vc.doctorName = doctorName
        vc.customerMasterObj = customerMasterModel
        vc.isFromAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorSample()
    {
        
        let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sampleProductListVcID) as! SampleProductListViewController
        vc.isComingFromAttendanceDoctor = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddActivity()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ActivityStepperViewControllerID) as! ActivityStepperViewController
        vc.isFromAttendance = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditDoctorVisit()
    {
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitVcID) as! DoctorVisitViewController
        vc.isComingFromModifyPage = true
        vc.isFromAttendance =  true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToModifyDoctorSample()
    {
        let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sampleDCRListVcID) as! SampleDetailsViewController
        let attendanceSamplelist = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisitSamples(doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        let sampleProductList = BL_DCR_Attendance.sharedInstance.convertAttendanceSampleToDCRSample(list: attendanceSamplelist)
        vc.currentList = sampleProductList
        vc.isComingFromModifyPage = true
        vc.isComingFromAttendanceDoctor = true
        vc.dcrId = DCRModel.sharedInstance.dcrId
        vc.visitId = DCRModel.sharedInstance.doctorVisitId
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    func setDefaults()
    {
        if DCRModel.sharedInstance.customerCode != nil && DCRModel.sharedInstance.customerCode == ""
        {
            self.navigationItem.title = String(format: "%@", flexiDoctorName)
            DCRModel.sharedInstance.doctorName = flexiDoctorName
        }
        else
        {
            self.navigationItem.title = String(format: "%@", customerMasterModel.Customer_Name)
            DCRModel.sharedInstance.doctorName = customerMasterModel.Customer_Name
        }
        
        let suffixConfigVal = BL_DCR_Doctor_Visit.sharedInstance.getDoctorSuffixColumnName()
        var detailText : String = ""
        
        if DCRModel.sharedInstance.customerCode != nil && DCRModel.sharedInstance.customerCode == ""
        {
            let userObj = getUserModelObj()
            doctorDetail.text = String(format: "%@ | %@", flexiSpecialityName, (userObj?.Region_Name)!)
            DCRModel.sharedInstance.doctorSpeciality = flexiSpecialityName
        }
        else
        {
           if (customerMasterModel != nil)
                {
            if (customerMasterModel.MDL_Number != "" || customerMasterModel.MDL_Number != nil)
            {
                let strHospitalName = checkNullAndNilValueForString(stringData: customerMasterModel.Hospital_Name!) as? String
                let strHospitalAccountNumber = checkNullAndNilValueForString(stringData: customerMasterModel.Hospital_Account_Number!) as? String
                
                if customerMasterModel.Hospital_Account_Number != ""
                {
//                    detailText = String(format: "%@ | %@ | %@ | %@ | %@ | %@", strHospitalName!, strHospitalAccountNumber!, ccmNumberPrefix + customerMasterModel.MDL_Number, customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                    detailText = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName!, strHospitalAccountNumber!, customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                }
                else
                {
//                    detailText = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName!, ccmNumberPrefix + customerMasterModel.MDL_Number, customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                    detailText = String(format: "%@ | %@ | %@ | %@", strHospitalName!,customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                }
            }
           
            else
            {
                detailText = String(format: "%@ | %@ | %@", customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
            }
            
            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && (customerMasterModel != nil && customerMasterModel.Sur_Name != "" )
            {
                detailText = String(format: "%@ | %@", detailText, customerMasterModel.Sur_Name!)
            }
            
            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && (customerMasterModel != nil && customerMasterModel.Local_Area != "")
            {
                detailText = String(format: "%@ | %@", detailText, customerMasterModel.Local_Area!)
            }
            
            doctorDetail.text = detailText
            DCRModel.sharedInstance.doctorSpeciality = customerMasterModel.Speciality_Name
        }
        
        }
        
        let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
        doctorVisitDate.text = String(format: "Date: %@", dcrDateVal)
        
        saveBtn.setTitle("SAVE \(appDoctor.uppercased()) VISIT", for: .normal)
    }
    
    @IBAction func coverBtnAction(_ sender: AnyObject)
    {
        let index = sender.tag
        
        if index != stepperIndex.attachmentIndex || index != stepperIndex.detailedProduct
        {
            let stepperObj = BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList[index!]
            
            if index == stepperIndex.doctorVisitIndex
            {
                if (stepperObj.recordCount > 0)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index!)
                }
            }
            else
            {
                if (stepperObj.recordCount > 1)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index!)
                }
                else if(index == stepperIndex.sampleIndex)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index!)
                }
            }
        }
        
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        if(BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList.count > index)
        {
            let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
            
            tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
        }
    }
    

    
}
