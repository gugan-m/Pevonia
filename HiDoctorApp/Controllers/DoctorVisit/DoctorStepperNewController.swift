//
//  DoctorStepperNewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import MobileCoreServices
class DoctorStepperNewController : UIViewController, UINavigationControllerDelegate, UIDocumentPickerDelegate
{
   //mark variables
   
       var customerMasterModel:CustomerMasterModel!
       var flexiSpecialityName : String = ""
       var flexiDoctorName : String = ""
       var stepperIndex: DoctorVisitStepperIndex!
       var locationAlertCount: Int = 0
       var geoLocationSkipRemarks: String = EMPTY
       var currentLocation: GeoLocationModel!
       var doctorStepperString = String()
       var objBusinessStatus: BusinessStatusModel?
       var obj: BussinessPotential?
       var punch_start: String?
       var punch_status: Int?
       var punch_timezone: String?
       var punch_timeoffset: String?
       var punch_UTC: String?
    let pobAmt: Double = 0
    var meetingObjectiveList: [CallObjectiveModel] = []
    var sampleList: [UserProductMapping] = []
    var selectedSampleArr: [UserProductMapping] = []
    var masterSampleArr: [UserProductMapping] = []
    var searchSampleArr: [UserProductMapping] = []
    var isSearchEnable = false
    var searchtext = ""
    var objDoctor : StepperDoctorModel?
    var userDCRProductList : [DCRSampleModel] = []
    var attachmentList : [DCRAttachmentModel] = []
    var selectedCallObj : CallObjectiveModel?
    var pickerview = UIPickerView()
    var visitTimePicker = UIDatePicker()
    var visitTime : String = EMPTY
    var visitMode : String = AM
    var dueDatePicker : UIDatePicker!
    var dueDate : String?
    var modifyDoctorVisitObj : DCRDoctorVisitModel!
    var specialityName : String = EMPTY
    var doctorName : String = EMPTY
    var objCallObjective: BusinessStatusModel?
    var campaignCode = ""
       var campaignName = ""
       var time: String = ""
    var customerMasterObj:CustomerMasterModel!
    
    // Mark outlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var doctorVisitDate: UILabel!
    @IBOutlet weak var eDetailingButton: UIButton!
    @IBOutlet weak var eDetailingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detailedproducttblview: UITableView!
    @IBOutlet weak var accompanisttblview: UITableView!
    @IBOutlet weak var visittime: TextField!
    @IBOutlet weak var checkinlabel: UILabel!
    @IBOutlet weak var checkoutlabel: UILabel!
    @IBOutlet weak var followupsdate: TextField!
    @IBOutlet weak var followupremarks: UITextView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblAttachments: UITableView!
       @IBOutlet weak var sampleSearchBar: UISearchBar!
       @IBOutlet weak var tblSamples: UITableView!
    @IBOutlet weak var tblSelectedSample: UITableView!
       @IBOutlet weak var SelectedListHeaderView: UIView!
       @IBOutlet weak var selectedListView: UITableView!
    @IBOutlet weak var viewhdrSelectedSamples: UIView!
      @IBOutlet weak var cons_AttachmentHeight: NSLayoutConstraint!
    @IBOutlet weak var consSelectedTblHeight: NSLayoutConstraint!
@IBOutlet weak var txtMeetingObjective: UITextField!
    //mark actions
    @IBAction func addattachment() {
        
        
        
    }
    @IBAction func adddetailedproduct() {
        
        
    }
    
