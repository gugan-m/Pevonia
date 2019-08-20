//
//  UploadMyDCRModels.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class UploadMyDCRModels: NSObject
{
    var checksum: Int!
    var lstDCRMasterStaging: [UploadDCRHeader]!
    var lstDCRAccompanistModel: [UploadDCRAccompanist]!
    var lstTravelledPlaces: [UploadDCRTravelledPlaces]!
    var lstDCRVisitStaging: [UploadDCRDoctorVisit]!
    var lstAccompStaging: [UploadDCRDoctorAccompanist]!
    var lstSampleProductsStaging: [UploadDCRSample]!
    var lstDetailedStaging: [UploadDCRDetailedProducts]!
    var lstChemistStaging: [UploadDCRChemistVisit]!
    var lstRCPAStaging: [UploadDCRRCPADetails]!
    var lstStockiestStaging: [UploadDCRStockistVisit]!
    var lstExpenseStaging: [UploadDCRExpense]!
    var lstTimeSheetActivityStaging: [UploadDCRAttendanceActivities]!
}
