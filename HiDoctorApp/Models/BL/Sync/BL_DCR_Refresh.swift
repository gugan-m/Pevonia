//
//  BL_DCR_Refresh.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol DCRRefreshDelegate
{
    func getServiceStatus(message : String, statusCode : Int)
    func getInwardAlert(statusCode:Int,isNavigate:Bool)
}

class BL_DCR_Refresh: NSObject
{
    static let sharedInstance = BL_DCR_Refresh()
    
    var delegate : DCRRefreshDelegate?
    let fieldFlag: String = "F"
    let attendanceFlag: String = "A"
    var isFromDCRUpload : Bool = false
    
    struct apiMessageName
    {
        static let DCRLockLeave = "DVR Lock Not Working"
        static let DCRCalendarData = "DVR Calendar"
        static let DCRHeaderData = "DVR Header"
        static let DCRAccompanistData = "DVR Ride Along"
        static let DCRTravelledPlaces = "DVR Travelled places"
        static let DCRDoctorVisitDetails  = "DVR \(appDoctor) visit details"
        static let DCRDoctorAccompanist = "DVR \(appDoctor) Ride Along"
        static let DCRSampleDetails = "DVR Sample details"
        static let DCRDetailedProducts = "DVR Detailed products"
        static let DCRChemistVisit = "DVR \(appChemist) visit"
        static let DCRChemistDayVisits = "DVR \(appChemist)Day Visits"
        static let DCRChemistAccompanist = "DVR \(appChemist) Ride Along"
        static let DCRChemistSamplePromotion = "DVR \(appChemist)t SamplePromotion"
        static let DCRChemistDetailedProductsDetails = "DVR \(appChemist) DetailedProducts Details"
        static let DCRChemistRCPAOwnProductDetails = "DVR \(appChemist) RCPAOwn ProductDetails"
        static let DCRChemistRCPACompetitorProductDetails = "DVR \(appChemist) RCPACompetitor ProductDetails"
        static let DCRChemistDayFollowups = "DVR \(appChemist) Followups"
        static let DCRChemistDayAttachments = "DVR \(appChemist) Attachments"
        static let DCRDoctorPOB = "DVR \(appDoctor) POB"
        static let DCRChemistPOB = "DVR \(appChemist) POB"
        static let DCRRCPADetails = "DVR RCPA details"
        static let DCRFollowUpDetails = "DVR FollowUp Details"
        static let DCRAttachmentDetails = "DVR Attachment details"
        static let DCRStockiestDetails = "DVR Stockiest details"
        static let DCRExpenseDetails = "DVR Expense details"
        static let DCRAttendanceActivities = "DVR Office activities"
        static let DCRUserProducts = "DVR User products"
        static let DCRCallActivity = "DVR Call Activity"
        static let DCRMCActivity = "DVR MC Activity"
        static let AttendanceDCRCallActivity = "Office DVR Call Activity"
        static let AttendanceDCRMCActivity = "Office DVR MC Activity"
        static let AssetAnalyticsDetails = "ResourceAnalyticsDetails"
        static let TPUnfreezeDates = "PR Unfreeze Dates"
        static let DCRCompetitor = "DVR Competitor Details"
        static let DCRAttendanceSample = "DVR Office Sample Details"
    }
    
    // MARK:- Public Functions
    func isAnyPendingDCRToUpload() -> Bool
    {
        let appiedAndApprovedDCRCount = getPendingUploadDCRCount()
        
        if (appiedAndApprovedDCRCount > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isDraftDcrAvailable() -> Bool
    {
        let draftDCRCount = getPendingDraftDCRCount()
        
        if (draftDCRCount > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getPendingUploadDCRCount() -> Int
    {
        return DBHelper.sharedInstance.getAppliedDCRCount()
    }
    
    func getPendingDraftDCRCount() -> Int
    {
        return DBHelper.sharedInstance.getDraftDCRCount()
    }
    
    func dcrRefreshAPICall(refreshMode: DCRRefreshMode, endDate: String?)
    {
        BL_UploadAnalytics.sharedInstance.dcrRefreshInProgress = true
        BL_UploadFeedback.sharedInstance.dcrRefreshInProgress = true
        BL_UploadDoctorVisitFeedback.sharedInstance.dcrRefreshInProgress = true
        
        if refreshMode != DCRRefreshMode.TAKE_SERVER_DATA
        {
            getDCRLockLeaves() { (status) in
                if status == SERVER_SUCCESS_CODE
                {
                    self.DCRHeaderAPI(refreshMode: refreshMode, endDate: endDate)
                }
                else
                {
                    let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRLockLeave)
                    self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
                }
            }
        }
        else
        {
            getDCRCalendarDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
                if status == SERVER_SUCCESS_CODE
                {
                    self.getDCRLockLeaves(completion: { (status) in
                        if (status == SERVER_SUCCESS_CODE)
                        {
                            self.DCRHeaderAPI(refreshMode: refreshMode, endDate: endDate)
                        }
                        else
                        {
                            let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCalendarData)
                            self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
                        }
                    })
                }
                else
                {
                    let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCalendarData)
                    self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
                }
            }
        }
    }
    
    func updateInwardQty(operation: String, inwardProductList: [DCRSampleModel]?)
    {
        if (inwardProductList != nil)
        {
            for objInward in inwardProductList!
            {
                DBHelper.sharedInstance.updateInwardQty(productCode: objInward.sampleObj.Product_Code, operation: operation, quantity: objInward.sampleObj.Quantity_Provided)
            }
        }
    }
    
    func updateBatchInwardQty(operation: String, inwardProductList: [DCRSampleBatchModel]?)
    {
        if (inwardProductList != nil)
        {
            for objInward in inwardProductList!
            {
                DBHelper.sharedInstance.updateBatchInwardQty(productCode: objInward.Product_Code, batchNumber: objInward.Batch_Number, operation: operation, quantity: objInward.Quantity_Provided)
            }
        }
    }
    
    func updateChemistInwardQty(operation: String, inwardProductList: [DCRChemistSamplePromotion])
    {
        for objInward in inwardProductList
        {
            DBHelper.sharedInstance.updateInwardQty(productCode: objInward.ProductCode, operation: operation, quantity: objInward.QuantityProvided)
        }
    }
    
    func updateChemistInwardQty(operation: String, inwardProductList: [DCRChemistSamplePromotion]?)
    {
        if (inwardProductList != nil)
        {
            for objInward in inwardProductList!
            {
                DBHelper.sharedInstance.updateInwardQty(productCode: objInward.ProductCode, operation: operation, quantity: objInward.QuantityProvided)
            }
        }
    }
    
