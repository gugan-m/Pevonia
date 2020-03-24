//
//  BL_DCR_Attendance.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB
class BL_DCR_Attendance: NSObject
{
    static let sharedInstance = BL_DCR_Attendance()
    
    //MARK:- Public Functions
    func getDCRAttendanceActivities() -> [DCRAttendanceActivityModel]?
    {
        return DBHelper.sharedInstance.getDCRAttendanceActivities(dcrId: getDCRId())
    }
    
    func getProjectActivityList() -> [ProjectActivityMaster]?
    {
        return DBHelper.sharedInstance.getProjectActivityList()
    }
    
    func saveDCRAttendanceActivity(objProjectActivityModel: ProjectActivityMaster, startTime: String, endTime: String, remarks: String)
    {
        let dcrAttendanceActivityDict: NSDictionary = ["DCR_Id": getDCRId(), "DCR_Actual_Date": convertDateIntoServerStringFormat(date: getDCRDate()), "Project_Code": objProjectActivityModel.Project_Code, "Activity_Code": objProjectActivityModel.Activity_Code, "Start_Time": startTime, "End_Time": endTime, "Remarks": remarks]
        let objAttendaceActivity: DCRAttendanceActivityModel = DCRAttendanceActivityModel(dict: dcrAttendanceActivityDict)
        
        DBHelper.sharedInstance.insertDCRAttendanceActivity(dcrAttendanceActivityObj: objAttendaceActivity)
    }
    func saveDCRAttendanceActivity1(Project_Code: String,Activity_Code:String, startTime: String, endTime: String, remarks: String)
    {
        let dcrAttendanceActivityDict: NSDictionary = ["DCR_Id": getDCRId(), "DCR_Actual_Date": convertDateIntoServerStringFormat(date: getDCRDate()), "Project_Code":Project_Code , "Activity_Code": Activity_Code, "Start_Time": startTime, "End_Time": endTime, "Remarks": remarks]
        let objAttendaceActivity: DCRAttendanceActivityModel = DCRAttendanceActivityModel(dict: dcrAttendanceActivityDict)
        
        DBHelper.sharedInstance.insertDCRAttendanceActivity(dcrAttendanceActivityObj: objAttendaceActivity)
    }
    
    func updateDCRAttendanceActivity(dcrAttendanceActivityObj: DCRAttendanceActivityModel)
    {
        return DBHelper.sharedInstance.updateDCRAttendanceActivity(dcrAttendanceActivityObj: dcrAttendanceActivityObj)
    }
    
    func deleteDCRAttendanceActivity(dcrAttendanceActivityId: Int)
    {
        return DBHelper.sharedInstance.deleteDCRAttendanceActivity(dcrAttendanceActivityId: dcrAttendanceActivityId)
    }
    
    //MARK:- Doctor Sample Save,Delete
    func saveDCRAttendanceDoctorVisit(customerOBJ: CustomerMasterModel) -> Int
    {
        let doctorObj:DCRAttendanceDoctorModel!
        let dict:NSDictionary = ["DCR_Id":getDCRId(),"DCR_Code":DCRModel.sharedInstance.dcrCode,"Doctor_Code": customerOBJ.Customer_Code,"Doctor_Name": customerOBJ.Customer_Name,"Hospital_Name": customerOBJ.Hospital_Name!,"DCR_Doctor_Visit_Code": EMPTY,"DCR_Actual_Date": getDCRDate(),"Speciality_Name": customerOBJ.Speciality_Name,"Speciality_Code": customerOBJ.Speciality_Code,"Category_Code": customerOBJ.Category_Code ?? EMPTY,"Category_Name": customerOBJ.Category_Name ?? EMPTY,"Doctor_Region_Name":customerOBJ.Region_Name,"Doctor_Region_Code":customerOBJ.Region_Code,"MDL_Number":customerOBJ.MDL_Number]
        doctorObj = DCRAttendanceDoctorModel.init(dict: dict)
        return DAL_DCR_Attendance.sharedInstance.saveDCRAttendanceDoctorVisits(dcrAattendanceDoctorObj: doctorObj)
    }
    
