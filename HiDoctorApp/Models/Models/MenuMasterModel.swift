//
//  MenuMasterModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 22/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class MenuMasterModel: Record
{
    var Menu_Id: Int!
    var Menu_Name: String!
    var Section_Name: String!
    var Count: Int = -1
    var isActivityIndicatorLoading: Bool = false
    
    var MenuType: String!
    var MdmMenuUrl: String!
    var MenuCategory: String!

    
    init(dict: NSDictionary)
    {
        self.Menu_Id = dict.value(forKey: "Menu_Id") as! Int
        self.Menu_Name = dict.value(forKey: "Menu_Name") as! String
        self.MenuType = dict.value(forKey: "Type") as! String
        self.MdmMenuUrl = dict.value(forKey: "MDM_Menu_Url") as! String
        self.MenuCategory = dict.value(forKey: "Category") as! String
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MENU_MASTER
    }
    
    required init(row: Row)
    {
        Menu_Id = row["Menu_Id"]
        Menu_Name = row["Menu_Name"]
        MenuType = row["Type"]
        MdmMenuUrl = row["MDM_Menu_Url"]
        MenuCategory = row["Category"]
        
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Menu_Id"] = Menu_Id
        container["Menu_Name"] = Menu_Name
        container["Type"] = MenuType
        container["MDM_Menu_Url"] = MdmMenuUrl
        container["Category"] = MenuCategory
        
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Menu_Id": Menu_Id,
//            "Menu_Name": Menu_Name
//        ]
//    }
}