    func updateAttendanceDoctorInwardQty(operation: String, inwardProductList: [DCRAttendanceSampleDetailsModel]?)
    {
        if (inwardProductList != nil)
        {
            for objInward in inwardProductList!
            {
                DBHelper.sharedInstance.updateInwardQty(productCode: objInward.Product_Code, operation: operation, quantity: objInward.Quantity_Provided!)
            }
        }
    }

    
    // MARK: - Private functions
    private func DCRHeaderAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRHeaderDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRAccompanistAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRHeaderData)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRAccompanistAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRAccompanistDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRTravalledPlacesAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAccompanistData)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRTravalledPlacesAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRTravelledPlacesV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRDoctorVisitAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRTravelledPlaces)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRDoctorVisitAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRDoctorVisitDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRDoctorAccompanistAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDoctorVisitDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRDoctorAccompanistAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRDoctorAccompanistV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRSampleDetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDoctorAccompanist)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRSampleDetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRSampleDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRDetailProductsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRSampleDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRDetailProductsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRDetailedProductsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRChemistVisitAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDetailedProducts)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRChemistVisitAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistVisitDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistAccompanistAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistVisit)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    //    private func getDCRChemistDayVisitsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    //    {
    //        getDCRChemistsVisits(refreshMode: refreshMode, endDate: endDate) { (status) in
    //            if status == SERVER_SUCCESS_CODE
    //            {
    //                self.getDCRChemistAccompanistAPI(refreshMode: refreshMode, endDate: endDate)
    //            }
    //            else
    //            {
    //                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDayVisits)
    //                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
    //            }
    //        }
    //    }
    
    private func getDCRChemistAccompanistAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistAccompanist(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistSamplePromotionAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistAccompanist)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistSamplePromotionAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistSamplePromotion(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistDetailedProductsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistSamplePromotion)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistDetailedProductsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistDetailedProducts(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistRCPAOwnAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDetailedProductsDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistRCPAOwnAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistRCPAOwn(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistRCPACompetitorAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistRCPAOwnProductDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistRCPACompetitorAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistRCPACompetitor(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistFollowUpsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistRCPACompetitorProductDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistFollowUpsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistFollowUps(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistAttachmentAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDayFollowups)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getDCRChemistAttachmentAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRChemistAttachment(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getPOBOrderDetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDayAttachments)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getPOBOrderDetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getPOBOrderDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getPOBOrderDetailsV63API(refreshMode: refreshMode, endDate: endDate)
                
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDoctorPOB)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func getPOBOrderDetailsV63API(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getPOBOrderDetailsV63(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRRCPADetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistPOB)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRRCPADetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRRCPADetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRFollowUpDetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRRCPADetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRFollowUpDetailsAPI(refreshMode : DCRRefreshMode , endDate : String?)
    {
        getDCRFollowUpDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRAttachmentDetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRRCPADetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
        
    }
    
    private func DCRAttachmentDetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRAttachmentDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRStockiestVisitAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttachmentDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRStockiestVisitAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRStockistVisitDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRExpenseDetailsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRStockiestDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRExpenseDetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRExpenseDetailsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRAttendanceActivitiesAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRExpenseDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRAttendanceActivitiesAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRAttendanceActivitiesV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRUserProductsAPI(refreshMode: refreshMode, endDate: endDate)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttendanceActivities)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRUserProductsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getUserProductsV59(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.AssetAnalyticsDetailsAPI(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRUserProducts)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRUserProducts)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func AssetAnalyticsDetailsAPI(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getAssetAnalyticsDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRCallActivity(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetAnalyticsDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetAnalyticsDetails)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRCallActivity(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRCallActivites(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRMCActivity(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCallActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCallActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRMCActivity(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRMCActivites(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.AttendanceDCRCallActivity(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRMCActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRMCActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func AttendanceDCRCallActivity(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getAttendanceDCRCallActivites(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.AttendanceDCRMCActivity(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceDCRCallActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceDCRCallActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func AttendanceDCRMCActivity(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getAttendanceDCRMCActivites(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRCompetitorDetails(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceDCRMCActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceDCRMCActivity)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    private func DCRCompetitorDetails(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRCompetitorDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.DCRAttendanceSampleDetails(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCompetitor)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCompetitor)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            
        }
    }
    
    private func DCRAttendanceSampleDetails(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getDCRAttendanceSampleDetails(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.TPUnfreezeDates(refreshMode: refreshMode, endDate: endDate)
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttendanceSample)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttendanceSample)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
            
        }
    }
    
    private func TPUnfreezeDates(refreshMode: DCRRefreshMode, endDate: String?)
    {
        getTPUnfreezeDate(refreshMode: refreshMode, endDate: endDate) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.endDCRRefresh()
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TPUnfreezeDates)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
                if(BL_Upload_DCR.sharedInstance.isFromDCRUpload)
                {
                    if BL_MenuAccess.sharedInstance.isInwardAcknowledgementNeededPrivEnable()
                    {
                        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.INWARD_ACKNOWLEDGEMENT_ENFORCEMENT) == PrivilegeValues.YES.rawValue)
                        {
                            showCustomActivityIndicatorView(loadingText: "Loading Inward Details")
                            WebServiceHelper.sharedInstance.getInwardChalanListWithProduct{ (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    removeCustomActivityView()
                                    if(apiObj.list.count > 0)
                                    {
                                        //                                    if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.INWARD_ACKNOWLEDGEMENT_ENFORCEMENT) == PrivilegeValues.YES.rawValue)
                                        //                                    {
                                        //show alert
                                        let alertViewController = UIAlertController(title:alertTitle, message: "You have still pending Inward Acknowledgment.Please acknowledge them to proceed further", preferredStyle: UIAlertControllerStyle.alert)
                                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                                            
                                            self.delegate?.getInwardAlert(statusCode: status, isNavigate: true)
                                            
                                        }
                                        ))
                                        
                                        getAppDelegate().root_navigation.present(alertViewController, animated: true, completion: nil)
                                        // }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            else
            {
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TPUnfreezeDates)
                self.delegate?.getServiceStatus(message: statusMsg, statusCode: status)
            }
        }
    }
    
    func getDCRLockLeaves(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getDCRLockLeaves { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRLockLeavesCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRCalendarDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonStringForHeader(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRCalendarDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRCalendarDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRHeaderDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonStringForHeader(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRHeaderDetailsCallBack(refreshMode: refreshMode, dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRAccompanistDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRAccompanistDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRAccompanistsDetailsCallBack(dataArray: apiResponseObj.list)
                
                self.getDCRAccompanistInheritance(refreshMode: refreshMode, endDate: endDate, completion: { (status) in
                    completion(status)
                })
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    func getDCRAccompanistInheritance(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRAccompanistInheritance(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRAccompanistInheritanceCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRTravelledPlacesV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRTravelledPlacesV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRTravelledPlacesDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRDoctorVisitDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRDoctorVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRDoctorVisitDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRDoctorAccompanistV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRDoctorAccompanistDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRDoctorAccompanistDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRSampleDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRSampleDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRSampleDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRDetailedProductsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRDetailedProductsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRDetailedProductsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistVisitDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getChemistsVisitCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRRCPADetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRRCPADetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRRCPADetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRFollowUpDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCustomerFollowUpDetails(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRFollowUPDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    
    private func getDCRAttachmentDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRAttachmentDetails(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.deleteWebAttachments()
                
                if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                {
                    for dict in apiResponseObj.list
                    {
                        let dictionary = dict as! NSDictionary
                        let apiDCRCode = dictionary.value(forKey: "DCR_Code") as! String
                        var dcrId: Int = 0
                        let dcrdetails = DBHelper.sharedInstance.getDCRDetails(dcrCode: apiDCRCode)
                        if dcrdetails.count > 0
                        {
                            dcrId = dcrdetails[0].DCR_Id
                        }
                        let mutableDict : NSMutableDictionary = [:]
                        mutableDict.addEntries(from: dictionary as! [AnyHashable : Any])
                        mutableDict.setValue(dcrId, forKey: "DCR_Id")
                        DBHelper.sharedInstance.insertDCRAttachment(dict: mutableDict)
                    }
                }
                
                //self.getDCRAttachmentDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRStockistVisitDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRStockistVisitDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRStockistVisitDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRExpenseDetailsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRExpenseDetailsV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRExpenseDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRAttendanceActivitiesV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRTimesheetEntryV59(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRAttendanceActivitiesCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getUserProductsV59(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getUserProductsV59 { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getUserProductsCallBack(apiResponseObj: apiResponseObj)
            }
            
            completion(statusCode!)
        }
    }
    
    func getTPUnfreezeDate(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerUnfreezeDates(masterDataGroupName: EMPTY) { (status) in
            completion(status)
        }
    }
    func getDCRCallActivitesInReport(startDate:String,regionCode: String ,userCode: String ,completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonStringForDoctorPOB(startDate: startDate, regionCode: regionCode, userCode: userCode, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                completion(apiResponseObj)
            }
            
            completion(apiResponseObj)
        }
    }
    
    func getDCRMCActivitesInReport(startDate:String,regionCode: String ,userCode: String ,completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonStringForDoctorPOB(startDate: startDate, regionCode: regionCode, userCode: userCode, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                completion(apiResponseObj)
            }
            
            completion(apiResponseObj)
        }
    }
    
    func getAttendanceDCRCallActivitesInReport(startDate:String,regionCode: String ,userCode: String ,completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonStringForDoctorPOB(startDate: startDate, regionCode: regionCode, userCode: userCode, flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                completion(apiResponseObj)
            }
            
            completion(apiResponseObj)
        }
    }
    
    func getAttendanceDCRMCActivitesInReport(startDate:String,regionCode: String ,userCode: String ,completion: @escaping (ApiResponseModel) -> ())
    {
        let postJsonString = getPostJsonStringForDoctorPOB(startDate: startDate, regionCode: regionCode, userCode: userCode, flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                completion(apiResponseObj)
            }
            
            completion(apiResponseObj)
        }
    }
    
   func getDCRCallActivitesInPrepare(completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
               // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALL_ACTIVITY)
                DBHelper.sharedInstance.deletDCRActivityDetails(entityType: sampleBatchEntity.Doctor.rawValue)
                var dcrActivitylist : [DCRActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_code":dict["Visit_code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Customer_Activity_ID":dict["Customer_Activity_ID"]!,"Activity_Name":dict["Activity_Name"]!,"Activity_Remarks":dict["Activity_Remarks"]!,"Entity_Type":sampleBatchEntity.Doctor.rawValue]
                    let dcrActivityObj = DCRActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                // DBHelper.sharedInstance.insertDCRCallActivity(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
     func getDCRMCActivitesInPrepare(completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
               // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_MC_ACTIVITY)
                DBHelper.sharedInstance.deletDCRMCActivityDetails(entityType: sampleBatchEntity.Doctor.rawValue)
                
                var dcrActivitylist : [DCRMCActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_Code":dict["Visit_code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Campaign_Code":dict["Campaign_Code"]!,"Campaign_Name":dict["Campaign_Name"]!,"MC_Activity_Id":dict["MC_Activity_Id"]!,"Activity_Name":dict["Activity_Name"]!,"MC_Remark":dict["MC_Remark"]!,"Entity_Type":sampleBatchEntity.Doctor.rawValue]
                    
                    let dcrActivityObj = DCRMCActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                //DBHelper.sharedInstance.insertDCRMCCallActivityList(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRMCCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRCallActivites(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
               // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALL_ACTIVITY)
                DBHelper.sharedInstance.deletDCRActivityDetails(entityType: sampleBatchEntity.Doctor.rawValue)
                
                var dcrActivitylist : [DCRActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_code":dict["Visit_code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Customer_Activity_ID":dict["Customer_Activity_ID"]!,"Activity_Name":dict["Activity_Name"]!,"Activity_Remarks":dict["Activity_Remarks"]!,"Entity_Type":sampleBatchEntity.Doctor.rawValue]
                    let dcrActivityObj = DCRActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
               // DBHelper.sharedInstance.insertDCRCallActivity(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRMCActivites(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
              //  DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_MC_ACTIVITY)
                
                DBHelper.sharedInstance.deletDCRMCActivityDetails(entityType: sampleBatchEntity.Doctor.rawValue)
                
                var dcrActivitylist : [DCRMCActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_Code":dict["Visit_code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Campaign_Code":dict["Campaign_Code"]!,"Campaign_Name":dict["Campaign_Name"]!,"MC_Activity_Id":dict["MC_Activity_Id"]!,"Activity_Name":dict["Activity_Name"]!,"MC_Remark":dict["MC_Remark"]!,"Entity_Type":sampleBatchEntity.Doctor.rawValue]
                    
                    let dcrActivityObj = DCRMCActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                //DBHelper.sharedInstance.insertDCRMCCallActivityList(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRMCCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    func getAttendanceDCRCallActivitesInPrepare(completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALL_ACTIVITY)
                DBHelper.sharedInstance.deletDCRActivityDetails(entityType: sampleBatchEntity.Attendance.rawValue)
                var dcrActivitylist : [DCRActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_code":dict["DCR_Doctor_Visit_Code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Customer_Activity_ID":dict["Customer_Activity_ID"]!,"Activity_Name":dict["Activity_Name"]!,"Activity_Remarks":dict["Activity_Remarks"]!,"Entity_Type":sampleBatchEntity.Attendance.rawValue]
                    let dcrActivityObj = DCRActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                // DBHelper.sharedInstance.insertDCRCallActivity(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    func getAttendanceDCRMCActivitesInPrepare(completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_MC_ACTIVITY)
                DBHelper.sharedInstance.deletDCRMCActivityDetails(entityType: sampleBatchEntity.Attendance.rawValue)
                
                var dcrActivitylist : [DCRMCActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_Code":dict["DCR_Doctor_Visit_Code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Campaign_Code":dict["Campaign_Code"]!,"Campaign_Name":dict["Campaign_Name"]!,"MC_Activity_Id":dict["MC_Activity_Id"]!,"Activity_Name":dict["Activity_Name"]!,"MC_Remark":dict["MC_Remark"]!,"Entity_Type":sampleBatchEntity.Attendance.rawValue]
                    
                    let dcrActivityObj = DCRMCActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                //DBHelper.sharedInstance.insertDCRMCCallActivityList(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRMCCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getAttendanceDCRCallActivites(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRCallActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                // DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALL_ACTIVITY)
                DBHelper.sharedInstance.deletDCRActivityDetails(entityType: sampleBatchEntity.Attendance.rawValue)
                
                var dcrActivitylist : [DCRActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_code":dict["DCR_Doctor_Visit_Code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Customer_Activity_ID":dict["Customer_Activity_ID"]!,"Activity_Name":dict["Activity_Name"]!,"Activity_Remarks":dict["Activity_Remarks"]!,"Entity_Type":sampleBatchEntity.Attendance.rawValue]
                    let dcrActivityObj = DCRActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                // DBHelper.sharedInstance.insertDCRCallActivity(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getAttendanceDCRMCActivites(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: attendanceFlag)
        
        WebServiceHelper.sharedInstance.getAttendanceDCRMCActivities(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                //  DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_MC_ACTIVITY)
                
                DBHelper.sharedInstance.deletDCRMCActivityDetails(entityType: sampleBatchEntity.Attendance.rawValue)
                
                var dcrActivitylist : [DCRMCActivityCallType] = []
                
                for obj in apiResponseObj.list
                {
                    let dict = obj as! Dictionary<String,Any>
                    
                    let CategoryData:NSDictionary = ["DCR_Id":0,"DCR_Code":dict["DCR_Code"]!,"DCR_Customer_Visit_Id":0,"Visit_code":dict["DCR_Doctor_Visit_Code"]!,"Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Campaign_Code":dict["Campaign_Code"]!,"Campaign_Name":dict["Campaign_Name"]!,"MC_Activity_Id":dict["MC_Activity_Id"]!,"Activity_Name":dict["Activity_Name"]!,"MC_Remark":dict["MC_Remark"]!,"Entity_Type":sampleBatchEntity.Attendance.rawValue]
                    
                    let dcrActivityObj = DCRMCActivityCallType(dict: CategoryData)
                    dcrActivitylist.append(dcrActivityObj)
                }
                
                //DBHelper.sharedInstance.insertDCRMCCallActivityList(array: apiResponseObj.list)
                DBHelper.sharedInstance.insertDCRMCCallActivityList(array: dcrActivitylist)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRCompetitorDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCompetitor(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.insertDCRCompetitorDetails(array: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRAttendanceSampleDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonStringForHeader(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRAttendanceSample(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                DAL_DCR_Attendance.sharedInstance.insertDCRAttendanceDoctorDetails(array: apiResponseObj.list)
                for obj in apiResponseObj.list
                {
                    let doctorObj = obj as! NSDictionary
                    let sampleList = doctorObj.value(forKey: "lstAttendanceSamplesDetails") as! NSArray
                    DAL_DCR_Attendance.sharedInstance.insertDCRAttendanceSampleDetails(array: sampleList)
                    self.getDCRSampleBatchCallBackDetailsAttendance(dataArray: sampleList, entityType: sampleBatchEntity.Attendance.rawValue)
                }
            }
            
            completion(statusCode!)
        }
    }
    
    func getDCRCompetitorDetailsInPrepare(completion: @escaping (Int) -> ())
    {
        
        let postJsonString = getPostJsonStringForHeader(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getDCRCompetitor(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                DBHelper.sharedInstance.insertDCRCompetitorDetails(array: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    
    func getDCRAttendanceSampleDetailsInPrepare(completion: @escaping (Int) -> ())
    {
        
        let postJsonString = getPostJsonStringForHeader(refreshMode: DCRRefreshMode.EMPTY, endDate: "", flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getDCRAttendanceSample(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
             if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                DAL_DCR_Attendance.sharedInstance.insertDCRAttendanceDoctorDetails(array: apiResponseObj.list)
                for obj in apiResponseObj.list
                {
                    let doctorObj = obj as! NSDictionary
                    let sampleList = doctorObj.value(forKey: "lstAttendanceSamplesDetails") as! NSArray
                    DAL_DCR_Attendance.sharedInstance.insertDCRAttendanceSampleDetails(array: sampleList)
                }
            }
            
            completion(statusCode!)
        }
    }
    
    
    //MARK:- eDetailing service call
    private func getAssetAnalyticsDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: EMPTY)
        
        WebServiceHelper.sharedInstance.getAssetAnalyticsDetail(postData: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if statusCode == SERVER_SUCCESS_CODE
            {
                if (apiResponseObj.list != nil && apiResponseObj.list.count > 0)
                {
                    let dict = apiResponseObj.list.firstObject as! NSDictionary
                    UserDefaults.standard.setValue((dict.object(forKey: "Max_Customer_Detailed_Id") as? Int), forKey: "Max_Detailed_Id")
                    let deletailedDBId = DBHelper.sharedInstance.getMaxCustomerDetailedId()
                    var detailedId : Int = 0
                    
                    if let detailId = UserDefaults.standard.object(forKey: "Max_Detailed_Id") as? Int
                    {
                        if deletailedDBId != nil
                        {
                            if detailId > deletailedDBId!
                            {
                                detailedId = detailId
                            }
                            else
                            {
                                detailedId = deletailedDBId!
                            }
                        }
                    }
                    else if deletailedDBId != nil
                    {
                        detailedId = deletailedDBId!
                    }
                    var getDateList : [String] = []
                    for modelObj in apiResponseObj.list
                    {
                        if let dict = modelObj as? NSDictionary
                        {
                            let dateString = dict.value(forKey: "Detailed_DateTime") as! String
                            let convertedDate = getDateAndTimeFormatWithoutMilliSecond(dateString: dateString)
                            let convertedDateString = convertDateIntoServerStringFormat(date: convertedDate)
                            if !getDateList.contains(convertedDateString)
                            {
                                getDateList.append(convertedDateString)
                                DBHelper.sharedInstance.deleteAnalyticsByDCRDate(dcrDate: convertedDateString)
                            }
                            
                            let assetObj = AssetAnalyticsDetail(dict: dict)
                            detailedId += 1
                            assetObj.Customer_Detailed_Id = detailedId
                            assetObj.Detailed_DateTime = convertedDateString
                            if let playerStartTime = dict.value(forKey: "Player_Start_Time") as? Int
                            {
                                assetObj.Player_StartTime = "\(playerStartTime)"
                            }
                            else
                            {
                                assetObj.Player_StartTime = ""
                            }
                            if let playerEndTime = dict.value(forKey: "Player_End_Time") as? Int
                            {
                                assetObj.Player_EndTime = "\(playerEndTime)"
                            }
                            else
                            {
                                assetObj.Player_EndTime = ""
                            }
                            _ = DBHelper.sharedInstance.insertAssetAnalytics(assetObj: assetObj)
                        }
                    }
                }
                
                completion(statusCode!)
            }
            else
            {
                completion(statusCode!)
            }
        }
    }
    
    //MARK:- CHemistDay
    private func getDCRChemistAccompanist(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayAccompanist(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistAccompanistCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistSamplePromotion(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDaySamplePromotion(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistSamplePromotionCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistDetailedProducts(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayDetailedproducts(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistDetailedProductDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistRCPAOwn(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayRCPAOwn(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistRCPAOwnProductDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistRCPACompetitor(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayRCPACompetitor(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistRCPACompetitorProductDetailsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistFollowUps(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayFollowups(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistDayFollowupsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistAttachment(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getChemistDayAttachments(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getDCRChemistDayAttachmentsCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getDCRChemistsVisits(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        //let postJsonString = getPostJsonString(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        //        WebServiceHelper.sharedInstance.getChemistsVisits(jsonString: postJsonString) { (apiResponseObj) in
        //            let statusCode = apiResponseObj.Status
        //
        //            if (statusCode ==  SERVER_SUCCESS_CODE)
        //            {
        //                self.getChemistsVisitCallBack(dataArray: apiResponseObj.list)
        //            }
        //
        //            completion(statusCode!)
        //        }
        WebServiceHelper.sharedInstance.getDCRChemistVisitDetails{ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getChemistsVisitCallBack(dataArray: apiResponseObj.list)
            }
            
            completion(statusCode!)
        }
        
    }
    
    private func getPOBOrderDetails(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonStringForPOB(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getPOBOrderDetails(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getPOBOrderCallBack(dataArray: apiResponseObj.list, isChemist: false)
            }
            
            completion(statusCode!)
        }
    }
    
    private func getPOBOrderDetailsV63(refreshMode: DCRRefreshMode, endDate: String?, completion: @escaping (Int) -> ())
    {
        let postJsonString = getPostJsonStringForPOB(refreshMode: refreshMode, endDate: endDate, flag: fieldFlag)
        
        WebServiceHelper.sharedInstance.getPOBOrderDetailsV63(jsonString: postJsonString) { (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode ==  SERVER_SUCCESS_CODE)
            {
                self.getPOBOrderCallBack(dataArray: apiResponseObj.list, isChemist: true)
            }
            
            completion(statusCode!)
        }
    }
    
    
    private func endDCRRefresh()
    {
        BL_UploadAnalytics.sharedInstance.dcrRefreshInProgress = false
        BL_UploadFeedback.sharedInstance.dcrRefreshInProgress = false
        BL_UploadDoctorVisitFeedback.sharedInstance.dcrRefreshInProgress = false
        
        BL_PrepareMyDevice.sharedInstance.updateDCRIdsForNewlyDownloadedDCRs()
        
        let uniqueDCRDates = DBHelper.sharedInstance.getUniqueDCRDates()
        var headerList: [DCRHeaderModel] = []
        
        for row in uniqueDCRDates
        {
            let date = row["DCR_Actual_Date"] as! String
            let dateArray = date.components(separatedBy: " ")
            
            let dict: NSDictionary = ["DCR_Actual_Date": dateArray.first!, "Flag": 0]
            let objDCRHeaderObj: DCRHeaderModel = DCRHeaderModel(dict: dict)
            
            headerList.append(objDCRHeaderObj)
        }
        
        updateDCRCalendarHeader(uniqueDCRDates: headerList)
        
//        let inwardProductList = getInwardCountGivenInAllDCRs()
//
//        let batchInwardProdutList = getBatchInwardCountGivenInAllDCRs()
//
//        updateInwardQty(operation: "-", inwardProductList: inwardProductList)
//
//        updateBatchInwardQty(operation: "-", inwardProductList: batchInwardProdutList)
        
        updateProductCurrentStock()
        
        removeCustomActivityView()
        
        if (uploadAnalyticsDuringDCRRefresh)
        {
            showCustomActivityIndicatorView(loadingText: "Please wait...")
            BL_UploadAnalytics.sharedInstance.checkAnalyticsStatus()
        }
    }
    
    func updateProductCurrentStock() //both samples and batch
    {
        let inwardProductList = getInwardCountGivenInAllDCRs()
        
        let batchInwardProdutList = getBatchInwardCountGivenInAllDCRs()
        
        updateInwardQty(operation: "-", inwardProductList: inwardProductList)
        
        updateBatchInwardQty(operation: "-", inwardProductList: batchInwardProdutList)
    }
    
    private func getErrorMessageForStatus(statusCode: Int, dataName: String) -> String
    {
        if (statusCode == SERVER_SUCCESS_CODE)
        {
            return "Download completed"
        }
        else if (statusCode == SERVER_ERROR_CODE)
        {
            return "Server error while downloading \(dataName) data. Please try again"
        }
        else if (statusCode == NO_INTERNET_ERROR_CODE)
        {
            return "Internet connection error. Please try again"
        }
        else if (statusCode == LOCAL_ERROR_CODE)
        {
            return "Unable to process \(dataName) data. Please try again"
        }
        else
        {
            return ""
        }
    }
    
    private func getPostJsonStringForHeader(refreshMode: DCRRefreshMode, endDate: String?, flag: String) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = getUserCode()
        dcrParameterModelObj.RegionCode = getRegionCode()
        dcrParameterModelObj.Flag = flag
        
        if (refreshMode == DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA)
        {
            let calendarHeaderObj = DBHelper.sharedInstance.getCalendarStartDate()
            
            dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: calendarHeaderObj!.Activity_Date_In_Date)
            dcrParameterModelObj.EndDate = endDate!
            dcrParameterModelObj.DCRStatus = "0,3,"
        }
        else
        {
            dcrParameterModelObj.StartDate = ""
            dcrParameterModelObj.EndDate = ""
            dcrParameterModelObj.DCRStatus = "ALL"
        }
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        
        return jsonString
    }
    
    private func getPostJsonString(refreshMode: DCRRefreshMode, endDate: String?, flag: String) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = getUserCode()
        dcrParameterModelObj.RegionCode = getRegionCode()
        dcrParameterModelObj.Flag = flag
        
        if (refreshMode == DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA)
        {
            let calendarHeaderObj = DBHelper.sharedInstance.getCalendarStartDate()
            
            dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: calendarHeaderObj!.Activity_Date_In_Date)
            dcrParameterModelObj.EndDate = endDate!
            dcrParameterModelObj.DCRStatus = "0,3,"
        }
        else
        {
            dcrParameterModelObj.StartDate = ""
            dcrParameterModelObj.EndDate = ""
            dcrParameterModelObj.DCRStatus = "ALL"
        }
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        return jsonString
    }
    
    private func getPostJsonStringForPOB(refreshMode: DCRRefreshMode, endDate: String?, flag: String) -> String
    {
        let dcrParameterModelObj = DCRParameterPOB()
        
        dcrParameterModelObj.Company_Code = getCompanyCode()
        dcrParameterModelObj.User_Code = getUserCode()
        dcrParameterModelObj.Region_Code = getRegionCode()
        dcrParameterModelObj.Flag = flag
        
        if (refreshMode == DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA)
        {
            // let calendarHeaderObj = DBHelper.sharedInstance.getCalendarStartDate()
            
            //            dcrParameterModelObj.StartDate = convertDateIntoServerStringFormat(date: calendarHeaderObj!.Activity_Date_In_Date)
            //            dcrParameterModelObj.EndDate = endDate!
            dcrParameterModelObj.Order_Status = "ALL"
        }
        else
        {
            //            dcrParameterModelObj.StartDate = ""
            //            dcrParameterModelObj.EndDate = ""
            dcrParameterModelObj.Order_Status = "ALL"
        }
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringifyforPob(json: dcrParameterModelObj)
        return jsonString
    }
    
    private func getPostJsonStringForDoctorPOB(startDate: String?,regionCode: String ,userCode: String, flag: String) -> String
    {
        let dcrParameterModelObj = DCRParameterV59()
        
        dcrParameterModelObj.CompanyCode = getCompanyCode()
        dcrParameterModelObj.UserCode = userCode
        dcrParameterModelObj.RegionCode = regionCode
        dcrParameterModelObj.Flag = flag
        
        if(startDate != nil)
        {
            dcrParameterModelObj.StartDate = startDate!
            dcrParameterModelObj.EndDate = startDate!
            dcrParameterModelObj.DCRStatus = "ALL"
        }
        
        //let jsonString = JSONSerializer.toJson(dcrParameterModelObj)
        let jsonString = stringify(json: dcrParameterModelObj)
        
        return jsonString
    }
    
    func getDCRLockLeavesCallBack(dataArray: NSArray)
    {
//        DBHelper.sharedInstance.updateAllLockLeaveInDCRCalendar()
//
//        if (dataArray.count > 0)
//        {
//            for obj in dataArray
//            {
//                let dict = obj as! NSDictionary
//                let activityDate = dict.value(forKey: "Activity_Date") as! String
//                let lockLeave = dict.value(forKey: "Is_LockLeave") as! Int
//
//                DBHelper.sharedInstance.updateLockLeaveInDCRCalendar(activityDate: activityDate, lockLeave: lockLeave)
//            }
//        }
        
        DBHelper.sharedInstance.updateAllLockLeaveInDCRCalendar()
        
        if (dataArray.count > 0)
        {
            var uniqueDateList: [String] = []
            
            for obj in dataArray
            {
                let dict = obj as! NSDictionary
                let date = dict.value(forKey: "Activity_Date") as! String
                
                if (!uniqueDateList.contains(date))
                {
                    uniqueDateList.append(date)
                }
            }
            
            for date in uniqueDateList
            {
                let predicate = NSPredicate(format: "Activity_Date == %@", date)
                let filteredArray = dataArray.filtered(using: predicate) as! NSArray
                
                if (filteredArray.count > 0)
                {
                    var fieldValue = 0
                    var attendanceValue = 0
                    var lockLeave = 0
                    
                    for obj in filteredArray
                    {
                        let filteredDict = obj as! NSDictionary
                        
                        if (filteredDict.value(forKey: "Flag") as! String == "F")
                        {
                            fieldValue = filteredDict.value(forKey: "Is_LockLeave") as! Int
                        }
                        else if (filteredDict.value(forKey: "Flag") as! String == "A")
                        {
                            attendanceValue = filteredDict.value(forKey: "Is_LockLeave") as! Int
                        }
                        else if (filteredDict.value(forKey: "Flag") as! String == "X")
                        {
                            lockLeave = filteredDict.value(forKey: "Is_LockLeave") as! Int
                        }

                    }
                    
                    DBHelper.sharedInstance.updateLockLeaveInDCRCalendar(activityDate: date, attendanceLock: attendanceValue, fieldLock: fieldValue, lockLeave:lockLeave)
                }
            }
        }

    }
    
    private func getDCRHeaderDetailsCallBack(refreshMode: DCRRefreshMode, dataArray: NSArray)
    {
        if (refreshMode == DCRRefreshMode.MERGE_LOCAL_AND_SERVER_DATA || refreshMode == DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA)
        {
            if (dataArray.count > 0)
            {
                for obj in dataArray
                {
                    let dict = obj as! NSDictionary
                    
                    let serverObj: DCRHeaderModel = DCRHeaderModel(dict: dict)
                    let localDCRHeaderList = DBHelper.sharedInstance.getDCRHeaderByDCRDate(dcrActualDate: getServerFormattedDateString(date: serverObj.DCR_Actual_Date))
                    
                    if (localDCRHeaderList != nil)
                    {
                        if (localDCRHeaderList!.count > 0)
                        {
                            if (localDCRHeaderList!.count == 1)
                            {
                                if (localDCRHeaderList![0].Flag == serverObj.Flag)
                                {
                                    deleteDCR(dcrHeaderObj: localDCRHeaderList![0], isCalledFromDCRRefresh: true)
                                }
                                else
                                {
                                    var shouldDeleteDCR: Bool = false
                                    
                                    if (BL_DCR_Leave.sharedInstance.isMultipleActiviesAllowedForADate())
                                    {
                                        if (serverObj.Flag == DCRFlag.leave.rawValue || localDCRHeaderList![0].Flag == DCRFlag.leave.rawValue)
                                        {
                                            if (BL_DCR_Leave.sharedInstance.isHalfADayLeaveAllowed() == false)
                                            {
                                                shouldDeleteDCR = true
                                            }
                                        }
                                    }
                                    else
                                    {
                                        shouldDeleteDCR = true
                                    }
                                    
                                    if (shouldDeleteDCR)
                                    {
                                        deleteDCR(dcrHeaderObj: localDCRHeaderList![0], isCalledFromDCRRefresh: true)
                                    }
                                }
                            }
                            else // Two activities for the same date in local
                            {
                                let filteredArray = localDCRHeaderList!.filter{
                                    $0.Flag == serverObj.Flag
                                }
                                
                                if (filteredArray.count == 0)
                                {
                                    for filterObj in localDCRHeaderList!
                                    {
                                        deleteDCR(dcrHeaderObj: filterObj, isCalledFromDCRRefresh: true)
                                    }
                                }
                                else
                                {
                                    deleteDCR(dcrHeaderObj: filteredArray[0], isCalledFromDCRRefresh: true)
                                }
                            }
                        }
                    }
                }
                
                insertDCRHeader(dataArray: dataArray)
            }
        }
        else if (refreshMode == DCRRefreshMode.TAKE_SERVER_DATA)
        {
            DBHelper.sharedInstance.deleteAllDCRData()
            
            insertDCRHeader(dataArray: dataArray)
        }
    }
    
    func deleteDCR(dcrHeaderObj: DCRHeaderModel, isCalledFromDCRRefresh: Bool)
    {
        if (dcrHeaderObj.Flag == DCRFlag.fieldRcpa.rawValue)
        {
            deleteFieldDCRByDCRId(dcrId: dcrHeaderObj.DCR_Id, isCalledFromDCRRefresh: isCalledFromDCRRefresh)
        }
        else if (dcrHeaderObj.Flag == DCRFlag.attendance.rawValue)
        {
            deleteAttendanceDCRByDCRId(dcrId: dcrHeaderObj.DCR_Id, isCalledFromDCRRefresh: isCalledFromDCRRefresh)
        }
        else if (dcrHeaderObj.Flag == DCRFlag.leave.rawValue)
        {
            deleteLeaveDCRByDCRId(dcrId: dcrHeaderObj.DCR_Id)
        }
    }
    
    private func deleteFieldDCRByDCRId(dcrId: Int, isCalledFromDCRRefresh: Bool)
    {
        let inwardList = getInwardCountGivenByDCRId(dcrId: dcrId) //DCRChemistSamplePromotion
        
        if (!isCalledFromDCRRefresh)
        {
            updateInwardQty(operation: "+", inwardProductList: inwardList)
        }
        
        let chemistInwardList = DBHelper.sharedInstance.getChemistInwardCountByDCRId(dcrId: dcrId)
        
        if (!isCalledFromDCRRefresh)
        {
            updateChemistInwardQty(operation: "+", inwardProductList: chemistInwardList)
        }
        
        let sampleBatchList = getBatchInwardCountGivenByDCRId(dcrId: dcrId)
        
        if (!isCalledFromDCRRefresh)//Sample Batch
        {
            updateBatchInwardQty(operation: "+", inwardProductList: sampleBatchList)
        }
        
        let getAttachments = DBHelper.sharedInstance.getAttachmentsForDCRId(dcrId: dcrId)
        
        for model in getAttachments
        {
            Bl_Attachment.sharedInstance.deleteAttachmentFile(fileName: model.attachmentName!)
        }
        
//        let chemistAttachmentsList = DBHelper.sharedInstance.getChemistAttachmentsForUpload(dcrId: dcrId)
//        
//        for model in chemistAttachmentsList
//        {
//            Bl_Attachment.sharedInstance.deleteAttachmentFile(fileName: model.UploadedFileName)
//        }
        
        DBHelper.sharedInstance.deleteFieldDCRByDCRId(dcrId: dcrId)
    }
    
    private func deleteAttendanceDCRByDCRId(dcrId: Int, isCalledFromDCRRefresh: Bool)
    {
        let inwardList = getInwardCountGivenForAttendanceDCR(dcrId: dcrId) //DCRChemistSamplePromotion
        
        if (!isCalledFromDCRRefresh)
        {
            var convertedList: [DCRSampleModel] = []
            
            for obj in inwardList
            {
                let sampleProdModel: SampleProductsModel = SampleProductsModel()
                
                sampleProdModel.Product_Code = obj.Product_Code
                sampleProdModel.Quantity_Provided = obj.Quantity_Provided!
                
                let objSample: DCRSampleModel = DCRSampleModel(sampleObj: sampleProdModel)
                
                convertedList.append(objSample)
            }
            
            updateInwardQty(operation: "+", inwardProductList: convertedList)
            
            let sampleBatchList = getBatchInwardCountGivenByDCRId(dcrId: dcrId)
            
            updateBatchInwardQty(operation: "+", inwardProductList: sampleBatchList)
        }
        
        DBHelper.sharedInstance.deleteAttendanceDCRByDCRId(dcrId: dcrId)
    }
    
    private func deleteLeaveDCRByDCRId(dcrId: Int)
    {
        DBHelper.sharedInstance.deleteLeaveDCRByDCRId(dcrId: dcrId)
    }
    
    private func getDCRCalendarDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: TRAN_DCR_CALENDAR_HEADER)
        
        DBHelper.sharedInstance.insertDCRCalendarDetails(array: dataArray)
    }
    
    private func insertDCRHeader(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRHeaderDetails(array: dataArray)
    }
    
    private func getDCRAccompanistsDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRAccompanistsDetails(array: dataArray)
    }
    
    private func getDCRAccompanistInheritanceCallBack(dataArray: NSArray)
    {
        for obj in dataArray
        {
            let dict = obj as! NSDictionary
            let dcrCode = dict.value(forKey: "DCR_Code") as! String
            let accUserCode = dict.value(forKey: "Acc_User_Code") as! String
            let isInherited = dict.value(forKey: "Is_Customer_Data_Inherited") as! Int
            
            DBHelper.sharedInstance.updateDCRInheritanceDoneForAccompanist(userCode: accUserCode, dcrCode: dcrCode, status: isInherited)
        }
    }
    
    private func getDCRTravelledPlacesDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRTravelledPlacesDetails(array: dataArray)
    }
    
    private func getDCRDoctorVisitDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRDoctorVisitDetails(array: dataArray)
    }
    
    private func getDCRDoctorAccompanistDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDoctorAccompanist(dataArray: dataArray)
    }
    
    private func getDCRDetailedProductsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRDetailedProducts(array: dataArray)
    }
    
    private func getDCRSampleDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRSampleDetails(array: dataArray)
        getDCRSampleBatchCallBackDetails(dataArray: dataArray, entityType: sampleBatchEntity.Doctor.rawValue)
    }
    
    private func getDCRSampleBatchCallBackDetails(dataArray: NSArray,entityType:String)
    {
        var visitCode = String()
        if(sampleBatchEntity.Doctor.rawValue == entityType)
        {
            visitCode = "DCR_Visit_Code"
        }
        else if(sampleBatchEntity.Chemist.rawValue == entityType)
        {
            visitCode = "CV_Visit_Id"
        }
        for obj in dataArray
        {
            let sampleObj = obj as! NSDictionary

            let sampleBatchList = sampleObj.value(forKey: "lstuserproductbatch") as! NSArray
            if(sampleBatchList.count > 0)
            {
                var sampleBatchObjList :[DCRSampleBatchModel] = []
                for obj in sampleBatchList
                {
                    let batchObj = obj as! NSDictionary
                    var dict = NSDictionary()
                    if(sampleBatchEntity.Doctor.rawValue == entityType)
                    {
                        dict = ["DCR_Id":sampleObj.value(forKey: "DCR_Id")as?  Int ?? 0,"DCR_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "DCR_Code")as? String),"Visit_Id":sampleObj.value(forKey: "Visit_Id")as? Int ?? 0,"Visit_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: visitCode)as? String),"Ref_Id":-1,"Product_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "Product_Code")as? String),"Batch_Number":batchObj.value(forKey: "Batch_Number") ?? "","Quantity_Provided":batchObj.value(forKey: "Batch_Current_Stock") as?Int ?? 0 ,"Entity_Type":entityType] as NSDictionary
                    }
                    else if(sampleBatchEntity.Chemist.rawValue == entityType)
                    {
                        let vist_Code = sampleObj.value(forKey: visitCode)as? Int ?? 0
                        dict = ["DCR_Id":sampleObj.value(forKey: "DCR_Id")as?  Int ?? 0,"DCR_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "DCR_Code")as? String),"Visit_Id":sampleObj.value(forKey: "Visit_Id")as? Int ?? 0,"Visit_Code": "\(vist_Code)","Ref_Id":-1,"Product_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "Product_Code")as? String),"Batch_Number":batchObj.value(forKey: "Batch_Number") ?? "","Quantity_Provided":batchObj.value(forKey: "Batch_Current_Stock") as?Int ?? 0 ,"Entity_Type":entityType] as NSDictionary
                    }
                    let sampleBatchObj = DCRSampleBatchModel(dict:dict)
                    
                    sampleBatchObjList.append(sampleBatchObj)
                }
                DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList:sampleBatchObjList)
            }
        }
    }
    private func getDCRSampleBatchCallBackDetailsAttendance(dataArray: NSArray,entityType:String)
    {
        
        for obj in dataArray
        {
            let sampleObj = obj as! NSDictionary
            var sampleAttendanceBatchList = NSArray()
            if let sampleBatchList = sampleObj.value(forKey: "lstuserproductbatch") as? NSArray
            {
                sampleAttendanceBatchList = sampleBatchList
            }
            else
            {
                sampleAttendanceBatchList = []
            }
            if(sampleAttendanceBatchList.count > 0)
            {
                var sampleBatchObjList :[DCRSampleBatchModel] = []
                for obj in sampleAttendanceBatchList
                {
                    let batchObj = obj as! NSDictionary
                    let dict = ["DCR_Id":sampleObj.value(forKey: "DCR_Id")as?  Int ?? 0,"DCR_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "DCR_Code")as? String),"Visit_Id":sampleObj.value(forKey: "Visit_Id")as? Int ?? 0,"Visit_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "DCR_Visit_Code")as? String),"Ref_Id":-1,"Product_Code":checkNullAndNilValueForString(stringData:sampleObj.value(forKey: "Product_Code")as? String),"Batch_Number":batchObj.value(forKey: "Batch_Number") ?? "","Quantity_Provided":batchObj.value(forKey: "Batch_Quantity_Provided") as?Int ?? 0 ,"Entity_Type":entityType] as NSDictionary
                    let sampleBatchObj = DCRSampleBatchModel(dict:dict)
                    
                    sampleBatchObjList.append(sampleBatchObj)
                }
                DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList:sampleBatchObjList)
            }
        }
    }
    private func getDCRChemistVisitDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRChemistVisitDetails(array: dataArray)
    }
    
    private func getDCRRCPADetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRRCPADetails(array: dataArray)
    }
    
    private func getDCRFollowUPDetailsCallBack(dataArray : NSArray)
    {
        DBHelper.sharedInstance.insertDCRCustomerFollowUpDetails(array: dataArray)
    }
    
    private func getDCRAttachmentDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRAttachmentDetails(array: dataArray)
    }
    
    private func getDCRStockistVisitDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRStockistVisitDetails(array: dataArray)
    }
    
    private func getDCRExpenseDetailsCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertDCRExpenseDetails(array: dataArray)
    }
    
    private func getDCRAttendanceActivitiesCallBack(dataArray: NSArray)
    {
        DBHelper.sharedInstance.insertAttendanceActivities(array: dataArray)
    }
    
    private func getUserProductsCallBack(apiResponseObj: ApiResponseModel)
    {
        DBHelper.sharedInstance.deleteFromTable(tableName: MST_USER_PRODUCT)
        
        
        BL_PrepareMyDevice.sharedInstance.getUserProductMappingCallBack(apiResponseObj:apiResponseObj, apiName:EMPTY , masterDataGroupName:EMPTY)
       // DBHelper.sharedInstance.insertUserProductMapping(array: dataArray)
    }
    //MARK:- ChemistDay Call Back's
    
    private func getDCRChemistAccompanistCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistAccompanist(array: dataArray)
        }
    }
    
    private func getDCRChemistSamplePromotionCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistSamplePromotion(array: dataArray)
            getDCRSampleBatchCallBackDetails(dataArray: dataArray, entityType: sampleBatchEntity.Chemist.rawValue)
        }
    }
    
    private func getDCRChemistDetailedProductDetailsCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDetailedProductDetails(array: dataArray)
        }
    }
    
    private func getDCRChemistRCPAOwnProductDetailsCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistRCPAOwnProductDetails(array: dataArray)
        }
    }
    
    private func getDCRChemistRCPACompetitorProductDetailsCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistRCPACompetitorProductDetails(array: dataArray)
        }
    }
    
    private func getDCRChemistDayFollowupsCallBack(dataArray: NSArray)
    {
        // Insert new records in table
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDayFollowups(array: dataArray)
        }
    }
    
    private func getDCRChemistDayAttachmentsCallBack(dataArray: NSArray)
    {
        if (dataArray.count > 0)
        {
            DBHelper.sharedInstance.insertDCRDoctorVisitChemistDayAttachments(array: dataArray)
        }
    }
    
    private func getChemistsVisitCallBack(dataArray: NSArray)
    {
        if (dataArray.count > 0)
        {
            let chemistPredicate =
                NSPredicate(format: "DCR_Visit_Code = nil");
            let filteredArray = dataArray.filtered(using: chemistPredicate)
            let doctorPredicate = NSPredicate(format: "DCR_Visit_Code.length > 0");
            let docFilteredArray =  dataArray.filtered(using: doctorPredicate)
            if (docFilteredArray.count > 0)
            {
                DBHelper.sharedInstance.insertDCRChemistVisitDetails(array: docFilteredArray as NSArray)
            }
            if (filteredArray.count > 0)
            {
                DBHelper.sharedInstance.insertChemistDayVisit(array: filteredArray as NSArray)
            }
        }
    }
    
    private func getPOBOrderCallBack(dataArray: NSArray,isChemist: Bool)
    {
        if (dataArray.count > 0)
        {
            self.insertOrderedDetails(array: dataArray, isChemist: isChemist)
        }
    }
    
    func updateDCRCalendarHeader(uniqueDCRDates: [DCRHeaderModel]?)
    {
        let allDCRHeader = DBHelper.sharedInstance.getAllDCRHeader()
        
        if (uniqueDCRDates != nil && allDCRHeader != nil)
        {
            for uniqueDCRHeaderObj in uniqueDCRDates!
            {
                var filteredArray = allDCRHeader!.filter{
                    $0.DCR_Actual_Date == uniqueDCRHeaderObj.DCR_Actual_Date
                }
                
                let activityCount = filteredArray.count
                var dcrStatus: Int!
                
                if (filteredArray.count == 0)
                {
                    dcrStatus = DCRStatus.notEntered.rawValue
                }
                else if (filteredArray.count == 1)
                {
                    dcrStatus = Int(filteredArray[0].DCR_Status)
                }
                else
                {
                    filteredArray = allDCRHeader!.filter{
                        $0.DCR_Actual_Date == uniqueDCRHeaderObj.DCR_Actual_Date && Int($0.DCR_Status) == DCRStatus.unApproved.rawValue
                    }
                    
                    if (filteredArray.count > 0)
                    {
                        dcrStatus = DCRStatus.unApproved.rawValue
                    }
                    else
                    {
                        filteredArray = allDCRHeader!.filter{
                            $0.DCR_Actual_Date == uniqueDCRHeaderObj.DCR_Actual_Date && Int($0.DCR_Status) == DCRStatus.drafted.rawValue
                        }
                        
                        if (filteredArray.count > 0)
                        {
                            dcrStatus = DCRStatus.drafted.rawValue
                        }
                        else
                        {
                            filteredArray = allDCRHeader!.filter{
                                $0.DCR_Actual_Date == uniqueDCRHeaderObj.DCR_Actual_Date && Int($0.DCR_Status) == DCRStatus.applied.rawValue
                            }
                            
                            if (filteredArray.count > 0)
                            {
                                dcrStatus = DCRStatus.applied.rawValue
                            }
                            else
                            {
                                filteredArray = allDCRHeader!.filter{
                                    $0.DCR_Actual_Date == uniqueDCRHeaderObj.DCR_Actual_Date && Int($0.DCR_Status) == DCRStatus.approved.rawValue
                                }
                                
                                if (filteredArray.count > 0)
                                {
                                    dcrStatus = DCRStatus.approved.rawValue
                                }
                                else
                                {
                                    dcrStatus = DCRStatus.notEntered.rawValue
                                }
                            }
                        }
                    }
                }
                
                let dateString = convertDateIntoServerStringFormat(date: uniqueDCRHeaderObj.DCR_Actual_Date)
                
                DBHelper.sharedInstance.updateDCRCalendarHeader(activityDate: dateString, activityCount: activityCount, dcrStatus: dcrStatus)
            }
        }
    }
    
    private func getInwardCountGivenInAllDCRs() -> [DCRSampleModel]?
    {
        return DBHelper.sharedInstance.getInwardCountGivenInAllDCRs()
    }
    
    private func getBatchInwardCountGivenInAllDCRs() -> [DCRSampleBatchModel]?
    {
        return DBHelper.sharedInstance.getBatchInwardCountGivenInAllDCRs()
    }
    
    private func getInwardCountGivenByDCRId(dcrId: Int) -> [DCRSampleModel]?
    {
        return DBHelper.sharedInstance.getInwardCountGivenByDCRId(dcrId: dcrId)
    }
    
    private func getBatchInwardCountGivenByDCRId(dcrId: Int) -> [DCRSampleBatchModel]
    {
        return DBHelper.sharedInstance.getBatchInwardCountGivenByDCRId(dcrId: dcrId)
    }
    
    private func getInwardCountGivenForAttendanceDCR(dcrId: Int) -> [DCRAttendanceSampleDetailsModel]
    {
        return DBHelper.sharedInstance.getInwardCountGivenForAttendanceDCR(dcrId: dcrId)
    }
    
    private func insertOrderedDetails(array : NSArray,isChemist: Bool)
    {
        let orderedList = array
        let orderDetails: NSMutableArray = []
        let remarksList : NSMutableArray = []
        let orderedProductList : NSMutableArray = []
        var customerEntityType: String = Constants.CustomerEntityType.chemist
        
        if !isChemist
        {
            customerEntityType = Constants.CustomerEntityType.doctor
        }
        
        for dict in orderedList
        {
            var combinedAttributes : NSMutableDictionary!
            let orderDict = dict as! NSDictionary
            var orderEntryId : Int?
            let dict1 = ["DCR_Code":orderDict.value(forKey:"DCR_Code"),"DCR_Id":orderDict.value(forKey:"DCR_Id"),"Order_Id":orderDict.value(forKey:"Order_Id"),"Order_Status":orderDict.value(forKey:"Order_Status"),"Order_Mode":orderDict.value(forKey:"Order_Mode"),"Favouring_User_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Favouring_User_Code") as? String),"Favouring_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Favouring_Region_Code") as? String),"Visit_Id":orderDict.value(forKey:"Visit_Id")]
            let dict2 = ["Order_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Date") as? String),"DCR_Actual_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"DCR_Actual_Date") as? String),"Customer_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Code") as? String),"Customer_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Region_Code") as? String),"Customer_Name":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Name") as? String),"Customer_Speciality":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_Speciality") as? String),"Customer_MDLNumber":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_MDLNumber") as? String),"Customer_CategoryCode":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Customer_CategoryCode") as? String)]
            let dict3 = ["Stockiest_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Code") as! String),"Stockiest_Name":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Name") as? String),"Stockiest_Region_Code":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Stockiest_Region_Code") as? String),"Order_Due_Date":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Due_Date") as! String),"Action_Mode":orderDict.value(forKey:"Action_Mode"),"Entity_Type":customerEntityType,"Order_Number":checkNullAndNilValueForString(stringData:orderDict.value(forKey:"Order_Number") as? String)]
            
            
            combinedAttributes = NSMutableDictionary(dictionary: dict1)
            combinedAttributes.addEntries(from: dict2)
            combinedAttributes.addEntries(from: dict3)
            orderDetails.removeAllObjects()
            orderDetails.add(combinedAttributes)
            
            orderedProductList.removeAllObjects()
            remarksList.removeAllObjects()
            
            let headerObj = DCRDoctorVisitPOBHeaderModel(dict: combinedAttributes)
            if headerObj.Order_Status != Constants.OrderStatus.cancelled
            {
                orderEntryId = DBHelper.sharedInstance.insertPOBHeaderDetails(pobObj: headerObj)
                
                let remarksdict: NSDictionary = ["Remarks" : checkNullAndNilValueForString(stringData:orderDict.value(forKey: "Remarks") as? String), "DCR_Code":orderDict.value(forKey:"DCR_Code") as? String ?? EMPTY, "Order_Entry_Id": orderEntryId!]
                remarksList.add(remarksdict)
                
                if let orderedPOBList = (orderDict as AnyObject).object(forKey: "Orderdetails") as? NSArray
                {
                    for obj in orderedPOBList
                    {
                        let detailsDict = obj as! NSDictionary
                        let dict:NSDictionary = ["Order_Entry_Id":orderEntryId!,"DCR_Code":orderDict.value(forKey: "DCR_Code") as? String ?? EMPTY,"DCR_Id":orderDict.value(forKey: "DCR_Id") as? Int ?? 0,"Product_Name":detailsDict.value(forKey: "Product_Name") as! String,"Product_Code":detailsDict.value(forKey: "Product_Code")!,"Product_Qty":detailsDict.value(forKey: "Product_Qty") as? Double ?? 0.0,"Product_Unit_Rate":detailsDict.value(forKey: "Product_Unit_Rate") as? Double ?? 0.0,"Product_Amount":detailsDict.value(forKey: "Product_Amount") as? Double ?? 0.0]
                        orderedProductList.add(dict)
                    }
                }
                
                DBHelper.sharedInstance.insertDCRDoctorVisitOrderDetails(array: orderedProductList as NSArray)
                DBHelper.sharedInstance.insertDCRDoctorVisitOrderRemarksDetails(array: remarksList as NSArray)
            }
        }
    }
}
