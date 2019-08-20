//
//  DoctorFeedbackModel.swift
//  HiDoctorApp
//
//  Created by Admin on 7/28/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DoctorFeedbackModel: NSObject {

    var customerObj : CustomerMasterModel!
    var assetObj : AssetHeader!
}


class AssetFeedback : Record
{
    var id: Int!
    var regionCode: String!
    var customerCode: String!
    var userCode : String!
    var daCode: Int!
    var daType: Int!
    var rating: Int!
    var user_Like : Int!
    var feedBack : String!
    var is_Synced : Int!
    var timeZone : String
    var sourceOfEntry : Int!
    var updated_Date : Date!
    var updated_Date_Time : Date!
    
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        
        self.regionCode = dict.value(forKey: "Region_Code") as! String
        self.customerCode = dict.value(forKey: "Customer_Code") as! String
        self.userCode = dict.value(forKey: "User_Code") as! String
        self.daType = dict.value(forKey: "DA_Type") as? Int ?? 0
        self.rating = dict.value(forKey: "Rating") as? Int ?? 0
        self.user_Like = dict.value(forKey: "User_Like") as? Int ?? 0
        self.feedBack = checkNullAndNilValueForString(stringData: dict.value(forKey: "Feedback") as? String) 
        self.is_Synced = dict.value(forKey: "Is_Synced") as! Int
        self.timeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "Time_Zone") as? String)
        self.sourceOfEntry = Source_Of_Entry
        
         let startDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Current_Date") as? String)
        if startDate != "" {
        self.updated_Date = getStringInFormatDate(dateString: startDate)
        }
        
        let endDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Current_Datetime") as? String)
        if endDate != "" {
        self.updated_Date_Time = getDateAndTimeFormatWithoutMilliSecond(dateString: endDate)
        }
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TBL_EL_CUSTOMER_DA_FEEDBACK
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        daCode = row["DA_Code"]
        regionCode = row["Region_Code"]
        customerCode = row["Customer_Code"]
        userCode = row["User_Code"]
        daType = row["DA_Type"]
        rating = row["Rating"]
        user_Like = row["User_Like"]
        feedBack = row["Feedback"]
        is_Synced = row["Is_Synced"]
        timeZone = row["Time_Zone"]
        self.updated_Date = row["Updated_Date"]
        self.updated_Date_Time = row["Updated_Datetime"]
        self.sourceOfEntry = row["Source_Of_Entry"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["DA_Code"] = daCode
        container["Region_Code" ] = regionCode
        container["Customer_Code"] = customerCode
        container["User_Code"] = userCode
        container["DA_Type"] = daType
        container["Rating"] =  rating
        container["Source_Of_Entry"] = sourceOfEntry
        container["User_Like"] = user_Like
        container["Feedback"] = feedBack
        container["Is_Synced"] = is_Synced
        container["Time_Zone"] = timeZone
        container["Updated_Date"] = updated_Date
        container["Updated_Datetime"] = updated_Date_Time
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "DA_Code" : daCode,
//            "Region_Code" : regionCode ,
//            "Customer_Code" : customerCode ,
//            "User_Code" : userCode ,
//            "DA_Type" : daType,
//            "Rating" :  rating ,
//            "Source_Of_Entry" : sourceOfEntry,
//            "User_Like" : user_Like ,
//            "Feedback" : feedBack ,
//            "Is_Synced" : is_Synced ,
//            "Time_Zone" : timeZone ,
//            "Updated_Date" : updated_Date,
//            "Updated_Datetime" : updated_Date_Time
//        ]
//    }
}


class DoctorVisitFeedback : Record
{
    var id: Int!
    var userCode : String!
    var detailedDate : String!
    var customerCode: String!
    var customerRegionCode: String!
    var visitRating: Int!
    var VisitFeedBack : String!
    var is_Synced : Int!
    var timeZone : String
    var sourceOfEntry : Int!
    var updated_Date_Time : String!
    
    
    init(dict: NSDictionary)
    {
        self.customerCode = checkNullAndNilValueForString(stringData:dict.value(forKey: "Customer_Code") as? String)
        self.customerRegionCode = checkNullAndNilValueForString(stringData:dict.value(forKey: "Customer_Region_Code") as? String)
        self.userCode = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Code") as? String)
        self.visitRating = dict.value(forKey: "Visit_Rating") as? Int ?? 0
        self.VisitFeedBack = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Feedback") as? String)
        self.is_Synced = dict.value(forKey: "Is_Synced") as? Int ?? 0
        self.timeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "Time_Zone") as? String)
        self.sourceOfEntry = Source_Of_Entry
        self.detailedDate = checkNullAndNilValueForString(stringData: dict.value(forKey: "Detailed_Date") as? String)
        
        self.updated_Date_Time = checkNullAndNilValueForString(stringData:dict.value(forKey: "Current_Datetime") as? String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TBL_ED_DOCTOR_VISIT_FEEDBACK
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        customerRegionCode = row["Customer_Region_Code"]
        customerCode = row["Customer_Code"]
        userCode = row["User_Code"]
        visitRating = row["Visit_Rating"]
        VisitFeedBack = row["Visit_Feedback"]
        is_Synced = row["Is_Synced"]
        timeZone = row["Time_Zone"]
        self.updated_Date_Time = row["Updated_Datetime"]
        self.sourceOfEntry = row["Source_Of_Entry"]
        self.detailedDate = row["Detailed_Date"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["Customer_Region_Code"] = customerRegionCode
        container["Customer_Code"] = customerCode
        container["User_Code"] = userCode
        container["Visit_Rating"] =  visitRating
        container["Source_Of_Entry"] = sourceOfEntry
        container["Visit_Feedback"] = VisitFeedBack
        container["Is_Synced"] = is_Synced
        container["Time_Zone"] = timeZone
        container["Updated_Datetime"] = updated_Date_Time
        container["Detailed_Date"] = detailedDate
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "Customer_Region_Code" : customerRegionCode ,
//            "Customer_Code" : customerCode ,
//            "User_Code" : userCode ,
//            "Visit_Rating" :  visitRating ,
//            "Source_Of_Entry" : sourceOfEntry,
//            "Visit_Feedback" : VisitFeedBack ,
//            "Is_Synced" : is_Synced ,
//            "Time_Zone" : timeZone ,
//            "Updated_Datetime" : updated_Date_Time,
//            "Detailed_Date" : detailedDate
//        ]
//    }
}



