//
//  BL_DCR_Follow_Up.swift
//  HiDoctorApp
//
//  Created by SwaaS on 17/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Follow_Up: NSObject
{
    static let sharedInstance : BL_DCR_Follow_Up = BL_DCR_Follow_Up()
    
    func saveDCRFollowUpDetail(remarksText : String , dueDate : String)
    {
        let dict : NSDictionary = ["Visit_Id" : DCRModel.sharedInstance.doctorVisitId , "DCR_Visit_Code" : checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.doctorVisitCode) , "DCR_Id" : getDcrId() , "DCR_Code" : checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrCode) , "Tasks" : remarksText , "Due_Date" : dueDate]
        
        let followUpDetailDict = DCRFollowUpModel.init(dict: dict)
        
        DBHelper.sharedInstance.insertDCRFollowUpDetail(followUpObj: followUpDetailDict)
    }
    
    func getDCRFollowUpDetails() -> [DCRFollowUpModel]
    {
        return DBHelper.sharedInstance.getDCRFollowUpModel(dcrId: getDcrId(), dcrDoctorVisitId: DCRModel.sharedInstance.doctorVisitId)
    }
    
    func updateDCRFollowUpDetail(followUpObj : DCRFollowUpModel)
    {
        DBHelper.sharedInstance.updateFollowUpDetail(followUpObj: followUpObj)
    }
    
    func deleteFollowUpDetail(followUpObj : DCRFollowUpModel)
    {
        DBHelper.sharedInstance.deleteFollowUpDetail(followUpObj: followUpObj)
    }
    
    //MARK:- ChemistDay FollowUps
    func saveChemistDayFollowUpDetail(remarksText : String , dueDate : String)
    {
        var followupList:[[String:Any]] = []
        
        let dict : [String:Any] = ["DCR_Chemist_Day_Visit_Id" : getChemistVisitId() , "Chemist_Visit_Code" : checkNullAndNilValueForString(stringData: ChemistDay.sharedInstance.chemistVisitCode) , "DCR_Id" : getDcrId() , "DCR_Code" : checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.dcrCode) , "Tasks" : remarksText , "Due_Date" : dueDate,"Chemist_User_Code":ChemistDay.sharedInstance.customerCode,"Chemist_Region_Code":ChemistDay.sharedInstance.regionCode]
        followupList.append(dict)
        
        DBHelper.sharedInstance.insertDCRDoctorVisitChemistDayFollowups(array: followupList as NSArray)
    }
    
    func getChemistFollowUpDetails() -> [DCRChemistFollowup]
    {
        return DBHelper.sharedInstance.getChemistFollowUpModel(dcrId: getDcrId(), chemistVisitId : getChemistVisitId())
    }
    
    func updateChemistFollowUpDetail(followUpObj : DCRChemistFollowup)
    {
        DBHelper.sharedInstance.updateChemistDayFollowUpDetail(followUpObj: followUpObj)
        
    }
    
    func deleteChemistFollowUpDetail(followUpObj : DCRChemistFollowup)
    {
        DBHelper.sharedInstance.deleteDCRChemistFollowUpDetail(followUpObj: followUpObj)
    }
    
    func updateChemistDayFollowups(followUpObj : DCRChemistFollowup)
    {
        DBHelper.sharedInstance.deleteDCRChemistFollowUpDetail(followUpObj: followUpObj)
        DBHelper.sharedInstance.insertDCRChemistFollowups(followup : followUpObj)
        
    }
    func convertDCRChemistFollowupToDCRFollowup(chemistFollowupList: [DCRChemistFollowup]) -> [DCRFollowUpModel]
    {
        var dcrFollowupList : [DCRFollowUpModel] = []
        for obj in chemistFollowupList 
        {
        let dict : [String:Any] = ["Tasks":obj.Task,"Due_Date": convertDateIntoServerStringFormat(date:obj.DueDate),"DCR_Id":obj.DCRId]
        let dcrfollowupObj = DCRFollowUpModel(dict: dict as NSDictionary)
        dcrFollowupList.append(dcrfollowupObj)
        }
        
        return dcrFollowupList
    }

    private func getDcrId() -> Int
    {
       return DCRModel.sharedInstance.dcrId
    }
    
    private func getChemistVisitId() -> Int
    {
        return ChemistDay.sharedInstance.chemistVisitId
    }
}
