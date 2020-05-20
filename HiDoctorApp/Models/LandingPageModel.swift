//
//  LandingPageModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 12/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class LandingPageModel: NSObject
{
    var title:String = ""
    var titleImg : String = ""
    var titleId = 0
    
    func getMenuForId(id : Int) -> LandingPageModel
    {
        let titleObj  = LandingPageModel()
        
        switch id
        {
        case 0:
            titleObj.title =  PEV_DAILY_CALL_REPORT   //"Daily Call Report"
            titleObj.titleImg = "ic_DCR_Unselected"
            titleObj.titleId = 0
            break
        case 1:
            titleObj.title = "Approval"
            titleObj.titleImg = "icon-LandingApproval-Unselected"
            titleObj.titleId = 1
            break
        case 2:
            titleObj.title = TOUR_PLAN
            titleObj.titleImg = "ic_TP_Unselected"
            titleObj.titleId = 2
            break
        case 3:
            titleObj.title = "DashBoard"
            titleObj.titleImg = "ic_Dashboard_Unselected"
            titleObj.titleId = 3
            break
        case 4:
            titleObj.title = "Work History"
            titleObj.titleImg = "ic_report_Unselected"
            titleObj.titleId = 4
            break
        case 5:
            titleObj.title = PEV_UPLOAD_MY_DCR
            titleObj.titleImg = "ic_Upload_Unselected"
            titleObj.titleId = 5
            break
        case 6:
            titleObj.title = "More"
            titleObj.titleImg = "ic_more_Unselected"
            titleObj.titleId = 6
            break
        case 7:
            titleObj.title = PEV_DOCTOR // "Doctors/Customers"
            titleObj.titleImg = "ic_Doctor_Unselected"
            titleObj.titleId = 7
            break
        case 8:
            titleObj.title = "Master Data Download"
            titleObj.titleImg = "ic_master_dwld_unselected"
            titleObj.titleId = 8
            break
        case 9:
            //            titleObj.title = "Digital Assets"
            //            titleObj.titleImg = "ic_dig_assets_Unselected"
            titleObj.title = "Alerts"
            titleObj.titleImg = "ic_notice_board"
            titleObj.titleId = 9
            break
        case 10:
            titleObj.title = "Manage Accompanist data"
            titleObj.titleImg = "ic_man_accomp_Unselected"
            titleObj.titleId = 10
            break
        case 11:
            titleObj.title = "Help"
            titleObj.titleImg = "ic_man_accomp_Unselected"
            titleObj.titleId = 11
            break
        case 12:
            titleObj.title = "Notes Diary"
            titleObj.titleImg = "notes"
            titleObj.titleId = 12
            break
        default:
            titleObj.title = PEV_DAILY_CALL_REPORT//"Daily Call Report"
            titleObj.titleImg = "ic_DCR_Unselected"
            titleObj.titleId = 0
            break
        }
        return titleObj
    }
    
    func getMenuListForWithoutEDManager_Mobile() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,7,2,4,1,5,3,6]
        let indexList = [0,2,1,3,7,5,9,8,12,6] //DCR,TP,Approval,Dashboard,Reports,Upload DCR,Alerts,More
        
        for index in indexList{
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    func getMenuListForWithoutEDManager_MobileNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,7,2,4,1,5,3,6]
       // let indexList = [0,2,1,12,7,5,9,6] //DCR,TP,Approval,Dashboard,Reports,Upload DCR,Alerts,More
        let indexList = [0,2,1,3,7,5,9,8,12,6]
        for index in indexList{
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDManager_Mobile() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,7,2,9,1,5,3,6]
        let indexList = [0,2,1,3,7,5,9,8,12,6] //DCR,TP,Approval,Dashboard,Doctor/Customer,Upload DCR,Alerts,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    func getMenuListForWithEDManager_MobileNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,7,2,9,1,5,3,6]
       // let indexList = [0,2,1,12,7,5,9,6] //DCR,TP,Approval,Dashboard,Doctor/Customer,Upload DCR,Alerts,More
        let indexList = [0,2,1,3,7,5,9,8,12,6] //DCR,TP,Approval,Dashboard,Doctor/Customer,Upload DCR,Alerts,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    func getMenuListForWithoutEDRep_Mobile() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,8,3,6]
        let indexList = [0,2,7,3,4,5,9,8,12,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    func getMenuListForWithoutEDRep_MobileNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,8,3,6]
        //let indexList = [0,2,7,12,4,5,9,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        let indexList = [0,2,7,3,4,5,9,8,12,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDRep_Mobile() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,9,3,6]
        let indexList = [0,2,7,3,4,5,9,8,12,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        
        for index in indexList{
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDRep_MobileNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,9,3,6]
       // let indexList = [0,2,7,12,4,5,9,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        let indexList = [0,2,7,3,4,5,9,8,12,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        for index in indexList{
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithoutEDManager_IPad() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,1,8,7,10,3,6]
        let indexList = [0,2,1,7,12,3,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDManager_IPad() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,1,8,7,9,3,6]
        let indexList = [0,2,1,7,3,12,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithoutEDRep_IPad() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,8,3,6]
        let indexList = [0,2,7,3,4,5,9,12,8,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDRep_IPad() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,9,3,6]
        let indexList = [0,2,7,3,12,5,9,4,8,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithoutEDManager_IPadNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,1,8,7,10,3,6]
        //let indexList = [0,2,1,7,12,4,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        let indexList = [0,2,1,7,12,3,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDManager_IPadNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,1,8,7,9,3,6]
       // let indexList = [0,2,1,7,12,4,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        let indexList = [0,2,1,7,12,3,5,9,8,6] //DCR,TP,Approval,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,Master data download,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithoutEDRep_IPadNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,8,3,6]
       // let indexList = [0,2,7,12,4,5,9,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        let indexList = [0,2,7,3,12,4,5,9,8,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
    
    func getMenuListForWithEDRep_IPadNotes() -> [LandingPageModel]
    {
        var landingList = [LandingPageModel]()
        
        //        let indexList = [0,4,2,5,7,9,3,6]
        //let indexList = [0,2,7,12,4,5,9,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        let indexList = [0,2,7,3,4,5,9,12,8,6] //DCR,TP,Doctor/Customer,Dashboard,Reports,Upload DCR,Alerts,More
        for index in indexList
        {
            landingList.append(getMenuForId(id: index))
        }
        
        return landingList
    }
}

