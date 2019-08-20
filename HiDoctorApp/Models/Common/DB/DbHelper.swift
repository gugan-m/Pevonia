
import UIKit
import GRDB

class DBHelper: NSObject
{
    static let sharedInstance: DBHelper = DBHelper()
    
    func getAppStatusCount() -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try! Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_APP_STATUS)")!
        }
        
        return count
    }
    
    func deleteFromTable(tableName: String)
    {
        let deleteQuery = "DELETE FROM \(tableName)"
        executeQuery(query: deleteQuery)
    }
    
    //MARK:- API
    func insertApiDownloadDetail(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try ApiDownloadDetailModel(dict: dict).insert(db)
        })
    }
    
    func updateApiDownloadDetail(apiName : String, masterDataGroupName: String)
    {
        executeQuery(query: "UPDATE \(MST_API_DOWNLOAD_DETAIL) SET Download_Status = 1 WHERE Api_Name = '\(apiName)' AND Master_Data_Group_Name = '\(masterDataGroupName)'")
    }
    
    func getLastIncompleteApiDetails() -> ApiDownloadDetailModel?
    {
        var returnObj: ApiDownloadDetailModel? = nil
        
        try? dbPool.write({ db in
            if let rowValue = try ApiDownloadDetailModel.fetchOne(db, "SELECT * FROM \(MST_API_DOWNLOAD_DETAIL) WHERE Download_Status = ?", arguments: [0])
            {
                returnObj = rowValue
            }
        })
        
        return returnObj
    }
    
    //    func getbusinessstatus(customercode : String, regionCode : String, entity_type : Int, dcrDate: String) -> BussinessPotential?
    //    {
    //        var objSFC: BussinessPotential?
    //
    //        try? dbPool.read { db in
    //            objSFC = try BussinessPotential.fetchOne(db, "SELECT * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE DCR_Date <='" + dcrDate + "' " + "and Customer_Code='" + customercode + "' and Region_Code='" + regionCode + "' And Entity_Type=" + entity_type + "  order by DCR_Date desc LIMIT 1")
    //                   arguments:[customercode, regionCode, entity_type, dcrDate])
    //        }
    //
    //        return objSFC
    //    }
    
    func getbusinessstatus1(customercode : String, regionCode : String, entity_type : Int) -> BussinessPotential?
    {
        var objSFC: BussinessPotential?
        
        //objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
        
        try? dbPool.read { db in
            objSFC = try BussinessPotential.fetchOne(db, "SELECT * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE Doctor_Code = ? AND Doctor_Region_Code = ? AND Entity_Type = ? order by DCR_Date desc LIMIT 1",
                arguments:[customercode, regionCode, entity_type])
            // no_argumentnt: [customercode, regionCode, entity_type])
        }
        
        return objSFC
    }
    
    
    //    func getbusinessstatuspotential(customercode : String, productcode : String, regionCode : String, entity_type : Int) -> BussinessPotential?
    //    {
    //        var objSFC: BussinessPotential?
    //
    //        //objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
    //
    //        try? dbPool.read { db in
    //            objSFC = try BussinessPotential.fetchOne(db, "SELECT * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE Doctor_Code = ? AND Product_Code = ? AND Doctor_Region_Code = ? AND Entity_Type = ? order by DCR_Date desc LIMIT 1",
    //                arguments:[customercode, productcode, regionCode, entity_type])
    //            // no_argumentnt: [customercode, regionCode, entity_type])
    //        }
    //
    //        return objSFC
    //    }
    
    
    
    func getbusinessstatuspotential(customercode : String, productcode : String, regionCode : String, entity_type : Int) -> BussinessPotential?
    {
        var objSFC: BussinessPotential?
        
        //objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
        
        try? dbPool.read { db in
     
            objSFC = try BussinessPotential.fetchOne(db, "SELECT * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE Doctor_Code = ? AND Doctor_Region_Code = ? AND Product_Code = ? AND Entity_Type = ? ORDER BY date(DCR_Date) DESC Limit 1",
                arguments:[customercode, regionCode, productcode, entity_type])
            // no_argumentnt: [customercode, regionCode, entity_type])
        }
        
        return objSFC
    }
    
    
//    func deletebusinessstatuspotential(customercode : String, productcode : String, regionCode : String, entity_type : Int,dcrdate : Date) -> BussinessPotential?
//    {
//        var objSFC: BussinessPotential?
//        
//        //objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
//        
//        try? dbPool.read { db in
//            
//            objSFC = try BussinessPotential.fetchOne(db, "DELETE * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE Doctor_Code = ? AND Doctor_Region_Code = ? AND Product_Code = ? AND Entity_Type = ? DCR_Date = ?",
//                arguments:[customercode, regionCode, productcode, entity_type, dcrdate])
//            // no_argumentnt: [customercode, regionCode, entity_type])
//        }
//        
//        return objSFC
//    }
    
    
    
    
    
