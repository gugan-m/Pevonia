//
//  BL_DCR_Doctor_Visit.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Doctor_Visit: NSObject
{
    static let sharedInstance = BL_DCR_Doctor_Visit()
    
    var stepperDataList: [DCRStepperModel] = []
    var stepperIndex: DoctorVisitStepperIndex = DoctorVisitStepperIndex()
    var doctorVisitList : [DCRDoctorVisitModel] = []
    var accompanistList: [DCRDoctorAccompanist] = []
    var sampleList : [SampleBatchProductModel] = []
    var detailProductList : [DetailProductMaster] = []
    var assetList : [AssetsModel] = []
    var chemistVisitList : [DCRChemistVisitModel] = []
    var stockistVisitList : [DCRStockistVisitModel] = []
    var followUpList : [DCRFollowUpModel] = []
    var attachmentList : [DCRAttachmentModel] = []
    var pobDataList : [DCRDoctorVisitPOBHeaderModel] = []
    var activitStepperData: [ActivityMainStepperObj] = []
    var customerId : Int!
    var cpTab : Bool = false
    var tpTab : Bool = false
    var getAccompanistIndex : Int = 0
    var dynmicOrderData:[String] = []
    var dynamicArrayValue : Int = 0
    var showAddButton : Int = 0 //for show add button
    var showSkipButton : [Bool] = [] // for show button
    var skipFromController = [Bool](repeating: false, count: 10)
    var isModify : Bool = false
    
    //MARK:- Stepper functions
    func clearAllArray()
    {
        doctorVisitList = []
        accompanistList = []
        sampleList = []
        detailProductList = []
        assetList = []
        chemistVisitList = []
        followUpList = []
        attachmentList = []
        showSkipButton = []
        stepperDataList = []
        activitStepperData = []
    }
    
    func generateDataArray()
    {
        if(dynamicArrayValue == 0)
        {
            clearAllArray()
            
            updateStepperIndex(isUpdate: false)
        }
        
        if (dynmicOrderData.count > dynamicArrayValue)
        {
            if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.visit)
            {
                self.getDoctorVisitData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.accompanist)
            {
                self.getAccompanistData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.detailing)
            {
                    self.getDetailProductData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.samples)
            {
                self.getSampleProductData()
            }
            
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.assets)
            {
                self.getAssetData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.followUp)
            {
                self.getFollowupData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.attachment)
            {
                self.getAttachmentData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.RCPA)
            {
                if(!BL_Stepper.sharedInstance.isChemistDayEnabled())
                {
                    self.getChemistData()
                }
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.pob)
            {
                self.getPOBData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.activity)
            {
                self.getActivityData()
            }
            
            if(stepperDataList[stepperIndex.doctorVisitIndex].recordCount > 0)
            {
                if( stepperIndex.doctorVisitIndex+1 != stepperIndex.accompanistIndex)
                {
                    updateAddSkipButton(index: stepperIndex.doctorVisitIndex+1)
                }
                else
                {
                    updateAddSkipButton(index: stepperIndex.doctorVisitIndex+2)
                }
            }
        }
    }
    
    func updateStepperButtonStatus()
    {
        determineButtonStatus()
    }
    
    func updateAddSkipButton(index:Int)//after chemist Vist
    {
        if(stepperIndex.detailedProduct == index)
        {
            stepperDataList[index].showEmptyStateAddButton = true
            
            if getDetailedProductMandatoryNumber() == 0
            {
                stepperDataList[index].showEmptyStateSkipButton = true
            }
            else
            {
                stepperDataList[index].showEmptyStateSkipButton = false
            }
        }
        else if(stepperIndex.sampleIndex == index)
        {
            stepperDataList[index].showEmptyStateAddButton = true
            
            if getInputMandatoryNumber() == 0
            {
                stepperDataList[index].showEmptyStateSkipButton = true
            }
            else
            {
                stepperDataList[index].showEmptyStateSkipButton = false
            }
            
        }
        else
        {
            stepperDataList[index].showEmptyStateAddButton = true
            stepperDataList[index].showEmptyStateSkipButton = true
        }
        
    }
    
    private func updateStepperIndex(isUpdate:Bool)
    {
        if(dynmicOrderData.count >= dynamicArrayValue)
        {
            stepperIndex.doctorVisitIndex = 0
            stepperIndex.accompanistIndex = -1
            stepperIndex.sampleIndex = -1
            stepperIndex.detailedProduct = -1
            stepperIndex.assetIndex = -1
            stepperIndex.chemistIndex = -1
            stepperIndex.followUpIndex = -1
            stepperIndex.attachmentIndex = -1
            stepperIndex.pobIndex = -1
            stepperIndex.rcpaDetailIndex = -1
            stepperIndex.activity = -1
            
            for j in 0..<dynmicOrderData.count
            {
                if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.visit)
                {
                    stepperIndex.doctorVisitIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.accompanist)
                {
                    /*  if(isUpdate)
                     {
                     if(j != 1 && showAddButton > 0 && showAddButton != dynmicOrderData.count-1)
                     {
                     showAddButton -= 1
                     }
                     }*/
                    stepperIndex.accompanistIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.samples)
                {
                    stepperIndex.sampleIndex = j
                    
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.detailing)
                {
                    stepperIndex.detailedProduct = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.assets)
                {
                    stepperIndex.assetIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.followUp)
                {
                    stepperIndex.followUpIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.attachment)
                {
                    stepperIndex.attachmentIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.RCPA)
                {
                    stepperIndex.chemistIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.pob)
                {
                    stepperIndex.pobIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.activity)
                {
                    stepperIndex.activity = j
                }
                
                
            }
        }
    }
    
    private func getDoctorVisitData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(appDoctor) Visit Details"
        stepperObjModel.emptyStateTitle = "\(appDoctor) Visit Details"
        stepperObjModel.emptyStateSubTitle = "Update details of \(appDoctor) visits(i.e. time, POB, etc..)"
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = ""
        
        if DCRModel.sharedInstance.customerCode == ""
        {
            let doctorVisitList = getDCRDoctorVisitFlexiDoctor(doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
            if doctorVisitList != nil
            {
                self.doctorVisitList = doctorVisitList!
                stepperObjModel.recordCount = doctorVisitList!.count
            }
        }
        else
        {
            let doctorVisitList = getDCRDoctorVisitList()
            if doctorVisitList != nil
            {
                self.doctorVisitList = doctorVisitList!
                stepperObjModel.recordCount = doctorVisitList!.count
            }
        }
        
        //stepperDataList.append(stepperObjModel)
        
        showSkipButton.append(true)
        
        if(self.doctorVisitList.count != 0)
        {
            showAddButton += 1
        }
        
        stepperDataList.append(stepperObjModel)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    func getAccompanistData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(PEV_ACCOMPANIST) Details"
        stepperObjModel.emptyStateTitle = "\(PEV_ACCOMPANIST) Details"
        stepperObjModel.emptyStateSubTitle = "Update details of the user who worked with you"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD ACCOMPANIST"
        
        if (doctorVisitList.count > 0  && stepperIndex.accompanistIndex != 0)
        {
            let accompanistList = getDoctorAccompanist(doctorVisitId: getDCRDoctorVisitId(), dcrId: getDCRId())
            if accompanistList != nil
            {
                self.accompanistList = accompanistList!
                stepperObjModel.recordCount = accompanistList!.count
            }
        }
        
        // stepperDataList.append(stepperObjModel)
        
        showSkipButton.append(true)
        
        if(self.doctorVisitList.count != 0)
        {
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            if(dynmicOrderData.count-1 != stepperIndex.accompanistIndex)
            {
                showAddButton += 1
            }
        }
        
        
        stepperDataList.append(stepperObjModel)
        enableAddShowButton(index: stepperIndex.accompanistIndex)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    private func getSampleProductData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Samples / Promotional Items"
        stepperObjModel.emptyStateTitle = "Samples / Promotional Items"
        stepperObjModel.emptyStateSubTitle = "Update details of sample / promotional item issues"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD SAMPLE"
        
        if doctorVisitList.count > 0
        {
            let sampleProductList = getSampleProducts()
            let sampleBatchProductList = getSampleBatchProducts()
            if sampleProductList != nil
            {
                var sampleDataList : [SampleBatchProductModel] = []
                for sampleObj in sampleProductList!
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
                if((sampleProductList?.count)! > 0)
                {
                    let sampleBatchObj = SampleBatchProductModel()
                    var sampleModelList:[DCRSampleModel] = []
                    sampleBatchObj.title = ""
                    sampleBatchObj.isShowSection = false
                    for sampleObj in sampleProductList!
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
        
        // stepperDataList.append(stepperObjModel)
        
        if getInputMandatoryNumber() == 0
        {
            showSkipButton.append(true)
        }
        else
        {
            showSkipButton.append(false)
        }
        
        
        if(skipFromController[stepperIndex.sampleIndex])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            if getInputMandatoryNumber() == 0
            {
                stepperObjModel.showEmptyStateSkipButton = true
            }
            else
            {
                stepperObjModel.showEmptyStateSkipButton = false
            }
            
        }
        else if(self.sampleList.count != 0)
        {
            if(getInputMandatoryNumber() <= self.sampleList.count)
            {
                showAddButton += 1
            }
            else
            {
                showToastView(toastText: " You need to enter minimum of \(String(getInputMandatoryNumber())) input")
            }
            
        }
        
        
        stepperDataList.append(stepperObjModel)
        
        enableAddShowButton(index: stepperIndex.sampleIndex)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    private func getDetailProductData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Detailed Products"
        stepperObjModel.emptyStateTitle = "Detailed Products"
        stepperObjModel.emptyStateSubTitle = "Update the products detailed, business status, business potential and remarks information here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD PRODUCTS"
        
        if doctorVisitList.count > 0
        {
            let detailedProductList = getDetailedProducts(dcrId: getDCRId(), doctorVisitId: getDCRDoctorVisitId())
            if detailedProductList != nil
            {
                self.detailProductList = detailedProductList!
                stepperObjModel.recordCount = detailedProductList!.count
            }
        }
        
        // stepperDataList.append(stepperObjModel)
        
        if(getDetailedProductMandatoryNumber() == 0)
        {
            showSkipButton.append(true)
        }
        else
        {
            showSkipButton.append(false)
        }
        
        if(skipFromController[stepperIndex.detailedProduct])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            //getChemistMandatoryNumber()
            if getDetailedProductMandatoryNumber() == 0
            {
                stepperObjModel.showEmptyStateSkipButton = true
            }
            else
            {
                stepperObjModel.showEmptyStateSkipButton = false
            }
            
        }
        else if(self.detailProductList.count != 0)
        {
            if(getDetailedProductMandatoryNumber() <= self.detailProductList.count)
            {
                showAddButton += 1
            }
            else
            {
                showToastView(toastText: " You need to enter minimum of \(String(getDetailedProductMandatoryNumber())) detailing product(s)")
            }
        }
        
        stepperDataList.append(stepperObjModel)
        
        enableAddShowButton(index: stepperIndex.detailedProduct)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    private func getAssetData()
    {
        if showAssetCard()
        {
            let stepperObjModel: DCRStepperModel = DCRStepperModel()
            
            stepperObjModel.sectionTitle = "PEV_DIGITAL_ASSETS"
            stepperObjModel.emptyStateTitle = PEV_DIGITAL_ASSETS
            stepperObjModel.emptyStateSubTitle = "Update the details of the \(PEV_DIGITAL_ASSETS)"
            stepperObjModel.sectionIconName = "icon-stepper-two-user"
            stepperObjModel.isExpanded = false
            stepperObjModel.leftButtonTitle = ""
            
            if doctorVisitList.count > 0
            {
                let assetListing = getDCRDoctorAssetDetails()
                if assetListing.count > 0
                {
                    self.assetList = assetListing
                    stepperObjModel.recordCount = assetListing.count
                }
            }
            
            // stepperDataList.append(stepperObjModel)
            
            showSkipButton.append(true)
            
            if(skipFromController[stepperIndex.assetIndex])
            {
                showAddButton += 1
                stepperObjModel.showEmptyStateAddButton = true
                stepperObjModel.showEmptyStateSkipButton = true
                
            }
            else if(self.assetList.count != 0)
            {
                showAddButton += 1
            }
            
            stepperDataList.append(stepperObjModel)
            
            enableAddShowButton(index: stepperIndex.assetIndex)
            dynamicArrayValue += 1
            self.generateDataArray()
        }
    }
    
    private func getChemistData()
    {
        if (!BL_Stepper.sharedInstance.isChemistDayEnabled())
        {
            let stepperObjModel: DCRStepperModel = DCRStepperModel()
            
            stepperObjModel.sectionTitle = "\(appChemist) Visits"
            stepperObjModel.emptyStateTitle = "\(appChemist) Visits (Optional)"
            stepperObjModel.emptyStateSubTitle = "Update your \(appChemist) visits details here"
            stepperObjModel.sectionIconName = "icon-stepper-two-user"
            stepperObjModel.isExpanded = false
            stepperObjModel.leftButtonTitle = "ADD \(appChemist.uppercased()) VISIT"
            
            if doctorVisitList.count > 0
            {
                let chemistList = getDCRChemistVisitDetails()
                if chemistList != nil
                {
                    self.chemistVisitList = chemistList!
                    stepperObjModel.recordCount = chemistList!.count
                }
            }
            if(getChemistMandatoryNumber() == 0)
            {
                showSkipButton.append(true)
            }
            else
            {
                showSkipButton.append(false)
            }
            if(skipFromController[stepperIndex.chemistIndex])
            {
                showAddButton += 1
                stepperObjModel.showEmptyStateAddButton = true
                //getChemistMandatoryNumber()
                if getChemistMandatoryNumber() == 0
                {
                    stepperObjModel.showEmptyStateSkipButton = true
                }
                else
                {
                    stepperObjModel.showEmptyStateSkipButton = false
                }
                
            }
            else if(self.chemistVisitList.count != 0)
            {
                if(getChemistMandatoryNumber() <= self.detailProductList.count)
                {
                    showAddButton += 1
                }
                else
                {
                    showToastView(toastText: " You need to enter minimum of \(String(getChemistMandatoryNumber())) \(appChemist) for the \(appDoctor)")
                }
            }
            stepperDataList.append(stepperObjModel)
            
            enableAddShowButton(index: stepperIndex.chemistIndex)
            dynamicArrayValue += 1
            self.generateDataArray()
        }
    }
    
    private func getFollowupData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Follow-Ups"
        stepperObjModel.emptyStateTitle = "Follow-Ups"
        stepperObjModel.emptyStateSubTitle = "Update your follow-up details here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD FOLLOW-UPS"
        
        if doctorVisitList.count > 0
        {
            let followUpList = getFollowUpDetails()
            if followUpList.count > 0
            {
                self.followUpList = followUpList
                stepperObjModel.recordCount = followUpList.count
            }
        }
        
        //stepperDataList.append(stepperObjModel)
        
        showSkipButton.append(true)
        
        if(skipFromController[stepperIndex.followUpIndex])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            
        }
        else if(self.followUpList.count != 0)
        {
            showAddButton += 1
        }
        
        stepperDataList.append(stepperObjModel)
        
        enableAddShowButton(index: stepperIndex.followUpIndex)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    private func getAttachmentData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Attachments"
        stepperObjModel.emptyStateTitle = "Attachments"
        stepperObjModel.emptyStateSubTitle = "Update visits related documents and image here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD ATTACHMENT"
        
        if doctorVisitList.count > 0
        {
            let attachmentList = getDCRAttachmentDetails()
            if attachmentList != nil
            {
                self.attachmentList = attachmentList!
                stepperObjModel.recordCount = attachmentList!.count
            }
        }
        
        // stepperDataList.append(stepperObjModel)
        
        showSkipButton.append(true)
        
        if(skipFromController[stepperIndex.attachmentIndex])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            
        }
        else if(self.attachmentList.count != 0)
        {
            showAddButton += 1
        }
        
        stepperDataList.append(stepperObjModel)
        enableAddShowButton(index: stepperIndex.attachmentIndex)
        dynamicArrayValue += 1
        self.generateDataArray()
    }
    
    func getPOBData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Purchase Order Booking(POB)"
        stepperObjModel.emptyStateTitle = "Purchase Order Booking(POB)"
        stepperObjModel.emptyStateSubTitle = "Update POB details here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD POB"
        
        if doctorVisitList.count > 0
        {
            let pobDataList = getPobDetails()
            if(pobDataList != nil)
            {
                self.pobDataList =  pobDataList!
                stepperObjModel.recordCount = (pobDataList?.count)!
            }
        }
        
        showSkipButton.append(true)
        
        if(skipFromController[stepperIndex.pobIndex])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            
        }
        else if(self.pobDataList.count != 0)
        {
            showAddButton += 1
        }
        stepperDataList.append(stepperObjModel)
        enableAddShowButton(index: stepperIndex.pobIndex)
        dynamicArrayValue += 1
        self.generateDataArray()
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
        BL_Activity_Stepper.sharedInstance.isFromAttendance = false
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
        
        showSkipButton.append(true)
        
        if(skipFromController[stepperIndex.activity])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            
        }
        else if(activityList.count != 0 || mcActivityList.count != 0)
        {
            showAddButton += 1
        }
        stepperDataList.append(stepperObjModel)
        enableAddShowButton(index: stepperIndex.activity)
        dynamicArrayValue += 1
        self.generateDataArray()
        
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
    func getRCPACountforDoctorVisit(chemistId : Int) -> Int
    {
        var rcpaCount : Int = 0
        
        if doctorVisitList.count > 0
        {
            rcpaCount = DBHelper.sharedInstance.getRCPACountForChemistVisitId(dcrDoctorVisitId: DCRModel.sharedInstance.doctorVisitId, chemistVisitId: chemistId)
        }
        
        return rcpaCount
    }
    
    func enableAddShowButton(index:Int) //update add skip button for previous index
    {
        let indexValue = index - 1
        
        if (stepperDataList[index].recordCount > 0)
        {
            self.showAddSkipButton(indexValue:indexValue)
            
            if ((skipFromController.count) < (index + 1))
            {
                skipFromController[index + 1] = true
            }
        }
        if(stepperDataList[index].showEmptyStateAddButton == true)
        {
            self.showAddSkipButton(indexValue:indexValue)
        }
        if(index == dynmicOrderData.count-1)
        {
            if(stepperDataList[indexValue].recordCount > 0)
            {
                stepperDataList[index].showEmptyStateAddButton = true
                stepperDataList[index].showEmptyStateSkipButton = false
            }
        }
    }
    
    func showAddSkipButton(indexValue:Int)
    {
        for i in (0 ... indexValue).reversed()
        {
            if(stepperIndex.detailedProduct == i)
            {
                stepperDataList[i].showEmptyStateAddButton = true
                
                if getDetailedProductMandatoryNumber() == 0
                {
                    stepperDataList[i].showEmptyStateSkipButton = true
                }
                else
                {
                    stepperDataList[i].showEmptyStateSkipButton = false
                }
            }
            else if(stepperIndex.sampleIndex == i)
            {
                stepperDataList[i].showEmptyStateAddButton = true
                
                if getInputMandatoryNumber() == 0
                {
                    stepperDataList[i].showEmptyStateSkipButton = true
                }
                else
                {
                    stepperDataList[i].showEmptyStateSkipButton = false
                }
                
            }
            else
            {
                stepperDataList[i].showEmptyStateAddButton = true
                stepperDataList[i].showEmptyStateSkipButton = true
            }
        }
        skipFromController[indexValue] = true
    }
    
    private func updateStepperIndex()
    {
        stepperIndex.doctorVisitIndex = 0
        stepperIndex.accompanistIndex = 1
        stepperIndex.sampleIndex = 2
        stepperIndex.detailedProduct = 3
        
        if showAssetCard()
        {
            stepperIndex.assetIndex = 4
            
            if (!BL_Stepper.sharedInstance.isChemistDayEnabled())
            {
                stepperIndex.chemistIndex = 5
                stepperIndex.followUpIndex = 6
                stepperIndex.attachmentIndex = 7
            }
            else
            {
                stepperIndex.chemistIndex = 0
                stepperIndex.followUpIndex = 5
                stepperIndex.attachmentIndex = 6
            }
        }
        else
        {
            stepperIndex.assetIndex = 0
            
            if (!BL_Stepper.sharedInstance.isChemistDayEnabled())
            {
                stepperIndex.chemistIndex = 4
                stepperIndex.followUpIndex = 5
                stepperIndex.attachmentIndex = 6
            }
            else
            {
                stepperIndex.chemistIndex = 0
                stepperIndex.followUpIndex = 4
                stepperIndex.attachmentIndex = 5
            }
        }
    }
    func getPobDetails() -> [DCRDoctorVisitPOBHeaderModel]?
    {
        return BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: getDCRId() , visitId:DCRModel.sharedInstance.doctorVisitId,customerEntityType:getCustomerEntityType())
    }
    
    private func determineButtonStatus()
    {
        if doctorVisitList.count == 0
        {
            stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateAddButton = true
            stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateSkipButton = false
            
            if getDCRDoctorVisitMode() != PrivilegeValues.VISIT_TIME_MANDATORY.rawValue
            {
                stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateSkipButton = true
            }
        }
        else
        {
            if(showAddButton < stepperDataList.count && showAddButton < dynmicOrderData.count)
            {
                if(showAddButton < dynmicOrderData.count-1)
                {
                    if(stepperDataList[showAddButton].recordCount > 0)
                    {
                        stepperDataList[showAddButton+1].showEmptyStateAddButton = true
                        stepperDataList[showAddButton+1].showEmptyStateSkipButton = showSkipButton[showAddButton+1]
                    }
                    else
                    {
                        stepperDataList[showAddButton].showEmptyStateAddButton = true
                        stepperDataList[showAddButton].showEmptyStateSkipButton = showSkipButton[showAddButton]
                    }
                }
                else
                {
                    stepperDataList[showAddButton].showEmptyStateAddButton = true
                    stepperDataList[showAddButton].showEmptyStateSkipButton = false
                }
            }
        }
        
        //        else
        //        {
        //            stepperDataList[stepperIndex.doctorVisitIndex].showLeftButton = false
        //            stepperDataList[stepperIndex.doctorVisitIndex].showRightButton = true
        //
        //            if accompanistList.count == 0
        //            {
        //                stepperDataList[stepperIndex.accompanistIndex].showEmptyStateAddButton = true
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.accompanistIndex].showEmptyStateAddButton = false
        //            }
        //
        //            if sampleList.count == 0
        //            {
        //                stepperDataList[stepperIndex.sampleIndex].showEmptyStateAddButton = true
        //                if getInputMandatoryNumber() == 0
        //                {
        //                    stepperDataList[stepperIndex.sampleIndex].showEmptyStateSkipButton = true
        //                }
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.sampleIndex].showRightButton = true
        //                stepperDataList[stepperIndex.sampleIndex].showLeftButton = true
        //            }
        //
        //            if detailProductList.count == 0
        //            {
        //                if ((getInputMandatoryNumber() == 0 && sampleList.count > 0) || ((getInputMandatoryNumber() != 0) && (getInputMandatoryNumber() <= sampleList.count) && sampleList.count > 0) || chemistVisitList.count > 0 || followUpList.count > 0 || attachmentList.count > 0)
        //                {
        //                    stepperDataList[stepperIndex.detailedProduct].showEmptyStateAddButton = true
        //                }
        //                if getDetailedProductMandatoryNumber() == 0
        //                {
        //                    stepperDataList[stepperIndex.detailedProduct].showEmptyStateSkipButton = true
        //                }
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.detailedProduct].showRightButton = true
        //                stepperDataList[stepperIndex.detailedProduct].showLeftButton = true
        //            }
        //
        //            if chemistVisitList.count == 0
        //            {
        //                if ((getDetailedProductMandatoryNumber() == 0 && detailProductList.count > 0) || ((getDetailedProductMandatoryNumber() != 0) && (getDetailedProductMandatoryNumber() <= detailProductList.count) && detailProductList.count > 0) || followUpList.count > 0 || attachmentList.count > 0)
        //                {
        //                    stepperDataList[stepperIndex.chemistIndex].showEmptyStateAddButton = true
        //                    stepperDataList[stepperIndex.chemistIndex].showEmptyStateSkipButton = true
        //                }
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.chemistIndex].showRightButton = true
        //                stepperDataList[stepperIndex.chemistIndex].showLeftButton = true
        //            }
        //
        //            if followUpList.count == 0
        //            {
        //                if (BL_Stepper.sharedInstance.isChemistDayEnabled())
        //                {
        //                    if (detailProductList.count > 0)
        //                    {
        //                        stepperDataList[stepperIndex.followUpIndex].showEmptyStateAddButton = true
        //                        stepperDataList[stepperIndex.followUpIndex].showEmptyStateSkipButton = true
        //                    }
        //                }
        //                else
        //                {
        //                    if (chemistVisitList.count > 0)
        //                    {
        //                        stepperDataList[stepperIndex.followUpIndex].showEmptyStateAddButton = true
        //                        stepperDataList[stepperIndex.followUpIndex].showEmptyStateSkipButton = true
        //                    }
        //                }
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.followUpIndex].showLeftButton = true
        //                stepperDataList[stepperIndex.followUpIndex].showRightButton = true
        //            }
        //
        //            if attachmentList.count == 0
        //            {
        //                if followUpList.count > 0
        //                {
        //                    stepperDataList[stepperIndex.attachmentIndex].showEmptyStateAddButton = true
        //                }
        //            }
        //            else
        //            {
        //                stepperDataList[stepperIndex.attachmentIndex].showLeftButton = true
        //                stepperDataList[stepperIndex.attachmentIndex].showRightButton = true
        //            }
        //        }
    }
    
    
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
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
    
    func getCommonSingleCellHeight(selectedIndex: Int, parentIndex : Int) -> CGFloat
    {
        let topSpace: CGFloat = 0
        let bottomSpace: CGFloat = 10
        var line1Height: CGFloat = 0
        
        if parentIndex == stepperIndex.detailedProduct
        {
            let detailedProductname = detailProductList[selectedIndex].Product_Name + detailProductList[selectedIndex].stepperDisplayData
            line1Height = getTextSize(text: detailedProductname, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height + 10
            
            if(BL_DetailedProducts.sharedInstance.isDetailedCompetitorPrivilegeEnabled())
            {
                line1Height += 43
            }
        }
        else if parentIndex == stepperIndex.attachmentIndex
        {
            let attachmentName = attachmentList[selectedIndex].attachmentName
            line1Height = getTextSize(text: attachmentName, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height + 10
        }
        
        return topSpace + line1Height + bottomSpace
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpace : CGFloat = 20
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if selectedIndex == stepperIndex.detailedProduct
        {
            numberOfRows = stepperObj.recordCount
        }
        else
        {
            if (stepperObj.isExpanded == true)
            {
                numberOfRows = stepperObj.recordCount
            }
        }
        
        for i in 0..<numberOfRows
        {
            childTableHeight += getCommonSingleCellHeight(selectedIndex: i, parentIndex: selectedIndex)
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + topSpace
        
        if selectedIndex == stepperIndex.detailedProduct
        {
            totalHeight = totalHeight - 20
        }
        else
        {
            if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
            {
                totalHeight = totalHeight - 20
            }
        }
        
        return totalHeight
    }
    
    func getAccompanistCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpace : CGFloat = 20
        let titleSectionHeight: CGFloat = 30
        let bottomSpaceView: CGFloat = 20
        var numberOfRows: Int!
        var childTableHeight: CGFloat = 0
        
        numberOfRows = stepperObj.recordCount
        
        for i in 0..<numberOfRows
        {
            childTableHeight += getAccompanistSingleCellHeight(selectedIndex: i)
        }
        
        let totalHeight = titleSectionHeight + childTableHeight + bottomSpaceView + topSpace
        
        return totalHeight
    }
    
    func getAccompanistSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 10
        let bottomSpace : CGFloat = 10
        var accompNameHeight : CGFloat = 0
        let defaultCellHeight : CGFloat = 40.0
        
        let accompanistName = accompanistList[selectedIndex].Employee_Name
        accompNameHeight = getTextSize(text: accompanistName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        return topSpace + defaultCellHeight + accompNameHeight + bottomSpace
    }
    
    func getAccompanistEmptyHeight() -> CGFloat
    {
        return 60.0
    }
    
    func getAssetCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpace : CGFloat = 26
        let titleSectionHeight: CGFloat = 30
        var bottomViewHeight: CGFloat = 0
        let bottomSpaceView: CGFloat = 20
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        
        if stepperObj.isExpanded == true
        {
            numberOfRows = stepperObj.recordCount
        }
        
        if stepperObj.isExpanded == false && stepperObj.recordCount > 1
        {
            bottomViewHeight = 20
        }
        
        for i in 0..<numberOfRows
        {
            childTableHeight += getAssetSingleHeight(selectedIndex: i)
        }
        
        let totalHeight = titleSectionHeight + childTableHeight + bottomSpaceView + topSpace + bottomViewHeight
        
        return totalHeight
    }
    
    func getAssetSingleHeight(selectedIndex: Int) -> CGFloat
    {
        var getAssetNameHeight : CGFloat = 0
        var getViewedPagesHeight : CGFloat = 0
        var getUniquePagesHeight: CGFloat = 0
        var getViewedDurationHeight: CGFloat = 0
        var defaultCellHeight : CGFloat = 0
        
        var assetTypeName = ""
        if assetList[selectedIndex].assetType != nil{
            assetTypeName = getDocTypeVal(docType: assetList[selectedIndex].assetType)
        }
        let getAssetName = assetList[selectedIndex].assetsName + "(\(assetTypeName))"
        getAssetNameHeight = getTextSize(text: getAssetName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let playTime = getPlayTime(timeVal: assetList[selectedIndex].totalPlayedDuration)
        let getViewedDuration = viewedDuration + playTime
        getViewedDurationHeight = getTextSize(text: getViewedDuration, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        if assetTypeName != Constants.DocType.image && assetTypeName != Constants.DocType.video && assetTypeName != Constants.DocType.audio
        {
            let getViewedPages = viewedPages + assetList[selectedIndex].totalPagesViewed
            getViewedPagesHeight = getTextSize(text: getViewedPages, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let getUniquePages = uniquePages + assetList[selectedIndex].totalUniquePagesCount
            getUniquePagesHeight = getTextSize(text: getUniquePages, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            defaultCellHeight = 30
        }
        else
        {
            defaultCellHeight = 20
        }
        
        return defaultCellHeight + getAssetNameHeight + getViewedPagesHeight + getUniquePagesHeight + getViewedDurationHeight
    }
    
    func getAssetEmptyHeight() -> CGFloat
    {
        return 60.0
    }
    
    func getDoctorVisitSampleSingleHeight(selectedIndex : Int, parentIndex : Int) -> CGFloat
    {
        let topSpace: CGFloat = 0
        let verticalSpacing : CGFloat = 10
        let bottomSpace: CGFloat = 15
        var line1Height : CGFloat = 0
        var line2Height : CGFloat = 0
        if parentIndex == stepperIndex.activity
        {
            let activityObj = activitStepperData[selectedIndex]
            line1Height = getTextSize(text: activityObj.activityName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            line2Height = getTextSize(text: activityObj.activityRemarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        if parentIndex == stepperIndex.sampleIndex
        {
            let sampleObj = sampleList.first?.sampleList[selectedIndex].sampleObj
            line1Height = getTextSize(text: sampleObj?.Product_Name, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let quantityText = String(format: "%d", (sampleObj?.Quantity_Provided)!)
            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        
        if parentIndex == stepperIndex.chemistIndex
        {
            let chemistName = chemistVisitList[selectedIndex].Chemist_Name
            line1Height = getTextSize(text: chemistName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            var pobAmount : Double = 0
            if chemistVisitList[selectedIndex].POB_Amount != nil
            {
                pobAmount = chemistVisitList[selectedIndex].POB_Amount!
            }
            let subTitleText = String(format: "POB: %.2f |", pobAmount)
            line2Height = getTextSize(text: subTitleText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        
        if parentIndex == stepperIndex.followUpIndex
        {
            let followUpText = followUpList[selectedIndex].Follow_Up_Text
            line1Height = getTextSize(text: followUpText, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let dateString = convertDateIntoString(date: followUpList[selectedIndex].Due_Date)
            line2Height = getTextSize(text: dateString, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        if parentIndex == stepperIndex.pobIndex
        {
            let orderEntryId = pobDataList[selectedIndex].Order_Entry_Id
            let stockiestCode = pobDataList[selectedIndex].Stockiest_Code
            let stockiestName = pobDataList[selectedIndex].Stockiest_Name
            
            line1Height = getTextSize(text: stockiestName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            
            let noOfProduct = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: orderEntryId!)
            let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: orderEntryId!)
            
            let quantityText = String(format: "POB: "+"%d"+"| No Of Product"+"%d", noOfProduct,totalAmount)
            
            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            
            
        }
        
        return topSpace + verticalSpacing + bottomSpace + line1Height + line2Height
    }
    
    func getDoctorVisitSampleHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
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
    
    func getSampleBatchHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
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
            businessStatus = ""
        }
        
        if (doctorVisitList[0].Call_Objective_Name.count > 0)
        {
            callObjective = doctorVisitList[0].Call_Objective_Name!
        }
        else
        {
            callObjective = ""
        }
        
        if (doctorVisitList[0].Campaign_Name.count > 0)
        {
            campaignName = doctorVisitList[0].Campaign_Name!
        }
        else
        {
            campaignName = ""
        }
        
        let businessDisplay = "Business Status" + businessStatus
        let callObjDisplay = "\nObjective\n\n" + callObjective
        let campaignDisplay = "" + campaignName
        let remarksDisplay = "\n\n\n"
        
        let businessStatusHeight : CGFloat = getTextSize(text: businessDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let callObjectyiveHeight : CGFloat = getTextSize(text: callObjDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let remarksNewLineHeight: CGFloat = getTextSize(text: remarksDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let campaignHeight : CGFloat = getTextSize(text: campaignDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let remarks = doctorVisitList[0].Remarks
        let remarksLblheight : CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let cellHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight  + callObjectyiveHeight + remarksNewLineHeight  + 10
        return cellHeight
    }
    
    func getDoctorVisitDetailHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[selectedIndex]
        
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
            businessStatus = ""
        }
        
        if (doctorVisitList[0].Call_Objective_Name.count > 0)
        {
            callObjective = doctorVisitList[0].Call_Objective_Name!
        }
        else
        {
            callObjective = ""
        }
        if (doctorVisitList[0].Campaign_Name.count > 0)
        {
            campaignName = doctorVisitList[0].Campaign_Name!
        }
        else
        {
            campaignName = ""
        }
        
        let businessDisplay = "Business Status" + businessStatus
        let callObjDisplay = "\nObjective\n\n" + callObjective
        let campaignDisplay = "" + campaignName
        let remarksDisplay = "\n\n\n"
        
        let businessStatusHeight : CGFloat = getTextSize(text: businessDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let callObjectyiveHeight : CGFloat = getTextSize(text: callObjDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let campaignHeight : CGFloat = getTextSize(text: campaignDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let remarksNewLineHeight: CGFloat = getTextSize(text: remarksDisplay, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        childTableHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + callObjectyiveHeight + remarksNewLineHeight + 10
        
        if (stepperObj.isExpanded == false)
        {
            totalHeight = totalHeight - remarksHeight - line1VerticalSpacing - remarksLblheight  - callObjectyiveHeight - remarksNewLineHeight
        }
        
        return totalHeight
    }
    
    //MARK:- Public Functions
    func getDCRDoctorVisitList() -> [DCRDoctorVisitModel]?
    {
        if(!isHourlyReportEnabled() && !isAppGeoLocationEnabled())
        {
            BL_DCRCalendar.sharedInstance.prefillDoctorsForDCRDate(selectedDate: DCRModel.sharedInstance.dcrDate, dcrId: getDCRId())
        }
        return DBHelper.sharedInstance.getDCRDoctorVisitforDoctorId(dcrId: getDCRId(), customerCode: getCustomerCode(), regionCode: getCustomerRegionCode())
    }
    
    func getDCRDoctorList() -> [DCRDoctorVisitModel]
    {
        var doctorvisitModel: [DCRDoctorVisitModel] = []
        doctorvisitModel = DBHelper.sharedInstance.getDCRDoctorVisitDetails(dcrId: getDCRId())
        return doctorvisitModel
    }
    
    func getDCRDoctorVisitFlexiDoctor(doctorVisitId : Int) -> [DCRDoctorVisitModel]?
    {
        return DBHelper.sharedInstance.getDoctorVisitDetailFlexiDoctor(dcrId: getDCRId(), doctorVisitId: doctorVisitId)
    }
    
    func getDoctorVisitDetailByDoctorVisitId(doctorVisitId: Int) -> DCRDoctorVisitModel?
    {
        return DBHelper.sharedInstance.getDoctorVisitDetailByDoctorVisitId(doctorVisitId: doctorVisitId)
    }
    
    
    func getAttendanceDoctorVisitDetailByDoctorVisitId(doctorVisitId: Int) -> DCRDoctorVisitModel?
    {
        return DBHelper.sharedInstance.getAttendanceDoctorVisitDetailByDoctorVisitId(doctorVisitId: doctorVisitId)
    }
    
    func getDCRAccompanistsList() -> [DCRAccompanistModel]?
    {
        return BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
    }
    func getAccompanistsList() -> [AccompanistModel]?
    {
        return BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
    }
    
    func getDCRAccompanistsListWithoutVandNA() -> [DCRAccompanistModel]?
    {
        return BL_DCR_Accompanist.sharedInstance.getDCRAccompanistListWithoutVandNA()
    }
    
    
    
    func canUseAccompanistsDoctor() -> Bool
    {
        var returnValue: Bool = false
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ACCOMPANISTS_DATA).uppercased()
        let privArray = privilegeValue.components(separatedBy: ",")
        
        if (privArray.contains(DOCTOR))
        {
            returnValue = true
        }
        
        return true
    }
    
    func convertToDoctorVisitUserModel() -> [UserMasterWrapperModel]?
    {
        var userList : [UserMasterWrapperModel] = []
        let accompanistList = getDCRAccompanistsList()
        
        let loggedUserModel = getUserModelObj()
        loggedUserModel?.Employee_name = "Mine"
        let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
        wrapperModel.userObj = loggedUserModel!
        
        userList.append(wrapperModel)
        
        if (accompanistList?.count)! > 0
        {
            for accompanistObj in accompanistList!
            {
                let userModel : UserMasterModel = UserMasterModel()
                userModel.Employee_name = accompanistObj.Employee_Name
                userModel.User_Name = accompanistObj.Acc_User_Name
                userModel.User_Type_Name = accompanistObj.Acc_User_Type_Name
                userModel.Region_Name = checkNullAndNilValueForString(stringData:accompanistObj.Region_Name)
                userModel.Region_Code = accompanistObj.Acc_Region_Code
                userModel.User_Code = checkNullAndNilValueForString(stringData: accompanistObj.Acc_User_Code)
                let wrapperModel : UserMasterWrapperModel = UserMasterWrapperModel()
                wrapperModel.userObj = userModel
                userList.append(wrapperModel)
            }
        }
        
        return userList
    }
    
    /*
     If the function returns nil value mean, TP is not defined or no doctors defined in TP for the date
     If the function returns zero count mean, no doctors defined in TP
     */
    
    func getLocalArea(customerCode:String, regionCode:String) -> CustomerMasterModel?
    {
        return DBHelper.sharedInstance.getLocalArea(customerCode:customerCode, regionCode:regionCode)
    }
    
    func getTPDoctorsForSelectedDate() -> [CustomerMasterModel]?
    {
        var tpDoctorList: [TourPlannerDoctor]?
        let tpHeaderObj:TourPlannerHeader? = BL_Stepper.sharedInstance.getTPHeaderByDate(dcrDate: DCRModel.sharedInstance.dcrDateString)
        
        if (tpHeaderObj != nil)
        {
            let dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
            let cpCodeInTP = checkNullAndNilValueForString(stringData: tpHeaderObj?.CP_Code)
            
            tpDoctorList = []
            
            if (cpCodeInTP != "")
            {
                let cpCodeInDCR = checkNullAndNilValueForString(stringData: dcrHeaderObj?.CP_Code)
                if (cpCodeInTP == cpCodeInDCR)
                {
                    tpDoctorList = BL_Stepper.sharedInstance.getTPDoctorsByDate(dcrDate: DCRModel.sharedInstance.dcrDate)
                    tpTab = true
                }
                else
                {
                    cpTab = true
                }
            }
            else
            {
                tpDoctorList = BL_Stepper.sharedInstance.getTPDoctorsByDate(dcrDate: DCRModel.sharedInstance.dcrDate)
                tpTab = true
            }
        }
        
        var customerMasterList: [CustomerMasterModel] = []
        
        if (tpDoctorList != nil)
        {
            for tpDoctorObj in tpDoctorList!
            {
                let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCodeAndRegionCode(customerCode: tpDoctorObj.Doctor_Code, regionCode: tpDoctorObj.Doctor_Region_Code, customerEntityType: DOCTOR)
                
                if (customerObj != nil)
                {
                    customerMasterList.append(customerObj!)
                }
            }
        }
        
        return customerMasterList
    }
    private func getCustomerEntityType() -> String
    {
        return Constants.CustomerEntityType.doctor
    }
    /*
     If the function returns nil value mean, CP is not chosen for the date
     If the function returns zero count mean, no doctors defined in CP
     */
    func getCPDoctorsForSelectedDate() -> [CustomerMasterModel]?
    {
        var cpDoctorList: [CampaignPlannerDoctors]?
        let dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        let cpCodeInDCR = checkNullAndNilValueForString(stringData: dcrHeaderObj?.CP_Code)
        
        if (cpCodeInDCR != "")
        {
            cpDoctorList = BL_Stepper.sharedInstance.getCPDoctorsByCpCode(cpCode: cpCodeInDCR)
        }
        
        var customerMasterList: [CustomerMasterModel] = []
        
        if (cpDoctorList != nil)
        {
            for cpDoctorObj in cpDoctorList!
            {
                let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCodeAndRegionCode(customerCode: cpDoctorObj.Doctor_Code, regionCode: cpDoctorObj.Doctor_Region_Code, customerEntityType: DOCTOR)
                
                if (customerObj != nil)
                {
                    customerMasterList.append(customerObj!)
                }
            }
        }
        
        return customerMasterList
    }
    
    func getDoctorMasterList(regionCode: String) -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getCustomerMasterList(regionCode: regionCode, customerEntityType: DOCTOR)
    }
    
    func getDoctorMasterListOrderBY(regionCode: String,orderBy : String) -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getCustomerMasterListOrderBy(regionCode: regionCode, customerEntityType: DOCTOR,orderBy: orderBy)
    }
    
    
    func getDoctorMasterListForEdit(regionCode: String) -> [CustomerMasterModel]
    {
        let customerList = DBHelper.sharedInstance.getCustomerMasterListForEdit(regionCode: regionCode, customerEntityType: DOCTOR)
        let convertedList = convertModel(customerList: customerList)
        
        return convertedList
    }
    
    func convertModel(customerList: [CustomerMasterEditModel]) -> [CustomerMasterModel]
    {
        var convertedList: [CustomerMasterModel] = []
        
        for objCustEdit in customerList
        {
            var anniversaryDate: String = EMPTY
            var dob: String = EMPTY
            
            if (objCustEdit.Anniversary_Date != nil)
            {
                anniversaryDate = getServerFormattedDateString(date: objCustEdit.Anniversary_Date!)
            }
            
            if (objCustEdit.DOB != nil)
            {
                dob = getServerFormattedDateString(date: objCustEdit.DOB!)
            }
            
            let dict1: NSDictionary = ["Customer_Code": objCustEdit.Customer_Code, "Customer_Name": objCustEdit.Customer_Name, "Region_Code": objCustEdit.Region_Code, "Region_Name": objCustEdit.Region_Name, "Speciality_Code": objCustEdit.Speciality_Code, "Speciality_Name": objCustEdit.Speciality_Name, "Category_Code": objCustEdit.Category_Code, "Category_Name": objCustEdit.Category_Name,"Hospital_Account_Number": objCustEdit.Hospital_Account_Number]
            let dict2: NSDictionary = ["MDL_Number": objCustEdit.MDL_Number, "Local_Area": objCustEdit.Local_Area, "Hospital_Name": objCustEdit.Hospital_Name, "Customer_Entity_Type": objCustEdit.Customer_Entity_Type, "Customer_Latitude": objCustEdit.Latitude, "Customer_Longitude": objCustEdit.Longitude, "Anniversary_Date": anniversaryDate, "DOB": dob]
            var combinedAttributes : NSMutableDictionary!
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
            
            let objCustomer: CustomerMasterModel = CustomerMasterModel(dict: combinedAttributes)
            objCustomer.Customer_Status = objCustEdit.Customer_Status
            
            convertedList.append(objCustomer)
        }
        
        return convertedList
    }
    
    func getDoctorMasterSortList(regionCode: String, sortFieldCode: Int, sortTypeCode: Int) -> [CustomerMasterModel]?
    {
        var sortTypeString : String!
        if sortTypeCode == 0
        {
            sortTypeString = "ASC"
        }
        else
        {
            sortTypeString = "DESC"
        }
        
        switch sortFieldCode {
        case 0:
            return DBHelper.sharedInstance.getCustomerMasterSortList(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Customer_Name", sortType: sortTypeString)
        case 1:
            return DBHelper.sharedInstance.getCustomerMasterSortList(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "MDL_Number", sortType: sortTypeString)
        case 2:
            return DBHelper.sharedInstance.getCustomerMasterSortList(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Speciality_Name", sortType: sortTypeString)
        case 3:
            return DBHelper.sharedInstance.getCustomerMasterSortList(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Category_Name", sortType: sortTypeString)
        case 4:
            return DBHelper.sharedInstance.getCustomerMasterSortList(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Local_Area", sortType: sortTypeString)
        default:
            return []
        }
    }
    
    func getDoctorMasterSortListForEdit(regionCode: String, sortFieldCode: Int, sortTypeCode: Int) -> [CustomerMasterModel]
    {
        var sortTypeString : String!
        var convertedList: [CustomerMasterModel] = []
        var customerList: [CustomerMasterEditModel] = []
        
        if sortTypeCode == 0
        {
            sortTypeString = "ASC"
        }
        else
        {
            sortTypeString = "DESC"
        }
        
        switch sortFieldCode
        {
        case 0:
            customerList = DBHelper.sharedInstance.getCustomerMasterSortListEdit(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Customer_Name", sortType: sortTypeString)
        case 1:
            customerList = DBHelper.sharedInstance.getCustomerMasterSortListEdit(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "MDL_Number", sortType: sortTypeString)
        case 2:
            customerList = DBHelper.sharedInstance.getCustomerMasterSortListEdit(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Speciality_Name", sortType: sortTypeString)
        case 3:
            customerList = DBHelper.sharedInstance.getCustomerMasterSortListEdit(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Category_Name", sortType: sortTypeString)
        case 4:
            customerList = DBHelper.sharedInstance.getCustomerMasterSortListEdit(regionCode: regionCode, customerEntityType: DOCTOR, sortColumn: "Local_Area", sortType: sortTypeString)
        default:
            return []
        }
        
        convertedList = convertModel(customerList: customerList)
        
        return convertedList
    }
    
    func saveFlexiDoctor(doctorName: String)
    {
        let dict: NSDictionary = ["Flexi_Doctor_Name": doctorName]
        let flexiDoctorObj: FlexiDoctorModel = FlexiDoctorModel(dict: dict)
        
        DBHelper.sharedInstance.insertFleixDoctor(flexiDoctorObj: flexiDoctorObj)
    }
    
    func getFlexiDoctorsList() -> [FlexiDoctorModel]?
    {
        return DBHelper.sharedInstance.getFlexiDoctorList()
    }
    
    func saveFlexiAttendanceDoctorVisitDetails(doctorName : String, specialityName : String, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode : String?, viewController: UIViewController, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignCode:String,campaignName:String)
    {
        var pob = "0"
        var pobAmount = pobAmount
        
        if (pobAmount == nil)
        {
            pobAmount = 0.0
        }
        else
        {
            pob = String(describing: pobAmount!)
        }
        
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = defaultCallObjectiveName
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        var remarkValue = String()
        if let remark = remarks
        {
            remarkValue = remark
        }
        else
        {
            remarkValue = NOT_APPLICABLE
        }
        //  let dcrIdString = String(format : "%d", getDCRId())
        let dict:NSDictionary = ["DCR_Id":getDCRId(),"DCR_Code":DCRModel.sharedInstance.dcrCode,"Doctor_Code": "","Doctor_Name": doctorName,"DCR_Doctor_Visit_Code": EMPTY,"DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString,"Speciality_Name": specialityName,"Speciality_Code": "","Category_Code":EMPTY, "Hospital_Name": "",  "Category_Name":EMPTY, "Doctor_Region_Name":"","Doctor_Region_Code":regionCode!,"MDL_Number":"","Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus,"Campaign_Code":campaignCode,"Campaign_Name":campaignName,"POB_Amount": pob,"Visit_Mode": visitMode, "Visit_Time": visitTime,"Lattitude": getLatitude(), "Longitude": getLongitude(),"Remarks": remarkValue]
        
        let doctorVisitObj:DCRAttendanceDoctorModel = DCRAttendanceDoctorModel.init(dict: dict)
        
        let doctorVisitId = DAL_DCR_Attendance.sharedInstance.saveDCRAttendanceDoctorVisits(dcrAattendanceDoctorObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: pobAmount, viewController: viewController)
        //  DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
    }
    
    func saveAttendanceVisitDetails(customerCode: String?, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode: String?, viewController: UIViewController, geoFencingSkipRemarks: String, latitude: Double, longitude: Double, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignCode:String,specialityCode:String,campaignName:String)
    {
        
        var doctorCode: String?
        var doctorName: String?
        var doctorRegionCode: String?
        var specialtyName: String?
        var categoryCode: String?
        var categoryName: String?
        var mdlNumber: String?
        var Hospital_Name: String?
        var doctorRegionName: String?
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = EMPTY
        var specialityCode : String?
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        
        
        if (customerCode != nil)
        {
            //let doctorObj = getCustomerMasterByCustomerId(customerId: customerId!)
            let doctorObj = getCustomerMasterByCustomerCode(customerCode: customerCode!, regionCode: regionCode!)
            
            if (doctorObj != nil)
            {
                doctorCode = doctorObj!.Customer_Code
                doctorName = doctorObj!.Customer_Name
                doctorRegionCode = doctorObj!.Region_Code
                specialtyName = doctorObj!.Speciality_Name
                categoryCode = doctorObj!.Category_Code
                categoryName = doctorObj!.Category_Name
                mdlNumber = doctorObj!.MDL_Number
                doctorRegionName = doctorObj!.Region_Name
                specialityCode = doctorObj!.Speciality_Code
                Hospital_Name = doctorObj!.Hospital_Name
            }
        }
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        if (!BL_Geo_Location.sharedInstance.isGeoFencingEnabled())
        {
            currentLat = getLatitude()
            currentLong = getLongitude()
        }
        
        var pob = "0"
        
        if (pobAmount != nil)
        {
            pob = String(pobAmount!)
        }
        var remarkValue = String()
        if let remark = remarks
        {
            remarkValue = remark
        }
        else
        {
            remarkValue = NOT_APPLICABLE
        }
        
        
        let dict:NSDictionary = ["DCR_Id":getDCRId(),"DCR_Code":DCRModel.sharedInstance.dcrCode,"Doctor_Code": doctorCode ?? EMPTY,"Doctor_Name":doctorName,"DCR_Doctor_Visit_Code": EMPTY,"DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString,"Speciality_Name": specialtyName,"Speciality_Code": specialityCode ?? EMPTY,"Category_Code": categoryCode ?? EMPTY,"Category_Name": categoryName ?? EMPTY,"Doctor_Region_Name":doctorRegionName,"Doctor_Region_Code":doctorRegionCode,"MDL_Number":mdlNumber,"Hospital_Name":Hospital_Name,"Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus,"Campaign_Code":campaignCode,"Campaign_Name":campaignName,"POB_Amount": pob,"Visit_Mode": visitMode, "Visit_Time": visitTime,"Lattitude": currentLat, "Longitude": currentLong, "Remarks": remarkValue]
        
        let doctorVisitObj:DCRAttendanceDoctorModel = DCRAttendanceDoctorModel.init(dict: dict)
        
        let doctorVisitId = DAL_DCR_Attendance.sharedInstance.saveDCRAttendanceDoctorVisits(dcrAattendanceDoctorObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        //  DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
    }
    
    func saveDoctorVisitDetails(customerCode: String?, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode: String?, viewController: UIViewController, geoFencingSkipRemarks: String, latitude: Double, longitude: Double, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignName:String,campaignCode: String)
    {
        var doctorId: Int?
        var doctorCode: String?
        var doctorName: String?
        var doctorRegionCode: String?
        var specialtyName: String?
        var categoryCode: String?
        var categoryName: String?
        var mdlNumber: String?
        var isCPDoc: Int = 0
        var isAccDoc: Int = 0
        var doctorRegionName: String?
        var localArea: String?
        var surName: String?
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = EMPTY
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        var HospitalName: String?
        
        if (customerCode != nil)
        {
            //let doctorObj = getCustomerMasterByCustomerId(customerId: customerId!)
            let doctorObj = getCustomerMasterByCustomerCode(customerCode: customerCode!, regionCode: regionCode!)
            
            if (doctorObj != nil)
            {
                doctorId = doctorObj!.Customer_Id
                doctorCode = doctorObj!.Customer_Code
                doctorName = doctorObj!.Customer_Name
                doctorRegionCode = doctorObj!.Region_Code
                specialtyName = doctorObj!.Speciality_Name
                categoryCode = doctorObj!.Category_Code
                categoryName = doctorObj!.Category_Name
                mdlNumber = doctorObj!.MDL_Number
                doctorRegionName = doctorObj!.Region_Name
                localArea = doctorObj!.Local_Area
                surName = doctorObj!.Sur_Name
                HospitalName = doctorObj!.Hospital_Name
                
                isCPDoc = isCPDoctor(doctorCode: doctorCode!, doctorRegionCode: doctorRegionCode!)
                isAccDoc = isAccompanistDoctor(doctorRegionCode: doctorRegionCode!)
            }
        }
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        var currentLat = String(latitude)
        var currentLong = String(longitude)
        
        if (!BL_Geo_Location.sharedInstance.isGeoFencingEnabled())
        {
            currentLat = getLatitude()
            currentLong = getLongitude()
        }
        
        var pob = "0"
        
        if (pobAmount != nil)
        {
            pob = String(pobAmount!)
        }
        
        let dcrIdString = String(format : "%d", getDCRId())
        let doctorDict: NSDictionary = ["DCR_Id": dcrIdString, "Doctor_Id": doctorId, "Doctor_Code": doctorCode, "Doctor_Region_Code": doctorRegionCode, "Doctor_Name": doctorName, "Speciality_Name": specialtyName, "MDL_Number": mdlNumber, "Category_Code": categoryCode, "Category_Name": categoryName, "Visit_Mode": visitMode, "Visit_Time": visitTime, "POB_Amount": pob, "Is_CP_Doc": isCPDoc, "Is_Acc_Doctor": isAccDoc, "Remarks": remarks, "Lattitude": currentLat, "Longitude": currentLong, "Doctor_Region_Name": doctorRegionName, "Local_Area": localArea, "Sur_Name": surName, "Geo_Fencing_Deviation_Remarks": geoFencingSkipRemarks, "Geo_Fencing_Page_Source": Constants.Geo_Fencing_Page_Names.DCR, "Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus, "Is_DCR_Inherited_Doctor": 0,"Campaign_Code":campaignCode,"Campaign_Name":campaignName,"Hospital_Name":HospitalName]
        
        let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
        let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: pobAmount, viewController: viewController)
    }
    func savePunchInDoctorVisitDetails(customerCode: String?, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode: String?, viewController: UIViewController, geoFencingSkipRemarks: String, latitude: Double, longitude: Double, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignName:String,campaignCode: String, Punch_Start_Time: String?, Punch_Status: Int?, Punch_Offset: String?, Punch_TimeZone: String?, Punch_UTC_DateTime: String? )
    {
        var doctorId: Int?
        var doctorCode: String?
        var doctorName: String?
        var doctorRegionCode: String?
        var specialtyName: String?
        var categoryCode: String?
        var categoryName: String?
        var mdlNumber: String?
        var isCPDoc: Int = 0
        var isAccDoc: Int = 0
        var doctorRegionName: String?
        var localArea: String?
        var surName: String?
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = EMPTY
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        var HospitalName: String?
        
        if (customerCode != nil)
        {
            //let doctorObj = getCustomerMasterByCustomerId(customerId: customerId!)
            let doctorObj = getCustomerMasterByCustomerCode(customerCode: customerCode!, regionCode: regionCode!)
            
            if (doctorObj != nil)
            {
                doctorId = doctorObj!.Customer_Id
                doctorCode = doctorObj!.Customer_Code
                doctorName = doctorObj!.Customer_Name
                doctorRegionCode = doctorObj!.Region_Code
                specialtyName = doctorObj!.Speciality_Name
                categoryCode = doctorObj!.Category_Code
                categoryName = doctorObj!.Category_Name
                mdlNumber = doctorObj!.MDL_Number
                doctorRegionName = doctorObj!.Region_Name
                localArea = doctorObj!.Local_Area
                surName = doctorObj!.Sur_Name
                HospitalName = doctorObj!.Hospital_Name
                
                isCPDoc = isCPDoctor(doctorCode: doctorCode!, doctorRegionCode: doctorRegionCode!)
                isAccDoc = isAccompanistDoctor(doctorRegionCode: doctorRegionCode!)
            }
        }
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        var currentLat = String(latitude)
        var currentLong = String(longitude)
        
        if (!BL_Geo_Location.sharedInstance.isGeoFencingEnabled())
        {
            currentLat = getLatitude()
            currentLong = getLongitude()
        }
        
        var pob = "0"
        
        if (pobAmount != nil)
        {
            pob = String(pobAmount!)
        }
        
        let dcrIdString = String(format : "%d", getDCRId())
        let doctorDict: NSDictionary = ["DCR_Id": dcrIdString, "Doctor_Id": doctorId, "Doctor_Code": doctorCode, "Doctor_Region_Code": doctorRegionCode, "Doctor_Name": doctorName, "Speciality_Name": specialtyName, "MDL_Number": mdlNumber, "Category_Code": categoryCode, "Category_Name": categoryName, "Visit_Mode": visitMode, "Visit_Time": visitTime, "POB_Amount": pob, "Is_CP_Doc": isCPDoc, "Is_Acc_Doctor": isAccDoc, "Remarks": remarks, "Lattitude": currentLat, "Longitude": currentLong, "Doctor_Region_Name": doctorRegionName, "Local_Area": localArea, "Sur_Name": surName, "Geo_Fencing_Deviation_Remarks": geoFencingSkipRemarks, "Geo_Fencing_Page_Source": Constants.Geo_Fencing_Page_Names.DCR, "Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus, "Is_DCR_Inherited_Doctor": 0,"Campaign_Code":campaignCode,"Campaign_Name":campaignName,"Hospital_Name":HospitalName,"Customer_Met_StartTime":Punch_Start_Time,"Punch_Status":Punch_Status,"Punch_OffSet":Punch_Offset,"Punch_TimeZone":Punch_TimeZone,"UTC_DateTime":Punch_UTC_DateTime]
        
        let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
        let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: pobAmount, viewController: viewController)
    }
    func savePunchInFlexiDoctorVisitDetails(doctorName : String, specialityName : String, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode : String?, viewController: UIViewController, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignName:String,campaignCode:String, Punch_Start_Time: String?, Punch_Status: Int?, Punch_Offset: String?, Punch_TimeZone: String?, Punch_UTC_DateTime: String? )
    {
        var pob = "0"
        var pobAmount = pobAmount
        
        if (pobAmount == nil)
        {
            pobAmount = 0.0
        }
        else
        {
            pob = String(describing: pobAmount!)
        }
        
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = defaultCallObjectiveName
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        let dcrIdString = String(format : "%d", getDCRId())
        let doctorDict: NSMutableDictionary = ["DCR_Id": dcrIdString, "Doctor_Id": 0, "Doctor_Code": "", "Doctor_Region_Code": regionCode, "Doctor_Name": doctorName, "Speciality_Name": specialityName, "MDL_Number": "", "Category_Code": "", "Category_Name": "", "Visit_Mode": visitMode, "Visit_Time": visitTime, "POB_Amount": pob, "Is_CP_Doc": 0, "Is_Acc_Doctor": 0, "Remarks": remarks, "Lattitude": getLatitude(), "Longitude": getLongitude(), "Doctor_Region_Name": getRegionName(), "Local_Area": EMPTY, "Sur_Name": EMPTY, "Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus, "Is_DCR_Inherited_Doctor": 0,"Campaign_Code":campaignCode,"Campaign_Name":campaignName, "Customer_Met_StartTime":Punch_Start_Time,"Punch_Status":Punch_Status,"Punch_OffSet":Punch_Offset,"Punch_TimeZone":Punch_TimeZone,"UTC_DateTime":Punch_UTC_DateTime]
        
        let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
        let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: pobAmount, viewController: viewController)
        
    }
    func isHourlyReportEnabled() -> Bool
    {
        var isEnabled: Bool = false
        let appGeoPrivValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY)
        let hourlyReportPrivValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.HOURLY_REPORT_ENABLED)
        
        if (appGeoPrivValue.uppercased() == PrivilegeValues.YES.rawValue.uppercased() && hourlyReportPrivValue.uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            isEnabled = true
        }
        
        return isEnabled
    }
    
    func isAppGeoLocationEnabled() -> Bool
    {
        var isEnabled: Bool = false
        
        let appGeoPrivValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY)
        if (appGeoPrivValue.uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            isEnabled = true
        }
        
        return isEnabled
    }
    
    func isEdetailedDoctor(customerCode:String,regionCode:String,date:String) -> Bool{
        
        let value =  DBHelper.sharedInstance.getEdetailedDoctor(customerCode: customerCode, regionCode: regionCode, date: date)
        if(value > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func insertDoctorVisitTracker(modifiedEntity: Int, pobAmount: Double?, viewController: UIViewController)
    {
        var pobAmount = pobAmount
        
        if (isHourlyReportEnabled())
        {
            let doctorVisitObj = getDoctorVisitDetailByDoctorVisitId(doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
            
            var doctorCode: String = EMPTY
            var doctorRegionCode: String = EMPTY
            var mdlNumber: String = EMPTY
            var categoryCode: String = EMPTY
            var doctorName: String = EMPTY
            var spltyName: String = EMPTY
            var HospitalName: String = EMPTY
            
            if (doctorVisitObj != nil)
            {
                doctorCode = doctorVisitObj!.Doctor_Code!
                doctorRegionCode = doctorVisitObj!.Doctor_Region_Code!
                mdlNumber = doctorVisitObj!.MDL_Number!
                categoryCode = doctorVisitObj!.Category_Code!
                doctorName = doctorVisitObj!.Doctor_Name!
                spltyName = doctorVisitObj!.Speciality_Name!
                HospitalName = doctorVisitObj!.Hospital_Name!
            }
            
            if (pobAmount == nil)
            {
                pobAmount = 0.0
            }
            
            let enteredDateTime = convertDateToDate(date: getCurrentDateAndTime(), dateFormat: dateTimeWithoutMilliSec, timeZone: NSTimeZone.local)
            
            let trackerDict: NSDictionary = ["DCR_Doctor_Visit_Id": DCRModel.sharedInstance.doctorVisitId, "DCR_Id": getDCRId(), "DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString, "Doctor_Code": doctorCode, "Doctor_Region_Code": doctorRegionCode, "MDL_Number": mdlNumber, "Category_Code": categoryCode, "Lattitude": getLatitude(), "Longitude": getLongitude(), "Doctor_Visit_Date_Time": enteredDateTime, "Modified_Entity": modifiedEntity, "Doctor_Name": doctorName, "Speciality_Name": spltyName, "POB_Amount": pobAmount!, "Hospital_Name": HospitalName]
            
            let objDoctorVisitTracker = DoctorVisitTrackerModel(dict: trackerDict)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController, completion: { (objApiResponse) in
                if (objApiResponse.list.count > 0)
                {
                    DBHelper.sharedInstance.insertDoctorVisitTracker(objDoctorVisitTracker: objDoctorVisitTracker)
                    
                    //      self.sendHourlyReport(completion: { (objApiResponse) in
                    //         print(objApiResponse.Status)
                    //       })
                }
            })
        }
    }
    
    func insertDoctorVisitTrackerByCustomerCode(customerCode: String, regionCode: String, modifiedEntity: Int, pobAmount: Float?, viewController: UIViewController, geoFencingDeviationRemarks: String,completion : @escaping (_ status : Int) -> ())
    {
        var pobAmount = pobAmount
        let latString = getLatitude()
        let longString = getLongitude()
        var visitTime = String()
        
        if (isHourlyReportEnabled())
        {
            let doctorVisitObj = DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: customerCode, regionCode: regionCode)
            
            var mdlNumber: String = EMPTY
            var categoryCode: String = EMPTY
            var doctorName: String = EMPTY
            var spltyName: String = EMPTY
            var hospitalName: String = EMPTY
            
            if (doctorVisitObj != nil)
            {
                mdlNumber = doctorVisitObj!.MDL_Number!
                categoryCode = doctorVisitObj!.Category_Code!
                doctorName = doctorVisitObj!.Customer_Name!
                spltyName = doctorVisitObj!.Speciality_Name!
                hospitalName = doctorVisitObj!.Hospital_Name!
            }
            
            if (pobAmount == nil)
            {
                pobAmount = 0.0
            }
            
//            let enteredDateTime = convertDateToDate(date: getCurrentDateAndTime(), dateFormat: dateTimeWithoutMilliSec, timeZone: NSTimeZone.local)
            let visitTime = BL_DoctorList.sharedInstance.punchInTime
            
            let trackerDict: NSDictionary = ["DCR_Doctor_Visit_Id": 0, "DCR_Id": 0, "DCR_Actual_Date": getServerFormattedDateString(date: Date()), "Doctor_Code": customerCode, "Doctor_Region_Code": regionCode, "MDL_Number": mdlNumber, "Category_Code": categoryCode, "Lattitude": latString, "Longitude": longString, "Doctor_Visit_Date_Time": Doctor_Visit_Date_Time(dateString: visitTime), "Modified_Entity": modifiedEntity, "Doctor_Name": doctorName, "Speciality_Name": spltyName, "POB_Amount": pobAmount!, "Hospital_Name": hospitalName]
            
            let objDoctorVisitTracker = DoctorVisitTrackerModel(dict: trackerDict)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController, completion: { (objApiResponse) in
                if (objApiResponse.list.count > 0)
                {
                    DBHelper.sharedInstance.insertDoctorVisitTracker(objDoctorVisitTracker: objDoctorVisitTracker)
                    
                    self.sendHourlyReport(completion: { (objApiResponse) in
                        
                        print(objApiResponse.Status)
                        if(objApiResponse.Status == SERVER_SUCCESS_CODE)
                        {
                            completion(SERVER_SUCCESS_CODE)
//                            let getVisitDetails = objApiResponse.list[0] as! NSDictionary
//                            let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
//                            let dateTimeArray = getVisitTime.components(separatedBy: " ")
//                            let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
//                            let compare = NSCalendar.current.compare(originalDate, to: Date(), toGranularity: .day)
//                            if(compare == .orderedSame)
//                            {
//                                visitTime = getVisitTime
//
//                                self.insertEDetailedDoctorLocation(customerCode: customerCode, customerRegionCode: regionCode, latString: latString, longString: longString, geoFencingDeviationRemarks: geoFencingDeviationRemarks, dateString: visitTime)
//                                completion(SERVER_SUCCESS_CODE)
//                            }
//                            else
//                            {
//                                completion(SERVER_ERROR_CODE)
//                            }
                        }
                        else
                        {
                            completion(SERVER_ERROR_CODE)
                            //                            AlertView.showAlertView(title: alertTitle, message: "EDetailing Date is not a current date", viewController: viewController)
                        }
                    })
                }
            })
        }
        else
        {
            
            insertEDetailedDoctorLocation(customerCode: customerCode, customerRegionCode: regionCode, latString: latString, longString: longString, geoFencingDeviationRemarks: geoFencingDeviationRemarks, dateString: EMPTY)
            
            completion(SERVER_SUCCESS_CODE)
        }
    }
    
    func insertEDetailedDoctorLocation(customerCode: String, customerRegionCode: String, latString: String, longString: String, geoFencingDeviationRemarks: String,dateString:String)
    {
        let dcrDate = getServerFormattedDateString(date: Date())
        let count = DBHelper.sharedInstance.getEDDoctorLocationCount(customerCode: customerCode, customerRegionCode: customerRegionCode, dcrDate: dcrDate)
        
        if (count == 0) // No record is inserted for this doctor today
        {
            var latitude: Double = 0.0
            var longitude: Double = 0.0
            
            if (checkNullAndNilValueForString(stringData: latString) != EMPTY)
            {
                latitude = Double(latString)!
            }
            
            if (checkNullAndNilValueForString(stringData: longString) != EMPTY)
            {
                longitude = Double(longString)!
            }
            
            let dict: NSDictionary = ["Customer_Code": customerCode, "Customer_Region_Code": customerRegionCode, "DCR_Actual_Date": dcrDate, "Latitude": latitude, "Longitude": longitude, "Geo_Fencing_Deviation_Remarks": geoFencingDeviationRemarks,"Synced_Date_Time":dateString]
            let objDoctorLocation: EDetailDoctorLocationInfoModel = EDetailDoctorLocationInfoModel(dict: dict)
            
            DBHelper.sharedInstance.insertEDetailedDoctorLocationInfo(objDoctorLocation: objDoctorLocation)
        }
    }
    
    func saveFlexiDoctorVisitDetails(doctorName : String, specialityName : String, visitTime: String?, visitMode: String?, pobAmount: Double?, remarks: String?, regionCode : String?, viewController: UIViewController, businessStatusId: Int, businessStatusName: String, objCallObjective: BusinessStatusModel?,campaignName:String,campaignCode:String)
    {
        var pob = "0"
        var pobAmount = pobAmount
        
        if (pobAmount == nil)
        {
            pobAmount = 0.0
        }
        else
        {
            pob = String(describing: pobAmount!)
        }
        
        var callObjId: Int = defaultCallObjectiveId
        var callObjName: String = defaultCallObjectiveName
        let callObjStatus: Int = defaultCallObjectiveActviveStatus
        
        if (objCallObjective != nil)
        {
            callObjId = objCallObjective!.Business_Status_ID!
            callObjName = objCallObjective!.Status_Name!
        }
        
        let dcrIdString = String(format : "%d", getDCRId())
        let doctorDict: NSMutableDictionary = ["DCR_Id": dcrIdString, "Doctor_Id": 0, "Doctor_Code": "", "Doctor_Region_Code": regionCode, "Doctor_Name": doctorName, "Speciality_Name": specialityName, "MDL_Number": "", "Category_Code": "", "Category_Name": "", "Visit_Mode": visitMode, "Visit_Time": visitTime, "POB_Amount": pob, "Is_CP_Doc": 0, "Is_Acc_Doctor": 0, "Remarks": remarks, "Lattitude": getLatitude(), "Longitude": getLongitude(), "Doctor_Region_Name": getRegionName(), "Local_Area": EMPTY, "Sur_Name": EMPTY, "Business_Status_ID": businessStatusId, "Status_Name": businessStatusName, "Status": 1, "Call_Objective_ID": callObjId, "Call_Objective_Name": callObjName, "Call_Objective_Status": callObjStatus, "Is_DCR_Inherited_Doctor": 0,"Campaign_Code":campaignCode,"Campaign_Name":campaignName]
        
        let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
        let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
        
        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
        DCRModel.sharedInstance.customerVisitId = doctorVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.doctor
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: pobAmount, viewController: viewController)
    }
    
    func updateDCRDoctorVisit(dcrDoctorVisitObj: DCRDoctorVisitModel, viewController: UIViewController)
    {
        dcrDoctorVisitObj.Lattitude = checkNullAndNilValueForString(stringData: getLatitude())
        dcrDoctorVisitObj.Longitude = checkNullAndNilValueForString(stringData: getLongitude())
        
        DBHelper.sharedInstance.updateDCRDoctorVisit(dcrDoctorVisitObj: dcrDoctorVisitObj)
        
        insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: dcrDoctorVisitObj.POB_Amount, viewController: viewController)
    }
    
    
    func deleteDCRDoctorVisit(dcrDoctorVisitId: Int, customerCode: String, regionCode: String, dcrDate: String, doctorName: String)
    {
        BL_SampleProducts.sharedInstance.addInwardQty(dcrId: getDCRId(), doctorVisitId: dcrDoctorVisitId)
        
        BL_SampleProducts.sharedInstance.addBatchInwardQty(dcrId: getDCRId(), doctorVisitId: dcrDoctorVisitId, entityType: sampleBatchEntity.Doctor.rawValue)
        
        let getAttachments = DBHelper.sharedInstance.getAttachmentsForDoctorVisitId(doctorVisitId: dcrDoctorVisitId)
        for model in getAttachments
        {
            Bl_Attachment.sharedInstance.deleteAttachmentFile(fileName: model.attachmentName!)
        }
        
        DBHelper.sharedInstance.deleteDCRDoctorVisit(dcrDoctorVisitId: dcrDoctorVisitId)
        
        if (getEDetailedDoctorRemovePrivilegeValue() == PrivilegeValues.YES.rawValue)
        {
            let dict: NSDictionary = ["DCR_Actual_Date": dcrDate, "Doctor_Code": customerCode, "Doctor_Region_Code": regionCode, "Doctor_Name": doctorName, "DCR_Id": getDCRId()]
            let deleteObj = EDetailDoctorDeleteAudit(dict: dict)
            
            DBHelper.sharedInstance.insertEDetailDeleteAudit(objDeleteAudit: deleteObj)
            DBHelper.sharedInstance.deleteEDetailedAnalyticsForDoctor(customerCode: customerCode, regionCode: regionCode, dcrDate: dcrDate)
        }
    }
    
    func getDoctorAccompanist(doctorVisitId: Int, dcrId: Int) -> [DCRDoctorAccompanist]?
    {
        return BL_DCR_Doctor_Accompanists.sharedInstance.getDCRDoctorAccompanists(doctorVisitId: doctorVisitId, dcrId: dcrId)
    }
    
    func getDetailedProducts(dcrId: Int, doctorVisitId: Int) -> [DetailProductMaster]?
    {
        let productList = BL_DetailedProducts.sharedInstance.getDCRDetailedProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
        var dcrDetailedCompetitorReportList :[DCRCompetitorDetailsModel] = []
        
        for obj in productList
        {
            var productAttributes: String = EMPTY
            let space: String = "     "
            
            //productAttributes += "\n\n\(space)Business Status\n"
            
            if (obj.objWrapper.objBusinessStatus != nil)
            {
               // productAttributes += space + obj.objWrapper.objBusinessStatus!.Status_Name!
            }
            else
            {
                //productAttributes += "\(space)N/A"
            }
            
            //productAttributes += "\n\n\(space)Business Potential\n"
            if (obj.objWrapper.businessPotential != EMPTY)
            {
                if (obj.objWrapper.businessPotential != defaultBusinessPotential)
                {
              //      productAttributes += space + obj.objWrapper.businessPotential
                }
                else
                {
                //    productAttributes += "\(space)N/A"
                }
            }
            else
            {
                //productAttributes += "\(space)N/A"
            }
            
           // productAttributes += "\nRemarks\n"
            if (checkNullAndNilValueForString(stringData: obj.objWrapper.remarks) != EMPTY)
            {
                productAttributes = obj.objWrapper.remarks
            }
            else
            {
               // productAttributes += "\(space)N/A"
            }
            
            obj.stepperDisplayData = productAttributes
            obj.detailedCompetitorReportList = DBHelper.sharedInstance.getdetailCompetitorList(doctorVisitId: doctorVisitId, productCode: obj.Product_Code)
        }
        
        return productList
    }
    
    func getSampleProducts() -> [DCRSampleModel]?
    {
        return BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: getDCRId(), doctorVisitId: getDCRDoctorVisitId())
    }
    
    func getSampleBatchProducts() -> [DCRSampleBatchModel]
    {
        return BL_SampleProducts.sharedInstance.getSampleBatchDCRProducts(dcrId: getDCRId(), visitId: getDCRDoctorVisitId(), entityType: sampleBatchEntity.Doctor.rawValue)
    }
    
    func getDCRChemistVisitDetails() -> [DCRChemistVisitModel]?
    {
        return BL_DCR_Chemist_Visit.sharedInstance.getDCRChemistVisit()
    }
    
    func getFollowUpDetails() -> [DCRFollowUpModel]
    {
        return BL_DCR_Follow_Up.sharedInstance.getDCRFollowUpDetails()
    }
    
    func getDCRAttachmentDetails() -> [DCRAttachmentModel]?
    {
        return Bl_Attachment.sharedInstance.getDCRAttachment(dcrId: getDCRId(), doctorVisitId: getDCRDoctorVisitId())
    }
    
    func isGeoLocationMandatory() -> Bool
    {
        var locationMandatory: Bool = false
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY).uppercased()
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            locationMandatory = true
        }
        
        return locationMandatory
    }
    
    func getDoctorSuffixColumnName() -> [String]
    {
        let privVal = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_SUFIX_COLUMNS).uppercased()
        let privValList : [String] = privVal.components(separatedBy: ",")
        return privValList
    }
    
    func sendHourlyReport(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        var postData: NSMutableArray!
        let trackerList = DBHelper.sharedInstance.getDoctorVisitTracker()
        
        if (trackerList.count > 0)
        {
            postData = []
            
            for objTracker in trackerList
            {
                let doctorRegionCode: String = checkNullAndNilValueForString(stringData: objTracker.Doctor_Region_Code)
                let doctorCode: String = checkNullAndNilValueForString(stringData: objTracker.Doctor_Code)
                let mdlNumber: String = checkNullAndNilValueForString(stringData: objTracker.MDL_Number)
                let Hospital_Name: String = checkNullAndNilValueForString(stringData: objTracker.Hospital_Name)
                let categoryCode: String = checkNullAndNilValueForString(stringData: objTracker.Category_Code)
                var latitude: String = checkNullAndNilValueForString(stringData: objTracker.Lattitude)
                var longitude: String = checkNullAndNilValueForString(stringData: objTracker.Longitude)
                var pobAmount: Double? = objTracker.POB_Amount
                
                if (latitude == EMPTY)
                {
                    latitude = "0.0"
                }
                
                if (longitude == EMPTY)
                {
                    longitude = "0.0"
                }
                
                if (pobAmount == nil)
                {
                    pobAmount = 0.0
                }
               let punchtime =  BL_DoctorList.sharedInstance.punchInTime
                let dict1: NSDictionary = ["DCR_Visit_Tracker_Id": objTracker.DCR_Doctor_Visit_Tracker_Id, "DCR_Actual_Date": convertDateIntoServerStringFormat(date: objTracker.DCR_Actual_Date), "Visit_Id": objTracker.DCR_Doctor_Visit_Id, "DCR_Id": objTracker.DCR_Id, "Doctor_Region_Code": doctorRegionCode, "Doctor_Code": doctorCode, "MDL_Number": mdlNumber, "Hospital_Name": Hospital_Name, "Category_Code": categoryCode]
                
                let dict2: NSDictionary = ["Lattitude": Double(latitude)!, "Longitude": Double(longitude)!, "Doctor_Visit_Date_Time": punchtime, "Modified_Entity": BL_DoctorList.sharedInstance.modifyEntity, "Doctor_Name": objTracker.Doctor_Name, "Speciality_Name": objTracker.Speciality_Name!, "Doctor_Id": 0, "Line_Of_Business": 2, "POB_Amount": Double(pobAmount!),"Customer_Entity_Type":"D","Source_Of_Entry":"iOS"]
                
                var combinedAttributes : NSMutableDictionary!
                combinedAttributes = NSMutableDictionary(dictionary: dict1)
                combinedAttributes.addEntries(from: dict2 as! [AnyHashable : Any])
                
                postData.add(combinedAttributes)
            }
            
            WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiRespobseObj) in
                if (apiRespobseObj.Status == SERVER_SUCCESS_CODE)
                {
                    DBHelper.sharedInstance.deletelDoctorVisitTracker()
                }
                
                completion(apiRespobseObj)
            })
        }
        else
        {
            completion(getApiResponseObject())
        }
    }
    
    //MARK:-- Validation Functions
    func getInputMandatoryPrivilegeValidation(dcrDoctorVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        let minimumInputCount = getInputMandatoryNumber()
        
        if (minimumInputCount > 0)
        {
            let dcrInputCount = DBHelper.sharedInstance.getDoctorSampleCount(dcrDoctorVisitId: dcrDoctorVisitId)
            
            if (dcrInputCount < minimumInputCount)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    
    func getDetailedProductMandatoryPrivilegeValidation(dcrDoctorVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        let minimumDetailingCount = getDetailedProductMandatoryNumber()
        
        if (minimumDetailingCount > 0)
        {
            let dcrDetailingCount = DBHelper.sharedInstance.getDoctorDetailedProductsCount(dcrDoctorVisitId: dcrDoctorVisitId)
            
            if (dcrDetailingCount < minimumDetailingCount)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    
    func getChemistMandatoryPrivilegeValidation(dcrDoctorVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        let minimumChemistCount = getChemistMandatoryNumber()
        
        if (minimumChemistCount > 0)
        {
            let dcrChemistCount = DBHelper.sharedInstance.getDoctorChemistCount(dcrDoctorVisitId: dcrDoctorVisitId)
            
            if (dcrChemistCount < minimumChemistCount)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    
    
    func getMoneyTree() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.MONEY_TREE_KEY)
    }
    
    
    
    func getDoctorVisitTimeEntryMode() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_VISIT_TIME_ENTRY_MODE).uppercased()
    }
    
    func getDoctorCaptureValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_FIELD_CAPTURE_CONTROLS).uppercased()
    }
    
    func getDCRDoctorVisitMode() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_VISIT_MODE).uppercased()
    }
    
    func showPOBAmtView() -> Bool
    {
        var show : Bool  = false
        let value = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DOCTOR_POB_AMOUNT).uppercased()
        if value == "YES"
        {
            show = true
        }
        return show
    }
    
    func isValidDoctor(dcrDoctorVisitObj: DCRDoctorVisitModel) -> Bool
    {
        var isValid: Bool = false
        var isFlexiDoctor: Bool = false
        
        if (checkNullAndNilValueForString(stringData: dcrDoctorVisitObj.Doctor_Code) == EMPTY)
        {
            isFlexiDoctor = true
        }
        
        if (isFlexiDoctor)
        {
            let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RIGID_DOCTOR_ENTRY).uppercased()
            
            if (privValue == PrivilegeValues.NO.rawValue)
            {
                isValid = true
            }
        }
        else
        {
            let customerObj: CustomerMasterModel? = getCustomerMasterByCustomerCode(customerCode: dcrDoctorVisitObj.Doctor_Code!, regionCode: dcrDoctorVisitObj.Doctor_Region_Code!)
            
            if (customerObj != nil)
            {
                if (checkNullAndNilValueForString(stringData: customerObj!.Customer_Name) != EMPTY)
                {
                    if (customerObj!.Region_Code == getRegionCode())
                    {
                        isValid = true
                    }
                    else
                    {
                        if (canUseAccompanistsDoctor())
                        {
                            let dcrAccompanistsList = getDCRAccompanistsList()
                            
                            if (dcrAccompanistsList != nil)
                            {
                                let filteredArray = dcrAccompanistsList!.filter{
                                    $0.Acc_Region_Code == customerObj!.Region_Code
                                }
                                
                                if (filteredArray.count > 0)
                                {
                                    isValid = true
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return isValid
    }
    
    /*
     If this function returns true, the user has no need to enter RCPA mandatorily
     If this function returns false, the user MUST enter RCPA mandatorily
     */
    func doRCPAMandatoryCheck(doctorCategoryName: String?, dcrDoctorVisitId: Int) -> Bool
    {
        var returnValue: Bool = true
        
        if (!BL_Stepper.sharedInstance.isChemistDayEnabled())
        {
            if (doctorCategoryName != nil)
            {
                if (doctorCategoryName != "")
                {
                    let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY).uppercased()
                    let privArray = privilegeValue.components(separatedBy: ",")
                    
                    if (privArray.contains(doctorCategoryName!.uppercased()))
                    {
                        let rcpaCount = DBHelper.sharedInstance.getRCPACountForDoctorVisitId(dcrDoctorVisitId: dcrDoctorVisitId)
                        
                        if (rcpaCount == 0)
                        {
                            returnValue = false
                        }
                    }
                }
            }
        }
        
        return returnValue
    }
    
    func doDoctorVisitAllValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        let doctorList = getDCRDoctorList()
        
        if (doctorList != nil)
        {
            for doctorVisitObj in doctorList
            {
                errorMessage = doDoctorVisitAllValidations(doctorVisitObj: doctorVisitObj)
                
                if (errorMessage != EMPTY)
                {
                    break
                }
            }
        }
        
        return errorMessage
    }
    
    func doDoctorVisitAllValidations(doctorVisitObj: DCRDoctorVisitModel) -> String
    {
        let errorMessage: String = EMPTY
        let priviledge = self.getDoctorCaptureValue()
        let privArray = priviledge.components(separatedBy: ",")
        //        let isValid: Bool = isValidDoctor(dcrDoctorVisitObj: doctorVisitObj)
        //
        //        if (!isValid)
        //        {
        //            errorMessage = "The doctor \(doctorVisitObj.Doctor_Name!) is invalid"
        //        }
        
        if (getDCRDoctorVisitMode() == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue)
        {
            if (checkNullAndNilValueForString(stringData: doctorVisitObj.Visit_Time) == EMPTY)
            {
                return  "\(appDoctor) visit time is missing for the \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
            }
        }
        if privArray.contains(Constants.ChemistDayCaptureValue.samples)
        {
            if (!getInputMandatoryPrivilegeValidation(dcrDoctorVisitId: doctorVisitObj.DCR_Doctor_Visit_Id))
            {
                return "You need to enter minimum of \(String(getInputMandatoryNumber())) input(s) for the \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.detailing)
        {
            if (!getDetailedProductMandatoryPrivilegeValidation(dcrDoctorVisitId: doctorVisitObj.DCR_Doctor_Visit_Id))
            {
                return "You need to enter minimum of \(String(getDetailedProductMandatoryNumber())) detailing product(s) for the \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.RCPA)
        {
            if BL_Stepper.sharedInstance.isChemistDayEnabled() == false
            {
                if (!getChemistMandatoryPrivilegeValidation(dcrDoctorVisitId: doctorVisitObj.DCR_Doctor_Visit_Id))
                {
                    return "You need to enter minimum of \(String(getChemistMandatoryNumber())) \(appChemist) for the \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
                }
            }
        }
        if privArray.contains(Constants.ChemistDayCaptureValue.RCPA)
        {
            if (!doRCPAMandatoryCheck(doctorCategoryName: doctorVisitObj.Category_Name, dcrDoctorVisitId: doctorVisitObj.DCR_Doctor_Visit_Id))
            {
                return "You need to enter minimum of 1 RCPA for the \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.pob)
        {
            let poblist = doctorPOBSaleProductCheck(doctorVisitId: doctorVisitObj.DCR_Doctor_Visit_Id)
            
            if poblist.count != 0
            {
                for obj in poblist
                {
                    let pobCheck = obj[0] as! Bool
                    let stockiestName = obj[1] as! String
                    
                    if pobCheck == false
                    {
                        return "You need to enter minimum of 1 sale product for the \(appStockiest) \(stockiestName ) in POB for the  \(appDoctor) \(doctorVisitObj.Doctor_Name!)"
                    }
                }
            }
        }
        
        return errorMessage
    }
    
    func doctorPOBSaleProductCheck(doctorVisitId: Int) -> [[Any]]
    {
        var validated : [[Any]] = []
        let headerList = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: getDCRId(), visitId: doctorVisitId, customerEntityType: Constants.CustomerEntityType.doctor)
        
        for obj in headerList
        {
            if obj.Order_Entry_Id != nil && obj.Order_Entry_Id != 0
            {
                validated.append(doPOBSaleProductsCheck(headerObj: obj))
            }
        }
        
        return validated
    }
    
    func doPOBSaleProductsCheck(headerObj: DCRDoctorVisitPOBHeaderModel) -> [Any]
    {
        var mandatoryCheckList : [Any] = []
        let pobSaleProducts = BL_POB_Stepper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryID: headerObj.Order_Entry_Id)
        var  stockiestName = EMPTY
        
        stockiestName = headerObj.Stockiest_Name
        
        if (pobSaleProducts.count == 0)
        {
            mandatoryCheckList.append(false)
            mandatoryCheckList.append(stockiestName)
            return mandatoryCheckList
        }
        else
        {
            mandatoryCheckList.append(true)
            mandatoryCheckList.append(stockiestName)
            return mandatoryCheckList
        }
    }
    
    func getCustomerMasterByCustomerCode(customerCode: String, regionCode: String) -> CustomerMasterModel?
    {
        return DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: customerCode, regionCode: regionCode)
    }
    
    func getCustomerMasterByCustomerCodeForEdit(customerCode: String, regionCode: String) -> CustomerMasterEditModel?
    {
        return DBHelper.sharedInstance.getCustomerByCustomerCodeForEdit(customerCode: customerCode, regionCode: regionCode)
    }
    
    //MARK:- Private Functions
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    //    private func getCustomerId() -> Int
    //    {
    //        return DCRModel.sharedInstance.customerId
    //    }
    
    private func getCustomerCode() -> String
    {
        return DCRModel.sharedInstance.customerCode
    }
    
    private func getCustomerRegionCode() -> String
    {
        return DCRModel.sharedInstance.customerRegionCode
    }
    
    func isCPDoctor(doctorCode: String, doctorRegionCode: String) -> Int
    {
        var returnValue: Int = 0
        let cpDoctorList = getCPDoctorsForSelectedDate()
        
        if (cpDoctorList != nil)
        {
            if (cpDoctorList!.count > 0)
            {
                let filteredArray = cpDoctorList!.filter{
                    $0.Category_Code == doctorCode && $0.Region_Code == doctorRegionCode
                }
                
                if (filteredArray.count > 0)
                {
                    returnValue = 1
                }
            }
        }
        
        return returnValue
    }
    
    func isAccompanistDoctor(doctorRegionCode: String) -> Int
    {
        var returnValue: Int = 0
        
        if (doctorRegionCode.uppercased() != getRegionCode().uppercased())
        {
            returnValue = 1
        }
        
        return returnValue
    }
    
    private func getInputMandatoryNumber() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_INPUT_MANDATORY_NUMBER)
        var minimumInputCount: Int = 0
        
        if (privilegeValue != "")
        {
            minimumInputCount = Int(privilegeValue)!
        }
        
        return minimumInputCount
    }
    
    private func getDetailedProductMandatoryNumber() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_DETAILING_MANDATORY_NUMBER)
        var minimumDetailingCount: Int = 0
        
        if (privilegeValue != "")
        {
            minimumDetailingCount = Int(privilegeValue)!
        }
        
        return minimumDetailingCount
    }
    
    private func getChemistMandatoryNumber() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_CHEMIST_MANDATORY_NUMBER)
        var minimumChemistCount: Int = 0
        
        if (privilegeValue != "")
        {
            minimumChemistCount = Int(privilegeValue)!
        }
        
        return minimumChemistCount
    }
    
    func doctorMasterAddBtnHidden() -> Bool
    {
        var flag : Bool = true
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RIGID_DOCTOR_ENTRY).uppercased()
        if privValue.contains(PrivilegeValues.NO.rawValue)
        {
            flag = false
        }
        
        return flag
    }
    
    func doctorAttendanceMasterAddBtnHidden() -> Bool
    {
        var flag : Bool = true
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RIGID_ATTENDANCE_DOCTOR_ENTRY).uppercased()
        if privValue.contains(PrivilegeValues.NO.rawValue)
        {
            flag = false
        }
        
        return flag
    }
    
    func getTourPlannerPrivVal() -> Bool
    {
        var flag : Bool = true
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.TOUR_PLANNER).uppercased()
        if privValue.contains(PrivilegeValues.NO.rawValue)
        {
            flag = false
        }
        
        return flag
    }
    
    private func getDCRDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.doctorVisitId
    }
    
    private func getApiResponseObject() -> ApiResponseModel
    {
        let apiResponseObj: ApiResponseModel = ApiResponseModel()
        
        apiResponseObj.Status = SERVER_ERROR_CODE
        apiResponseObj.Message = "No records found to send live tracker report"
        apiResponseObj.list = []
        apiResponseObj.Count = 0
        
        return apiResponseObj
    }
    
    func updateAccompanistCall(index: Int, selectedIndex: Int)
    {
        let model = accompanistList[index]
        var accompStatus:String!
        if selectedIndex == 0
        {
            accompStatus = "1"
        }
        else if selectedIndex == 1
        {
            accompStatus = "0"
        }
        else
        {
            accompStatus = "99"
        }
        model.Is_Accompanied = accompStatus
        DBHelper.sharedInstance.updateDCRDoctorAccompanist(dcrDoctorAccompanistObj: model)
    }
    
    func checkAccompanistCallStatus() -> DCRDoctorAccompanist?
    {
        var model : DCRDoctorAccompanist?
        
        let accompDataList = DBHelper.sharedInstance.getDCRDoctorAccompanistsByAccompaniedStatus(dcrId: getDCRId(), doctorVisitId: getDCRDoctorVisitId(), accompaniedStatus: 99)
        
        if (accompDataList.count > 0)
        {
            model = accompDataList.first!
        }
        
        return model
    }
    
    func getDCRDoctorAssetDetails() -> [AssetsModel]
    {
        var assetList : [AssetsModel] = []
        
        let assetAnalyticsList  = DBHelper.sharedInstance.getDCRDoctorDigitalAssets(dcrDate: DCRModel.sharedInstance.dcrDateString, customerCode: DCRModel.sharedInstance.customerCode,regionCode: DCRModel.sharedInstance.customerRegionCode)
        let assetsUnqiueNumberList = DBHelper.sharedInstance.getTotalUniquePagesCount(dcrDate: DCRModel.sharedInstance.dcrDateString, customerCode:  DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode)
        if assetAnalyticsList != nil
        {
            for analyticObj in assetAnalyticsList!
            {
                let assetObj : AssetsModel = AssetsModel()
                let filteredList = assetsUnqiueNumberList.filter{
                    $0.DA_Code == analyticObj.DA_Code
                }
                assetObj.assetsName = analyticObj.Da_Name
                assetObj.assetType = analyticObj.Doc_Type
                var playedTimeDuration : String = "0.0"
                if analyticObj.Total_played_Time_Duration != nil
                {
                    playedTimeDuration = String(describing: analyticObj.Total_played_Time_Duration!)
                }
                assetObj.totalPlayedDuration = playedTimeDuration
                assetObj.totalPagesViewed = "\(analyticObj.Total_Viewed_Pages!)"
                if filteredList.count > 0
                {
                    let obj = filteredList.first
                    assetObj.totalUniquePagesCount = "\((obj?.Total_Unique_Pages_Count)!)"
                }
                assetList.append(assetObj)
            }
        }
        
        return assetList
    }
    
    //MARK:- eDetailing
    func geteDetailingConfigVal() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.IS_EDetailing_Enabled)
    }
    func getMoneyTreeConfig() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getMoneyTreeConfigSettingValue(configName: ConfigNames.MONEY_TREE_KEY)
    }
    
    func getStoryEnabledPrivVal() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.IS_MC_STORY_ENABLED)
    }
    
    func getAssetDetails() -> [AssetAnalytics]?
    {
        return DBHelper.sharedInstance.getDoctorVisitAssets(customerCode: DCRModel.sharedInstance.customerCode, dcrDate: DCRModel.sharedInstance.dcrDate)
    }
    
    func checkDoctorAnalyticsDetails(customerCode: String, regionCode: String, dcrDate: String) -> Int
    {
        return DBHelper.sharedInstance.checkDoctorExistsAnalyticsDetail(customerCode: customerCode, regionCode: regionCode, dcrDate: dcrDate)
    }
    
    func getEDetailedDoctorRemovePrivilegeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DELETE_EDETAILED_DOCTOR_IN_DCR_DOCTOR_VISIT)
    }
    
    func isEDetailingAnalyticsSynced(customerCode: String, regionCode: String, dcrDate: String) -> Bool
    {
        if (DBHelper.sharedInstance.getEDetailedSyncedAnalyticsCount(customerCode: customerCode, regionCode: regionCode, dcrDate: dcrDate) > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func canRemoveEDetailedDoctor(customerCode: String, regionCode: String, dcrDate: String) -> Bool
    {
        var allowToDelete: Bool = true
        let analyticsCount = checkDoctorAnalyticsDetails(customerCode: customerCode, regionCode: regionCode, dcrDate: dcrDate)
        
        if (analyticsCount > 0)
        {
            let priValue = getEDetailedDoctorRemovePrivilegeValue()
            
            if (priValue == PrivilegeValues.NO.rawValue)
            {
                allowToDelete = false
            }
        }
        
        return allowToDelete
    }
    
    func showAssetCard() -> Bool
    {
        var flag : Bool = false
        
        if (geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased() && getDCRDoctorAssetDetails().count > 0)
        {
            flag = true
        }
        
        return flag
    }
    
    func getDCRDoctorAssetDetails(dcrDate : String) -> [AssetAnalyticsDetail]?
    {
        return DBHelper.sharedInstance.getAssetsCustomerByDCRDate(dcrDate: dcrDate)
    }
    
    
    //    func insertAssetDetailedDoctorInVisit(dcrDate : String)
    //    {
    //        let assetAnalyticsList = getDCRDoctorAssetDetails(dcrDate: dcrDate)
    //
    //        if assetAnalyticsList != nil
    //        {
    //            for assetAnalyticsObj in assetAnalyticsList!
    //            {
    //                var doctorId: Int?
    //                var doctorCode: String?
    //                var doctorName: String?
    //                var doctorRegionCode: String?
    //                var specialtyName: String?
    //                var categoryCode: String?
    //                var categoryName: String?
    //                var mdlNumber: String?
    //                var isCPDoc: Int = 0
    //                var isAccDoc: Int = 0
    //                var doctorRegionName: String?
    //                var localArea: String?
    //                var surName: String?
    //
    //                if (assetAnalyticsObj.Customer_Code != nil)
    //                {
    //                    let doctorObj = getCustomerMasterByCustomerCode(customerCode: (assetAnalyticsObj.Customer_Code)!, regionCode: (assetAnalyticsObj.Customer_Region_Code)!)
    //
    //                    if (doctorObj != nil)
    //                    {
    //                        doctorId = doctorObj!.Customer_Id
    //                        doctorCode = doctorObj!.Customer_Code
    //                        doctorName = doctorObj!.Customer_Name
    //                        doctorRegionCode = doctorObj!.Region_Code
    //                        specialtyName = doctorObj!.Speciality_Name
    //                        categoryCode = doctorObj!.Category_Code
    //                        categoryName = doctorObj!.Category_Name
    //                        mdlNumber = doctorObj!.MDL_Number
    //                        doctorRegionName = doctorObj!.Region_Name
    //                        localArea = doctorObj!.Local_Area
    //                        surName = doctorObj!.Sur_Name
    //
    //                        isCPDoc = isCPDoctor(doctorCode: doctorCode!, doctorRegionCode: doctorRegionCode!)
    //                        isAccDoc = isAccompanistDoctor(doctorRegionCode: doctorRegionCode!)
    //                    }
    //
    //                    let dcrIdString = String(format : "%d", getDCRId())
    //                    let doctorDict: NSDictionary = ["DCR_Id": dcrIdString, "Doctor_Id": doctorId!, "Doctor_Code": doctorCode!, "Doctor_Region_Code": doctorRegionCode!, "Doctor_Name": doctorName!, "Speciality_Name": specialtyName!, "MDL_Number": mdlNumber!, "Category_Code": categoryCode!, "Category_Name": categoryName!,"Is_CP_Doc": isCPDoc, "Is_Acc_Doctor": isAccDoc,"Lattitude": getLatitude(), "Longitude": getLongitude(), "Doctor_Region_Name": doctorRegionName!, "Local_Area": checkNullAndNilValueForString(stringData: localArea), "Sur_Name": checkNullAndNilValueForString(stringData: surName)]
    //
    //                    let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorDict)
    //
    //                    let doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
    //
    //                    DCRModel.sharedInstance.doctorVisitId = doctorVisitId
    //
    //                    insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: 0.0)
    //                }
    //            }
    //        }
    //    }
    
    func getConvertedTPDocForSelDateToCustomerModel() -> [CustomerMasterModel]?
    {
        var tpDoctorList: [TourPlannerDoctor]?
        tpDoctorList = BL_Stepper.sharedInstance.getTPDoctorsByDate(dcrDate: getServerFormattedDate(date: Date()))
        
        var customerMasterList: [CustomerMasterModel] = []
        
        if (tpDoctorList != nil)
        {
            for tpDoctorObj in tpDoctorList!
            {
                let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCodeAndRegionCode(customerCode: tpDoctorObj.Doctor_Code, regionCode: tpDoctorObj.Doctor_Region_Code, customerEntityType: DOCTOR)
                
                if (customerObj != nil)
                {
                    customerMasterList.append(customerObj!)
                }
            }
        }
        
        return customerMasterList
    }
    
    func updateDCRDoctorVisitTimeBasedOnAssetAnaytics()
    {
        if (checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerCode) != EMPTY && checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerRegionCode) != EMPTY)
        {
            let objDoctorVisit = DBHelper.sharedInstance.getDoctorVisitDetailsByDoctorCode(dcrId: DCRModel.sharedInstance.dcrId, customerCode: DCRModel.sharedInstance.customerCode, regionCode: DCRModel.sharedInstance.customerRegionCode)
            var assetAnalytics:[AssetAnalyticsDetail] = []
            let doctorVisitModePrivValue = getDCRDoctorVisitMode()
            
            if (objDoctorVisit != nil)
            {
                if (objDoctorVisit!.DCR_Doctor_Visit_Id > 0)
                {
                    let list = DBHelper.sharedInstance.getAssestAnalyticsByCustomer(dcrDate: DCRModel.sharedInstance.dcrDateString, customerCode: DCRModel.sharedInstance.customerCode, customeRegionCode: DCRModel.sharedInstance.customerRegionCode)
                    
                    if list != nil
                    {
                        assetAnalytics = list
                    }
                    
                    if assetAnalytics.count > 0
                    {
                        let visitDetails =  BL_DCRCalendar.sharedInstance.getVisitTimeBasedOnAssetAnalytics(objAssetAnalytics: assetAnalytics[0])
                        let visitMode = visitDetails.0
                        var visitTime = visitDetails.1
                        
                        if (!isHourlyReportEnabled())
                        {
                            if (doctorVisitModePrivValue == PrivilegeValues.AM_PM.rawValue)
                            {
                                visitTime = EMPTY
                            }
                        }
                        
                        BL_DCRCalendar.sharedInstance.updateVisitTimeBasedOnAssetAnalytics(visitMode: visitMode, visitTime: visitTime, dcrDoctorVisitId: (objDoctorVisit?.DCR_Doctor_Visit_Id)!)
                    }
                }
            }
        }
    }
    
    func isDetailedDoctor() -> Bool
    {
        var isDetailed = false
        var assetDetails:[AssetAnalyticsDetail] = []
        if (checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerCode) != EMPTY && checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerRegionCode) != EMPTY)
        {
            let assetAnalytics = DBHelper.sharedInstance.getAssestAnalyticsByCustomer(dcrDate: DCRModel.sharedInstance.dcrDateString, customerCode: DCRModel.sharedInstance.customerCode, customeRegionCode: DCRModel.sharedInstance.customerRegionCode)
            if assetAnalytics != nil
            {
                assetDetails = assetAnalytics
            }
            if assetDetails.count > 0
            {
                isDetailed = true
                return isDetailed
            }
            else
            {
                return isDetailed
            }
        }
        else
        {
            return isDetailed
        }
    }
    
    private func getDefaultBusinessStatus() -> BusinessStatusModel
    {
        let dict: NSDictionary = ["Business_Status_Id": defaultBusineessStatusId, "Status_Name": defaultBusinessStatusName, "Entity_Type_Description": DOCTOR, "Entity_Type": Constants.Business_Status_Entity_Type_Ids.Doctor]
        let objStatus = BusinessStatusModel(dict: dict)
        
        return objStatus
    }
    
    private func getDefaultCallObjectiveStatus() -> BusinessStatusModel
    {
        let dict: NSDictionary = ["Business_Status_Id": defaultCallObjectiveId, "Status_Name": defaultCallObjectiveName, "Entity_Type_Description": DOCTOR, "Entity_Type": Constants.Call_Objective_Entity_Type_Ids.Doctor]
        let objStatus = BusinessStatusModel(dict: dict)
        
        return objStatus
    }
    
    func getDoctorBusinessStatusList() -> [BusinessStatusModel]
    {
        var statusList = DBHelper.sharedInstance.getBusinessStatusByEntityType(businessStatusEntityType: Constants.Business_Status_Entity_Type_Ids.Doctor)
        
        //        if (statusList.count > 0)
        //        {
        statusList.insert(getDefaultBusinessStatus(), at: 0)
        //        }
        
        return statusList
    }
    
    func getProductBusinessStatusList() -> [BusinessStatusModel]
    {
        var statusList = DBHelper.sharedInstance.getBusinessStatusByEntityType(businessStatusEntityType: Constants.Business_Status_Entity_Type_Ids.Detailed_Products)
        
        //        if (statusList.count > 0)
        //        {
        statusList.insert(getDefaultBusinessStatus(), at: 0)
        //        }
        
        return statusList
    }
    
    func getCampaignList()
    {
        DBHelper.sharedInstance.getMCList(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
    }
    
    func getDoctorCallObjectiveList() -> [BusinessStatusModel]
    {
        let callObjectiveList = DBHelper.sharedInstance.getCallObjectiveByEntityType(entityType: Constants.Call_Objective_Entity_Type_Ids.Doctor)
        var lstStatus: [BusinessStatusModel] = []
        
        if (callObjectiveList.count > 0)
        {
            for objCallObjective in callObjectiveList
            {
                let dict: NSDictionary = ["Business_Status_Id": objCallObjective.Call_Objective_ID, "Status_Name": objCallObjective.Call_Objective_Name, "Entity_Type_Description": DOCTOR, "Entity_Type": Constants.Call_Objective_Entity_Type_Ids.Doctor]
                let objStatus = BusinessStatusModel(dict: dict)
                
                lstStatus.append(objStatus)
            }
        }
        
        lstStatus.insert(getDefaultCallObjectiveStatus(), at: 0)
        
        return lstStatus
    }
    
    //MARK:- DCR Inheritance
    func getDCRInheritancePrivilegeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_INHERITANCE)
    }
    
    func isDCRInheritanceEnabled() -> Bool
    {
        let privValue = getDCRInheritancePrivilegeValue()
        
        if (privValue == PrivilegeValues.ONE.rawValue || privValue == PrivilegeValues.TWO.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isDCRInheritanceEditable() -> Bool
    {
        var isEditable: Bool = true
        
        if (isDCRInheritanceEnabled())
        {
            let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.IS_DCR_INHERITANCE_EDITABLE)
            
            if (privValue == PrivilegeValues.NO.rawValue)
            {
                isEditable = false
            }
        }
        
        return isEditable
    }
    
    func doDCRInheritanceValidations() -> DCRInheritanceValidationModel
    {
        if (!isManager())
        {
            return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.PROCEED, message: EMPTY)
        }
        
        let dcrInheritanceValue = getDCRInheritancePrivilegeValue()
        if (dcrInheritanceValue == PrivilegeValues.ZERO.rawValue)
        {
            return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.PROCEED, message: EMPTY)
        }
        
        if (!canUseAccompanistsDoctor())
        {
            return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.PROCEED, message: EMPTY)
        }
        
        //        let accompanistList = BL_Stepper.sharedInstance.accompanistList
        //        if (accompanistList.count == 0)
        //        {
        //            if (dcrInheritanceValue == PrivilegeValues.ONE.rawValue)
        //            {
        //                return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_ERROR, message: EMPTY)
        //            }
        //            else if (dcrInheritanceValue == PrivilegeValues.TWO.rawValue)
        //            {
        //                return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.ACCOMPANIST_NOT_ENTERED_CONFIRMATION, message: EMPTY)
        //            }
        //        }
        
        let accUserCodes = dcrInheritanceAccompanistCodes()
        
        if (!checkInternetConnectivity())
        {
            if (dcrInheritanceValue == PrivilegeValues.ONE.rawValue)
            {
                return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.INTERNET_MANDATORY_ERROR, message: accUserCodes)
            }
            else if (dcrInheritanceValue == PrivilegeValues.TWO.rawValue)
            {
                return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.INTERNET_OPTIONAL_ERROR, message: accUserCodes)
            }
        }
        
        if (accUserCodes == EMPTY)
        {
            return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.PROCEED, message: EMPTY)
        }
        
        //        let accDataNowDownloadedUsers = isAccompanistDataDownloaded(userCodes: accUserCodes)
        //
        //        if (accDataNowDownloadedUsers != EMPTY)
        //        {
        //            return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.ACC_DATA_NOT_DOWNLOADED_ERROR, message: accDataNowDownloadedUsers)
        //        }
        
        return generateDCRInheritanceResponseModel(status: Constants.DCR_Inheritance_Status_Codes.MAKE_API_CALL, message: accUserCodes)
    }
    
    func generateDCRInheritanceResponseModel(status: Int, message: String) -> DCRInheritanceValidationModel
    {
        let objResponse: DCRInheritanceValidationModel = DCRInheritanceValidationModel()
        
        objResponse.Status = status
        objResponse.Message = message
        
        return objResponse
    }
    
    private func dcrInheritanceAccompanistCodes() -> String
    {
        var accompanistsUsersCodes: String = EMPTY
        let dcrAccompanistList = BL_Stepper.sharedInstance.accompanistList
        let accompanistMasterList = DBHelper.sharedInstance.getAccompanistMaster()
        
        for objAccompanist in dcrAccompanistList
        {
            if (getDoctorCount(regionCode: objAccompanist.Acc_Region_Code) > 0) // Doctor master should be there
            {
                if (accompanistMasterList != nil)
                {
                    let filteredArray = accompanistMasterList.filter{
                        $0.User_Code == objAccompanist.Acc_User_Code! && $0.Child_User_Count == 0 && $0.User_Name != VACANT && $0.User_Name != NOT_ASSIGNED
                    }
                    
                    if (filteredArray.count > 0) // Should be leaf user
                    {
                        let dcrFiltered = dcrAccompanistList.filter{
                            $0.Acc_User_Code! == objAccompanist.Acc_User_Code! && $0.Is_Customer_Data_Inherited != Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success && $0.Is_Only_For_Doctor == "0"
                        }
                        
                        if (dcrFiltered.count > 0) // Not previously downloaded and got success
                        {
                            accompanistsUsersCodes += objAccompanist.Acc_User_Code! + ","
                        }
                    }
                }
            }
        }
        
        return accompanistsUsersCodes
    }
    
    private func isAccompanistDataDownloaded(userCodes: String) -> String
    {
        var accompanistNames: String = EMPTY
        let accArray = userCodes.components(separatedBy: ",")
        
        for accUserCode in accArray
        {
            if (accUserCode != EMPTY)
            {
                let filteredArray = BL_Stepper.sharedInstance.accompanistList.filter{
                    $0.Acc_User_Code == accUserCode
                }
                
                if (filteredArray.count > 0)
                {
                    let accObj = filteredArray.first!
                    
                    if (BL_DCR_Accompanist.sharedInstance.isAccompanistDataAvailable(userCode: accObj.Acc_User_Code!, regionCode: accObj.Acc_Region_Code) == 0)
                    {
                        accompanistNames += accObj.Employee_Name! + ","
                    }
                }
            }
        }
        
        return accompanistNames
    }
    
    func getAccompanistDCRDoctorVisit(viewController: UIViewController, accompanistsUsersCodes: String, completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        let postData: [String: Any] = ["Company_Code": getCompanyCode(), "User_Code": getUserCode(), "ACC_User_Code": accompanistsUsersCodes, "DcrDate": DCRModel.sharedInstance.dcrDateString]
        
        WebServiceHelper.sharedInstance.getDCRInhetitanceDoctors(postData: postData, completion: { (objApiResponse) in
            let responseList = objApiResponse.list
            
            if (responseList != nil)
            {
                if (responseList!.count > 0)
                {
                    let dict = objApiResponse.list.firstObject! as! NSDictionary
                    var errorMsg: String = EMPTY
                    
                    // Get error users list & msg
                    let errorUserList: NSArray = dict.value(forKey: "lstErrorUsers") as! NSArray
                    errorMsg = self.getDCRInheritanceErrorMsgs(responseList: errorUserList)
                    
                    // Get success users list & msg
                    let successUserList: NSArray = dict.value(forKey: "lstSuccessUsers") as! NSArray
                    let doctorList: NSArray = dict.value(forKey: "lstDCRInheritanceDetails") as! NSArray
                    let successMsg: String = self.getSuccessMsgs(successUserList: successUserList, doctorList: doctorList)
                    
                    if (errorMsg != EMPTY)
                    {
                        errorMsg += "\n"
                    }
                    errorMsg += successMsg
                    
                    // Insert DCR doctor and Doctor Accompanist
                    if (doctorList.count > 0)
                    {
                        self.insertDCRDoctorInheritance(responseList: doctorList, viewController: viewController)
                    }
                    
                    //                    let dcrInheritanceValue = self.getDCRInheritancePrivilegeValue()
                    //                    if (dcrInheritanceValue == PrivilegeValues.ONE.rawValue)
                    //                    {
                    //                        if (errorUserList.count > 0 && successMsg == EMPTY)
                    //                        {
                    //                            objApiResponse.Status = 2
                    //                        }
                    //                    }
                    
                    objApiResponse.Message = errorMsg
                }
            }
            
            completion(objApiResponse)
        })
    }
    
    func canInheritedUserAddDoctors(accUserCode: String, isFlexi: Bool) -> Bool
    {
        var canAddDoctor: Bool = true
        
        if (!isFlexi)
        {
            if (!self.isDCRInheritanceEditable())
            {
                let dcrAccompanistList = BL_Stepper.sharedInstance.accompanistList
                let filteredArray = dcrAccompanistList.filter{
                    $0.Acc_User_Code == accUserCode && $0.Is_Only_For_Doctor == "0" && ($0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status)
                }
                
                if (filteredArray.count > 0)
                {
                    canAddDoctor = false
                }
            }
        }
        
        return canAddDoctor
    }
    
    func showInhertianceNewDoctorAddErrorMsg()
    {
        AlertView.showAlertView(title: errorTitle, message: Display_Messages.DCR_Inheritance_Messages.ADD_DOCTOR_RESTRICTION_MESSAGE)
    }
    
    func isLeafUser(userCode: String, regionCode: String) -> Bool
    {
        var isLeafUser: Bool = false
        let accompanistList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        
        if (accompanistList != nil)
        {
            let filteredArray = accompanistList.filter{
                $0.User_Code == userCode && $0.Child_User_Count == 0
            }
            
            if (filteredArray.count > 0)
            {
                if (getDoctorCount(regionCode: regionCode) > 0)
                {
                    isLeafUser = true
                }
            }
        }
        
        return isLeafUser
    }
    
    func checkAccompanistEnteredDCRForInheritance(accompanistUserCode: String, dcrDate: String, completion: @escaping (_ apiResponseObject: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.checkAccompanistEnteredDCRForInheritance(accompanistUserCode: accompanistUserCode, dcrDate: dcrDate) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func updateAccompanistDownloadStatus(userCodes: String, dcrId: Int, status: Int)
    {
        let userCodeArray = userCodes.components(separatedBy: ",")
        
        for userCode in userCodeArray
        {
            if (userCode != EMPTY)
            {
                DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: userCode, dcrId: dcrId, status: status)
            }
        }
        
        BL_Stepper.sharedInstance.accompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()!
    }
    
    private func getDoctorCount(regionCode: String) -> Int
    {
        return DBHelper.sharedInstance.getRegionEntityCount(regionCode: regionCode, entityType: DOCTOR)
    }
    
    private func getDCRInheritanceErrorMsgs(responseList: NSArray) -> String
    {
        var errorMsgs: String = EMPTY
        
        if (responseList.count > 0)
        {
            var predicate = NSPredicate(format: "Error_Type = %@", Constants.DCR_Inheritance_API_Error_Types.LOCK)
            var filteredArray = responseList.filtered(using: predicate)
            var lockDCRMsg: String = EMPTY
            
            // Lock
            if (filteredArray.count > 0)
            {
                for obj in filteredArray
                {
                    let dict = obj as! NSDictionary
                    
                    if (lockDCRMsg != EMPTY)
                    {
                        lockDCRMsg += "\n"
                    }
                    
                    lockDCRMsg += "\( dict.value(forKey: "Employee_Name") as! String)'s DVR is in lock status"
                    
                    updateAccompanistDownloadStatus(userCodes: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status)
                    //DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
                }
            }
            
            if (lockDCRMsg != EMPTY)
            {
                errorMsgs = lockDCRMsg
            }
            
            // DCR not entered
            filteredArray.removeAll()
            predicate = NSPredicate(format: "Error_Type = %@", Constants.DCR_Inheritance_API_Error_Types.NO_DCR)
            filteredArray = responseList.filtered(using: predicate)
            var noDCRMsg: String = EMPTY
            
            if (filteredArray.count > 0)
            {
                for obj in filteredArray
                {
                    let dict = obj as! NSDictionary
                    
                    if (noDCRMsg != EMPTY)
                    {
                        noDCRMsg += "\n"
                    }
                    
                    noDCRMsg += "\(dict.value(forKey: "Employee_Name") as! String) has not entered DVR"
                    
                    updateAccompanistDownloadStatus(userCodes: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
                    //DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
                }
            }
            
            if (noDCRMsg != EMPTY)
            {
                if (errorMsgs != EMPTY)
                {
                    errorMsgs += "\n"
                }
                
                errorMsgs += noDCRMsg
            }
            
            // DCR entered but not in approved status
            filteredArray.removeAll()
            predicate = NSPredicate(format: "Error_Type = %@", Constants.DCR_Inheritance_API_Error_Types.NO_APPROVED_DCR)
            filteredArray = responseList.filtered(using: predicate)
            var noApprovedDCRMsg: String = EMPTY
            
            if (filteredArray.count > 0)
            {
                for obj in filteredArray
                {
                    let dict = obj as! NSDictionary
                    
                    if (noApprovedDCRMsg != EMPTY)
                    {
                        noApprovedDCRMsg += "\n"
                    }
                    
                    noApprovedDCRMsg += "\(dict.value(forKey: "Employee_Name") as! String)'s DVR is not in approved status"
                    
                    updateAccompanistDownloadStatus(userCodes: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
                    //DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: dict.value(forKey: "Acc_User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error)
                }
            }
            
            if (noApprovedDCRMsg != EMPTY)
            {
                if (errorMsgs != EMPTY)
                {
                    errorMsgs += "\n"
                }
                
                errorMsgs += noApprovedDCRMsg
            }
        }
        
        return errorMsgs
    }
    
    private func getSuccessMsgs(successUserList: NSArray, doctorList: NSArray) -> String
    {
        var successMsg: String = EMPTY
        
        if (successUserList.count > 0)
        {
            for obj in successUserList
            {
                let dict = obj as! NSDictionary
                
                let predicate = NSPredicate(format: "User_Code = %@", dict.value(forKey: "User_Code") as! String)
                let filteredDV = doctorList.filtered(using: predicate)
                
                updateAccompanistDownloadStatus(userCodes: dict.value(forKey: "User_Code") as! String, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success)
                
                if(filteredDV.count > 0)
                {
                    if (successMsg != EMPTY)
                    {
                        successMsg += "\n"
                    }
                    
                    successMsg += "\(dict.value(forKey: "Employee_Name") as! String)'s DVR is downloaded"
                }
            }
        }
        
        return successMsg
    }
    
    private func insertDCRDoctorInheritance(responseList: NSArray, viewController: UIViewController)
    {
        if (responseList.count > 0)
        {
            var doctorVisitList: [DCRDoctorVisitModel] = []
            let alreadyEnteredDoctors: [DCRDoctorVisitModel] = BL_Stepper.sharedInstance.doctorList
            
            for obj in responseList
            {
                let dict = obj as! NSDictionary
                let doctorCode: String = checkNullAndNilValueForString(stringData:  dict.value(forKey: "Doctor_Code") as? String)
                let doctorRegionCode: String = checkNullAndNilValueForString(stringData:  dict.value(forKey: "Doctor_Region_Code") as? String)
                let filteredArray = doctorVisitList.filter{
                    $0.Doctor_Code! == doctorCode && $0.Doctor_Region_Code == doctorRegionCode
                }
                
                if (filteredArray.count == 0) // Check for same doctor not entered by two user
                {
                    var doctorVisitId: Int!
                    let doctorVisitFilteredArray = alreadyEnteredDoctors.filter{
                        $0.Doctor_Code == doctorCode && $0.Doctor_Region_Code == doctorRegionCode
                    }
                    
                    if (doctorVisitFilteredArray.count == 0) // Check the same doctor is not entered in this DCR
                    {
                        let doctorVisitDict: NSDictionary = ["DCR_Id": String(self.getDCRId()), "DCR_Actual_Date": DCRModel.sharedInstance.dcrDateString, "Doctor_Code": doctorCode, "Doctor_Region_Code": doctorRegionCode, "Doctor_Name": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Doctor_Name") as? String), "Speciality_Name": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Speciality_Name") as? String), "MDL_Number": checkNullAndNilValueForString(stringData:  dict.value(forKey: "MDL_Number") as? String), "Category_Code": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Category_Code") as? String), "Category_Name": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Category_Name") as? String), "Visit_Mode": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Visit_Mode") as? String), "Visit_Time": checkNullAndNilValueForString(stringData:  dict.value(forKey: "Doctor_Visit_Time") as? String), "Is_Acc_Doctor": 1, "Lattitude": getLatitude(), "Longitude": getLongitude(), "Doctor_Region_Name": checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String), "Local_Area":  checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String), "Sur_Name":  checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String), "Is_DCR_Inherited_Doctor": 1]
                        
                        let doctorVisitObj: DCRDoctorVisitModel = DCRDoctorVisitModel(dict: doctorVisitDict)
                        doctorVisitId = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorVisitObj)
                        DCRModel.sharedInstance.doctorVisitId = doctorVisitId
                        
                        doctorVisitList.append(doctorVisitObj)
                        
                        //                        self.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Doctor_Modified, pobAmount: 0, viewController: viewController)
                    }
                    else
                    {
                        doctorVisitId = doctorVisitFilteredArray.first!.DCR_Doctor_Visit_Id
                    }
                    
                    DCRModel.sharedInstance.doctorVisitId = doctorVisitId
                    
                    self.insertDCRDoctorAccompanist(responseList: responseList, doctorVisitId: doctorVisitId, doctorCode: doctorCode, doctorRegionCode: doctorRegionCode)
                }
            }
        }
    }
    
    private func insertDCRDoctorAccompanist(responseList: NSArray, doctorVisitId: Int, doctorCode: String, doctorRegionCode: String)
    {
        let doctorAccompanistList = BL_DCR_Doctor_Accompanists.sharedInstance.convertToDCRDoctorAccompanistsModel(dcrAccompanistList: BL_Stepper.sharedInstance.accompanistList)
        
        for objDocAcc in doctorAccompanistList
        {
            let filteredArray = BL_Stepper.sharedInstance.accompanistList.filter{
                $0.Acc_User_Code == objDocAcc.Acc_User_Code && ($0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status)
            }
            let isLeaf: Bool = isLeafUser(userCode: objDocAcc.Acc_User_Code!, regionCode: objDocAcc.Acc_Region_Code)
            
            if (filteredArray.count > 0 || isLeaf)
            {
                objDocAcc.Is_Only_For_Doctor = "1"
                objDocAcc.Is_Accompanied = "0"
            }
        }
        
        let predicate = NSPredicate(format: "Doctor_Code = %@ AND Doctor_Region_Code = %@", doctorCode, doctorRegionCode)
        let filteredDV = responseList.filtered(using: predicate)
        let accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        
        for obj in filteredDV
        {
            let dictDV = obj as! NSDictionary
            let userCode = checkNullAndNilValueForString(stringData:  dictDV.value(forKey: "User_Code") as? String)
            let filteredAcc = accompanistMasterList.filter{
                $0.User_Code == userCode
            }
            
            if (filteredAcc.count > 0)
            {
                let filteredDocAcc = doctorAccompanistList.filter{
                    $0.Acc_User_Code == userCode
                }
                
                if (filteredDocAcc.count > 0)
                {
                    filteredDocAcc.first!.Is_Only_For_Doctor = "0"
                    filteredDocAcc.first!.Is_Accompanied = "1"
                }
                
                DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanist: doctorAccompanistList)
                
                updateAccompanistDownloadStatus(userCodes: userCode, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success)
                //DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: userCode, dcrId: getDCRId(), status: Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success)
            }
        }
    }
}


