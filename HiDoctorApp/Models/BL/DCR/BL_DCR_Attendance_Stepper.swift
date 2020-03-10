//
//  BL_DCR_Attendance_Stepper.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Attendance_Stepper: NSObject
{
    //MARK:- Global Variables
    static let sharedInstance = BL_DCR_Attendance_Stepper()
    
    //MARK:-Private Variables
    
    var stepperDataList: [DCRStepperModel] = []
    var workPlaceList : [StepperWorkPlaceModel] = []
    var sfcList: [DCRTravelledPlacesModel] = []
    var expenseList: [DCRExpenseModel] = []
    var activityList : [DCRAttendanceActivityModel] = []
    var doctorList: [DCRAttendanceDoctorModel] = []
    var docList : [Int] = []
    var dcrId : Int!
    var dcrStatus : Int!
    var dcrHeaderObj: DCRHeaderModel?
    var isSFCUpdated: Bool = false
    var isDataInsertedFromTP: Bool = false
    var workplaceindex = Int()
    var travelindex = Int()
    var activityindex = Int()
    var doctorindex = Int()
    var expenseindex = Int()
    var generalindex = Int()
    var selectedDoctorIndex = 0
    var expenseListCount = 0
    //MARK:- Public Functions
    
    func getCurrentArray()
    {
        self.dcrId = DCRModel.sharedInstance.dcrId
        self.dcrStatus = DCRModel.sharedInstance.dcrStatus
        
        clearAllArray()
        
        self.getWorkPlaceDetails()
        self.updateDCRStatusAsDraft()
        self.getSFCDetails()
        self.getActivityDetails()
        if(checkAttendanceSampleAvailable())
        {
        self.getDoctorDetails()
        }
        self.getExpenseDetails()
        self.getGeneralRemarks()
        getIndex()
        self.determineButtonStatus()
    }
    
    private func getWorkPlaceDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        var stepperWorkPlaceList: [StepperWorkPlaceModel] = []
        
        stepperObjModel.sectionTitle = "Work Place Details"
        stepperObjModel.emptyStateTitle = "Work Place Details"
        stepperObjModel.emptyStateSubTitle = "Update your day work category, place and time"
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        let dcrHeaderDetails: DCRHeaderModel? = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        self.dcrHeaderObj = dcrHeaderDetails
        
        if (dcrHeaderDetails != nil)
        {
            if (checkNullAndNilValueForString(stringData: dcrHeaderDetails?.Category_Name) != EMPTY)
            {
                var stepperWorkPlaceObj: StepperWorkPlaceModel!
                
                stepperObjModel.recordCount = 3
                
                stepperWorkPlaceObj = StepperWorkPlaceModel()
                stepperWorkPlaceObj.key = "Work Category"
                
                if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.Category_Name) != "")
                {
                    stepperWorkPlaceObj.value = dcrHeaderDetails!.Category_Name
                }
                else
                {
                    stepperWorkPlaceObj.value = "N/A"
                }
                stepperWorkPlaceList.append(stepperWorkPlaceObj)
                
                stepperWorkPlaceObj = StepperWorkPlaceModel()
                stepperWorkPlaceObj.key = "Work Place"
                
                if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.Place_Worked) != "")
                {
                    stepperWorkPlaceObj.value = dcrHeaderDetails!.Place_Worked
                }
                else
                {
                    stepperWorkPlaceObj.value = "N/A"
                }
                
                stepperWorkPlaceList.append(stepperWorkPlaceObj)
                
                stepperWorkPlaceObj = StepperWorkPlaceModel()
                stepperWorkPlaceObj.key = "Work Time"
                
                if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.Start_Time) != "")
                {
                    stepperWorkPlaceObj.value = dcrHeaderDetails!.Start_Time
                    
                    if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.End_Time) != "")
                    {
                        stepperWorkPlaceObj.value = stepperWorkPlaceObj.value + " - " + dcrHeaderDetails!.End_Time!
                    }
                }
                else
                {
                    stepperWorkPlaceObj.value = "N/A"
                }
                stepperWorkPlaceList.append(stepperWorkPlaceObj)
            }
            
        }
        self.workPlaceList = stepperWorkPlaceList
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getSFCDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Travel Details"
        stepperObjModel.emptyStateTitle = "Travel Details"
        stepperObjModel.emptyStateSubTitle = "Update your work travel details here"
        stepperObjModel.sectionIconName = "icon-stepper-sfc"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD TRAVEL PLACE"
        
        self.isSFCUpdated = BL_Stepper.sharedInstance.checkSFCVersionUpdate()
        
        let sfcList: [DCRTravelledPlacesModel]? = getDCRSFCDetails()
        
        if (sfcList != nil)
        {
            self.sfcList = sfcList!
            stepperObjModel.recordCount = sfcList!.count
        }
        if isTravelAllowed(){
          stepperDataList.append(stepperObjModel)
        } else {
            if sfcList?.count != 0 {
                stepperDataList.append(stepperObjModel)
            } else {
                
            }
        }
    }
    
    func isTravelAllowed()-> Bool {
        let isTravelAvilabel = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_ATTENDANCE_CAPTURE_CONTROLS).uppercased()
        if isTravelAvilabel.contains("TRAVEL_DETAILS") {
            return true
        }
        return false
    }
    
    func isExpenceAllowed()-> Bool {
        let isTravelAvilabel = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_ATTENDANCE_CAPTURE_CONTROLS).uppercased()
        print(isTravelAvilabel)
        if isTravelAvilabel.contains("EXPENSE_DETAILS"){
            return true
        }
        return false
    }

    private func getActivityDetails()
    {
        let stepperObjModel : DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Activity Details"
        stepperObjModel.emptyStateTitle = "Activity Details"
        stepperObjModel.emptyStateSubTitle = "Update your Activity details here"
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD ACTIVITY"
        
        let dcrActivityList : [DCRAttendanceActivityModel]?  = getDCRActivityDetails()
        if dcrActivityList != nil
        {
            self.activityList = dcrActivityList!
            stepperObjModel.recordCount = self.activityList.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    func getDoctorDetails(){
        
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Contact Sample Details"
        stepperObjModel.emptyStateTitle = "Contact Sample Details"
        stepperObjModel.emptyStateSubTitle = "Update the Contact samples details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD CONTACTS"
        
        
        self.doctorList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisists()
        //self.doctorList = convertToStepperAttendanceDoctorModel(attendanceDoctorList: attendanceDoctorList)
        
        stepperObjModel.recordCount = self.doctorList.count
        stepperDataList.append(stepperObjModel)
    }
    
    private func convertToStepperAttendanceDoctorModel(attendanceDoctorList: [DCRAttendanceDoctorModel]) -> [StepperAttendanceDoctorModel]
    {
        var lstStepperDoctorList: [StepperAttendanceDoctorModel] = []
        let lstSamples: [DCRAttendanceSampleDetailsModel] = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(dcrId: getDCRId())
        let lstsampleBatchs: [DCRSampleBatchModel] = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamplesBatchs(dcrId: getDCRId())
        
        for objDoctor in attendanceDoctorList
        {
            
            let objStepperDoctor: StepperAttendanceDoctorModel = StepperAttendanceDoctorModel()
            
            objStepperDoctor.doctorId = objDoctor.DCR_Doctor_Visit_Id
            objStepperDoctor.Customer_Code = objDoctor.Doctor_Code
            objStepperDoctor.Region_Code = objDoctor.Doctor_Region_Code
            objStepperDoctor.Customer_Name = objDoctor.Doctor_Name
            objStepperDoctor.Region_Name = objDoctor.Doctor_Region_Name
            objStepperDoctor.Speciality_Name = objDoctor.Speciality_Name
            objStepperDoctor.MDL_Number = objDoctor.MDL_Number
            objStepperDoctor.Hospital_Name = objDoctor.Hospital_Name
            
            objStepperDoctor.sampleList = []
            
            let filteredList = lstSamples.filter{
                $0.DCR_Doctor_Visit_Id == objStepperDoctor.doctorId
            }
            let filteredBatchList = lstsampleBatchs.filter{
                $0.Visit_Id == objStepperDoctor.doctorId
            }
            if(filteredList.count>0)
            {
                var sampleDataList : [SampleBatchProductModel] = []
                for sampleObj in filteredList
                {
                    var sampleModelList:[DCRSampleModel] = []
                    let sampleBatchObj = SampleBatchProductModel()
                    sampleBatchObj.title = sampleObj.Product_Name
                    
                    let filterValue = filteredBatchList.filter{
                        $0.Ref_Id == sampleObj.DCR_Attendance_Sample_Id
                    }
                    if(filterValue.count > 0)
                    {
                        for obj in filterValue
                        {
                            let dict: NSDictionary = ["Visit_Id": obj.Visit_Id, "DCR_Id": obj.DCR_Id ?? 0, "Product_Id": 0, "Product_Code": obj.Product_Code, "Product_Name": obj.Batch_Number, "Quantity_Provided": String(obj.Quantity_Provided!)]
                            let objDCRSample: DCRSampleModel = DCRSampleModel(dict: dict)
                            objDCRSample.sampleObj.Batch_Name = obj.Batch_Number
                            objDCRSample.sampleObj.Quantity_Provided = obj.Quantity_Provided
                            sampleModelList.append(objDCRSample)
                        }
                        sampleBatchObj.title = sampleObj.Product_Name
                        sampleBatchObj.isShowSection = true
                        sampleBatchObj.sampleList = sampleModelList
                        sampleDataList.append(sampleBatchObj)
                    }
                }
                if(filteredList.count > 0)
                {
                    let sampleBatchObj = SampleBatchProductModel()
                    var sampleModelList:[DCRSampleModel] = []
                    sampleBatchObj.title = ""
                    sampleBatchObj.isShowSection = false
                    for sampleObj in filteredList
                    {
                        
                        let filterValue = filteredBatchList.filter{
                            $0.Ref_Id == sampleObj.DCR_Attendance_Sample_Id
                        }
                        if(filterValue.count == 0)
                        {
                            let dict: NSDictionary = ["Visit_Id": sampleObj.DCR_Doctor_Visit_Id, "DCR_Id": sampleObj.DCR_Id ?? 0, "Product_Id": 0, "Product_Code": sampleObj.Product_Code, "Product_Name": sampleObj.Product_Name, "Quantity_Provided": String(sampleObj.Quantity_Provided!)]
                            let objDCRSample: DCRSampleModel = DCRSampleModel(dict: dict)
                            sampleModelList.append(objDCRSample)
                        }
                    }
                    if(sampleModelList.count > 0)
                    {
                        sampleBatchObj.sampleList = sampleModelList
                        sampleDataList.append(sampleBatchObj)
                    }
                }
                objStepperDoctor.sampleList = sampleDataList
                lstStepperDoctorList.append(objStepperDoctor)
            }
        }
        
        return lstStepperDoctorList
    }
    private func getExpenseDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Expense Details"
        stepperObjModel.emptyStateTitle = "Expense Details"
        stepperObjModel.emptyStateSubTitle = "Update your expense details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD EXPENSE"
     
        
        if (activityList.count > 0)
        {
            if isExpenceAllowed() {
              BL_Expense.sharedInstance.calculateFareForPrefillTypeExpenses()
            }
            let expenseList: [DCRExpenseModel]? = BL_Expense.sharedInstance.getDCRExpenses()
            
            if (expenseList != nil)
            {
                self.expenseList = expenseList!
                stepperObjModel.recordCount = expenseList!.count
            }
        }
       
        if isExpenceAllowed()  {
             stepperDataList.append(stepperObjModel)
        } else {
            if expenseList.count != 0 {
                stepperDataList.append(stepperObjModel)
            } else {
                
            }
        }
    }
    
    private func getGeneralRemarks()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Task I did today"
        stepperObjModel.emptyStateTitle = "Task I did today"
        stepperObjModel.emptyStateSubTitle = "Update your task here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-remarks"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        if (activityList.count > 0)
        {
            dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
            var generalRemarks = dcrHeaderObj?.DCR_General_Remarks

            if (generalRemarks != nil)
            {
                if (checkNullAndNilValueForString(stringData: generalRemarks) != "")
                {
                    generalRemarks = generalRemarks!.replacingOccurrences(of: GENERAL_REMARKS_API_SPLIT_CHAR, with: " ")
                    generalRemarks = generalRemarks!.replacingOccurrences(of: GENERAL_REMARKS_LOCAL_SPLIT_CHAR, with: " ")
                    dcrHeaderObj!.DCR_General_Remarks = generalRemarks
                    stepperObjModel.recordCount = 1
                }
            }
        }
        stepperDataList.append(stepperObjModel)
    }
    
    // MARK:-  Button status fuctions
    private func workplace_ButtonStatus(index: Int){
        if (workPlaceList.count == 0)
        {
            stepperDataList[index].showEmptyStateAddButton = true
        } else {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = false
        }
    }
    
    private func travelplace_ButtonStatus(index: Int) {
        if workPlaceList.count == 0 {
            stepperDataList[index].showEmptyStateAddButton = false
        } else if (sfcList.count == 0)
        {
            stepperDataList[index].showEmptyStateAddButton = true
        }
        else
        {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = BL_Stepper.sharedInstance.isHOPEnabledForSelectedCategory()
        }
    }
    
    private func activity_ButtonStatus(index: Int) {
        if (workPlaceList.count == 0){
            stepperDataList[index].showEmptyStateAddButton = false
        }
         else if (activityList.count == 0 )
        {
            stepperDataList[index].showEmptyStateAddButton = true
        }
        else
        {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = true
        }
    }
    //Doctor details
    private func partnerDetails_ButtonStatus(index: Int) {
        
        if(workPlaceList.count == 0 || activityList.count == 0 ) {
            stepperDataList[index].showEmptyStateAddButton = false
        } else if doctorList.count == 0 {
            stepperDataList[index].showEmptyStateAddButton = true
        }    else {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = true
        }
    }
    
    private func expense_ButtonStatus(index: Int) {
        if (workPlaceList.count == 0 || activityList.count == 0 || doctorList.count == 0 )
        {
            stepperDataList[index].showEmptyStateAddButton = false
        }
        else if (expenseList.count == 0 ){
            stepperDataList[index].showEmptyStateAddButton = true
        }
        else {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = true
        }
    }
    
    private func remark_ButtonStatus(index: Int) {
        if isExpenceAllowed() {
            if expenseList.count != 0 {
                stepperDataList[index].showEmptyStateAddButton = true
            } else {
                stepperDataList[index].showEmptyStateAddButton = false
            }
        } else if doctorList.count == 0 {
            stepperDataList[index].showEmptyStateAddButton = false
        } else if (stepperDataList[index].recordCount == 0)
        {
            stepperDataList[index].showEmptyStateAddButton = true
        }
        else
        {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = true
        }
    }

    
    func btn_noTravel_noExpense() {
        workplace_ButtonStatus(index: 0)
        activity_ButtonStatus(index: 1)
        partnerDetails_ButtonStatus(index:2)
        remark_ButtonStatus(index: 3)
    }
    
    func btn_noTravel_yesExpense() {
        workplace_ButtonStatus(index: 0)
        activity_ButtonStatus(index: 1)
        partnerDetails_ButtonStatus(index:2)
        expense_ButtonStatus(index: 3)
        remark_ButtonStatus(index: 4)
    }
    
    func btn_yesTravel_noExpense() {
        workplace_ButtonStatus(index: 0)
        travelplace_ButtonStatus(index: 1)
        activity_ButtonStatus(index: 2)
        partnerDetails_ButtonStatus(index:3)
        remark_ButtonStatus(index: 4)
    }
    
    func btn_yesTravel_yesExpense() {
        workplace_ButtonStatus(index: 0)
        travelplace_ButtonStatus(index: 1)
        activity_ButtonStatus(index: 2)
        partnerDetails_ButtonStatus(index:3)
        expense_ButtonStatus(index: 4)
        remark_ButtonStatus(index: 5)
    }

    
    
    func no_partner_btn_noTravel_noExpense() {
        workplace_ButtonStatus(index: 0)
        activity_ButtonStatus(index: 1)
       // partnerDetails_ButtonStatus(index:2)
        remark_ButtonStatus(index: 2)
    }
    
    func no_partner_btn_noTravel_yesExpense() {
        workplace_ButtonStatus(index: 0)
        activity_ButtonStatus(index: 1)
      //  partnerDetails_ButtonStatus(index:2)
        expense_ButtonStatus(index: 2)
        remark_ButtonStatus(index: 3)
    }
    
    func no_partner_btn_yesTravel_noExpense() {
        workplace_ButtonStatus(index: 0)
        travelplace_ButtonStatus(index: 1)
        activity_ButtonStatus(index: 2)
      //  partnerDetails_ButtonStatus(index:3)
        remark_ButtonStatus(index: 3)
    }
    
    func no_partner_btn_yesTravel_yesExpense() {
        workplace_ButtonStatus(index: 0)
        travelplace_ButtonStatus(index: 1)
        activity_ButtonStatus(index: 2)
       // partnerDetails_ButtonStatus(index:3)
        expense_ButtonStatus(index: 3)
        remark_ButtonStatus(index: 4)
    }
    
    
    private func determineButtonStatus()
    {
        
        if(BL_DCR_Attendance_Stepper().checkAttendanceSampleAvailable())
        {
            if isExpenceAllowed() == false && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    btn_noTravel_noExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    btn_yesTravel_yesExpense()
                }
                
            } else if isExpenceAllowed() ==  true && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    btn_noTravel_yesExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    btn_yesTravel_yesExpense()
                }
                
                
            } else if isExpenceAllowed() == false && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    btn_yesTravel_noExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    btn_yesTravel_yesExpense()
                }
                
                
            } else if isExpenceAllowed() == true && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    btn_yesTravel_yesExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    btn_yesTravel_yesExpense()
                }
            } else {
                
            }
        } else {
            if isExpenceAllowed() == false && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    no_partner_btn_noTravel_noExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    no_partner_btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    no_partner_btn_yesTravel_yesExpense()
                }
                
            } else if isExpenceAllowed() ==  true && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    no_partner_btn_noTravel_yesExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    no_partner_btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    no_partner_btn_yesTravel_yesExpense()
                }
                
                
            } else if isExpenceAllowed() == false && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_noExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    no_partner_btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    no_partner_btn_yesTravel_yesExpense()
                }
                
                
            } else if isExpenceAllowed() == true && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_yesExpense()
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    no_partner_btn_noTravel_yesExpense()
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    no_partner_btn_yesTravel_noExpense()
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    no_partner_btn_yesTravel_yesExpense()
                }
            } else {
                
            }
        }
        
        
        
        
        
        
        
        
        
        
