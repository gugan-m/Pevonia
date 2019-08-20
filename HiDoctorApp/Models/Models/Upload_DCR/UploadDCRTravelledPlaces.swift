//
//  UploadDCRTravelledPlaces.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class UploadDCRTravelledPlaces: Record
{
    var DCR_Travel_Id: Int!
    var DCR_Code: String?
    var DCR_Id: Int!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var SFC_Category_Name: String?
    var Distance_Fare_Code: String?
    var SFC_Version: Int?
    var Route_Way: String?
    var SFC_Region_Code: String?
    var Flag: Int!
    var ifCircularRouteApplied: Int?
    var SFC_Category_Code: String?
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_TRAVELLED_PLACES //448960
    }
    
    required init(row: Row)
    {
        DCR_Travel_Id = row["DCR_Travel_Id"]
        DCR_Id = row["DCR_Id"]
        From_Place = row["From_Place"]
        To_Place = row["To_Place"]
        Travel_Mode = row["Travel_Mode"]
        Distance = row["Distance"]
        SFC_Category_Name = row["SFC_Category_Name"]
        Distance_Fare_Code = row["Distance_Fare_Code"]
        SFC_Version = row["SFC_Version"]
        Route_Way = row["Route_Way"]
        Flag = row["Flag"]
        DCR_Code = row["DCR_Code"]
        ifCircularRouteApplied = row["Is_Circular_Route_Complete"]
        SFC_Region_Code = row["Region_Code"]
        
        super.init(row: row)
    }
}