//    delete from mst_status_Prefill where DCR_Date <='"+dcrDate+"' " +
//    "and Customer_Code='"+doctorCode+"' and Region_Code='"+regionCode+"' And Product_Code='"+productCode+"' And Entity_Type="+entityType+"
    
    func getbusinessstatuspotential1(customercode : String, productcode : String, regionCode : String, entity_type : Int) -> BussinessPotential?
    {
        var objSFC: BussinessPotential?
        
        //objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE ((From_Place = ? AND To_Place = ?) OR (From_Place = ? AND To_Place = ?)) AND Date_From <= ? AND Date_To >= ? LIMIT 1", arguments:[fromPlace, toPlace, toPlace, fromPlace, dcrDate, dcrDate])
        
        try? dbPool.read { db in
            objSFC = try BussinessPotential.fetchOne(db, "SELECT * FROM \(BUSINESS_STATUS_POTENTIAL) WHERE Doctor_Code = ? AND Doctor_Region_Code = ? AND Product_Code = ?  AND Entity_Type = ?  order by DCR_Date desc LIMIT 1",
                arguments:[customercode, regionCode, productcode, entity_type])
            // no_argumentnt: [customercode, regionCode, entity_type])
        }
        
        return objSFC
    }
    
    func getHourlyreportdata() -> [HourlyReportModel]?
    {
        var hourlyreportlist: [HourlyReportModel]?
        
        try? dbPool.read { db in
            
//            let Data = try HourlyReportModel.fetchAll(db, "SELECT * FROM \(Hourly_Report_Visit)")
            let Data = try HourlyReportModel.fetchAll(db, "SELECT \(Hourly_Report_Visit).Doctor_Region_Code,\(Hourly_Report_Visit).Doctor_Code,\(Hourly_Report_Visit).Doctor_Visit_Date_Time,\(Hourly_Report_Visit).Doctor_Name,\(Hourly_Report_Visit).Longitude,\(Hourly_Report_Visit).Latitude,\(Hourly_Report_Visit).Speciality_Name,\(Hourly_Report_Visit).MDL_Number,\(Hourly_Report_Visit).Category_Code,\(Hourly_Report_Visit).Category_Name,\(Hourly_Report_Visit).Customer_Entity_Type, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(Hourly_Report_Visit) LEFT JOIN \(MST_CUSTOMER_MASTER) ON \(Hourly_Report_Visit).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE DCR_Actual_Date = CURRENT_DATE")
            
            hourlyreportlist = Data
        }
        
        return hourlyreportlist
    }
    
    func getMasterDataDownloadTime() -> [ApiDownloadDetailModel]?
    {
        var masterDataList: [ApiDownloadDetailModel]? = nil
        
        try? dbPool.write({ db in
            masterDataList = try ApiDownloadDetailModel.fetchAll(db, "SELECT Master_Data_Group_Name,MAX(Download_Date) AS Download_Date FROM \(MST_API_DOWNLOAD_DETAIL) WHERE Download_Status = ? GROUP BY Master_Data_Group_Name", arguments: [1])
        })
        
        return masterDataList
    }
    
    //MARK:- Login screen
    func insertCompanyDetails(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try CompanyDetails(dict: dict).insert(db)
        })
    }
    
    func insertUserDetails(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try UserModel(dict: dict).insert(db)
        })
    }
    
    func updateSessionId(sessionId: Int)
    {
        executeQuery(query: "UPDATE \(MST_USER_DETAILS) SET Session_Id = \(sessionId)")
    }
    
    //MARK:- App Status
    func insertAppStatus()
    {
        try? dbPool.write({ db in
            try AppStatusModel().insert(db)
        })
    }
    
    func updateLoginCompleted()
    {
        executeQuery(query: "UPDATE \(MST_APP_STATUS) SET Is_Login_Completed = 1")
    }
    
    func updatePMDCompleted()
    {
        executeQuery(query: "UPDATE \(MST_APP_STATUS) SET Is_PMD_Completed = 1")
    }
    
    func updatePMDAccompanistCompleted()
    {
        executeQuery(query: "UPDATE \(MST_APP_STATUS) SET Is_PMD_Accompanist_Completed = 1, OverAll_Status = 1")
    }
    
    func getAppStatus() -> AppStatusModel?
    {
        var appStatus: AppStatusModel?
        
        try? dbPool.read { db in
            appStatus = try AppStatusModel.fetchOne(db, "SELECT * FROM \(MST_APP_STATUS)")
        }
        
        return appStatus
    }
    
    // MARK:- Prepare My Device
    // MARK:-- Privileges
    func insertPrivileges(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try PrivilegeModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Company Config Settings
    func insertCompanyConfigSettings(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try ConfigSettingsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Work Categories
    func insertWorkCategories(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try WorkCategories(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Specialties
    func insertSpecialties(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try SpecialtyMasterModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Leave Type Master
    func insertLeaveTypeMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try LeaveTypeMaster(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Travel Mode Master
    func insertTravelModeMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TravelModeMaster(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Project Activity Master
    func insertProjectActivityMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try ProjectActivityMaster(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Detail Product Master
    func insertDetailProductMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DetailProductMaster(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Campaign Planner
    func insertCampaignPlannerHeader(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CampaignPlannerHeader(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCampaignPlannerSFC(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CampaignPlannerSFC(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCampaignPlannerDoctors(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CampaignPlannerDoctors(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Expense Group Mapping
    func insertExpenseGroupMapping(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try ExpenseGroupMapping(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Tour Planner
    func insertTourPlannerHeader(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerHeader(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTourPlannerHeaderObj(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try TourPlannerHeader(dict: dict).insert(db)
        })
    }
    
    func insertTourPlannerSFC(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerSFC(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTourPlannerDoctor(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerDoctor(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTourPlannerAccompanist(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerAccompanist(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTourPlannerProduct(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerProduct(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTourPlannerUnfreezeDates(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try TourPlannerUnfreezeDates(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- DFC Master
    func insertDFCMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DFCMaster(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- User Product Mapping
    func insertUserProductMapping(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try UserProductMapping(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Sample Product Batch Mapping
    func insertSampleBatchMapping(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try SampleBatchMapping(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- Accompanist
    func insertAccompanist(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try AccompanistModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:-- DCR
    func insertDCRCalendarDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRCalendarModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func updateHolidayInCalendarHeader(activityDate: String)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CALENDAR_HEADER) SET Is_Holiday = 1 WHERE DATE(Activity_Date) = DATE('\(activityDate)')")
    }
    
    func updateAllHolidayInCalendarHeader()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CALENDAR_HEADER) SET Is_Holiday = 0")
    }
    
    func insertDCRHeaderDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRHeaderModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRTravelledPlacesDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRTravelledPlacesModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRAccompanistsDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRAccompanistModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRDoctorVisitModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRSampleDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRSampleModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDetailedProducts(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRDetailedProductsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRChemistVisitDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistVisitModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertChemistDayVisit(array: NSArray)
    {
        
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try ChemistDayVisit(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    func insertDCRRCPADetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRRCPAModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRCustomerFollowUpDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRFollowUpModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRAttachmentDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRAttachmentModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRAttachment(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try DCRAttachmentModel(dict: dict).insert(db)
        })
    }
    
    func insertDCRStockistVisitDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRStockistVisitModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRExpenseDetails(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRExpenseModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAttendanceActivities(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRAttendanceActivityModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getNewlyDownloadedDCRHeader() -> [DCRHeaderModel]?
    {
        var dcrHeaderList: [DCRHeaderModel]?
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE (LENGTH(DCR_Code) > 0 OR DCR_Code IS NOT NULL)")
        }
        
        return dcrHeaderList
    }
    
    func updateDCRIdInFieldTables(dcrCode: String, dcrId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ACCOMPANIST) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_TRAVELLED_PLACES) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND Flag = \(DCRFlag.fieldRcpa.rawValue) AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_ACCOMPANIST) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DETAILED_PRODUCTS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMISTS_VISIT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_RCPA_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_STOCKIST_VISIT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_EXPENSE_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND Flag = \(DCRFlag.fieldRcpa.rawValue) AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND Flag = \(DCRFlag.fieldRcpa.rawValue) AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_DAY_VISIT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ACCOMPANIST) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_RCPA_OWN) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_FOLLOWUP) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ATTACHMENT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CALL_ACTIVITY) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_MC_ACTIVITY) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
        
        // To Do
        executeQuery(query: "UPDATE \(TRAN_DCR_COMPETITOR_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
    }
    
    func getDCRDetails(dcrCode: String) -> [DCRHeaderModel]
    {
        var modelList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            modelList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Code = ?", arguments: [dcrCode])
        }
        
        return modelList
    }
    
    func updateDCRIdInAttendanceTables(dcrCode: String, dcrId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_ACTIVITIES) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_TRAVELLED_PLACES) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND Flag = \(DCRFlag.attendance.rawValue) AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_EXPENSE_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND Flag = \(DCRFlag.attendance.rawValue) AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        //
        
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1)")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CALL_ACTIVITY) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_MC_ACTIVITY) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)' AND (DCR_Id = 0 OR DCR_Id = -1) AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
        
        
    }
    
    func updateDCRIdInOrderTable(dcrCode: String, dcrId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) SET DCR_Id = \(dcrId) WHERE DCR_Code = '\(dcrCode)'")
    }
    
    func getNewlyDownloadedDCRDoctorVisits() -> [DCRDoctorVisitModel]?
    {
        var dcrHeaderList: [DCRDoctorVisitModel]?
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE (LENGTH(DCR_Code) > 0 OR DCR_Code IS NULL)")
        }
        
        return dcrHeaderList
    }
    
    func getNewlyDownloadedDCRSampleBatch() -> [DCRSampleBatchModel]
    {
        var dcrHeaderList: [DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRSampleBatchModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE Ref_Id = -1 ")
        }
        
        return dcrHeaderList
    }
    
    func updateSampleBatchRefId(refId: Int, visitId: Int, productCode: String, entityType: String)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET Ref_Id = \(refId) WHERE Visit_Id = \(visitId) AND Product_Code = '\(productCode)' AND Entity_Type = '\(entityType)'")
    }
    
    func getNewlyDownloadedDCRAttendanceDoctorVisits() -> [DCRAttendanceDoctorModel]?
    {
        var dcrAttendanceDoctorList: [DCRAttendanceDoctorModel]?
        
        try? dbPool.read { db in
            dcrAttendanceDoctorList = try DCRAttendanceDoctorModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE (LENGTH(DCR_Code) > 0 OR DCR_Code IS NULL)")
        }
        
        return dcrAttendanceDoctorList
    }
    
    func updateDCRDoctorVisitIdInDetailTables(dcrDoctorVisitCode: String, dcrDoctorVisitId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_ACCOMPANIST) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DETAILED_PRODUCTS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMISTS_VISIT) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_RCPA_DETAILS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CALL_ACTIVITY) SET DCR_Customer_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Customer_Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_MC_ACTIVITY) SET DCR_Customer_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Customer_Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
        
        // To Do
        executeQuery(query: "UPDATE \(TRAN_DCR_COMPETITOR_DETAILS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET Visit_Id = \(dcrDoctorVisitId) WHERE Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)'")
    }
    
    func updateDCRAttendanceDoctorVisitIdInDetailTables(dcrDoctorVisitCode: String, dcrDoctorVisitId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) SET DCR_Doctor_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Doctor_Visit_Code = '\(dcrDoctorVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET Visit_Id = \(dcrDoctorVisitId) WHERE Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CALL_ACTIVITY) SET DCR_Customer_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Customer_Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_MC_ACTIVITY) SET DCR_Customer_Visit_Id = \(dcrDoctorVisitId) WHERE DCR_Customer_Visit_Code = '\(dcrDoctorVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Attendance.rawValue)'")
    }
    
    func getNewlyDownloadedDCRChemistVisits() -> [DCRChemistVisitModel]?
    {
        var dcrHeaderList: [DCRChemistVisitModel]?
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRChemistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE (LENGTH(DCR_Code) > 0 OR DCR_Code IS NOT NULL)")
        }
        
        return dcrHeaderList
    }
    
    func getNewlyDownloadedDCRChemistDayVisits() -> [ChemistDayVisit]
    {
        var dcrChemistDayList: [ChemistDayVisit] = []
        
        try? dbPool.read { db in
            dcrChemistDayList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE (LENGTH(DCR_Code) > 0 AND DCR_Code IS NOT NULL AND DCR_Code != '\(EMPTY)')")
        }
        
        return dcrChemistDayList
    }
    
    func getNewlyDownloadedDCRChemistRCPAOwn() -> [DCRChemistRCPAOwn]
    {
        var dcrChemistRCPAList: [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            dcrChemistRCPAList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE (LENGTH(DCR_Code) > 0 AND DCR_Code IS NOT NULL AND DCR_Code != '\(EMPTY)')")
        }
        
        return dcrChemistRCPAList
    }
    
    func updateRCPAOwnIdInCompetitorTable(ownId:Int, rcpaOwnProductId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) SET DCR_Chemist_RCPA_Own_Id = \(rcpaOwnProductId) WHERE DCR_Chemist_RCPA_Own_Id = \(ownId)")
    }
    
    func updateDCRChemistVisitIdInDetailTables(dcrChemistVisitCode: String, dcrChemistVisitId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_RCPA_DETAILS) SET DCR_Chemist_Visit_Id = \(dcrChemistVisitId) WHERE DCR_Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        
    }
    
    func updateDCRChemistDayVisitIdInDetailTables(dcrChemistVisitCode: Int, dcrChemistVisitId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ACCOMPANIST) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_RCPA_OWN) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ATTACHMENT) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_FOLLOWUP) SET DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitId) WHERE Chemist_Visit_Code = '\(dcrChemistVisitCode)'")
        
        executeQuery(query: "UPDATE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) SET Visit_Id = \(dcrChemistVisitId) WHERE Visit_Code = '\(dcrChemistVisitCode)' AND Entity_Type = '\(sampleBatchEntity.Chemist.rawValue)'")
        
    }
    
    func updateChemistVisitIdInOrderTable(dcrCode: String,dcrId: Int,visitId: Int,chemistCode: String, chemistName: String)
    {
        if chemistCode != EMPTY
        {
            executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET DCR_Id = \(dcrId), Visit_Id = \(visitId) WHERE Customer_Entity_Type = 'C' AND Customer_Code = '\(chemistCode)' AND DCR_Code = '\(dcrCode)'")
        }
        else
        {
            let query = "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET DCR_Id = \(dcrId), Visit_Id = \(visitId) WHERE Customer_Entity_Type = 'C' AND Customer_Name = '\(chemistName)' AND DCR_Code = '\(dcrCode)'"
            print (query)
            executeQuery(query: query)
        }
    }
    
    func updateDoctorVisitIdInOrderTable(dcrCode: String,dcrId: Int,visitId: Int,doctorCode: String, doctorName: String)
    {
        if doctorCode != EMPTY
        {
            executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET DCR_Id = \(dcrId), Visit_Id = \(visitId) WHERE Customer_Entity_Type = 'D' AND Customer_Code = '\(doctorCode)' AND DCR_Code = '\(dcrCode)'")
            //AND DATE(Order_Date) = DATE('\(dcrDate)')"
        }
        else
        {
            executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET DCR_Id = \(dcrId), Visit_Id = \(visitId) WHERE Customer_Entity_Type = 'D' AND Customer_Name = '\(doctorName)' AND DCR_Code = '\(dcrCode)' AND Customer_Code IS NOT NULL")
        }
    }
    
    func deleteCustomerMasterData(regionCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code IN(\(regionCodes))")
    }
    
    func deleteSFCMasterData(regionCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_SFC_MASTER) WHERE Region_Code IN(\(regionCodes))")
    }
    
    func deleteCPSFC(cpCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CP_SFC) WHERE CP_Code IN(\(cpCodes))")
    }
    
    func deleteCPDoctors(cpCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CP_DOCTORS) WHERE CP_Code IN(\(cpCodes))")
    }
    
    func deleteCPHeader(cpCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CP_HEADER) WHERE CP_Code IN(\(cpCodes))")
    }
    
    func getCPHeaderByRegionCodes(regionCodes: String) -> [CampaignPlannerHeader]?
    {
        var cpHeaderList : [CampaignPlannerHeader]?
        
        try? dbPool.read { db in
            cpHeaderList = try CampaignPlannerHeader.fetchAll(db, "SELECT * FROM \(MST_CP_HEADER) WHERE Region_Code IN (\(regionCodes))")
        }
        
        return cpHeaderList
    }
    
    func getAccompanistDataDownloadedRegions() -> [AccompanistDataDownloadModel]
    {
        var list: [AccompanistDataDownloadModel] = []
        
        try? dbPool.read { db in
            list = try AccompanistDataDownloadModel.fetchAll(db, "SELECT User_Code,Region_Code FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE Is_All_Data_Downloaded =  1 GROUP BY User_Code,Region_Code")
        }
        
        return list
    }
    
    func deleteAccompanistDownloadDetails(regionCode: String, userCode: String)
    {
        executeQuery(query: "DELETE FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE User_Code = '\(userCode)' AND Region_Code = '\(regionCode)' AND Is_All_Data_Downloaded = 1")
    }
    
    func getAllCPHeader() -> [CampaignPlannerHeader]
    {
        var cpHeaderList: [CampaignPlannerHeader] = []
        
        try? dbPool.read { db in
            cpHeaderList = try CampaignPlannerHeader.fetchAll(db, "SELECT * FROM \(MST_CP_HEADER)")
        }
        
        return cpHeaderList
    }
    
    func updateCPIdInCPSFC(cpId: Int, cpCode: String)
    {
        executeQuery(query: "UPDATE mst_CP_SFC SET CP_Id = \(cpId) WHERE CP_Code = '\(cpCode)'")
    }
    
    func updateCPIdInCPDoctor(cpId: Int, cpCode: String)
    {
        executeQuery(query: "UPDATE mst_CP_Doctors SET CP_Id = \(cpId) WHERE CP_Code = '\(cpCode)'")
    }
    
    func updateCPIdInTPHeader(cpId: Int, cpCode: String)
    {
        executeQuery(query: "UPDATE tran_TP_Header SET CP_Id = \(cpId) WHERE CP_Code = '\(cpCode)'")
    }
    
    func updateCPIdInDCRHeader(cpId: Int, cpCode: String)
    {
        executeQuery(query: "UPDATE tran_DCR_Header SET CP_Id = \(cpId) WHERE CP_Code = '\(cpCode)'")
    }
    
    func updateCPNameInDCRHeader(cpName: String, cpCode: String)
    {
        executeQuery(query: "UPDATE tran_DCR_Header SET CP_Name = '\(cpName)' WHERE CP_Code = '\(cpCode)'")
    }
    
    func updateCategoryNameInDFC(categoryName: String, categoryCode: String)
    {
        executeQuery(query: "UPDATE mst_DFC SET Category_Name = '\(categoryName)' WHERE Category_Code = '\(categoryCode)'")
    }
    
    // MARK:- Customer
    func insertCustomerMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerMasterModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCustomerMasterPersonalInfo(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerMasterPersonalInfo(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCustomerMasterEdit(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerMasterEditModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCustomerMasterPersonalInfoEdit(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerMasterPersonalInfoEdit(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    // MARK:- SFC
    func insertSFCMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try SFCMasterModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    // MARK:- Holiday
    func insertHolidayMaster(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try HolidayMasterModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    // MARK:- Competitor Product
    func insertCompetitorProducts(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CompetitorProductModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:- Prepare my device - Accompanist data
    
    func getLastIncompleteAccompanistDataDownloadDetails() -> AccompanistDataDownloadModel?
    {
        var returnObj: AccompanistDataDownloadModel? = nil
        
        try? dbPool.read({ db in
            if let rowValue = try AccompanistDataDownloadModel.fetchOne(db, "SELECT * FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE Is_All_Data_Downloaded = ?", arguments: [1])
            {
                returnObj = rowValue
            }
        })
        
        return returnObj
    }
    
    func AccompanistDownloadUserDetails(requestId: Int) -> [AccompanistDataDownloadModel]
    {
        var userList: [AccompanistDataDownloadModel] = []
        
        try? dbPool.read { db in
            userList = try AccompanistDataDownloadModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE Request_Id = ?", arguments: [requestId])
        }
        
        return userList
    }
    
    func insertAccompanistDataDownloaDetails(objAccompanistDataDownload: AccompanistDataDownloadModel)
    {
        try? dbPool.write({ db in
            try objAccompanistDataDownload.insert(db)
        })
    }
    
    func updateAccompanistDoctorDataDownloaded(requestId: Int)
    {
        executeQuery(query: "UPDATE \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) SET Is_Doctor_Data_Downloaded = 1 WHERE Request_Id = \(requestId)")
    }
    
    func updateAccompanistChemistDataDownloaded(requestId: Int)
    {
        executeQuery(query: "UPDATE \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) SET Is_Chemist_Data_Downloaded = 1 WHERE Request_Id = \(requestId)")
    }
    
    func updateAccompanistSFCDataDownloaded(requestId: Int)
    {
        executeQuery(query: "UPDATE \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) SET Is_SFC_Data_Downloaded = 1 WHERE Request_Id = \(requestId)")
    }
    
    func updateAccompanistCPDataDownloaded(requestId: Int)
    {
        executeQuery(query: "UPDATE \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) SET Is_CP_Data_Downloaded = 1 WHERE Request_Id = \(requestId)")
    }
    
    func updateAccompanistAllDataDownloaded(requestId: Int)
    {
        executeQuery(query: "UPDATE \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) SET Is_All_Data_Downloaded = 1 WHERE Request_Id = \(requestId)")
    }
    
    func getImmediateChildUsers() -> [AccompanistModel]?
    {
        var accompanistList: [AccompanistModel]?
        
        try? dbPool.read { db in
            let accompanistData = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) WHERE Is_Immedidate_User = ? ORDER BY LOWER(Employee_name) ASC", arguments: [1])
            accompanistList = accompanistData
        }
        
        return accompanistList
    }
    
    func getAllAccompanists() -> [AccompanistModel]?
    {
        var accompanistList: [AccompanistModel]?
        
        try? dbPool.read { db in
            let accompanistData = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) ORDER BY LOWER(Employee_name) ASC")
            accompanistList = accompanistData
        }
        
        return accompanistList
    }
    func getAccompanistsforvisit() -> [AccompanistModel]?
    {
        var accompanistList: [AccompanistModel]?
        
        try? dbPool.read { db in
            let accompanistData = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) ORDER BY LOWER(Employee_name) ASC")
            accompanistList = accompanistData
        }
        
        return accompanistList
    }
    
    func getAccompanistDownloadMaxRequestId() -> Int?
    {
        var count:Int?
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT MAX(Request_Id) FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS)")
        }
        
        return count
    }
    
    func getAccompanistDownloadStatusForUser(userCode: String, regionCode: String, downloadStatus: Int) -> AccompanistDataDownloadModel?
    {
        var accomapnistDownloadObj: AccompanistDataDownloadModel?
        
        try? dbPool.read { db in
            accomapnistDownloadObj = try AccompanistDataDownloadModel.fetchOne(db, "SELECT * FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE User_Code = ? AND Region_Code = ? AND Is_All_Data_Downloaded = ?", arguments: [userCode,regionCode,downloadStatus])
        }
        
        return accomapnistDownloadObj
    }
    
    func updateAccompanistDownloadStatusToError(userCode: String, regionCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try AccompanistDataDownloadModel.fetchOne(db, "SELECT * FROM \(MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS) WHERE User_Code = ? AND Region_Code = ? AND Is_All_Data_Downloaded = ?", arguments: [userCode,regionCode,0])
            {
                rowValue.Is_All_Data_Downloaded = -1
                try? rowValue.update(db)
            }
        })
    }
    
    // TravelTrackingReport
    func getTravelTrackingReport() -> [travelTrackingReport]?
    {
        var TravelTrackingReportList: [travelTrackingReport]?
        
        try? dbPool.read { db in
            let TravelTrackingReportDatA = try travelTrackingReport.fetchAll(db, "SELECT * FROM \(Travel_Tracking_Report) order by Entered_DateTime ASC")
            TravelTrackingReportList = TravelTrackingReportDatA
        }
        return TravelTrackingReportList
    }
    
    // Privileges
    func getPrivileges() -> [PrivilegeModel]?
    {
        var privilegeList: [PrivilegeModel]?
        
        try? dbPool.read { db in
            let privilegeData = try PrivilegeModel.fetchAll(db, "SELECT * FROM \(MST_PRIVILEGES)")
            privilegeList = privilegeData
        }
        
        return privilegeList
    }
    
    func getConfigSettings() -> [ConfigSettingsModel]?
    {
        var configList: [ConfigSettingsModel]?
        
        try? dbPool.read { db in
            let configData = try ConfigSettingsModel.fetchAll(db, "SELECT * FROM \(TRAN_CONFIG_SETTINGS)")
            configList = configData
        }
        
        return configList
    }
    
    //MARK:- OnBoard
    func insertOnboardDetail(shownType : Int)
    {
        try? dbPool.write({ db in
            try OnBoardModel(versionName: getCurrentAppVersion(), shownType: shownType, moduleName: OnBoardScreenName.whatsNew.rawValue).insert(db)
        })
    }
    
    func getOnboardDetailsCount() -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(ONBOARDSHOWN) WHERE Version_Name = ?",arguments : [getCurrentAppVersion()])!
        }
        return count
    }
    
    func updateOnBoardDetail(shownType : Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try OnBoardModel.fetchOne(db, key:["Version_Name": getCurrentAppVersion()])
            {
                rowValue.shownType = shownType
                try? rowValue.update(db)
            }
        })
    }
    
    func checkOnBoardShown() -> Bool
    {
        var onBoardShow : Bool = true
        
        try? dbPool.read({ db  in
            let rowValue = try OnBoardModel.fetchOne(db, key:["Version_Name": getCurrentAppVersion()])
            
            if rowValue?.versionName == getCurrentAppVersion() && rowValue?.shownType == 1
            {
                onBoardShow = false
            }
            else
            {
                onBoardShow = true
            }
        })
        
        return onBoardShow
    }
    
    func getUserDetail() -> UserModel?
    {
        var customerList: UserModel?
        
        try? dbPool.read({ db  in
            customerList = try UserModel.fetchOne(db)
        })
        
        return customerList
    }
    
    func getCompanyDetails() -> CompanyDetails?
    {
        var companyList: CompanyDetails?
        
        try? dbPool.read({db in
            companyList = try CompanyDetails.fetchOne(db)
        })
        
        return companyList
    }
    
    func getDCRCalendarDetails() -> [DCRCalendarModel]
    {
        var dcrCalendarList : [DCRCalendarModel] = []
        
        try? dbPool.read { db in
            let dcrCalendarDetail = try DCRCalendarModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALENDAR_HEADER)")
            
            dcrCalendarList = dcrCalendarDetail
        }
        
        return dcrCalendarList
    }
    
    func getDCRActivityCount(dcrDate : Date) -> Int
    {
        var rowCount : Int = 0
        
        try? dbPool.read { db in
            let rowValue = try DCRCalendarModel.fetchAll(db, "SELECT Activity_Count FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Activity_Date = ?", arguments: [dcrDate])
            
            rowCount = rowValue.count
        }
        
        return rowCount
    }
    
    func insertInitialDCREntry(dict: NSDictionary) -> Int
    {
        var id : Int = 0
        try? dbPool.write({ db in
            try DCRHeaderModel(dict: dict).insert(db)
            id = Int(db.lastInsertedRowID)
        })
        
        return id
    }
    
    func getTpDataforDCRDate(date : Date, activity : Int,  status: Int) -> [TourPlannerHeader]
    {
        var tourPlannerList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tourPlannerList = try TourPlannerHeader.fetchAll(db, "SELECT tran_TP_Header.TP_Entry_Id,tran_TP_Header.TP_Id,tran_TP_Header.TP_Date,tran_TP_Header.TP_Day,tran_TP_Header.Activity,tran_TP_Header.Status,tran_TP_Header.CP_Id,tran_TP_Header.CP_Code,tran_TP_Header.CP_Name,tran_TP_Header.Category_Code,tran_TP_Header.Category_Name,tran_TP_Header.Activity_Code,tran_TP_Header.Activity_Name,tran_TP_Header.Project_Code,tran_TP_Header.Work_Place,tran_TP_Header.Meeting_Place,tran_TP_Header.Meeting_Time,tran_TP_Header.UnApprove_Reason,tran_TP_Header.TP_ApprovedBy,tran_TP_Header.Approved_Date,tran_TP_Header.Is_Weekend,tran_TP_Header.Is_Holiday,tran_TP_Header.Remarks,tran_TP_Header.Upload_Message,mst_Work_Category.*, mst_CP_Header.CP_Name FROM tran_TP_Header LEFT JOIN mst_Work_Category ON tran_TP_Header.Category_Code = mst_Work_Category.Category_Code LEFT JOIN mst_CP_Header ON tran_TP_Header.CP_Code = mst_CP_Header.CP_Code WHERE TP_Date = ? AND Activity = ? AND Status = ?", arguments : [date, activity, status])
        }
        
        return tourPlannerList
    }
    
    func getTpDataBetweenDates(startDate: String, endDate: String, status: Int) -> [TourPlannerHeader]
    {
        var tourPlannerList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tourPlannerList = try TourPlannerHeader.fetchAll(db, "SELECT tran_TP_Header.*, mst_Work_Category.*, mst_CP_Header.CP_Name FROM tran_TP_Header LEFT JOIN mst_Work_Category ON tran_TP_Header.Category_Code = mst_Work_Category.Category_Code LEFT JOIN mst_CP_Header ON tran_TP_Header.CP_Code = mst_CP_Header.CP_Code WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)') AND Status = ?", arguments : [status])
        }
        
        return tourPlannerList
    }
    
    func getLeaveTpDataforDCRDate(date: Date, status: Int) -> [TourPlannerHeader]
    {
        var tourPlannerList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tourPlannerList = try TourPlannerHeader.fetchAll(db, "SELECT \(TRAN_TP_HEADER).*, \(TRAN_LEAVE_TYPE_MASTER).Leave_Type_Id FROM \(TRAN_TP_HEADER) LEFT JOIN \(TRAN_LEAVE_TYPE_MASTER) ON \(TRAN_TP_HEADER).Activity_Code = \(TRAN_LEAVE_TYPE_MASTER).Leave_Type_Code WHERE TP_Date = ? AND Activity = ? AND Status = ?", arguments : [date, DCRFlag.leave.rawValue, status])
        }
        
        return tourPlannerList
    }
    
    func getTPAccompanistForTPId(tpId : Int) -> [TourPlannerAccompanist]
    {
        var TPAccompList : [TourPlannerAccompanist] = []
        
        try? dbPool.read { db in
            TPAccompList = try TourPlannerAccompanist.fetchAll(db, "SELECT tran_TP_Accompanists.*, mst_Accompanist.User_Code, mst_Accompanist.Accompanist_Id FROM tran_TP_Accompanists LEFT JOIN mst_Accompanist ON tran_TP_Accompanists.Acc_User_Name = mst_Accompanist.User_Name AND tran_TP_Accompanists.Acc_Region_Code = mst_Accompanist.Region_Code WHERE TP_Id = ?" , arguments : [tpId])
        }
        
        return TPAccompList
    }
    
    func getTPAccompanistByTPId(tpId : Int) -> [TourPlannerAccompanist]
    {
        var TPAccompList : [TourPlannerAccompanist] = []
        
        try? dbPool.read { db in
            TPAccompList = try TourPlannerAccompanist.fetchAll(db, "SELECT * FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Id = ?" , arguments : [tpId])
        }
        
        return TPAccompList
    }
    
    func getTPTravelledPlaceForTPId(tpEntryId : Int) -> [TourPlannerSFC]
    {
        var travelledPlaceList : [TourPlannerSFC] = []
        
        try? dbPool.read { db in
            travelledPlaceList = try TourPlannerSFC.fetchAll(db, "SELECT \(TRAN_TP_SFC).*, \(MST_SFC_MASTER).Category_Name FROM \(TRAN_TP_SFC) LEFT JOIN \(MST_SFC_MASTER) ON \(TRAN_TP_SFC).Distance_fare_Code = \(MST_SFC_MASTER).Distance_Fare_Code AND \(TRAN_TP_SFC).SFC_Version = \(MST_SFC_MASTER).SFC_Version WHERE TP_Entry_Id = ?", arguments : [tpEntryId])
        }
        
        return travelledPlaceList
    }
    
    func deleteDCRHeaderDetailforDCRId(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = \(dcrId)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRAccompanistDetailforDCRId(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAccompanistModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = \(dcrId)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRSFCDetailforDCRId(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = \(dcrId)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDoctorVisitForDCRId(dcrId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = \(dcrId)")
    }
    
    func deleteDCRAttendanceActivityforDCRId(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttendanceActivityModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) WHERE DCR_Id = \(dcrId)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getSeqDCREntryDate(startDate: Date, endDate : Date) -> [DCRCalendarModel]
    {
        var modelList : [DCRCalendarModel] = []
        
        try? dbPool.read { db in
            modelList = try DCRCalendarModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Activity_Date >= ? AND Activity_Date < ? AND Activity_Count = 0 AND Is_WeekEnd=0 AND Is_holiday=0 AND Is_LockLeave=0  ORDER BY Activity_Date ASC LIMIT 1", arguments: [startDate, endDate])
        }
        
        return modelList
    }
    
    func getSeqDCREntryDraftValid(startDate: Date, endDate: Date) -> [DCRCalendarModel]
    {
        var modelList : [DCRCalendarModel] = []
        
        try? dbPool.read { db in
            modelList = try DCRCalendarModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Activity_Date >= ? AND Activity_Date < ? AND DCR_Status=? ORDER BY Activity_Date ASC", arguments: [startDate, endDate, DCRStatus.drafted.rawValue])
        }
        
        return modelList
    }
    
    func getSeqDCREntryUnapprovedValid(startDate: Date, endDate: Date) -> [DCRHeaderModel]
    {
        var modelList : [DCRHeaderModel] = []
        
        let query = "SELECT * FROM \(TRAN_DCR_HEADER) DH INNER JOIN \(TRAN_DCR_CALENDAR_HEADER) CH ON DH.DCR_Actual_Date = CH.Activity_Date_In_Date  WHERE DH.DCR_Actual_Date >= ? AND DH.DCR_Actual_Date < ? AND DH.DCR_Status = ? AND CH.Is_LockLeave = 0 AND Is_Field_Lock = 0 AND Activity_Count = 0 AND Is_Attendance_Lock = 0 ORDER BY DH.DCR_Actual_Date ASC"
        //        let query = "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date >= ? AND DCR_Actual_Date < ? AND DCR_Status = ? AND DCR_Actual_Date NOT IN (SELECT Activity_Date_In_Date FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Activity_Date_In_Date >= ? AND Activity_Date_In_Date < ?) ORDER BY DCR_Actual_Date ASC"
        
        
       // let query = "SELECT  Activity_Date FROM tran_Calendar_Header WHERE DH.DCR_Actual_Date >= ? AND DH.DCR_Actual_Date <= ?" +
      //  " AND Activity_Count = 0 AND Is_WeekEnd = 0 AND Is_holiday=0 AND Is_LockLeave=0  ORDER BY Activity_Date ASC LIMIT 1"

        print(query)
        
        try? dbPool.read { db in
            modelList = try DCRHeaderModel.fetchAll(db, query, arguments: [startDate, endDate, DCRStatus.unApproved.rawValue])
        }
        
        return modelList
    }
    
    func getLastEnteredDate() -> [DCRCalendarModel]
    {
        var calendarList : [DCRCalendarModel] = []
        
        try? dbPool.read { db in
            calendarList = try DCRCalendarModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE DCR_Status = 1 OR DCR_Status = 2 ORDER BY Activity_Date DESC LIMIT 1")
        }
        
        return calendarList
    }
    
    func getUnapprovedCount(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status = ?", arguments: [dcrDate, DCRStatus.unApproved.rawValue])!
        }
        
        return count
    }
    
    func getLeaveStatus(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status NOT IN (\(DCRStatus.unApproved.rawValue), \(DCRStatus.newDCR.rawValue)) AND Flag = ?", arguments: [dcrDate, DCRFlag.leave.rawValue])!
        }
        
        return count
    }
    
    func getApprovedStatus(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status = ?", arguments: [dcrDate, DCRStatus.approved.rawValue])!
        }
        
        return count
    }
    
    func getLeaveUnapprovedStatus(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status = ? AND Flag = ?", arguments: [dcrDate, DCRStatus.unApproved.rawValue, DCRFlag.leave.rawValue])!
        }
        
        return count
    }
    
    func getDcrLWHAStatus(dcrDate: Date) -> [DCRCalendarModel]?
    {
        var dcrCalendarList : [DCRCalendarModel]?
        
        try? dbPool.read { db in
            let dcrCalendarDetail = try DCRCalendarModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Activity_Date = ?", arguments: [dcrDate])
            
            dcrCalendarList = dcrCalendarDetail
        }
        
        return dcrCalendarList
    }
    
    func getDCRDetails(dcrDate : Date) -> [DCRHeaderModel]?
    {
        var dcrHeaderList : [DCRHeaderModel]?
        
        try? dbPool.read { db in
            let dcrHeaderDetail = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ?", arguments: [dcrDate])
            
            dcrHeaderList = dcrHeaderDetail
        }
        
        return dcrHeaderList
    }
    
    func isLeaveApplied(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            let dcrHeaderDetail = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ? AND DCR_Status NOT IN(\(DCRStatus.newDCR.rawValue), \(DCRStatus.notEntered.rawValue))", arguments: [dcrDate, DCRFlag.leave.rawValue])
            if dcrHeaderDetail.count > 0
            {
                count = dcrHeaderDetail.count
            }
        }
        
        return count
    }
    
    func getDCRFlag(dcrDate : Date) -> Int
    {
        var flag: Int = -1
        
        try? dbPool.read { db in
            let dcrHeaderDetail = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status != -1", arguments: [dcrDate])
            if dcrHeaderDetail.count > 0
            {
                flag = dcrHeaderDetail[0].Flag
            }
        }
        
        return flag
    }
    
    func getDCRAttendanceActivity(dcrDate : Date) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) WHERE DCR_Id = (SELECT DCR_Id FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ?)", arguments: [dcrDate, DCRFlag.attendance.rawValue])!
        }
        
        return count
    }
    
    func getDCRDoctorVisits(dcrId: Int) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getDCRChemistEntry(dcrId: Int) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getRCPAEntry(dcrId : Int) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getStockiestEntry(dcrId :  Int) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getExpensesEntry(dcrId: Int) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getLeaveName(leaveTypeCode : String?) -> String
    {
        var name : String = ""
        
        try? dbPool.read { db in
            let leaveList : [LeaveTypeMaster] = try LeaveTypeMaster.fetchAll(db, "SELECT * FROM \(TRAN_LEAVE_TYPE_MASTER) WHERE Leave_Type_Code = ? LIMIT 1", arguments: [leaveTypeCode])
            if leaveList.count > 0
            {
                name = leaveList[0].Leave_Type_Name
            }
        }
        
        return name
    }
    
    func getHolidayName(holidayDate : Date) -> String
    {
        var name : String = ""
        
        try? dbPool.read { db in
            let holidayList : [HolidayMasterModel] = try HolidayMasterModel.fetchAll(db, "SELECT * FROM \(MST_HOLIDAY_MASTER) WHERE Holiday_Date = ? LIMIT 1", arguments: [holidayDate])
            if holidayList.count > 0
            {
                name = holidayList[0].Holiday_Name
            }
        }
        
        return name
    }
    
    func checkDCRExists(dcrDate : Date, dcrFlag : Int) -> [DCRHeaderModel]
    {
        var modelList : [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            modelList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ?", arguments:[dcrDate, dcrFlag])
        }
        
        return modelList
    }
    
    func getCategoryDataforCategoryName(categoryName : String) -> [WorkCategories]
    {
        var categoryList : [WorkCategories] = []
        
        try? dbPool.read { db in
            categoryList = try WorkCategories.fetchAll(db, "SELECT * FROM \(MST_WORK_CATEGORY) WHERE Category_Name = ?", arguments:[categoryName])
        }
        
        return categoryList
    }
    
    // MARK:- Expenses
    func getPrefillTypeExpenses(dcrDate: Date, expenseEntityCode: String) -> [ExpenseGroupMapping]?
    {
        var expenseTypes : [ExpenseGroupMapping]?
        
        try? dbPool.read { db in
            expenseTypes = try ExpenseGroupMapping.fetchAll(db, "SELECT * FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE UPPER(Expense_Mode) = ? AND Expense_Entity_Code = ? AND (UPPER(Is_Prefill) = 'F' OR (Is_Prefill) = 'R') AND ? BETWEEN Effective_From AND Effective_To AND Record_Status = ?", arguments: ["DAILY", expenseEntityCode, dcrDate, 1])
        }
        
        return expenseTypes
    }
    
    func getDCRSFC(dcrId: Int, flag: Int) -> [DCRTravelledPlacesModel]?
    {
        var sfcList : [DCRTravelledPlacesModel]?
        
        try? dbPool.read { db in
            sfcList = try DCRTravelledPlacesModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_ID = ? AND Flag = ?", arguments: [dcrId, flag])
        }
        
        return sfcList
    }
    
    func getDFC(dcrDate: Date, expenseEntityCode: String, travelMode: String) -> [DFCMaster]?
    {
        var dfcList : [DFCMaster]?
        
        try? dbPool.read { db in
            dfcList = try DFCMaster.fetchAll(db, "SELECT * FROM \(MST_DFC) WHERE Entity_Code = ? AND ? BETWEEN Date_From AND Date_To AND UPPER(Travel_Mode) = ? ORDER BY From_Km,Travel_Mode", arguments: [expenseEntityCode,dcrDate,travelMode.uppercased()])
        }
        
        return dfcList
    }
    
    func getSFCBySFCCode(distanceFareCode: String, sfcVersion: Int, dcrDate: Date) -> SFCMasterModel?
    {
        var objSFC : SFCMasterModel?
        
        try? dbPool.read { db in
            objSFC = try SFCMasterModel.fetchOne(db, "SELECT * FROM \(MST_SFC_MASTER) WHERE Distance_Fare_Code = ? AND SFC_Version = ? AND ? BETWEEN Date_From AND Date_To", arguments: [distanceFareCode,sfcVersion,dcrDate])
        }
        
        return objSFC
    }
    
    func insertDCRExpenseDetails(dcrExpenseList: [DCRExpenseModel])
    {
        try? dbPool.writeInTransaction { db in
            for dcrExpenseObj in dcrExpenseList
            {
                try dcrExpenseObj.insert(db)
            }
            return .commit
        }
    }
    
    func getDoctorVisitCountForDCRId(dcrId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func getChemistDayVisitCountForDCRId(dcrId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func deletePrefillTypeExpenses(dcrId: Int, expenseTypeCodeArr: [String])
    {
        for expenseTypeCode in expenseTypeCodeArr
        {
            try? dbPool.write({ db in
                if let rowValue = try DCRExpenseModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ? AND Expense_Type_Code = ?", arguments: [dcrId, expenseTypeCode])
                {
                    try! rowValue.delete(db)
                }
            })
        }
    }
    
    func deletePrefilledExpenses(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRExpenseModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ? AND Is_Prefilled = ?", arguments: [dcrId, 1])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getDCRExpenses(dcrId: Int) -> [DCRExpenseModel]?
    {
        var expenseList : [DCRExpenseModel]?
        
        try? dbPool.read { db in
            expenseList = try DCRExpenseModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_ID = ?", arguments: [dcrId])
        }
        
        return expenseList
    }
    
    func getExpenseTypes() -> [ExpenseGroupMapping]?
    {
        var expenseTypes : [ExpenseGroupMapping]?
        
        try? dbPool.read { db in
            expenseTypes = try ExpenseGroupMapping.fetchAll(db, "SELECT * FROM \(MST_EXPENSE_GROUP_MAPPING)")
        }
        
        return expenseTypes
    }
    
    func getUniqueExpenseTypes(dcrActualDate: String) -> [ExpenseGroupMapping]
    {
        var expenseTypes : [ExpenseGroupMapping] = []
        let query: String = "SELECT Expense_Type_Code,Expense_Type_Name,Expense_Group_Id,Expense_Mode FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE Record_Status = 1 AND Is_Prefill NOT IN ('F','R') AND DATE('\(dcrActualDate)') BETWEEN Effective_From AND Effective_To GROUP BY Expense_Type_Code,Expense_Type_Name ORDER BY Expense_Type_Name"
        
        try? dbPool.read { db in
            expenseTypes = try ExpenseGroupMapping.fetchAll(db, query)
        }
        
        return expenseTypes
    }
    
    func getDailyModeNoPrefillExpenseTypes(dcrActualDate: String, expenseEnityCode: String) -> [ExpenseGroupMapping]
    {
        var expenseTypes : [ExpenseGroupMapping] = []
        let query: String = "SELECT Expense_Type_Code,Expense_Type_Name,Expense_Group_Id,Expense_Mode FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE Record_Status = 1 AND Expense_Mode = 'DAILY' AND Is_Prefill NOT IN ('F','R')  AND DATE('\(dcrActualDate)') BETWEEN Effective_From AND Effective_To AND Expense_Entity_Code = '\(expenseEnityCode)' GROUP BY Expense_Type_Code,Expense_Type_Name ORDER BY Expense_Type_Name"
        
        try? dbPool.read { db in
            expenseTypes = try ExpenseGroupMapping.fetchAll(db, query)
        }
        
        return expenseTypes
    }
    
    func getNonDailyModeExpenseTypes(dcrActualDate: String) -> [ExpenseGroupMapping]
    {
        var expenseTypes : [ExpenseGroupMapping] = []
        let query: String = "SELECT Expense_Type_Code,Expense_Type_Name,Expense_Group_Id,Expense_Mode FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE Record_Status = 1 AND Expense_Mode <> 'DAILY' AND DATE('\(dcrActualDate)') BETWEEN Effective_From AND Effective_To GROUP BY Expense_Type_Code,Expense_Type_Name ORDER BY Expense_Type_Name"
        
        try? dbPool.read { db in
            expenseTypes = try ExpenseGroupMapping.fetchAll(db, query)
        }
        
        return expenseTypes
    }
    
    func getExpenseTypeByExpenseCode(dcrActualDate: String , expenseCode : String) -> ExpenseGroupMapping?
    {
        var expenseType : ExpenseGroupMapping?
        print(dcrActualDate)
        print(expenseCode)
        let query: String = "SELECT * FROM \(MST_EXPENSE_GROUP_MAPPING) WHERE Record_Status = 1 AND Is_Prefill NOT IN ('F','R') AND DATE('\(dcrActualDate)') BETWEEN Effective_From AND Effective_To AND Expense_Type_Code = '\(expenseCode)'"
        
        try? dbPool.read { db in
            expenseType = try ExpenseGroupMapping.fetchOne(db, query)
        }
        return expenseType
    }
    
    func updateDCRExpense(dcrExpenseObj: DCRExpenseModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRExpenseModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Expense_Id = ?", arguments: [dcrExpenseObj.DCR_Expense_Id])
            {
                rowValue.Expense_Type_Code = dcrExpenseObj.Expense_Type_Code
                rowValue.Expense_Type_Name = dcrExpenseObj.Expense_Type_Name
                rowValue.Expense_Amount = dcrExpenseObj.Expense_Amount
                rowValue.Eligibility_Amount = dcrExpenseObj.Eligibility_Amount
                rowValue.Expense_Mode = dcrExpenseObj.Expense_Mode
                rowValue.Expense_Group_Id = dcrExpenseObj.Expense_Group_Id
                rowValue.Expense_Claim_Code = dcrExpenseObj.Expense_Claim_Code
                rowValue.Remarks = dcrExpenseObj.Remarks
                rowValue.Is_Prefilled = dcrExpenseObj.Is_Prefilled
                rowValue.Is_Editable = dcrExpenseObj.Is_Editable
                rowValue.Flag = dcrExpenseObj.Flag
                try? rowValue.update(db)
            }
        })
    }
    
    func deleteDCRExpense(expenseTypeCode: String, dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRExpenseModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ? AND Expense_Type_Code = ?", arguments: [dcrId, expenseTypeCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRExpense(dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRExpenseModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getDailyAllowanceEnteredCount(dcrDate: String, expenseTypeCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM tran_DCR_Expense_Details INNER JOIN tran_DCR_Header ON tran_DCR_Expense_Details.DCR_Id = tran_DCR_Header.DCR_Id WHERE DATE(tran_DCR_Header.DCR_Actual_Date) = DATE('\(dcrDate)') AND tran_DCR_Expense_Details.Expense_Type_Code = ? AND DCR_Status IN (0,1,2)", arguments: [expenseTypeCode])!
        }
        
        return count
    }
    
    func getApprovedTPCount(tpDate: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) = DATE('\(tpDate)') AND Status = \(TPStatus.approved.rawValue) AND Activity = \(TPFlag.fieldRcpa.rawValue)")!
        }
        
        return count
    }
    
    func getUnfreezedTPCount(tpDate: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_TP_UNFREEZE_DATES) WHERE DATE(TP_Date) = DATE('\(tpDate)')")!
        }
        
        return count
    }
    
    // MARK:- Privileges
    
    func getPrivilegeByPrivilegeName(privilegeName: String) -> PrivilegeModel?
    {
        var objPrivilege : PrivilegeModel?
        
        try? dbPool.read { db in
            objPrivilege = try PrivilegeModel.fetchOne(db, "SELECT * FROM \(MST_PRIVILEGES) WHERE Privilege_Name = ?", arguments: [privilegeName])
        }
        
        return objPrivilege
    }
    
    func getConfigByConfigName(configName: String) -> ConfigSettingsModel?
    {
        var objConfig : ConfigSettingsModel?
        
        try? dbPool.read { db in
            objConfig = try ConfigSettingsModel.fetchOne(db, "SELECT * FROM \(TRAN_CONFIG_SETTINGS) WHERE Config_Name = ?", arguments: [configName])
        }
        
        return objConfig
    }
    
    //MARK: - DCR
    
    func getListOfDCRAccompanist(dcrId: Int) -> [DCRAccompanistModel]?
    {
        var accompanistList: [DCRAccompanistModel]?
        
        try? dbPool.read { db in

            accompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM tran_DCR_Accompanist WHERE DCR_Id = ?", arguments: [dcrId])
 
        }
        return accompanistList
    }
    
    
    func getListOfDCRAccompanistWithoutVandNA(dcrId: Int) -> [DCRAccompanistModel]?
    {
        var accompanistList: [DCRAccompanistModel]?
        
        try? dbPool.read { db in
       
            accompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM tran_DCR_Accompanist WHERE DCR_Id = ? AND Employee_Name != 'VACANT' AND Employee_Name != 'NOT_ASSIGNED' AND Employee_Name != 'NOT ASSIGNED' ", arguments: [dcrId])
  
        }
        return accompanistList
    }
    
    
    func getAllListOfDCRAccompanist() -> [DCRAccompanistModel]?
    {
        var accompanistList: [DCRAccompanistModel]?
        
        try? dbPool.read { db in
            
            accompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM tran_DCR_Accompanist")
        }
        return accompanistList
    }
    
    
    func getListOfCpByRegionCode(regionCode : String) -> [CampaignPlannerHeader]?
    {
        var campaignList: [CampaignPlannerHeader]?
        
        try? dbPool.read { db in
            campaignList =  try CampaignPlannerHeader.fetchAll(db, "SELECT * FROM \(MST_CP_HEADER) WHERE Region_Code = ?", arguments: [regionCode])
        }
        return campaignList
    }
    
    
    func getWorkPlaceDetails(date:Date) -> [SFCMasterModel]?
    {
        var placeList : [SFCMasterModel]?
        let tpDate = TPModel.sharedInstance.tpDate
        
        try? dbPool.read { db in
            placeList =  try SFCMasterModel.fetchAll(db, "SELECT From_Place FROM \(MST_SFC_MASTER) WHERE Date_From <= ? AND Date_To >= ? UNION SELECT To_Place FROM \(MST_SFC_MASTER) WHERE Date_From <= ? AND Date_To >= ? ", arguments:[date,date,date,date])
        }
        return placeList
    }
    
    func getWorkCategoryList() -> [WorkCategories]?
    {
        var workCategoryList : [WorkCategories]?
        
        try? dbPool.read { db in
            
            workCategoryList =  try WorkCategories.fetchAll(db, "SELECT * FROM \(MST_WORK_CATEGORY)")
        }
        return workCategoryList
    }
    
    func insertFlexiWorkPlace(flexiPlaceObj: FlexiPlaceModel)
    {
        try? dbPool.write({ db in
            try flexiPlaceObj.insert(db)
        })
    }
    
    func getFlexiWorkPlaceList() -> [FlexiPlaceModel]?
    {
        var flexiWorkPlaceList : [FlexiPlaceModel]?
        
        try? dbPool.read { db in
            flexiWorkPlaceList = try FlexiPlaceModel.fetchAll(db, "SELECT * FROM \(MST_FLEXI_PLACE)")
        }
        
        return flexiWorkPlaceList
    }
    
    func getTPHeaderByTPDate(tpDate: Date) -> TourPlannerHeader?
    {
        var objTPHeader : TourPlannerHeader?
        
        try? dbPool.read { db in
            objTPHeader = try TourPlannerHeader.fetchOne(db, "SELECT tran_TP_Header.*,mst_CP_Header.CP_Name FROM tran_TP_Header LEFT JOIN mst_CP_Header ON tran_TP_Header.CP_Code = mst_CP_Header.CP_Code WHERE DATE(TP_Date) = DATE('\(tpDate)')")
        }
        
        return objTPHeader
    }
    func getTPHeaderByTPDate(tpDate: String) -> TourPlannerHeader?
    {
        var objTPHeader : TourPlannerHeader?
        
        try? dbPool.read { db in
            objTPHeader = try TourPlannerHeader.fetchOne(db, "SELECT tran_TP_Header.*,mst_CP_Header.CP_Name FROM tran_TP_Header LEFT JOIN mst_CP_Header ON tran_TP_Header.CP_Code = mst_CP_Header.CP_Code WHERE DATE(TP_Date) = DATE('\(tpDate)')")
        }
        
        return objTPHeader
    }
    
    func getTPHeaderByTPDateForDCRCalendar(tpDate: String) -> [TourPlannerHeader]
    {
        var objTPHeader : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            objTPHeader = try TourPlannerHeader.fetchAll(db, "SELECT tran_TP_Header.*,mst_CP_Header.CP_Name FROM tran_TP_Header LEFT JOIN mst_CP_Header ON tran_TP_Header.CP_Code = mst_CP_Header.CP_Code WHERE DATE(TP_Date) = DATE('\(tpDate)' AND Status = 1)")
        }
        
        return objTPHeader
    }
    
    func getCPHeaderByCPCode(cpCode: String) -> CampaignPlannerHeader?
    {
        var objCPHeader : CampaignPlannerHeader?
        
        try? dbPool.read { db in
            objCPHeader = try CampaignPlannerHeader.fetchOne(db, "SELECT mst_CP_Header.*,mst_Work_Category.Category_Name FROM mst_CP_Header INNER JOIN mst_Work_Category ON mst_CP_Header.Category_Code = mst_Work_Category.Category_Code WHERE mst_CP_Header.CP_Code = ?", arguments: [cpCode])
        }
        
        return objCPHeader
    }
    
    func getCpDetailsByCpCode(cpCode : String) -> CampaignPlannerHeader?
    {
        var objCpDetails : CampaignPlannerHeader?
        
        try? dbPool.read { db in
            
            objCpDetails = try CampaignPlannerHeader.fetchOne(db , "SELECT * from  \(MST_CP_HEADER) WHERE CP_Code = ?" , arguments : [cpCode])
        }
        return objCpDetails
    }
    
    func getDCRHeaderByDCRId(dcrId: Int) -> DCRHeaderModel?
    {
        var objDCRHeader : DCRHeaderModel?
        
        try? dbPool.read { db in
            objDCRHeader = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return objDCRHeader
    }
    
    func updateDCRWorkPlaceDetail(dcrHeaderObj: DCRHeaderObjectModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, key: dcrHeaderObj.DCR_Id)
            {
                rowValue.CP_Id = dcrHeaderObj.CP_Id
                rowValue.CP_Code = dcrHeaderObj.CP_Code
                rowValue.CP_Name = dcrHeaderObj.CP_Name
                rowValue.Category_Id = dcrHeaderObj.Category_Id
                rowValue.Category_Name = dcrHeaderObj.Category_Name
                rowValue.Place_Worked = dcrHeaderObj.Place_Worked
                rowValue.Start_Time = dcrHeaderObj.Start_Time
                rowValue.End_Time = dcrHeaderObj.End_Time
                rowValue.DCR_Status = dcrHeaderObj.DCR_Status
                rowValue.DCR_Code = EMPTY
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRWorkTime(startTime: String, endTime: String, dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, key: dcrId)
            {
                rowValue.Start_Time = startTime
                rowValue.End_Time = endTime
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRWorkPlaceDetailForAutomatic(dcrHeaderObj: DCRHeaderModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, key: dcrHeaderObj.DCR_Id)
            {
                rowValue.Place_Worked = dcrHeaderObj.Place_Worked
                rowValue.Category_Id = dcrHeaderObj.Category_Id
                rowValue.Category_Name = dcrHeaderObj.Category_Name
                //                rowValue.Start_Time = dcrHeaderObj.Start_Time
                //                rowValue.End_Time = dcrHeaderObj.End_Time
                rowValue.DCR_Status = dcrHeaderObj.DCR_Status
                rowValue.DCR_Code = EMPTY
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRWorkCategoryForAutomatic(dcrHeaderObj: DCRHeaderObjectModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, key: dcrHeaderObj.DCR_Id)
            {
                rowValue.Category_Id = dcrHeaderObj.Category_Id
                rowValue.Category_Name = dcrHeaderObj.Category_Name
                rowValue.DCR_Status = dcrHeaderObj.DCR_Status
                rowValue.DCR_Code = EMPTY
                try! rowValue.update(db)
            }
        })
    }
    
    func getTPHeaderByTpDate(tpdate: Date) -> TourPlannerHeader?
    {
        var tpHeaderObj : TourPlannerHeader?
        
        try? dbPool.read { db in
            tpHeaderObj = try TourPlannerHeader.fetchOne(db, "SELECT * FROM tran_TP_Header WHERE TP_Date = ?", arguments: [tpdate])
        }
        
        return tpHeaderObj
    }
    
    
    func getTPHeaderByTPEntryId(tpEntryId: Int) -> TourPlannerHeader?
    {
        var objTPHeader : TourPlannerHeader?
        
        try? dbPool.read { db in
            objTPHeader = try TourPlannerHeader.fetchOne(db, "SELECT * FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = ?", arguments: [tpEntryId])
        }
        
        return objTPHeader
    }
    
    func updateTPWorkPlaceDetail(tpHeaderObj: TourPlannerHeaderObjModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerHeader.fetchOne(db, key: tpHeaderObj.TP_Entry_Id)
            {
                rowValue.CP_Id = tpHeaderObj.CP_Id
                rowValue.CP_Code = tpHeaderObj.CP_Code
                rowValue.CP_Name = tpHeaderObj.CP_Name
                rowValue.Category_Id = tpHeaderObj.Category_Id
                rowValue.Category_Name = tpHeaderObj.Category_Name
                rowValue.Status = tpHeaderObj.Status
                rowValue.TP_Id = 0
                try! rowValue.update(db)
            }
        })
    }
    
    func getTPDoctorsByTpDate(tpdate: Date) -> [TourPlannerDoctor]?
    {
        var tpDoctorList : [TourPlannerDoctor]?
        
        try? dbPool.read { db in
            tpDoctorList = try TourPlannerDoctor.fetchAll(db, "SELECT tran_TP_Doctors.* FROM tran_TP_Doctors INNER JOIN tran_TP_Header ON tran_TP_Doctors.TP_Id = tran_TP_Header.TP_Id WHERE tran_TP_Header.TP_Date = ? AND tran_TP_Header.Status = '1'", arguments: [tpdate])
        }
        
        return tpDoctorList
    }
    
    func getCPDoctorsByCPCode(cpCode: String) -> [CampaignPlannerDoctors]?
    {
        var cpDoctorList : [CampaignPlannerDoctors]?
        
        try? dbPool.read { db in
            cpDoctorList = try CampaignPlannerDoctors.fetchAll(db, "SELECT * FROM mst_CP_Doctors WHERE mst_CP_Doctors.CP_Code = ?", arguments: [cpCode])
        }
        
        return cpDoctorList
    }
    
    func getPendingDCRCountForValidation(previousMonthDate: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Status <> -1 AND (LENGTH(DCR_Code) = 0 OR DCR_Status IN (3)) AND DATE(DCR_Actual_Date) >= DATE('\(previousMonthDate)') AND DATE(DCR_Actual_Date) NOT IN (SELECT DATE(Activity_Date_In_Date) FROM \(TRAN_DCR_CALENDAR_HEADER) WHERE Is_LockLeave = 1)")!
        }
        
        return count
    }
    
    func getTPSFC(tpDate: String, sfcCode: String, fromPlace: String, toPlace: String, travelMode: String) -> [TourPlannerSFC]
    {
        var accompanistMasterList : [TourPlannerSFC] = []
        let query = "SELECT SFC.* FROM \(TRAN_TP_SFC) SFC INNER JOIN \(TRAN_TP_HEADER) TPH ON SFC.TP_Entry_Id = TPH.TP_Entry_Id WHERE DATE(TPH.TP_Date) = DATE('\(tpDate)') AND TPH.Status = \(TPStatus.approved.rawValue) AND TPH.Activity = \(TPFlag.fieldRcpa.rawValue) AND SFC.Distance_fare_Code = '\(sfcCode)' AND SFC.From_Place = '\(fromPlace)' AND SFC.To_Place = '\(toPlace)' AND SFC.Travel_Mode = '\(travelMode)'"
        
        try? dbPool.read { db in
            accompanistMasterList = try TourPlannerSFC.fetchAll(db, query)
        }
        
        return accompanistMasterList
    }
    
    // MARK:- DCR Accompanist
    func getAccompanistMaster() -> [AccompanistModel]
    {
        var accompanistMasterList : [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistMasterList = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) ORDER BY LOWER(Employee_name) ASC")
        }
        
        return accompanistMasterList
    }
    
    func getAccompanistMasterList() ->[AccompanistModel]
    {
        var accompanistMasterList : [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistMasterList = try AccompanistModel.fetchAll(db, "SELECT * FROM mst_Accompanist WHERE (Is_Child_User = 0  AND User_Name <> 'VACANT' AND User_Name <> 'NOT ASSIGNED') UNION SELECT ACC.* FROM mst_Accompanist ACC INNER JOIN mst_Region_Entity_Count RC ON ACC.Region_Code = RC.Region_Code WHERE RC.Count > 0  AND (ACC.Is_Child_User = 1 OR ACC.Is_Child_User = -1) UNION SELECT ACC.* FROM mst_Accompanist ACC INNER JOIN mst_Region_Entity_Count RC ON ACC.Region_Code = RC.Region_Code WHERE RC.Count = 0  AND (ACC.Is_Child_User = 1 OR ACC.Is_Child_User = -1) AND  ACC.User_Name <> 'VACANT' AND ACC.User_Name <> 'NOT ASSIGNED' UNION SELECT * FROM mst_Accompanist WHERE ((Is_Child_User = 1 OR Is_Child_User = -1)  AND User_Name <> 'VACANT' AND User_Name <> 'NOT ASSIGNED')  AND Region_Code NOT IN (SELECT Region_Code FROM mst_Region_Entity_Count)")
        }
        
        return accompanistMasterList
    }
    
    func getDPMAccompanistMasterList(fullIndex:String) ->[AccompanistModel]
    {
        
        var accompanistDPMMasterList : [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistDPMMasterList = try AccompanistModel.fetchAll(db,"SELECT * FROM mst_Accompanist WHERE Full_index like '%\(fullIndex)%'")
        }
        
        return accompanistDPMMasterList
    }
    
    func getAccompanistMasterTPFreezeList() ->[AccompanistModel]
    {
        var accompanistMasterList : [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistMasterList = try AccompanistModel.fetchAll(db, "SELECT * FROM mst_Accompanist WHERE (Is_Child_User = 0  AND User_Name <> 'VACANT' AND User_Name <> 'NOT ASSIGNED') UNION SELECT ACC.* FROM mst_Accompanist ACC INNER JOIN mst_Region_Entity_Count RC ON ACC.Region_Code = RC.Region_Code WHERE RC.Count = 0  AND (ACC.Is_Child_User = 1 or ACC.Is_Child_User = -1) AND  ACC.User_Name <> 'VACANT' AND ACC.User_Name <> 'NOT ASSIGNED' UNION SELECT ACC.* FROM mst_Accompanist ACC INNER JOIN mst_Region_Entity_Count RC ON ACC.Region_Code = RC.Region_Code WHERE RC.Count > 0 AND ACC.Is_Child_User = -1 UNION SELECT * FROM mst_Accompanist WHERE ((Is_Child_User = 1 OR Is_Child_User = -1)  AND User_Name <> 'VACANT' AND User_Name <> 'NOT ASSIGNED')  AND Region_Code NOT IN (SELECT Region_Code FROM mst_Region_Entity_Count)")
        }
        
        return accompanistMasterList
    }
    
    func getAccompanistDoctorCount(regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(1) FROM mst_Accompanist ACC INNER JOIN mst_Region_Entity_Count EC ON ACC.Region_Code = EC.Region_Code WHERE ACC.Region_Code = ? AND ACC.Child_User_Count = 0 AND ACC.User_Name <> 'VACANT' AND ACC.User_Name <> 'NOT ASSIGNED'  AND EC.Entity_Type = 'DOCTOR' AND EC.Count > 0  ", arguments: [regionCode])!
        }
        
        return count
    }
    
    func insertDCRAccompanist(dcrAccompanistModelObj: DCRAccompanistModel)
    {
        try? dbPool.write { db in
            try dcrAccompanistModelObj.insert(db)
        }
    }
    
    func updateDCRAccompanist(dcrAccompanistModelObj: DCRAccompanistModel!) -> Bool
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAccompanistModel.fetchOne(db, key: dcrAccompanistModelObj.DCR_Accompanist_Id)
            {
                rowValue.DCR_Id = dcrAccompanistModelObj.DCR_Id
                rowValue.Acc_User_Code = dcrAccompanistModelObj.Acc_User_Code
                rowValue.Acc_Region_Code = dcrAccompanistModelObj.Acc_Region_Code
                rowValue.Acc_User_Name = dcrAccompanistModelObj.Acc_User_Name
                rowValue.Acc_User_Type_Name = dcrAccompanistModelObj.Acc_User_Type_Name
                rowValue.Is_Only_For_Doctor = dcrAccompanistModelObj.Is_Only_For_Doctor
                rowValue.Acc_Start_Time = dcrAccompanistModelObj.Acc_Start_Time
                rowValue.Acc_End_Time = dcrAccompanistModelObj.Acc_End_Time
                rowValue.DCR_Code = dcrAccompanistModelObj.DCR_Code
                rowValue.Employee_Name = dcrAccompanistModelObj.Employee_Name
                try! rowValue.update(db)
            }
        })
        
        return true
    }
    
    func getAccompanistCountForDCRId(dcrId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ?", arguments: [dcrId])!
        }
        
        return count
    }
    
    func deleteDCRAccompanist(userCode: String,regionCode : String, dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAccompanistModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId,regionCode,userCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK: - Sample Products
    
    func getUserProducts(dateString:String) -> [UserProductMapping]!
    {
        var userProductsList : [UserProductMapping]!
        
        try? dbPool.read { db in
            userProductsList = try UserProductMapping.fetchAll(db ,"SELECT * FROM \(MST_USER_PRODUCT) WHERE DATE('\(dateString)') BETWEEN DATE(Effective_From) AND DATE(Effective_To)")
        }
        return userProductsList
    }
    
    func insertDCRSampleProducts(sampleList : [DCRSampleModel])
    {
        try? dbPool.writeInTransaction{ db in
            
            for sampleObj in sampleList
            {
                try sampleObj.insert(db)
            }
            return .commit
        }
    }
    
    func deleteDCRSampleDetails(dcrId: Int, doctorVisitId: Int)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRSampleModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
            {
                try! rowValue.delete(db)
            }
            
        })
    }
    
    func getDCRSampleProducts(dcrId: Int, doctorVisitId: Int) -> [DCRSampleModel]?
    {
        var dcrSampleList : [DCRSampleModel]?
        
        try? dbPool.read { db in
            dcrSampleList = try DCRSampleModel.fetchAll(db, "SELECT \(TRAN_DCR_SAMPLE_DETAILS).*,\(MST_USER_PRODUCT).Current_Stock,\(MST_USER_PRODUCT).Product_Type_Name, \(MST_USER_PRODUCT).Product_Type_Code , \(MST_USER_PRODUCT).Division_Name FROM \(TRAN_DCR_SAMPLE_DETAILS) INNER JOIN \(MST_USER_PRODUCT) ON \(TRAN_DCR_SAMPLE_DETAILS).Product_Code = \(MST_USER_PRODUCT).Product_Code WHERE \(TRAN_DCR_SAMPLE_DETAILS).DCR_Id = ? AND DCR_Doctor_Visit_Id = ?",arguments:[dcrId,doctorVisitId])
        }
        
        return dcrSampleList
    }
    
    func getDCRChemistSampleProducts(dcrId: Int, chemistVisitId: Int) -> [DCRChemistSamplePromotion]?
    {
        var dcrSampleList : [DCRChemistSamplePromotion]?
        
        try? dbPool.read { db in
            dcrSampleList = try DCRChemistSamplePromotion.fetchAll(db, "SELECT \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION).*,\(MST_USER_PRODUCT).Current_Stock,\(MST_USER_PRODUCT).Product_Type_Name, \(MST_USER_PRODUCT).Product_Type_Code , \(MST_USER_PRODUCT).Division_Name FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) INNER JOIN \(MST_USER_PRODUCT) ON \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION).Product_Code = \(MST_USER_PRODUCT).Product_Code WHERE \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION).DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?",arguments:[dcrId,chemistVisitId])
        }
        
        return dcrSampleList
    }
    
    func getChemistSampleCount(chemistDayVisitId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Chemist_Day_Visit_Id = ? ", arguments: [chemistDayVisitId])!
        }
        
        return count
    }
    
    func getDCRSFCDetails(dcrId: Int) -> [DCRTravelledPlacesModel]?
    {
        var sfcList : [DCRTravelledPlacesModel]?
        
        try? dbPool.read { db in
            sfcList = try DCRTravelledPlacesModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return sfcList
    }
    
    func getDCRDoctorVisitDetails(dcrId: Int) -> [DCRDoctorVisitModel]
    {
        var doctorList : [DCRDoctorVisitModel] = []
        
//        try? dbPool.read { db in
//            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
//        }
        
        try? dbPool.read ({ db in
            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT \(TRAN_DCR_DOCTOR_VISIT).*, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_DCR_DOCTOR_VISIT) LEFT JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_DCR_DOCTOR_VISIT).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE DCR_ID = ?" , arguments : [dcrId])
        })
        
        return doctorList
    }
    
    func getLocalArea(customerCode:String, regionCode:String) -> CustomerMasterModel?
    {
        var localArea: CustomerMasterModel?
        try? dbPool.read { db in
            localArea = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code  = ? AND Region_Code = ?", arguments: [customerCode,regionCode])
        }
        return localArea
    }
    
    func getDCRDoctorVisitforDoctorId(dcrId: Int, customerCode: String, regionCode: String) -> [DCRDoctorVisitModel]?
    {
        var doctorList : [DCRDoctorVisitModel]?
        
        try? dbPool.read { db in
            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])
        }
        
