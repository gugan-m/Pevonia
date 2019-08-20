//
//  DoctorVisitModifyController.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorVisitModifyController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    var doctorVisitList : [DCRDoctorVisitModel] = []
    var suffixConfigVal : [String]!
    var constrainedWidth : CGFloat!
    var cellIdentifier : String!
    var isForChemistDay: Bool = false
    var customerType:String = ""
    var chemistlist: [ChemistDayVisit] = []
    var attendanceDoctorList: [DCRAttendanceDoctorModel] = []
    var isFromAttendanceDoctor: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if isForChemistDay
        {
            chemistlist = DBHelper.sharedInstance.getChemistDayVisitsForDCRId(dcrId: DCRModel.sharedInstance.dcrId)!
            if (chemistlist.count) > 0
            {
                doctorVisitList = convertChemistDayModelToDoctorVisitModel(array: chemistlist)
            }
            else
            {
                doctorVisitList = []
            }
            customerType = appChemist
        }
        else if isFromAttendanceDoctor
        {
            attendanceDoctorList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList
            if (attendanceDoctorList.count) > 0
            {
                doctorVisitList = converAttendanceDoctorModelToDoctorVisitModel(array: attendanceDoctorList)
            }
            else
            {
                doctorVisitList = []
            }
            customerType = appDoctor
        }
        else
        {
            doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
            customerType = appDoctor
        }
        
        self.navigationItem.title = "\(customerType) visits"
        constrainedWidth = SCREEN_WIDTH - 70.0
        cellIdentifier = "doctorVisitDetail"
        let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
        subTitle.text = String(format: "%@ | %@", fieldRcpa, dcrDateVal)
        setEmptyViewVisibility()
        suffixConfigVal = BL_DCR_Doctor_Visit.sharedInstance.getDoctorSuffixColumnName()
        
