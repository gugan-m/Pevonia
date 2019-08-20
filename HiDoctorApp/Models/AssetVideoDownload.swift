//
//  AssetVideoDownload.swift
//  HiDoctorApp
//
//  Created by Vijay on 23/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class AssetVideoDownload: Record
{
    var id: Int!
    var encodingPreset: Int!
    var daCode: Int!
    var fileSize: Int!
    
    init(dict: NSDictionary)
    {
        if let preset = dict.value(forKey: "Encoding_Preset") as? Int
        {
            self.encodingPreset = preset
        }
        else
        {
            self.encodingPreset = 0
        }
        
        self.daCode = dict.value(forKey: "DA_Code") as! Int
        
        if let size = dict.value(forKey: "File_Size") as? Int
        {
            self.fileSize = size
        }
        else
        {
            self.fileSize = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_VIDEO_FILE_DOWNLOAD_INFO
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        encodingPreset = row["Encoding_Preset"]
        daCode = row["DA_Code"]
        fileSize = row["File_Size"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["Encoding_Preset"] = encodingPreset
        container["DA_Code"] = daCode
        container["File_Size"] = fileSize
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "Encoding_Preset": encodingPreset,
//            "DA_Code": daCode,
//            "File_Size": fileSize
//        ]
//    }
    }

class AssetPreset: Record
{
    var id: Int!
    var encodingPreset: String!
    var docType: Int!
    var sourceType: Int!
    
    init(dict: NSDictionary)
    {
        if let preset = dict.value(forKey: "Encoding_Preset") as? String
        {
            self.encodingPreset = preset
        }
        else
        {
            self.encodingPreset = ""
        }
        
        self.docType = dict.value(forKey: "Doc_Type") as! Int
        
        if let source = dict.value(forKey: "Source_Type") as? Int
        {
            self.sourceType = source
        }
        else
        {
            self.sourceType = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ASSET_PRESET
    }
    
    required init(row: Row)
    {
        id = row["Id"]
        encodingPreset = row["Encoding_Preset"]
        docType = row["Doc_Type"]
        sourceType = row["Source_Type"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Id"] = id
        container["Encoding_Preset"] = encodingPreset
        container["Doc_Type"] = docType
        container["Source_Type"] = sourceType
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Id": id,
//            "Encoding_Preset": encodingPreset,
//            "Doc_Type": docType,
//            "Source_Type": sourceType
//        ]
//    }
}
