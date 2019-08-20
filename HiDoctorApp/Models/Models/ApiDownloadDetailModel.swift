//
//  ApiDownloadDetailModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 06/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class ApiDownloadDetailModel: Record
{
    var Api_Name: String!
    var Master_Data_Group_Name: String!
    var Download_Date: Date!
    var Download_Status: Int!
    
    init(dict: NSDictionary)
    {
        self.Api_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Api_Name") as? String)
        self.Master_Data_Group_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Master_Data_Group_Name") as? String)
        self.Download_Date = dict.value(forKey: "Download_Date") as! Date
        self.Download_Status = dict.value(forKey: "Download_Status") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_API_DOWNLOAD_DETAILS
    }
    
    required init(row: Row)
    {
        Api_Name = row["Api_Name"]
        Master_Data_Group_Name = row["Master_Data_Group_Name"]
        Download_Date = row["Download_Date"]
        Download_Status = row["Download_Status"]
        
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["Api_Name"] =  Api_Name
        container["Master_Data_Group_Name"] =  Master_Data_Group_Name
        container["Download_Date"] =  Download_Date
        container["Download_Status"] =  Download_Status
    }
//     var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Api_Name": Api_Name,
//            "Master_Data_Group_Name": Master_Data_Group_Name,
//            "Download_Date": Download_Date,
//            "Download_Status": Download_Status
//        ]
//    }
}
