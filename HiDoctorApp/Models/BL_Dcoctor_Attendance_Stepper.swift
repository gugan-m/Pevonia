 //
//  BL_Dcoctor_Attendance_Stepper.swift
//  HiDoctorApp
//
//  Created by Swaas on 21/09/18.
//  Copyright © 2018 swaas. All rights reserved.
//

class BL_Doctor_Attendance_Stepper: NSObject
{
    static let sharedInstance = BL_Doctor_Attendance_Stepper()
    
    var stepperDataList: [DCRStepperModel] = []
    var doctorVisitList : [DCRAttendanceDoctorModel] = []
    var sampleList : [SampleBatchProductModel] = []
    var activitStepperData: [ActivityMainStepperObj] = []
    var dcrId: Int!
    var stepperIndex: DoctorVisitStepperIndex = DoctorVisitStepperIndex()
    var skipIndex: Int!
    
    
    
    func generateDataArray()
    {
        self.dcrId = DCRModel.sharedInstance.dcrId
        
        clearAllArray()
        self.setIndex()
        self.getDoctorVisitData()
        self.getSampleListData()
        self.getActivityData()
        self.determineButtonStatus()
        
    }
    
    func clearAllArray()
    {
        stepperDataList = []
        doctorVisitList = []
        sampleList = []
        activitStepperData = []
    }
    
    func setIndex()
    {
        stepperIndex.doctorVisitIndex = 0
        stepperIndex.sampleIndex = 1
        stepperIndex.activity = 2
    }
    
