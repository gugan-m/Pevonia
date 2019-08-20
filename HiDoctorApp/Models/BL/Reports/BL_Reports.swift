//
//  BL_Reports.swift
//  HiDoctorApp
//
//  Created by SwaaS on 16/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Reports: NSObject
{
    static let sharedInstance = BL_Reports()
    var doctorVisitId : Int!
    
    //MARK:- Public Functions
    func getAllChildUsers() -> [AccompanistModel]
    {
        var childUsers = DBHelper.sharedInstance.getAllChildUsersExceptVacant()
        let mineObj = getMineObject()
        
        if (mineObj != nil)
        {
            childUsers.insert(mineObj!, at: 0)
        }
        
        return childUsers
    }
    
    func getChildUsers() -> [AccompanistModel]
    {
        return DBHelper.sharedInstance.getAllChildUsers()
    }
    
    func getAppliedDCRs() -> [DCRHeaderModel]
    {
        return DBHelper.sharedInstance.getAppliedDCRs()
    }
    
    //MARK:- Private Functions
    func getMineObject() -> AccompanistModel?
    {
        let objUser = DBHelper.sharedInstance.getLoginUserDetails()
        var objAccompanist: AccompanistModel?
        let accList = DBHelper.sharedInstance.getAccompanistMaster()
        
        if (objUser != nil)
        {
            let dict: NSDictionary = ["Accompanist_Id": objUser!.userId, "User_Code": objUser!.userCode, "User_Name": objUser!.userName, "Employee_Name": "Mine", "User_Type_Name": objUser!.userTypeName, "Region_Code": objUser!.regionCode, "Region_Name": objUser!.regionName, "Is_Child": 0, "Is_Immediate": accList.count]
            
            objAccompanist = AccompanistModel(dict: dict)
        }
        
        return objAccompanist
    }
    
    //MARK:- Tp Report
    
    func getTpList() -> [TourPlannerHeader]
    {
        return DBHelper.sharedInstance.getTPHeaderExceptHolidayAndWeekend()
    }
    
    func getDCRHeaderDetailsV59Report(userObj: ApprovalUserMasterModel, completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getUserPerDayReportPostData(userObj: userObj)
        WebServiceHelper.sharedInstance.getDCRHeaderDetailsV59Report(postData: postData) { (apiResonseObj) in
            completion(apiResonseObj)
        }
    }
    
    func getUserPerDayReportPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,  "Flag" : "","RegionCode": userObj.Region_Code,"DCRStatus": "ALL"]
    }
    
    //MARK:- DCR
    func getAccompanistDetails() -> NSArray
    {
        var dcrAccompanistList : NSArray = []
        let list : NSMutableArray = []
        
        let accompanistList = BL_Stepper.sharedInstance.getDCRAccompanistDetails()
        
        if (accompanistList != nil)
        {
            let filteredArray = accompanistList!.filter {
                $0.Is_Only_For_Doctor == "0"
            }
            
            for obj in filteredArray
            {
                obj.Acc_Start_Time = checkNullAndNilValueForString(stringData: obj.Acc_Start_Time)
                obj.Acc_End_Time = checkNullAndNilValueForString(stringData: obj.Acc_End_Time)
                
                let dict : NSDictionary = ["Acc_User_Name" : obj.Acc_User_Name!, "Acc_Start_Time" : obj.Acc_Start_Time!, "Acc_End_Time" : obj.Acc_End_Time!]
                
                list.add(dict)
            }
            
            dcrAccompanistList = NSArray(array: list)
        }
        
        return dcrAccompanistList
    }
    
    func getWorkPlaceDetails() -> NSArray
    {
        var dcrWorkPlaceList : NSArray = []
        let list : NSMutableArray = []
        
        let workPlaceObj = BL_Stepper.sharedInstance.getDCRWorkPlace()!
        
        workPlaceObj.CP_Name = checkNullAndNilValueForString(stringData: workPlaceObj.CP_Name)
        workPlaceObj.Category_Name = checkNullAndNilValueForString(stringData: workPlaceObj.Category_Name)
        workPlaceObj.Start_Time = checkNullAndNilValueForString(stringData: workPlaceObj.Start_Time)
        workPlaceObj.End_Time = checkNullAndNilValueForString(stringData: workPlaceObj.End_Time)
        
        
        let dict : NSDictionary = ["CP_Name" : workPlaceObj.CP_Name! , "Category_Name" : workPlaceObj.Category_Name! , "Place_Worked" : workPlaceObj.Place_Worked! , "Start_Time" : workPlaceObj.Start_Time! , "End_Time" : workPlaceObj.End_Time! , "Unapprove_Reason" : checkNullAndNilValueForString(stringData:  workPlaceObj.Unapprove_Reason) , "DCR_General_Remarks" : checkNullAndNilValueForString(stringData: workPlaceObj.DCR_General_Remarks)]
        list.add(dict)
        
        dcrWorkPlaceList = NSArray(array: list)
        return dcrWorkPlaceList
    }
    
    func getDCRSFCDetails() -> NSArray
    {
        var dcrSFCDetails : NSArray = []
        let list : NSMutableArray = []
        
        let sfcList = BL_Stepper.sharedInstance.getDCRSFCDetails()!
        
        for obj in sfcList
        {
            let dict : NSDictionary = ["From_Place" : obj.From_Place , "To_Place" : obj.To_Place , "Distance" : String(obj.Distance) , "Travel_Mode" :obj.Travel_Mode]
            list.add(dict)
        }
        dcrSFCDetails = NSArray(array : list)
        return dcrSFCDetails
    }
    
    func getDCRDoctorDetails() -> NSArray
    {
        var dcrDoctorDetails : NSArray = []
        let list : NSMutableArray = []
        
        let doctorList = BL_Stepper.sharedInstance.getDCRDoctorDetails()!
        
        for obj in  doctorList
        {
            obj.MDL_Number = checkNullAndNilValueForString(stringData: obj.MDL_Number)
            obj.Category_Name = checkNullAndNilValueForString(stringData: obj.Category_Name)
            obj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: obj.Doctor_Region_Name)
            obj.Hospital_Name = checkNullAndNilValueForString(stringData: obj.Hospital_Name) as? String
            // punch in reports
            if (BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
            {
                let dict : NSDictionary = ["Doctor_Name" : obj.Doctor_Name! , "MDL_Number" : obj.MDL_Number! , "Speciality_Name" : obj.Speciality_Name , "Category_Name" : obj.Category_Name! , "Region_Name" : obj.Doctor_Region_Name! ,"Doctor_Code" : obj.Doctor_Code! , "Doctor_Region_Code" : obj.Doctor_Region_Code! ,"Doctor_Visit_Id" : obj.DCR_Doctor_Visit_Id , "DCR_Id" : obj.DCR_Id , "Hospital_Name" : obj.Hospital_Name!,"Punch_Start_Time" : obj.Punch_Start_Time , "Punch_End_Time" : obj.Punch_End_Time!]
                
                list.add(dict)
            }
            else
            {
            let dict : NSDictionary = ["Doctor_Name" : obj.Doctor_Name! , "MDL_Number" : obj.MDL_Number! , "Speciality_Name" : obj.Speciality_Name , "Category_Name" : obj.Category_Name! , "Region_Name" : obj.Doctor_Region_Name! ,"Doctor_Code" : obj.Doctor_Code! , "Doctor_Region_Code" : obj.Doctor_Region_Code! ,"Doctor_Visit_Id" : obj.DCR_Doctor_Visit_Id , "DCR_Id" : obj.DCR_Id , "Hospital_Name" : obj.Hospital_Name!]
                
            list.add(dict)
            }
        }
        dcrDoctorDetails = NSArray(array: list)
        return dcrDoctorDetails
    }
    
    func getCombinedChemistVisitDetails(responseList: NSArray) -> NSArray
    {
        var predicate = NSPredicate(format: "DCR_Visit_Code == %@ AND Chemist_Code != %@", EMPTY, EMPTY)
        let chemistDayMasterList = responseList.filtered(using: predicate)
        
        predicate = NSPredicate(format: "DCR_Visit_Code == %@ AND Chemist_Code == %@", EMPTY, EMPTY)
        let chemistDayFlexiList = responseList.filtered(using: predicate)
        
        predicate = NSPredicate(format: "DCR_Visit_Code != %@ AND Chemist_Code != %@", EMPTY, EMPTY)
        let doctorMasterChemistList = responseList.filtered(using: predicate)
        
        predicate = NSPredicate(format: "DCR_Visit_Code != %@ AND Chemist_Code == %@", EMPTY, EMPTY)
        let doctorFlexiChemistList = responseList.filtered(using: predicate)
        
        let resultList: NSMutableArray = []
        
        for obj in chemistDayMasterList
        {
            let dict = obj as! NSDictionary
            var visitId: Int = -1
            var dcrId: Int = -1
            
            if let chemistVisitId = dict.value(forKey: "Visit_Id") as? Int
            {
                visitId = chemistVisitId
            }
            
            if let id = dict.value(forKey: "DCR_Id") as? Int
            {
                dcrId = id
            }
            
            let resultDict: NSDictionary = ["Chemist_Code": dict.value(forKey: "Chemist_Code") as! String, "Chemist_Name": dict.value(forKey: "Chemist_Name") as! String, "POB_Amount": dict.value(forKey: "POB_Amount") as? Double ?? 0, "Is_Chemist_Day": "1", "DCR_Code": dict.value(forKey: "DCR_Code") as! String, "Visit_Id": visitId, "DCR_Id": dcrId]
            
            resultList.add(resultDict)
        }
        
        for obj in chemistDayFlexiList
        {
            let dict = obj as! NSDictionary
            var visitId: Int = -1
            var dcrId: Int = -1
            
            if let chemistVisitId = dict.value(forKey: "Visit_Id") as? Int
            {
                visitId = chemistVisitId
            }
            
            if let id = dict.value(forKey: "DCR_Id") as? Int
            {
                dcrId = id
            }
            
            let resultDict: NSDictionary = ["Chemist_Code": EMPTY, "Chemist_Name": dict.value(forKey: "Chemist_Name") as! String, "POB_Amount": dict.value(forKey: "POB_Amount") as? Double ?? 0, "Is_Chemist_Day": "1", "DCR_Code": dict.value(forKey: "DCR_Code") as! String, "Visit_Id": visitId, "DCR_Id": dcrId]
            
            resultList.add(resultDict)
        }
        
        var uniqueChemistCodes: [String] = []
        
        for obj in doctorMasterChemistList
        {
            let dict = obj as! NSDictionary
            let chemistCode = dict.value(forKey: "Chemist_Code") as! String
            
            if (!uniqueChemistCodes.contains(chemistCode))
            {
                uniqueChemistCodes.append(chemistCode)
            }
        }
        
        for chemistCode in uniqueChemistCodes
        {
            predicate = NSPredicate(format: "DCR_Visit_Code != %@ AND Chemist_Code == %@", EMPTY, chemistCode)
            var pobAmount: Double = 0
            var chemistName: String = EMPTY
            let filteredArray = responseList.filtered(using: predicate)
            
            if (filteredArray.count > 0)
            {
                for obj in filteredArray
                {
                    let dict = obj as! NSDictionary
                    
                    if let pobStr = dict.value(forKey: "POBAmount") as? String
                    {
                        pobAmount += Double(pobStr) ?? 0
                    }
                    else if let pobDouble = dict.value(forKey: "POB_Amount") as? Double
                    {
                        pobAmount += pobDouble
                    }
                   // pobAmount += dict.value(forKey: "POB_Amount") as? Double ?? 0.0
                    chemistName = dict.value(forKey: "Chemist_Name") as! String
                }
            }
            
            let resultDict: NSDictionary = ["Chemist_Code": chemistCode, "Chemist_Name": chemistName, "POB_Amount": pobAmount, "Is_Chemist_Day": "0"]
            
            resultList.add(resultDict)
        }
        
        for obj in doctorFlexiChemistList
        {
            let dict = obj as! NSDictionary
            var pobAmount : Double = 0
            if let pobStr = dict.value(forKey: "POBAmount") as? String
            {
                pobAmount = Double(pobStr) ?? 0
            }
            else if let pobDouble = dict.value(forKey: "POB_Amount") as? Double
            {
                pobAmount = pobDouble
            }
            let resultDict: NSDictionary = ["Chemist_Code": EMPTY, "Chemist_Name": dict.value(forKey: "Chemist_Name") as! String, "POB_Amount": pobAmount, "Is_Chemist_Day": "0"]
            
            resultList.add(resultDict)
        }
        
        return resultList
    }
    
    func getDCRChemistsDetails() -> NSArray
    {
        let list : NSMutableArray = []
        let chemistList = DBHelper.sharedInstance.getChemistDayVisitsForDCRId(dcrId: DCRModel.sharedInstance.dcrId)
        let doctorChemistList = DBHelper.sharedInstance.getDCRChemistVisitForUpload(dcrId: DCRModel.sharedInstance.dcrId)
        
        if (chemistList != nil)
        {
            for objChemistDayVisit in chemistList!
            {
                let dict: NSDictionary = ["DCR_Visit_Code": EMPTY, "Chemist_Code": checkNullAndNilValueForString(stringData: objChemistDayVisit.ChemistCode), "Chemist_Name": checkNullAndNilValueForString(stringData: objChemistDayVisit.ChemistName), "POB_Amount": 0.0, "DCR_Code": EMPTY, "Visit_Id": objChemistDayVisit.DCRChemistDayVisitId, "DCR_Id": objChemistDayVisit.DCRId]
                
                list.add(dict)
            }
        }
        
        if (doctorChemistList.count > 0)
        {
            for objChemistVisit in doctorChemistList
            {
                var pobAmount: Double = 0.0
                
                if (objChemistVisit.POB_Amount != nil)
                {
                    pobAmount = objChemistVisit.POB_Amount!
                }
                
                let dict: NSDictionary = ["DCR_Visit_Code": "1", "Chemist_Code": checkNullAndNilValueForString(stringData: objChemistVisit.Chemist_Code), "Chemist_Name": checkNullAndNilValueForString(stringData: objChemistVisit.Chemist_Name), "POB_Amount": pobAmount, "DCR_Code": EMPTY, "Visit_Id": -1, "DCR_Id": objChemistVisit.DCR_Id]
                
                list.add(dict)
            }
        }
        
        return getCombinedChemistVisitDetails(responseList: list)
    }
    
    func getDCRStockiestsDetails() -> NSArray
    {
        var dcrStockiestsDetails : NSArray = []
        let list : NSMutableArray = []
        
        let stockiestsList = BL_Stepper.sharedInstance.getDCRStockistDetails()!
        
        for obj in stockiestsList
        {
            obj.Stockiest_Name = checkNullAndNilValueForString(stringData: obj.Stockiest_Name)
            if obj.POB_Amount == nil
            {
                obj.POB_Amount = 0
            }
            
            if obj.Collection_Amount == nil
            {
                obj.Collection_Amount = 0
            }
            
            let dict : NSDictionary = ["Stockiest_Name" : obj.Stockiest_Name , "POB_Amount" : obj.POB_Amount! , "Collection_Amount" : obj.Collection_Amount!]
            list.add(dict)
        }
        
        dcrStockiestsDetails = NSArray(array: list)
        return dcrStockiestsDetails
    }
    
    func getDCRExpenseDetails() -> NSArray
    {
        var dcrExpenseDetails : NSArray = []
        let list : NSMutableArray = []
        
        let expenseDetails = BL_Stepper.sharedInstance.getDCRExpenseDetails()!
        
        for obj in expenseDetails
        {
            obj.Expense_Type_Name = checkNullAndNilValueForString(stringData: obj.Expense_Type_Name)
            
            if obj.Expense_Amount == nil
            {
                obj.Expense_Amount = 0
            }
            
            let dict : NSDictionary = ["Expense_Type_Name":obj.Expense_Type_Name ,"Expense_Amount" : obj.Expense_Amount]
            list.add(dict)
        }
        
        dcrExpenseDetails = NSArray(array : list)
        return dcrExpenseDetails
    }
    
    func getDCRDoctorVisitDetails() -> NSArray
    {
        var dcrDoctorVisitList : NSArray = []
        let list : NSMutableArray = []
        
         let dcrDoctorVisitDetailObj = BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitDetailByDoctorVisitId(doctorVisitId: doctorVisitId)
       
        
        if dcrDoctorVisitDetailObj != nil
        {
            dcrDoctorVisitDetailObj?.Doctor_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Doctor_Name)
            dcrDoctorVisitDetailObj?.MDL_Number = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.MDL_Number)
            dcrDoctorVisitDetailObj?.Hospital_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Hospital_Name)
            dcrDoctorVisitDetailObj?.Category_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Category_Name)
            dcrDoctorVisitDetailObj?.Visit_Time = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Visit_Time)
            dcrDoctorVisitDetailObj?.Visit_Mode = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Visit_Mode)
            dcrDoctorVisitDetailObj?.Business_Status_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Business_Status_Name)
            dcrDoctorVisitDetailObj?.Call_Objective_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Call_Objective_Name)
            dcrDoctorVisitDetailObj?.Punch_Start_Time = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Punch_Start_Time)
                 dcrDoctorVisitDetailObj?.Punch_End_Time = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Punch_End_Time)
            
            if let amt = dcrDoctorVisitDetailObj!.POB_Amount
                
            {
                dcrDoctorVisitDetailObj!.POB_Amount = amt
            }
            else
            {
                dcrDoctorVisitDetailObj!.POB_Amount = 0.0
            }
            
            dcrDoctorVisitDetailObj?.Remarks = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Remarks)
            
            let dict : NSDictionary = ["Doctor_Name" : dcrDoctorVisitDetailObj!.Doctor_Name! , "MDL_Number" : dcrDoctorVisitDetailObj!.MDL_Number! , "Hospital_Name" : dcrDoctorVisitDetailObj!.Hospital_Name! , "Speciality_Name" : dcrDoctorVisitDetailObj!.Speciality_Name , "Category_Name" :dcrDoctorVisitDetailObj!.Category_Name! , "Visit_Mode" : dcrDoctorVisitDetailObj!.Visit_Mode , "Visit_Time" : dcrDoctorVisitDetailObj!.Visit_Time! , "POB_Amount" : String(dcrDoctorVisitDetailObj!.POB_Amount!) , "Remarks" : dcrDoctorVisitDetailObj!.Remarks!, "Status_Name": dcrDoctorVisitDetailObj!.Business_Status_Name!, "Call_Objective_Name": dcrDoctorVisitDetailObj!.Call_Objective_Name!, "Geo_Fencing_Deviation_Remarks": checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj!.Geo_Fencing_Deviation_Remarks), "DCR_Id": dcrDoctorVisitDetailObj!.DCR_Id!, "DCR_Doctor_Visit_Id": dcrDoctorVisitDetailObj!.DCR_Doctor_Visit_Id!,"Campaign_Name": dcrDoctorVisitDetailObj!.Campaign_Name!,"Punch_Start_Time":dcrDoctorVisitDetailObj?.Punch_Start_Time,"Punch_End_Time":dcrDoctorVisitDetailObj?.Punch_End_Time]
            list.add(dict)
        }
        
        dcrDoctorVisitList = NSArray(array: list)
        return dcrDoctorVisitList
    }
    
    func getAttendanceDCRDoctorVisitDetails() -> NSArray
    {
        var dcrDoctorVisitList : NSArray = []
        let list : NSMutableArray = []
        
         let dcrDoctorVisitDetailObj = BL_DCR_Doctor_Visit.sharedInstance.getAttendanceDoctorVisitDetailByDoctorVisitId(doctorVisitId: doctorVisitId)
        
        if dcrDoctorVisitDetailObj != nil
        {
            dcrDoctorVisitDetailObj?.Doctor_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Doctor_Name)
            dcrDoctorVisitDetailObj?.MDL_Number = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.MDL_Number)
            dcrDoctorVisitDetailObj?.Hospital_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Hospital_Name)
            dcrDoctorVisitDetailObj?.Category_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Category_Name)
            dcrDoctorVisitDetailObj?.Visit_Time = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Visit_Time)
            dcrDoctorVisitDetailObj?.Visit_Mode = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Visit_Mode)
            dcrDoctorVisitDetailObj?.Business_Status_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Business_Status_Name)
            dcrDoctorVisitDetailObj?.Call_Objective_Name = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Call_Objective_Name)
            
            if let amt = dcrDoctorVisitDetailObj!.POB_Amount
                
            {
                dcrDoctorVisitDetailObj!.POB_Amount = amt
            }
            else
            {
                dcrDoctorVisitDetailObj!.POB_Amount = 0.0
            }
            
            dcrDoctorVisitDetailObj?.Remarks = checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj?.Remarks)
            
            let dict : NSDictionary = ["Doctor_Name" : dcrDoctorVisitDetailObj!.Doctor_Name! , "MDL_Number" : dcrDoctorVisitDetailObj!.MDL_Number!, "Hospital_Name" : dcrDoctorVisitDetailObj!.Hospital_Name! , "Speciality_Name" : dcrDoctorVisitDetailObj!.Speciality_Name , "Category_Name" :dcrDoctorVisitDetailObj!.Category_Name! , "Visit_Mode" : dcrDoctorVisitDetailObj!.Visit_Mode , "Visit_Time" : dcrDoctorVisitDetailObj!.Visit_Time! , "POB_Amount" : String(dcrDoctorVisitDetailObj!.POB_Amount!) , "Remarks" : dcrDoctorVisitDetailObj!.Remarks!, "Status_Name": dcrDoctorVisitDetailObj!.Business_Status_Name!, "Call_Objective_Name": dcrDoctorVisitDetailObj!.Call_Objective_Name!, "Geo_Fencing_Deviation_Remarks": checkNullAndNilValueForString(stringData: dcrDoctorVisitDetailObj!.Geo_Fencing_Deviation_Remarks), "DCR_Id": dcrDoctorVisitDetailObj!.DCR_Id!, "DCR_Doctor_Visit_Id": dcrDoctorVisitDetailObj!.DCR_Doctor_Visit_Id!, "Campaign_Name": dcrDoctorVisitDetailObj!.Campaign_Name!, "Hospital_Name": dcrDoctorVisitDetailObj!.Hospital_Name!]
            list.add(dict)
        }
        
        dcrDoctorVisitList = NSArray(array: list)
        return dcrDoctorVisitList
    }
    
    
    func getDCRDoctorAccompanistDetails(doctorVisitId: Int, dcrId: Int) -> NSArray
    {
        var dcrDcotorAccList : NSArray = []
        let list : NSMutableArray = []
        
        let dcrAccompanitsList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorAccompanist(doctorVisitId: doctorVisitId, dcrId: dcrId)
        
        if dcrAccompanitsList != nil
        {
            for obj in dcrAccompanitsList!
            {
                let dict : NSDictionary = ["Acc_User_Name" : obj.Acc_User_Name! , "Is_Only_For_Doctor" : obj.Is_Only_For_Doctor, "Is_Accompanied": obj.Is_Accompanied]
                let isDoctor = obj.Is_Accompanied!
                if(isDoctor == "1")
                {
                    list.add(dict)
                }
            }
        }
        
        dcrDcotorAccList = NSArray(array: list)
        return dcrDcotorAccList
    }
    
    func getDCRDoctorSampleDetails() -> NSArray
    {
        var dcrDoctorSampleList : NSArray = []
        let list : NSMutableArray = []
        var productName = String()
        let newLine = "\n"
        var quantity = Int()
        
        let sampleList = BL_DCR_Doctor_Visit.sharedInstance.getSampleProducts()
        
        if sampleList != nil
        {
            for obj in sampleList!
            {
                let sampleBatchList = BL_DCR_Doctor_Visit.sharedInstance.getSampleBatchProducts()
                if(sampleBatchList.count > 0)
                {
                    let filterValue = sampleBatchList.filter{
                        $0.Product_Code == obj.sampleObj.Product_Code
                    }
                    if(filterValue.count > 0)
                    {
                        for (index,objBatch) in sampleBatchList.enumerated()
                        {
                            if(index == 0)
                            {
                                let prodName = obj.sampleObj.Product_Name
                                let batchName = objBatch.Batch_Number
                                productName = prodName! + newLine + batchName!
                            }
                            else
                            {
                                productName = objBatch.Batch_Number
                               quantity = objBatch.Quantity_Provided
                            }
                            quantity = objBatch.Quantity_Provided
                            let dict : NSDictionary = ["Product_Name" : productName , "Quantity_Provided" : String(quantity)]
                            list.add(dict)
                        }
                    }
                    else
                    {
                        let dict : NSDictionary = ["Product_Name" : obj.sampleObj.Product_Name , "Quantity_Provided" : String(obj.sampleObj.Quantity_Provided)]
                        list.add(dict)
                    }
                }
                else
                {
                
                let dict : NSDictionary = ["Product_Name" : obj.sampleObj.Product_Name , "Quantity_Provided" : String(obj.sampleObj.Quantity_Provided)]
                list.add(dict)
                }
            }
        }
        
        dcrDoctorSampleList = NSArray(array: list)
        return dcrDoctorSampleList
        
    }
    
    func getAttendanceDCRDoctorSampleDetails() -> NSArray
    {
        var dcrDoctorSampleList : NSArray = []
        let list : NSMutableArray = []
        var productName = String()
        let newLine = "\n"
        var quantity = Int()
        
        let attendanceSamplelist = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisitSamples(doctorVisitId: BL_Doctor_Attendance_Stepper.sharedInstance.getDCRDoctorVisitId())
        
        let sampleProductList = BL_DCR_Attendance.sharedInstance.convertAttendanceSampleToDCRSample(list: attendanceSamplelist)
        let sampleList = sampleProductList
        
        if sampleList != nil
        {
            for obj in sampleList
            {
                let sampleBatchList = BL_Doctor_Attendance_Stepper.sharedInstance.getSampleBatchProducts()
                if(sampleBatchList.count > 0)
                {
                    let filterValue = sampleBatchList.filter{
                        $0.Product_Code == obj.sampleObj.Product_Code
                    }
                    if(filterValue.count > 0)
                    {
                        for (index,objBatch) in filterValue.enumerated()
                        {
                            if(index == 0)
                            {
                                let prodName = obj.sampleObj.Product_Name
                                let batchName = objBatch.Batch_Number
                                productName = prodName! + newLine + batchName!
                            }
                            else
                            {
                                productName = objBatch.Batch_Number
                                quantity = objBatch.Quantity_Provided
                            }
                            quantity = objBatch.Quantity_Provided
                            let dict : NSDictionary = ["Product_Name" : productName , "Quantity_Provided" : String(quantity)]
                            list.add(dict)
                        }
                    }
                    else
                    {
                        let dict : NSDictionary = ["Product_Name" : obj.sampleObj.Product_Name , "Quantity_Provided" : String(obj.sampleObj.Quantity_Provided)]
                        list.add(dict)
                    }
                }
                else
                {
                    
                    let dict : NSDictionary = ["Product_Name" : obj.sampleObj.Product_Name , "Quantity_Provided" : String(obj.sampleObj.Quantity_Provided)]
                    list.add(dict)
                }
            }
        }
        
        dcrDoctorSampleList = NSArray(array: list)
        return dcrDoctorSampleList
        
    }
    
    func getDCRAttendanceDoctorSampleDetails(sampleList:[DCRAttendanceSampleDetailsModel]) -> NSArray
    {
        var dcrDoctorSampleList : NSArray = []
        let list : NSMutableArray = []
        var productName = String()
        let newLine = "\n"
        var quantity = Int()
        
        let sampleList = sampleList
        
        if sampleList != nil
        {
            for obj in sampleList
            {
                let sampleBatchList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamplesBatchs(dcrId: DCRModel.sharedInstance.dcrId,doctorVisitId:obj.DCR_Doctor_Visit_Id)
                if(sampleBatchList.count > 0)
                {
                    let filterValue = sampleBatchList.filter{
                        $0.Product_Code == obj.Product_Code
                    }
                    if(filterValue.count > 0)
                    {
                        for (index,objBatch) in sampleBatchList.enumerated()
                        {
                            if(index == 0)
                            {
                                let prodName = obj.Product_Name
                                let batchName = objBatch.Batch_Number
                                productName = prodName! + newLine + batchName!
                            }
                            else
                            {
                                productName = objBatch.Batch_Number
                                quantity = objBatch.Quantity_Provided
                            }
                            quantity = objBatch.Quantity_Provided
                            let dict : NSDictionary = ["Product_Name" : productName , "Quantity_Provided" : String(quantity)]
                            list.add(dict)
                        }
                    }
                    else
                    {
                        let dict : NSDictionary = ["Product_Name" : obj.Product_Name , "Quantity_Provided" : obj.Quantity_Provided]
                        list.add(dict)
                    }
                }
                else
                {
                    
                    let dict : NSDictionary = ["Product_Name" : obj.Product_Name , "Quantity_Provided" : obj.Quantity_Provided]
                    list.add(dict)
                }
            }
        }
        
        dcrDoctorSampleList = NSArray(array: list)
        return dcrDoctorSampleList
        
    }
    
    func getDoctorDetailedProducts(dcrId: Int, doctorVisitId: Int) -> NSArray
    {
        var dcrDoctorProductList : NSArray = []
        let list : NSMutableArray = []
        
        let productList = BL_DCR_Doctor_Visit.sharedInstance.getDetailedProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
        
        if productList != nil
        {
            for obj in productList!
            {
                let dict : NSDictionary = ["Product_Name" : obj.Product_Name, "Product_Attr": obj.stepperDisplayData, "Competitor_Products":obj.detailedCompetitorReportList]
                list.add(dict)
            }
        }
        
        dcrDoctorProductList = NSArray(array: list)
        return dcrDoctorProductList
    }
    
    func getDoctorDetailSampleBatchDetails(dataArray: NSArray)-> NSArray
    {
        var dcrDoctorProductList : NSArray = []
        let list : NSMutableArray = []
        let newLine = "\n"
        
        for (_,element) in dataArray.enumerated()
        {
            let sampleObj = element as! NSDictionary
            let batchList = sampleObj.value(forKey: "lstuserproductbatch") as! NSArray
            var productName = String()
            var quantity = Int()
            
            
            if(batchList.count > 0)
            {
                for (index,obj) in batchList.enumerated()
                {
                    let batchObj = obj as! NSDictionary
                    if(index == 0)
                    {
                        let prodName = sampleObj.value(forKey:"Product_Name") as! String
                        let batchName = batchObj.value(forKey: "Batch_Number") as! String
                        productName = prodName + newLine + batchName
                    }
                    else
                    {
                        productName = batchObj.value(forKey: "Batch_Number") as! String
                    }
                    quantity = batchObj.value(forKey: "Batch_Quantity_Provided") as! Int
                    let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
                    
                    list.add(dict)
                }
            }
            else
            {
                productName = sampleObj.value(forKey:"Product_Name") as! String
                quantity = sampleObj.value(forKey: "Quantity_Provided") as! Int
                let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
                list.add(dict)
            }
        }
        dcrDoctorProductList = NSArray(array: list)
        return dcrDoctorProductList
    }
    
    func getDoctorDetailedProductsApi(dataArray: NSArray) -> NSArray
    {
        var dcrDoctorProductList : NSArray = []
        let list : NSMutableArray = []
        var detailedCompetitorProductList :[DCRCompetitorDetailsModel] = []
        
        for obj in dataArray
        {
            let dict = obj as! NSDictionary
            let productName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Product_Name") as? String)
            var productAttributes: String = EMPTY
            
            productAttributes += "\n\nBusiness Status\n"
            
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Status_Name") as? String) != EMPTY)
            {
                productAttributes += dict.value(forKey: "Status_Name") as! String
            }
            else
            {
                productAttributes += "N/A"
            }
            
            productAttributes += "\n\nBusiness Potential\n"
            if let potential = dict.value(forKey: "BusinessPotential") as? Float
            {
                if (potential != Float(defaultBusinessPotential) && potential != -1)
                {
                    productAttributes += String(potential)
                }
                else
                {
                    productAttributes += "N/A"
                }
            }
            else
            {
                productAttributes += "N/A"
            }
            
            productAttributes += "\n\nRemarks\n"
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Business_Status_Remarks") as? String) != EMPTY)
            {
                productAttributes += dict.value(forKey: "Business_Status_Remarks") as! String
            }
            else
            {
                productAttributes += "N/A"
            }
            
            var dcrDetailedCompetitorList = dict.value(forKey: "lstCompetitorDetails") as! NSArray
            
            detailedCompetitorProductList = []
            
            for competitorObj in dcrDetailedCompetitorList
            {
                let dictValue = competitorObj as! NSDictionary
                let dict1 = ["DCR_Doctor_Visit_Code":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "DCR_Visit_Code") as? String),"DCR_Doctor_Visit_Id":0,"DCR_Product_Detail_Id":0,"DCR_Product_Detail_Code":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Sale_Product_Code") as? String),"DCR_Id":0,"DCR_Code":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "DCR_Code") as? String),"Competitor_Code":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Competitor_Code") as? String),"Competitor_Name":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Competitor_Name") as? String),"Product_Name":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Product_Name") as? String),"Product_Code":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Product_Code") as? String),"Value":dictValue.value(forKey: "value") ?? 0,"Probability":dictValue.value(forKey: "Probability") ?? 0.0,"Remarks":checkNullAndNilValueForString(stringData: dictValue.value(forKey: "Remarks") as? String)] as [String : Any]
                let dcrDetailCompetitorObj = DCRCompetitorDetailsModel(dict: dict1 as NSDictionary)
                detailedCompetitorProductList.append(dcrDetailCompetitorObj)
            }
            
            let productDict : NSDictionary = ["Product_Name" : productName, "Product_Attr": productAttributes,"Competitor_Products":detailedCompetitorProductList]
            list.add(productDict)
        }
        
        dcrDoctorProductList = NSArray(array: list)
        return dcrDoctorProductList
    }
    
    func getDCRDoctorAssets() -> NSArray
    {
        var dcrDoctorAssetList : NSArray = []
        let list : NSMutableArray = []
        
        let assetList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorAssetDetails()
        
        for obj in assetList
        {
            var totalPagesViewed = 0
            let PagesViewed = checkNullAndNilValueForString(stringData: obj.totalPagesViewed)
            if PagesViewed != EMPTY
            {
                totalPagesViewed = Int(PagesViewed)!
            }
            
            let dict : NSDictionary = ["DA_Name" : obj.assetsName,"Doc_Type":obj.assetType,"Total_Viewed_Pages": totalPagesViewed,"Total_Unique_Pages_Count":Int(obj.totalUniquePagesCount)!,"Total_Played_Time_Duration":Int(Float(obj.totalPlayedDuration!)!)]
            list.add(dict)
        }
        
        dcrDoctorAssetList = NSArray(array: list)
        return dcrDoctorAssetList
    }
    
    func getDCRDcotorChemist() -> NSArray
    {
        var dcrDoctorChemistList : NSArray = []
        
        let list : NSMutableArray = []
        
        let chemistList = BL_DCR_Doctor_Visit.sharedInstance.getDCRChemistVisitDetails()
        
        
        
        for obj in chemistList!
        {
            if let amt = obj.POB_Amount
            {
                obj.POB_Amount = amt
            }
            else
            {
                obj.POB_Amount = 0.0
            }
            
            let dict : NSDictionary = ["Chemist_Name" : obj.Chemist_Name!,"POB_Amount" : obj.POB_Amount!,"DCR_Chemist_Visit_Id" : obj.DCR_Chemist_Visit_Id]
            list.add(dict)
        }
        dcrDoctorChemistList = NSArray(array: list)
        return dcrDoctorChemistList
    }
    
    func getDCRChemistRCPADetails(chemisVisitId : Int) -> NSArray
    {
        var dcrChemistRCPAList : NSArray = []
        let list : NSMutableArray = []
        let chemistList = DBHelper.sharedInstance.getDCRRCPADetails(dcrChemistVisitId: chemisVisitId)
        
        for obj in chemistList!
        {
            if let qty = obj.Qty_Given
            {
                obj.Qty_Given = qty
            }
            else
            {
                obj.Qty_Given = 0
            }
            
            let dict : NSDictionary = ["Own_Product_Name" : obj.Own_Product_Name ,"Competitor_Product_Name" : checkNullAndNilValueForString(stringData: obj.Competitor_Product_Name) , "Qty_Given" :obj.Qty_Given!]
            
            list.add(dict)
        }
        dcrChemistRCPAList = NSArray(array: list)
        return dcrChemistRCPAList
    }
    
    func getDCRFollowUpsDetails() -> NSArray
    {
        var dcrFollowUpList : NSArray = []
        let list : NSMutableArray = []
        let followUpList = BL_DCR_Follow_Up.sharedInstance.getDCRFollowUpDetails()
        
        for obj in followUpList
        {
            let dict : NSDictionary = ["Tasks" : checkNullAndNilValueForString(stringData: obj.Follow_Up_Text),"Due_Date": obj.Due_Date]
            
            list.add(dict)
        }
        
        dcrFollowUpList = NSArray(array: list)
        return dcrFollowUpList
    }
    
    func getDCRAttachmentDetails() -> NSArray
    {
        var dcrAttachmentList : NSArray = []
        let list : NSMutableArray = []
        let attachmentList = BL_DCR_Doctor_Visit.sharedInstance.getDCRAttachmentDetails()
        
        for obj in attachmentList!
        {
            let dict : NSDictionary = ["Uploaded_File_Name":checkNullAndNilValueForString(stringData: obj.attachmentName)]
            list.add(dict)
        }
        
        dcrAttachmentList = NSArray(array: list)
        return dcrAttachmentList
    }
    
    //MARK:-Attendance
    
    func getDCRActivityDetails() -> NSArray
    {
        var dcrActivityDetails : NSArray = []
        let list : NSMutableArray = []
        
        let activityList = BL_DCR_Attendance_Stepper.sharedInstance.getDCRActivityDetails()!
        for obj in activityList
        {
            obj.Activity_Name = checkNullAndNilValueForString(stringData: obj.Activity_Name)
            obj.Start_Time = checkNullAndNilValueForString(stringData: obj.Start_Time)
            obj.End_Time = checkNullAndNilValueForString(stringData: obj.End_Time)
            let dict : NSDictionary = ["Activity_Name" : obj.Activity_Name! , "Start_Time" : obj.Start_Time! , "End_Time" : obj.End_Time!]
            list.add(dict)
        }
        dcrActivityDetails = NSArray(array : list)
        return dcrActivityDetails
    }
    func getDCRAttendanceDoctorDetails()-> NSArray {
        var dcrDoctorDetails : NSArray = []
        let list : NSMutableArray = []
        let dcrAttendanceDoctors  = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisists()
        for obj in dcrAttendanceDoctors
        {
            let dcrVisitid = obj.DCR_Doctor_Visit_Id
            let dcrAttendanceSamples = BL_DCR_Attendance.sharedInstance.getDCRAttendanceDoctorVisitSamples(doctorVisitId: dcrVisitid!)
        
            let dict = ["Doctor_Name" :checkNullAndNilValueForString(stringData: obj.Doctor_Name), "MDL_Number" : checkNullAndNilValueForString(stringData: obj.MDL_Number), "Hospital_Name" : checkNullAndNilValueForString(stringData: obj.Hospital_Name), "Speciality_Name" : checkNullAndNilValueForString(stringData: obj.Speciality_Name) , "Category_Name":checkNullAndNilValueForString(stringData: obj.Category_Name), "Region_Name" : checkNullAndNilValueForString(stringData: obj.Doctor_Region_Name),"Sample_List":dcrAttendanceSamples,"DCR_Id":DCRModel.sharedInstance.dcrId,"Doctor_Visit_Id":dcrVisitid ?? 0,"Doctor_Code":checkNullAndNilValueForString(stringData: obj.Doctor_Code),"Doctor_Region_Code":checkNullAndNilValueForString(stringData: obj.Doctor_Region_Code)] as [String : Any]
           list.add(dict)
        }
        dcrDoctorDetails = NSArray(array : list)
        return dcrDoctorDetails
        
    }
    //MARK:- Leave
    
    func getDCRLeaveDetails() -> NSDictionary
    {
        
        let leaveObj = BL_Stepper.sharedInstance.getDCRWorkPlace()!
        
        
        leaveObj.Reason = checkNullAndNilValueForString(stringData: leaveObj.Reason)
        let  leaveTypeName = BL_DCR_Leave.sharedInstance.getLeaveTypeName(leaveTypeCode: leaveObj.Leave_Type_Code!)
        
        let dict : NSDictionary = ["leaveTypeName" : leaveTypeName,"Reason" :  leaveObj.Reason! ,"Unapprove_Reason" : checkNullAndNilValueForString(stringData: leaveObj.Unapprove_Reason)]
        return dict
    }
    
    //MARK:-Report
    func getReportMenu() -> [MenuMasterModel]
    {
        return getMenus(menuIds: getReportMenuIds())
    }
    
    func checkIsIfHourlyReportExistInMenu() -> Bool
    {
        var isExist : Bool = false
        let filteredArray = getReportMenu().filter {
            $0.Menu_Id == MenuIDs.Hourly_Report.rawValue
        }
        if filteredArray.count > 0
        {
            isExist = true
        }
        return isExist
    }
    
    func checkIsIfTraveltrackingreportExistInMenu() -> Bool
    {
        var isExist : Bool = false
        let filteredArray = getReportMenu().filter {
            $0.Menu_Id == MenuIDs.traveltrackingreport.rawValue
        }
        if filteredArray.count > 0
        {
            isExist = true
        }
        return isExist
    }
    
    func checkIsIfLiveTrackForManagerReportExistInMenu() -> Bool
    {
        var isExist : Bool = false
        let filteredArray = getReportMenu().filter {
            $0.Menu_Id == MenuIDs.LiveTrackingChartManager.rawValue
        }
        if filteredArray.count > 0
        {
            isExist = true
        }
        return isExist
    }
    //LiveTrackingChartManager
    
    func checkIsIfGeoLocationReportExistInMenu() -> Bool
    {
        var isExist : Bool = false
        let filteredArray = getReportMenu().filter {
            $0.Menu_Id == MenuIDs.GEO_Location_Report.rawValue
        }
        if filteredArray.count > 0
        {
            isExist = true
        }
        return isExist
    }
    
    func checkIsIfLiveTrackingInfoExistsInMenu() -> Bool
    {
        var isExist : Bool = false
        let filteredArray = getReportMenu().filter {
            $0.Menu_Id == MenuIDs.DoctorApproval.rawValue
        }
        if filteredArray.count > 0
        {
            isExist = true
        }
        return isExist
    }
    
    private func getMenus(menuIds: String) -> [MenuMasterModel]
    {
        
        return DBHelper.sharedInstance.getMenuMasterByMenuIDs(menuIds: menuIds)
    }
    
    private func getReportMenuIds() -> String
    {
        let menuIDs: String = String(MenuIDs.Hourly_Report.rawValue) + "," + String(MenuIDs.GEO_Location_Report.rawValue) + "," + String(MenuIDs.LiveTrackingChartManager.rawValue) + "," + String(MenuIDs.traveltrackingreport.rawValue)
        return menuIDs
    }
    
    func getTpHeaderDetailsData(userObj : ApprovalUserMasterModel ,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerPostData(userObj: userObj)
        WebServiceHelper.sharedInstance.getTourPlannerHeader(postData: postData)  { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    func getTpHeaderDetailsDataForDCRApproval(userObj : ApprovalUserMasterModel ,completion : @escaping (_ apiResponseObject : ApiResponseModel) -> ())
    {
        let postData = getTourPlannerDCRApprovalPostData(userObj: userObj)
        WebServiceHelper.sharedInstance.getTourPlannerHeader(postData: postData)  { (apiResponseObject) in
            completion(apiResponseObject)
        }
    }
    
    private func getTourPlannerPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,"RegionCode": userObj.Region_Code, "StartDate": NSNull(), "EndDate": NSNull(),"TPStatus": "ALL"]
    }
    
    private func getTourPlannerDCRApprovalPostData(userObj : ApprovalUserMasterModel) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode(), "UserCode": userObj.User_Code,"RegionCode": userObj.Region_Code, "StartDate": userObj.Actual_Date, "EndDate": userObj.Entered_Date,"TPStatus": "ALL"]
    }
    
    //MARK:- ChemistDay
    func getDCRChemistVisitDetails() -> NSArray
    {
        var dcrChemistVisitList : NSArray = []
        let list : NSMutableArray = []
        
        let dcrChemistVisitDetailObj = DBHelper.sharedInstance.getChemistVisitDetailByChemistVisitId(chemistVisitId : ChemistDay.sharedInstance.chemistVisitId)
        
        if dcrChemistVisitDetailObj != nil
        {
            dcrChemistVisitDetailObj?.ChemistName = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.ChemistName)
            dcrChemistVisitDetailObj?.MDLNumber = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.MDLNumber)
            dcrChemistVisitDetailObj?.CategoryName = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.CategoryName)
            dcrChemistVisitDetailObj?.VisitTime = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.VisitTime)
            dcrChemistVisitDetailObj?.VisitMode = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.VisitMode)
            
            dcrChemistVisitDetailObj?.Remarks = checkNullAndNilValueForString(stringData: dcrChemistVisitDetailObj?.Remarks)
            
            let dict : NSDictionary = ["Doctor_Name" : dcrChemistVisitDetailObj!.ChemistName! , "MDL_Number" : dcrChemistVisitDetailObj!.MDLNumber! , "Speciality_Name" : NA , "Category_Name" :dcrChemistVisitDetailObj!.CategoryName! , "Visit_Mode" : dcrChemistVisitDetailObj!.VisitMode , "Visit_Time" : dcrChemistVisitDetailObj!.VisitTime! , "POB_Amount" : NA , "Remarks" : dcrChemistVisitDetailObj!.Remarks!,"DCR_Id": dcrChemistVisitDetailObj!.DCRId, "Chemist_Visit_Id": dcrChemistVisitDetailObj!.DCRChemistDayVisitId]
            list.add(dict)
        }
        
        dcrChemistVisitList = NSArray(array: list)
        return dcrChemistVisitList
    }
    
    func getDCRChemistAccompanistDetails(chemistVisitId: Int, dcrId: Int) -> NSArray
    {
        var dcrChemistAccList : NSArray = []
        let list : NSMutableArray = []
        let dcrChemistAccompanitsList = BL_Common_Stepper.sharedInstance.getChemistAccompanist(chemistVisitId: chemistVisitId, dcrId: dcrId)
        
        if dcrChemistAccompanitsList != nil
        {
            for obj in dcrChemistAccompanitsList!
            {
                let dict : NSDictionary = ["Acc_User_Name" : checkNullAndNilValueForString(stringData:obj.AccUserName!), "Is_Only_For_Doctor" : obj.IsOnlyForChemist, "Is_Accompanied": String(obj.IsAccompaniedCall)]
                let isChemist = obj.IsAccompaniedCall!
                
                if(isChemist == 1)
                {
                    list.add(dict)
                }
            }
        }
        
        dcrChemistAccList = NSArray(array: list)
        return dcrChemistAccList
    }
    
    func getDCRChemistSampleDetails() -> NSArray
    {
        var dcrDoctorSampleList : NSArray = []
        let list : NSMutableArray = []
        var productName = String()
        let newLine = "\n"
        var quantity = Int()
        
        let sampleList = BL_Common_Stepper.sharedInstance.getSampleProducts()
        
        if sampleList != nil
        {
            for obj in sampleList!
            {
                let sampleBatchList = BL_Common_Stepper.sharedInstance.getSampleBatchProducts()
                if((sampleBatchList.count) > 0)
                {
                    let filterValue = sampleBatchList.filter{
                        $0.Product_Code == obj.ProductCode
                    }
                    if((filterValue.count) > 0)
                    {
                        for (index,objBatch) in (sampleBatchList.enumerated())
                        {
                            if(index == 0)
                            {
                                let prodName = obj.ProductName
                                let batchName = objBatch.Batch_Number
                                productName = prodName! + newLine + batchName!
                            }
                            else
                            {
                                productName = objBatch.Batch_Number
                                quantity = objBatch.Quantity_Provided
                            }
                            quantity = objBatch.Quantity_Provided
                            let dict : NSDictionary = ["Product_Name" : productName , "Quantity_Provided" : String(quantity)]
                            list.add(dict)
                        }
                    }
                    else
                    {
                        let dict : NSDictionary = ["Product_Name" : obj.ProductName , "Quantity_Provided" : String(obj.QuantityProvided)]
                        list.add(dict)
                    }
                }
                else
                {
                    
                    let dict : NSDictionary = ["Product_Name" : obj.ProductName , "Quantity_Provided" : String(obj.QuantityProvided)]
                    list.add(dict)
                }
            }
        }
        
        dcrDoctorSampleList = NSArray(array: list)
        return dcrDoctorSampleList
//        var dcrChemistSampleList : NSArray = []
//        let list : NSMutableArray = []
//
//        let sampleList = BL_Common_Stepper.sharedInstance.getSampleProducts()
//
//        if sampleList != nil
//        {
//            for obj in sampleList!
//            {
//                if obj.QuantityProvided == nil
//                {
//                    obj.QuantityProvided = 0
//                }
//                let dict : NSDictionary = ["Product_Name" : obj.ProductName , "Quantity_Provided" : String(obj.QuantityProvided)]
//                list.add(dict)
//            }
//        }
//
//        dcrChemistSampleList = NSArray(array: list)
//        return dcrChemistSampleList
        
    }
    
    func getdcrChemistDetailedProducts() -> NSArray
    {
        var dcrChemistProductList : NSArray = []
        let list : NSMutableArray = []
        
        let productList = BL_Common_Stepper.sharedInstance.getDetailedProducts()
        
        if productList != nil
        {
            for obj in productList!
            {
                let dict : NSDictionary = ["Product_Name" : obj.Product_Name]
                list.add(dict)
            }
        }
        dcrChemistProductList = NSArray(array: list)
        return dcrChemistProductList
    }
    
    func getDCRChemistAssets() -> NSArray
    {
        var dcrChemistAssetList : NSArray = []
        let list : NSMutableArray = []
        
        //        let assetList = BL_DCR_Doctor_Visit.sharedInstance.getDCRDoctorAssetDetails()
        //
        //        for obj in assetList
        //        {
        //            var totalPagesViewed = 0
        //            let PagesViewed = checkNullAndNilValueForString(stringData: obj.totalPagesViewed)
        //            if PagesViewed != EMPTY
        //            {
        //                totalPagesViewed = Int(PagesViewed)!
        //            }
        //
        //            let dict : NSDictionary = ["DA_Name" : obj.assetsName,"Doc_Type":obj.assetType,"Total_Viewed_Pages": totalPagesViewed,"Total_Unique_Pages_Count":Int(obj.totalUniquePagesCount)!,"Total_Played_Time_Duration":Int(Float(obj.totalPlayedDuration!)!)]
        //            list.add(dict)
        //        }
        
        dcrChemistAssetList = NSArray(array: list)
        return dcrChemistAssetList
    }
    
    func getDCRChemistFollowUpsDetails() -> NSArray
    {
        var dcrFollowUpList : NSArray = []
        let list : NSMutableArray = []
        let followUpList = BL_Common_Stepper.sharedInstance.getFollowUpDetails()
        
        for obj in followUpList
        {
            let dict : NSDictionary = ["Tasks" : checkNullAndNilValueForString(stringData: obj.Task),"Due_Date": obj.DueDate]
            
            list.add(dict)
        }
        
        dcrFollowUpList = NSArray(array: list)
        return dcrFollowUpList
    }
    
    func getDCRChemistAttachmentDetails() -> NSArray
    {
        var dcrAttachmentList : NSArray = []
        let list : NSMutableArray = []
        let attachmentList = BL_Common_Stepper.sharedInstance.getDCRChemistAttachmentDetails()
        
        for obj in attachmentList!
        {
            let dict : NSDictionary = ["Uploaded_File_Name":checkNullAndNilValueForString(stringData: obj.UploadedFileName)]
            list.add(dict)
        }
        
        dcrAttachmentList = NSArray(array: list)
        return dcrAttachmentList
    }
    
    func getDCRChemistPOB() -> NSArray
    {
        var dcrDoctorChemistList : NSArray = []
        let list : NSMutableArray = []
        let chemistList = BL_Common_Stepper.sharedInstance.getPobDetails()
        
        for obj in chemistList!
        {
            let detailObj = BL_POB_Stepper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryID: obj.Order_Entry_Id)
            //            let remarksObj  = BL_POB_Stepper.sharedInstance.getPOBRemarks(orderEntryId: obj.Order_Entry_Id)
            let pob = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: obj.Order_Entry_Id)
            let orderDetailsPOB : NSMutableArray = []
            
            for obj in detailObj
            {
                let dict : [String:Any] = ["Product_Name":obj.Product_Name,"Product_Qty":obj.Product_Qty,"Product_Unit_Rate":obj.Product_Unit_Rate,"Product_Amount":obj.Product_Amount]
                orderDetailsPOB.add(dict)
            }
            
            let dict : NSDictionary = ["Chemist_Name" :obj.Stockiest_Name,"POB_Amount" :Float(pob),"DCR_Chemist_Visit_Id" :detailObj.count ,"Orderdetails": orderDetailsPOB]
            list.add(dict)
        }
        
        dcrDoctorChemistList = NSArray(array: list)
        return dcrDoctorChemistList
    }
    
    func getDCRDoctorPOB() -> NSArray
    {
        var dcrDoctorChemistList : NSArray = []
        let list : NSMutableArray = []
        let chemistList = BL_DCR_Doctor_Visit.sharedInstance.getPobDetails()
        
        for obj in chemistList!
        {
            let detailObj = BL_POB_Stepper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryID: obj.Order_Entry_Id)
            //            let remarksObj  = BL_POB_Stepper.sharedInstance.getPOBRemarks(orderEntryId: obj.Order_Entry_Id)
            let pob = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: obj.Order_Entry_Id)
            let orderDetailsPOB : NSMutableArray = []
            
            for obj in detailObj
            {
                let dict : [String:Any] = ["Product_Name":obj.Product_Name,"Product_Qty":obj.Product_Qty,"Product_Unit_Rate":obj.Product_Unit_Rate,"Product_Amount":obj.Product_Amount]
                orderDetailsPOB.add(dict)
            }
            
            let dict : NSDictionary = ["Chemist_Name" :obj.Stockiest_Name,"POB_Amount" :Float(pob),"DCR_Chemist_Visit_Id" :detailObj.count ,"Orderdetails": orderDetailsPOB]
            list.add(dict)
        }
        
        dcrDoctorChemistList = NSArray(array: list)
        return dcrDoctorChemistList
    }
    
    func getChemistDayRCPACompetitorDetails(chemistVisitId : Int,rcpaOwnId: Int) -> NSArray
    {
        var dcrChemistDayRCPAList : NSArray = []
        let list : NSMutableArray = []
        var productName = EMPTY
        let chemistList = DBHelper.sharedInstance.getChemistDayRCPACompetitor(chemistDayVisitId: chemistVisitId,rcpaOwn_Id: rcpaOwnId)
        
        for obj in chemistList
        {
            if let qty = obj.Quantity
            {
                obj.Quantity = qty
            }
            else
            {
                obj.Quantity = 0
            }
            productName = DBHelper.sharedInstance.getProductName(productCode: obj.OwnProductCode)!
            let dict : NSDictionary = ["Product_Name" : productName,"Competitor_Product_Name" : checkNullAndNilValueForString(stringData: obj.CompetitorProductName) , "Qty" :obj.Quantity!]
            
            list.add(dict)
        }
        dcrChemistDayRCPAList = NSArray(array: list)
        return dcrChemistDayRCPAList
    }
    
    func getChemistDayRCPAOwn() -> NSArray
    {
        var dcrChemistDayRCPAList : NSArray = []
        
        let list : NSMutableArray = []
        
        let chemistList = BL_Common_Stepper.sharedInstance.getDCRChemistRCPADetailsForReport()
        
        for obj in chemistList!
        {
            let dict : NSDictionary = ["Customer_Name" :obj.DoctorName,"Product_Name" :obj.ProductName,"Qty" : obj.Quantity,"Chemist_RCPA_OWN_Product_Id":obj.DCRChemistRCPAOwnId,"CV_Visit_Id":obj.DCRChemistDayVisitId]
            list.add(dict)
        }
        dcrChemistDayRCPAList = NSArray(array: list)
        return dcrChemistDayRCPAList
    }
    
    func getDoctorActivity() -> NSArray
    {
        
        var dcrDoctorActivityList : NSArray = []
        let list : NSMutableArray = []
        BL_Activity_Stepper.sharedInstance.isFromAttendance = false
        let doctorActivityList = BL_Activity_Stepper.sharedInstance.getCallActivityList()
        
        for obj in doctorActivityList
        {
            let dict : NSDictionary = ["Activity_Name" : checkNullAndNilValueForString(stringData: obj.Customer_Activity_Name),"Activity_Remarks": checkNullAndNilValueForString(stringData:obj.Activity_Remarks)]
            
            list.add(dict)
        }
        dcrDoctorActivityList = NSArray(array: list)
        return dcrDoctorActivityList
    }
    
    func getDoctorMCActivity() -> NSArray
    {
        
        var dcrDoctorMCActivityList : NSArray = []
        let list : NSMutableArray = []
        BL_Activity_Stepper.sharedInstance.isFromAttendance = false
        let doctorMCActivityList = BL_Activity_Stepper.sharedInstance.getMCCallActivityList()
        
        for obj in doctorMCActivityList
        {
            let campaignName = checkNullAndNilValueForString(stringData:obj.Campaign_Name)
            let activityName = checkNullAndNilValueForString(stringData:obj.MC_Activity_Name)
            
            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData: obj.MC_Activity_Remarks),"Activity_Name": campaignName + "\n" + activityName]
            
            list.add(dict)
        }
        dcrDoctorMCActivityList = NSArray(array: list)
        return dcrDoctorMCActivityList
    }
    
    func getAttendanceDoctorActivity() -> NSArray
    {
        
        var dcrDoctorActivityList : NSArray = []
        let list : NSMutableArray = []
        BL_Activity_Stepper.sharedInstance.isFromAttendance = true
        let doctorActivityList = BL_Activity_Stepper.sharedInstance.getCallActivityList()
        
        for obj in doctorActivityList
        {
            let dict : NSDictionary = ["Activity_Name" : checkNullAndNilValueForString(stringData: obj.Customer_Activity_Name),"Activity_Remarks": checkNullAndNilValueForString(stringData:obj.Activity_Remarks)]
            
            list.add(dict)
        }
        dcrDoctorActivityList = NSArray(array: list)
        return dcrDoctorActivityList
    }
    
    func getAttendanceDoctorMCActivity() -> NSArray
    {
        
        var dcrDoctorMCActivityList : NSArray = []
        let list : NSMutableArray = []
        BL_Activity_Stepper.sharedInstance.isFromAttendance = true
        let doctorMCActivityList = BL_Activity_Stepper.sharedInstance.getMCCallActivityList()
        
        for obj in doctorMCActivityList
        {
            let campaignName = checkNullAndNilValueForString(stringData:obj.Campaign_Name)
            let activityName = checkNullAndNilValueForString(stringData:obj.MC_Activity_Name)
            
            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData: obj.MC_Activity_Remarks),"Activity_Name": campaignName + "\n" + activityName]
            
            list.add(dict)
        }
        dcrDoctorMCActivityList = NSArray(array: list)
        return dcrDoctorMCActivityList
    }
    
    
}

