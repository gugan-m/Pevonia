//
//  BL_Common_Stepper.swift
//  HiDoctorApp
//
//  Created by Vijay on 22/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Common_Stepper: NSObject
{
    static let sharedInstance = BL_Common_Stepper()
    
    var stepperDataList: [DCRStepperModel] = []
    var stepperIndex: DoctorVisitStepperIndex = DoctorVisitStepperIndex()
    var chemistVisitList : [ChemistDayVisit] = []
    var stockistVisitList : [DCRStockistVisitModel] = []
    var accompanistList: [DCRChemistAccompanist] = []
    var sampleList : [SampleBatchProductModel] = []
    var detailProductList : [DetailProductMaster] = []
    var assetList : [AssetsModel] = []
    var followUpList : [DCRChemistFollowup] = []
    var attachmentList : [DCRChemistAttachment] = []
    var pobDataList : [DCRDoctorVisitPOBHeaderModel] = []
    var rcpaDataList : [DCRChemistRCPAOwn] = []
    var getAccompanistIndex : Int = 0
    var dynmicOrderData:[String] = []
    var dynamicArrayValue : Int = 0
    var showAddButton : Int = 0 //for show add button
    var showSkipButton : [Bool] = [] // for show button
    var skipFromController = [Bool](repeating: false, count: 8)
    var isModify : Bool = false
    
    
    private func clearAllArray()
    {
        chemistVisitList = []
        accompanistList = []
        sampleList = []
        detailProductList = []
        assetList = []
        followUpList = []
        attachmentList = []
        showSkipButton = []
        stepperDataList = []
    }
    
    func generateDataArray()
    {
        if(dynamicArrayValue == 0)
        {
            clearAllArray()
            
            updateStepperIndex(isUpdate: false)
            
        }
        
        if(dynmicOrderData.count > dynamicArrayValue)
        {
            if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.visit)
            {
                self.getVisitData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.accompanist)
            {
                self.getAccompanistData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.samples)
            {
                self.getSampleProductData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.detailing)
            {
                self.getDetailProductData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == "getAssetData")
            {
                self.getAssetData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == "getChemistData")
            {
                
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
                self.getRCPAData()
            }
            else if(dynmicOrderData[dynamicArrayValue] == Constants.ChemistDayCaptureValue.pob)
            {
                self.getPOBData()
            }
            
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
                else if(dynmicOrderData[j] == "getAssetData")
                {
                    stepperIndex.assetIndex = j
                }
                else if(dynmicOrderData[j] == "getChemistData")
                {
                    stepperIndex.chemistIndex = j
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
                    stepperIndex.rcpaDetailIndex = j
                }
                else if(dynmicOrderData[j] == Constants.ChemistDayCaptureValue.pob)
                {
                    stepperIndex.pobIndex = j
                }
                
            }
        }
    }
    
    private func determineButtonStatus()
    {
        if chemistVisitList.count == 0
        {
            stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateAddButton = true
            stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateSkipButton = false
            
            if getChemistVisitMode() != PrivilegeValues.VISIT_TIME_MANDATORY.rawValue
            {
                stepperDataList[stepperIndex.doctorVisitIndex].showEmptyStateSkipButton = true
            }
        }
        else
        {
            
            if(showAddButton < dynmicOrderData.count)
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
    }
    
    private func getVisitData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(appChemist) Visit Details"
        stepperObjModel.emptyStateTitle = "\(appChemist) Visit Details"
        stepperObjModel.emptyStateSubTitle = "Update details of \(appChemist) visits(i.e. time, etc..)"
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        
        if ChemistDay.sharedInstance.customerCode == ""
        {
            if ChemistDay.sharedInstance.chemistVisitId != nil
            {
                let chemistVisitList = getDCRChemistVisitFlexiChemist(chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
                if chemistVisitList != nil
                {
                    self.chemistVisitList = chemistVisitList!
                    stepperObjModel.recordCount = chemistVisitList!.count
                }
                
            }
        }
        else
        {
            let chemistVisitList = getDCRChemistVisitList()
            if chemistVisitList != nil
            {
                self.chemistVisitList = chemistVisitList!
                stepperObjModel.recordCount = chemistVisitList!.count
            }
        }
        
        showSkipButton.append(true)
        
        if(self.chemistVisitList.count != 0)
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
        
        if (chemistVisitList.count > 0 && stepperIndex.accompanistIndex != 0 )
        {
            let accompanistList = getChemistAccompanist(chemistVisitId: ChemistDay.sharedInstance.chemistVisitId, dcrId: DCRModel.sharedInstance.dcrId)
            if accompanistList != nil
            {
                self.accompanistList = accompanistList!
                stepperObjModel.recordCount = accompanistList!.count
            }
        }
        
        showSkipButton.append(true)
        
        if(self.chemistVisitList.count != 0)
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
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD SAMPLE"
        
        if chemistVisitList.count > 0
        {
         
                let sampleProductList = getSampleProducts()
                let sampleBatchProductList = getSampleBatchProducts()
                if sampleProductList != nil
                {
                    var sampleDataList : [SampleBatchProductModel] = []
                    for sampleObj in sampleProductList!
                    {
                        var sampleModelList:[DCRChemistSamplePromotion] = []
                        let sampleBatchObj = SampleBatchProductModel()
                        sampleBatchObj.title = sampleObj.ProductName
                        
                        let filterValue = sampleBatchProductList.filter{
                            $0.Ref_Id == sampleObj.DCRChemistSampleId
                        }
                        if(filterValue.count > 0)
                        {
                            for obj in filterValue
                            {
                                let dict = ["DCR_Chemist_Day_Visit_Id":0,"DCR_Id":sampleObj.DCRId,"DCR_Code":sampleObj.DCRCode,"Chemist_Visit_Id":sampleObj.ChemistVisitId,"CV_Visit_Id":0,"Product_Code":sampleObj.ProductCode,"Product_Name":sampleObj.ProductName,"Quantity_Provided":obj.Quantity_Provided] as [String : Any]
                                let sampleChemist = DCRChemistSamplePromotion(dict: dict as NSDictionary)
                                sampleChemist.BatchName = obj.Batch_Number
                                sampleModelList.append(sampleChemist)
                            }
                            sampleBatchObj.title = sampleObj.ProductName
                            sampleBatchObj.isShowSection = true
                            sampleBatchObj.chemistSamplePromotion = sampleModelList
                            sampleDataList.append(sampleBatchObj)
                        }
                    }
                    if((sampleProductList?.count)! > 0)
                    {
                        let sampleBatchObj = SampleBatchProductModel()
                        var sampleModelList:[DCRChemistSamplePromotion] = []
                        sampleBatchObj.title = ""
                        sampleBatchObj.isShowSection = false
                        for sampleObj in sampleProductList!
                        {
                            
                            let filterValue = sampleBatchProductList.filter{
                                $0.Ref_Id == sampleObj.DCRChemistSampleId
                            }
                            if(filterValue.count == 0)
                            {
                                sampleModelList.append(sampleObj)
                            }
                            
                        }
                        if(sampleModelList.count > 0)
                        {
                            sampleBatchObj.chemistSamplePromotion = sampleModelList
                            sampleDataList.append(sampleBatchObj)
                        }
                    }
                    self.sampleList = sampleDataList
                    stepperObjModel.recordCount = sampleDataList.count
                }
            
        }
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
        stepperObjModel.emptyStateSubTitle = "Update the detailed products information here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD PRODUCTS"
        
        if chemistVisitList.count > 0
        {
            
            let detailedProductList = getDetailedProducts()
            if detailedProductList != nil
            {
                self.detailProductList = detailedProductList!
                stepperObjModel.recordCount = detailedProductList!.count
            }
        }
        
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
            
            stepperObjModel.sectionTitle = PEV_DIGITAL_ASSETS
            stepperObjModel.emptyStateTitle = PEV_DIGITAL_ASSETS
            stepperObjModel.emptyStateSubTitle = "Update the details of the \(PEV_DIGITAL_ASSETS)"
            stepperObjModel.sectionIconName = "icon-stepper-two-user"
            stepperObjModel.isExpanded = false
            stepperObjModel.leftButtonTitle = ""
            
            if self.chemistVisitList.count > 0
            {
                let assetListing = getDCRDoctorAssetDetails()
                if assetListing.count > 0
                {
                    self.assetList = assetListing
                    stepperObjModel.recordCount = assetListing.count
                }
            }
            showSkipButton.append(true)
            
            if(self.assetList.count != 0)
            {
                showAddButton += 1
            }
            
            stepperDataList.append(stepperObjModel)
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
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD FOLLOW-UPS"
        
        if chemistVisitList.count > 0
        {
            
            let followUpList = getFollowUpDetails()
            if followUpList.count > 0
            {
                self.followUpList = followUpList
                stepperObjModel.recordCount = followUpList.count
            }
        }
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
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD ATTACHMENT"
        
        if chemistVisitList.count > 0
        {
            let attachmentList = getDCRChemistAttachmentDetails()
            if attachmentList != nil
            {
                self.attachmentList = attachmentList!
                stepperObjModel.recordCount = attachmentList!.count
            }
        }
        
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
    
    func getRCPAData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "RCPA"
        stepperObjModel.emptyStateTitle = "RCPA"
        stepperObjModel.emptyStateSubTitle = "Update Competitor product details here"
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD RCPA"
        
        if chemistVisitList.count > 0
        {
            let rcpaList = getDCRChemistRCPADetails()
            if rcpaList != nil
            {
                self.rcpaDataList = rcpaList!
                stepperObjModel.recordCount = rcpaList!.count
            }
        }
        
        showSkipButton.append(true)
    
        if(skipFromController[stepperIndex.rcpaDetailIndex])
        {
            showAddButton += 1
            stepperObjModel.showEmptyStateAddButton = true
            stepperObjModel.showEmptyStateSkipButton = true
            
        }
        else if(self.rcpaDataList.count != 0)
        {
            showAddButton += 1
        }
        
        stepperDataList.append(stepperObjModel)
        
        enableAddShowButton(index: stepperIndex.rcpaDetailIndex)

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
        
        if chemistVisitList.count > 0
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
    
    func enableAddShowButton(index:Int) //update add skip button for previous index
    {
        
        let indexValue = index-1
        
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
//        for i in (0 ... indexValue).reversed()
//        {
//
//            if(stepperIndex.detailedProduct == i)
//            {
//                stepperDataList[i].showEmptyStateAddButton = true
//
//                if getDetailedProductMandatoryNumber() == 0
//                {
//                    stepperDataList[i].showEmptyStateSkipButton = true
//                }
//                else
//                {
//                    stepperDataList[i].showEmptyStateSkipButton = false
//                }
//            }
//            else if(stepperIndex.sampleIndex == i)
//            {
//                stepperDataList[i].showEmptyStateAddButton = true
//
//                if getInputMandatoryNumber() == 0
//                {
//                    stepperDataList[i].showEmptyStateSkipButton = true
//                }
//                else
//                {
//                    stepperDataList[i].showEmptyStateSkipButton = false
//                }
//
//            }
//            else
//            {
//                stepperDataList[i].showEmptyStateAddButton = true
//                stepperDataList[i].showEmptyStateSkipButton = true
//            }
//        }

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
    
    //privilege
    func showAssetCard() -> Bool
    {
        var flag : Bool = false
        
        if (geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased() && getDCRDoctorAssetDetails().count > 0)
        {
            flag = true
        }
        
        return flag
    }
    
    func geteDetailingConfigVal() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.IS_EDetailing_Enabled)
    }
    
    func getChemistDayCaptureValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CHEMIST_VISITS_CAPTURE_CONTROLS).uppercased()
    }
    
    func getChemistVisitMode() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_CHEMIST_VISIT_MODE).uppercased()
    }
    
    func getChemistVisitTimeEntryMode() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_DOCTOR_VISIT_TIME_ENTRY_MODE).uppercased()
    }
    
    func getDcrStockistVisitTimeEntryMode() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_STOCKIEST_VISIT_TIME).uppercased()
    }
    
    private func getInputMandatoryNumber() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_CHEMIST_INPUT_MANDATORY_NUMBER)
        var minimumInputCount: Int = 0
        
        if (privilegeValue != "")
        {
            minimumInputCount = Int(privilegeValue)!
        }
        
        return minimumInputCount
    }
    
    private func getDetailedProductMandatoryNumber() -> Int
    {
        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_CHEMIST_DETAILING_MANDATORY_NUMBER)
        var minimumDetailingCount: Int = 0
        
        if (privilegeValue != "")
        {
            minimumDetailingCount = Int(privilegeValue)!
        }
        
        return minimumDetailingCount
    }
    
    func doChemistVisitAllValidations(chemistVisitObj: ChemistDayVisit) -> String
    {
        var errorMessage: String = EMPTY
        let priviledge = self.getChemistDayCaptureValue()
        let privArray = priviledge.components(separatedBy: ",")
        
        if (getChemistVisitMode() == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue)
        {
            if (checkNullAndNilValueForString(stringData: chemistVisitObj.VisitTime) == EMPTY)
            {
                return  " Visit time is missing for the \(appChemist) \(chemistVisitObj.ChemistName!)"
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.samples)
        {
            if (!getInputMandatoryPrivilegeValidation(dcrChemistVisitId: chemistVisitObj.DCRChemistDayVisitId))
            {
                return "You need to enter minimum of \(String(getInputMandatoryNumber())) input(s) for the \(appChemist) \(chemistVisitObj.ChemistName!)"
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.detailing)
        {
            if (!getDetailedProductMandatoryPrivilegeValidation(dcrChemistVisitId: chemistVisitObj.DCRChemistDayVisitId))
            {
                return "You need to enter minimum of \(String(getDetailedProductMandatoryNumber())) detailing product(s) for the \(appChemist) \(chemistVisitObj.ChemistName!)"
            }
        }
        
//        if privArray.contains(Constants.ChemistDayCaptureValue.RCPA)
//        {
//            if (BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList().count > 0)
//            {
//                let rcpaCheckList = chemistRCPACheckMandatory(chemistVisitId: chemistVisitObj.DCRChemistDayVisitId)
//
//                if rcpaCheckList.count > 0
//                {
//                    for obj in rcpaCheckList
//                    {
//                        let rcpaCheck = obj[0] as! Bool
//                        let docName = obj[1] as! String
//
//                        if rcpaCheck == false
//                        {
//                            return "You need to enter minimum of 1 RCPA for the \(appDoctor) \(docName )"
//                        }
//                    }
//                }
//                else
//                {
//                    return "You need to enter minimum of 1 RCPA for the \(appDoctor) in DCR"
//                }
//            }
//        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.pob)
        {
            let poblist = chemistPOBSaleProductCheck(chemistVisitId: chemistVisitObj.DCRChemistDayVisitId)
            
            if poblist.count != 0
            {
                for obj in poblist
                {
                    let pobCheck = obj[0] as! Bool
                    let stockiestName = obj[1] as! String
                    
                    if pobCheck == false
                    {
                        return "You need to enter minimum of 1 sale product for the \(appStockiest) \(stockiestName )"
                    }
                }
            }
        }
        
        if privArray.contains(Constants.ChemistDayCaptureValue.accompanist)
        {
            if checkDCRChemistAccompanistCallStatus(dcrChemistDayVisitId: chemistVisitObj.DCRChemistDayVisitId,dcrId : chemistVisitObj.DCRId) != nil
            {
                let accObj = checkDCRChemistAccompanistCallStatus(dcrChemistDayVisitId: chemistVisitObj.DCRChemistDayVisitId,dcrId : chemistVisitObj.DCRId)
                errorMessage = accompMissedPrefixErrorMsg + (accObj?.AccUserName)! + accompMissedSuffixErrorMsg
            }
        }
        
        return errorMessage
    }
    
    func doChemistVisitAllValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        let chemistList = DBHelper.sharedInstance.getChemistDayVisitsForDCRId(dcrId: getDCRId())
        
        if (chemistList != nil)
        {
            for chemistVisitObj in chemistList!
            {
                errorMessage = doChemistVisitAllValidations(chemistVisitObj: chemistVisitObj)
                
                if (errorMessage != EMPTY)
                {
                    break
                }
            }
        }
        
        return errorMessage
    }
    
    func checkDCRChemistAccompanistCallStatus(dcrChemistDayVisitId: Int,dcrId : Int) -> DCRChemistAccompanist?
    {
        var model : DCRChemistAccompanist?
        
        let accompDataList = DBHelper.sharedInstance.getDCRChemistAccompanistsByAccompaniedStatus(dcrId : dcrId,chemistVisitId:dcrChemistDayVisitId, accompaniedStatus : 99)
        
        if (accompDataList.count > 0)
        {
            model = accompDataList.first!
        }
        
        return model
    }
    
    func getInputMandatoryPrivilegeValidation(dcrChemistVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        let minimumInputCount = getInputMandatoryNumber()
        
        if (minimumInputCount > 0)
        {
            let dcrInputCount = DBHelper.sharedInstance.getChemistSampleCount(chemistDayVisitId: dcrChemistVisitId)
            
            if (dcrInputCount < minimumInputCount)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    //TO DO
    func getPOBSaleProductMandatoryCheck(dcrChemistVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        
        let dcrInputCount = BL_POB_Stepper.sharedInstance.getPOBDetailsForDCRId(dcrId: getDCRId(), visitId: ChemistDay.sharedInstance.chemistVisitId)?.count
        
        if (dcrInputCount! == 0)
        {
            isValidationSuccess = false
        }
        
        return isValidationSuccess
    }
    
    func getDetailedProductMandatoryPrivilegeValidation(dcrChemistVisitId: Int) -> Bool
    {
        var isValidationSuccess: Bool = true
        let minimumDetailingCount = getDetailedProductMandatoryNumber()
        
        if (minimumDetailingCount > 0)
        {
            let dcrDetailingCount = DBHelper.sharedInstance.getDCRChemistSelectedDetailedProductList(dcrId: getDCRId(), chemistVisitId: dcrChemistVisitId).count
            
            if (dcrDetailingCount < minimumDetailingCount)
            {
                isValidationSuccess = false
            }
        }
        
        return isValidationSuccess
    }
    
    func doRCPAMandatoryCheck(docObj: DCRDoctorVisitModel, chemistVisitId: Int) -> [Any]
    {
        var mandatoryCheckList : [Any] = []
        
        if (docObj.Category_Name != nil) && (docObj.Category_Name != "")
        {
            let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY).uppercased()
            let privArray = privilegeValue.components(separatedBy: ",")
            
            if (privArray.contains(docObj.Category_Name!.uppercased()))
            {
                let rcpaList = DBHelper.sharedInstance.getDCRChemistRCPADoctor(chemistVisitId: chemistVisitId,dcrId : getDCRId(),doctorCategoryName: docObj.Category_Name!, doctorCode: docObj.Doctor_Code!, doctorRegionCode: docObj.Doctor_Region_Code!)
                
                if (rcpaList.count == 0)
                {
                    mandatoryCheckList.append(false)
                    mandatoryCheckList.append(docObj.Doctor_Name!)
                    return mandatoryCheckList
                }
                else
                {
                    mandatoryCheckList.append(true)
                    mandatoryCheckList.append(docObj.Doctor_Name!)
                    return mandatoryCheckList
                }
            }
            else
            {
                mandatoryCheckList = []
                mandatoryCheckList.append(true)
                mandatoryCheckList.append(EMPTY)
                return mandatoryCheckList
            }
        }
        else
        {
            mandatoryCheckList = []
            mandatoryCheckList.append(true)
            mandatoryCheckList.append(EMPTY)
            return mandatoryCheckList
        }
    }
    
    func chemistRCPACheckMandatory(chemistVisitId: Int) -> [[Any]]
    {
        var validated : [[Any]] = []
        let dcrDoctorList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
        
        if dcrDoctorList.count > 0
        {
            for obj in dcrDoctorList
            {
                if obj.Category_Name != nil && obj.Category_Name != EMPTY
                {
                    validated.append(doRCPAMandatoryCheck(docObj: obj, chemistVisitId: chemistVisitId))
                }
                else
                {
                    validated.append([true,EMPTY])
                }
            }
            
            return validated
        }
        else
        {
            return validated
        }
    }
    
    func chemistListAddBtnHidden() -> Bool
    {
        var flag : Bool = false
        
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RIGID_CHEMIST_ENTRY).uppercased()
        if privValue.contains(PrivilegeValues.YES.rawValue)
        {
            flag = true
        }
        
        return flag
    }
    
    func doAllCustomerValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        if (BL_Stepper.sharedInstance.isChemistDayEnabled())
        {
            errorMessage =  self.doChemistVisitAllValidations()
            
            if (self.chemistVisitList.count > 0)
            {
                let priviledge = BL_Common_Stepper.sharedInstance.getChemistDayCaptureValue().uppercased()
                let privArray = priviledge.components(separatedBy: ",")
                
                if privArray.contains(Constants.ChemistDayCaptureValue.accompanist)
                {
                    if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_CHEMIST_VISITS) == PrivilegeValues.YES.rawValue)
                    {
                        
                        let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistListWithoutVandNA()
                        //let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
                        let doctorAccompanistList = DBHelper.sharedInstance.getChemistAccompanistForUpload(dcrId: getDCRId())
                        
                        if (dcrAccompanistList != nil) && (doctorAccompanistList.count > 0)
                        {
                            for objDCRAccompanist in dcrAccompanistList!
                            {
                                let filteredArray = doctorAccompanistList.filter{
                                    $0.AccUserCode == objDCRAccompanist.Acc_User_Code && $0.AccRegionCode == objDCRAccompanist.Acc_Region_Code
                                }
                                
                                if (filteredArray.count == 0)
                                {
                                    errorMessage = "\(accompMissedPrefixErrorMsg)" + "\(objDCRAccompanist.Employee_Name!)" + "\(accompMissedSuffixErrorMsg)"
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return errorMessage
    }
    
    func doAllCustomerValidationsForChemistObj(chemistObj: ChemistDayVisit) -> String
    {
        var errorMessage: String = EMPTY
        
        errorMessage =  self.doChemistVisitAllValidations(chemistVisitObj: chemistObj)
               return errorMessage
    }
    
    func getRCPAMandatoryDoctorCategoryPriviledgeValue() -> String
    {
        var priviledgeValue: String = ""
        
        priviledgeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY).uppercased()
        return priviledgeValue
    }
    
    func getAccompanistsValidInChemistVisitPriviledgeValue() -> String
    {
        var priviledgeValue: String = ""
        
        priviledgeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_CHEMIST_VISITS)
        return priviledgeValue
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
        
        return mandatoryCheckList
    }
    
    func chemistPOBSaleProductCheck(chemistVisitId: Int) -> [[Any]]
    {
        var validated : [[Any]] = []
        let headerList = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: getDCRId(), visitId: chemistVisitId, customerEntityType: Constants.CustomerEntityType.chemist)
        
        for obj in headerList
        {
            if obj.Order_Entry_Id != nil && obj.Order_Entry_Id != 0
            {
                validated.append(doPOBSaleProductsCheck(headerObj: obj))
            }
        }
        
        return validated
    }
    
    //save chemistVisit
    func saveChemistVisitDetails(customerCode: String?, visitTime: String?, visitMode: String?, entityType: String?, remarks: String?, regionCode: String?, viewController: UIViewController)
    {
        var chemistCode : String?
        var chemistName : String?
        var regionName : String?
        var categoryCode : String?
        var categoryName : String?
        var mdlNumber : String?
        
        if (customerCode != nil)
        {
            //let doctorObj = getCustomerMasterByCustomerId(customerId: customerId!)
            let chemistObj = getCustomerByCustomerCodeandEntityType(customerCode: customerCode!, regionCode: regionCode!, entityType: entityType!)
            
            if(chemistObj != nil)
            {
                chemistCode = chemistObj!.Customer_Code
                chemistName = chemistObj!.Customer_Name
                regionName = chemistObj!.Region_Name
                categoryCode = chemistObj!.Category_Code
                categoryName = chemistObj!.Category_Name
                mdlNumber = chemistObj!.MDL_Number
            }
        }
        
        let dcrIdString = getDCRId()
        var latitude = getLatitude()
        var longitude = getLongitude()
        
        if(latitude == EMPTY || longitude == EMPTY)
        {
            latitude = "0.0"
            longitude = "0.0"
        }
        
        var newVisitTime = visitTime
        
        if (checkNullAndNilValueForString(stringData: visitTime) != EMPTY)
        {
            newVisitTime = newVisitTime!.replacingOccurrences(of: "AM", with: "")
            newVisitTime = newVisitTime!.replacingOccurrences(of: "PM", with: "")
            newVisitTime = newVisitTime!.replacingOccurrences(of: " ", with: "")
        }
        
        let chemistDict: NSDictionary =   ["DCR_Id" : dcrIdString,"Chemist_Code" : chemistCode ?? "","Chemist_Name" : chemistName!, "Chemists_Region_Code" : regionCode ?? EMPTY, "Region_Name" : regionName,"Visit_Mode" : visitMode,"Visit_Time" : newVisitTime,"Category_Code" : categoryCode,"Category_Name" : categoryName,"Remarks" : remarks, "Chemists_Visit_latitude" : Double(latitude)!,"Chemists_Visit_Longitude" :Double(longitude)!,"Chemists_MDL_Number" : mdlNumber ?? ""]
        
        let chemistVisitObj: ChemistDayVisit = ChemistDayVisit(dict: chemistDict)
        let chemistVisitId = DBHelper.sharedInstance.insertDCRChemistVisit(dcrChemistVisitObj: chemistVisitObj)
        
        ChemistDay.sharedInstance.chemistVisitId = chemistVisitId
        DCRModel.sharedInstance.customerVisitId = chemistVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
    }
    
    func saveFlexiChemistVisitDetails(chemistName : String, specialityName : String, visitTime: String?, visitMode: String?, remarks: String?, regionCode : String?, viewController: UIViewController)
    {
        let dcrIdString = getDCRId()
        var latitude = getLatitude()
        var longitude = getLongitude()
        
        if(latitude == EMPTY || longitude == EMPTY)
        {
            latitude = "0.0"
            longitude = "0.0"
        }
        
        var newVisitTime = visitTime
        
        if (checkNullAndNilValueForString(stringData: visitTime) != EMPTY)
        {
            newVisitTime = newVisitTime!.replacingOccurrences(of: "AM", with: "")
            newVisitTime = newVisitTime!.replacingOccurrences(of: "PM", with: "")
            newVisitTime = newVisitTime!.replacingOccurrences(of: " ", with: "")
        }
        
        let chemistDict: NSDictionary =   ["DCR_Id" : dcrIdString,"Chemist_Code" : "","Chemist_Name" : chemistName, "Chemists_Region_Code" : regionCode!, "Region_Name" :getRegionName(),"Visit_Mode" : visitMode!,"Visit_Time" : newVisitTime!,"Category_Code" : "","Category_Name" : "","Remarks" : remarks ?? "", "Chemists_Visit_Longitude" : Double(longitude)!,"Chemists_Visit_latitude" : Double(latitude)!,"Chemists_MDL_Number" : ""]
        
        let chemistVisitObj: ChemistDayVisit = ChemistDayVisit(dict: chemistDict)
        let chemistVisitId = DBHelper.sharedInstance.insertDCRChemistVisit(dcrChemistVisitObj: chemistVisitObj)
        
        ChemistDay.sharedInstance.chemistVisitId = chemistVisitId
        DCRModel.sharedInstance.customerVisitId = chemistVisitId
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
    }
    
    func getCustomerByCustomerCodeandEntityType(customerCode: String, regionCode: String,entityType : String) -> CustomerMasterModel?
    {
        return DBHelper.sharedInstance.getCustomerByCustomerCodeandEntityType(customerCode: customerCode, regionCode: regionCode, entityType: entityType)
    }
    
    func updateAccompanistCall(index: Int, selectedIndex: Int)
    {
        let model = accompanistList[index]
        var accompStatus:Int!
        if selectedIndex == 0
        {
            accompStatus = 1
        }
        else if selectedIndex == 1
        {
            accompStatus = 0
        }
        else
        {
            accompStatus = 99
        }
        model.IsAccompaniedCall = accompStatus
        DBHelper.sharedInstance.updateDCRChemistAccompanist(dcrDoctorAccompanistObj: model)
    }
    func getDCRChemistVisitList() -> [ChemistDayVisit]?
    {
        return DBHelper.sharedInstance.getChemistVisitforChemistId(dcrId: getDCRId(), customerCode: getCustomerCode(), regionCode: getCustomerRegionCode())
    }
    
    func getDCRChemistVisitFlexiChemist(chemistVisitId : Int) -> [ChemistDayVisit]?
    {
        return DBHelper.sharedInstance.getChemistVisitDetailFlexiChemist(dcrId: getDCRId(), chemistVisitId: chemistVisitId)
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getCustomerEntityType() -> String
    {
        return Constants.CustomerEntityType.chemist
    }
    
    private func getCustomerCode() -> String
    {
        return ChemistDay.sharedInstance.customerCode
    }
    
    private func getCustomerRegionCode() -> String
    {
        return ChemistDay.sharedInstance.regionCode
    }
    
    func getChemistAccompanist(chemistVisitId: Int, dcrId: Int) -> [DCRChemistAccompanist]?
    {
        return BL_DCR_Chemist_Accompanists.sharedInstance.getDCRChemistAccompanists(chemistVisitId: chemistVisitId, dcrId: dcrId)
    }
    
    func getSampleProducts() -> [DCRChemistSamplePromotion]?
    {
        return BL_Common_Stepper.sharedInstance.getSampleDCRProducts(dcrId: getDCRId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
    }
    func getSampleBatchProducts() -> [DCRSampleBatchModel]
    {
        return BL_SampleProducts.sharedInstance.getSampleBatchDCRProducts(dcrId: getDCRId(), visitId: ChemistDay.sharedInstance.chemistVisitId, entityType: sampleBatchEntity.Chemist.rawValue)
    }
    func getSampleDCRProducts(dcrId: Int, chemistVisitId: Int) -> [DCRChemistSamplePromotion]?
    {
        return DBHelper.sharedInstance.getDCRChemistSampleProducts(dcrId: dcrId, chemistVisitId: chemistVisitId)
    }
    
    func updateDCRchemistVisit(dcrChemistVisitObj: ChemistDayVisit, viewController: UIViewController)
    {
        DBHelper.sharedInstance.updateDCRChemistVisit(dcrChemistVisitObj: dcrChemistVisitObj)
    }
    
    func getFollowUpDetails() -> [DCRChemistFollowup]
    {
        return BL_DCR_Follow_Up.sharedInstance.getChemistFollowUpDetails()
    }
    
    func getDetailedProducts() -> [DetailProductMaster]?
    {
        return BL_DetailedProducts.sharedInstance.getChemistDetailedProducts()
    }
    
    func getDCRChemistAttachmentDetails() -> [DCRChemistAttachment]?
    {
        return Bl_Attachment.sharedInstance.getDCRChemistAttachment(dcrId: getDCRId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId )
    }
    func getPobDetails() -> [DCRDoctorVisitPOBHeaderModel]?
    {
        return BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: getDCRId() , visitId: ChemistDay.sharedInstance.chemistVisitId,customerEntityType:getCustomerEntityType())
    }
    func getDCRChemistRCPADetails() -> [DCRChemistRCPAOwn]?
    {
        return BL_DCR_Chemist_Visit.sharedInstance.getRCPAEnteredDoctorsList()
    }
    
    func getDCRChemistRCPADetailsForReport() -> [DCRChemistRCPAOwn]?
    {
        return DBHelper.sharedInstance.getRCPADetailedProductForReport(dcrId: getDCRId(),chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
    }
    
    
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
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
        let remarks = chemistVisitList[0].Remarks
        let remarksLblheight : CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        let cellHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight
        return cellHeight
    }
    
    func getDoctorVisitDetailHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
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
        let remarks = chemistVisitList[0].Remarks
        let remarksLblheight : CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        childTableHeight = topSpace + bottomSpace + visitModeHeight + line1VerticalSpacing + visitModeLblHeight + verticalSpacingBtnlines + remarksHeight + line1VerticalSpacing + remarksLblheight
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == false)
        {
            totalHeight = totalHeight - remarksHeight - line1VerticalSpacing - remarksLblheight
        }
        
        return totalHeight
    }
    
    func getAccompanistSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 10
        let bottomSpace : CGFloat = 10
        var accompNameHeight : CGFloat = 0
        let defaultCellHeight : CGFloat = 40.0
        
        let accompanistName = accompanistList[selectedIndex].EmployeeName
        accompNameHeight = getTextSize(text: accompanistName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        return topSpace + defaultCellHeight + accompNameHeight + bottomSpace
    }
    
    func getAccompanistCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
    
    func getDoctorVisitSampleHeight(selectedIndex : Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
        let sampleBatchList = sampleList
        
        let topSpace : CGFloat = 20
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var childTableHeight: CGFloat = 0
        
        for sampleBatchobj in sampleBatchList
        {
            for obj in sampleBatchobj.chemistSamplePromotion
            {
                let sampleObj = obj
                let line1Height = getTextSize(text: sampleObj.ProductName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
                let quantityText = String(format: "%d", (sampleObj.QuantityProvided)!)
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
        let sampleObj = sampleList[section].chemistSamplePromotion[0]
        let line1Height = getTextSize(text: sampleObj.ProductName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        let quantityText = String(format: "%d", (sampleObj.QuantityProvided)!)
        let line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        
        return  line1Height + line2Height + 35
    }
    
    func getDoctorVisitSampleSingleHeight(selectedIndex : Int, parentIndex : Int) -> CGFloat
    {
        let topSpace: CGFloat = 0
        let verticalSpacing : CGFloat = 10
        let bottomSpace: CGFloat = 15
        var line1Height : CGFloat = 0
        var line2Height : CGFloat = 0
        
//        if parentIndex == stepperIndex.sampleIndex
//        {
//            let productName = sampleList[selectedIndex].ProductName
//            line1Height = getTextSize(text: productName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//            let quantityText = String(format: "%d", sampleList[selectedIndex].QuantityProvided)
//            line2Height = getTextSize(text: quantityText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
//        }
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
        
        //        if parentIndex == stepperIndex.chemistIndex
        //        {
        //            let chemistName = chemistVisitList[selectedIndex].Chemist_Name
        //            line1Height = getTextSize(text: chemistName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        //            var pobAmount : Float = 0
        //            if chemistVisitList[selectedIndex].POB_Amount != nil
        //            {
        //                pobAmount = chemistVisitList[selectedIndex].POB_Amount!
        //            }
        //            let subTitleText = String(format: "POB: %.2f |", pobAmount)
        //            line2Height = getTextSize(text: subTitleText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        //        }
        //
        if parentIndex == stepperIndex.followUpIndex
        {
            let followUpText = followUpList[selectedIndex].Task
            line1Height = getTextSize(text: followUpText, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            let dateString = convertDateIntoString(date: followUpList[selectedIndex].DueDate)
            line2Height = getTextSize(text: dateString, fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
        }
        
        if(parentIndex == stepperIndex.rcpaDetailIndex)
        {
            let RCPADoctorName = rcpaDataList[selectedIndex].DoctorName
            line1Height = getTextSize(text: RCPADoctorName, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            
            let RCPADoctorMDL = rcpaDataList[selectedIndex].DoctorMDLNumber
            line2Height = getTextSize(text: "MDL Number: \(RCPADoctorMDL!)", fontName: fontRegular, fontSize: 13.0, constrainedWidth: SCREEN_WIDTH - 104.0).height
            
            
        }
        
        return topSpace + verticalSpacing + bottomSpace + line1Height + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
    
    func getCommonSingleCellHeight(selectedIndex: Int, parentIndex : Int) -> CGFloat
    {
        let topSpace: CGFloat = 0
        let bottomSpace: CGFloat = 10
        var line1Height: CGFloat = 0
        
        if parentIndex == stepperIndex.detailedProduct
        {
            let detailedProductname = detailProductList[selectedIndex].Product_Name
            line1Height = getTextSize(text: detailedProductname, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height + 10
        }
        else if parentIndex == stepperIndex.attachmentIndex
        {
            let attachmentName = attachmentList[selectedIndex].UploadedFileName
            line1Height = getTextSize(text: attachmentName, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 104.0).height + 10
        }
        
        return topSpace + line1Height + bottomSpace
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
    func convertChemistSampleToDCRSample(list : [DCRChemistSamplePromotion]) -> [DCRSampleModel]
    {
        var sampleObjList : [SampleProductsModel] = []
        var sampleProductList : [DCRSampleModel] = []
        for obj in list
        {
            let sampleObj : SampleProductsModel = SampleProductsModel()
            sampleObj.Product_Name = obj.ProductName
            sampleObj.Product_Code = obj.ProductCode
            sampleObj.Quantity_Provided = obj.QuantityProvided
            sampleObj.Current_Stock = obj.CurrentStock
            sampleObj.DCR_Sample_Id = obj.DCRChemistSampleId
            sampleObj.DCR_Id = obj.DCRId
            sampleObj.DCR_Code = obj.DCRCode
            sampleObj.DCR_Doctor_Visit_Code = obj.ChemistVisitCode
            sampleObj.DCR_Doctor_Visit_Id = obj.DCRChemistDayVisitId
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        return sampleProductList
        
    }
    
    
    
    //MARK:- RCPA related Functions
    
    func getDoctorsList() -> [DCRDoctorVisitModel]
    {
        return BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
    }
    
    func getDCRAccompanists() -> [DCRAccompanistModel]
    {
        return BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()!
    }
    
    //MARK:- Delete chemistvisit
    
    func deleteChemistVisitDetailsForChemistDayVisitId(dcrId: Int, chemistVisitId: Int)
    {
        BL_SampleProducts.sharedInstance.addInwardQty(dcrId: getDCRId(), chemistVisitId: chemistVisitId)
        
        BL_SampleProducts.sharedInstance.addBatchInwardQty(dcrId: getDCRId(), doctorVisitId: chemistVisitId, entityType: sampleBatchEntity.Chemist.rawValue)
        
        let getAttachments = Bl_Attachment.sharedInstance.getDCRChemistAttachment(dcrId: getDCRId(), chemistVisitId: chemistVisitId)
        
        if (getAttachments != nil)
        {
            if (getAttachments!.count > 0)
            {
                for model in getAttachments!
                {
                    Bl_Attachment.sharedInstance.deleteAttachmentFile(fileName: model.UploadedFileName)
                }
            }
        }
        
        DBHelper.sharedInstance.deleteChemistDayAttachments(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deletePOBForChemist(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDayFollowups(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDayRCPACompetitor(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDayRCPAOwn(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDayDetailedProducts(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDaySamplePromotion(chemistVisitId: chemistVisitId,dcrId: dcrId)
        DBHelper.sharedInstance.deleteChemistDayAccompanist(dcrId: dcrId,chemistVisitId: chemistVisitId)
        DBHelper.sharedInstance.deleteChemistDayVisit(chemistVisitId: chemistVisitId,dcrId: dcrId)
    }
    
    func clearAllValues()
    {
        clearAllArray()
        stepperIndex = DoctorVisitStepperIndex()
        attachmentList = []
        pobDataList = []
        rcpaDataList = []
        getAccompanistIndex = 0
        dynmicOrderData = []
        dynamicArrayValue  = 0
        showAddButton  = 0
        isModify = false
    }
    
}
