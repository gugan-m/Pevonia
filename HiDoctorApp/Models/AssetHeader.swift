//
//  AssetHeader.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class AssetHeader: Record
{
    var daCode: Int!
    var daName: String!
    var docType: Int!
    var isDownloadable: Int!
    var isViewable: Int = 0
    var isShareable: Int = 0
    var thumbnailUrl: String!
    var daSize: Float!
    var isDownloaded: Int!
    var daFileName: String!
    var startDate: Date!
    var endDate: Date!
    var daDesc: String!
    var noOfParts: Int!
    var duration: Int!
    var tagValue : String!
    var onlineUrl : String!
    var localUrl : String!
    var Html_Start_Page : String!
    var mc_StoryId = 0
    var ud_StoryId = 0
    var displayIndex = 1
    var Asset_Id: Int!
    var Total_Measure: String!
    var Measured_Unit: String!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        
        if let TotalMeasure = dict.value(forKey: "Total_Measure") as? String
               {
                   self.Total_Measure = TotalMeasure
               }
               else
               {
                   self.Total_Measure = ""
        }
        
        if let MeasuredUnit = dict.value(forKey: "Measured_Unit") as? String
               {
                   self.Measured_Unit = MeasuredUnit
               }
               else
               {
                   self.Measured_Unit = ""
        }
        if let name = dict.value(forKey: "DA_Name") as? String
        {
            self.daName = name
        }
        else
        {
            self.daName = ""
        }
        
        self.docType = dict.value(forKey: "DA_Type") as! Int
        self.isDownloadable = dict.value(forKey: "Is_Downloadable") as! Int
        if let thumbUrl = dict.value(forKey: "DA_Thumbnail_URL") as? String
        {
            self.thumbnailUrl = thumbUrl
        }
        else
        {
            self.thumbnailUrl = ""
        }
        
        if let size = dict.value(forKey: "DA_Size_In_MB") as? Float
        {
            self.daSize = size
        }
        else if let sizeDouble = dict.value(forKey: "DA_Size_In_MB") as? Double
        {
            self.daSize = Float(sizeDouble)
        }
        else
        {
            self.daSize = 0.0
        }
        
        if let downloadStatus = dict.value(forKey: "Is_Downloaded")
        {
            self.isDownloaded = downloadStatus as! Int
        }
        else
        {
            self.isDownloaded = 0
        }
        
        if let fileName = dict.value(forKey: "DA_FileName") as? String
        {
            self.daFileName = fileName
        }
        else
        {
            self.daFileName = ""
        }
        
        self.startDate = getStringInFormatDate(dateString: dict.value(forKey: "FromDate") as! String)
        self.endDate = getStringInFormatDate(dateString: dict.value(forKey: "ToDate") as! String)
        self.Html_Start_Page = checkNullAndNilValueForString(stringData: dict.value(forKey: "Html_Start_Page") as? String)
        
        if let desc = dict.value(forKey: "DA_Description") as? String
        {
            self.daDesc = desc
        }
        else
        {
            self.daDesc = ""
        }
        
        if let numberOfParts = dict.value(forKey: "Number_Of_Parts") as? Int
        {
            self.noOfParts = numberOfParts
        }
        else
        {
            self.noOfParts = 0
        }
        
        if let durationInSeconds = dict.value(forKey: "Total_Duration_in_Seconds") as? Int
        {
            self.duration = durationInSeconds
        }
        else
        {
            self.duration = 0
        }
        
//        self.onlineUrl = checkNullAndNilValueForString(stringData: dict.value(forKey: "onlineUrl") as? String)
        
        if let onlineUrl = dict.value(forKey: "DA_Online_URL") as? String
        {
            self.onlineUrl = onlineUrl
        }
        else
        {
            self.onlineUrl = ""
        }
        
//        if let offlineUrl = dict.value(forKey: "DA_Offline_Url") as? String
//        {
//            self.localUrl = offlineUrl
//        }
//        else
//        {
//            self.localUrl = ""
//        }
        
        var assetId = DBHelper.sharedInstance.getMaxAssetId() ?? 0
        assetId += 1
        
        self.Asset_Id = assetId
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ASSET_HEADER
    }
    
    required init(row: Row)
    {
        daCode = row["DA_Code"]
        daName = row["DA_Name"]
        docType = row["Doc_Type"]
        isDownloadable = row["Is_Downloadable"]
        isViewable = row["Is_Viewable"]
        isShareable = row["Is_Shareable"]
        thumbnailUrl = row["Thumbnail_Url"]
        daSize = row["DA_Size_In_MB"]
        isDownloaded = row["Is_Downloaded"]
        daFileName = row["DA_FileName"]
        startDate = row["Effective_From"]
        endDate = row["Effective_To"]
        daDesc = row["DA_Description"]
        noOfParts = row["Number_Of_Parts"]
        duration = row["Total_Duration_In_Seconds"]
        onlineUrl = row["DA_Online_Url"]
        localUrl = row["DA_Offline_Url"]
        tagValue = row["Tag_Value"]
        Html_Start_Page = row["Html_Start_Page"]
        Asset_Id = row["Asset_Id"]
      Total_Measure = row["Total_Measure"]
        Measured_Unit = row["Measured_Unit"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DA_Code"] = daCode
        container["DA_Name"] = daName
        container["Doc_Type"] = docType
        container["Is_Downloadable"] = isDownloadable
        container["Is_Viewable"] = isViewable
        container["Is_Shareable"] = isShareable
        container["Thumbnail_Url"] = thumbnailUrl
        container["DA_Online_Url"] = onlineUrl
        container["Html_Start_Page"] = Html_Start_Page
        container["DA_Size_In_MB"] = daSize
        container["Is_Downloaded"] = isDownloaded
        container["DA_FileName"] = daFileName
        container["Effective_From"] = startDate
        container["Effective_To"] = endDate
        container["DA_Description"] = daDesc
        container["Number_Of_Parts"] = noOfParts
        container["Total_Duration_In_Seconds"] = duration
        container["Asset_Id"] = Asset_Id
        container["Total_Measure"] = Total_Measure
        container["Measured_Unit"] = Measured_Unit
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//
//
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DA_Code": daCode,
//            "DA_Name": daName,
//            "Doc_Type": docType,
//            "Is_Downloadable": isDownloadable,
//            "Is_Viewable": isViewable,
//            "Is_Shareable": isShareable,
//            "Thumbnail_Url": thumbnailUrl,
//            "DA_Online_Url": onlineUrl,
//            "Html_Start_Page": Html_Start_Page
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "DA_Size_In_MB": daSize,
//            "Is_Downloaded": isDownloaded,
//            "DA_FileName": daFileName,
//            "Effective_From": startDate,
//            "Effective_To": endDate,
//            "DA_Description": daDesc,
//            "Number_Of_Parts": noOfParts,
//            "Total_Duration_In_Seconds": duration
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
    
       
}

class AssetDownload: Record
{
    var localUrl : String!
    var daCode: Int!
    var daType: Int!
    var isDownloaded: Int!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        self.localUrl = checkNullAndNilValueForString(stringData: dict.value(forKey: "DA_Offline_Url") as? String)
        self.daType = dict.value(forKey: "DA_Type") as! Int
        self.isDownloaded = dict.value(forKey: "Is_Downloaded") as! Int
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DOWNLOADED_ASSET
    }
    
    required init(row: Row)
    {
        daCode = row["DA_Code"]
        localUrl = row["DA_Offline_Url"]
        daType = row["DA_Type"]
        isDownloaded = row["Is_Downloaded"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DA_Code"] = daCode
        container["DA_Offline_Url" ] = localUrl
        container["DA_Type"] = daType
        container["Is_Downloaded"] = isDownloaded
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DA_Code": daCode,
//            "DA_Offline_Url" : localUrl,
//            "DA_Type": daType,
//            "Is_Downloaded": isDownloaded
//        ]
//        return dict1
//    }
}

class AssetShowListModel : Record{
    
    var daCode: Int!
    var daName: String!
    var docType: Int!
    var isDownloadable: Int!
    var isViewable: Int = 0
    var isShareable: Int = 0
    var thumbnailUrl: String!
    var daSize: Float!
    var isDownloaded: Int!
    var daFileName: String!
    var startDate: Date!
    var endDate: Date!
    var daDesc: String!
    var noOfParts: Int!
    var duration: Int!
    var tagValue : String!
    var onlineUrl : String!
    var localUrl : String!
    var Html_Start_Page : String!
    var storyId: NSNumber!
    var displayOrder: Int!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        
        if let name = dict.value(forKey: "DA_Name") as? String
        {
            self.daName = name
        }
        else
        {
            self.daName = ""
        }
        
        self.docType = dict.value(forKey: "DA_Type") as! Int
        self.isDownloadable = dict.value(forKey: "Is_Downloadable") as! Int
        
        if let thumbUrl = dict.value(forKey: "DA_Thumbnail_URL") as? String
        {
            self.thumbnailUrl = thumbUrl
        }
        else
        {
            self.thumbnailUrl = ""
        }
        
        if let size = dict.value(forKey: "DA_Size_In_MB") as? Float
        {
            self.daSize = size
        }
        else
        {
            self.daSize = 0.0
        }
        
        if let downloadStatus = dict.value(forKey: "Is_Downloaded")
        {
            self.isDownloaded = downloadStatus as! Int
        }
        else
        {
            self.isDownloaded = 0
        }
        
        if let fileName = dict.value(forKey: "DA_FileName") as? String
        {
            self.daFileName = fileName
        }
        else
        {
            self.daFileName = ""
        }
        
        if let fromDate = dict.value(forKey: "FromDate") as? Date
        {
            self.startDate = fromDate
            
        }
        
        if let toDate = dict.value(forKey: "ToDate") as? Date
        {
            self.endDate = toDate
        }
        
        self.Html_Start_Page = checkNullAndNilValueForString(stringData: dict.value(forKey: "Html_Start_Page") as? String)
        
        if let desc = dict.value(forKey: "DA_Description") as? String
        {
            self.daDesc = desc
        }
        else
        {
            self.daDesc = ""
        }
        
        if let numberOfParts = dict.value(forKey: "Number_Of_Parts") as? Int
        {
            self.noOfParts = numberOfParts
        }
        else
        {
            self.noOfParts = 0
        }
        
        if let durationInSeconds = dict.value(forKey: "Total_Duration_in_Seconds") as? Int
        {
            self.duration = durationInSeconds
        }
        else
        {
            self.duration = 0
        }
        
        //        self.onlineUrl = checkNullAndNilValueForString(stringData: dict.value(forKey: "onlineUrl") as? String)
        
        if let onlineUrl = dict.value(forKey: "DA_Online_URL") as? String
        {
            self.onlineUrl = onlineUrl
        }
        else
        {
            self.onlineUrl = ""
        }
        
        //        if let offlineUrl = dict.value(forKey: "DA_Offline_Url") as? String
        //        {
        //            self.localUrl = offlineUrl
        //        }
        //        else
        //        {
        //            self.localUrl = ""
        //        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TBL_CUSTOMER_TEMP_SHOWLIST
    }
    
    required init(row: Row)
    {
        daCode = row["DA_Code"]
        daName = row["DA_Name"]
        docType = row["Doc_Type"]
        isDownloadable = row["Is_Downloadable"]
        isViewable = row["Is_Viewable"]
        isShareable = row["Is_Shareable"]
        thumbnailUrl = row["Thumbnail_Url"]
        daSize = row["DA_Size_In_MB"]
        isDownloaded = row["Is_Downloaded"]
        daFileName = row["DA_FileName"]
        startDate = row["Effective_From"]
        endDate = row["Effective_To"]
        daDesc = row["DA_Description"]
        noOfParts = row["Number_Of_Parts"]
        duration = row["Total_Duration_In_Seconds"]
        onlineUrl = row["DA_Online_Url"]
        localUrl = row["DA_Offline_Url"]
        tagValue = row["Tag_Value"]
        Html_Start_Page = row["Html_Start_Page"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DA_Code"] = daCode
        container["DA_Name"] = daName
        container["Doc_Type"] = docType
        container["Is_Downloadable"] = isDownloadable
        container["Is_Viewable"] = isViewable
        container["Is_Shareable"] = isShareable
        container["Thumbnail_Url"] = thumbnailUrl
        container["DA_Online_Url"] = onlineUrl
        container["Html_Start_Page"] = Html_Start_Page
        container["DA_Size_In_MB"] = daSize
        container["Is_Downloaded"] = isDownloaded
        container["DA_FileName"] = daFileName
        container["Effective_From"] = startDate
        container["Effective_To"] = endDate
        container["DA_Description"] = daDesc
        container["Number_Of_Parts"] = noOfParts
        container["Total_Duration_In_Seconds"] = duration
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "DA_Code": daCode,
//            "DA_Name": daName,
//            "Doc_Type": docType,
//            "Is_Downloadable": isDownloadable,
//            "Is_Viewable": isViewable,
//            "Is_Shareable": isShareable,
//            "Thumbnail_Url": thumbnailUrl,
//            "DA_Online_Url": onlineUrl,
//            "Html_Start_Page": Html_Start_Page
//        ]
//        let dict2 : [String : DatabaseValueConvertible?] = [
//            "DA_Size_In_MB": daSize,
//            "Is_Downloaded": isDownloaded,
//            "DA_FileName": daFileName,
//            "Effective_From": startDate,
//            "Effective_To": endDate,
//            "DA_Description": daDesc,
//            "Number_Of_Parts": noOfParts,
//            "Total_Duration_In_Seconds": duration
//        ]
//
//        var combinedAttributes : NSMutableDictionary!
//
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//
//        combinedAttributes.addEntries(from: dict2)
//
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
 
    
}

class AssetShowList: Record
{
    var storyId: NSNumber!
    var daCode: Int!
    var displayOrder: Int!
    var id: Int!
    
    init(dict: NSDictionary)
    {
        storyId = dict.value(forKey: "Story_Id") as! NSNumber
        daCode = dict.value(forKey: "DA_Code") as! Int
        displayOrder = dict.value(forKey: "Display_Order") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TBL_CUSTOMER_TEMP_SHOWLIST
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        storyId = row["Story_Id"]
        daCode = row["DA_Code"]
        displayOrder = row["Display_Order"]
        
        super.init(row: row)
    }
    
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["Story_Id"] = storyId
        container["DA_Code"] = daCode
        container["Display_Order"] = displayOrder
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//        {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Id": id,
//            "Story_Id": storyId,
//            "DA_Code": daCode,
//            "Display_Order": displayOrder
//        ]
//        
//        return dict1
//    }
}
