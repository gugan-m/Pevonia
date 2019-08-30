//
//  BL_Stepper.swift
//  HiDoctorApp
//
//  Created by SwaaS on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_Stepper: NSObject
{
    //MARK:- Global Variables
    static let sharedInstance = BL_Stepper()
    
    //MARK:- Private Variables
    var stepperDataList: [DCRStepperModel] = []
    var accompanistList: [DCRAccompanistModel] = []
    var workPlaceList: [StepperWorkPlaceModel] = []
    var sfcList: [DCRTravelledPlacesModel] = []
    var doctorList: [DCRDoctorVisitModel] = []
    var stockistList: [DCRStockistVisitModel] = []
    var expenseList: [DCRExpenseModel] = []
    var dcrId: Int!
    var dcrStatus: Int!
    var accompanistDataPendingList: [DCRAccompanistModel] = []
    var dcrHeaderObj: DCRHeaderModel?
    var isDataInsertedFromTP: Bool = false
    var isSFCUpdated: Bool = false
    var isChemistDay: Bool = false
    var chemistDayHeaderList: [ChemistDayVisit] = []
    var isTPFreeseDay: Bool = false
    
    //MARK:- Public Functions
    func getAccompanistDataPendingList()
    {
        accompanistDataPendingList = []
        
        let dcrAccompanists = DBHelper.sharedInstance.getListOfDCRAccompanist(dcrId: DCRModel.sharedInstance.dcrId)
        let userMasterAccompanist = DBHelper.sharedInstance.getAccompanistMaster()
        
        if (dcrAccompanists != nil)
        {
            for dcrAccompanistObj in dcrAccompanists!
            {
                let filterValue = userMasterAccompanist.filter{
                    $0.Region_Code == dcrAccompanistObj.Acc_Region_Code
                }
                if filterValue.count > 0
                {
                    dcrAccompanistObj.Region_Name = filterValue.first?.Region_Name ?? EMPTY
                }
                let downloadStatus = BL_DCR_Accompanist.sharedInstance.isAccompanistDataAvailable(userCode: dcrAccompanistObj.Acc_User_Code!, regionCode: dcrAccompanistObj.Acc_Region_Code!)
                
                if (downloadStatus != 1)
                {
                    dcrAccompanistObj.isAccompanistDataDownloadLater = false
                    accompanistDataPendingList.append(dcrAccompanistObj)
                }
            }
        }
    }
    
    func generateDataArray()
    {
        self.dcrId = DCRModel.sharedInstance.dcrId
        self.dcrStatus = DCRModel.sharedInstance.dcrStatus
        
        clearAllArray()
        
        self.isChemistDay = isChemistDayEnabled()
        
        getAccompanistData()
        getWorkPlaceDetails()
        updateDCRStatusAsDraft()
        getSFCDetails()
        getDoctorDetails()
        getChemistDetails()
        getStockistDetails()
        getExpenseDetails()
        getGeneralRemarks()
        getWorkTimeDetails()
        isTPFreezedDate()
        
        determineButtonStatus()
        disableButtonsForTPFreeze()
    }
    
    func isDCRAutoApprovalRequired() -> Bool
    {
        var autoApproval: Bool = false
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_AUTO_APPROVAL).uppercased()
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            autoApproval = true
        }
        
        return autoApproval
    }
    
    //MARK:-- Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpaceToContainer: CGFloat = 2
        let titleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateTitle, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let verticalSpaceBetweenTitleAndSubTitle: CGFloat = 4
        let subTitleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateSubTitle, fontName: fontRegular, fontSize: 12, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let verticalSpaceBetweenButtonAndSubTitle: CGFloat = 12
        var buttonHeight: CGFloat = 0
        
        if (stepperObj.showEmptyStateAddButton == true || stepperObj.showEmptyStateSkipButton == true)
        {
            buttonHeight = 29
        }
        
        let bottomSpace: CGFloat = 20
        
        return topSpaceToContainer + titleLabelHeight + verticalSpaceBetweenTitleAndSubTitle + subTitleLabelHeight + verticalSpaceBetweenButtonAndSubTitle + buttonHeight + bottomSpace
    }
    
    func getCommonSingleCellHeight() -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = 16
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 4
        let line2Height: CGFloat = 16
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
            childTableHeight += getCommonSingleCellHeight()
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getDoctorSingleCellHeight() -> CGFloat
    {
        let topSpace: CGFloat = 4
        let imageHeight: CGFloat = 24
        let label1TopSpace: CGFloat = 10
        let line1Height: CGFloat = 16
        let label2TopSpace: CGFloat = 4
        let line2Height: CGFloat = 16
        let dividerViewTopSpace: CGFloat = 8
        let dividerViewHeight: CGFloat = 1
        
        return topSpace + imageHeight + label1TopSpace + line1Height + label2TopSpace + line2Height + dividerViewTopSpace + dividerViewHeight
    }
    
    func getDoctorCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
            childTableHeight += getDoctorSingleCellHeight()
        }
        
        var totalHeight = titleSectionHeight + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getSFCSingleCellHeight() -> CGFloat
    {
        return 72
    }
    
    func getSFCCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
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
            childTableHeight += getSFCSingleCellHeight()
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getGeneralRemarksSingleCellHeight() -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = getTextSize(text: dcrHeaderObj!.DCR_General_Remarks, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - 101)).height
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 0
        let line2Height: CGFloat = 0
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getGeneralRemarksCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: DCRStepperModel = BL_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        let childTableHeight: CGFloat = getGeneralRemarksSingleCellHeight()
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    //MARK:-- Accompanist Data Download Functions
    func accompanistDataDownloadPendingUsersList() -> [DCRAccompanistModel]
    {
        let filteredArray = accompanistDataPendingList.filter{
            $0.isAccompanistDataDownloadLater == false
        }
        
        return filteredArray
    }
    
    func updateAccompanistDataDownloadAsLater(selectedAccompanistList: [DCRAccompanistModel])
    {
        for objDCRAccompanist in selectedAccompanistList
        {
            let filteredArray = accompanistDataPendingList.filter{
                $0.Acc_User_Code == objDCRAccompanist.Acc_User_Code && $0.Acc_Region_Code == objDCRAccompanist.Acc_Region_Code
            }
            
            if (filteredArray.count > 0)
            {
                filteredArray[0].isAccompanistDataDownloadLater = true
            }
        }
    }
    
    private func convertAccModelToUserModel(accompanistList: [DCRAccompanistModel]) -> [UserMasterModel]
    {
        var userList: [UserMasterModel] = []
        
        for objDCRAccompanist in accompanistList
        {
            let userObj: UserMasterModel = UserMasterModel()
            
            userObj.User_Code = objDCRAccompanist.Acc_User_Code
            userObj.Region_Code = objDCRAccompanist.Acc_Region_Code
            
            userList.append(userObj)
        }
        
        return userList
    }
    
    func downloadAccompanistData(selectedAccompanistList: [DCRAccompanistModel],viewController:UIViewController, completion: @escaping (Int) -> ())
    {
        let userList = convertAccModelToUserModel(accompanistList: selectedAccompanistList)
        
        BL_PrepareMyDeviceAccompanist.sharedInstance.beginAccompanistDataDownload(selectedAccompanists: userList)
        
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController, completion: { (apiResponseObj) in
            if (apiResponseObj.list.count > 0)
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.getCustomerData(isCalledFromMasterDataDownload: false) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDeviceAccompanist.sharedInstance.getSFCData(isCalledFromMasterDataDownload: false, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerHeader(isCalledFromMasterDataDownload: false, completion: { (status) in
                                    if (status == SERVER_SUCCESS_CODE)
                                    {
                                        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerSFC(isCalledFromMasterDataDownload: false, completion: { (status) in
                                            if (status == SERVER_SUCCESS_CODE)
                                            {
                                                BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerDoctor(isCalledFromMasterDataDownload: false, completion: { (status) in
                                                    if (status == SERVER_SUCCESS_CODE)
                                                    {
                                                        var regionCodes: String = EMPTY
                                                        
                                                        for obj in selectedAccompanistList
                                                        {
                                                            regionCodes += obj.Acc_Region_Code + ","
                                                        }
                                                        
                                                        BL_PrepareMyDevice.sharedInstance.getCustomerAddress(masterDataGroupName: EMPTY, selectedRegionCode: regionCodes, completion: { (status) in
                                                            if (status == SERVER_SUCCESS_CODE)
                                                            {
                                                                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: regionCodes, completion: { (status) in
                                                                    if status == SERVER_SUCCESS_CODE
                                                                    {
                                                                        BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
                                                                        self.generateDataArray()
                                                                        completion(status)
                                                                    }
                                                                    else
                                                                    {
                                                                        completion(status)
                                                                    }
                                                                })
                                                            }
                                                            else
                                                            {
                                                                completion(status)
                                                            }
                                                            
                                                        })
                                                    }
                                                    else
                                                    {
                                                        completion(status)
                                                    }
                                                })
                                            }
                                            else
                                            {
                                                completion(status)
                                            }
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
        })
    }
    
    func getTPHeaderByDate(dcrDate: String) -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTPDate(tpDate: dcrDate)
    }
    
    func getTPDoctorsByDate(dcrDate: Date) -> [TourPlannerDoctor]?
    {
        return DBHelper.sharedInstance.getTPDoctorsByTpDate(tpdate: dcrDate)
    }
    
    func getCPDoctorsByCpCode(cpCode: String) -> [CampaignPlannerDoctors]?
    {
        return DBHelper.sharedInstance.getCPDoctorsByCPCode(cpCode: cpCode)
    }
    
    //MARK:-- Submit DCR Functions
    func doSubmitDCRValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        errorMessage = doAllAccompanistValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllWorkPlaceValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllSFCValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllCustomerValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        //        errorMessage = doAllStockistValidation()
        //        if (errorMessage != EMPTY)
        //        {
        //            return errorMessage
        //        }
        
        errorMessage = doDoctorInavlidAccompanistValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doDoctorAccompanistEmptyAccompaniedValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllChemistVisitValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doChemistDayRCPAMandatoryValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doChemistInvalidAccompanistValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doChemistAccompanistEmptyAccompaniedValidation()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllExpenseValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doAllGeneralRemarksValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        errorMessage = doInheritanceValidations()
        if (errorMessage != EMPTY)
        {
            return errorMessage
        }
        
        return errorMessage
    }
    
    func submitDCR(captureLocation: Bool)
    {
        var dcrStatus = DCRStatus.applied.rawValue
        
        if (isDCRAutoApprovalRequired())
        {
            dcrStatus = DCRStatus.approved.rawValue
        }
        
        if (captureLocation)
        {
            DBHelper.sharedInstance.updateDCRStatusAndLocation(dcrId: DCRModel.sharedInstance.dcrId, dcrStatus: dcrStatus, latitude: getLatitude(), longitude: getLongitude(), dcrCode: EMPTY)
        }
        else
        {
            DBHelper.sharedInstance.updateDCRStatus(dcrId: DCRModel.sharedInstance.dcrId, dcrStatus: dcrStatus, dcrCode: EMPTY)
        }
        
        let dcrHeaderObj = DBHelper.sharedInstance.getDCRHeaderByDCRId(dcrId: DCRModel.sharedInstance.dcrId)
        
        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj!])
    }
    
    func checkSFCVersionUpdate() -> Bool
    {
        let dcrSFCList = getDCRSFCDetails()
        var isSFCUpdated: Bool = false
        
        if (dcrSFCList != nil)
        {
            if (dcrSFCList!.count > 0)
            {
                for objDCRSFC in dcrSFCList!
                {
                    let versionNumber = objDCRSFC.SFC_Version
                    let sfcCode = objDCRSFC.Distance_Fare_Code
                    
                    let updatedSFCList = DAL_SFC.sharedInstance.checkForNewSFCVersion(distanceFareCode: sfcCode!, sfcVersion: versionNumber!)
                    
                    if (updatedSFCList.count > 0)
                    {
                        DAL_SFC.sharedInstance.updateSFCDetails(fromPlace: objDCRSFC.From_Place, toPlace: objDCRSFC.To_Place, distance: updatedSFCList[0].Distance, distanceFareCode: sfcCode!, travelMode: objDCRSFC.Travel_Mode, sfcVersion: updatedSFCList[0].SFC_Version, travelId: objDCRSFC.DCR_Travel_Id, regionCode: objDCRSFC.Region_Code!, categoryName: objDCRSFC.SFC_Category_Name!)
                        
                        isSFCUpdated = true
                    }
                }
            }
        }
        
        return isSFCUpdated
    }
    
    func isAutSyncEnabledForDCR() -> Bool
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.AUTO_SYNC_ENABLED_FOR)
        var isEnabled: Bool = false
        
        if (privValue != EMPTY)
        {
            let privArray = privValue.uppercased().components(separatedBy: ",")
            
            if (privArray.contains(PrivilegeValues.DCR.rawValue.uppercased()))
            {
                isEnabled = true
            }
        }
        
        return isEnabled
    }
    
    //MARK:- Private Functions
    //MARK:-- Get Data Functions
    
    func getDCRAccompanistDetails() -> [DCRAccompanistModel]?
    {
        return BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
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
        return DBHelper.sharedInstance.getDCRSFCDetails(dcrId: getDCRId())
    }
    
    func getDCRStockistDetails() -> [DCRStockistVisitModel]?
    {
        return DBHelper.sharedInstance.getDCRStockistVisitDetails(dcrId: getDCRId())
    }
    
    func getDCRDoctorDetails() -> [DCRDoctorVisitModel]?
    {
        return DBHelper.sharedInstance.getDCRDoctorVisitDetails(dcrId: getDCRId())
    }
    
    func getChemistDayHeaderDetails() -> [ChemistDayVisit]
    {
        return DBHelper.sharedInstance.getChemistDayHeaderDetails(dcrId: getDCRId())
    }
    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    //MARK:-- Array Functions
    
    func clearAllArray()
    {
        isSFCUpdated = false
        stepperDataList = []
        accompanistList = []
        workPlaceList = []
        sfcList = []
        doctorList = []
        stockistList = []
        expenseList = []
        chemistDayHeaderList = []
        dcrHeaderObj = nil
        isChemistDay = false
        isTPFreeseDay = false
    }
    
    private func getAccompanistData()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(PEV_ACCOMPANIST) Details"
        stepperObjModel.emptyStateTitle = "\(PEV_ACCOMPANIST) Details"
        stepperObjModel.emptyStateSubTitle = "Update details of the person who worked with you"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD RIDE ALONG"
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Accompanist.rawValue
        
        let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
        
        if (dcrAccompanistList != nil)
        {
            for accompanistObj in dcrAccompanistList!
            {
                if (checkNullAndNilValueForString(stringData: accompanistObj.Acc_Start_Time) == EMPTY)
                {
                    accompanistObj.Acc_Start_Time = NOT_APPLICABLE
                }
                
                if (checkNullAndNilValueForString(stringData: accompanistObj.Acc_End_Time) == EMPTY)
                {
                    accompanistObj.Acc_End_Time = NOT_APPLICABLE
                }
            }
            
            self.accompanistList = dcrAccompanistList!
            stepperObjModel.recordCount = dcrAccompanistList!.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getWorkPlaceDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        var stepperWorkPlaceList: [StepperWorkPlaceModel] = []
        
        stepperObjModel.sectionTitle = "Work Place Details"
        stepperObjModel.emptyStateTitle = "Work Place Details"
        stepperObjModel.emptyStateSubTitle = "Update your day work category, place and time"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.WorkPLace.rawValue
        
        let dcrHeaderDetails: DCRHeaderModel? = getDCRWorkPlace()
        self.dcrHeaderObj = dcrHeaderDetails
        
        if (dcrHeaderDetails != nil)
        {
            if (checkNullAndNilValueForString(stringData: dcrHeaderDetails?.Category_Name) != EMPTY)
            {
                var stepperWorkPlaceObj: StepperWorkPlaceModel!
                
                let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAMPAIGN_PLANNER)
                
                stepperObjModel.recordCount = 3
                
                if (privilegeValue == PrivilegeValues.YES.rawValue || privilegeValue == PrivilegeValues.OPTIONAL.rawValue)
                {
                    stepperWorkPlaceObj = StepperWorkPlaceModel()
                    stepperWorkPlaceObj.key = appCp
                    
                    if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.CP_Name) != "")
                    {
                        stepperWorkPlaceObj.value = dcrHeaderDetails!.CP_Name
                    }
                    else
                    {
                        stepperWorkPlaceObj.value = "N/A"
                    }
                    
                    stepperWorkPlaceList.append(stepperWorkPlaceObj)
                }
                else
                {
                    stepperObjModel.recordCount = 2
                }
                
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
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-sfc"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD TRAVEL PLACE"
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.SFC.rawValue
        
        self.isSFCUpdated = checkSFCVersionUpdate()
        
        let sfcList: [DCRTravelledPlacesModel]? = getDCRSFCDetails()
        
        if (sfcList != nil)
        {
            self.sfcList = sfcList!
            stepperObjModel.recordCount = sfcList!.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getDoctorDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = ""
        
        if (!isChemistDayEnabled())
        {
            stepperObjModel.emptyStateTitle = "\(appDoctor) & \(appChemist) Visits"
        }
        else
        {
            stepperObjModel.emptyStateTitle = "\(appDoctor) Visits"
        }
        
        stepperObjModel.emptyStateSubTitle = "Update your \(appDoctor) visit details here"
        
        if (!isChemistDayEnabled())
        {
            stepperObjModel.doctorEmptyStateTitle = "\(appDoctor) & \(appChemist) Visits"
        }
        else
        {
            stepperObjModel.doctorEmptyStateTitle = "\(appDoctor) Visits"
        }
        
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = true
        stepperObjModel.leftButtonTitle = "ADD \(appDoctor.uppercased())"
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Doctor.rawValue
        
        let doctorList: [DCRDoctorVisitModel]? = getDCRDoctorDetails()
        
        if (doctorList != nil)
        {
            self.doctorList = doctorList!
            stepperObjModel.recordCount = doctorList!.count
        }
        
        let pendingDoctorVisitCount = getPendingDoctorVisitCount(dcrDate: DCRModel.sharedInstance.dcrDate, dcrId: self.dcrId)
        
        stepperObjModel.doctorEmptyStatePendingCount = "\(self.doctorList.count) \(appDoctor) Visits"
        
        if (pendingDoctorVisitCount != -1)
        {
            if (pendingDoctorVisitCount > 0)
            {
                stepperObjModel.doctorEmptyStatePendingCount = stepperObjModel.doctorEmptyStatePendingCount + " | \(pendingDoctorVisitCount) \(appDoctor) Visit(s) (pending)"
            }
            else
            {
                stepperObjModel.doctorEmptyStatePendingCount = stepperObjModel.doctorEmptyStatePendingCount + " | No Pending \(appDoctor) Visit(s)"
            }
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getChemistDetails()
    {
        if (self.isChemistDay)
        {
            let stepperObjModel: DCRStepperModel = DCRStepperModel()
            
            stepperObjModel.sectionTitle = "\(appChemist) Visits"
            stepperObjModel.emptyStateTitle = "\(appChemist) Visits"
            stepperObjModel.emptyStateSubTitle = "Update your \(appChemist) visit details here"
            stepperObjModel.doctorEmptyStateTitle = "\(appChemist) Visits"
            stepperObjModel.sectionIconName = "icon-stepper-two-user"
            stepperObjModel.isExpanded = true
            stepperObjModel.leftButtonTitle = "ADD \(appChemist.uppercased())"
            stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Chemist.rawValue
            
            let chemistList: [ChemistDayVisit] = getChemistDayHeaderDetails()
            self.chemistDayHeaderList = chemistList
            
            stepperObjModel.recordCount = chemistList.count
            stepperDataList.append(stepperObjModel)
        }
    }
    
    private func getStockistDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "\(appStockiest) Details"
        stepperObjModel.emptyStateTitle = "\(appStockiest) Visits(Optional)"
        stepperObjModel.emptyStateSubTitle = "Update your \(appStockiest) visit details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-two-user"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD \(appStockiest.uppercased())"
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Stockist.rawValue
        
        let stockistList: [DCRStockistVisitModel]? = getDCRStockistDetails()
        
        if (stockistList != nil)
        {
            self.stockistList = stockistList!
            stepperObjModel.recordCount = stockistList!.count
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getExpenseDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Expense Details"
        stepperObjModel.emptyStateTitle = "Expense Details"
        stepperObjModel.emptyStateSubTitle = "Update your expense details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "ic_Currency"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = "ADD EXPENSE"
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Expense.rawValue
        
        if (doctorList.count > 0 || chemistDayHeaderList.count > 0)
        {
            BL_Expense.sharedInstance.calculateFareForPrefillTypeExpenses()
            
            let expenseList: [DCRExpenseModel]? = getDCRExpenseDetails()
            if (expenseList != nil)
            {
                self.expenseList = expenseList!
                stepperObjModel.recordCount = expenseList!.count
            }
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getGeneralRemarks()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "General Remarks"
        stepperObjModel.emptyStateTitle = "General Remarks"
        stepperObjModel.emptyStateSubTitle = "Update your general remarks here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-stepper-remarks"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.GeneralRemarks.rawValue
        
//        if (doctorList.count > 0)
//        {
            dcrHeaderObj = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
            var generalRemarks = dcrHeaderObj?.DCR_General_Remarks
            
            if (generalRemarks != nil)
            {
                if (checkNullAndNilValueForString(stringData: generalRemarks!) != "")
                {
                    generalRemarks = generalRemarks!.replacingOccurrences(of: GENERAL_REMARKS_API_SPLIT_CHAR, with: " ")
                    generalRemarks = generalRemarks!.replacingOccurrences(of: GENERAL_REMARKS_LOCAL_SPLIT_CHAR, with: " ")
                    
                    dcrHeaderObj!.DCR_General_Remarks = generalRemarks
                    
                    stepperObjModel.recordCount = 1
                }
            }
//        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func getWorkTimeDetails()
    {
        let stepperObjModel: DCRStepperModel = DCRStepperModel()
        
        stepperObjModel.sectionTitle = "Work Time"
        stepperObjModel.emptyStateTitle = "Work Time Details"
        stepperObjModel.emptyStateSubTitle = "Update your work time details here"
        stepperObjModel.doctorEmptyStateTitle = ""
        stepperObjModel.doctorEmptyStatePendingCount = ""
        stepperObjModel.sectionIconName = "icon-time"
        stepperObjModel.isExpanded = false
        stepperObjModel.leftButtonTitle = ""
        stepperObjModel.Entity_Id = DCR_Stepper_Entity_Id.Work_Time.rawValue
        stepperObjModel.recordCount = 0
        
        let workTime = calculateWorkTimeBasedOnCustomerVisitTime()
        let startTime = workTime.0
        let endTime = workTime.1
        
        if(startTime != EMPTY && endTime != EMPTY)
        {
        DBHelper.sharedInstance.updateDCRWorkTime(startTime: startTime, endTime: endTime, dcrId: getDCRId())
        self.dcrHeaderObj?.Start_Time = startTime
        self.dcrHeaderObj?.End_Time = endTime
        stepperObjModel.recordCount = 1
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    func getCustomerVisitTimeArray() -> [Date]
    {
        let dcrDateString = DCRModel.sharedInstance.dcrDateString
        let doctorVisitList: [DCRDoctorVisitModel] = DBHelper.sharedInstance.getDCRDoctorVisitDetails(dcrId: getDCRId())
        let chemistDayVisitList: [ChemistDayVisit] = DBHelper.sharedInstance.getChemistDayHeaderDetails(dcrId: getDCRId())
        let stockistVisitList: [DCRStockistVisitModel] = DBHelper.sharedInstance.getDCRStockiestVisitList(dcrId: getDCRId())
        var timeArray: [Date] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeForAssets
        
        for objDocVisit in doctorVisitList
        {
            if (checkNullAndNilValueForString(stringData: objDocVisit.Visit_Time) != EMPTY)
            {
                let visitTimeArr = objDocVisit.Visit_Time?.components(separatedBy: " ")
                let docvisittime = (visitTimeArr?[0])! + " " + objDocVisit.Visit_Mode
                let timeString = convert12HrTo24Hr(timeString: docvisittime)
                let visitTime = dcrDateString! + " " + timeString + ":00"
                let converedTime = dateFormatter.date(from: visitTime)!
                
                timeArray.append(converedTime)
            }
        }
        
        for objChemVisit in chemistDayVisitList
        {
            if (checkNullAndNilValueForString(stringData: objChemVisit.VisitTime) != EMPTY)
            {
                let visitTimeArr = objChemVisit.VisitTime.components(separatedBy: " ")
                let chemvisittime = visitTimeArr[0] + " " + objChemVisit.VisitMode
                let timeString = convert12HrTo24Hr(timeString: chemvisittime)
                let visitTime = dcrDateString! + " " + timeString + ":00"
                let converedTime = dateFormatter.date(from: visitTime)!
//                let converedTime: Date = getDateStringInFormatDate(dateString : visitTime , dateFormat : dateTimeWithoutMilliSec) // TODO:2 Convert to date type
                
                timeArray.append(converedTime)
            }
        }
        
        for objStockVisit in stockistVisitList
        {
            if (checkNullAndNilValueForString(stringData: objStockVisit.Visit_Time) != EMPTY)
            {
                let visitTimeArr = objStockVisit.Visit_Time?.components(separatedBy: " ")
                let stockVisitTime = visitTimeArr![0] + " " + objStockVisit.Visit_Mode!
                let timeString = convert12HrTo24Hr(timeString: stockVisitTime)
                let visitTime = dcrDateString! + " " + timeString + ":00"
                let converedTime = dateFormatter.date(from: visitTime)!
                
                timeArray.append(converedTime)
            }
        }
        
        if (timeArray.count > 0)
        {
            timeArray.sort(by: { (date1, date2) -> Bool in
                date1 < date2
            })
        }
        
        return timeArray
    }
    
    private func calculateWorkTimeBasedOnCustomerVisitTime() -> (String, String)
    {
        var startTime: String = checkNullAndNilValueForString(stringData: dcrHeaderObj?.Start_Time)
        var endTime: String = checkNullAndNilValueForString(stringData: dcrHeaderObj?.End_Time)
        let dcrDateString = DCRModel.sharedInstance.dcrDateString
        var timeArray: [Date] = getCustomerVisitTimeArray()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeForAssets
        
        if (timeArray.count > 0)
        {
            if startTime != EMPTY && endTime != EMPTY
            {
                let starttimeString = convert12HrTo24Hr(timeString: startTime)
                let startvisitTime = dcrDateString! + " " + starttimeString + ":00"
                let existingStartTime = dateFormatter.date(from: startvisitTime)!
                
                let endtimeString = convert12HrTo24Hr(timeString: endTime)
                let endvisitTime = dcrDateString! + " " + endtimeString + ":00"
                let existingEndTime = dateFormatter.date(from: endvisitTime)!
                
                if (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
                {
                    timeArray.append(existingStartTime)
                    timeArray.append(existingEndTime)
                }
            }
            
            timeArray.sort(by: { (date1, date2) -> Bool in
                date1 < date2
            })
            
            let startdateString = dateFormatter.string(from: timeArray.first!)
            //startTime = ""
            startTime = getTimeIn12HrFormat(date: getDateFromString(dateString: startdateString), timeZone: NSTimeZone.local)
            
            let endDateString = dateFormatter.string(from: timeArray.last!)
            //startTime = ""
            endTime = getTimeIn12HrFormat(date: getDateFromString(dateString: endDateString), timeZone: NSTimeZone.local)
        }
        else
        {
            if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
            {
                startTime = EMPTY
                endTime = EMPTY
            }
        }
        
        return (startTime, endTime)
    }
    
    private func determineButtonStatus()
    {
        if (accompanistList.count == 0)
        {
            stepperDataList[0].showEmptyStateAddButton = true
            stepperDataList[0].showEmptyStateSkipButton = false
            
            if (checkNullAndNilValueForString(stringData: dcrHeaderObj?.Category_Name) == "")
            {
                stepperDataList[0].showEmptyStateSkipButton = BL_DCR_Accompanist.sharedInstance.doMinimumAccompanistValidation()
            }
        }
        else
        {
            stepperDataList[0].showRightButton = true
            stepperDataList[0].showLeftButton = BL_DCR_Accompanist.sharedInstance.doMaximumAccompanistValidation()
        }
        
        if (workPlaceList.count == 0)
        {
            if (accompanistList.count > 0)
            {
                stepperDataList[1].showEmptyStateAddButton = BL_DCR_Accompanist.sharedInstance.doMinimumAccompanistValidation()
            }
            else
            {
                stepperDataList[1].showEmptyStateAddButton = false
            }
            
            stepperDataList[1].showEmptyStateSkipButton = false
        }
        else
        {
            stepperDataList[1].showRightButton = true
            stepperDataList[1].showLeftButton = false
            
            if (sfcList.count == 0)
            {
                stepperDataList[2].showEmptyStateAddButton = true
                stepperDataList[2].showEmptyStateSkipButton = false
            }
            else
            {
                stepperDataList[2].showRightButton = true
                stepperDataList[2].showLeftButton = isHOPEnabledForSelectedCategory()
                
                var chemistIndex: Int = 4
                var stockistIndex: Int = 4
                var expenseIndex: Int = 5
                var remarksIndex: Int = 6
                var workTimeIndex: Int = 7
                
                if (self.isChemistDay)
                {
                    chemistIndex = 4
                    stockistIndex = 5
                    expenseIndex = 6
                    remarksIndex = 7
                    workTimeIndex = 8
                }
                
                if (doctorList.count == 0)
                {
                    stepperDataList[3].showEmptyStateAddButton = true
                    
                    if (self.isChemistDay)
                    {
                        stepperDataList[3].showEmptyStateSkipButton = true
                    }
                }
                else
                {
                    stepperDataList[3].showRightButton = true
                    stepperDataList[3].showLeftButton = true
                }
                
                if (self.isChemistDay)
                {
                    if (chemistDayHeaderList.count == 0)
                    {
                        stepperDataList[chemistIndex].showEmptyStateAddButton = true
                        stepperDataList[chemistIndex].showEmptyStateSkipButton = true
                    }
                    else
                    {
                        stepperDataList[chemistIndex].showLeftButton = true
                        stepperDataList[chemistIndex].showRightButton = true
                    }
                }
                
                determineStockistExpenseRemarksButtons(stockistIndex: stockistIndex, expenseIndex: expenseIndex, remarksIndex: remarksIndex, workTimeIndex: workTimeIndex)
            }
        }
    }
    
    private func determineStockistExpenseRemarksButtons(stockistIndex: Int, expenseIndex: Int, remarksIndex: Int, workTimeIndex: Int)
    {
        if (stockistList.count == 0)
        {
            if (self.doctorList.count > 0 || self.chemistDayHeaderList.count > 0)
            {
                stepperDataList[stockistIndex].showEmptyStateAddButton = true
                stepperDataList[stockistIndex].showEmptyStateSkipButton = true
            }
        }
        else
        {
            stepperDataList[stockistIndex].showRightButton = true
            stepperDataList[stockistIndex].showLeftButton = true
        }
        
        if (expenseList.count == 0)
        {
            if (self.doctorList.count > 0 || self.chemistDayHeaderList.count > 0)
            {
                stepperDataList[expenseIndex].showEmptyStateAddButton = true
                stepperDataList[expenseIndex].showEmptyStateSkipButton = true
            }
        }
        else
        {
            stepperDataList[expenseIndex].showRightButton = true
            stepperDataList[expenseIndex].showLeftButton = true
            
            if (stepperDataList[remarksIndex].recordCount == 0)
            {
                stepperDataList[remarksIndex].showEmptyStateAddButton = true
                stepperDataList[remarksIndex].showEmptyStateSkipButton = true
            }
            else
            {
                stepperDataList[remarksIndex].showRightButton = true
                stepperDataList[remarksIndex].showLeftButton = false
            }
        }
        
        let startTime: String = checkNullAndNilValueForString(stringData: dcrHeaderObj?.Start_Time)
        let endTime: String = checkNullAndNilValueForString(stringData: dcrHeaderObj?.End_Time)
        
        if (startTime != EMPTY && endTime != EMPTY)
        {
            stepperDataList[workTimeIndex].showRightButton = !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            stepperDataList[workTimeIndex].showLeftButton = false
        }
        else
        {
            stepperDataList[workTimeIndex].showRightButton = !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            stepperDataList[workTimeIndex].showLeftButton = false
            if (checkNullAndNilValueForString(stringData: dcrHeaderObj?.DCR_General_Remarks) != EMPTY)
            {
                stepperDataList[workTimeIndex].showEmptyStateAddButton = !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            }
            else
            {
                stepperDataList[workTimeIndex].showEmptyStateAddButton = !BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            }
        }
    }
    
    private func isTPFreezedDate()
    {
        self.isTPFreeseDay = false
        
        if (DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue)
        {
            if (self.dcrHeaderObj!.Is_TP_Frozen == 1)
            {
                let approvedTPCount = DBHelper.sharedInstance.getApprovedTPCount(tpDate: getDCRDate())
                
                if (approvedTPCount > 0)
                {
                    let unfreezeCount = DBHelper.sharedInstance.getUnfreezedTPCount(tpDate: getDCRDate())
                    
                    if (unfreezeCount <= 0)
                    {
                        self.isTPFreeseDay = true
                    }
                }
            }
        }
    }
    
    private func getDCRDate() -> String
    {
        return DCRModel.sharedInstance.dcrDateString
    }
    
    private func getWorkCategoryName() -> String
    {
        return DCRModel.sharedInstance.expenseEntityName
    }
    
    private func disableButtonsForTPFreeze()
    {
        if (self.isTPFreeseDay)
        {
            // Accompanist
            stepperDataList[0].showEmptyStateAddButton = true
            stepperDataList[0].showEmptyStateSkipButton = true
         //   stepperDataList[0].showLeftButton = true
            
            //Work Place
            stepperDataList[1].showEmptyStateAddButton = false
            stepperDataList[1].showEmptyStateSkipButton = false
            stepperDataList[1].showLeftButton = false
            stepperDataList[1].showRightButton = false
            
            //SFC
            stepperDataList[2].showEmptyStateAddButton = false
            stepperDataList[2].showEmptyStateSkipButton = false
            stepperDataList[2].showLeftButton = false
            
            let categoryName = getWorkCategoryName()
            let sfcValidationPrivList: [String] = BL_SFC.sharedInstance.getSFCValidationPrivVal()
            
            if (sfcValidationPrivList.contains(categoryName.uppercased()))
            {
                let circleRoutePrivList: [String] = BL_SFC.sharedInstance.getCircleRouteAppCategoryPrivVal()
                
                if (circleRoutePrivList.contains(categoryName.uppercased()))
                {
                    stepperDataList[2].showLeftButton = true
                }
            }
        }
    }
    
    private func getCategoryName() -> String
    {
        var categoryName: String = ""
        
        let filteredArray = workPlaceList.filter{
            $0.key == "Work Category"
        }
        
        if (filteredArray.count > 0)
        {
            categoryName = filteredArray[0].value
        }
        
        return categoryName.uppercased()
    }
    
    func isHOPEnabledForSelectedCategory() -> Bool
    {
        return BL_SFC.sharedInstance.checkIntermediateStatus()
    }
    
    func isChemistDayEnabled() -> Bool
    {
        let configValue = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.CHEMIST_DAY).uppercased()
        
        if (configValue == ConfigValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK:-- Pending Doctor Visit Functions
    /*
     If it returns -1 mean, no doctors planned in CP or TP
     If it returns 0 mean, no pending doctors (i.e. user has entered all the doctors planned in DCR)
     If it returns greater than zero mean that number of doctors are pending in DCR
     */
    func getPendingDoctorVisitCount(dcrDate: Date, dcrId: Int) -> Int
    {
        let tpHeaderObj = getTPHeaderByDate(dcrDate: getServerFormattedDateString(date: dcrDate))
        var deviatedDoctorsCount: Int = -1
        var tpDoctorsDeviationCount: Int = -1
        let dcrDoctorList = DBHelper.sharedInstance.getDCRDoctorVisitDetails(dcrId: dcrId)
        
        if (tpHeaderObj != nil)
        {
            tpDoctorsDeviationCount = getTPDoctorsDeviatedInDCR(dcrDate: dcrDate, dcrDoctorList: dcrDoctorList)
        }
        
        if (tpDoctorsDeviationCount == -1) // -1 mean, no TP doctors defined. So check CP doctors in DCR
        {
            let cpCode = getCPCode(dcrId: dcrId)
            
            if (cpCode != EMPTY)
            {
                let cpDoctorsDeviationCount = getCPDoctorsDeviatedInDCR(cpCode: cpCode, dcrDoctorList: dcrDoctorList)
                
                if (cpDoctorsDeviationCount != -1)
                {
                    deviatedDoctorsCount = cpDoctorsDeviationCount
                }
            }
        }
        else
        {
            deviatedDoctorsCount = tpDoctorsDeviationCount
        }
        
        return deviatedDoctorsCount
    }
    
    private func getCPCode(dcrId: Int) -> String
    {
        let dcrHeaderObj = DBHelper.sharedInstance.getDCRHeaderByDCRId(dcrId: dcrId)
        var cpCode: String = EMPTY
        
        if (dcrHeaderObj != nil)
        {
            if (checkNullAndNilValueForString(stringData: dcrHeaderObj!.CP_Code) != EMPTY)
            {
                cpCode = dcrHeaderObj!.CP_Code!
            }
        }
        
        return cpCode
    }
    
    /*
     If it returns -1 mean no doctors defined in TP
     If it returns any number other than -1 mean, that number of TP doctors been deviated in DCR
     */
    private func getTPDoctorsDeviatedInDCR(dcrDate: Date, dcrDoctorList: [DCRDoctorVisitModel]?) -> Int
    {
        let tpDoctors = getTPDoctorsByDate(dcrDate: dcrDate)
        var deviatedDoctorsCount: Int = -1
        
        if (tpDoctors != nil)
        {
            if (tpDoctors!.count > 0)
            {
                deviatedDoctorsCount = tpDoctors!.count
                
                if (dcrDoctorList != nil)
                {
                    for tpDoctorObj in tpDoctors!
                    {
                        let filteredArray = dcrDoctorList!.filter{
                            tpDoctorObj.Doctor_Code == $0.Doctor_Code && tpDoctorObj.Doctor_Region_Code == $0.Doctor_Region_Code
                        }
                        
                        if (filteredArray.count > 0)
                        {
                            deviatedDoctorsCount -= 1
                        }
                    }
                }
            }
        }
        
        return deviatedDoctorsCount
    }
    
    /*
     If it returns -1 mean no doctors defined in CP
     If it returns any number other than -1 mean, that number of CP doctors been deviated in DCR
     */
    private func getCPDoctorsDeviatedInDCR(cpCode: String, dcrDoctorList: [DCRDoctorVisitModel]?) -> Int
    {
        let cpDoctors = getCPDoctorsByCpCode(cpCode: cpCode)
        var deviatedDoctorsCount: Int = -1
        
        if (cpDoctors != nil)
        {
            if (cpDoctors!.count > 0)
            {
                deviatedDoctorsCount = cpDoctors!.count
                
                if (dcrDoctorList != nil)
                {
                    for cpDoctorObj in cpDoctors!
                    {
                        let filteredArray = doctorList.filter{
                            cpDoctorObj.Doctor_Code == $0.Doctor_Code && cpDoctorObj.Doctor_Region_Code == $0.Doctor_Region_Code
                        }
                        
                        if (filteredArray.count > 0)
                        {
                            deviatedDoctorsCount -= 1
                        }
                    }
                }
            }
        }
        
        return deviatedDoctorsCount
    }
    
    //MARK:- General Remarks
    
    private func getDCRGeneralRemark(dcrId : Int) -> String
    {
        return DBHelper.sharedInstance.getDCRStepperGeneralRemarks(dcrId: dcrId)
    }
    
    func updateDCRGeneralRemarks(remarksTxt : String , dcrId : Int)
    {
        var generalRemarks = getDCRGeneralRemark(dcrId: getDCRId())
        var preRemarks: String = EMPTY
        
        if (generalRemarks != EMPTY && generalRemarks.contains(GENERAL_REMARKS_API_SPLIT_CHAR))
        {
            let remarksArray = generalRemarks.components(separatedBy: GENERAL_REMARKS_LOCAL_SPLIT_CHAR)
            
            if (remarksArray.count > 0)
            {
                preRemarks = remarksArray[0]
            }
        }
        
        generalRemarks = preRemarks + GENERAL_REMARKS_LOCAL_SPLIT_CHAR + remarksTxt
        
        DBHelper.sharedInstance.updateDCRGeneralRemarksDetails(dcrId : dcrId , remarksTxt: generalRemarks)
    }
    
    func getGeneralRemarksForModify() -> String
    {
        let generalRemarks = getDCRGeneralRemark(dcrId: getDCRId())
        var modifyRemarks: String = EMPTY
        
        if (generalRemarks != EMPTY && generalRemarks.contains(GENERAL_REMARKS_LOCAL_SPLIT_CHAR))
        {
            let remarksArray = generalRemarks.components(separatedBy: GENERAL_REMARKS_LOCAL_SPLIT_CHAR)
            
            if (remarksArray.count > 0)
            {
                modifyRemarks = remarksArray[remarksArray.count - 1]
            }
        }
        
        return modifyRemarks
    }
    
    func getPreviousGeneralRemarks() -> String
    {
        let generalRemarks = getDCRGeneralRemark(dcrId: getDCRId())
        var preRemarks: String = EMPTY
        
        if (generalRemarks != EMPTY && generalRemarks.contains(GENERAL_REMARKS_API_SPLIT_CHAR))
        {
            let remarksArray = generalRemarks.components(separatedBy: GENERAL_REMARKS_LOCAL_SPLIT_CHAR)
            
            if (remarksArray.count > 0)
            {
                let splittedStringArr : [String] = remarksArray[0].components(separatedBy: GENERAL_REMARKS_API_SPLIT_CHAR)
                for i in 0..<splittedStringArr.count
                {
                    if i == splittedStringArr.count - 1
                    {
                        preRemarks = preRemarks + splittedStringArr[i]
                    }
                    else
                    {
                        preRemarks = preRemarks + splittedStringArr[i] + "\n"
                    }
                }
            }
        }
        
        return preRemarks
    }
    
    //MARK:-- Validation Functions
    private func doAllAccompanistValidation() -> String
    {
        //        let accompanistMasterList = BL_DCR_Accompanist.sharedInstance.getAccompanistMasterList()
        let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
        var errorMessage: String = EMPTY
        
        if (dcrAccompanistList != nil)
        {
            //            if (accompanistMasterList != nil)
            //            {
            //                for objDCRAccompanist in dcrAccompanistList!
            //                {
            //                    let filteredArray = accompanistMasterList!.filter{
            //                        $0.Region_Code == objDCRAccompanist.Acc_Region_Code && $0.User_Code == objDCRAccompanist.Acc_User_Code
            //                    }
            //
            //                    if (filteredArray.count == 0)
            //                    {
            //                        errorMessage = objDCRAccompanist.Acc_User_Name! + " is an invalid accompanist"
            //                        return errorMessage
            //                    }
            //                }
            //            }
            
            let minimumAccompanistCount = BL_DCR_Accompanist.sharedInstance.getMinimumAccompanistCount()
            
            if (minimumAccompanistCount > 0)
            {
                if (dcrAccompanistList!.count < minimumAccompanistCount)
                {
                    errorMessage = "You need to enter minimum of \(minimumAccompanistCount) Ride Along in a DVR"
                    return errorMessage
                }
            }
            
            let maximumAccompanistCount = BL_DCR_Accompanist.sharedInstance.getMaximumAccompanistCount()
            
            if (maximumAccompanistCount > 0)
            {
                if (dcrAccompanistList!.count > maximumAccompanistCount)
                {
                    errorMessage = "You can enter maximum of \(maximumAccompanistCount) Ride Along only in a DVR"
                    return errorMessage
                }
            }
            
            let doctorRegionCodes = DBHelper.sharedInstance.getDoctorVisitUniqueRegionCode(dcrId: DCRModel.sharedInstance.dcrId)
            for model in doctorRegionCodes
            {
                if model.Doctor_Region_Code != getRegionCode()
                {
                    let regionCodeExists = DBHelper.sharedInstance.checkRegionCodeExistsDCRAccompanist(regionCode: model.Doctor_Region_Code!, dcrId: DCRModel.sharedInstance.dcrId)
                    if regionCodeExists == 0
                    {
                        errorMessage = "Your entered \(appDoctor) is invalid."
                        return errorMessage
                    }
                }
            }
        }
        
        return errorMessage
    }
    
    func doAllWorkPlaceValidations() -> String
    {
        var errorMessage: String = EMPTY
        var privValue = BL_WorkPlace.sharedInstance.getPrivelegeValueForWorkTime()
        let dcrHeaderDetails = BL_WorkPlace.sharedInstance.getDCRHeaderDetailForWorkPlace()
        
        if checkNullAndNilValueForString(stringData: dcrHeaderDetails?.Place_Worked).count > flexiPlaceMaxLength
        {
            errorMessage = "You have entered more than \(flexiPlaceMaxLength) characters in Work Place. Please change the work place"
            return errorMessage
        }
        
        if (privValue == PrivilegeValues.MANDATORY.rawValue)
        {
            if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.Start_Time) == EMPTY)
            {
                errorMessage = "Please enter start time & end time in \"Work Time\" section"
                return errorMessage
            }
        }
//        if checkNullAndNilValueForString(stringData: dcrHeaderDetails!.Start_Time) != EMPTY
//        {
//            if !BL_WorkPlace.sharedInstance.validateFromToTime(fromTime: dcrHeaderDetails!.Start_Time!, toTime: dcrHeaderDetails!.End_Time!)
//            {
//                errorMessage = " \"To Time\" should be greater than \"From Time\""
//                return errorMessage
//            }
//        }
        
        if (DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue)
        {
            privValue = BL_WorkPlace.sharedInstance.getPrevilegeValueForCP()
            
            if (privValue == PrivilegeValues.YES.rawValue)
            {
                if (checkNullAndNilValueForString(stringData: dcrHeaderDetails!.CP_Code) == EMPTY)
                {
                    errorMessage = "Please choose a \(appCp) in \"Work Place Details\" section"
                    return errorMessage
                }
            }
           if dcrHeaderDetails!.CP_Code != EMPTY && dcrHeaderDetails!.CP_Code != nil
           {
            if(!BL_WorkPlace.sharedInstance.checkIfCpExistsInMaster(cpCode: dcrHeaderDetails!.CP_Code))//check cp invalid validation
            {
                errorMessage = ("Selected \(appCp) is not in Approved status")
                return errorMessage
            }
            }
            
        }
        
        return errorMessage
    }
    
    func doAllSFCValidations() -> String
    {
        let dcrTravelledPlacesList = DAL_SFC.sharedInstance.getTravelledDetailList()
        var errorMessage: String = EMPTY
        
        if (dcrTravelledPlacesList != nil)
        {
            for objSFC in dcrTravelledPlacesList!
            {
                errorMessage = BL_SFC.sharedInstance.sfcValidationCheck(fromPlace: objSFC.From_Place, toPlace: objSFC.To_Place, travelMode: objSFC.Travel_Mode)
                
                if (errorMessage != EMPTY)
                {
                    return errorMessage
                }
            }
        }
        
        errorMessage = BL_SFC.sharedInstance.saveTravelledPlaces()
        
        return errorMessage
    }
    
    private func doAllCustomerValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        errorMessage =  BL_DCR_Doctor_Visit.sharedInstance.doDoctorVisitAllValidations()
        
        if self.doctorList.count > 0
        {
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_DOC_VISITS) == PrivilegeValues.YES.rawValue)
            {
                let dcrAccompanistList = BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()
                let doctorAccompanistList = BL_DCR_Doctor_Accompanists.sharedInstance.getDCRDoctorAccompanistsByDCRId()
                
                if (dcrAccompanistList != nil)
                {
                    for objDCRAccompanist in dcrAccompanistList!
                    {
                        let filteredArray = doctorAccompanistList.filter{
                            $0.Acc_User_Code == objDCRAccompanist.Acc_User_Code && $0.Acc_Region_Code == objDCRAccompanist.Acc_Region_Code
                        }
                        
                        if (filteredArray.count == 0)
                        {
                            
//                            if objDCRAccompanist.Employee_Name != "VACANT" && objDCRAccompanist.Employee_Name != "NOT ASSIGNED"
//
//                            {
                            
                            errorMessage = "\(accompMissedPrefixErrorMsg)" + "\(objDCRAccompanist.Employee_Name!)" + "\(accompMissedSuffixErrorMsg)"
                            break
                                
                            //}
                        }
                    }
                }
            }
            
            if (errorMessage == EMPTY)
            {
                if (isChemistDayEnabled())
                {
                    let rcpaMandPriv = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY).uppercased()
                    
                    if (rcpaMandPriv != EMPTY)
                    {
                        let priviledge = BL_Common_Stepper.sharedInstance.getChemistDayCaptureValue()
                        let privArray = priviledge.components(separatedBy: ",")
                        let categoryArray = rcpaMandPriv.components(separatedBy: ",")
                        
                        if privArray.contains(Constants.ChemistDayCaptureValue.RCPA)
                        {
                            let rcpaList = DBHelper.sharedInstance.getChemistRCPAOwnForUpload(dcrId: getDCRId())
                            
                            for objDoctorVisit in self.doctorList
                            {
                                if (categoryArray.contains(checkNullAndNilValueForString(stringData: objDoctorVisit.Category_Name?.uppercased())))
                                {
                                    if (self.chemistDayHeaderList.count == 0)
                                    {
                                        errorMessage = "You need to enter minimum of 1 RCPA for the \(appDoctor) \(objDoctorVisit.Doctor_Name! )"
                                        break
                                    }
                                    else
                                    {
                                        let filteredArray = rcpaList.filter{
                                            $0.DoctorCode == objDoctorVisit.Doctor_Code! && $0.DoctorRegionCode == objDoctorVisit.Doctor_Region_Code!
                                        }
                                        
                                        if (filteredArray.count == 0)
                                        {
                                            errorMessage = "You need to enter minimum of 1 RCPA for the \(appDoctor) \(objDoctorVisit.Doctor_Name! )"
                                            break
                                        }
                                    }
                                }
                                
                                if (errorMessage != EMPTY)
                                {
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
    
    private func doAllStockistValidation() -> String
    {
        let dcrStockistList = BL_DCR_Stockiests.sharedInstance.getDCRStockiestsList()
        let stockistMasterList = BL_DCR_Stockiests.sharedInstance.getMasterStockiestList()
        var errorMessage: String = EMPTY
        
        for objDCRStockist in dcrStockistList
        {
            let filteredArray = stockistMasterList.filter{
                $0.Customer_Code == objDCRStockist.Stockiest_Code
            }
            
            if (filteredArray.count == 0)
            {
                errorMessage = "\(objDCRStockist.Stockiest_Name) is an invalid \(appStockiest)"
            }
        }
        
        return errorMessage
    }
    
    func doAllExpenseValidations() -> String
    {
        let dcrExpenseList = BL_Expense.sharedInstance.getDCRExpenses()
        var errorMessage: String = EMPTY
        
        if (dcrExpenseList != nil)
        {
            let expenseTypeList = BL_Expense.sharedInstance.getExpenseTypes()
            
            if (expenseTypeList != nil)
            {
                for objDCRExpense in dcrExpenseList!
                {
                    var filterdArray = expenseTypeList!.filter{
                        $0.Expense_Type_Code == objDCRExpense.Expense_Type_Code
                    }
                    
                    if (filterdArray.count == 0)
                    {
                        errorMessage = (objDCRExpense.Expense_Type_Name) + " is an invalid expense type"
                        break
                    }
                    
                    if (filterdArray[0].Expense_Mode.uppercased() == DAILY)
                    {
                        filterdArray = expenseTypeList!.filter{
                            $0.Expense_Type_Code.uppercased() == objDCRExpense.Expense_Type_Code.uppercased() && $0.Expense_Entity_Code.uppercased() == DCRModel.sharedInstance.expenseEntityCode.uppercased()
                        }
                    }
                    
                    if (filterdArray.count > 0)
                    {
                        if (filterdArray[0].Is_Validation_On_Eligibility == "Y")
                        {
                            if (filterdArray[0].Eligibility_Amount != nil && objDCRExpense.Is_Prefilled == 0)
                            {
                                let eligibilityAmout = filterdArray[0].Eligibility_Amount!
                                
                                if (objDCRExpense.Expense_Amount > eligibilityAmout)
                                {
                                    let expenseTypeName = objDCRExpense.Expense_Type_Name as String
                                    errorMessage = "You have entered more than the eiligibility amount for \(expenseTypeName)"
                                    break
                                }
                            }
                        }
                        
                        if (filterdArray[0].Is_Remarks_Mandatory == 1 && checkNullAndNilValueForString(stringData: objDCRExpense.Remarks) == EMPTY)
                        {
                            errorMessage = "Remarks is mandatory for \(objDCRExpense.Expense_Type_Name!)"
                            break
                        }
                    }
                    else
                    {
                        errorMessage = (objDCRExpense.Expense_Type_Name) + " is an invalid expense type"
                        break
                    }
                }
            }
            else
            {
                errorMessage = "There are some invalid expense type(s) in your DVR"
            }
        }
        
        return errorMessage
    }
    
    
    private func doAllGeneralRemarksValidations() -> String
    {
        var errorMessage: String = EMPTY
        
        if (checkNullAndNilValueForString(stringData: dcrHeaderObj?.Unapprove_Reason) != EMPTY)
        {
            if (getGeneralRemarksForModify() == EMPTY)
            {
                errorMessage = "Please enter general remarks"
            }
        }
        
        return errorMessage
    }
    
    private func doInheritanceValidations() -> String
    {
        var errorMessage: String = EMPTY
        var errorUsers: String = EMPTY
        
        if (BL_DCR_Doctor_Visit.sharedInstance.getDCRInheritancePrivilegeValue() == PrivilegeValues.ONE.rawValue)
        {
            let filteredArray = self.accompanistList.filter{
                $0.Is_Customer_Data_Inherited != Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success && $0.Is_Customer_Data_Inherited != Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status && $0.Is_Only_For_Doctor == "0"
            }
            
            for objAcc in filteredArray
            {
                if (BL_DCR_Doctor_Visit.sharedInstance.isLeafUser(userCode: objAcc.Acc_User_Code!, regionCode: objAcc.Acc_Region_Code))
                {
                    let doctorFilter = self.doctorList.filter{
                        $0.Doctor_Region_Code! == objAcc.Acc_Region_Code && $0.Is_DCR_Inherited_Doctor == 1
                    }
                    
                    if (doctorFilter.count == 0)
                    {
                        errorUsers += objAcc.Employee_Name! + ","
                    }
                }
            }
            
            if (errorUsers != EMPTY)
            {
                errorUsers = String(errorUsers.dropLast(1))
                
                errorMessage = Display_Messages.DCR_Inheritance_Messages.NO_INHERITED_DOCTOR_SUBMIT_DCR_VALIDATION
                errorMessage = errorMessage.replacingOccurrences(of: "@ACC_USER", with: errorUsers)
            }
        }
        
        return errorMessage
    }
    
    private func doAllChemistVisitValidations() -> String
    {
        return BL_Common_Stepper.sharedInstance.doAllCustomerValidations()
    }
    
    private func updateDCRStatusAsDraft()
    {
        if (isDataInsertedFromTP == false)
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
    
    private func doDoctorInavlidAccompanistValidation() -> String
    {
        var errorMessage : String = EMPTY
        
        let dcrDoctorInvalidAccompaniedList = DBHelper.sharedInstance.getDCRInvalidDoctorAccompanistsByDCRId(dcrId: getDCRId(), accompaniedStatus: 99)
        
        if (dcrDoctorInvalidAccompaniedList.count > 0)
        {
            let accompanistObj = dcrDoctorInvalidAccompaniedList.first!
            errorMessage = accompMissedPrefixErrorMsg + accompanistObj.Employee_Name! + accompMissedSuffixErrorMsg
        }
        
        return errorMessage
    }
    
    private func doChemistInvalidAccompanistValidation() -> String
    {
        var errorMessage : String = EMPTY
        
        let dcrChemistInvalidAccompaniedList = DBHelper.sharedInstance.getDCRInvalidChemistAccompanistsByDCRId(dcrId: getDCRId(), accompaniedStatus: 99)
        
        if (dcrChemistInvalidAccompaniedList.count > 0)
        {
            let accompanistObj = dcrChemistInvalidAccompaniedList.first!
            errorMessage = accompMissedPrefixErrorMsg + accompanistObj.AccUserName! + accompMissedSuffixErrorMsg
        }
        
        return errorMessage
    }
    
    private func doDoctorAccompanistEmptyAccompaniedValidation() -> String
    {
        var errorMessage : String = EMPTY
        
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_DOC_VISITS) == PrivilegeValues.YES.rawValue)
        {
            let dcrDoctorAccompanistList = DBHelper.sharedInstance.getDCRDoctorAccompanistIsNotAccompanied(dcrId: getDCRId())
            if dcrDoctorAccompanistList != nil
            {
                let dcrAccompanitsListCount = String(describing: getDCRAccompanistDetails()!.count)
                
                if dcrDoctorAccompanistList != nil
                {
                    if (dcrDoctorAccompanistList?.count)! > 0
                    {
                        errorMessage = "You have entered " + dcrAccompanitsListCount + " Ride Along(s) in DVR but not selected in any of the \(appDoctorPlural). Please select the Ride Along for the entered \(appDoctorPlural) to proceed the same."
                    }
                }
            }
        }
        return errorMessage
    }
    
    private func doChemistAccompanistEmptyAccompaniedValidation() -> String
    {
        var errorMessage : String = EMPTY
        
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_CHEMIST_VISITS) == PrivilegeValues.YES.rawValue)
        {
            let dcrDoctorAccompanistList = DBHelper.sharedInstance.getDCRChemistAccompanistIsNotAccompanied(dcrId: getDCRId())
            if dcrDoctorAccompanistList != nil
            {
                let dcrAccompanitsListCount = String(describing: getDCRAccompanistDetails()!.count)
                
                if dcrDoctorAccompanistList != nil
                {
                    if (dcrDoctorAccompanistList?.count)! > 0
                    {
                        errorMessage = "You are entered the " + dcrAccompanitsListCount + " Ride Along(s), but not selected for any of the \(appChemistPlural). Please select the Ride Along for the entered \(appChemistPlural) to proceed the same."
                    }
                }
            }
        }
        return errorMessage
    }
    
    private func doChemistDayRCPAMandatoryValidation() -> String
    {
        var errorMessage : String = EMPTY
        
        if (isChemistDayEnabled())
        {
            let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CHEMIST_VISITS_CAPTURE_CONTROLS).uppercased()
            let privArray = privilegeValue.components(separatedBy: ",")
            
            if privArray.contains(Constants.ChemistDayCaptureValue.RCPA)
            {
                let rcpaMandatoryPrivValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY).uppercased()
                
                if (rcpaMandatoryPrivValue != EMPTY)
                {
                    let mandatoryCategoryArray = rcpaMandatoryPrivValue.components(separatedBy: ",")
                    
                    for categoryName in mandatoryCategoryArray
                    {
                        let doctorList = DBHelper.sharedInstance.getDoctorVisitByCategoryName(dcrId: getDCRId(), categoryName: categoryName)
                        
                        if (doctorList.count == 0)
                        {
                            errorMessage = "No \(categoryName) \(appDoctorPlural) are entered in this DVR. You need to enter minimum of 1 RCPA for \(categoryName) \(appDoctorPlural)"
                            return errorMessage
                        }
                        
                        for objDoctorVisit in doctorList
                        {
                            let rcpaList = DBHelper.sharedInstance.getRCPAListByDoctorCode(dcrId: getDCRId(), doctorCode: checkNullAndNilValueForString(stringData: objDoctorVisit.Doctor_Code), doctorRegionCode: checkNullAndNilValueForString(stringData: objDoctorVisit.Doctor_Region_Code))
                            
                            if (rcpaList.count == 0)
                            {
                                errorMessage = "Please enter minimum of 1 RCPA for the \(appDoctor) \(objDoctorVisit.Doctor_Name!)"
                                return errorMessage
                            }
                        }
                    }
                }
            }
        }
        
        return errorMessage
    }
}