//        if (workPlaceList.count == 0)
//        {
//            stepperDataList[0].showEmptyStateAddButton = true
//        }
//        else
//        {
//            stepperDataList[0].showRightButton = true
//            stepperDataList[0].showLeftButton = false
//
//            if (sfcList.count == 0)
//            {
//                stepperDataList[1].showEmptyStateAddButton = true
//            }
//            else
//            {
//                stepperDataList[1].showRightButton = true
//                stepperDataList[1].showLeftButton = BL_Stepper.sharedInstance.isHOPEnabledForSelectedCategory()
//
//                if (activityList.count == 0)
//                {
//                    stepperDataList[2].showEmptyStateAddButton = true
//                }
//                else
//                {
//
//                    let priviledge = getAttendanceCaptureValue()
//                    let privilegeArray = priviledge.components(separatedBy: ",")
//                    let expenseList: [DCRExpenseModel]? = BL_Expense.sharedInstance.getDCRExpenses()
//
//                    stepperDataList[2].showRightButton = true
//                    stepperDataList[2].showLeftButton = true
//                    if(!checkAttendanceSampleAvailable())
//                    {
//
////                        if (expenseList.count == 0)
////                        {
////                            stepperDataList[3].showEmptyStateAddButton = true
////                        }
////
////                        else
////                        {
////                            stepperDataList[3].showRightButton = true
////                            stepperDataList[3].showLeftButton = true
////                        }
////
////                        if (stepperDataList[4].recordCount == 0)
////                        {
////                            stepperDataList[4].showEmptyStateAddButton = true
////                        }
////                        else
////                        {
////                            stepperDataList[4].showRightButton = true
////                            stepperDataList[4].showLeftButton = false
////                        }
//
//                        if privilegeArray.contains(Constants.ChemistDayCaptureValue.attendance_expenses) || expenseList!.count > 0
//                        {
//                            self.expenxeRemarksState(index: 3)
//                        }
//                        else
//                        {
//                            self.expenxeRemarksState(index: 2)
//                        }
//
//
//                    }
//                    else
//                    {
//                        if(doctorList.count == 0) {
//                            stepperDataList[3].showEmptyStateAddButton = true
//                            if privilegeArray.contains(Constants.ChemistDayCaptureValue.attendance_expenses) || expenseList!.count > 0
//                            {
//                                self.expenxeRemarksState(index: 4)
//                            }
//                            else
//                            {
//                                self.expenxeRemarksState(index: 3)
//                            }
//                        }
//                        else
//                        {
//                            stepperDataList[3].showRightButton = true
//                            stepperDataList[3].showLeftButton = true
//
//                            if privilegeArray.contains(Constants.ChemistDayCaptureValue.attendance_expenses) || expenseList!.count > 0
//                            {
//                                self.expenxeRemarksState(index: 4)
//                            }
//                            else
//                            {
//                                self.expenxeRemarksState(index: 3)
//                            }
////                            if (expenseList.count == 0)
////                            {
////                                stepperDataList[4].showEmptyStateAddButton = true
////                            }
////
////                            else
////                            {
////                                stepperDataList[4].showRightButton = true
////                                stepperDataList[4].showLeftButton = true
////                            }
////
////                            if (stepperDataList[5].recordCount == 0)
////                            {
////                                stepperDataList[5].showEmptyStateAddButton = true
////                            }
////                            else
////                            {
////                                stepperDataList[5].showRightButton = true
////                                stepperDataList[5].showLeftButton = false
////                            }
//                        }
//                    }
//                }
   //         }
      //  }
    }
    
    func expenxeRemarksState(index:Int)
    {
        if (expenseList.count == 0)
        {
            stepperDataList[index].showEmptyStateAddButton = true
        }
            
        else
        {
            stepperDataList[index].showRightButton = true
            stepperDataList[index].showLeftButton = true
        }
        
        if (stepperDataList[index+1].recordCount == 0)
        {
            stepperDataList[index+1].showEmptyStateAddButton = true
        }
        else
        {
            stepperDataList[index+1].showRightButton = true
            stepperDataList[index+1].showLeftButton = false
        }
    }
    
    func setIndex(work: Int,travel: Int,activity: Int,partner: Int,expense: Int,remark: Int) {
        workplaceindex = work
        travelindex = travel
        activityindex = activity
        doctorindex = partner
        expenseindex = expense
        generalindex = remark
    }
    
    
    func getIndex()
    {
        if(BL_DCR_Attendance_Stepper().checkAttendanceSampleAvailable())
        {
            if isExpenceAllowed() == false && isTravelAllowed() == false {
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: -1, remark: 3)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: -1, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                   setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: 4, remark: 5)
                }
                
            } else if isExpenceAllowed() ==  true && isTravelAllowed() == false {
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: 3, remark: 4)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: -1, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: 4, remark: 5)
                }
            }else if isExpenceAllowed() == false && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: -1, remark: 4)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: -1, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: 4, remark: 5)
                }
            }else if isExpenceAllowed() == true && isTravelAllowed() == true{
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: 4, remark: 5)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: 2, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: -1, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: 3, expense: 4, remark: 5)
                }
            } else {
                
            }
            

            
        }
        else{
            
            if isExpenceAllowed() == false && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                }