//        try? dbPool.read ({ db in
//            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT \(TRAN_DCR_DOCTOR_VISIT).*, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_DCR_DOCTOR_VISIT) LEFT JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_DCR_DOCTOR_VISIT).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE DCR_ID = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?" , arguments : [dcrId, customerCode, regionCode])
//        })
        
        return doctorList
    }
    
    func checkDoctorVisitforDoctorId(doctorCode: String, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [DCRModel.sharedInstance.dcrId,doctorCode,regionCode])!
        }
        
//        try? dbPool.read { db in
//            count = try Int.fetchOne(db, "SELECT \(TRAN_DCR_DOCTOR_VISIT).*, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_DCR_DOCTOR_VISIT) LEFT JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_DCR_DOCTOR_VISIT).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE DCR_ID = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?" , arguments : [DCRModel.sharedInstance.dcrId,doctorCode,regionCode])!
//        }
        
        return count
    }
    
    func checkDoctorVisitforAttandanceDoctorId(doctorCode: String, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [DCRModel.sharedInstance.dcrId,doctorCode,regionCode])!
        }
        
        return count
    }
    
    func checkAttendenceDoctorVisitforDoctorId(doctorCode: String, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ?", arguments: [DCRModel.sharedInstance.dcrId,doctorCode])!
        }
        
        return count
    }
    
    func checkDoctorVisitforDoctorIdForChemistDay(doctorCode: String, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [DCRModel.sharedInstance.dcrId,ChemistDay.sharedInstance.chemistVisitId,doctorCode,regionCode])!
        }
        
        return count
    }
    
    func getDoctorVisitDetailFlexiDoctor(dcrId: Int, doctorVisitId : Int) -> [DCRDoctorVisitModel]?
    {
        var doctorList : [DCRDoctorVisitModel]?
        
        try? dbPool.read { db in
            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = '' AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
        }
        
        return doctorList
    }
    
    func getDoctorVisitDetailByDoctorVisitId(doctorVisitId : Int) -> DCRDoctorVisitModel?
    {
        var doctorVisitObj : DCRDoctorVisitModel?
        
//        try? dbPool.read { db in
//            doctorVisitObj = try DCRDoctorVisitModel.fetchOne(db, "SELECT \(TRAN_DCR_DOCTOR_VISIT).*,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_DOCTOR_VISIT) LEFT JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_DOCTOR_VISIT).Doctor_Region_Code = \(MST_ACCOMPANIST).Region_Code WHERE DCR_Doctor_Visit_Id = ?", arguments: [doctorVisitId])
//        }
        
        try? dbPool.read ({ db in
            doctorVisitObj = try DCRDoctorVisitModel.fetchOne(db, "SELECT \(TRAN_DCR_DOCTOR_VISIT).*, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_DCR_DOCTOR_VISIT) LEFT JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_DCR_DOCTOR_VISIT).Doctor_Region_Code = \(MST_CUSTOMER_MASTER).Region_Code WHERE DCR_Doctor_Visit_Id = ?" , arguments : [doctorVisitId])
        })

        
        return doctorVisitObj
    }
    
    func getAttendanceDoctorVisitDetailByDoctorVisitId(doctorVisitId : Int) -> DCRDoctorVisitModel?
    {
        var doctorVisitObj : DCRDoctorVisitModel?
        
        try? dbPool.read { db in
            doctorVisitObj = try DCRDoctorVisitModel.fetchOne(db, "SELECT \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT).*,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) LEFT JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT).Doctor_Region_Code = \(MST_ACCOMPANIST).Region_Code WHERE DCR_Doctor_Visit_Id = ?", arguments: [doctorVisitId])
        }
        
        return doctorVisitObj
    }
    
    func getSpecilaity() -> [SpecialtyMasterModel]
    {
        var modelList : [SpecialtyMasterModel] = []
        
        try? dbPool.read { db in
            modelList = try SpecialtyMasterModel.fetchAll(db, "SELECT * FROM \(MST_SPECIALTIES)")
        }
        
        return modelList
    }
    
    func getDCRStockistVisitDetails(dcrId: Int) -> [DCRStockistVisitModel]?
    {
        var stockistList : [DCRStockistVisitModel]?
        
        try? dbPool.read { db in
            stockistList = try DCRStockistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return stockistList
    }
    
    //MARK:- Stockiest
    
    func getStockiestList(customerEntityType : String) -> [CustomerMasterModel]?
    {
        var stockiestMasterList : [CustomerMasterModel]?
        
        try? dbPool.read { db in
            stockiestMasterList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Entity_Type = ?",arguments:[customerEntityType])
        }
        
        return stockiestMasterList
    }
    
    func getStockiestName(stockiestCode: String,customerEntityType: String) -> CustomerMasterModel?
    {
        var stockiestMasterObj : CustomerMasterModel?
        
        try? dbPool.read { db in
            stockiestMasterObj = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code = ? AND Customer_Entity_Type = ?",arguments:[stockiestCode,customerEntityType])
        }
        
        return stockiestMasterObj
    }
    
    func insertDcrStockiestsVisit(dcrStockiestVisitObj : DCRStockistVisitModel)
    {
        try? dbPool.write { db in
            try dcrStockiestVisitObj.insert(db)
        }
    }
    
    func insertBussinesPotential(businessobj : BussinessPotential)
    {
        try? dbPool.write { db in
            try businessobj.insert(db)
        }
    }
    
    func getDCRStockiestVisitList(dcrId: Int) -> [DCRStockistVisitModel]
    {
        var dcrStockiestsList : [DCRStockistVisitModel] = []
        
        try? dbPool.read { db in
            dcrStockiestsList = try DCRStockistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = ?",arguments:[dcrId])
        }
        return dcrStockiestsList
    }
    
    func updateDCRStockiestsVisit(dcrStockiestObj : DCRStockistVisitModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRStockistVisitModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Stockiest_Id = ?", arguments: [dcrStockiestObj.DCR_Stockiest_Id])
            {
                rowValue.Stockiest_Id = dcrStockiestObj.Stockiest_Id
                rowValue.Stockiest_Code = dcrStockiestObj.Stockiest_Code
                rowValue.Stockiest_Name = dcrStockiestObj.Stockiest_Name
                rowValue.POB_Amount = dcrStockiestObj.POB_Amount
                rowValue.Collection_Amount = dcrStockiestObj.Collection_Amount
                rowValue.Remarks = dcrStockiestObj.Remarks
                rowValue.Visit_Mode = dcrStockiestObj.Visit_Mode
                rowValue.Visit_Time = dcrStockiestObj.Visit_Time
                rowValue.Latitude = dcrStockiestObj.Latitude
                rowValue.Longitude = dcrStockiestObj.Longitude
                
                try? rowValue.update(db)
            }
        })
    }
    
    
    func deleteDCRStockiets(stockiestsCode: String, dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRStockistVisitModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = ? AND Stockiest_Code = ?", arguments: [dcrId, stockiestsCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:-Detailed Products
    
    func getDetailedProducts(productTypeName:String,date:String,regionCode:String) -> [DetailProductMaster]
    {
        var detailedMasterList : [DetailProductMaster] = []
        
        try? dbPool.read { db in
            detailedMasterList = try DetailProductMaster.fetchAll(db, "SELECT * FROM \(MST_DETAIL_PRODUCTS) WHERE Product_Type_Name = '\(productTypeName)' AND Region_Code = '\(regionCode)' AND DATE('\(date)') BETWEEN DATE(Effective_From) AND DATE(Effective_To) GROUP BY Product_Code")
        }
        return detailedMasterList
    }
    
    func getDetailedProductsPOB(productTypeName:String,date:String) -> [DetailProductMaster]
    {
        var detailedMasterList : [DetailProductMaster] = []
        
        try? dbPool.read { db in
            detailedMasterList = try DetailProductMaster.fetchAll(db, "SELECT * FROM \(MST_DETAIL_PRODUCTS) WHERE Price_Group_Code != ? AND Region_Code = '\(DCRModel.sharedInstance.customerRegionCode!)' AND Product_Type_Name = '\(productTypeName)' AND DATE('\(date)') BETWEEN DATE(Effective_From) AND DATE(Effective_To)",arguments : [NA])
        }
        return detailedMasterList
    }
    
    
    func insertDetailedProducts(dcrDetailedProducts: [DCRDetailedProductsModel])
    {
        try? dbPool.write { db in
            for obj in dcrDetailedProducts
            {
                try obj.insert(db)
            }
        }
    }
    
    func getDCRDetailedProducts(dcrId: Int, doctorVisitId: Int) -> [DCRDetailedProductsModel]
    {
        var dcrDetailedList : [DCRDetailedProductsModel] = []
        
        try? dbPool.read { db in
            dcrDetailedList = try DCRDetailedProductsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
        }
        return dcrDetailedList
    }
    
    func deleteDCRDetailedProducts(dcrId: Int, doctorVisitId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRDetailedProductsModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRCompetitorProducts(doctorVisitId: Int, productCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRCompetitorDetailsModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_COMPETITOR_DETAILS) WHERE DCR_Doctor_Visit_Id = ? AND DCR_Product_Detail_Code = ?", arguments: [doctorVisitId, productCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:-DCR Doctor Accompanist
    
    func getDCRAccompanists(dcrId: Int) -> [DCRAccompanistModel]
    {
        var dcrAccompanistsList : [DCRAccompanistModel]?
        
        try? dbPool.read { db in
            dcrAccompanistsList = try DCRAccompanistModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ? ORDER BY LOWER(Employee_Name) ASC",arguments:[dcrId])
        }
        
        //                                                                   "SELECT \(TRAN_DCR_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_Name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_ACCOMPANIST) INNER JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_ACCOMPANIST).Acc_User_Code = \(MST_ACCOMPANIST).User_Code AND \(TRAN_DCR_ACCOMPANIST).Acc_Region_Code = \(MST_ACCOMPANIST).Region_Code WHERE \(TRAN_DCR_ACCOMPANIST).DCR_Id = ? ORDER BY LOWER(Employee_Name) ASC",arguments:[dcrId]
        
        //        )
        //       }
        return dcrAccompanistsList!
    }
    
    func getDCRDoctorAccompanists(dcrId: Int, doctorVisitId: Int) -> [DCRDoctorAccompanist]
    {
        var dcrAccompanistsList : [DCRDoctorAccompanist]?
        
        try? dbPool.read { db in
            dcrAccompanistsList = try DCRDoctorAccompanist.fetchAll(db, "SELECT \(TRAN_DCR_DOCTOR_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_Name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) INNER JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_User_Code = \(MST_ACCOMPANIST).User_Code AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code = \(MST_ACCOMPANIST).Region_Code WHERE \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Id = ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Doctor_Visit_Id = ?",arguments:[dcrId,doctorVisitId])
        }
        return dcrAccompanistsList!
    }
    
    
    func getDCRChemistAccompanists(dcrId: Int, chemistVisitId: Int) -> [DCRChemistAccompanist]
    {
        var dcrAccompanistsList : [DCRChemistAccompanist]?
        
        try? dbPool.read { db in
            dcrAccompanistsList = try DCRChemistAccompanist.fetchAll(db, "SELECT tran_DCR_Chemist_Accompanist.*,mst_Accompanist.Employee_Name,mst_Accompanist.Region_Name FROM tran_DCR_Chemist_Accompanist INNER JOIN mst_Accompanist ON tran_DCR_Chemist_Accompanist.Acc_User_Code = mst_Accompanist.User_Code AND tran_DCR_Chemist_Accompanist.Acc_Region_Code = mst_Accompanist.Region_Code WHERE tran_DCR_Chemist_Accompanist.DCR_Id = ? AND tran_DCR_Chemist_Accompanist.DCR_Chemist_Day_Visit_Id = ?",arguments:[dcrId,chemistVisitId])
        }
        return dcrAccompanistsList!
    }
    
    
    func getDCRDoctorAccompanists(dcrId: Int) -> [DCRDoctorAccompanist]
    {
        var dcrAccompanistsList : [DCRDoctorAccompanist] = []
        
        try? dbPool.read { db in
            dcrAccompanistsList = try DCRDoctorAccompanist.fetchAll(db, "SELECT \(TRAN_DCR_DOCTOR_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_Name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) INNER JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_User_Code = \(MST_ACCOMPANIST).User_Code WHERE \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Id = ?",arguments:[dcrId])
        }
        return dcrAccompanistsList
    }
    
    func deleteDCRDoctorAccompanists(dcrId: Int, doctorVisitId: Int)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRDoctorAccompanist.fetchOne(db, "DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRDoctorAccompanistsForAccDelete(dcrId: Int, accompanistRegionCode: String)
    {
        
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = \(dcrId) AND Acc_Region_Code = '\(accompanistRegionCode)'")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = \(dcrId) AND Acc_Region_Code = '\(accompanistRegionCode)'")
    }
    
    func insertDoctorAccompanist(dcrDoctorAccompanist: [DCRDoctorAccompanist])
    {
        try? dbPool.write { db in
            for obj in dcrDoctorAccompanist
            {
                try obj.insert(db)
            }
        }
    }
    
    func insertDoctorAccompanist(dcrDoctorAccompanistObj: DCRDoctorAccompanist)
    {
        try? dbPool.write { db in
            try dcrDoctorAccompanistObj.insert(db)
        }
    }
    
    func updateDCRDoctorAccompanist(dcrDoctorAccompanistObj : DCRDoctorAccompanist)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRDoctorAccompanist.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ? AND DCR_Doctor_Accompanist_Id = ?", arguments: [dcrDoctorAccompanistObj.DCR_Id,dcrDoctorAccompanistObj.DCR_Doctor_Visit_Id,dcrDoctorAccompanistObj.DCR_Doctor_Accompanist_Id])
            {
                rowValue.Is_Accompanied = dcrDoctorAccompanistObj.Is_Accompanied
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRDoctorAccompanistByDCRId(dcrId : Int,dcrModifyAccompanitsObj : DCRAccompanistModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRDoctorAccompanist.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId,dcrModifyAccompanitsObj.Acc_Region_Code,dcrModifyAccompanitsObj.Acc_User_Code])
            {
                rowValue.Is_Only_For_Doctor = dcrModifyAccompanitsObj.Is_Only_For_Doctor
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRAccompanistByDCRId(dcrId : Int,dcrModifyAccompanitsObj : DCRAccompanistModel,employeeName:String)
    {
        let query = "UPDATE \(TRAN_DCR_ACCOMPANIST) SET Employee_Name = '\(employeeName)' WHERE DCR_Id = \(dcrId) AND Acc_Region_Code = '\(dcrModifyAccompanitsObj.Acc_Region_Code!)' AND Acc_User_Code = '\(dcrModifyAccompanitsObj.Acc_User_Code!)'"
        executeQuery(query: query)
    }
    
    
    func updateDCRChemistAccompanistByDCRId(dcrId : Int,dcrModifyAccompanitsObj : DCRAccompanistModel)
    {
        let query = "UPDATE \(TRAN_DCR_CHEMIST_ACCOMPANIST) SET Is_Only_For_Chemist = '\(dcrModifyAccompanitsObj.Is_Only_For_Doctor!)' WHERE DCR_Id = \(dcrId) AND Acc_Region_Code = '\(dcrModifyAccompanitsObj.Acc_Region_Code!)' AND Acc_User_Code = '\(dcrModifyAccompanitsObj.Acc_User_Code!)'"
        executeQuery(query: query)
    }
    
    //MARK:- DCR Chemist Visit
    func getDCRChemistVisit(dcrDoctorVisitId: Int) -> [DCRChemistVisitModel]?
    {
        var dcrChemistList : [DCRChemistVisitModel]?
        
        try? dbPool.read { db in
            dcrChemistList = try DCRChemistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Doctor_Visit_Id = ?",arguments:[dcrDoctorVisitId])
        }
        
        return dcrChemistList
    }
    func getDCRChemistVisitfromDcrId(dcrId: Int) -> [DCRChemistVisitModel]?
    {
        var dcrChemistList : [DCRChemistVisitModel]?
        
        try? dbPool.read { db in
            dcrChemistList = try DCRChemistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Id = ?",arguments:[dcrId])
        }
        
        return dcrChemistList
    }
    
    func getCustomerMasterList(regionCode: String, customerEntityType: String) -> [CustomerMasterModel]?
    {
        var chemistMasterList : [CustomerMasterModel]?
        
        try? dbPool.read { db in
            chemistMasterList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY Customer_Name",arguments:[regionCode,customerEntityType])
        }
        
        return chemistMasterList
    }
    
    
    func getCustomerMasterListOrderBy(regionCode: String, customerEntityType: String,orderBy : String) -> [CustomerMasterModel]?
    {
        var chemistMasterList : [CustomerMasterModel]?
        
        try? dbPool.read { db in
            chemistMasterList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY = ? ",arguments:[regionCode,customerEntityType,orderBy])
        }
        
        return chemistMasterList
    }
    
    
    func getCampaignCustomerMasterList(campaignCode: String,regionCode: String, customerEntityType: String) -> [CustomerMasterModel]?
    {
        
        var chemistMasterList : [CustomerMasterModel]?
        
        try? dbPool.read { db in
            chemistMasterList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Category_Code IN (SELECT Ref_Code FROM \(MST_MC_DETAILS) WHERE Campaign_Code = ? AND Ref_Type = 'MC_CUSTOMER_CATEGORY') AND Speciality_Code IN (SELECT Ref_Code FROM \(MST_MC_DETAILS) WHERE Campaign_Code = ? AND Ref_Type = 'MC_SPECIALITY') AND Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY Customer_Name",arguments:[campaignCode,campaignCode,regionCode,customerEntityType])
        }
        
        return chemistMasterList
    }
    
    func getCampaignProductMasterList(campaignCode: String,regionCode: String) -> [DetailProductMaster]
    {
        
        
        var chemistMasterList : [DetailProductMaster] = []
        
        try? dbPool.read { db in
            chemistMasterList = try DetailProductMaster.fetchAll(db, "SELECT det.Product_Code,det.Product_Name,det.Unit_Rate,det.Region_Code FROM mst_Division_Mapping_Details dpd INNER JOIN mst_Detail_Products det ON dpd.Entity_Code = det.Product_Code AND dpd.Ref_Type = 'PRODUCT' INNER JOIN mst_MC_Details mcd ON dpd.Entity_Code = mcd.Ref_Code AND dpd.Ref_Type = 'PRODUCT' WHERE det.Region_Code = ? AND det.Product_Type_Name = 'ACTIVITY' AND DATE (Effective_From) <= date('now','localtime') AND DATE(Effective_To) >=date('now','localtime') AND mcd.Campaign_Code = ? GROUP BY det.Product_Code",arguments:[regionCode,campaignCode])
        }
        
        return chemistMasterList
    }
    
    
    func getCustomerMasterListForEdit(regionCode: String, customerEntityType: String) -> [CustomerMasterEditModel]
    {
        var chemistMasterList : [CustomerMasterEditModel] = []
        
        try? dbPool.read { db in
            chemistMasterList = try CustomerMasterEditModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER_EDIT) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY Customer_Name",arguments:[regionCode,customerEntityType])
        }
        
        return chemistMasterList
    }
    
    func deleteCustomerDataByRegionCode(regionCode: String, customerEntityType: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code = '\(regionCode)' AND UPPER(Customer_Entity_Type) = '\(customerEntityType)'")
    }
    
    func deleteCustomerDataByRegionCodeForEdit(regionCode: String, customerEntityType: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER_EDIT) WHERE Region_Code = '\(regionCode)' AND UPPER(Customer_Entity_Type) = '\(customerEntityType)'")
    }
    
    func deleteCustomerPersonalInfoByRegionCode(regionCode: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER_PERSONAL_INFO) WHERE Region_Code = '\(regionCode)'")
    }
    
    func deleteCustomerPersonalInfoByRegionCodeForEdit(regionCode: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT) WHERE Region_Code = '\(regionCode)'")
    }
    
    func getCustomerMasterSortList(regionCode: String, customerEntityType: String, sortColumn: String, sortType: String) -> [CustomerMasterModel]?
    {
        var customerList : [CustomerMasterModel]?
        
        try? dbPool.read { db in
            customerList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY \(sortColumn) \(sortType)",arguments:[regionCode, customerEntityType])
        }
        
        return customerList
    }
    
    func getCustomerMasterSortListEdit(regionCode: String, customerEntityType: String, sortColumn: String, sortType: String) -> [CustomerMasterEditModel]
    {
        var customerList : [CustomerMasterEditModel] = []
        
        try? dbPool.read { db in
            customerList = try CustomerMasterEditModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER_EDIT) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY \(sortColumn) \(sortType)",arguments:[regionCode, customerEntityType])
        }
        
        return customerList
    }
    
    func insertDCRChemistVisit(dcrChemistVisitObj: DCRChemistVisitModel)
    {
        try? dbPool.write({ db in
            try dcrChemistVisitObj.insert(db)
        })
    }
    
    func getDCRChemistVisitId() -> Int
    {
        var chemistId : Int = 0
        try? dbPool.read { db in
            chemistId = try Int.fetchOne(db, "SELECT MAX(DCR_Chemist_Visit_Id) FROM \(TRAN_DCR_CHEMISTS_VISIT)")!
        }
        return chemistId
    }
    
    //    func updateDCRChemistVisit(dcrChemistVisitObj: DCRChemistVisitModel)
    //    {
    //        let chemistId = dcrChemistVisitObj.Chemist_Id!
    //        let chemistCode = dcrChemistVisitObj.Chemist_Code!
    //        let chemistName = dcrChemistVisitObj.Chemist_Name!
    //        let pobAmt = dcrChemistVisitObj.POB_Amount!
    //        try? dbPool.write({ db in
    //            if let rowValue = DCRChemistVisitModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Chemist_Visit_Id = ?", arguments: [dcrChemistVisitObj.DCR_Chemist_Visit_Id])
    //            {
    //                rowValue.Chemist_Id = chemistId
    //                rowValue.Chemist_Code = chemistCode
    //                rowValue.Chemist_Name = chemistName
    //                rowValue.POB_Amount = pobAmt
    //                try! rowValue.update(db)
    //            }
    //        })
    //    }
    
    
    func updateDCRChemistVisit(dcrChemistVisitObj: DCRChemistVisitModel)
    {
        let chemistId = dcrChemistVisitObj.Chemist_Id!
        let chemistCode = dcrChemistVisitObj.Chemist_Code!
        let chemistName = dcrChemistVisitObj.Chemist_Name!
        let pobAmt = dcrChemistVisitObj.POB_Amount!
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMISTS_VISIT) SET Chemist_Id = \(chemistId),Chemist_Code = '\(chemistCode)',Chemist_Name = '\(chemistName)',POB_Amount = \(pobAmt) WHERE DCR_Chemist_Visit_Id = \(dcrChemistVisitObj.DCR_Chemist_Visit_Id!)")
    }
    
    func deleteDCRChemistVisit(dcrChemistVisitId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistVisitModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Chemist_Visit_Id = ?", arguments: [dcrChemistVisitId])
            {
                try! rowValue.delete(db)
            }
        })
        
        executeQuery(query: "DELETE FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = \(dcrChemistVisitId)")
    }
    
    func getRCPACountForDoctorVisitId(dcrDoctorVisitId: Int) -> Int    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Doctor_Visit_Id = ?", arguments: [dcrDoctorVisitId])!
        }
        
        return count
    }
    
    func getRCPACountForChemistVisitId(dcrDoctorVisitId: Int, chemistVisitId : Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Doctor_Visit_Id = ? AND DCR_Chemist_Visit_Id = ?", arguments: [dcrDoctorVisitId, chemistVisitId])!
        }
        
        return count
    }
    
    func insertFleixChemist(flexiChemistObj: FlexiChemistModel)
    {
        try? dbPool.write({ db in
            try flexiChemistObj.insert(db)
        })
    }
    
    func getLastFlexiChemistObject()
    {
        
    }
    
    func getFlexiChemistList() -> [FlexiChemistModel]?
    {
        var chemistList : [FlexiChemistModel]?
        
        try? dbPool.read { db in
            chemistList = try FlexiChemistModel.fetchAll(db, "SELECT * FROM \(MST_FLEXI_CHEMIST)")
        }
        
        return chemistList
    }
    
    func getDCRRCPADetails(dcrChemistVisitId: Int) -> [DCRRCPAModel]?
    {
        var rcpaList : [DCRRCPAModel]?
        
        try? dbPool.read { db in
            rcpaList = try DCRRCPAModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = ? ORDER BY Product_Code",arguments:[dcrChemistVisitId])
        }
        
        return rcpaList
    }
    
    func getDCRRCPADetailsByOwnProductId(dcrChemistVisitId: Int,ownProductCode : String) -> [DCRRCPAModel]?
    {
        var rcpaList : [DCRRCPAModel]?
        
        try? dbPool.read { db in
            rcpaList = try DCRRCPAModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = ? AND Product_Code = ? AND LENGTH(Competitor_Product_Name) > 0",arguments:[dcrChemistVisitId,ownProductCode])
        }
        
        return rcpaList
    }
    
    func deleteRCPADetails(dcrChemistVisitId: Int, productCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRRCPAModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = ? AND Product_Code = ?", arguments: [dcrChemistVisitId, productCode])
            {
                try! rowValue.delete(db)
            }
            
        })
    }
    
    func insertDCRRCPADetails(rcpaList: [DCRRCPAModel])
    {
        try? dbPool.writeInTransaction { db in
            for rcpaObj in rcpaList
            {
                try rcpaObj.insert(db)
            }
            return .commit
        }
    }
    
    func getCompetitorProducts(ownProductCode: String) -> [CompetitorProductModel]?
    {
        var compProdList : [CompetitorProductModel]?
        
        try? dbPool.read { db in
            compProdList = try CompetitorProductModel.fetchAll(db, "SELECT * FROM \(MST_COMPETITOR_PRODUCT) WHERE Own_Product_code = ? ORDER BY Competitor_Product_Name",arguments:[ownProductCode])
        }
        
        return compProdList
    }
    
    func getDCRRCPAUniqueOwnProducts(dcrChemistVisitId: Int) -> [DCRRCPAModel]?
    {
        var rcpaList : [DCRRCPAModel]?
        
        //        try? dbPool.read { db in
        //            rcpaList = try DCRRCPAModel.fetchAll(db, "SELECT Own_Product_Id,Product_Code,Own_Product_Name,DCR_Chemist_Visit_Id FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = ? GROUP BY Own_Product_Id,Product_Code,Own_Product_Name",arguments:[dcrChemistVisitId])
        try? dbPool.read { db in
            rcpaList = try DCRRCPAModel.fetchAll(db, "SELECT Own_Product_Id,Product_Code,Own_Product_Name,DCR_Chemist_Visit_Id FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Chemist_Visit_Id = ? AND LENGTH (Own_Product_Code) > 0 GROUP BY Own_Product_Id,Product_Code,Own_Product_Name",arguments:[dcrChemistVisitId])
        }
        
        return rcpaList
    }
    
    //MARK:- Attendance
    func getDCRAttendanceActivities(dcrId: Int) -> [DCRAttendanceActivityModel]?
    {
        var dcrAttendanceActivityList : [DCRAttendanceActivityModel]?
        
        try? dbPool.read { db in
            dcrAttendanceActivityList = try DCRAttendanceActivityModel.fetchAll(db, "SELECT \(TRAN_DCR_ATTENDANCE_ACTIVITIES).*,\(MST_PROJECT_ACTIVITY).Project_Name,\(MST_PROJECT_ACTIVITY).Activity_Name FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) INNER JOIN \(MST_PROJECT_ACTIVITY) ON \(TRAN_DCR_ATTENDANCE_ACTIVITIES).Project_Code = \(MST_PROJECT_ACTIVITY).Project_Code AND \(TRAN_DCR_ATTENDANCE_ACTIVITIES).Activity_Code = \(MST_PROJECT_ACTIVITY).Activity_Code WHERE \(TRAN_DCR_ATTENDANCE_ACTIVITIES).DCR_Id = ?",arguments:[dcrId])
        }
        
        return dcrAttendanceActivityList
    }
    
    func getProjectActivityList() -> [ProjectActivityMaster]?
    {
        var activityList : [ProjectActivityMaster]?
        
        try? dbPool.read { db in
            activityList = try ProjectActivityMaster.fetchAll(db, "SELECT * FROM \(MST_PROJECT_ACTIVITY) ORDER BY Activity_Name")
        }
        
        return activityList
    }
    
    func insertDCRAttendanceActivity(dcrAttendanceActivityObj: DCRAttendanceActivityModel)
    {
        try? dbPool.write({ db in
            try dcrAttendanceActivityObj.insert(db)
        })
    }
    
    func updateDCRAttendanceActivity(dcrAttendanceActivityObj: DCRAttendanceActivityModel)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ATTENDANCE_ACTIVITIES) SET Project_Code = '\(dcrAttendanceActivityObj.Project_Code!)',Activity_Code = '\(dcrAttendanceActivityObj.Activity_Code!)',Start_Time = '\(dcrAttendanceActivityObj.Start_Time!)',End_Time = '\(dcrAttendanceActivityObj.End_Time!)' , Remarks = '\(dcrAttendanceActivityObj.Remarks!)'  WHERE DCR_Attendance_Id = \(dcrAttendanceActivityObj.DCR_Attendance_Id!)")
    }
    
    func deleteDCRAttendanceActivity(dcrAttendanceActivityId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttendanceActivityModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) WHERE DCR_Attendance_Id = ?", arguments: [dcrAttendanceActivityId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- DCR Doctor Visit
    func insertFleixDoctor(flexiDoctorObj: FlexiDoctorModel)
    {
        try? dbPool.write({ db in
            try flexiDoctorObj.insert(db)
        })
    }
    
    func getFlexiDoctorList() -> [FlexiDoctorModel]?
    {
        var doctorList : [FlexiDoctorModel]?
        
        try? dbPool.read { db in
            doctorList = try FlexiDoctorModel.fetchAll(db, "SELECT * FROM \(MST_FLEXI_DOCTOR)")
        }
        
        return doctorList
    }
    
    func getCustomerByCustomerCode(customerCode: String, regionCode: String) -> CustomerMasterModel?
    {
        var objCustomerMaster : CustomerMasterModel?
        
        try? dbPool.read { db in
            objCustomerMaster = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code = ? AND Region_Code = ?",arguments:[customerCode, regionCode])
        }
        
        return objCustomerMaster
    }
    
    func getCustomerByCustomerCodeForEdit(customerCode: String, regionCode: String) -> CustomerMasterEditModel?
    {
        var objCustomerMaster : CustomerMasterEditModel?
        
        try? dbPool.read { db in
            objCustomerMaster = try CustomerMasterEditModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER_EDIT) WHERE Customer_Code = ? AND Region_Code = ?",arguments:[customerCode, regionCode])
        }
        
        return objCustomerMaster
    }
    
    func getCustomerByCustomerCodeandEntityType(customerCode: String, regionCode: String, entityType: String) -> CustomerMasterModel?
    {
        var objCustomerMaster : CustomerMasterModel?
        
        try? dbPool.read { db in
            objCustomerMaster = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code = ? AND Region_Code = ? AND Customer_Entity_Type = ?",arguments:[customerCode, regionCode, entityType])
        }
        
        return objCustomerMaster
    }
    
    
    func insertDCRDoctorVisit(dcrDoctorVisitObj: DCRDoctorVisitModel) -> Int
    {
        var doctorVisitId: Int = 0
        
        try? dbPool.write({ db in
            try dcrDoctorVisitObj.insert(db)
            doctorVisitId = try Int(db.lastInsertedRowID)
        })
        
        return doctorVisitId
    }
    
    func updateDCRDoctorVisit(dcrDoctorVisitObj: DCRDoctorVisitModel)
    {
        
        let campaignName = dcrDoctorVisitObj.Campaign_Name.replacingOccurrences(of: "'", with: "\'")
        //
        //        let query = "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Visit_Mode ='\(dcrDoctorVisitObj.Visit_Mode!)',Visit_Time = '\(dcrDoctorVisitObj.Visit_Time!)',POB_Amount = \(dcrDoctorVisitObj.POB_Amount!),Remarks = '\(dcrDoctorVisitObj.Remarks!)', Lattitude = '\(dcrDoctorVisitObj.Lattitude!)', Longitude = '\(dcrDoctorVisitObj.Longitude!)', Business_Status_ID = \(dcrDoctorVisitObj.Business_Status_ID!), Business_Status_Name = '\(dcrDoctorVisitObj.Business_Status_Name!)', Business_Status_Active_Status = \(dcrDoctorVisitObj.Business_Status_Active_Status!), Call_Objective_ID = \(dcrDoctorVisitObj.Call_Objective_ID!), Call_Objective_Name = '\(dcrDoctorVisitObj.Call_Objective_Name!)', Call_Objective_Active_Status = \(dcrDoctorVisitObj.Call_Objective_Active_Status!), Campaign_Code = '\(dcrDoctorVisitObj.Campaign_Code!)', Campaign_Name = '\(dcrDoctorVisitObj.Campaign_Name.replacingOccurrences(of: "'", with: "\'"))' WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitObj.DCR_Doctor_Visit_Id!)"
        //        print(query)
        //   executeQuery(query: query)
        
        
        try? dbPool.write({ db in
            try db.execute("UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Visit_Mode ='\(dcrDoctorVisitObj.Visit_Mode!)',Visit_Time = '\(dcrDoctorVisitObj.Visit_Time!)',POB_Amount = \(dcrDoctorVisitObj.POB_Amount!),Remarks = '\(dcrDoctorVisitObj.Remarks!)', Lattitude = '\(dcrDoctorVisitObj.Lattitude!)', Longitude = '\(dcrDoctorVisitObj.Longitude!)', Business_Status_ID = \(dcrDoctorVisitObj.Business_Status_ID!), Business_Status_Name = '\(dcrDoctorVisitObj.Business_Status_Name!)', Business_Status_Active_Status = \(dcrDoctorVisitObj.Business_Status_Active_Status!), Call_Objective_ID = \(dcrDoctorVisitObj.Call_Objective_ID!), Call_Objective_Name = '\(dcrDoctorVisitObj.Call_Objective_Name!)', Call_Objective_Active_Status = \(dcrDoctorVisitObj.Call_Objective_Active_Status!), Campaign_Code = :Campaign_Code, Campaign_Name = :Campaign_Name WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitObj.DCR_Doctor_Visit_Id!)",
                arguments: ["Campaign_Code": dcrDoctorVisitObj.Campaign_Code!, "Campaign_Name": dcrDoctorVisitObj.Campaign_Name!])
        })
        
        
        
        //        try? dbPool.write({ db in
        //            if let rowValue = try DCRDoctorVisitModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitObj.DCR_Doctor_Visit_Id!)")
        //            {
        //                rowValue.Visit_Mode = dcrDoctorVisitObj.Visit_Mode
        //                rowValue.Visit_Time = dcrDoctorVisitObj.Visit_Time
        //                rowValue.POB_Amount = dcrDoctorVisitObj.POB_Amount
        //                rowValue.Remarks = dcrDoctorVisitObj.Remarks
        //                rowValue.Lattitude = dcrDoctorVisitObj.Lattitude
        //                rowValue.Longitude = dcrDoctorVisitObj.Longitude
        //                rowValue.Business_Status_ID = dcrDoctorVisitObj.Business_Status_ID
        //                rowValue.Business_Status_Name = dcrDoctorVisitObj.Business_Status_Name
        //                rowValue.Business_Status_Active_Status = dcrDoctorVisitObj.Business_Status_Active_Status
        //                rowValue.Call_Objective_ID = dcrDoctorVisitObj.Call_Objective_ID
        //                rowValue.Call_Objective_Name = dcrDoctorVisitObj.Call_Objective_Name
        //                rowValue.Call_Objective_Active_Status = dcrDoctorVisitObj.Call_Objective_Active_Status
        //                rowValue.Campaign_Code = dcrDoctorVisitObj.Campaign_Code
        //                rowValue.Campaign_Name = dcrDoctorVisitObj.Campaign_Name
        //                try! rowValue.update(db)
        //            }
        //        })
    }
    
    func updateDCRDoctorVisitTime(visittime: String,VisitMode: String,DCR_Doctor_Visit_Id: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Visit_Mode ='\(VisitMode)',Visit_Time = '\(visittime)' WHERE DCR_Doctor_Visit_Id = \(DCR_Doctor_Visit_Id)")
    }
    
    func deleteDCRDoctorVisit(dcrDoctorVisitId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Id = \(dcrDoctorVisitId)")
    }
    
    func getDoctorSampleCount(dcrDoctorVisitId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Doctor_Visit_Id = ?", arguments: [dcrDoctorVisitId])!
        }
        
        return count
    }
    
    func getDoctorDetailedProductsCount(dcrDoctorVisitId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Doctor_Visit_Id = ?", arguments: [dcrDoctorVisitId])!
        }
        
        return count
    }
    
    func getDoctorChemistCount(dcrDoctorVisitId: Int) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Doctor_Visit_Id = ?", arguments: [dcrDoctorVisitId])!
        }
        
        return count
    }
    
    func getCustomerByCustomerCodeAndRegionCode(customerCode: String, regionCode: String, customerEntityType: String) -> CustomerMasterModel?
    {
        var objCustomerMaster : CustomerMasterModel?
        
        try? dbPool.read { db in
            objCustomerMaster = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code = ? AND Region_Code = ? AND Customer_Entity_Type = ? ORDER BY Customer_Name",arguments:[customerCode, regionCode, customerEntityType])
        }
        
        return objCustomerMaster
    }
    
    func insertDoctorVisitTracker(objDoctorVisitTracker: DoctorVisitTrackerModel)
    {
        try? dbPool.write({ db in
            try objDoctorVisitTracker.insert(db)
        })
    }
    
    func getDetailedProductsFromEDetailingAnalytics(doctorVisitId: Int, customerCode: String, regionCode: String, dcrDate: String) -> [DetailProductMaster]
    {
        var productList : [DetailProductMaster] = []
        
        let query = "SELECT * FROM mst_Detail_Products  WHERE Product_Code IN (SELECT DP.Product_Code FROM tran_Asset_Analytics_Details AAD INNER JOIN tran_ED_Asset_Product_Mapping APM ON AAD.DA_Code = APM.DA_Code INNER JOIN mst_Detail_Products DP ON APM.Product_Code = DP.Product_Code WHERE DATE(AAD.Detailed_DateTime) = DATE('\(dcrDate)') AND AAD.Customer_Code = '\(customerCode)' AND AAD.Customer_Region_Code = '\(regionCode)' AND AAD.Is_Preview = 0 AND APM.Product_Code NOT IN (SELECT Product_Code FROM tran_DCR_Detailed_Products WHERE DCR_Doctor_Visit_Id = \(doctorVisitId)) GROUP BY DP.Product_Code)"
        
        try? dbPool.read { db in
            productList = try DetailProductMaster.fetchAll(db, query)
        }
        
        return productList
    }
    
    func updateCustomerAddress(customerAddress: GeoLocationModel, pageSource: String)
    {
        executeQuery(query: "UPDATE \(MST_CUSTOMER_ADDRESS) SET Latitude = '\(customerAddress.Latitude!)', Longitude = '\(customerAddress.Longitude!)', Is_Synced = 0, Update_Page_Source = '\(pageSource)' WHERE Address_Id = \(customerAddress.Address_Id!)")
    }
    
    func getCustomerAddress(customerCode: String, regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        var customerAddresList : [CustomerAddressModel] = []
        
        try? dbPool.read { db in
            customerAddresList = try CustomerAddressModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_ADDRESS) WHERE Customer_Code = ? AND Region_Code = ? AND Customer_Entity_Type = ?", arguments: [customerCode, regionCode, customerEntityType])
        }
        
        return customerAddresList
    }
    
    func getCustomerAddress1(customerCode: String, regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        var customerAddresList : [CustomerAddressModel] = []
        
        try? dbPool.read { db in
            customerAddresList = try CustomerAddressModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_ADDRESS) WHERE Customer_Code_Global = ? AND Region_Code_Global = ? AND Customer_Entity_Type = ? AND Updated_By = 'CA'", arguments: [customerCode, regionCode, customerEntityType])
        }
        
        return customerAddresList
    }
    
    
    
    func getCustomerAddress2(regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        var customerAddresList : [CustomerAddressModel] = []
        
        try? dbPool.read { db in
            customerAddresList = try CustomerAddressModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_ADDRESS) WHERE Region_Code_Global = ? AND Customer_Entity_Type = ?", arguments: [regionCode, customerEntityType])
        }
        
        return customerAddresList
    }
    

    func getCustomerAddress(regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        var customerAddresList : [CustomerAddressModel] = []
        
        try? dbPool.read { db in
            customerAddresList = try CustomerAddressModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_ADDRESS) WHERE Region_Code = ? AND Customer_Entity_Type = ?", arguments: [regionCode, customerEntityType])
        }
        
        return customerAddresList
    }
    
    func getCustomerAddressForUpSync() -> [CustomerAddressModel]
    {
        var customerAddresList : [CustomerAddressModel] = []
        
        try? dbPool.read { db in
            customerAddresList = try CustomerAddressModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_ADDRESS) WHERE Is_Synced = ?", arguments: [0])
        }
        
        return customerAddresList
    }
    
    func markCustomerAddressSynced()
    {
        executeQuery(query: "UPDATE \(MST_CUSTOMER_ADDRESS) SET Is_Synced = 1 WHERE Is_Synced = 0")
    }
    
    //MARK:- Leave
    func getDCRHeaderByDCRDate(dcrActualDate: String) -> [DCRHeaderModel]?
    {
        var dcrHeaderList : [DCRHeaderModel]?
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrActualDate)')")
        }
        
        return dcrHeaderList
    }
    
    
    func getDCRHeaderByDCRDateAndFlag(dcrActualDate: Date, flag: Int) -> DCRHeaderModel?
    {
        var dcrHeaderObj : DCRHeaderModel?
        
        try? dbPool.read { db in
            dcrHeaderObj = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ?", arguments: [dcrActualDate, flag])
        }
        
        return dcrHeaderObj
    }
    
    func insertDCRHeader(dcrHeaderObj: DCRHeaderModel)
    {
        try? dbPool.write({ db in
            try dcrHeaderObj.insert(db)
        })
    }
    
    func getLeaveTypes(dcrDate: Date) -> [LeaveTypeMaster]?
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.string(from: dcrDate)
        var leaveTypeList : [LeaveTypeMaster]?
        
        try? dbPool.read { db in
            leaveTypeList = try LeaveTypeMaster.fetchAll(db, "SELECT * FROM \(TRAN_LEAVE_TYPE_MASTER) WHERE DATE(\(TRAN_LEAVE_TYPE_MASTER).Effective_From) <= date('\(dateObj)') AND DATE(\(TRAN_LEAVE_TYPE_MASTER).Effective_To) >= date('\(dateObj)') ")
        }
        
        return leaveTypeList
    }
    
    
    func updateLeave(dcrHeaderObj: DCRHeaderModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ?", arguments: [dcrHeaderObj.DCR_Actual_Date, DCRFlag.leave.rawValue])
            {
                rowValue.Leave_Type_Id = dcrHeaderObj.Leave_Type_Id
                rowValue.Leave_Type_Code = dcrHeaderObj.Leave_Type_Code
                rowValue.Reason = dcrHeaderObj.Reason
                rowValue.DCR_Status = String(DCRStatus.applied.rawValue)
                rowValue.DCR_Entered_Date = dcrHeaderObj.DCR_Entered_Date
                rowValue.Lattitude = dcrHeaderObj.Lattitude
                rowValue.Longitude = dcrHeaderObj.Longitude
                rowValue.DCR_Code = dcrHeaderObj.DCR_Code
                try! rowValue.update(db)
            }
        })
    }
    
    func getEDetailedProducts(dcrDate: String, customerCode: String, customerRegionCode: String) -> [Row]
    {
        var productList : [Row] = []
        
        try? dbPool.read { db in
            productList = try Row.fetchAll(db, "SELECT APM.Product_Code,APM.DA_Code,MDP.Product_Name FROM \(TRAN_ASSET_ANALYTICS_DETAILS) AAD INNER JOIN \(TRAN_ED_ASSET_PRODUCT_MAPPING) APM ON AAD.DA_Code = APM.DA_Code INNER JOIN mst_Detail_Products MDP ON APM.Product_Code = MDP.Product_Code WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND AAD.Customer_Code = '\(customerCode)' AND AAD.Customer_Region_Code = '\(customerRegionCode)' AND AAD.Played_Time_Duration > 0 GROUP BY APM.Product_Code,APM.DA_Code,MDP.Product_Name")
        }
        
        return productList
    }
    
    func getDayWiseEDetailedProducts(dcrDate: String, customerCode: String, customerRegionCode: String) -> [DayWiseAssestsDetailedModel]
    {
        var productList : [DayWiseAssestsDetailedModel] = []
        
        try? dbPool.read { db in
            productList = try DayWiseAssestsDetailedModel.fetchAll(db, "SELECT * FROM \(TRAN_DAY_WISE_ASSETS_DETAILED) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrDate)') AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customerRegionCode)'")
        }
        
        return productList
    }
    
    func getDayWiseEDetailedProducts(dcrDate: String, customerCode: String, customerRegionCode: String, status: Int) -> [DayWiseAssestsDetailedModel]
    {
        var productList : [DayWiseAssestsDetailedModel] = []
        
        try? dbPool.read { db in
            productList = try DayWiseAssestsDetailedModel.fetchAll(db, "SELECT Product_Code,Product_Name FROM \(TRAN_DAY_WISE_ASSETS_DETAILED) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrDate)') AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customerRegionCode)' AND Active_Status = \(status) GROUP BY Product_Code,Product_Name")
        }
        
        return productList
    }
    
    func insertDayWiseDetailedProducts(productList : [DayWiseAssestsDetailedModel])
    {
        try? dbPool.writeInTransaction { db in
            for objProduct in productList{
                
                try objProduct.insert(db)
            }
            return .commit
        }
    }
    
    func updateDayWiseDetailedProductStatus(dcrDate: String, customerCode: String, customerRegionCode: String, productCode: String, status: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DAY_WISE_ASSETS_DETAILED) SET Active_Status = \(status) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrDate)') AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customerRegionCode)' AND Product_Code = '\(productCode)'")
    }
    
    //MARK:- DCR Refresh
    func deleteFieldDCRByDCRId(dcrId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = \(dcrId) AND DCR_Doctor_Visit_Code != '' AND Blob_Url != ''")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = \(dcrId) AND (Chemist_Visit_Id IS NOT NULL AND Chemist_Visit_Id > 0) AND Blob_Url != ''")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_COMPETITOR_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = \(dcrId)")
    }
    
    func deleteAttendanceDCRByDCRId(dcrId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Id = \(dcrId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Id = \(dcrId)")
    }
    
    func deleteLeaveDCRByDCRId(dcrId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = \(dcrId)")
    }
    
    func deleteAllDCRData()
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_EXPENSE_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_STOCKIST_VISIT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_RCPA_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMISTS_VISIT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DETAILED_PRODUCTS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ACCOMPANIST)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_HEADER)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_DAY_VISIT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_OWN)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ATTACHMENT)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP)")
        
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_MC_ACTIVITY)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_COMPETITOR_DETAILS)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING)")
        
    }
    
    func getUniqueDCRDates() -> [Row]
    {
        var dcrHeaderList: [Row] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try Row.fetchAll(db, "SELECT DCR_Actual_Date FROM \(TRAN_DCR_HEADER) GROUP BY DCR_Actual_Date ORDER BY DCR_Actual_Date")
        }
        
        return dcrHeaderList
    }
    
    func getAllDCRHeader() -> [DCRHeaderModel]?
    {
        var dcrHeaderList: [DCRHeaderModel]?
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Status <> -1")
        }
        
        return dcrHeaderList
    }
    
    func updateDCRCalendarHeader(activityDate: String, activityCount: Int, dcrStatus: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CALENDAR_HEADER) SET Activity_Count = \(activityCount), DCR_Status = \(dcrStatus) WHERE DATE(Activity_Date_In_Date) = DATE('\(activityDate)')")
    }
    
    func getInwardCountGivenInAllDCRs() -> [DCRSampleModel]?
    {
        var samplesList: [DCRSampleModel]?
        
        try? dbPool.read { db in
            samplesList = try DCRSampleModel.fetchAll(db, "SELECT Product_Code,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_SAMPLE_DETAILS) GROUP BY Product_Code")
        }
        
        return samplesList
    }
    
    func getBatchInwardCountGivenInAllDCRs() -> [DCRSampleBatchModel]?
    {
        var samplesList: [DCRSampleBatchModel]?
        
        try? dbPool.read { db in
            samplesList = try DCRSampleBatchModel.fetchAll(db, "SELECT Product_Code,Batch_Number,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) GROUP BY Product_Code,Batch_Number")
        }
        
        return samplesList
    }
    
    func getChemistInwardCountByDCRId(dcrId: Int) -> [DCRChemistSamplePromotion]
    {
        var samplesList: [DCRChemistSamplePromotion] = []
        
        try? dbPool.read { db in
            samplesList = try DCRChemistSamplePromotion.fetchAll(db, "SELECT Product_Code,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = ? GROUP BY Product_Code", arguments: [dcrId])
        }
        
        return samplesList
    }
    
    func getInwardCountGivenByDCRId(dcrId: Int) -> [DCRSampleModel]
    {
        var samplesList: [DCRSampleModel] = []
        
        try? dbPool.read { db in
            samplesList = try DCRSampleModel.fetchAll(db, "SELECT Product_Code,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Id = ? GROUP BY Product_Code", arguments: [dcrId])
        }
        
        return samplesList
    }
    
    func getBatchInwardCountGivenByDCRId(dcrId: Int) -> [DCRSampleBatchModel]
    {
        var samplesList: [DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            samplesList = try DCRSampleBatchModel.fetchAll(db, "SELECT Product_Code,Batch_Number,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = ? GROUP BY Product_Code,Batch_Number", arguments: [dcrId])
        }
        
        return samplesList
    }
    
    func getInwardCountGivenForAttendanceDCR(dcrId: Int) -> [DCRAttendanceSampleDetailsModel]
    {
        var samplesList: [DCRAttendanceSampleDetailsModel] = []
        
        try? dbPool.read { db in
            samplesList = try DCRAttendanceSampleDetailsModel.fetchAll(db, "SELECT Product_Code,SUM(Quantity_Provided) AS Quantity_Provided FROM \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS) WHERE DCR_Id = ? GROUP BY Product_Code", arguments: [dcrId])
        }
        
        return samplesList
    }
    
    func updateInwardQty(productCode: String, operation: String, quantity: Int)
    {
        executeQuery(query: "UPDATE \(MST_USER_PRODUCT) SET Current_Stock = Current_Stock \(operation) \(quantity) WHERE Product_Code = '\(productCode)'")
    }
    
    func updateBatchInwardQty(productCode: String,batchNumber: String,operation: String, quantity: Int)
    {
        executeQuery(query: "UPDATE \(MST_SAMPLE_BATCH_MAPPING) SET Batch_Current_Stock = Batch_Current_Stock \(operation) \(quantity) WHERE Product_Code = '\(productCode)' AND Batch_Number = '\(batchNumber)'")
    }
    
    func getCalendarStartDate() -> DCRCalendarModel?
    {
        var objCalendar: DCRCalendarModel?
        
        try? dbPool.read { db in
            objCalendar = try DCRCalendarModel.fetchOne(db, "SELECT Activity_Date_In_Date FROM \(TRAN_DCR_CALENDAR_HEADER) ORDER BY Activity_Date ASC LIMIT 1")
        }
        
        return objCalendar
    }
    
    func getAppliedDCRCount() -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE (DCR_Status = ? OR DCR_Status = ?) AND (DCR_Code IS NULL OR DCR_Code = '')", arguments: [DCRStatus.applied.rawValue,DCRStatus.approved.rawValue])!
        }
        
        return count
    }
    
    func getDraftDCRCount() -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE (DCR_Status = ?) AND (DCR_Code IS NULL OR DCR_Code = '')", arguments: [DCRStatus.drafted.rawValue])!
        }
        
        return count
    }
    
    
    func insertDoctorAccompanist(dataArray: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in dataArray
            {
                try DCRDoctorAccompanist(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertMenuMaster(dataArray: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in dataArray
            {
                try MenuMasterModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func updateLockLeaveInDCRCalendar(activityDate: String, attendanceLock: Int,fieldLock: Int,lockLeave:Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CALENDAR_HEADER) SET Is_Attendance_Lock = \(attendanceLock),Is_Field_Lock = \(fieldLock),Is_LockLeave = \(lockLeave)  WHERE DATE(Activity_Date) = DATE('\(activityDate)')")
    }
    
    func updateAllLockLeaveInDCRCalendar()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CALENDAR_HEADER) SET Is_Field_Lock = 0, Is_Attendance_Lock = 0,Is_LockLeave = 0")
    }
    
    //MARK:- Upload my DCR
    func getPendingDCRsForUpload() -> [DCRHeaderModel]
    {
        var dcrHeaderList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE (DCR_Status = ? OR DCR_Status = ?) AND (DCR_Code IS NULL OR DCR_Code = '') ORDER BY DCR_Actual_Date ASC", arguments: [DCRStatus.applied.rawValue, DCRStatus.approved.rawValue])
        }
        
        return dcrHeaderList
    }
    
    func getDCRHeaderForUpload(dcrId: Int) -> [DCRHeaderModel]
    {
        var dcrHeaderList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrHeaderList
    }
    
    func getDCRAccompanistForUpload(dcrId: Int) -> [DCRAccompanistModel]
    {
        var dcrAccompanistList: [DCRAccompanistModel] = []
        
        try? dbPool.read { db in
            dcrAccompanistList = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrAccompanistList
    }
    
    func getDCRDeleteDoctorAudit() -> [EDetailDoctorDeleteAudit]
    {
        var dcrAccompanistList: [EDetailDoctorDeleteAudit] = []
        
        try? dbPool.read { db in
            dcrAccompanistList = try EDetailDoctorDeleteAudit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_EDETAIL_DOCTOR_DELETE_AUDIT)")
        }
        
        return dcrAccompanistList
    }
    
    func deleteEDetailedDeleteDoctorAudit()
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_EDETAIL_DOCTOR_DELETE_AUDIT)")
    }
    
    func getDCRTravelledPlacesForUpload(dcrId: Int) -> [DCRTravelledPlacesModel]
    {
        var dcrSFCList: [DCRTravelledPlacesModel] = []
        
        try? dbPool.read { db in
            dcrSFCList = try DCRTravelledPlacesModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrSFCList
    }
    
    func getDCRDoctorVisitForUpload(dcrId: Int) -> [DCRDoctorVisitModel]
    {
        var dcrDoctorList: [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            dcrDoctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrDoctorList
    }
    func getDCRDoctorVisitPunchTimeValidation(dcrId: Int) -> [DCRDoctorVisitModel]
    {
        var dcrDoctorList: [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            dcrDoctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Punch_End_Time = ''", arguments: [dcrId])
        }
        
        return dcrDoctorList
    }
    func getDCRDoctorVisitid(dcrId: Int, doctorcode: String) -> [DCRDoctorVisitModel]
    {
        var dcrDoctorList: [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            dcrDoctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? ", arguments: [dcrId,doctorcode])
        }
        
        return dcrDoctorList
    }
    
    func getDCRDoctorAccompanistForUpload(dcrId: Int) -> [DCRDoctorAccompanist]
    {
        var dcrDoctorAccompanistList: [DCRDoctorAccompanist] = []
        
        try? dbPool.read { db in
            dcrDoctorAccompanistList = try DCRDoctorAccompanist.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrDoctorAccompanistList
    }
    
    func getDCRDetailedProductsForUpload(dcrId: Int) -> [DCRDetailedProductsModel]
    {
        var dcrDetailedProductList: [DCRDetailedProductsModel] = []
        
        try? dbPool.read { db in
            dcrDetailedProductList = try DCRDetailedProductsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DETAILED_PRODUCTS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrDetailedProductList
    }
    
    func getDCRSampleDetailsForUpload(dcrId: Int) -> [DCRSampleModel]
    {
        var dcrSampleList: [DCRSampleModel] = []
        
        try? dbPool.read { db in
            dcrSampleList = try DCRSampleModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_SAMPLE_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrSampleList
    }
    
    func getDCRSampleBatchDetailsForUpload(dcrId: Int,visitId:Int,productCode:String,entityType:String) -> [DCRSampleBatchModel]
    {
        var dcrSampleList: [DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            dcrSampleList = try DCRSampleBatchModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = ? AND Visit_Id = ? AND Product_Code = ? AND Entity_Type = ?", arguments: [dcrId,visitId,productCode,entityType])
        }
        
        return dcrSampleList
    }
    
    func getDCRChemistVisitForUpload(dcrId: Int) -> [DCRChemistVisitModel]
    {
        var dcrChemistList: [DCRChemistVisitModel] = []
        
        try? dbPool.read { db in
            dcrChemistList = try DCRChemistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMISTS_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrChemistList
    }
    
    func getDCRRCPADetailsForUpload(dcrId: Int) -> [DCRRCPAModel]
    {
        var rcpaList: [DCRRCPAModel] = []
        
        try? dbPool.read { db in
            rcpaList = try DCRRCPAModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_RCPA_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return rcpaList
    }
    
    func getDCRStockistVisitForUpload(dcrId: Int) -> [DCRStockistVisitModel]
    {
        var stcokistList: [DCRStockistVisitModel] = []
        
        try? dbPool.read { db in
            stcokistList = try DCRStockistVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_STOCKIST_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return stcokistList
    }
    
    func getDCRExpenseDetailsForUpload(dcrId: Int) -> [DCRExpenseModel]
    {
        var expenseList: [DCRExpenseModel] = []
        
        try? dbPool.read { db in
            expenseList = try DCRExpenseModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_EXPENSE_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return expenseList
    }
    
    func getDCRCountByDCRDate(dcrDate: Date) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND DCR_Status <> -1", arguments: [dcrDate])!
        }
        
        return count
    }
    
    func getDCRAttendanceActivitiesForUpload(dcrId: Int) -> [DCRAttendanceActivityModel]
    {
        var activitiesList: [DCRAttendanceActivityModel] = []
        
        try? dbPool.read { db in
            activitiesList = try DCRAttendanceActivityModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ATTENDANCE_ACTIVITIES) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return activitiesList
    }
    
    func updateDCRStatus(dcrId: Int, dcrStatus: Int, dcrCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = ?", arguments: [dcrId])
            {
                rowValue.DCR_Status = String(dcrStatus)
                rowValue.DCR_Code = dcrCode
                try! rowValue.update(db)
            }
        })
    }
    
    func updateDCRStatusAndLocation(dcrId: Int, dcrStatus: Int, latitude: String, longitude: String, dcrCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = ?", arguments: [dcrId])
            {
                rowValue.DCR_Status = String(dcrStatus)
                rowValue.Lattitude = latitude
                rowValue.Longitude = longitude
                rowValue.DCR_Code = dcrCode
                
                try! rowValue.update(db)
            }
        })
    }
    
    func getPOBHeaderForUpload(dcrId: Int) -> [DCRDoctorVisitPOBHeaderModel]
    {
        var pobHeaderList: [DCRDoctorVisitPOBHeaderModel] = []
        
        try? dbPool.read { db in
            pobHeaderList = try DCRDoctorVisitPOBHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return pobHeaderList
    }
    
    func getPOBDetailsForUpload(dcrId: Int) -> [DCRDoctorVisitPOBDetailsModel]
    {
        var pobDetailsList: [DCRDoctorVisitPOBDetailsModel] = []
        
        try? dbPool.read { db in
            pobDetailsList = try DCRDoctorVisitPOBDetailsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return pobDetailsList
    }
    
    func getPOBRemarksForUpload(dcrId: Int) -> [DCRDoctorVisitPOBRemarksModel]
    {
        var remarksList: [DCRDoctorVisitPOBRemarksModel] = []
        
        try? dbPool.read { db in
            remarksList = try DCRDoctorVisitPOBRemarksModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return remarksList
    }
    
    func getChemistDayVisitDetailsForUpload(dcrId: Int) -> [ChemistDayVisit]
    {
        var chemistDayList: [ChemistDayVisit] = []
        
        try? dbPool.read { db in
            chemistDayList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistDayList
    }
    
    func getChemistAccompanistForUpload(dcrId: Int) -> [DCRChemistAccompanist]
    {
        var chemistAccompanistList: [DCRChemistAccompanist] = []
        
        try? dbPool.read { db in
            chemistAccompanistList = try DCRChemistAccompanist.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistAccompanistList
    }
    
    func getChemistSamplestForUpload(dcrId: Int) -> [DCRChemistSamplePromotion]
    {
        var chemistSamplesList: [DCRChemistSamplePromotion] = []
        
        try? dbPool.read { db in
            chemistSamplesList = try DCRChemistSamplePromotion.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistSamplesList
    }
    
    func getChemistDetailedProductsForUpload(dcrId: Int) -> [DCRChemistDetailedProduct]
    {
        var chemistDetailProductList: [DCRChemistDetailedProduct] = []
        
        try? dbPool.read { db in
            chemistDetailProductList = try DCRChemistDetailedProduct.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistDetailProductList
    }
    
    func getChemistAttachmentsForUpload(dcrId: Int) -> [DCRChemistAttachment]
    {
        var chemistAttachmentList: [DCRChemistAttachment] = []
        
        try? dbPool.read { db in
            chemistAttachmentList = try DCRChemistAttachment.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistAttachmentList
    }
    
    func getChemistAttachmentsByDCRId(dcrId: Int) -> [DCRChemistAttachment]
    {
        var chemistAttachmentList: [DCRChemistAttachment] = []
        
        try? dbPool.read { db in
            chemistAttachmentList = try DCRChemistAttachment.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND (Chemist_Visit_Id IS NOT NULL AND Chemist_Visit_Id > 0) AND Blob_Url != ''", arguments: [dcrId])
        }
        
        return chemistAttachmentList
    }
    
    func getChemistFollowupsForUpload(dcrId: Int) -> [DCRChemistFollowup]
    {
        var chemistFollowupList: [DCRChemistFollowup] = []
        
        try? dbPool.read { db in
            chemistFollowupList = try DCRChemistFollowup.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistFollowupList
    }
    
    func getChemistRCPAOwnForUpload(dcrId: Int) -> [DCRChemistRCPAOwn]
    {
        var chemistRCPAOwnList: [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            chemistRCPAOwnList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistRCPAOwnList
    }
    
    func getChemistRCPACompetitorForUpload(dcrId: Int) -> [DCRChemistRCPACompetitor]
    {
        var chemistRCPACompList: [DCRChemistRCPACompetitor] = []
        
        try? dbPool.read { db in
            chemistRCPACompList = try DCRChemistRCPACompetitor.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistRCPACompList
    }
    
    //MARK:- General Remarks
    func updateDCRGeneralRemarksDetails(dcrId : Int,remarksTxt : String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, key: dcrId)
            {
                rowValue.DCR_General_Remarks = remarksTxt
                try! rowValue.update(db)
            }
        })
    }
    
    func getDCRStepperGeneralRemarks(dcrId : Int) -> String
    {
        var dcrGeneralRemarks : String = ""
        try? dbPool.read ({ db in
            let dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Id = ?" , arguments : [dcrId])
            if dcrHeaderList.count > 0
            {
                dcrGeneralRemarks = dcrHeaderList[0].DCR_General_Remarks!
            }
            
        })
        return dcrGeneralRemarks
    }
    
    //MARK: - Work place CP validation
    func deleteSFCDetailsWorkplace()
    {
        let dcrId = DCRModel.sharedInstance.dcrId
        
        try? dbPool.write({ db in
            if let rowValue = try DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = \(dcrId!)")
            {
                try! rowValue.delete(db)
            }
        })
        
    }
    
    func deleteTPSFCDetailsWorkplace()
    {
        let tpEntryId = TPModel.sharedInstance.tpEntryId
        
        try? dbPool.write({ db in
            if let rowValue = try TourPlannerSFC.fetchOne(db, "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id = \(tpEntryId!)")
            {
                try! rowValue.delete(db)
            }
        })
        
    }
    
    func getSFCDetailsforCPCode(cpCode : String) -> [CampaignPlannerSFC]
    {
        var sfcList : [CampaignPlannerSFC] = []
        
        try? dbPool.read ({ db in
            sfcList = try CampaignPlannerSFC.fetchAll(db, "SELECT \(MST_CP_SFC).*, \(MST_WORK_CATEGORY).Category_Name FROM \(MST_CP_SFC) LEFT JOIN \(MST_WORK_CATEGORY) ON \(MST_CP_SFC).SFC_Category_Code = \(MST_WORK_CATEGORY).Category_Code WHERE CP_Code = ?" , arguments : [cpCode])
        })
        
        return sfcList
    }
    
    //MARK:-- Menu Access
    func getMenuMasterByMenuIDs(menuIds: String) -> [MenuMasterModel]
    {
        var menuList : [MenuMasterModel] = []
        
        try? dbPool.read ({ db in
            menuList = try MenuMasterModel.fetchAll(db, "SELECT * FROM \(MST_MENU_MASTER) WHERE Menu_Id IN (\(menuIds))")
        })
        
        return menuList
    }
    
    func getMenuMasterByMenuType(MenuType: String, MenuCategory: String) -> [MenuMasterModel]
    {
        var menuList: [MenuMasterModel] = []
        
        try? dbPool.read ({ db in
            menuList = try MenuMasterModel.fetchAll(db, "SELECT * FROM \(MST_MENU_MASTER) WHERE Type = '3' AND Category = 'Responsive' ")
        })
        
        return menuList
    }
    
    //MARK:- Dashboard
    func getDashboardDetailIdByEntityId(entityId: Int, dashboardId: Int) -> DashboardDetailsModel?
    {
        var objDashboardDetail: DashboardDetailsModel?
        
        try? dbPool.read ({ db in
            objDashboardDetail = try DashboardDetailsModel.fetchOne(db, "SELECT * FROM \(MST_DASHBOARD_DETAILS) WHERE Entity_Id = ? AND Dashboard_Id = ?", arguments : [entityId, dashboardId])
        })
        
        return objDashboardDetail
    }
    
    func insertDashboardHeader(array: NSArray, userCode: String, regionCode: String) -> Int
    {
        var dashboardId = 0
        
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DashboardHeaderModel(dict: data as! NSDictionary, userCode: userCode, regionCode: regionCode).insert(db)
            }
            
            dashboardId = Int(db.lastInsertedRowID)
            return .commit
        }
        
        return dashboardId
    }
    
    func insertDashboardDetail(array: NSArray, dashboardId: Int)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DashboardDetailsModel(dict: data as! NSDictionary, dashboardId: dashboardId).insert(db)
            }
            return .commit
        }
    }
    
    
    func insertBussinessP(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try BussinessPotential(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertTravelTrackingReport(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try travelTrackingReport(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    func insertHourlyReport(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try HourlyReportModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    func insertDashboardDateDetail(array: NSArray, dashboardDetailId: Int, dashboardId: Int)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DashboardDateDetailsModel(dict: data as! NSDictionary, dashboardDetailId: dashboardDetailId, dashboardId: dashboardId).insert(db)
            }
            return .commit
        }
    }
    
    func insertDashboardMissedDoctor(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DashboardMissedDoctorModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getDashboardHeader(userCode: String, regionCode: String) -> DashboardHeaderModel?
    {
        var objDashboardHeader : DashboardHeaderModel?
        
        try? dbPool.read ({ db in
            objDashboardHeader = try DashboardHeaderModel.fetchOne(db, "SELECT * FROM \(MST_DASHBOARD_HEADER) WHERE User_Code = ? AND Region_Code = ?" , arguments : [userCode,regionCode])
        })
        
        return objDashboardHeader
    }
    
    func getDashboardDetails(dashboardId: Int) -> [DashboardDetailsModel]
    {
        var dashboardDetailList : [DashboardDetailsModel] = []
        
        try? dbPool.read ({ db in
            dashboardDetailList = try DashboardDetailsModel.fetchAll(db, "SELECT * FROM \(MST_DASHBOARD_DETAILS) WHERE Dashboard_Id = ?" , arguments : [dashboardId])
        })
        
        return dashboardDetailList
    }
    
    func getDashboardDateDetails(dashboardId: Int, dashboardDetailId: Int) -> [DashboardDateDetailsModel]
    {
        var dashboardDetailList : [DashboardDateDetailsModel] = []
        
        try? dbPool.read ({ db in
            dashboardDetailList = try DashboardDateDetailsModel.fetchAll(db, "SELECT * FROM \(MST_DASHBOARD_DATE_DETAILS) WHERE Dashboard_Id = ? AND Dashboard_Detail_Id = ?" , arguments : [dashboardId, dashboardDetailId])
        })
        
        return dashboardDetailList
    }
    
    func getDashboardMissedDoctors() -> [DashboardMissedDoctorModel]
    {
        var dashboardMissedDoctors : [DashboardMissedDoctorModel] = []
        
        try? dbPool.read ({ db in
            dashboardMissedDoctors = try DashboardMissedDoctorModel.fetchAll(db, "SELECT * FROM \(MST_DASHBOARD_MISSED_DOCTOR)")
        })
        
        return dashboardMissedDoctors
    }
    
    func deleteDashboardHeader(dashboardId: Int)
    {
        executeQuery(query: "DELETE FROM \(MST_DASHBOARD_HEADER) WHERE Dashboard_Id = \(dashboardId)")
    }
    
    func deleteDashboardDetails(dashboardId: Int)
    {
        executeQuery(query: "DELETE FROM \(MST_DASHBOARD_DETAILS) WHERE Dashboard_Id = \(dashboardId)")
    }
    
    func deleteDashboardDateDetails(dashboardId: Int)
    {
        executeQuery(query: "DELETE FROM \(MST_DASHBOARD_DATE_DETAILS) WHERE Dashboard_Id = \(dashboardId)")
    }
    
    func deleteDashboardMissedDoctors(dashboardId: Int)
    {
        executeQuery(query: "DELETE FROM \(MST_DASHBOARD_MISSED_DOCTOR) WHERE Dashboard_Id = \(dashboardId)")
    }
    
    //MARK:- Dashboard PS
    
    func insertPSDetails(dataArray: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in dataArray
            {
                try DashboardPSHeaderModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertPSProductDetails(dataArray: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in dataArray
            {
                try DashboardPSDetailsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCollectionDetails(dataArray: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in dataArray
            {
                try DashboardCollectionValuesModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getPSDetails() -> [DashboardPSHeaderModel]
    {
        var documentDetails : [DashboardPSHeaderModel] = []
        
        try? dbPool.read { db in
            
            documentDetails = try DashboardPSHeaderModel.fetchAll(db , "SELECT *  FROM \(TRAN_PS_Header) ORDER BY Display_Order" )
        }
        
        return documentDetails
    }
    
    func getCollectionDetails() -> [DashboardCollectionValuesModel]
    {
        var collectionDetails : [DashboardCollectionValuesModel] = []
        
        try? dbPool.read { db in
            
            collectionDetails = try DashboardCollectionValuesModel.fetchAll(db , "SELECT * FROM \(TRAN_PS_Collection_Values)" )
        }
        return collectionDetails
    }
    
    func getPSProductDetails() ->  [DashboardPSDetailsModel]
    {
        var collectionDetails : [DashboardPSDetailsModel] = []
        
        try? dbPool.read { db in
            
            collectionDetails = try DashboardPSDetailsModel.fetchAll(db , "SELECT *  FROM \(TRAN_PS_ProductDetails)" )
        }
        return collectionDetails
    }
    
    func deleteDashboardPSDetails()
    {
        executeQuery(query: "DELETE FROM \(TRAN_PS_ProductDetails)")
        executeQuery(query: "DELETE FROM \(TRAN_PS_Collection_Values)")
        executeQuery(query: "DELETE FROM \(TRAN_PS_Header)")
    }
    
    //MARK:- Reports
    //MARK:-- User Per Day Report
    func getAllChildUsers() -> [AccompanistModel]
    {
        var accompanistList: [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistList = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) WHERE Is_Child_User = ? ORDER BY LOWER(Employee_name) ASC", arguments: [1])
        }
        
        return accompanistList
    }
    
    func getAllChildUsersExceptVacant() -> [AccompanistModel]
    {
        var accompanistList: [AccompanistModel] = []
        
        try? dbPool.read { db in
            accompanistList = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) WHERE Is_Child_User = ? AND UPPER(User_Code) <> ? AND UPPER(User_Code) <> ? ORDER BY LOWER(Employee_name) ASC", arguments: [1,VACANT.uppercased(),NOT_ASSIGNED.uppercased()])
        }
        
        return accompanistList
    }
    
    func getAppliedDCRs() -> [DCRHeaderModel]
    {
        var dcrHeaderList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Status != ?", arguments: [DCRStatus.newDCR.rawValue])
        }
        
        return dcrHeaderList
    }
    
    func getLoginUserDetails() -> UserModel?
    {
        var objUser: UserModel?
        
        try? dbPool.read { db in
            objUser = try UserModel.fetchOne(db, "SELECT * FROM \(MST_USER_DETAILS)")
        }
        
        return objUser
    }
    
    
    //MARK:- Tp Report
    
    func getTpList() -> [TourPlannerHeader]
    {
        var tpList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tpList = try TourPlannerHeader.fetchAll(db , "SELECT * FROM \(TRAN_TP_HEADER)")
        }
        return tpList
    }
    
    func getTPHeaderExceptHolidayAndWeekend() -> [TourPlannerHeader]
    {
        var tpList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tpList = try TourPlannerHeader.fetchAll(db , "SELECT * FROM \(TRAN_TP_HEADER) WHERE Activity > 0")
        }
        return tpList
    }
    
    func getTpProductDetails() -> [TourPlannerProduct]
    {
        let tpProductList : [TourPlannerProduct] = []
        
        
        return tpProductList
    }
    
    
    func getTpDoctorDetailsByTpId(TP_Entry_Id : Int) -> [TourPlannerDoctor]
    {
        var tpDoctorList : [TourPlannerDoctor] = []
        
//   **     TP_Doctor_Id = row["TP_Doctor_Id"]
//   **     TP_Id = row["TP_Id"]
//   **     TP_Date = row["TP_Date"]
//   **     Doctor_Code = row["Doctor_Code"]
//   **     Doctor_Region_Code = row["Doctor_Region_Code"]
//   **     Doctor_Region_Name = row["Doctor_Region_Name"]
//   **     Doctor_Name = row["Doctor_Name"]
//        Speciality_Name = row["Speciality_Name"]
//        MDL_Number = row["MDL_Number"]
//        Category_Code = row["Category_Code"]
//        Category_Name = row["Category_Name"]
//   **     TP_Entry_Id = row["TP_Entry_Id"]
        
        
        try? dbPool.read { db in

                tpDoctorList = try TourPlannerDoctor.fetchAll(db , "SELECT \(MST_CUSTOMER_MASTER).MDL_Number,\(MST_CUSTOMER_MASTER).Hospital_Name,\(MST_CUSTOMER_MASTER).Customer_Code,\(MST_CUSTOMER_MASTER).Speciality_Name,\(MST_CUSTOMER_MASTER).Category_Name,\(TRAN_TP_DOCTOR).Doctor_Region_Name,\(TRAN_TP_DOCTOR).TP_Date,\(TRAN_TP_DOCTOR).TP_Id,\(TRAN_TP_DOCTOR).TP_Doctor_Id,\(TRAN_TP_DOCTOR).TP_Entry_Id,\(TRAN_TP_DOCTOR).Doctor_Name,\(TRAN_TP_DOCTOR).Doctor_Code,\(TRAN_TP_DOCTOR).Doctor_Region_Code FROM \(TRAN_TP_DOCTOR) INNER JOIN \(MST_CUSTOMER_MASTER) on \(MST_CUSTOMER_MASTER).Customer_Code = \(TRAN_TP_DOCTOR).Doctor_Code AND \(MST_CUSTOMER_MASTER).Region_Code = \(TRAN_TP_DOCTOR).Doctor_Region_Code where TP_Entry_Id = ?", arguments: [TP_Entry_Id])
//            tpDoctorList = try TourPlannerDoctor.fetchAll(db , "SELECT \(TRAN_TP_DOCTOR).* , \(MST_CUSTOMER_MASTER).Customer_Name AS Doctor_Name , \(MST_CUSTOMER_MASTER).MDL_Number AS MDL_Number , \(MST_CUSTOMER_MASTER).Region_Name AS Doctor_Region_Name , \(MST_CUSTOMER_MASTER).Category_Name , \(MST_CUSTOMER_MASTER).Customer_Code, \(MST_CUSTOMER_MASTER).Speciality_Name, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_TP_DOCTOR) INNER JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_TP_DOCTOR).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code AND \(TRAN_TP_DOCTOR).Doctor_Region_Code = \(MST_CUSTOMER_MASTER).Region_Code WHERE \(TRAN_TP_DOCTOR).TP_Entry_Id = ?" , arguments: [TP_Entry_Id])

        }
        
        return tpDoctorList
    }
    
    func getTpDoctorDetailsByTpId1(tpdate: Date) -> [TourPlannerDoctor]
    {
        var tpDoctorList : [TourPlannerDoctor] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormatter.string(from: tpdate)
        //        try? dbPool.read { db in
        //            tpDoctorList = try TourPlannerDoctor.fetchAll(db , "SELECT \(TRAN_TP_DOCTOR).* , \(MST_CUSTOMER_MASTER).Customer_Name AS Doctor_Name , \(MST_CUSTOMER_MASTER).MDL_Number AS MDL_Number , \(MST_CUSTOMER_MASTER).Region_Name AS Doctor_Region_Name , \(MST_CUSTOMER_MASTER).Category_Name , \(MST_CUSTOMER_MASTER).Customer_Code, \(MST_CUSTOMER_MASTER).Speciality_Name, \(MST_CUSTOMER_MASTER).Hospital_Name FROM \(TRAN_TP_DOCTOR) INNER JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_TP_DOCTOR).Doctor_Code = \(MST_CUSTOMER_MASTER).Customer_Code AND \(TRAN_TP_DOCTOR).Doctor_Region_Code = \(MST_CUSTOMER_MASTER).Region_Code WHERE \(TRAN_TP_DOCTOR).TP_Entry_Id = ?" , arguments: [tpEntryId])
        
        
        try? dbPool.read { db in
            tpDoctorList = try TourPlannerDoctor.fetchAll(db , "SELECT \(MST_CUSTOMER_MASTER).MDL_Number,\(MST_CUSTOMER_MASTER).Hospital_Name,\(MST_CUSTOMER_MASTER).Customer_Code,\(MST_CUSTOMER_MASTER).Speciality_Name,\(MST_CUSTOMER_MASTER).Category_Name,\(TRAN_TP_DOCTOR).Doctor_Region_Name,\(TRAN_TP_DOCTOR).TP_Date,\(TRAN_TP_DOCTOR).TP_Id,\(TRAN_TP_DOCTOR).TP_Doctor_Id,\(TRAN_TP_DOCTOR).TP_Entry_Id,\(TRAN_TP_DOCTOR).Doctor_Name,\(TRAN_TP_DOCTOR).Doctor_Code,\(TRAN_TP_DOCTOR).Doctor_Region_Code FROM \(TRAN_TP_DOCTOR) INNER JOIN \(MST_CUSTOMER_MASTER) on \(MST_CUSTOMER_MASTER).Customer_Code = \(TRAN_TP_DOCTOR).Doctor_Code AND \(MST_CUSTOMER_MASTER).Region_Code = \(TRAN_TP_DOCTOR).Doctor_Region_Code where TP_Date = ?", arguments: [dateStr])
            
        }
        
        return tpDoctorList
    }
    
    func getDoctorPersonalInfo(customerCode: String, regionCode: String) -> CustomerMasterPersonalInfo?
    {
        var doctorObj : CustomerMasterPersonalInfo?
        
        try? dbPool.read { db in
            doctorObj = try CustomerMasterPersonalInfo.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER_PERSONAL_INFO) WHERE Customer_Code = ? AND Region_Code = ?",arguments:[customerCode, regionCode])
        }
        return doctorObj
    }
    
    func getDoctorPersonalInfoEdit(customerCode: String, regionCode: String) -> CustomerMasterPersonalInfoEdit?
    {
        var doctorObj : CustomerMasterPersonalInfoEdit?
        
        try? dbPool.read { db in
            doctorObj = try CustomerMasterPersonalInfoEdit.fetchOne(db, "SELECT * FROM \(MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT) WHERE Customer_Code = ? AND Region_Code = ?",arguments:[customerCode, regionCode])
        }
        return doctorObj
    }
    
    func deleteCustomerMasterEditByCusotmerCode(customerCode: String, regionCode: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT) WHERE Customer_Code = '\(customerCode)' AND Region_Code = '\(regionCode)'")
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER_EDIT) WHERE Customer_Code = '\(customerCode)' AND Region_Code = '\(regionCode)'")
    }
    
    func deleteCustomerMasterByCusotmerCode(customerCode: String, regionCode: String)
    {
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER_PERSONAL_INFO) WHERE Customer_Code = '\(customerCode)' AND Region_Code = '\(regionCode)'")
        executeQuery(query: "DELETE FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code = '\(customerCode)' AND Region_Code = '\(regionCode)'")
    }
    
    //MARK:- Delete DCR
    func getDCRHeaderForDeleteDCR(dcrStatus: String) -> [DCRHeaderModel]
    {
        var dcrHeaderList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            dcrHeaderList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Status IN (\(dcrStatus)) ORDER BY DCR_Actual_Date DESC")
        }
        
        return dcrHeaderList
    }
    
    func getDoctorVisitTracker() -> [DoctorVisitTrackerModel]
    {
        var trackerList : [DoctorVisitTrackerModel] = []
        
        try? dbPool.read { db in
            trackerList = try DoctorVisitTrackerModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_TRACKER)")
        }
        
        return trackerList
    }
    
    func deletelDoctorVisitTracker()
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_TRACKER)")
    }
    
    //MARL:- DCR Accompanist Data Validations
    func getCPCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) INNER JOIN \(MST_CP_HEADER) ON \(TRAN_DCR_HEADER).CP_Code = \(MST_CP_HEADER).CP_Code WHERE \(TRAN_DCR_HEADER).DCR_Id = ? AND \(MST_CP_HEADER).Region_Code = ? ", arguments: [dcrId, regionCode])!
        }
        
        return count
    }
    
    func getSFCCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = ? AND Region_Code = ?", arguments: [dcrId, regionCode])!
        }
        
        return count
    }
    
    func getDoctorCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Region_Code = ?", arguments: [dcrId, regionCode])!
        }
        
        return count
    }
    
    func getDoctorAccompanistCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String , userCode : String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId, regionCode,userCode])!
        }
        
        return count
    }
    
    func getChemistAccompanistCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String , userCode : String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId, regionCode,userCode])!
        }
        
        return count
    }
    
    func getChemistCountUsedInDCRByRegionCode(dcrId: Int, regionCode: String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMISTS_VISIT) INNER JOIN \(MST_CUSTOMER_MASTER) ON \(TRAN_DCR_CHEMISTS_VISIT).Chemist_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE \(TRAN_DCR_CHEMISTS_VISIT).DCR_Id = ? AND \(MST_CUSTOMER_MASTER).Region_Code = ? ", arguments: [dcrId, regionCode])!
        }
        
        return count
    }
    
    //MARK:- Delete Accompanist Data
    
    func deleteCPUsedInDCRByRegionCode(dcrId: Int, regionCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRHeaderModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_HEADER) INNER JOIN \(MST_CP_HEADER) ON \(TRAN_DCR_HEADER).CP_Code = \(MST_CP_HEADER).CP_Code WHERE \(TRAN_DCR_HEADER).DCR_Id = ? AND \(MST_CP_HEADER).Region_Code = ? ", arguments: [dcrId, regionCode])
            {
                rowValue.CP_Code = EMPTY
                rowValue.CP_Name = EMPTY
                try! rowValue.update(db)
            }
        })
    }
    
    func deleteSFCUsedInDCRByRegionCode(dcrId: Int, regionCode: String)
    {
        //        try? dbPool.write({ db in
        //            if let rowValue = DCRTravelledPlacesModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = ? AND Region_Code = ?", arguments: [dcrId, regionCode])
        //            {
        //                try! rowValue.delete(db)
        //            }
        //        })
        
        executeQuery(query: "DELETE FROM \(TRAN_DCR_TRAVELLED_PLACES) WHERE DCR_Id = \(dcrId) AND Region_Code = '\(regionCode)'")
    }
    
    func deleteDoctorUsedInDCRByRegionCode(dcrId: Int, regionCode: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRDoctorVisitModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Region_Code = ?", arguments: [dcrId, regionCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getDoctorUsedInDCRByRegionCode(dcrId: Int, regionCode: String) -> [DCRDoctorVisitModel]
    {
        var doctorList: [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            doctorList = try DCRDoctorVisitModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Region_Code = ?", arguments: [dcrId, regionCode])
        }
        
        return doctorList
    }
    
//    func getEdetailingModified(drcCustomerCode: String ,regionCode: String) -> [DCRDoctorVisitModel]
//    {
//        var doctorList: [DCRDoctorVisitModel] = []
//        
//        try? dbPool.read { db in
//            doctorList = try DCRDoctorVisitModel.fetchAll(db, "select \(TRAN_DCR_DOCTOR_VISIT).Doctor_Code,\(TRAN_DCR_DOCTOR_VISIT).Doctor_Region_Code from \(TRAN_DCR_DOCTOR_VISIT) inner join + \(MST_CUSTOMER_MASTER) on \(MST_CUSTOMER_MASTER).DCR_Id = \(TRAN_DCR_DOCTOR_VISIT).DCR_Id and \(TRAN_TP_SFC).Flag = 1 where \(TRAN_DCR_DOCTOR_VISIT).Doctor_Code = ? and \(TRAN_DCR_DOCTOR_VISIT).Doctor_Region_Code = ? and \(MST_CUSTOMER_MASTER).DCR_Actual_Date = CURRENT_DATE", arguments: [drcCustomerCode, regionCode])
//        }
//        return doctorList
//    }
    
    func getDoctorUsedInChemistRCPAByRegionCode(dcrId: Int, regionCode: String) -> [DCRChemistRCPAOwn]
    {
        var accDocList: [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            accDocList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND Doctor_Region_Code = ?", arguments: [dcrId, regionCode])
        }
        
        return accDocList
    }
    
    func deleteDoctorAccompanistUsedInDCRByRegionCode(dcrId: Int, regionCode: String , userCode : String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRDoctorAccompanist.fetchOne(db,"DELETE FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId, regionCode,userCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    func deleteChemistAccompanistUsedInDCRByRegionCode(dcrId: Int, regionCode: String , userCode : String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistAccompanist.fetchOne(db,"DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = ? AND Acc_Region_Code = ? AND Acc_User_Code = ?", arguments: [dcrId, regionCode,userCode])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteChemistUsedInDCRByRegionCode(dcrId: Int, regionCode: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMISTS_VISIT)  WHERE  \(TRAN_DCR_CHEMISTS_VISIT).Chemist_Code IN (SELECT \(MST_CUSTOMER_MASTER).Customer_Code  FROM  \(MST_CUSTOMER_MASTER) INNER JOIN \(TRAN_DCR_CHEMISTS_VISIT) ON \(TRAN_DCR_CHEMISTS_VISIT).Chemist_Code = \(MST_CUSTOMER_MASTER).Customer_Code WHERE   \(TRAN_DCR_CHEMISTS_VISIT).DCR_Id = \(dcrId) AND  \(MST_CUSTOMER_MASTER).Region_Code = \(regionCode))")
    }
    
    //MARK:- TP Download Alert
    func getTPCountForTPDate(tpDate: String, status: Int) -> Int
    {
        var count = 0
        var query = EMPTY
        if status == 0
        {
            query = "SELECT COUNT(*) FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) = DATE('\(tpDate)')"
        }
        else
        {
            query = "SELECT COUNT(*) FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) = DATE('\(tpDate)') AND Status = \(status)"
        }
        print(query)
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, query)!
        }
        
        return count
    }
    
    func deleteTPdata(startDate: String, endDate: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_TP_PRODUCT) WHERE TP_Id IN (SELECT TP_Id FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_DOCTOR) WHERE TP_Id IN (SELECT TP_Id FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Id IN (SELECT TP_Id FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Id IN (SELECT TP_Id FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        deleteTPUnfrezeDates(startDate: startDate, endDate: endDate)
    }
    
    func deleteTPHeader(tpEntryId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_TP_HEADER) WHERE TP_Entry_Id = \(tpEntryId)")
    }
    
    func deleteTPUnfrezeDates(startDate: String, endDate: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_TP_HEADER) WHERE TP_Id IN (SELECT TP_Id FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
    }
    
    //MARK:- Follow Up
    
    func insertDCRFollowUpDetail(followUpObj : DCRFollowUpModel)
    {
        try? dbPool.write({ db in
            try followUpObj.insert(db)
        })
    }
    
    func getDCRFollowUpDetailsByDCRId(dcrId : Int) -> [DCRFollowUpModel]
    {
        var dcrFollowUpList :  [DCRFollowUpModel] = []
        
        try? dbPool.read { db in
            dcrFollowUpList = try DCRFollowUpModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrFollowUpList
    }
    
    func getDCRFollowUpModel(dcrId: Int, dcrDoctorVisitId : Int) -> [DCRFollowUpModel]
    {
        var dcrFollowUpList :  [DCRFollowUpModel] = []
        
        try? dbPool.read { db in
            dcrFollowUpList = try DCRFollowUpModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, dcrDoctorVisitId])
        }
        
        return dcrFollowUpList
    }
    
    func updateFollowUpDetail(followUpObj : DCRFollowUpModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRFollowUpModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ? AND Follow_Up_Id = ?", arguments: [followUpObj.DCR_Id,followUpObj.DCR_Doctor_Visit_Id,followUpObj.Follow_Up_Id])
            {
                rowValue.Follow_Up_Text = followUpObj.Follow_Up_Text!
                rowValue.Due_Date = followUpObj.Due_Date!
                try! rowValue.update(db)
            }
        })
    }
    
    func deleteFollowUpDetail(followUpObj : DCRFollowUpModel)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttendanceActivityModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) WHERE DCR_Id = \(followUpObj.DCR_Id!) AND DCR_Doctor_Visit_Id = \(followUpObj.DCR_Doctor_Visit_Id!) AND Follow_Up_Id = \(followUpObj.Follow_Up_Id!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:- Attachment
    
    func insertLeaveAttachmentDetail(dcrLeaveModel: DCRLeaveModel)
    {
        try? dbPool.write({ db in
            try dcrLeaveModel.insert(db)
        })
    }
    
    
    func insertAttachmentDetail(dcrAttachmentModel: DCRAttachmentModel)
    {
        try? dbPool.write({ db in
            try dcrAttachmentModel.insert(db)
        })
    }
    
    func getAttachmentDetails(dcrId: Int, doctorVisitId: Int) -> [DCRAttachmentModel]?
    {
        var dcrAttachmentList: [DCRAttachmentModel]?
        
        try? dbPool.read ({ db in
            dcrAttachmentList = try DCRAttachmentModel.fetchAll(db, "SELECT Id, Attachment_Size, Blob_Url, Uploaded_File_Name, IsFile_Downloaded FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments : [dcrId, doctorVisitId])
        })
        
        return dcrAttachmentList
    }
    
    func getLeaveAttachmentDetails(dcrDate: String) -> [DCRLeaveModel]?
    {
        var dcrAttachmentList: [DCRLeaveModel]?
        
        try? dbPool.read ({ db in
            dcrAttachmentList = try DCRLeaveModel.fetchAll(db, "SELECT Attachment_Id, Attachment_Size, Document_Url, Uploaded_File_Name, IsFile_Downloaded FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE DCR_Actual_Date = ?", arguments : [dcrDate])
        })
        
        return dcrAttachmentList
    }
    
    func deleteAttachment(attachmentId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE Id = ?", arguments : [attachmentId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    func insertNotesAttachmentDetail(dcrAttachmentModel: NotesAttachment)
    {
        try? dbPool.write({ db in
            try dcrAttachmentModel.insert(db)
        })
    }
    func getAttachmentNotes() -> [NotesAttachment]?
    {
        var dcrAttachmentList: [NotesAttachment]?
        
        try? dbPool.read ({ db in
            dcrAttachmentList = try NotesAttachment.fetchAll(db, "SELECT * FROM \(Notes_Attachment)")
        })
        
        return dcrAttachmentList
    }
    
    func deleteNotesAttachment()
    {
        executeQuery(query: "DELETE FROM \(Notes_Attachment)")
    }
    func deleteLeaveAttachment(attachmentId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id = ?", arguments : [attachmentId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    
    func deleteLeaveAttachmentDCR(dcrDate: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE DCR_Actual_Date = ?", arguments : [dcrDate])
            {
                try! rowValue.delete(db)
            }
        })
    }
    // executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE Order_Entry_Id = \(orderEntryId)")
    func getAttachmentCountPerDoctor(dcrId: Int, doctorVisitId: Int) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])!
        }
        
        return count
    }
    
    func getAttachmentCountForLeave(dcrDate: String) -> Int
    {
        var count: Int = 0

        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE DCR_Actual_Date = ?", arguments: [dcrDate])!
        }

        return count
    }


    
    func updateAttachmentDCRVisitCode(dcrId: Int, doctorVisitId: Int, dcrVisitCode: String)
    {
        //        try? dbPool.write({ db in
        //            if let rowValue = DCRAttachmentModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Doctor_Visit_Id = ?", arguments: [dcrId, doctorVisitId])
        //            {
        //                rowValue.dcrVisitCode = dcrVisitCode
        //                try! rowValue.update(db)
        //            }
        //        })
        
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) SET DCR_Doctor_Visit_Code = '\(dcrVisitCode)' WHERE DCR_Id = \(dcrId) AND DCR_Doctor_Visit_Id = \(doctorVisitId)")
    }
    
    func updateChemistAttachmentVisitId(chemistDayVisitId: Int, cvVisitId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ATTACHMENT) SET Chemist_Visit_Id = '\(cvVisitId)' WHERE DCR_Chemist_Day_Visit_Id = \(chemistDayVisitId)")
    }
    
    func getPendingAttachmentsToUpload() -> [DCRAttachmentModel]
    {
        var modelList : [DCRAttachmentModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRAttachmentModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Code != '' AND Blob_Url = '' AND Uploaded_File_Name != '' AND Is_Success = -1 LIMIT \(maxConcurrentOperationCount)")
        })
        
        return modelList
    }
    
    func leaveAttachmentsToUpload() -> [DCRLeaveModel]
    {
        var modelList : [DCRLeaveModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRLeaveModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id != '' AND Uploaded_File_Name != '' AND Is_Success = -1 LIMIT \(maxConcurrentOperationCount)")
        })
        
        return modelList
    }
    
    func getPendingChemistAttachmentsToUpload() -> [DCRChemistAttachment]
    {
        var modelList : [DCRChemistAttachment] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRChemistAttachment.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE (Chemist_Visit_Id IS NOT NULL AND Chemist_Visit_Id > 0) AND Blob_Url = '' AND Uploaded_File_Name != '' AND Is_Success = -1 LIMIT \(maxConcurrentOperationCount)")
        })
        
        return modelList
    }
    
    func updateAttachmentBlobUrl(attachmentId: Int, blobUrl: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE Id = ?", arguments: [attachmentId])
            {
                rowValue.attachmentBlobUrl = blobUrl
                try! rowValue.update(db)
            }
        })
    }
    
    func updateLeaveAttachmentBlobUrl(attachmentId: Int, blobUrl: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRLeaveModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id = ?", arguments: [attachmentId])
            {
                rowValue.documentUrl = blobUrl
                try! rowValue.update(db)
            }
        })
    }
    
    func updateChemistAttachmentBlobUrl(attachmentId: Int, blobUrl: String)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ATTACHMENT) SET Blob_Url = '\(blobUrl)' WHERE DCR_Chemist_Attachment_Id = \(attachmentId)")
    }
    
    func updateAttachmentSuccessFlag(attachmentId: Int, isSuccess: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE Id = ?", arguments: [attachmentId])
            {
                rowValue.isSuccess = isSuccess
                try! rowValue.update(db)
            }
        })
    }
    
    func updateChemistAttachmentSuccessFlag(attachmentId: Int, isSuccess: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_ATTACHMENT) SET Is_Success = \(isSuccess) WHERE DCR_Chemist_Attachment_Id = \(attachmentId)")
    }
    
    func updateLeaveAttachmentSuccessFlag(attachmentId: Int, isSuccess: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_LEAVE_ATTACHMENT) SET Is_Success = \(isSuccess) WHERE Attachment_Id = \(attachmentId)")
    }
    
    func updateAttachmentDownloadStatus(attachmentId: Int, isDownloaded: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE Id = ?", arguments: [attachmentId])
            {
                rowValue.isFileDownloaded = isDownloaded
                try! rowValue.update(db)
            }
        })
    }
    
    func updateLeaveAttachmentDownloadStatus(attachmentId: Int, isDownloaded: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRLeaveModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id = ?", arguments: [attachmentId])
            {
                rowValue.isFileDownloaded = isDownloaded
                try! rowValue.update(db)
            }
        })
    }
    
    func getFailureAttachmentCount() -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Code != '' AND Blob_Url = '' AND Uploaded_File_Name != '' AND Is_Success = 0")!
        }
        
        return count
    }
    
    func getFailureLeaveAttachmentCount() -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id != '' AND Blob_Url = '' AND Uploaded_File_Name != '' AND Is_Success = 0")!
        }
        
        return count
    }
    
    func getFailureChemistAttachmentCount() -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE Chemist_Visit_Id > 0 AND Blob_Url = '' AND Uploaded_File_Name != '' AND Is_Success = 0")!
        }
        
        return count
    }
    
    func updateFailureAttachmentStatus()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) SET Is_Success = -1 WHERE DCR_Doctor_Visit_Code != '' AND Blob_Url = '' AND Is_Success = 0")
    }
    
    func getUploadableAttachments() -> [DCRAttachmentModel]
    {
        var modelList: [DCRAttachmentModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRAttachmentModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Code != '' AND Blob_Url = '' AND Uploaded_File_Name != ''")
        })
        
        return modelList
    }
    
    func getLeaveUploadableAttachments(dcrDate: String) -> [DCRLeaveModel]
    {
        var modelList: [DCRLeaveModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRLeaveModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id != '' AND Document_Url = '' AND Uploaded_File_Name != '' AND DCR_Actual_Date = ?", arguments : [dcrDate])
        })
        
        return modelList
    }
    
    func getChemistUploadableAttachments() -> [DCRChemistAttachment]
    {
        var modelList: [DCRChemistAttachment] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRChemistAttachment.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE (Chemist_Visit_Id IS NOT NULL AND Chemist_Visit_Id > 0) AND Blob_Url = '' AND Uploaded_File_Name != ''")
        })
        
        return modelList
    }
    
    //MARK: - Error Log
    func getErrorLogCount() -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = (try Int.fetchOne(db, "SELECT COUNT(1) FROM \(TRAN_ERROR_LOG)"))!
        }
        
        return count
    }
    
    func getErrorLogs() -> [ErrorLogModel]
    {
        var errorList: [ErrorLogModel] = []
        
        try? dbPool.read ({ db in
            errorList = try ErrorLogModel.fetchAll(db, "SELECT * FROM \(TRAN_ERROR_LOG)")
        })
        
        return errorList
    }
    
    func insertErrorLog(objErrorLog: ErrorLogModel)
    {
        try? dbPool.write({ db in
            try objErrorLog.insert(db)
        })
    }
    
    func deleteErrorLog()
    {
        executeQuery(query: "DELETE FROM \(TRAN_ERROR_LOG)")
    }
    
    func getUploadableAttachments(dcrId: Int) -> [DCRAttachmentModel]
    {
        var modelList: [DCRAttachmentModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRAttachmentModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = ?", arguments: [dcrId])
        })
        
        return modelList
    }
    
    func updateAttachmentName(attachmentId: Int, fileName: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRAttachmentModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE Id = ?", arguments: [attachmentId])
            {
                rowValue.attachmentName = fileName
                try! rowValue.update(db)
            }
        })
    }
    
    func updateLeaveAttachmentName(attachmentId: Int, fileName: String)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRLeaveModel.fetchOne(db, "SELECT * FROM \(TRAN_DCR_LEAVE_ATTACHMENT) WHERE Attachment_Id = ?", arguments: [attachmentId])
            {
                rowValue.attachmentName = fileName
                try! rowValue.update(db)
            }
        })
    }
    
    
    func deleteWebAttachments()
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Code != '' AND Blob_Url != ''")
    }
    
    func getAttachmentsForDCRId(dcrId: Int) -> [DCRAttachmentModel]
    {
        var modelList: [DCRAttachmentModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRAttachmentModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Id = \(dcrId) AND DCR_Doctor_Visit_Code != '' AND Blob_Url != ''")
        })
        
        return modelList
    }
    
    func getAttachmentsForDoctorVisitId(doctorVisitId: Int) -> [DCRAttachmentModel]
    {
        var modelList: [DCRAttachmentModel] = []
        
        try? dbPool.read ({ db in
            modelList = try DCRAttachmentModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) WHERE DCR_Doctor_Visit_Id = \(doctorVisitId)")
        })
        
        return modelList
    }
    
    //MARK:- Version Upgrade
    
    func getIncompleteVersionUpgrades() -> [VersionUpgradeModel]
    {
        var versionUpgradeList :  [VersionUpgradeModel] = []
        
        try? dbPool.read ({ db in
            versionUpgradeList = try VersionUpgradeModel.fetchAll(db, "SELECT * FROM \(MST_VERSION_UPGRADE_INFO) WHERE Is_Version_Update_Completed = ?", arguments : [0])
        })
        
        return versionUpgradeList
    }
    
    func insertVersionUpgradeInfo(objVersionUpgradeModel: VersionUpgradeModel)
    {
        try? dbPool.write({ db in
            try objVersionUpgradeModel.insert(db)
        })
    }
    
    //    func updateVersionUpgradeStatus(status: Int, versionNumber: String)
    //    {
    //        executeQuery(query: "UPDATE \(MST_VERSION_UPGRADE_INFO) SET Is_Version_Update_Completed = \(status) WHERE Version_Number = '\(versionNumber)'")
    //    }
    
    func updateVersionUpgradeStatusForVersionNumber(status: Int, versionNumber: String)
    {
        executeQuery(query: "UPDATE \(MST_VERSION_UPGRADE_INFO) SET Is_Version_Update_Completed = \(status) WHERE Version_Number = '\(versionNumber)'")
    }
    
    func updateAllVersionUpgrade(status: Int)
    {
        executeQuery(query: "UPDATE \(MST_VERSION_UPGRADE_INFO) SET Is_Version_Update_Completed = \(status)")
    }
    
    //MARK:- Validation
    func getDCRDoctorAccompanistIsNotAccompanied(dcrId : Int) -> [DCRAccompanistModel]?
    {
        var dcrDoctorAccompanistsList : [DCRAccompanistModel]?
        
        try? dbPool.read { db in
            dcrDoctorAccompanistsList = try DCRAccompanistModel.fetchAll(db, "SELECT \(TRAN_DCR_ACCOMPANIST).Acc_Region_Code,\(TRAN_DCR_ACCOMPANIST).Is_TP_Frozen,SUM(CASE WHEN \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied= 99 THEN 0 ELSE \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied END) + SUM(\(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Only_For_Doctor),Count(\(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code) FROM \(TRAN_DCR_ACCOMPANIST) INNER JOIN \(TRAN_DCR_DOCTOR_ACCOMPANIST) ON \(TRAN_DCR_ACCOMPANIST).Acc_Region_Code = \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code AND \(TRAN_DCR_ACCOMPANIST).DCR_Id = \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Id WHERE  \(TRAN_DCR_ACCOMPANIST).DCR_Id = ? GROUP BY \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code HAVING SUM(CASE WHEN \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied=99 THEN 0 ELSE \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied END )+ SUM(\(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Only_For_Doctor) = 0",arguments:[dcrId])
        }
        return dcrDoctorAccompanistsList
    }
    
    func getDCRChemistAccompanistIsNotAccompanied(dcrId : Int) -> [DCRAccompanistModel]?
    {
        var dcrDoctorAccompanistsList : [DCRAccompanistModel]?
        
        try? dbPool.read { db in
            dcrDoctorAccompanistsList = try DCRAccompanistModel.fetchAll(db, "SELECT \(TRAN_DCR_ACCOMPANIST).Acc_Region_Code,\(TRAN_DCR_ACCOMPANIST).Is_TP_Frozen,SUM(CASE WHEN \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call= 99 THEN 0 ELSE \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call END) + SUM(\(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Only_For_Chemist),Count(\(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_Region_Code) FROM \(TRAN_DCR_ACCOMPANIST) INNER JOIN \(TRAN_DCR_CHEMIST_ACCOMPANIST) ON \(TRAN_DCR_ACCOMPANIST).Acc_Region_Code = \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_Region_Code AND \(TRAN_DCR_ACCOMPANIST).DCR_Id = \(TRAN_DCR_CHEMIST_ACCOMPANIST).DCR_Id WHERE  \(TRAN_DCR_ACCOMPANIST).DCR_Id = ? GROUP BY \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_Region_Code HAVING SUM(CASE WHEN \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call=99 THEN 0 ELSE \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call END )+ SUM(\(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Only_For_Chemist) = 0",arguments:[dcrId])
        }
        return dcrDoctorAccompanistsList
    }
    
    func getDCRDoctorAccompanistsByAccompaniedStatus(dcrId : Int,doctorVisitId:Int,accompaniedStatus : Int) -> [DCRDoctorAccompanist]
    {
        var dcrDoctorAccompanistList : [DCRDoctorAccompanist] = []
        
        try? dbPool.read { db in
            dcrDoctorAccompanistList = try DCRDoctorAccompanist.fetchAll(db,"SELECT  \(TRAN_DCR_DOCTOR_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST)  INNER JOIN \(MST_ACCOMPANIST) ON \(MST_ACCOMPANIST).Region_Code = \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code AND \(MST_ACCOMPANIST).User_Code = \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_User_Code WHERE \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Id= ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Doctor_Visit_Id= ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied = ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Only_For_Doctor = ?",arguments :[dcrId,doctorVisitId,accompaniedStatus,0])
        }
        return dcrDoctorAccompanistList
    }
    
    func getDCRChemistAccompanistsByAccompaniedStatus(dcrId : Int,chemistVisitId:Int,accompaniedStatus : Int) -> [DCRChemistAccompanist]
    {
        var dcrDoctorAccompanistList : [DCRChemistAccompanist] = []
        
        try? dbPool.read { db in
            dcrDoctorAccompanistList = try DCRChemistAccompanist.fetchAll(db,"SELECT  \(TRAN_DCR_CHEMIST_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST)  INNER JOIN \(MST_ACCOMPANIST) ON \(MST_ACCOMPANIST).Region_Code = \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_Region_Code AND \(MST_ACCOMPANIST).User_Code = \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_User_Code WHERE \(TRAN_DCR_CHEMIST_ACCOMPANIST).DCR_Id= ? AND \(TRAN_DCR_CHEMIST_ACCOMPANIST).DCR_Chemist_Day_Visit_Id= ? AND \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call = ? AND \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Only_For_Chemist = ?",arguments :[dcrId,chemistVisitId,accompaniedStatus,0])
        }
        return dcrDoctorAccompanistList
    }
    
    func getDCRInvalidDoctorAccompanistsByDCRId(dcrId : Int,accompaniedStatus : Int) -> [DCRDoctorAccompanist]
    {
        var dcrDoctorAccompanistList : [DCRDoctorAccompanist] = []
        
        try? dbPool.read { db in
            dcrDoctorAccompanistList = try DCRDoctorAccompanist.fetchAll(db,"SELECT  \(TRAN_DCR_DOCTOR_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_DOCTOR_ACCOMPANIST)  INNER JOIN \(MST_ACCOMPANIST) ON \(MST_ACCOMPANIST).Region_Code = \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_Region_Code AND \(MST_ACCOMPANIST).User_Code = \(TRAN_DCR_DOCTOR_ACCOMPANIST).Acc_User_Code WHERE \(TRAN_DCR_DOCTOR_ACCOMPANIST).DCR_Id= ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Accompanied = ? AND \(TRAN_DCR_DOCTOR_ACCOMPANIST).Is_Only_For_Doctor = ?",arguments :[dcrId,accompaniedStatus,0])
        }
        return dcrDoctorAccompanistList
    }
    
    func getDCRInvalidChemistAccompanistsByDCRId(dcrId : Int,accompaniedStatus : Int) -> [DCRChemistAccompanist]
    {
        var dcrDoctorAccompanistList : [DCRChemistAccompanist] = []
        
        try? dbPool.read { db in
            dcrDoctorAccompanistList = try DCRChemistAccompanist.fetchAll(db,"SELECT  \(TRAN_DCR_CHEMIST_ACCOMPANIST).*,\(MST_ACCOMPANIST).Employee_name,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST)  INNER JOIN \(MST_ACCOMPANIST) ON \(MST_ACCOMPANIST).Region_Code = \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_Region_Code AND \(MST_ACCOMPANIST).User_Code = \(TRAN_DCR_CHEMIST_ACCOMPANIST).Acc_User_Code WHERE \(TRAN_DCR_CHEMIST_ACCOMPANIST).DCR_Id= ? AND \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Accompanied_Call = ? AND \(TRAN_DCR_CHEMIST_ACCOMPANIST).Is_Only_For_Chemist = ?",arguments :[dcrId,accompaniedStatus,0])
        }
        return dcrDoctorAccompanistList
    }
    
    //MARK:- POB Details
    
    func insertDCRDoctorVisitOrderHeaderDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRDoctorVisitPOBHeaderModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertPOBHeaderDetails(pobObj: DCRDoctorVisitPOBHeaderModel) -> Int
    {
        var orderEntryID: Int = 0
        
        try? dbPool.write({ db in
            try pobObj.insert(db)
            orderEntryID = Int(db.lastInsertedRowID)
        })
        
        return orderEntryID
    }
    
    func insertDetailedProductsPOB(array: [DCRDoctorVisitPOBDetailsModel])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    func insertDCRDoctorVisitOrderDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRDoctorVisitPOBDetailsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitOrderRemarksDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRDoctorVisitPOBRemarksModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func updateDCRDoctorVisitOrderHeaderDetails(stockiestCode: String,stockiestRegionCode: String,orderEntryId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET Stockiest_Code = '\(stockiestCode)', Stockiest_Region_Code = '\(stockiestRegionCode)' WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func updateOrderHeaderDetailsOrderStatus(orderEntryId: Int,orderstatus: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET Order_Status = \(orderstatus) WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func updateDueDateInPOBHeader(dueDate: String,orderEntryId: Int)
    {
        //date string to be sent in yyyy/dd/mm
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) SET Order_Due_Date = '\(dueDate)' WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func updatePOBRemarks(orderEntryId: Int,remarks: String)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) SET Remarks = '\(remarks)' WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func deletePOBDetails(orderEntryId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func deletePOBDetailsForOrderDetailId(orderEntryId: Int,orderDetailId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE Order_Entry_Id = \(orderEntryId) AND Order_Detail_Id = \(orderDetailId)")
    }
    
    func deletePOBRemarks(orderEntryId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func deletePOBHeader(orderEntryId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE Order_Entry_Id = \(orderEntryId)")
    }
    
    func getPOBHeaderForDCRId(dcrId: Int,visitId: Int,customerEntityType: String) -> [DCRDoctorVisitPOBHeaderModel]
    {
        var pobHeaderList : [DCRDoctorVisitPOBHeaderModel] = []
        
        try? dbPool.read { db in
            pobHeaderList = try DCRDoctorVisitPOBHeaderModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE DCR_Id = ? AND Visit_Id = ? AND Customer_Entity_Type = ? AND Order_Status != 0",arguments :[dcrId,visitId,customerEntityType])
        }
        
        return pobHeaderList
    }
    
    func getPOBDetailsBasedOnCustomer(dcrId: Int, visitId: Int,customerEntityType: String,orderEntryId: Int) -> [DCRDoctorVisitPOBDetailsModel]?
    {
        var pobOrderList : [DCRDoctorVisitPOBDetailsModel] = []
        
        try? dbPool.read { db in
            pobOrderList = try DCRDoctorVisitPOBDetailsModel.fetchAll(db,"SELECT \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS).* FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) INNER JOIN \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) ON \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER). Order_Entry_Id = \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS).Order_Entry_Id WHERE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER).DCR_Id = ? AND  \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER).Visit_Id = ? AND \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER).Customer_Entity_Type = ? AND \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER).Order_Entry_Id = ?",arguments :[dcrId,visitId,customerEntityType,orderEntryId])
        }
        return pobOrderList
    }
    
    func getPOBHeaderForOrderEntryId(orderEntryId: Int) -> DCRDoctorVisitPOBHeaderModel?
    {
        var pobHeaderList : DCRDoctorVisitPOBHeaderModel?
        
        try? dbPool.read { db in
            pobHeaderList = try DCRDoctorVisitPOBHeaderModel.fetchOne(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) WHERE Order_Entry_Id = ? AND Order_Status != 0",arguments :[orderEntryId])
        }
        return pobHeaderList
    }
    
    func getPOBDetailsForOrderEntryId(orderEntryId: Int) -> [DCRDoctorVisitPOBDetailsModel]
    {
        var pobDetailList : [DCRDoctorVisitPOBDetailsModel] = []
        
        try? dbPool.read { db in
            pobDetailList = try DCRDoctorVisitPOBDetailsModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) WHERE Order_Entry_Id = ? ",arguments :[orderEntryId])
        }
        return pobDetailList
    }
    
    func getPOBRemarks(orderEntryId: Int) -> DCRDoctorVisitPOBRemarksModel?
    {
        var remarksList: DCRDoctorVisitPOBRemarksModel?
        
        try? dbPool.read { db in
            remarksList = try DCRDoctorVisitPOBRemarksModel.fetchOne(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) WHERE Order_Entry_Id = ? ",arguments :[orderEntryId])
        }
        return remarksList
    }
    
    func getAccompanistDetailsByRegionCode(regionCode: String) -> AccompanistModel?
    {
        var objAccomapnistMaster : AccompanistModel?
        
        try? dbPool.read { db in
            objAccomapnistMaster = try AccompanistModel.fetchOne(db, "SELECT * FROM \(MST_ACCOMPANIST) WHERE Region_Code = ? ORDER BY LOWER(Employee_name) ASC LIMIT 1", arguments: [regionCode])
        }
        
        return objAccomapnistMaster
    }
    
    //MARK:- Edetailing
    
    func insertAssetHeaderDetails(array : NSArray)
    {
        //        try? dbPool.writeInTransaction { db in
        //            for data in array
        //            {
        //                try AssetHeader(dict: data as! NSDictionary).insert(db)
        //            }
        //            return .commit
        //        }
        
        try? dbPool.write { db in
            for data in array
            {
                try AssetHeader(dict: data as! NSDictionary).insert(db)
            }
        }
    }
    
    func insertAssetDownloaded(dict : NSDictionary)
    {
        try? dbPool.writeInTransaction { db in
            try AssetDownload(dict:dict).insert(db)
            return .commit
        }
    }
    
    func insertAssetTagDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try AssetTag(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAssetPartDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try AssetParts(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDetailedProductDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try AssestProductMappingModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAssetAnalyticsDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try AssetAnalyticsDetail(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAssetAnalytics(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try AssetAnalyticsDetail(dict: dict).insert(db)
        })
    }
    
    func getMasterAssetList() -> [AssetHeader]
    {
        var assetsList : [AssetHeader] = []
        
        try? dbPool.read { db in
            
            assetsList = try AssetHeader.fetchAll(db,"SELECT \(MST_ASSET_HEADER).*,\(TRAN_DOWNLOADED_ASSET).DA_Offline_Url FROM \(MST_ASSET_HEADER) LEFT JOIN \(TRAN_DOWNLOADED_ASSET) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_DOWNLOADED_ASSET).DA_Code WHERE DATE(\(MST_ASSET_HEADER).Effective_From) <= date('now','localtime') AND DATE(\(MST_ASSET_HEADER).Effective_To) >= date('now','localtime') ORDER BY Asset_Id ASC")
        }
        return assetsList
    }
    
    func getAssetsPartsListByDaCode(daCode : String) -> [AssetParts]
    {
        var assetsPartsList : [AssetParts] = []
        
        try? dbPool.read { db in
            assetsPartsList = try AssetParts.fetchAll(db,"SELECT * FROM \(MST_ASSET_PARTS) WHERE DA_Code IN(\(daCode))")
        }
        return assetsPartsList
    }
    
    func getAssetsTags() -> [AssetTag]
    {
        var assetTagList : [AssetTag] = []
        
        try? dbPool.read { db in
            assetTagList = try AssetTag.fetchAll(db,"SELECT * FROM \(MST_ASSET_TAG_DETAILS)")
        }
        
        return assetTagList
    }
    
    func getAssetPartsList() -> [AssetParts]
    {
        var assetsPartList : [AssetParts] = []
        
        try? dbPool.read { db in
            assetsPartList = try AssetParts.fetchAll(db,"SELECT * FROM \(MST_ASSET_PARTS)")
        }
        return assetsPartList
    }
    
    func getAssetsByDownloadStatus(downloadStatus : Int) -> [AssetHeader]
    {
        var assetsList : [AssetHeader]  = []
        try? dbPool.read {  db in
            assetsList = try AssetHeader.fetchAll(db,"SELECT * FROM \(MST_ASSET_HEADER) WHERE Is_Downloaded = \(downloadStatus) LIMIT \(maxAssetsConcuurentOperationCount)")
        }
        return assetsList
    }
    
    func getAssetsByInProgressStatus(downloadStatus : Int) -> [AssetHeader]
    {
        var assetsList : [AssetHeader]  = []
        try? dbPool.read {  db in
            assetsList = try AssetHeader.fetchAll(db,"SELECT * FROM \(MST_ASSET_HEADER) WHERE Is_Downloaded = \(downloadStatus)")
        }
        return assetsList
    }
    
    func getAssetsByDacode(daCode : Int) -> AssetHeader
    {
        var assetObj : AssetHeader!
        try? dbPool.read {  db in
            assetObj = try AssetHeader.fetchOne(db,"SELECT * FROM \(MST_ASSET_HEADER) WHERE DA_Code = \(daCode)")
        }
        return assetObj
    }
    
    func updateDownloadStatus(downloadStatus : Int,fileName : String,daCode : Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try AssetHeader.fetchOne(db, "SELECT * FROM \(MST_ASSET_HEADER) WHERE DA_Code = ?", arguments: [daCode])
            {
                rowValue.isDownloaded = downloadStatus
                try! rowValue.update(db)
            }
        })
    }
    
    func getDownloadedHTMLAssets() -> [AssetDownload]
    {
        var modelList: [AssetDownload] = []
        
        try? dbPool.read {  db in
            modelList = try AssetDownload.fetchAll(db,"SELECT * FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Type = \(Constants.DocTypeIds.zip)")
        }
        
        return modelList
    }
    
    func getHTMLAssetsinMaster() -> [AssetHeader]
    {
        var modelList: [AssetHeader] = []
        
        try? dbPool.read {  db in
            modelList = try AssetHeader.fetchAll(db,"SELECT * FROM \(MST_ASSET_HEADER) WHERE Doc_Type = \(Constants.DocTypeIds.zip)")
        }
        
        return modelList
    }
    
    func updateAssetDownloaded(daCode : Int,offlineUrl : String, docType: Int, isDownloaded: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try AssetDownload.fetchOne(db, "SELECT * FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Code = ? AND DA_Type = ?", arguments: [daCode, docType])
            {
                rowValue.localUrl = offlineUrl
                rowValue.isDownloaded = isDownloaded
                try! rowValue.update(db)
            }
        })
    }
    
    func checkDownloadedAssetsForDACode(daCode: Int) -> [AssetDownload]
    {
        var modelList: [AssetDownload] = []
        
        try? dbPool.read {  db in
            modelList = try AssetDownload.fetchAll(db,"SELECT * FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Code = \(daCode)")
        }
        
        return modelList
    }
    
    func insertAssetAnalytics(assetObj : AssetAnalyticsDetail) -> Int
    {
        var id : Int = 0
        try? dbPool.write({ db in
            try assetObj.insert(db)
            id = Int(db.lastInsertedRowID)
        })
        return id
    }
    
    func getAssetAnalyticsByAnalyticsId(analyticsId : Int) -> AssetAnalyticsDetail
    {
        var assetAnalyticsObj  : AssetAnalyticsDetail!
        
        try? dbPool.read { db in
            assetAnalyticsObj = try AssetAnalyticsDetail.fetchOne(db , "SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Asset_Id = \(analyticsId)")
        }
        return assetAnalyticsObj
    }
    
    func getAssetSessionIdByDaCode(daCode : Int, customerDetailedId: Int, customerCode: String, customeregionCode: String, detailingDate: String) -> Int?
    {
        var sessionId : Int?
        let query = "SELECT MAX(Session_Id) FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(detailingDate)') AND DA_Code = \(daCode) AND Customer_Detailed_Id = \(customerDetailedId) AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customeregionCode)'"
        print(query)
        try? dbPool.read { db in
            sessionId = try Int.fetchOne(db, query)
        }
        return sessionId
    }
    
    func getMaxCustomerDetailedId() -> Int?
    {
        var detailedId : Int?
        try? dbPool.read { db in
            detailedId = try Int.fetchOne(db, "SELECT MAX(Customer_Detailed_Id) FROM \(TRAN_ASSET_ANALYTICS_DETAILS)")
        }
        return detailedId
    }
    
    func getMaxCustomerDetailedId(customerCode: String, customerRegionCode: String, detailingDate: String) -> Int?
    {
        var detailedId : Int?
        try? dbPool.read { db in
            detailedId = (try Int.fetchOne(db, "SELECT MAX(Customer_Detailed_Id) FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND DATE(Detailed_DateTime) = DATE('\(detailingDate)')", arguments: [customerCode,customerRegionCode]))
        }
        return detailedId
    }
    
    func updateAnalyticsByAnalyticsId(analyticsId : Int,analyticsObj :AssetAnalyticsDetail)
    {
        try? dbPool.write({ db in
            if let rowValue = try  AssetAnalyticsDetail.fetchOne(db, "SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Asset_Id = ?", arguments: [analyticsId])
            {
                rowValue.Detailed_EndTime = analyticsObj.Detailed_EndTime
                rowValue.Player_EndTime = analyticsObj.Player_EndTime
                rowValue.Played_Time_Duration = analyticsObj.Played_Time_Duration
                try! rowValue.update(db)
            }
        })
        
    }
    
    func deleteAssetByDownload()
    {
        executeQuery(query: "DELETE FROM \(MST_ASSET_HEADER) WHERE isDownloaded = 0")
    }
    
    func getAssetsCustomerByDCRDate(dcrDate : String) -> [AssetAnalyticsDetail]?
    {
        var assetAnalyticsList : [AssetAnalyticsDetail]?
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT Distinct Customer_Code, Customer_Name, Customer_Speciality_Name,Customer_Category_Name,Customer_Category_Code,Customer_Speciality_Code,Customer_Region_Code, Sur_Name, Local_Area, Latitude, Longitude, MDL_Number, Detailed_StartTime, Punch_Start_Time, Punch_End_Time, Punch_Offset, Punch_TimeZone, Punch_UTC_DateTime, Punch_Status FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Is_Preview = 0")
        }
        return assetAnalyticsList
    }
    
    func getAssetAnayticsByDate(dcrDate : String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Is_Preview = 0 ORDER BY Detailed_StartTime ASC")
        }
        return assetAnalyticsList
    }
    
    func getAssestAnalyticsByCustomer(dcrDate: String, customerCode: String, customeRegionCode: String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customeRegionCode)' AND Is_Preview = 0 ORDER BY Detailed_StartTime ASC")
        }
        return assetAnalyticsList
    }
    func updatepunchendtime(Customercode: String, regioncode:String, time:String)
    {
         executeQuery(query: "UPDATE \(TRAN_ASSET_ANALYTICS_DETAILS) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE DATE(Detailed_DateTime) = DATE('\(getCurrentDate())') AND Customer_Code = '\(Customercode)' AND Customer_Region_Code = '\(regioncode)'")
    }
    func getAssestAnalyticscheckpunchendtime( customerCode: String, customeRegionCode: String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(customeRegionCode)' AND Punch_End_Time = ''")
        }
        return assetAnalyticsList
    }
    func getAssestAnalyticscheckpunchout(dcrDate: String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Punch_End_Time = ''")
        }
        return assetAnalyticsList
    }
  
    func getPunchtimevalidationforselectedcustomers(dcrDate: Int, customerCode: String, customeRegionCode: String) -> [DCRDoctorVisitModel]
    {
        var assetAnalyticsList : [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try DCRDoctorVisitModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = \(dcrDate) AND Doctor_Code = '\(customerCode)' AND Doctor_Region_Code = '\(customeRegionCode)'")
        }
        return assetAnalyticsList
    }
    
    
    func getLocalAreaFromAssetAnaytics(dcrDate : String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Is_Preview = 0 AND LENGTH(Local_Area) > 0 ORDER BY Detailed_StartTime ASC")
        }
        return assetAnalyticsList
    }
    
    func checkDoctorExistsAnalyticsDetail(customerCode: String, regionCode: String, dcrDate: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' AND DATE(Detailed_DateTime) = DATE('\(dcrDate)')")!
        }
        
        return count
    }
    
    func deleteEDetailedAnalyticsForDoctor(customerCode: String, regionCode: String, dcrDate: String)
    {
        let query = "DELETE FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' AND DATE(Detailed_DateTime) = DATE('\(dcrDate)')"
        print(query)
        
        executeQuery(query: query)
    }
    
    func insertEDetailDeleteAudit(objDeleteAudit: EDetailDoctorDeleteAudit)
    {
        try? dbPool.writeInTransaction { db in
            try objDeleteAudit.insert(db)
            return .commit
        }
    }
    
    func getEDetailedSyncedAnalyticsCount(customerCode: String, regionCode: String, dcrDate: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' AND DATE(Detailed_DateTime) = DATE('\(dcrDate)') AND Is_Synced = 1")!
        }
        
        return count
    }
    
    func getDCRDoctorDigitalAssets(dcrDate : String,customerCode : String,regionCode: String) -> [AssetAnalyticsDetail]?
    {
        var assetAnalyticsList : [AssetAnalyticsDetail]?
        let querry = "SELECT Customer_Code, Customer_Name, DA_Type, \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code, SUM(Played_Time_Duration) AS Total_Played_Time_Duration, Count(\(TRAN_ASSET_ANALYTICS_DETAILS).Asset_Id) AS Total_Viewed_Pages,\(MST_ASSET_HEADER).DA_Name FROM \(TRAN_ASSET_ANALYTICS_DETAILS) INNER JOIN \(MST_ASSET_HEADER) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') And Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' GROUP BY Customer_Code,Customer_Region_Code,\(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code"
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db,"SELECT Customer_Code, Customer_Name, DA_Type, \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code, SUM(Played_Time_Duration) AS Total_Played_Time_Duration, Count(\(TRAN_ASSET_ANALYTICS_DETAILS).Asset_Id) AS Total_Viewed_Pages,\(MST_ASSET_HEADER).DA_Name FROM \(TRAN_ASSET_ANALYTICS_DETAILS) INNER JOIN \(MST_ASSET_HEADER) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') And Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' GROUP BY Customer_Code,Customer_Region_Code,\(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code")
        }
        return assetAnalyticsList
    }
    
    func getTotalUniquePagesCount(dcrDate : String,customerCode : String,regionCode : String) -> [AssetAnalyticsDetail]
    {
        var assetAnalyticsList : [AssetAnalyticsDetail] = []
        try? dbPool.read { db in
            assetAnalyticsList = try AssetAnalyticsDetail.fetchAll(db ,"SELECT COUNT(*) AS Total_Unique_Pages_Count , DA_Code FROM  (SELECT Customer_Code, Customer_Name, \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code, DATE(Detailed_DateTime) AS Detailed_Time, Part_Id, Count(\(TRAN_ASSET_ANALYTICS_DETAILS).Asset_Id) AS Total_Viewed_Pages FROM \(TRAN_ASSET_ANALYTICS_DETAILS) INNER JOIN \(MST_ASSET_HEADER) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code WHERE DATE(Detailed_DateTime) = DATE('\(dcrDate)') And Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)'GROUP BY Customer_Code, Customer_Region_Code, DATE(Detailed_DateTime),\(TRAN_ASSET_ANALYTICS_DETAILS).DA_Code, Part_Id) GROUP BY da_code")
        }
        return assetAnalyticsList
    }
    
    func getNotExistsDaCode() -> [AssetDownload]
    {
        var daCodeList : [AssetDownload] = []
        try? dbPool.read { db in
            daCodeList = try AssetDownload.fetchAll(db, "SELECT DA_Code FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Code NOT IN (SELECT DA_Code FROM \(MST_ASSET_HEADER))")
        }
        return daCodeList
    }
    
    func deleteAssetsDownlodedByDacode(daCodes : String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Code IN (\(daCodes)) ")
    }
    
    func deleteAssetDownloaded(daCode: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DOWNLOADED_ASSET) WHERE DA_Code = \(daCode)")
    }
    
    func getDoctorVisitUniqueRegionCode(dcrId: Int) -> [DCRDoctorVisitModel]
    {
        var doctorVisitList: [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            doctorVisitList = try DCRDoctorVisitModel.fetchAll(db, "SELECT DISTINCT Doctor_Region_Code FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = \(dcrId)")
        }
        
        return doctorVisitList
    }
    
    func checkRegionCodeExistsDCRAccompanist(regionCode: String, dcrId: Int) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_ACCOMPANIST) WHERE Acc_Region_Code = ? AND DCR_Id = ?", arguments: [regionCode, dcrId])!
        }
        
        return count
    }
    
    func insertMCDoctorProductMapping(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCDoctorProductMappingModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDoctorProductMapping(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DoctorProductMappingModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCustomerAddress(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerAddressModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertHospitalAccountNumberData(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CustomerHospitalInfoModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getAssetsMappedToDoctors(doctorCode: String, regionCode: String) -> [AssestProductMappingModel]
    {
        var assetsList: [AssestProductMappingModel] = []
        
        try? dbPool.read { db in
            assetsList = try AssestProductMappingModel.fetchAll(db, "SELECT APM.* FROM \(TRAN_ED_ASSET_PRODUCT_MAPPING) APM INNER JOIN \(MST_ASSET_HEADER) AH ON APM.DA_Code = AH.DA_Code INNER JOIN \(MST_DOCTOR_PRODUCT_MAPPING) DPM ON APM.Product_Code = DPM.Product_Code WHERE DPM.Customer_Code = ? AND DPM.Customer_Region_Code = ? ORDER BY DPM.Priority_Order ASC", arguments: [doctorCode, regionCode])
        }
        
        return assetsList
    }
    
    func getAssetsMappedToTargets(doctorCode: String, regionCode: String) -> [AssestProductMappingModel]
    {
        var assetsList: [AssestProductMappingModel] = []
        
        try? dbPool.read { db in
            assetsList = try AssestProductMappingModel.fetchAll(db, "SELECT APM.* FROM tran_ED_Asset_Product_Mapping APM INNER JOIN mst_Asset_Header AH ON APM.DA_Code = AH.DA_Code INNER JOIN mst_Doctor_Product_Mapping DPM ON APM.Product_Code = DPM.Product_Code WHERE DPM.Customer_Code = ? AND DPM.Customer_Region_Code = ? AND Ref_Type = ? ORDER BY DPM.Priority_Order ASC", arguments: [doctorCode, regionCode, Constants.Doctor_Product_Mapping_Ref_Types.TARGET_MAPPING])
        }
        
        return assetsList
    }
    
    func getProductsMappedToAssets(daCode: Int) -> [AssestProductMappingModel]
    {
        var assetsList: [AssestProductMappingModel] = []
        
        try? dbPool.read { db in
            assetsList = try AssestProductMappingModel.fetchAll(db, "SELECT APM.*,DP.Product_Name FROM \(TRAN_ED_ASSET_PRODUCT_MAPPING) APM INNER JOIN \(MST_DETAIL_PRODUCTS) DP ON APM.Product_Code = DP.Product_Code WHERE APM.DA_Code = ?", arguments: [daCode])
        }
        
        return assetsList
    }
    
    func deleteDayWiseAssetsDetailed(dcrDate: String, doctorCode: String, regionCode: String, daCode: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DAY_WISE_ASSETS_DETAILED) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrDate)') AND Customer_Code = '\(doctorCode)' AND Customer_Region_Code = '\(regionCode)' AND DA_Code = \(daCode)")
    }
    
    func insertEDetailedDoctorLocationInfo(objDoctorLocation: EDetailDoctorLocationInfoModel)
    {
        try? dbPool.writeInTransaction { db in
            try objDoctorLocation.insert(db)
            return .commit
        }
    }
    
    func getEDDoctorLocationCount(customerCode: String, customerRegionCode: String, dcrDate: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_ED_DOCTOR_LOCATION_INFO) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND DATE(DCR_Actual_Date) = DATE('\(dcrDate)')", arguments: [customerCode, customerRegionCode])!
        }
        
        return count
    }
    
    func getEDDoctorLocationData(dcrDate: String) -> [EDetailDoctorLocationInfoModel]
    {
        var doctorList: [EDetailDoctorLocationInfoModel] = []
        
        try? dbPool.read { db in
            doctorList = try EDetailDoctorLocationInfoModel.fetchAll(db, "SELECT * FROM \(TRAN_ED_DOCTOR_LOCATION_INFO) WHERE DATE(DCR_Actual_Date) = DATE('\(dcrDate)')")
        }
        
        return doctorList
    }
    
    //MARK:-Story
    
    func insertStoryHeaderDetails(array : NSArray)
    {
        //        try? dbPool.writeInTransaction { db in
        //            for data in array
        //            {
        //                try StoryHeader(dict: data as! NSDictionary).insert(db)
        //            }
        //            return .commit
        //        }
        
        try? dbPool.write { db in
            for data in array
            {
                try StoryHeader(dict: data as! NSDictionary).insert(db)
            }
        }
    }
    
    func insertStoryAssetDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try StoryAssets(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertStoryCategoryDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try StoryCategories(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    
    func insertStorySpecialitiesDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try StorySpecialities(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //    func insertMasterStoryAnalytics(array : NSArray)
    //    {
    //        try? dbPool.writeInTransaction { db in
    //            for data in array
    //            {
    //                try StoryAssetAnalytics(dict: data as! NSDictionary).insert(db)
    //            }
    //            return .commit
    //        }
    //    }
    
    func insertLocalStoryDetails(storyObj : StoryLocalHeader)
    {
        try? dbPool.write({ db in
            try storyObj.insert(db)
        })
    }
    
    func insertMasterLocalStoryAsset(assetObj : StoryLocalAssets)
    {
        try? dbPool.write({ db in
            try assetObj.insert(db)
        })
    }
    
    func insertMasterStoryAnalytics(analyticsObj :StoryAssetAnalytics)
    {
        try? dbPool.write({ db in
            try analyticsObj.insert(db)
        })
    }
    
    func insertMasterLocalAnalytics(localAnalyticsObj : StoryLocalAssetAnalytics)
    {
        try? dbPool.write({ db in
            try localAnalyticsObj.insert(db)
        })
    }
    
    
    
    func getMasterStoryIdByCustomerDetails(categoryCode : String,specialityCode : String) -> [StoryHeader]
    {
        var storyList : [StoryHeader] = []
        try? dbPool.read { db in
            storyList = try StoryHeader.fetchAll(db, "SELECT DISTINCT \(MST_MC_STORY_HEADER).* FROM \(MST_MC_STORY_HEADER) INNER JOIN \(MST_MC_STORY_CATEGORIES) ON \(MST_MC_STORY_CATEGORIES).Story_Id = \(MST_MC_STORY_HEADER).Story_Id INNER JOIN \(MST_MC_STORY_SPECIALITIES) ON  \(MST_MC_STORY_SPECIALITIES).Story_Id = \(MST_MC_STORY_HEADER).Story_Id WHERE  \(MST_MC_STORY_SPECIALITIES).Speciality_Code = '\(specialityCode)' AND \(MST_MC_STORY_CATEGORIES).Category_Code = '\(categoryCode)' AND DATE(\(MST_MC_STORY_HEADER).Effective_From) <= date('now','localtime') AND DATE(\(MST_MC_STORY_HEADER).Effective_To) >= date('now','localtime')")
        }
        
        return storyList
    }
    
    func getMasterStoryList() -> [StoryHeader]{
        
        var storyList : [StoryHeader] = []
        try? dbPool.read { db in
            storyList = try StoryHeader.fetchAll(db, "SELECT * FROM \(MST_MC_STORY_HEADER)  WHERE  DATE(\(MST_MC_STORY_HEADER).Effective_From) <= date('now','localtime') AND DATE(\(MST_MC_STORY_HEADER).Effective_To) >= date('now','localtime') ORDER BY Local_Story_Id ASC")
        }
        return storyList
    }
    
    func getStoryHeaderByStoryId(storyId : NSNumber) -> StoryHeader
    {
        var storyObj : StoryHeader!
        try? dbPool.read { db in
            storyObj = try StoryHeader.fetchOne(db, "SELECT * FROM \(MST_MC_STORY_HEADER) WHERE Story_Id = \(storyId)")
        }
        
        if storyObj == nil
        {
            storyObj = StoryHeader(dict: ["Story_Id" : -2 , "Story_Name" : "" ])
        }
        
        return storyObj
    }
    
    func getAssetsByStoryId(storyId : NSNumber) -> [AssetHeader]
    {
        var assetList : [AssetHeader] = []
        
        try? dbPool.read { db in
            assetList = try AssetHeader.fetchAll(db ,"SELECT \(MST_ASSET_HEADER).*,\(TRAN_DOWNLOADED_ASSET).DA_Offline_Url FROM \(MST_ASSET_HEADER) LEFT JOIN \(TRAN_DOWNLOADED_ASSET) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_DOWNLOADED_ASSET).DA_Code WHERE \(MST_ASSET_HEADER) .DA_Code  IN (SELECT \(MST_MC_STORY_ASSETS).DA_Code FROM \(MST_MC_STORY_ASSETS) WHERE \(MST_MC_STORY_ASSETS).Story_Id = \(storyId) ORDER BY \(MST_MC_STORY_ASSETS).Display_Order ) ")
        }
        return assetList
    }
    
    func getSpecialityCodeByStoryId(storyId : NSNumber) -> [String]
    {
        var specialities = [String]()
        
        try? dbPool.read { db in
            specialities = try String.fetchAll(db, "SELECT \(MST_SPECIALTIES).Speciality_Name from \(MST_SPECIALTIES) WHERE \(MST_SPECIALTIES).Speciality_Code IN (SELECT \(MST_MC_STORY_SPECIALITIES).Speciality_Code  FROM \(MST_MC_STORY_SPECIALITIES) WHERE Story_Id = \(storyId))")
        }
        return specialities
    }
    
    func getMandatoryStoryListIds(customerObj : CustomerMasterModel) -> [StoryHeader]
    {
        var storyIdList = [StoryHeader]()
        let categoryCode : String = customerObj.Category_Code!
        let specialistCode : String = customerObj.Speciality_Code
        let customerCode : String = customerObj.Customer_Code
        
        try? dbPool.read{db in
            
            storyIdList = try StoryHeader.fetchAll(db, "SELECT DISTINCT \(MST_MC_STORY_HEADER).* FROM \(MST_MC_STORY_HEADER) INNER JOIN \(MST_MC_STORY_CATEGORIES) ON \(MST_MC_STORY_HEADER).Story_Id = \(MST_MC_STORY_CATEGORIES).Story_Id INNER JOIN \(MST_MC_STORY_SPECIALITIES) ON \(MST_MC_STORY_HEADER).Story_Id = \(MST_MC_STORY_SPECIALITIES).Story_Id WHERE \(MST_MC_STORY_CATEGORIES).Category_Code = '\(categoryCode)' AND \(MST_MC_STORY_SPECIALITIES).Speciality_Code = '\(specialistCode)' AND DATE(\(MST_MC_STORY_HEADER).Effective_From) <= date('now','localtime') AND DATE(\(MST_MC_STORY_HEADER).Effective_To) >= date('now','localtime') AND \(MST_MC_STORY_HEADER).Is_Mandatory = 1 AND \(MST_MC_STORY_HEADER).Story_Id NOT IN ( SELECT Story_Id FROM  \(TRAN_MC_STORY_ASSET_LOG) WHERE Customer_Code = '\(customerCode)')" )
        }
        print(storyIdList, "storylist")
        
        return storyIdList
    }
    
    func clearTempList()
    {
        executeQuery(query: "DELETE FROM \(TBL_CUSTOMER_TEMP_SHOWLIST) WHERE Story_Id = -1")
    }
    
    //MARK:- Doctor visit - Asset listing
    func getDoctorVisitAssets(customerCode: String, dcrDate: Date) -> [AssetAnalytics]?
    {
        var modeList: [AssetAnalytics]?
        
        try? dbPool.read { db in
            modeList = try AssetAnalytics.fetchAll(db, "SELECT \(TRAN_ASSET_ANALYTICS_SUMMARY).*, \(MST_ASSET_HEADER).DA_Name, \(MST_ASSET_HEADER).Doc_Type FROM \(TRAN_ASSET_ANALYTICS_SUMMARY) INNER JOIN \(MST_ASSET_HEADER) ON \(TRAN_ASSET_ANALYTICS_SUMMARY).DA_Code = \(MST_ASSET_HEADER).DA_Code WHERE \(TRAN_ASSET_ANALYTICS_SUMMARY).Customer_Code = ? AND \(TRAN_ASSET_ANALYTICS_SUMMARY).Played_DateTime = ?", arguments: [customerCode, dcrDate])
        }
        
        return modeList
    }
    
    func checkDoctorVisitExists(dcrId: Int, customerCode: String, regionCode: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])!
        }
        
        return count
    }
    
    func getDoctorVisitId(dcrId: Int, customerCode: String, regionCode: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT DCR_Doctor_Visit_Id FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])!
        }
        
        return count
    }
    
    func getDoctorVisitDetailsByDoctorCode(dcrId: Int, customerCode: String, regionCode: String) -> DCRDoctorVisitModel?
    {
        var obj: DCRDoctorVisitModel?
        
        try? dbPool.read { db in
            obj = try DCRDoctorVisitModel.fetchOne(db, "SELECT DCR_Doctor_Visit_Id FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])
        }
        
        return obj
    }
    
    func geteDetailedDoctorList(dcrDate: Date) -> [AssetAnalytics]
    {
        var modelList : [AssetAnalytics] = []
        
        try? dbPool.read { db in
            modelList = try AssetAnalytics.fetchAll(db,"SELECT * FROM \(TRAN_ASSET_ANALYTICS_SUMMARY) WHERE Played_DateTime = ?", arguments: [dcrDate])
        }
        
        return modelList
    }
    
    //MARK:- Get AssetAnalytics
    func getAssetAnalytics() -> [AssetAnalyticsDetail]
    {
        var modelList : [AssetAnalyticsDetail] = []
        
        try? dbPool.read { db in
            modelList = try AssetAnalyticsDetail.fetchAll(db, "SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Is_Synced = 0")
        }
        
        return modelList
    }
    
    func updateAssetAnalytics(assetId: Int, isSynched: Int, synchedDatetime: Date)
    {
        try? dbPool.write({ db in
            if let rowValue = try AssetAnalyticsDetail.fetchOne(db, "SELECT * FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Asset_Id = ?", arguments: [assetId])
            {
                rowValue.Is_Synced = isSynched
                rowValue.Synced_DateTime = synchedDatetime
                try! rowValue.update(db)
            }
        })
    }
    
    func getDCRIdforDCRDate(dcrDate: Date) -> [DCRHeaderModel]
    {
        var modelList: [DCRHeaderModel] = []
        
        try? dbPool.read { db in
            modelList = try DCRHeaderModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_HEADER) WHERE DCR_Actual_Date = ? AND Flag = ?", arguments: [dcrDate, DCRFlag.fieldRcpa.rawValue])
        }
        
        return modelList
    }
    
    func checkCustomerForDCRIdCustomerCode(dcrId: Int, customerCode: String, regionCode: String) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])!
        }
        
        return count
    }
    
    func deleteAnalyticsByAssetId(assetId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Asset_Id = \(assetId)")
    }
    
    func deleteAnalyticsByDCRDate(dcrDate: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_ASSET_ANALYTICS_DETAILS) WHERE Detailed_DateTime = DATE('\(dcrDate)') AND Is_Synced = 1")
    }
    
    
    //MARK:- Customer Feedback
    
    
    func insertAssetFeedback(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try AssetFeedback(dict: dict).insert(db)
        })
    }
    
    func insertDoctorVisitFeedback(dict : NSDictionary)
    {
        try? dbPool.write({ db in
            try DoctorVisitFeedback(dict: dict).insert(db)
        })
    }
    
    func getDoctorVisitFeedBackForToday(customerObj : CustomerMasterModel) -> DoctorVisitFeedback{
        
        var doctorVisitFeedback  : DoctorVisitFeedback!
        let date = getCurrentDate()
        let customerCode = customerObj.Customer_Code!
        try? dbPool.read { db in
            doctorVisitFeedback = try DoctorVisitFeedback.fetchOne(db , "SELECT * FROM \(TBL_ED_DOCTOR_VISIT_FEEDBACK) WHERE Detailed_Date = '\(date)' AND Customer_Code = '\(customerCode)'")
        }
        if doctorVisitFeedback == nil{
            let dict = NSDictionary()
            doctorVisitFeedback = DoctorVisitFeedback(dict: dict)
        }
        
        return doctorVisitFeedback
    }
    
    func updateDoctorVisitFeedback(feedback : DoctorVisitFeedback){
        
        executeQuery(query: "UPDATE \(TBL_ED_DOCTOR_VISIT_FEEDBACK) SET Detailed_Date = '\(feedback.detailedDate!)',Visit_Rating = '\(feedback.visitRating!)',Visit_Feedback = '\(feedback.VisitFeedBack!)',Updated_Datetime = '\(feedback.updated_Date_Time!)', Is_Synced = \(feedback.is_Synced!)  WHERE Id = \(feedback.id!)")
    }
    
    func getDoctorVisitFeedback() -> [DoctorVisitFeedback]
    {
        var modelList : [DoctorVisitFeedback] = []
        
        try? dbPool.read { db in
            modelList = try DoctorVisitFeedback.fetchAll(db, "SELECT * FROM \(TBL_ED_DOCTOR_VISIT_FEEDBACK) WHERE Is_Synced = 0")
        }
        
        return modelList
    }
    
    
    func updateDoctorVisitFeedbackStatus(feedbackId: Int, isSynched: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DoctorVisitFeedback.fetchOne(db, "SELECT * FROM \(TBL_ED_DOCTOR_VISIT_FEEDBACK) WHERE Id = ?", arguments: [feedbackId])
            {
                rowValue.is_Synced = isSynched
                try! rowValue.update(db)
            }
        })
    }
    
    
    func getCustomerFeedback() -> [AssetFeedback]
    {
        var modelList : [AssetFeedback] = []
        
        try? dbPool.read { db in
            modelList = try AssetFeedback.fetchAll(db, "SELECT * FROM \(TBL_EL_CUSTOMER_DA_FEEDBACK) WHERE Is_Synced = 0")
        }
        
        return modelList
    }
    
    func updateCustomerFeedbackStatus(assetId: Int, isSynched: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try AssetFeedback.fetchOne(db, "SELECT * FROM \(TBL_EL_CUSTOMER_DA_FEEDBACK) WHERE Id = ?", arguments: [assetId])
            {
                rowValue.is_Synced = isSynched
                try! rowValue.update(db)
            }
        })
    }
    
    
    //MARK:- Edetailing showlist
    
    
    func insertCustomerShowList1(showListObj : AssetShowList)
    {
        
        try? dbPool.write({ db in
            try showListObj.insert(db)
        })
        
    }
    
    func getMaxAssetId() -> Int?
    {
        var count:Int?
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT MAX(Asset_Id) FROM \(MST_ASSET_HEADER)")
        }
        
        return count
    }
    
    func getMaxLocalStoryId() -> Int?
    {
        var count:Int?
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT MAX(Local_Story_Id) FROM \(MST_MC_STORY_HEADER)")
        }
        
        return count
    }
    
    func getMaxDisplayOrderForShowList() -> Int?
    {
        var count:Int?
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT MAX(Display_Order) FROM \(TBL_CUSTOMER_TEMP_SHOWLIST)")
        }
        
        return count
    }
    
    func updateTheDisplayIndexForShowList(showListObj : ShowListModel , displayIndex : Int){
        
        executeQuery(query: "UPDATE \(TBL_CUSTOMER_TEMP_SHOWLIST) SET Display_Order = \(displayIndex) WHERE Id = \(showListObj.id!) ")
    }
    
    
    func getCustomerShowList() -> [AssetShowList]
    {
        var showList: [AssetShowList] = []
        
        try? dbPool.read { db in
            showList = try AssetShowList.fetchAll(db, "SELECT * FROM \(TBL_CUSTOMER_TEMP_SHOWLIST)")
        }
        
        return showList
    }
    
    func getAssetShowList() -> [AssetShowList]
    {
        var modelList: [AssetShowList] = []
        
        try? dbPool.read { db in
            modelList = try AssetShowList.fetchAll(db ,"SELECT * FROM \(TBL_CUSTOMER_TEMP_SHOWLIST) ORDER BY Display_Order")
        }
        
        return modelList
    }
    
    func getAssetsByDacodeWithOfflineUrl(daCode : Int) -> AssetHeader?
    {
        var assetObj : AssetHeader?
        try? dbPool.read {  db in
            assetObj = try AssetHeader.fetchOne(db, "SELECT \(MST_ASSET_HEADER).*, \(TRAN_DOWNLOADED_ASSET).DA_Offline_Url FROM \(MST_ASSET_HEADER) LEFT JOIN \(TRAN_DOWNLOADED_ASSET) ON \(MST_ASSET_HEADER).DA_Code = \(TRAN_DOWNLOADED_ASSET).DA_Code WHERE \(MST_ASSET_HEADER).DA_Code = \(daCode)")
        }
        
        return assetObj
    }
    
    func removeAssetFromShowListbyDaCode(daCode : Int){
        
        executeQuery(query: "DELETE FROM \(TBL_CUSTOMER_TEMP_SHOWLIST) WHERE DA_Code IN(\(daCode))")
    }
    
    //MARK:- TP Refresh
    func deleteTourPlannerData(startDate: String, endDate: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_TP_PRODUCT) WHERE TP_Entry_Id IN (SELECT TP_Entry_Id FROM tran_TP_Header WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_DOCTOR) WHERE TP_Entry_Id IN (SELECT TP_Entry_Id FROM tran_TP_Header WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_SFC) WHERE TP_Entry_Id IN (SELECT TP_Entry_Id FROM tran_TP_Header WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_ACCOMPANIST) WHERE TP_Entry_Id IN (SELECT TP_Entry_Id FROM tran_TP_Header WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)'))")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_HEADER) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)')")
        
        executeQuery(query: "DELETE FROM \(TRAN_TP_UNFREEZE_DATES) WHERE DATE(TP_Date) >= DATE('\(startDate)') AND DATE(TP_Date) <= DATE('\(endDate)')")
    }
    
    func removeAssetFromShowListByStoryId(storyId : NSNumber){
        
        executeQuery(query: "DELETE FROM \(TBL_CUSTOMER_TEMP_SHOWLIST) WHERE Story_Id IN(\(storyId))")
    }
    
    
    func getAllTPHeader() -> [TourPlannerHeader]
    {
        var tpHeaderList : [TourPlannerHeader] = []
        
        try? dbPool.read { db in
            tpHeaderList = try TourPlannerHeader.fetchAll(db, "SELECT * FROM \(TRAN_TP_HEADER) WHERE TP_Id > ?", arguments: [0])
        }
        
        return tpHeaderList
    }
    
    func updateTPIdAndTPEntryIdInRefTabls(tpId: Int, tpEntryId: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_PRODUCT) SET TP_Entry_Id = \(tpEntryId) WHERE TP_Id = \(tpId)")
        executeQuery(query: "UPDATE \(TRAN_TP_DOCTOR) SET TP_Entry_Id = \(tpEntryId) WHERE TP_Id = \(tpId)")
        executeQuery(query: "UPDATE \(TRAN_TP_SFC) SET TP_Entry_Id = \(tpEntryId) WHERE TP_Id = \(tpId)")
        executeQuery(query: "UPDATE \(TRAN_TP_ACCOMPANIST) SET TP_Entry_Id = \(tpEntryId) WHERE TP_Id = \(tpId)")
    }
    
    func updateTPDateInTPDoctorTable(tpId: Int, tpDate: String)
    {
        executeQuery(query: "UPDATE \(TRAN_TP_DOCTOR) SET TP_Date = '\(tpDate)' WHERE TP_Id = \(tpId)")
    }
    
    
    //MARK:- Mail Message
    func insertMailHeader(array: [MailMessageHeader])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func insertMailContent(array: [MailMessageContent])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func insertMailAgent(array: [MailMessageAgent])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func insertMailAttachment(array: [MailMessageAttachment])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func getMailMessageHeader() -> [MailMessageHeader]
    {
        var msgList: [MailMessageHeader] = []
        
        try? dbPool.read { db in
            msgList = try MailMessageHeader.fetchAll(db, "SELECT * FROM \(TRAN_MAIL_MESSAGE_HEADER)")
        }
        
        return msgList
    }
    
    func getMailMessageContent() -> [MailMessageContent]
    {
        var msgList: [MailMessageContent] = []
        
        try? dbPool.read { db in
            msgList = try MailMessageContent.fetchAll(db, "SELECT * FROM \(TRAN_MAIL_MSG_CONTENT)")
        }
        
        return msgList
    }
    
    func getMailMessageAgent() -> [MailMessageAgent]
    {
        var msgList: [MailMessageAgent] = []
        
        try? dbPool.read { db in
            msgList = try MailMessageAgent.fetchAll(db, "SELECT * FROM \(TRAN_MAIL_MSG_AGENT)")
        }
        
        return msgList
    }
    
    func getMailMessageAttachments() -> [MailMessageAttachment]
    {
        var msgList: [MailMessageAttachment] = []
        
        try? dbPool.read { db in
            msgList = try MailMessageAttachment.fetchAll(db, "SELECT * FROM \(TRAN_MAIL_MSG_ATTACHMENT)")
        }
        
        return msgList
    }
    
    func updateMsgIdIdInRefTabls(msgId: Int, msgCode: String)
    {
        executeQuery(query: "UPDATE \(TRAN_MAIL_MSG_ATTACHMENT) SET Msg_Id = \(msgId) WHERE Msg_Code = '\(msgCode)'")
        executeQuery(query: "UPDATE \(TRAN_MAIL_MSG_AGENT) SET Msg_Id = \(msgId) WHERE Msg_Code = '\(msgCode)'")
        executeQuery(query: "UPDATE \(TRAN_MAIL_MSG_CONTENT) SET Msg_Id = \(msgId) WHERE Msg_Code = '\(msgCode)'")
    }
    
    func updateMailAttachmentLocalPath(localPath: String, blobUrl: String, msgCode: String)
    {
        executeQuery(query: "UPDATE \(TRAN_MAIL_MSG_ATTACHMENT) SET Local_Attachment_Path = '\(localPath)' WHERE Msg_Code = '\(msgCode)' AND Blob_Url = '\(blobUrl)'")
    }
    
    //MARK: Landing Alerts
    func getAnniversaryDoctors() -> [CustomerMasterModel]
    {
        var doctorList : [CustomerMasterModel] = []
        
        try? dbPool.read { db in
            doctorList = try CustomerMasterModel.fetchAll(db, "SElECT *,((strftime('%s',strftime('%Y', 'now','localtime')||strftime('-%m-%d', Anniversary_Date))-strftime('%s','now','localtime'))/86400.0+1+((strftime('%s','now', 'localtime','+1 year')-strftime('%s','now',  'localtime'))/86400.0)) % ((strftime('%s','now', 'localtime','+1 year')-strftime('%s','now',  'localtime'))/86400.0) as indays from mst_Customer_Master where indays < 7 or indays = 364 order by indays asc")
        }
        
        return doctorList
    }
    
    func getBirthdayDoctors() -> [CustomerMasterModel]
    {
        var doctorList : [CustomerMasterModel] = []
        
        try? dbPool.read { db in
            doctorList = try CustomerMasterModel.fetchAll(db, "SElECT *,((strftime('%s',strftime('%Y', 'now','localtime')||strftime('-%m-%d', DOB))-strftime('%s','now','localtime'))/86400.0+1+((strftime('%s','now', 'localtime','+1 year')-strftime('%s','now',  'localtime'))/86400.0)) % ((strftime('%s','now', 'localtime','+1 year')-strftime('%s','now',  'localtime'))/86400.0) as indays from mst_Customer_Master where indays < 7 or indays = 364 order by indays asc")
        }
        
        return doctorList
    }
    
    //MARK: Logout
    func getPendingDCRCount() -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_HEADER) WHERE DCR_Code IS NULL OR DCR_Code = ''")!
        }
        
        return count
    }
    
    func getPendingTPCount() -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_TP_HEADER) WHERE TP_Id = 0 AND Activity > 0")!
        }
        
        return count
    }
    
    func getAllTableNames() -> [Row]
    {
        var rows: [Row] = []
        
        try? dbPool.read { db in
            rows = try Row.fetchAll(db, "SELECT Name AS 'Table_Name' FROM sqlite_master WHERE Type = 'table'")
        }
        
        return rows
    }
    //MARK:- ChemistDay
    
    func getChemistVisitDetailFlexiChemist(dcrId: Int, chemistVisitId : Int) -> [ChemistDayVisit]?
    {
        var doctorList : [ChemistDayVisit]?
        
        try? dbPool.read { db in
            doctorList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ? AND Chemist_Code = '' AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
        }
        
        return doctorList
    }
    
    func getChemistVisitforChemistId(dcrId: Int, customerCode: String, regionCode: String) -> [ChemistDayVisit]?
    {
        var chemistList : [ChemistDayVisit]?
        
        try? dbPool.read { db in
            chemistList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ? AND Chemist_Code = ? AND Chemist_Region_Code = ?", arguments: [dcrId, customerCode, regionCode])
        }
        
        return chemistList
    }
    
    func updateValueForNewColumnsInPOBBuild()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Geo_Fencing_Deviation_Remarks = '', Geo_Fencing_Page_Source = ''")
        executeQuery(query: "UPDATE \(TRAN_ED_DOCTOR_LOCATION_INFO) SET Geo_Fencing_Deviation_Remarks = ''")
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Business_Status_ID = \(defaultBusineessStatusId), Business_Status_Name = '',Business_Status_Active_Status = 1, Call_Objective_ID = \(defaultCallObjectiveId), Call_Objective_Name = '', Call_Objective_Active_Status = 1")
        executeQuery(query: "UPDATE \(TRAN_DCR_DETAILED_PRODUCTS) SET Business_Status_ID = \(defaultBusineessStatusId), Business_Status_Name = '',Business_Status_Active_Status = 1, Business_Potential = \(Float(defaultBusinessPotential) ?? -1.0), Remarks = ''")
    }
    
    func updateValueForNewColumnsInInheritanceBuild()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Is_DCR_Inherited_Doctor = 0")
        executeQuery(query: "UPDATE \(TRAN_DCR_ACCOMPANIST) SET Is_Customer_Data_Inherited = \(Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Yet_To_Download)")
    }
    
    func getChemistDayVisitsByRegionCode(dcrId: Int, regionCode: String) -> [ChemistDayVisit]
    {
        var chemistList : [ChemistDayVisit] = []
        
        try? dbPool.read { db in
            chemistList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ? AND Chemist_Region_Code = ?", arguments: [dcrId, regionCode])
        }
        
        return chemistList
    }
    
    func insertDCRDoctorVisitChemistAccompanist(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistAccompanist(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    func updateDCRChemistVisit(dcrChemistVisitObj: ChemistDayVisit)
    {
        
        executeQuery(query: "UPDATE \(TRAN_DCR_CHEMIST_DAY_VISIT) SET Visit_Mode ='\(dcrChemistVisitObj.VisitMode!)',Visit_Time = '\(dcrChemistVisitObj.VisitTime!)',Remarks = '\(dcrChemistVisitObj.Remarks!)',Latitude = \(dcrChemistVisitObj.Latitude!),Longitude = \(dcrChemistVisitObj.Longitude!) WHERE DCR_Chemist_Day_Visit_Id = \(dcrChemistVisitObj.DCRChemistDayVisitId!)")
    }
    
    func insertDCRChemistVisit(dcrChemistVisitObj: ChemistDayVisit) -> Int
    {
        var chemistVisitId: Int = 0
        
        try? dbPool.write({ db in
            try dcrChemistVisitObj.insert(db)
            chemistVisitId = Int(db.lastInsertedRowID)
        })
        
        return chemistVisitId
    }
    func insertchemistvisitdata(dcrChemistVisitObj: ChemistDayVisit) -> Int
    {
        var chemistVisitId: Int = 0
        
        try? dbPool.write({ db in
            try dcrChemistVisitObj.insert(db)
            chemistVisitId = Int(db.lastInsertedRowID)
        })
        
        return chemistVisitId
    }
    func insertDcrchemistvisitdata(dcrChemistVisit: DCRChemistVisitModel) -> Int
    {
        var chemistVisitId: Int = 0
        
        try? dbPool.write({ db in
            try dcrChemistVisit.insert(db)
            chemistVisitId = Int(db.lastInsertedRowID)
        })
        
        return chemistVisitId
    }
    func insertDCRChemistAccompanist(dcrChemistAccompanist: [DCRChemistAccompanist])
    {
        try? dbPool.write { db in
            for obj in dcrChemistAccompanist
            {
                try obj.insert(db)
            }
        }
    }
    
    
    
    
    func insertChemistAccompanist(dcrChemistAccompanistObj: DCRChemistAccompanist)
    {
        try? dbPool.write { db in
            try dcrChemistAccompanistObj.insert(db)
        }
    }
    
    
    func insertDCRDoctorVisitChemistSamplePromotion(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistSamplePromotion(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitChemistDetailedProductDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistDetailedProduct(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitChemistRCPAOwnProductDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistRCPAOwn(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitChemistRCPACompetitorProductDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistRCPACompetitor(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRDoctorVisitChemistDayFollowups(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistFollowup(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRChemistFollowups(followup : DCRChemistFollowup)
    {
        try? dbPool.writeInTransaction{ db in
            try followup.insert(db)
            return .commit
        }
    }
    
    func insertDCRDoctorVisitChemistDayAttachments(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRChemistAttachment(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //GET
    
    func getDCRChemistSelectedDetailedProductList(dcrId: Int,chemistVisitId: Int) -> [DCRChemistDetailedProduct]
    {
        var selectedDetailedProductList:[DCRChemistDetailedProduct] = []
        
        try? dbPool.read { db in
            selectedDetailedProductList = try DCRChemistDetailedProduct.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
        }
        
        return selectedDetailedProductList
    }
    
    func getChemistVisitDetailByChemistVisitId(chemistVisitId : Int) -> ChemistDayVisit?
    {
        var chemistVisitObj : ChemistDayVisit?
        
        try? dbPool.read { db in
            chemistVisitObj = try ChemistDayVisit.fetchOne(db, "SELECT \(TRAN_DCR_CHEMIST_DAY_VISIT).*,\(MST_ACCOMPANIST).Region_Name FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) LEFT JOIN \(MST_ACCOMPANIST) ON \(TRAN_DCR_CHEMIST_DAY_VISIT).Chemist_Region_Code = \(MST_ACCOMPANIST).Region_Code WHERE  DCR_Chemist_Day_Visit_Id = ?", arguments: [chemistVisitId])
        }
        
        return chemistVisitObj
    }
    
    func deleteDCRChemistSampleDetails(dcrId: Int, chemistVisitId: Int)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistSamplePromotion.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
            {
                try! rowValue.delete(db)
            }
            
        })
    }
    func insertDCRChemistSampleProducts(sampleList : [DCRChemistSamplePromotion])
    {
        try? dbPool.writeInTransaction{ db in
            
            for sampleObj in sampleList
            {
                try sampleObj.insert(db)
            }
            return .commit
        }
    }
    
    
    
    //delete
    
    func deleteDCRChemistDetailedProducts(dcrId: Int, chemistVisitId: Int)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRDetailedProductsModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) WHERE DCR_Id = ? AND  DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
            {
                try! rowValue.delete(db)
            }
            
        })
    }
    
    //ChemistDay Followup
    
    func getChemistDayFollowUpDetailsByDCRId(dcrId : Int) -> [DCRChemistFollowup]
    {
        var chemistFollowUpList :  [DCRChemistFollowup] = []
        
        try? dbPool.read { db in
            chemistFollowUpList = try DCRChemistFollowup.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistFollowUpList
    }
    
    func getChemistFollowUpModel(dcrId: Int, chemistVisitId : Int) -> [DCRChemistFollowup]
    {
        var chemistFollowUpList :  [DCRChemistFollowup] = []
        
        try? dbPool.read { db in
            chemistFollowUpList = try DCRChemistFollowup.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
        }
        
        return chemistFollowUpList
    }
    
    func updateChemistDayFollowUpDetail(followUpObj : DCRChemistFollowup)
    {
        //        try? dbPool.write({ db in
        //                if let rowValue = DCRChemistFollowup.fetchOne(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Chemist_Followup_Id = ?", arguments: [followUpObj.DCRChemistFollowupId!])
        //                {
        //                    rowValue.Task = followUpObj.Task!
        //                    rowValue.DueDate = followUpObj.DueDate!
        //                    try! rowValue.update(db)
        //                }
        //            })
        
        let task = followUpObj.Task!
        let dueDate = getServerFormattedDateString(date: followUpObj.DueDate!)
        //
        let query = "UPDATE \(TRAN_DCR_CHEMIST_FOLLOWUP) SET Task = '\(task)' AND Due_Date = '\(dueDate)'  WHERE DCR_Chemist_Followup_Id = \(followUpObj.DCRChemistFollowupId!)"
        print(query)
        executeQuery(query: query)
    }
    
    func deleteChemistFollowUpDetail(followUpObj : DCRChemistFollowup)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistFollowup.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = \(followUpObj.DCRId!) AND DCR_Chemist_Day_Visit_Id = \(followUpObj.ChemistVisitId!) AND DCR_Chemist_Followup_Id = \(followUpObj.DCRChemistFollowupId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func deleteDCRChemistFollowUpDetail(followUpObj : DCRChemistFollowup)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistFollowup.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Chemist_Followup_Id = \(followUpObj.DCRChemistFollowupId!)")
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func insertChemistAttachmentDetail(dcrChemistAttachmentModel: DCRChemistAttachment)
    {
        try? dbPool.writeInTransaction{ db in
            
            try dcrChemistAttachmentModel.insert(db)
            return .commit
        }
    }
    
    func getAttachmentCountPerChemist(dcrId: Int, chemistVisitId: Int) -> Int
    {
        var count: Int = 0
        
        try? dbPool.read { db in
            count = try Int.fetchOne(db, "SELECT COUNT(*) FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])!
        }
        
        return count
    }
    
    func getChemistAttachmentDetails(dcrId: Int, chemistVisitId: Int) -> [DCRChemistAttachment]?
    {
        var dcrChemistAttachmentList: [DCRChemistAttachment]?
        
        try? dbPool.read ({ db in
            dcrChemistAttachmentList = try DCRChemistAttachment.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments : [dcrId, chemistVisitId])
        })
        
        return dcrChemistAttachmentList
    }
    
    //    func getChemistAttachmentDetails(dcrId: Int, chemistVisitId: Int) -> [DCRChemistAttachment]?
    //    {
    //        var dcrChemistAttachmentList: [DCRChemistAttachment]?
    //
    //        try? dbPool.read ({ db in
    //            dcrChemistAttachmentList = DCRChemistAttachment.fetchAll(db, "SELECT DCR_Chemist_Attachment_Id, Blob_Url, Uploaded_File_Name, IsFile_Downloaded FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments : [dcrId, chemistVisitId])
    //        })
    //
    //        return dcrChemistAttachmentList
    //    }
    
    func updateChemsistAttachmentDownloadStatus(attachmentId: Int, isDownloaded: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistAttachment.fetchOne(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Chemist_Attachment_Id = ?", arguments: [attachmentId])
            {
                rowValue.IsFileDownloaded = isDownloaded
                try! rowValue.update(db)
            }
        })
    }
    
    func deleteChemistAttachment(attachmentId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistAttachment.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Chemist_Attachment_Id = ?", arguments : [attachmentId])
            {
                try! rowValue.delete(db)
            }
        })
    }
    
    //MARK:-- Chemist RCPA
    func getRCPAEnteredDoctorsList(chemistDayVisitId : Int) -> [DCRChemistRCPAOwn]
    {
        var chemistFollowUpList :  [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            chemistFollowUpList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT  Doctor_Code,Doctor_Region_Code,Doctor_Name,Doctor_MDL_Number,Doctor_Speciality_Name,Doctor_Category_Name FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Chemist_Day_Visit_Id = ? GROUP BY Doctor_Code,Doctor_Region_Code,Doctor_Name,Doctor_MDL_Number,Doctor_Speciality_Name,Doctor_Category_Name", arguments: [chemistDayVisitId])
        }
        
        return chemistFollowUpList
    }
    
    func getRCPADetailsByDoctorCode(chemistDayVisitId: Int, doctorCode : String, doctorRegionCode: String) -> [DCRChemistRCPAOwn]
    {
        var rcpaList :  [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            rcpaList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT  * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Chemist_Day_Visit_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [chemistDayVisitId, doctorCode, doctorRegionCode])
        }
        
        return rcpaList
    }
    
    func getRCPADetailsByDoctorName(chemistDayVisitId: Int, doctorName: String, doctorSpecialityName: String) -> [DCRChemistRCPAOwn]
    {
        var rcpaList :  [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            rcpaList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT  * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Chemist_Day_Visit_Id = ? AND Doctor_Name = ? AND Doctor_Speciality_Name = ?", arguments: [chemistDayVisitId, doctorName, doctorSpecialityName])
        }
        
        return rcpaList
    }
    
    func deleteChemistDayRCPA(chemistRCPAOwnId: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Chemist_RCPA_Own_Id = \(chemistRCPAOwnId)")
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Chemist_RCPA_Own_Id = \(chemistRCPAOwnId)")
    }
    
    func insertChemistDayRCPAOwn(objRCPAOwn: DCRChemistRCPAOwn) -> Int
    {
        var id: Int = 0
        
        try? dbPool.write({ db in
            try objRCPAOwn.insert(db)
            id = Int(db.lastInsertedRowID)
        })
        
        return id
    }
    
    func getChemistDayHeaderDetails(dcrId: Int) -> [ChemistDayVisit]
    {
        var chemistList : [ChemistDayVisit] = []
        
        try? dbPool.read { db in
            chemistList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ?", arguments: [dcrId])
        }
        
        return chemistList
    }
    
    //delete chemistVisit
    func deleteChemistDayAccompanist(dcrId: Int,chemistVisitId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistAccompanist.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //        executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ACCOMPANIST) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDaySamplePromotion(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistSamplePromotion.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDayDetailedProducts(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistDetailedProduct.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDayRCPAOwn(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistRCPAOwn.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDayRCPACompetitor(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistRCPACompetitor.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDayFollowups(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistFollowup.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_FOLLOWUP) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deleteChemistDayAttachments(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRChemistAttachment.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_ATTACHMENT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    
    func deletePOBForChemist(chemistVisitId: Int,dcrId: Int)
    {
        let list = getPOBHeaderForDCRId(dcrId: dcrId,visitId: chemistVisitId,customerEntityType: Constants.CustomerEntityType.chemist)
        
        for obj in list
        {
            if obj.Order_Status != Constants.OrderStatus.inprogress && obj.Order_Status != Constants.OrderStatus.complete
            {
                DBHelper.sharedInstance.deletePOBRemarks(orderEntryId: obj.Order_Entry_Id)
                DBHelper.sharedInstance.deletePOBDetails(orderEntryId: obj.Order_Entry_Id)
                DBHelper.sharedInstance.deletePOBHeader(orderEntryId: obj.Order_Entry_Id)
            }
        }
    }
    
    func deleteChemistDayVisit(chemistVisitId: Int,dcrId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try ChemistDayVisit.fetchOne(db, "DELETE FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])            {
                try! rowValue.delete(db)
            }
        })
        //executeQuery(query: "DELETE FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? ",arguments: [dcrId,chemistVisitId])
    }
    //RCPA
    
    func getRCPADetailedProduct(dcrId: Int,chemistVisitId: Int,doctorCode: String,regionCode: String) -> [DCRChemistRCPAOwn]
    {
        var selectedDetailedProductList:[DCRChemistRCPAOwn] = []
        try? dbPool.read { db in
            selectedDetailedProductList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments: [dcrId, chemistVisitId,doctorCode,regionCode])
        }
        return selectedDetailedProductList
        
    }
    
    func getRCPADetailedProductForFlexiDoctor(dcrId: Int,chemistVisitId: Int,doctorname: String,docSpeciality: String) -> [DCRChemistRCPAOwn]
    {
        var selectedDetailedProductList:[DCRChemistRCPAOwn] = []
        try? dbPool.read { db in
            selectedDetailedProductList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ? AND Doctor_Name = ? AND Doctor_Speciality_Name = ?", arguments: [dcrId, chemistVisitId,doctorname,docSpeciality])
        }
        return selectedDetailedProductList
        
    }
    
    func getRCPADetailedProductForReport(dcrId: Int,chemistVisitId: Int) -> [DCRChemistRCPAOwn]
    {
        var selectedDetailedProductList:[DCRChemistRCPAOwn]?
        try? dbPool.read { db in
            selectedDetailedProductList = try DCRChemistRCPAOwn.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND DCR_Chemist_Day_Visit_Id = ?", arguments: [dcrId, chemistVisitId])
        }
        return selectedDetailedProductList!
        
    }
    
    func getDCRRCPADetailsByOwnProductId(dcrChemistDayVisitId: Int,ownProductCode : String) -> [DCRChemistRCPACompetitor]?
    {
        var rcpaList : [DCRChemistRCPACompetitor]?
        
        try? dbPool.read { db in
            rcpaList = try DCRChemistRCPACompetitor.fetchAll(db,"SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Chemist_Day_Visit_Id = ? AND Own_Product_Code = ?",arguments:[dcrChemistDayVisitId,ownProductCode])
        }
        
        return rcpaList
    }
    
    func getChemistDayVisitsForDCRId(dcrId: Int) -> [ChemistDayVisit]?
    {
        var chemistList : [ChemistDayVisit]?
        
        try? dbPool.read { db in
            chemistList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = \(dcrId)")
        }
        
        return chemistList
    }
    
    func getChemistDayVisitsForDCRIdAndVisitId(dcrId: Int,chemistDayVisitId: Int) -> [ChemistDayVisit]?
    {
        var chemistList : [ChemistDayVisit]?
        
        try? dbPool.read { db in
            chemistList = try ChemistDayVisit.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CHEMIST_DAY_VISIT) WHERE DCR_Id = \(dcrId) AND DCR_Chemist_Day_Visit_Id = \(chemistDayVisitId)")
        }
        
        return chemistList
    }
    
    func getChemistModel(customerCode:String) -> CustomerMasterModel
    {
        let customerType = "CHEMIST"
        var chemistObj: CustomerMasterModel?
        try? dbPool.read { db in
            chemistObj = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code  = ? AND Customer_Entity_Type = ?", arguments: [customerCode,customerType])
        }
        return chemistObj!
    }
    
    func getDoctorModel(customerCode:String) -> CustomerMasterModel
    {
        let customerType = "DOCTOR"
        var doctorObj: CustomerMasterModel?
        try? dbPool.read { db in
            doctorObj = try CustomerMasterModel.fetchOne(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Customer_Code  = ? AND Customer_Entity_Type = ?", arguments: [customerCode,customerType])
        }
        return doctorObj!
    }
    
    
    func getChemistDayRCPACompetitor(chemistDayVisitId: Int,rcpaOwn_Id: Int) -> [DCRChemistRCPACompetitor]
    {
        var chemistObj: [DCRChemistRCPACompetitor]?
        let query = "SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) WHERE DCR_Chemist_RCPA_Own_Id  = \(rcpaOwn_Id) AND DCR_Chemist_Day_Visit_Id = \(chemistDayVisitId)"
        print(query)
        try? dbPool.read { db in
            chemistObj = try DCRChemistRCPACompetitor.fetchAll(db, query)
        }
        return chemistObj!
    }
    
    func getProductName(productCode: String) -> String?
    {
        var name : String = ""
        try? dbPool.read { db in
            let obj : DCRChemistRCPAOwn = try DCRChemistRCPAOwn.fetchOne(db, "SELECT Product_Name FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE Product_Code = ?", arguments: [productCode])!
            name = obj.ProductName
        }
        return name
    }
    
    
    func getDCRChemistRCPADoctor(chemistVisitId: Int, dcrId : Int, doctorCategoryName: String, doctorCode: String, doctorRegionCode: String) -> [DCRChemistRCPAOwn]
    {
        var rcpaList : [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            rcpaList = try DCRChemistRCPAOwn.fetchAll(db,"SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Chemist_Day_Visit_Id = ? AND DCR_Id = ? AND Doctor_Category_Name = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?",arguments:[chemistVisitId, dcrId,doctorCategoryName, doctorCode, doctorRegionCode])
        }
        
        return rcpaList
    }
    
    func getRCPAListByDoctorCode(dcrId : Int, doctorCode: String, doctorRegionCode: String) -> [DCRChemistRCPAOwn]
    {
        var rcpaList : [DCRChemistRCPAOwn] = []
        
        try? dbPool.read { db in
            rcpaList = try DCRChemistRCPAOwn.fetchAll(db,"SELECT * FROM \(TRAN_DCR_CHEMIST_RCPA_OWN) WHERE DCR_Id = ? AND Doctor_Code = ? AND Doctor_Region_Code = ?", arguments:[dcrId, doctorCode, doctorRegionCode])
        }
        
        return rcpaList
    }
    
    func getDoctorVisitByCategoryName(dcrId: Int, categoryName: String) -> [DCRDoctorVisitModel]
    {
        var doctorList : [DCRDoctorVisitModel] = []
        
        try? dbPool.read { db in
            doctorList = try DCRDoctorVisitModel.fetchAll(db,"SELECT * FROM \(TRAN_DCR_DOCTOR_VISIT) WHERE DCR_Id = ? AND UPPER(Category_Name) = ?", arguments:[dcrId, categoryName.uppercased()])
        }
        
        return doctorList
    }
    
    func updateDCRChemistAccompanist(dcrDoctorAccompanistObj : DCRChemistAccompanist)
    {
        let query = "UPDATE \(TRAN_DCR_CHEMIST_ACCOMPANIST) SET Is_Accompanied_Call = \(dcrDoctorAccompanistObj.IsAccompaniedCall!) WHERE DCR_Chemist_Accompanist_Id = \(dcrDoctorAccompanistObj.DCRChemistAccompanistId!)"
        executeQuery(query: query)
        
    }
    
    //MARK:-- MCDoctorProductMapping
    func getMCDoctorProductMapping(customerCode: String, regionCode: String, date: String, refType: String) -> [DoctorProductMappingModel]
    {
        var mcDoctorMappingObj : [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            mcDoctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND  DATE('\(date)')  BETWEEN DATE(MC_Effective_From) AND DATE(MC_Effective_To) AND Ref_Type = ? ORDER BY Priority_Order ASC",arguments:[customerCode, regionCode, refType])
        }
        return mcDoctorMappingObj
    }
    
    func getTargetProductMapping(customerCode: String, regionCode: String, refType: String) -> [DoctorProductMappingModel]
    {
        var mcDoctorMappingObj : [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            mcDoctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND Ref_Type = ? ORDER BY Priority_Order ASC",arguments:[customerCode, regionCode, refType])
        }
        return mcDoctorMappingObj
    }
    
    func getDoctorProductMapping(customerCode: String, regionCode: String,refType: String,date: String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND Ref_Type = ? ORDER BY Priority_Order ASC",arguments:[customerCode,regionCode,refType])
        }
        
        return doctorMappingObj
    }
    
    func deleteMCProductMapping(regionCodes: String)
    {
        executeQuery(query: "DELETE FROM \(MST_MC_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Region_Code IN (\(regionCodes))")
    }
    
    func deleteProductMapping(regionCodes: String)
    {
        let query = "DELETE FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Region_Code IN (\(regionCodes))"
        executeQuery(query: query)
    }
    
    func deleteCustomerAddress(regionCodes: String)
    {
        let query = "DELETE FROM \(MST_CUSTOMER_ADDRESS) WHERE Region_Code_Global IN (\(regionCodes))"
        executeQuery(query: query)
    }
    
    func deleteHospitalAccountNumberInfo(regionCodes: String)
    {
        let query = "DELETE FROM \(TRAN_CUSTOMER_HOSPITAL_INFO) WHERE Region_Code IN (\(regionCodes))"
        executeQuery(query: query)
    }
    
    func insertMasterDataDownloadCheckStatus(objMasterData: MasterDataDownloadCheckModel)
    {
        deleteFromTable(tableName: TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO)
        UserDefaults.standard.set("", forKey: MasterDataDownloadMessage)
        try? dbPool.write({ db in
            try objMasterData.insert(db)
        })
    }
    
    func updateSkipCountMasterDataDownloadCheck(currentDate: String, skipCount: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO) SET Skip_Count = \(skipCount) WHERE DATE(API_Check_Date) = DATE('\(currentDate)')")
        
    }
    
    func updateCompletedStatusMasterDataDownloadCheck(currentDate: String, completedStatus: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO) SET Completed_Status = \(completedStatus) WHERE DATE(API_Check_Date) = DATE('\(currentDate)')")
    }
    
    func getMasterDataDownloadCheckList(currentDate: String) -> [MasterDataDownloadCheckModel]
    {
        var masterDataDownloadCheckList : [MasterDataDownloadCheckModel] = []
        try? dbPool.read { db in
            masterDataDownloadCheckList = try MasterDataDownloadCheckModel.fetchAll(db, "SELECT * FROM \(TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO) WHERE DATE(API_Check_Date) = DATE('\(currentDate)')")
        }
        return masterDataDownloadCheckList
    }
    
    func getMasterDataDownloadCheckList() -> [MasterDataDownloadCheckModel]
    {
        var masterDataDownloadCheckList : [MasterDataDownloadCheckModel] = []
        try? dbPool.read { db in
            masterDataDownloadCheckList = try MasterDataDownloadCheckModel.fetchAll(db, "SELECT * FROM \(TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO)")
        }
        return masterDataDownloadCheckList
    }
    
    func updateDCRFreezeForAll()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_HEADER) SET Is_TP_Frozen = 0")
    }
    
    func updateIsTPSFCForAll()
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_TRAVELLED_PLACES) SET Is_TP_SFC = 0")
    }
    
    //MARK:- Password Policy
    func updateUserDetails(lastPasswordUpdateDate: String, accountLockedDate: String, isAccountLocked: Int,fullIndex:String)
    {
        let query = "UPDATE \(MST_USER_DETAILS) SET Last_Password_Updated_Date = '\(lastPasswordUpdateDate)', Account_Locked_DateTime = '\(accountLockedDate)', Is_Account_Locked = \(isAccountLocked), Full_index = '\(fullIndex)'"
        executeQuery(query: query)
    }
    
    func updateUserDetailsWithPassword(lastPasswordUpdateDate: String, accountLockedDate: String, isAccountLocked: Int, password: String)
    {
        let query = "UPDATE \(MST_USER_DETAILS) SET Last_Password_Updated_Date = '\(lastPasswordUpdateDate)', Account_Locked_DateTime = '\(accountLockedDate)',User_Password = '\(password)', Is_Account_Locked = \(isAccountLocked)"
        executeQuery(query: query)
    }
    
    func updateUserDetailRegionType(regionTypeCode: String, regionTypeName: String)
    {
        let query = "UPDATE \(MST_USER_DETAILS) SET Region_Type_Code = '\(regionTypeCode)', Region_Type_Name = '\(regionTypeName)'"
        executeQuery(query: query)
    }
    
    //Activity
    
    func insertMCHeaderModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCHeaderModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCallActivityModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CallActivity(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertMCRegionTypeModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCRegionTypeModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertMCCategoryModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCCategoryModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertMCSpecialtyModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCSpecialtyModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertMCActivityModelList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCActivityModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getCallActivity() -> [CallActivity]
    {
        var callActivityList : [CallActivity]?
        
        try? dbPool.read { db in
            callActivityList = try CallActivity.fetchAll(db, "SELECT * FROM \(MST_CALL_ACTIVITY) ")
        }
        return callActivityList!
    }
    
    func getMCActivity() -> [MCActivityModel]
    {
        var mcActivityList : [MCActivityModel]?
        
        try? dbPool.read { db in
            mcActivityList = try MCActivityModel.fetchAll(db, "SELECT * FROM \(MST_MC_ACTIVITY)")
        }
        return mcActivityList!
        
    }
    
    func deleteDoctorCallActivityData(doctorVisitCode: Int)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Customer_Visit_Id IN(\(doctorVisitCode) AND Entity_Type = '\(sampleBatchEntity.Doctor.rawValue)')")
    }
    
    func deletDCRActivityDetails(entityType: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE Entity_Type = '\(entityType)'")
    }
    
    func deletDCRMCActivityDetails(entityType: String)
    {
        executeQuery(query: "DELETE FROM \(TRAN_DCR_MC_ACTIVITY) WHERE Entity_Type = '\(entityType)'")
    }
    
    
    func updateDoctorCallActivityData(doctorVisitCode: Int,activityID: Int,entityType:String)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRActivityCallType.fetchOne(db, "DELETE FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND Customer_Activity_ID = ? AND Entity_Type = '\(entityType)' ",arguments: [doctorVisitCode,activityID])            {
                try! rowValue.delete(db)
            }
        })
        
    }
    
    func updateDoctorMCCallActivityData(doctorVisitCode: Int,activityID: Int,CampaignCode:String,entityType:String)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRMCActivityCallType.fetchOne(db, "DELETE FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND MC_Activity_Id = ? AND Campaign_Code = ? AND Entity_Type = '\(entityType)'",arguments: [doctorVisitCode,activityID,CampaignCode])            {
                try! rowValue.delete(db)
            }
        })
        
    }
    
    
    func insertDCRCallActivity(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRActivityCallType(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRCallActivityList(array: [DCRActivityCallType])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRMCCallActivityList(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRMCActivityCallType(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDCRMCCallActivityList(array: [DCRMCActivityCallType])
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try data.insert(db)
            }
            return .commit
        }
    }
    
    func getCallActivityList(dcrId:Int,doctorVisitCode: Int,entityType:String) -> [DCRActivityCallType]
    {
        var activityList : [DCRActivityCallType] = []
        
        try? dbPool.read { db in
            activityList = try DCRActivityCallType.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments:[doctorVisitCode,dcrId])
        }
        return activityList
    }
    
    func getMcCallActivityList(dcrId:Int,doctorVisitCode: Int,entityType:String) -> [DCRMCActivityCallType]
    {
        var activityList : [DCRMCActivityCallType] = []
        
        try? dbPool.read { db in
            activityList = try DCRMCActivityCallType.fetchAll(db, "SELECT * FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments:[doctorVisitCode,dcrId])
        }
        return activityList
    }
    
    func getMCActivityList(campaignCode:String) -> [MCActivityModel]
    {
        var activityList : [MCActivityModel] = []
        try? dbPool.read { db in
            activityList = try MCActivityModel.fetchAll(db, "SELECT * FROM \(MST_MC_ACTIVITY) WHERE Campaign_Code = ?",arguments:[campaignCode])
        }
        return activityList
    }
    
    func getDoctorMcCallActivityList(doctorVisitCode: Int,campaignCode:String,entityType:String) -> [DCRMCActivityCallType]
    {
        var activityList : [DCRMCActivityCallType] = []
        try? dbPool.read { db in
            activityList = try DCRMCActivityCallType.fetchAll(db, "SELECT * FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Customer_Visit_Id = ? AND Campaign_Code = ? AND Entity_Type = '\(entityType)'",arguments:[doctorVisitCode,campaignCode])
        }
        return activityList
    }
    
    func getMCList(dcrActualDate: String, doctorCode: String, doctorRegionCode: String) -> [MCHeaderModel]
    {
        
        var activityList : [MCHeaderModel] = []
        let query = "SELECT MMH.Campaign_Code,MMH.Campaign_Name FROM MST_MC_HEADER MMH INNER JOIN MST_MC_ACTIVITY MMA on MMH.Campaign_Code = MMA.Campaign_Code INNER JOIN mst_Doctor_Product_Mapping DPM ON MMH.Campaign_Code = DPM.MC_Code WHERE DPM.Customer_Code = '\(doctorCode)' AND Customer_Region_Code = '\(doctorRegionCode)' AND DPM.Mapped_Region_Code = '\(getRegionCode())' AND DATE('\(dcrActualDate)') BETWEEN DATE(MMH.Effective_From) AND DATE(MMH.Effective_To) GROUP BY MMH.Campaign_Code,MMH.Campaign_Name"
        //SELECT MCH.Campaign_Code,MCH.Campaign_Name FROM MST_MC_HEADER MCH INNER JOIN MST_MC_MAPPED_REGION_TYPES MCRT ON MCH.Campaign_Code = MCRT.Campaign_Code INNER JOIN MST_MC_CATEGORY MCCAT ON MCH.Campaign_Code = MCCAT.Campaign_Code INNER JOIN MST_MC_SPECIALITY MCSPL ON MCH.Campaign_Code = MCSPL.Campaign_Code WHERE DATE('\(dcrActualDate)') BETWEEN MCH.Effective_From AND MCH.Effective_To AND MCRT.Region_Type_Code = '\(regionTypeCode)' AND MCCAT.Customer_Category_Code= '\(doctorCategoryCode)' AND MCSPL.Customer_Speciality_Code = '\(spltyCode)' GROUP BY MCH.Campaign_Code,MCH.Campaign_Name"
        print(query)
        try? dbPool.read { db in
            activityList = try MCHeaderModel.fetchAll(db, query)
        }
        return activityList
    }
    
    func getMCListForDoctor(dcrActualDate: String, doctorCode: String, doctorRegionCode: String) -> [MCHeaderModel]
    {
        
        var activityList : [MCHeaderModel] = []
        let query = "SELECT MMH.Campaign_Code,MMH.Campaign_Name FROM MST_MC_HEADER MMH INNER JOIN mst_Doctor_Product_Mapping DPM ON MMH.Campaign_Code = DPM.MC_Code WHERE DPM.Customer_Code = '\(doctorCode)' AND DPM.Customer_Region_Code = '\(doctorRegionCode)' AND DATE('\(dcrActualDate)') BETWEEN DATE(MMH.Effective_From) AND DATE(MMH.Effective_To) GROUP BY DPM.MC_Code"
        //SELECT MCH.Campaign_Code,MCH.Campaign_Name FROM MST_MC_HEADER MCH INNER JOIN MST_MC_MAPPED_REGION_TYPES MCRT ON MCH.Campaign_Code = MCRT.Campaign_Code INNER JOIN MST_MC_CATEGORY MCCAT ON MCH.Campaign_Code = MCCAT.Campaign_Code INNER JOIN MST_MC_SPECIALITY MCSPL ON MCH.Campaign_Code = MCSPL.Campaign_Code WHERE DATE('\(dcrActualDate)') BETWEEN MCH.Effective_From AND MCH.Effective_To AND MCRT.Region_Type_Code = '\(regionTypeCode)' AND MCCAT.Customer_Category_Code= '\(doctorCategoryCode)' AND MCSPL.Customer_Speciality_Code = '\(spltyCode)' GROUP BY MCH.Campaign_Code,MCH.Campaign_Name"
        print(query)
        try? dbPool.read { db in
            activityList = try MCHeaderModel.fetchAll(db, query)
        }
        return activityList
    }
    
    func insertBusinesStatus(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try BusinessStatusModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertCallObjective(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CallObjectiveModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getBusinessStatusByEntityType(businessStatusEntityType: Int) -> [BusinessStatusModel]
    {
        var statusList : [BusinessStatusModel] = []
        
        try? dbPool.read { db in
            statusList = try BusinessStatusModel.fetchAll(db, "SELECT * FROM \(MST_BUSINESS_STATUS) WHERE Entity_Type = ? ",arguments:[businessStatusEntityType])
        }
        return statusList
    }
    
    func getCallObjectiveByEntityType(entityType: Int) -> [CallObjectiveModel]
    {
        var statusList : [CallObjectiveModel] = []
        
        try? dbPool.read { db in
            statusList = try CallObjectiveModel.fetchAll(db, "SELECT * FROM \(MST_CALL_OBJECTIVE) WHERE Entity_Type = ? ",arguments:[entityType])
        }
        return statusList
    }
    
    func getDCRCallActivityForUpload(dcrId: Int,entityType: String) -> [DCRActivityCallType]
    {
        var statusList : [DCRActivityCallType] = []
        
        try? dbPool.read { db in
            statusList = try DCRActivityCallType.fetchAll(db, "SELECT * FROM \(TRAN_DCR_CALL_ACTIVITY) WHERE DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments:[dcrId])
        }
        return statusList
    }
    
    func getDCRMCActivityForUpload(dcrId: Int,entityType: String) -> [DCRMCActivityCallType]
    {
        var statusList : [DCRMCActivityCallType] = []
        
        try? dbPool.read { db in
            statusList = try DCRMCActivityCallType.fetchAll(db, "SELECT * FROM \(TRAN_DCR_MC_ACTIVITY) WHERE DCR_Id = ? AND Entity_Type = '\(entityType)'",arguments:[dcrId])
        }
        return statusList
    }
    
    func updateDCRInheritanceDoneForAccompanist(userCode: String, dcrId: Int, status: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ACCOMPANIST) SET Is_Customer_Data_Inherited = \(status) WHERE DCR_Id = \(dcrId) AND Acc_User_Code = '\(userCode)'")
    }
    
    func updateDCRInheritanceDoneForAccompanist(userCode: String, dcrCode: String, status: Int)
    {
        executeQuery(query: "UPDATE \(TRAN_DCR_ACCOMPANIST) SET Is_Customer_Data_Inherited = \(status) WHERE DCR_Code = '\(dcrCode)' AND Acc_User_Code = '\(userCode)'")
    }
    
    func insertRegionEntityCount(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try RegionEntityCount(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getRegionEntityCount(regionCode: String, entityType: String) -> Int
    {
        var count : Int = 0
        
        try? dbPool.read { db in
            count = try! Int.fetchOne(db, "SELECT COUNT(*) FROM \(MST_REGION_ENTITY_COUNT) WHERE Region_Code = ? AND Entity_Type = ?",arguments:[regionCode, entityType])!
        }
        
        return count
    }
    
    //MARK:-- Competitor Product
    func insertDCRCompetitorDetails(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DCRCompetitorDetailsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAllCompetitor(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try CompetitorModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertAllProductCompetitor(array : NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try ProductModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getCompetitorList() -> [CompetitorModel]
    {
        var competitorList : [CompetitorModel] = []
        
        try? dbPool.read { db in
            competitorList = try CompetitorModel.fetchAll(db, "SELECT * FROM \(MST_COMPETITOR_MAPPING)")
        }
        return competitorList
    }
    
    func getCompetitorProductList(competitorCode:Int) -> [ProductModel]
    {
        var competitorProductList : [ProductModel] = []
        
        try? dbPool.read { db in
            competitorProductList = try ProductModel.fetchAll(db, "SELECT * FROM \(MST_COMPETITOR_PRODUCT_MASTER) WHERE Competitor_Code = \(competitorCode)")
        }
        return competitorProductList
    }
    
    func insertDcrDetailedCompetitor(dict: NSDictionary)
    {
        try? dbPool.write({ db in
            try DCRCompetitorDetailsModel(dict: dict).insert(db)
        })
    }
    
    func getDcrDetailedCompetitorList(dcrId:Int,doctorVisitId: Int,productCode: String) -> [DCRCompetitorDetailsModel]
    {
        var competitorList : [DCRCompetitorDetailsModel] = []
        
        try? dbPool.read { db in
            competitorList = try DCRCompetitorDetailsModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_COMPETITOR_DETAILS) WHERE DCR_Doctor_Visit_Id = ? AND DCR_Id = ? AND  DCR_Product_Detail_Code = ?",arguments:[doctorVisitId,dcrId,productCode])
        }
        return competitorList
    }
    func updateDcrDetailedCompetitor(dcrDetailCompetitorObj:DCRCompetitorDetailsModel,competitorDetailId:Int)
    {
        let query = "UPDATE \(TRAN_DCR_COMPETITOR_DETAILS) SET Competitor_Name = '\(dcrDetailCompetitorObj.Competitor_Name!)',Competitor_Code = '\(dcrDetailCompetitorObj.Competitor_Code!)',Product_Name = '\(dcrDetailCompetitorObj.Product_Name!)',Product_Code = '\(dcrDetailCompetitorObj.Product_Code!)',Value = \(dcrDetailCompetitorObj.Value!), Probability = \(dcrDetailCompetitorObj.Probability!),Remarks = '\(dcrDetailCompetitorObj.Remarks!)' WHERE Competitor_Detail_Id = \(competitorDetailId)"
        executeQuery(query: query)
    }
    
    func deleteDCRDetailedCompetitor(competitorDetailId: Int)
    {
        try? dbPool.write({ db in
            if let rowValue = try DCRCompetitorDetailsModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_COMPETITOR_DETAILS) WHERE Competitor_Detail_Id = ?",arguments: [competitorDetailId])            {
                try! rowValue.delete(db)
            }
        })
    }
    
    func getDCRDetailedCompetitor(dcrId: Int) -> [DCRCompetitorDetailsModel]
    {
        var dcrDetaliCompetitorList: [DCRCompetitorDetailsModel] = []
        
        try? dbPool.read { db in
            dcrDetaliCompetitorList = try DCRCompetitorDetailsModel.fetchAll(db, "SELECT cd.*,dv.Doctor_Code FROM tran_DCR_Competitor_Details cd INNER JOIN tran_DCR_Doctor_Visit dv ON cd.DCR_Doctor_Visit_Id = dv.DCR_Doctor_Visit_Id WHERE cd.DCR_Id = ?", arguments: [dcrId])
        }
        
        return dcrDetaliCompetitorList
    }
    
    func getdetailCompetitorList(doctorVisitId:Int,productCode:String) -> [DCRCompetitorDetailsModel]
    {
        var dcrDetaliCompetitorList: [DCRCompetitorDetailsModel] = []
        
        try? dbPool.read { db in
            dcrDetaliCompetitorList = try DCRCompetitorDetailsModel.fetchAll(db, "SELECT * FROM tran_DCR_Competitor_Details WHERE DCR_Doctor_Visit_Id = ? AND DCR_Product_Detail_Code = ?", arguments: [doctorVisitId,productCode])
        }
        
        return dcrDetaliCompetitorList
    }
    
    func getEdetailedDoctor(customerCode:String,regionCode:String,date:String) -> Int
    {
        var count = 0
        
        try? dbPool.read { db in
            count = try! Int.fetchOne(db, "SELECT COUNT(1) FROM tran_Asset_Analytics_Details WHERE DATE(Detailed_DateTime) = DATE('\(date)') AND Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)'")!
        }
        
        return count
    }
    
    func getEdetailingSyncedDateAndTime(customerCode: String,regionCode:String,dcrActualDate: String) -> String
    {
        var dcrEdetailDetail = String()
        
        let query = "SELECT Synced_Date_Time FROM \(TRAN_ED_DOCTOR_LOCATION_INFO) WHERE Customer_Code = '\(customerCode)' AND Customer_Region_Code = '\(regionCode)' AND DATE(DCR_Actual_Date) = DATE('\(dcrActualDate)')"
        try? dbPool.read { db in
            dcrEdetailDetail = try! String.fetchOne(db, query)!
        }
        
        return dcrEdetailDetail
    }
    
    //MARK:-- Sample Product Batch Mapping
    
    func getBatchFromProductCode(productCode:String,dcrDate:String) -> [SampleBatchMapping]
    {
        var sampleBatchList: [SampleBatchMapping] = []
        
        try? dbPool.read { db in
            sampleBatchList = try SampleBatchMapping.fetchAll(db, "SELECT * FROM \(MST_SAMPLE_BATCH_MAPPING) WHERE Product_Code = ? AND DATE('\(dcrDate)') BETWEEN DATE(Batch_Effective_From) AND DATE(Batch_Effective_To)", arguments: [productCode])
        }
        
        return sampleBatchList
    }
    
    func getBatchSampleProducts(dateString:String) -> [SampleBatchMapping]!
    {
        var sampleBatchList: [SampleBatchMapping] = []
        
        try? dbPool.read { db in
            sampleBatchList = try SampleBatchMapping.fetchAll(db ,"SELECT * FROM \(MST_SAMPLE_BATCH_MAPPING) WHERE DATE('\(dateString)') BETWEEN DATE(Effective_From) AND DATE(Effective_To)")
        }
        return sampleBatchList
    }
    
    func getDCRSampleBatchProducts(dcrId: Int, visitId: Int,entityType: String) -> [DCRSampleBatchModel]
    {
        var dcrSampleList : [DCRSampleBatchModel] = []
        try? dbPool.read { db in
            dcrSampleList = try DCRSampleBatchModel.fetchAll(db, "SELECT \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).* FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) INNER JOIN \(MST_SAMPLE_BATCH_MAPPING) ON \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Product_Code = \(MST_SAMPLE_BATCH_MAPPING).Product_Code AND \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Batch_Number = \(MST_SAMPLE_BATCH_MAPPING).Batch_Number WHERE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).DCR_Id = ? AND Visit_Id = ? AND Entity_Type = ?",arguments:[dcrId,visitId,entityType])
        }
        
        return dcrSampleList
        //TRAN_DCR_CHEMIST_SAMPLE_PROMOTION
        //TRAN_DCR_SAMPLE_DETAILS
    }
    
    func getDCRSampleBatchProducts(dcrId: Int, visitId: Int,productCode: String,sampleId:Int) -> [DCRSampleBatchModel]
    {
        var dcrSampleList : [DCRSampleBatchModel] = []
        
        try? dbPool.read { db in
            dcrSampleList = try DCRSampleBatchModel.fetchAll(db, "SELECT \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).* FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) INNER JOIN \(MST_SAMPLE_BATCH_MAPPING) ON \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Product_Code = \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Product_Code AND \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Batch_Number = \(MST_SAMPLE_BATCH_MAPPING).Batch_Number WHERE \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).DCR_Id = ? AND Visit_Id = ? AND \(TRAN_DCR_SAMPLE_DETAILS_MAPPING).Product_Code = ? AND Ref_Id = ?",arguments:[dcrId,visitId,productCode,sampleId])
        }
        
        return dcrSampleList
        
    }
    
    func deleteDCRSampleBatchDetails(dcrId: Int, visitId: Int,entityType: String)
    {
        
        try? dbPool.write({ db in
            if let rowValue = try DCRSampleBatchModel.fetchOne(db, "DELETE FROM \(TRAN_DCR_SAMPLE_DETAILS_MAPPING) WHERE DCR_Id = ? AND Visit_Id = ? AND Entity_Type = ?", arguments: [dcrId, visitId,entityType])
            {
                try! rowValue.delete(db)
            }
            
        })
    }
    
    func insertDCRSampleBatchProducts(sampleList : [DCRSampleBatchModel])
    {
        try? dbPool.writeInTransaction{ db in
            
            for sampleObj in sampleList
            {
                try sampleObj.insert(db)
            }
            return .commit
        }
    }
    
    func getUserProductMinMaxCount(productCode:String) -> UserProductMapping
    {
        var userProduct: UserProductMapping?
        
        try? dbPool.read { db in
            userProduct = try UserProductMapping.fetchOne(db, "SELECT * FROM \(MST_USER_PRODUCT) WHERE Product_Code  = ? ", arguments: [productCode])
        }
        
        return userProduct!
    }
    
    //MARK:- DPM
    func insertAllMCDetails(array:NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try MCAllDetailsModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func insertDivisionMappingDetails(array:NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try DivisionMappingDetails(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    func getMCAllList(refType: String,refCode: String) -> [MCAllDetailsModel]
    {
        var mcList: [MCAllDetailsModel] = []
        
        
        try? dbPool.read { db in
            mcList = try MCAllDetailsModel.fetchAll(db, "SELECT MH.Campaign_Name,MH.Campaign_Code from \(MST_MC_DETAILS) MCD INNER JOIN \(MST_MC_HEADER) MH ON MH.Campaign_Code = MCD.Campaign_Code WHERE MCD.Ref_Type = '\(refType)' AND MCD.Ref_Code = '\(refCode)' AND DATE(MH.Effective_From) <= DATE('now','localtime') AND DATE(MH.Effective_To) >= DATE('now','localtime') GROUP BY MH.Campaign_Code", arguments: [])
        }
        
        
        return mcList
    }
    
    func getDoctorProductMappingList(regionCode: String,refType: String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Mapped_Region_Code = ? AND Ref_Type = ?",arguments:[regionCode,refType])
        }
        
        return doctorMappingObj
    }
    
    func getDoctorProductMappingListUsingCustomerCode(mappedRegionCode: String,refType: String,customerCode:String,customerRegionCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Region_Code = ? AND Mapped_Region_Code = ? AND Customer_Code = ? AND Ref_Type = ? GROUP BY Product_Code",arguments:[customerRegionCode,mappedRegionCode,customerCode,refType])
        }
        
        return doctorMappingObj
    }
    
    func getDPMProductList(mappedRegionCode: String,refType: String,customerRegionCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) INNER JOIN \(MST_CUSTOMER_MASTER)  WHERE mst_Doctor_Product_Mapping.Customer_Code = mst_Customer_Master.Customer_Code  AND mst_Doctor_Product_Mapping.Mapped_Region_Code = ? AND  mst_Doctor_Product_Mapping.Ref_Type = ? AND mst_Doctor_Product_Mapping.Customer_Region_Code = ? GROUP BY Product_Code",arguments:[mappedRegionCode,refType,customerRegionCode])
        }
        
        return doctorMappingObj
    }
    
    func getMappedCustomerList(refType:String,mappedRegion:String,selectedRegion:String,customerCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Customer_Code = ? AND Customer_Region_Code = ? AND Ref_Type = ? AND Mapped_Region_Code = ? GROUP BY Product_Code",arguments:[customerCode,selectedRegion,refType,mappedRegion])
        }
        
        return doctorMappingObj
    }
    
    func getMappedProductList(refType:String,mappedRegion:String,selectedRegion:String,productCode:String) -> [DoctorProductMappingModel]
    {
        
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE Product_Code = ? AND Mapped_Region_Code = ? AND Ref_Type = ? AND Selected_Region_Code = ? GROUP BY Customer_Code, Customer_region_Code",arguments:[productCode,mappedRegion,refType,selectedRegion])
        }
        
        return doctorMappingObj
        
    }
    
    func getMappedCampaignCustomerList(refType:String,mappedRegion:String,selectedRegion:String,mcCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE MC_Code = ? AND Selected_Region_Code = ? AND Ref_Type = ? AND Mapped_Region_Code = ? GROUP BY Customer_Code",arguments:[mcCode,selectedRegion,refType,mappedRegion])
        }
        
        return doctorMappingObj
    }
    
    func getMappedCampaignProductList(refType:String,mappedRegion:String,selectedRegion:String,mcCode:String) -> [DoctorProductMappingModel]
    {
        
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) INNER JOIN \(MST_CUSTOMER_MASTER) WHERE \(MST_CUSTOMER_MASTER).Customer_Code = \(MST_DOCTOR_PRODUCT_MAPPING).Customer_Code AND \(MST_DOCTOR_PRODUCT_MAPPING).Mapped_Region_Code = ? AND \(MST_DOCTOR_PRODUCT_MAPPING).Ref_Type = ? AND \(MST_DOCTOR_PRODUCT_MAPPING).MC_Code = ? AND \(MST_DOCTOR_PRODUCT_MAPPING).Selected_Region_Code = ?",arguments:[mappedRegion,refType,mcCode,selectedRegion])
        }
        
        return doctorMappingObj
    }
    
    func getMappedCampaignCustomerListUsingCustomerRegion(refType:String,mappedRegion:String,selectedRegion:String,mcCode:String,customerCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE MC_Code = ? AND Customer_Region_Code = ? AND Ref_Type = ? AND Mapped_Region_Code = ? AND Customer_Code = ?",arguments:[mcCode,selectedRegion,refType,mappedRegion,customerCode])
        }
        
        return doctorMappingObj
    }
    
    func getMappedCampaignProductListUsingCustomerRegion(refType:String,mappedRegion:String,selectedRegion:String,mcCode:String,productCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE MC_Code = ? AND Selected_Region_Code = ? AND Ref_Type = ? AND Mapped_Region_Code = ? AND Product_Code = ? GROUP BY Customer_Code,Customer_Region_Code",arguments:[mcCode,selectedRegion,refType,mappedRegion,productCode])
        }
        
        return doctorMappingObj
    }
    
    func getExistingDPMProductList(mappedRegionCode: String,refType: String,customerRegionCode:String,productCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) INNER JOIN \(MST_CUSTOMER_MASTER)  WHERE mst_Doctor_Product_Mapping.Customer_Code = mst_Customer_Master.Customer_Code  AND mst_Doctor_Product_Mapping.Mapped_Region_Code = ? AND  mst_Doctor_Product_Mapping.Ref_Type = ? AND mst_Doctor_Product_Mapping.Selected_Region_Code = ? AND mst_Doctor_Product_Mapping.Product_Code = ?",arguments:[mappedRegionCode,refType,customerRegionCode,productCode])
        }
        
        return doctorMappingObj
    }
    
    func getMCCampaignData(campaignCode:String)-> [MCHeaderModel]
    {
        var mcDataList: [MCHeaderModel] = []
        
        try? dbPool.read { db in
            mcDataList = try MCHeaderModel.fetchAll(db, "SELECT * FROM \(MST_MC_HEADER) WHERE Campaign_Code = ? GROUP BY Campaign_Code",arguments:[campaignCode])
        }
        
        return mcDataList
    }
    
    func getMappedRoleCampaignCustomerList(refType:String,mappedRegion:String,mcCode:String) -> [DoctorProductMappingModel]
    {
        var doctorMappingObj: [DoctorProductMappingModel] = []
        
        try? dbPool.read { db in
            doctorMappingObj = try DoctorProductMappingModel.fetchAll(db, "SELECT * FROM \(MST_DOCTOR_PRODUCT_MAPPING) WHERE MC_Code = ? AND Ref_Type = ? AND Mapped_Region_Code = ? GROUP BY Customer_Code",arguments:[mcCode,refType,mappedRegion])
        }
        
        return doctorMappingObj
    }
}

