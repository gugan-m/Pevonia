//
//  BL_WorkPlace.swift
//  HiDoctorApp
//
//  Created by swaasuser on 14/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_WorkPlace: NSObject
{
    static let sharedInstance : BL_WorkPlace = BL_WorkPlace()
    
    // MARK:- Public Functions
    func checkToShowCpDropDown(dcrId: String) -> Bool
    {
        var returnValue: Bool = false
        
        if (getDcrFlag() == DCR_FIELD)
        {
            let userPrevilege = getPrevilegeValueForCP()
            
            if userPrevilege == PrivilegeValues.YES.rawValue || userPrevilege == PrivilegeValues.OPTIONAL.rawValue
            {
                returnValue = true
            }
        }
        
        return returnValue
    }
    
    
    func checkToTPShowCpDropDown(tpEntryID: String) -> Bool
    {
        var returnValue: Bool = false
        
        if (getTPFlag() == TP_FIELD)
        {
            let userPrevilege = getPrevilegeValueForCP()
            
            if userPrevilege == PrivilegeValues.YES.rawValue || userPrevilege == PrivilegeValues.OPTIONAL.rawValue
            {
                returnValue = true
            }
        }
        
        return returnValue
    }
    
    func checkToShowAccompanistListForCP() -> Bool
    {
        var returnValue: Bool = false
        
        if (getDcrFlag() == DCR_FIELD)
        {
            let userPrevilege = getPrevilegeValue(previlegeKey: PrivilegeNames.SHOW_ACCOMPANISTS_DATA.rawValue)
            
            let privArray = userPrevilege.components(separatedBy: ",")
            
            if (privArray.contains(PrivilegeValues.CP.rawValue))
            {
                let accompanistList = getListOfAccompanist()
                
                if accompanistList.count > 0
                {
                    returnValue = true
                }
            }
        }
        
        return returnValue
    }
    
    
    func checkToShowTPAccompanistListForCP() -> Bool
    {
        var returnValue: Bool = false
        
        if (getTPFlag() == TP_FIELD)
        {
            let userPrevilege = getPrevilegeValue(previlegeKey: PrivilegeNames.SHOW_ACCOMPANISTS_DATA.rawValue)
            
            let privArray = userPrevilege.components(separatedBy: ",")
            
            if (privArray.contains(PrivilegeValues.CP.rawValue))
            {
                let accompanistList = getListOfAccompanist()
                
                if accompanistList.count > 0
                {
                    returnValue = true
                }
            }
        }
        
        return returnValue
    }
    
    func getListOfAccompanist() -> [DCRAccompanistModel]
    {
        let accompanistList = DBHelper.sharedInstance.getListOfDCRAccompanist(dcrId: getDcrId())
        return accompanistList!
    }
    
    
    func getListOfTPAccompanist() -> [TourPlannerAccompanist]
    {
        let accompanistList = DBHelper.sharedInstance.getTPAccompanistByTPId(tpId: getTPId())
        return accompanistList
    }
    
    func getCPList(regionCode : String) -> [CampaignPlannerHeader]
    {
        var cpList : [CampaignPlannerHeader] = []
        
        if regionCode != ""
        {
            cpList = DBHelper.sharedInstance.getListOfCpByRegionCode(regionCode: regionCode)!
        }
        
        return cpList
    }
    
    func getWorkCategoriesList() -> [WorkCategories]
    {
        return DBHelper.sharedInstance.getWorkCategoryList()!
    }

    //DCR Staus -1
    func getPrefillDataFromTP() -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTPDate(tpDate: getDcrDate())
    }
    //Prefill Work category  & Work place
    func getCPHeaderByCPCode(cpCode: String) -> CampaignPlannerHeader?
    {
        return DBHelper.sharedInstance.getCPHeaderByCPCode(cpCode: cpCode)
    }
    //DCR  Draft
    func getDCRHeaderDetailForWorkPlace() -> DCRHeaderModel?
    {
        return DBHelper.sharedInstance.getDCRHeaderByDCRId(dcrId: getDcrId())
    }
    func getTPHeaderDetailForWorkPlace() -> TourPlannerHeader?
    {
        return DBHelper.sharedInstance.getTPHeaderByTPEntryId(tpEntryId: getTPId())
    }
    
    //Submit
    func updateDCRWorkPlaceDetail(dcrHeaderModelObj: DCRHeaderObjectModel)
    {
        return DBHelper.sharedInstance.updateDCRWorkPlaceDetail(dcrHeaderObj: dcrHeaderModelObj)
    }
    
    func updateDCRWorkTimeDetail(dcrHeaderModelObj: DCRHeaderObjectModel)
    {
        return DBHelper.sharedInstance.updateDCRWorkTime(startTime: dcrHeaderModelObj.Start_Time!, endTime: dcrHeaderModelObj.End_Time!, dcrId: dcrHeaderModelObj.DCR_Id)
    }
    
    func updateTPWorkPlaceDetail(tpHeaderModelObj: TourPlannerHeaderObjModel)
    {
        return DBHelper.sharedInstance.updateTPWorkPlaceDetail(tpHeaderObj:tpHeaderModelObj)
    }
    
    func getWorkPlaceDetails(date:Date) -> [PlaceMasterModel]
    {
        var workPlaceList : [PlaceMasterModel] = []
        let PlaceList = DBHelper.sharedInstance.getWorkPlaceDetails(date: date)
        for obj in PlaceList!
        {
            let placeObj : PlaceMasterModel = PlaceMasterModel()
            placeObj.placeName = obj.From_Place
            workPlaceList.append(placeObj)
        }
        
        return workPlaceList
    }
    
    func updateCPDetails(cpCode: String?)
    {
        let cpSfcList = DBHelper.sharedInstance.getSFCDetailsforCPCode(cpCode: cpCode!)
        
        if cpSfcList.count > 0
        {
            BL_SFC.sharedInstance.insertCPSFCDetails(cpSFC: cpSfcList)
        }
        
    }
    
    func getDCRStatus() -> Int
    {
        return DCRModel.sharedInstance.dcrStatus
    }
    
    func getTpStatus() -> Int
    {
        return TPModel.sharedInstance.tpStatus
    }
    
    func saveFlexiWorkPlace(placeName : String)
    {
        let dict : NSDictionary = ["Flexi_Place_Name" : placeName]
        let workPlaceDict : FlexiPlaceModel = FlexiPlaceModel(dict: dict)
        DBHelper.sharedInstance.insertFlexiWorkPlace(flexiPlaceObj: workPlaceDict)
    }
    
    func getFlexiWorkPlaceList() -> [FlexiPlaceModel]
    {
        return DBHelper.sharedInstance.getFlexiWorkPlaceList()!
    }
    
    // MARK:- Private Functions
    private func getDcrFlag() -> Int
    {
        return DCRModel.sharedInstance.dcrFlag
    }
    
    private func getDcrId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDcrDate() -> Date
    {
        return DCRModel.sharedInstance.dcrDate
    }
    
    
    private func getTPFlag() -> Int
    {
        return TPModel.sharedInstance.tpFlag
    }
    
    private func getTPId() -> Int
    {
        return TPModel.sharedInstance.tpEntryId
    }
    
    private func getTPDate() -> Date
    {
        return TPModel.sharedInstance.tpDate
    }
    
    private func getPrevilegeValue(previlegeKey : PrivilegeNames.RawValue) -> String
    {
        let userPrevilege = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames(rawValue: previlegeKey)!)
        
        return userPrevilege
    }
    
    func getPrevilegeValueForCP() -> String
    {
        let userPrevilege = getPrevilegeValue(previlegeKey: PrivilegeNames.CAMPAIGN_PLANNER.rawValue)
        
        return userPrevilege
    }
    
    private func convertTimetoValidate(time : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: time)
        return date!
        
    }
    
    func getPrivelegeValueForWorkTime() -> String
    {
        let userPrevilege = getPrevilegeValue(previlegeKey: PrivilegeNames.DCR_WORK_TIME_MANDATORY.rawValue)
        
        return userPrevilege
    }
    
    //MARK: - Validation
    
    func checkIfCPMandatory() -> Bool
    {
         let cpPrivilegeValue = BL_WorkPlace.sharedInstance.getPrevilegeValueForCP()
        if cpPrivilegeValue == PrivilegeValues.YES.rawValue
        {
            return true
        }
            return false
    }
    
    func checkIfCpExistsInMaster(cpCode : String?) -> Bool
    {
        let cpCode = checkNullAndNilValueForString(stringData: cpCode)
        var isExists : Bool = false
        if cpCode != ""
        {
            let cpObj = DBHelper.sharedInstance.getCpDetailsByCpCode(cpCode: cpCode)
            if cpObj != nil
            {
                let cpCode = checkNullAndNilValueForString(stringData: cpObj?.CP_Code)
                if cpCode != ""
                {
                    isExists = true
                }
            }
        }
        return isExists
    }
    
    func checkIfWorkTimeMandatory() -> Bool
    {
        let worktimePrivelege = BL_WorkPlace.sharedInstance.getPrivelegeValueForWorkTime()
        if worktimePrivelege == PrivilegeValues.MANDATORY.rawValue
        {
            return true
        }
        return false
    }
    
    func validateFromToTime(fromTime : String , toTime : String) -> Bool
    {
        let fromDate = convertTimetoValidate(time: fromTime)
        
        let toDate = convertTimetoValidate(time: toTime)
        if fromDate.timeIntervalSince1970 < toDate.timeIntervalSince1970
        {
            return true
        }
        
        return false
    }
    
    func validateExistingFromTime(fromTime: String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeForAssets
        let fromDate = convertTimetoValidate(time: fromTime)
        let timeArray = BL_Stepper.sharedInstance.getCustomerVisitTimeArray()
        if timeArray.count > 0
        {
            let startdateString = dateFormatter.string(from: timeArray.first!)
            let existingFromTime = getTimeIn12HrFormat(date: getDateFromString(dateString: startdateString), timeZone: NSTimeZone.local)
            let existingFromDate = convertTimetoValidate(time: existingFromTime)
            if fromDate.timeIntervalSince1970 > existingFromDate.timeIntervalSince1970
            {
                return true
            }
        }
        return false
    }
    
    func validateExistingToTime(toTime: String) -> Bool
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeForAssets
        let toDate = convertTimetoValidate(time: toTime)
        let timeArray = BL_Stepper.sharedInstance.getCustomerVisitTimeArray()
        if timeArray.count > 0
        {
            let enddateString = dateFormatter.string(from: timeArray.last!)
            let existingToTime = getTimeIn12HrFormat(date: getDateFromString(dateString: enddateString), timeZone: NSTimeZone.local)
            let existingToDate = convertTimetoValidate(time: existingToTime)
            if toDate.timeIntervalSince1970 < existingToDate.timeIntervalSince1970
            {
                return true
            }
        }
        return false
    }

    
    func getWorkCategoryObjByCategoryName(workCategoryName : String) -> WorkCategoresObjectModel?
    {
        let workCategoryList =  getWorkCategoriesList()
        let workCategoryObj: WorkCategoresObjectModel = WorkCategoresObjectModel()
        var categoryName : String = workCategoryName
        if categoryName == ""
        {
            categoryName = defaultWorkCategoryType
        }
        let categoryList = workCategoryList.filter{
            $0.Category_Name == categoryName
        }
        
        if categoryList.count > 0
        {
            workCategoryObj.Category_Id = categoryList.first?.Category_Id
            workCategoryObj.Category_Code = categoryList.first?.Category_Code
            workCategoryObj.Category_Name = categoryList.first?.Category_Name
        }
        
        return workCategoryObj
    }
    
    func getWorkCategoryObjByCategoryId(categoryId : Int) -> WorkCategoresObjectModel?
    {
        let workCategoryList =  getWorkCategoriesList()
        let workCategoryObj: WorkCategoresObjectModel = WorkCategoresObjectModel()
        
        let categoryList = workCategoryList.filter{
            $0.Category_Id == categoryId
        }
        
        if categoryList.count > 0
        {
            let workCategoryObj : WorkCategoresObjectModel = WorkCategoresObjectModel()
            
            workCategoryObj.Category_Id = categoryList.first?.Category_Id
            workCategoryObj.Category_Code = categoryList.first?.Category_Code
            workCategoryObj.Category_Name = categoryList.first?.Category_Name
        }
        
        return workCategoryObj
    }
    
  }
