//
//  DAL_TP_SFC.swift
//  HiDoctorApp
//
//  Created by Admin on 8/9/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DAL_TP_SFC: NSObject {
    
    static let sharedInstance = DAL_TP_SFC()
    
    func getTPAccompanistList(tpId: Int) -> [TourPlannerAccompanist]?
    {
        var accompanistList: [TourPlannerAccompanist] = []
        
        try? dbPool.read { db in
            accompanistList = try TourPlannerAccompanist.fetchAll(db, "SELECT \(TRAN_TP_ACCOMPANIST).*,mst_Accompanist.Employee_name, mst_Accompanist.Region_Name FROM \(TRAN_TP_ACCOMPANIST) INNER JOIN mst_Accompanist ON \(TRAN_TP_ACCOMPANIST).Acc_Region_Code = mst_Accompanist.Region_Code AND \(TRAN_TP_ACCOMPANIST).Acc_User_Code = mst_Accompanist.User_Code WHERE \(TRAN_TP_ACCOMPANIST).TP_Entry_Id = ? ORDER BY mst_Accompanist.Employee_name", arguments: [tpId])
        }

        return accompanistList
    }
    
    func getPlaceList(regionCode: String, categoryName: String) -> [SFCMasterModel]?
    {
        var placeList: [SFCMasterModel] = []
        let tpDate = TPModel.sharedInstance.tpDate
        
        if categoryName != ""
        {
            try? dbPool.read { db in
                placeList = try SFCMasterModel.fetchAll(db, "SELECT From_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Category_Name = ? AND Date_From <= ? AND Date_To >= ? UNION SELECT To_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Category_Name = ? AND Date_From <= ? AND Date_To >= ?", arguments:[regionCode, categoryName, tpDate, tpDate, regionCode, categoryName, tpDate, tpDate])
            }
        } else
        {
            try? dbPool.read { db in
                placeList = try SFCMasterModel.fetchAll(db, "SELECT From_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Date_From <= ? AND Date_To >= ? UNION SELECT To_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Date_From <= ? AND Date_To >= ?", arguments:[regionCode, tpDate, tpDate, regionCode, tpDate, tpDate])
            }
        }
        
        return placeList
    }
    
    func getSFCDetailsBasedonPlaces(fromPlace : String, toPlace : String, regionCodeList : [String], categoryName: String) -> [SFCMasterModel]?
    {
        var sfcList: [SFCMasterModel] = []
        let dcrDate = TPModel.sharedInstance.tpDate
        
        var regionCodeString = ""
        
        for i in 0..<regionCodeList.count
        {
            regionCodeString += "'" + regionCodeList[i] + "',"
        }
        
        if (regionCodeString != "")
        {
            regionCodeString = regionCodeString.substring(to: regionCodeString.index(before: regionCodeString.endIndex))
        }
        
        if categoryName != ""
        {
            try? dbPool.read { db in
                sfcList = try SFCMasterModel.fetchAll(db, "SELECT Travel_Mode, Distance_Fare_Code, Distance, SFC_Version, Category_Name, Region_Code, From_Place, To_Place FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Category_Name = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate, categoryName])
            }
        }
        else
        {
            try? dbPool.read { db in
                sfcList = try SFCMasterModel.fetchAll(db, "SELECT Travel_Mode, Distance_Fare_Code, Distance, SFC_Version, Category_Name, Region_Code, From_Place, To_Place FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
            }
        }
        
        return sfcList
    }
    
    func getSFCDetailsBasedonPlacesandTravelmode(fromPlace : String, toPlace : String, regionCodeList : [String], categoryName: String, travelMode: String) -> [SFCMasterModel]?
    {
        var sfcList: [SFCMasterModel] = []
        let dcrDate = TPModel.sharedInstance.tpDate
        
        var regionCodeString = ""
        
        for i in 0..<regionCodeList.count
        {
            regionCodeString += "'" + regionCodeList[i] + "',"
        }
        
        if (regionCodeString != "")
        {
            regionCodeString = regionCodeString.substring(to: regionCodeString.index(before: regionCodeString.endIndex))
        }
        
        if categoryName != ""
        {
            try? dbPool.read { db in
                sfcList = try SFCMasterModel.fetchAll(db, "SELECT Travel_Mode, Distance_Fare_Code, Distance, SFC_Version, Category_Name, Region_Code, From_Place, To_Place FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Travel_Mode = ? AND Category_Name = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate, travelMode, categoryName])
            }
        } else
        {
            try? dbPool.read { db in
                sfcList = try SFCMasterModel.fetchAll(db, "SELECT Travel_Mode, Distance_Fare_Code, Distance, SFC_Version, Category_Name, Region_Code, From_Place, To_Place FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Travel_Mode = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate, travelMode])
            }
        }
        
        return sfcList
    }
    
    func getAccompanistRegionCodes() -> [TourPlannerAccompanist]?
    {
        var accompanistList: [TourPlannerAccompanist] = []
        let tpId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.read { db in
            accompanistList = try TourPlannerAccompanist.fetchAll(db, "SELECT Acc_Region_Code FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id = ?", arguments: [tpId])
        }
        
        return accompanistList
    }
    
    func getRegionNameforRegionCode(code : String) -> String
    {
        var name : String = ""
        
        try? dbPool.read { db in
            let accompanistList = try AccompanistModel.fetchAll(db, "SELECT Region_Name FROM \(MST_ACCOMPANIST) WHERE Region_Code = ?", arguments: [code])
            if accompanistList.count > 0
            {
                name = accompanistList[0].Region_Name
            }
        }
        
        return name
    }
    
    func getTravelModeList() -> [TravelModeMaster]?
    {
        var travelModeList : [TravelModeMaster] = []
        
        try? dbPool.read { db in
            travelModeList = try TravelModeMaster.fetchAll(db, "SELECT * FROM \(TRAN_TRAVEL_MODE_MASTER)")
        }
        
        return travelModeList
    }
    
    func getSFCValidationCheck(fromPlace : String, toPlace : String, travelMode : String, regionCodeList : [String], categoryName: String) -> Int
    {
        var count : Int = 0
        
        let tpDate = TPModel.sharedInstance.tpDate
        
        var regionCodeString = ""
        
        for i in 0..<regionCodeList.count
        {
            regionCodeString += "'" + regionCodeList[i] + "',"
        }
        
        if (regionCodeString != "")
        {
            regionCodeString = regionCodeString.substring(to: regionCodeString.index(before: regionCodeString.endIndex))
        }
        
        if categoryName != ""
        {
            try? dbPool.read { db in
                count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Category_Name = ? AND Travel_Mode = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, tpDate, tpDate, categoryName, travelMode])!
            }
        } else
        {
            try? dbPool.read { db in
                count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Travel_Mode = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, tpDate, tpDate, travelMode])!
            }
        }
        
        return count
    }
    
    func insertSFCDetails(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try TourPlannerSFC(dict: dict).insert(db)
        })
    }
    
    func getTravelledDetailList() -> [TourPlannerSFC]
    {
        var detailList : [TourPlannerSFC] = []
        let tpEntryId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.read { db in
            detailList = try TourPlannerSFC.fetchAll(db, "SELECT * FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = ?", arguments: [tpEntryId])
        }
        
        return detailList
    }
    
    func insertSelectedSFC(sfcList : [TourPlannerSFC])
    {
        try? dbPool.writeInTransaction { db in
            for sfcObj in sfcList{
                
                try sfcObj.insert(db)
            }
            return .commit
        }
    }
    
    func deleteTravelledDetail(travelId : Int)
    {
        let tpEntryId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_SFC_Id = \(travelId) AND TP_Entry_Id = \(tpEntryId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteAllTravelDetails(tpEntryId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = \(tpEntryId)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteNextTravelledDetail(travelId: Int)
    {
        let tpEntryId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_SFC_Id > \(travelId) AND TP_Entry_Id = \(tpEntryId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteCurrentNextTravelledDetail(travelId: Int)
    {
        let tpEntryId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_SFC_Id = \(travelId) AND TP_Entry_Id = \(tpEntryId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func checkForNewSFCVersion(distanceFareCode: String, sfcVersion : Int) -> [SFCMasterModel]
    {
        var modelList : [SFCMasterModel] = []
        let tpDate = TPModel.sharedInstance.tpDate
        
        try? dbPool.read { db in
            modelList = try SFCMasterModel.fetchAll(db, "SELECT From_Place, To_Place, Distance, Distance_Fare_Code, Travel_Mode, Category_Name, SFC_Version, Region_Code FROM \(MST_SFC_MASTER) WHERE Distance_Fare_Code = ? AND SFC_Version > ? AND Date_From <= ? AND Date_To >= ?", arguments: [distanceFareCode, sfcVersion, tpDate, tpDate])
        }
        
        return modelList
    }
    
    func updateSFCDetails(fromPlace : String, toPlace : String, distance : Float, distanceFareCode: String, travelMode: String, sfcVersion : Int, travelId: Int, regionCode : String, categoryName : String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_SFC) SET From_Place = '\(fromPlace)', To_Place = '\(toPlace)', Distance = \(distance), Distance_Fare_Code = '\(distanceFareCode)', Travel_Mode = '\(travelMode)', SFC_Version = \(sfcVersion), Region_Code = '\(regionCode)', SFC_Category_Name = '\(categoryName)' WHERE TP_SFC_Id = \(travelId)")
    }
    
}
