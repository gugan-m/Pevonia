//
//  BL_DCR_Chemist_Accompanist.swift
//  HiDoctorApp
//
//  Created by Vijay on 27/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


class BL_DCR_Chemist_Accompanists: NSObject
{
    static let sharedInstance : BL_DCR_Chemist_Accompanists = BL_DCR_Chemist_Accompanists()
    
    func getDCRAccompanists() -> [DCRAccompanistModel]
    {
        return DBHelper.sharedInstance.getDCRAccompanists(dcrId: getDcrId())
    }
    
    func getDCRAccompanistsVandNA() -> [DCRAccompanistModel]
    {
        return DBHelper.sharedInstance.getListOfDCRAccompanistWithoutVandNA(dcrId: getDcrId())!
    }
    
    
    func insertDCRChemistAccompanists(dcrAccompanistList : [DCRAccompanistModel])
    {
        let dcrChemistAccompanistList = convertToDCRChemistAccompanistsModel(dcrAccompanistList: dcrAccompanistList)
        DBHelper.sharedInstance.insertDCRChemistAccompanist(dcrChemistAccompanist: dcrChemistAccompanistList)
    }
    
    func convertToDCRChemistAccompanistsModel(dcrAccompanistList : [DCRAccompanistModel]) -> [DCRChemistAccompanist]
    {
        var dcrAccomapnistsChemistList : [DCRChemistAccompanist] = []
        var isAccompanied : Int!
        let checkAccompanistValid = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_CHEMIST_VISITS) == PrivilegeValues.YES.rawValue
        
        for dcrAccompanistsObj in dcrAccompanistList
        {
            if (checkAccompanistValid)
            {
                isAccompanied = 99
            }
            else
            {
                isAccompanied = 1
            }
            if(dcrAccompanistsObj.Is_Only_For_Doctor == "1")
            {
                isAccompanied = 0
            }
            let dict: [String:Any] = ["DCR_Id": getDcrId(),"Acc_Region_Code": dcrAccompanistsObj.Acc_Region_Code, "Acc_User_Code": dcrAccompanistsObj.Acc_User_Code!, "Acc_User_Name": dcrAccompanistsObj.Acc_User_Name!, "Acc_User_Type_Name": dcrAccompanistsObj.Acc_User_Type_Name!,"Is_Only_For_Chemist": dcrAccompanistsObj.Is_Only_For_Doctor, "DCR_Chemist_Day_Visit_Id": getDCRChemistVisitId(),"Is_Accompanied_call":isAccompanied]
            
            let dcrAccompanistObj : DCRChemistAccompanist = DCRChemistAccompanist(dict: dict as NSDictionary)
            
            dcrAccomapnistsChemistList.append(dcrAccompanistObj)
        }
        
        return dcrAccomapnistsChemistList
    }
    
   
    func insertDCRAccompanistToChemistAccompanist(dcrAccompanistObj : UserMasterModel,isIndependentCall : String)
    {
        let doctorVisitList = BL_Stepper.sharedInstance.getChemistDayHeaderDetails()
        
        if (doctorVisitList.count > 0)
        {
            for obj in doctorVisitList
            {
                let visitId = obj.DCRChemistDayVisitId
                let dcrDoctorAccompanistObj = convertToDCRChemistAccompanistsModel(dcrAccompanistObj: dcrAccompanistObj, isIndependentCall: isIndependentCall, chemistVisitId:visitId!)
                insertDCRDoctorAccompanist(dcrDoctorAccompanistObj: dcrDoctorAccompanistObj)
            }
        }
    }
    
    func convertToDCRChemistAccompanistsModel(dcrAccompanistObj : UserMasterModel,isIndependentCall: String,chemistVisitId : Int) -> DCRChemistAccompanist
    {
        
        let dict: [String:Any] = ["DCR_Id": getDcrId(),"Acc_Region_Code": dcrAccompanistObj.Region_Code, "Acc_User_Code": checkNullAndNilValueForString(stringData: dcrAccompanistObj.User_Code),"Acc_User_Name": dcrAccompanistObj.User_Name!, "Acc_User_Type_Name":checkNullAndNilValueForString(stringData: dcrAccompanistObj.User_Type_Name),"Is_Only_For_Chemist": isIndependentCall, "DCR_Chemist_Day_Visit_Id": chemistVisitId,"Is_Accompanied_call":1]
        let dcrDoctorAccompanistObj : DCRChemistAccompanist = DCRChemistAccompanist(dict: dict as NSDictionary)
        return dcrDoctorAccompanistObj
    }

    func updateDCRChemistAccompanist(dcrAccompanistObj :DCRAccompanistModel)
    {
        let doctorVisitList = BL_Stepper.sharedInstance.getChemistDayHeaderDetails()
        
        if (doctorVisitList.count > 0)
        {
            DBHelper.sharedInstance.updateDCRChemistAccompanistByDCRId(dcrId: DCRModel.sharedInstance.dcrId, dcrModifyAccompanitsObj: dcrAccompanistObj)
        }
    }

    func insertDCRDoctorAccompanist(dcrDoctorAccompanistObj : DCRChemistAccompanist)
    {
        DBHelper.sharedInstance.insertDCRChemistAccompanist(dcrChemistAccompanist: [dcrDoctorAccompanistObj])
    }
    
    func getDCRChemistAccompanists(chemistVisitId: Int, dcrId: Int) -> [DCRChemistAccompanist]
    {
        let dcrChemistAccompanists = DBHelper.sharedInstance.getDCRChemistAccompanists(dcrId: dcrId, chemistVisitId: chemistVisitId)
        return dcrChemistAccompanists
    }
    
    private func getDcrId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    private func getDCRChemistVisitId() -> Int
    {
        return ChemistDay.sharedInstance.chemistVisitId
    }
}

