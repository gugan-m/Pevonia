//
//  BL_TP_AttendanceStepper.swift
//  HiDoctorApp
//
//  Created by Admin on 8/8/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TP_AttendanceStepper: NSObject
{
    //MARK:- Global Variables
    static let sharedInstance = BL_TP_AttendanceStepper()
    
    //MARK:- Private Variables
    var stepperDataList: [DCRStepperModel] = []
    var workPlaceList: [StepperWorkPlaceModel] = []
    var placesList: [TourPlannerSFC] = []
    var objTPHeader: TourPlannerHeader?
    var isDataInsertedFromTP: Bool = false
    var isSFCUpdated: Bool = false
    var generalRemarks = ""
    var selectedDoctorIndex = 0
    
    //MARK:- Public Functions
    
    func generateDataArray()
    {
        clearAllArray()
        stepperDataList.removeAll()
        
       // getWorkPlaceDetails()
//        if isTravelEnabled() {
//           getPlaceDetails()
//        }
        getActivityDetails()
        getGeneralRemarks()
        
 //       determineButtonStatus()
    }
    
    //MARK:-- Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        
        if (selectedIndex == 2)
        {
            line2Height = 0
        }
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        let stepperObj: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        let stepperObj: DCRStepperModel = BL_TP_AttendanceStepper.sharedInstance.stepperDataList[selectedIndex]
        
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
    
    func isTravelEnabled() -> Bool {
         if PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_ATTENDANCE_CAPTURE_CONTROLS) == PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue {
            return true
         } else {
            return false
        }
    }
    
    
    //MARK:-- Submit TP Functions
    
    func doSubmitTPValidations() -> String
    {
        var errorMessage: String = EMPTY
        
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
        
        errorMessage = doActivityValidation()
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
        BL_TPStepper.sharedInstance.submitTP()
    }
    
    //MARK:-- Array Functions
    func clearAllArray()
    {
        objTPHeader = nil
        stepperDataList = []
        workPlaceList = []
        placesList = []
        generalRemarks = ""
    }
    
    private func getWorkPlaceDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Work Place Details"
        stepperObjModel.emptyStateTitle = "Work Place Details"
        stepperObjModel.emptyStateSubTitle = "Update your day work category, place and time"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        self.objTPHeader = BL_TPCalendar.sharedInstance.getTPData(date: TPModel.sharedInstance.tpDateString)
        
        if (self.objTPHeader != nil)
        {
            if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Category_Name) != EMPTY)
            {
                var objTP: StepperWorkPlaceModel = StepperWorkPlaceModel()
                
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
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Place Details"
        stepperObjModel.emptyStateTitle = "Place Details"
        stepperObjModel.emptyStateSubTitle = "Update your work travel details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-sfc"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD"
        
        self.placesList = []
        
        let sfcList = BL_TPStepper.sharedInstance.getTPSelectedTravelPlacesDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        
        if (sfcList != nil)
        {
            self.placesList = sfcList!
        }
        
        stepperObjModel.recordCount = self.placesList.count
        stepperDataList.append(stepperObjModel)
    }
    
    private func getActivityDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Activity Details"
        stepperObjModel.emptyStateTitle = "Activity Details"
        stepperObjModel.emptyStateSubTitle = "Update your work activity details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD"
        
         self.objTPHeader = BL_TPCalendar.sharedInstance.getTPData(date: TPModel.sharedInstance.tpDateString)
        
        if (checkNullAndNilValueForString(stringData: self.objTPHeader?.Activity_Name) != EMPTY)
        {
            stepperObjModel.recordCount = 1
        }
        else
        {
            stepperObjModel.recordCount = 0
        }
        
        stepperDataList.append(stepperObjModel)
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
        stepperObjModel.leftButtonTitle = ""
        
        self.objTPHeader = BL_TPCalendar.sharedInstance.getTPData(date: TPModel.sharedInstance.tpDateString)
        
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
        if (checkNullAndNilValueForString(stringData: self.objTPHeader?.Category_Name) != EMPTY)
        {
            stepperDataList[0].showRightButton = true
            
             if isTravelEnabled() {
                if (self.placesList.count > 0)
                {
                    stepperDataList[1].showLeftButton = BL_TP_SFC.sharedInstance.checkIntermediateEntry()
                    stepperDataList[1].showRightButton = true
                    
                    if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Activity_Name) != EMPTY)
                    {
                        stepperDataList[2].showRightButton = true
                        
                        if (checkNullAndNilValueForString(stringData: self.objTPHeader?.Remarks) != EMPTY)
                        {
                            stepperDataList[3].showRightButton = true
                        }
                        else
                        {
                            stepperDataList[3].showEmptyStateAddButton = true
                        }
                    }
                    else
                    {
                        stepperDataList[2].showEmptyStateAddButton = true
                    }
                }
                else
                {
                    stepperDataList[1].showEmptyStateAddButton = true
                }
             } else  {
                if (checkNullAndNilValueForString(stringData: self.objTPHeader!.Activity_Name) != EMPTY)
                {
                    stepperDataList[1].showRightButton = true
                    
                    if (checkNullAndNilValueForString(stringData: self.objTPHeader?.Remarks) != EMPTY)
                    {
                        stepperDataList[2].showRightButton = true
                    }
                    else
                    {
                        stepperDataList[2].showEmptyStateAddButton = true
                    }
                }
                else
                {
                    stepperDataList[1].showEmptyStateAddButton = true
                }
            }
        }
        else
        {
            stepperDataList[0].showEmptyStateAddButton = true
        }
    }
    
    //MARK:-- Validation Functions
    private func doAllWorkPlaceValidations() -> String
    {
        var errorMessage: String = EMPTY
        
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
        
        if (checkNullAndNilValueForString(stringData: objTPHeader?.Category_Name) == EMPTY)
        {
            errorMessage = "Please choose work category"
            return errorMessage
        }
        
        return errorMessage
    }
    
    private func doAllSFCValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        //        if (dcrTravelledPlacesList != nil)
        //        {
        //            for objSFC in dcrTravelledPlacesList!
        //            {
        //                errorMessage = BL_SFC.sharedInstance.sfcValidationCheck(fromPlace: objSFC.From_Place, toPlace: objSFC.To_Place, travelMode: objSFC.Travel_Mode)
        //
        //                if (errorMessage != EMPTY)
        //                {
        //                    return errorMessage
        //                }
        //            }
        //        }
        //
        //        errorMessage = BL_SFC.sharedInstance.saveTravelledPlaces()
        
        return errorMessage
    }
    
    private func doActivityValidation() -> String
    {
        if (checkNullAndNilValueForString(stringData: self.objTPHeader?.Activity_Name) == EMPTY)
        {
            return "Please choose an activity"
        }
        else
        {
            return EMPTY
        }
    }
    
    private func doAllGeneralRemarksValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        return errorMessage
    }
    
    //MARK:- DB - Save & Update
    func setSelectedTpDataInContext(date: String, tpFlag: Int)
    {
        objTPHeader = nil
        objTPHeader = getTPDataForSelectedDate(date: date)
        
        TPModel.sharedInstance.tpDate = getStringInFormatDate(dateString: date)
        TPModel.sharedInstance.tpDateString = date
        TPModel.sharedInstance.tpFlag = tpFlag
        
        if (objTPHeader != nil)
        {
            TPModel.sharedInstance.tpEntryId = objTPHeader!.TP_Entry_Id
            TPModel.sharedInstance.tpStatus = objTPHeader!.Status
        }
        else
        {
            TPModel.sharedInstance.tpEntryId = TPStatus.newTP.rawValue
            TPModel.sharedInstance.tpStatus = TPStatus.newTP.rawValue
        }
    }
    
    func insertTPheaderDetails(date: String, tpFlag: Int)
    {
        if (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue)
        {
            insertTourPlannerHeader()
            setSelectedTpDataInContext(date: date, tpFlag: tpFlag)
        }
    }
    
    private func insertTourPlannerHeader()
    {
        let day = getDayFromDate(date: TPModel.sharedInstance.tpDate)
        
        let dict: NSDictionary = ["TP_Id": 0, "TP_Date": TPModel.sharedInstance.tpDateString, "TP_Day": day, "Activity": String(TPModel.sharedInstance.tpFlag), "Activity_Code": EMPTY, "Activity_Name": EMPTY, "Project_Code": EMPTY, "Status": TPStatus.drafted.rawValue]
        
        DBHelper.sharedInstance.insertTourPlannerHeader(array: [dict])
    }
    
    func deleteTPSelectedTravelPlacesDetails(tp_SFC_Id: Int)
    {
        BL_TPStepper.sharedInstance.deleteTPSelectedTravelPlacesDetails(tp_SFC_Id: tp_SFC_Id)
    }
    
    func insertTPSelectedTravelPlacesDetails(dictArray: NSMutableArray)
    {
        BL_TPStepper.sharedInstance.insertTPSelectedTravelPlacesDetails(dictArray: dictArray)
    }
    
    private func updateWorkPlaceModel(workPlaceObj: TourPlannerHeader,tp_Entry_Id: Int)
    {
        BL_TPStepper.sharedInstance.updateWorkPlaceModel(workPlaceObj: workPlaceObj,tp_Entry_Id: tp_Entry_Id)
    }
    
    func updateWorkPlaceDetails(Date: String, tpFlag: Int,workPlaceObj: TourPlannerHeader)
    {
        if (TPModel.sharedInstance.tpEntryId == TPStatus.newTP.rawValue)
        {
            insertTourPlannerHeader()
            setSelectedTpDataInContext(date: Date,tpFlag: tpFlag)
            updateWorkPlaceModel(workPlaceObj: workPlaceObj, tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        }
        else
        {
            BL_TPStepper.sharedInstance.updateWorkPlaceModel(workPlaceObj: workPlaceObj, tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        }
    }
    
    func updateAttendanceActivity(objActivity: ProjectActivityMaster)
    {
        insertTourPlannerHeader()
        setSelectedTpDataInContext(date: TPModel.sharedInstance.tpDateString ,tpFlag: TPModel.sharedInstance.tpFlag)
        DAL_TP_Stepper.sharedInstance.updateAttendanceActivity(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, activityCode: objActivity.Activity_Code, activityName: objActivity.Activity_Name, projectCode: objActivity.Project_Code)
    }
    
    func updateRemarksDetails(tp_Entry_Id: Int, remarks: String)
    {
        BL_TPStepper.sharedInstance.updateRemarksDetails(tp_Entry_Id: tp_Entry_Id, remarks: remarks)
    }
    
    //MARK:- DB - Get
    func getTPDataForSelectedDate(date: String) -> TourPlannerHeader?
    {
        return BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: date)
    }
    
    func getRemarksDetails(tp_Entry_Id: Int) -> TourPlannerHeader?
    {
        return BL_TPStepper.sharedInstance.getRemarksDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getTPSelectedTravelPlacesDetails(tp_Entry_Id: Int) -> [TourPlannerSFC]?
    {
        return BL_TPStepper.sharedInstance.getTPSelectedTravelPlacesDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getLastSyncDate(apiName: String) -> ApiDownloadDetailModel
    {
        return BL_TPStepper.sharedInstance.getLastSyncDate(apiName: apiName)
    }
    
    func getWorkPlaceDetails(tp_Entry_Id: Int) -> TourPlannerHeader
    {
        return BL_TPStepper.sharedInstance.getWorkPlaceDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
    func getDayFromDate(date: Date) -> String
    {
        return convertDateInToDay(date: date)
    }
}
