//
//  BL_DCR_Doctor_Accompanists.swift
//  HiDoctorApp
//
//  Created by swaasuser on 29/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit


class BL_DCR_Doctor_Accompanists: NSObject
{
    static let sharedInstance : BL_DCR_Doctor_Accompanists = BL_DCR_Doctor_Accompanists()
    
    func getDCRAccompanists() -> [DCRAccompanistModel]
    {
        return DBHelper.sharedInstance.getDCRAccompanists(dcrId:getDcrId())
    }
    
    
    func getDCRAccompanistVandNA() -> [DCRAccompanistModel]
    {
        return DBHelper.sharedInstance.getListOfDCRAccompanistWithoutVandNA(dcrId:getDcrId())!
    }
    
    func insertDCRAccompanistToDoctorAccompanist(dcrAccompanistObj : UserMasterModel, isIndependentCall : String)
    {
        let doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
        
        if doctorVisitList.count > 0
        {
            for obj in doctorVisitList
            {
                let visitId = obj.DCR_Doctor_Visit_Id
                let dcrDoctorAccompanistObj = convertToDCRDoctorAccompanistsModel(dcrAccompanistObj: dcrAccompanistObj, isIndependentCall: isIndependentCall, doctorVisitId:visitId!)
                
                if (dcrDoctorAccompanistObj.Is_Only_For_Doctor == "1")
                {
                    dcrDoctorAccompanistObj.Is_Accompanied = "0"
                }
                
                insertDCRDoctorAccompanist(dcrDoctorAccompanistObj: dcrDoctorAccompanistObj)
            }
        }
    }
    
    func updateDCRDoctorAccompanist(dcrAccompanistObj :DCRAccompanistModel)
    {
        let doctorVisitList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorList()
        
        if doctorVisitList.count > 0
        {
             DBHelper.sharedInstance.updateDCRDoctorAccompanistByDCRId(dcrId: DCRModel.sharedInstance.dcrId, dcrModifyAccompanitsObj: dcrAccompanistObj)
        }
    }
    
    func insertDCRDoctorAccompanists(dcrAccompanistList : [DCRAccompanistModel])
    {
        let dcrDoctorAccompanistList = convertToDCRDoctorAccompanistsModel(dcrAccompanistList: dcrAccompanistList)
        
        if (BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEnabled())
        {
            for objDoctorAccompanist in dcrDoctorAccompanistList
            {
                let filteredArray = dcrAccompanistList.filter{
                    $0.Acc_User_Code! == objDoctorAccompanist.Acc_User_Code! && ($0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status)
                }
                
                if (filteredArray.count > 0)
                {
                    objDoctorAccompanist.Is_Accompanied = "0"
                    objDoctorAccompanist.Is_Only_For_Doctor = "1"
                }
            }
        }
        
        DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanist: dcrDoctorAccompanistList)
    }
    
    func convertToDCRDoctorAccompanistsModel(dcrAccompanistList : [DCRAccompanistModel]) -> [DCRDoctorAccompanist]
    {
        var dcrAccomapnistsDoctorList : [DCRDoctorAccompanist] = []
        var isAccompanied : Int!
        
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.ACCOMPANISTS_VALID_IN_DOC_VISITS) == PrivilegeValues.YES.rawValue)
        {
            isAccompanied = 99
        }
        else
        {
            isAccompanied = 1
        }
        
        for dcrAccompanistsObj in dcrAccompanistList
        {
            let dict: NSDictionary = ["DCR_Id": getDcrId(),"Acc_Region_Code": dcrAccompanistsObj.Acc_Region_Code, "Acc_User_Code": dcrAccompanistsObj.Acc_User_Code!, "Acc_User_Name": dcrAccompanistsObj.Acc_User_Name!, "Acc_User_Type_Name": dcrAccompanistsObj.Acc_User_Type_Name!,"Is_Only_For_Doctor": dcrAccompanistsObj.Is_Only_For_Doctor, "Visit_ID": getDCRDoctorVisitId(),"accompainedCall":isAccompanied]
            
            let dcrAccompanistObj : DCRDoctorAccompanist = DCRDoctorAccompanist(dict: dict)
            
            dcrAccomapnistsDoctorList.append(dcrAccompanistObj)
        }
        
        return dcrAccomapnistsDoctorList
    }
    
    func convertToDCRDoctorAccompanistsModel(dcrAccompanistObj : UserMasterModel,isIndependentCall: String,doctorVisitId : Int) -> DCRDoctorAccompanist
    {
        let dict: NSDictionary = ["DCR_Id": getDcrId(),"Acc_Region_Code": dcrAccompanistObj.Region_Code, "Acc_User_Code": checkNullAndNilValueForString(stringData: dcrAccompanistObj.User_Code), "Acc_User_Name": dcrAccompanistObj.User_Name!, "Acc_User_Type_Name":checkNullAndNilValueForString(stringData: dcrAccompanistObj.User_Type_Name),"Is_Only_For_Doctor": isIndependentCall, "Visit_ID":doctorVisitId,"accompainedCall":1]
        
        let dcrDoctorAccompanistObj : DCRDoctorAccompanist = DCRDoctorAccompanist(dict: dict)
        return dcrDoctorAccompanistObj
    }
    
    func updateDCRDoctorAccompanist(dcrAccompanistList : [DCRAccompanistModel])
    {
        let dcrDoctorAccompanistList = convertToDCRDoctorAccompanistsModel(dcrAccompanistList: dcrAccompanistList)
        DBHelper.sharedInstance.deleteDCRDoctorAccompanists(dcrId: getDcrId(),doctorVisitId : getDCRDoctorVisitId())
        DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanist: dcrDoctorAccompanistList)
    }
    
    func getDCRDoctorAccompanists(doctorVisitId: Int, dcrId: Int) -> [DCRDoctorAccompanist]
    {
        let dcrDoctorAccompanists = DBHelper.sharedInstance.getDCRDoctorAccompanists(dcrId: dcrId, doctorVisitId: doctorVisitId)
        return dcrDoctorAccompanists
    }
    
    func getDCRDoctorAccompanistsByDCRId() -> [DCRDoctorAccompanist]
    {
        let dcrDoctorAccompanists = DBHelper.sharedInstance.getDCRDoctorAccompanists(dcrId: getDcrId())
        return dcrDoctorAccompanists
    }
    
    //    func getDCRSelectedAccompanists() -> [DCRAccompanistModel]
    //    {
    //        let dcrDoctorAccompanists = getDCRDoctorAccompanists()
    //        return dcrDoctorAccompanists
    //    }
    
    func convertToAccompanistModel(list : [DCRDoctorAccompanist]) -> NSMutableArray
    {
        var dcrAccompnistList : NSMutableArray = []
        for obj in list
        {
            dcrAccompnistList.add(obj)
        }
        return dcrAccompnistList
    }
    
    //MARK:-Private Function
    
    private func getDcrId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDcrCode() -> String
    {
        return DCRModel.sharedInstance.dcrCode
    }
    
    private func getDCRDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.doctorVisitId
    }
    
    private func getDCRDoctorVisitCode() -> String
    {
        return DCRModel.sharedInstance.doctorVisitCode
    }
    
    private func insertDCRDoctorAccompanist(dcrDoctorAccompanistObj : DCRDoctorAccompanist)
    {
        DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanistObj: dcrDoctorAccompanistObj)
    }
    
}
