//
//  DAL_SFC.swift
//  HiDoctorApp
//
//  Created by Vijay on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DAL_SFC: NSObject {
    
    static let sharedInstance = DAL_SFC()
    
    func getDCRAccompanistList(dcrId: Int) -> [DCRAccompanistModel]?
    {
        var accompanistList: [DCRAccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT tran_DCR_Accompanist.*,mst_Accompanist.Employee_name, mst_Accompanist.Region_Name FROM tran_DCR_Accompanist INNER JOIN mst_Accompanist ON tran_DCR_Accompanist.Acc_Region_Code = mst_Accompanist.Region_Code AND tran_DCR_Accompanist.Acc_User_Code = mst_Accompanist.User_Code WHERE tran_DCR_Accompanist.DCR_Id = ? ORDER BY mst_Accompanist.Employee_name", arguments: [dcrId])
        }
        return accompanistList
    }

    func getPlaceList(regionCode: String, categoryName: String) -> [SFCMasterModel]?
    {
        var placeList: [SFCMasterModel] = []
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
        if categoryName != ""
        {
            try? dbPool.read { db in
                placeList = try SFCMasterModel.fetchAll(db, "SELECT From_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Category_Name = ? AND Date_From <= ? AND Date_To >= ? UNION SELECT To_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Category_Name = ? AND Date_From <= ? AND Date_To >= ?", arguments:[regionCode, categoryName, dcrDate, dcrDate, regionCode, categoryName, dcrDate, dcrDate])
            }
        } else
        {
            try? dbPool.read { db in
                placeList = try SFCMasterModel.fetchAll(db, "SELECT From_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Date_From <= ? AND Date_To >= ? UNION SELECT To_Place FROM \(MST_SFC_MASTER) WHERE Region_Code = ? AND Date_From <= ? AND Date_To >= ?", arguments:[regionCode, dcrDate, dcrDate, regionCode, dcrDate, dcrDate])
            }
        }
        
        return placeList
    }
    
    func getSFCDetailsBasedonPlaces(fromPlace : String, toPlace : String, regionCodeList : [String], categoryName: String) -> [SFCMasterModel]?
    {
        var sfcList: [SFCMasterModel] = []
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
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
        } else
        {
            try? dbPool.read { db in
                sfcList = try SFCMasterModel.fetchAll(db, "SELECT Travel_Mode, Distance_Fare_Code, Distance, SFC_Version, Category_Name, Region_Code, From_Place, To_Place FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
            }
        }
        
        return sfcList
    }
    
    func getSFCDetailsBasedonPlaces(fromPlace : String, toPlace : String, dcrDate: String) -> SFCMasterModel?
    {
        var objSFC: SFCMasterModel?
        
        try? dbPool.read { db in
            objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
        }
        
        return objSFC
    }
    
    func getSFCMasterBySFCCode(sfcCode: String, versionNo: Int) -> SFCMasterModel?
    {
        var sfcObj: SFCMasterModel?
        
        try? dbPool.read { db in
            sfcObj = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE Distance_Fare_Code = ? AND SFC_Version = ?", arguments:[sfcCode, versionNo])
        }
        
        return sfcObj
    }
    
    func getSFCDetailsBasedonPlacesandTravelmode(fromPlace : String, toPlace : String, regionCodeList : [String], categoryName: String, travelMode: String) -> [SFCMasterModel]?
    {
        var sfcList: [SFCMasterModel] = []
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
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
    
    func getAccompanistRegionCodes() -> [DCRAccompanistModel]?
    {
        var accompanistList: [DCRAccompanistModel] = []
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.read { db in
            accompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ?", arguments: [dcrId])
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
        
        let dcrDate = DCRModel.sharedInstance.dcrDate
        
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
                count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Category_Name = ? AND Travel_Mode = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate, categoryName, travelMode])!
            }
        } else
        {
            try? dbPool.read { db in
                count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? AND Travel_Mode = ? AND Region_Code IN (\(regionCodeString))", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate, travelMode])!
            }
        }
        
        return count
    }
    
    func insertSFCDetails(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try DCRTravelledPlacesModel(dict: dict).insert(db)
        })
    }
    
    func getTravelledDetailList() -> [DCRTravelledPlacesModel]?
    {
        var detailList : [DCRTravelledPlacesModel] = []
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.read { db in
            detailList = try DCRTravelledPlacesModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return detailList
    }
    
    func deleteTravelledDetail(travelId : Int)
    {
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.write({ db in
            if let rowValue = try DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Travel_Id = \(travelId) AND DCR_Id = \(dcrId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteNextTravelledDetail(travelId: Int)
    {
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.write({ db in
            if let rowValue = try DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Travel_Id > \(travelId) AND DCR_Id = \(dcrId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteCurrentNextTravelledDetail(travelId: Int)
    {
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.write({ db in
            if let rowValue = try DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Travel_Id >= \(travelId) AND DCR_Id = \(dcrId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func checkForNewSFCVersion(distanceFareCode: String, sfcVersion : Int) -> [SFCMasterModel]
    {
        var modelList : [SFCMasterModel] = []
        let dcrDate = DCRModel.sharedInstance.dcrDate
        let query = "SELECT From_Place, To_Place, Distance, Distance_Fare_Code, Travel_Mode, Category_Name, SFC_Version, Region_Code FROM \(MST_SFC_MASTER) WHERE Distance_Fare_Code = '\(distanceFareCode)' AND SFC_Version > \(sfcVersion) AND Date_From <= \(dcrDate) AND Date_To >= \(dcrDate)"
        try? dbPool.read { db in
            modelList = try SFCMasterModel.fetchAll(db, "SELECT From_Place, To_Place, Distance, Distance_Fare_Code, Travel_Mode, Category_Name, SFC_Version, Region_Code FROM \(MST_SFC_MASTER) WHERE Distance_Fare_Code = ? AND SFC_Version > ? AND Date_From <= ? AND Date_To >= ?", arguments: [distanceFareCode, sfcVersion, dcrDate, dcrDate])
        }
        
        return modelList
    }
    
    func updateSFCDetails(fromPlace : String, toPlace : String, distance : Float, distanceFareCode: String, travelMode: String, sfcVersion : Int, travelId: Int, regionCode : String, categoryName : String)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_TRAVELLED_PLACES) SET From_Place = '\(fromPlace)', To_Place = '\(toPlace)', Distance = \(distance), Distance_Fare_Code = '\(distanceFareCode)', Travel_Mode = '\(travelMode)', SFC_Version = \(sfcVersion), Region_Code = '\(regionCode)', SFC_Category_Name = '\(categoryName)' WHERE DCR_Travel_Id = \(travelId)")
    }
    
    
    func getPlaceList1(FromDate: String) -> [SFCMasterModel]?
    {
        var placeList: [SFCMasterModel] = []
        
            try? dbPool.read { db in
                placeList = try SFCMasterModel.fetchAll(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE From_Place = ? OR  To_Place = ?", arguments:[FromDate,FromDate])
            }
        
        return placeList
    }
    
//    func getPlaceList2(ToDate: String) -> [SFCMasterModel]?
//    {
//        var placeList: [SFCMasterModel] = []
//
//        try? dbPool.read { db in
//            placeList = try SFCMasterModel.fetchAll(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE To_Place >= ?", arguments:[ToDate])
//        }
//
//        return placeList
//    }
    
    
    
    func checkDistanceDCREdit(dcrDate : Date) -> [ExpenseGroupMapping]
    {
        var modelList : [ExpenseGroupMapping] = []
        
       // "DATE(Effective_From)<=DATE('"+dcrDate+"') AND DATE(Effective_To)>=DATE('"+dcrDate+"')"
        
        try? dbPool.read { db in
            modelList = try ExpenseGroupMapping.fetchAll(db, "SELECT * from \(MST_EXPENSE_GROUP_MAPPING) WHERE Effective_From <= ? AND Effective_To >= ?", arguments : [dcrDate, dcrDate])
        }
        
        return modelList
    }
    
    func checkDistanceEditStatus(dcrDate : Date, categoryName : String) -> [ExpenseGroupMapping]
    {
        var modelList : [ExpenseGroupMapping] = []
        
        try? dbPool.read { db in
            modelList = try ExpenseGroupMapping.fetchAll(db, "SELECT Distance_Edit FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE SFC_Type != 'E' AND Record_Status ='1' AND Expense_Entity = ? AND Effective_From <= ? AND Effective_To >= ? LIMIT 1", arguments : [categoryName, dcrDate, dcrDate])
        }
        
        return modelList
    }
}
