//
//  DAL_TP_SFC.swift
//  HiDoctorApp
//
//  Created by Admin on 8/9/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DAL_TP_Calendar: NSObject {
    
    static let sharedInstance = DAL_TP_Calendar()
    
    func getListOfTpAccompanist(tpId: Int) -> [TourPlannerAccompanist]
    {
        var modelList: [TourPlannerAccompanist] = []
        
        try? dbPool.read { db in
            
            modelList = try TourPlannerAccompanist.fetchAll(db, "SELECT * FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = ?", arguments: [tpId])
            
        }
        
        return modelList
    }
    
    func getListOfTpSFC(tpId: Int) -> [TourPlannerSFC]
    {
        var modelList: [TourPlannerSFC] = []
        
        try? dbPool.read { db in
            
            modelList = try TourPlannerSFC.fetchAll(db, "SELECT * FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = ?", arguments: [tpId])
            
        }
        
        return modelList
    }
    
    func getListOfTpDoctors(tpId: Int) -> [TourPlannerDoctor]
    {
        var modelList: [TourPlannerDoctor] = []
        
        try? dbPool.read { db in
            
            modelList = try TourPlannerDoctor.fetchAll(db, "SELECT * FROM \(TRAN_TP_DOCTOR) WHERE TP_Entry_Id = ?", arguments: [tpId])
            
        }
        
        return modelList
    }
    
    func deleteTPDraftedAndUnApprovedDetails(tpId: Int)
    {
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = \(tpId)")
        
    }
    
    func insertTPHeaderData(tourPlannerHeader: TourPlannerHeader)
    {
        
        try? dbPool.write({ db in
            try tourPlannerHeader.insert(db)
        })
        
    }
    
    
        
}