//                workplaceindex = 0
//                travelindex = -1
//                activityindex = 1
//                doctorindex = 2
//                expenseindex = -1
//                generalindex = 3
            } else if isExpenceAllowed() ==  true && isTravelAllowed() == false {
                
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                }
                
//                workplaceindex = 0
//                travelindex = -1
//                activityindex = 1
//                doctorindex = 2
//                expenseindex = 3
//                generalindex = 4
            }else if isExpenceAllowed() == false && isTravelAllowed() == true{
               
                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                }
                
                
                
//                workplaceindex = 0
//                travelindex = 1
//                activityindex = 2
//                doctorindex = 3
//                expenseindex = -1
//                generalindex = 4
            }else if isExpenceAllowed() == true && isTravelAllowed() == true{

                if sfcList.count == 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                } else if sfcList.count == 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: -1, activity: 1, partner: -1, expense: 2, remark: 3)
                } else if sfcList.count != 0 && expenseList.count == 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: -1, remark: 3)
                } else if sfcList.count != 0 && expenseList.count != 0 {
                    setIndex(work: 0, travel: 1, activity: 2, partner: -1, expense: 3, remark: 4)
                }
                
                
                
                //                workplaceindex = 0
//                travelindex = 1
//                activityindex = 2
//                doctorindex = 3
//                expenseindex = 4
//                generalindex = 5
            } else {
                
            }
            
            
            
            
            