    @IBAction func submitdoctoraction() {
            
            let dcrDoctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList
                  if dcrDoctorVisitList.count > 0
                  {
                      let dcrDoctorVisitObj = dcrDoctorVisitList.first
                      self.modifyDoctorVisitObj = dcrDoctorVisitObj
                  }
                  else
                  
                  {
                  savedoctorvisitdetails()
                  }
            let doctorobj = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList[0]
            if(isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && doctorobj.Punch_Start_Time != "" && doctorobj.Punch_End_Time == "" )
            {
                
                let initialAlert = "Check-out time for " + doctorobj.Doctor_Name + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + doctorobj.Doctor_Name
                //let indexpath = sender.tag
                let alertViewController = UIAlertController(title: "Check Out", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                    //_ = self.navigationController?.popViewController(animated: false)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "Check Out", style: UIAlertActionStyle.default, handler: { alertAction in
                    //function
                    DBHelper.sharedInstance.updatepunchendtime(Customercode: doctorobj.Doctor_Code!, regioncode:doctorobj.Doctor_Region_Code!, time:getStringFromDateforPunch(date: getCurrentDateAndTime()))
                    self.updatepunchout(dcrID: doctorobj.DCR_Id, visitid: doctorobj.DCR_Doctor_Visit_Id!)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
            else
            {
                let doctorObj = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList[0]
                let statusMsg = BL_DCR_Doctor_Visit.sharedInstance.doDoctorVisitAllValidations(doctorVisitObj: doctorObj)
                if statusMsg != ""
                {
                    AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
                }
                else if BL_DCR_Doctor_Visit.sharedInstance.checkAccompanistCallStatus() != nil
                {
                    let alertMsg = accompMissedPrefixErrorMsg + (BL_DCR_Doctor_Visit.sharedInstance.checkAccompanistCallStatus()?.Employee_Name)! + accompMissedSuffixErrorMsg
                    AlertView.showAlertView(title: alertTitle, message: alertMsg, viewController: self)
                }
                else
                {
                    _ = navigationController?.popViewController(animated: false)
                }
            }
        
    }
    
    @IBAction func edetailingaction() {
        BL_DoctorList.sharedInstance.regionCode = DCRModel.sharedInstance.customerRegionCode
        BL_DoctorList.sharedInstance.customerCode = DCRModel.sharedInstance.customerCode
        
        let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode)
        
        CustomerModel.sharedInstance.navTitle = checkNullAndNilValueForString(stringData: customerObj?.Customer_Name)
        BL_DoctorList.sharedInstance.doctorTitle = checkNullAndNilValueForString(stringData: customerObj?.Customer_Name)
        
        var deletailedDBId = DBHelper.sharedInstance.getMaxCustomerDetailedId(customerCode: BL_DoctorList.sharedInstance.customerCode, customerRegionCode: BL_DoctorList.sharedInstance.regionCode, detailingDate: getCurrentDate())
        
        if (deletailedDBId == nil)
        {
            deletailedDBId = 0
        }
        
        BL_AssetModel.sharedInstance.detailedCustomerId = deletailedDBId! + 1
        self.flexiDoctorName = checkNullAndNilValueForString(stringData: customerObj?.Customer_Name)
        moveToNextScreen()
    }
    
    override func viewDidLoad() {
        self.selectedSampleArr = []
               self.masterSampleArr = []
               self.searchSampleArr = []
               self.getMeetingObjective()
               self.getSamplesList()
        self.currentLocation = getCurrentLocaiton()
        self.pickerview.delegate = self as! UIPickerViewDelegate
               let val = userDCRProductList
        setDefaults()
        setDoneButton()
        let attachmentArr = Bl_Attachment.sharedInstance.getDCRAttachment(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        if attachmentArr != nil
        {
            attachmentList = attachmentArr!
        }
        self.addTimePicker()
        addFromDatePicker()
        followupremarks.layer.borderWidth = 1
        followupremarks.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        followupremarks.layer.cornerRadius = 4
        self.txtMeetingObjective.inputView = self.pickerview
        addCustomBackButtonToNavigationBar()
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        self.title = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate) + " (Field)"
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if (isCurrentDate())
        {
            visittime.isEnabled = false
            var intime : String = ""
            intime = stringFromDate(date1: getDateFromString(dateString: punch_start ?? ""))
            
            var outtime = ""
            self.checkinlabel.text = "Check In: \(intime)"
            self.checkoutlabel.text = "Check Out: \(outtime)"
            
        }
        let followUpModifyList = BL_DCR_Follow_Up.sharedInstance.getDCRFollowUpDetails()
               if (followUpModifyList != nil && followUpModifyList.count > 0)
               {
                   let modifyFollowUpObj = followUpModifyList[0]
                let date = getStringFromDate(date: modifyFollowUpObj.Due_Date!)
                dueDate = date
                followupremarks.text = modifyFollowUpObj.Follow_Up_Text
                followupsdate.text = dueDate
                   // BL_DCR_Follow_Up.sharedInstance.updateDCRFollowUpDetail(followUpObj: modifyFollowUpObj!)
               }
        let dcrDoctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitList()
        if dcrDoctorVisitList?.count ?? 0 > 0
              {
                for i in dcrDoctorVisitList!
                {
                    if (i.Doctor_Code == DCRModel.sharedInstance.customerCode)
                    {
                        let dcrDoctorVisitObj = i
                        self.modifyDoctorVisitObj = dcrDoctorVisitObj
                        visittime.text = dcrDoctorVisitObj.Visit_Time
                        self.txtMeetingObjective.text = dcrDoctorVisitObj.Call_Objective_Name
                    }
                }
               
                
              }
             
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        let followUpModifyList = BL_DCR_Follow_Up.sharedInstance.getDCRFollowUpDetails()
        if (followUpModifyList != nil && followUpModifyList.count > 0)
        {
            let modifyFollowUpObj = followUpModifyList[0]
            let date = getDateFromString(dateString: dueDate!)
            modifyFollowUpObj.Due_Date = date
            modifyFollowUpObj.Follow_Up_Text = followupremarks.text
            BL_DCR_Follow_Up.sharedInstance.updateDCRFollowUpDetail(followUpObj: modifyFollowUpObj)
        }
        else
        {
            if (dueDate == nil)
            {
                dueDate = convertDateIntoServerStringFormat(date:DCRModel.sharedInstance.dcrDate)
            }
            BL_DCR_Follow_Up.sharedInstance.saveDCRFollowUpDetail(remarksText:followupremarks.text, dueDate: dueDate!)
        }
        let dcrDoctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitList()
        if dcrDoctorVisitList?.count ?? 0 > 0
        {
            for i in dcrDoctorVisitList!
            {
                if (i.Doctor_Code == DCRModel.sharedInstance.customerCode)
                {
                    let dcrDoctorVisitObj = i
                               self.modifyDoctorVisitObj = dcrDoctorVisitObj
                               self.modifyDoctorVisitObj.Visit_Time = visittime.text
                    self.modifyDoctorVisitObj.Call_Objective_ID = i.Call_Objective_ID
                    self.modifyDoctorVisitObj.Call_Objective_Name = i.Call_Objective_Name
                               updatedoctorvisitdetails()
                }
            }
           
        }
        else
        
        {
        savedoctorvisitdetails()
        }
        if selectedSampleArr.count != 0  {
            var currentList = convertToDCRSampleModel(list: selectedSampleArr)
                let temp = currentList
            currentList.removeAll()
            for i in temp
            {
                i.sampleObj.DCR_Id = DCRModel.sharedInstance.dcrId
                i.sampleObj.DCR_Doctor_Visit_Id = DCRModel.sharedInstance.doctorVisitId
                i.sampleObj.DCR_Sample_Id = 0
                currentList.append(i)
            }
            let sampleBatchList = BL_SampleProducts.sharedInstance.convertToSampleBatchModel(selectedList: currentList,isComingFromModifyPage:false, dcrId: DCRModel.sharedInstance.dcrId,visitId:DCRModel.sharedInstance.customerVisitId,sampleId: 0)
                      // changeCurrentList(list: sampleBatchList)
            
                   BL_SampleProducts.sharedInstance.saveDoctorSampleDCRProducts(sampleProductList: sampleBatchList,isFrom:sampleBatchEntity.Doctor.rawValue,doctorVisitId: DCRModel.sharedInstance.customerVisitId)
            }
    }
    
    // mark functions
    
    func updatedoctorvisitdetails()
    {
           
                   // self.setValueToModifyObj()
        BL_DCR_Doctor_Visit.sharedInstance.updateDCRDoctorVisit(dcrDoctorVisitObj: self.modifyDoctorVisitObj, viewController: self)
 
                    _ = self.navigationController?.popViewController(animated: false)
                    if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                    {
                        let customerCode = DCRModel.sharedInstance.customerCode
                        let remarksText =  ""
                        let statusId: Int = defaultBusineessStatusId
                        let statusName: String = EMPTY
                        let postData: NSMutableArray = []
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":customerCode ?? EMPTY,"Doctor_Name":self.modifyDoctorVisitObj.Doctor_Name,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":self.modifyDoctorVisitObj.Speciality_Name,"Category_Code": self.modifyDoctorVisitObj.Category_Code ?? EMPTY,"MDL_Number":self.modifyDoctorVisitObj.MDL_Number!,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":modifyDoctorVisitObj.Punch_Start_Time,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":1,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                        
                        postData.add(dict)
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                
                                removeCustomActivityView()
                                _ = self.navigationController?.popViewController(animated: false)

                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                        })
                    }
                    
                    
                }
    
    
    func savedoctorvisitdetails()
   {
                    let customerCode = DCRModel.sharedInstance.customerCode
                    let remarksText =  ""
                    var statusId: Int = defaultBusineessStatusId
                    var statusName: String = EMPTY
                  
                    
                    //                let doctorVisits = DBHelper.sharedInstance.getEdetailingModified(drcCustomerCode: DCRModel.sharedInstance.customerCode, regionCode: getRegionCode())
                    
                    if  customerCode == ""
                    {
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .short
                        
                        if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                        {
                            let postData: NSMutableArray = []
                            let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":self.doctorName,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Speciality_Name":self.specialityName,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":time,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                            
                            postData.add(dict)
                            showCustomActivityIndicatorView(loadingText: "Loading...")
                            WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    removeCustomActivityView()
                                    let visittime = stringFromDate(date1: Date())
                                    let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                    let visitmode = visittime.substring(from: lastcharacterIndex)
                                    var localTimeZoneName: String { return TimeZone.current.identifier }
                                    BL_DCR_Doctor_Visit.sharedInstance.savePunchInFlexiDoctorVisitDetails( doctorName: self.doctorName, specialityName: self.specialityName, visitTime: visittime, visitMode: visitmode, pobAmount: self.pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode, Punch_Start_Time: self.time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch())
                                        self.insertDCRDoctorAccompanists()
                                    _ = self.navigationController?.popViewController(animated: false)

                                }
                                else
                                {
                                    removeCustomActivityView()
                                    AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                                }
                            })
                        }
                        else if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                        {
                            
                            var visittime = ""
                            var visitmode = ""
                            
                            if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() || BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ){
                                
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
                            var localTimeZoneName: String { return TimeZone.current.identifier }
                            BL_DCR_Doctor_Visit.sharedInstance.savePunchInFlexiDoctorVisitDetails( doctorName: doctorName, specialityName: specialityName, visitTime: stringFromDate(date1: getDateFromString(dateString: time)), visitMode: visitmode, pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode, Punch_Start_Time: time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch())
                            insertDCRDoctorAccompanists()
                            _ = self.navigationController?.popViewController(animated: false)
                        }
                        else
                        {
                            
                            BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: doctorName, specialityName: specialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: pobAmt, remarks:remarksText, regionCode: BL_InitialSetup.sharedInstance.regionCode, viewController: self, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective,campaignName:self.campaignName, campaignCode:self.campaignCode)
                            insertDCRDoctorAccompanists()
                            _ = self.navigationController?.popViewController(animated: false)
                        }
                    }
                    else
                    {
                        
                        
                        if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                        {
                            let postData: NSMutableArray = []
                            let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code":customerCode ?? EMPTY,"Doctor_Name":customerMasterObj.Customer_Name,"regionCode":DCRModel.sharedInstance.customerRegionCode,"Speciality_Name":customerMasterObj.Speciality_Name,"Category_Code":customerMasterObj.Category_Code ?? EMPTY,"MDL_Number":customerMasterObj.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":time,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":DCRModel.sharedInstance.customerRegionCode,"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                            
                            postData.add(dict)
                            showCustomActivityIndicatorView(loadingText: "Loading...")
                            WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    removeCustomActivityView()
                                    
                                   let visittime = stringFromDate(date1: Date())
                                    let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                   let visitmode = visittime.substring(from: lastcharacterIndex)
                                    
                                    var localTimeZoneName: String { return TimeZone.current.identifier }
                                    BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails( customerCode: customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: self.pobAmt, remarks: remarksText, regionCode: DCRModel.sharedInstance.customerRegionCode, viewController: self, geoFencingSkipRemarks: "", latitude: 0.0, longitude: 0.0, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: self.campaignName, campaignCode: self.campaignCode, Punch_Start_Time: self.time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch() )
                                       // self.insertDCRDoctorAccompanists()
                                        _ = self.navigationController?.popViewController(animated: false)
                                    
                                }
                                else
                                {
                                    removeCustomActivityView()
                                    AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                                }
                            })
                        }
                        else if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                        {
                            
                            
                            var visittime = ""
                            var visitmode = ""
                            
                            if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() || BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ){
                                
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
                            
                            var localTimeZoneName: String { return TimeZone.current.identifier }
                            BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails( customerCode: customerCode, visitTime: stringFromDate(date1: getDateFromString(dateString: time)), visitMode: visitmode, pobAmount: pobAmt, remarks: remarksText, regionCode: DCRModel.sharedInstance.customerRegionCode, viewController: self, geoFencingSkipRemarks: "", latitude: 0.0, longitude: 0.0, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: self.campaignName, campaignCode: self.campaignCode, Punch_Start_Time: time, Punch_Status: 1, Punch_Offset: getOffset(), Punch_TimeZone: localTimeZoneName, Punch_UTC_DateTime: getUTCDateForPunch() )
                           // insertDCRDoctorAccompanists()
                            _ = self.navigationController?.popViewController(animated: false)
                        }
                        else
                        {
                            BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: pobAmt, remarks: remarksText,regionCode: DCRModel.sharedInstance.customerRegionCode!, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: self.objCallObjective, campaignName: campaignName, campaignCode: self.campaignCode)
                           // insertDCRDoctorAccompanists()
                            _ = self.navigationController?.popViewController(animated: false)
                        }
                    }
                    
                }
    func insertDCRDoctorAccompanists()
    {
        BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanistVandNA())
    }
    func setDoneButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "icon-done"), for: .normal)
        button.addTarget(self, action:#selector(doneAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
       
    }
    func getMeetingObjective() {
        self.meetingObjectiveList = DBHelper.sharedInstance.getCallObjectiveByEntityType(entityType: Constants.Call_Objective_Entity_Type_Ids.Doctor)
    }
    @objc func doneAction() {
           self.navigationController?.popViewController(animated: true)
       }
    
    func getSamplesList() {
        userDCRProductList = BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)!
        if userDCRProductList.count != 0 {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: DCRModel.sharedInstance.dcrDateString)!
            for sam_obj in userDCRProductList {
                for num in 0..<self.sampleList.count{
                    if sam_obj.sampleObj.Product_Code == self.sampleList[num].Product_Code {
                        self.sampleList[num].Selected_Quantity = sam_obj.sampleObj.Quantity_Provided
                    }
                }
            }
            // Non filtered Array
            for sam_obj in userDCRProductList {
                for sample in self.sampleList{
                    if sam_obj.sampleObj.Product_Code != sample.Product_Code && sample.Selected_Quantity == 0 {
                        self.masterSampleArr.append(sample)
                    }
                }
            }
            // Selected ArrList
            for sam_obj in userDCRProductList {
                for sample in self.sampleList{
                    if sam_obj.sampleObj.Product_Code == sample.Product_Code && sample.Selected_Quantity > 0{
                        self.selectedSampleArr.append(sample)
                    }
                }
            }
        } else {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: DCRModel.sharedInstance.dcrDateString)!
            if selectedSampleArr.count == 0 && self.masterSampleArr.count == 0 {
                self.masterSampleArr = self.sampleList
            }
        }
        self.tblSelectedSample.reloadData()
               self.tblSamples.reloadData()
               self.scrollView.contentSize =
               self.setScrollViewOffset()
    }
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
    
    @objc func backButtonClicked()
    {
        if(BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList != nil &&  BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList.count > 0){
            
            let doctorobj = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList[0]
            if(isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && doctorobj.Punch_Start_Time != "" && doctorobj.Punch_End_Time == "" )
            {
                let initialAlert = "Check-out time for " + doctorobj.Doctor_Name + " is " + getcurrenttime() + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + doctorobj.Doctor_Name
                //let indexpath = sender.tag
                let alertViewController = UIAlertController(title: "Check Out", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
                    
                    alertAction in
                    
                    //_ = self.navigationController?.popViewController(animated: false)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "Check Out", style: UIAlertActionStyle.default, handler: { alertAction in
                    //function
                    DBHelper.sharedInstance.updatepunchendtime(Customercode: doctorobj.Doctor_Code!, regioncode:doctorobj.Doctor_Region_Code!, time:getStringFromDateforPunch(date: getCurrentDateAndTime()))
                    self.updatepunchout(dcrID: doctorobj.DCR_Id, visitid: doctorobj.DCR_Doctor_Visit_Id!)
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
            else
            {
                _ = navigationController?.popViewController(animated: false)
            }
        }
        else
        {
            _ = navigationController?.popViewController(animated: false)
            
        }
    }
    
    func updatepunchout(dcrID: Int, visitid: Int)
    {
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE DCR_Id = \(dcrID) AND DCR_Doctor_Visit_Id = '\(visitid)'")
        _ = navigationController?.popViewController(animated: false)
        
        
    }
    
    func getServerTime() -> String
       {
           let date = Date()
           return stringFromDate(date1: date)
       }
    func getVisitTimeMode() -> String
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode()
    }
    func getVisitMode(visitTimeEntry:String) ->(visitMode:String,visitTime:String)
       {
           var visitTime = EMPTY
           var visitMode = EMPTY
           
           if visitTimeEntry == PrivilegeValues.AM_PM.rawValue
           {
               visitMode = getVisitModeType(visitTime: getServerTime())
           }
           else
           {
               visitMode = getVisitModeType(visitTime: getServerTime())
               visitTime = getServerTime()
           }
           
           return (visitMode,visitTime)
       }
    func getVisitModeType(visitTime : String) -> String
      {
          let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
          return visitTime.substring(from: lastcharacterIndex)
      }
    func insertDCRDoctorVisit(completion : @escaping (_ status : Int) -> ())
    {
        let objDoctorVisit = DBHelper.sharedInstance.getAllDetailsWith(dcrId: DCRModel.sharedInstance.dcrId, customerCode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode)
        
        if (objDoctorVisit == nil)
        {
            var visitTime: String = EMPTY
            var visitMode: String = AM
            
            
            
            if (!BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
            {
                var visittime = ""
                var visitmode = ""
                
                if(BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() || BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME.rawValue ){
                    
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
                BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: defaultBusineessStatusId, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY, Punch_Start_Time: punch_start, Punch_Status: punch_status, Punch_Offset: punch_timeoffset, Punch_TimeZone: punch_timezone, Punch_UTC_DateTime: punch_UTC)
                
                BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
                
                completion(SERVER_SUCCESS_CODE)
                
            }
            else {
                if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
                {
                    
                    let postData: NSMutableArray = []
                 
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": DCRModel.sharedInstance.customerCode,"Doctor_Name":flexiDoctorName,"regionCode":customerMasterModel.Region_Code,"Speciality_Name":customerMasterModel.Speciality_Name,"Category_Code":customerMasterModel.Category_Code ?? EMPTY,"MDL_Number":customerMasterModel.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + getServerTime(),"Lattitude":self.currentLocation.Latitude,"Longitude":self.currentLocation.Longitude ,"Modified_Entity":0,"Doctor_Region_Code":customerMasterModel.Region_Code,"Customer_Entity_Type":"D"]
                    
                    postData.add(dict)
                    
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            
                            let visittime = stringFromDate(date1: Date())
                            let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                            let visitmode = visittime.substring(from: lastcharacterIndex)
                            
                            
                            BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: defaultBusineessStatusId, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY, Punch_Start_Time: self.punch_start, Punch_Status: self.punch_status, Punch_Offset: self.punch_timeoffset, Punch_TimeZone: self.punch_timezone, Punch_UTC_DateTime: self.punch_UTC)
                            
                            BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
                            
                            completion(SERVER_SUCCESS_CODE)

                        }
                        else
                        {
                            removeCustomActivityView()
                            completion(SERVER_ERROR_CODE)
                        }
                        
                    })
                    
                }
                else if(BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
                {
                    let visitTimeEntry = getVisitTimeMode()
                    let getVisitDetails = self.getVisitMode(visitTimeEntry: visitTimeEntry)
                    visitMode = getVisitDetails.visitMode
                    visitTime = getVisitDetails.visitTime
                    
                    BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: defaultBusineessStatusId, businessStatusName: EMPTY, objCallObjective: nil,  campaignName: EMPTY, campaignCode: EMPTY)
                    
                    BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
                    
                    completion(SERVER_SUCCESS_CODE)
                }
                else
                {
                    let visitTimeEntry = getVisitTimeMode()
                    if visitTimeEntry != PrivilegeValues.AM_PM.rawValue
                    {
                        visitMode = AM
                    }
                    BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: defaultBusineessStatusId, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                    
                    BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
                    
                    completion(SERVER_SUCCESS_CODE)
                }
            }
        }
        else
        {
            
            if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
            {
                
                let postData: NSMutableArray = []
            
                
                let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": DCRModel.sharedInstance.customerCode,"Doctor_Name":flexiDoctorName,"regionCode":customerMasterModel.Region_Code,"Speciality_Name":customerMasterModel.Speciality_Name,"Category_Code":customerMasterModel.Category_Code ?? EMPTY,"MDL_Number":customerMasterModel.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":objDoctorVisit?.Punch_Start_Time ?? "" ,"Lattitude":objDoctorVisit?.Lattitude ?? 0.0,"Longitude":objDoctorVisit?.Longitude ?? 0.0 ,"Modified_Entity":1,"Doctor_Region_Code":objDoctorVisit?.Doctor_Region_Code ?? "","Customer_Entity_Type":"D"]
                
                postData.add(dict)
                
                showCustomActivityIndicatorView(loadingText: "Loading...")
                
                WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        removeCustomActivityView()
                        
                        completion(SERVER_SUCCESS_CODE)

                    }
                    else
                    {
                        removeCustomActivityView()
                        completion(SERVER_ERROR_CODE)
                    }
                    
                })
                
            }else{
                completion(SERVER_SUCCESS_CODE)
            }
        }
    }
    @IBAction func act_stepper(_ sender: UIStepper) {
        
        for num in 0..<self.sampleList.count {
            if self.sampleList[num].Product_Id == sender.tag {
                self.sampleList[num].Selected_Quantity = Int(sender.value)
            }
        }
        self.selectedSampleArr = self.sampleList.filter{$0.Selected_Quantity != 0}
        if self.selectedSampleArr.count == 0 {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: DCRModel.sharedInstance.dcrDateString)!
        }
        self.masterSampleArr = self.sampleList.filter{$0.Selected_Quantity == 0}
        if self.isSearchEnable ==  true {
            self.sortCurrentList(searchText: self.searchtext)
        }
        
        self.tblSelectedSample.reloadData()
        self.tblSamples.reloadData()
        self.scrollView.contentSize =
        self.setScrollViewOffset()
    }
    private func addTimePicker()
    {
        visitTimePicker = getTimePickerView()
        visittime.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DoctorVisitViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(DoctorVisitViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        visittime.inputAccessoryView = doneToolbar
        visittime.inputView = visitTimePicker
    }
    @objc func cancelBtnClicked()
    {
        self.visittime.resignFirstResponder()
    }
    
    @objc func doneBtnClicked()
    {
        let time = self.visitTimePicker.date
        let selectedVisitTime = stringFromDate(date1: time)
        self.visittime.text = selectedVisitTime
        self.visitMode = self.getVisitModeType(visitTime: selectedVisitTime)
        self.visitTime = selectedVisitTime
        self.visittime.resignFirstResponder()
    }
    
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        self.followupsdate.text = date
    }
    
    private func addFromDatePicker()
    {
        dueDatePicker = getDatePickerView()
        dueDatePicker.minimumDate = DCRModel.sharedInstance.dcrDate
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelBtnClicked1))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        followupsdate.inputAccessoryView = doneToolbar
        followupsdate.inputView = dueDatePicker
    }
    
    @objc func fromPickerDoneAction()
    {
        dueDate = convertDateInRequiredFormat(date: dueDatePicker.date, format: defaultServerDateFormat)
        setDateDetails(sender: dueDatePicker)
        followupsdate.resignFirstResponder()
    }
    
    @objc func cancelBtnClicked1()
    {
        followupsdate.resignFirstResponder()
    }
    func setScrollViewOffset() -> CGSize {
        let serch_listHeight = CGFloat(395)
        let selected_thblHeight = CGFloat(70 * self.selectedSampleArr.count)
        if self.selectedSampleArr.count == 0 {
            self.viewhdrSelectedSamples.isHidden = true
            self.selectedListView.isHidden = true
        } else {
            self.viewhdrSelectedSamples.isHidden = false
            self.selectedListView.isHidden = false
        }
        self.consSelectedTblHeight.constant = selected_thblHeight
        let tbl_Sample_maxy = self.tblSamples.frame.origin.y + self.tblSamples.frame.maxY
        return CGSize(width: self.view.frame.width, height: selected_thblHeight + tbl_Sample_maxy)
    }
    private func moveToNextScreen()
    {
        insertDCRDoctorVisit { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                self.deleteShowList()
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: AssetParentVCID) as! AssetParentViewController
                
                vc.isComingFromDCR = true
                if(BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList != nil &&  BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList.count > 0)
                {
                    let doctorobj = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList[0]
                    if(doctorobj.Punch_End_Time != "")
                    {
                        BL_AssetModel.sharedInstance.isfromDcrPunchIn = true
                        BL_AssetModel.sharedInstance.punchin = doctorobj.Punch_Start_Time!
                        BL_AssetModel.sharedInstance.punchout = doctorobj.Punch_End_Time!
                        BL_AssetModel.sharedInstance.punchutc = doctorobj.Punch_UTC_DateTime!
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showAlertView(title: alertTitle, message: "DVR Date is not a current date", viewController: self)
            }
        }
        
    }
    private func toggleEDetailingButton()
    {
        hideEDetailingButon()
        
        if (BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            if (DCRModel.sharedInstance.dcrDateString == getServerFormattedDateString(date: getCurrentDateAndTime()))
            {
                if (DCRModel.sharedInstance.customerCode != EMPTY)
                {
                    showEDetailingButton()
                }
            }
        }
    }
    
    private func showEDetailingButton()
    {
        eDetailingButton.isHidden = false
        eDetailingView.isHidden = false
        eDetailingWidthConstraint.constant = 200
        doctorVisitDate.isHidden = true
        
        var buttonHeight: CGFloat = 60
        
        if SwifterSwift().isPhone
        {
            buttonHeight = 40
        }
        
        eDetailingViewHeightConstraint.constant = buttonHeight
        
        let height = CGFloat(8 + getDetailLabelHeight() + 12 + buttonHeight + 12)
        
        headerViewHeightConstraint.constant = height
    }
    
    private func hideEDetailingButon()
    {
        eDetailingButton.isHidden = true
        eDetailingView.isHidden = true
        eDetailingWidthConstraint.constant = 0
        doctorVisitDate.isHidden = false
        
        let height = CGFloat(8 + getDetailLabelHeight() + 12 + 14 + 12)
        
        eDetailingViewHeightConstraint.constant = 0
        headerViewHeightConstraint.constant = height
    }
    
    private func getDetailLabelHeight() -> CGFloat
    {
        let height = getTextSize(text: doctorDetail.text, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 32).height
        return height
    }
    func setDefaults()
       {
           if DCRModel.sharedInstance.customerCode == ""
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
           
           if DCRModel.sharedInstance.customerCode == ""
           {
               let userObj = getUserModelObj()
               doctorDetail.text = String(format: "%@ | %@", flexiSpecialityName, (userObj?.Region_Name)!)
               DCRModel.sharedInstance.doctorSpeciality = flexiSpecialityName
           }
           else
           {
               if customerMasterModel.MDL_Number != ""
               {
                   let strHospitalName = checkNullAndNilValueForString(stringData: customerMasterModel.Hospital_Name!) as? String
                   let strHospitalAccountNumber = checkNullAndNilValueForString(stringData: customerMasterModel.Hospital_Account_Number!) as? String
                   
                   if customerMasterModel.Hospital_Account_Number != ""
                   {
                       detailText = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName!, strHospitalAccountNumber!, customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                   }
                   else
                   {
                       detailText = String(format: "%@ | %@ | %@ | %@ ", strHospitalName!, customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
                   }
               }
               else
               {
                   detailText = String(format: "%@ | %@ | %@", customerMasterModel.Speciality_Name, customerMasterModel.Category_Name!, customerMasterModel.Region_Name)
               }
               
               if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && customerMasterModel.Sur_Name != ""
               {
                   detailText = String(format: "%@ | %@", detailText, customerMasterModel.Sur_Name!)
               }
               
               if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && customerMasterModel.Local_Area != ""
               {
                   detailText = String(format: "%@ | %@", detailText, customerMasterModel.Local_Area!)
               }
               
               doctorDetail.text = detailText
               DCRModel.sharedInstance.doctorSpeciality = customerMasterModel.Speciality_Name
           }
           
           let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
           doctorVisitDate.text = String(format: "Date: %@", dcrDateVal)
           
           submitbtn.setTitle("Submit", for: .normal)
           
           toggleEDetailingButton()
       }
    private func deleteShowList()
    {
        //DBHelper.sharedInstance.clearTempList()
        BL_AssetModel.sharedInstance.assignAllPlayListToShowList(customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
    }
    
    func convertToDCRSampleModel(list : [UserProductMapping]) -> [DCRSampleModel]
    {
        var sampleObjList : [SampleProductsModel] = []
        var sampleProductList : [DCRSampleModel] = []
        
        for obj in list
        {
            let sampleObj : SampleProductsModel = SampleProductsModel()
            sampleObj.Product_Name = obj.Product_Name
            sampleObj.Product_Id = obj.Product_Id
            sampleObj.Product_Code = obj.Product_Code
            sampleObj.Current_Stock = obj.Current_Stock
            sampleObj.Product_Type_Name = obj.Product_Type_Name
            sampleObj.Division_Name = obj.Division_Name
            sampleObj.Quantity_Provided = obj.Selected_Quantity
            sampleObj.Speciality_Code = obj.Speciality_Code
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        
        return sampleProductList
    }
    
    func addDCRSampleProducts(list : [DCRSampleModel]) -> [DCRSampleModel]
    {
        let userSelectedList = list
        
        for obj in userSelectedList
        {
            _ = userDCRProductList.filter {
                if $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
                {
                    obj.sampleObj.Quantity_Provided = $0.sampleObj.Quantity_Provided
                }
                return true
            }
        }
        
        return userSelectedList
    }
    
    
    // Mark: - Attachment
    @IBAction func act_AddAttachment(_ sender: UIButton) {
           self.show_AddActionSheet()
       }
       
       func show_AddActionSheet() {
           showiCloudActionSheet()
       }
       
       @IBAction func removeAttachment(_ sender: UIButton) {
           let attachment_Name = self.attachmentList[sender.tag].attachmentName
           let alertController = UIAlertController(title: "\(attachment_Name!)", message: "Will be removed from this plan", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
               UIAlertAction in
               let filename = self.attachmentList[sender.tag].attachmentName ?? ""
              Bl_Attachment.sharedInstance.deleteAttachmentFile(fileName: filename)
           let attachmentArr = Bl_Attachment.sharedInstance.getDCRAttachment(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
            if attachmentArr != nil
            {
                self.attachmentList = attachmentArr!
            }
               self.tblAttachments.reloadData()
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
               UIAlertAction in
               
           }
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)
           self.present(alertController, animated: true, completion: nil)
       }
       
       private func showiCloudActionSheet()
       {
           let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
           
           let iCloudDrive = UIAlertAction(title: "iCloud Library", style: .default, handler: {
               (alert: UIAlertAction) -> Void in
               self.uploadFilesFromiCloud()
           })
           actionSheetController.addAction(iCloudDrive)
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
               (alert: UIAlertAction) -> Void in
               
           })
           actionSheetController.addAction(cancelAction)
           
           if SwifterSwift().isPhone
           {
               self.present(actionSheetController, animated: true, completion: nil)
           }
           else
           {
               if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                   currentPopoverpresentioncontroller.sourceView = self.view
                   currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                   currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                   self.present(actionSheetController, animated: true, completion: nil)
               }
           }
       }
       
       //MARK:- Get Image using iCloud Drive
       private func uploadFilesFromiCloud()
       {
           let value1 = [String(kUTTypePDF),String(kUTTypeImage),String(kUTTypeSpreadsheet), String(kUTTypeBMP)]
           let value2 = [String(kUTTypeTIFF), String(kUTTypeZipArchive),String(kUTTypeText),docxTypeId,docTypeId]
           var valueType: [String] = []
           valueType.append(contentsOf: value1)
           valueType.append(contentsOf: value2)
           
           let documentPickerController = UIDocumentPickerViewController(documentTypes:valueType, in: .import)
           documentPickerController.delegate = self
           documentPickerController.navigationController?.navigationBar.topItem?.title = " "
           
           self.present(documentPickerController, animated: true, completion: nil)
       }
       
       //MARK:- Document picker delegates
       func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
       {
           var fileCount = Int()
           fileCount = self.attachmentList.count
           if fileCount < maxFileUploadCount
           {
               if let getData = NSData(contentsOf: url)
               {
                   var fileSize = Float(getData.length)
                   fileSize = fileSize/(1024*1024)
                   if fileSize > maxFileSize
                   {
                       AlertView.showAlertView(title: "Alert", message: "File size should not exceed \(maxFileSize) MB")
                   }
                   else
                   {
                       let urlPath = url.path
                       let fileSplittedString = urlPath.components(separatedBy: "/")
                       if fileSplittedString.count > 0
                       {
                           let fileName = fileSplittedString.last!
                           
                           let formatter = DateFormatter()
                           formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                           let timestamp:String = formatter.string(from: getCurrentDateAndTime())
                           let modifiedFileName = "\(timestamp)-\(fileName)"
                           let fileSize = Bl_Attachment.sharedInstance.convertToBytes(number: fileSize)
                           Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: getData as Data, fileName: modifiedFileName)
                     Bl_Attachment.sharedInstance.insertAttachment(attachmentName: fileName, attachmentSize: fileSize)
                       }
                      let attachmentArr = Bl_Attachment.sharedInstance.getDCRAttachment(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                       if attachmentArr != nil
                       {
                           attachmentList = attachmentArr!
                       }
                       self.tblAttachments.reloadData()
                   }
                   
               }
           }
           else
           {
                        AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
                   }
       }

       
    
}
//MARK:- Table View Delegate Methods

