//
//  AddFlexiDoctor.swift
//  HiDoctorApp
//
//  Created by Vijay on 12/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddFlexiDoctor: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, selectedSpecialityDelgate {

    @IBOutlet weak var doctorNameLbl: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doctorNameHeader: UILabel!
    @IBOutlet weak var doctorSpecialityHeader: UILabel!
    
    @IBOutlet weak var doctorSpeciality: UILabel!
    @IBOutlet weak var recentlyAddedHeader: UILabel!
    
    var isfromChemistDay : Bool = false
    var doctorList : [FlexiDoctorModel] = []
    var validSpeciality : Bool = false
    var specialtyCode: String = EMPTY
    var isFromAttendance: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
//        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        self.view.addGestureRecognizer(tapRecog)
        
        self.navigationItem.title = "Add Flexi \(appDoctor)"
        doctorNameHeader.text = "\(appDoctor) Name"
        doctorSpecialityHeader.text = "\(appDoctor) Position"
        recentlyAddedHeader.text = "Recently added (Flexi \(appDoctorPlural))"
        doctorSpeciality.text = "Select \(appDoctor) Position"
        
        doctorList = BL_DCR_Doctor_Visit.sharedInstance.getFlexiDoctorsList()!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = doctorList[indexPath.row].Flexi_Doctor_Name
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell")
        cell?.textLabel?.text = name
        cell?.textLabel?.font = UIFont(name: fontRegular, size: 14.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = doctorList[indexPath.row].Flexi_Doctor_Name
        specialtyCode = EMPTY
        doctorNameLbl.text = name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    

    @IBAction func submitAction(_ sender: AnyObject)
    {
        let charSet = Constants.CharSet.Alphabet + " ."
        if doctorNameLbl.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter the \(appDoctor) name", viewController: self)
        }
        else if isSplCharAvailable(charSet: charSet, stringValue: doctorNameLbl.text!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter valid \(appDoctor) name", viewController: self)
        }
        else if (doctorNameLbl.text?.count)! > flexiDoctorMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "\(appDoctor) name", maxVal: flexiDoctorMaxLength, viewController: self)
        }
        else if validSpeciality == false
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter the Position", viewController: self)
        }
        else
        {
            if isFromAttendance
            {


//                let dict = ["Customer_Name":doctorNameLbl.text!,"Customer_Code" : EMPTY,"Region_Code":getRegionCode(),"Region_Name": getRegionName(),"Speciality_Name":doctorSpeciality.text!,"Category_Name":EMPTY,"MDL_Number":EMPTY,"Customer_Entity_Type": "DOCTOR"]
//                let customerObj = CustomerMasterModel(dict: dict as NSDictionary)
//                BL_SampleProducts.sharedInstance.selectedAttendanceDoctor = customerObj
//                let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: sampleProductListVcID) as! SampleProductListViewController
//                vc.isComingFromAttendanceDoctor = true
//
                
                 BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctor(doctorName:condenseWhitespace(stringValue: doctorNameLbl.text!))
                
                if self.navigationController != nil
                {
                    let sb = UIStoryboard(name: attendanceStepperSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: AttendanceDoctorStepperControllerID) as! AttendanceDoctorStepperController
                    let dict: NSDictionary = [:]
                    let customerobj : CustomerMasterModel? = CustomerMasterModel(dict:dict)
                    DCRModel.sharedInstance.customerCode = nil
                    customerobj?.Customer_Name = doctorNameLbl.text!
                    customerobj?.Speciality_Name = doctorSpeciality.text!
                    customerobj?.Speciality_Code = specialtyCode
                    customerobj?.Region_Code = getRegionCode()
                    customerobj?.Region_Name = getRegionName()
                    customerobj?.Customer_Code = ""
                    customerobj?.Category_Name = ""
                    customerobj?.Sur_Name = ""
                    customerobj?.Local_Area = ""
                    vc.customerMasterModel = customerobj
                    
                    
            self.navigationController?.pushViewController(vc, animated: true)
                }


            }
            else if !isfromChemistDay
            {
                BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctor(doctorName:condenseWhitespace(stringValue: doctorNameLbl.text!))
                
                if self.navigationController != nil
                {
                    let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
                    vc.flexiDoctorName = doctorNameLbl.text!
                    vc.flexiSpecialityName = doctorSpeciality.text!
                    vc.flexiDoctorName = self.doctorNameLbl.text!
                    if(BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                    {
                    vc.flexiSpecialityName = self.doctorSpeciality.text!
                    
                    vc.flexiDoctorName = self.doctorNameLbl.text!
                    
                    vc.flexiSpecialityName = self.doctorSpeciality.text!
                    
                    var localTimeZoneName: String { return TimeZone.current.identifier }
                    
                    //vc.currentLocation = currentLocation
                    
                    vc.punch_start = getStringFromDateforPunch(date: getCurrentDateAndTime())
                    
                    vc.punch_status = 1
                    
                    vc.punch_UTC = getUTCDateForPunch()
                    
                    vc.punch_timezone = localTimeZoneName
                    
                    vc.punch_timeoffset = getOffset()
                    }
                    //                DCRModel.sharedInstance.customerId = 0
                    DCRModel.sharedInstance.customerCode = ""
                    DCRModel.sharedInstance.customerRegionCode = getRegionCode()
                    DCRModel.sharedInstance.doctorVisitId = 0
                    
                    if let navigationController = self.navigationController
                    {
                        navigationController.popViewController(animated: false)
                        navigationController.popViewController(animated: false)
                        navigationController.pushViewController(vc, animated: false)
                        
                        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ADD_DOCTOR_FROM_DCR)
                        
                        if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                        {
                            var model : [DCRDoctorVisitModel] = []
                            
                            model = DBHelper.sharedInstance.getDCRDoctorVisitPunchTimeValidation(dcrId: DCRModel.sharedInstance.dcrId)
                            if(model != nil && model.count > 0)
                            {
                                let doctorobj : DCRDoctorVisitModel = model[0]
                                
                                let initialAlert = "Check-out time for " + doctorobj.Doctor_Name + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + doctorobj.Doctor_Name

                                let alertViewController = UIAlertController(title: "Check Out", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)

                                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                                     navigationController.popViewController(animated: false)
                                    alertViewController.dismiss(animated: true, completion: nil)
                                    
                                }))

                                alertViewController.addAction(UIAlertAction(title: "Go to modify", style: UIAlertActionStyle.default, handler: { alertAction in
                                     navigationController.popViewController(animated: false)
                                    self.navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
                                    alertViewController.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.present(alertViewController, animated: true, completion: nil)
                            }
                            else
                            {
                                let currentLocation = getCurrentLocaiton()
                                
                                let initialAlert = "Check-in time for " + doctorNameLbl.text! + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + doctorNameLbl.text!
                                
                                //let indexpath = sender.tag
                                
                                let alertViewController = UIAlertController(title: "Check In", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)

                                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                                    navigationController.popViewController(animated: false)
                                    alertViewController.dismiss(animated: true, completion: nil)
                                    
                                }))
                                alertViewController.addAction(UIAlertAction(title: "Check In", style: UIAlertActionStyle.default, handler: { alertAction in
                                    if (privValue == PrivilegeValues.YES.rawValue)
                                    {
                                        let sb = UIStoryboard(name: mainSb, bundle: nil)
                                        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                        vc.webViewTitle = "Add \(appDoctor)"
                                        
                                        let companyObj = DBHelper.sharedInstance.getCompanyDetails()
                                        
                                        if (companyObj != nil)
                                        {
                                            let companyUrl = companyObj!.companyURL
                                            var url = "https://" + companyUrl!
                                            url += "/HiDoctor_Master/CMDoctor/Doctormaster?CC="
                                            
                                            var queryString: String = "CC="
                                            queryString += getCompanyCode() + "&UC=" + getUserCode() + "&RC=" + getRegionCode()
                                            queryString += "&S=2"
                                            queryString += "&DN=\(self.doctorNameLbl.text!)"
                                            queryString += "&SC=\(self.specialtyCode)"
                                            
                                            let data = queryString.data(using: String.Encoding.utf8)
                                            let encodedString = data?.base64EncodedString()
                                            
                                            url += encodedString!
                                            print(url)
                                            
                                            vc.siteURL = url
                                            vc.pageSource = 1
                                            
                                            navigationController.pushViewController(vc, animated: false)
                                        }
                                    }
                                  
                                    
                                }))
                                self.present(alertViewController, animated: true, completion: nil)
                                
                            }
                        
                    }
                        else
                        {
                            if (privValue == PrivilegeValues.YES.rawValue)
                            {
                                let sb = UIStoryboard(name: mainSb, bundle: nil)
                                let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
                                vc.webViewTitle = "Add \(appDoctor)"
                                
                                let companyObj = DBHelper.sharedInstance.getCompanyDetails()
                                
                                if (companyObj != nil)
                                {
                                    let companyUrl = companyObj!.companyURL
                                    var url = "https://" + companyUrl!
                                    url += "/HiDoctor_Master/CMDoctor/Doctormaster?CC="
                                    
                                    var queryString: String = "CC="
                                    queryString += getCompanyCode() + "&UC=" + getUserCode() + "&RC=" + getRegionCode()
                                    queryString += "&S=2"
                                    queryString += "&DN=\(doctorNameLbl.text!)"
                                    queryString += "&SC=\(specialtyCode)"
                                    
                                    let data = queryString.data(using: String.Encoding.utf8)
                                    let encodedString = data?.base64EncodedString()
                                    
                                    url += encodedString!
                                    print(url)
                                    
                                    vc.siteURL = url
                                    vc.pageSource = 1
                                    
                                    navigationController.pushViewController(vc, animated: false)
                                }
                            }
                           
                        }
                    }
                }
            }
            else
            {
                let sb = UIStoryboard(name: detailProductSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
                let dict = ["Customer_Name":doctorNameLbl.text!,"Customer_Code" : EMPTY,"Region_Code":getRegionCode(),"Region_Name": getRegionName(),"Speciality_Name":doctorSpeciality.text!,"Category_Name":EMPTY,"MDL_Number":EMPTY,"Customer_Entity_Type": "DOCTOR"]
                let customerObj = CustomerMasterModel(dict: dict as NSDictionary)
                vc.customerModel = customerObj
                vc.isFromRCPA = true
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func isCurrentDate() -> Bool
    {
        
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func specialityAction(_ sender: AnyObject)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SpecialityListVcId") as! FlexiDoctorSpeciality
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getSelectedSpeciality(name: String, code: String) {
        if name != ""
        {
            validSpeciality = true
            doctorSpeciality.text = name
            specialtyCode = code
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
