//
//  BL_TPCalendar.swift
//  HiDoctorApp
//
//  Created by Vijay on 21/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TPCalendar: NSObject
{
    static let sharedInstance = BL_TPCalendar()
    
    var tourPlannerHeader : [TourPlannerHeader] = []
    var isEmptyCalendarModel : Bool = false
    var activityCode = 0
    var stepperDataList: [DCRStepperModel] = []
    var callObjectDataList: [CallObjectModel] = []
    var tourPlannerAccompanist: [TourPlannerAccompanist] = []
    var tourPlannerSFC: [TourPlannerSFC] = []
    var tourPlannerDoctor : [TourPlannerDoctor] = []
    var Accompanist:[UserMasterWrapperModel] = []
    
    func getTPMonth() -> NSDictionary
    {
        let dictionary:NSMutableDictionary = [:]
        let date = NSDate()
        let unitFlags = Set<Calendar.Component>([.month, .year])
        let calendar = NSCalendar.current
        var components = calendar.dateComponents(unitFlags, from: date as Date)
        var prevMonth = components.month! - 1
        var prevBeforeMonth = prevMonth - 1
        var nextMonth = components.month! + 1
        var nextAfterMonth = nextMonth + 1
        let currentMonth = components.month
        var prevYear = components.year
        var prevBeforeYear = components.year
        var nextYear = components.year
        var nextAfterYear = components.year
        let currentYear = components.year
        
        if prevMonth == 0
        {
            prevMonth = 12
            prevYear = components.year! - 1
            prevBeforeMonth = 11
            prevBeforeYear = components.year! - 1
        }
        
        if prevBeforeMonth == 0
        {
            prevBeforeMonth = 12
            prevBeforeYear = components.year! - 1
        }
        
        if nextMonth == 13
        {
            nextMonth = 1
            nextYear = components.year! + 1
            nextAfterMonth = 2
            nextAfterYear = components.year! + 1
        }
        
        if nextAfterMonth == 13
        {
            nextAfterMonth = 1
            nextAfterYear = components.year! + 1
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let prevMonthStringFormat = String(format: "%@ - %d", (months?[prevMonth - 1])!, prevYear!)
        let prevBeforeMonthStringFormat = String(format: "%@ - %d", (months?[prevBeforeMonth - 1])!, prevBeforeYear!)
        let nextMonthStringFormat = String(format: "%@ - %d", (months?[nextMonth - 1])!, nextYear!)
        let nextAfterMonthStringFormat = String(format: "%@ - %d", (months?[nextAfterMonth - 1])!, nextAfterYear!)
        let currentMonthStringFormat = String(format: "%@ - %d", (months?[currentMonth! - 1])!, currentYear!)
        let array: NSArray = [prevBeforeMonthStringFormat, prevMonthStringFormat, currentMonthStringFormat, nextMonthStringFormat, nextAfterMonthStringFormat]
        var startDateString: String!
        var beforeMiddleDateString : String!
        var endDateString: String!
        var middleDateString: String!
        var afterMiddleDateString: String!
        
        if prevBeforeMonth == 10 || prevBeforeMonth == 11 || prevBeforeMonth == 12
        {
            startDateString = String(format: "%d-01-%d", prevBeforeMonth, prevBeforeYear!)
        }
        else
        {
            startDateString = String(format: "0%d-01-%d", prevBeforeMonth, prevBeforeYear!)
        }
        
        if prevMonth == 10 || prevMonth == 11 || prevMonth == 12
        {
            beforeMiddleDateString = String(format: "%d-01-%d", prevMonth, prevYear!)
        }
        else
        {
            beforeMiddleDateString = String(format: "0%d-01-%d", prevMonth, prevYear!)
        }
        
        if nextMonth == 10 || nextMonth == 11 || nextMonth == 12
        {
            afterMiddleDateString = String(format: "%d-01-%d", nextMonth, nextYear!)
        }
        else
        {
            afterMiddleDateString = String(format: "0%d-01-%d", nextMonth, nextYear!)
        }
        
        if nextAfterMonth == 10 || nextAfterMonth == 11 || nextAfterMonth == 12
        {
            endDateString = String(format: "%d-01-%d", nextAfterMonth, nextAfterYear!)
        }
        else
        {
            endDateString = String(format: "0%d-01-%d", nextAfterMonth, nextAfterYear!)
        }
        
        if currentMonth == 10 || currentMonth == 11 || currentMonth == 12
        {
            middleDateString = String(format: "%d-01-%d", currentMonth!, currentYear!)
        }
        else
        {
            middleDateString = String(format: "0%d-01-%d", currentMonth!, currentYear!)
        }
        
        let startDate = getTpCalendarMonthStringToDate(dateString: startDateString)
        let beforeMiddleDate = getTpCalendarMonthStringToDate(dateString: beforeMiddleDateString)
        let afterMiddleDate = getTpCalendarMonthStringToDate(dateString: afterMiddleDateString)
        let endDate = getTpCalendarMonthStringToDate(dateString: endDateString)
        let middleDate = getTpCalendarMonthStringToDate(dateString: middleDateString)
        
        dictionary.setValue(array, forKey: "monthArray")
        dictionary.setValue(startDate, forKey: "startDate")
        dictionary.setValue(beforeMiddleDate, forKey: "beforeMiddleDate")
        dictionary.setValue(afterMiddleDate, forKey: "afterMiddleDate")
        dictionary.setValue(endDate, forKey: "endDate")
        dictionary.setValue(middleDate, forKey: "middleDate")
        
        return dictionary
    }
    
    func clearAllValues()
    {
        tourPlannerHeader.removeAll()
        isEmptyCalendarModel = false
        activityCode = 0
        stepperDataList.removeAll()
        callObjectDataList.removeAll()
        tourPlannerAccompanist.removeAll()
        tourPlannerSFC.removeAll()
        tourPlannerDoctor.removeAll()
        Accompanist.removeAll()
    }
    
    func isToday(date: Date) -> Bool
    {
        var flag = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: getCurrentDateAndTime())
        let paramDateString = dateFormatter.string(from: date)
        
        if currentDateString == paramDateString
        {
            flag = true
        }
        
        return flag
    }
    
    private func getTpCalendarMonthStringToDate(dateString: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let getDate = dateFormatter.date(from: dateString)
        return getServerFormattedDate(date: getDate!)
    }
    
    func getTPCalendarModel()
    {
        tourPlannerHeader = []
        
        tourPlannerHeader = DBHelper.sharedInstance.getTpList()
        
        if tourPlannerHeader.count == 0
        {
            isEmptyCalendarModel = true
        }
    }
    
    func getHolidayName(dcrDate : Date) -> String
    {
        let holidayName = DBHelper.sharedInstance.getHolidayName(holidayDate: dcrDate)
        
        return holidayName
    }
    
    func getTPData(date: Date) -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTPDate(tpDate: date)
    }
    func getTPData(date: String) -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTPDate(tpDate: date)
    }
    
    func getTPAccompanistData() -> [TourPlannerAccompanist]
    {
        var tourPlannerAccompanistList : [TourPlannerAccompanist] = []
        
        tourPlannerAccompanistList = DAL_TP_Calendar.sharedInstance.getListOfTpAccompanist(tpId: tourPlannerHeader[0].TP_Entry_Id!)
        
        return tourPlannerAccompanistList
    }
    
    func getTPSFCData() -> [TourPlannerSFC]
    {
        var tourPlannerSFCList : [TourPlannerSFC] = []
        
        tourPlannerSFCList = DAL_TP_Calendar.sharedInstance.getListOfTpSFC(tpId: tourPlannerHeader[0].TP_Entry_Id!)

        return tourPlannerSFCList
    }
    
    
    func getTPDoctorData() -> [TourPlannerDoctor]
    {
        var tourPlannerDoctorList : [TourPlannerDoctor] = []
        
         if (TPModel.sharedInstance.tpStatus == 3){
            tourPlannerDoctorList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
         }else if (TPModel.sharedInstance.tpStatus == 2){
            if(TPModel.sharedInstance.tpId == 0){
                tourPlannerDoctorList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId)
            }else{
                tourPlannerDoctorList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
            }
         }else if (TPModel.sharedInstance.tpStatus == 0){
            tourPlannerDoctorList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
         }
         else{
            tourPlannerDoctorList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate)
        }
        

        return tourPlannerDoctorList
    }
    
    
    func isAddBtnHidden(date : Date) -> Bool
    {
        var flag : Bool = false
        var activityCount : Int = 0
        var isWeekEnd : Int = 0
        var isHoliday : Int = 0
        
        let tourPlannerHeader:TourPlannerHeader? = BL_TPCalendar.sharedInstance.getTPData(date: date)
        
        if tourPlannerHeader != nil
        {
            activityCount = (tourPlannerHeader?.Activity!)!
            isWeekEnd = (tourPlannerHeader?.Is_Weekend)!
            isHoliday = (tourPlannerHeader?.Is_Holiday)!
        }
        
        if activityCount == 1 ||  isWeekEnd == 1 || isHoliday == 1
        {
            flag = true
        }
        
        return flag
    }
    
    func convertDateIntoDCRDisplayformat(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy ( EEEE )"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter.string(from: date)
    }
    
    func generateDataArray(_ activity:Int,objTPHeader: TourPlannerHeader?)
    {
        activityCode = activity
        clearAllArray()
        if TPModel.sharedInstance.tpFlag == TPFlag.fieldRcpa.rawValue
        {
            getCallObjectModelList(objTPHeader: objTPHeader)
            getAccompanistDataList()
            getSFCDataList()
            getDoctorDataList()
        }
        else if TPModel.sharedInstance.tpFlag == TPFlag.attendance.rawValue
        {
            getCallObjectModelList(objTPHeader: objTPHeader)
            getSFCDataList()
        }
        else
        {
        getCallObjectModelList(objTPHeader: objTPHeader)
        }
        
    }
    
    //MARK:-- Array Functions
    func clearAllArray()
    {
        stepperDataList = []
        callObjectDataList = []
        tourPlannerAccompanist = []
        Accompanist = []
        tourPlannerSFC = []
        tourPlannerDoctor = []
    }
    
    private func getCallObjectModelList(objTPHeader: TourPlannerHeader?)
    {
        if (objTPHeader != nil)
        {
            let stepperObjModel: DCRStepperModel = DCRStepperModel()
            
            stepperObjModel.sectionTitle = "\(PEV_TOUR_PLAN) Details"
            stepperObjModel.sectionIconName = "icon-stepper-work-area"
            
            var callObjectModel = CallObjectModel()
            
            if(activityCode == TPFlag.fieldRcpa.rawValue) // Field
            {
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Call Objective"
                callObjectModel.objName = "Field"
                callObjectDataList.append(callObjectModel)
                
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Work Category"
                
                if tourPlannerHeader.count > 0
                {
                    if(checkNullAndNilValueForString(stringData: objTPHeader!.Category_Name!) != "")
                    {
                        callObjectModel.objName = objTPHeader!.Category_Name!
                    }
                    else
                    {
                        callObjectModel.objName = NOT_APPLICABLE
                    }
                }
                else
                {
                    callObjectModel.objName = NOT_APPLICABLE
                }
                
                callObjectDataList.append(callObjectModel)
            }
            else if(activityCode == TPFlag.attendance.rawValue) // attendance
            {
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Call Objective"
                callObjectModel.objName = "Attendance"
                callObjectDataList.append(callObjectModel)
                
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Activity Name"
                
                if tourPlannerHeader.count > 0
                {
                    if(checkNullAndNilValueForString(stringData: objTPHeader!.Activity_Name!) != "")
                    {
                        callObjectModel.objName = objTPHeader!.Activity_Name!
                    }
                    else
                    {
                        callObjectModel.objName = NOT_APPLICABLE
                    }
                }
                else
                {
                    callObjectModel.objName = NOT_APPLICABLE
                }
                
                callObjectDataList.append(callObjectModel)
                
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Work Category"
                
                if tourPlannerHeader.count > 0
                {
                    if(checkNullAndNilValueForString(stringData: objTPHeader!.Category_Name!) != "")
                    {
                        callObjectModel.objName = objTPHeader!.Category_Name!
                    }
                    else
                    {
                        callObjectModel.objName = NOT_APPLICABLE
                    }
                }
                else
                {
                    callObjectModel.objName = NOT_APPLICABLE
                }
                
                callObjectDataList.append(callObjectModel)
            }
            else if(activityCode == TPFlag.leave.rawValue) // leave
            {
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Call Objective"
                callObjectModel.objName = "Not Working"
                callObjectDataList.append(callObjectModel)
                
                callObjectModel = CallObjectModel()
                callObjectModel.objTitle = "Activity Name"
                
                if tourPlannerHeader.count > 0
                {
                    if(checkNullAndNilValueForString(stringData: objTPHeader!.Activity_Name!) != "")
                    {
                        callObjectModel.objName = objTPHeader!.Activity_Name!
                    }
                    else
                    {
                        callObjectModel.objName = NOT_APPLICABLE
                    }
                }
                else
                {
                    callObjectModel.objName = NOT_APPLICABLE
                }
                
                callObjectDataList.append(callObjectModel)
            }
            
            stepperObjModel.recordCount = callObjectDataList.count
            stepperDataList.append(stepperObjModel)
        }
    }
    
    private func getAccompanistDataList()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(PEV_ACCOMPANIST) Details"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        
        Accompanist = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        stepperObjModel.recordCount = Accompanist.count
        stepperDataList.append(stepperObjModel)
    }
    
    private func getSFCDataList()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Place Details"
        stepperObjModel.sectionIconName = "icon-stepper-sfc"
        
        self.tourPlannerSFC = BL_TPStepper.sharedInstance.getTPSelectedTravelPlacesDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)!
        stepperObjModel.recordCount = self.tourPlannerSFC.count
        stepperDataList.append(stepperObjModel)
    }
    
    private func getDoctorDataList()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(appDoctor) Details"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        
        self.tourPlannerDoctor = BL_TPCalendar.sharedInstance.getTPDoctorData()
        
        stepperObjModel.recordCount = self.tourPlannerDoctor.count
        stepperDataList.append(stepperObjModel)
    }
    
    
    // start
    
