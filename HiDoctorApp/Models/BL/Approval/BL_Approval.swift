//
//  BL_Approval.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_Approval: NSObject
{
    static let sharedInstance : BL_Approval  = BL_Approval()
    
    //MARK:- Approval List
    
    func getDCRApprovalDataList() -> [ApprovalTableListModel]
    {
        var approvalDataList : [ApprovalTableListModel] = []
        for index : Int in 0 ..< 7
        {
            var approvalObject = ApprovalTableListModel()
            
            approvalObject.sectionTitle = ["\(PEV_ACCOMPANIST) Details","Work Place Details","Travel Details", "\(appDoctor) Visits","\(appChemist) Visits","\(appStockiestPlural) Visits","Expenses Details"][index]
            approvalObject.emptyStateText = ["No \(PEV_ACCOMPANIST) available","No work place details available","No travel details available","No \(appDoctor) visit available","No \(appChemist) visit available","No \(appStockiestPlural) available","No expenses available"][index]
            approvalObject.titleImage = ["icon-stepper-two-user","icon-stepper-work-area","icon-map-mark","icon-work-user","icon-work-user","icon-stepper-two-user","ic_Currency"][index]
            approvalObject.sectionViewType = SectionHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getTpApprovalDataList() -> [ApprovalTableListModel]
    {
        var approvalDataList : [ApprovalTableListModel] = []
        for index : Int in 0 ..< 5
        {
            var approvalObject = ApprovalTableListModel()
            
            approvalObject.sectionTitle = ["\(PEV_ACCOMPANIST) Details","Work Place Details","Travel Details", "\(appDoctor) Visits","Product Details"][index]
            approvalObject.emptyStateText = ["No \(PEV_ACCOMPANIST) available","No work place details available","No travel details available","No \(appDoctor) visit available","No products available"][index]
            approvalObject.titleImage = ["icon-stepper-two-user","icon-stepper-work-area","icon-map-mark","icon-work-user","icon-stepper-two-user"][index]
            approvalObject.sectionType = TpSectionHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getDCRAttendanceDataList() -> [ApprovalAttendanceListModel]
    {
        var approvalDataList : [ApprovalAttendanceListModel] = []
        for index : Int in 0 ..< 5
        {
            var approvalObject = ApprovalAttendanceListModel()
            
            approvalObject.sectionTitle = ["Work Place Details","Travel Details", "Activity Details","Partner Sample Details","Expenses Details"][index]
            approvalObject.emptyStateText = ["No work place details available","No travel details available","No activity available","No Partner Samples available","No expenses available"][index]
            approvalObject.titleImage = ["icon-stepper-work-area","icon-map-mark","icon-stepper-work-area","icon-stepper-two-user","ic_Currency"][index]
            approvalObject.sectionViewType = AttendanceHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getTpAttendanceDataList() -> [ApprovalAttendanceListModel]
    {
        var approvalDataList : [ApprovalAttendanceListModel] = []
        for index : Int in 0 ..< 3
        {
            var approvalObject = ApprovalAttendanceListModel()
            
            approvalObject.sectionTitle = ["Work Place Details","Travel Details", "Activity Details"][index]
            approvalObject.emptyStateText = ["No work place details available","No travel details available","No activity available"][index]
            approvalObject.titleImage = ["icon-stepper-work-area","icon-map-mark","icon-stepper-work-area"][index]
            approvalObject.sectionViewType = AttendanceHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getDCRApprovalDataList() -> [DoctorDetailsListModel]
    {
        var approvalDataList : [DoctorDetailsListModel] = []
        for index : Int in 0 ..< 11
        {
            var approvalObject = DoctorDetailsListModel()
            
            
            approvalObject.sectionTitle = ["\(appDoctor) Visit Details","\(PEV_ACCOMPANIST) Details","Samples/Promotional Items", "Detailed Products",PEV_DIGITAL_ASSETS,"Follow Ups","Attachments","\(appChemist) Visits","Purchase Order Booking Details","Call Activity","MC Activity"][index]
            approvalObject.emptyStateText = ["No \(appDoctor) visit details available","No \(PEV_ACCOMPANIST) details available.","No samples available","No detailed products available","No \(PEV_DIGITAL_ASSETS) Available","No FollowUps available","No attachments available","No \(appChemist) visit details available","No Purchase Order booking Available","No Call Activity","No MC Activity"][index]
            approvalObject.titleImage = ["icon-stepper-work-area","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-asset-inactive","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user"][index]
            approvalObject.sectionViewType = DoctorDetailsHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getAttendanceDCRApprovalDataList() -> [DoctorDetailsListModel]
    {
        var approvalDataList : [DoctorDetailsListModel] = []
        for index : Int in 0 ..< 4
        {
            var approvalObject = DoctorDetailsListModel()
            
            
            approvalObject.sectionTitle = ["\(appDoctor) Visit Details","Samples/Promotional Items","Call Activity","MC Activity"][index]
            approvalObject.emptyStateText = ["No \(appDoctor) visit details available","No samples available","No Call Activity","No MC Activity"][index]
            approvalObject.titleImage = ["icon-stepper-work-area","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user"][index]
            approvalObject.sectionViewType = DoctorDetailsHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    func getDCRChemistApprovalDataList() -> [DoctorDetailsListModel]
    {
        var approvalDataList : [DoctorDetailsListModel] = []
        for index : Int in 0 ..< 8
        {
            var approvalObject = DoctorDetailsListModel()
            
            approvalObject.sectionTitle = ["\(appChemist) Visit Details","\(PEV_ACCOMPANIST) Details","Samples/Promotional Items", "Detailed Products","RCPA Details","Follow Ups","Attachments","Purchase Order Booking Details"][index]
            approvalObject.emptyStateText = ["No \(appDoctor) visit details available","No \(PEV_ACCOMPANIST) details available.","No samples available","No detailed products available","No RCPA available","No FollowUps available","No attachments available","No Purchase Order booking Available"][index]
            approvalObject.titleImage = ["icon-stepper-work-area","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user","icon-stepper-two-user"][index]
            approvalObject.sectionViewType = DoctorDetailsHeaderType.init(rawValue: index)!
            approvalDataList.append(approvalObject)
        }
        return approvalDataList
    }
    
    
    
    //MARK:- Cell Height
    
    func getLoadingCellHeight() -> CGFloat
    {
        return 50
    }
    
    func getEmptyStateCellHeight()-> CGFloat
    {
        return 30
    }
    
    func getEmptyStateRetryCellHeight() -> CGFloat
    {
        return 65
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
        let bottomSpacetoLine2 : CGFloat = 4
        
        return topSpaceToLine1 + line1LblHeight + line2LblHeight + bottomSpacetoLine2
    }
    
    func getCommonHeightforWorkPlaceDetails(dataList : [StepperWorkPlaceModel]) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        // let line1LblHeight : CGFloat = 17
        
        for obj in dataList
        {
            let line1Height = getLine2HeightForWorkPlace(text: obj.key , fontType: fontRegular)
            let line2Height = getLine2HeightForWorkPlace(text: obj.value , fontType: fontSemiBold)
            childTableViewHeight += getSingleCellHeight() + line1Height + line2Height
        }
        
        return childTableViewHeight
    }
    
    func getLine2HeightForWorkPlace(text : String , fontType : String) -> CGFloat
    {
        if text == NOT_APPLICABLE
        {
            return 17
        }
        else
        {
            return getTextSize(text: text, fontName: fontType, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 66).height
        }
    }
    
    
    func getLineHeightAccordingToType(sectionType : Int , dict : NSDictionary) -> CGFloat
    {
        var height : CGFloat = 0
        var line2Text : String = ""
        var line1Text : String = ""
        var fontType : String = fontSemiBold
        
        if sectionType == 0
        {
            var employeName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
            let fromTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_Start_Time") as? String)
            let toTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Acc_End_Time")as? String)
            var workingTime  : String = ""
            fontType = fontSemiBold
            
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
        else if sectionType == 5
        {
            var stockiestName : String = ""
            
            fontType = fontSemiBold
            
            stockiestName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Stockiest_Name") as? String)
            if stockiestName == ""
            {
                stockiestName = NOT_APPLICABLE
            }
            
            var pobAmount : String = ""
            
            if let pob = dict.value(forKey: "POB_Amount") as? Float
            {
                pobAmount = String(pob)
            }
            
            if pobAmount == ""
            {
                pobAmount = NOT_APPLICABLE
            }
            
            var collectionAmount : String = ""
            if let collection = dict.value(forKey: "Collection_Amount") as? Float
            {
                collectionAmount = String(collection)
            }
            
            
            if collectionAmount == ""
            {
                collectionAmount = NOT_APPLICABLE
            }
            
            line1Text = stockiestName
            line2Text  = "Pob : \(pobAmount) - Collection Amount : \(collectionAmount)"
        }
        else if sectionType == 6
        {
            fontType = fontSemiBold
            
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Expense_Type_Name") as? String)
            
            let expenseAmount = dict.object(forKey: "Expense_Amount") as? Float
            line2Text = "Rs. \(String(describing: expenseAmount))"
        }
        else if sectionType == 7
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
        else if sectionType == 8
        {
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
        }
        else
        {
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            let workStartTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Start_Time") as? String)
            
            if workStartTime != ""
            {
                let  workToTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "End_Time") as? String)
                line2Text = "\(workStartTime) - \(workToTime)"
            }
        }
        
        
        height += getTextSize(text: line1Text, fontName: fontType, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 66).height
        
        height += getTextSize(text: line2Text, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 66).height
        
        return height
    }
    
    func getSFCSingleCellHeight() -> CGFloat
    {
        return 68
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
                childTableHeight = childTableHeight + height
            }
            else
            {
                childTableHeight = childTableHeight + height - 22
            }
        }
        return childTableHeight
    }
    
    func geChemistVisitCellHeight(dataList : NSArray , type : Int) -> CGFloat
    {
        var childTableHeight: CGFloat = 0
        
        for obj in dataList
        {
            let height = getSingleDoctorVisitCellHeight() + getChemistVisitHeight(dict: obj as! NSDictionary)
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
    
    func geStockistVisitCellHeight(dataList : NSArray , type : Int) -> CGFloat
    {
        var childTableHeight: CGFloat = 0
        
        for obj in dataList
        {
            let height = getSingleDoctorVisitCellHeight() + getStockistVisitHeight(dict: obj as! NSDictionary)
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

    
    func getSingleDoctorVisitCellHeight() -> CGFloat
    {
        let topSpace : CGFloat = 4 + 15
        let line1Height : CGFloat = 0
        let bottomToLine2Height : CGFloat = 4
        let line2Height : CGFloat = 0
        let bottomToMoreHeight :CGFloat = 4
        let moreLblHeight:CGFloat = 17
        let moreBottomToView : CGFloat = 4
        let sepViewHeight : CGFloat = 1
        
        return topSpace + line1Height + bottomToLine2Height + line2Height + bottomToMoreHeight + moreLblHeight + moreBottomToView + sepViewHeight
    }
    
    func getDoctorVisitDetails(dict : NSDictionary) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat  = 0
        
        
        let HospitalName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if HospitalName != ""
        {
            doctorDetails = HospitalName
        }
        
        
        var mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        
        mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL") as? String)
        
        if mdlNumber == ""
        {
            mdlNumber = NOT_APPLICABLE
        }
        
      //  doctorDetails = doctorDetails + " | " + "MDL NO : \(mdlNumber)"
        
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
        
        
        
        let doctorName =   "\(appDoctor) Name:\(checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String))"
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
        let doctorNameHgt = getTextSize(text: doctorName, fontName: fontSemiBold, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 86).height
        
        return lblHeight + doctorNameHgt
    }
    
    func getChemistVisitHeight(dict : NSDictionary) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat  = 0
        
        if (dict.value(forKey: "Is_Chemist_Day") as! String == "0")
        {
            if let pobAmount = dict.value(forKey: "POB_Amount") as? Float
            {
                doctorDetails = "POB: \(pobAmount)"
            }
            else if let pobAmount = dict.value(forKey: "POB_Amount") as? Double
            {
                doctorDetails = "POB: \(pobAmount)"
            }
        }
        let doctorName =   "\(appChemist) Name:\(checkNullAndNilValueForString(stringData: dict.object(forKey: "Doctor_Name") as? String))"
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
        let doctorNameHgt = getTextSize(text: doctorName, fontName: fontSemiBold, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 86).height
        
        return lblHeight + doctorNameHgt
    }
    
    func getStockistVisitHeight(dict : NSDictionary) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat  = 0
        
//        if (dict.value(forKey: "Is_Chemist_Day") as! String == "0")
//        {
//            if let pobAmount = dict.value(forKey: "POB_Amount") as? Float
//            {
//                doctorDetails = "POB: \(pobAmount)"
//            }
//            else if let pobAmount = dict.value(forKey: "POB_Amount") as? Double
//            {
//                doctorDetails = "POB: \(pobAmount)"
//            }
//        }
        let doctorName =   "\(appStockiest) Name:\(checkNullAndNilValueForString(stringData: dict.value(forKey: "Stockiest_Name") as? String))"
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 86).height
        let doctorNameHgt = getTextSize(text: doctorName, fontName: fontSemiBold, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 86).height
        
        return lblHeight + doctorNameHgt
    }
    
    //MARK:-Doctor Details Height
    
    
    func getCommonDoctorCellHeight(dataList : NSArray , sectionType : Int,fromChemistDay:Bool) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        
        for obj in dataList
        {
            let dict = obj as! NSDictionary
            
            let lineHeight = getLineHeightForDoctorDetails(dict: dict, sectionType: sectionType,fromChemistDay:fromChemistDay)
            childTableViewHeight += getSingleCellHeight() + lineHeight
            if sectionType == 7 || sectionType == 8
            {
                childTableViewHeight += 17 //More lbl height
            }
        }
        
        return childTableViewHeight
    }
    
    func getCommonAttendanceDoctorCellHeight(dataList : NSArray , sectionType : Int) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        
        for obj in dataList
        {
            let dict = obj as! NSDictionary
            
            let lineHeight = getLineHeightForDoctorDetails(dict: dict, sectionType: sectionType)
            childTableViewHeight += getSingleCellHeight() + lineHeight
            if sectionType == 7 || sectionType == 8 || sectionType == 3
            {
                childTableViewHeight += 17 //More lbl height
            }
        }
        
        return childTableViewHeight
    }
    
    
    func getDetailedProductCellHeight(dataList : NSArray , sectionType : Int,fromChemistDay:Bool) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        
        for obj in dataList
        {
            let dict = obj as! NSDictionary
            
            let lineHeight = getLineHeightForDoctorDetails(dict: dict, sectionType: sectionType,fromChemistDay:fromChemistDay)
            childTableViewHeight += getSingleCellHeight() + lineHeight
            if sectionType == 7 || sectionType == 8
            {
                childTableViewHeight += 17 //More lbl height
            }
        }
        
        return childTableViewHeight
    }
    func getLineHeightForDoctorDetails(dict : NSDictionary,sectionType : Int) -> CGFloat
    {
        var height : CGFloat = 0
        var line2Text : String = ""
        var line1Text : String = ""
        var fontType : String = fontSemiBold
        var constrainedWidth = 79
        
        if sectionType == 0
        {
            line1Text = dict.object(forKey: "SectionName") as! String!
            var sectionVal  = checkNullAndNilValueForString(stringData: dict.object(forKey: "SectionValue") as? String)
            
            if sectionVal == ""
            {
                sectionVal = NOT_APPLICABLE
            }
            
            line2Text = sectionVal
        }
        else if sectionType == 1
        {
            var productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            if productName == ""
            {
                productName = NOT_APPLICABLE
            }
            line1Text = productName
            var quantity = checkNullAndNilValueForString(stringData: dict.object(forKey: "Quantity_Provided") as? String)
            if quantity == ""
            {
                quantity = NOT_APPLICABLE
            }
            line2Text = quantity
            
        }
        else if sectionType == 2
        {
            var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
            if activityName == ""
            {
                activityName = NOT_APPLICABLE
            }
            if activityRemarks == ""
            {
                activityRemarks = NOT_APPLICABLE
            }
            line1Text = activityName
            line2Text =  "Remarks: \(activityRemarks)"
            
        }
        else if sectionType == 3
        {
            var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
            if activityName == ""
            {
                activityName = NOT_APPLICABLE
            }
            if activityRemarks == ""
            {
                activityRemarks = NOT_APPLICABLE
            }
            line1Text = activityName
            line2Text =  "Remarks: \(activityRemarks)"
        }
        height += getTextSize(text: line1Text, fontName: fontType, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 79).height
        
        if line2Text != EMPTY
        {
            height += getTextSize(text: line2Text, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 79).height
        }
        
        return height
    }
    
    func getLineHeightForDoctorDetails(dict : NSDictionary,sectionType : Int,fromChemistDay:Bool) -> CGFloat
    {
        var height : CGFloat = 0
        var line2Text : String = ""
        var line1Text : String = ""
        var fontType : String = fontSemiBold
        var constrainedWidth = 79
        
        if sectionType == 0
        {
            line1Text = dict.object(forKey: "SectionName") as! String!
            var sectionVal  = checkNullAndNilValueForString(stringData: dict.object(forKey: "SectionValue") as? String)
            
            if sectionVal == ""
            {
                sectionVal = NOT_APPLICABLE
            }
            
            line2Text = sectionVal
        }
        else if sectionType  == 1
        {
            var employeeName  = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
            let isForDoctor = dict.object(forKey: "Is_Only_For_Doctor") as? Int
            if employeeName == ""
            {
                employeeName = NOT_APPLICABLE
            }
            if isForDoctor == 1
            {
                employeeName = "\(employeeName) \nIndependant Call"
            }
            
            line1Text = employeeName
        }
        else if sectionType == 2
        {
            var productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            if productName == ""
            {
                productName = NOT_APPLICABLE
            }
            line1Text = productName
            var quantity = checkNullAndNilValueForString(stringData: dict.object(forKey: "Quantity_Provided") as? String)
            if quantity == ""
            {
                quantity = NOT_APPLICABLE
            }
            line2Text = quantity
            
        }
        else if sectionType == 3
        {
            var detProduct = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            fontType = fontRegular
            
            detProduct += checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Attr") as? String)
            
            if detProduct == ""
            {
                detProduct = NOT_APPLICABLE
            }
            
            line1Text = detProduct
        }
        else if sectionType == 5
        {
            let followUpsText = checkNullAndNilValueForString(stringData: dict.object(forKey: "Tasks") as? String)
            line1Text = followUpsText
            line2Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Due_Date") as? String)
            fontType = fontRegular
        }
        else if sectionType == 6
        {
            line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Uploaded_File_Name") as? String)
            constrainedWidth -= 24
        }
        else if sectionType == 8
        {
            var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
            if chemistName == ""
            {
                chemistName = NOT_APPLICABLE
            }
            
            line1Text = chemistName
            
            var pob : String = ""
            if let pobAmount =  dict.object(forKey: "POB_Amount") as? Float
            {
                pob = String(pobAmount)
            }
            if pob == ""
            {
                pob = "0.0"
            }
            var pobProduct : String = ""
            if let Produt = dict.object(forKey: "DCR_Chemist_Visit_Id") as? Int
            {
                pobProduct = String(Produt)
            }
            else
            {
                pobProduct = "0"
            }
            
            line2Text = "POB Amount: " + pob + " | " + "No Of Product: " + pobProduct
        }
        else if sectionType == 9
        {
            var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
            if activityName == ""
            {
                activityName = NOT_APPLICABLE
            }
            if activityRemarks == ""
            {
                activityRemarks = NOT_APPLICABLE
            }
            line1Text = activityName
            line2Text =  "Remarks: \(activityRemarks)"
            
        }
        else if sectionType == 10
        {
            var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
            var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
            if activityName == ""
            {
                activityName = NOT_APPLICABLE
            }
            if activityRemarks == ""
            {
                activityRemarks = NOT_APPLICABLE
            }
            line1Text = activityName
            line2Text =  "Remarks: \(activityRemarks)"
        }
        else if sectionType == 7
        {
            if(fromChemistDay)
            {
                var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
                if chemistName == ""
                {
                    chemistName = NOT_APPLICABLE
                }
                
                line1Text = chemistName
                
                var pob : String = ""
                if let pobAmount =  dict.object(forKey: "POB_Amount") as? Float
                {
                    pob = String(pobAmount)
                }
                if pob == ""
                {
                    pob = "0.0"
                }
                var pobProduct : String = ""
                if let Produt = dict.object(forKey: "DCR_Chemist_Visit_Id") as? Int
                {
                    pobProduct = String(Produt)
                }
                else
                {
                    pobProduct = "0"
                }
                
                line2Text = "POB Amount: " + pob + " | " + "No Of Product: " + pobProduct
            }
            else
            {
                var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
                if chemistName == ""
                {
                    chemistName = NOT_APPLICABLE
                }
                
                line1Text = chemistName
                
                var pob : String = ""
                if let pobAmount =  dict.object(forKey: "POB_Amount") as? Float
                {
                    pob = String(pobAmount)
                }
                if pob == ""
                {
                    pob = NOT_APPLICABLE
                }
                
                line2Text = pob + " | " + "RCPA"
            }
        }
        else if sectionType == 4
        {
            let customerName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Customer_Name") as? String)
            var productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            if productName == ""
            {
                productName = NOT_APPLICABLE
            }
            line1Text = customerName
            var quantity = checkNullAndNilValueForString(stringData: dict.object(forKey: "Qty") as? String)
            if quantity == ""
            {
                quantity = NOT_APPLICABLE
            }
            line2Text = "Own Product: \(productName) | Own Product Qty:  \(quantity)"
        }
        
        
        height += getTextSize(text: line1Text, fontName: fontType, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 79).height
        
        if line2Text != EMPTY
        {
            height += getTextSize(text: line2Text, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 79).height
            if (sectionType == 4)
            {
                height += 15
            }
        }
        
        return height
    }
    
    func getCommonDoctorAssetCellHeight(dataList : NSArray) -> CGFloat
    {
        var childTableViewHeight : CGFloat = 0
        
        for obj in dataList
        {
            let dict = obj as! NSDictionary
            childTableViewHeight += getLineHeightForAsset(dict: dict)
        }
        return childTableViewHeight
    }
    
    func getLineHeightForAsset(dict : NSDictionary) -> CGFloat
    {
        var totalLblHeight : CGFloat = 54
        var docType: String = ""
        if (dict.object(forKey: "Doc_Type") as? Int != nil)
        {
         docType = getDocTypeVal(docType: dict.object(forKey: "Doc_Type") as! Int)
        }
        let assetName = "\(checkNullAndNilValueForString(stringData: dict.object(forKey: "DA_Name")as? String))(\(docType))"
        
        if docType != Constants.DocType.document && docType != Constants.DocType.zip
        {
            totalLblHeight -= 28
        }
        let assetNameHeight = getTextSize(text: assetName, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH - 74).height
        return totalLblHeight + assetNameHeight
    }
    
    //MARK:- DCR Approval Api Calls
    
    
    func getDCRHeaderDetailsV59Report(userObj: ApprovalUserMasterModel, completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUserPerDayReportPostData(userObj: userObj)
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59Report(postData: postData) { (apiResonseObj) in
            completion(apiResonseObj)
        }
    }
    //Accompanists Details
    func getDCRAccompanistsDetails(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRAccompanistForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRWorkPlaceDetails(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRTravelledDetails(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRTravelledPlacesForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRDoctorVisitDetailsForUserPerday(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRDoctorVisitDetailsForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRChemistVisitDetailsForUserPerday(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetailsForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRStockiestsVisitDetails(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRStockiestVisitDetailsForUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRExpenseDetails(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRExpenseDetailsUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    //MARK :- Attenadnce
    
    func getDCRActivityDetails(userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        
        WebServiceHelper.sharedInstance.getDCRActivityDetailsUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRAttendanceSamples(userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ()){
        
        WebServiceHelper.sharedInstance.getDCRAttendanceSampleUserPerday(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    //MARK:- Lock Release
    func getLockLeaveDetailsForUser(userCode: String, regionCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getLockLeaveDetailsForUser(userCode: userCode, regionCode: regionCode) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getActivityLockLeaveDetailsForUser(userCode: String, regionCode: String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getActivityLockLeaveDetailsForUser(userCode: userCode, regionCode: regionCode) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func gettpFreezeDetailsForUser(userCode: String, selectedMonth: String,selectedYear:String, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getTPFreezeDetailsForUser(userCode: userCode, selectedMonth: selectedMonth,selectedYear:selectedYear) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    
    //MARK:- DCR Approval
    
    func getDCRMonthWiseCount(userCode : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDCRMonthWiseCount(userCode: userCode)
        {
            (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDCRAccompanistForUserPerdayReport(userObj:ApprovalUserMasterModel,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRAccompanistForUserPerdayReport(userObj: userObj){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRADoctorVisitDetails(DCRCode: String, doctorVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRADoctorVisitDetails(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    
    func getDCRDoctorAccompanistForADoctorVisit(DCRCode:String,doctorVisitCode: String, completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRDoctorAccompanistForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRSampleDetailsForADoctorVisit(DCRCode:String,doctorVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRSampleDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    
    func getDCRDetailedProductsDetailsForADoctorVisit(DCRCode:String,doctorVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRDetailedProductsDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    
    func getDoctorDigitalAssets(userCode:String,dcrDate : String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRDigitalAssetsForADoctorVisit(userCode: userCode, customerCode: DCRModel.sharedInstance.customerCode, dcrDate: dcrDate) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func getDCRChemistVisitDetailsForADoctorVisit(DCRCode:String,doctorVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    
    func getDCRRCPADetailsForADoctorAndChemistVisit(DCRCode:String,doctorVisitCode: String, chemistVisitCode: String, completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRRCPADetailsForADoctorAndChemistVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode, chemistVisitCode: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getAttachmentForDoctorDetails(userCode : String,doctorVisitCode : String, completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRAttachmentDetails(userCode: userCode, doctorVisitCode: doctorVisitCode) { (apiReponseObject) in
            completion(apiReponseObject)
        }
        
    }
    
    func getFollowUpDetails(userCode : String , doctorVisitCode : String, completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRFollowUpsDetails(userCode: userCode, doctorVisitCode: doctorVisitCode) { (apiReponseObject) in
            completion(apiReponseObject)
        }
    }
    
    //MARK:- Tp Approval
    
    //MARKL:- Field
    
    func getTpMonthWiseCount(userCode : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getTpMonthWiseCount(userCode: userCode)
        { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTpAccompanistData(userObj : ApprovalUserMasterModel,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerApprovalPostData(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getTourPlannerAccompanist(postData: postData){ (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTpWorkPlaceDetailsData(userObj : ApprovalUserMasterModel ,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerApprovalPostData(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getTourPlannerHeader(postData: postData)
        { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTpTravelledDetails(userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerApprovalPostData(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getTourPlannerSFC(postData: postData)
        { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getDoctorVisitDetailsData(userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerApprovalPostData(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getTourPlannerDoctor(postData: postData)
        { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    func getTourPlannerProduct(userObj : ApprovalUserMasterModel , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerApprovalPostData(userObj: userObj)
        
        WebServiceHelper.sharedInstance.getTourPlannerProduct(postData: postData)
        { (apiResponseObject) in
            
            completion(apiResponseObject)
        }
    }
    
    private func getTourPlannerApprovalPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,"RegionCode": userObj.Region_Code, "StartDate": userObj.Actual_Date, "EndDate": userObj.Entered_Date,"TPStatus": "2,"]
    }
    
    //MARK:- Approval Status
    
    func updateDCRStatus(userList : [ApprovalUserMasterModel] , userObj : ApprovalUserMasterModel , reason : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUpdateDCRStatusList(userList: userList, reason: reason)
        WebServiceHelper.sharedInstance.updateDCRStatus(postData: postData, userObj: userObj) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func updateTpStatus(userList : [ApprovalUserMasterModel] , userObj : ApprovalUserMasterModel , reason : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUpdateTpStatusList(userList: userList, reason: reason)
        WebServiceHelper.sharedInstance.updateTpStatus(postData: postData, userObj: userObj) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
//    func updateLeaveStatus(userList : [LeaveApprovalModel] , userObj : ApprovalUserMasterModel , leaveObj : LeaveApprovalModel, reason : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
//    {
//        let postData = getUpdateLeaveStatusList(userList: userList, reason: reason)
//        WebServiceHelper.sharedInstance.updateLeaveStatus(postData: postData, userObj: userObj, leaveObj: leaveObj) { (apiResponseObj) in
//            completion(apiResponseObj)
//        }
//    }
    //leave test 1
    func updateLeaveStatus1(userList : [LeaveApprovalModel] , leaveObj : LeaveApprovalModel, reason : String , completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUpdateLeaveStatusList(userList: userList, reason: reason)
        WebServiceHelper.sharedInstance.updateLeaveStatus1(postData: postData, leaveObj: leaveObj) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    
    func getUpdateDCRStatusList(userList : [ApprovalUserMasterModel] , reason : String) -> NSArray
    {
        let list : NSMutableArray = []
        for obj in userList
        {
            let userObj = obj as ApprovalUserMasterModel
            let dict : NSDictionary = ["Unapproval_Reason": reason ,"DCR_Code": userObj.DCR_Code,
                                       "Client_Flag": userObj.Activity, "User_Name": getUserName(),"DCR_Status":userObj.approvalStatus, "DCR_Actual_Date": userObj.Actual_Date, "Is_Checked": userObj.IsChecked]
            list.add(dict)
        }
        return NSArray(array: list)
    }
    
    
    func getUpdateTpStatusList(userList : [ApprovalUserMasterModel] , reason : String) -> NSArray
    {
        let list : NSMutableArray = []
        for obj in userList
        {
            let userObj = obj as ApprovalUserMasterModel
            let dict : NSDictionary = ["Approved_User_Code" : getUserCode() , "Approved_User_Name" : getUserName() , "TP_Id" : userObj.Activity_Id , "User_Name" : userObj.User_Name ,  "Status" : userObj.approvalStatus]
            list.add(dict)
        }
        return NSArray(array: list)
    }
    
    func getUpdateLeaveStatusList(userList : [LeaveApprovalModel] , reason : String) -> NSArray
    {
        let list : NSMutableArray = []
        for obj in userList
        {
            let userObj = obj as LeaveApprovalModel
//            var dcrStatus = userObj.Status
//            let a:Int? = Int(dcrStatus!)
            let dict : NSDictionary = ["Unapproval_Reason": reason , "From_Date": userObj.From_Date! , "To_Date": userObj.To_Date!, "Client_Flag": "3", "User_Name": getUserName(),"DCR_Status":userObj.approvalStatus, "Is_Checked": userObj.IsChecked]
            list.add(dict)
        }
        return NSArray(array: list)
    }
    
 //"Client_Flag":3,"From_Date":"2019-07-12","To_Date":"2019-07-13","DCR_Status":0,"Unapproval_Reason":"665","User_Name":"administrator","Is_Checked":0
    // "From_Date": userObj.From_Date! , "To_Date": userObj.To_Date!,
    
    
    func getDCRStatus(dcrStatus : String) -> String
    {
        var status : String = ""
        let type = Int(dcrStatus)
        
        if type == DCRStatus.applied.rawValue
        {
            status = applied
        }
        else if type == DCRStatus.drafted.rawValue
        {
            status = "Draft"
        }
        else if type == DCRStatus.approved.rawValue
        {
            status = approved
        }
        else if type == DCRStatus.unApproved.rawValue
        {
            status = unApproved
        }
        
        return status
    }
    
    //MARK:- Conversion
    
    func getMonthNameByNumber(monthNumber : Int) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        
        let months = dateFormatter.monthSymbols as [String]
        let monthSymbol = months[monthNumber - 1] // month - from your date components
        return monthSymbol
    }
    
    func getendDateOfMonth(month : String , year : String) -> Date
    {
        let date = getDateStringInFormatDate(dateString: "\(year) - \(month) - 01", dateFormat: "yyyy-MM-dd")
        return  Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
    }
    
    
    class func getTextForReason() -> String
    {
        return "Reason For Approval / Rejection"
    }
    
    func getTrimmedTextForUnapproveReason(reason : String) -> String
    {
        var reasonText : String!
        if reason.last == "^"
        {
            reasonText = String(reason.dropLast(1))
        }
        else
        {
            reasonText = reason
        }
        
        return reasonText.replacingOccurrences(of: "~", with: "-").replacingOccurrences(of: "^", with: "\n\n")
    }
    
    func getTrimmedTextForGeneralRemarks(text : String) -> String
    {
        return text.replacingOccurrences(of: GENERAL_REMARKS_API_SPLIT_CHAR, with: " ").replacingOccurrences(of: GENERAL_REMARKS_LOCAL_SPLIT_CHAR, with: "")
    }
    
    private func getUserPerDayReportPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,  "Flag" : "","RegionCode": userObj.Region_Code,"StartDate" : userObj.Actual_Date , "EndDate" : userObj.Entered_Date,"DCRStatus": "1,"]
    }
    
    //ChemistDay
    func getDCRAChemistVisitDetails(DCRCode: String, chemistVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getChemistVisitPerDay(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRChemistAccompanistForAChemistVisit(DCRCode:String,chemistVisitCode: String, completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitAccompanist(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRSampleDetailsForAChemistVisit(DCRCode:String,chemistVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitSamplePromotion(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRDetailedProductsDetailsForChemistVisit(DCRCode:String,chemistVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitDetailedProducts(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRRCPAProductsDetailsForChemistVisit(DCRCode:String,chemistVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitRCPAOwnProducts(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getDCRRCPACompetitorProductsDetailsForChemistVisit(DCRCode:String,chemistVisitCode: String,completion : @escaping(_ apiRsponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitRCPACompetitorProducts(dcrCode: DCRCode, visitId: chemistVisitCode){ (apiRsponseObject) in
            completion(apiRsponseObject)
        }
    }
    
    func getAttachmentForChemistDetails(chemistVisitCode : String,userCode : String, completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitAttachments(visitId: chemistVisitCode, userCode: userCode)
        { (apiRsponseObject) in
            completion(apiRsponseObject)
        }
        
        
    }
    
    func getChemistFollowUpDetails(chemistVisitCode : String,userCode : String, completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getUserperdayChemistVisitFollowups(visitId: chemistVisitCode,userCode: userCode)
        { (apiReponseObject) in
            completion(apiReponseObject)
        }
    }
    
    func getPOBForChemistDetails(regionCode: String ,userCode: String , startDate: String, endDate: String,completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRChemistVisitOrderDetails(postData: getPostDataForPOB(regionCode: regionCode, userCode: userCode, startDate: startDate, endDate: endDate)) { (apiReponseObject) in
            completion(apiReponseObject)
        }
    }
    func getPOBForDoctorDetails(regionCode: String ,userCode: String , startDate: String, endDate: String,completion : @escaping(_ apiReponseObject : ApiResponseModel) ->())
    {
        WebServiceHelper.sharedInstance.getDCRDoctorVisitOrderDetails(postData: getPostDataForPOB(regionCode: regionCode, userCode: userCode, startDate: startDate, endDate: endDate)) { (apiReponseObject) in
            completion(apiReponseObject)
        }
    }
    
    func getPostDataForPOB(regionCode: String ,userCode: String , startDate: String, endDate: String) -> [String: Any]
    {
        return ["Company_Code": getCompanyCode(), "User_Code": userCode, "Region_Code": regionCode, "Start_Date": startDate, "End_Date": endDate, "Order_Status": "ALL"]
    }
    
    func convertTPHeaderToCommonModel(list : NSArray) -> [ApprovalUserMasterModel]
    {
        var currentList : [ApprovalUserMasterModel] = []
        
        for obj in list
        {
            let userObj : ApprovalUserMasterModel = ApprovalUserMasterModel()
            let dict = obj as! NSDictionary
            if(dict.object(forKey: "TP_Id") as! Int != 0)
            {
                userObj.Activity_Id = dict.object(forKey: "TP_Id") as! Int
                userObj.Actual_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: dict.object(forKey: "TP_Date") as! String , dateFormat: defaultServerDateFormat))
                userObj.Entered_Date = convertDateIntoServerStringFormat(date: getDateStringInFormatDate(dateString: dict.object(forKey: "TP_Date") as! String , dateFormat: defaultServerDateFormat))
                userObj.actualDate = convertDateIntoString(dateString: dict.object(forKey: "TP_Date") as! String)
                let tpCode = dict.object(forKey: "TP_Id") as! Int
                userObj.DCR_Code = String(describing: tpCode)
                userObj.approvalStatus = dict.object(forKey: "TP_Status") as! Int
                let activityValue = dict.object(forKey: "Activity") as! Int
                userObj.Activity = Int(activityValue)
                currentList.append(userObj)
            }
        }
        return currentList
    }
    
    //Doctor Approval
    func getDoctorApprovalDoctorDetail(regionCode: String, customerStatus: Int, completion: @escaping(_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getDoctorApprovalDoctorDetail(regionCode: regionCode, customerStatus: customerStatus) { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
}

struct ApprovalTableListModel
{
    var sectionTitle : String = ""
    var titleImage : String = ""
    var emptyStateText : String = ""
    var currentAPIStatus : APIStatus = APIStatus.Loading
    var dataList : NSArray = []
    var sectionViewType : SectionHeaderType!
    var sectionType : TpSectionHeaderType!
    var rowHeight : CGFloat!
}

struct DoctorDetailsListModel
{
    var sectionTitle : String = ""
    var titleImage : String = ""
    var emptyStateText : String = ""
    var currentAPIStatus : APIStatus = APIStatus.Loading
    var dataList : NSArray = []
    var sectionViewType : DoctorDetailsHeaderType!
}

struct ApprovalAttendanceListModel
{
    var sectionTitle : String = ""
    var titleImage : String = ""
    var emptyStateText : String = ""
    var currentAPIStatus : APIStatus = APIStatus.Loading
    var dataList : NSArray = []
    var sectionViewType : AttendanceHeaderType!
}

enum SectionHeaderType : Int
{
    case Accompanists = 0
    case WorkPlace = 1
    case Travel = 2
    case DoctorVisit = 3
    case ChemistVisit = 4
    case Stockiest = 5
    case Expense = 6
}

enum TpSectionHeaderType : Int
{
    case Accompanists = 0
    case WorkPlace = 1
    case Travel = 2
    case DoctorVisit = 3
    case Product = 4
}

enum AttendanceHeaderType : Int
{
    case WorkPlace = 0
    case Travel = 1
    case Activity = 2
    case Doctor = 3
    case Expenses = 4
}

enum DoctorDetailsHeaderType : Int {
    case DoctorVisit = 0
    case Accompanist = 1
    case Sample = 2
    case DetailedProduct = 3
    case DigitalAssets = 4
    case FollowUps = 5
    case Attachment = 6
    case ChemistVisit = 7
    case pob = 8
    case callType = 9
    case mcActivity = 10
}

enum AttendanceDoctorDetailsHeaderType : Int {
    case DoctorVisit = 0
    case Sample = 1
    case callType = 2
    case mcActivity = 3
}

class ApproveErrorTypeTwo : Codable
{
    var Available_Count : Int!
    var Max_Count : Int!
    var Selected_Count : Int!
    var Excess_Count : Int!
    var Entity_Type : String!
    var Entity_Value : String!
}

class ExpenseApproval : NSObject
{
    var User_Code : String?
    var Claim_Code : String!
    var Request_Code: String!
    var Status_Code: String!
    var Actual_Amount: Float!
    var Approved_Amount: Float!
    var Date_From: String!
    var Date_To: String!
    var Entered_DateTime: String!
    var Remarks_By_User: String!
    var Remarks_By_Admin: String!
    var Request_Name: String!
    var Request_Entity: String!
    var Status_Name: String!
    var Cylce_Code: String!
    var Move_Order: String!
    var Status_Owner_Type: String!
    var Favouring_User_Code: String!
    var User_Name: String!
    var Region_Name: String!
    var Remarks_Count: Int!
    var Order_No: Int!
    var User_Type_Name: String!
    var Expense_Claim_Screen_Mode: String!
    var Attachment_Count: Int!
    var Max_Order: String!
    var isSelected: Bool! = false
    
}

class ExpenseAttachmentList : NSObject
{
    var File_Name : String!
    var Claim_Code : String!
    var Image_File_Path : String!
}

class ExpenseClaimDetail :  NSObject
{
    var title: String!
    var value: String!
}
class ExpenseClaimTypeList : NSObject
{
    var Expense_Type_Name: String!
    var Expense_Amount: Float!
    var Approved_Amount: Float!
    var Total_Deduction: Float!
    var Expense_Type_Code: String!
}
class ExpenseClaimAdditionalTypeList : NSObject
{
    var Dcr_Actual_Date: String!
    var Category: String!
    var Dcr_Activity_Flag: String!
    var Claim_Detail_Code: String!
    var Expense_Type_Name: String!
    var Expense_Amount:Float!
    var Approved_Amount:Float!
    var Deduction_Amount:Float!
    var Remarks_By_User: String!
    var Managers_Approval_Remark: String!
    var Favouring_User_Code: String!
    var Expense_Type_Code: String!
    var isEdited: Bool = false
    var previousDeduction : Float = 0.0
    var Bill_Number : String!
}
class ExpenseViewDCRWiseDetailList: NSObject
{
    
    var DCR_Actual_Date: String!
    var Claim_Code: String!
    var DCR_Activity_Flag: String!
    var Expense_Type_Name: String!
    var Category: String!
    var DCR_Status: String!
    var Expense_Amount:Float!
    var Approved_Amount:Float!
    var Deduction_Amount:Float!
    var Remarks_By_User: String!
    var Managers_Approval_Remark: String!
    var Doctor_Visit_Count:Int!
    var User_Code: String!
    var DCR_Expense_Code: String!
    var Expense_Mode: String!
    var Expense_Type_Code: String!
    var Claim_Detail_Code: String!
    var DCR_Date: String!
    var Expense_Remarks: String!
    var Bill_Number: String!
    var isEdited: Bool = false
    var previousDeduction : Float = 0.0
}
class ExpenseClaimSFC : NSObject
{
    var From_Place: String!
    var To_Place: String!
    var Distance: Int!
    var Distance_Fare_Code: String!
    var Sfc_Version_No: String!
    var Category: String!
    var SFC_Visit_Count: Int!
    var Actual_Visit_Count: Int!
    var Trend: String!
    var Travel_Mode: String!
    var Region_Name: String!
    
}

class ExpenseClaimEligibility : NSObject
{
    var Eligibility_Amount:Float!
    var Expense_Mode: String!
    var Expense_Type_Name: String!
    var Approved_Amount:Float!
    var Expense_Amount:Float!
    var Eligible_Amount_Per_Num_Of_Applicable_Days:Double!
}
class ExpenseOtherDeduction : NSObject
{
    
}

class ExpensePaymentDetail : NSObject
{
    
}

class ExpenseRemarks :  NSObject
{
    var Updated_Date: String!
    var User_Name: String!
    var Remarks_By_User: String!
}

class ExpenseStatusHistory : NSObject
{
    var Status_Name: String!
    var Updated_By: String!
    var Updated_Date: String!
    var User_Type_Name: String!
}

class ExpenseDetailSectionList: NSObject
{
    var rowCount : Int!
    var isVisible : Bool!
    var emptyMessage: String!
    var sectioTitle: String!
    var rowHeight: CGFloat!
    var rowValueList: [Any]!
    var isSectionVisible : Bool!
}

class ApproveErrorTypeOne : Codable
{
    var Customer_Code : String!
    var MDL_Number : String!
    var Category_Name : String!
    var Customer_Name : String!
    var Campaign_Name : String!
    var Speciality_Name : String!
    var Hospital_Name : String!
    var isSelected : Bool = false
    
    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try container.decodeIfPresent(String.self, forKey: .isSelected)) != nil {
            self.isSelected = true
        }
        else
        {
            self.isSelected = false
        }
        if let Customer_Code = try container.decodeIfPresent(String.self, forKey: .Customer_Code) {
            self.Customer_Code = Customer_Code
        }
        if let Customer_Name = try container.decodeIfPresent(String.self, forKey: .Customer_Name) {
            self.Customer_Name = Customer_Name
        }
        if let MDL_Number = try container.decodeIfPresent(String.self, forKey: .MDL_Number) {
            self.MDL_Number = MDL_Number
        }
        if let Speciality_Name = try container.decodeIfPresent(String.self, forKey: .Speciality_Name) {
            self.Speciality_Name = Speciality_Name
        }
        if let Category_Name = try container.decodeIfPresent(String.self, forKey: .Category_Name) {
            self.Category_Name = Category_Name
        }
        if let Campaign_Name = try container.decodeIfPresent(String.self, forKey: .Campaign_Name) {
            self.Campaign_Name = Campaign_Name
        }
        if let Hospital_Name = try container.decodeIfPresent(String.self, forKey: .Hospital_Name) {
            self.Hospital_Name = Hospital_Name
        }
    }
}
class TPFreezeLockDict: Decodable
{
    var User_Code : String!
    var TP_Date : String!
    var Activity_Code : String!
    var Category : String!
    var Work_Area : String!
    var CP_name : String!
    var SFC : String!
}
class DoctorApprovalModelDict : Codable
{
    var Customer_Code : String!
    var Customer_Name : String!
    var MDL_Number : String!
    var Speciality_Name : String!
    var Category_Name : String!
    var Hospital_Name : String!
    var isSelected : Bool = false
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try container.decodeIfPresent(String.self, forKey: .isSelected)) != nil {
            self.isSelected = true
        } else {
            self.isSelected = false
        }
        if let Customer_Code = try container.decodeIfPresent(String.self, forKey: .Customer_Code) {
            self.Customer_Code = Customer_Code
        }
        if let Customer_Name = try container.decodeIfPresent(String.self, forKey: .Customer_Name) {
            self.Customer_Name = Customer_Name
        }
        if let MDL_Number = try container.decodeIfPresent(String.self, forKey: .MDL_Number) {
            self.MDL_Number = MDL_Number
        }
        if let Speciality_Name = try container.decodeIfPresent(String.self, forKey: .Speciality_Name) {
            self.Speciality_Name = Speciality_Name
        }
        if let Category_Name = try container.decodeIfPresent(String.self, forKey: .Category_Name) {
            self.Category_Name = Category_Name
        }
        if let Hospital_Name = try container.decodeIfPresent(String.self, forKey: .Hospital_Name) {
            self.Hospital_Name = Hospital_Name
        }
    }
}
class DoctorApprovalModelArray
{
    var List : [DoctorApprovalModelDict] = []
    var CustomerFirstChar : String
    
    init(dict:NSDictionary)
    {
        self.List = dict.value(forKey: "DoctorApprovalModelDictList") as! [DoctorApprovalModelDict]
        self.CustomerFirstChar = dict.value(forKey: "first") as! String
    }
}

enum APIStatus
{
    case Loading
    case Success
    case Failed
}

class BL_ExpenseClaim: NSObject
{
    static let sharedInstance : BL_ExpenseClaim  = BL_ExpenseClaim()
    var expenseDCRDetailList: [ExpenseViewDCRWiseDetailList] = []
    var expenseAdditionalDetailList: [ExpenseClaimAdditionalTypeList] = []
    var expenseDetailSectionList: [ExpenseDetailSectionList] = []
    var previousDeduction : Float!
    var otherDeduction : Float!
    var tempOtherDeduction : Float!
    
}

public class BStatusPotential : NSObject
{
    var Doctor_Code: String!
    var Doctor_Region_Code: String!
    var Dcr_Date: String!
    var Business_Status_Id: Int!
    var Business_Status_Name: String!
    var Entity_Type: Int!
    var Entity_Description: String?
    var Division_Code: String?
    var Product_Code: String?
    var Business_Potential : Float = 0.0
}
