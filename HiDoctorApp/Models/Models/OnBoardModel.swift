//
//  OnBoardModel.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class OnBoardModel: Record
{
    var versionName: String!
    var shownType: Int!
    var moduleName : String!
    
    init(versionName : String , shownType : Int , moduleName : String)
    {
        self.versionName = versionName
        self.shownType = shownType
        self.moduleName = moduleName
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return ONBOARDSHOWN
    }
    
    required init(row: Row)
    {
        versionName = row["Version_Name"]
        shownType = row["Shown_Type"]
        moduleName = row["Screen_Name"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Version_Name"] =  versionName
        container["Shown_Type"] =  shownType
        container["Screen_Name"] =  moduleName
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Version_Name": versionName,
//            "Shown_Type": shownType,
//            "Screen_Name": moduleName
//        ]
//    }
}