//    func getTourPlanCellHeight(selectedIndex: Int) -> CGFloat
//    {
//        let stepperObj: DCRStepperModel = BL_TPCalendar.sharedInstance.stepperDataList[selectedIndex]
//        
//        let titleSectionHeight: CGFloat = 30
//        let buttonViewHeight: CGFloat = 60
//        let bottomSpaceView: CGFloat = 5
//        let cellY: CGFloat = 0
//        var numberOfRows: Int = 1
//        var childTableHeight: CGFloat = 0
//        
//        numberOfRows = stepperObj.recordCount
//        
//        for _ in 1...numberOfRows
//        {
//            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
//        }
//        
//        let totalHeight = titleSectionHeight + cellY + childTableHeight + bottomSpaceView + buttonViewHeight
//        
//        //        if (stepperObj.recordCount == 1)
//        //        {
//        //            totalHeight = totalHeight - 20
//        //        }
//        
//        return totalHeight
//    }
    
    func getCommonSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = 16
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 4
        let line2Height: CGFloat = 0
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getDefaultCellHeight() -> CGFloat
    {
        
        return 40.0
    }
    
    func getChildTourPlanCellHeight() -> CGFloat
    {
        
        return 60.0
    }
    
    func getTourPlanCellHeight() -> CGFloat
    {
        
        let defaultHeight:CGFloat = getDefaultCellHeight()
        
        let singleCellHeight:CGFloat = getChildTourPlanCellHeight()
        
        let cellCount:CGFloat = CGFloat(BL_TPCalendar.sharedInstance.callObjectDataList.count)
        
        let totalHeight:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        
        return totalHeight
    }
    
    