//        if (!isForChemistDay)
//        {
//            if (!BL_DCR_Doctor_Visit.sharedInstance.canInheritedUserAddDoctors(accUserCode: getUserCode(), isFlexi: false))
//            {
//                addBtn.isEnabled = false
//                addBtn.tintColor = .clear
//            }
//        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setEmptyViewVisibility()
    {
        if doctorVisitList.count > 0
        {
            contentView.isHidden = false
            emptyState.isHidden = true
        }
        else
        {
            contentView.isHidden = true
            emptyState.isHidden = false
            emptyStateLbl.text = "No \(customerType) visit details found"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doctorVisitList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightVal : CGFloat = 156.0
        
        let model = doctorVisitList[indexPath.row]
        
        var detailText : String = ""
        
        let userObj = getUserModelObj()
        
        if model.Doctor_Region_Code == userObj?.Region_Code
        {
            model.Doctor_Region_Name = userObj?.Region_Name
        }
        
        if model.Doctor_Code == EMPTY
        {
            detailText = String(format: "MDL NO: | %@ | %@", model.Speciality_Name, model.Doctor_Region_Name!)
        }
        else
        {
            let strHospitalName = checkNullAndNilValueForString(stringData: model.Hospital_Name) as? String
            detailText = String(format: "%@ | %@ | %@ | %@ | %@",strHospitalName!, model.MDL_Number!, model.Speciality_Name, model.Category_Name!, model.Doctor_Region_Name!)
            
            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
            }
            
            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
            }
        }
        
        let detailTextSize = getTextSize(text: detailText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
        
        heightVal = heightVal + detailTextSize.height
        
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = doctorVisitList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DoctorVisitDetail
        cell.doctorName.text = String(format: "%@", model.Doctor_Name)
        
        var detailText : String = ""
        let userObj = getUserModelObj()
        
        if isForChemistDay == false
        {
            if model.Doctor_Region_Code == userObj?.Region_Code
            {
                model.Doctor_Region_Name = userObj?.Region_Name
            }
            
            if model.Doctor_Code == EMPTY
            {
                detailText = String(format: "MDL NO: | %@ | %@", model.Speciality_Name, model.Doctor_Region_Name!)
            }
            else
            {
                let strHospitalName = checkNullAndNilValueForString(stringData: model.Hospital_Name) as? String
                detailText = String(format: "%@ | %@ | %@ | %@ | %@", ccmNumberPrefix + strHospitalName!, model.MDL_Number!, model.Speciality_Name, model.Category_Name!, model.Doctor_Region_Name!)
                
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
            }
            
            cell.doctorDesc.text = detailText
            
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
                
            {
               cell.visitMode.text = model.Visit_Time
            }
            else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_VISIT_MODE) == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue) && (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
            {
                cell.visitMode.text = model.Visit_Time
            }
            else
            {
                cell.visitMode.text = model.Visit_Mode
            }
            
            if (!BL_DCR_Doctor_Visit.sharedInstance.canRemoveEDetailedDoctor(customerCode: checkNullAndNilValueForString(stringData: model.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: model.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString)))
            {
                cell.removeBtn.isHidden = true
            }
            else
            {
                cell.removeBtn.isHidden = false
                cell.removeBtn.tag = indexPath.row
            }
            
            if (cell.removeBtn.isHidden == false)
            {
                if (BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEnabled() && model.Is_DCR_Inherited_Doctor == 1)
                {
                    cell.removeBtn.isHidden = true
                    cell.removeBtn.tag = indexPath.row
                }
            }
            
            cell.modifyBtn.tag = indexPath.row
        }
        else
        {
            if model.Doctor_Region_Code == userObj?.Region_Code
            {
                model.Doctor_Region_Name = userObj?.Region_Name
            }
            
            if model.Doctor_Code == EMPTY
            {
                model.Doctor_Region_Code = getRegionCode()
                model.Doctor_Region_Name = getRegionName()
                detailText = String(format: "%@", model.Doctor_Region_Name!)
            }
            else
            {
                
                if model.MDL_Number != EMPTY && model.MDL_Number != nil
                {
                    detailText = String(format: "%@ | %@ ",model.MDL_Number!, model.Doctor_Region_Name!)
                }
                else
                {
                    detailText = String(format: "%@ ",model.Doctor_Region_Name!)
                }
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
            }
            
            cell.doctorDesc.text = detailText
            
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() 
                
            {
                cell.visitMode.text = model.Visit_Time
            }
            else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_VISIT_MODE) == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue) && (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
            {
                cell.visitMode.text = model.Visit_Time
            }
            else
            {
                cell.visitMode.text = model.Visit_Mode
            }
            
            cell.removeBtn.isHidden = false
            cell.removeBtn.tag = indexPath.row
            cell.modifyBtn.tag = indexPath.row
        }
        
        return cell
    }
    
    @IBAction func modifyBtnAction(_ sender: AnyObject)
    {
        if isForChemistDay
        {
            let chemistObj = chemistlist[sender.tag]
            self.navigateToModifyPage(Obj: chemistObj)
        }
        else if isFromAttendanceDoctor
        {
            let model = doctorVisitList[sender.tag]
            let sb = UIStoryboard(name: attendanceStepperSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: AttendanceDoctorStepperControllerID) as! AttendanceDoctorStepperController
            // vc.geoLocationSkipRemarks = geoFencingSkipRemarks
           
            //        DCRModel.sharedInstance.customerId = model.Doctor_Id
            DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
            DCRModel.sharedInstance.customerRegionCode = model.Doctor_Region_Code
            DCRModel.sharedInstance.doctorVisitId = model.DCR_Doctor_Visit_Id
            DCRModel.sharedInstance.customerVisitId = model.DCR_Doctor_Visit_Id
            DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
            
            if DCRModel.sharedInstance.customerCode != ""
            {
                let custObj = BL_DCR_Doctor_Visit.sharedInstance.getLocalArea(customerCode: model.Doctor_Code!, regionCode: model.Doctor_Region_Code!)
                let local_Area = checkNullAndNilValueForString(stringData: custObj?.Local_Area)
                let dict : NSMutableDictionary = [:]
                
                dict.setValue(model.Doctor_Code, forKey: "Customer_Code")
                dict.setValue(model.Doctor_Name, forKey: "Customer_Name")
                dict.setValue(model.Doctor_Region_Name, forKey: "Region_Name")
                dict.setValue(model.Speciality_Name, forKey: "Speciality_Name")
                dict.setValue(model.Category_Name, forKey: "Category_Name")
                dict.setValue(model.MDL_Number, forKey: "MDL_Number")
                dict.setValue(model.Hospital_Name, forKey: "Hospital_Name")
                dict.setValue(local_Area, forKey: "Local_Area")
                dict.setValue(model.Sur_Name, forKey: "Sur_Name")
                dict.setValue(model.Category_Code, forKey: "Category_Code")
                
                let customerModel = CustomerMasterModel.init(dict: dict)
                vc.customerMasterModel = customerModel
                
                BL_DoctorList.sharedInstance.regionCode = checkNullAndNilValueForString(stringData: model.Doctor_Region_Code)
                BL_DoctorList.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
            }
            else
            {
                vc.flexiDoctorName = model.Doctor_Name
                vc.flexiSpecialityName = model.Speciality_Name
                
                BL_DoctorList.sharedInstance.regionCode = EMPTY
                BL_DoctorList.sharedInstance.customerCode = EMPTY
            }
            
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        else
        {
            let model = doctorVisitList[sender.tag]
            let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
            //        DCRModel.sharedInstance.customerId = model.Doctor_Id
            DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
            DCRModel.sharedInstance.customerRegionCode = model.Doctor_Region_Code
            DCRModel.sharedInstance.doctorVisitId = model.DCR_Doctor_Visit_Id
            DCRModel.sharedInstance.customerVisitId = model.DCR_Doctor_Visit_Id
            DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
            
            if DCRModel.sharedInstance.customerCode != ""
            {
                let custObj = BL_DCR_Doctor_Visit.sharedInstance.getLocalArea(customerCode: model.Doctor_Code!, regionCode: model.Doctor_Region_Code!)
                let local_Area = checkNullAndNilValueForString(stringData: custObj?.Local_Area)
                let dict : NSMutableDictionary = [:]
                
                dict.setValue(model.Doctor_Code, forKey: "Customer_Code")
                dict.setValue(model.Doctor_Name, forKey: "Customer_Name")
                dict.setValue(model.Doctor_Region_Name, forKey: "Region_Name")
                dict.setValue(model.Speciality_Name, forKey: "Speciality_Name")
                dict.setValue(model.Category_Name, forKey: "Category_Name")
                dict.setValue(model.MDL_Number, forKey: "MDL_Number")
                dict.setValue(model.Hospital_Name, forKey: "Hospital_Name")
                dict.setValue(local_Area, forKey: "Local_Area")
                dict.setValue(model.Sur_Name, forKey: "Sur_Name")
                dict.setValue(model.Category_Code, forKey: "Category_Code")
                
                let customerModel = CustomerMasterModel.init(dict: dict)
                vc.customerMasterModel = customerModel
                
                BL_DoctorList.sharedInstance.regionCode = checkNullAndNilValueForString(stringData: model.Doctor_Region_Code)
                BL_DoctorList.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: model.Doctor_Code)
            }
            else
            {
                vc.flexiDoctorName = model.Doctor_Name
                vc.flexiSpecialityName = model.Speciality_Name
                
                BL_DoctorList.sharedInstance.regionCode = EMPTY
                BL_DoctorList.sharedInstance.customerCode = EMPTY
            }
            
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        
    }
    
    @IBAction func removeBtnAction(_ sender: AnyObject)
    {
        showRemoveAlert(tag: sender.tag)
    }
    
    func showRemoveAlert(tag: Int)
    {
        let alert = UIAlertController(title: "Alert", message: "Do you want to Remove?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAction(tag: tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func removeAction(tag: Int)
    {
        let model = doctorVisitList[tag]
        if isForChemistDay
        {
            let chemistObj = chemistlist[tag]
            self.removeChemistDetails(chemistVisitId :chemistObj.DCRChemistDayVisitId)
            chemistlist = DBHelper.sharedInstance.getChemistDayVisitsForDCRId(dcrId: DCRModel.sharedInstance.dcrId)!
            if (chemistlist.count) > 0
            {
                doctorVisitList = convertChemistDayModelToDoctorVisitModel(array: chemistlist)
            }
            else
            {
                doctorVisitList = []
            }
        }
        else if isFromAttendanceDoctor
        {
            
            //  BL_SampleProducts.sharedInstance.addInwardQty(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: model.DCR_Doctor_Visit_Id)
            
            BL_SampleProducts.sharedInstance.addBatchInwardQty(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: model.DCR_Doctor_Visit_Id, entityType: sampleBatchEntity.Attendance.rawValue)
            BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceDoctorVisit(doctorVisitId: model.DCR_Doctor_Visit_Id)
            BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceDoctorSample(doctorVisitId: model.DCR_Doctor_Visit_Id)
            
            BL_DCR_Attendance.sharedInstance.deleteDCRAttendenceActivity(doctorVisitId: model.DCR_Doctor_Visit_Id)
            
            BL_DCR_Attendance_Stepper.sharedInstance.getDoctorDetails()
            attendanceDoctorList = BL_DCR_Attendance_Stepper.sharedInstance.doctorList
            if (attendanceDoctorList.count) > 0
            {
                doctorVisitList = converAttendanceDoctorModelToDoctorVisitModel(array: attendanceDoctorList)
            }
            else
            {
                doctorVisitList = []
            }
        }
        else
        {
            var allowToRemoveDoctor: Bool = true
            
            if (BL_DCR_Doctor_Visit.sharedInstance.getEDetailedDoctorRemovePrivilegeValue() == PrivilegeValues.YES.rawValue)
            {
                if (BL_DCR_Doctor_Visit.sharedInstance.isEDetailingAnalyticsSynced(customerCode: checkNullAndNilValueForString(stringData: model.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: model.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString)))
                {
                    allowToRemoveDoctor = false
                }
            }
            
            if (allowToRemoveDoctor)
            {
                BL_DCR_Doctor_Visit.sharedInstance.deleteDCRDoctorVisit(dcrDoctorVisitId: model.DCR_Doctor_Visit_Id, customerCode: checkNullAndNilValueForString(stringData: model.Doctor_Code), regionCode: checkNullAndNilValueForString(stringData: model.Doctor_Region_Code), dcrDate: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrDateString), doctorName: model.Doctor_Name)
                
                doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
                showToastView(toastText: "\(customerType) deleted successfully")
            }
            else
            {
                AlertView.showAlertView(title: errorTitle, message: Display_Messages.DCR_DOCTOR_VISIT.EDETAILED_DOCTOR_REMOVE_BUT_ANALYTICS_SYNCED)
            }
        }
        
        tableView.reloadData()
        setEmptyViewVisibility()
        
    }
    
    @IBAction func doneAction(_ sender: AnyObject)
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addAction(_ sender: AnyObject)
    {
        if isFromAttendanceDoctor
        {
            if(isManager())
            {
                let sb = UIStoryboard(name: attendanceStepperSb, bundle: nil)
                let vc:AttendanceAccompanistListController = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttendanceAccompanistListVCID) as! AttendanceAccompanistListController
                //vc.isFromAttendance = true
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            else
            {
                let loggedUserModel = getUserModelObj()
                let regionCode = loggedUserModel?.Region_Code
                let regionName = loggedUserModel?.Region_Name
                let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
                let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
                vc.regionCode = regionCode
                vc.regionName = regionName
                vc.isFromAttendance = true
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
                
            }
        }
        else if isForChemistDay
        {
            self.navigateToAddChemistDay()
        }
        else{
            
            let showAccompanistScreen = BL_DCR_Doctor_Visit.sharedInstance.canUseAccompanistsDoctor()
            let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsList()
            
            //let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsListWithoutVandNA()
            
            if showAccompanistScreen == true && (dcrAccompCount?.count)! > 0
            {
                let sb = UIStoryboard(name: commonListSb, bundle: nil)
                let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
                vc.navigationScreenName = doctorMasterVcID
                vc.isFromDCR = true
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            else
            {
                let loggedUserModel = getUserModelObj()
                let regionCode = loggedUserModel?.Region_Code
                let regionName = loggedUserModel?.Region_Name
                let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
                let vc:DoctorMasterController = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
                vc.regionCode = regionCode
                vc.regionName = regionName
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func convertChemistDayModelToDoctorVisitModel(array: [ChemistDayVisit]) -> [DCRDoctorVisitModel]
    {
        var doctorVisitModel:[DCRDoctorVisitModel] = []
        if array != nil
        {
            for obj in array
            {
                if obj.ChemistCode != EMPTY
                {
               // let chemistObj = DBHelper.sharedInstance.getChemistModel(customerCode: obj.ChemistCode)
                    let dict = ["DCR_Id":String(obj.DCRId),"DCR_Code":checkNullAndNilValueForString(stringData: obj.DCRCode),"Doctor_Region_Code":obj.RegionCode ?? EMPTY,"Doctor_Code":obj.ChemistCode,"Doctor_Name":obj.ChemistName,"Speciality_Name": EMPTY,"MDL_Number":checkNullAndNilValueForString(stringData: obj.MDLNumber),"Category_Code":NA,"Category_Name":NA,"Visit_Mode":checkNullAndNilValueForString(stringData:obj.VisitMode),"Visit_Time":checkNullAndNilValueForString(stringData: obj.VisitTime),"POB_Amount":EMPTY] as [String : Any]
                    
                    let docObj = DCRDoctorVisitModel(dict: dict as NSDictionary)
                    doctorVisitModel.append(docObj)
                }
                else
                {
                    let dict = ["DCR_Id":String(obj.DCRId),"DCR_Code":checkNullAndNilValueForString(stringData: obj.DCRCode),"Doctor_Region_Code":EMPTY,"Doctor_Code":EMPTY,"Doctor_Name":obj.ChemistName,"Speciality_Name":EMPTY,"MDL_Number":NA,"Category_Code":NA,"Category_Name":NA,"Visit_Mode":checkNullAndNilValueForString(stringData:obj.VisitMode),"Visit_Time":checkNullAndNilValueForString(stringData: obj.VisitTime),"POB_Amount":EMPTY] as [String : Any]
                    
                    let docObj = DCRDoctorVisitModel(dict: dict as NSDictionary)
                    doctorVisitModel.append(docObj)
                }
                
                
            }
        }
        return doctorVisitModel
    }
    
    func converAttendanceDoctorModelToDoctorVisitModel(array: [DCRAttendanceDoctorModel]) -> [DCRDoctorVisitModel]
    {
        var doctorVisitModel:[DCRDoctorVisitModel] = []
        if array != nil
        {
            for obj in array
            {
                if obj.Doctor_Code != EMPTY
                {
                    // let chemistObj = DBHelper.sharedInstance.getChemistModel(customerCode: obj.ChemistCode)
                    let dict = ["DCR_Id":String(obj.DCR_Id!),"DCR_Code":checkNullAndNilValueForString(stringData: obj.DCR_Code),"Doctor_Region_Code":obj.Doctor_Region_Code ?? EMPTY,"Doctor_Code":obj.Doctor_Code,"Doctor_Name":obj.Doctor_Name,"Speciality_Name": EMPTY,"MDL_Number":checkNullAndNilValueForString(stringData: obj.MDL_Number),"Hospital_Name":checkNullAndNilValueForString(stringData: obj.Hospital_Name),"Category_Code":obj.Category_Code,"Category_Name":obj.Category_Name,"Visit_Mode":checkNullAndNilValueForString(stringData:obj.Visit_Mode),"Visit_Time":checkNullAndNilValueForString(stringData: obj.Visit_Time),"POB_Amount":EMPTY] as [String : Any]
                    
                    let docObj = DCRDoctorVisitModel(dict: dict as NSDictionary)
                    docObj.DCR_Doctor_Visit_Id = obj.DCR_Doctor_Visit_Id
                    doctorVisitModel.append(docObj)
                }
                else
                {
                    let dict = ["DCR_Id":String(obj.DCR_Id!),"DCR_Code":checkNullAndNilValueForString(stringData: obj.DCR_Code),"Doctor_Region_Code":EMPTY,"Doctor_Code":EMPTY,"Doctor_Name":obj.Doctor_Name,"Speciality_Name":EMPTY,"MDL_Number":NA,"Category_Code":NA,"Category_Name":NA,"Visit_Mode":checkNullAndNilValueForString(stringData:obj.Visit_Mode),"Visit_Time":checkNullAndNilValueForString(stringData: obj.Visit_Time),"POB_Amount":EMPTY] as [String : Any]
                    
                    let docObj = DCRDoctorVisitModel(dict: dict as NSDictionary)
                    docObj.DCR_Doctor_Visit_Id = obj.DCR_Doctor_Visit_Id
                    doctorVisitModel.append(docObj)
                }
                
                
            }
        }
        return doctorVisitModel
    }
    
    private func removeChemistDetails(chemistVisitId :Int)
    {
        let dcrId = DCRModel.sharedInstance.dcrId!
        BL_Common_Stepper.sharedInstance.deleteChemistVisitDetailsForChemistDayVisitId(dcrId: dcrId, chemistVisitId: chemistVisitId)
        
    }
    
    private func navigateToAddChemistDay()
    {
        let showAccompanistScreen = BL_DCR_Chemist_Visit.sharedInstance.canUseAccompanistsChemist()
        let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsList()
        //let dcrAccompCount = BL_DCR_Doctor_Visit.sharedInstance.getDCRAccompanistsListWithoutVandNA()
        
        if showAccompanistScreen == true && (dcrAccompCount?.count)! > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = ChemistDayVcID
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        else
        {
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
            vc.regionCode = getRegionCode()
            vc.isComingFromChemistDay = true
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
    }
    
    private func navigateToModifyPage(Obj: ChemistDayVisit)
    {
        DCRModel.sharedInstance.customerVisitId = Obj.DCRChemistDayVisitId!
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
        ChemistDay.sharedInstance.chemistVisitId = Obj.DCRChemistDayVisitId!
        ChemistDay.sharedInstance.chemistVisitCode = Obj.ChemistVisitCode
        ChemistDay.sharedInstance.customerCode = Obj.ChemistCode
        ChemistDay.sharedInstance.customerName = Obj.ChemistName!
        ChemistDay.sharedInstance.regionCode = checkNullAndNilValueForString(stringData: Obj.RegionCode)
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ChemistDayVcID) as! ChemistDayStepperController
        vc.customerMasterModel = convertChemistToCustomerObjectModel(chemistObj : Obj)
        vc.isFromModify = true
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
        
    }
    
    func convertChemistToCustomerObjectModel(chemistObj : ChemistDayVisit)->CustomerMasterModel
    {
        if chemistObj.ChemistCode != EMPTY && chemistObj.ChemistCode != nil
        
        {
            //let obj = DBHelper.sharedInstance.getChemistModel(customerCode: chemistObj.ChemistCode)
            let convertObject : NSDictionary = ["Customer_Code" : chemistObj.ChemistCode!,"Customer_Name":chemistObj.ChemistName,"Region_Code":chemistObj.RegionCode ?? EMPTY,"Region_Name":chemistObj.RegionName ?? EMPTY,"Speciality_Code":"","Speciality_Name":EMPTY,"Category_Code":NA,"Category_Name":NA,"MDL_Number":chemistObj.MDLNumber ?? EMPTY,"Local_Area":EMPTY,"Hospital_Name":"","Customer_Entity_Type":"CHEMIST","Sur_Name":NA,"Customer_Latitude":chemistObj.Latitude,"Customer_Longitude":chemistObj.Longitude,"Anniversary_Date":"","DOB":""]
            let customerObject = CustomerMasterModel(dict: convertObject)
            return customerObject
            
        }
        else
        {
        let convertObject : NSDictionary = ["Customer_Code" :EMPTY,"Customer_Name":chemistObj.ChemistName,"Region_Code":chemistObj.RegionCode ?? EMPTY,"Region_Name":chemistObj.RegionName ?? EMPTY,"Speciality_Code":"","Speciality_Name":EMPTY,"Category_Code":NA,"Category_Name":NA,"MDL_Number":EMPTY,"Local_Area": EMPTY,"Hospital_Name":"","Customer_Entity_Type":"CHEMIST","Sur_Name":NA,"Customer_Latitude":chemistObj.Latitude,"Customer_Longitude":chemistObj.Longitude,"Anniversary_Date":"","DOB":""]
            let customerObject = CustomerMasterModel(dict: convertObject)
            return customerObject
        }
    }
}