//            if privilegeArray.contains(Constants.ChemistDayCaptureValue.attendance_expenses) || expenseList!.count > 0
//            {
//                workplaceindex = 0
//                travelindex = 1
//                activityindex = 2
//                expenseindex = 3
//                generalindex = 4
//                doctorindex = -1
//            }
//            else
//            {
//                workplaceindex = 0
//                travelindex = 1
//                activityindex = 2
//                generalindex = 3
//                doctorindex = -1
//            }
        }
        
    }
    
    //MARK:-- Get Data Functions
    func checkAttendanceSampleAvailable() -> Bool
    {
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_SAMPLE_IN_DCR_ATTENDANCE) == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    func getDCRExpenseDetails() -> [DCRExpenseModel]?
    {
        return BL_Expense.sharedInstance.getDCRExpenses()
    }
    
    func getDCRWorkPlace() -> DCRHeaderModel?
    {
        return BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
    }

    func getDCRSFCDetails() -> [DCRTravelledPlacesModel]?
    {
        return DBHelper.sharedInstance.getDCRSFCDetails(dcrId:getDCRId())
    }
    
    func getDCRActivityDetails() -> [DCRAttendanceActivityModel]?
    {
        return DBHelper.sharedInstance.getDCRAttendanceActivities(dcrId: getDCRId())
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    func clearAllArray()
    {
        self.isSFCUpdated = false
        stepperDataList = []
        workPlaceList = []
        sfcList = []
        expenseList = []
        dcrHeaderObj = nil
    }
    
    //MARK:- Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpaceToContainer: CGFloat = 2
        let titleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateTitle, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 16))).height
        let verticalSpaceBetweenTitleAndSubTitle: CGFloat = 4
        let subTitleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateSubTitle, fontName: fontRegular, fontSize: 12, constrainedWidth: (SCREEN_WIDTH - (49 + 16))).height
        let verticalSpaceBetweenButtonAndSubTitle: CGFloat = 12
        var buttonHeight: CGFloat = 0
        
        if stepperObj.showEmptyStateAddButton == true
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
        let line2Height: CGFloat = 16
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        let line1Height: CGFloat = getTextSize(text: dcrHeaderObj!.DCR_General_Remarks, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - 101)).height
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 0
        let line2Height: CGFloat = 0
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getGeneralRemarksCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
    
