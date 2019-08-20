//
//  WorkCategories.swift
//  HiDoctorApp
//
//  Created by SwaaS on 01/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class WorkCategories: Record
{
    var Category_Id: Int!
    var Category_Name: String!
    var Category_Code: String!
    
    init(categoryCode: String, categoryName: String)
    {
        self.Category_Code = categoryCode
        self.Category_Name = categoryName
        
        super.init()
    }
    
    init(dict: NSDictionary)
    {
        self.Category_Id = dict.value(forKey: "Category_Id") as! Int
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_WORK_CATEGORY
    }
    
    required init(row: Row)
    {
        Category_Id = row["Category_Id"]
        Category_Name = row["Category_Name"]
        Category_Code = row["Category_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["Category_Id"] =  Category_Id
        container["Category_Name"] =  Category_Name
        container["Category_Code"] =  Category_Code
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Category_Id": Category_Id,
//            "Category_Name": Category_Name,
//            "Category_Code": Category_Code
//        ]
//    }
}

class WorkCategoresObjectModel: NSObject
{
    var Category_Id: Int!
    var Category_Name: String!
    var Category_Code: String!
}