extension DoctorStepperNewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAttachments
        {
            self.cons_AttachmentHeight.constant = CGFloat(self.attachmentList.count * 50)
            return self.attachmentList.count
        }
        else if tableView == tblSelectedSample
        {
            return selectedSampleArr.count
        }
        else
        {
            if self.isSearchEnable ==  true {
                return self.searchSampleArr.count
            } else {
                return self.masterSampleArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == tblAttachments
       {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TpMeetingObjAttachmentcell") as! TpMeetingObjAttachmentcell
        cell.lblAttachmentName.text = self.attachmentList[indexPath.row].attachmentName
        cell.btnDelete.tag = indexPath.row
        return cell
       }
       else if tableView == tblSelectedSample
       {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPSelectedSampleListCell") as! TPSelectedSampleListCell
        let obj = self.selectedSampleArr[indexPath.row]
        cell.Stepper.tag =  obj.Product_Id
        cell.Stepper.value = Double(obj.Selected_Quantity)
        cell.lblSampleName.text = obj.Product_Name
        cell.lblSampleCount.text = String(Int(cell.Stepper.value))
        return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TpMeetingObjSamplescell") as! TpMeetingObjSamplescell
            var obj: UserProductMapping!
            if self.isSearchEnable ==  true {
                obj = self.searchSampleArr[indexPath.row]
            } else {
                obj = self.masterSampleArr[indexPath.row]
            }
            cell.Stepper.tag =  obj.Product_Id
            cell.Stepper.value = Double(obj.Selected_Quantity)
            cell.lblSampleName.text = obj.Product_Name
            cell.lblSampleCount.text = String(Int(cell.Stepper.value))
        return cell
       }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblAttachments
        {
           return 50
        }
        else if tableView == tblSelectedSample
        {
          return 70
        }
        else
        {
           return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblAttachments
        {
            let sb = UIStoryboard(name: mainSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
            vc.webViewTitle = self.attachmentList[indexPath.row].attachmentName
            let redirectUrl = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: self.attachmentList[indexPath.row].attachmentName!)
            vc.siteURL = redirectUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK:- Search Bar Delegate Methods

extension DoctorStepperNewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.sampleSearchBar.resignFirstResponder()
        self.isSearchEnable = false
        self.searchtext = ""
        self.tblSamples.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchEnable = true
        self.sampleSearchBar.resignFirstResponder()
        self.tblSamples.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            self.isSearchEnable = true
            self.sortCurrentList(searchText: searchText)
        } else {
            self.searchSampleArr = self.masterSampleArr
            self.isSearchEnable = false
            self.searchtext = ""
            self.tblSamples.reloadData()
        }
        self.searchtext = searchText
    }
    
    func sortCurrentList(searchText:String)
    {
        var searchList : [UserProductMapping] = []
        searchList = self.masterSampleArr.filter { (userDetails) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let userName = (userDetails.Product_Name).lowercased()
            return userName.contains(lowerCasedText) && userDetails.Selected_Quantity == 0
        }
        self.searchSampleArr = searchList
         self.tblSamples.reloadData()
    }
}
//MARK:- Picker View Delegate Methods

extension DoctorStepperNewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.meetingObjectiveList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.meetingObjectiveList[row].Call_Objective_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCallObj = self.meetingObjectiveList[row]
        self.txtMeetingObjective.text = self.meetingObjectiveList[row].Call_Objective_Name
        self.txtMeetingObjective.resignFirstResponder()
        let dic = ["Business_Status_Id" : self.meetingObjectiveList[row].Call_Objective_ID ?? 0,"Status_Name" : self.meetingObjectiveList[row].Call_Objective_Name ?? EMPTY] as [String : Any]
            self.objCallObjective = BusinessStatusModel(dict : dic as NSDictionary)
    }
}
