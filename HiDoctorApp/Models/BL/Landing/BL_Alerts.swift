//
//  BL_Alerts.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Alerts: NSObject
{
    static let sharedInstance = BL_Alerts()
    
    
    var noticeBoardUnreadCount : Bool = false
    
    func getAlertsList() -> [LandingAlertModel]
    {
        var alertList: [LandingAlertModel] = []
        
        var objAlert: LandingAlertModel = LandingAlertModel()
        
        objAlert.index = 0
        objAlert.alertTitle = "Message"
        objAlert.imageName = "ic_message"
        
        objAlert.count = 0
        alertList.append(objAlert)
        
        objAlert = LandingAlertModel()
        objAlert.index = 1
        objAlert.alertTitle = "Notice Board"
        objAlert.imageName = "ic_noticeboard_alert"
        objAlert.count = 0
        alertList.append(objAlert)
        
        objAlert = LandingAlertModel()
        objAlert.index = 2
        objAlert.alertTitle = "Birthdays"
        objAlert.imageName = "ic_birthdays"
        objAlert.count = 0
        alertList.append(objAlert)
        
        objAlert = LandingAlertModel()
        objAlert.index = 3
        objAlert.alertTitle = "Anniversaries"
        objAlert.imageName = "ic_anniversaries"
        objAlert.count = 0
        alertList.append(objAlert)
        
        if(BL_MenuAccess.sharedInstance.isInwardAcknowledgementNeededPrivEnable())
        {
            objAlert = LandingAlertModel()
            objAlert.index = 4
            objAlert.alertTitle = "Inward Acknowledgement"
            objAlert.imageName = "icon_inward"
            objAlert.count = 0
            alertList.append(objAlert)
        }
//        if(BL_MenuAccess.sharedInstance.isInChamberEffectivenssAvailable() || BL_MenuAccess.sharedInstance.isTaskAvailabel())
//        {
            objAlert = LandingAlertModel()
            objAlert.index = 5
            objAlert.alertTitle = "Tasks"
            objAlert.imageName = "icon-task"
            objAlert.count = 0
            alertList.append(objAlert)
     //   }
        
        return alertList
    }
    
    func getDates() -> (Date, Date)
    {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: yesterday!)
        
        return (yesterday!, nextWeek!)
    }
    
    func getUnreadNoticeCount(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getUnreadNoticeCount { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func getUnreadMessageCount(completion : @escaping (_ apiResponseObj : ApiResponseModel) -> ())
    {
        WebServiceHelper.sharedInstance.getUnreadMessageCount { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func getBirthdayDoctors() -> [CustomerMasterModel]
    {
        let doctorList = DBHelper.sharedInstance.getBirthdayDoctors()
        return sortDoctorList(doctorList: doctorList)
    }
    
    func getAnniversaryDoctors() -> [CustomerMasterModel]
    {
        let doctorList = DBHelper.sharedInstance.getAnniversaryDoctors()
        return sortDoctorList(doctorList: doctorList)
    }
    
    private func sortDoctorList(doctorList: [CustomerMasterModel]) -> [CustomerMasterModel]
    {
        var resultList: [CustomerMasterModel] = []
        
        let pastDaysList = doctorList.filter{
            $0.indays! > 300
        }
        
        if (pastDaysList.count > 0)
        {
            for objDoctor in pastDaysList
            {
                resultList.append(objDoctor)
            }
        }
        
        let futureDaysList = doctorList.filter{
            $0.indays! < 300
        }
        
        if (futureDaysList.count > 0)
        {
            for objDoctor in futureDaysList
            {
                resultList.append(objDoctor)
            }
        }
        
        return resultList
    }
}

class ChemistSectionListHeaderModel : NSObject
{
    var sectionTitle : String = ""
    var dataList : [CustomerMasterModel] = []
}
