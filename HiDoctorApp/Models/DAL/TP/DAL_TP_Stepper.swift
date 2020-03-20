//
//  DAL_TP_Stepper.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DAL_TP_Stepper: NSObject {
    static let sharedInstance = DAL_TP_Stepper()
    
    
    //MARK:- Functions for TPAccompanist
    
    func getAllAccompanistList() -> [AccompanistModel]
    {
        var modelList: [AccompanistModel] = []
        try? dbPool.read { db in
            modelList = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST)")
            }
        return modelList
    }
 
    func insertSelectedAccompanistDetails(dictArray : NSMutableArray)
    {
        for dict in dictArray
        {
            try? dbPool.write({ db in
                try TourPlannerAccompanist(dict: dict as! NSDictionary).insert(db)
            })
        }
    }
    
    func getSelectedAccompanistsDetails(tp_Entry_Id: Int) -> [TourPlannerAccompanist]
    {
        var accList: [TourPlannerAccompanist] = []
        try? dbPool.read { db in
            accList = try TourPlannerAccompanist.fetchAll(db, "SELECT * FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return accList
    }
    func deleteAccompanists(tp_Entry_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerAccompanist.fetchOne(db, "DELETE FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = ? ", arguments: [tp_Entry_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteSelectedAccompanists(tp_Entry_Id: Int,Acc_Code: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerAccompanist.fetchOne(db, "DELETE FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = ? AND Acc_User_Code = ?" , arguments: [tp_Entry_Id,Acc_Code])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- Delete TP
    func deleteTP(tpEntryId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_TP_PRODUCT) WHERE TP_Entry_Id = \(tpEntryId)")
        executeQuery(query: "DELETE FROM \(TRAN_TP_DOCTOR) WHERE TP_Entry_Id = \(tpEntryId)")
        executeQuery(query: "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = \(tpEntryId)")
        executeQuery(query: "DELETE FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = \(tpEntryId)")
        executeQuery(query: "DELETE FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = \(tpEntryId)")
       // executeQuery(query: "DELETE FROM \(TRAN_TP_DOCTOR_VISIT_ATTACHMENT) WHERE TP_Entry_Id = \(tpEntryId)")
    }

    //MARK:- Functions to update and get MeetingPoint&MeetingTime details
    
    func getMeetingDetails(tp_Entry_Id: Int)-> TourPlannerHeader?
    {
        var meetingModel: TourPlannerHeader?
        
        try? dbPool.read { db in
            meetingModel = try TourPlannerHeader.fetchOne(db, "SELECT Meeting_Place ,Meeting_Time FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        
        return meetingModel
    }
    
    func updateMeetingDetails(meetingPlace: String, meetingTime: String, tp_Entry_Id: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Meeting_Place = '\(meetingPlace)', Meeting_Time = '\(meetingTime)',Status = \(TPStatus.drafted.rawValue) WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }
    
    //MARK:- Functions to Update and get WorkPlaceDetails
    
    func getTPAttendanceWorkPlaceDetails(tp_Entry_Id: Int)-> TourPlannerHeader?
    {
        var workPlaceModel: TourPlannerHeader?
        
        try? dbPool.read { db in
            workPlaceModel = try TourPlannerHeader.fetchOne(db, "SELECT Work_Place ,Category_Name FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return workPlaceModel
    }
    
    func updateTPAttendanceWorkPlaceModel(workPlaceObj: TourPlannerHeader,tp_Entry_Id: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Work_Place = '\(workPlaceObj.Work_Place!)', Category_Name = '\(workPlaceObj.Category_Name!)' WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }

    //MARK:- Functions for get and update TPGeneralReamrks And AttendanceRemarks
    func getGeneralRemarks(tp_Entry_Id: Int) -> TourPlannerHeader?
    {
        var remarksModel: TourPlannerHeader?
        
        try? dbPool.read { db in
            remarksModel = try TourPlannerHeader.fetchOne(db, "SELECT Remarks FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return remarksModel
    }
    
    func updateGeneralRemarks(tp_Entry_Id: Int, remarks: String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Remarks = '\(remarks)', Status = \(TPStatus.drafted.rawValue)  WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }
    
    //MARK:- Functions for get and update TPAttendanceActivity
    func getAttendanceActivity(tp_Entry_Id: Int) -> TourPlannerHeader?
    {
        var activityModel: TourPlannerHeader?
        
        try? dbPool.read { db in
            activityModel = try TourPlannerHeader.fetchOne(db, "SELECT Activity_Name FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return activityModel
    }
    
    func updateAttendanceActivity(tp_Entry_Id: Int, activityCode: String, activityName: String, projectCode: String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Activity_Code = '\(activityCode)', Activity_Name = '\(activityName)', Project_Code = '\(projectCode)' WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }
    
    //MARK:- Copy Accompanist SFC
    
    func insertAccomapanistSFC(dictArray : [NSMutableDictionary])
    {
        for dict in dictArray{
            
            try? dbPool.write({ db in
                try TourPlannerSFC(dict: dict).insert(db)
            })
        }
    }
    
    //MARK:- Copy Accompanist DoctorDetails
    
    func insertAccomapanistDoctorDetails(dictArray : [NSMutableDictionary])
    {
        for dict in dictArray{
            
            try? dbPool.write({ db in
                try TourPlannerDoctor(dict: dict).insert(db)
            })
        }
    }
    
    //MARK:- Copy AccomapanistHeader Details
    
    func updateHeaderDetailsFromAccHeader(tp_Entry_Id: Int, cp_Code: String, category_Code: String, work_Place: String, cp_Name: String, meeting_Place: String, meeting_Time: String, category_Name: String, remarks: String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET CP_Code = '\(cp_Code)', Category_Code = '\(category_Code)', Work_Place = '\(work_Place)', CP_Name = '\(cp_Name)', Meeting_Place = '\(meeting_Place)', Meeting_Time = '\(meeting_Time)', Category_Name = '\(category_Name)', Remarks = '\(remarks)' WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }
    
    //MARK:- Delete CopiedAccompanist SFC
    
    func deleteCopiedAccSFC(tp_Entry_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = ? ", arguments: [tp_Entry_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- Delete CopiedAccompanist DoctorDetails
    
    func deleteCopiedAccDoctorDetails(tp_Entry_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerDoctor.fetchOne(db, "DELETE FROM \(TRAN_TP_DOCTOR) WHERE TP_Entry_Id = ? ", arguments: [tp_Entry_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteCopiedAccDoctorSamples(tp_Entry_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerProduct.fetchOne(db, "DELETE FROM \(TRAN_TP_PRODUCT) WHERE TP_Entry_Id = ? ", arguments: [tp_Entry_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- TP SFC Functions to get selected travelplaceslist
    
    func getTPSelectedSFCDetails(tp_Entry_Id: Int) -> [TourPlannerSFC]?
    {
        var sfcList : [TourPlannerSFC]?
        
        try? dbPool.read { db in
            sfcList = try TourPlannerSFC.fetchAll(db, "SELECT * FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return sfcList
    }
    
    func insertSelectedSFC(dictArray : NSMutableArray)
    {
        for dict in dictArray{
            
            try? dbPool.write({ db in
                try TourPlannerSFC(dict: dict as! NSDictionary).insert(db)
            })
        }
    }
    func deleteSelectedSFC(tp_SFC_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerDoctor.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_SFC_Id = ? ", arguments: [tp_SFC_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- Get lastSyncDate 
    
    func getLastSyncedDate(apiname: String) -> ApiDownloadDetailModel
    {
        var apiModel: ApiDownloadDetailModel?
        
        try? dbPool.read
            { db in
            apiModel = try ApiDownloadDetailModel.fetchOne(db, "SELECT * FROM \(MST_API_DOWNLOAD_DETAILS) WHERE Api_Name = ? ORDER BY Download_Date DESC LIMIT 1" , arguments: [apiname])!
        }
      return apiModel!
    }
    
    //MARK:- Functions for save,get and delete doctorDetailsFromTP
    
    func deleteSelectedDoctorFromTP(tp_Doctor_Id: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerDoctor.fetchOne(db, "DELETE FROM \(TRAN_TP_DOCTOR) WHERE TP_Doctor_Id = ? ", arguments: [tp_Doctor_Id])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getSelectedDoctor(tp_Entry_Id: Int) -> [TourPlannerDoctor]
    {
        var sampleList: [TourPlannerDoctor] = []
        try? dbPool.read { db in
            sampleList = try TourPlannerDoctor.fetchAll(db, "SELECT * FROM \(TRAN_TP_DOCTOR) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return sampleList
    }
    
    func insertTPDoctors(lstTPDoctors: [TourPlannerDoctor])
    {
        try? dbPool.writeInTransaction { db in
            for obj in lstTPDoctors
            {
                try obj.insert(db)
            }
            return .commit
        }
    }
    
    //MARK:- Functions for save,get and delete samplesForDoctorFromTP
    
    func deleteSelectedSamplesForDoctor(tpEntryId: Int, doctorCode: String, regionCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerProduct.fetchOne(db, "DELETE FROM \(TRAN_TP_PRODUCT) WHERE TP_Entry_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [tpEntryId, doctorCode, regionCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getSelectedSamples(tp_Entry_Id: Int) -> [TourPlannerProduct]
    {
        var sampleList: [TourPlannerProduct] = []
        
        try? dbPool.read { db in
            sampleList = try TourPlannerProduct.fetchAll(db, "SELECT * FROM \(TRAN_TP_PRODUCT) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        
        return sampleList
    }
    func getSelectedSamplesFromTP(tp_ID: Int,Doctorcode: String) -> [TourPlannerProduct]
    {
        var sampleList: [TourPlannerProduct] = []
        
        try? dbPool.read { db in
            sampleList = try TourPlannerProduct.fetchAll(db, "SELECT * FROM \(TRAN_TP_PRODUCT) WHERE TP_Id = ? AND Doctor_Code = ?", arguments: [tp_ID,Doctorcode])
        }
        
        return sampleList
    }
    
    func getTPAttachmentList(entry_Id: Int) -> [TPAttachmentModel]?
    {
        return DBHelper.sharedInstance.getTPAttachmentList(entry_Id:entry_Id)
    }
    
    func insertSelectedSamples(lstTPSamples :[TourPlannerProduct])
    {
        try? dbPool.writeInTransaction { db in
            for obj in lstTPSamples
            {
                try obj.insert(db)
            }
            return .commit
        }
    }
    
    //MARK:- Functions to Update and get WorkPlaceDetails for TPAttendance
    
    func getWorkPlaceDetails(tp_Entry_Id: Int)-> TourPlannerHeader?
    {
        var workPlaceModel: TourPlannerHeader?
        
        try? dbPool.read { db in
            workPlaceModel = try TourPlannerHeader.fetchOne(db, "SELECT Work_Place ,Category_Name,CP_Name  FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tp_Entry_Id])
        }
        return workPlaceModel
    }
    
    func updateWorkPlaceModel(workPlaceObj: TourPlannerHeader,tp_Entry_Id: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Work_Place = '\(workPlaceObj.Work_Place!)', Category_Name = '\(workPlaceObj.Category_Name!)',Category_Code = '\(workPlaceObj.Category_Code!)', CP_Name = '\(workPlaceObj.CP_Name!)',CP_Code = '\(workPlaceObj.CP_Code!)',Status = \(TPStatus.drafted.rawValue)  WHERE TP_Entry_Id = \(tp_Entry_Id)")
    }
    
    func updateTourPlannerLeave(tpEntryId: Int, activity_code: String, activity_Name: String, leave_reason: String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET  Activity_Code = '\(activity_code)', Activity_Name = '\(activity_Name)',Remarks = '\(leave_reason)',Status = \(TPStatus.applied.rawValue), Upload_Message = '\(EMPTY)',TP_Id = 0, Activity = \(TPFlag.leave.rawValue) WHERE TP_Entry_Id = \(tpEntryId)")
    }
    
    func updateTourPlannerStatus(tpEntryId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Status = \(TPStatus.applied.rawValue), TP_Id = 0, Upload_Message = '' WHERE TP_Entry_Id = \(tpEntryId)")
    }
    func changeTPStatusToDraft(tpEntryId: Int)
    {
       executeQuery(query: "UPDATE \(TRAN_TP_HEADER) SET Status = \(TPStatus.drafted.rawValue) WHERE TP_Entry_Id = \(tpEntryId)")
    }
}
