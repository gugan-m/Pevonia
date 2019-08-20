//
//  BL_SampleProducts.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_SampleProducts: NSObject {

    static let sharedInstance : BL_SampleProducts = BL_SampleProducts()
    
    var tpSampleList = [DCRSampleModel]()
    var selectedAttendanceDoctor : CustomerMasterModel?
    
    func getUserProducts(dateString:String) -> [UserProductMapping]
    {
        return DBHelper.sharedInstance.getUserProducts(dateString: dateString)!
    }
    
    func saveDoctorSampleDCRProducts(sampleProductList : [SampleBatchProductModel],isFrom:String,doctorVisitId:Int)
    {
        var dcrSampleProductList : [DCRSampleModel] = []
        var dcrSampleBatchProductList : [DCRSampleModel] = []
        var resultList : [DCRSampleModel] = []
        
        for sampleBatchObj in sampleProductList
        {
            if(sampleBatchObj.isShowSection)
            {
                for obj in sampleBatchObj.sampleList
                {
                    dcrSampleBatchProductList.append(obj)
                }
            }
            else
            {
                for obj in sampleBatchObj.sampleList
                {
                    dcrSampleProductList.append(obj)
                }
            }
            
        }
        
        for obj in dcrSampleBatchProductList
        {
            let filteredArray = resultList.filter{
                $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
            }
            
            if (filteredArray.count == 0)
            {
                
                let sampleProductObj = SampleProductsModel()
                sampleProductObj.Batch_Current_Stock =  obj.sampleObj.Batch_Current_Stock
                sampleProductObj.Batch_Name = obj.sampleObj.Batch_Name
                sampleProductObj.Current_Stock = obj.sampleObj.Current_Stock
                sampleProductObj.DCR_Code = obj.sampleObj.DCR_Code
                sampleProductObj.Product_Name = obj.sampleObj.Product_Name
                sampleProductObj.Product_Code = obj.sampleObj.Product_Code
                sampleProductObj.DCR_Id = obj.sampleObj.DCR_Id
                sampleProductObj.DCR_Doctor_Visit_Id = obj.sampleObj.DCR_Doctor_Visit_Id
                sampleProductObj.DCR_Doctor_Visit_Code = obj.sampleObj.DCR_Doctor_Visit_Code
                
                var qtyProvided: Int = 0

                let batchFilter = dcrSampleBatchProductList.filter{
                    $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
                }

                for objBatch in batchFilter
                {
                    qtyProvided += objBatch.sampleObj.Quantity_Provided
                }

               
                sampleProductObj.Quantity_Provided = qtyProvided
                
                let objDCRSample: DCRSampleModel = DCRSampleModel(sampleObj: sampleProductObj)
                
                resultList.append(objDCRSample)
            }
        }
        
        for obj in dcrSampleProductList
        {
            let filteredArray = resultList.filter{
                $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
            }
            if(filteredArray.count == 0)
            {
                resultList.append(obj)
            }
        }
        if(isFrom == sampleBatchEntity.Doctor.rawValue)
        {
            saveSampleDCRProducts(sampleProductList: resultList,dcrSampleBatchProductList: dcrSampleBatchProductList)
        }
        else if(isFrom == sampleBatchEntity.Chemist.rawValue)
        {
            saveSampleDCRChemistProducts(sampleProductList: resultList,dcrSampleBatchProductList: dcrSampleBatchProductList)
        }
        else if(isFrom == sampleBatchEntity.Attendance.rawValue)
        {
            BL_DCR_Attendance.sharedInstance.saveDcrAttendanceDoctorVisitSamples(dcrAttendanceDoctorVisitSamples: resultList, dcrSampleBatchProductList: dcrSampleBatchProductList, doctorVisitId: doctorVisitId)
        }
    }
    
    
    
    func saveSampleDCRProducts(sampleProductList : [DCRSampleModel],dcrSampleBatchProductList: [DCRSampleModel])
    {
        var dcrProductList : [DCRSampleModel] = []
        
        for obj in sampleProductList
        {
            obj.sampleObj.DCR_Id = getDcrId()
            obj.sampleObj.DCR_Code = getDcrCode()
            obj.sampleObj.DCR_Doctor_Visit_Id = getDCRDoctorVisitId()
            dcrProductList.append(obj)
        }
        
        addInwardQty(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId())
        
        DBHelper.sharedInstance.deleteDCRSampleDetails(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId())
        
        DBHelper.sharedInstance.insertDCRSampleProducts(sampleList : dcrProductList)
        
        subtractInwardQty(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId())
        
        let dcrSampleList = DBHelper.sharedInstance.getDCRSampleProducts(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId())
        
        var sampleBatchList: [DCRSampleBatchModel] = []
        
        for obj in dcrSampleBatchProductList
        {
          
            let filterArray = dcrSampleList?.filter{
                $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
            }
            let dict = ["DCR_Id":getDcrId(),"DCR_Code":getDcrCode(),"Visit_Id":getDCRDoctorVisitId(),"Visit_Code":"","Ref_Id":filterArray?.first?.sampleObj.DCR_Sample_Id ?? 0,"Product_Code":obj.sampleObj.Product_Code,"Batch_Number":obj.sampleObj.Batch_Name,"Quantity_Provided":"\(obj.sampleObj.Quantity_Provided!)","Entity_Type":sampleBatchEntity.Doctor.rawValue] as [String : Any]
            
            let dcrSampleBatch = DCRSampleBatchModel(dict: dict as NSDictionary)
            sampleBatchList.append(dcrSampleBatch)
        }
        
        addBatchInwardQty(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId(), entityType: sampleBatchEntity.Doctor.rawValue)
        
        DBHelper.sharedInstance.deleteDCRSampleBatchDetails(dcrId: getDcrId(), visitId: getDCRDoctorVisitId(), entityType: sampleBatchEntity.Doctor.rawValue)
        
        var i = 0
        
        for obj in dcrSampleBatchProductList
        {
            if obj.sampleObj.Quantity_Provided > 0
            {
                DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList : [sampleBatchList[i]])
                
            }
            i = i+1
        }
        