    func saveDcrAttendanceDoctorVisitSamples(dcrAttendanceDoctorVisitSamples:[DCRSampleModel],dcrSampleBatchProductList: [DCRSampleModel],doctorVisitId: Int)
    {
        var sampleDetailsArray: [DCRAttendanceSampleDetailsModel] = []
        for obj in dcrAttendanceDoctorVisitSamples
        {
            let dict: NSDictionary = ["DCR_Id": getDCRId(), "DCR_Code": DCRModel.sharedInstance.dcrCode, "Product_Code": obj.sampleObj.Product_Code, "Product_Name":obj.sampleObj.Product_Name, "Quantity_Provided": obj.sampleObj.Quantity_Provided, "DCR_Doctor_Visit_Id": doctorVisitId,"DCR_Doctor_Visit_Code":EMPTY,"DCR_Actual_Date":getDCRDate()]
            
            let dcrChemistProductList : DCRAttendanceSampleDetailsModel = DCRAttendanceSampleDetailsModel(dict: dict)
            
            sampleDetailsArray.append(dcrChemistProductList)
        }
        
        BL_SampleProducts.sharedInstance.addInwardQty(dcrId: getDCRId(), attendanceDoctorVisitId: doctorVisitId)
        
        deleteDCRAttendanceDoctorSample(doctorVisitId: doctorVisitId)
        
        DAL_DCR_Attendance.sharedInstance.saveDCRAttendanceSampleDetails(dcrAttendanceSamples: sampleDetailsArray)
        
        BL_SampleProducts.sharedInstance.subtractInwardQty(dcrId: getDCRId(), attendanceDoctorVisitId: doctorVisitId)
        
        let dcrSampleList = getDCRAttendanceDoctorVisitSamples(doctorVisitId: doctorVisitId)
        
        var sampleBatchList: [DCRSampleBatchModel] = []
        
        for obj in dcrSampleBatchProductList
        {
            
            let filterArray = dcrSampleList.filter{
                $0.Product_Code == obj.sampleObj.Product_Code
            }
            let dict = ["DCR_Id":getDCRId(),"DCR_Code":DCRModel.sharedInstance.dcrCode,"Visit_Id":doctorVisitId,"Visit_Code":"","Ref_Id":filterArray.first?.DCR_Attendance_Sample_Id ?? 0,"Product_Code":obj.sampleObj.Product_Code,"Batch_Number":obj.sampleObj.Batch_Name,"Quantity_Provided":"\(obj.sampleObj.Quantity_Provided!)","Entity_Type":sampleBatchEntity.Attendance.rawValue] as [String : Any]
            
            let dcrSampleBatch = DCRSampleBatchModel(dict: dict as NSDictionary)
            sampleBatchList.append(dcrSampleBatch)
        }
        
      BL_SampleProducts.sharedInstance.addBatchInwardQty(dcrId: getDCRId(), doctorVisitId: doctorVisitId, entityType: sampleBatchEntity.Attendance.rawValue)
        
        DBHelper.sharedInstance.deleteDCRSampleBatchDetails(dcrId: getDCRId(), visitId: doctorVisitId, entityType: sampleBatchEntity.Attendance.rawValue)
        
        var i = 0
        
        for obj in dcrSampleBatchProductList
        {
            if obj.sampleObj.Quantity_Provided > 0
            {
                DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList : [sampleBatchList[i]])
                
            }
            i = i+1
        }
        
        //DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList : sampleBatchList)
        
