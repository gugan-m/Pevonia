//
//  DoctorVisitStepperController.swift
//  HiDoctorApp
//
//  Created by Vijay on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import CoreLocation

class DoctorVisitStepperController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Do any additional setup after loading the view.
        //addBackButtonView()
        addCustomBackButtonToNavigationBar()
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        setDefaults()
        setDoctorStepper()
        BL_DCR_Doctor_Visit.sharedInstance.skipFromController = [Bool](repeating: false, count: BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.count)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

        var temp_dynmicOrderData:[String] = []
        for (index, element) in BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.enumerated()
        {
            if(element != Constants.ChemistDayCaptureValue.travel_details &&
                element != Constants.ChemistDayCaptureValue.expenses &&
                element != Constants.ChemistDayCaptureValue.stockiest)
            {
                temp_dynmicOrderData.append(element)
            }
        }
        if temp_dynmicOrderData != nil && temp_dynmicOrderData.count > 0{
            BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData = temp_dynmicOrderData
        }

        
        if BL_DCR_Doctor_Visit.sharedInstance.showAssetCard()
        {
            for (index, element) in BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.enumerated()
            {
                if(element == Constants.ChemistDayCaptureValue.detailing)
                {
                    if(index < BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.count-1)
                    {
                        if(!BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData[index+1].contains(Constants.ChemistDayCaptureValue.assets))
                        {
                            BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.insert(Constants.ChemistDayCaptureValue.assets, at: index+1)
                        }
                    }
                    else
                    {
                        BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.append(Constants.ChemistDayCaptureValue.assets)
                    }
                }
            }
        }
        if (BL_DCRCalendar.sharedInstance.selectedStatus == DCRStatus.unApproved.rawValue || BL_DCRCalendar.sharedInstance.selectedStatus == DCRStatus.drafted.rawValue)
        {
            if(DCRModel.sharedInstance.doctorVisitId == 0)
            {
                let stepperPrivValue = doctorStepperString.components(separatedBy: ",")
                let filterPobValue = stepperPrivValue.filter{
                    $0 == Constants.ChemistDayCaptureValue.pob
                }
                if(filterPobValue.count == 0)
                {
                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData = BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.filter
                        {
                            $0 != Constants.ChemistDayCaptureValue.pob
                    }
                }
                let filterActivityValue = stepperPrivValue.filter{
                    $0 == Constants.ChemistDayCaptureValue.activity
                }
                if(filterActivityValue.count == 0)
                {
                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData = BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.filter
                        {
                            $0 != Constants.ChemistDayCaptureValue.activity
                    }
                }
            }
            else
            {
                let pobDataList = BL_DCR_Doctor_Visit.sharedInstance.getPobDetails()
                
                if((pobDataList?.count)! > 0)
                {
                    if (!BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.contains(Constants.ChemistDayCaptureValue.pob))
                    {
                        BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.append(Constants.ChemistDayCaptureValue.pob)
                    }
                    //                    for (index, _) in BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.enumerated()
                    //                    {
                    //                        if(!BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData[index].contains(Constants.ChemistDayCaptureValue.pob))
                    //                        {
                    //                            if(index == BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.count-1)
                    //                            {
                    //                                BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.append(Constants.ChemistDayCaptureValue.pob)
                    //                            }
                    //                        }
                    //                    }
                }
                
                let activityDataList = BL_Activity_Stepper.sharedInstance.getCallActivityList()
                let mcActivityList = BL_Activity_Stepper.sharedInstance.getMCCallActivityList()
                if(activityDataList.count > 0 || mcActivityList.count > 0 )
                {
                    if (!BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.contains(Constants.ChemistDayCaptureValue.activity))
                    {
                        BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.append(Constants.ChemistDayCaptureValue.activity)
                    }
                    
                }
            }
            
            
        }
        self.insertDetailedProducts()
        BL_DCR_Doctor_Visit.sharedInstance.skipFromController = [Bool](repeating: false, count: BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.count)
        //BL_DCR_Doctor_Visit.sharedInstance.updateDCRDoctorVisitTimeBasedOnAssetAnaytics()
        self.stepperUpdate()
        stepperIndex = BL_DCR_Doctor_Visit.sharedInstance.stepperIndex
        
        saveDoctorButtonVisiblity()
        reloadTableView()
        setUpdatedContentViewHeight()
    }
    
    func stepperUpdate()
    {
        BL_DCR_Doctor_Visit.sharedInstance.dynamicArrayValue = 0
        BL_DCR_Doctor_Visit.sharedInstance.showAddButton = 0
        BL_DCR_Doctor_Visit.sharedInstance.generateDataArray()
        BL_DCR_Doctor_Visit.sharedInstance.updateStepperButtonStatus()
    }
    
    func setDoctorStepper()
    {
        doctorStepperString = Constants.ChemistDayCaptureValue.visit + "," +  BL_DCR_Doctor_Visit.sharedInstance.getDoctorCaptureValue()
        doctorStepperString = doctorStepperString.replacingOccurrences(of: " ", with: "")
        
        BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData = doctorStepperString.components(separatedBy: ",")
        for (index, element) in BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.enumerated()
        {
            //            if(element == Constants.ChemistDayCaptureValue.detailing)
            //            {
            //                if BL_DCR_Doctor_Visit.sharedInstance.showAssetCard()
            //                {
            //                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.append(Constants.ChemistDayCaptureValue.assets)
            //
            //                }
            //            }
            if(element == Constants.ChemistDayCaptureValue.RCPA)
            {
                if(BL_Stepper.sharedInstance.isChemistDayEnabled())
                {
                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.remove(at: index)
                }
                
            }
            //            if(element == Constants.ChemistDayCaptureValue.activity)
            //            {
            //                if(index == BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.count)
            //                {
            //                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.remove(at: index-1)
            //                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.insert(Constants.ChemistDayCaptureValue.callActivity, at: index-1)
            //                    BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.insert(Constants.ChemistDayCaptureValue.mcActivity, at: index)
            //                }
            //                else
            //                {
            //                BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.remove(at: index)
            //                BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.insert(Constants.ChemistDayCaptureValue.callActivity, at: index)
            //                BL_DCR_Doctor_Visit.sharedInstance.dynmicOrderData.insert(Constants.ChemistDayCaptureValue.mcActivity, at: index+1)
            //                }
            //
            //            }
            
        }
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
        
        saveBtn.setTitle("SAVE \(appDoctor.uppercased()) VISIT", for: .normal)
        
        toggleEDetailingButton()
    }
    
    private func saveDoctorButtonVisiblity()
    {
        let doctorVisitCount = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList
        if doctorVisitCount.count > 0
        {
            saveDoctorView.isHidden = false
            saveBtnHeightConst.constant = 40.0
        }
        else
        {
            saveDoctorView.isHidden = true
            saveBtnHeightConst.constant = 0
        }
    }
    
    //MARK:-- Button Action Helper Methods
    private func addNewEntry(index: Int)
    {
        //        switch index
        //        {
        //        case stepperIndex.doctorVisitIndex:
        //            navigateToAddDoctorVisit()
        //        case stepperIndex.accompanistIndex:
        //            navigateToAddDoctorAccompanist()
        //        case stepperIndex.sampleIndex:
        //            navigateToAddDoctorSample()
        //        case stepperIndex.detailedProduct:
        //            navigateToAddDoctorDetailProduct()
        //        case stepperIndex.chemistIndex:
        //            navigateToAddDoctorChemist()
        //        case stepperIndex.followUpIndex:
        //            navigateToAddFollowup()
        //        case stepperIndex.attachmentIndex:
        //            navigateToAddAttachment()
        //        default:
        //            print(1)
        //        }
        
        
        if (index == stepperIndex.doctorVisitIndex )
        {
            navigateToAddDoctorVisit()
        }
        else if (index == stepperIndex.accompanistIndex )
        {
            navigateToAddDoctorAccompanist()
        }
        else if (index == stepperIndex.sampleIndex)
        {
            navigateToAddDoctorSample()
        }
        else if(index == stepperIndex.detailedProduct)
        {
            navigateToAddDoctorDetailProduct()
        }
        else if(index == stepperIndex.chemistIndex)
        {
            navigateToAddDoctorChemist()
        }
        else if(index == stepperIndex.followUpIndex)
        {
            navigateToAddFollowup()
        }
        else if(index == stepperIndex.attachmentIndex)
        {
            navigateToAddAttachment()
        }
        else if(index == stepperIndex.pobIndex)
        {
            navigateToAddPOB()
        }
        else if (index == stepperIndex.activity)
        {
            navigateToAddActivity()
        }
        
    }
    
    private func modifyEntry(index: Int)
    {
        
        if (index == stepperIndex.doctorVisitIndex )
        {
            navigateToEditDoctorVisit()
        }
        else if (index == stepperIndex.accompanistIndex )
        {
            navigateToModifyDoctorAccompanist()
        }
        else if (index == stepperIndex.sampleIndex)
        {
            navigateToModifyDoctorSample()
        }
        else if(index == stepperIndex.detailedProduct)
        {
            navigateToModifyDoctorDetailProduct()
        }
        else if(index == stepperIndex.chemistIndex)
        {
            navigateToModifyDoctorChemist()
        }
        else if(index == stepperIndex.followUpIndex)
        {
            navigateToModifyFollowup()
        }
        else if(index == stepperIndex.attachmentIndex)
        {
            navigateToAttachmentList()
        }
        else if(index == stepperIndex.pobIndex)
        {
            navigateToModifyPOB()
        }
        else if (index == stepperIndex.activity)
        {
            navigateToAddActivity()
        }
        //        switch index
        //        {
        //        case stepperIndex.doctorVisitIndex:
        //            navigateToEditDoctorVisit()
        //        case stepperIndex.accompanistIndex:
        //            navigateToModifyDoctorAccompanist()
        //        case stepperIndex.sampleIndex:
        //            navigateToModifyDoctorSample()
        //        case stepperIndex.detailedProduct:
        //            navigateToModifyDoctorDetailProduct()
        //        case stepperIndex.chemistIndex:
        //            navigateToModifyDoctorChemist()
        //        case stepperIndex.followUpIndex:
        //            navigateToModifyFollowup()
        //        case stepperIndex.attachmentIndex:
        //            navigateToAttachmentList()
        //        default:
        //            print(1)
        //        }
    }
    //MARK:- Add new POB
    func navigateToAddPOB()
    {
        BL_POB_Stepper.sharedInstance.orderEntryId = 0
        BL_POB_Stepper.sharedInstance.dueDate = Date()
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBStepperVcID) as! POBStepperViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Modify POB
    
    func navigateToModifyPOB()
    {
        let list = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: DCRModel.sharedInstance.dcrId , visitId: DCRModel.sharedInstance.customerVisitId,customerEntityType:getCustomerEntityType())
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBSalesProductModifyVcID) as! POBSalesProductsModifyListViewController
        vc.pobSalesModifyList = list
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToAddActivity()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ActivityStepperViewControllerID) as! ActivityStepperViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getCustomerEntityType() -> String
    {
        return DCRModel.sharedInstance.customerEntityType
    }
    
    func navigateToModifyDoctorAccompanist()
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: DoctorAccompanistVcID) as! DoctorAccompanistListViewController
        
        vc.isComingFromModify = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToModifyDoctorSample()
    {
        let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sampleDCRListVcID) as! SampleDetailsViewController
        vc.currentList = BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: DCRModel.sharedInstance.dcrId , doctorVisitId: DCRModel.sharedInstance.doctorVisitId)!
        vc.isComingFromModifyPage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToModifyDoctorDetailProduct()
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.isComingFromModifyPage = true
        //        vc.customerCode = self.customerMasterModel.Customer_Code
        //        vc.regionCode = self.customerMasterModel.Region_Code
        vc.isFromDoctor = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToModifyDoctorChemist()
    {
        navigateToNextScreen(stoaryBoard: chemistsSb, viewController: ModifyChemistListVcID)
    }
    
    //MARK:- Add new attachment
    func navigateToAddAttachment()
    {
        if Bl_Attachment.sharedInstance.getAttachmentCount() < maxFileUploadCount
        {
            Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
            Attachment.sharedInstance.isFromMessage = false
            Attachment.sharedInstance.isFromChemistDay = false
            Attachment.sharedInstance.isfromLeave = false
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
        }
    }
    
    //MARK:- Modify attachment
    func navigateToModifyAttachment()
    {
        navigateToAttachmentList()
    }
    
    //MARK:- Push the Attachment VC in the stack
    func navigateToAttachmentList()
    {
        navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.AttachmentSb, viewController: Constants.ViewControllerNames.AttachmentVCID)
    }
    
    // MARK:-- Navigation Functions
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorAccompanist()
    {
        navigateToNextScreen(stoaryBoard: detailProductSb, viewController: DoctorAccompanistVcID)
    }
    
    private func navigateToAddDoctorSample()
    {
        navigateToNextScreen(stoaryBoard: sampleProductListSb, viewController: sampleProductListVcID)
    }
    
    private func navigateToAddDoctorDetailProduct()
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.isComingFromModifyPage = false
        //        vc.customerCode = self.customerMasterModel.Customer_Code
        //        vc.regionCode = self.customerMasterModel.Region_Code
        vc.isFromDoctor = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToEditDoctorAccompanist()
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DoctorAccompanistVcID) as! DoctorAccompanistListViewController
        vc.isComingFromModify = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorVisit()
    {
        
        var doctorName : String = ""
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitVcID) as! DoctorVisitViewController
        vc.specialityName = self.flexiSpecialityName
        vc.geoLocationSkipRemarks = self.geoLocationSkipRemarks
        vc.currentLocation = self.currentLocation
        
        if DCRModel.sharedInstance.customerCode == ""
        {
            doctorName = self.flexiDoctorName
        }
        vc.doctorName = doctorName
        vc.customerMasterObj = customerMasterModel
        if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
        {
            vc.time = punch_start!
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorChemist()
    {
        var localArea: String = EMPTY
        
        if customerMasterModel != nil
        {
            localArea = checkNullAndNilValueForString(stringData: customerMasterModel.Local_Area)
        }
        
        if BL_DCR_Chemist_Visit.sharedInstance.canUseAccompanistsChemist() && BL_DCR_Accompanist.sharedInstance.getDCRAccompanistListCount() > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.doctorLocalArea = localArea
            vc.navigationScreenName = UserListScreenName.DCRChemistAccompanistList.rawValue
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if (localArea == EMPTY)
            {
                let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
                vc.regionCode = getRegionCode()
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ChemistListSectionVCID) as! ChemistListSectionViewController
                vc.regionCode = getRegionCode()
                vc.doctorLocalArea = localArea
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func navigateToEditDoctorVisit()
    {
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitVcID) as! DoctorVisitViewController
        vc.isComingFromModifyPage = true
        vc.geoLocationSkipRemarks = self.geoLocationSkipRemarks
        vc.currentLocation = self.currentLocation
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddFollowup()
    {
        //        let list = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: DCRModel.sharedInstance.dcrId, visitId: 1,customerEntityType: "C")
        //        if (list?.count)! > 0
        //        {
        //            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        //            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBSalesProductModifyVcID) as! POBSalesProductsModifyListViewController
        //            vc.pobSalesModifyList = list!
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        //        else
        //        {
        //            BL_POB_Stepper.sharedInstance.orderEntryId = 0
        //            BL_POB_Stepper.sharedInstance.dueDate = Date()
        //            navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.POBSb, viewController: Constants.ViewControllerNames.POBStepperVcID)
        //        }
        navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.FollowUpSb, viewController: Constants.ViewControllerNames.AddFollowUpVcID)
        
    }
    private func navigateToModifyFollowup()
    {
        navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.FollowUpSb, viewController: Constants.ViewControllerNames.ModifyFollowUpListVcID)
    }
    
    private func skipItem(index: Int)
    {
        switch index
        {
        case stepperIndex.doctorVisitIndex:
            if DCRModel.sharedInstance.customerCode == ""
            {
                var visitTime: String = EMPTY
                var visitMode: String = AM
                
                
                if BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                {
                    if(checkInternetConnectivity())
                    {
                        let postData: NSMutableArray = []
                        
                        let userObj = getUserModelObj()
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":flexiDoctorName,"regionCode":userObj?.Region_Code ?? EMPTY,"Speciality_Name":flexiSpecialityName,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":punch_start,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":userObj?.Region_Code ?? EMPTY,"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                        
                        postData.add(dict)
                        
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        
                        WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                removeCustomActivityView()
                                let visittime = stringFromDate(date1: Date())
                                let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                               let visitmode = visittime.substring(from: lastcharacterIndex)

                                let userObj = getUserModelObj()
                                BL_DCR_Doctor_Visit.sharedInstance.savePunchInFlexiDoctorVisitDetails(doctorName: self.flexiDoctorName, specialityName: self.flexiSpecialityName, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY,Punch_Start_Time: self.punch_start, Punch_Status: self.punch_status, Punch_Offset: self.punch_timeoffset, Punch_TimeZone: self.punch_timezone, Punch_UTC_DateTime: self.punch_UTC)
                                self.skipDoctor(index:index)
                                
                                
                                
//                                let getVisitDetails = apiObj.list[0] as! NSDictionary
//                                let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
//                                var dateTimeArray = getVisitTime.components(separatedBy: " ")
//                                let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
//                                let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
//                                if(compare == .orderedSame)
//                                {
//                                    let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
//                                    let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
//                                    let userObj = getUserModelObj()
//
//                                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: self.flexiDoctorName, specialityName: self.flexiSpecialityName, visitTime:visitTime, visitMode: dateTimeArray[2], pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
//                                    self.skipDoctor(index:index)
//                                }
//                                else if(compare == .orderedDescending)
//                                {
//                                    visitTime = self.getServerTime()
//                                    visitMode = self.getVisitModeType(visitTime: visitTime)
//                                    let userObj = getUserModelObj()
//                                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: self.flexiDoctorName, specialityName: self.flexiSpecialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
//                                    self.skipDoctor(index:index)
//                                }
//                                else
//                                {
//                                    AlertView.showAlertView(title: alertTitle, message: "DVR Date is not a current date", viewController: self)
//                                }
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                            
                            
                            
                            // visitTime = getServerTime()
                            //visitMode = getVisitModeType(visitTime: visitTime)
                        })
                        
                        //    let userObj = getUserModelObj()
                        //   BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: flexiDoctorName, specialityName: flexiSpecialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil)
                        
                    }
                    else
                    {
                        AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage + " to save \(appDoctor)", viewController: self)
                    }
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
                    let userObj = getUserModelObj()
                    BL_DCR_Doctor_Visit.sharedInstance.savePunchInFlexiDoctorVisitDetails(doctorName: self.flexiDoctorName, specialityName: self.flexiSpecialityName, visitTime: stringFromDate(date1: getDateFromString(dateString: punch_start!)), visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY,Punch_Start_Time: punch_start, Punch_Status: punch_status, Punch_Offset: punch_timeoffset, Punch_TimeZone: punch_timezone, Punch_UTC_DateTime: punch_UTC)
                    self.skipDoctor(index:index)
                }
                else
                {
                    let userObj = getUserModelObj()
                    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: flexiDoctorName, specialityName: flexiSpecialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                    self.skipDoctor(index:index)
                }
            }
            else
            {
                
                let visitTimeEntry = getVisitTimeMode()
                
                var visitTime: String = EMPTY
                var visitMode: String = AM
                
                var statusId: Int = defaultBusineessStatusId
                var statusName: String = EMPTY
                
                if (objBusinessStatus != nil)
                {
                    statusId = objBusinessStatus!.Business_Status_ID!
                    statusName = objBusinessStatus!.Status_Name!
                }
                
                //DBHelper.sharedInstance.getbusinessstatus(customercode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 1, dcrDate: getCurrentDate())
                obj = DBHelper.sharedInstance.getbusinessstatus1(customercode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 1)
                if (obj != nil)
                {
                    statusId = obj!.Business_Status_Id!
                    statusName = obj!.Business_Status_Name!
                }
                
                
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
                    BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: stringFromDate(date1: getDateFromString(dateString: punch_start!)), visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: defaultBusineessStatusId, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY, Punch_Start_Time: punch_start, Punch_Status: punch_status, Punch_Offset: punch_timeoffset, Punch_TimeZone: punch_timezone, Punch_UTC_DateTime: punch_UTC)
                    
                    self.skipDoctor(index:index)
                    
                }
                else {
                    
                    if BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                    {
                        if(checkInternetConnectivity())
                        {
                            let postData: NSMutableArray = []
                            
                            // let userObj = getUserModelObj()
                            let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": DCRModel.sharedInstance.customerCode,"Doctor_Name":customerMasterModel.Customer_Name,"regionCode":customerMasterModel.Region_Code!,"Speciality_Name":customerMasterModel.Speciality_Name!,"Category_Code": customerMasterModel.Category_Code ?? EMPTY,"MDL_Number":customerMasterModel.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":punch_start,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":customerMasterModel.Region_Code,"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                            
                            postData.add(dict)
                            showCustomActivityIndicatorView(loadingText: "Loading...")
                            WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    removeCustomActivityView()
                                    
                                   let visittime = stringFromDate(date1: Date())
                                    let lastcharacterIndex = visittime.index(visittime.endIndex, offsetBy: -2)
                                   let visitmode = visittime.substring(from: lastcharacterIndex)
                                    
                                    
                                    BL_DCR_Doctor_Visit.sharedInstance.savePunchInDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY, Punch_Start_Time: self.punch_start, Punch_Status: self.punch_status, Punch_Offset: self.punch_timeoffset, Punch_TimeZone: self.punch_timezone, Punch_UTC_DateTime: self.punch_UTC)
                                    
                                    self.skipDoctor(index:index)
                                    
                                    
                                    
                                    
//                                    let getVisitDetails = apiObj.list[0] as! NSDictionary
//                                    let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
//                                    var dateTimeArray = getVisitTime.components(separatedBy: " ")
//                                    let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
//                                    let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
//                                    if(compare == .orderedSame)
//                                    {
//                                        let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
//                                        let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
//
//                                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: dateTimeArray[2], pobAmount: 0.0, remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
//                                        self.skipDoctor(index:index)
//                                    }
//                                    else if(compare == .orderedDescending)
//                                    {
//                                        visitTime = self.getServerTime()
//                                        visitMode = self.getVisitModeType(visitTime: visitTime)
//                                        var statusId: Int = defaultBusineessStatusId
//                                        var statusName: String = EMPTY
//
//                                        if (self.objBusinessStatus != nil)
//                                        {
//                                            statusId = self.objBusinessStatus!.Business_Status_ID!
//                                            statusName = self.objBusinessStatus!.Status_Name!
//                                        }
//
//                                        self.obj = DBHelper.sharedInstance.getbusinessstatus1(customercode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 1)
//                                        if (self.obj != nil)
//                                        {
//                                            statusId = self.obj!.Business_Status_Id!
//                                            statusName = self.obj!.Business_Status_Name!
//                                        }
//                                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
//                                        self.skipDoctor(index:index)
//                                    }
//                                    else
//                                    {
//                                        removeCustomActivityView()
//                                        AlertView.showAlertView(title: alertTitle, message: "DVR Date is not a current date", viewController: self)
//                                    }
                                }
                                else
                                {
                                    removeCustomActivityView()
                                    AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                                }
                                
                                
                                
                                //visitTime = getServerTime()
                                // visitMode = getVisitModeType(visitTime: visitTime)
                            })
                            
                            //                var statusId: Int = defaultBusineessStatusId
                            //                var statusName: String = EMPTY
                            //
                            //                if (objBusinessStatus != nil)
                            //                {
                            //                    statusId = objBusinessStatus!.Business_Status_ID!
                            //                    statusName = objBusinessStatus!.Status_Name!
                            //                }
                            
                            //                    BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil)
                        }
                        else
                        {
                            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage + " to save \(appDoctor)", viewController: self)
                        }
                    }
                    else if(isEdetailedDoctor() && BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
                    {
                        let getVisitDetails = self.getVisitMode(visitTimeEntry: visitTimeEntry)
                        visitMode = getVisitDetails.visitMode
                        visitTime = getVisitDetails.visitTime
                        
                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                        self.skipDoctor(index:index)
                    }
                    else if(!isEdetailedDoctor() && BL_DCR_Doctor_Visit.sharedInstance.isAppGeoLocationEnabled())
                    {
                        // let getVisitDetails = self.getVisitMode(visitTimeEntry: visitTimeEntry)
                        // visitMode = getVisitDetails.visitMode
                        // visitTime = getVisitDetails.visitTime
                        
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
                        
                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visittime, visitMode: visitmode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                        self.skipDoctor(index:index)
                    }
                    else if(isEdetailedDoctor())
                    {
                        let getVisitDetails = self.getVisitMode(visitTimeEntry: visitTimeEntry)
                        visitMode = getVisitDetails.visitMode
                        visitTime = getVisitDetails.visitTime
                        
                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                        self.skipDoctor(index:index)
                    }
                    else
                    {
                        
                        BL_DCR_Doctor_Visit.sharedInstance.saveDoctorVisitDetails(customerCode: DCRModel.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self, geoFencingSkipRemarks: self.geoLocationSkipRemarks, latitude: self.currentLocation.Latitude, longitude: self.currentLocation.Longitude, businessStatusId: statusId, businessStatusName: statusName, objCallObjective: nil, campaignName: EMPTY, campaignCode: EMPTY)
                        self.skipDoctor(index:index)
                    }
                    
                }
            }
            
            //            if(isSkipped)
            //            {
            //                saveDoctorView.isHidden = false
            //
            //                if(index+1 != stepperIndex.accompanistIndex)
            //                {
            //                    BL_DCR_Doctor_Visit.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+1)
            //                }
            //                else
            //                {
            //                    BL_DCR_Doctor_Visit.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+2)
            //                }
            //
            //                //BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[1].showEmptyStateAddButton = true
            //                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.sampleIndex].showEmptyStateAddButton = true
            //                BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
            //
            //                //BL_DCR_Doctor_Visit.sharedInstance.generateDataArray()
            //                self.stepperUpdate()
            //
            //                reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex)
            //                reloadTableViewAtIndexPath(index: stepperIndex.accompanistIndex)
            //                if(index+1 != stepperIndex.accompanistIndex)
            //                {
            //                    reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+1)
            //                }
            //                else
            //                {
            //                    reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+2)
            //                }
            
        default:
            print(1)
            if(BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count-1 > index)
            {
                
                BL_DCR_Doctor_Visit.sharedInstance.skipFromController[index] = true
            }
            self.stepperUpdate()
            reloadTableViewAtIndexPath(index: index)
            reloadTableViewAtIndexPath(index: index+1)
            if(BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[index+1].recordCount > 0)
            {
                if(BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count-1 > index+2)
                {
                    BL_DCR_Doctor_Visit.sharedInstance.skipFromController[index+2] = true
                    self.stepperUpdate()
                    reloadTableViewAtIndexPath(index: index+1)
                    reloadTableViewAtIndexPath(index: index+2)
                }
            }
            
            
            if(index == BL_DCR_Doctor_Visit.sharedInstance.stepperIndex.accompanistIndex-1)
            {
                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[index+2].showEmptyStateAddButton = true
                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[index+2].showEmptyStateSkipButton = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[index+2].showEmptyStateSkipButton
                self.reloadTableViewAtIndexPath(index: index+2)
            }
            //        case stepperIndex.accompanistIndex:
            //            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.sampleIndex].showEmptyStateAddButton = true
            //            reloadTableViewAtIndexPath(index: stepperIndex.sampleIndex)
            //        case stepperIndex.sampleIndex:
            //            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.detailedProduct].showEmptyStateAddButton = true
            //            reloadTableViewAtIndexPath(index: stepperIndex.detailedProduct)
            //        case stepperIndex.detailedProduct:
            ////            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[4].showEmptyStateAddButton = true
            ////            reloadTableViewAtIndexPath(index: 4)
            //            if (!BL_Stepper.sharedInstance.isChemistDayEnabled())
            //            {
            //                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.chemistIndex].showEmptyStateAddButton = true
            //                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.chemistIndex].showEmptyStateSkipButton = true
            //                reloadTableViewAtIndexPath(index: stepperIndex.chemistIndex)
            //            }
            //            else
            //            {
            //                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.followUpIndex].showEmptyStateAddButton = true
            //                BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.followUpIndex].showEmptyStateSkipButton = true
            //                reloadTableViewAtIndexPath(index: stepperIndex.followUpIndex)
            //            }
            //        case stepperIndex.chemistIndex:
            //            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.followUpIndex].showEmptyStateAddButton = true
            //            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.followUpIndex].showEmptyStateSkipButton = true
            //            reloadTableViewAtIndexPath(index: stepperIndex.followUpIndex)
            //        case stepperIndex.followUpIndex:
            //            BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[stepperIndex.attachmentIndex].showEmptyStateAddButton = true
            //            reloadTableViewAtIndexPath(index: stepperIndex.attachmentIndex)
            //        default:
            //            print(1)
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
    func skipDoctor(index:Int)
    {
        saveDoctorView.isHidden = false
        
        if(index+1 != stepperIndex.accompanistIndex)
        {
            BL_DCR_Doctor_Visit.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+1)
        }
        else
        {
            BL_DCR_Doctor_Visit.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+2)
        }
        
        //BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[1].showEmptyStateAddButton = true
        BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[1].showEmptyStateAddButton = true
        
        
        //BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists())
        BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList: BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanistVandNA())
        
        //BL_DCR_Doctor_Visit.sharedInstance.generateDataArray()
        self.stepperUpdate()
        
        reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex)
        reloadTableViewAtIndexPath(index: stepperIndex.accompanistIndex)
        if(index+1 != stepperIndex.accompanistIndex)
        {
            reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+1)
        }
        else
        {
            reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+2)
        }
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
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
    }
    
    func getVisitModeType(visitTime : String) -> String
    {
        let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
        return visitTime.substring(from: lastcharacterIndex)
    }
    
    func isEdetailedDoctor() -> Bool
    {
        
        if(DCRModel.sharedInstance.customerCode != nil && self.customerMasterModel.Region_Code != nil)
        {
            let value = BL_DCR_Doctor_Visit.sharedInstance.isEdetailedDoctor(customerCode: DCRModel.sharedInstance.customerCode, regionCode: self.customerMasterModel.Region_Code, date: DCRModel.sharedInstance.dcrDateString)
            
            return value
        }
        else
        {
            return false
        }
    }
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        if(BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count > index)
        {
            let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
            
            tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count
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
        if (indexPath.row == BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[rowIndex]
        
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
            
            if rowIndex == stepperIndex.accompanistIndex
            {
                cell.emptyStateAddButton.isHidden = true
                cell.emptyStateSkipButton.isHidden = true
                if objStepperModel.showEmptyStateAddButton == true
                {
                    cell.emptyStateView.isHidden = true
                    cell.cardView.isHidden = false
                    cell.cardView.clipsToBounds = false
                    
                    cell.accompEmptyStateView.isHidden = false
                    cell.accompEmptyLbl.text = "No Ride Along Available"
                    
                    if cell.parentTableView != nil
                    {
                        cell.parentTableView = tableView
                        cell.parentTableView.isHidden = false
                        cell.childTableView.reloadData()
                    }
                }
                else
                {
                    cell.parentTableView = tableView
                    cell.childTableView.reloadData()
                    cell.emptyStateView.isHidden = false
                    cell.cardView.isHidden = true
                    cell.cardView.clipsToBounds = true
                }
            }
            else
            {
                if(indexPath.row == BL_DCR_Doctor_Visit.sharedInstance.stepperDataList.count - 1)
                {
                    cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
                    cell.emptyStateSkipButton.isHidden = true
                }
                else
                {
                    cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
                    cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
                }
                
                cell.parentTableView = tableView
                cell.childTableView.reloadData()
                cell.emptyStateView.isHidden = false
                cell.cardView.isHidden = true
                cell.cardView.clipsToBounds = true
            }
            
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
        
        if rowIndex == stepperIndex.doctorVisitIndex && objStepperModel.recordCount > 0
        {
            cell.sectionToggleImageView.isHidden = false
        }
        else
        {
            cell.sectionToggleImageView.isHidden = true
        }
        cell.sectionToggleImageView.clipsToBounds = true
        
        var checkRecordCount = 0
        
        if rowIndex == stepperIndex.doctorVisitIndex
        {
            checkRecordCount = 0
        }
        else
        {
            checkRecordCount = 1
        }
        
        if (objStepperModel.recordCount > checkRecordCount)
        {
            if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
            {
                cell.sectionToggleImageView.isHidden = true
            }
            else
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
        }
        
        cell.moreView.isHidden = true
        cell.moreView.clipsToBounds = true
        cell.moreViewHeightConstraint.constant = 0
        cell.buttonViewHeight.constant = 60
        
        if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
        {
            cell.moreView.isHidden = true
            cell.moreViewHeightConstraint.constant = 0
            cell.sectionCoverButton.isHidden = true
            cell.coverBtnWidthConst.constant = 0.0
            if rowIndex == stepperIndex.accompanistIndex
            {
                cell.buttonViewHeight.constant = 0
                cell.leftButton.isHidden = true
                cell.rightButton.isHidden = true
            }
            else if rowIndex == stepperIndex.detailedProduct
            {
                
                
                cell.buttonViewHeight.constant = 40
                cell.leftButton.isHidden = false
                cell.rightButton.isHidden = false
            }
        }
        else
        {
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
        }
        
        if (stepperIndex.assetIndex != 0 && rowIndex == stepperIndex.assetIndex)
        {
            if (objStepperModel.isExpanded == false && objStepperModel.recordCount > checkRecordCount)
            {
                cell.buttonViewHeight.constant = 20
                cell.moreViewHeightConstraint.constant = 20
            }
            else
            {
                cell.buttonViewHeight.constant = 0
                cell.moreViewHeightConstraint.constant = 0
            }
            
            cell.btmSepView.isHidden = true
            cell.leftButton.isHidden = true
            cell.rightButton.isHidden = true
        }
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        cell.emptyStateSkipButton.tag = rowIndex
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_DCR_Doctor_Visit.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if index == stepperIndex.doctorVisitIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitDetailHeight(selectedIndex: index)
            }
            else if index == stepperIndex.accompanistIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getAccompanistCellHeight(selectedIndex: index)
            }
            else if (stepperIndex.assetIndex != 0 && index == stepperIndex.assetIndex)
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getAssetCellHeight(selectedIndex: index)
            }
            else if index == stepperIndex.detailedProduct || index == stepperIndex.attachmentIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getCommonCellHeight(selectedIndex: index)
            }
            else if index == stepperIndex.followUpIndex || index == stepperIndex.pobIndex || index == stepperIndex.activity
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
            else if(index == stepperIndex.sampleIndex )
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getSampleBatchHeight(selectedIndex: index)
            }
            else if (stepperIndex.chemistIndex != 0 && index == stepperIndex.chemistIndex)
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
            else
            {
                return 0
            }
        }
    }
    
    @IBAction func coverBtnAction(_ sender: AnyObject)
    {
        let index = sender.tag
        
        if index != stepperIndex.attachmentIndex || index != stepperIndex.detailedProduct
        {
            let stepperObj = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[index!]
            
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
        
        setUpdatedContentViewHeight()
    }
    
    func setUpdatedContentViewHeight()
    {
        //        var variableHeight : CGFloat!
        //        let defaultContentHeight = self.view.frame.size.height - 64.0 - 90.0 - 20.0
        //        variableHeight = defaultContentHeight
        //        if tableView.contentSize.height > defaultContentHeight
        //        {
        //            variableHeight = variableHeight + (tableView.contentSize.height - defaultContentHeight)
        //        }
        //
        //        if saveDoctorView.isHidden != true
        //        {
        //            variableHeight = variableHeight + 40.0
        //        }
        //        contentViewHeightConst.constant = variableHeight
    }
    
    func getVisitTimeMode() -> String
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode()
    }
    
    @IBAction func leftButtonAction(_ sender: AnyObject)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func rightButtonAction(_ sender: AnyObject)
    {
        modifyEntry(index: sender.tag)
    }
    
    @IBAction func emptyStateAddAction(_ sender: AnyObject)
    {
        addNewEntry(index: sender.tag)
    }
    
    @IBAction func emptyStateSkipAction(_ sender: AnyObject)
    {
        skipItem(index: sender.tag)
        setUpdatedContentViewHeight()
        saveDoctorButtonVisiblity()
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl)
    {
        BL_DCR_Doctor_Visit.sharedInstance.updateAccompanistCall(index: sender.tag, selectedIndex: sender.selectedSegmentIndex)
        self.stepperUpdate()
        tableView.reloadData()
    }
    
    @IBAction func saveDoctorAction(_ sender: AnyObject)
    {
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
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eDetailingAction()
    {
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
    
    func popViewControllers()
    {
        if let navigationController = self.navigationController
        {
            navigationController.popToRootViewController(animated: false)
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    private func insertDetailedProducts()
    {
        if (checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerCode) != EMPTY && checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerRegionCode) != EMPTY)
        {
            let objDoctorVisit = DBHelper.sharedInstance.getDoctorVisitDetailsByDoctorCode(dcrId: DCRModel.sharedInstance.dcrId, customerCode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode)
            
            if (objDoctorVisit != nil)
            {
                if (objDoctorVisit!.DCR_Doctor_Visit_Id > 0)
                {
                    BL_DCRCalendar.sharedInstance.insertEDetailedProducts(customerCode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode, doctorVisitId: objDoctorVisit!.DCR_Doctor_Visit_Id, dcrId: DCRModel.sharedInstance.dcrId)
                }
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
    
    private func deleteShowList()
    {
        //DBHelper.sharedInstance.clearTempList()
        BL_AssetModel.sharedInstance.assignAllPlayListToShowList(customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
    }
    @objc func navigateToCompetiorProduct(_ sender: UIButton)
    {
        let rowIndex = sender.tag
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CompetitorProductDetailViewControllerID ) as! CompetitorProductDetailViewController
        vc.selectedProductObj = BL_DCR_Doctor_Visit.sharedInstance.detailProductList[rowIndex]
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
}
