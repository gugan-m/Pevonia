//
//  StoryAssets.swift
//  HiDoctorApp
//
//  Created by Vijay on 31/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class StoryAssets: Record
{
    var Story_Id: NSNumber!
    var DA_Code: Int!
    var Display_Order: Int!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        if let daCode =  dict.value(forKey: "DA_Code") as? Int
        {
            self.DA_Code = daCode
        }
        self.Display_Order = dict.value(forKey: "Display_Order") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_STORY_ASSETS
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        DA_Code = row["DA_Code"]
        Display_Order = row["Display_Order"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["DA_Code"] = DA_Code
        container["Display_Order"] = Display_Order
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "DA_Code": DA_Code,
//            "Display_Order": Display_Order
//        ]
//
//        return dict
//    }
}

class StoryLocalAssets: Record
{
    var Story_Id: NSNumber!
    var DA_Code: Int!
    var Display_Order: Int!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.DA_Code = dict.value(forKey: "DA_Code") as! Int
        self.Display_Order = dict.value(forKey: "Display_Order") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_LOCAL_STORY_ASSETS
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        DA_Code = row["DA_Code"]
        Display_Order = row["Display_Order"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["DA_Code"] = DA_Code
        container["Display_Order"] = Display_Order
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "DA_Code": DA_Code,
//            "Display_Order": Display_Order
//        ]
//
//        return dict
//    }
}

class StoryCategories: Record
{
    var Story_Id: NSNumber!
    var Category_Code: String!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_STORY_CATEGORIES
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        Category_Code = row["Category_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["Category_Code"] = Category_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "Category_Code": Category_Code
//        ]
//
//        return dict
//    }
}

class StorySpecialities: Record
{
    var Story_Id: NSNumber!
    var Speciality_Code: String!
    
    init(dict: NSDictionary)
    {
        self.Story_Id = dict.value(forKey: "Story_Id") as! NSNumber
        self.Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_STORY_SPECIALITIES
    }
    
    required init(row: Row)
    {
        Story_Id = row["Story_Id"]
        Speciality_Code = row["Speciality_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Story_Id"] = Story_Id
        container["Speciality_Code"] = Speciality_Code
    }
    
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict: [String : DatabaseValueConvertible?] = [
//            "Story_Id": Story_Id,
//            "Speciality_Code": Speciality_Code
//        ]
//        
//        return dict
//    }
}