class MoreListHeaderModel : NSObject
{
    var sectionTitle : String = ""
    var dataList : [MoreListDescriptionModel] = []
}

class MoreListDescriptionModel : NSObject
{
    var stoaryBoardName : String = ""
    var viewControllerIdentifier : String = ""
    var icon : String = ""
    var descriptionTxt : String = ""
    var menuId = 0
    var displayId = 0
}

class LandingDataManager : NSObject
{
    var displayedArrayList : [LandingPageModel] = []
    var displayMenuList = [Int]()
    
    static let sharedManager : LandingDataManager =
    {
        let instance = LandingDataManager()
        return instance
    }()
}

class LandingAlertModel
{
    var index: Int!
    var alertTitle: String!
    var imageName: String!
    var count: Int!
}

class MasterDataDownloadCheckModel: Record
{
    var API_Check_Date : Date!
    var Skip_Count: Int!
    var Completed_Status: Int!
    
    init(dict : NSDictionary)
    {
        let checkDate = dict.value(forKey: "API_Check_Date") as! String
        let dateArray = checkDate.components(separatedBy: " ")
        self.API_Check_Date = getStringInFormatDate(dateString: dateArray[0])
        self.Skip_Count = dict.value(forKey: "Skip_Count") as? Int ?? 0
        self.Completed_Status = dict.value(forKey: "Completed_Status") as? Int ?? 0
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO
    }
    
    required init(row: Row)
    {
        API_Check_Date = row["API_Check_Date"]
        Skip_Count = row["Skip_Count"]
        Completed_Status = row["Completed_Status"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["API_Check_Date"] = API_Check_Date
        container["Skip_Count"] = Skip_Count
        container["Completed_Status"] = Completed_Status
    }
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        return [
    //            "API_Check_Date" :API_Check_Date,
    //            "Skip_Count":Skip_Count,
    //            "Completed_Status":Completed_Status
    //        ]
    //    }
    
}
