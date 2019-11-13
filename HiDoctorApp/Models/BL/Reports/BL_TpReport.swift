//
//  BL_TpReport.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TpReport: NSObject
{
    static let sharedInstance : BL_TpReport = BL_TpReport()
    
    var tpId : Int = 0
    var tpDate : Date!
    var headerList :[CopyTPAccHeaderModel] = []
    var sfcList :[CopyTpAccSFC] = []
    var doctorList:[CopyAccDoctorDetails] = []
    var accompanistList:[UserMasterModel] = []
    var activityCount : Int = 0
    
    //MARK:- Approval List
    
    func getTpReportDataList() -> [TpReportListModel]
    {
        var reportDataList : [TpReportListModel] = []
        for index : Int in 0 ..< 4
        {
            var reportObject = TpReportListModel()
            
            reportObject.sectionTitle = ["\(PEV_ACCOMPANIST) Detail","Work Place Details","Travel Details", "\(appDoctor) Visits"][index]
            reportObject.emptyStateText = ["No \(PEV_ACCOMPANIST) Available","No work Place details available","No travel details available","No \(appDoctor) visit available"][index]
            reportObject.titleImage = ["icon-stepper-two-user","icon-stepper-work-area","icon-map-mark","icon-stepper-two-user"][index]
            reportObject.sectionType = TpReportSectionHeader.init(rawValue: index)!
            reportDataList.append(reportObject)
        }
        return reportDataList
    }
    
    func clearAllArray()
    {
        tpId = 0
        tpDate = Date()
        headerList.removeAll()
        sfcList.removeAll()
        doctorList.removeAll()
        accompanistList.removeAll()
        activityCount = 0
    }
    
    func getTpAttendanceDataList() -> [TpReportListModel]
    {
        var attendanceDataList : [TpReportListModel] = []
        for index : Int in 0 ..< 3
        {
            var reportObject = TpReportListModel()
            
            reportObject.sectionTitle = ["Work Place Details","Travel Details", "Activity Details"][index]
            reportObject.emptyStateText = ["No work place details available","No travel details available","No activity details"][index]
            reportObject.titleImage = ["icon-stepper-work-area","icon-map-mark","icon-stepper-work-area"][index]
            reportObject.attendanceSectionType = TpAttendanceSectionHeader.init(rawValue: index)!
            attendanceDataList.append(reportObject)
        }
        return attendanceDataList
    }
    

    class func getDateList() -> [TpReportCalendarModel]
    {
        var dateList : [TpReportCalendarModel] = []
        let currentDate = Date()
    
        var cal = Calendar(identifier: Calendar.Identifier.gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!
        
        
        let startDate = cal.date(byAdding: Calendar.Component.month, value: -1, to: currentDate)!
        
        var components = cal.dateComponents([Calendar.Component.year,Calendar.Component.month], from: startDate)
        let startMonthDate = cal.date(from: components)
        var endDate = cal.date(byAdding: Calendar.Component.month, value: 2, to: currentDate)!
        components = cal.dateComponents([Calendar.Component.year,Calendar.Component.month], from: endDate)
        
        components.day = 0
        
        endDate = cal.date(from: components)!
      
        let interval = cal.dateComponents([Calendar.Component.day], from: startMonthDate!, to: endDate).day!
        
        for index : Int in 0...interval
        {
            let calendarObj : TpReportCalendarModel = TpReportCalendarModel()
            let date = cal.date(byAdding: Calendar.Component.day, value: index, to: startMonthDate!)!
            calendarObj.tpFullDate = convertDateIntoString(date: date)
            calendarObj.tpDay = convertDateInToDay(date : date)
            calendarObj.tpMonth = convertDateInRequiredFormat(date : date , format : "MMM")
            calendarObj.tpDate = convertDateInRequiredFormat(date : date , format : "dd")
            dateList.append(calendarObj)
        }
        return dateList
    }
    
    //MARK:- Tp DB Details
    
    func getTpHeaderDetails(tpDate : Date) -> TourPlannerHeader?
    {
       return DBHelper.sharedInstance.getTPHeaderByTPDate(tpDate: convertDateIntoServerStringFormat(date: tpDate))
    }
    
    func getTpAccompanistDetails(tpId : Int) -> [TourPlannerAccompanist]
    {
       return DBHelper.sharedInstance.getTPAccompanistForTPId(tpId: tpId)
    }
    
    func getTpSFCDetails(tpEntryId : Int) -> [TourPlannerSFC]
    {
        return DBHelper.sharedInstance.getTPTravelledPlaceForTPId(tpEntryId: tpEntryId)
    }
    
    func getTpDoctorDetails(TP_Entry_Id : Int) -> [TourPlannerDoctor]
    {
        return DBHelper.sharedInstance.getTpDoctorDetailsByTpId(TP_Entry_Id: TP_Entry_Id)
    }
    
    func getTpDoctorDetails1(tpDate : Date) -> [TourPlannerDoctor]
    {
        return DBHelper.sharedInstance.getTpDoctorDetailsByTpId1(tpdate : tpDate )
    }
    
    func getTpHeaderDetail(tpDate : Date) -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTpDate(tpdate: tpDate)
    }
    
    
    //MARK:- Tp Details Format
    
    func getTpAccompanistDetails(userName: String) -> NSArray
    {
        
        var tpAccompanistList : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
            let accompanistList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: tpId)
            
            for obj in accompanistList
            {
                let dict : NSDictionary = ["Acc_User_Name" : obj.userObj.Employee_name]
                list.add(dict)
            }
            tpAccompanistList = NSArray(array: list)
        }
        else
        {
            let accompanistList = self.accompanistList
            for obj in accompanistList
            {
                let dict : NSDictionary = ["Acc_User_Name" : obj.Employee_name]
                list.add(dict)
            }
            tpAccompanistList = NSArray(array: list)
        }
        return tpAccompanistList
    }
    
    func getTpWorkPlaceDetails(userName: String) -> NSArray
    {
        var tpWorkPlaceList : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
        let workPlaceObj =  getTpHeaderDetails(tpDate: tpDate)
        if workPlaceObj != nil
        {
            workPlaceObj?.CP_Name = checkNullAndNilValueForString(stringData: workPlaceObj?.CP_Name)
            workPlaceObj?.Category_Name = checkNullAndNilValueForString(stringData: workPlaceObj?.Category_Name)
            workPlaceObj?.Work_Place = checkNullAndNilValueForString(stringData: workPlaceObj?.Work_Place)
            
            let dict : NSDictionary = ["CP_Name" : workPlaceObj!.CP_Name! , "Category_Name" : workPlaceObj!.Category_Name! , "Place_Worked" : workPlaceObj!.Work_Place!]
            list.add(dict)
        }
        
        tpWorkPlaceList = NSArray(array: list)
        }
        else
        {
            let workPlaceObj =  self.headerList[0]
            if workPlaceObj != nil
            {
                workPlaceObj.cp_Name = checkNullAndNilValueForString(stringData: workPlaceObj.cp_Name)
                workPlaceObj.work_Category_Name = checkNullAndNilValueForString(stringData: workPlaceObj.work_Category_Name)
                workPlaceObj.work_Area = checkNullAndNilValueForString(stringData: workPlaceObj.work_Area)
                
                let dict : NSDictionary = ["CP_Name" : workPlaceObj.cp_Name! , "Category_Name" : workPlaceObj.work_Category_Name! , "Place_Worked" : workPlaceObj.work_Area!]
                list.add(dict)
            }
            
            tpWorkPlaceList = NSArray(array: list)
        }
        return tpWorkPlaceList
    }
    
    func getTpSFCDetails(userName: String) -> NSArray
    {
        var tpSFCDetails : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
        let sfcList = getTpSFCDetails(tpEntryId: tpId)
        
        for obj in sfcList
        {
            let dict : NSDictionary = ["From_Place" : obj.From_Place , "To_Place" : obj.To_Place , "Distance" : obj.Distance , "Travel_Mode" :obj.Travel_Mode]
            list.add(dict)
        }
        tpSFCDetails = NSArray(array : list)
        }
        else
        {
            let sfcList = self.sfcList
            
            for obj in sfcList
            {
                let dict : NSDictionary = ["From_Place" : obj.from_Place , "To_Place" : obj.to_Place , "Distance" : obj.distance , "Travel_Mode" :obj.travel_Mode]
                list.add(dict)
            }
            tpSFCDetails = NSArray(array : list)
        }
        return tpSFCDetails
    }
    
    func getTpDoctorDetails(userName: String, type: Int, tpDate: Date) -> NSArray
    {
        var dcrDoctorDetails : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
            
            if (type == 3){
                let doctorList = getTpDoctorDetails(TP_Entry_Id: tpId)
                
                for obj in  doctorList
                {
                    obj.Hospital_Name = checkNullAndNilValueForString(stringData: obj.Hospital_Name)
                    obj.MDL_Number = checkNullAndNilValueForString(stringData: obj.MDL_Number)
                    obj.Category_Name = checkNullAndNilValueForString(stringData: obj.Category_Name)
                    obj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: obj.Doctor_Region_Name)
                    
                    
                    let dict : NSDictionary = ["Doctor_Name" : obj.Doctor_Name! , "Hospital_Name" : obj.Hospital_Name! , "MDL_Number" : obj.MDL_Number! , "Speciality_Name" : obj.Speciality_Name , "Category_Name" : obj.Category_Name! , "Region_Name" : obj.Doctor_Region_Name! , "Region_Code" : obj.Doctor_Region_Code , "Doctor_Code" : obj.Doctor_Code ]
                    list.add(dict)
                }
                dcrDoctorDetails = NSArray(array: list)
            }
        else{
            let doctorList = getTpDoctorDetails1(tpDate: tpDate)
            
            for obj in  doctorList
            {
                obj.Hospital_Name = checkNullAndNilValueForString(stringData: obj.Hospital_Name)
                obj.MDL_Number = checkNullAndNilValueForString(stringData: obj.MDL_Number)
                obj.Category_Name = checkNullAndNilValueForString(stringData: obj.Category_Name)
                obj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: obj.Doctor_Region_Name)
                
                
                let dict : NSDictionary = ["Doctor_Name" : obj.Doctor_Name! , "Hospital_Name" : obj.Hospital_Name! , "MDL_Number" : obj.MDL_Number! , "Speciality_Name" : obj.Speciality_Name , "Category_Name" : obj.Category_Name! , "Region_Name" : obj.Doctor_Region_Name! , "Region_Code" : obj.Doctor_Region_Code , "Doctor_Code" : obj.Doctor_Code ]
                list.add(dict)
            }
            dcrDoctorDetails = NSArray(array: list)
        }
        
        }
        else
        {
            let doctorList = self.doctorList
            
            for obj in  doctorList
            {
                obj.Hospital_Name = checkNullAndNilValueForString(stringData: obj.Hospital_Name)
                obj.mdl = checkNullAndNilValueForString(stringData: obj.mdl)
                obj.category_Name = checkNullAndNilValueForString(stringData: obj.category_Name)
                obj.doctor_Region_Code = checkNullAndNilValueForString(stringData: obj.doctor_Region_Code)
                

                
                let dict : NSDictionary = ["Doctor_Name" : obj.doctor_Name! , "Hospital_Name" : obj.Hospital_Name! , "MDL_Number" : obj.mdl! , "Speciality_Name" : obj.doctorSpeciality , "Category_Name" : obj.category_Name! , "Region_Name" : obj.region_Name , "Region_Code" : obj.doctor_Region_Code , "Doctor_Code" : obj.doctor_Code]
                list.add(dict)
            }
            dcrDoctorDetails = NSArray(array: list)
        }
        return dcrDoctorDetails
    }
    
    //MARK:- Attendance
    
    func getTpActivityDetails(userName: String) -> NSArray
    {
        var tpActivityList : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
        let headerObj =  getTpHeaderDetails(tpDate: tpDate)
        if headerObj != nil
        {
            headerObj?.Activity_Name = checkNullAndNilValueForString(stringData:  headerObj?.Activity_Name)
            let dict : NSDictionary = ["Activity_Name" : headerObj!.Activity_Name!]
            list.add(dict)
        }
        
        tpActivityList = NSArray(array: list)
        }
        else
        {
            let headerObj =  self.headerList[0]
            if headerObj != nil
            {
                headerObj.activity_Name = checkNullAndNilValueForString(stringData:  headerObj.activity_Name)
                let dict : NSDictionary = ["Activity_Name" : headerObj.activity_Name!]
                list.add(dict)
            }
            
            tpActivityList = NSArray(array: list)
            
        }
        return tpActivityList
    }
    
    
    func getTpLeaveDetails(userName: String) -> NSArray
    {
        var tpActivityList : NSArray = []
        let list : NSMutableArray = []
        if userName == "Mine"
        {
        let headerObj =  getTpHeaderDetail(tpDate: tpDate)
        if headerObj != nil
        {
            headerObj?.Activity_Name = checkNullAndNilValueForString(stringData:  headerObj?.Activity_Name)
            let dict : NSDictionary = ["Activity_Name" : headerObj!.Activity_Name!]
            list.add(dict)
        }
        
        tpActivityList = NSArray(array: list)
        }
        else
        {
            let headerObj =  self.headerList[0]
            if headerObj != nil
            {
                headerObj.activity_Name = checkNullAndNilValueForString(stringData:  headerObj.activity_Name)
                let dict : NSDictionary = ["Activity_Name" : headerObj.activity_Name!]
                list.add(dict)
            }
            
            tpActivityList = NSArray(array: list)

        }
        return tpActivityList
    }
    
   
    func getWorkPlaceListModel(dict : NSDictionary , type : Int) -> [StepperWorkPlaceModel]
    {
        var workPlaceObj : StepperWorkPlaceModel  = StepperWorkPlaceModel()
        var workPlaceList : [StepperWorkPlaceModel] = []
        var campaignName : String = ""
        var workCategory : String = ""
        var workPlace : String = ""
       
//        if type != 2
//        {
//            workPlaceObj.key = "Campaign Plan"
//
//            campaignName = checkNullAndNilValueForString(stringData: dict.object(forKey: "CP_Name") as? String)
//            if campaignName == ""
//            {
//                campaignName = NOT_APPLICABLE
//            }
//
//            workPlaceObj.value = campaignName
//            workPlaceList.append(workPlaceObj)
//
//        }
        
        workPlaceObj = StepperWorkPlaceModel()
        workPlaceObj.key = "Work Category"
        
        workCategory = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category_Name") as? String)
        
        if workCategory == ""
        {
            workCategory = NOT_APPLICABLE
        }
        
        workPlaceObj.value = workCategory
        workPlaceList.append(workPlaceObj)
        
        workPlaceObj = StepperWorkPlaceModel()
        workPlaceObj.key = "Work Place"
        
        workPlace = checkNullAndNilValueForString(stringData: dict.object(forKey: "Place_Worked") as? String)
       
        if workPlace == ""
        {
            workPlace = NOT_APPLICABLE
        }
        
        workPlaceObj.value = workPlace
        workPlaceList.append(workPlaceObj)
        
        return workPlaceList
    }
    
    
    //MARK:- Cell Height
    

    
    func getEmptyStateCellHeight()-> CGFloat
    {
        return 30
    }
    
    func getCommonCellHeight(dataList : NSArray , sectionType : Int) -> CGFloat
    {
        
        var childTableViewHeight : CGFloat = 0
        
        for obj in dataList
        {
            let dict = obj as! NSDictionary
            
            childTableViewHeight += getSingleCellHeight() + getLineHeightAccordingToType(sectionType: sectionType, dict: dict)
        }
        
        return childTableViewHeight
    }
    
    func getSingleCellHeight() -> CGFloat
    {
        let topSpaceToLine1 : CGFloat = 4
        let line1LblHeight : CGFloat = 0
        let line2LblHeight : CGFloat = 0
        let bottomSpacetoLine2 : CGFloat = 8
        
        return topSpaceToLine1 + line1LblHeight + line2LblHeight + bottomSpacetoLine2
    }
    
    func getCommonHeightforWorkPlaceDetails(dataList : [StepperWorkPlaceModel]) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        // let line1LblHeight : CGFloat = 17
        
        for obj in dataList
        {
            childTableViewHeight += getSingleCellHeight() + getLine2HeightForWorkPlace(text: obj.value , fontType: fontBold) + getLine2HeightForWorkPlace(text: obj.key , fontType: fontRegular)
        }
        
        return childTableViewHeight
    }
    
    func getLine2HeightForWorkPlace(text : String , fontType : String) -> CGFloat
    {
        return getTextSize(text: text, fontName: fontType, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
    }
    
    
    func getLineHeightAccordingToType(sectionType : Int , dict : NSDictionary) -> CGFloat
    {
        var height : CGFloat = 0
        var line2Text : String = ""
        var line1Text : String = ""
        var fontType : String = fontBold
        
        if sectionType == 0
        {
            var employeName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
            let fromTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_Start_Time") as? String)
            let toTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_End_Time")as? String)
            var workingTime  : String = ""
            fontType = fontRegular
            
            if fromTime == ""
            {
                workingTime = NOT_APPLICABLE
            }
            else
            {
                workingTime  = "\(fromTime) - \(toTime)"
            }
            
            if employeName == ""
            {
                employeName = NOT_APPLICABLE
            }
            
            if workingTime == ""
            {
                workingTime = NOT_APPLICABLE
            }
            
            line1Text = employeName
            line2Text = workingTime
        }
        else if sectionType == 4
        {
            fontType = fontSemiBold
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            
            var quantity : String = ""
            var currentStock : String = ""
            
            quantity = checkNullAndNilValueForString(stringData: dict.object(forKey: "Quantity_Provided") as? String)
            
            if quantity == ""
            {
                quantity = "null"
            }
            
            currentStock = checkNullAndNilValueForString(stringData: dict.object(forKey: "Current_Stock") as? String)
            
            if currentStock == ""
            {
                currentStock = "null"
            }
            
            line2Text = "Quantity Provided : \(quantity) | Current_Stock : \(currentStock)"
        }
        else if sectionType == 5
        {
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
        }
        
        
        height += getTextSize(text: line1Text, fontName: fontType, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 86).height
        
        height += getTextSize(text: line2Text, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
        
        return height
    }
    
    func getSFCSingleCellHeight() -> CGFloat
    {
        return 67
    }
    
    
    func getSFCCellHeight(dataList : NSArray) -> CGFloat
    {
        
        let numberOfRows: Int = dataList.count
        var childTableHeight: CGFloat = 0
        
        
        for _ in 1...numberOfRows
        {
            childTableHeight += getSFCSingleCellHeight()
        }
        
        return childTableHeight
        
    }
    
    
    func getDoctorVisitCellHeight(dataList : NSArray , type : Int) -> CGFloat
    {
        var childTableHeight: CGFloat = 0
        
        for obj in dataList
        {
            let height = getSingleDoctorVisitCellHeight() + getDoctorVisitDetails(dict: obj as! NSDictionary)
            if type == 1
            {
                childTableHeight = childTableHeight + height - 19
            }
            else
            {
                childTableHeight = childTableHeight + height - 19
            }
        }
        return childTableHeight
    }
    
    func getSingleDoctorVisitCellHeight() -> CGFloat
    {
        let topSpace : CGFloat = 10 + 7
        let line1Height : CGFloat = 0
        let bottomToLine2Height : CGFloat = 8
        let line2Height : CGFloat = 0
        let bottomToMoreHeight :CGFloat = 8
        let moreLblHeight:CGFloat = 19
        let moreBottomToView : CGFloat = 8
        let sepViewHeight : CGFloat = 1
        
        return topSpace + line1Height + bottomToLine2Height + line2Height + bottomToMoreHeight + moreLblHeight + moreBottomToView + sepViewHeight
    }
    
    
    func getDoctorVisitDetails(dict : NSDictionary) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat  = 0
        
        var HospitalName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if HospitalName == ""
        {
            HospitalName = NOT_APPLICABLE
        }
        
        doctorDetails = HospitalName
        
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
       // doctorDetails = doctorDetails + " | " + "MDL NO: \(mdlNumber)"
        
        let specialityName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Speciality_Name") as? String)
        if specialityName != ""
        {
            doctorDetails = doctorDetails + " | " + specialityName
        }
        
        var categoryName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category_Name") as? String)
        if categoryName == ""
        {
            categoryName = NOT_APPLICABLE
        }
        
        doctorDetails = doctorDetails + " | " + categoryName
        
        let regionName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Name") as? String)
        if regionName != ""
        {
            doctorDetails = doctorDetails + " | " + regionName
        }
        
        let doctorName =   checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String)
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 110).height
        let doctorNameHgt = getTextSize(text: doctorName, fontName: fontSemiBold, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 110).height
        
        return lblHeight + doctorNameHgt
    }

    func getTPDataFromApi(userObj: ApprovalUserMasterModel,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        self.activityCount = 0
        let postData = getPostData(userObj: userObj)
        self.clearArray()
        WebServiceHelper.sharedInstance.getTourPlannerHeader(postData : postData) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                if apiResponseObject.list.count > 0
                {
                    for value in apiResponseObject.list
                    {
                        let obj = value as! NSDictionary
                        let headermodel = CopyTPAccHeaderModel()
                        
                        headermodel.call_Objective = "Call Objective"
                        headermodel.activity_Type = "Field"
                        headermodel.work_Category = obj.value(forKey: "Category_Name") as? String
                        headermodel.work_Category_Name = obj.value(forKey: "Category_Name") as? String
                        headermodel.cp_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "CP_Code") as? String)
                        headermodel.cp_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "CP_Name") as? String)
                        headermodel.tp_Id = obj.value(forKey: "TP_Id") as? Int ?? 0
                        headermodel.work_Area = checkNullAndNilValueForString(stringData: obj.value(forKey: "Work_Area") as? String)
                        headermodel.tp_Status = obj.value(forKey: "TP_Status") as? Int ?? 0
                        headermodel.activity_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity_Code") as? String)
                        headermodel.activity_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity_Name") as? String)
                        headermodel.project_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Project_Code") as? String)
                        headermodel.tp_Date = checkNullAndNilValueForString(stringData: obj.value(forKey:  "TP_Date") as? String)
                        headermodel.cp_Id = obj.value(forKey: "CP_Id") as? Int ?? 0
                        headermodel.category_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Category_Code") as? String)
                        headermodel.activity = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity") as? String)
                        headermodel.tp_Day = checkNullAndNilValueForString(stringData: obj.value(forKey: "TP_Day" ) as? String)
                        headermodel.meeting_Place = checkNullAndNilValueForString(stringData: obj.value(forKey: "Meeting_Place" ) as? String)
                        headermodel.meeting_Time = checkNullAndNilValueForString(stringData: obj.value(forKey: "Meeting_Time") as? String)
                        headermodel.UnApprove_Reason = checkNullAndNilValueForString(stringData: obj.value(forKey: "UnApprove_Reason") as? String)
                        headermodel.tp_ApprovedBy = checkNullAndNilValueForString(stringData: obj.value(forKey: "TP_ApprovedBy") as? String)
                        headermodel.approved_Date = checkNullAndNilValueForString(stringData: obj.value(forKey: "Approved_Date") as? String)
                        headermodel.is_Weekend = obj.value(forKey: "Is_Weekend") as? Int ?? 0
                        headermodel.is_Holiday = obj.value(forKey: "Is_Holiday") as? Int ?? 0
                        headermodel.copyAccess = obj.value(forKey: "CopyAccess") as? Int ?? 0
                        headermodel.remarks = checkNullAndNilValueForString(stringData: obj.value(forKey: "Remarks") as? String)
                        
                        self.headerList.append(headermodel)
                        
                    }
                    self.activityCount = 1
                    if(userObj.Activity == 1 || userObj.Activity == 2)
                    {
                        WebServiceHelper.sharedInstance.getTourPlannerSFC(postData : postData) { (apiResponseObject) in
                            if apiResponseObject.Status == SERVER_SUCCESS_CODE
                            {
                                if apiResponseObject.list.count > 0
                                {
                                    for value in apiResponseObject.list
                                    {
                                        print(apiResponseObject.list)
                                        let obj = value as! NSDictionary
                                        let sfcModel = CopyTpAccSFC()
                                        sfcModel.company_Code = obj.value(forKey: "Company_Code") as? String
                                        sfcModel.from_Place = obj.value(forKey:  "From_Place") as? String
                                        sfcModel.to_Place = obj.value(forKey: "To_Place") as? String
                                        let distance = obj.value(forKey: "Distance") as? CGFloat ?? 0
                                        sfcModel.distance = "\(distance)"
                                        sfcModel.distance_Fare_Code = obj.value(forKey: "Distance_Fare_Code") as? String
                                        sfcModel.project_Code = obj.value(forKey: "Project_Code") as? String
                                        sfcModel.route_Way = obj.value(forKey:  "Route_Way") as? String
                                        sfcModel.sfc_Category_Name = obj.value(forKey: "SFC_Category_Name") as? String
                                        sfcModel.sfc_Code = obj.value(forKey: "SFC_Code") as? String
                                        sfcModel.sfc_Region_Code = obj.value(forKey: "SFC_Region_Code") as? String
                                        sfcModel.sfc_Version = obj.value(forKey: "SFC_Version") as? String
                                        sfcModel.tp_Date = obj.value(forKey: "TP_Date") as? String
                                        sfcModel.tp_Id = obj.value(forKey:  "TP_Id") as? Int
                                        sfcModel.tp_SFC_Id = obj.value(forKey: "TP_SFC_Id") as!Int
                                        sfcModel.travel_Mode = obj.value(forKey: "Travel_Mode") as? String
                                        
                                        self.sfcList.append(sfcModel)
                                    }
                                    self.activityCount = 2
                                    if(userObj.Activity == 1)
                                    {
                                    WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData: postData) { (apiResponseObject) in
                                        if apiResponseObject.Status == SERVER_SUCCESS_CODE
                                        {
                                            if apiResponseObject.list.count > 0
                                            {
                                                for value in apiResponseObject.list
                                                {
                                                    
                                                    let obj = value as! NSDictionary
                                                    let doctorModel = CopyAccDoctorDetails()
                                                    doctorModel.doctor_Name = obj.value(forKey: "Doctor_Name") as? String
                                                    doctorModel.doctorSpeciality = obj.value(forKey: "Speciality_Name") as? String
                                                    doctorModel.Hospital_Name = obj.value(forKey: "Hospital_Name") as? String
                                                    doctorModel.tp_Id = obj.value(forKey: "TP_Id") as! Int
                                                    doctorModel.tp_Doctor_Id = obj.value(forKey: "TP_Doctor_Id") as! Int
                                                    doctorModel.doctor_Code = obj.value(forKey: "Doctor_Code") as? String
                                                    doctorModel.doctor_Region_Code = obj.value(forKey: "Doctor_Region_Code") as? String
                                                    doctorModel.mdl = obj.value(forKey: "MDL") as? String
                                                    doctorModel.region_Code = obj.value(forKey: "Region_Code") as? String
                                                    doctorModel.region_Name = obj.value(forKey: "Region_Name") as? String
                                                    doctorModel.category_Name = obj.value(forKey: "Category_Name") as? String
                                                    doctorModel.category_Code = obj.value(forKey: "SFC_Category_Name") as? String
                                                    
                                                    self.doctorList.append(doctorModel)
                                                    
                                                    
                                                }
                                                //completion(apiResponseObject)
                                                
                                            }
//                                            else
//                                            {
//                                              completion(apiResponseObject)//only field
//                                            }
                                            self.accompanistList.removeAll()
                                            WebServiceHelper.sharedInstance.getTourPlannerAccompanist(postData: postData)
                                            {
                                                (apiResponseObject) in
                                                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                                                {
                                                    if apiResponseObject.list.count > 0
                                                    {
                                                        for value in apiResponseObject.list
                                                        {
                                                            let obj = value as! NSDictionary
                                                            let accModel = UserMasterModel()
                                                            
                                                            accModel.Employee_name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Name") as? String)
                                                            accModel.Region_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_Region_Code") as? String)
                                                            accModel.User_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Code") as? String)
                                                            accModel.User_Type_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Type_Name") as? String)
                                                            
                                                            self.accompanistList.append(accModel)
                                                            
                                                        }
                                                    }
                                                    completion(apiResponseObject)
                                                }
                                                else
                                                {
                                                    completion(apiResponseObject)//only field
                                                }
                                                
                                            }
                                            
                                            self.activityCount = 3
                                        }
                                        else
                                        {
                                            self.headerList.removeAll()
                                            self.sfcList.removeAll()
                                            completion(apiResponseObject)
                                        }
                                        }
                                        
                                    }
                                    else
                                    {
                                        completion(apiResponseObject)//only attendance
                                    }
                                }
                                else
                                {
 
                                    if(userObj.Activity == 1)
                                    {
                                        WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData: postData) { (apiResponseObject) in
                                            if apiResponseObject.Status == SERVER_SUCCESS_CODE
                                            {
                                                if apiResponseObject.list.count > 0
                                                {
                                                    for value in apiResponseObject.list
                                                    {
                                                        
                                                        let obj = value as! NSDictionary
                                                        let doctorModel = CopyAccDoctorDetails()
                                                        doctorModel.doctor_Name = obj.value(forKey: "Doctor_Name") as? String
                                                        doctorModel.doctorSpeciality = obj.value(forKey: "Speciality_Name") as? String
                                                        doctorModel.Hospital_Name = obj.value(forKey: "Hospital_Name") as? String
                                                        doctorModel.tp_Id = obj.value(forKey: "TP_Id") as! Int
                                                        doctorModel.tp_Doctor_Id = obj.value(forKey: "TP_Doctor_Id") as! Int
                                                        doctorModel.doctor_Code = obj.value(forKey: "Doctor_Code") as? String
                                                        doctorModel.doctor_Region_Code = obj.value(forKey: "Doctor_Region_Code") as? String
                                                        doctorModel.mdl = obj.value(forKey: "MDL") as? String
                                                        doctorModel.region_Code = obj.value(forKey: "Region_Code") as? String
                                                        doctorModel.region_Name = obj.value(forKey: "Region_Name") as? String
                                                        doctorModel.category_Name = obj.value(forKey: "Category_Name") as? String
                                                        doctorModel.category_Code = obj.value(forKey: "SFC_Category_Name") as? String
                                                        
                                                        self.doctorList.append(doctorModel)
                                                        
                                                        
                                                    }
                                                    //completion(apiResponseObject)
                                                    
                                                }
                                                //                                            else
                                                //                                            {
                                                //                                              completion(apiResponseObject)//only field
                                                //                                            }
                                                self.accompanistList.removeAll()
                                                WebServiceHelper.sharedInstance.getTourPlannerAccompanist(postData: postData)
                                                {
                                                    (apiResponseObject) in
                                                    if apiResponseObject.Status == SERVER_SUCCESS_CODE
                                                    {
                                                        if apiResponseObject.list.count > 0
                                                        {
                                                            for value in apiResponseObject.list
                                                            {
                                                                let obj = value as! NSDictionary
                                                                let accModel = UserMasterModel()
                                                                
                                                                accModel.Employee_name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Name") as? String)
                                                                accModel.Region_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_Region_Code") as? String)
                                                                accModel.User_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Code") as? String)
                                                                accModel.User_Type_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Acc_User_Type_Name") as? String)
                                                                
                                                                self.accompanistList.append(accModel)
                                                                
                                                            }
                                                        }
                                                        completion(apiResponseObject)
                                                    }
                                                    else
                                                    {
                                                        completion(apiResponseObject)//only field
                                                    }
                                                    
                                                }
                                                
                                                self.activityCount = 3
                                            }
                                            else
                                            {
                                                self.headerList.removeAll()
                                                self.sfcList.removeAll()
                                                completion(apiResponseObject)
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                   completion(apiResponseObject)
                                }
                            }
                            else
                            {
                                self.headerList.removeAll()
                                completion(apiResponseObject)
                                
                                
                            }
                            
                        }
                       
                    }
                    else
                    {
                        self.activityCount = 1
                        completion(apiResponseObject)//only leave
                    }
                }
                else
                {
                    self.activityCount = 0
                    completion(apiResponseObject)//empty state
                }
            }
            else
            {
                completion(apiResponseObject)
            }
            
        }
    }

    
    func getDoctorDataFromApi(userObj: ApprovalUserMasterModel,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
        {
            let postData = getPostData(userObj: userObj)
            WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData : postData) { (apiResponseObject) in
                completion(apiResponseObject)
            }

    }
     func getPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,"RegionCode": userObj.Region_Code, "StartDate": userObj.Actual_Date, "EndDate": userObj.Actual_Date,"TPStatus": "ALL"]
    }
    
    func clearArray()
    {
        self.headerList.removeAll()
        self.sfcList.removeAll()
        self.doctorList.removeAll()
        self.accompanistList.removeAll()
    }

}

struct TpReportListModel
{
    var sectionTitle : String = ""
    var titleImage : String = ""
    var emptyStateText : String = ""
    var dataList : NSArray = []
    var sectionType : TpReportSectionHeader!
    var attendanceSectionType : TpAttendanceSectionHeader!
}



class TpReportCalendarModel : NSObject
{
    var tpFullDate : String!
    var tpDay : String!
    var tpMonth : String!
    var tpDate : String!
}

enum TpReportSectionHeader : Int
{
    case Accompanists = 0
    case WorkPlace = 1
    case Travel = 2
    case DoctorVisit = 3
    case Product = 4
}

enum TpAttendanceSectionHeader : Int
{
    case WorkPlace = 0
    case Travel = 1
    case Activity = 2
}