        BL_SampleProducts.sharedInstance.subtractBatchInwardQty(dcrId: getDCRId(), doctorVisitId: doctorVisitId, entityType: sampleBatchEntity.Attendance.rawValue)
        
    }
    
    func getDCRAttendanceDoctorVisists() -> [DCRAttendanceDoctorModel]
    {
        return DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctor(dcrId: getDCRId())
    }
    
    func getDCRAttendanceDoctorVisit() -> [DCRAttendanceDoctorModel]
    {
        return DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctor(dcrId: getDCRId(), customerCode: getCustomerCode(), regionCode: getCustomerRegionCode())
    }
    
    func getDCRAttendanceDoctorVisitSamples(doctorVisitId: Int) -> [DCRAttendanceSampleDetailsModel]
    {
        return DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: doctorVisitId, dcrId: getDCRId())
    }
    
    func deleteDCRAttendanceDoctorSample(doctorVisitId: Int)
    {
        DAL_DCR_Attendance.sharedInstance.deleteDCRSampleDetails(dcrId: getDCRId(), doctorVisitId: doctorVisitId)
    }
    
    func deleteDCRAttendanceDoctorVisit(doctorVisitId: Int)
    {
        BL_SampleProducts.sharedInstance.addInwardQty(dcrId: getDCRId(), attendanceDoctorVisitId: doctorVisitId)
        DAL_DCR_Attendance.sharedInstance.deleteDCRDoctorVisit(doctorVisitId: doctorVisitId, dcrId: getDCRId())
    }
    
    func deleteDCRAttendenceActivity(doctorVisitId: Int)
    {
       DAL_DCR_Attendance.sharedInstance.deleteCallActivity(doctorVisitId: doctorVisitId, entityType: sampleBatchEntity.Attendance.rawValue, dcrId: getDCRId())
        
        DAL_DCR_Attendance.sharedInstance.deleteMCCallActivity(doctorVisitId: doctorVisitId, entityType: sampleBatchEntity.Attendance.rawValue, dcrId: getDCRId())
    }
    
    
    //this function to be called when navigate to modify sample
    func getSelectedSampleProductForDCRAttendance(doctorVisitId: Int) -> [DCRSampleModel]
    {
        var sampleProductList : [DCRSampleModel] = []
        let doctorVisitSamples = self.getDCRAttendanceDoctorVisitSamples(doctorVisitId: doctorVisitId)
        if doctorVisitSamples.count > 0
        {
            sampleProductList = self.convertChemistSampleToDCRSample(list: doctorVisitSamples)
        }
        return sampleProductList
    }
    func convertChemistSampleToDCRSample(list : [DCRAttendanceSampleDetailsModel]) -> [DCRSampleModel]
    {
        var sampleObjList : [SampleProductsModel] = []
        var sampleProductList : [DCRSampleModel] = []
        for obj in list
        {
            let sampleObj : SampleProductsModel = SampleProductsModel()
            sampleObj.Product_Name = obj.Product_Name
            sampleObj.Product_Code = obj.Product_Code
            sampleObj.Quantity_Provided = obj.Quantity_Provided
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        return sampleProductList
        
    }
    
    func getSelectDoctorProductCode(dcrId: Int, doctorVisit: Int) -> [String]
    {
        var selectedList : [String] = []
        
        let selectedDCRList =  DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: doctorVisit, dcrId: dcrId)
        if(selectedDCRList.count > 0)
        {
            for dcrAttendanceSample in selectedDCRList
            {
                if dcrAttendanceSample.Product_Code != nil
                {
                    selectedList.append(dcrAttendanceSample.Product_Code)
                }
            }
            
        }
        return selectedList
    }
    
    func convertAttendanceSampleToDCRSample(list : [DCRAttendanceSampleDetailsModel]) -> [DCRSampleModel]
    {
        var sampleObjList : [SampleProductsModel] = []
        var sampleProductList : [DCRSampleModel] = []
        for obj in list
        {
            
           let currentStock =  DAL_DCR_Attendance.sharedInstance.getCurrentStock(productCode: obj.Product_Code)
            let sampleObj : SampleProductsModel = SampleProductsModel()
            sampleObj.Product_Name = obj.Product_Name
            sampleObj.Product_Code = obj.Product_Code
            sampleObj.Quantity_Provided = obj.Quantity_Provided
            sampleObj.Current_Stock = currentStock
            sampleObj.DCR_Sample_Id = obj.DCR_Attendance_Sample_Id
            sampleObj.DCR_Id = obj.DCR_Id
            sampleObj.DCR_Code = obj.DCR_Code
            sampleObj.DCR_Doctor_Visit_Code = obj.DCR_Doctor_Visit_Code
            sampleObj.DCR_Doctor_Visit_Id = obj.DCR_Doctor_Visit_Id
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        return sampleProductList
        
    }
    
    func updateDCRAttendanceDoctorVisit(dcrDoctorVisitObj: DCRAttendanceDoctorModel, viewController: UIViewController)
    {
        dcrDoctorVisitObj.Lattitude = checkNullAndNilValueForString(stringData: getLatitude())
        dcrDoctorVisitObj.Longitude = checkNullAndNilValueForString(stringData: getLongitude())
        
        DAL_DCR_Attendance.sharedInstance.updateDCRAttendanceDoctorVisit(dcrDoctorVisitObj: dcrDoctorVisitObj)
        
     
    }
    
    //MARK:- Private Functions
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDCRDate() -> Date
    {
        return DCRModel.sharedInstance.dcrDate
    }
    
    private func getCustomerCode() -> String
    {
        return DCRModel.sharedInstance.customerCode
    }
    
    private func getCustomerRegionCode() -> String
    {
        return DCRModel.sharedInstance.customerRegionCode
    }
}

