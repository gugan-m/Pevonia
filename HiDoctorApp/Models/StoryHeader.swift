//
//  StoryHeader.swift
//  HiDoctorApp
//
//  Created by Vijay on 31/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class StoryHeader: Record
{
    var Story_Id: NSNumber!
    var Story_Name: String!
    var Effective_From: Date!
    var Effective_To: Date!
    var No_Of_Assets: Int!
    var Is_Mandatory: Int!
    var Last_Updated_Time: Date?
    var Local_Story_Id: Int!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.Story_Name = dict.value(forKey: "Story_Name") as! String
        
        if let effectiveFrom = dict.value(forKey: "Valid_From") as? String
        {
            self.Effective_From = getStringInFormatDate(dateString: effectiveFrom )
        }
        
        if let Effective_To = dict.value(forKey: "Valid_To") as? String
        {
            self.Effective_To = getStringInFormatDate(dateString:  Effective_To)
        }
        
        if let assetList = dict.object(forKey: "lstStoryAssetDetails") as? NSArray
        {
            self.No_Of_Assets = assetList.count
        }
        else
        {
            self.No_Of_Assets = 0
        }
        
        if let isMandatory = dict.value(forKey: "IsMandatory") as? Int
        {
            self.Is_Mandatory = isMandatory
        }
        else
        {
           self.Is_Mandatory = 0
        }
        
        if let lastUpdatedTime = dict.value(forKey: "Last_Updated_Time") as? String
        {
            self.Last_Updated_Time = getStringInFormatDate(dateString: lastUpdatedTime)
        }
        
        var localStoryId = DBHelper.sharedInstance.getMaxLocalStoryId() ?? 0
        localStoryId += 1
        
        self.Local_Story_Id = localStoryId
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_STORY_HEADER
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        Story_Name = row["Story_Name"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        No_Of_Assets = row["No_Of_Assets"]
        Is_Mandatory = row["Is_Mandatory"]
        Last_Updated_Time = row["Last_Updated_Time"]
        Local_Story_Id = row["Local_Story_Id"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Story_Id"] = Story_Id
        container["Story_Name"] = Story_Name
        container["Effective_From"] = Effective_From
        container["Effective_To"] = Effective_To
        container["No_Of_Assets"] = No_Of_Assets
        container["Is_Mandatory"] = Is_Mandatory
        container["Last_Updated_Time"] = Last_Updated_Time
        container["Local_Story_Id"] = Local_Story_Id
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "Story_Name": Story_Name,
//            "Effective_From": Effective_From,
//            "Effective_To": Effective_To,
//            "No_Of_Assets": No_Of_Assets,
//            "Is_Mandatory": Is_Mandatory,
//            "Last_Updated_Time": Last_Updated_Time
//        ]
//
//        return dict
//    }
}

class StoryLocalHeader: Record
{
    var Story_Id: NSNumber!
    var Story_Name: String!
    var No_Of_Assets: Int!
    var Is_Synched: Int!
    var Active_Status: Int!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.Story_Name = dict.value(forKey: "Story_Name") as! String
        if let noOfAssets = dict.value(forKey: "No_Of_Assets") as? Int
        {
            self.No_Of_Assets = noOfAssets
        }
        else
        {
            self.No_Of_Assets = 0
        }
        self.Is_Synched = dict.value(forKey: "Is_Synched") as! Int
        self.Active_Status = dict.value(forKey: "Active_Status") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_LOCAL_STORY_HEADER
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        Story_Name = row["Story_Name"]
        No_Of_Assets = row["No_Of_Assets"]
        Is_Synched = row["Is_Synched"]
        Active_Status = row["Active_Status"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["Story_Name"] = Story_Name
        container["No_Of_Assets"] = No_Of_Assets
        container["Is_Synched"] = Is_Synched
        container["Active_Status"] = Active_Status
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "Story_Name": Story_Name,
//            "No_Of_Assets": No_Of_Assets,
//            "Is_Synched": Is_Synched,
//            "Active_Status": Active_Status
//        ]
//        
//        return dict
//    }
}
