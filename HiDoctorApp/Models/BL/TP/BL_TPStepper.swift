//
//  BL_TPStepper.swift
//  HiDoctorApp
//
//  Created by Admin on 7/24/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TPStepper: NSObject
{
    //MARK:- Global Variables
    static let sharedInstance = BL_TPStepper()
    
    //MARK:- Private Variables
    var stepperDataList: [DCRStepperModel] = []
    var accompanistList: [UserMasterWrapperModel] = []
    var meetingPlaceList : [StepperMeetingPlaceModel] = []
    var workPlaceList: [StepperWorkPlaceModel] = []
    var placesList: [TourPlannerSFC] = []
    var doctorList: [StepperDoctorModel] = []
    var sfcList: [DCRTravelledPlacesModel] = []
    var allAccompanistList: [AccompanistModel] = []
    var accompanistDataPendingList: [DCRAccompanistModel] = []
    var dcrHeaderObj: DCRHeaderModel?
    var objTPHeader: TourPlannerHeader?
    var isDataInsertedFromTP: Bool = false
    var isSFCUpdated: Bool = false
    var generalRemarks = ""
    var selectedDoctorIndex = 0
    
    //MARK:- Public Functions
    
    func generateDataArray()
    {
        clearAllArray()
        getDoctorsCount()
        getDoctorDetails()
        getAccompanistData()
//        if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
//            getPlaceDetails()
//        }
        
        getWorkPlaceDetails()
        getGeneralRemarks()
       // determineButtonStatus()
    }
    
    func generateProspectDataArray()
        {
            clearAllArray()
          //  getDoctorsCount()
           // getDoctorDetails()
            getAccompanistData()
    //        if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
    //            getPlaceDetails()
    //        }
            
            getWorkPlaceDetails()
            getGeneralRemarks()
           // determineButtonStatus()
        }
    

    //MARK:-- Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpaceToContainer: CGFloat = 2
        let titleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateTitle, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let verticalSpaceBetweenTitleAndSubTitle: CGFloat = 4
        let subTitleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateSubTitle, fontName: fontRegular, fontSize: 12, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let verticalSpaceBetweenButtonAndSubTitle: CGFloat = 12
        var buttonHeight: CGFloat = 0
        
        if (stepperObj.showEmptyStateAddButton == true || stepperObj.showEmptyStateSkipButton == true)
        {
            buttonHeight = 29
        }
        
        let bottomSpace: CGFloat = 20
        
        return topSpaceToContainer + titleLabelHeight + verticalSpaceBetweenTitleAndSubTitle + subTitleLabelHeight + verticalSpaceBetweenButtonAndSubTitle + buttonHeight + bottomSpace
    }
    
    func getCommonSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = 16
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 4
        var line2Height: CGFloat = 16
        
        if (selectedIndex == 0)
        {
            line2Height = 0
        }
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if (stepperObj.isExpanded == true)
        {
            numberOfRows = stepperObj.recordCount
        }
        else
        {
            numberOfRows = 1
        }
        
        for _ in 1...numberOfRows
        {
            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true )
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getAccompanistCellHeight(selectedIndex: Int) -> CGFloat
    {
        let totalHeight: CGFloat = getCommonCellHeight(selectedIndex: selectedIndex)
        
        //totalHeight += getCopyTPHeight()
        if((PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).count > 0))
        {
            return totalHeight + getCopyTPHeight()
        }
        else
        {
            return totalHeight
        }
    }
    
    private func getCopyTPHeight() -> CGFloat
    {
        let messageText = "More than one \(PEV_ACCOMPANIST) has planned joint visit on this day. Do you want to copy his \(PEV_TOUR_PLAN)?"
        let getheight = getTextSize(text: messageText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-120).height
        let calculateHeihgt = 50 - getheight
        
        return 156 - calculateHeihgt
    }
    
    func getDoctorSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 4
        let imageHeight: CGFloat = 24
        let label1TopSpace: CGFloat = 10
        let line1Height: CGFloat = 16
        let label2TopSpace: CGFloat = 4
        let line2Height: CGFloat = 16
        let dividerViewTopSpace: CGFloat = 8
        let dividerViewHeight: CGFloat = 1
        let line3Height : CGFloat = 16
        let line3TopSpace : CGFloat = 15
        let childTableViewTopSpace :CGFloat = 8
        let childTableViewBottomSpace:CGFloat = 8
        let removeBtnTopSpace : CGFloat = 8
        let removeBtnHeight : CGFloat = 28
        let addSampleBtnTopSpace : CGFloat = 8
        let addSampleBtnHeight : CGFloat = 28
        var childTableViewHeight : CGFloat = 0
        
        for _ in doctorList[selectedIndex].sampleList1
        {
            childTableViewHeight += 20
        }
        
        var totalSpace : CGFloat = 0
        
        let topViewSpace = topSpace + imageHeight + label1TopSpace + line1Height + label2TopSpace + line2Height + dividerViewTopSpace + dividerViewHeight + line3Height + line3TopSpace
        totalSpace += topViewSpace
        
        if doctorList[selectedIndex].isExpanded
        {
            let tableviewSpace = childTableViewTopSpace + childTableViewBottomSpace  + childTableViewHeight
            let btnSpace =  removeBtnTopSpace + removeBtnHeight + addSampleBtnTopSpace + addSampleBtnHeight
            
            totalSpace += tableviewSpace + btnSpace
        }
        
        return totalSpace
    }
    
    func getDoctorCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 41
        let buttonViewHeight: CGFloat = 50
        let bottomSpaceView: CGFloat = 0
        //let cellY: CGFloat = 28
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if (stepperObj.isExpanded == true)
        {
            numberOfRows = stepperObj.recordCount
        }
        
        for index in 0...numberOfRows -  1
        {
            childTableHeight += getDoctorSingleCellHeight(selectedIndex: index)
        }
        
        var totalHeight = titleSectionHeight + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getSFCSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        return 72
    }
    
    func getSFCCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if (stepperObj.isExpanded == true)
        {
            numberOfRows = stepperObj.recordCount
        }
        else
        {
            numberOfRows = 1
        }
        
        for _ in 1...numberOfRows
        {
            childTableHeight += getSFCSingleCellHeight(selectedIndex: selectedIndex)
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getGeneralRemarksSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = getTextSize(text: generalRemarks, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - 101)).height
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 0
        let line2Height: CGFloat = 0
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getGeneralRemarksCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPStepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        let childTableHeight: CGFloat = getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    //MARK:-- Accompanist Data Download Functions
    func getAccompanistDataPendingList()
    {
        accompanistDataPendingList = []
        
        for tpAccompanistObj in self.accompanistList
        {
            let downloadStatus = BL_DCR_Accompanist.sharedInstance.isAccompanistDataAvailable(userCode: tpAccompanistObj.userObj.User_Code!, regionCode: tpAccompanistObj.userObj.Region_Code!)
            
            if (downloadStatus != 1)
            {
                let dict: NSDictionary = ["DCR_Id": 0, "Acc_Region_Code": tpAccompanistObj.userObj.Region_Code, "Acc_User_Code": tpAccompanistObj.userObj.User_Code, "Acc_User_Name": tpAccompanistObj.userObj.User_Name, "Acc_User_Type_Name": tpAccompanistObj.userObj.User_Type_Name, "Is_Customer_Data_Inherited": Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Yet_To_Download]
                let dcrAccompObj: DCRAccompanistModel = DCRAccompanistModel(dict: dict)
                
                dcrAccompObj.Employee_Name = tpAccompanistObj.userObj.Employee_name
                dcrAccompObj.Region_Name = tpAccompanistObj.userObj.Region_Name
                dcrAccompObj.isAccompanistDataDownloadLater = false
                
                accompanistDataPendingList.append(dcrAccompObj)
            }
        }
    }
    
    func accompanistDataDownloadPendingUsersList() -> [DCRAccompanistModel]
    {
        let filteredArray = accompanistDataPendingList.filter{
            $0.isAccompanistDataDownloadLater == false
        }
        
        return filteredArray
    }
    
    func updateAccompanistDataDownloadAsLater(selectedAccompanistList: [DCRAccompanistModel])
    {
        for objTPAccompanist in selectedAccompanistList
        {
            let filteredArray = accompanistDataPendingList.filter{
                $0.Acc_User_Code == objTPAccompanist.Acc_User_Code && $0.Acc_Region_Code == objTPAccompanist.Acc_Region_Code
            }
            
            if (filteredArray.count > 0)
            {
                filteredArray[0].isAccompanistDataDownloadLater = true
            }
        }
    }
    
    private func convertAccModelToUserModel(accompanistList: [DCRAccompanistModel]) -> [UserMasterModel]
    {
        var userList: [UserMasterModel] = []
        
        for objDCRAccompanist in accompanistList
        {
            let userObj: UserMasterModel = UserMasterModel()
            
            userObj.User_Code = objDCRAccompanist.Acc_User_Code
            userObj.Region_Code = objDCRAccompanist.Acc_Region_Code
            
            userList.append(userObj)
        }
        
        return userList
    }
    
    func downloadAccompanistData(selectedAccompanistList: [DCRAccompanistModel], completion: @escaping (Int) -> ())
    {
        let userList = convertAccModelToUserModel(accompanistList: selectedAccompanistList)
        
        BL_PrepareMyDeviceAccompanist.sharedInstance.beginAccompanistDataDownload(selectedAccompanists: userList)
        
        BL_PrepareMyDeviceAccompanist.sharedInstance.getCustomerData(isCalledFromMasterDataDownload: false) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.getSFCData(isCalledFromMasterDataDownload: false, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerHeader(isCalledFromMasterDataDownload: false, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerSFC(isCalledFromMasterDataDownload: false, completion: { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerDoctor(isCalledFromMasterDataDownload: false, completion: { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
                                                self.generateDataArray()
                                                completion(status)
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func getCPDoctorsByCpCode(cpCode: String) -> [CampaignPlannerDoctors]?
    {
        return DBHelper.sharedInstance.getCPDoctorsByCPCode(cpCode: cpCode)
    }
    
    //MARK:-- Submit TP Functions
    
    func doSubmitTPValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        errorMessage = doAllAccompanistValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
//        errorMessage = doAllWorkPlaceValidations()
//        if (errorMessage != EMPTY)
//        {
//            return errorMessage
//        }
        
//        errorMessage = doAllSFCValidations()
//        if (errorMessage != EMPTY)
//        {
//            return errorMessage
//        }
        
        errorMessage = doAllCustomerValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllGeneralRemarksValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        return errorMessage
    }
    
    func submitTP()
    {
        DAL_TP_Stepper.sharedInstance.updateTourPlannerStatus(tpEntryId: TPModel.sharedInstance.tpEntryId)
    }
    
    //MARK:-- Array Functions
    func clearAllArray()
    {
        isSFCUpdated = false
        objTPHeader = nil
        stepperDataList = []
        accompanistList = []
        meetingPlaceList = []
        workPlaceList = []
        placesList = []
        doctorList = []
        generalRemarks = ""
    }
    
    private func getDoctorsCount()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Whom Am I Going To Meet"
        stepperObjModel.emptyStateTitle = "Whom Am I Going To Meet"
        stepperObjModel.emptyStateSubTitle = "Number of Contacts planned "
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "Add Contact"
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getAccompanistData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Who Am I Going With"
        stepperObjModel.emptyStateTitle = "Who Am I Going With"
        stepperObjModel.emptyStateSubTitle = "I am going alone"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "Add Ride Along"
        
        self.accompanistList = []
        self.objTPHeader = BL_TPCalendar.sharedInstance.getTPData(date: TPModel.sharedInstance.tpDateString)
        
        if (self.objTPHeader != nil)
        {
            self.accompanistList = getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        }
        
        stepperObjModel.recordCount = self.accompanistList.count
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getMeetingPointDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Plan"
        stepperObjModel.emptyStateTitle = "Plan"
        stepperObjModel.emptyStateSubTitle = ""
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        self.meetingPlaceList = []
        
        if (self.objTPHeader != nil)
        {
            var objTP: StepperMeetingPlaceModel = StepperMeetingPlaceModel()
            let meetingPlace: String = checkNullAndNilValueForString(stringData: self.objTPHeader!.Meeting_Place)
            let meetingTime: String = checkNullAndNilValueForString(stringData: self.objTPHeader!.Meeting_Time)
            
            if (meetingPlace != EMPTY && meetingTime != EMPTY)
            {
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Point"
                objTP.value = meetingPlace
                self.meetingPlaceList.append(objTP)
                
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Time"
                objTP.value = meetingTime
                self.meetingPlaceList.append(objTP)
            }
            else if (meetingPlace != EMPTY && meetingTime == EMPTY)
            {
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Point"
                objTP.value = meetingPlace
                self.meetingPlaceList.append(objTP)
                
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Time"
                objTP.value = NOT_APPLICABLE
                self.meetingPlaceList.append(objTP)
            }
            else if (meetingPlace == EMPTY && meetingTime != EMPTY)
            {
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Point"
                objTP.value = NOT_APPLICABLE
                self.meetingPlaceList.append(objTP)
                
                objTP =  StepperMeetingPlaceModel()
                objTP.key = "Meeting Time"
                objTP.value = meetingTime
                self.meetingPlaceList.append(objTP)
            }
        }
        
        stepperObjModel.recordCount = self.meetingPlaceList.count
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getWorkPlaceDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Work Category"
        stepperObjModel.emptyStateTitle = "Work Category"
        stepperObjModel.emptyStateSubTitle = ""
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        self.workPlaceList = []
        
        if (self.objTPHeader != nil)
        {
            if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Category_Name) != EMPTY)
            {
                var objTP: StepperWorkPlaceModel = StepperWorkPlaceModel()
                
                if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAMPAIGN_PLANNER) != PrivilegeValues.NO.rawValue)
                {
                   // objTP.key = "Campaign Planner"
                    
                  // objTP.key = "Beat/Patch"
                    objTP.key = "Saved Routing"
                    
                    if (checkNullAndNilValueForString(stringData: self.objTPHeader!.CP_Name) != EMPTY)
                    {
                        objTP.value = objTPHeader!.CP_Name!
                    }
                    else
                    {
                        objTP.value = NOT_APPLICABLE
                    }
                    
                    self.workPlaceList.append(objTP)
                }
                
                objTP = StepperWorkPlaceModel()
                objTP.key = "Work Category"
                
                if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Category_Name) != EMPTY)
                {
                    objTP.value = objTPHeader!.Category_Name!
                }
                else
                {
                    objTP.value = NOT_APPLICABLE
                }
                
                self.workPlaceList.append(objTP)
                
                objTP = StepperWorkPlaceModel()
                objTP.key = "Work Place"
                
                if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Work_Place) != EMPTY)
                {
                    objTP.value = objTPHeader!.Work_Place!
                }
                else
                {
                    objTP.value = NOT_APPLICABLE
                }
                
                self.workPlaceList.append(objTP)
            }
        }
        
        stepperObjModel.recordCount = self.workPlaceList.count
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getPlaceDetails()
    {
//        let stepperObjModel: DCRStepperModel = DCRStepperModel()
//
//        stepperObjModel.sectionTitle = "Who Am I Going With"
//        stepperObjModel.emptyStateTitle = "Who Am I Going With"
//        stepperObjModel.emptyStateSubTitle = "I am going Alone/I will be accompained by"
//        stepperObjModel.doctorEmptyStateTitle = ""
//        stepperObjModel.doctorEmptyStatePendingCount = ""
//        stepperObjModel.sectionIconName = "icon-stepper-sfc"
//        stepperObjModel.isExpanded = false
//        stepperObjModel.leftButtonTitle = "Add Ride Along"
//
//        self.placesList = []
//
//        let sfcList = getTPSelectedTravelPlacesDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
//
//        if (sfcList != nil)
//        {
//            self.placesList = sfcList!
//        }
//
//        stepperObjModel.recordCount = self.placesList.count
//        stepperDataList.append(stepperObjModel)
    }
    
    private func getDoctorDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Plan"
        stepperObjModel.emptyStateTitle = "Plan"
        stepperObjModel.emptyStateSubTitle = ""
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        
        if (TPModel.sharedInstance.tpStatus == 3){
            
            let tpDoctorList = getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
            self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
            stepperObjModel.recordCount = self.doctorList.count
        }else if (TPModel.sharedInstance.tpStatus == 2){
            
            if (TPModel.sharedInstance.tpId == 0){
                let tpDoctorList = getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
                self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
                stepperObjModel.recordCount = self.doctorList.count
            }else{
                let tpDoctorList = getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
                self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
                stepperObjModel.recordCount = self.doctorList.count
            }
            
        }else if (TPModel.sharedInstance.tpStatus == 0){
            
//            if (TPModel.sharedInstance.tpId == 0){
                let tpDoctorList = getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
                self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
                stepperObjModel.recordCount = self.doctorList.count
//            }else{
//                let tpDoctorList = getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
//                self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
//                stepperObjModel.recordCount = self.doctorList.count
         //   }
        }
        else{
            
            let tpDoctorList = getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
            self.doctorList = convertToStepperDoctorModel(tpDoctorList: tpDoctorList)
            stepperObjModel.recordCount = self.doctorList.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func convertToStepperDoctorModel(tpDoctorList: [TourPlannerDoctor]) -> [StepperDoctorModel]
    {
        var lstStepperDoctorList: [StepperDoctorModel] = []
        let lstSamples: [TourPlannerProduct] = getSelectedSamples(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        
        for objTPDoctor in tpDoctorList
        {
            let objStepperDoctor: StepperDoctorModel = StepperDoctorModel()
            
            objStepperDoctor.tpDoctorId = objTPDoctor.TP_Doctor_Id
            objStepperDoctor.Customer_Code = objTPDoctor.Doctor_Code
            objStepperDoctor.Region_Code = objTPDoctor.Doctor_Region_Code
            objStepperDoctor.Customer_Name = objTPDoctor.Doctor_Name
            objStepperDoctor.Region_Name = objTPDoctor.Doctor_Region_Name
            objStepperDoctor.Speciality_Name = objTPDoctor.Speciality_Name
            objStepperDoctor.Category_Name = objTPDoctor.Category_Name
            objStepperDoctor.MDL_Number = objTPDoctor.MDL_Number
            objStepperDoctor.Hospital_Name = objTPDoctor.Hospital_Name
            
            objStepperDoctor.sampleList = []
            
            let filteredList = lstSamples.filter{
                $0.Doctor_Code == objStepperDoctor.Customer_Code && $0.Doctor_Region_Code == objStepperDoctor.Region_Code
            }
            
            if (filteredList.count > 0)
            {
                for objTPProduct in filteredList
                {
                    let dict: NSDictionary = ["Visit_Id": 0, "DCR_Id": 0, "Product_Id": 0, "Product_Code": objTPProduct.Product_Code, "Product_Name": objTPProduct.Product_Name, "Quantity_Provided": String(objTPProduct.Quantity_Provided)]
                    
                    let objDCRSample: DCRSampleModel = DCRSampleModel(dict: dict)
                    
                    objStepperDoctor.sampleList1.append(objDCRSample)
                }
            }
            
            lstStepperDoctorList.append(objStepperDoctor)
        }
        
        return lstStepperDoctorList
    }
    
    private func getGeneralRemarks()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "General Remarks"
        stepperObjModel.emptyStateTitle = "General Remarks"
        stepperObjModel.emptyStateSubTitle = "Update your general remarks here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-remarks"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "Add Remarks"
        
        generalRemarks = EMPTY
        
        if (checkNullAndNilValueForString(stringData: objTPHeader?.Remarks) != EMPTY)
        {
            generalRemarks = objTPHeader!.Remarks!
            stepperObjModel.recordCount = 1
        }
        else
        {
            stepperObjModel.recordCount = 0
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func determineButtonStatus()
    {
        if (objTPHeader != nil)
        {
            if (accompanistList.count == 0) // Accompanist Section
            {
                stepperDataList[0].showEmptyStateAddButton = true
                stepperDataList[0].showEmptyStateSkipButton = !isAccompanistMandatory()
            }
            else
            {
                stepperDataList[0].showRightButton = true
                
                if (self.accompanistList.count < 4)
                {
                    stepperDataList[0].showLeftButton = true
                }
            }
            
            if (self.meetingPlaceList.count > 0)
            {
                stepperDataList[1].showRightButton = true
                stepperDataList[1].showLeftButton = true
            }
            else
            {
                stepperDataList[1].showEmptyStateAddButton = true
                stepperDataList[1].showEmptyStateSkipButton = !isMeetingPlaceTimeMandatory()
            }
            
            if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
                
                if (checkNullAndNilValueForString(stringData: objTPHeader!.Category_Name) != EMPTY) // Work Place Section
                {
                    stepperDataList[2].showRightButton = true
                    stepperDataList[2].showLeftButton = true
                    
                    if (placesList.count == 0)// SFC Section
                    {
                        stepperDataList[3].showEmptyStateAddButton = true
                    }
                    else
                    {
                        stepperDataList[3].showLeftButton = BL_TP_SFC.sharedInstance.checkIntermediateEntry()
                        stepperDataList[3].showRightButton = true
                        
                        if (doctorList.count == 0)// Doctor Section
                        {
                            stepperDataList[4].showEmptyStateAddButton = true
                        }
                        else
                        {
                            stepperDataList[4].showLeftButton = true
                            
                            if (checkNullAndNilValueForString(stringData: objTPHeader!.Remarks) != EMPTY) // Remarks Section
                            {
                                stepperDataList[5].showRightButton = true
                            }
                            else
                            {
                                stepperDataList[5].showEmptyStateAddButton = true
                            }
                        }
                    }
                }
                else
                {
                    stepperDataList[2].showEmptyStateAddButton = true
                }
                
            } else {
                if (checkNullAndNilValueForString(stringData: objTPHeader!.Category_Name) != EMPTY) // Work Place Section
                {
                    stepperDataList[2].showRightButton = true
                    stepperDataList[2].showLeftButton = true
                   
                    if (doctorList.count == 0)// Doctor Section
                    {
                        stepperDataList[3].showEmptyStateAddButton = true
                    }
                    else
                    {
                        stepperDataList[3].showLeftButton = true
                        
                        if (checkNullAndNilValueForString(stringData: objTPHeader!.Remarks) != EMPTY) // Remarks Section
                        {
                            stepperDataList[4].showRightButton = true
                        }
                        else
                        {
                            stepperDataList[4].showEmptyStateAddButton = true
                        }
                    }
                }
                else
                {
                    stepperDataList[2].showEmptyStateAddButton = true
                    
                    if (doctorList.count == 0)// Doctor Section
                    {
                        stepperDataList[3].showEmptyStateAddButton = true
                    }
                    else
                    {
                        stepperDataList[3].showLeftButton = true
                        
                        if (checkNullAndNilValueForString(stringData: objTPHeader!.Remarks) != EMPTY) // Remarks Section
                        {
                            stepperDataList[4].showRightButton = true
                        }
                        else
                        {
                            stepperDataList[4].showEmptyStateAddButton = true
                        }
                    }
                }
            }
        }
        else
        {
            stepperDataList[0].showEmptyStateAddButton = true
            stepperDataList[0].showEmptyStateSkipButton = !isAccompanistMandatory()
        }
    }
    
    func setSelectedTpDataInContext(date: String, tpFlag: Int)
    {
        objTPHeader = nil
        objTPHeader = getTPDataForSelectedDate(date: date)
        
        TPModel.sharedInstance.tpDate = getStringInFormatDate(dateString: date)
        TPModel.sharedInstance.tpDateString = date
        TPModel.sharedInstance.tpFlag = tpFlag
        TPModel.sharedInstance.isHollday = 0
        TPModel.sharedInstance.isWeekend = 0
        
        if (objTPHeader != nil)
        {
            if (objTPHeader!.Activity! > 0)
            {
                TPModel.sharedInstance.tpEntryId = objTPHeader!.TP_Entry_Id
                TPModel.sharedInstance.tpStatus = objTPHeader!.Status
                
                if objTPHeader!.TP_Id != 0
                {
                    TPModel.sharedInstance.tpId = objTPHeader!.TP_Id
                }
                else
                {
                    TPModel.sharedInstance.tpId = 0
                }
                
                if  (checkNullAndNilValueForString(stringData: objTPHeader!.Category_Code) != EMPTY)
                {
                    TPModel.sharedInstance.expenseEntityName = objTPHeader!.Category_Name
                    TPModel.sharedInstance.expenseEntityCode = objTPHeader!.Category_Code
                }
                
                TPModel.sharedInstance.isHollday = objTPHeader!.Is_Holiday
                TPModel.sharedInstance.isWeekend = objTPHeader!.Is_Weekend
            }
            else if(BL_TPCalendar.sharedInstance.isCPVisitFrequencyEnabled())
            {
                if (objTPHeader!.Activity! == 0)
                {
                    TPModel.sharedInstance.tpEntryId = objTPHeader!.TP_Entry_Id
                    TPModel.sharedInstance.tpStatus = objTPHeader!.Status
                    
                    if objTPHeader!.TP_Id != 0
                    {
                        TPModel.sharedInstance.tpId = objTPHeader!.TP_Id
                    }
                    else
                    {
                        TPModel.sharedInstance.tpId = 0
                    }
                    
                    if  (checkNullAndNilValueForString(stringData: objTPHeader!.Category_Code) != EMPTY)
                    {
                        TPModel.sharedInstance.expenseEntityName = objTPHeader!.Category_Name
                        TPModel.sharedInstance.expenseEntityCode = objTPHeader!.Category_Code
                    }
                    
                    TPModel.sharedInstance.isHollday = objTPHeader!.Is_Holiday
                    TPModel.sharedInstance.isWeekend = objTPHeader!.Is_Weekend
                }
            }
            else
            {
                TPModel.sharedInstance.tpEntryId = TPStatus.newTP.rawValue
                TPModel.sharedInstance.tpStatus = TPStatus.newTP.rawValue
            }
        }
        else
        {
            TPModel.sharedInstance.tpEntryId = TPStatus.newTP.rawValue
            TPModel.sharedInstance.tpStatus = TPStatus.newTP.rawValue
        }
    }
    
    //MARK:-- Validation Functions
    private func doAllAccompanistValidation() -> String
    {
        var errorMessage: String = EMPTY
        let accompanistMasterList = getAllAccompanistList()
        
        if (isAccompanistMandatory())
        {
            if (self.accompanistList.count == 0)
            {
                errorMessage = "Please choose at least one Ride Along"
                return errorMessage
            }
        }
        
        for objTPAccompanist in self.accompanistList
        {
            let filteredArray = accompanistMasterList.filter{
                $0.Region_Code == objTPAccompanist.userObj.Region_Code && $0.User_Code == objTPAccompanist.userObj.User_Code
            }
            
            if (filteredArray.count == 0)
            {
                errorMessage = objTPAccompanist.userObj.Employee_name! + " is an invalid Ride Along"
                return errorMessage
            }
        }
        
        let maximumAccompanistCount = BL_DCR_Accompanist.sharedInstance.getMaximumAccompanistCount()
        
        if (maximumAccompanistCount > 0)
        {
            if (self.accompanistList.count > maximumAccompanistCount)
            {
                errorMessage = "You can choose maximum of \(maximumAccompanistCount) Ride Along only in a PR"
                return errorMessage
            }
        }
        
        return errorMessage
    }
    
    private func doAllWorkPlaceValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        if (isMeetingPlaceTimeMandatory())
        {
            if (checkNullAndNilValueForString(stringData: objTPHeader?.Meeting_Place) == EMPTY)
            {
                errorMessage = "Please enter Account"
                return errorMessage
            }
            
            if (checkNullAndNilValueForString(stringData: objTPHeader?.Meeting_Time) == EMPTY)
            {
                errorMessage = "Please enter meeting time"
                return errorMessage
            }
        }
        
        if (TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue)
        {
            let privValue = BL_WorkPlace.sharedInstance.getPrevilegeValueForCP()
            
            if (privValue == PrivilegeValues.YES.rawValue)
            {
                if (checkNullAndNilValueForString(stringData: objTPHeader!.CP_Code) == EMPTY)
                {
                    errorMessage = "Please choose a \(appCp) in \"Work Place Details\" section"
                    return errorMessage
                }
            }
        }
        
        return errorMessage
    }
    
    private func doAllSFCValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        for objSFC in sfcList
        {
            errorMessage = BL_TP_SFC.sharedInstance.sfcValidationCheck(fromPlace: objSFC.From_Place, toPlace: objSFC.To_Place, travelMode: objSFC.Travel_Mode)
            
            if (errorMessage != EMPTY)
            {
                return errorMessage
            }
        }
        
        return errorMessage
    }
    
    private func doAllCustomerValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_ACC_MAND_DOC_MAND_VALUES).uppercased()
        
        if (checkNullAndNilValueForString(stringData: privValue) != EMPTY)
        {
            let privArray = privValue.components(separatedBy: "_")
            
            if (privArray.count > 0)
            {
                let doctorMandCount = Int(privArray.last!)
                
                if (doctorMandCount! > 0 && self.doctorList.count < doctorMandCount!)
                {
                    errorMessage = "Please choose at least \(String(doctorMandCount!)) \(appDoctorPlural)"
                    return errorMessage
                }
            }
        }
        
        for objTPDoctor in self.doctorList
        {
            if (objTPDoctor.Region_Code != getRegionCode())
            {
                let filtered = self.accompanistList.filter{
                    $0.userObj.Region_Code == objTPDoctor.Region_Code
                }
                
                if (filtered.count == 0)
                {
                    errorMessage = "\(objTPDoctor.Customer_Name!) is invalid \(appDoctor). This \(appDoctor) does not belong to your territory or any of the Ride Along territory"
                    break
                }
            }
        }
        
        return errorMessage
    }
    
    private func doAllGeneralRemarksValidations() -> String
    {
        let errorMessage: String = EMPTY
        
        return errorMessage
    }
    
    func canUseAccompanistCp(entityName:String) -> Bool
    {
        var returnValue = false
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).uppercased()
        
        if (privValue != EMPTY)
        {
            let privArray = privValue.components(separatedBy: ",")
            
            if (privArray.contains(entityName.uppercased()))
            {
                if (self.accompanistList.count > 0)
                {
                    returnValue = true
                }
            }
        }
        
        return returnValue
    }
    
    private func isAccompanistMandatory() -> Bool
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_ACC_MAND_DOC_MAND_VALUES).uppercased()
        
        if (privValue.contains(PrivilegeValues.YES.rawValue))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isMeetingPlaceTimeMandatory() -> Bool
    {
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_MEETING_PLACE_TIME_MANDATORY) == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK:- DB - Save & Update
    func insertTPheaderDetails(Date: String,tpFlag: Int)
    {
        if (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue)
        {
            insertTourPlannerHeader()
            setSelectedTpDataInContext(date: Date, tpFlag: tpFlag)
        }
        else
        {
            let tpHeaderObj = getTPDataForSelectedDate(date: Date)
            
            if (tpHeaderObj != nil)
            {
                if (tpHeaderObj!.Activity! == 0)
                {
                    deleteTPHeader(tpEntryId: tpHeaderObj!.TP_Entry_Id!)
                    insertTourPlannerHeader()
                    setSelectedTpDataInContext(date: Date, tpFlag: tpFlag)
                }
            }
        }
    }
    
    private func deleteTPHeader(tpEntryId: Int)
    {
        DBHelper.sharedInstance.deleteTPHeader(tpEntryId: tpEntryId)
    }
    
    private func insertTourPlannerHeader()
    {
        let day = getDayFromDate(date: TPModel.sharedInstance.tpDate)
        var activityCode: String = "FIELD_RCPA"
        var projectCode: String = "FIELD_RCPA"
        //var status : Int!
        
        if (TPModel.sharedInstance.tpFlag != TPFlag.fieldRcpa.rawValue)
        {
            activityCode = EMPTY
        }
        if (TPModel.sharedInstance.tpFlag == TPFlag.leave.rawValue)
        {
            projectCode = "LEAVE"
        }
        else if (TPModel.sharedInstance.tpFlag == TPFlag.attendance.rawValue)
        {
            projectCode = EMPTY
        }
        
        let dict: NSDictionary = ["TP_Id": 0, "TP_Date": TPModel.sharedInstance.tpDateString, "TP_Day": day, "Activity": String(TPModel.sharedInstance.tpFlag), "Activity_Code": activityCode, "Activity_Name": activityCode, "Project_Code": projectCode, "TP_Status": TPStatus.drafted.rawValue, "Is_Weekend": TPModel.sharedInstance.isWeekend, "Is_Holiday": TPModel.sharedInstance.isHollday]
        
        if (objTPHeader != nil)
        {
            if (objTPHeader!.TP_Entry_Id > 0 && objTPHeader!.Activity == 0 && (objTPHeader!.Is_Holiday == 1 || objTPHeader!.Is_Weekend == 1))
            {
                //deleteTP(tpEntryId: objTPHeader!.TP_Entry_Id)
                DBHelper.sharedInstance.deleteTPHeader(tpEntryId: objTPHeader!.TP_Entry_Id)
            }
        }
        
        DBHelper.sharedInstance.insertTourPlannerHeader(array: [dict])
        
        setSelectedTpDataInContext(date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag)
    }
    
    func insertTourPlannerHeaderForLeave(date: Date, leaveTypeCode: String, leaveTypeName: String, remarks: String)
    {
        let day = getDayFromDate(date: TPModel.sharedInstance.tpDate)
        
        let dict: NSDictionary = ["TP_Id": 0, "TP_Date": convertDateIntoServerStringFormat(date: date), "TP_Day": day, "Activity": String(TPFlag.leave.rawValue), "Activity_Code": leaveTypeCode, "Activity_Name": leaveTypeName, "Project_Code": "LEAVE", "TP_Status": TPStatus.applied.rawValue, "Remarks": remarks, "Upload_Msg": EMPTY, "Is_Weekend": TPModel.sharedInstance.isWeekend, "Is_Holiday": TPModel.sharedInstance.isHollday]
        
        if (objTPHeader != nil)
        {
            if (objTPHeader!.TP_Entry_Id > 0 && objTPHeader!.Activity == 0 && (objTPHeader!.Is_Holiday == 1 || objTPHeader!.Is_Weekend == 1))
            {
                //deleteTP(tpEntryId: objTPHeader!.TP_Entry_Id)
                DBHelper.sharedInstance.deleteTPHeader(tpEntryId: objTPHeader!.TP_Entry_Id)
            }
        }
        
        DBHelper.sharedInstance.insertTourPlannerHeader(array: [dict])
        setSelectedTpDataInContext(date: TPModel.sharedInstance.tpDateString, tpFlag: TPModel.sharedInstance.tpFlag)
    }
    
    func updateTourPlannerLeave(tpEntryId: Int, leave_type_code: String, leave_type: String, leave_reason: String)
    {
        DAL_TP_Stepper.sharedInstance.updateTourPlannerLeave(tpEntryId: tpEntryId, activity_code: leave_type_code, activity_Name: leave_type, leave_reason: leave_reason)
    }
    
    func insertAccompanistData(accArray: [UserMasterWrapperModel])
    {
        let accList:NSMutableArray = []
        
        for value in accArray
        {
            let model:UserMasterModel = value.userObj
            let dictionary : NSMutableDictionary = [:]
            dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
            dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
            dictionary.setValue(TPModel.sharedInstance.tpDateString, forKey: "TP_Date")
            dictionary.setValue(model.User_Code, forKey: "Acc_User_Code")
            dictionary.setValue(model.User_Name, forKey: "Acc_User_Name")
            dictionary.setValue(model.Region_Code, forKey: "Acc_Region_Code")
            dictionary.setValue(model.User_Type_Name, forKey: "Acc_User_Type_Name")
            dictionary.setValue(model.Employee_name, forKey: "Acc_Employee_Name")
            if  (model.User_Name == VACANT) || (model.User_Name == NOT_ASSIGNED)
            {
                dictionary.setValue("1",forKey: "Is_Only_For_Doctor")
            }
            else
            {
               dictionary.setValue("0",forKey: "Is_Only_For_Doctor")
            }
            dictionary.setValue(EMPTY,forKey: "Acc_User_Type_Code")
            accList.add(dictionary)
        }
        
        if (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue)
        {
            insertTourPlannerHeader()
        }
        else
        {
            BL_TPStepper.sharedInstance.deleteAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        }
        
        DAL_TP_Stepper.sharedInstance.insertSelectedAccompanistDetails(dictArray: accList)
        changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
        
        getAccompanistData()
        
        getAccompanistDataPendingList()
    }
    
    func deleteAccompanists(tp_Entry_Id: Int)
    {
        DAL_TP_Stepper.sharedInstance.deleteAccompanists(tp_Entry_Id: tp_Entry_Id)
        
        getAccompanistDataPendingList()
    }
    
    func updateMeetingPointAndTime(Date: String,tpFlag: Int,meeting_place: String, meeting_Time: String)
    {
        if (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue)
        {
            insertTourPlannerHeader()
            setSelectedTpDataInContext(date: Date,tpFlag: tpFlag)
            BL_TPStepper.sharedInstance.updateMeetingDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, meetingPlace: meeting_place, meetingTime: meeting_Time)
        }
        else
        {
            BL_TPStepper.sharedInstance.updateMeetingDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, meetingPlace: meeting_place, meetingTime: meeting_Time)
        }
    }
    
    private func updateMeetingDetails(tp_Entry_Id: Int,meetingPlace: String,meetingTime: String)
    {
        DAL_TP_Stepper.sharedInstance.updateMeetingDetails(meetingPlace: meetingPlace, meetingTime: meetingTime, tp_Entry_Id: tp_Entry_Id)
    }
    
    func deleteTPSelectedTravelPlacesDetails(tp_SFC_Id: Int)
    {
        DAL_TP_Stepper.sharedInstance.deleteSelectedSFC(tp_SFC_Id: tp_SFC_Id)
    }
    
    func insertTPSelectedTravelPlacesDetails(dictArray: NSMutableArray)
    {
        DAL_TP_Stepper.sharedInstance.insertSelectedSFC(dictArray: dictArray)
    }
    
    func deleteDoctorFromTP(tp_Doctor_Id: Int)
    {
        let filtered = self.doctorList.filter{
            $0.tpDoctorId == tp_Doctor_Id
        }
        
        if (filtered.count > 0)
        {
            deleteSelectedSamplesForDoctor(tpEntryId: TPModel.sharedInstance.tpEntryId, doctorCode: filtered.first!.Customer_Code, regionCode: filtered.first!.Region_Code)
        }
        
        DAL_TP_Stepper.sharedInstance.deleteSelectedDoctorFromTP(tp_Doctor_Id: tp_Doctor_Id)
    }
    
   // func insertTPSelectedDoctorDetails(selectedDoctorsList: [TPCustomerMasterDoctorModel])
   // func insertTPSelectedDoctorDetails(selectedDoctorsList: [CustomerSortedModel])
    func insertTPSelectedDoctorDetails(selectedDoctorsList: [CustomerMasterModel])
    {
        var lstTPDoctors: [TourPlannerDoctor] = []
        
        for objDoctor in selectedDoctorsList
        {
            let dict: NSDictionary = ["TP_Entry_Id": TPModel.sharedInstance.tpEntryId, "TP_Id": 0, "TP_Date": TPModel.sharedInstance.tpDateString, "Doctor_Code": objDoctor.Customer_Code, "Doctor_Region_Code": objDoctor.Region_Code, "Doctor_Name": objDoctor.Customer_Name, "Speciality_Name": objDoctor.Speciality_Name, "MDL_Number": objDoctor.MDL_Number, "Category_Code": checkNullAndNilValueForString(stringData: objDoctor.Category_Code), "Category_Name": checkNullAndNilValueForString(stringData: objDoctor.Category_Name), "Doctor_Region_Name": objDoctor.Region_Name, "Hospital_Name": checkNullAndNilValueForString(stringData: objDoctor.Hospital_Name)]
            
            let objTPDoctor: TourPlannerDoctor = TourPlannerDoctor(dict: dict)
            
            lstTPDoctors.append(objTPDoctor)
        }
        
        DAL_TP_Stepper.sharedInstance.insertTPDoctors(lstTPDoctors: lstTPDoctors)
        changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
    }
    
    
    func updateWorkPlaceModel(workPlaceObj: TourPlannerHeader,tp_Entry_Id: Int)
    {
        DAL_TP_Stepper.sharedInstance.updateWorkPlaceModel(workPlaceObj: workPlaceObj,tp_Entry_Id: tp_Entry_Id)
        setSelectedTpDataInContext(date: TPModel.sharedInstance.tpDateString ,tpFlag: TPModel.sharedInstance.tpFlag)
    }
    
    private func insertSFC(workPlaceObj: TourPlannerHeader, oldCPCode: String, oldCategoryCode: String)
    {
        if (oldCPCode != workPlaceObj.CP_Code)
        {
            BL_TP_SFC.sharedInstance.deleteAllTravelDetails()
        }
        else if (oldCategoryCode != workPlaceObj.Category_Code)
        {
            BL_TP_SFC.sharedInstance.deleteAllTravelDetails()
        }
        
       // if (checkNullAndNilValueForString(stringData: objTPHeader?.CP_Code) != workPlaceObj.CP_Code)
        //{
            if (checkNullAndNilValueForString(stringData: workPlaceObj.CP_Code) != EMPTY)
            {
                let cpSfcList = DBHelper.sharedInstance.getSFCDetailsforCPCode(cpCode: workPlaceObj.CP_Code!)
                
                if cpSfcList.count > 0
                {
                    BL_TP_SFC.sharedInstance.insertCPSFCDetails(cpSFC: cpSfcList)
                    changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
                }
            }
       // }
    }
    
    func updateWorkPlaceDetails(Date: String, tpFlag: Int, workPlaceObj: TourPlannerHeader)
    {
        let tpHeaderObj = getTPDataForSelectedDate(date: Date)
        var isUnapprovedDCR: Bool = false
        
        if (tpHeaderObj != nil)
        {
            if (tpHeaderObj!.TP_Id > 0 && tpHeaderObj!.Status == TPStatus.unapproved.rawValue)
            {
                isUnapprovedDCR = true
            }
        }
        
        if (!isUnapprovedDCR && (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue || TPModel.sharedInstance.tpStatus == 0))
        {
            insertTourPlannerHeader()
            setSelectedTpDataInContext(date: Date,tpFlag: tpFlag)
            updateWorkPlaceModel(workPlaceObj: workPlaceObj, tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
            BL_TP_SFC.sharedInstance.deleteAllTravelDetails()
            insertSFC(workPlaceObj: workPlaceObj, oldCPCode: EMPTY, oldCategoryCode: EMPTY)
        }
        else
        {
            let oldCategoryCode = checkNullAndNilValueForString(stringData: objTPHeader?.Category_Code)
            let oldCPCode = checkNullAndNilValueForString(stringData: objTPHeader?.CP_Code)
            
            BL_TPStepper.sharedInstance.updateWorkPlaceModel(workPlaceObj: workPlaceObj, tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
            insertSFC(workPlaceObj: workPlaceObj, oldCPCode: oldCPCode, oldCategoryCode: oldCategoryCode)
        }
    }
    
    func deleteSelectedSamplesForDoctor(tpEntryId: Int, doctorCode: String, regionCode: String)
    {
        DAL_TP_Stepper.sharedInstance.deleteSelectedSamplesForDoctor(tpEntryId: tpEntryId, doctorCode: doctorCode, regionCode: regionCode)
    }
    
    func insertSelectedSamples(doctorCode: String, regionCode: String, lstDCRSamples: [DCRSampleModel])
    {
        deleteSelectedSamplesForDoctor(tpEntryId: TPModel.sharedInstance.tpEntryId, doctorCode: doctorCode, regionCode: regionCode)
        
        var lstTPProducts: [TourPlannerProduct] = []
        
        for objDCRSample in lstDCRSamples
        {
            let dict: NSDictionary = ["TP_Entry_Id": TPModel.sharedInstance.tpEntryId, "TP_Id": 0, "Doctor_Code": doctorCode, "Doctor_Region_Code": regionCode, "Product_Code": objDCRSample.sampleObj.Product_Code, "Product_Name": objDCRSample.sampleObj.Product_Name, "Quantity_Provided": String(objDCRSample.sampleObj.Quantity_Provided)]
            let objTPProduct: TourPlannerProduct = TourPlannerProduct(dict: dict)
            
            lstTPProducts.append(objTPProduct)
        }
        DAL_TP_Stepper.sharedInstance.insertSelectedSamples(lstTPSamples: lstTPProducts)
        changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
    }
    
    func updateRemarksDetails(tp_Entry_Id: Int, remarks: String)
    {
        DAL_TP_Stepper.sharedInstance.updateGeneralRemarks(tp_Entry_Id: tp_Entry_Id, remarks: remarks)
    }
    
    func deleteTP(tpEntryId: Int)
    {
        let tpHeaderObj = getTPDataForSelectedDate(date: TPModel.sharedInstance.tpDateString)
        let day = getDayFromDate(date: TPModel.sharedInstance.tpDate)
        
        DAL_TP_Stepper.sharedInstance.deleteTP(tpEntryId: tpEntryId)
        
        if (tpHeaderObj != nil)
        {
            if (tpHeaderObj!.Is_Weekend == 1 || tpHeaderObj!.Is_Holiday == 1)
            {
                let dict: NSDictionary = ["TP_Id": 0, "TP_Date": TPModel.sharedInstance.tpDateString, "TP_Day": day, "Activity": 0, "Activity_Code": EMPTY, "Activity_Name": EMPTY, "Project_Code": EMPTY, "TP_Status": 0, "Is_Weekend": TPModel.sharedInstance.isWeekend, "Is_Holiday": TPModel.sharedInstance.isHollday]
                
                DBHelper.sharedInstance.insertTourPlannerHeader(array: [dict])
            }
        }
    }
    
    //MARK:- DB - Get
    func getTPDataForSelectedDate(date: String) -> TourPlannerHeader?
    {
        return BL_TPCalendar.sharedInstance.getTPData(date: date)
    }
    
    func changeTPStatusToDraft(tpEntryId: Int)
    {
        if (TPModel.sharedInstance.tpStatus == TPStatus.unapproved.rawValue)
        {
            DAL_TP_Stepper.sharedInstance.changeTPStatusToDraft(tpEntryId: tpEntryId)
        }
    }
    func getSelectedAccompanists(tp_Entry_Id: Int) -> [UserMasterWrapperModel]
    {
        let lstTPAcc = DAL_TP_Stepper.sharedInstance.getSelectedAccompanistsDetails(tp_Entry_Id: tp_Entry_Id)
        let lstMasterAcc = DAL_TP_Stepper.sharedInstance.getAllAccompanistList()
        var lstSelectedAcc:[UserMasterWrapperModel] = []
        
        for objTPAcc in lstTPAcc
        {
            let filtered = lstMasterAcc.filter{
                $0.Region_Code == objTPAcc.Acc_Region_Code && $0.User_Code == objTPAcc.Acc_User_Code
            }
            
            if (filtered.count > 0)
            {
                let objAcc: AccompanistModel = filtered.first!
                
                let objUserMasterWrapperModel: UserMasterWrapperModel = UserMasterWrapperModel()
                let objUserMasterModel = UserMasterModel()
                
                objUserMasterModel.Employee_name = objAcc.Employee_name
                objUserMasterModel.Region_Code = objAcc.Region_Code
                objUserMasterModel.Region_Name = objAcc.Region_Name
                objUserMasterModel.User_Code = objAcc.User_Code
                objUserMasterModel.User_Name = objAcc.User_Name
                objUserMasterModel.User_Type_Name = objAcc.User_Type_Name
                objUserMasterModel.Hospital_Name = objAcc.Hospital_Name
                
                objUserMasterWrapperModel.userObj = objUserMasterModel
                objUserMasterWrapperModel.isSelected = true
                
                lstSelectedAcc.append(objUserMasterWrapperModel)
            }
        }
        
        return lstSelectedAcc
    }
    
    func getMeetingDetails(tp_Entry_Id: Int) -> TourPlannerHeader?
    {
        return DAL_TP_Stepper.sharedInstance.getMeetingDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getRemarksDetails(tp_Entry_Id: Int) -> TourPlannerHeader?
    {
        return DAL_TP_Stepper.sharedInstance.getGeneralRemarks(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getTPSelectedTravelPlacesDetails(tp_Entry_Id: Int) -> [TourPlannerSFC]?
    {
        return DAL_TP_Stepper.sharedInstance.getTPSelectedSFCDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getLastSyncDate(apiName: String) -> ApiDownloadDetailModel
    {
        return DAL_TP_Stepper.sharedInstance.getLastSyncedDate(apiname: apiName)
    }
    
    func getTPSelectedDoctorDetails1(tpdate: Date) -> [TourPlannerDoctor]
    {
       // return DAL_TP_Stepper.sharedInstance.getSelectedDoctor(tp_Entry_Id:tp_Entry_Id)
        
        return DBHelper.sharedInstance.getTpDoctorDetailsByTpId1(tpdate : tpdate)
    }
    
    func getTPSelectedDoctorDetails(TP_Entry_Id: Int) -> [TourPlannerDoctor]
    {
        // return DAL_TP_Stepper.sharedInstance.getSelectedDoctor(tp_Entry_Id:tp_Entry_Id)
        
        return DBHelper.sharedInstance.getTpDoctorDetailsByTpId(TP_Entry_Id: TP_Entry_Id)
    }
    
    func getWorkPlaceDetails(tp_Entry_Id: Int) -> TourPlannerHeader
    {
        return DAL_TP_Stepper.sharedInstance.getWorkPlaceDetails(tp_Entry_Id: tp_Entry_Id)!
    }
    
    func getSelectedSamples(tp_Entry_Id: Int) -> [TourPlannerProduct]
    {
        return DAL_TP_Stepper.sharedInstance.getSelectedSamples(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getDayFromDate(date: Date) -> String
    {
        return convertDateInToDay(date: date)
    }
    
    private func getAllAccompanistList() -> [UserMasterModel]
    {
        var accompanistModelList: [AccompanistModel] = []
        var userMasterModelList:[UserMasterModel] = []
        
        accompanistModelList = DAL_TP_Stepper.sharedInstance.getAllAccompanistList()
        
        for accompanistModelObj in accompanistModelList
        {
            let userMasterModelObj = UserMasterModel()
            
            userMasterModelObj.Accompanist_Id = accompanistModelObj.Accompanist_Id
            userMasterModelObj.User_Code = accompanistModelObj.User_Code
            userMasterModelObj.User_Name = accompanistModelObj.User_Name
            userMasterModelObj.Employee_name = accompanistModelObj.Employee_name
            userMasterModelObj.User_Type_Name = accompanistModelObj.User_Type_Name
            userMasterModelObj.Region_Name = accompanistModelObj.Region_Name
            userMasterModelObj.Region_Code = accompanistModelObj.Region_Code
            userMasterModelObj.Division_Name = accompanistModelObj.Division_Name
            userMasterModelObj.Is_Child_User = accompanistModelObj.Is_Child_User
            userMasterModelObj.Is_Immedidate_User = accompanistModelObj.Is_Immedidate_User
            
            userMasterModelList.append(userMasterModelObj)
        }
        
        return userMasterModelList
    }
}