class DAL_DCR_Attendance: NSObject
{
    static let sharedInstance = DAL_DCR_Attendance()
    
    func getSelectedDCRAttendanceDoctor(dcrId: Int) -> [DCRAttendanceDoctorModel]
    {
        var selectedDCRAttendanceDoctorVisits: [DCRAttendanceDoctorModel] = []
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisits = try DCRAttendanceDoctorModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        return selectedDCRAttendanceDoctorVisits
    }
    
    func getSelectedDCRAttendanceDoctor(dcrId: Int, customerCode: String, regionCode: String) -> [DCRAttendanceDoctorModel]
    {
        var selectedDCRAttendanceDoctorVisits: [DCRAttendanceDoctorModel] = []
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisits = try DCRAttendanceDoctorModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId,customerCode,regionCode])
        }
        return selectedDCRAttendanceDoctorVisits
    }
    func getAttendanceDoctorVisitDetailFlexiDoctor(dcrId: Int, doctorVisitId : Int) -> [DCRAttendanceDoctorModel]
    {
        var doctorList : [DCRAttendanceDoctorModel] = []
        
        try? dbPool.read { db in
            doctorList = try DCRAttendanceDoctorModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
        }
        
        return doctorList
    }
    func getCurrentStock(productCode:String) -> Int
    {
        var count = Int()
        
        try? dbPool.read { db in
            count = (try Int.fetchOne(db, "SELECT Current_Stock FROM \(MST_USER_DETAILS) WHERE Product_Code = '\(productCode)'"))!
        }
        
        return count
    }
    
    func getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: Int,dcrId: Int) -> [DCRAttendanceSampleDetailsModel]
    {
        var selectedDCRAttendanceDoctorVisitsSamples :[DCRAttendanceSampleDetailsModel] = []
        
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisitsSamples = try DCRAttendanceSampleDetailsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) WHERE DCR_Doctor_Visit_Id = ? AND DCR_Id = ?", arguments: [doctorVisitId,dcrId])
        }
        return selectedDCRAttendanceDoctorVisitsSamples
    }
    
    func getSelectedDCRAttendanceDoctorVisitSamples(dcrId: Int) -> [DCRAttendanceSampleDetailsModel]
    {
        var selectedDCRAttendanceDoctorVisitsSamples :[DCRAttendanceSampleDetailsModel] = []
        
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisitsSamples = try DCRAttendanceSampleDetailsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        return selectedDCRAttendanceDoctorVisitsSamples
    }
    
    func getSelectedDCRAttendanceDoctorVisitSamplesBatchs(dcrId: Int) -> [DCRSampleBatchModel]
    {
        var selectedDCRAttendanceDoctorVisitsSamples :[DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisitsSamples = try DCRSampleBatchModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = ? AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'", arguments: [dcrId])
        }
        return selectedDCRAttendanceDoctorVisitsSamples
    }
    
    func getSelectedDCRAttendanceDoctorVisitSamplesBatchs(dcrId: Int,doctorVisitId:Int) -> [DCRSampleBatchModel]
    {
        var selectedDCRAttendanceDoctorVisitsSamples :[DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            selectedDCRAttendanceDoctorVisitsSamples = try DCRSampleBatchModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = ? AND Visit_Id = ?  AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'", arguments: [dcrId,doctorVisitId])
        }
        return selectedDCRAttendanceDoctorVisitsSamples
    }
    
    func saveDCRAttendanceDoctorVisits(dcrAattendanceDoctorObj: DCRAttendanceDoctorModel) -> Int
    {
        var doctorVisitId: Int = 0
        
        try? dbPool.write({ db in
            try dcrAattendanceDoctorObj.insert(db)
            doctorVisitId = Int(db.lastInsertedRowID)
        })
        
        return doctorVisitId
    }
    
    func saveDCRAttendanceSampleDetails(dcrAttendanceSamples: [DCRAttendanceSampleDetailsModel])
    {
        try? dbPool.writeInTransaction{ db in
            
            for sampleObj in dcrAttendanceSamples
            {
                try sampleObj.insert(db)
            }
            return .commit
        }
    }
    
  func deleteDCRDoctorVisit(doctorVisitId: Int, dcrId: Int)
  {
    executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = \(dcrId) AND DCR_Doctor_Visit_Id = \(doctorVisitId)")
    }
    
    
    func deleteDCRSampleDetails(dcrId: Int, doctorVisitId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) WHERE DCR_Id = \(dcrId) AND DCR_Doctor_Visit_Id = \(doctorVisitId)")
    }
    
    func insertDCRAttendanceDoctorDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRAttendanceDoctorModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRAttendanceSampleDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRAttendanceSampleDetailsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func updateDCRAttendanceDoctorVisit(dcrDoctorVisitObj: DCRAttendanceDoctorModel)
    {
        let query = "UPDATE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) SET Visit_Mode ='\(dcrDoctorVisitObj.Visit_Mode!)',Visit_Time = '\(dcrDoctorVisitObj.Visit_Time!)',POB_Amount = \(dcrDoctorVisitObj.POB_Amount!),Remarks = '\(dcrDoctorVisitObj.Remarks!)', Lattitude = '\(dcrDoctorVisitObj.Lattitude!)', Longitude = '\(dcrDoctorVisitObj.Longitude!)', Business_Status_ID = \(dcrDoctorVisitObj.Business_Status_ID!), Business_Status_Name = '\(dcrDoctorVisitObj.Business_Status_Name!)', Business_Status_Active_Status = \(dcrDoctorVisitObj.Business_Status_Active_Status!), Call_Objective_ID = \(dcrDoctorVisitObj.Call_Objective_ID!), Call_Objective_Name = '\(dcrDoctorVisitObj.Call_Objective_Name!)', Call_Objective_Active_Status = \(dcrDoctorVisitObj.Call_Objective_Active_Status!), Campaign_Code = '\(dcrDoctorVisitObj.Campaign_Code!)', Campaign_Name = '\(dcrDoctorVisitObj.Campaign_Name!)' WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitObj.DCR_Doctor_Visit_Id!)"
        print(query)
        executeQuery(query: query)
    }
    
    func deleteCallActivity(doctorVisitId: Int, entityType: String, dcrId:Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRActivityCallType.fetchOne(db, "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments: [doctorVisitId,dcrId])            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteMCCallActivity(doctorVisitId: Int, entityType: String, dcrId:Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRMCActivityCallType.fetchOne(db, "DELETE FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments: [doctorVisitId,dcrId])            {
                try! rowValue.delete(db)
            }
        })
    }
}

