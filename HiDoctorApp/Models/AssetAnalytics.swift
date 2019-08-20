//
//  AssetAnalytics.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class AssetAnalytics: Record
{
    var id: Int!
    var daCode: Int!
    var playedTimeDuration: Int!
    var playedDateTime: Date!
    var timeZone: String!
    var isPreview: Int!
    var isSynced: Int!
    var syncedDateTime: Date!
    var customerCode: String!
    var customerName: String!
    var customerRegionCode: String!
    var customerMdlNo: String!
    var customerSpecialityCode: String!
    var customerSpecialityName: String!
    var customerCategoryCode: String!
    var customerCategoryName: String!
    var daName: String?
    var docType: Int!
    var playMode: Int!
    var like: Int!
    var rating: Int!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        
        if let duration = dict.value(forKey: "Played_Time_Duration") as? Int
        {
            self.playedTimeDuration = duration
        }
        else
        {
            self.playedTimeDuration = 0
        }
        
        self.playedDateTime = getStringInFormatDate(dateString: dict.value(forKey: "Played_DateTime") as! String)
        
        if let getTimeZone = dict.value(forKey: "Time_Zone") as? String
        {
            self.timeZone = getTimeZone
        }
        else
        {
            self.timeZone = ""
        }
        
        self.isPreview = dict.value(forKey: "Is_Preview") as! Int
        self.isSynced = dict.value(forKey: "Is_Synced") as! Int
        self.syncedDateTime = getStringInFormatDate(dateString: dict.value(forKey: "Synced_DateTime") as! String)
        self.customerCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.customerName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name") as? String)
        self.customerRegionCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_RegionCode") as? String)
        self.customerMdlNo = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_MDLNo") as? String)
        self.customerSpecialityCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_SpecialityCode") as? String)
        self.customerSpecialityName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_SpecialityName") as? String)
        
        if let catCode = dict.value(forKey: "Customer_CategoryCode") as? String
        {
            self.customerCategoryCode = catCode
        }
        else
        {
            self.customerCategoryCode = ""
        }
        
        if let catName = dict.value(forKey: "Customer_CategoryName") as? String
        {
            self.customerCategoryName = catName
        }
        else
        {
            self.customerCategoryName = ""
        }
        
        if let playMode = dict.value(forKey: "PlayMode") as? Int
        {
            self.playMode = playMode
        }
        else
        {
            self.playMode = 0
        }
        
        if let like = dict.value(forKey: "Like") as? Int
        {
            self.like = like
        }
        else
        {
            self.like = 0
        }
        
        if let rating = dict.value(forKey: "Rating") as? Int
        {
            self.rating = rating
        }
        else
        {
            self.rating = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_ASSET_ANALYTICS_SUMMARY
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        daCode = row["DA_Code"]
        playedTimeDuration = row["Played_Time_Duration"]
        playedDateTime = row["Played_DateTime"]
        timeZone = row["Time_Zone"]
        isPreview = row["Is_Preview"]
        isSynced = row["Is_Synced"]
        syncedDateTime = row["Synced_DateTime"]
        customerCode = row["Customer_Code"]
        customerName = row["Customer_Name"]
        customerMdlNo = row["Customer_MDL_Number"]
        customerRegionCode = row["Customer_Region_Code"]
        customerSpecialityCode = row["Customer_Speciality_Code"]
        customerSpecialityName = row["Customer_Speciality_Name"]
        customerCategoryCode = row["Customer_Category_Code"]
        customerCategoryName = row["Customer_Category_Name"]
        daName = row["DA_Name"]
        docType = row["Doc_Type"]
        playMode = row["PlayMode"]
        like = row["Like"]
        rating = row["Rating"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["DA_Code"] = daCode
        container["Played_Time_Duration"] = playedTimeDuration
        container["Played_DateTime"] = playedDateTime
        container["Time_Zone"] = timeZone
        container["Is_Preview"] = isPreview
        container["Is_Synced"] = isSynced
        container["Synced_DateTime"] = syncedDateTime
        container["Customer_Code"] = customerCode
        container["Customer_Name"] = customerName
        container["Customer_MDL_Number"] = customerMdlNo
        container["Customer_Region_Code"] = customerRegionCode
        container["Customer_Speciality_Code"] = customerSpecialityCode
        container["Customer_Speciality_Name"] = customerSpecialityName
        container["Customer_Category_Code"] = customerCategoryCode
        container["Customer_Category_Name"] = customerCategoryName
        container["DA_Name"] = daName
        container["Doc_Type"] = docType
        container["PlayMode"] = playMode
        container["Like"] = like
        container["Rating"] = rating
    }
    
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        let dict1: [String : DatabaseValueConvertible?] = [
    //            "Id": id,
    //            "DA_Code": daCode,
    //            "Played_Time_Duration": playedTimeDuration,
    //            "Played_DateTime": playedDateTime,
    //            "Time_Zone": timeZone,
    //            "Is_Preview": isPreview,
    //            "Is_Synced": isSynced,
    //            "Synced_DateTime": syncedDateTime
    //        ]
    //        let dict2 : [String : DatabaseValueConvertible?] = [
    //            "Customer_Code": customerCode,
    //            "Customer_Name": customerName,
    //            "Customer_MDL_Number": customerMdlNo,
    //            "Customer_Region_Code": customerRegionCode,
    //            "Customer_Speciality_Code": customerSpecialityCode,
    //            "Customer_Speciality_Name": customerSpecialityName,
    //            "Customer_Category_Code": customerCategoryCode,
    //            "Customer_Category_Name": customerCategoryName
    //        ]
    //
    //        let dict3: [String : DatabaseValueConvertible?] = [
    //            "DA_Name": daName,
    //            "Doc_Type": docType,
    //            "PlayMode": playMode,
    //            "Like": like,
    //            "Rating": rating
    //        ]
    //
    //        var combinedAttributes : NSMutableDictionary!
    //
    //        combinedAttributes = NSMutableDictionary(dictionary: dict1)
    //
    //        combinedAttributes.addEntries(from: dict2)
    //
    //        combinedAttributes.addEntries(from: dict3)
    //
    //        return combinedAttributes as! [String : DatabaseValueConvertible?]
    //    }
}

class AssetAnalyticsDetail: Record
{
    var Asset_Id: Int!
    var DA_Code: Int!
    var Part_Id: Int!
    var Part_URL: String!
    var Session_Id : Int!
    var Detailed_DateTime: String!
    var Detailed_StartTime : String!
    var Detailed_EndTime : String!
    var Player_StartTime : String!
    var Player_EndTime : String!
    var Played_Time_Duration : Int!
    var Time_Zone: String!
    var Is_Preview: Int!
    var Is_Synced: Int!
    var Synced_DateTime: Date!
    var Customer_Code: String!
    var Customer_Name: String!
    var Customer_Region_Code: String!
    var Customer_Speciality_Code: String!
    var Customer_Speciality_Name: String!
    var Customer_Category_Code: String?
    var Customer_Category_Name: String?
    var MDL_Number : String?
    var Local_Area: String?
    var Sur_Name: String?
    var PlayMode : String!
    var Like : Int!
    var Rating : Int!
    var Latitude : String!
    var Longitude : String!
    var Da_Name : String!
    var Doc_Type : Int!
    var Total_played_Time_Duration : Int!
    var Total_Viewed_Pages : Int!
    var Total_Unique_Pages_Count : Int!
    var Customer_Detailed_Id : Int!
    var UD_Story_Id: NSNumber!
    var MC_Story_Id: NSNumber!
    var Punch_Start_Time: String?
    var Punch_End_Time: String?
    var Punch_Status: Int?
    var Punch_Offset: String?
    var Punch_TimeZone: String?
    var Punch_UTC_DateTime: String?
    var Hospital_Name: String!
   // var Hospital_Account_Number : String!
    
    init(dict: NSDictionary)
    {
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Part_Id = dict.value(forKey: "Part_Id") as! Int
        self.Part_URL = checkNullAndNilValueForString(stringData: dict.value(forKey: "Part_URL") as? String)
        self.Session_Id = dict.value(forKey:"SessionId") as! Int
        self.Detailed_DateTime = dict.value(forKey : "Detailed_DateTime") as! String
        self.Detailed_StartTime = checkNullAndNilValueForString(stringData: dict.value(forKey : "Detailed_StartTime") as? String)
        if let detailedEndDate = dict.value(forKey: "Detailed_EndTime") as? String
        {
            self.Detailed_EndTime = detailedEndDate
        }
        self.Player_StartTime = checkNullAndNilValueForString(stringData:  dict.value(forKey : "Player_Start_Time") as? String)
        self.Player_EndTime = checkNullAndNilValueForString(stringData: dict.value(forKey : "Player_End_Time") as? String)
        if let playedTime = dict.value(forKey : "Played_Time_Duration") as? Int
        {
            self.Played_Time_Duration = playedTime
        }
        
        self.Time_Zone = getCurrentTimeZone()
        self.Is_Preview =  dict.value(forKey: "isPreview") as! Int
        if let getVal = dict.value(forKey: "Is_Synced")
        {
            self.Is_Synced = getVal as! Int
        }
        else
        {
            self.Is_Synced = 1
        }
        if let syncTime =  dict.value(forKey: "Synced_DateTime") as? Date
        {
            self.Synced_DateTime = syncTime
        }
        
        if let playMode = dict.value(forKey: "PlayMode") as? Int
        {
            self.PlayMode = String(playMode)
        }
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Customer_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Name") as? String)
        self.Customer_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Region_Code") as? String)
        self.Customer_Speciality_Code = checkNullAndNilValueForString(stringData:  dict.value(forKey: "Customer_Speciality_Code") as? String)
        self.Customer_Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Speciality_Name") as? String)
        self.Customer_Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Category_Code") as? String)
        self.Customer_Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Category_Name") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
      //  self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey : "Hospital_Account_Number") as? String)
        self.Like = dict.value(forKey: "Like") as? Int
        self.Rating = dict.value(forKey: "Rating") as? Int
        self.UD_Story_Id = 0
        self.MC_Story_Id = dict.value(forKey: "MC_Story_Id") as? NSNumber ?? 0
        self.Punch_Start_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_Start_Time") as? String)
        self.Punch_End_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_End_Time") as? String)
        self.Punch_Offset = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_Offset") as? String)
        self.Punch_TimeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_TimeZone") as? String)
        self.Punch_UTC_DateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_UTC_DateTime") as? String)
        if let punch = dict.value(forKey: "Punch_Status") as? Int
        {
            self.Punch_Status = punch
        }
        else
        {
            self.Punch_Status = 0
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_ASSET_ANALYTICS_DETAILS
    }
    
    required init(row: Row)
    {
        Asset_Id = row["Asset_Id"]
        DA_Code = row["DA_Code"]
        Part_Id = row["Part_Id"]
        Part_URL = row["Part_URL"]
        Session_Id = row["Session_Id"]
        Detailed_DateTime = row["Detailed_DateTime"]
        Detailed_StartTime  = row["Detailed_StartTime"]
        Detailed_EndTime = row["Detailed_EndTime"]
        Player_StartTime = row["Player_StartTime"]
        Player_EndTime = row["Player_EndTime"]
        Played_Time_Duration = row["Played_Time_Duration"]
        Time_Zone = row["Time_Zone"]
        Is_Preview = row["Is_Preview"]
        Is_Synced = row["Is_Synced"]
        Synced_DateTime = row["Synced_DateTime"]
        Customer_Code = row["Customer_Code"]
        Customer_Name = row["Customer_Name"]
        Customer_Region_Code = row["Customer_Region_Code"]
        Customer_Speciality_Code = row["Customer_Speciality_Code"]
        Customer_Speciality_Name = row["Customer_Speciality_Name"]
        Customer_Category_Code = row["Customer_Category_Code"]
        Customer_Category_Name = row["Customer_Category_Name"]
        Local_Area = row["Local_Area"]
        Sur_Name = row["Sur_Name"]
        PlayMode = row["PlayMode"]
        Like = row["Like"]
        Rating = row["Rating"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Da_Name = row["Da_Name"]
        Doc_Type = row["DA_Type"]
        Total_Viewed_Pages = row["Total_Viewed_Pages"]
        Total_Unique_Pages_Count = row["Total_Unique_Pages_Count"]
        Total_played_Time_Duration = row["Total_played_Time_Duration"]
        MDL_Number = row["MDL_Number"]
        Customer_Detailed_Id = row["Customer_Detailed_Id"]
        UD_Story_Id = row["UD_StoryID"]
        MC_Story_Id = row["MC_StoryID"]
        Hospital_Name = row["Hospital_Name"]
      //  Hospital_Account_Number = row["Hospital_Account_Number"]

        Punch_Status = row["Punch_Status"]
        Punch_UTC_DateTime =  row["Punch_UTC_DateTime"]
        Punch_TimeZone = row["Punch_TimeZone"]
        Punch_Start_Time = row["Punch_Start_Time"]
        Punch_End_Time = row["Punch_End_Time"]
        Punch_Offset =  row["Punch_Offset"]

        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Asset_Id"] = Asset_Id
        container["DA_Code"] = DA_Code
        container["DA_Type"] = Doc_Type
        container["Part_Id"] = Part_Id
        container["Part_URL"] = Part_URL
        container["Session_Id"] = Session_Id
        container["Detailed_DateTime"] = Detailed_DateTime
        container["Detailed_StartTime"] = Detailed_StartTime
        container["Detailed_EndTime"] = Detailed_EndTime
        container["Player_StartTime"] = Player_StartTime
        container["Player_EndTime"] = Player_EndTime
        container["Played_Time_Duration"] = Played_Time_Duration
        container["Time_Zone"] = Time_Zone
        container[ "Is_Preview"] = Is_Preview
        container[ "Is_Synced"] = Is_Synced
        container["Synced_DateTime"] = Synced_DateTime
        container["Customer_Code"] = Customer_Code
        container["Customer_Name"] = Customer_Name
        container["Customer_Region_Code"] = Customer_Region_Code
        container["Customer_Speciality_Code"] = Customer_Speciality_Code
        container["MDL_Number"] = MDL_Number
        container["Customer_Detailed_Id"] = Customer_Detailed_Id
        container["Customer_Speciality_Name"] = Customer_Speciality_Name
        container["Customer_Category_Code"] = Customer_Category_Code
        container["Customer_Category_Name"] = Customer_Category_Name
        container["Local_Area"] = Local_Area
        container["Sur_Name"] = Sur_Name
        container["PlayMode"] = PlayMode
        container["Like"] = Like
        container["Rating"] = Rating
        container["Latitude"] = Latitude
        container["Longitude"] = Longitude
        container["MC_StoryID"] = MC_Story_Id
        container["UD_StoryID"] = UD_Story_Id
        container["Hospital_Name"] = Hospital_Name

       // container["Hospital_Account_Number"] = Hospital_Account_Number

        container["Punch_Status"] = Punch_Status
        container["Punch_UTC_DateTime"] = Punch_UTC_DateTime
        container["Punch_TimeZone"] = Punch_TimeZone
        container["Punch_Start_Time"] = Punch_Start_Time
        container["Punch_End_Time"] = Punch_End_Time
        container["Punch_Offset"] = Punch_Offset

    }
    
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        let dict1: [String : DatabaseValueConvertible?] = [
    //            container["Asset_Id"] = Asset_Id
    //            "DA_Code"] = DA_Code
    //            "DA_Type"] = Doc_Type
    //            "Part_Id"] = Part_Id
    //            "Part_URL"] = Part_URL
    //            "Session_Id"] = Session_Id
    //            "Detailed_DateTime"] = Detailed_DateTime
    //            "Detailed_StartTime"] = Detailed_StartTime
    //            "Detailed_EndTime"] = Detailed_EndTime
    //            "Player_StartTime"] = Player_StartTime
    //            "Player_EndTime"] = Player_EndTime
    //            "Played_Time_Duration"] = Played_Time_Duration
    //            "Time_Zone"] = Time_Zone
    //            "Is_Preview"] = Is_Preview
    //            "Is_Synced"] = Is_Synced
    //            "Synced_DateTime"] = Synced_DateTime
    //            "Customer_Code"] = Customer_Code
    //            "Customer_Name"] = Customer_Name
    //            "Customer_Region_Code"] = Customer_Region_Code
    //            "Customer_Speciality_Code"] = Customer_Speciality_Code
    //            "MDL_Number"] = MDL_Number
    //            "Customer_Detailed_Id"] = Customer_Detailed_Id
    //            "Customer_Speciality_Name"] = Customer_Speciality_Name
    //            "Customer_Category_Code"] = Customer_Category_Code
    //            "Customer_Category_Name"] = Customer_Category_Name
    //            "Local_Area"] = Local_Area
    //            "Sur_Name"] = Sur_Name
    //            "PlayMode"] = PlayMode
    //            "Like"] = Like
    //            "Rating"] = Rating
    //            "Latitude"] = Latitude
    //            "Longitude"] = Longitude
    //            "MC_StoryID"] = MC_Story_Id
    //            "UD_StoryID"] = UD_Story_Id
    //            ]
    //        let dict2 : [String : DatabaseValueConvertible?] = [
    //            "Is_Synced":Is_Synced,
    //            "Synced_DateTime":Synced_DateTime,
    //            "Customer_Code":Customer_Code,
    //            "Customer_Name":Customer_Name,
    //            "Customer_Region_Code":Customer_Region_Code,
    //            "Customer_Speciality_Code":Customer_Speciality_Code,
    //            "MDL_Number":MDL_Number,
    //            "Customer_Detailed_Id":Customer_Detailed_Id
    //        ]
    //        
    //        let dict3 : [String : DatabaseValueConvertible?] = [
    //            "Customer_Speciality_Name":Customer_Speciality_Name,
    //            "Customer_Category_Code":Customer_Category_Code,
    //            "Customer_Category_Name":Customer_Category_Name,
    //            "Local_Area":Local_Area,
    //            "Sur_Name":Sur_Name,
    //            "PlayMode":PlayMode,
    //            "Like":Like,
    //            "Rating":Rating,
    //            "Latitude":Latitude,
    //            "Longitude":Longitude,
    //            "MC_StoryID": MC_Story_Id,
    //            "UD_StoryID": UD_Story_Id
    //        ]
    //        
    //        var combinedAttributes : NSMutableDictionary!
    //        
    //        combinedAttributes = NSMutableDictionary(dictionary: dict1)
    //        
    //        combinedAttributes.addEntries(from: dict2)
    //        combinedAttributes.addEntries(from: dict3)
    //        
    //        return combinedAttributes as! [String : DatabaseValueConvertible?]
    //    }
}
