//
//  AccompanistDataDownloadModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class AccompanistDataDownloadModel: Record
{
    var Request_Id: Int!
    var User_Code: String!
    var Region_Code: String!
    var Is_Doctor_Data_Downloaded: Int!
    var Is_Chemist_Data_Downloaded: Int!
    var Is_SFC_Data_Downloaded: Int!
    var Is_CP_Data_Downloaded: Int!
    var Is_All_Data_Downloaded: Int!
    var Download_DateTime: Date!
    
    override init()
    {
        super.init()
    }
    
    init(dict: NSDictionary)
    {
        self.Request_Id = dict.value(forKey: "Request_Id") as! Int
        self.User_Code = dict.value(forKey: "User_Code") as! String
        self.Region_Code = dict.value(forKey: "Region_Code") as! String
        self.Is_Doctor_Data_Downloaded = dict.value(forKey: "Is_Doctor_Data_Downloaded") as! Int
        self.Is_Chemist_Data_Downloaded = dict.value(forKey: "Is_Chemist_Data_Downloaded") as! Int
        self.Is_SFC_Data_Downloaded = dict.value(forKey: "Is_SFC_Data_Downloaded") as! Int
        self.Is_CP_Data_Downloaded = dict.value(forKey: "Is_CP_Data_Downloaded") as! Int
        self.Is_All_Data_Downloaded = dict.value(forKey: "Is_All_Data_Downloaded") as! Int
        self.Download_DateTime = dict.value(forKey: "Download_DateTime") as! Date
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS
    }
    
    required init(row: Row)
    {
        Request_Id = row["Request_Id"]
        User_Code = row["User_Code"]
        Region_Code = row["Region_Code"]
        Is_Doctor_Data_Downloaded = row["Is_Doctor_Data_Downloaded"]
        Is_Chemist_Data_Downloaded = row["Is_Chemist_Data_Downloaded"]
        Is_SFC_Data_Downloaded = row["Is_SFC_Data_Downloaded"]
        Is_CP_Data_Downloaded = row["Is_CP_Data_Downloaded"]
        Is_All_Data_Downloaded = row["Is_All_Data_Downloaded"]
        Download_DateTime = row["Download_DateTime"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["Request_Id"] =  Request_Id
        container["User_Code"] =  User_Code
        container["Region_Code"] =  Region_Code
        container["Is_Doctor_Data_Downloaded"] =  Is_Doctor_Data_Downloaded
        container["Is_Chemist_Data_Downloaded"] =  Is_Chemist_Data_Downloaded
        container["Is_SFC_Data_Downloaded"] =  Is_SFC_Data_Downloaded
        container["Is_CP_Data_Downloaded"] =  Is_CP_Data_Downloaded
        container["Is_All_Data_Downloaded"] =  Is_All_Data_Downloaded
        container["Download_DateTime"] =  Download_DateTime
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        return [
//            "Request_Id": Request_Id,
//            "User_Code": User_Code,
//            "Region_Code": Region_Code,
//            "Is_Doctor_Data_Downloaded": Is_Doctor_Data_Downloaded,
//            "Is_Chemist_Data_Downloaded": Is_Chemist_Data_Downloaded,
//            "Is_SFC_Data_Downloaded": Is_SFC_Data_Downloaded,
//            "Is_CP_Data_Downloaded": Is_CP_Data_Downloaded,
//            "Is_All_Data_Downloaded": Is_All_Data_Downloaded,
//            "Download_DateTime": Download_DateTime
//        ]
//    }
}
