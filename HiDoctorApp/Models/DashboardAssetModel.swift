//
//  DashboardAssetModel.swift
//  HiDoctorApp
//
//  Created by Vijay on 12/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardAssetModel: NSObject
{
    var DA_Code: Int!
    var DA_Name: String!
    var Is_Downloadable: Int!
    var DA_Type: Int!
    var DA_Size: Float!
    var Uploaded_Date: String!
    var Uploaded_By: String!
    var DA_Online_Url: String!
    var Status_Action: String!
    var DA_Thumbnail_Url: String!
    var DA_File_Name: String!
    var DA_Description: String!
    var Is_Default_Thumbnail: Int!
    var No_Of_Parts: Int!
    var FromDate: String!
    var ToDate: String!
}

class DashboardAssetUserModel: NSObject
{
    var userName: String!
    var userCode: String!
    var count: Int!
}

class DashboardTopDoctor: NSObject
{
    var Doctor_Code: String!
    var Doctor_Name: String!
    var Doctor_Speciality: String!
    var MDL_No: String!
    var Category_Name: String!
    var No_Of_Views: Int!
    var Profile_Img: String!
    var Duration: Int!
    var Asset_List = [DashboardTopAssets]()
}

class DashboardTopAssets: NSObject
{
    var Asset_Id: Int!
    var Asset_Name: String!
    var Asset_Downloadable : String!
    var No_Of_Views: Int!
    var Asset_Thumbnail: String!
    var Asset_Type: Int!
    var Asset_Size: Float!
    var Is_Downloadable: Int!
    var Duration: Int!
    var Doctor_List =  [DashboardTopDoctor]()
}
