//
//  BL_DCRReject.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_DCRReject: NSObject
{
    static let sharedInstance : BL_DCRReject = BL_DCRReject()
    
    func checkIsRejectPrevilegeEnabled() -> Bool
    {
        var isEnabled : Bool = false
        let privilegeValue = getPreviligeValue().uppercased()
        let privArray = privilegeValue.components(separatedBy: ",")
        
        if privArray.contains(PrivilegeValues.DCR.rawValue.uppercased())
        {
            isEnabled = true
        }
        
        return isEnabled
    }
    
    func getPreviligeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames(rawValue: PrivilegeNames.CAN_UNAPPROVE_AN_APPROVED_ENTRY_OF.rawValue)!)
    }
    
    //MARK:- API Call
    
    func getDCRHeaderDetailsV59Report(userObj: ApprovalUserMasterModel, completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUserPerDayReportPostData(userObj: userObj)
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59Report(postData: postData) { (apiResonseObj) in
            completion(apiResonseObj)
        }
    }
    
    func getUserPerDayReportPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,  "Flag" : "","RegionCode": userObj.Region_Code,"StartDate" : userObj.Actual_Date , "EndDate" : userObj.Entered_Date,"DCRStatus": "2,"]
    }
    
}