//    func getDoctorCellHeight(selectedIndex: Int) -> CGFloat
//    {
//        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
//
//        let titleSectionHeight: CGFloat = 41
//        let buttonViewHeight: CGFloat = 50
//        let bottomSpaceView: CGFloat = 0
//        //let cellY: CGFloat = 28
//        var numberOfRows: Int = 1
//        var childTableHeight: CGFloat = 0
//
//        if (stepperObj.isExpanded == true)
//        {
//            numberOfRows = stepperObj.recordCount
//        }
//
//        for index in 0...numberOfRows -  1
//        {
//            childTableHeight += getDoctorSingleCellHeight(selectedIndex: index)
//        }
//
//        var totalHeight = titleSectionHeight + childTableHeight + buttonViewHeight + bottomSpaceView
//
//        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
//        {
//            totalHeight = totalHeight - 20
//        }
//
//        return totalHeight
//    }
    
//    func getDoctorSingleCellHeight(selectedIndex: Int) -> CGFloat
//    {
//        let topSpace: CGFloat = 4
//        let imageHeight: CGFloat = 24
//        let label1TopSpace: CGFloat = 10
//        let line1Height: CGFloat = 16
//        let label2TopSpace: CGFloat = 4
//        let line2Height: CGFloat = 16
//        let dividerViewTopSpace: CGFloat = 8
//        let dividerViewHeight: CGFloat = 1
//        let line3Height : CGFloat = 16
//        let line3TopSpace : CGFloat = 15
//        let childTableViewTopSpace :CGFloat = 8
//        let childTableViewBottomSpace:CGFloat = 8
//        let removeBtnTopSpace : CGFloat = 8
//        let removeBtnHeight : CGFloat = 28
//        let addSampleBtnTopSpace : CGFloat = 8
//        let addSampleBtnHeight : CGFloat = 28
//        var childTableViewHeight : CGFloat = 0
//        
//        for obj in doctorList[selectedIndex].sampleList
//        {
//            if(obj.isShowSection || !obj.isShowSection)
//            {
//                childTableViewHeight += 20
//            }
//            
//            for _ in obj.sampleList
//            {
//               childTableViewHeight += 20
//            }
//        }
//        
//        var totalSpace : CGFloat = 0
//        
//        let topViewSpace = topSpace + imageHeight + label1TopSpace + line1Height + label2TopSpace + line2Height + dividerViewTopSpace + dividerViewHeight + line3Height + line3TopSpace
//        totalSpace += topViewSpace
//        
//        if doctorList[selectedIndex].isExpanded
//        {
//            let tableviewSpace = childTableViewTopSpace + childTableViewBottomSpace  + childTableViewHeight
//            let btnSpace =  removeBtnTopSpace + removeBtnHeight + addSampleBtnTopSpace + addSampleBtnHeight
//            
//            totalSpace += tableviewSpace + btnSpace
//        }
//        
//        return totalSpace
//    }
    //MARK:- SUBMIT DCR FUNCTION
    
    func doSubmitDCRValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        errorMessage = BL_Stepper.sharedInstance.doAllWorkPlaceValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage =  BL_Stepper.sharedInstance.doAllSFCValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllActivityValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        // Based upon attendance privilege value
        let priviledge = getAttendanceCaptureValue()
        let privilegeArray = priviledge.components(separatedBy: ",")
        let expenseList: [DCRExpenseModel]? = BL_Expense.sharedInstance.getDCRExpenses()
        if privilegeArray.contains(Constants.ChemistDayCaptureValue.attendance_expenses) || expenseList!.count > 0
        {
            errorMessage = BL_Stepper.sharedInstance.doAllExpenseValidations()
            if (errorMessage != EMPTY)
            {
                return errorMessage
            }
        }
        
        errorMessage = doAllGeneralRemarksValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doDoctorValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        return errorMessage
    }
    
    
    
    //MARK:- VALIDATIONS
    
    private func doAllGeneralRemarksValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        if (checkNullAndNilValueForString(stringData: dcrHeaderObj?.Unapprove_Reason) != EMPTY)
        {
            if (BL_Stepper.sharedInstance.getGeneralRemarksForModify() == EMPTY)
            {
                errorMessage = "Please enter general remarks"
            }
        }
        
        return errorMessage
    }
    
    private func doAllActivityValidation() -> String
    {
        let dcrActivityList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceActivities()!
        let activityList = BL_DCR_Attendance.sharedInstance.getProjectActivityList()!
        var errorMessage: String = EMPTY
        
        for objDCRActivity in dcrActivityList
        {
            let filteredArray = activityList.filter{
                $0.Activity_Code == objDCRActivity.Activity_Code
            }
            
            if (filteredArray.count == 0)
            {
                errorMessage = "\(objDCRActivity.Activity_Name!) is an invalid Activity"
            }
            
            if (objDCRActivity.Start_Time == EMPTY && objDCRActivity.End_Time == EMPTY)
            {
                errorMessage = "Start time & end time are missing for activity \(objDCRActivity.Activity_Name!)"
            }
            
            if (objDCRActivity.Start_Time == EMPTY)
            {
                errorMessage = "Start time is missing for activity \(objDCRActivity.Activity_Name!)"
            }
            
            if (objDCRActivity.End_Time == EMPTY)
            {
                errorMessage = "End time is missing for activity \(objDCRActivity.Activity_Name!)"
            }
            
            if (checkNullAndNilValueForString(stringData: objDCRActivity.Remarks).count > attendanceActivityRemarksLength)
            {
                errorMessage = "Remarks for \(objDCRActivity.Activity_Name!) exceeds \(attendanceActivityRemarksLength) characters. Please correct the remarks"
            }
            
            if (errorMessage != EMPTY)
            {
                break
            }
        }
        
        return errorMessage
    }
    
    private func doDoctorValidation() -> String
    {
        var errorMessage: String = EMPTY
        if(checkAttendanceSampleAvailable())
        {
            if BL_Doctor_Attendance_Stepper.sharedInstance.doctorVisitList.count > 0
            {
                if BL_Doctor_Attendance_Stepper.sharedInstance.sampleList.count > 0 || BL_Doctor_Attendance_Stepper.sharedInstance.activitStepperData.count > 0
                {
                    errorMessage = ""
                    
                }
                else
                {
                    errorMessage = "You need to entry Samples or Activity for every Office \(appDoctor)"
                }
            }
        }
        else
        {
            errorMessage = ""
        }
        
        return errorMessage
    }
    
    private func updateDCRStatusAsDraft()
    {
        if (dcrStatus == DCRStatus.newDCR.rawValue && isDataInsertedFromTP == false)
        {
            if (workPlaceList.count > 0)
            {
                self.dcrStatus = DCRStatus.drafted.rawValue
                self.dcrHeaderObj?.DCR_Status = String(dcrStatus)
                
                DBHelper.sharedInstance.updateDCRStatus(dcrId: self.dcrId, dcrStatus: dcrStatus, dcrCode: EMPTY)
                
                BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [self.dcrHeaderObj!])
            }
        }
        else
        {
            self.isDataInsertedFromTP = false
        }
    }

    //MARK:- Doctor
    func showAccompanistAddBtn() -> Bool
    {
        let accompanistDataDownloadedList = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
        if accompanistDataDownloadedList.count > 0
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func getDownloadedAcoompanists() -> [AccompanistDataDownloadModel]
    {
        var accompanistDataDownloadedList:[AccompanistDataDownloadModel] = []
        
        accompanistDataDownloadedList = DBHelper.sharedInstance.getAccompanistDataDownloadedRegions()
        if accompanistDataDownloadedList.count > 0
        {
            return accompanistDataDownloadedList
        }
        else
        {
            return accompanistDataDownloadedList
        }
    }
    
    func getDoctorVisitCellHeight(dataList : [StepperAttendanceDoctorModel] , type : Int) -> CGFloat
    {
        var childTableHeight: CGFloat = 0
        
        for obj in dataList
        {
            let height = BL_Approval.sharedInstance.getSingleDoctorVisitCellHeight() + getDoctorVisitDetails(dict: obj)
            if type == 1
            {
                childTableHeight = childTableHeight + height
            }
            else
            {
                childTableHeight = childTableHeight + height - 22
            }
        }
        return childTableHeight
    }
    
    func getDoctorVisitDetails(dict : StepperAttendanceDoctorModel) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat  = 0
        
        let Hospital_Name : String = checkNullAndNilValueForString(stringData: dict.Hospital_Name)
        if Hospital_Name != ""
        {
            doctorDetails = Hospital_Name
        }
        
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.MDL_Number)
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
        doctorDetails = doctorDetails + " | " + "MDL NO : \(mdlNumber)"
        
        let specialityName : String = checkNullAndNilValueForString(stringData: dict.Speciality_Name)
        if specialityName != ""
        {
            doctorDetails = doctorDetails + " | " + specialityName
        }
        
        var categoryName : String = checkNullAndNilValueForString(stringData: "")
        if categoryName == ""
        {
            categoryName = NOT_APPLICABLE
        }
        
        doctorDetails = doctorDetails + " | " + categoryName
        
        
        let regionName = checkNullAndNilValueForString(stringData: dict.Region_Name)
        if regionName != ""
        {
            doctorDetails = doctorDetails + " | " + regionName
        }
        
        let doctorName =   "\(appDoctor) Name:\(checkNullAndNilValueForString(stringData: dict.Customer_Name))"
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
        let doctorNameHgt = getTextSize(text: doctorName, fontName: fontSemiBold, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 86).height
        
        return lblHeight + doctorNameHgt
    }
    func getDoctorCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Attendance_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 41
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        //let cellY: CGFloat = 28
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if (stepperObj.isExpanded == true)
        {
            numberOfRows = stepperObj.recordCount
        }
        
        for _ in 1...numberOfRows
        {
            childTableHeight += BL_Stepper.sharedInstance.getDoctorSingleCellHeight()
        }
        
        var totalHeight = titleSectionHeight + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getAttendanceCaptureValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE).uppercased()
    }
    
}


