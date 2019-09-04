//
//  BL_DCRCalendar.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCRCalendar: NSObject
{
    static let sharedInstance = BL_DCRCalendar()
    
    var dcrCalendarModel : [DCRCalendarModel] = []
    var dcrHeaderModel : [DCRHeaderModel] = []
    var dcrLWHAModel : [DCRCalendarModel] = []
    var isEmptyCalendarModel : Bool = false
    var resignedAccompanists: [String] = []
    var selectedStatus : Int = 99
    var tpPreFillAlert : [String] = []

    // Get Current, Prev & Next month
    func getCPNMonth() -> NSDictionary
    {
        let dictionary:NSMutableDictionary = [:]
        
        let date = NSDate()
        let unitFlags = Set<Calendar.Component>([.month, .year])
        let calendar = NSCalendar.current
        
        var components = calendar.dateComponents(unitFlags, from: date as Date)
        var prevMonth = components.month! - 1
        var nextMonth = components.month! + 1
        let currentMonth = components.month
        var prevYear = components.year
        var nextYear = components.year
        let currentYear = components.year
        if prevMonth == 0 {
            prevMonth = 12
            prevYear = components.year! - 1
        }
        
        if nextMonth == 13 {
            nextMonth = 1
            nextYear = components.year! + 1
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let prevMonthStringFormat = String(format: "%@ - %d", (months?[prevMonth - 1])!, prevYear!)
        let nextMonthStringFormat = String(format: "%@ - %d", (months?[nextMonth - 1])!, nextYear!)
        let currentMonthStringFormat = String(format: "%@ - %d", (months?[currentMonth! - 1])!, currentYear!)
        let array: NSArray = [prevMonthStringFormat, currentMonthStringFormat, nextMonthStringFormat]
        var startDateString: String!
        var endDateString: String!
        var middleDateString: String!
        if prevMonth == 10 || prevMonth == 11 || prevMonth == 12
        {
            startDateString = String(format: "%d-01-%d", prevMonth, prevYear!)
        }
        else
        {
            startDateString = String(format: "0%d-01-%d", prevMonth, prevYear!)
        }
        if nextMonth == 10 || nextMonth == 11 || nextMonth == 12
        {
            endDateString = String(format: "%d-01-%d", nextMonth, nextYear!)
        }
        else
        {
            endDateString = String(format: "0%d-01-%d", nextMonth, nextYear!)
        }
        if currentMonth == 10 || currentMonth == 11 || currentMonth == 12
        {
            middleDateString = String(format: "%d-01-%d", currentMonth!, currentYear!)
        }
        else
        {
            middleDateString = String(format: "0%d-01-%d", currentMonth!, currentYear!)
        }
        let startDate = getCalendarMonthStringToDate(dateString: startDateString)
        let endDate = getCalendarMonthStringToDate(dateString: endDateString)
        let middleDate = getCalendarMonthStringToDate(dateString: middleDateString)
        dictionary.setValue(array, forKey: "monthArray")
        dictionary.setValue(startDate, forKey: "startDate")
        dictionary.setValue(endDate, forKey: "endDate")
        dictionary.setValue(middleDate, forKey: "middleDate")
        
        return dictionary
    }
    
    func clearAllArray()
    {
        dcrCalendarModel.removeAll()
        dcrHeaderModel.removeAll()
        dcrLWHAModel.removeAll()
        isEmptyCalendarModel = false
        resignedAccompanists.removeAll()
        tpPreFillAlert.removeAll()
    }
    
    func convertDateIntoDCRDisplayformat(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd - MMM - yyyy - EEEE"
        dateFormatter.timeZone = utcTimeZone
        return dateFormatter.string(from: date)
    }
    
    func checkIsFutureDate(date : Date) -> Bool
    {
        var flag : Bool = false
        
        let currentDate = getServerFormattedDate(date: getCurrentDateAndTime())
        let paramDate = getServerFormattedDate(date: date)
        
        if currentDate.compare(paramDate) == .orderedAscending
        {
            flag = true
        }
        
        return flag
    }
    
    func isToday(date: Date) -> Bool
    {
        var flag = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        let currentDateString = dateFormatter.string(from: getCurrentDateAndTime())
        let paramDateString = dateFormatter.string(from: date)
        if currentDateString == paramDateString
        {
            flag = true
        }
        
        return flag
    }
    
    func insertLeaveTPDetails(selectedDate: Date)
    {
        let modelList = DBHelper.sharedInstance.checkDCRExists(dcrDate: selectedDate, dcrFlag: DCRFlag.leave.rawValue)
        if modelList.count > 0
        {
            let dcrId = modelList[0].DCR_Id
            DBHelper.sharedInstance.deleteDCRHeaderDetailforDCRId(dcrId: dcrId!)
        }
        
        let tpModelList = DBHelper.sharedInstance.getLeaveTpDataforDCRDate(date: selectedDate, status: TPStatus.approved.rawValue)
        
        if tpModelList.count > 0
        {
            let model = tpModelList[0]
            
            let dictionary : NSMutableDictionary = [:]
            
            dictionary.setValue(convertDateIntoServerStringFormat(date: selectedDate), forKey: "DCR_Actual_Date")
            dictionary.setValue(convertDateIntoServerStringFormat(date: getCurrentDateAndTime()), forKey: "Dcr_Entered_Date")
            dictionary.setValue("-1", forKey: "DCR_Status")
            dictionary.setValue("", forKey: "DCR_Code")
            dictionary.setValue(DCRFlag.leave.rawValue, forKey: "Flag")
            dictionary.setValue(getRegionCode(), forKey: "Region_Code")
            dictionary.setValue(Float(1), forKey: "Activity_Count")
            dictionary.setValue(getLatitude(), forKey: "Lattitude")
            dictionary.setValue(getLongitude(), forKey: "Longitude")
            dictionary.setValue(model.LeaveType_Id, forKey: "Leave_Type_Id")
            dictionary.setValue(model.Activity_Code, forKey: "Leave_Type_Code")
            dictionary.setValue(model.Remarks, forKey: "Reason")
            
            let dcrId = DBHelper.sharedInstance.insertInitialDCREntry(dict: dictionary)
            
            DCRModel.sharedInstance.dcrId = dcrId
            DCRModel.sharedInstance.dcrStatus = DCRStatus.newDCR.rawValue
            DCRModel.sharedInstance.dcrFlag = DCRFlag.leave.rawValue
            DCRModel.sharedInstance.dcrDate = selectedDate
            DCRModel.sharedInstance.dcrDateString = convertDateIntoServerStringFormat(date: selectedDate)
            DCRModel.sharedInstance.dcrCode = ""
        }
        else
        {
            DCRModel.sharedInstance.dcrDate = selectedDate
            DCRModel.sharedInstance.dcrDateString = convertDateIntoServerStringFormat(date: selectedDate)
            DCRModel.sharedInstance.dcrStatus = DCRStatus.notEntered.rawValue
        }
        
    }
    
    func insertInitialDCR(flag : Int, selectedDate : Date)
    {
        let modelList = DBHelper.sharedInstance.checkDCRExists(dcrDate: selectedDate, dcrFlag: flag)
        
        if modelList.count > 0
        {
            let dcrId = modelList[0].DCR_Id
            let dcrFlag = modelList[0].Flag
            
            DBHelper.sharedInstance.deleteDCRHeaderDetailforDCRId(dcrId: dcrId!)
            
            if dcrFlag == DCRFlag.fieldRcpa.rawValue
            {
                DBHelper.sharedInstance.deleteDCRAccompanistDetailforDCRId(dcrId: dcrId!)
                DBHelper.sharedInstance.deleteDoctorVisitForDCRId(dcrId: dcrId!)
            }
            else if dcrFlag == DCRFlag.attendance.rawValue
            {
                DBHelper.sharedInstance.deleteDCRAttendanceActivityforDCRId(dcrId: dcrId!)
            }
            
            DBHelper.sharedInstance.deleteDCRSFCDetailforDCRId(dcrId: dcrId!)
        }
        
        insertDCRTPDetails(flag: flag, selectedDate: selectedDate)
    }
    
    func insertDCRTPDetails(flag : Int, selectedDate : Date)
    {
        resignedAccompanists = []
        tpPreFillAlert = []
        
        let dictionary : NSMutableDictionary = [:]
        
        dictionary.setValue(convertDateIntoServerStringFormat(date: selectedDate), forKey: "DCR_Actual_Date")
        dictionary.setValue(convertDateIntoServerStringFormat(date: getCurrentDateAndTime()), forKey: "Dcr_Entered_Date")
        dictionary.setValue("-1", forKey: "DCR_Status")
        dictionary.setValue("", forKey: "DCR_Code")
        dictionary.setValue(flag, forKey: "Flag")
        dictionary.setValue(getRegionCode(), forKey: "Region_Code")
        dictionary.setValue(Float(1), forKey: "Activity_Count")
        dictionary.setValue(getLatitude(), forKey: "Lattitude")
        dictionary.setValue(getLongitude(), forKey: "Longitude")
        dictionary.setValue(0, forKey: "IsTPFrozenData")
        
        DCRModel.sharedInstance.dcrStatus = -1
        
        var tpId : Int = 0
        
        let tpModelList = DBHelper.sharedInstance.getTpDataforDCRDate(date: selectedDate, activity: flag, status: TPStatus.approved.rawValue)
        
        if tpModelList.count > 0
        {
            let model = tpModelList[0]
            tpId = model.TP_Id
            dictionary.setValue(String(DCRStatus.drafted.rawValue), forKey: "DCR_Status")
            dictionary.setValue(model.Work_Place, forKey: "Place_Worked")
            dictionary.setValue(model.CP_Id, forKey: "CP_Id")
            dictionary.setValue(model.CP_Name, forKey: "CP_Name")
            dictionary.setValue(model.CP_Code, forKey: "CP_Code")
            dictionary.setValue(model.Category_Id, forKey: "Category_Id")
            dictionary.setValue(model.Category_Name, forKey: "Category_Name")
            dictionary.setValue(model.Remarks, forKey: "DCR_General_Remarks")
            
            let isTPFreezed = isFrozenTP(flag: flag, date: convertDateIntoServerStringFormat(date: selectedDate))
            dictionary.setValue(isTPFreezed, forKey: "IsTPFrozenData")
            
            DCRModel.sharedInstance.dcrStatus = DCRStatus.drafted.rawValue
            let cpCode = model.CP_Code
            if(cpCode != EMPTY)
            {
                if(!BL_WorkPlace.sharedInstance.checkIfCpExistsInMaster(cpCode: model.CP_Code))//check cp invalid validation
                {
                    tpPreFillAlert.append("Selected \(appCp) is not in Approved status")
                }
            }
        }
        
        let dcrId = DBHelper.sharedInstance.insertInitialDCREntry(dict: dictionary)
        
        DCRModel.sharedInstance.dcrId = dcrId
        DCRModel.sharedInstance.dcrFlag = flag
        DCRModel.sharedInstance.dcrDate = selectedDate
        DCRModel.sharedInstance.dcrDateString = convertDateIntoServerStringFormat(date: selectedDate)
        DCRModel.sharedInstance.dcrCode = EMPTY
        
        if DCRModel.sharedInstance.dcrStatus == DCRStatus.drafted.rawValue
        {
            let modelList = DBHelper.sharedInstance.checkDCRExists(dcrDate: selectedDate, dcrFlag: flag)
            
            BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: modelList)
        }
        
        if (flag == DCRFlag.fieldRcpa.rawValue)
        {
            prefillDoctorsForDCRDate(selectedDate: selectedDate, dcrId: dcrId)
        }
        
        if tpModelList.count > 0
        {
            let model = tpModelList[0]
            
            DCRModel.sharedInstance.expenseEntityName = model.Category_Name
            DCRModel.sharedInstance.expenseEntityCode = model.Category_Code
            
            if flag == DCRFlag.fieldRcpa.rawValue
            {
                BL_Stepper.sharedInstance.isDataInsertedFromTP = true
            }
            else if flag == DCRFlag.attendance.rawValue
            {
                BL_DCR_Attendance_Stepper.sharedInstance.isDataInsertedFromTP = true
            }
        }
        else
        {
            DCRModel.sharedInstance.expenseEntityName = ""
            DCRModel.sharedInstance.expenseEntityCode = ""
            
            if flag == DCRFlag.fieldRcpa.rawValue
            {
                BL_Stepper.sharedInstance.isDataInsertedFromTP = false
            }
            else if flag == DCRFlag.attendance.rawValue
            {
                BL_DCR_Attendance_Stepper.sharedInstance.isDataInsertedFromTP = false
            }
        }
        
        if tpId > 0
        {
            if flag == DCRFlag.fieldRcpa.rawValue
            {
                let tpAccompList = DBHelper.sharedInstance.getTPAccompanistByTPId(tpId: tpId)
                
                if tpAccompList.count > 0
                {
                    let accompArr : NSMutableArray = []
                    let accompanistMaster = DBHelper.sharedInstance.getAccompanistMaster()
                    
                    for model in tpAccompList
                    {
                        let filteredArray = accompanistMaster.filter{
                            $0.User_Code == model.Acc_User_Code && $0.Region_Code == model.Acc_Region_Code
                        }
                        
                        var insertData: Bool = true
                        var objAccompMaster: AccompanistModel?
                        
                        if (filteredArray.count == 0)
                        {
                            objAccompMaster = DBHelper.sharedInstance.getAccompanistDetailsByRegionCode(regionCode: model.Acc_Region_Code)
                            
                            if (objAccompMaster == nil)
                            {
                                if(model.Acc_Region_Name != nil && model.Acc_Region_Name != EMPTY)
                                {
                                    tpPreFillAlert.append("Selected Region: \(model.Acc_Region_Name ?? EMPTY)  is inactive")
                                }
                                else
                                {
                                tpPreFillAlert.append("One of the Selected Ride Along Region is inactive")
                                }
                                insertData = false
                            }
                        }
                        
                        if (insertData)
                        {
                            let dictionary : NSMutableDictionary = [:]
                            dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                            dictionary.setValue(EMPTY, forKey: "DCR_Code")
                            dictionary.setValue(model.Acc_Region_Code, forKey: "Acc_Region_Code")
                            
                            if (filteredArray.count > 0)
                            {
                                dictionary.setValue(model.Acc_User_Code, forKey: "Acc_User_Code")
                                dictionary.setValue(model.Acc_User_Name, forKey: "Acc_User_Name")
                                dictionary.setValue(model.Acc_User_Type_Name, forKey: "Acc_User_Type_Name")
                                dictionary.setValue(filteredArray.first?.Employee_name, forKey: "Employee_Name")
                            }
                            else
                            {
                                dictionary.setValue(objAccompMaster!.User_Code, forKey: "Acc_User_Code")
                                dictionary.setValue(objAccompMaster!.User_Name, forKey: "Acc_User_Name")
                                dictionary.setValue(objAccompMaster!.User_Type_Name, forKey: "Acc_User_Type_Name")
                                dictionary.setValue(objAccompMaster!.Employee_name, forKey: "Employee_Name")
                                
                                
                                resignedAccompanists.append(getMessageForResignedAccompanists(oldUserName: model.Acc_User_Name, newUserName: objAccompMaster!.User_Name, regionName: objAccompMaster!.Region_Name))
                                
                                tpPreFillAlert.append(getMessageForResignedAccompanists(oldUserName: model.Acc_User_Name, newUserName: objAccompMaster!.User_Name, regionName: objAccompMaster!.Region_Name))
                            }
                            
                            if (dictionary.value(forKey: "Acc_User_Code") as! String == VACANT || dictionary.value(forKey: "Acc_User_Code")  as! String == NOT_ASSIGNED)
                            {
                                dictionary.setValue("1", forKey: "Is_Only_For_Doctor")
                            }
                            else
                            {
                                dictionary.setValue(model.Is_Only_For_Doctor, forKey: "Is_Only_For_Doctor")
                            }
                            
                            //                            dictionary.setValue("1", forKey: "Is_Only_For_Doctor")
                            
                            let isTPFreezed = isFrozenTP(flag: flag, date: convertDateIntoServerStringFormat(date: selectedDate))
                            dictionary.setValue(isTPFreezed, forKey: "Is_TP_Frozen")
                            
                            accompArr.add(dictionary)
                        }
                    }
                    
                    DBHelper.sharedInstance.insertDCRAccompanistsDetails(array: accompArr)
                }
            }
            else if flag == DCRFlag.attendance.rawValue
            {
                let dictionary : NSMutableDictionary = [:]
                let model = tpModelList[0]
                
                dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                dictionary.setValue(convertDateIntoServerStringFormat(date: selectedDate), forKey: "DCR_Actual_Date")
                dictionary.setValue(model.Project_Code, forKey: "Project_Code")
                dictionary.setValue(model.Activity_Code, forKey: "Activity_Code")
                dictionary.setValue(EMPTY, forKey: "Start_Time")
                dictionary.setValue(EMPTY, forKey: "End_Time")
                dictionary.setValue(model.Remarks, forKey: "Remarks")
                dictionary.setValue(EMPTY, forKey: "DCR_Code")
                
                let activityArr : NSMutableArray = []
                activityArr.add(dictionary)
                
                DBHelper.sharedInstance.insertAttendanceActivities(array: activityArr)
            }
            
            let tpSFCList = DBHelper.sharedInstance.getTPTravelledPlaceForTPId(tpEntryId: tpModelList.first!.TP_Entry_Id)
            
            if tpSFCList.count > 0
            {
                BL_SFC.sharedInstance.insertTPSFCDetails(tpSFC: tpSFCList)
            }
            
            let sfcExpired = BL_Stepper.sharedInstance.doAllSFCValidations()
            
            
            if(sfcExpired != EMPTY)
            {
               tpPreFillAlert.append("One of Your entered route is not available in your SFC master or may be expired.")

            }
            
            
        }
        
        

//        if (tpId > 0)
//        {
//            automaticPrefillHeader(objTPHeader: tpModelList.first!)
//        }
//        else
//        {
//            automaticPrefillHeader(objTPHeader: nil)
//        }
//        
//        automaticSFCPrefill()

    }
    
    private func getDCRDate() -> String
    {
        return DCRModel.sharedInstance.dcrDateString
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getCustomerEntityType() -> String
    {
        return DCRModel.sharedInstance.customerEntityType
    }
    
     func isFrozenTP(flag: Int, date: String) -> Int
    {
        var isFreezed: Int = 0
        
        if (flag == DCRFlag.fieldRcpa.rawValue)
        {
            let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APPROVED_FIELD_TP_CAN_BE_DEVIATED).uppercased()
            
            if (privValue == PrivilegeValues.NO.rawValue)
            {
                let approvedTPCount = DBHelper.sharedInstance.getApprovedTPCount(tpDate: date)
                
                if (approvedTPCount > 0)
                {
                    let unfreezeCount = DBHelper.sharedInstance.getUnfreezedTPCount(tpDate: date)
                    
                    if (unfreezeCount == 0)
                    {
                        isFreezed = 1
                    }
                }
            }
        }
        
        return isFreezed
    }
    
    private func automaticPrefillHeader(objTPHeader: TourPlannerHeader?)
    {
        if (DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            let dcrDate = getDCRDate()
            let eDetailedAnayticsList = DBHelper.sharedInstance.getAssetAnayticsByDate(dcrDate: dcrDate)
            
            if (eDetailedAnayticsList.count > 0)
            {
                let startTime = eDetailedAnayticsList.first!.Detailed_StartTime
                let endTime = eDetailedAnayticsList.last!.Detailed_EndTime
                var startTimeString: String = EMPTY
                var endTimeString: String = EMPTY
                var categoryCode: String = EMPTY
                var categoryName: String = EMPTY
                var categoryId: Int = 0
                var workPlace: String = EMPTY
                
                startTimeString = getTimeIn12HrFormat(date: getDateFromString(dateString: startTime!), timeZone: NSTimeZone.local)
                endTimeString = getTimeIn12HrFormat(date: getDateFromString(dateString: endTime!), timeZone: NSTimeZone.local)
                
                if (objTPHeader != nil)
                {
                    if (objTPHeader!.Activity_Code!.uppercased() == "FIELD_RCPA" || objTPHeader!.Activity_Code!.uppercased() == "FIELD")
                    {
                        if (checkNullAndNilValueForString(stringData: objTPHeader!.Category_Code) != EMPTY)
                        {
                            categoryCode = objTPHeader!.Category_Code
                            categoryName = objTPHeader!.Category_Name!
                            
                            if (objTPHeader!.Category_Id != nil)
                            {
                                categoryId = objTPHeader!.Category_Id!
                            }
                            
                            if (objTPHeader!.Work_Place != nil)
                            {
                                workPlace = objTPHeader!.Work_Place!
                            }
                        }
                    }
                }
                
                if (checkNullAndNilValueForString(stringData: categoryName) == EMPTY)
                {
                    let categoryList = BL_WorkPlace.sharedInstance.getWorkCategoriesList()
                    
                    if (categoryList.count > 0)
                    {
                        let filteredArray = categoryList.filter{
                            $0.Category_Name.uppercased() == "HQ"
                        }
                        
                        if (filteredArray.count > 0)
                        {
                            categoryCode = filteredArray.first!.Category_Code
                            categoryName = filteredArray.first!.Category_Name
                            categoryId = filteredArray.first!.Category_Id
                        }
                    }
                }
                
                if (workPlace == EMPTY)
                {
                    workPlace = getRegionName()
                }
                
                let dict: NSDictionary = ["DCR_Status": String(DCRStatus.drafted.rawValue), "Category_Id": categoryId, "Category_Name": categoryName, "Start_Time": startTimeString, "End_Time": endTimeString, "DCR_Actual_Date": dcrDate, "Dcr_Entered_Date": dcrDate, "Place_Worked": workPlace, "Flag": DCRFlag.fieldRcpa.rawValue]
                let objDCRHeader: DCRHeaderModel = DCRHeaderModel(dict: dict)
                
                objDCRHeader.DCR_Id = DCRModel.sharedInstance.dcrId
                
                DBHelper.sharedInstance.updateDCRWorkPlaceDetailForAutomatic(dcrHeaderObj: objDCRHeader)
                
                DCRModel.sharedInstance.dcrStatus = DCRStatus.drafted.rawValue
                DCRModel.sharedInstance.expenseEntityCode = categoryCode
                DCRModel.sharedInstance.expenseEntityName = categoryName
            }
        }
    }
    
    private func automaticSFCPrefill()
    {
        if (DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            let dcrDate = getDCRDate()
            let eDetailedAnayticsList = DBHelper.sharedInstance.getLocalAreaFromAssetAnaytics(dcrDate: dcrDate)
            
            if (eDetailedAnayticsList.count > 0)
            {
                var placeList: [SFCPrefillModel] = []
                var objPrefill: SFCPrefillModel = SFCPrefillModel();
                var lastPlace: String = EMPTY
                
                objPrefill.From_Place = eDetailedAnayticsList.first!.Local_Area!
                objPrefill.To_Place = EMPTY
                placeList.append(objPrefill)
                
                lastPlace = eDetailedAnayticsList.first!.Local_Area!
                
                let count = eDetailedAnayticsList.count
                
                if (count > 1)
                {
                    for i in 1..<count
                    {
                        if (lastPlace.uppercased() != eDetailedAnayticsList[i].Local_Area!.uppercased())
                        {
                            placeList.last!.To_Place = eDetailedAnayticsList[i].Local_Area
                            
                            objPrefill = SFCPrefillModel()
                            objPrefill.From_Place = eDetailedAnayticsList[i].Local_Area
                            objPrefill.To_Place = EMPTY
                            placeList.append(objPrefill)
                            
                            lastPlace = objPrefill.From_Place
                        }
                    }
                }
                
                placeList.last!.To_Place = placeList.first!.From_Place
                
                var sfcObj: SFCMasterModel?
                var dcrSFCList:[DCRTravelledPlacesModel] = []
                
                for placeObj in placeList
                {
                    sfcObj = nil
                    sfcObj = DAL_SFC.sharedInstance.getSFCDetailsBasedonPlaces(fromPlace: placeObj.From_Place, toPlace: placeObj.To_Place, dcrDate: dcrDate)
                    
                    if (sfcObj != nil)
                    {
                        let dcrSFCDict = convertSFCToDCRSFC(objSFC: sfcObj!, placeObj: placeObj)
                        DAL_SFC.sharedInstance.insertSFCDetails(dict: dcrSFCDict)
                        
                        let dcrSFCObj: DCRTravelledPlacesModel = DCRTravelledPlacesModel(dict: dcrSFCDict)
                        dcrSFCList.append(dcrSFCObj)
                    }
                }
                
                if (dcrSFCList.count > 0)
                {
                    automaticPrefillCategory(dcrSFCList: dcrSFCList)
                }
            }
        }
    }
    
    private func automaticPrefillCategory(dcrSFCList:[DCRTravelledPlacesModel])
    {
        let categoriesList = Set(dcrSFCList.map { $0.SFC_Category_Name!})
        var higherCategoryName: String = "HQ"
        var higherCategoryRank: Int = 1
        
        for categoryName in categoriesList
        {
            let rank = getCategoryRank(categoryName: categoryName)
            
            if (rank > higherCategoryRank)
            {
                higherCategoryName = categoryName
                higherCategoryRank = rank
            }
        }
        
        let workCategories = BL_WorkPlace.sharedInstance.getWorkCategoriesList()
        let filteredArray = workCategories.filter{
            $0.Category_Name.uppercased() == higherCategoryName.uppercased()
        }
        
        if (filteredArray.count > 0)
        {
            let objDCRHeader: DCRHeaderObjectModel = DCRHeaderObjectModel()
            
            objDCRHeader.Category_Id = filteredArray.first!.Category_Id
            objDCRHeader.Category_Name = filteredArray.first!.Category_Name
            objDCRHeader.DCR_Status = String(DCRStatus.drafted.rawValue)
            objDCRHeader.DCR_Code = EMPTY
            objDCRHeader.DCR_Id = getDCRId()
            
            DCRModel.sharedInstance.expenseEntityCode = filteredArray.first!.Category_Code
            DCRModel.sharedInstance.expenseEntityName = filteredArray.first!.Category_Name
            DCRModel.sharedInstance.dcrStatus = DCRStatus.drafted.rawValue
            
            DBHelper.sharedInstance.updateDCRWorkCategoryForAutomatic(dcrHeaderObj: objDCRHeader)
        }
    }
    
    private func getCategoryRank(categoryName: String) -> Int
    {
        if (categoryName.uppercased() == "EX HQ")
        {
            return 2
        }
        else if (categoryName.uppercased() == "OS" || categoryName.uppercased() == "OUT STATION" || categoryName.uppercased() == "OUT-STATION")
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    
    private func convertSFCToDCRSFC(objSFC: SFCMasterModel, placeObj: SFCPrefillModel) -> NSDictionary
    {
        let dict1: NSDictionary = ["DCR_Id": getDCRId(), "From_Place": placeObj.From_Place, "To_Place": placeObj.To_Place, "Travel_Mode": objSFC.Travel_Mode, "Distance": String(objSFC.Distance), "SFC_Category_Name": objSFC.Category_Name, "Distance_Fare_Code": objSFC.Distance_Fare_Code]
        
        let dict2: NSDictionary = ["SFC_Version": objSFC.SFC_Version, "Route_Way": EMPTY, "Flag": DCRFlag.fieldRcpa.rawValue, "DCR_Code": EMPTY, "Is_Circular_Route_Complete": 0, "SFC_Region_Code": objSFC.Region_Code]
        
        var combinedAttributes : NSMutableDictionary!
        combinedAttributes = NSMutableDictionary(dictionary: dict1)
        combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
        
        return combinedAttributes
    }
    
    func prefillDoctorsForDCRDate(selectedDate: Date, dcrId: Int)
    {
        //var doctorVisitId = Int()
        let dcrDate = convertDateIntoServerStringFormat(date: selectedDate)
        let eDetailedDoctorList = DBHelper.sharedInstance.getAssetsCustomerByDCRDate(dcrDate: dcrDate)
        
        if eDetailedDoctorList != nil
        {
            let eDetailedDoctorLocation = DBHelper.sharedInstance.getEDDoctorLocationData(dcrDate: dcrDate)
            let doctorVisitModePrivValue = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorVisitMode()
            
            for model in eDetailedDoctorList!
            {
                let checkDoctorExists = DBHelper.sharedInstance.checkDoctorVisitExists(dcrId: dcrId, customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code)
                let visitTimeDetails = getVisitTimeBasedOnAssetAnalytics(objAssetAnalytics: model)
                var visitMode = visitTimeDetails.0
                var visitTime = visitTimeDetails.1
                
                if (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
                {
                    if (doctorVisitModePrivValue == PrivilegeValues.AM_PM.rawValue)
                    {
                        visitTime = EMPTY
                    }
                }
                else
                {
                    let locationFilter = eDetailedDoctorLocation.filter{
                        $0.Customer_Code == model.Customer_Code && $0.Customer_Region_Code == model.Customer_Region_Code
                    }
                    if(locationFilter.count > 0)
                    {
                        let getVisiDetails = DBHelper.sharedInstance.getEdetailingSyncedDateAndTime(customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code, dcrActualDate: DCRModel.sharedInstance.dcrDateString)
                        if(getVisiDetails != nil && getVisiDetails != EMPTY)
                        {
                            let visitTimeArray = getVisiDetails.components(separatedBy: " ")
                            if(visitTimeArray.count > 1)
                            {
                                let visitTimes = visitTimeArray[1].components(separatedBy: ":")
                                visitTime = visitTimes[0] + ":" + visitTimes[1] + " " + visitTimeArray[2]
                                visitMode = visitTimeArray[2]
                            }
                            else
                            {
                                visitMode = visitTimeDetails.0
                                visitTime = visitTimeDetails.1
                            }
                        }
                        else
                        {
                            visitMode = visitTimeDetails.0
                            visitTime = visitTimeDetails.1
                        }
                    }
                    else
                    {
                        visitMode = visitTimeDetails.0
                        visitTime = visitTimeDetails.1
                    }
                    
                    
                }
                if checkDoctorExists == 0
                {
                    let doctorObj = BL_DCR_Doctor_Visit.sharedInstance.getCustomerMasterByCustomerCode(customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code)
                    
                    let isCPDoc = BL_DCR_Doctor_Visit.sharedInstance.isCPDoctor(doctorCode: model.Customer_Code, doctorRegionCode: model.Customer_Region_Code)
                    let isAccDoc = BL_DCR_Doctor_Visit.sharedInstance.isAccompanistDoctor(doctorRegionCode: model.Customer_Region_Code)
                    var latitude: String = ""
                    var longitude: String = ""
                    let locationFilter = eDetailedDoctorLocation.filter{
                        $0.Customer_Code == model.Customer_Code && $0.Customer_Region_Code == model.Customer_Region_Code
                    }
                    var geoFencingDeviationRemarks: String = EMPTY
                    
                    if (locationFilter.count > 0)
                    {
                        latitude = String(locationFilter.first!.Latitude)
                        longitude = String(locationFilter.first!.Longitude)
                        geoFencingDeviationRemarks = locationFilter.first!.Geo_Fencing_Deviation_Remarks
                    }
                    
                    let dict1: [String: Any] = ["DCR_Id": "\(dcrId)", "Doctor_Id": doctorObj?.Customer_Id ?? 0, "Doctor_Code": model.Customer_Code, "Doctor_Region_Code": model.Customer_Region_Code, "Doctor_Name": model.Customer_Name, "Speciality_Name": model.Customer_Speciality_Name, "MDL_Number": model.MDL_Number ?? "", "Hospital_Name": model.Hospital_Name ?? "", "Category_Code": model.Customer_Category_Code ?? "","Customer_Met_StartTime":model.Punch_Start_Time , "Customer_Met_EndTime":model.Punch_End_Time , "Punch_OffSet": model.Punch_Offset, "Punch_TimeZone": model.Punch_TimeZone, "UTC_DateTime": model.Punch_UTC_DateTime, "Punch_Status": model.Punch_Status]
                    
                    let dict2: [String: Any] = ["Category_Name": model.Customer_Category_Name ?? "", "Visit_Mode": visitMode, "Visit_Time": visitTime, "POB_Amount": 0.0, "Is_CP_Doc": isCPDoc, "Is_Acc_Doctor": isAccDoc, "Remarks": EMPTY, "Lattitude": latitude, "Longitude": longitude, "Doctor_Region_Name": doctorObj?.Region_Name ?? "", "Local_Area": model.Local_Area ?? "", "Sur_Name": model.Sur_Name ?? "", "Geo_Fencing_Deviation_Remarks": geoFencingDeviationRemarks, "Geo_Fencing_Page_Source": Constants.Geo_Fencing_Page_Names.EDETAILING]
                    
                    let doctorDict: NSMutableDictionary = [:]
                    doctorDict.addEntries(from: dict1)
                    doctorDict.addEntries(from: dict2)
                    
                    let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
                    let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
                    
                    self.insertEDetailedProducts(customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code, doctorVisitId: doctorVisitId, dcrId: dcrId)
                    
                    
                    
//                    if (model.Customer_Code == EMPTY) && (model.Customer_Region_Code == EMPTY) && (dcrId == 0)
//                    {
                    
                    var list: [DCRAccompanistModel] = []

                    try? dbPool.read { db in

                        let accompanistData = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ? AND Employee_Name != 'VACANT' AND Employee_Name != 'NOT ASSIGNED'  ", arguments: [dcrId])

                        list = accompanistData

                    }

                                for j in list

                                {

                                    if list.count > 0
                                    {
                                        let dict: NSDictionary = ["DCR_Id": dcrId, "Acc_Region_Code": j.Acc_Region_Code, "Acc_User_Code": j.Acc_User_Code , "Acc_User_Name": j.Acc_User_Name, "Acc_User_Type_Name": j.Acc_User_Type_Name, "Employee_Name":j.Employee_Name,"Visit_ID": doctorVisitId]

                                        let dcrAccompanistModelObj: DCRDoctorAccompanist = DCRDoctorAccompanist(dict: dict)
                                        DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanistObj: dcrAccompanistModelObj)
                                    }


                                }
//
//
//                    //}

                        
                    }
                    
                
                else
                {
                    let doctorVisitId = DBHelper.sharedInstance.getDoctorVisitId(dcrId: dcrId, customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code)
                    self.insertEDetailedProducts(customerCode: model.Customer_Code, regionCode: model.Customer_Region_Code, doctorVisitId: doctorVisitId, dcrId: dcrId)
                    self.updateVisitTimeBasedOnAssetAnalytics(visitMode: visitMode, visitTime: visitTime, dcrDoctorVisitId: doctorVisitId)
                }
            }
        }
    }
    
    func insertEDetailedProducts(customerCode: String, regionCode: String, doctorVisitId: Int, dcrId: Int)
    {
        let dcrDate = DCRModel.sharedInstance.dcrDateString!
        let newProducts = DBHelper.sharedInstance.getDayWiseEDetailedProducts(dcrDate: dcrDate, customerCode: customerCode, customerRegionCode: regionCode, status: 1)
        
        if (newProducts.count > 0)
        {
            var dcrDetailedProductsInsertList: [DetailProductMaster] = []
            let dcrDetailedProducts = DBHelper.sharedInstance.getDCRDetailedProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
            
            for objProduct in newProducts
            {
                let filteredArray = dcrDetailedProducts.filter{
                    $0.Product_Code == objProduct.Product_Code
                }
                
                if (filteredArray.count == 0)
                {
                    let dict: NSDictionary = ["Detail_Product_Id": 0, "Product_Code": objProduct.Product_Code, "Product_Name": objProduct.Product_Name, "Speciality_Code": EMPTY]
                    let objDetailedProduct: DetailProductMaster = DetailProductMaster(dict: dict)
                    let objWrapper: DCRDetailedProductsWrapperModel = DCRDetailedProductsWrapperModel()
                    objWrapper.businessPotential = defaultBusinessPotential
                    objWrapper.businessPotential = EMPTY
                    objWrapper.remarks = EMPTY
                    
                    objDetailedProduct.objWrapper = objWrapper
                    
                    dcrDetailedProductsInsertList.append(objDetailedProduct)
                }
            }
            
            BL_DetailedProducts.sharedInstance.insertDetailedProducts(detailedProductList: dcrDetailedProductsInsertList, doctorVisitId: doctorVisitId)
        }
    }
    
    func getCalendarModel()
    {
        if dcrCalendarModel.count > 0
        {
            dcrCalendarModel.removeAll()
        }
        
        dcrCalendarModel = DBHelper.sharedInstance.getDCRCalendarDetails()
        
        if dcrCalendarModel.count == 0
        {
            isEmptyCalendarModel = true
        }
    }
    
    func getHolidayName(dcrDate : Date) -> String
    {
        let holidayName = DBHelper.sharedInstance.getHolidayName(holidayDate: dcrDate)
        
        return holidayName
    }
    
    func getDCRData(date: Date) -> [DCRCalendarModel]
    {
        var dcrCalendarList : [DCRCalendarModel] = []
        
        let paramDate = getServerFormattedDate(date: date)
        
        let filteredDate = dcrCalendarModel.filter {
            $0.Activity_Date == paramDate
        }
        
        if filteredDate.count > 0
        {
            dcrCalendarList = filteredDate
        }
        
        return dcrCalendarList
    }
    
    func getDCRDetails(date : Date) -> [DCRDetail]?
    {
        var dcrDetailList : [DCRDetail]? = []
        let dcrHeaderList : [DCRHeaderModel] = DBHelper.sharedInstance.getDCRDetails(dcrDate: date)!
        let dcrCalendarList: [DCRCalendarModel] = DBHelper.sharedInstance.getDCRCalendarDetails()
        
        for dcrHeaderData in dcrHeaderList
        {
            let dcrDetailData : DCRDetail = DCRDetail()
            dcrDetailData.dcrId = dcrHeaderData.DCR_Id
            dcrDetailData.dcrFlag = dcrHeaderData.Flag
            dcrDetailData.dcrCode = dcrHeaderData.DCR_Code
            dcrDetailData.dcrStatus = Int(dcrHeaderData.DCR_Status)
            dcrDetailData.workPlace = dcrHeaderData.Place_Worked
            dcrDetailData.cpName = dcrHeaderData.CP_Name
            dcrDetailData.unapprovedBy = dcrHeaderData.Unapprove_Reason
            dcrDetailData.isLocked = 0
            dcrDetailData.selectedDate = date
            
            let filteredArray = dcrCalendarList.filter{
                ($0.Is_Field_Lock == 1 || $0.Is_Attendance_Lock == 1 || $0.Is_LockLeave == 1)  && $0.Activity_Date_In_Date == dcrHeaderData.DCR_Actual_Date
            }
            
            if (filteredArray.count > 0)
            {
                dcrDetailData.isLocked = 1
            }
            
            if dcrDetailData.dcrStatus != -1
            {
                dcrDetailData.categoryName = dcrHeaderData.Category_Name
                let categoryModel = DBHelper.sharedInstance.getCategoryDataforCategoryName(categoryName: dcrDetailData.categoryName!)
                if categoryModel.count > 0
                {
                    dcrDetailData.categoryCode = categoryModel[0].Category_Code
                }
            }
            
            if dcrHeaderData.Flag == DCRFlag.fieldRcpa.rawValue
            {
                dcrDetailData.doctorVisitCount = DBHelper.sharedInstance.getDCRDoctorVisits(dcrId: dcrHeaderData.DCR_Id)
                dcrDetailData.doctorPendingVisitCount = BL_Stepper.sharedInstance.getPendingDoctorVisitCount(dcrDate: date, dcrId: dcrHeaderData.DCR_Id)
                dcrDetailData.chemistEntryCount = DBHelper.sharedInstance.getDCRChemistEntry(dcrId: dcrHeaderData.DCR_Id)
                dcrDetailData.stockiestEntryCount = DBHelper.sharedInstance.getStockiestEntry(dcrId: dcrHeaderData.DCR_Id)
                dcrDetailData.rcpaEntryCount = DBHelper.sharedInstance.getRCPAEntry(dcrId: dcrHeaderData.DCR_Id)
                dcrDetailData.expensesEntryCount = DBHelper.sharedInstance.getExpensesEntry(dcrId: dcrHeaderData.DCR_Id)
            }
            
            if dcrHeaderData.Flag == DCRFlag.attendance.rawValue
            {
                dcrDetailData.attendanceActivityCount = DBHelper.sharedInstance.getDCRAttendanceActivity(dcrDate: date)
            }
            
            if dcrHeaderData.Flag == DCRFlag.leave.rawValue
            {
                dcrDetailData.leaveName = DBHelper.sharedInstance.getLeaveName(leaveTypeCode: dcrHeaderData.Leave_Type_Code)
                //                dcrDetailData.unapprovedReason = dcrHeaderData.Reason
            }
            
            dcrDetailList?.append(dcrDetailData)
        }
        
        return dcrDetailList
    }
    
    func isAddBtnHidden(date : Date) -> Bool
    {
        var flag : Bool = false
        var activityCount : Int = 0
        var isLockLeave : Int = 0
        //var isWeekEnd : Int = 0
        //var isHoliday : Int = 0
        
        if dcrLWHAModel.count > 0
        {
            activityCount = dcrLWHAModel[0].Activity_Count
            if(dcrLWHAModel[0].Is_LockLeave == 1)
            {
                isLockLeave = 1
            }
            else
            {
                isLockLeave = 0
            }
//            isWeekEnd = dcrLWHAModel[0].Is_WeekEnd
//            isHoliday = dcrLWHAModel[0].Is_Holiday
        }
        
        let payrollIntegratedVal : String = getPayrollIntegratedVal()
        let entryValList = getDCROptionPrivVal()
        let currentDate = getServerFormattedDate(date: getCurrentDateAndTime())
        let paramDate = getServerFormattedDate(date: date)
        let leaveEntryVal : String = getLeaveEntryConfigVal()
        
        if activityCount == 2 || isLockLeave  == 1 || (currentDate.compare(paramDate) == .orderedAscending && payrollIntegratedVal == ConfigValues.YES.rawValue) || (currentDate.compare(paramDate) == .orderedAscending && !entryValList.contains(PrivilegeValues.LEAVE.rawValue))
        {
            flag = true
        }
        
        if activityCount == 1 && leaveEntryVal == PrivilegeValues.FULL_DAY.rawValue
        {
            let leaveStatus = DBHelper.sharedInstance.getLeaveStatus(dcrDate: paramDate)
            if leaveStatus > 0
            {
                flag = true
            }
        }
        
        if currentDate.compare(paramDate) == .orderedAscending
        {
            let leaveStatus = DBHelper.sharedInstance.isLeaveApplied(dcrDate: paramDate)
            if leaveStatus > 0
            {
                flag = true
            }
            
            if getFutureLeaveAvailable().uppercased() == "NO"
            {
                flag = true
            }
            
        }
        
        let validationMsg : String = BL_DCRCalendar.sharedInstance.getActivityPerDayValidation()
        if validationMsg != ""
        {
            flag = true
        }
        
        return flag
    }
    
    func isLockDCR(date: Date) -> Bool
    {
        var flag : Bool = false
        
        if dcrLWHAModel.count > 0
        {
            dcrLWHAModel.removeAll()
        }
        
        dcrLWHAModel = DBHelper.sharedInstance.getDcrLWHAStatus(dcrDate: date)!
        
        if dcrLWHAModel.count > 0
        {
            let isLockLeave = dcrLWHAModel[0].Is_LockLeave as Int
            let isFieldLeave = dcrLWHAModel[0].Is_Field_Lock as Int
            let isAttendanceLeave = dcrLWHAModel[0].Is_Attendance_Lock as Int
            
            if isFieldLeave == 1 || isAttendanceLeave == 1 || isLockLeave == 1
            {
                flag = true
            }
        }
        
        return flag
    }
    
    func getFutureLeaveAvailable() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.FUTURE_LEAVE_ALLOW_IN_DCR).uppercased()
    }
    
    func dcrCategoryValidation(date: Date) -> NSArray
    {
        let entryValList = getDCROptionPrivVal()
        var activityCount : Int = 0
        let array:NSMutableArray = []
        let currentDate = getServerFormattedDate(date: getCurrentDateAndTime())
        let paramDate = getServerFormattedDate(date: date)
        
        if currentDate.compare(paramDate) == .orderedAscending
        {
            if entryValList.contains(PrivilegeValues.LEAVE.rawValue)
            {
                array.add(DCRActivityName.leave.rawValue)
            }
        } else {
            if dcrLWHAModel.count > 0
            {
                activityCount = dcrLWHAModel[0].Activity_Count
            }
            let flag = DBHelper.sharedInstance.getDCRFlag(dcrDate: date)
            if activityCount == 1
            {
                if flag == DCRFlag.leave.rawValue
                {
                    if entryValList.contains(PrivilegeValues.FIELD_RCPA.rawValue)
                    {
                        array.add(DCRActivityName.fieldRcpa.rawValue)
                    }
                    
                    if entryValList.contains(PrivilegeValues.ATTENDANCE.rawValue)
                    {
                        array.add(DCRActivityName.attendance.rawValue)
                    }
                } else if flag == DCRFlag.fieldRcpa.rawValue
                {
                    if entryValList.contains(PrivilegeValues.ATTENDANCE.rawValue)
                    {
                        array.add(DCRActivityName.attendance.rawValue)
                    }
                    
                    if !isLeaveCategoryHidden(date: paramDate) && entryValList.contains(PrivilegeValues.LEAVE.rawValue)
                    {
                        array.add(DCRActivityName.leave.rawValue)
                    }
                    
                } else if flag == DCRFlag.attendance.rawValue
                {
                    if entryValList.contains(PrivilegeValues.FIELD_RCPA.rawValue)
                    {
                        array.add(DCRActivityName.fieldRcpa.rawValue)
                    }
                    
                    if !isLeaveCategoryHidden(date: paramDate) && entryValList.contains(PrivilegeValues.LEAVE.rawValue)
                    {
                        array.add(DCRActivityName.leave.rawValue)
                    }
                }
            } else
            {
                if isLeaveCategoryHidden(date: paramDate)
                {
                    if entryValList.contains(PrivilegeValues.FIELD_RCPA.rawValue)
                    {
                        array.add(DCRActivityName.fieldRcpa.rawValue)
                    }
                    
                    if entryValList.contains(PrivilegeValues.ATTENDANCE.rawValue)
                    {
                        array.add(DCRActivityName.attendance.rawValue)
                    }
                    //LEAVE
                    if entryValList.contains(PrivilegeValues.LEAVE.rawValue)
                    {
                        array.add(DCRActivityName.leave.rawValue)
                    }
                } else
                {
                    if entryValList.contains(PrivilegeValues.FIELD_RCPA.rawValue)
                    {
                        array.add(DCRActivityName.fieldRcpa.rawValue)
                    }
                    
                    if entryValList.contains(PrivilegeValues.ATTENDANCE.rawValue)
                    {
                        array.add(DCRActivityName.attendance.rawValue)
                    }
                    
                    if entryValList.contains(PrivilegeValues.LEAVE.rawValue)
                    {
                        array.add(DCRActivityName.leave.rawValue)
                    }
                }
            }
        }
        
        return array
    }
    
    func isLeaveCategoryHidden(date : Date) -> Bool
    {
        var flag : Bool = false
        var isWeekEnd : Int = 0
        var isHoliday : Int = 0
        var activityCount : Int = 0
        let leaveEntryVal : String = getLeaveEntryConfigVal()
        var dcrStatus: Int = -1
        let dcrFlag = DBHelper.sharedInstance.getDCRFlag(dcrDate: date)
        
        if dcrLWHAModel.count > 0
        {
            isWeekEnd = dcrLWHAModel[0].Is_WeekEnd
            isHoliday = dcrLWHAModel[0].Is_Holiday
            activityCount = dcrLWHAModel[0].Activity_Count
            dcrStatus = dcrLWHAModel[0].DCR_Status
        }
        
        if getPayrollIntegratedVal() == ConfigValues.YES.rawValue || isWeekEnd == 1 || isHoliday == 1 || (activityCount == 1 && leaveEntryVal == PrivilegeValues.FULL_DAY.rawValue && dcrStatus != DCRStatus.unApproved.rawValue && dcrFlag != DCRFlag.leave.rawValue)
        {
            flag = true
        }
        
        return flag
    }
    
    func getActivityPerDayValidation() -> String
    {
        var message : String = ""
        
        let activityConfigVal = getActivityPerDayConfigVal()
        
        if activityConfigVal == PrivilegeValues.SINGLE.rawValue
        {
            if dcrLWHAModel.count > 0
            {
                if dcrLWHAModel[0].Activity_Count == 1
                {
                    message = activityConfigErrorMsg
                }
            }
        }
        
        return message
    }
    
    func activityRestrictionValidation(dcrDate : Date) -> Bool
    {
        var flag : Bool = false
        
        let activityConfigVal = getActivityPerDayConfigVal()
        let getApprovedCount = DBHelper.sharedInstance.getApprovedStatus(dcrDate: dcrDate)
        
        if activityConfigVal == PrivilegeValues.RESTRICTED.rawValue && getApprovedCount > 0
        {
            flag = true
        }
        
        return flag
    }
    
    func isUnapprovedEditBtnHidden(dcrDate : Date,isAttendanceLock:Bool,isLockLeave:Bool) -> Bool
    {
        var flag : Bool = false
        
        if dcrLWHAModel.count > 0
        {
            let activityCount = dcrLWHAModel[0].Activity_Count
            
            if activityCount == 2
            {
                let leaveEntryVal = getLeaveEntryConfigVal()
                let activityConfigVal = getActivityPerDayConfigVal()
                let unApprovedCount = DBHelper.sharedInstance.getUnapprovedCount(dcrDate: dcrDate)
                let leaveStatus = DBHelper.sharedInstance.getLeaveStatus(dcrDate: dcrDate)
                let getLeaveUnapprovedStatus = DBHelper.sharedInstance.getLeaveUnapprovedStatus(dcrDate: dcrDate)
                
                if (leaveEntryVal == PrivilegeValues.FULL_DAY.rawValue && leaveStatus > 0 && unApprovedCount == 1)
                    || (activityConfigVal == PrivilegeValues.SINGLE.rawValue && unApprovedCount == 1)
                    || (leaveEntryVal == PrivilegeValues.FULL_DAY.rawValue && getLeaveUnapprovedStatus > 0 && unApprovedCount == 1)
                {
                    flag = true
                }
            }
        }
        
        if (!flag)
        {
            let calendarList = DBHelper.sharedInstance.getDCRCalendarDetails()
            var filteredArray : [DCRCalendarModel] = []
            if(!isLockLeave)
            {
                if(isAttendanceLock)
                {
                    filteredArray = calendarList.filter{
                        $0.Is_Attendance_Lock == 1 && $0.Activity_Date_In_Date == dcrDate
                    }
                }
                else
                {
                    filteredArray = calendarList.filter{
                        $0.Is_Field_Lock == 1 && $0.Activity_Date_In_Date == dcrDate
                    }
                }
            }
            else
            {
                filteredArray = calendarList.filter{
                    $0.Is_LockLeave == 1 && $0.Activity_Date_In_Date == dcrDate
                }
            }
            
            if (filteredArray.count > 0)
            {
                flag = true
            }
        }
        
        return flag
    }
    
    private func isLessthanHidoctorStartDate(dateToCompare: Date)-> Bool
    {
        var userStartDate = Date()
        
        userStartDate = getUserStartDate()
        
        if (userStartDate <= dateToCompare)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func getSequentialEntryValidation(startDate : Date, endDate: Date, isEditMode: Bool) -> String
    {
        var modifiedStartDate : Date = startDate
        let userStartDate : Date = getUserStartDate()
        
        if userStartDate.compare(startDate) == .orderedDescending
        {
            modifiedStartDate = userStartDate
        }
        
        let dictionary = BL_DCRCalendar.sharedInstance.getCPNMonth()
        var monthStartDate = dictionary.value(forKey: "startDate") as! Date
        
        if isLessthanHidoctorStartDate(dateToCompare: monthStartDate)
        {
            monthStartDate = userStartDate
        }
        
        var message : String = ""
        let privValList : [String] = self.getSequentialEntryPrivVal()
        
        if (privValList.contains(PrivilegeValues.YES.rawValue) && privValList.contains(PrivilegeValues.DRAFTED_DCR.rawValue))
        {
            let dataCountFirstSet : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDate(startDate: modifiedStartDate, endDate: endDate)
            if dataCountFirstSet.count > 0
            {
                let model : DCRCalendarModel = dataCountFirstSet[0] as DCRCalendarModel
                message = "\(seqValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqValidSuffixErrorMsg)"
            }
            
            if message == ""
            {
                if (getUnapprovedinSeqConfigVal() == ConfigValues.YES.rawValue)
                {
                    let dataCount : [DCRHeaderModel] = DBHelper.sharedInstance.getSeqDCREntryUnapprovedValid(startDate: modifiedStartDate, endDate: endDate)
                    if dataCount.count > 0
                    {
                        let model : DCRHeaderModel = dataCount[0] as DCRHeaderModel
                        message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.DCR_Actual_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                    }
                }
            }
            
            if message == ""
            {
                let dataCountSecondSet : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDraftValid(startDate: modifiedStartDate, endDate: endDate)
                
                if dataCountSecondSet.count > 0
                {
                    let model : DCRCalendarModel = dataCountSecondSet[0] as DCRCalendarModel
                    message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                }
            }
            
        }
        else if privValList.contains(PrivilegeValues.YES.rawValue)
        {
            let dataCount : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDate(startDate: modifiedStartDate, endDate: endDate)
            if dataCount.count > 0
            {
                let model : DCRCalendarModel = dataCount[0] as DCRCalendarModel
                message = "\(seqValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqValidSuffixErrorMsg)"
            }
            
            if message == ""
            {
                if (getUnapprovedinSeqConfigVal() == ConfigValues.YES.rawValue)
                {
                    let dataCount : [DCRHeaderModel] = DBHelper.sharedInstance.getSeqDCREntryUnapprovedValid(startDate: modifiedStartDate, endDate: endDate)
                    if dataCount.count > 0
                    {
                        let model : DCRHeaderModel = dataCount[0] as DCRHeaderModel
                        message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.DCR_Actual_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                    }
                }
            }
        }
        else if (privValList.contains(PrivilegeValues.MONTH_CHECK.rawValue) && privValList.contains(PrivilegeValues.DRAFTED_DCR.rawValue))
        {
            let dataCountFirstSet : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDate(startDate: monthStartDate, endDate: endDate)
            if dataCountFirstSet.count > 0
            {
                let model : DCRCalendarModel = dataCountFirstSet[0] as DCRCalendarModel
                message = "\(seqValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqValidSuffixErrorMsg)"
            }
            
            if message == ""
            {
                if (getUnapprovedinSeqConfigVal() == ConfigValues.YES.rawValue)
                {
                    let dataCount : [DCRHeaderModel] = DBHelper.sharedInstance.getSeqDCREntryUnapprovedValid(startDate: monthStartDate, endDate: endDate)
                    if dataCount.count > 0
                    {
                        let model : DCRHeaderModel = dataCount[0] as DCRHeaderModel
                        message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.DCR_Actual_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                    }
                }
            }
            
            if message == ""
            {
                let dataCountSecondSet : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDraftValid(startDate: monthStartDate, endDate: endDate)
                
                if dataCountSecondSet.count > 0
                {
                    let model : DCRCalendarModel = dataCountSecondSet[0] as DCRCalendarModel
                    message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                }
            }
        }
        else if privValList.contains(PrivilegeValues.MONTH_CHECK.rawValue)
        {
            let dataCount : [DCRCalendarModel] = DBHelper.sharedInstance.getSeqDCREntryDate(startDate: monthStartDate, endDate: endDate)
            
            if dataCount.count > 0
            {
                let model : DCRCalendarModel = dataCount[0] as DCRCalendarModel
                message = "\(seqValidPrefixErrorMsg) \(convertDateIntoString(date: model.Activity_Date)). \(seqValidSuffixErrorMsg)"
            }
            
            if message == ""
            {
                if (getUnapprovedinSeqConfigVal() == ConfigValues.YES.rawValue)
                {
                    
                    let dataCount : [DCRHeaderModel] = DBHelper.sharedInstance.getSeqDCREntryUnapprovedValid(startDate: monthStartDate, endDate: endDate)
                    if dataCount.count > 0
                    {
                        let model : DCRHeaderModel = dataCount[0] as DCRHeaderModel
                        message = "\(seqDCRStatusValidPrefixErrorMsg) \(convertDateIntoString(date: model.DCR_Actual_Date)). \(seqDCRStatusValidSuffixErrorMsg)"
                    }
                }
            }
        }
        
        if (message == EMPTY)
        {
            if (!isEditMode)
            {
                message = doOfflineDCRCountValidation()
            }
        }
        
        return message
    }
    
    func doOfflineDCRCountValidation() -> String
    {
        let allowedDCRCount = getAllowedOfflineDCRCount()
        let availableDCRCount = DBHelper.sharedInstance.getPendingDCRCountForValidation(previousMonthDate:getPreviousMonth(date: Date()))
        
        if (availableDCRCount >= allowedDCRCount)
        {
            return "You have some pending DVR(s) to be uploaded/submit. Please complete those DVR(s) before entering new DVR"
        }
        else
        {
            return EMPTY
        }
    }
    
    private func getAllowedOfflineDCRCount() -> Int
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.NUMBER_OF_OFFLINE_DCR_ALLOWED)
        
        return Int(privValue)!
    }
    
    func getUnapprovedTextformat(text : String?) -> String
    {
        let trimmedText = text?.replacingOccurrences(of: "^", with: "")
        let splittedStringArr : [String] = trimmedText!.components(separatedBy: "~")
        var outputString : String = ""
        for i in 0..<splittedStringArr.count
        {
            if i == splittedStringArr.count - 1
            {
                outputString = outputString + splittedStringArr[i]
            }
            else
            {
                outputString = outputString + splittedStringArr[i] + "\nReason: "
            }
        }
        
        return outputString
    }
    
    func getLastEnteredDate() -> Date
    {
        var enteredDate : Date!
        
        let calendarList = DBHelper.sharedInstance.getLastEnteredDate()
        if calendarList.count > 0
        {
            enteredDate = Calendar.current.date(byAdding: .day, value: 1, to: calendarList[0].Activity_Date)
        }
        else
        {
            enteredDate = getUserStartDate()
        }
        
        return enteredDate
    }
    
    // Get Privilages & configurations values
    func getDCROptionPrivVal() -> [String]
    {
        let dcrEntryOptionPrivVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_ENTRY_OPTIONS).uppercased()
        let privValList : [String] = dcrEntryOptionPrivVal.components(separatedBy: ",")
        return privValList
    }
    
    func getPayrollIntegratedVal() -> String
    {
        let payrollIntegratedVal : String = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.IsPayRollIntegrated).uppercased()
        return payrollIntegratedVal
    }
    
    func getSequentialEntryPrivVal() -> [String]
    {
        let getSequentialEntryPrivVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SEQUENTIAL_DCR_ENTRY).uppercased()
        let privValList : [String] = getSequentialEntryPrivVal.components(separatedBy: ",")
        return privValList
    }
    
    func getActivityPerDayConfigVal() -> String
    {
        let getActivityConfigVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SINGLE_ACTIVITY_PER_DAY).uppercased()
        return getActivityConfigVal
    }
    
    func getLeaveEntryConfigVal() -> String
    {
        let getLeaveConfigVal : String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_ENTRY_MODE).uppercased()
        return getLeaveConfigVal
    }
    
    func getUnapprovedinSeqConfigVal() -> String
    {
        let getUnapprovedSeqConfigVal : String = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_UNAPPROVED_INCLUDE_IN_SEQ).uppercased()
        return getUnapprovedSeqConfigVal
    }
    
    //MARK:- TP Data download alert
    func canShowTPDownloadAlert(selectedDate: Date) -> Bool
    {
        var showAlert: Bool = false
        
        if (isTpLockPrivilegeEnabled())
        {
            if (isTPAvailableForSelectedDate(selectedDate: selectedDate) == false)
            {
                showAlert = true
            }
        }
        
        return showAlert
    }
    
    func canShowTPDownloadAlertApprovedTP(selectedDate: Date) -> Bool
    {
        var showAlert: Bool = false
        
        if (isApprovedTPAvailableForSelectedDate(selectedDate: selectedDate) == false)
        {
            showAlert = true
        }
        
        return showAlert
    }
    
    
    func downloadTpDataForDate(selectedDate: Date, completion: @escaping (String) -> ())
    {
        let dateString: String = convertDateIntoServerStringFormat(date: selectedDate)
        
        BL_TPRefresh.sharedInstance.downloadTpData(startDate: dateString, endDate: dateString) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                let tpList = DBHelper.sharedInstance.getTpDataBetweenDates(startDate: dateString, endDate: dateString, status: TPStatus.approved.rawValue)
                
                if (tpList.count > 0)
                {
                    completion("PR data downloaded successfully")
                }
                else
                {
                    completion("No approved PR found")
                }
            }
            else
            {
                completion("Unable to download PR data")
            }
        }
    }
    
    func downloadTpDataForMonth(startDate: Date, endDate: Date, completion: @escaping (String) -> ())
    {
        let startDateString: String = convertDateIntoServerStringFormat(date: startDate)
        let endDateString: String = convertDateIntoServerStringFormat(date: endDate)
        
        BL_TPRefresh.sharedInstance.downloadTpData(startDate: startDateString, endDate: endDateString) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                let tpList = DBHelper.sharedInstance.getTpDataBetweenDates(startDate: startDateString, endDate: endDateString, status: TPStatus.approved.rawValue)
                
                if (tpList.count > 0)
                {
                    completion("PR data downloaded successfully")
                }
                else
                {
                    completion("No approved PR found")
                }
            }
            else
            {
                completion("Unable to download PR data")
            }
        }
    }
    
    func isTpLockPrivilegeEnabled() -> Bool
    {
        var isPrivEnabled: Bool = false
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TP_LOCK_DAY)
        
        if (privValue != EMPTY)
        {
            let lockDay = Int(privValue)
            
            if (lockDay! > 0)
            {
                isPrivEnabled = true
            }
        }
        
        return isPrivEnabled
    }
    
    func isApprovedTPAvailableForSelectedDate(selectedDate: Date) -> Bool
    {
        let count = DBHelper.sharedInstance.getTPCountForTPDate(tpDate: convertDateIntoServerStringFormat(date: selectedDate), status: TPStatus.approved.rawValue)
        
        if (count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isTPAvailableForSelectedDate(selectedDate: Date) -> Bool
    {
        let count = DBHelper.sharedInstance.getTPCountForTPDate(tpDate: convertDateIntoServerStringFormat(date: selectedDate), status: TPStatus.unapproved.rawValue)
        
        if (count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func getMessageForResignedAccompanists(oldUserName: String, newUserName: String, regionName: String) -> String
    {
        var message: String = EMPTY
        
        if (oldUserName == VACANT || oldUserName == NOT_ASSIGNED) && (newUserName != VACANT && newUserName != NOT_ASSIGNED)
        {
            message = "During the PR creation, \(regionName) was VACANT and \(newUserName) has been assigned to this region recently. However, this call is marked as an independent call. You may modify it."
        }
        else if (oldUserName != VACANT && oldUserName != NOT_ASSIGNED) && (newUserName == VACANT || newUserName == NOT_ASSIGNED)
        {
            message = "During the PR creation, \(oldUserName) was assigned to \(regionName) region. As of now, it is VACANT. Hence, it is assumed that you are using this region only for \(appDoctor) visits (i.e. Independent Call)."
        }
        else if (oldUserName != VACANT && oldUserName != NOT_ASSIGNED) && (newUserName != VACANT && newUserName != NOT_ASSIGNED)
        {
            message = "During the PR creation, \(oldUserName) was assigned to \(regionName) region. However, \(newUserName) has been assigned to this region recently. Hence, it is assumed that you are accompanying \(newUserName) for this \(appDoctor) visits."
        }
        
        return message
    }
    
    func getVisitTimeBasedOnAssetAnalytics(objAssetAnalytics: AssetAnalyticsDetail) -> (String, String)
    {
        var visitMode: String = EMPTY
        var visitTime: String = EMPTY
        
        if objAssetAnalytics.Detailed_StartTime != nil && objAssetAnalytics.Detailed_StartTime != ""
        {
            let detailedStarttime = objAssetAnalytics.Detailed_StartTime
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let newdate = dateformatter.date(from: detailedStarttime!)
            dateformatter.dateFormat = "a"
            visitMode = dateformatter.string(from: newdate!)
            visitTime = getTimeIn12HrFormat(date: getDateFromString(dateString: detailedStarttime!), timeZone: NSTimeZone.local)
        }
        
        return (visitMode, visitTime)
    }
    
    func updateVisitTimeBasedOnAssetAnalytics(visitMode: String, visitTime: String, dcrDoctorVisitId: Int)
    {
        DBHelper.sharedInstance.updateDCRDoctorVisitTime(visittime: visitTime, VisitMode: visitMode, DCR_Doctor_Visit_Id: dcrDoctorVisitId)
    }
    
    func getDCREntryTPApprovalNeededValue() -> Bool
    {
        var flag : Bool = false
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_ENTRY_TP_APPROVAL_NEEDED).uppercased()
        if privValue.contains(PrivilegeValues.YES.rawValue)
        {
            flag = true
        }
        
        return flag
    }
    
    func getTPHeaderByTPDateForDCRCalendar(date: String) -> Bool
    {
        var flag: Bool = false
        let tpheader = DBHelper.sharedInstance.getTPHeaderByTPDateForDCRCalendar(tpDate: date)
        if tpheader.count > 0
        {
            flag = true
        }
        return flag
    }
    
    func dcrEntryTPApprovalNeeded() -> Bool
    {
        if (self.getDCREntryTPApprovalNeededValue())
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func navigateToLandingUploadDCR(viewController:UIViewController)
    {
        
        let navigationController = viewController.navigationController
        
        if (navigationController != nil)
        {
            let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: DCRUploadVcID) as! DCRUploadController
            navigationController?.pushViewController(vc, animated: true)
            
            removeVersionToastView()
        }
    }
    
    func navigateToUploadDCR(viewController:UIViewController,enabledAutoSync:Bool)
    {
        
        let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:DCRUploadVcID) as! DCRUploadController
        
        vc.enabledAutoSync = enabledAutoSync
        
        if let navigationController = viewController.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func getDCRUploadError(viewController: UIViewController,isFromLandingUpload:Bool,enabledAutoSync:Bool)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getDCRUploadErrorMessage { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    if apiObj.list.count > 0
                    {
                        let review = "Kindly review the same."
                        var message = EMPTY
                        var messages:[String] = []
                        messages.append("Your Upload cannot proceed Due to the following reason")
                        for obj in apiObj.list
                        {
                            let objValue = obj as! [String:Any]
                            let str = objValue["message"] as! String
                            messages.append(str)
                        }
                        messages.append(review)
                        
                        for (index,obj) in messages.enumerated()
                        {
                            
                            if(index == 0)
                            {
                                message += obj + "\n\n"
                            }
                            else if(index+1 == messages.count)
                            {
                                message += "\n" + obj
                            }
                            else
                            {
                                message += "\(index).)" + obj + "\n\n"
                            }
                        }
                        
                        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        viewController.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        if isFromLandingUpload
                        {
                            self.navigateToLandingUploadDCR(viewController:viewController)
                        }
                        else
                        {
                            self.navigateToUploadDCR(viewController:viewController, enabledAutoSync: enabledAutoSync)
                        }
                    }
                }
                else
                {
                    if isFromLandingUpload
                    {
                        self.navigateToLandingUploadDCR(viewController:viewController)
                    }
                    else
                    {
                        self.navigateToUploadDCR(viewController:viewController, enabledAutoSync: enabledAutoSync)
                    }
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
}
