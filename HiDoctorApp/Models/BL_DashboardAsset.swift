//
//  BL_DashboardAsset.swift
//  HiDoctorApp
//
//  Created by Vijay on 12/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_DashboardAsset: NSObject
{
    static let sharedInstance = BL_DashboardAsset()
    var dashboardTop10DoctorsList : NSArray = []
    var dashboardTop10AssetsList : NSArray = []
    
    func getAssetData(entityType: Int, userCode: String, completion: @escaping (_ assetModel: [DashboardAssetModel], _ errorMsg: String) -> ())
    {
        let postData: [String : Any] = ["CompanyCode": getCompanyCode(), "UserCode": userCode, "SelforTeam": 0, "IsSummary": 0, "EntityType": entityType]
        WebServiceHelper.sharedInstance.getDashboardAssetListForSelf(postData: postData) {(apiResponseObj) in
            
            if apiResponseObj.Status == SERVER_SUCCESS_CODE
            {
                var modelList : [DashboardAssetModel] = []
                if apiResponseObj.list.count > 0
                {
                    for dict in apiResponseObj.list
                    {
                        if let dictionary = dict as? NSDictionary
                        {
                            let model = DashboardAssetModel()
                            model.DA_Code = dictionary.value(forKey: "DA_Code") as! Int
                            model.DA_Name = dictionary.value(forKey: "DA_Name") as! String
                            //model.Is_Downloadable = dictionary.value(forKey: "Is_Downloadable") as! Int
                            model.DA_Type = dictionary.value(forKey: "DA_Type") as! Int
                         
                                model.DA_Size = dictionary["DA_Size_In_MB"] as? Float ?? 0.0
                            
                            
                            model.DA_Thumbnail_Url = checkNullAndNilValueForString(stringData: dictionary["DA_Thumbnail_URL"] as? String)
                            
                            if let getUploadedDate = dictionary.value(forKey: "Uploaded_Date") as? String
                            {
                                model.Uploaded_Date = getUploadedDate
                            }
                            else
                            {
                                model.Uploaded_Date = ""
                            }
                            
//                            if let getUploadedby = dictionary.value(forKey: "Uploaded_By") as? String
//                            {
//                                model.Uploaded_By = getUploadedby
//                            }
//                            else
//                            {
//                                model.Uploaded_By = ""
//                            }
//                            
//                            if let getOnlineUrl = dictionary.value(forKey: "DA_Online_URL") as? String
//                            {
//                                model.DA_Online_Url = getOnlineUrl
//                            }
//                            else
//                            {
//                                model.DA_Online_Url = ""
//                            }
//                            
//                            if let getStatus = dictionary.value(forKey: "Status_Action") as? String
//                            {
//                                model.Status_Action = getStatus
//                            }
//                            else
//                            {
//                                model.Status_Action = ""
//                            }
//                            
//                            if let getThumbnail = dictionary.value(forKey: "DA_Thumbnail_URL") as? String
//                            {
//                                model.DA_Thumbnail_Url = getThumbnail
//                            }
//                            else
//                            {
//                                model.DA_Thumbnail_Url = ""
//                            }
//                            
//                            if let getDaFile = dictionary.value(forKey: "DA_File_Name") as? String
//                            {
//                                model.DA_File_Name = getDaFile
//                            }
//                            else
//                            {
//                                model.DA_File_Name = ""
//                            }
//                            
//                            if let getDadesc = dictionary.value(forKey: "DA_Description") as? String
//                            {
//                                model.DA_Description = getDadesc
//                            }
//                            else
//                            {
//                                model.DA_Description = ""
//                            }
//                            
//                            if let defaultThumb = dictionary.value(forKey: "Is_Default_Thumbnail") as? Int
//                            {
//                                model.Is_Default_Thumbnail = defaultThumb
//                            }
//                            else
//                            {
//                                model.Is_Default_Thumbnail = 0
//                            }
//                            
//                            model.No_Of_Parts = dictionary.value(forKey: "Number_Of_Parts") as! Int
//                            
//                            if let startDate = dictionary.value(forKey: "FromDate") as? String
//                            {
//                                model.FromDate = startDate
//                            }
//                            else
//                            {
//                                model.FromDate = ""
//                            }
//                            
//                            if let endDate = dictionary.value(forKey: "ToDate") as? String
//                            {
//                                model.ToDate = endDate
//                            }
//                            else
//                            {
//                                model.ToDate = ""
//                            }
                            
                            modelList.append(model)
                        }
                    }
                    
                    completion(modelList, "")
                }
                else
                {
                    completion([], "")
                }
            }
            else if apiResponseObj.Status == SERVER_ERROR_CODE || apiResponseObj.Status == NO_INTERNET_ERROR_CODE
            {
                completion([], apiResponseObj.Message)
            }
            else
            {
                completion([], serverSideError)
            }
        }
    }
    
    
    func getTopDoctorData( completion: @escaping (_ doctorModel: [DashboardTopDoctor], _ errorMsg: String) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardTopTenDoctors(regionCode: "", completion: { (apiResponseObj) in
                            
        if apiResponseObj.Status == SERVER_SUCCESS_CODE{
        self.dashboardTop10DoctorsList = apiResponseObj.list
            
            var modelList : [DashboardTopDoctor] = []
            if apiResponseObj.list.count > 0
            {
                for dict in apiResponseObj.list
                {
                    if let dictionary = dict as? NSDictionary
                    {
                        let model = DashboardTopDoctor()
                        model.Category_Name = checkNullAndNilValueForString(stringData: dictionary["Category_Name"] as? String)
                        model.Doctor_Code =  checkNullAndNilValueForString(stringData: dictionary["Customer_Code"] as? String)
                        model.Doctor_Name =  checkNullAndNilValueForString(stringData: dictionary["Customer_Name"]as? String)
                        model.Doctor_Speciality =  checkNullAndNilValueForString(stringData: dictionary["Speciality_Name"] as? String)
                        model.MDL_No =  checkNullAndNilValueForString(stringData: dictionary["MDL_Number"] as? String)
                        if dictionary["Total_Views"] != nil{
                        model.No_Of_Views =  dictionary["Total_Views"] as! Int
                        }else{
                            model.No_Of_Views = 0
                        }
                    
                        model.Profile_Img =  checkNullAndNilValueForString(stringData: dictionary["CustomerImage_URL"] as? String)
                        
                        if dictionary["Total_Detail_time_duration"] != nil{
                        model.Duration =  dictionary["Total_Detail_time_duration"] as! Int
                        }else{
                            model.Duration = 0
                        }
                        
                        if dictionary["lstCustomerAsset_Details"] != nil{
                        let asset_List =  dictionary["lstCustomerAsset_Details"] as! [NSDictionary]
                        for asset in asset_List {
                            
                            let assetModel = DashboardTopAssets()
                            
                            if asset["Asset_Id"] != nil{
                            assetModel.Asset_Id = asset["Asset_Id"] as! Int
                            }else{
                            assetModel.Asset_Id = 0
                            }
                            assetModel.Asset_Name = checkNullAndNilValueForString(stringData: asset["Asset_Name"]  as? String)
                            assetModel.Asset_Thumbnail = checkNullAndNilValueForString(stringData: asset["DA_Thumbnail_URL"]  as? String)
                            if asset["Total_Count"]  != nil{
                            assetModel.No_Of_Views = asset["Total_Count"] as! Int
                            }else{
                                assetModel.No_Of_Views = 0
                            }
                            if asset["Total_Detail_time_duration"] != nil{
                            assetModel.Duration = asset["Total_Detail_time_duration"] as! Int
                            }else{
                                assetModel.Duration = 0
                            }
                            
                            assetModel.Asset_Type = asset["Asset_Type"] as? Int ?? 0
                            
                            assetModel.Asset_Downloadable =
                                checkNullAndNilValueForString(stringData:  asset["Asset_Downloadable"] as? String)
                            assetModel.Asset_Size = asset["Asset_Size"] as? Float ?? 0.0
                            model.Asset_List.append(assetModel)
                        }
                        modelList.append(model)
                        }
                    }}
                completion(modelList , "")
        }else{
            completion([], "")
            }
            
        }else{
            completion([], serverSideError)

            }
        })

    }
    
    func getTopAssetData( completion: @escaping (_ assetModel: [DashboardTopAssets], _ errorMsg: String) -> ())
    {
        WebServiceHelper.sharedInstance.getDashboardTopTenAssets(regionCode: "", completion: { (apiResponseObj) in
            
            if apiResponseObj.Status == SERVER_SUCCESS_CODE{
                self.dashboardTop10AssetsList = apiResponseObj.list
                
                var modelList : [DashboardTopAssets] = []
                if apiResponseObj.list.count > 0
                {
                    for dict in apiResponseObj.list
                    {
                        if let dictionary = dict as? NSDictionary
                        {
                            let assetModel = DashboardTopAssets()
                            if dictionary["Asset_Id"]  != nil{
                            assetModel.Asset_Id = dictionary["Asset_Id"] as! Int
                            }else{
                                assetModel.Asset_Id = 0
                            }
                            assetModel.Asset_Name = checkNullAndNilValueForString(stringData: dictionary["Asset_Name"]  as? String)
                            assetModel.Asset_Thumbnail = checkNullAndNilValueForString(stringData: dictionary["DA_Thumbnail_URL"] as? String)
                            
                            if dictionary["Total_Detail_time_duration"]  != nil{
                            assetModel.Duration = dictionary["Total_Detail_time_duration"] as! Int
                            }else{
                               assetModel.Duration = 0
                            }
                            if dictionary["Total_Views"] != nil{
                            assetModel.No_Of_Views =  dictionary["Total_Views"] as! Int
                            }else{
                                assetModel.No_Of_Views = 0
                            }
                            
                            assetModel.Asset_Type = dictionary[	"Asset_Type"] as? Int ?? 0
                            
                            assetModel.Asset_Downloadable =
                               checkNullAndNilValueForString(stringData:  dictionary["Asset_Downloadable"] as? String)
                            assetModel.Asset_Size = dictionary["Asset_Size"] as? Float ?? 0.0
                            
                            if dictionary["lstAssetDoctor_Details"] != nil{
                            let doctorList =  dictionary["lstAssetDoctor_Details"] as! [NSDictionary]
                            for doctor in doctorList {
                                
                                let model = DashboardTopDoctor()
                                model.Category_Name = checkNullAndNilValueForString(stringData: doctor["Category_Name"] as? String)
                                model.Doctor_Code =  checkNullAndNilValueForString(stringData: doctor["Customer_Code"] as? String)
                                model.Doctor_Name =  checkNullAndNilValueForString(stringData: doctor["Customer_Name"] as? String)
                                model.Doctor_Speciality = checkNullAndNilValueForString(stringData: doctor["Speciality_Name"] as? String)
                                model.MDL_No =  checkNullAndNilValueForString(stringData: doctor["MDL_Number"] as? String)
                                model.Profile_Img = checkNullAndNilValueForString(stringData: doctor["CustomerImage_URL"] as? String)
                                if  doctor["Total_Detail_time_duration"]  != nil{
                                model.Duration =  doctor["Total_Detail_time_duration"] as! Int
                                }else{
                                    model.Duration = 0
                                }
                                
                                assetModel.Doctor_List.append(model)
                            }
                            modelList.append(assetModel)
                            }
                        }}
                    completion(modelList , "")
                
            }else{
                completion([], "")
            }
            }else{
                completion([], serverSideError)
            }
        })
    }
}
