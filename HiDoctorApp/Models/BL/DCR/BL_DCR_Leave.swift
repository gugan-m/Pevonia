//
//  BL_DCR_Leave.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Leave: NSObject
{
    static let sharedInstance = BL_DCR_Leave()
    
    //MARK:- Public Functions
    
    private func getDCRDate() -> String
    {
        return DCRModel.sharedInstance.dcrDateString
    }
    
    func getLeaveTypes() -> [LeaveTypeMaster]?
    {
        let tpDate = TPModel.sharedInstance.tpDate
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
        let strCheck = UserDefaults.standard.string(forKey: "LeaveDCR")
        if (strCheck == "1") {
            return DBHelper.sharedInstance.getLeaveTypes(dcrDate: dcrDate!)
        }else{
            return DBHelper.sharedInstance.getLeaveTypes(dcrDate: tpDate!)
        }
    }
    
    func getUnapprovedLeaveData(leaveDate: Date) -> DCRHeaderModel?
    {
        return DBHelper.sharedInstance.getDCRHeaderByDCRDateAndFlag(dcrActualDate: leaveDate, flag: DCRFlag.leave.rawValue)
    }
    
    func isOnlineValidationRequired(leaveTypeName: String) -> Bool
    {
        var isValidationRequired: Bool = false
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_ENTRY_VALIDATION_REQUIRED_LEAVES).uppercased()
        let privArray = privValue.components(separatedBy: ",")
        
        if (privArray.contains(leaveTypeName.uppercased()))
        {
            isValidationRequired = true
        }
        
        return isValidationRequired
    }
    
    func applyOnlineLeave(startDate: Date, endDate: Date, leaveTypeCode: String, leaveTypeName: String, leaveReason: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        let startDateString = convertDateIntoServerStringFormat(date: startDate)
        let endDateString = convertDateIntoServerStringFormat(date: endDate)
    
        let appVersion = getCurrentAppVersion()
        let versionData = appVersion.components(separatedBy: "(")
        let versionName = versionData[0]
        let versionCode = versionData[1].components(separatedBy: ")")[0]

        var leaveData : NSMutableArray = []
        var insertData : [String : Any] = [:]
        let attachmentList = Bl_Attachment.sharedInstance.getDCRLeaveAttachmentDetails()
        
        for obj in attachmentList!
        {
            insertData = ["Leave_Type_Code": leaveTypeCode, "From_Date": startDateString, "To_Date": endDateString, "Number_Of_Days": EMPTY, "Leave_Status": String(DCRStatus.applied.rawValue), "Document_Url": "",  "Uploaded_File_Name": obj.attachmentName!]
            
            leaveData.add(insertData)
            
        }
        
        let postData: [String : Any] = ["DCR_Status": 1, "End_Date": endDateString, "Leave_Type_Code": leaveTypeCode, "Leave_Type_Name": leaveTypeName, "Reason": leaveReason, "Start_Date": startDateString, "versionCode": versionCode, "versionName": versionName, "lstLeaveAttachments": leaveData]
        
        let arrayData: NSArray = [postData]
        
        WebServiceHelper.sharedInstance.insertOnlineLeave(postData: arrayData) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    //MARK:- Pending Leave Approval
    
    func LeavePendingApproval(userCode: String, status: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.pendingLeaveApproval(userCode: userCode, status: status) { (apiResponseObj) in
            
            completion(apiResponseObj)
        }
    }
    
    func canApplyLeaveForTheseDates(startDate: Date, endDate: Date) -> String
    {
        var errorMessage: String = EMPTY
        let interval: TimeInterval = 24*60*60 //one day
        var nextDate = startDate
        let compareDate = endDate.addingTimeInterval(interval)
        
        while nextDate.compare(compareDate) == ComparisonResult.orderedAscending
        {
            errorMessage = canApplyLeaveForThisDate(dcrActualDate: nextDate)
            
            if (errorMessage != EMPTY)
            {
                break
            }
            
            nextDate = nextDate.addingTimeInterval(interval)
        }
        
        return errorMessage
    }
    
    func applyLeave(startDate: Date, endDate: Date, leaveTypeId: String, leaveTypeCode: String, leaveReason: String, leaveArray: NSArray)
    {
        let interval: TimeInterval = 24*60*60 //one day
        var nextDate = startDate
        let compareDate = endDate.addingTimeInterval(interval)
        var dcrHeaderDict: NSDictionary!
        let enteredDate = convertDateIntoServerStringFormat(date: Date())
        let latitude = getLatitude()
        let longitude = getLongitude()
        let calenderDetails = DBHelper.sharedInstance.getDCRCalendarDetails()
        
    
            let objLeave = DBHelper.sharedInstance.getDCRHeaderByDCRDateAndFlag(dcrActualDate: nextDate, flag: DCRFlag.leave.rawValue)
            var dcrCode: String = EMPTY
            
            if (leaveArray.count > 0)
            {
                let dcrDateString = convertDateIntoServerStringFormat(date: nextDate)
                let predicate = NSPredicate(format: "LeaveDCRDate == %@", dcrDateString)
                let filteredArray =  leaveArray.filtered(using: predicate)
                
                if (filteredArray.count > 0)
                {
                    let dict = filteredArray[0] as! NSDictionary
                    dcrCode = dict.value(forKey: "DCR_Code") as! String
                }
            }
            
            if (objLeave != nil) //Could be unapproved leave
            {
                updateLeave(leaveDate: nextDate, leaveTypeId: leaveTypeId, leaveTypeCode: leaveTypeCode, leaveReason: leaveReason, dcrCode: dcrCode)
            }
            else
            {
//                if (isHolidayOrWeekend(dcrActualDate: nextDate, calendarDetails: calenderDetails))
//                {
                    dcrHeaderDict = ["DCR_Actual_Date": convertDateIntoServerStringFormat(date: nextDate), "Dcr_Entered_Date": enteredDate, "DCR_Status": String(DCRStatus.applied.rawValue), "Flag": DCRFlag.leave.rawValue, "Leave_Type_Id": Int(leaveTypeId), "Leave_Type_Code": leaveTypeCode, "Lattitude": latitude, "Longitude": longitude, "Reason": leaveReason, "Region_Code": getRegionCode(), "DCR_Code": dcrCode,"DCR_Type" : "L"]
                    
                    let dcrHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dcrHeaderDict)
                    
                    DBHelper.sharedInstance.insertDCRHeader(dcrHeaderObj: dcrHeaderObj)
                    
                    BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
               // }
            }
            
           // nextDate = nextDate.addingTimeInterval(interval)
        
    }
    
    func updateLeave(leaveDate: Date, leaveTypeId: String, leaveTypeCode: String, leaveReason: String, dcrCode: String)
    {
        var dcrHeaderDict: NSDictionary!
        let enteredDate = convertDateIntoServerStringFormat(date: Date())
        let latitude = getLatitude()
        let longitude = getLongitude()
        let calenderDetails = DBHelper.sharedInstance.getDCRCalendarDetails()
        let dcrStatus = DCRStatus.applied.rawValue
        
//        if (isHolidayOrWeekend(dcrActualDate: leaveDate, calendarDetails: calenderDetails))
//        {
            dcrHeaderDict = ["DCR_Actual_Date": convertDateIntoServerStringFormat(date:leaveDate), "Dcr_Entered_Date": enteredDate, "DCR_Status": String(dcrStatus), "Flag": DCRFlag.leave.rawValue, "Leave_Type_Id": Int(leaveTypeId), "Leave_Type_Code": leaveTypeCode, "Lattitude": latitude, "Longitude": longitude, "Reason": leaveReason, "Region_Code": getRegionCode(), "DCR_Code": dcrCode]
            
            let dcrHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dcrHeaderDict)
            
            DBHelper.sharedInstance.updateLeave(dcrHeaderObj: dcrHeaderObj)
            
            BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
        //}
    }
    
    
    
    func applyOffice(dcrDate: Date, endDate: Date, leaveTypeId: String, leaveTypeCode: String, leaveReason: String, dcrCode: String)
        {
            let interval: TimeInterval = 24*60*60 //one day
            let compareDate = endDate.addingTimeInterval(interval)
            var dcrHeaderDict: NSDictionary!
            let enteredDate = convertDateIntoServerStringFormat(date: Date())
            let latitude = getLatitude()
            let longitude = getLongitude()
            let calenderDetails = DBHelper.sharedInstance.getDCRCalendarDetails()
            
        
    //                if (isHolidayOrWeekend(dcrActualDate: nextDate, calendarDetails: calenderDetails))
    //                {
            dcrHeaderDict = ["DCR_Actual_Date":convertDateIntoServerStringFormat(date: dcrDate), "Dcr_Entered_Date": enteredDate, "DCR_Status": String(DCRStatus.applied.rawValue), "Flag": DCRFlag.attendance.rawValue,"Lattitude": latitude, "Longitude": longitude, "Reason": leaveReason, "Region_Code": getRegionCode(), "DCR_Code": dcrCode,"DCR_Type" : "A"]
                        
                        let dcrHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dcrHeaderDict)
                        
                        DBHelper.sharedInstance.insertDCRHeader(dcrHeaderObj: dcrHeaderObj)
                        
                        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
                   // }
                
               // nextDate = nextDate.addingTimeInterval(interval)
            
        }
        
        func updateOffice(leaveDate: Date, leaveTypeId: String, leaveTypeCode: String, leaveReason: String, dcrCode: String)
        {
            var dcrHeaderDict: NSDictionary!
            let enteredDate = convertDateIntoServerStringFormat(date: Date())
            let latitude = getLatitude()
            let longitude = getLongitude()
            let calenderDetails = DBHelper.sharedInstance.getDCRCalendarDetails()
            let dcrStatus = DCRStatus.applied.rawValue
            
    //        if (isHolidayOrWeekend(dcrActualDate: leaveDate, calendarDetails: calenderDetails))
    //        {
                dcrHeaderDict = ["DCR_Actual_Date": convertDateIntoServerStringFormat(date:leaveDate), "Dcr_Entered_Date": enteredDate, "DCR_Status": String(dcrStatus), "Flag": DCRFlag.attendance.rawValue, "Leave_Type_Id": Int(leaveTypeId), "Leave_Type_Code": leaveTypeCode, "Lattitude": latitude, "Longitude": longitude, "Reason": leaveReason, "Region_Code": getRegionCode(), "DCR_Code": dcrCode]
                
                let dcrHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dcrHeaderDict)
                
                DBHelper.sharedInstance.updateLeave(dcrHeaderObj: dcrHeaderObj)
                
                BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
            //}
        }
    
    //MARK:- Private Functions
    private func getDCRHeaderByDate(dcrActualDate: Date) -> [DCRHeaderModel]?
    {
        return DBHelper.sharedInstance.getDCRHeaderByDCRDate(dcrActualDate: getServerFormattedDateString(date: dcrActualDate))
    }
    
    private func canApplyLeaveForThisDate(dcrActualDate: Date) -> String
    {
        var errorMessage: String = EMPTY
        let dcrHeaderList = getDCRHeaderByDate(dcrActualDate: dcrActualDate)
        
        if (dcrHeaderList != nil)
        {
            if (dcrHeaderList!.count > 0)
            {
                let convertedDate = convertDateIntoString(date: dcrActualDate)
                
                if (dcrHeaderList!.count > 1)
                {
                    let filteredArray = dcrHeaderList?.filter{
                        $0.Flag == DCRFlag.leave.rawValue && $0.DCR_Status == String(DCRStatus.unApproved.rawValue)
                    }
                    
                    if (filteredArray!.count == 0)
                    {
                        errorMessage = "Already you have entered two activities for \(convertedDate). Hence you are not allowed to apply Not Working for this date"
                    }
                }
                else
                {
                    if (dcrHeaderList![0].Flag == DCRFlag.leave.rawValue && dcrHeaderList![0].DCR_Status != String(DCRStatus.unApproved.rawValue) && dcrHeaderList![0].DCR_Status != String(DCRStatus.newDCR.rawValue))
                    {
                        errorMessage = "Already you have applied Not Working for \(convertedDate)."
                    }
                    else
                    {
                        if (dcrHeaderList![0].Flag != DCRFlag.leave.rawValue)
                        {
                            if (isMultipleActiviesAllowedForADate())
                            {
                                if (isHalfADayLeaveAllowed() == false)
                                {
                                    errorMessage = "Already you have entered an activity for \(convertedDate). Not Working can not be applied for half a day"
                                }
                            }
                            else
                            {
                                errorMessage = "Already you have entered an activity for \(convertedDate). You can enter only one activity for a date"
                            }
                        }
                    }
                }
            }
        }
        
        return errorMessage
    }
    
    func isMultipleActiviesAllowedForADate() -> Bool
    {
        var returnValue: Bool = true
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SINGLE_ACTIVITY_PER_DAY)
        
        if (privValue == PrivilegeValues.SINGLE.rawValue)
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    func isHalfADayLeaveAllowed() -> Bool
    {
        var returnValue: Bool = true
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.LEAVE_ENTRY_MODE)
        
        if (privValue == PrivilegeValues.FULL_DAY.rawValue)
        {
            returnValue = false
        }
        
        return returnValue
    }
    
    private func isHolidayOrWeekend(dcrActualDate: Date, calendarDetails: [DCRCalendarModel]) -> Bool
    {
        var isHolidayOrWeekend: Bool = false
        
        if (calendarDetails.count > 0)
        {
            let filteredArray = calendarDetails.filter{
                $0.Activity_Date_In_Date == dcrActualDate //&& ($0.Is_Holiday == 1 || $0.Is_WeekEnd == 1)
            }
            
            if (filteredArray.count > 0)
            {
                isHolidayOrWeekend = true
            }
        }
        
        return isHolidayOrWeekend
    }
    
    func getLeaveTypeName(leaveTypeCode:String) -> String
    {
       return DBHelper.sharedInstance.getLeaveName(leaveTypeCode: leaveTypeCode)
    }
}
