  //
//  BL_Activity_Stepper.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

class BL_Activity_Stepper: NSObject
{
    
static let sharedInstance = BL_Activity_Stepper()

//MARK:- Private Variables

    var stepperDataList: [DCRStepperModel] = []
    var callTypeList: [DCRActivityCallType] = []
    var mcActivityList: [DCRMCActivityCallType] = []
    var dcrId: Int!
    var stepperIndex: ActivityStepperIndex!
    var skipIndex: Int!
    var isFromAttendance : Bool = false
    
    
    func generateDataArray()
    {
        self.dcrId = DCRModel.sharedInstance.dcrId
       
        clearAllArray()
        getCallTypeData()
        getmcActivityData()
        
        determineButtonStatus()
    }
    
    func clearAllArray()
    {
        stepperDataList = []
        callTypeList = []
        mcActivityList = []
    }
    
    private func getCallTypeData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Call Type Details"
        stepperObjModel.emptyStateTitle = "Call Type Details"
        stepperObjModel.emptyStateSubTitle = "Update details of the Call Type"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD ACTIVITY"
        
        let activityList = getCallActivityList()
        if activityList.count > 0
        {
            self.callTypeList = activityList
            stepperObjModel.recordCount = callTypeList.count
        }
         stepperDataList.append(stepperObjModel)
    }
    
    private func getmcActivityData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "MC Activity Details"
        stepperObjModel.emptyStateTitle = "MC Activity Details"
        stepperObjModel.emptyStateSubTitle = "Update details of the MC Activity Details"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD MCACTIVITY"
        let mcActivityList = getMCCallActivityList()
        if mcActivityList.count > 0
        {
            self.mcActivityList = mcActivityList
            stepperObjModel.recordCount = mcActivityList.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func determineButtonStatus()
    {
        if(skipIndex != nil)
        {
            stepperDataList[skipIndex-1].showEmptyStateAddButton = true
            stepperDataList[skipIndex-1].showEmptyStateSkipButton = true
           mcActivitystate()
        }
        else if (callTypeList.count == 0)
        {
            let activityList = DBHelper.sharedInstance.getCallActivity()
            if(activityList.count > 0)
            {
                stepperDataList[0].showEmptyStateAddButton = true
                stepperDataList[0].showEmptyStateSkipButton = true
              //  stepperDataList[1].showEmptyStateAddButton = true
              //  stepperDataList[1].showEmptyStateSkipButton = false
            }
            else
            {
                stepperDataList[0].showEmptyStateAddButton = false
                stepperDataList[0].showEmptyStateSkipButton = false
                stepperDataList[0].emptyStateSubTitle = "No Activity available"
             mcActivitystate()
            }
            
            
        }
        else
        {
            mcActivitystate()
        }
       
    }
    func mcActivitystate()
    {
        if( DCRModel.sharedInstance.customerCode == nil){
             DCRModel.sharedInstance.customerCode == ""
        }

        let mcActivityList = DBHelper.sharedInstance.getMCList(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
        if(mcActivityList.count > 0)
        {
            stepperDataList[1].showEmptyStateAddButton = true
            stepperDataList[1].showEmptyStateSkipButton = false
        }
        else
        {
            stepperDataList[1].showEmptyStateAddButton = false
            stepperDataList[1].showEmptyStateSkipButton = false
            stepperDataList[1].emptyStateSubTitle = "No MC Activity available"
        }

    }
    func getCallActivityList() -> [DCRActivityCallType]
    {
        if isFromAttendance
        {
            return DBHelper.sharedInstance.getCallActivityList(dcrId:getDCRId(),doctorVisitCode: getDoctorVisitId(), entityType: sampleBatchEntity.Attendance.rawValue)
        }
        else
        {
           return DBHelper.sharedInstance.getCallActivityList(dcrId:getDCRId(),doctorVisitCode: getDoctorVisitId(),entityType: sampleBatchEntity.Doctor.rawValue)
        }
    }
    
    func getMCCallActivityList() -> [DCRMCActivityCallType]
    {
        if isFromAttendance
        {
        return DBHelper.sharedInstance.getMcCallActivityList(dcrId:getDCRId(),doctorVisitCode: getDoctorVisitId(),entityType: sampleBatchEntity.Attendance.rawValue)
        }
        else
        {
           return DBHelper.sharedInstance.getMcCallActivityList(dcrId:getDCRId(),doctorVisitCode: getDoctorVisitId(),entityType: sampleBatchEntity.Doctor.rawValue)
        }
    }
    
    private func getDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.customerVisitId
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    func getDoctorVisitSampleHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Activity_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpace : CGFloat = 20
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
        
        for i in 0..<numberOfRows
        {
            childTableHeight += getDoctorVisitSampleSingleHeight(selectedIndex: i, parentIndex: selectedIndex)
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + topSpace
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getDoctorVisitSampleSingleHeight(selectedIndex : Int, parentIndex : Int) -> CGFloat
    {
        let topSpace: CGFloat = 0
        let verticalSpacing : CGFloat = 10
        let bottomSpace: CGFloat = 15
        var line1Height : CGFloat = 0
        var line2Height : CGFloat = 0
        
        if parentIndex == 0
        {
            let productName = callTypeList[selectedIndex].Customer_Activity_Name
            line1Height = getTextSize(text: productName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let quantityText = "Remarks:" + "\n" + callTypeList[selectedIndex].Activity_Remarks
            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        else if parentIndex == 1
        {
            let MCName = self.mcActivityList[selectedIndex].Campaign_Name
            let productName = self.mcActivityList[selectedIndex].MC_Activity_Name
            line1Height = getTextSize(text: MCName! + "\n" + productName!, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let quantityText = "Remarks:" + "\n" +  self.mcActivityList[selectedIndex].MC_Activity_Remarks
            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        
//        if parentIndex == stepperIndex.pobIndex
//        {
//            let orderEntryId = pobDataList[selectedIndex].Order_Entry_Id
//            let stockiestCode = pobDataList[selectedIndex].Stockiest_Code
//            let stockiestName = pobDataList[selectedIndex].Stockiest_Name
//
//            line1Height = getTextSize(text: stockiestName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//
//            let noOfProduct = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: orderEntryId!)
//            let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: orderEntryId!)
//
//            let quantityText = String(format: "POB: "+"%d"+"| No Of Product"+"%d", noOfProduct,totalAmount)
//
//            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//
//
//        }
//
//        //        if parentIndex == stepperIndex.chemistIndex
//        //        {
//        //            let chemistName = chemistVisitList[selectedIndex].Chemist_Name
//        //            line1Height = getTextSize(text: chemistName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//        //            var pobAmount : Float = 0
//        //            if chemistVisitList[selectedIndex].POB_Amount != nil
//        //            {
//        //                pobAmount = chemistVisitList[selectedIndex].POB_Amount!
//        //            }
//        //            let subTitleText = String(format: "POB: %.2f |", pobAmount)
//        //            line2Height = getTextSize(text: subTitleText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//        //        }
//        //
//        if parentIndex == stepperIndex.followUpIndex
//        {
//            let followUpText = followUpList[selectedIndex].Task
//            line1Height = getTextSize(text: followUpText, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//            let dateString = convertDateIntoString(date: followUpList[selectedIndex].DueDate)
//            line2Height = getTextSize(text: dateString, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//        }
//
//        if(parentIndex == stepperIndex.rcpaDetailIndex)
//        {
//            let RCPADoctorName = rcpaDataList[selectedIndex].DoctorName
//            line1Height = getTextSize(text: RCPADoctorName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//
//            let RCPADoctorMDL = rcpaDataList[selectedIndex].DoctorMDLNumber
//            line2Height = getTextSize(text: "MDL Number: \(RCPADoctorMDL!)", fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//
//
//        }
//
        return topSpace + verticalSpacing + bottomSpace + line1Height + line2Height
    }
    
   
    
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Activity_Stepper.sharedInstance.stepperDataList[selectedIndex]
        let topSpaceToContainer: CGFloat = 2
        let titleLabelHeight: CGFloat = 14.0
        let verticalSpaceBetweenTitleAndSubTitle: CGFloat = 6
        let subTitleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateSubTitle, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - (48 + 8))).height
        let verticalSpaceBetweenButtonAndSubTitle: CGFloat = 13
        var buttonHeight: CGFloat = 0
        
        if (stepperObj.showEmptyStateAddButton == true)
        {
            buttonHeight = 30
        }
        
        let bottomSpace: CGFloat = 20
        
        return topSpaceToContainer + titleLabelHeight + verticalSpaceBetweenTitleAndSubTitle + subTitleLabelHeight + verticalSpaceBetweenButtonAndSubTitle + buttonHeight + bottomSpace
    }
    
}