    private func getDoctorVisitData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(appDoctor) Visit Details"
        stepperObjModel.emptyStateTitle = "\(appDoctor) Visit Details"
        stepperObjModel.emptyStateSubTitle = "Update details of \(appDoctor) visits(i.e. time, POB, etc..)"
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        if DCRModel.sharedInstance.customerCode != nil && DCRModel.sharedInstance.customerCode == ""
        {
            let doctorVisitList = getDCRAttendanceDoctorVisitFlexiDoctor(doctorVisitId: getDCRDoctorVisitId())
            if doctorVisitList.count > 0
            {
                self.doctorVisitList = doctorVisitList
                stepperObjModel.recordCount = doctorVisitList.count
            }
            
        }
        else if DCRModel.sharedInstance.customerCode != nil
        {
            let doctorVisitList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisit()
            if doctorVisitList.count > 0
            {
                self.doctorVisitList = doctorVisitList
                stepperObjModel.recordCount = doctorVisitList.count
            }
        }
        stepperDataList.append(stepperObjModel)
    }
    
    private func getSampleListData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Samples / Promotional Items"
        stepperObjModel.emptyStateTitle = "Samples / Promotional Items"
        stepperObjModel.emptyStateSubTitle = "Update details of sample / promotional item issues"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD SAMPLE"
        
        if doctorVisitList.count > 0
        {
            let attendanceSamplelist = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisitSamples(doctorVisitId: getDCRDoctorVisitId())
            
            let sampleProductList = BL_DCR_Attendance.sharedInstance.convertAttendanceSampleToDCRSample(list: attendanceSamplelist)
            let sampleBatchProductList = getSampleBatchProducts()
            if sampleProductList != nil
            {
                var sampleDataList : [SampleBatchProductModel] = []
                for sampleObj in sampleProductList
                {
                    var sampleModelList:[DCRSampleModel] = []
                    let sampleBatchObj = SampleBatchProductModel()
                    sampleBatchObj.title = sampleObj.sampleObj.Product_Name
                    
                    let filterValue = sampleBatchProductList.filter{
                        $0.Ref_Id == sampleObj.sampleObj.DCR_Sample_Id
                    }
                    if(filterValue.count > 0)
                    {
                        for obj in filterValue
                        {
                            //                            let sampleBatchObj = sampleObj
                            //                            sampleBatchObj.sampleObj.Batch_Name = obj.Batch_Number
                            //                            sampleBatchObj.sampleObj.Quantity_Provided = obj.Quantity_Provided
                            //                            sampleModelList.append(sampleBatchObj)
                            
                            let sampleProductObj = SampleProductsModel()
                            sampleProductObj.Batch_Current_Stock =  obj.Quantity_Provided
                            sampleProductObj.Batch_Name = obj.Batch_Number
                            sampleProductObj.Current_Stock = sampleObj.sampleObj.Current_Stock
                            sampleProductObj.DCR_Code = sampleObj.sampleObj.DCR_Code
                            sampleProductObj.Product_Name = sampleObj.sampleObj.Product_Name
                            sampleProductObj.Product_Code = sampleObj.sampleObj.Product_Code
                            sampleProductObj.Quantity_Provided = obj.Quantity_Provided
                            sampleProductObj.DCR_Id = sampleObj.sampleObj.DCR_Id
                            sampleProductObj.DCR_Doctor_Visit_Id = sampleObj.sampleObj.DCR_Doctor_Visit_Id
                            sampleProductObj.DCR_Doctor_Visit_Code = sampleObj.sampleObj.DCR_Doctor_Visit_Code
                            let dict = DCRSampleModel(sampleObj: sampleProductObj)
                            sampleModelList.append(dict)
                        }
                        sampleBatchObj.title = sampleObj.sampleObj.Product_Name
                        sampleBatchObj.isShowSection = true
                        sampleBatchObj.sampleList = sampleModelList
                        sampleDataList.append(sampleBatchObj)
                    }
                }
                if((sampleProductList.count) > 0)
                {
                    let sampleBatchObj = SampleBatchProductModel()
                    var sampleModelList:[DCRSampleModel] = []
                    sampleBatchObj.title = ""
                    sampleBatchObj.isShowSection = false
                    for sampleObj in sampleProductList
                    {
                        
                        let filterValue = sampleBatchProductList.filter{
                            $0.Ref_Id == sampleObj.sampleObj.DCR_Sample_Id
                        }
                        if(filterValue.count == 0)
                        {
                            sampleModelList.append(sampleObj)
                        }
                        
                    }
                    if(sampleModelList.count > 0)
                    {
                        sampleBatchObj.sampleList = sampleModelList
                        sampleDataList.append(sampleBatchObj)
                    }
                }
                self.sampleList = sampleDataList
                stepperObjModel.recordCount = sampleDataList.count
            }
        }
        
        
        
        stepperDataList.append(stepperObjModel)

    }
    
    func getActivityData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        stepperObjModel.sectionTitle = "Activity"
        stepperObjModel.emptyStateTitle = "Activity"
        stepperObjModel.emptyStateSubTitle = "Update Activity details here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD ACTIVITY"
        
        var activityList: [DCRActivityCallType] = []
        var mcActivityList: [DCRMCActivityCallType] = []
        if doctorVisitList.count > 0
        {
            activityList = BL_Activity_Stepper.sharedInstance.getCallActivityList()
            mcActivityList = BL_Activity_Stepper.sharedInstance.getMCCallActivityList()
            
            let activityData = getActivityDisplayData(activity: activityList, mcActivity: mcActivityList)
            
            if(activityData != nil)
            {
                self.activitStepperData =  activityData
                stepperObjModel.recordCount = (activityData.count)
            }
        }
        
        
        stepperDataList.append(stepperObjModel)
    
        
    }
    
    private func determineButtonStatus()
    {
        if(skipIndex == nil)
        {
            if doctorVisitList.count == 0
            {
            stepperDataList[0].showEmptyStateAddButton = true
            stepperDataList[0].showEmptyStateSkipButton = true
            }
            else if doctorVisitList.count > 0 && sampleList.count == 0 && activitStepperData.count == 0
            {
                stepperDataList[1].showEmptyStateAddButton = true
                stepperDataList[1].showEmptyStateSkipButton = true
            }
            else if doctorVisitList.count > 0 && sampleList.count > 0
            {
                stepperDataList[2].showEmptyStateAddButton = true
                stepperDataList[2].showEmptyStateSkipButton = false
            }
            else if doctorVisitList.count > 0 && activitStepperData.count > 0
            {
                stepperDataList[1].showEmptyStateAddButton = true
                stepperDataList[1].showEmptyStateSkipButton = false
            }
        }
        else if (doctorVisitList.count == 0 || skipIndex == 0)
        {
            if doctorVisitList.count == 0
            {
                stepperDataList[0].showEmptyStateAddButton = true
                stepperDataList[0].showEmptyStateSkipButton = true
            }
            else if doctorVisitList.count > 0 && sampleList.count > 0
            {
                stepperDataList[2].showEmptyStateAddButton = true
                stepperDataList[2].showEmptyStateSkipButton = false
            }
            else
            {
                stepperDataList[1].showEmptyStateAddButton = true
                stepperDataList[1].showEmptyStateSkipButton = true
            }
        }
        else if(skipIndex == 1)
        {
            if (doctorVisitList.count == 0)
            {
                stepperDataList[0].showEmptyStateAddButton = true
                stepperDataList[0].showEmptyStateSkipButton = true
            }
            
            if(sampleList.count > 0)
            {
                stepperDataList[2].showEmptyStateAddButton = true
                stepperDataList[2].showEmptyStateSkipButton = false
            }
            else
            {
                stepperDataList[1].showEmptyStateAddButton = true
                stepperDataList[1].showEmptyStateSkipButton = true
                stepperDataList[2].showEmptyStateAddButton = true
                stepperDataList[2].showEmptyStateSkipButton = false
            }
            
        }        
    }
    
    func getDCRAttendanceDoctorVisitFlexiDoctor(doctorVisitId : Int) -> [DCRAttendanceDoctorModel]
    {
        return DAL_DCR_Attendance.sharedInstance.getAttendanceDoctorVisitDetailFlexiDoctor(dcrId: getDCRId(), doctorVisitId: doctorVisitId)
    }
    
    func getSampleBatchProducts() -> [DCRSampleBatchModel]
    {
        return BL_SampleProducts.sharedInstance.getSampleBatchDCRProducts(dcrId: getDCRId(), visitId: getDCRDoctorVisitId(), entityType: sampleBatchEntity.Attendance.rawValue)
    }
    
    func getActivityDisplayData(activity:[DCRActivityCallType],mcActivity:[DCRMCActivityCallType]) -> [ActivityMainStepperObj]
    {
        if(activity.count > 0)
        {
            var activityObjList:[ActivityMainStepperObj] = []
            for activityData in activity
            {
                let activityObj = ActivityMainStepperObj()
                activityObj.activityName = activityData.Customer_Activity_Name
                activityObj.activityRemarks = activityData.Activity_Remarks
                
                activityObjList.append(activityObj)
            }
            return activityObjList
        }
        else if(mcActivity.count > 0)
        {
            var activityObjList:[ActivityMainStepperObj] = []
            for activityData in mcActivity
            {
                let activityObj = ActivityMainStepperObj()
                activityObj.activityName = activityData.Campaign_Name + "\n" + activityData.MC_Activity_Name
                activityObj.activityRemarks = activityData.MC_Activity_Remarks
                
                activityObjList.append(activityObj)
            }
            return activityObjList
        }
        else
        {
            return []
        }
        
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    func getDCRDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.doctorVisitId
    }
    
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = self.stepperDataList[selectedIndex]
        
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
    
    func getDoctorVisitDetailSingleHeight() -> CGFloat
    {
        let topSpace : CGFloat = 0
        let bottomSpace : CGFloat = 15
        let line1VerticalSpacing : CGFloat = 10
        let verticalSpacingBtnlines : CGFloat = 20
        let visitModeHeight: CGFloat = 15
        let visitModeLblHeight : CGFloat = 13
        let remarksHeight : CGFloat = 15
        var businessStatus = String()
        var callObjective = String()
        var campaignName = String()
        
        if(doctorVisitList[0].Business_Status_Name.count > 0)
        {
            businessStatus = doctorVisitList[0].Business_Status_Name!
        }
        else
        {
            businessStatus = "N/A"
        }
        
        if (doctorVisitList[0].Call_Objective_Name.count > 0)
        {
            callObjective = doctorVisitList[0].Call_Objective_Name!
        }
        else
        {
            callObjective = "N/A"
        }
        
        
        if (doctorVisitList[0].Campaign_Name.count > 0)
        {
            campaignName = doctorVisitList[0].Campaign_Name!
        }
        else
        {
            campaignName = "N/A"
        }
        
        let businessDisplay = "Business Status\n\n" + businessStatus
        let callObjDisplay = "\n\nCall Objective\n\n" + callObjective
        let campaignDisplay = "\n\nCampaign Name\n\n" + campaignName
        let remarksDisplay = "\n\n\n"
        
        let businessStatusHeight : CGFloat = getTextSize(text: businessDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let callObjectyiveHeight : CGFloat = getTextSize(text: callObjDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let remarksNewLineHeight: CGFloat = getTextSize(text: remarksDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let campaignHeight : CGFloat = getTextSize(text: campaignDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let remarks = doctorVisitList[0].Remarks
        let remarksLblheight : CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let cellHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight + businessStatusHeight + callObjectyiveHeight + remarksNewLineHeight + campaignHeight
        return cellHeight
    }
    
    func getDoctorVisitDetailHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = self.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var childTableHeight: CGFloat = 0
        
        let topSpace : CGFloat = 0
        let bottomSpace : CGFloat = 15
        let line1VerticalSpacing : CGFloat = 10
        let verticalSpacingBtnlines : CGFloat = 20
        let visitModeHeight: CGFloat = 15
        let visitModeLblHeight : CGFloat = 13
        let remarksHeight : CGFloat = 15
        let remarks = doctorVisitList[0].Remarks
        let remarksLblheight : CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        var businessStatus = String()
        var callObjective = String()
        var campaignName = String()
        
        if(doctorVisitList[0].Business_Status_Name.count > 0)
        {
            businessStatus = doctorVisitList[0].Business_Status_Name!
        }
        else
        {
            businessStatus = "N/A"
        }
        
        if (doctorVisitList[0].Call_Objective_Name.count > 0)
        {
            callObjective = doctorVisitList[0].Call_Objective_Name!
        }
        else
        {
            callObjective = "N/A"
        }
        
        if (doctorVisitList[0].Campaign_Name.count > 0)
        {
            campaignName = doctorVisitList[0].Campaign_Name!
        }
        else
        {
            campaignName = "N/A"
        }
        
        let businessDisplay = "Business Status\n\n" + businessStatus
        let callObjDisplay = "\n\nCall Objective\n\n" + callObjective
        let campaignDisplay = "\n\nCampaign Name\n\n" + campaignName
        let remarksDisplay = "\n\n\n"
        
        let businessStatusHeight : CGFloat = getTextSize(text: businessDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let callObjectyiveHeight : CGFloat = getTextSize(text: callObjDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
         let campaignHeight : CGFloat = getTextSize(text: campaignDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let remarksNewLineHeight: CGFloat = getTextSize(text: remarksDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        childTableHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + businessStatusHeight + callObjectyiveHeight + remarksNewLineHeight + campaignHeight
        
        if (stepperObj.isExpanded == false)
        {
            totalHeight = totalHeight - remarksHeight - line1VerticalSpacing - remarksLblheight - businessStatusHeight - callObjectyiveHeight - remarksNewLineHeight
        }
        
        return totalHeight
    }
    
    func getSampleBatchHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = stepperDataList[selectedIndex]
        let sampleBatchList = sampleList
        
        let topSpace : CGFloat = 20
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var childTableHeight: CGFloat = 0
        
        for sampleBatchobj in sampleBatchList
        {
            for obj in sampleBatchobj.sampleList
            {
                let sampleObj = obj.sampleObj
                let line1Height = getTextSize(text: sampleObj.Product_Name, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
                let quantityText = String(format: "%d", (sampleObj.Quantity_Provided)!)
                let line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
                childTableHeight += line1Height + line2Height + 35
            }
            
            childTableHeight += 40
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + topSpace
        
        if (stepperObj.isExpanded == false)
        {
            totalHeight = 250
            
        }
        
        return totalHeight
    }
    
    func getSampleBatchSingleHeight(section:Int,row:Int) -> CGFloat
    {
        let sampleObj = sampleList[section].sampleList[0].sampleObj
        let line1Height = getTextSize(text: sampleObj.Product_Name, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let quantityText = String(format: "%d", (sampleObj.Quantity_Provided)!)
        let line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        return  line1Height + line2Height + 35
    }
    
    func getDoctorVisitSampleHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = stepperDataList[selectedIndex]
        
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
        
            let activityObj = activitStepperData[selectedIndex]
            line1Height = getTextSize(text: activityObj.activityName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            line2Height = getTextSize(text: activityObj.activityRemarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        return topSpace + verticalSpacing + bottomSpace + line1Height + line2Height
    }
    
}