//    func getSubAccCellHeight(selectedIndex: Int) -> CGFloat
//    {
//        let stepperObj: DCRStepperModel = BL_TPCalendar.sharedInstance.stepperDataList[selectedIndex]
//        
//        let titleSectionHeight: CGFloat = 30
//        let buttonViewHeight: CGFloat = 60
//        let bottomSpaceView: CGFloat = 5
//        let cellY: CGFloat = 0
//        var numberOfRows: Int = 1
//        var childTableHeight: CGFloat = 0
//        
//        numberOfRows = stepperObj.recordCount
//        
//        for _ in 1...numberOfRows
//        {
//            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
//        }
//        
//        let totalHeight = titleSectionHeight + cellY + childTableHeight + bottomSpaceView + buttonViewHeight
//        
//        //        if (stepperObj.recordCount == 1)
//        //        {
//        //            totalHeight = totalHeight - 20
//        //        }
//        
//        return totalHeight
//    }
    
    
    func getChildAccompaniestCellHeight() -> CGFloat
    {
        
        return 40.0
    }

    
    func getAccompaniestCellHeight(selectedIndex: Int) -> CGFloat
    {
        
        let stepperObj: DCRStepperModel = BL_TPCalendar.sharedInstance.stepperDataList[selectedIndex]
        
        let defaultHeight:CGFloat = getDefaultCellHeight()
        
        let singleCellHeight:CGFloat = getChildAccompaniestCellHeight()
        
        let cellCount:CGFloat = CGFloat(stepperObj.recordCount)
        
        let totalHeight:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        
        return totalHeight
        
        
        
        //        let titleSectionHeight: CGFloat = 30
        //        let buttonViewHeight: CGFloat = 60
        //        let bottomSpaceView: CGFloat = 5
        //        let cellY: CGFloat = 0
        //        var numberOfRows: Int = 1
        //        var childTableHeight: CGFloat = 0
        //
        //        numberOfRows = stepperObj.recordCount
        //
        //        for _ in 1...numberOfRows
        //        {
        //            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
        //        }
        //
        //        let totalHeight = titleSectionHeight + cellY + childTableHeight + bottomSpaceView + buttonViewHeight
        //
        //        //        if (stepperObj.recordCount == 1)
        //        //        {
        //        //            totalHeight = totalHeight - 20
        //        //        }
        //
        //        return totalHeight
    }
    
    func getChildPlaceDetailsCellHeight() -> CGFloat
    {
        
        return 95.0
    }
    
    func getPlaceDetailsCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPCalendar.sharedInstance.stepperDataList[selectedIndex]
        
        
        let defaultHeight:CGFloat = getDefaultCellHeight()
        
        let singleCellHeight:CGFloat = getChildPlaceDetailsCellHeight()
        
        let cellCount:CGFloat = CGFloat(stepperObj.recordCount)
        
        let totalHeight:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        
        return totalHeight
        
        
        //        let titleSectionHeight: CGFloat = 30
        //        let buttonViewHeight: CGFloat = 60
        //        let bottomSpaceView: CGFloat = 5
        //        let cellY: CGFloat = 0
        //        var numberOfRows: Int = 1
        //        var childTableHeight: CGFloat = 0
        //
        //        numberOfRows = stepperObj.recordCount
        //
        //        for _ in 1...numberOfRows
        //        {
        //            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
        //        }
        //
        //        let totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        //
        //        //        if (stepperObj.recordCount == 1)
        //        //        {
        //        //            totalHeight = totalHeight - 20
        //        //        }
        //
        //        return totalHeight
    }
    
    func getChildDoctorDetailsCellHeight(index: Int) -> CGFloat
    {
        let doctorObjModel = BL_TPCalendar.sharedInstance.getTPDoctorData()[index]
        let strHospitalName = checkNullAndNilValueForString(stringData: doctorObjModel.Hospital_Name!) as? String
//        let str = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName! , doctorObjModel.MDL_Number!, doctorObjModel.Speciality_Name, doctorObjModel.Category_Name!, doctorObjModel.Doctor_Region_Name!)
        let str = String(format: "%@ | %@ | %@ | %@", strHospitalName!, doctorObjModel.Speciality_Name, doctorObjModel.Category_Name!, doctorObjModel.Doctor_Region_Name!)

        let titleLabelHeight: CGFloat = getTextSize(text: str, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let singleCellHeight:CGFloat = 45.0
        let totalHeight:CGFloat = (singleCellHeight + titleLabelHeight) //* cellCount
        
        return totalHeight
    }
    
    func getDoctorDetailsCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_TPCalendar.sharedInstance.stepperDataList[selectedIndex]
        let defaultHeight: CGFloat = 45.0
        let cellCount = stepperObj.recordCount
        var singleCellHeight: CGFloat =  0
        
        for i in 0..<cellCount
        {
            singleCellHeight += getChildDoctorDetailsCellHeight(index: i)
        }
        
        let totalHeight:CGFloat = singleCellHeight + defaultHeight
        return totalHeight
    }
    
    // End
    
    //MARK:-- Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let defaultHeight:CGFloat = 80.0
        let singleCellHeight:CGFloat = 60.0
        let cellCount:CGFloat = 0.0
        let _:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        
        return defaultHeight
    }
    
    func getTPDataForSelectedDate(date: Date) -> TourPlannerHeader?
    {
        return BL_TPCalendar.sharedInstance.getTPData(date: date)
    }
    
    func setSelectedTpDataInContext(date: Date, tpFlag: Int)
    {
        let  objTPHeader: TourPlannerHeader? = getTPDataForSelectedDate(date: date)
        
        TPModel.sharedInstance.tpDate = date
        TPModel.sharedInstance.tpDateString = convertDateIntoServerStringFormat(date: date)
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
    
    func getDayFromDate(date: Date) -> String
    {
        return convertDateInToDay(date: date)
    }
    
    func getTPEntryOptions() -> [String]
    {
        let tpEntryOptions = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_ENTRY_OPTIONS).uppercased().components(separatedBy: ",")
        var tpOptions: [String] = []
        
        for option in tpEntryOptions
        {
            if (option == PrivilegeValues.FIELD_RCPA.rawValue)
            {
                tpOptions.append(fieldRcpa)
            }
            else if (option == PrivilegeValues.ATTENDANCE.rawValue)
            {
                tpOptions.append(attendance)
            }
            else if (option == PrivilegeValues.LEAVE.rawValue)
            {
                
                    tpOptions.append(leave)
            }
        }
        
        return tpOptions
    }
    //MARK : TO ENABLE ADD ON WEEKEND
    func isCPVisitFrequencyEnabled()->Bool
    {
       
        if(PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CP_VISIT_FREQENCY_IN_TP ) == PrivilegeValues.ZERO.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
        
    }
}
