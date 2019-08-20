//
//  BL_DeleteDCR.swift
//  HiDoctorApp
//
//  Created by SwaaS on 15/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_DeleteDCR: NSObject
{
    static let sharedInstance = BL_DeleteDCR()
    
    func getDCRHeaderForDeleteDCR(filterArr: [String]) -> [DCRHeaderModel]
    {
        var filterString = ""
        
        for i in 0..<filterArr.count
        {
            filterString += "'" + filterArr[i] + "',"
        }
        
        if (filterString != "")
        {
            filterString = filterString.substring(to: filterString.index(before: filterString.endIndex))
        }
        return DBHelper.sharedInstance.getDCRHeaderForDeleteDCR(dcrStatus: filterString)
    }
    
    func checkDCRExist(dcrDate: String, flag: Int, completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.checkDCRExist(userCode: getUserCode(), dcrDate: dcrDate, flag: flag) { (apiResponseObj) in
            completion(apiResponseObj)
        }
    }
    
    func deleteDCR(dcrHeaderObj: DCRHeaderModel)
    {
        BL_DCR_Refresh.sharedInstance.deleteDCR(dcrHeaderObj: dcrHeaderObj, isCalledFromDCRRefresh: false)
        BL_DCR_Refresh.sharedInstance.updateDCRCalendarHeader(uniqueDCRDates: [dcrHeaderObj])
    }
}
