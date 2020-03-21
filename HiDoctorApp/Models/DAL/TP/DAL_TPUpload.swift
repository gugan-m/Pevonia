//
//  DAL_TPUpload.swift
//  HiDoctorApp
//
//  Created by Vijay on 14/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DAL_TPUpload: NSObject
{
    static let sharedInstance = DAL_TPUpload()
    
    func getPendingUploadMonthWiseCount() -> [Row]
    {
        var rows: [Row] = []
        
       try? dbPool.read { db in
            rows = try Row.fetchAll(db, "SELECT COUNT(TP_Entry_Id) AS 'Count', STRFTIME('%m-%Y', TP_Date) as 'Month-Year' FROM \(TRAN_TP_HEADER) WHERE Status = \(TPStatus.applied.rawValue) AND TP_Id = 0 GROUP BY STRFTIME('%m-%Y', TP_Date)")
        }
        
        return rows
    }
    
    func getPendingUploadTPsList(month: Int, year: Int) -> [TourPlannerHeader]
    {
        var rows: [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            rows = try TourPlannerHeader.fetchAll(db, "SELECT * FROM tran_TP_Header WHERE CAST(STRFTIME('%m', TP_Date) AS INT) = \(month) AND CAST(STRFTIME('%Y', TP_Date) AS INT) = \(year) AND Status = \(TPStatus.applied.rawValue) AND TP_Id = 0 ORDER BY TP_Date")
        }
        
        return rows
    }
    
    func updateStatus(tpEntryId:Int)
    {
        let query = "UPDATE \(TRAN_TP_HEADER) SET Status = 3,TP_Id = 1  WHERE TP_Entry_Id = \(tpEntryId)"
        executeQuery(query: query)
    }
    
    func updateTPId(tpEntryId: Int, tpId: Int, tpStatus: Int, uploadMessage: String)
    {
        let query = "UPDATE \(TRAN_TP_HEADER) SET TP_Id = \(tpId), Status = \(tpStatus), Upload_Message = '\(uploadMessage)' WHERE TP_Entry_Id = \(tpEntryId)"
        
        executeQuery(query: query)
    }
    
    func updateAttachmentTPId(tpEntryId: Int, tpId: Int, TP_Doctor_Id: Int)
    {
        let query = "UPDATE \(TRAN_TP_DOCTOR_VISIT_ATTACHMENT) SET TP_Id = \(tpId), TP_Doctor_Id = \(TP_Doctor_Id) WHERE TP_Entry_Id = \(tpEntryId)"
        
        executeQuery(query: query)
    }
    
    
}
