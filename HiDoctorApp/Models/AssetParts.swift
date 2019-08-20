//
//  AssetParts.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class AssetParts: Record
{
    var id: Int!
    var daCode: Int!
    var partId: Int!
    var partName: String!
    var startTime: Int!
    var endTime: Int!
    var duration: Int!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        self.partId = dict.value(forKey: "Image_Id") as! Int
        
        if let name = dict.value(forKey: "Image_Name") as? String
        {
            self.partName = name
        }
        else
        {
            self.partName = ""
        }
        
        self.startTime = dict.value(forKey: "Start_Time") as! Int
        self.endTime = dict.value(forKey: "End_Time") as! Int
        self.duration = dict.value(forKey: "Total_Duration_in_Seconds") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ASSET_PARTS
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        daCode = row["DA_Code"]
        partId = row["Part_Id"]
        partName = row["Part_Name"]
        startTime = row["Start_Time"]
        endTime = row["End_Time"]
        duration = row["Total_Duration_In_Seconds"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["DA_Code"] = daCode
        container["Part_Id"] = partId
        container["Part_Name"] = partName
        container["Start_Time"] = startTime
        container["End_Time"] = endTime
        container["Total_Duration_In_Seconds"] = duration
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "DA_Code": daCode,
//            "Part_Id": partId,
//            "Part_Name": partName,
//            "Start_Time": startTime,
//            "End_Time": endTime,
//            "Total_Duration_In_Seconds": duration
//        ]
//    }
}

class AssetTag: Record
{
    var id: Int!
    var daCode: Int!
    var tagType: Int!
    var tagValue: String!
    var tagCode: String!
    
    init(dict: NSDictionary)
    {
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        self.tagType = dict.value(forKey: "DA_Detail_Code") as! Int
        
        if let name = dict.value(forKey: "DA_Tag_Value") as? String
        {
            self.tagValue = name
        }
        else
        {
            self.tagValue = ""
        }
        
        self.tagCode = dict.value(forKey: "DA_Tag_Code") as! String
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ASSET_TAG_DETAILS
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        daCode = row["DA_Code"]
        tagType = row["Tag_Type"]
        tagValue = row["Tag_Value"]
        tagCode = row["Tag_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Id"] = id
        container["DA_Code"] = daCode
        container["Tag_Type"] = tagType
        container["Tag_Value"] = tagValue
        container["Tag_Code"] = tagCode
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "DA_Code": daCode,
//            "Tag_Type": tagType,
//            "Tag_Value": tagValue,
//            "Tag_Code": tagCode
//        ]
//    }
}