//        DBHelper.sharedInstance.insertDCRSampleBatchProducts(sampleList : sampleBatchList)
        
        subtractBatchInwardQty(dcrId: getDcrId(), doctorVisitId: getDCRDoctorVisitId(), entityType: sampleBatchEntity.Doctor.rawValue)
        
        
        
//        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Sample_Modified)
    }
    func saveSampleDCRChemistProducts(sampleProductList : [DCRSampleModel],dcrSampleBatchProductList: [DCRSampleModel])
    {
        var dcrChemistProductLists : [DCRChemistSamplePromotion] = []
        
        for obj in sampleProductList
        {
            let dict: NSDictionary = ["DCR_Id": getDcrId(), "DCR_Code": getDcrCode(), "Product_Code": obj.sampleObj.Product_Code, "Product_Name":obj.sampleObj.Product_Name, "Quantity_Provided": obj.sampleObj.Quantity_Provided, "DCR_Chemist_Day_Visit_Id": ChemistDay.sharedInstance.chemistVisitId,"CurrentStock":obj.sampleObj.Current_Stock]

            let dcrChemistProductList : DCRChemistSamplePromotion = DCRChemistSamplePromotion(dict: dict)

            dcrChemistProductLists.append(dcrChemistProductList)
        }
        
        addInwardQty(dcrId: getDcrId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        
        DBHelper.sharedInstance.deleteDCRChemistSampleDetails(dcrId: getDcrId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        
        DBHelper.sharedInstance.insertDCRChemistSampleProducts(sampleList : dcrChemistProductLists)
        
        subtractInwardQty(dcrId: getDcrId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        
        let dcrSampleList = DBHelper.sharedInstance.getDCRChemistSampleProducts(dcrId: getDcrId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        
        var sampleBatchList: [DCRSampleBatchModel] = []
        
        for obj in dcrSampleBatchProductList
        {
            
            let filterArray = dcrSampleList?.filter{
                $0.ProductCode == obj.sampleObj.Product_Code
            }
            let dict = ["DCR_Id":getDcrId(),"DCR_Code":getDcrCode(),"Visit_Id":ChemistDay.sharedInstance.chemistVisitId,"Visit_Code":"","Ref_Id":filterArray?.first?.DCRChemistSampleId ?? 0,"Product_Code":obj.sampleObj.Product_Code,"Batch_Number":obj.sampleObj.Batch_Name,"Quantity_Provided":"\(obj.sampleObj.Quantity_Provided!)","Entity_Type":sampleBatchEntity.Chemist.rawValue] as [String : Any]
            
            let dcrSampleBatch = DCRSampleBatchModel(dict: dict as NSDictionary)
            sampleBatchList.append(dcrSampleBatch)
        }
        
        addBatchInwardQty(dcrId: getDcrId(), doctorVisitId: ChemistDay.sharedInstance.chemistVisitId, entityType: sampleBatchEntity.Chemist.rawValue)
        
        DBHelper.sharedInstance.deleteDCRSampleBatchDetails(dcrId: getDcrId(), visitId: ChemistDay.sharedInstance.chemistVisitId, entityType: sampleBatchEntity.Chemist.rawValue)
        
        
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
        
        subtractBatchInwardQty(dcrId: getDcrId(), doctorVisitId: ChemistDay.sharedInstance.chemistVisitId, entityType: sampleBatchEntity.Chemist.rawValue)
        
        //        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Sample_Modified)
    }
    
//    func saveSampleDCRAttendenceProducts(sampleProductList : [DCRSampleModel],dcrDate: Date,doctorVisitId:Int)
//    {
//
//
//        var dcrAttendanceProductLists : [DCRAttendanceSampleDetailsModel] = []
////
//        for obj in sampleProductList
//        {
//            let dict: NSDictionary = ["DCR_Id": getDcrId(), "DCR_Code": getDcrCode(), "Product_Code": obj.sampleObj.Product_Code, "Product_Name":obj.sampleObj.Product_Name, "Quantity_Provided": obj.sampleObj.Quantity_Provided, "DCR_Chemist_Day_Visit_Id": ChemistDay.sharedInstance.chemistVisitId,"DCR_Actual_Date":dcrDate,"DCR_Doctor_Visit_Id":doctorVisitId,"DCR_Doctor_Visit_Code":""]
//            
//            let dcrCAttendenceProductList : DCRAttendanceSampleDetailsModel = DCRAttendanceSampleDetailsModel(dict: dict)
//            
//            dcrAttendanceProductLists.append(dcrCAttendenceProductList)
//        }
//        
//        addInwardQty(dcrId: getDcrId(), attendanceDoctorVisitId: doctorVisitId)
//        
//        DAL_DCR_Attendance.sharedInstance.deleteDCRChemistSampleDetails(dcrId: getDcrId(), doctorVisitId: doctorVisitId)
//        
//        DAL_DCR_Attendance.sharedInstance.saveDCRAttendanceSampleDetails(dcrAttendanceSamples: dcrAttendanceProductLists)
//        
//        addInwardQty(dcrId: getDcrId(), attendanceDoctorVisitId: doctorVisitId)
//
//
//    }
    func addInwardQty(dcrId: Int, attendanceDoctorVisitId: Int)
    {
        updateInwardQty(operation: "+", dcrId: dcrId, attendanceDoctorVisitId: attendanceDoctorVisitId)
    }
    
    func subtractInwardQty(dcrId: Int, attendanceDoctorVisitId: Int)
    {
        updateInwardQty(operation: "-", dcrId: dcrId, attendanceDoctorVisitId: attendanceDoctorVisitId)
    }

    func addInwardQty(dcrId: Int, chemistVisitId: Int)
    {
        updateInwardQty(operation: "+", dcrId: dcrId, chemistVisitId: chemistVisitId)
    }

    func subtractInwardQty(dcrId: Int, chemistVisitId: Int)
    {
        updateInwardQty(operation: "-", dcrId: dcrId, chemistVisitId: chemistVisitId)
    }

    func addInwardQty(dcrId: Int, doctorVisitId: Int)
    {
        updateInwardQty(operation: "+", dcrId: dcrId, doctorVisitId: doctorVisitId)
    }
    
    func subtractInwardQty(dcrId: Int, doctorVisitId: Int)
    {
        updateInwardQty(operation: "-", dcrId: dcrId, doctorVisitId: doctorVisitId)
    }
    
    func addBatchInwardQty(dcrId: Int, doctorVisitId: Int, entityType: String)
    {
        updateBatchInwardQty(operation: "+", dcrId: dcrId, visitId: doctorVisitId,entityType:entityType)
    }
    
    func subtractBatchInwardQty(dcrId: Int, doctorVisitId: Int, entityType: String)
    {
        updateBatchInwardQty(operation: "-", dcrId: dcrId, visitId: doctorVisitId,entityType:entityType)
    }
    
    func getSampleDCRProducts(dcrId: Int, doctorVisitId: Int) -> [DCRSampleModel]?
    {
        return DBHelper.sharedInstance.getDCRSampleProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
    }
    
    func getSampleDCRAttendanceProducts(dcrId: Int, doctorVisitId: Int) -> [DCRSampleModel]?
    {
        return DBHelper.sharedInstance.getDCRSampleProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
    }
    
    func getSampleBatchDCRProducts(dcrId: Int, visitId: Int,entityType: String) -> [DCRSampleBatchModel]
    {
        return DBHelper.sharedInstance.getDCRSampleBatchProducts(dcrId: dcrId, visitId: visitId, entityType: entityType)
    }
    
    func getSampleDCRChemistProducts(dcrId: Int, chemistVisitId: Int) -> [DCRChemistSamplePromotion]?
    {
        return DBHelper.sharedInstance.getDCRChemistSampleProducts(dcrId: dcrId, chemistVisitId: chemistVisitId)
    }

    
    func getSampleTPProducts(tpID: Int, doctorVisitId: Int) -> [DCRSampleModel]?
    {
        return DBHelper.sharedInstance.getDCRSampleProducts(dcrId: tpID, doctorVisitId: doctorVisitId)
    }
    
    func getSelectProductCode(dcrId: Int, doctorVisitId: Int) -> [String]
    {
        var selectedList : [String] = []
        
        if let selectedDCRList =  BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
        {
            for dcrSample in selectedDCRList
            {
                if dcrSample.sampleObj.Product_Code != nil
                {
                    selectedList.append(dcrSample.sampleObj.Product_Code)
                }
            }
        }
        return selectedList
    }
    
    func getSelectChemistProductCode(dcrId: Int, chemistVisitId: Int) -> [String]
    {
        var selectedList : [String] = []
        
        if let selectedDCRList =  BL_SampleProducts.sharedInstance.getSampleDCRChemistProducts(dcrId: dcrId, chemistVisitId:chemistVisitId)
        {
            for dcrChemistSample in selectedDCRList
            {
                if dcrChemistSample.ProductCode != nil
                {
                    selectedList.append(dcrChemistSample.ProductCode)
                }
            }

        }
         return selectedList
    }
    
    func getSelectedSampleProducts(userSelectedCode :[String],dateString: String) -> [UserProductMapping]
    {
        var selectedList : [UserProductMapping] = []
        let  userProductsList :[UserProductMapping] = BL_SampleProducts.sharedInstance.getUserProducts(dateString: dateString)
        selectedList = userProductsList.filter
            {
                userSelectedCode.contains($0.Product_Code)
        }
        
        return selectedList
    }
    
    func getSelectedSampleProducts1(userSelectedCode :[String],dateString: String,isComingFromChemistDay:Bool,isComingFromAttendanceDoctor:Bool,attendanceDoctorVisitId:Int) -> [UserProductMapping]
    {
        var selectedList : [UserProductMapping] = []
        let  userProductsList :[UserProductMapping] = BL_SampleProducts.sharedInstance.getUserProducts(dateString: dateString)
        selectedList = userProductsList.filter
        {
            userSelectedCode.contains($0.Product_Code)
        }
        
        if(isComingFromChemistDay)
        {
           let userDCRChemistProductList = BL_SampleProducts.sharedInstance.getSampleDCRChemistProducts(dcrId: DCRModel.sharedInstance.dcrId, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)!
            
            
            for sampleObj in selectedList
            {
                let filterValue = userDCRChemistProductList.filter{
                    $0.ProductCode == sampleObj.Product_Code
                }
                if(filterValue.count > 0)
                {
                    let dcrSelectedSample = filterValue.first!
                    
                    sampleObj.dcrId = dcrSelectedSample.DCRId
                    sampleObj.visitId = dcrSelectedSample.DCRChemistDayVisitId
                    sampleObj.sampleId = dcrSelectedSample.DCRChemistSampleId
                }
                
            }
           
            
        }
        else if(isComingFromAttendanceDoctor)
        {
           let userDCRAttendenceProductList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: attendanceDoctorVisitId, dcrId: DCRModel.sharedInstance.dcrId)
            
            for sampleObj in selectedList
            {
                let filterValue = userDCRAttendenceProductList.filter{
                    $0.Product_Code == sampleObj.Product_Code
                }
                
                if(filterValue.count > 0)
                {
                    let dcrSelectedSample = filterValue.first!
                    
                    sampleObj.dcrId = dcrSelectedSample.DCR_Id!
                    sampleObj.visitId = dcrSelectedSample.DCR_Doctor_Visit_Id
                    sampleObj.sampleId = dcrSelectedSample.DCR_Attendance_Sample_Id
                }
                
            }
        }
        else
        {
            
            let userDCRProductList = BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)!
            
            for sampleObj in selectedList
            {
                let filterValue = userDCRProductList.filter{
                    $0.sampleObj.Product_Code == sampleObj.Product_Code
                }
                
                if(filterValue.count > 0)
                {
                    
                    let dcrSelectedSample = filterValue.first!
                    
                    sampleObj.dcrId = dcrSelectedSample.sampleObj.DCR_Id!
                    sampleObj.visitId = dcrSelectedSample.sampleObj.DCR_Doctor_Visit_Id
                    sampleObj.sampleId = dcrSelectedSample.sampleObj.DCR_Sample_Id
                }
                
            }
        }
        
        return selectedList
    }
    
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
    
    func updateInwardQty(operation: String, dcrId: Int, doctorVisitId: Int)
    {
        let dcrSampleProductList = getSampleDCRProducts(dcrId: dcrId, doctorVisitId: doctorVisitId)
        
        BL_DCR_Refresh.sharedInstance.updateInwardQty(operation: operation, inwardProductList: dcrSampleProductList)
    }
    
    func updateBatchInwardQty(operation: String, dcrId: Int, visitId: Int,entityType: String)
    {
        let dcrSampleProductList = getSampleBatchDCRProducts(dcrId: dcrId, visitId: visitId,entityType: entityType)
        
        BL_DCR_Refresh.sharedInstance.updateBatchInwardQty(operation: operation, inwardProductList: dcrSampleProductList)
    }
    
    func updateInwardQty(operation: String, dcrId: Int, chemistVisitId: Int)
    {
        let dcrChemistSampleProductList = getSampleDCRChemistProducts(dcrId: dcrId, chemistVisitId: chemistVisitId)
        
        BL_DCR_Refresh.sharedInstance.updateChemistInwardQty(operation: operation, inwardProductList: dcrChemistSampleProductList)
    }
    
  
    
    func updateInwardQty(operation: String, dcrId: Int, attendanceDoctorVisitId: Int)
    {
        
        let dcrAttendanceSampleList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: attendanceDoctorVisitId, dcrId: dcrId)

        
        BL_DCR_Refresh.sharedInstance.updateAttendanceDoctorInwardQty(operation: operation, inwardProductList: dcrAttendanceSampleList)
    }
    
    func convertToSampleBatchModel(selectedList:[DCRSampleModel],isComingFromModifyPage:Bool,dcrId:Int,visitId:Int,sampleId:Int) -> [SampleBatchProductModel]
    {
        var sampleProductBatchList: [SampleBatchProductModel] = []
        
        for sampleObj in selectedList
        {
            let sampleListObj = SampleBatchProductModel()
            var sampleModelList:[DCRSampleModel] = []
            let sampleBatchList = DBHelper.sharedInstance.getBatchFromProductCode(productCode: sampleObj.sampleObj.Product_Code,dcrDate:DCRModel.sharedInstance.dcrDateString!)
            var sampleDcrBatchList : [DCRSampleBatchModel] = []
            if(isComingFromModifyPage)
            {
                if(sampleObj.sampleObj.DCR_Id > 0 && sampleObj.sampleObj.DCR_Doctor_Visit_Id > 0 && (sampleObj.sampleObj.DCR_Sample_Id > 0))
                {
                    sampleDcrBatchList = DBHelper.sharedInstance.getDCRSampleBatchProducts(dcrId: sampleObj.sampleObj.DCR_Id, visitId: sampleObj.sampleObj.DCR_Doctor_Visit_Id,productCode: sampleObj.sampleObj.Product_Code,sampleId:sampleObj.sampleObj.DCR_Sample_Id)
                }
                
                if(sampleDcrBatchList.count == 0)
                {
                    sampleDcrBatchList = DBHelper.sharedInstance.getDCRSampleBatchProducts(dcrId: dcrId, visitId: visitId,productCode: sampleObj.sampleObj.Product_Code,sampleId:sampleId)

                }
            }
            else
            {
                if(sampleObj.sampleObj.DCR_Id > 0 && sampleObj.sampleObj.DCR_Doctor_Visit_Id > 0 && (sampleObj.sampleObj.DCR_Sample_Id > 0))
                {
                    sampleDcrBatchList = DBHelper.sharedInstance.getDCRSampleBatchProducts(dcrId: sampleObj.sampleObj.DCR_Id, visitId: sampleObj.sampleObj.DCR_Doctor_Visit_Id,productCode: sampleObj.sampleObj.Product_Code,sampleId:sampleObj.sampleObj.DCR_Sample_Id)
                }
            }
            if(sampleBatchList.count > 0)
            {
                sampleListObj.title = sampleObj.sampleObj.Product_Name
                sampleListObj.isShowSection = true
                for batchObj in sampleBatchList
                {
                    
                    
                    let filterValue = sampleDcrBatchList.filter{
                        $0.Batch_Number == batchObj.Batch_Number
                    }
                    var quantity = Int()
                    if(sampleDcrBatchList.count == 0)
                    {
                        quantity = 0
                            //sampleObj.sampleObj.Quantity_Provided
                    }
                    else
                    {
                        if(filterValue.count>0)
                        {
                            quantity = (filterValue.first?.Quantity_Provided)!
                        }
                        else
                        {
                            quantity = 0
                        }
                    }
                    
                    //(dcrId: sampleObj.sampleObj.DCR_Id, visitId: sampleObj.sampleObj.DCR_Doctor_Visit_Id,productCode:)
                    
            
                    var batchCurrentStock = Int()
                    if( batchObj.Batch_Current_Stock >= 0)
                    {
                        batchCurrentStock = batchObj.Batch_Current_Stock
                    }
                    else
                    {
                        batchCurrentStock = 0
                    }
                    let sampleProductObj = SampleProductsModel()
                    sampleProductObj.Batch_Current_Stock = batchCurrentStock + quantity
                    sampleProductObj.Batch_Name = batchObj.Batch_Number
                    sampleProductObj.Current_Stock = sampleObj.sampleObj.Current_Stock
                    sampleProductObj.DCR_Code = sampleObj.sampleObj.DCR_Code
                    sampleProductObj.Product_Name = sampleObj.sampleObj.Product_Name
                    sampleProductObj.Product_Code = sampleObj.sampleObj.Product_Code
                    sampleProductObj.Quantity_Provided = quantity
                    sampleProductObj.DCR_Id = sampleObj.sampleObj.DCR_Id
                    sampleProductObj.DCR_Doctor_Visit_Id = sampleObj.sampleObj.DCR_Doctor_Visit_Id
                    sampleProductObj.DCR_Doctor_Visit_Code = sampleObj.sampleObj.DCR_Doctor_Visit_Code
                    sampleProductObj.DCR_Sample_Id = sampleObj.sampleObj.DCR_Sample_Id
                    let dict = DCRSampleModel(sampleObj: sampleProductObj)
                    sampleModelList.append(dict)
                }
                sampleListObj.sampleList = sampleModelList
                
                sampleProductBatchList.append(sampleListObj)
            }
        }
        var sampleModelLists:[DCRSampleModel] = []
        let sampleListObj = SampleBatchProductModel()
        sampleListObj.title = ""
        sampleListObj.isShowSection = false
        for sampleObjs in selectedList
        {
            let sampleBatchList = DBHelper.sharedInstance.getBatchFromProductCode(productCode: sampleObjs.sampleObj.Product_Code, dcrDate: DCRModel.sharedInstance.dcrDateString!)
            if(sampleBatchList.count == 0)
            {
                
                let sampleBatchObj = sampleObjs
                
                sampleModelLists.append(sampleBatchObj)
            }
        }
        sampleListObj.sampleList = sampleModelLists
        sampleProductBatchList.append(sampleListObj)
        
        return sampleProductBatchList
    }
    
    func getSampleBatchProducts(date:String) -> [SampleBatchMapping]
    {
        return DBHelper.sharedInstance.getBatchSampleProducts(dateString: date)
    }
    

}