/*
 {
 var lstStepperDoctorList: [StepperAttendanceDoctorModel] = []
 let lstSamples: [DCRAttendanceSampleDetailsModel] = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(dcrId: getDCRId())
 let lstsampleBatchs: [DCRSampleBatchModel] = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamplesBatchs(dcrId: getDCRId())
 
 for objDoctor in attendanceDoctorList
 {
 
 let objStepperDoctor: StepperAttendanceDoctorModel = StepperAttendanceDoctorModel()
 
 objStepperDoctor.doctorId = objDoctor.DCR_Doctor_Visit_Id
 objStepperDoctor.Customer_Code = objDoctor.Doctor_Code
 objStepperDoctor.Region_Code = objDoctor.Doctor_Region_Code
 objStepperDoctor.Customer_Name = objDoctor.Doctor_Name
 objStepperDoctor.Region_Name = objDoctor.Doctor_Region_Name
 objStepperDoctor.Speciality_Name = objDoctor.Speciality_Name
 objStepperDoctor.MDL_Number = objDoctor.MDL_Number
 
 objStepperDoctor.sampleList = []
 
 let filteredList = lstSamples.filter{
 $0.DCR_Doctor_Visit_Id == objStepperDoctor.doctorId
 }
 
 for obj in filteredList
 {
 let filteredBatchList = lstsampleBatchs.filter{
 $0.Ref_Id == obj.DCR_Attendance_Sample_Id
 }
 if(filteredList.count > 0)
 {
 
 if filteredList.count != nil
 {
 var sampleDataList : [SampleBatchProductModel] = []
 for sampleObj in filteredList
 {
 var sampleModelList:[DCRSampleModel] = []
 let sampleBatchObj = SampleBatchProductModel()
 sampleBatchObj.title = sampleObj.Product_Name
 
 let filterValue = filteredBatchList.filter{
 $0.Ref_Id == sampleObj.DCR_Attendance_Sample_Id
 }
 if(filterValue.count > 0)
 {
 for obj in filterValue
 {
 let sampleBatchObj = sampleObj
 let dict: NSDictionary = ["Visit_Id": sampleBatchObj.DCR_Attendance_Sample_Id, "DCR_Id": sampleBatchObj.DCR_Id ?? 0, "Product_Id": 0, "Product_Code": sampleBatchObj.Product_Code, "Product_Name": sampleBatchObj.Product_Name, "Quantity_Provided": String(sampleBatchObj.Quantity_Provided!)]
 let objDCRSample: DCRSampleModel = DCRSampleModel(dict: dict)
 objDCRSample.sampleObj.Batch_Name = obj.Batch_Number
 objDCRSample.sampleObj.Quantity_Provided = obj.Quantity_Provided
 sampleModelList.append(objDCRSample)
 }
 sampleBatchObj.title = sampleObj.Product_Name
 sampleBatchObj.isShowSection = true
 sampleBatchObj.sampleList = sampleModelList
 sampleDataList.append(sampleBatchObj)
 }
 }
 if(filteredList.count > 0)
 {
 let sampleBatchObj = SampleBatchProductModel()
 var sampleModelList:[DCRSampleModel] = []
 sampleBatchObj.title = ""
 sampleBatchObj.isShowSection = false
 for sampleObj in filteredList
 {
 
 let filterValue = filteredBatchList.filter{
 $0.Ref_Id == sampleObj.DCR_Attendance_Sample_Id
 }
 if(filterValue.count == 0)
 {
 let dict: NSDictionary = ["Visit_Id": sampleObj.DCR_Attendance_Sample_Id, "DCR_Id": sampleObj.DCR_Id ?? 0, "Product_Id": 0, "Product_Code": sampleObj.Product_Code, "Product_Name": sampleObj.Product_Name, "Quantity_Provided": String(sampleObj.Quantity_Provided!)]
 let objDCRSample: DCRSampleModel = DCRSampleModel(dict: dict)
 sampleModelList.append(objDCRSample)
 }
 
 }
 if(sampleModelList.count > 0)
 {
 sampleBatchObj.sampleList = sampleModelList
 sampleDataList.append(sampleBatchObj)
 }
 }
 objStepperDoctor.sampleList = sampleDataList
 }
 
 }
 lstStepperDoctorList.append(objStepperDoctor)
 }
 }
 
 return lstStepperDoctorList
 }*/
